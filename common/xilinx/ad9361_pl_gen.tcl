# create and setup IP's for ad9361 wrapper only.

vivado_ip_vlvn_version_check "xilinx.com:ip:axi_crossbar:2.1"

# crossbar will allow multiple devices slave devices connect to a single master.
create_ip -vlnv xilinx.com:ip:axi_crossbar:2.1 -module_name axi_crossbar_ad9361
set_property CONFIG.NUM_MI {4} [get_ips axi_crossbar_ad9361]
set_property CONFIG.PROTOCOL {AXI4LITE} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M00_A00_BASE_ADDR {0x79020000} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M01_A00_BASE_ADDR {0x7C400000} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M02_A00_BASE_ADDR {0x7C420000} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M03_A00_BASE_ADDR {0x41620000} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M00_A00_ADDR_WIDTH {16} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M01_A00_ADDR_WIDTH {12} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M02_A00_ADDR_WIDTH {12} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M03_A00_ADDR_WIDTH {12} [get_ips axi_crossbar_ad9361]

generate_target all [get_ips axi_crossbar_ad9361]

set_property generate_synth_checkpoint false [get_files axi_crossbar_ad9361.xci]

vivado_ip_vlvn_version_check "xilinx.com:ip:proc_sys_reset:5.0"

# create a system reset with
create_ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 -module_name pl_reset_ad9361
set_property CONFIG.RESET_BOARD_INTERFACE Custom [get_ips pl_reset_ad9361]
set_property CONFIG.C_EXT_RST_WIDTH 1 [get_ips pl_reset_ad9361]
set_property CONFIG.C_AUX_RST_WIDTH 1 [get_ips pl_reset_ad9361]

generate_target all [get_ips pl_reset_ad9361]

set_property generate_synth_checkpoint false [get_files pl_reset_ad9361.xci]

vivado_ip_vlvn_version_check "xilinx.com:ip:axi_iic:2.1"

create_ip -vlnv xilinx.com:ip:axi_iic:2.1 -module_name axi_iic_fmc

set_property generate_synth_checkpoint false [get_files axi_iic_fmc.xci]
