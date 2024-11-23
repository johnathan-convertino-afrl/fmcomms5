# FMCOMM5 FPGA Project
### Contains core files and scripts to generate a fmcomms5 platform using fusesoc.

![image](docs/manual/img/AFRL.png)

---

   author: Jay Convertino

   date: 2024.03.20

   details: Generate fmcomms5 FPGA image for various targets. See fusesoc section for targets available.

   license: MIT

---

### Version
#### Current
  - none

#### Previous
  - none

### DOCUMENTATION
  For detailed usage information, please navigate to one of the following sources. They are the same, just in a different format.

  - [fmcomms5.pdf](docs/manual/fmcomms5.pdf)
  - [github page](https://johnathan-convertino-afrl.github.io/fmcomms5/)

### DEPENDENCIES
#### Build
  - AD:common:ad_iobuf:1.0.0
  - AFRL:utility:xilinx_zc706_board_base:1.0.0
  - AFRL:utility:xilinx_zc706_boot_gen:1.0.0
  - AFRL:utility:xilinx_zc702_board_base:1.0.0
  - AFRL:utility:xilinx_zc702_boot_gen:1.0.0
  - AFRL:utility:xilinx_zcu102_board_base:1.0.0
  - AFRL:utility:xilinx_zcu102_boot_gen:1.0.0
  - AFRL:utility:intel_a10soc_board_base:1.0.0
  - AFRL:utility:intel_a10soc_boot_gen:1.0.0
  - AD:RF_Transceiver:axi_ad9361:1.0.0
  - AD:utility:tdd_sync:1.0.0
  - AD:memory_controller:axi_dmac:1.0.0
  - AD:data_flow:util_cpack_axis:1.0.0
  - AD:data_flow:util_upack:2.0.0
  - AD:buffer:util_rfifo:1.0.0
  - AD:buffer:util_wfifo:1.0.0
  - AD:common:util_clkdiv:1.0.0
  - AD:common:ad_rst:1.0.0
  - AFRL:utility:tcl_helper_check:1.0.0
  - zipcpu:axi_lite:crossbar:1.0.0

#### Simulation
  - none, not implimented.

### PARAMETERS
  * FPGA_TECHNOLOGY : See ad_hdl_fusesoc readme.md for details
  * FPGA_FAMILY : See ad_hdl_fusesoc readme.md for details
  * SPEED_GRADE : See ad_hdl_fusesoc readme.md for details
  * DEV_PACKAGE : See ad_hdl_fusesoc readme.md for details
  * ADC_INIT_DELAY : Tune IDELAY macros
  * DAC_INIT_DELAY : Tune IDELAY macros
  * DELAY_REFCLK_FREQUENCY : Reference clock in MHz for delay input
  * DMA_AXI_PROTOCOL_TO_PS : Set DMA protocol, 1 = AXI3, 0 = AXI4
  * AXI_DMAC_ADC_ADDR : Set address of ADC DMA, default: 32'h7C400000
  * AXI_DMAC_DAC_ADDR : Set address of DAC DMA, default: 32'h7C420000
  * AXI_AD9361_0_ADDR : Set address of AD9361 0, default: 32'h79020000
  * AXI_AD9361_1_ADDR : Set address of AD9361 1, default: 32'h79040000

### FUSESOC

* fusesoc_info.core created.
* Simulation not available

#### Targets

* RUN WITH: (fusesoc run --target=zed_bootgen VENDER:CORE:NAME:VERSION)
* -- target can be one of the below.
  - a10soc           : a10soc target.
  - a10soc_bootgen   : arria10 build with BOOTFS file generation.
  - zc702            : zc702 target.
  - zc702_bootgen    : zc702 build with boot.bin output in BOOTFS folder.
  - zc706            : zc706 target.
  - zc706_bootgen    : zc706 build with boot.bin output in BOOTFS folder.
  - zcu102           : zcu102 target.
  - zcu102_bootgen   : zcu102 build with boot.bin output in BOOTFS folder.

