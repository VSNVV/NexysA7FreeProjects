## Sennal de Reloj
set_property -dict { PACKAGE_PIN E3    IOSTANDARD LVCMOS33 } [get_ports { CLK }]; #IO_L12P_T1_MRCC_35 Sch=clk100mhz
create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports { CLK }];

## Boton de RST
set_property -dict { PACKAGE_PIN M18   IOSTANDARD LVCMOS33 } [get_ports { RST }]; #IO_L4N_T0_D05_14 Sch=btnu

## Entrada UART RX
set_property -dict { PACKAGE_PIN C4    IOSTANDARD LVCMOS33 } [get_ports { RX }]; #IO_L7P_T1_AD6P_35 Sch=uart_txd_in

# Sennal ERROR_RECEP
set_property -dict { PACKAGE_PIN H17   IOSTANDARD LVCMOS33 } [get_ports { ERROR_RECEP }]; #IO_L18P_T2_A24_15 Sch=led[0]

# Sennal de los LEDS RGB
set_property -dict { PACKAGE_PIN R12   IOSTANDARD LVCMOS33 } [get_ports { PWM_BLUE_OUT1 }]; #IO_L5P_T0_D06_14 Sch=led16_b
set_property -dict { PACKAGE_PIN M16   IOSTANDARD LVCMOS33 } [get_ports { PWM_GREEN_OUT1 }]; #IO_L10P_T1_D14_14 Sch=led16_g
set_property -dict { PACKAGE_PIN N15   IOSTANDARD LVCMOS33 } [get_ports { PWM_RED_OUT1 }]; #IO_L11P_T1_SRCC_14 Sch=led16_r

set_property -dict { PACKAGE_PIN G14   IOSTANDARD LVCMOS33 } [get_ports { PWM_BLUE_OUT2 }]; #IO_L15N_T2_DQS_ADV_B_15 Sch=led17_b
set_property -dict { PACKAGE_PIN R11   IOSTANDARD LVCMOS33 } [get_ports { PWM_GREEN_OUT2 }]; #IO_0_14 Sch=led17_g
set_property -dict { PACKAGE_PIN N16   IOSTANDARD LVCMOS33 } [get_ports { PWM_RED_OUT2 }]; #IO_L11N_T1_SRCC_14 Sch=led17_r