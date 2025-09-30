# ####################################################################

#  Created by Genus(TM) Synthesis Solution 20.11-s111_1 on Tue Sep 23 16:16:51 IST 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design vendingMachine

create_clock -name "clk" -period 2.0 -waveform {0.0 1.0} [get_ports clk]
set_clock_transition -rise 0.1 [get_clocks clk]
set_load -pin_load 0.15 [get_ports choco_out]
set_load -pin_load 0.15 [get_ports chng_out]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay -max 0.8 [get_ports two_in]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.8 [get_ports one_in]
set_input_delay -clock [get_clocks clk] -add_delay -max 0.8 [get_ports reset]
set_output_delay -clock [get_clocks clk] -add_delay -max 0.8 [get_ports choco_out]
set_output_delay -clock [get_clocks clk] -add_delay -max 0.8 [get_ports chng_out]
set_max_fanout 20.000 [current_design]
set_input_transition 0.12 [get_ports clk]
set_input_transition 0.12 [get_ports reset]
set_input_transition 0.12 [get_ports two_in]
set_input_transition 0.12 [get_ports one_in]
set_wire_load_mode "enclosed"
set_clock_uncertainty -setup 0.01 [get_ports clk]
set_clock_uncertainty -hold 0.01 [get_ports clk]
