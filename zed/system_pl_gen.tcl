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
