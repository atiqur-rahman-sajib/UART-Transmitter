# UART Transmitter - SystemVerilog

## Project Overview
A UART (Universal Asynchronous Receiver-Transmitter) Transmitter implemented 
in SystemVerilog. The design transmits 8-bit data serially at 9600 baud using 
a 50MHz system clock.

## Specifications
- Clock Frequency : 50 MHz
- Baud Rate       : 9600
- Data Bits       : 8
- Start Bits      : 1
- Stop Bits       : 1
- Parity          : None (8N1)

## Files
- design.sv    : UART TX module (uart_tx)
- testbench.sv : Testbench (tb_uart_tx)

## How It Works
The design uses a 4-state FSM:
- IDLE  : Line held HIGH, waiting for tx_start
- START : Pulls line LOW for one bit period (start bit)
- DATA  : Transmits 8 data bits LSB first
- STOP  : Pulls line HIGH for one bit period (stop bit)

## Test Cases
Test 1 : Send 0x41 ('A')
Test 2 : Send 0xFF (all ones)
Test 3 : Send 0x00 (all zeros)

## How to Simulate
Open in EDA Playground:
https://edaplayground.com/x/ts3j

Tools: SystemVerilog + any Verilog simulator (e.g. Icarus Verilog)

## Author
Atiqur Rahman Sajib
