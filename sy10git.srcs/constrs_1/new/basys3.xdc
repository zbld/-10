## Clock (100?MHz)


set_property PACKAGE_PIN W5 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]
create_clock -add -name sys_clk_pin -period 10.000 -waveform {0 5} [get_ports clk]

## Reset button (BTNC)
set_property PACKAGE_PIN U18 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]

## Switches for debug (use SW0-SW4 -> sw_dbg[0..4])
set_property PACKAGE_PIN V17 [get_ports {sw_dbg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_dbg[0]}]

set_property PACKAGE_PIN V16 [get_ports {sw_dbg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_dbg[1]}]

set_property PACKAGE_PIN W16 [get_ports {sw_dbg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_dbg[2]}]

set_property PACKAGE_PIN W17 [get_ports {sw_dbg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_dbg[3]}]

set_property PACKAGE_PIN W15 [get_ports {sw_dbg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {sw_dbg[4]}]

set_property PACKAGE_PIN W4 [get_ports {ans[3]}]	
set_property PACKAGE_PIN V4 [get_ports {ans[2]}]
set_property PACKAGE_PIN U4 [get_ports {ans[1]}]
set_property PACKAGE_PIN U2 [get_ports {ans[0]}]	
set_property PACKAGE_PIN W7 [get_ports {seg[6]}]
set_property PACKAGE_PIN W6 [get_ports {seg[5]}]
set_property PACKAGE_PIN U8 [get_ports {seg[4]}]
set_property PACKAGE_PIN V8 [get_ports {seg[3]}]
set_property PACKAGE_PIN U5 [get_ports {seg[2]}]
set_property PACKAGE_PIN V5 [get_ports {seg[1]}]
set_property PACKAGE_PIN U7 [get_ports {seg[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ans[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ans[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ans[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {ans[0]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[6]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[5]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[4]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[3]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[2]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[1]}]
set_property IOSTANDARD LVCMOS33 [get_ports {seg[0]}]