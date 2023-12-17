# Clock Constraint
create_clock -period 10 [get_ports clk]

# I/O Assignments
set_property -dict {PACKAGE_PIN P25 IOSTANDARD LVCMOS33} [get_ports tx]
set_property -dict {PACKAGE_PIN P26 IOSTANDARD LVCMOS33} [get_ports rx]
