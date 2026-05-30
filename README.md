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


### Asynchronous FIFO

- Write and read operations occur using different clocks.
- Uses Gray-coded pointers for safe clock domain crossing.
- Includes pointer synchronization modules.
- Commonly used for communication between different clock domains.

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
