# Sennal de Reloj
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK }];

# Sennal de Reset
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { RST }]; #IO_L4N_T0_D05_14 Sch=btnu

# NUMBER_IN
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { NUMBER_IN[0] }]; #IO_L24N_T3_RS0_15 Sch=NUMBER_IN[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { NUMBER_IN[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=NUMBER_IN[1]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { NUMBER_IN[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=NUMBER_IN[2]
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { NUMBER_IN[3] }]; #IO_L13N_T2_MRCC_14 Sch=NUMBER_IN[3]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { NUMBER_IN[4] }]; #IO_L12N_T1_MRCC_14 Sch=NUMBER_IN[4]
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { NUMBER_IN[5] }]; #IO_L7N_T1_D10_14 Sch=NUMBER_IN[5]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { NUMBER_IN[6] }]; #IO_L17N_T2_A13_D29_14 Sch=NUMBER_IN[6]
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { NUMBER_IN[7] }]; #IO_L5N_T0_D07_14 Sch=NUMBER_IN[7]

# NUMBER_OK
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { NUMBER_OK }]; #IO_L9P_T1_DQS_14 Sch=btnc

# SEG_AG
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[0] }];	
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[1] }];	
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[2] }];	
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[3] }];	
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[4] }];	
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[5] }];	
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[6] }];	

# AND_70
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { AND_70[0] }]; #IO_L23P_T3_FOE_B_15 Sch=an[0]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { AND_70[1] }]; #IO_L23N_T3_FWE_B_15 Sch=an[1]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { AND_70[2] }]; #IO_L24P_T3_A01_D17_14 Sch=an[2]
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { AND_70[3] }]; #IO_L19P_T3_A22_15 Sch=an[3]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { AND_70[4] }]; #IO_L8N_T1_D12_14 Sch=an[4]
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { AND_70[5] }]; #IO_L14P_T2_SRCC_14 Sch=an[5]
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { AND_70[6] }]; #IO_L23P_T3_35 Sch=an[6]
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { AND_70[7] }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]