# Verilog_Voting_machine
RTL design and testbench of a voting machine using Verilog
# Verilog Voting Machine

This project implements a digital **voting machine** using Verilog HDL. It simulates the core functionality of an electronic voting system, including candidate selection, vote registration, and result display. The design is based on a finite state machine (FSM) and verified through a testbench using waveform simulations.

---

## Design Overview

The voting machine allows users to vote for one of multiple candidates. It uses an FSM to transition between states such as idle, ready, voting, and result display.

### Key Functionalities

- Candidate selection via binary or one-hot encoded inputs
- Vote registration only during active voting sessions
- Synchronous FSM-driven logic
- Accurate vote counting for each candidate
- Reset capability to initialize system for new sessions

---

## Input/Output Description

### Inputs

| Signal            | Description                               |
|-------------------|-------------------------------------------|
| `clk`             | Clock signal                              |
| `reset`           | Active-high reset input                   |
| `vote_enable`     | Enables/disables voting session           |
| `vote_btn`        | Simulates vote casting button             |
| `candidate_select`| Encoded input to select a candidate       |

### Outputs

| Signal           | Description                                 |
|------------------|---------------------------------------------|
| `vote_count_X`   | Vote counter for each candidate             |
| `result_display` | Output showing final result (if applicable) |
| `state`          | Current FSM state (for verification)        |

---

## Testbench Description

The testbench (`testbench.v`) is designed to verify the voting machine's behavior across various conditions:

- Valid and invalid vote casting
- Reset functionality
- Session-based voting control
- FSM state transitions
- Accurate vote tallying

Simulation can be performed using tools like **ModelSim**, **GTKWave**, or **Vivado**, and waveform outputs can be used to verify correctness.

---

## Repository Structure

