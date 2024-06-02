# Sennal de Reloj
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK }];

# Sennal de Reset
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { RST }]; #IO_L4N_T0_D05_14 Sch=btnu

# Sennal BIN_NUM
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[0] }]; #IO_L24N_T3_RS0_15 Sch=BIN_NUM[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=BIN_NUM[1]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=BIN_NUM[2]
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[3] }]; #IO_L13N_T2_MRCC_14 Sch=BIN_NUM[3]
set_property -dict { PACKAGE_PIN R17   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[4] }]; #IO_L12N_T1_MRCC_14 Sch=BIN_NUM[4]
set_property -dict { PACKAGE_PIN T18   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[5] }]; #IO_L7N_T1_D10_14 Sch=BIN_NUM[5]
set_property -dict { PACKAGE_PIN U18   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[6] }]; #IO_L17N_T2_A13_D29_14 Sch=BIN_NUM[6]
set_property -dict { PACKAGE_PIN R13   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[7] }]; #IO_L5N_T0_D07_14 Sch=BIN_NUM[7]
set_property -dict { PACKAGE_PIN T8    IOSTANDARD LVCMOS18 } [get_ports { BIN_NUM[8] }]; #IO_L24N_T3_34 Sch=BIN_NUM[8]
set_property -dict { PACKAGE_PIN U8    IOSTANDARD LVCMOS18 } [get_ports { BIN_NUM[9] }]; #IO_25_34 Sch=BIN_NUM[9]
set_property -dict { PACKAGE_PIN R16   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[10] }]; #IO_L15P_T2_DQS_RDWR_B_14 Sch=BIN_NUM[10]
set_property -dict { PACKAGE_PIN T13   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[11] }]; #IO_L23P_T3_A03_D19_14 Sch=BIN_NUM[11]
set_property -dict { PACKAGE_PIN H6    IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[12] }]; #IO_L24P_T3_35 Sch=BIN_NUM[12]
set_property -dict { PACKAGE_PIN U12   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[13] }]; #IO_L20P_T3_A08_D24_14 Sch=BIN_NUM[13]
set_property -dict { PACKAGE_PIN U11   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[14] }]; #IO_L19N_T3_A09_D25_VREF_14 Sch=BIN_NUM[14]
set_property -dict { PACKAGE_PIN V10   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM[15] }]; #IO_L21P_T3_DQS_14 Sch=BIN_NUM[15]

# Sennal BIN_NUM_OK
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { BIN_NUM_OK }]; #IO_L9P_T1_DQS_14 Sch=btnc

# Sennal SEG_AG
set_property -dict { PACKAGE_PIN T10   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[0] }]; #IO_L24N_T3_A00_D16_14 Sch=ca
set_property -dict { PACKAGE_PIN R10   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[1] }]; #IO_25_14 Sch=cb
set_property -dict { PACKAGE_PIN K16   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[2] }]; #IO_25_15 Sch=cc
set_property -dict { PACKAGE_PIN K13   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[3] }]; #IO_L17P_T2_A26_15 Sch=cd
set_property -dict { PACKAGE_PIN P15   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[4] }]; #IO_L13P_T2_MRCC_14 Sch=ce
set_property -dict { PACKAGE_PIN T11   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[5] }]; #IO_L19P_T3_A10_D26_14 Sch=cf
set_property -dict { PACKAGE_PIN L18   IOSTANDARD LVCMOS33 } [get_ports { SEG_AG[6] }]; #IO_L4P_T0_D04_14 Sch=cg

# Sennal AND_70
set_property -dict { PACKAGE_PIN J17   IOSTANDARD LVCMOS33 } [get_ports { AND_70[0] }]; #IO_L23P_T3_FOE_B_15 Sch=an[0]
set_property -dict { PACKAGE_PIN J18   IOSTANDARD LVCMOS33 } [get_ports { AND_70[1] }]; #IO_L23N_T3_FWE_B_15 Sch=an[1]
set_property -dict { PACKAGE_PIN T9    IOSTANDARD LVCMOS33 } [get_ports { AND_70[2] }]; #IO_L24P_T3_A01_D17_14 Sch=an[2]
set_property -dict { PACKAGE_PIN J14   IOSTANDARD LVCMOS33 } [get_ports { AND_70[3] }]; #IO_L19P_T3_A22_15 Sch=an[3]
set_property -dict { PACKAGE_PIN P14   IOSTANDARD LVCMOS33 } [get_ports { AND_70[4] }]; #IO_L8N_T1_D12_14 Sch=an[4]
set_property -dict { PACKAGE_PIN T14   IOSTANDARD LVCMOS33 } [get_ports { AND_70[5] }]; #IO_L14P_T2_SRCC_14 Sch=an[5]
set_property -dict { PACKAGE_PIN K2    IOSTANDARD LVCMOS33 } [get_ports { AND_70[6] }]; #IO_L23P_T3_35 Sch=an[6]
set_property -dict { PACKAGE_PIN U13   IOSTANDARD LVCMOS33 } [get_ports { AND_70[7] }]; #IO_L23N_T3_A02_D18_14 Sch=an[7]