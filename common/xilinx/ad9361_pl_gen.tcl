# create and setup IP's for ad9361 wrapper only.

#idea, move iic to the gen_pl... then add a crossbar for it there.

vivado_ip_vlvn_version_check "xilinx.com:ip:axi_crossbar:2.1"

# crossbar will allow multiple devices slave devices connect to a single master.
create_ip -vlnv xilinx.com:ip:axi_crossbar:2.1 -module_name axi_crossbar_ad9361
set_property CONFIG.NUM_MI {3} [get_ips axi_crossbar_ad9361]
set_property CONFIG.PROTOCOL {AXI4LITE} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M00_A00_BASE_ADDR [format 0x%x [expr "0x09020000 + $address_offset"]] [get_ips axi_crossbar_ad9361]
set_property CONFIG.M01_A00_BASE_ADDR [format 0x%x [expr "0x0C420000 + $address_offset"]] [get_ips axi_crossbar_ad9361]
set_property CONFIG.M02_A00_BASE_ADDR [format 0x%x [expr "0x0C400000 + $address_offset"]] [get_ips axi_crossbar_ad9361]
set_property CONFIG.M00_A00_ADDR_WIDTH {16} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M01_A00_ADDR_WIDTH {12} [get_ips axi_crossbar_ad9361]
set_property CONFIG.M02_A00_ADDR_WIDTH {12} [get_ips axi_crossbar_ad9361]

generate_target all [get_ips axi_crossbar_ad9361]

set_property generate_synth_checkpoint false [get_files axi_crossbar_ad9361.xci]

# vivado_ip_vlvn_version_check "xilinx.com:ip:proc_sys_reset:5.0"
#
# # create a system reset with
# create_ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 -module_name pl_reset_ad9361
# set_property CONFIG.RESET_BOARD_INTERFACE Custom [get_ips pl_reset_ad9361]
# set_property CONFIG.C_EXT_RESET_HIGH {0} [get_ips pl_reset_ad9361]
# set_property CONFIG.C_EXT_RST_WIDTH {1} [get_ips pl_reset_ad9361]
# set_property CONFIG.C_AUX_RST_WIDTH {1} [get_ips pl_reset_ad9361]
#
# generate_target all [get_ips pl_reset_ad9361]
#
# set_property generate_synth_checkpoint false [get_files pl_reset_ad9361.xci]
