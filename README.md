# Design and UVM Verification of ALU

A 4-bit registered ALU designed in SystemVerilog and verified with a UVM testbench.
Simulated in QuestaSim 2021.1 using the built-in UVM 1.1d.

## Repository Hierarchy

```
.
├── README.md
├── rtl/                    # Design under test
│   └── alu.sv
├── verification/           # UVM testbench
│   ├── alu_if.sv
│   ├── alu_seq_item.sv
│   ├── alu_sequence.sv
│   ├── alu_sequencer.sv
│   ├── alu_driver.sv
│   ├── alu_monitor.sv
│   ├── alu_agent.sv
│   ├── alu_scoreboard.sv
│   ├── alu_coverage.sv
│   ├── alu_env.sv
│   ├── alu_test.sv
│   ├── alu_tb_pkg.sv
│   └── alu_tb_top.sv
├── scripts/                # Automation
│   └── run_regression.do
├── questasim logs/         # Simulation logs and transcripts
└── coverage/               # .ucdb databases and coverage reports
```

| Folder | Contents |
|--------|----------|
| `rtl/` | The ALU design (`alu.sv`) |
| `verification/` | Interface, UVM classes, package and testbench top |
| `scripts/` | Tcl `.do` regression script: compile, elaborate, run, save and merge coverage |
| `questasim logs/` | Log files produced by the simulation runs |
| `coverage/` | Per-test and merged `.ucdb` databases and text coverage reports |

## Design (DUT)

- 4-bit operands `a` and `b`, 2-bit opcode `op`, 4-bit registered `result`
- Synchronous operation with an active-high asynchronous reset

| op | Operation |
|----|-----------|
| `2'b00` | `a + b` |
| `2'b01` | `a - b` |
| `2'b10` | `a & b` |
| `2'b11` | `a \| b` |

## UVM Testbench Architecture

```
                    alu_test
                       |
                    alu_env
          ┌────────────┼─────────────┐
      alu_agent   alu_scoreboard  alu_coverage
     ┌────┼─────┐        ^             ^
alu_sequencer alu_driver alu_monitor ---┴--- (analysis port)
     ^            |          |
alu_sequence      └── alu_if ┘
                       |
                      DUT (alu)
```

| Component | Role |
|-----------|------|
| `alu_if` | Interface with clock, reset, inputs and result |
| `alu_seq_item` | Randomized transaction (`a`, `b`, `op`) plus observed `result` |
| `alu_sequence` / `alu_sequencer` | Generates randomized transactions |
| `alu_driver` | Drives transactions onto the interface |
| `alu_monitor` | Samples the interface and broadcasts through an analysis port |
| `alu_agent` | Contains the driver, monitor and sequencer |
| `alu_scoreboard` | Analysis FIFO with a reference model; counts passes and errors |
| `alu_coverage` | Functional coverage (covergroups) |
| `alu_env` / `alu_test` | Environment and test |
| `alu_tb_pkg` | Package that includes all UVM classes |
| `alu_tb_top` | Top module: clock, reset, DUT, interface and `config_db` setup |

## Features

- Constrained-random stimulus
- Self-checking scoreboard with a reference model
- Functional coverage and code coverage on the DUT (statement, branch, condition, expression, toggle)
- Automated regression that saves per-test `.ucdb` files and merges them

## How to Run

1. Open QuestaSim and `cd` to the repository root.
2. Run the regression script:

   ```
   do scripts/run_regression.do
   ```

3. Logs are written to `questasim logs/` and coverage results to `coverage/`.

> Compile order matters: `alu.sv` and `alu_if.sv` first, then `alu_tb_pkg.sv`
> (which includes all UVM class files), then `alu_tb_top.sv`. The class files
> included by the package must not be compiled separately.

## Tools

- QuestaSim 2021.1
- UVM 1.1d
- SystemVerilog
