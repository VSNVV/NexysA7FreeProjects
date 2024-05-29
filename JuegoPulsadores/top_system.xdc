## Clock signal
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK }];

# Sennal de Reset
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { RST }]; #IO_L4N_T0_D05_14 Sch=btnu

# Botones de J1 y J2
set_property -dict { PACKAGE_PIN P17   IOSTANDARD LVCMOS33 } [get_ports { BUTTONJ2 }]; #IO_L12P_T1_MRCC_14 Sch=btnl
set_property -dict { PACKAGE_PIN M17   IOSTANDARD LVCMOS33 } [get_ports { BUTTONJ1 }]; #IO_L10N_T1_D15_14 Sch=btnr

# Led de END_GAME
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { END_GAME }]; #IO_L18P_T2_A24_15 Sch=led[0]

# 7 Segmentos display
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[0] }];	
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[1] }];	
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[2] }];	
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[3] }];	
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[4] }];	
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[5] }];	
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[6] }];

# AND_70
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { AND_70[0] }];	
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { AND_70[1] }];	
set_property -dict { PACKAGE_PIN T9   IOSTANDARD LVCMOS33 } [get_ports { AND_70[2] }];	
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { AND_70[3] }];	
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { AND_70[4] }];	
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { AND_70[5] }];	
set_property -dict { PACKAGE_PIN K2   IOSTANDARD LVCMOS33 } [get_ports { AND_70[6] }];	
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { AND_70[7] }];