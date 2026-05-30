# Synchronous & Asynchronous FIFO Design in Verilog

## Overview

This project implements both **Synchronous FIFO** and **Asynchronous FIFO** architectures using **Verilog HDL**. The designs were developed to understand FIFO-based data buffering, memory management, and clock domain crossing (CDC) techniques commonly used in digital and VLSI systems.

The repository includes:
- Verilog source code for Synchronous FIFO
- Verilog source code for Asynchronous FIFO
- Testbenches for functional verification
- Simulation waveforms
- FIFO status flag generation (Full, Empty, etc.)

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

### Synchronous FIFO

- Write and read operations occur using the same clock.
- Uses binary read and write pointers.
- Suitable for systems operating within a single clock domain.

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
