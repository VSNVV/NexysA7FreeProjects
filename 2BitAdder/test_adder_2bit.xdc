# Sennal de Reloj
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK }];

# Sennal de NUMBER1
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { NUMBER1[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { NUMBER1[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]

# Sennal de NUMBER2
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { NUMBER2[0] }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]
set_property -dict { PACKAGE_PIN R15   IOSTANDARD LVCMOS33 } [get_ports { NUMBER2[1] }]; #IO_L13N_T2_MRCC_14 Sch=sw[3]

# Sennal de RESULT
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { RESULT[0] }]; #IO_L18P_T2_A24_15 Sch=led[0]
set_property -dict { PACKAGE_PIN K15   IOSTANDARD LVCMOS33 } [get_ports { RESULT[1] }]; #IO_L24P_T3_RS1_15 Sch=led[1]
set_property -dict { PACKAGE_PIN J13   IOSTANDARD LVCMOS33 } [get_ports { RESULT[2] }]; #IO_L17N_T2_A25_15 Sch=led[2]

