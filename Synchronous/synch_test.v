`timescale 1ns/1ns

module tb_fifo_synch;

    parameter FIFO_DEPTH = 8;
    parameter DATA_WIDTH = 32;

    reg clk = 0;
    reg rst_n;
    reg cs;
    reg wr_en;
    reg rd_en;
    reg [DATA_WIDTH-1:0] data_in;

    wire [DATA_WIDTH-1:0] data_out;
    wire empty;
    wire full;

    integer i;

    // DUT
    fifo_synch #(
        .FIFO_DEPTH(FIFO_DEPTH),
        .DATA_WIDTH(DATA_WIDTH)
    ) dut (
        .clk(clk),
        .rst_n(rst_n),
        .cs(cs),
        .wr_en(wr_en),
        .rd_en(rd_en),
        .data_in(data_in),
        .data_out(data_out),
        .empty(empty),
        .full(full)
    );

    // 100 MHz clock
    always #5 clk = ~clk;


    // -------------------------
    // Write task
    // -------------------------
    task write_data(input [DATA_WIDTH-1:0] value);
    begin
        @(posedge clk);
        cs      <= 1;
        wr_en   <= 1;
        data_in <= value;

        $display("%0t WRITE  -> %0d", $time, value);

        @(posedge clk);
        wr_en <= 0;
        cs    <= 0;
    end
    endtask


    // -------------------------
    // Read task
    // -------------------------
    task read_data;
    begin
        @(posedge clk);
        cs    <= 1;
        rd_en <= 1;

        @(posedge clk);
        rd_en <= 0;
        cs    <= 0;

        #1 $display("%0t READ   <- %0d", $time, data_out);
    end
    endtask


    // -------------------------
    // Test sequence
    // -------------------------
    initial begin

        // initial values
        rst_n   = 0;
        cs      = 0;
        wr_en   = 0;
        rd_en   = 0;
        data_in = 0;

        // apply reset
        #12;
        @(posedge clk);
        rst_n = 1;

        // -----------------------------
        $display("\n--- Basic Write / Read ---");
        write_data(1);
        write_data(10);
        write_data(100);

        read_data();
        read_data();
        read_data();

        // -----------------------------
        $display("\n--- write and Read Test ---");
        for (i = 0; i < FIFO_DEPTH; i = i + 1) begin
            write_data(2**i);
            read_data();
        end

        // -----------------------------
        $display("\n--- Fill FIFO ---");
        for (i = 0; i <= FIFO_DEPTH; i = i + 1)
            write_data(i);

        for (i = 0; i < FIFO_DEPTH; i = i + 1)
            read_data();

        // -----------------------------
        $display("\n--- Simultaneous R/W ---");

        write_data(999);
        write_data(888);

        @(posedge clk);
        cs      <= 1;
        wr_en   <= 1;
        rd_en   <= 1;
        data_in <= 777;

        $display("%0t SIMULTANEOUS: write 777 + read", $time);

        @(posedge clk);
        wr_en <= 0;
        rd_en <= 0;
        cs    <= 0;

        #1 $display("%0t SIMULTANEOUS READ <- %0d", $time, data_out);

        // -----------------------------
        $display("\n--- Async Reset in Middle ---");

        write_data(111);
        write_data(222);

        #3 rst_n = 0;
        $display("%0t RESET asserted", $time);

        #10 rst_n = 1;
        $display("%0t After reset, empty = %0b", $time, empty);

        #40 $finish;
    end


    // waveform dump
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_fifo_synch);
    end

endmodule