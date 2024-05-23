# create a system reset with
create_ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 -module_name dma_rstgen
set_property CONFIG.RESET_BOARD_INTERFACE Custom [get_ips dma_rstgen]
set_property CONFIG.C_EXT_RST_WIDTH 8 [get_ips dma_rstgen]
set_property CONFIG.C_AUX_RST_WIDTH 8 [get_ips dma_rstgen]
set_property CONFIG.C_EXT_RESET_HIGH 0 [get_ips dma_rstgen]
set_property CONFIG.C_AUX_RESET_HIGH 0 [get_ips dma_rstgen]

set_property generate_synth_checkpoint false [get_files dma_rstgen.xci]

generate_target all [get_ips dma_rstgen]
