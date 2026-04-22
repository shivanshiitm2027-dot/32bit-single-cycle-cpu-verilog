# 32bit Single-Cycle CPU in Verilog

## Overview
This project implements a 32-bit single-cycle CPU in Verilog.

## Features
- 32-bit datapath
- ALU operations: ADD, SUB, AND, OR
- Load/store support
- Branch support
- Integrated datapath and control
- Simulation-based verification

## Modules
- `pc.v`
- `instr_mem.v`
- `reg_file.v`
- `control_unit.v`
- `alu_control.v`
- `alu.v`
- `data_mem.v`
- `sign_extend.v`
- `adder.v`
- `shift_left2.v`
- `mux2.v`
- `cpu_top.v`
- `tb_cpu.v`

## Tools Used
- Verilog
- Vivado / ModelSim / GTKWave

## Notes
This project is intended as a foundational CPU/datapath design project for learning computer architecture, RTL design, and digital system integration.
