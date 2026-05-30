# Synchronous & Asynchronous FIFO Design in Verilog

## Overview

This project implements both **Synchronous FIFO** and **Asynchronous FIFO** architectures using **Verilog HDL**. The designs were developed to understand FIFO-based data buffering, memory management, and clock domain crossing (CDC) techniques commonly used in digital and VLSI systems.

The repository includes:
- Verilog source code for Synchronous FIFO
- Verilog source code for Asynchronous FIFO
- Testbenches for functional verification
- Simulation waveforms


---

## Features

### Synchronous FIFO
- Single clock for read and write operations
- Circular buffer implementation
- Full and Empty flag generation
- Parameterized FIFO depth and data width
- Verified through simulation

### Asynchronous FIFO
- Independent read and write clocks
- Clock Domain Crossing (CDC) support
- Gray code pointer implementation
- Two-stage synchronizers for metastability reduction
- Full and Empty flag generation
- Verified through simulation

---

## FIFO Architecture

## Synchronous FIFO 

The synchronous FIFO uses a **single clock** for both read and write operations. Data is stored in a FIFO memory array, while separate read and write pointers manage data access. The design uses an extra pointer bit to distinguish between **full** and **empty** conditions and operates as a **circular buffer**.

### Key Components

* FIFO Memory Array
* Write Pointer
* Read Pointer
* Full Detection Logic
* Empty Detection Logic

### Circular Buffer Operation

The FIFO is implemented as a circular buffer. The read and write pointers continuously increment, while only their lower address bits are used to access memory locations. When the last memory location is reached, the pointers automatically wrap around to the beginning of the FIFO.

### Full Condition

The FIFO is considered **full** when the write pointer catches up to the read pointer after completing one wrap-around cycle. This is detected by comparing the pointers and inverting the most significant bit (MSB) of the read pointer.

```verilog
assign full = (write_pointer ==
              {~read_pointer[FIFO_DEPTH_LOG],
               read_pointer[FIFO_DEPTH_LOG-1:0]});
```

### Empty Condition

The FIFO is considered **empty** when the read and write pointers are equal, indicating that there is no valid data available for reading.

```verilog
assign empty = (read_pointer == write_pointer);
```


## Asynchronous FIFO
### FIFO.v

This module is a FIFO implementation with configurable data and address sizes. It consists of a memory module, read and write pointer handling modules, and read and write pointer synchronization modules. The read and write pointers are synchronized to the respective clock domains, and the read and write pointers are checked for empty and full conditions, respectively. The FIFO memory module stores the data and handles the read and write operations.

### FIFO_memory.v

The module has a memory array (mem) with a depth of 2^ADDR_SIZE. The read and write addresses are used to access the memory array. The write clock enable (wclk_en) and write full (wfull) signals are used to control the writing process. The write data is stored in the memory array on the rising edge of the write clock (wclk)

### two_ff_sync.v
The module has two flip-flops, q1 and q2, which store the input data (din) of size SIZE. On each clock cycle, the data is shifted from q1 to q2, and new data is loaded into q1. The reset signal (rst_n) is active low, meaning the FIFO is reset when rst_n is low

### rptr_empty.v

The module implements a read pointer for a FIFO with an empty flag. The read pointer is implemented in grey code to avoid glitches when transitioning clock domains. The read pointer is incremented based on the read increment signal and the empty flag. The empty flag is set when the read pointer is equal to the write pointer, indicating that the FIFO is empty. The read pointer and empty flag are updated on each clock cycle, and the read address is calculated from the read pointer.

### wptr_full.v
The module implements a write pointer for a FIFO with a full flag. The write pointer is implemented in gray code to avoid glitches when transitioning between clock domains. The write pointer is incremented based on the write increment signal and the full flag. The full flag is set when the write pointer is equal to the read pointer, indicating that the FIFO is full. The write pointer and full flag are updated on each clock cycle, and the write address is calculated from the write pointer.

---

## Project Structure

```text
├── Synchronous_FIFO/
│   ├── fifo.v
│   ├── fifo_tb.v
│   └── Waveforms/
│
├── Asynchronous_FIFO/
│   ├── fifo_mem.v
│   ├── sync_r2w.v
│   ├── sync_w2r.v
│   ├── rptr_empty.v
│   ├── wptr_full.v
│   ├── fifo_tb.v
│   └── Waveforms/
│
└── README.md
