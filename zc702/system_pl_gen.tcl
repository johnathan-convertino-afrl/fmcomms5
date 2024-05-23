ip_vlvn_version_check "xilinx.com:ip:axi_crossbar:2.1"

# crossbar will allow multiple devices slave devices connect to a single master.
create_ip -vlnv xilinx.com:ip:axi_crossbar:2.1 -module_name axi_crossbar_pl
set_property CONFIG.NUM_MI {2} [get_ips axi_crossbar_pl]
set_property CONFIG.PROTOCOL {AXI4LITE} [get_ips axi_crossbar_pl]
set_property CONFIG.M00_A00_BASE_ADDR {0x60000000} [get_ips axi_crossbar_pl]
set_property CONFIG.M01_A00_BASE_ADDR {0x41620000} [get_ips axi_crossbar_pl]
set_property CONFIG.M00_A00_ADDR_WIDTH {29} [get_ips axi_crossbar_pl]
set_property CONFIG.M01_A00_ADDR_WIDTH {12} [get_ips axi_crossbar_pl]

set_property generate_synth_checkpoint false [get_files axi_crossbar_pl.xci]

generate_target all [get_ips axi_crossbar_pl]

ip_vlvn_version_check "xilinx.com:ip:axi_iic:2.1"

create_ip -vlnv xilinx.com:ip:axi_iic:2.1 -module_name axi_iic_fmc

set_property generate_synth_checkpoint false [get_files axi_iic_fmc.xci]

generate_target all [get_ips axi_iic_fmc]

# create a system reset with
create_ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 -module_name dma_rstgen
set_property CONFIG.RESET_BOARD_INTERFACE Custom [get_ips dma_rstgen]
set_property CONFIG.C_EXT_RST_WIDTH 8 [get_ips dma_rstgen]
set_property CONFIG.C_AUX_RST_WIDTH 8 [get_ips dma_rstgen]
set_property CONFIG.C_EXT_RESET_HIGH 0 [get_ips dma_rstgen]
set_property CONFIG.C_AUX_RESET_HIGH 0 [get_ips dma_rstgen]

set_property generate_synth_checkpoint false [get_files dma_rstgen.xci]

generate_target all [get_ips dma_rstgen]
