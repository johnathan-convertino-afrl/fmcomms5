set_global_assignment -name TOP_LEVEL_ENTITY system_wrapper

set_global_assignment -name ROUTER_CLOCKING_TOPOLOGY_ANALYSIS ON
set_global_assignment -name OPTIMIZATION_MODE "HIGH PERFORMANCE EFFORT"
set_global_assignment -name PHYSICAL_SYNTHESIS ON
set_global_assignment -name ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION ON
set_global_assignment -name ROUTER_TIMING_OPTIMIZATION_LEVEL MAXIMUM
set_global_assignment -name FITTER_EFFORT "STANDARD FIT"
set_global_assignment -name PLACEMENT_EFFORT_MULTIPLIER 4.0
set_global_assignment -name OPTIMIZE_POWER_DURING_FITTING OFF

# lane interface

# Note: This projects requires a hardware rework to function correctly.
# The rework connects FMC header pins directly to the FPGA so that they can be
# accessed by the fabric.
#
# Changes required:
#  FMCA
#  R610: DNI -> R0
#  R611: DNI -> R0
#  R612: R0  -> DNI
#  R613: R0  -> DNI
#  R620: DNI -> R0
#  R632: DNI -> R0
#  R621: R0  -> DNI
#  R633: R0  -> DNI
#
#  FMCB
#  R361: R0  -> DNI
#  R365: R0  -> DNI
#  R360: DNI -> R0
#  R364: DNI -> R0
#  R373: R0  -> DNI
#  R383: R0  -> DNI
#  R372: DNI -> R0
#  R392: DNI -> R0

# constraints
# ad9361
set_location_assignment PIN_A4   -to  ref_clk                  ; ## D20  FMCA_HPC_LA17_CC_P
set_location_assignment PIN_B4   -to  "rx_clk(n)"              ; ## D21  FMCA_HPC_LA17_CC_N
## ID 0
set_location_assignment PIN_G14   -to  rx_clk_in_0             ; ## G06  FMCA_HPC_LA00_CC_P
set_location_assignment PIN_H14   -to  "rx_clk_in_0(n)"        ; ## G07  FMCA_HPC_LA00_CC_N
set_location_assignment PIN_E12   -to  rx_frame_in_0_p         ; ## D08  FMCA_HPC_LA01_CC_P
set_location_assignment PIN_E13   -to  rx_frame_in_0_n         ; ## D09  FMCA_HPC_LA01_CC_N
set_location_assignment PIN_C13   -to  rx_data_in_0_p[0]       ; ## H07  FMCA_HPC_LA02_P
set_location_assignment PIN_D13   -to  rx_data_in_0_n[0]       ; ## H08  FMCA_HPC_LA02_N
set_location_assignment PIN_C14   -to  rx_data_in_0_p[1]       ; ## G09  FMCA_HPC_LA03_P
set_location_assignment PIN_D14   -to  rx_data_in_0_n[1]       ; ## G10  FMCA_HPC_LA03_N
set_location_assignment PIN_H12   -to  rx_data_in_0_p[2]       ; ## H10  FMCA_HPC_LA04_P
set_location_assignment PIN_H13   -to  rx_data_in_0_n[2]       ; ## H11  FMCA_HPC_LA04_N
set_location_assignment PIN_F13   -to  rx_data_in_0_p[3]       ; ## D11  FMCA_HPC_LA05_P
set_location_assignment PIN_F14   -to  rx_data_in_0_n[3]       ; ## D12  FMCA_HPC_LA05_N
set_location_assignment PIN_A10   -to  rx_data_in_0_p[4]       ; ## C10  FMCA_HPC_LA06_P
set_location_assignment PIN_B10   -to  rx_data_in_0_n[4]       ; ## C11  FMCA_HPC_LA06_N
set_location_assignment PIN_A9    -to  rx_data_in_0_p[5]       ; ## H13  FMCA_HPC_LA07_P
set_location_assignment PIN_B9    -to  rx_data_in_0_n[5]       ; ## H14  FMCA_HPC_LA07_N
set_location_assignment PIN_B11   -to  tx_clk_out_0_p          ; ## G12  FMCA_HPC_LA08_P
set_location_assignment PIN_B12   -to  tx_clk_out_0_n          ; ## G13  FMCA_HPC_LA08_N
set_location_assignment PIN_A12   -to  tx_frame_out_0_p        ; ## D14  FMCA_HPC_LA09_P
set_location_assignment PIN_A13   -to  tx_frame_out_0_n        ; ## D15  FMCA_HPC_LA09_N

set_location_assignment PIN_A7    -to  tx_data_out_0_p[0]      ; ## C14  FMCA_HPC_LA10_P
set_location_assignment PIN_A8    -to  tx_data_out_0_n[0]      ; ## C15  FMCA_HPC_LA10_N
set_location_assignment PIN_C9    -to  tx_data_out_0_p[1]      ; ## H16  FMCA_HPC_LA11_P
set_location_assignment PIN_D9    -to  tx_data_out_0_n[1]      ; ## H17  FMCA_HPC_LA11_N
set_location_assignment PIN_M12   -to  tx_data_out_0_p[2]      ; ## G15  FMCA_HPC_LA12_P
set_location_assignment PIN_N13   -to  tx_data_out_0_n[2]      ; ## G16  FMCA_HPC_LA12_N
set_location_assignment PIN_J11   -to  tx_data_out_0_p[3]      ; ## D17  FMCA_HPC_LA13_P
set_location_assignment PIN_K11   -to  tx_data_out_0_n[3]      ; ## D18  FMCA_HPC_LA13_N
set_location_assignment PIN_J9    -to  tx_data_out_0_p[4]      ; ## C18  FMCA_HPC_LA14_P
set_location_assignment PIN_J10   -to  tx_data_out_0_n[4]      ; ## C19  FMCA_HPC_LA14_N
set_location_assignment PIN_D4    -to  tx_data_out_0_p[5]      ; ## H19  FMCA_HPC_LA15_P
set_location_assignment PIN_D5    -to  tx_data_out_0_n[5]      ; ## H20  FMCA_HPC_LA15_N

set_instance_assignment -name IO_STANDARD LVDS               -to rx_clk_in_0
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_clk_in_0
set_instance_assignment -name IO_STANDARD LVDS               -to rx_frame_in_0_p
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_frame_in_0_p
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_frame_in_0_p
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_0_p[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_0_p[0]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_0_p[0]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_0_p[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_0_p[1]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_0_p[1]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_0_p[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_0_p[2]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_0_p[2]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_0_p[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_0_p[3]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_0_p[3]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_0_p[4]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_0_p[4]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_0_p[4]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_0_p[5]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_0_p[5]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_0_p[5]

set_instance_assignment -name IO_STANDARD LVDS               -to tx_clk_out_0_p
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_clk_out_0_p
set_instance_assignment -name IO_STANDARD LVDS               -to tx_frame_out_0_p
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_frame_out_0_p
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_0_p[0]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_0_p[0]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_0_p[1]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_0_p[1]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_0_p[2]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_0_p[2]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_0_p[3]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_0_p[3]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_0_p[4]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_0_p[4]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_0_p[5]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_0_p[5]

## ID 1
set_location_assignment PIN_AV7   -to  rx_clk_in_1             ; ## G06  FMCB_HPC_LA00_CC_P
set_location_assignment PIN_AU7   -to  "rx_clk_in_1(n)"        ; ## G07  FMCB_HPC_LA00_CC_N
set_location_assignment PIN_AT7   -to  rx_frame_in_1_p         ; ## D08  FMCB_HPC_LA01_CC_P
set_location_assignment PIN_AT8   -to  rx_frame_in_1_n         ; ## D09  FMCB_HPC_LA01_CC_N
set_location_assignment PIN_AT9   -to  rx_data_in_1_p[0]       ; ## H07  FMCB_HPC_LA02_P
set_location_assignment PIN_AT10  -to  rx_data_in_1_n[0]       ; ## H08  FMCB_HPC_LA02_N
set_location_assignment PIN_AW8   -to  rx_data_in_1_p[1]       ; ## G09  FMCB_HPC_LA03_P
set_location_assignment PIN_AV8   -to  rx_data_in_1_n[1]       ; ## G10  FMCB_HPC_LA03_N
set_location_assignment PIN_AV9   -to  rx_data_in_1_p[2]       ; ## H10  FMCB_HPC_LA04_P
set_location_assignment PIN_AU9   -to  rx_data_in_1_n[2]       ; ## H11  FMCB_HPC_LA04_N
set_location_assignment PIN_AW9   -to  rx_data_in_1_p[3]       ; ## D11  FMCB_HPC_LA05_P
set_location_assignment PIN_AW10  -to  rx_data_in_1_n[3]       ; ## D12  FMCB_HPC_LA05_N -
set_location_assignment PIN_AR8   -to  rx_data_in_1_p[4]       ; ## C10  FMCB_HPC_LA06_P
set_location_assignment PIN_AP8   -to  rx_data_in_1_n[4]       ; ## C11  FMCB_HPC_LA06_N
set_location_assignment PIN_AU10  -to  rx_data_in_1_p[5]       ; ## H13  FMCB_HPC_LA07_P
set_location_assignment PIN_AU11  -to  rx_data_in_1_n[5]       ; ## H14  FMCB_HPC_LA07_N
set_location_assignment PIN_AP9   -to  tx_clk_out_1_p          ; ## G12  FMCB_HPC_LA08_P
set_location_assignment PIN_AN9   -to  tx_clk_out_1_n          ; ## G13  FMCB_HPC_LA08_N
set_location_assignment PIN_AR10  -to  tx_frame_out_1_p        ; ## D14  FMCB_HPC_LA09_P
set_location_assignment PIN_AP10  -to  tx_frame_out_1_n        ; ## D15  FMCB_HPC_LA09_N

set_location_assignment PIN_AT12  -to  tx_data_out_1_p[0]      ; ## C14  FMCB_HPC_LA10_P
set_location_assignment PIN_AR12  -to  tx_data_out_1_n[0]      ; ## C15  FMCB_HPC_LA10_N
set_location_assignment PIN_AK11  -to  tx_data_out_1_p[1]      ; ## H16  FMCB_HPC_LA11_P
set_location_assignment PIN_AK12  -to  tx_data_out_1_n[1]      ; ## H17  FMCB_HPC_LA11_N
set_location_assignment PIN_AM12  -to  tx_data_out_1_p[2]      ; ## G15  FMCB_HPC_LA12_P
set_location_assignment PIN_AL12  -to  tx_data_out_1_n[2]      ; ## G16  FMCB_HPC_LA12_N
set_location_assignment PIN_AN11  -to  tx_data_out_1_p[3]      ; ## D17  FMCB_HPC_LA13_P
set_location_assignment PIN_AM11  -to  tx_data_out_1_n[3]      ; ## D18  FMCB_HPC_LA13_N
set_location_assignment PIN_AL13  -to  tx_data_out_1_p[4]      ; ## C18  FMCB_HPC_LA14_P
set_location_assignment PIN_AL14  -to  tx_data_out_1_n[4]      ; ## C19  FMCB_HPC_LA14_N
set_location_assignment PIN_AN12  -to  tx_data_out_1_p[5]      ; ## H19  FMCB_HPC_LA15_P
set_location_assignment PIN_AN13  -to  tx_data_out_1_n[5]      ; ## H20  FMCB_HPC_LA15_N

set_instance_assignment -name IO_STANDARD LVDS               -to rx_clk_in_1
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_clk_in_1
set_instance_assignment -name IO_STANDARD LVDS               -to rx_frame_in_1_p
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_frame_in_1_p
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_frame_in_1_p
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_1_p[0]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_1_p[0]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_1_p[0]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_1_p[1]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_1_p[1]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_1_p[1]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_1_p[2]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_1_p[2]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_1_p[2]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_1_p[3]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_1_p[3]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_1_p[3]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_1_p[4]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_1_p[4]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_1_p[4]
set_instance_assignment -name IO_STANDARD LVDS               -to rx_data_in_1_p[5]
set_instance_assignment -name INPUT_TERMINATION DIFFERENTIAL -to rx_data_in_1_p[5]
set_instance_assignment -name INPUT_DELAY_CHAIN 30           -to rx_data_in_1_p[5]

set_instance_assignment -name IO_STANDARD LVDS               -to tx_clk_out_1_p
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_clk_out_1_p
set_instance_assignment -name IO_STANDARD LVDS               -to tx_frame_out_1_p
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_frame_out_1_p
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_1_p[0]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_1_p[0]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_1_p[1]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_1_p[1]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_1_p[2]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_1_p[2]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_1_p[3]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_1_p[3]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_1_p[4]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_1_p[4]
set_instance_assignment -name IO_STANDARD LVDS               -to tx_data_out_1_p[5]
set_instance_assignment -name OUTPUT_DELAY_CHAIN 2           -to tx_data_out_1_p[5]

## TO DO THE SECTION BELOW FOR PINOUT
## COMMON
set_location_assignment PIN_G7   -to   mcs_sync                           ; ## C22  FMCA_HPC_LA18_P
set_location_assignment PIN_L5   -to   gpio_ad5355_rfen                   ; ## H31  FMCA_HPC_LA28_P
set_location_assignment PIN_L8   -to   gpio_ad5355_lock                   ; ## H37  FMCA_HPC_LA32_P
## ID 0
set_location_assignment PIN_G5   -to   gpio_status_0[0]                   ; ## H22  FMCA_HPC_LA19_P
set_location_assignment PIN_G6   -to   gpio_status_0[1]                   ; ## H23  FMCA_HPC_LA19_N
set_location_assignment PIN_K10  -to   gpio_status_0[2]                   ; ## G21  FMCA_HPC_LA20_P
set_location_assignment PIN_L10  -to   gpio_status_0[3]                   ; ## G22  FMCA_HPC_LA20_N
set_location_assignment PIN_C2   -to   gpio_status_0[4]                   ; ## H25  FMCA_HPC_LA21_P
set_location_assignment PIN_D3   -to   gpio_status_0[5]                   ; ## H26  FMCA_HPC_LA21_N
set_location_assignment PIN_E7   -to   gpio_status_0[6]                   ; ## G24  FMCA_HPC_LA22_P
set_location_assignment PIN_F7   -to   gpio_status_0[7]                   ; ## G25  FMCA_HPC_LA22_N
set_location_assignment PIN_C1   -to   gpio_ctl_0[0]                      ; ## D23  FMCA_HPC_LA23_P
set_location_assignment PIN_D1   -to   gpio_ctl_0[1]                      ; ## D24  FMCA_HPC_LA23_N
set_location_assignment PIN_E1   -to   gpio_ctl_0[2]                      ; ## H28  FMCA_HPC_LA24_P
set_location_assignment PIN_E2   -to   gpio_ctl_0[3]                      ; ## H29  FMCA_HPC_LA24_N
set_location_assignment PIN_E3   -to   gpio_en_agc_0                      ; ## G27  FMCA_HPC_LA25_P
set_location_assignment PIN_H7   -to   gpio_resetb_0                      ; ## C23  FMCA_HPC_LA18_N
set_location_assignment PIN_A5   -to   enable_0                           ; ## G18  FMCA_HPC_LA16_P
set_location_assignment PIN_B5   -to   txnrx_0                            ; ## G19  FMCA_HPC_LA16_N
set_location_assignment PIN_G1   -to   gpio_debug_1_0                     ; ## C26  FMCA_HPC_LA27_P
set_location_assignment PIN_H2   -to   gpio_debug_2_0                     ; ## C27  FMCA_HPC_LA27_N
set_location_assignment PIN_F2   -to   gpio_calsw_1_0                     ; ## D26  FMCA_HPC_LA26_P
set_location_assignment PIN_G2   -to   gpio_calsw_2_0                     ; ## D27  FMCA_HPC_LA26_N

## ID 1
set_location_assignment PIN_AG14 -to   gpio_status_1[0]                   ; ## H22  FMCB_HPC_LA19_P
set_location_assignment PIN_AF14 -to   gpio_status_1[1]                   ; ## H23  FMCB_HPC_LA19_N
set_location_assignment PIN_T4   -to   gpio_status_1[2]                   ; ## G21  FMCB_HPC_LA20_P
set_location_assignment PIN_U4   -to   gpio_status_1[3]                   ; ## G22  FMCB_HPC_LA20_N
set_location_assignment PIN_T2   -to   gpio_status_1[4]                   ; ## H25  FMCB_HPC_LA21_P
set_location_assignment PIN_T3   -to   gpio_status_1[5]                   ; ## H26  FMCB_HPC_LA21_N
set_location_assignment PIN_U1   -to   gpio_status_1[6]                   ; ## G24  FMCB_HPC_LA22_P
set_location_assignment PIN_U2   -to   gpio_status_1[7]                   ; ## G25  FMCB_HPC_LA22_N
set_location_assignment PIN_V1   -to   gpio_ctl_1[0]                      ; ## D23  FMCB_HPC_LA23_P
set_location_assignment PIN_V2   -to   gpio_ctl_1[1]                      ; ## D24  FMCB_HPC_LA23_N
set_location_assignment PIN_W3   -to   gpio_ctl_1[2]                      ; ## H28  FMCB_HPC_LA24_P
set_location_assignment PIN_W4   -to   gpio_ctl_1[3]                      ; ## H29  FMCB_HPC_LA24_N
set_location_assignment PIN_V3   -to   gpio_en_agc_1                      ; ## G27  FMCB_HPC_LA25_P
set_location_assignment PIN_AN22 -to   gpio_resetb_1                      ; ## G30  FMCB_HPC_LA29_P WARNING THIS GOES THROUGH THE MAX5, NEED TO UPDATE MAX5 CODE
set_location_assignment PIN_AK15 -to   enable_1                           ; ## G18  FMCB_HPC_LA16_P
set_location_assignment PIN_AJ15 -to   txnrx_1                            ; ## G19  FMCB_HPC_LA16_N
set_location_assignment PIN_V8   -to   gpio_debug_3_1                     ; ## C26  FMCB_HPC_LA27_P
set_location_assignment PIN_V9   -to   gpio_debug_4_1                     ; ## C27  FMCB_HPC_LA27_N
set_location_assignment PIN_U9   -to   gpio_calsw_3_1                     ; ## D26  FMCB_HPC_LA26_P
set_location_assignment PIN_U10  -to   gpio_calsw_4_1                     ; ## D27  FMCB_HPC_LA26_N

set_instance_assignment -name IO_STANDARD "1.8 V" -to mcs_sync
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ad5355_rfen
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ad5355_lock

set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_0[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_0[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_0[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_0[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_0[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_0[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_0[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_0[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl_0[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl_0[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl_0[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl_0[3]

set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_en_agc_0
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_resetb_0
set_instance_assignment -name IO_STANDARD "1.8 V" -to enable_0
set_instance_assignment -name IO_STANDARD "1.8 V" -to txnrx_0
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_debug_1_0
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_debug_2_0
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_calsw_1_0
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_calsw_2_0

set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_1[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_1[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_1[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_1[3]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_1[4]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_1[5]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_1[6]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_status_1[7]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl_1[0]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl_1[1]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl_1[2]
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_ctl_1[3]

set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_en_agc_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_resetb_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to enable_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to txnrx_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_debug_3_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_debug_4_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_calsw_3_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to gpio_calsw_4_1

set_location_assignment PIN_N9   -to    spi_ad9361_0                     ; ## G30  FMCA_HPC_LA29_P
set_location_assignment PIN_P10  -to    spi_ad9361_1                     ; ## G31  FMCA_HPC_LA29_N
set_location_assignment PIN_P9   -to    spi_ad5355                       ; ## H34  FMCA_HPC_LA30_P
set_location_assignment PIN_R10  -to    spi_clk                          ; ## H35  FMCA_HPC_LA30_N
set_location_assignment PIN_R8   -to    spi_mosi                         ; ## G33  FMCA_HPC_LA31_N
set_location_assignment PIN_P8   -to    spi_miso                         ; ## G34  FMCA_HPC_LA31_P

set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to spi_ad9361_0
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_ad9361_0
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to spi_ad9361_1
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_ad9361_1
set_instance_assignment -name WEAK_PULL_UP_RESISTOR ON -to spi_ad5355
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_ad5355
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_clk
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_mosi
set_instance_assignment -name IO_STANDARD "1.8 V" -to spi_miso

## AND ABOVE

#clock fixes
# set_parameter -name GLOBAL_CLOCK 0 -to i_system_bd|axi_ad9361|axi_ad9361|i_dev_if|i_clk
# set_instance_assignment -name FAST_INPUT_REGISTER ON -to i_system_bd|axi_ad9361|axi_ad9361|i_dev_if|g_rx_data[*].i_rx_data
# set_instance_assignment -name FAST_INPUT_REGISTER ON -to i_system_bd|axi_ad9361|axi_ad9361|i_dev_if|i_rx_frame
