//******************************************************************************
//  file:     system_pl_wrapper.v
//
//  author:   JAY CONVERTINO
//
//  date:     2023/11/02
//
//  about:    Brief
//  System wrapper for pl only for zcu102 board.
//
//  license: License MIT
//  Copyright 2023 Jay Convertino
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
//  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
//  IN THE SOFTWARE.
//******************************************************************************

/*
 * Module: system_pl_wrapper
 *
 * System wrapper for pl only for zcu102 board.
 *
 * Parameters:
 *
 * FPGA_TECHNOLOGY        - Type of FPGA, such as Ultrascale, Arria 10. 1 is for 7 series.
 * FPGA_FAMILY            - Sub type of fpga, such as GX, SX, etc. 4 is for zynq.
 * SPEED_GRADE            - Number that corresponds to the ships recommeneded speed. 10 is for -1.
 * DEV_PACKAGE            - Specify a number that is equal to the manufactures package. 14 is for cl.
 * DELAY_REFCLK_FREQUENCY - Reference clock frequency used for ad_data_in instances
 * ADC_INIT_DELAY         - Initial Delay for the ADC
 * DAC_INIT_DELAY         - Initial Delay for the DAC
 *
 * Ports:
 *
 *  axi_aclk                      - AXI Lite control bus
 *  axi_aresetn                   - AXI Lite control bus
 *  s_axi_awvalid                 - AXI Lite control bus
 *  s_axi_awaddr                  - AXI Lite control bus
 *  s_axi_awready                 - AXI Lite control bus
 *  s_axi_awprot                  - AXI Lite control bus
 *  s_axi_wvalid                  - AXI Lite control bus
 *  s_axi_wdata                   - AXI Lite control bus
 *  s_axi_wstrb                   - AXI Lite control bus
 *  s_axi_wready                  - AXI Lite control bus
 *  s_axi_bvalid                  - AXI Lite control bus
 *  s_axi_bresp                   - AXI Lite control bus
 *  s_axi_bready                  - AXI Lite control bus
 *  s_axi_arvalid                 - AXI Lite control bus
 *  s_axi_araddr                  - AXI Lite control bus
 *  s_axi_arready                 - AXI Lite control bus
 *  s_axi_arprot                  - AXI Lite control bus
 *  s_axi_rvalid                  - AXI Lite control bus
 *  s_axi_rready                  - AXI Lite control bus
 *  s_axi_rresp                   - AXI Lite control bus
 *  s_axi_rdata                   - AXI Lite control bus
 *  adc_dma_irq                   - fmcomms5 ADC irq
 *  dac_dma_irq                   - fmcomms5 DAC irq
 *  delay_clk                     - fmcomms5 delay clock
 *  rx_clk_in_0_p                 - fmcomms5 0 rx clk
 *  rx_clk_in_0_n                 - fmcomms5 0 rx clk
 *  rx_frame_in_0_p               - fmcomms5 0 rx frame
 *  rx_frame_in_0_n               - fmcomms5 0 rx frame
 *  rx_data_in_0_p                - fmcomms5 0 rx data
 *  rx_data_in_0_n                - fmcomms5 0 rx data
 *  tx_clk_out_0_p                - fmcomms5 0 tx clk
 *  tx_clk_out_0_n                - fmcomms5 0 tx clk
 *  tx_frame_out_0_p              - fmcomms5 0 tx frame
 *  tx_frame_out_0_n              - fmcomms5 0 tx frame
 *  tx_data_out_0_p               - fmcomms5 0 tx data
 *  tx_data_out_0_n               - fmcomms5 0 tx data
 *  txnrx_0                       - fmcomms5 0 txnrx
 *  enable_0                      - fmcomms5 0 enable
 *  up_enable_0                   - fmcomms5 0 enable input
 *  up_txnrx_0                    - fmcomms5 0 txnrx select input
 *  tdd_sync_0_t                  - fmcomms5 0 TDD sync i/o
 *  tdd_sync_0_i                  - fmcomms5 0 TDD sync i/o
 *  tdd_sync_0_o                  - fmcomms5 0 TDD sync i/o
 *  rx_clk_in_1_p                 - fmcomms5 1 rx clk
 *  rx_clk_in_1_n                 - fmcomms5 1 rx clk
 *  rx_frame_in_1_p               - fmcomms5 1 rx frame
 *  rx_frame_in_1_n               - fmcomms5 1 rx frame
 *  rx_data_in_1_p                - fmcomms5 1 rx data
 *  rx_data_in_1_n                - fmcomms5 1 rx data
 *  tx_clk_out_1_p                - fmcomms5 1 tx clk
 *  tx_clk_out_1_n                - fmcomms5 1 tx clk
 *  tx_frame_out_1_p              - fmcomms5 1 tx frame
 *  tx_frame_out_1_n              - fmcomms5 1 tx frame
 *  tx_data_out_1_p               - fmcomms5 1 tx data
 *  tx_data_out_1_n               - fmcomms5 1 tx data
 *  txnrx_1                       - fmcomms5 1 txnrx
 *  enable_1                      - fmcomms5 1 enable
 *  up_enable_1                   - fmcomms5 1 enable input
 *  up_txnrx_1                    - fmcomms5 1 txnrx select input
 *  tdd_sync_1_t                  - fmcomms5 1 TDD sync i/o
 *  tdd_sync_1_i                  - fmcomms5 1 TDD sync i/o
 *  tdd_sync_1_o                  - fmcomms5 1 TDD sync i/o
 *  m_axi_aclk                    - DMA Clock
 *  adc_m_dest_axi_awaddr         - fmcomms5 ADC DMA
 *  adc_m_dest_axi_awlen          - fmcomms5 ADC DMA
 *  adc_m_dest_axi_awsize         - fmcomms5 ADC DMA
 *  adc_m_dest_axi_awburst        - fmcomms5 ADC DMA
 *  adc_m_dest_axi_awprot         - fmcomms5 ADC DMA
 *  adc_m_dest_axi_awcache        - fmcomms5 ADC DMA
 *  adc_m_dest_axi_awvalid        - fmcomms5 ADC DMA
 *  adc_m_dest_axi_awready        - fmcomms5 ADC DMA
 *  adc_m_dest_axi_wdata          - fmcomms5 ADC DMA
 *  adc_m_dest_axi_wstrb          - fmcomms5 ADC DMA
 *  adc_m_dest_axi_wready         - fmcomms5 ADC DMA
 *  adc_m_dest_axi_wvalid         - fmcomms5 ADC DMA
 *  adc_m_dest_axi_wlast          - fmcomms5 ADC DMA
 *  adc_m_dest_axi_bvalid         - fmcomms5 ADC DMA
 *  adc_m_dest_axi_bresp          - fmcomms5 ADC DMA
 *  adc_m_dest_axi_bready         - fmcomms5 ADC DMA
 *  dac_m_src_axi_arready         - fmcomms5 DAC DMA
 *  dac_m_src_axi_arvalid         - fmcomms5 DAC DMA
 *  dac_m_src_axi_araddr          - fmcomms5 DAC DMA
 *  dac_m_src_axi_arlen           - fmcomms5 DAC DMA
 *  dac_m_src_axi_arsize          - fmcomms5 DAC DMA
 *  dac_m_src_axi_arburst         - fmcomms5 DAC DMA
 *  dac_m_src_axi_arprot          - fmcomms5 DAC DMA
 *  dac_m_src_axi_arcache         - fmcomms5 DAC DMA
 *  dac_m_src_axi_rdata           - fmcomms5 DAC DMA
 *  dac_m_src_axi_rready          - fmcomms5 DAC DMA
 *  dac_m_src_axi_rvalid          - fmcomms5 DAC DMA
 *  dac_m_src_axi_rresp           - fmcomms5 DAC DMA
 *  dac_m_src_axi_rlast           - fmcomms5 DAC DMA
 */
module system_pl_wrapper #(
    parameter FPGA_TECHNOLOGY = 0,
    parameter FPGA_FAMILY = 0,
    parameter SPEED_GRADE = 0,
    parameter DEV_PACKAGE = 0,
    parameter ADC_INIT_DELAY = 23,
    parameter DAC_INIT_DELAY = 0,
    parameter DELAY_REFCLK_FREQUENCY = 200
  ) (
    input           axi_aclk,
    input           axi_aresetn,
    input           s_axi_awvalid,
    input  [31:0]   s_axi_awaddr,
    output          s_axi_awready,
    input   [2:0]   s_axi_awprot,
    input           s_axi_wvalid,
    input  [31:0]   s_axi_wdata,
    input  [ 3:0]   s_axi_wstrb,
    output          s_axi_wready,
    output          s_axi_bvalid,
    output [ 1:0]   s_axi_bresp,
    input           s_axi_bready,
    input           s_axi_arvalid,
    input  [31:0]   s_axi_araddr,
    output          s_axi_arready,
    input   [2:0]   s_axi_arprot,
    output          s_axi_rvalid,
    input           s_axi_rready,
    output [ 1:0]   s_axi_rresp,
    output [31:0]   s_axi_rdata,
    output          adc_dma_irq,
    output          dac_dma_irq,
    input           delay_clk,
    input           rx_clk_in_0_p,
    input           rx_clk_in_0_n,
    input           rx_frame_in_0_p,
    input           rx_frame_in_0_n,
    input   [5:0]   rx_data_in_0_p,
    input   [5:0]   rx_data_in_0_n,
    output          tx_clk_out_0_p,
    output          tx_clk_out_0_n,
    output          tx_frame_out_0_p,
    output          tx_frame_out_0_n,
    output  [5:0]   tx_data_out_0_p,
    output  [5:0]   tx_data_out_0_n,
    output          enable_0,
    output          txnrx_0,
    input           up_enable_0,
    input           up_txnrx_0,
    output          tdd_sync_0_t,
    input           tdd_sync_0_i,
    output          tdd_sync_0_o,
    input           rx_clk_in_1_p,
    input           rx_clk_in_1_n,
    input           rx_frame_in_1_p,
    input           rx_frame_in_1_n,
    input   [5:0]   rx_data_in_1_p,
    input   [5:0]   rx_data_in_1_n,
    output          tx_clk_out_1_p,
    output          tx_clk_out_1_n,
    output          tx_frame_out_1_p,
    output          tx_frame_out_1_n,
    output  [5:0]   tx_data_out_1_p,
    output  [5:0]   tx_data_out_1_n,
    output          enable_1,
    output          txnrx_1,
    input           up_enable_1,
    input           up_txnrx_1,
    output          tdd_sync_1_t,
    input           tdd_sync_1_i,
    output          tdd_sync_1_o,
    input           m_axi_aclk,
    output [31:0]   adc_m_dest_axi_awaddr,
    output [ 3:0]   adc_m_dest_axi_awlen,
    output [ 2:0]   adc_m_dest_axi_awsize,
    output [ 1:0]   adc_m_dest_axi_awburst,
    output [ 2:0]   adc_m_dest_axi_awprot,
    output [ 3:0]   adc_m_dest_axi_awcache,
    output          adc_m_dest_axi_awvalid,
    input           adc_m_dest_axi_awready,
    output [63:0]   adc_m_dest_axi_wdata,
    output [ 7:0]   adc_m_dest_axi_wstrb,
    input           adc_m_dest_axi_wready,
    output          adc_m_dest_axi_wvalid,
    output          adc_m_dest_axi_wlast,
    input           adc_m_dest_axi_bvalid,
    input  [ 1:0]   adc_m_dest_axi_bresp,
    output          adc_m_dest_axi_bready,
    input           dac_m_src_axi_arready,
    output          dac_m_src_axi_arvalid,
    output [31:0]   dac_m_src_axi_araddr,
    output [ 3:0]   dac_m_src_axi_arlen,
    output [ 2:0]   dac_m_src_axi_arsize,
    output [ 1:0]   dac_m_src_axi_arburst,
    output [ 2:0]   dac_m_src_axi_arprot,
    output [ 3:0]   dac_m_src_axi_arcache,
    input  [63:0]   dac_m_src_axi_rdata,
    output          dac_m_src_axi_rready,
    input           dac_m_src_axi_rvalid,
    input  [ 1:0]   dac_m_src_axi_rresp,
    input           dac_m_src_axi_rlast
  );

  wire        m_axi_aresetn;

  // Group: Instantianted Modules

  // Module: inst_dma_rstgen
  //
  // Generate a new DMA reset based on delay clock.
  dma_rstgen inst_dma_rstgen (
    .slowest_sync_clk(m_axi_aclk),
    .ext_reset_in(axi_aresetn),
    .aux_reset_in(1'b1),
    .mb_debug_sys_rst(1'b0),
    .dcm_locked(1'b1),
    .mb_reset(),
    .bus_struct_reset(),
    .peripheral_reset(),
    .interconnect_aresetn(),
    .peripheral_aresetn(m_axi_aresetn)
  );

  ad9361x2_pl_wrapper #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .FPGA_FAMILY(FPGA_FAMILY),
    .SPEED_GRADE(SPEED_GRADE),
    .DEV_PACKAGE(DEV_PACKAGE),
    .ADC_INIT_DELAY(ADC_INIT_DELAY),
    .DAC_INIT_DELAY(DAC_INIT_DELAY),
    .DELAY_REFCLK_FREQUENCY(DELAY_REFCLK_FREQUENCY),
    .DMA_AXI_PROTOCOL_TO_PS(0),
    .AXI_DMAC_ADC_ADDR(32'h9C400000),
    .AXI_DMAC_DAC_ADDR(32'h9C420000),
    .AXI_AD9361_0_ADDR(32'h99020000),
    .AXI_AD9361_1_ADDR(32'h99040000)
  ) inst_ad9361x2_pl_wrapper (
    .axi_aclk(axi_aclk),
    .axi_aresetn(axi_aresetn),
    .s_axi_awvalid(s_axi_awvalid),
    .s_axi_awaddr(s_axi_awaddr),
    .s_axi_awready(s_axi_awready),
    .s_axi_awprot(s_axi_awprot),
    .s_axi_wvalid(s_axi_wvalid),
    .s_axi_wdata(s_axi_wdata),
    .s_axi_wstrb(s_axi_wstrb),
    .s_axi_wready(s_axi_wready),
    .s_axi_bvalid(s_axi_bvalid),
    .s_axi_bresp(s_axi_bresp),
    .s_axi_bready(s_axi_bready),
    .s_axi_arvalid(s_axi_arvalid),
    .s_axi_araddr(s_axi_araddr),
    .s_axi_arready(s_axi_arready),
    .s_axi_arprot(s_axi_arprot),
    .s_axi_rvalid(s_axi_rvalid),
    .s_axi_rready(s_axi_rready),
    .s_axi_rresp(s_axi_rresp),
    .s_axi_rdata(s_axi_rdata),
    .adc_dma_irq(adc_dma_irq),
    .dac_dma_irq(dac_dma_irq),
    .delay_clk(delay_clk),
    .rx_clk_in_0_p(rx_clk_in_0_p),
    .rx_clk_in_0_n(rx_clk_in_0_n),
    .rx_frame_in_0_p(rx_frame_in_0_p),
    .rx_frame_in_0_n(rx_frame_in_0_n),
    .rx_data_in_0_p(rx_data_in_0_p),
    .rx_data_in_0_n(rx_data_in_0_n),
    .tx_clk_out_0_p(tx_clk_out_0_p),
    .tx_clk_out_0_n(tx_clk_out_0_n),
    .tx_frame_out_0_p(tx_frame_out_0_p),
    .tx_frame_out_0_n(tx_frame_out_0_n),
    .tx_data_out_0_p(tx_data_out_0_p),
    .tx_data_out_0_n(tx_data_out_0_n),
    .enable_0(enable_0),
    .txnrx_0(txnrx_0),
    .up_enable_0(up_enable_0),
    .up_txnrx_0(up_txnrx_0),
    .tdd_sync_0_t(tdd_sync_0_t),
    .tdd_sync_0_i(tdd_sync_0_i),
    .tdd_sync_0_o(tdd_sync_0_o),
    .rx_clk_in_1_p(rx_clk_in_1_p),
    .rx_clk_in_1_n(rx_clk_in_1_n),
    .rx_frame_in_1_p(rx_frame_in_1_p),
    .rx_frame_in_1_n(rx_frame_in_1_n),
    .rx_data_in_1_p(rx_data_in_1_p),
    .rx_data_in_1_n(rx_data_in_1_n),
    .tx_clk_out_1_p(tx_clk_out_1_p),
    .tx_clk_out_1_n(tx_clk_out_1_n),
    .tx_frame_out_1_p(tx_frame_out_1_p),
    .tx_frame_out_1_n(tx_frame_out_1_n),
    .tx_data_out_1_p(tx_data_out_1_p),
    .tx_data_out_1_n(tx_data_out_1_n),
    .enable_1(enable_1),
    .txnrx_1(txnrx_1),
    .up_enable_1(up_enable_1),
    .up_txnrx_1(up_txnrx_1),
    .tdd_sync_1_t(tdd_sync_1_t),
    .tdd_sync_1_i(tdd_sync_1_i),
    .tdd_sync_1_o(tdd_sync_1_o),
    .m_axi_aclk(m_axi_aclk),
    .m_axi_aresetn(m_axi_aresetn),
    .adc_m_dest_axi_awaddr(adc_m_dest_axi_awaddr),
    .adc_m_dest_axi_awlen(adc_m_dest_axi_awlen),
    .adc_m_dest_axi_awsize(adc_m_dest_axi_awsize),
    .adc_m_dest_axi_awburst(adc_m_dest_axi_awburst),
    .adc_m_dest_axi_awprot(adc_m_dest_axi_awprot),
    .adc_m_dest_axi_awcache(adc_m_dest_axi_awcache),
    .adc_m_dest_axi_awvalid(adc_m_dest_axi_awvalid),
    .adc_m_dest_axi_awready(adc_m_dest_axi_awready),
    .adc_m_dest_axi_wdata(adc_m_dest_axi_wdata),
    .adc_m_dest_axi_wstrb(adc_m_dest_axi_wstrb),
    .adc_m_dest_axi_wready(adc_m_dest_axi_wready),
    .adc_m_dest_axi_wvalid(adc_m_dest_axi_wvalid),
    .adc_m_dest_axi_wlast(adc_m_dest_axi_wlast),
    .adc_m_dest_axi_bvalid(adc_m_dest_axi_bvalid),
    .adc_m_dest_axi_bresp(adc_m_dest_axi_bresp),
    .adc_m_dest_axi_bready(adc_m_dest_axi_bready),
    .dac_m_src_axi_arready(dac_m_src_axi_arready),
    .dac_m_src_axi_arvalid(dac_m_src_axi_arvalid),
    .dac_m_src_axi_araddr(dac_m_src_axi_araddr),
    .dac_m_src_axi_arlen(dac_m_src_axi_arlen),
    .dac_m_src_axi_arsize(dac_m_src_axi_arsize),
    .dac_m_src_axi_arburst(dac_m_src_axi_arburst),
    .dac_m_src_axi_arprot(dac_m_src_axi_arprot),
    .dac_m_src_axi_arcache(dac_m_src_axi_arcache),
    .dac_m_src_axi_rdata(dac_m_src_axi_rdata),
    .dac_m_src_axi_rready(dac_m_src_axi_rready),
    .dac_m_src_axi_rvalid(dac_m_src_axi_rvalid),
    .dac_m_src_axi_rresp(dac_m_src_axi_rresp),
    .dac_m_src_axi_rlast(dac_m_src_axi_rlast)
  );

endmodule
