# Sennal de CLK
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK }];

# Sennal de RST
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { RST }]; #IO_L4N_T0_D05_14 Sch=btnu

# Sennal de SDA
set_property -dict { PACKAGE_PIN C15   IOSTANDARD LVCMOS33 } [get_ports { SDA }]; #IO_L12N_T1_MRCC_15 Sch=tmp_sda

# Sennal de SCL
set_property -dict { PACKAGE_PIN C14   IOSTANDARD LVCMOS33 } [get_ports { SCL }]; #IO_L1N_T0_AD0N_15 Sch=tmp_scl

# Sennal de ACK_STATE
set_property -dict { PACKAGE_PIN V11   IOSTANDARD LVCMOS33 } [get_ports { ACK_STATE }]; #IO_L21N_T3_DQS_A06_D22_14 Sch=led[15]

# Sennal de DATA
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { DATA[0] }]; #IO_L18P_T2_A24_15 Sch=led[0]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { DATA[1] }]; #IO_L24P_T3_RS1_15 Sch=led[1]
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { DATA[2] }]; #IO_L17N_T2_A25_15 Sch=led[2]
set_property -dict { PACKAGE_PIN N14   IOSTANDARD LVCMOS33 } [get_ports { DATA[3] }]; #IO_L8P_T1_D11_14 Sch=led[3]
set_property -dict { PACKAGE_PIN R18   IOSTANDARD LVCMOS33 } [get_ports { DATA[4] }]; #IO_L7P_T1_D09_14 Sch=led[4]
set_property -dict { PACKAGE_PIN V17   IOSTANDARD LVCMOS33 } [get_ports { DATA[5] }]; #IO_L18N_T2_A11_D27_14 Sch=led[5]
set_property -dict { PACKAGE_PIN U17   IOSTANDARD LVCMOS33 } [get_ports { DATA[6] }]; #IO_L17P_T2_A14_D30_14 Sch=led[6]
set_property -dict { PACKAGE_PIN U16   IOSTANDARD LVCMOS33 } [get_ports { DATA[7] }]; #IO_L18P_T2_A12_D28_14 Sch=led[7]