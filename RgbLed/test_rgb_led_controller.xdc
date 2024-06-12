# Sennal de Reloj
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK }];

# Sennal de RST
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { RST }]; #IO_L4N_T0_D05_14 Sch=btnu

# Sennal COLOR_SET
set_property -dict { PACKAGE_PIN J15   IOSTANDARD LVCMOS33 } [get_ports { COLOR_SET[0] }]; #IO_L24N_T3_RS0_15 Sch=sw[0]
set_property -dict { PACKAGE_PIN L16   IOSTANDARD LVCMOS33 } [get_ports { COLOR_SET[1] }]; #IO_L3N_T0_DQS_EMCCLK_14 Sch=sw[1]
set_property -dict { PACKAGE_PIN M13   IOSTANDARD LVCMOS33 } [get_ports { COLOR_SET[2] }]; #IO_L6N_T0_D08_VREF_14 Sch=sw[2]

# Sennal COLOR_SET_OK
set_property -dict { PACKAGE_PIN N17   IOSTANDARD LVCMOS33 } [get_ports { COLOR_SET_OK }]; #IO_L9P_T1_DQS_14 Sch=btnc

# Leds RGB
set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { BLUE_LED2 }]; #IO_L5P_T0_D06_14 Sch=led16_b
set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { GREEN_LED2 }]; #IO_L10P_T1_D14_14 Sch=led16_g
set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { RED_LED2 }]; #IO_L11P_T1_SRCC_14 Sch=led16_r
set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { BLUE_LED1 }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=led17_b
set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { GREEN_LED1 }]; #IO_0_14 Sch=led17_g
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { RED_LED1 }]; #IO_L11N_T1_SRCC_14 Sch=led17_r