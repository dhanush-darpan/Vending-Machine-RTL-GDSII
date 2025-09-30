# RTL Script to run Basic Synthesis Flow
set_db init_lib_search_path /home/install/FOUNDRY/digital/90nm/dig/lib/
set_db library slow.lib
read_hdl vendingMachine.v
elaborate
read_sdc ./input_constraints.sdc

set_db syn_generic_effort medium
syn_generic
set_db syn_map_effort medium
syn_map
set_db syn_opt_effort medium
syn_opt

write_hdl > vm_netlist.v
write_sdc > vm_output.sdc
report timing > vm_timing.rep
report area > vm_area.rep
report gates > vm_GateCount.rep
report power > vm_power.rep
report_timing_summary> vm_timing_summary.rep
gui_show
