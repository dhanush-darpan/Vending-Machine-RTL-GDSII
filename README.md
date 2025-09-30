# Vending Machine — RTL → GDSII (Cadence Design Suite)

**One-line:** A complete Cadence-based flow for a small vending-machine finite-state machine: RTL (Verilog) → synthesis (Genus) → gate-level netlist → P&R / GDSII with associated constraints, libs and verification assets.

## Project summary

This repository contains the RTL, testbench, synthesis scripts, foundry libraries (LEF/LIB), constraints and the final GDSII produced using Cadence tools (Genus / Innovus / Xcelium/Incisive). The design implements a small FSM-based vending machine with two inputs (one_in, two_in) and two outputs (choco_out, chng_out) and uses a 3-bit state register to sequence between idle, two_rs, one_rs, chocoout, and chngout.

### Key artifacts included:

- **RTL**: vendingMachine.v
- **Testbench**: testbench.v
- **Synthesized gate-level netlist**: vm_netlist.v (Genus-generated)
- **Constraints**: input_constraints.sdc, vm_output.sdc
- **Foundry files / libs / LEF**: under vendingMachine.enc.dat/libs/...
- **P&R / GDSII**: vendingMachine.gds
- **Flow scripts for synthesis / verification**: run.tcl, various *.tcl
- **Cadence simulation & verification support**: .simvision, INCA_libs (irun)
- **Reports produced by the flow**: timing, area, power, gate counts (e.g. vm_timing.rep, vm_area.rep, vm_power.rep, vm_GateCount.rep)

### High-level design notes

**Module**: vendingMachine

**Ports**:
- output choco_out, output chng_out, input clk, input reset, input two_in, input one_in

**FSM states** (as parameters):
- idle = 3'b000
- two_rs = 3'b001
- one_rs = 3'b010
- chocoout = 3'b011
- chngout = 3'b100

The repo contains both the RTL behavioral-style Verilog and a Genus-generated gate-level netlist (with mapped cell names and DFF cells).

Test vectors are in testbench.v — simple clock generator + stimulus sequences to exercise coin inputs and outputs.

### Directory structure (top-level — trimmed)
Vending Machine/
├─ vendingMachine.v # RTL
├─ testbench.v # Testbench / simulation stimulus
├─ vm_netlist.v # Gate-level netlist (Genus output)
├─ run.tcl # Example synthesis script (Genus)
├─ input_constraints.sdc # Input constraints for synthesis/timing
├─ vm_output.sdc # Output constraints (synth generated)
├─ vendingMachine.gds # Final GDSII
├─ vendingMachine.enc.dat/ # Encapsulated design data (LEF, libs, view prefs)
├─ fv/ # functional verification / fv maps
├─ INCA_libs/ # cadence/incisive support (irun)
├─ .simvision/ # Simvision bookmarks/config
└─ reports/ ... # timing/area/power reports (produced by flows)


Use zip contents or `ls` to review the full tree. The repository includes .git/ from the original environment; you can remove it if you want a fresh repo.

## Reproducing / Running the flow

**Assumption**: You have a licensed Cadence environment with Genus (synthesis), Innovus (place & route), and Incisive/Xcelium or equivalent. Paths to foundry libraries must be adjusted for your environment.

### 1) Functional simulation (open-source or Cadence)

**Open-source** (iverilog + vvp):

```sh
# from the repository root
iverilog -o tb.vvp vendingMachine.v testbench.v
vvp tb.vvp
```

### Cadence Incisive / Xcelium (example using irun):

```sh
# example; adjust library paths and INCAR files to your environment
irun -access +rwc -v2001 \
  -f filelist.f \
  -top testbench \
  -incdir ./vendingMachine.enc.dat/libs \
  +libext+.v \
  +define+SIM
```
(If INCA_libs is present, it contains runtime-specific library mappings for irun.)

### 2) Synthesis with Genus

A run.tcl script is included (Vending Machine/run.tcl). It does the following at a high level: sets library path, read RTL, read SDC, run synthesis (syn_generic / map / opt), write vm_netlist.v, and generate reports.

```sh
# inside Genus interactive or batch
source run.tcl
# or from shell:
genus -files run.tcl
```

Adjust init_lib_search_path and library entries within run.tcl to match your foundry/licensed library paths. The script writes timing/area/power reports: vm_timing.rep, vm_area.rep, vm_power.rep, vm_GateCount.rep.

### 3) Place & Route (Innovus / ICC / Innovus flow)

The package contains LEF and mapping files under vendingMachine.enc.dat/libs/lef/ and other tool-pref files. A typical Innovus flow:

```sh
# example (simplified)
innovus -no_gui -init pnr_run.tcl
# or in GUI:
innovus
# then source the included viewDefinition.tcl / preferences in the Enc data
```

If there is a provided P&R TCL (check inside vendingMachine.enc.dat or fv/), source that from Innovus. The final GDS in this repo is vendingMachine.gds.

### 4) LVS / DRC / Signoff

Use Foundry PDK views (DRC/LVS decks) with Calibre or Mentor tools as per your flow. This zip does not include proprietary DRC/LVS decks — run DRC/LVS using your foundry-provided rules.

Gate-level netlist (vm_netlist.v) and the LEF/GDS are present to cross-check.

## Files of special interest

- vendingMachine.v — top-level RTL. Contains the FSM and I/O.
- vm_netlist.v — synthesized netlist (Genus) with mapped cells and flops.
- testbench.v — simple stimulus to exercise the state machine.
- run.tcl — example synthesis flow script for Genus (edit library paths).
- input_constraints.sdc — clock and input timing constraints for synthesis.
- vendingMachine.gds — final GDSII layout.
- vendingMachine.enc.dat/ — contains LEF, lib and GUI preferences used by the Cadence tools.
- INCA_libs/ — incise/irun support (library mappings). Useful to simulate with Cadence tools.

## Reports & outputs (what to expect)

Synthesis flow (run.tcl) generates:
- vm_timing.rep — detailed timing report
- vm_timing_summary.rep — timing summary
- vm_area.rep — area report
- vm_GateCount.rep — gate count
- vm_power.rep — power estimate

Place & route may produce additional reporting files (power maps, final timing, fill reports).

## How to inspect the GDS / layout

Cadence Virtuoso / Layout XL / IC Station / Innovus — open vendingMachine.gds inside those tools with the appropriate PDK/tech library loaded.

```sh
klayout vendingMachine.gds
```

Be aware that correct layer interpretation requires the foundry layer map — otherwise shapes will still display, but layer semantics and colors may be generic.

## Conclusion

This project successfully demonstrates the end-to-end ASIC design flow for a digital system, starting from RTL coding in Verilog, through simulation and synthesis, and finally generating the GDSII layout using Cadence tools. The vending machine FSM serves as a compact yet practical example to illustrate each stage of the VLSI design cycle, including functional verification, timing closure, and physical implementation.

### This work can be extended further by:

- Running signoff checks (DRC/LVS) using foundry-provided decks
- Performing power optimization and floorplanning improvements
- Scaling the FSM to handle more complex vending operations