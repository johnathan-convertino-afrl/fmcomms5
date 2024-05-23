//******************************************************************************
/// @FILE    system_wrapper.v
/// @AUTHOR  JAY CONVERTINO
/// @DATE    2024.03.27
/// @BRIEF   System wrapper for pl and ps.
///
/// @LICENSE MIT
///  Copyright 2024 Jay Convertino
///
///  Permission is hereby granted, free of charge, to any person obtaining a copy
///  of this software and associated documentation files (the "Software"), to
///  deal in the Software without restriction, including without limitation the
///  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
///  sell copies of the Software, and to permit persons to whom the Software is
///  furnished to do so, subject to the following conditions:
///
///  The above copyright notice and this permission notice shall be included in
///  all copies or substantial portions of the Software.
///
///  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
///  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
///  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
///  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
///  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
///  FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
///  IN THE SOFTWARE.
//******************************************************************************

module system_wrapper #(
    parameter FPGA_TECHNOLOGY = 3,
    parameter FPGA_FAMILY = 4,
    parameter SPEED_GRADE = 20,
    parameter DEV_PACKAGE = 3,
    parameter DELAY_REFCLK_FREQUENCY = 500,
    parameter ADC_INIT_DELAY = 11,
    parameter DAC_INIT_DELAY = 0
  ) (
    input       [12:0]      gpio_bd_i,
    output      [ 7:0]      gpio_bd_o,

    input                   rx_clk_in_0_p,
    input                   rx_clk_in_0_n,
    input                   rx_frame_in_0_p,
    input                   rx_frame_in_0_n,
    input       [ 5:0]      rx_data_in_0_p,
    input       [ 5:0]      rx_data_in_0_n,
    output                  tx_clk_out_0_p,
    output                  tx_clk_out_0_n,
    output                  tx_frame_out_0_p,
    output                  tx_frame_out_0_n,
    output      [ 5:0]      tx_data_out_0_p,
    output      [ 5:0]      tx_data_out_0_n,
    input       [ 7:0]      gpio_status_0,
    output      [ 3:0]      gpio_ctl_0,
    output                  gpio_en_agc_0,
    output                  mcs_sync,
    output                  gpio_resetb_0,
    output                  enable_0,
    output                  txnrx_0,
    output                  gpio_debug_1_0,
    output                  gpio_debug_2_0,
    output                  gpio_calsw_1_0,
    output                  gpio_calsw_2_0,
    output                  gpio_ad5355_rfen,
    input                   gpio_ad5355_lock,

    input                   rx_clk_in_1_p,
    input                   rx_clk_in_1_n,
    input                   rx_frame_in_1_p,
    input                   rx_frame_in_1_n,
    input       [ 5:0]      rx_data_in_1_p,
    input       [ 5:0]      rx_data_in_1_n,
    output                  tx_clk_out_1_p,
    output                  tx_clk_out_1_n,
    output                  tx_frame_out_1_p,
    output                  tx_frame_out_1_n,
    output      [ 5:0]      tx_data_out_1_p,
    output      [ 5:0]      tx_data_out_1_n,
    input       [ 7:0]      gpio_status_1,
    output      [ 3:0]      gpio_ctl_1,
    output                  gpio_en_agc_1,
    output                  gpio_resetb_1,
    output                  enable_1,
    output                  txnrx_1,
    output                  gpio_debug_3_1,
    output                  gpio_debug_4_1,
    output                  gpio_calsw_3_1,
    output                  gpio_calsw_4_1,

    output                  spi_ad9361_0,
    output                  spi_ad9361_1,
    output                  spi_ad5355,
    output                  spi_clk,
    output                  spi_mosi,
    input                   spi_miso,

    input                   ref_clk_p,
    input                   ref_clk_n
  );

  // internal signals
  wire        m_axi_aclk;
  wire        m_axi_aresetn;

  //PS TO PL / PL TO PS signals

  wire        s_delay_clk;
  wire        s_axi_clk;
  wire        s_axi_aresetn;
  wire        s_adc_dma_irq;
  wire        s_dac_dma_irq;

  //axi gp0
  wire        w_axi_awvalid;
  wire [39:0] w_axi_awaddr;
  wire        w_axi_awready;
  wire [ 2:0] w_axi_awprot;
  wire        w_axi_wvalid;
  wire [31:0] w_axi_wdata;
  wire [ 3:0] w_axi_wstrb;
  wire        w_axi_wready;
  wire        w_axi_bvalid;
  wire [ 1:0] w_axi_bresp;
  wire        w_axi_bready;
  wire        w_axi_arvalid;
  wire [39:0] w_axi_araddr;
  wire        w_axi_arready;
  wire [ 2:0] w_axi_arprot;
  wire        w_axi_rvalid;
  wire        w_axi_rready;
  wire [ 1:0] w_axi_rresp;
  wire [31:0] w_axi_rdata;

  //axi interface for the adc to the hp0 interface
  wire [31:0]   adc_hp0_axi_awaddr;
  wire [ 3:0]   adc_hp0_axi_awlen;
  wire [ 2:0]   adc_hp0_axi_awsize;
  wire [ 1:0]   adc_hp0_axi_awburst;
  wire [ 2:0]   adc_hp0_axi_awprot;
  wire [ 3:0]   adc_hp0_axi_awcache;
  wire          adc_hp0_axi_awvalid;
  wire          adc_hp0_axi_awready;
  wire [63:0]   adc_hp0_axi_wdata;
  wire [ 7:0]   adc_hp0_axi_wstrb;
  wire          adc_hp0_axi_wready;
  wire          adc_hp0_axi_wvalid;
  wire          adc_hp0_axi_wlast;
  wire          adc_hp0_axi_bvalid;
  wire [ 1:0]   adc_hp0_axi_bresp;
  wire          adc_hp0_axi_bready;

  //axi interface for dac to the hp1 interface
  wire          dac_hp1_axi_arready;
  wire          dac_hp1_axi_arvalid;
  wire [31:0]   dac_hp1_axi_araddr;
  wire [ 3:0]   dac_hp1_axi_arlen;
  wire [ 2:0]   dac_hp1_axi_arsize;
  wire [ 1:0]   dac_hp1_axi_arburst;
  wire [ 2:0]   dac_hp1_axi_arprot;
  wire [ 3:0]   dac_hp1_axi_arcache;
  wire [63:0]   dac_hp1_axi_rdata;
  wire          dac_hp1_axi_rready;
  wire          dac_hp1_axi_rvalid;
  wire [ 1:0]   dac_hp1_axi_rresp;
  wire          dac_hp1_axi_rlast;

  // instantiations... copy pasta

  // defaults

  // internal registers

  reg             r_mcs_sync;
  reg     [  2:0] mcs_sync_m = 'd0;

  // internal signals

  wire            ref_clk_s;
  wire            ref_clk_s_ds;
  wire            ref_clk;
  wire    [ 94:0] gpio_i;
  wire    [ 94:0] gpio_o;
  wire            gpio_sync;

  // multi-chip synchronization

  always @(posedge ref_clk or negedge s_axi_aresetn) begin
    if (s_axi_aresetn == 1'b0) begin
      mcs_sync_m <= 3'd0;
      r_mcs_sync <= 1'd0;
    end else begin
      mcs_sync_m <= {mcs_sync_m[1:0], gpio_sync};
      r_mcs_sync <= mcs_sync_m[2] & ~mcs_sync_m[1];
    end
  end

  // instantiations

  IBUFDS i_ref_clk_ibuf_ds (
    .I (ref_clk_p),
    .IB (ref_clk_n),
    .O (ref_clk_s_ds));

  BUFG i_ref_clk_ibuf (
    .I (ref_clk_s_ds),
    .O (ref_clk_s));

  BUFR #(
    .BUFR_DIVIDE ("BYPASS")
  ) i_ref_clk_rbuf (
    .CLR (1'b0),
    .CE (1'b1),
    .I (ref_clk_s),
    .O (ref_clk));

  assign mcs_sync = r_mcs_sync;

  assign gpio_resetb_1 = gpio_o[65];
  assign gpio_ad5355_rfen = gpio_o[63];
  assign gpio_calsw_4_1 = gpio_o[62];
  assign gpio_calsw_3_1 = gpio_o[61];
  assign gpio_calsw_2_0 = gpio_o[60];
  assign gpio_calsw_1_0 = gpio_o[59];
  assign gpio_txnrx_1 = gpio_o[58];
  assign gpio_enable_1 = gpio_o[57];
  assign gpio_en_agc_1 = gpio_o[56];
  assign gpio_txnrx_0 = gpio_o[55];
  assign gpio_enable_0 = gpio_o[54];
  assign gpio_en_agc_0 = gpio_o[53];
  assign gpio_resetb_0 = gpio_o[52];
  assign gpio_sync = gpio_o[51];
  assign gpio_debug_4_0 = gpio_o[49];
  assign gpio_debug_3_0 = gpio_o[48];
  assign gpio_debug_2_0 = gpio_o[47];
  assign gpio_debug_1_0 = gpio_o[46];
  assign gpio_ctl_1 = gpio_o[45:42];
  assign gpio_ctl_0 = gpio_o[41:38];
  assign gpio_bd_o = gpio_o[20:13];
  assign gpio_i[12: 0] = gpio_bd_i;
  assign gpio_i[21:13] = gpio_o[21:13];
  assign gpio_i[29:22] = gpio_status_0;
  assign gpio_i[37:30] = gpio_status_1;
  assign gpio_i[63:38] = gpio_o[63:38];
  assign gpio_i[64] = gpio_ad5355_lock;
  assign gpio_i[94:65] = gpio_o[94:65];

  assign gpio_debug_3_1 = 1'b0;
  assign gpio_debug_4_1 = 1'b0;

  system_pl_wrapper #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .FPGA_FAMILY(FPGA_FAMILY),
    .SPEED_GRADE(SPEED_GRADE),
    .DEV_PACKAGE(DEV_PACKAGE),
    .ADC_INIT_DELAY(ADC_INIT_DELAY),
    .DAC_INIT_DELAY(DAC_INIT_DELAY),
    .DELAY_REFCLK_FREQUENCY(DELAY_REFCLK_FREQUENCY)
  ) inst_system_pl_wrapper (
    //AXI4LITE SLAVE INTERFACE TO CROSSBAR
    .axi_aclk(s_axi_clk),
    .axi_aresetn(s_axi_aresetn),

    .s_axi_awvalid(w_axi_awvalid),
    .s_axi_awaddr(w_axi_awaddr),
    .s_axi_awready(w_axi_awready),
    .s_axi_awprot(w_axi_awprot),
    .s_axi_wvalid(w_axi_wvalid),
    .s_axi_wdata(w_axi_wdata),
    .s_axi_wstrb(w_axi_wstrb),
    .s_axi_wready(w_axi_wready),
    .s_axi_bvalid(w_axi_bvalid),
    .s_axi_bresp(w_axi_bresp),
    .s_axi_bready(w_axi_bready),
    .s_axi_arvalid(w_axi_arvalid),
    .s_axi_araddr(w_axi_araddr),
    .s_axi_arready(w_axi_arready),
    .s_axi_arprot(w_axi_arprot),
    .s_axi_rvalid(w_axi_rvalid),
    .s_axi_rready(w_axi_rready),
    .s_axi_rresp(w_axi_rresp),
    .s_axi_rdata(w_axi_rdata),

    //irq
    .adc_dma_irq(s_adc_dma_irq),
    .dac_dma_irq(s_dac_dma_irq),

    //AD9361 IO
    //clocks
    .delay_clk(s_delay_clk),
    //ID 0
    //RX LVDS
    .rx_clk_in_0_p(rx_clk_in_0_p),
    .rx_clk_in_0_n(rx_clk_in_0_n),
    .rx_frame_in_0_p(rx_frame_in_0_p),
    .rx_frame_in_0_n(rx_frame_in_0_n),
    .rx_data_in_0_p(rx_data_in_0_p),
    .rx_data_in_0_n(rx_data_in_0_n),
    //TX LVDS
    .tx_clk_out_0_p(tx_clk_out_0_p),
    .tx_clk_out_0_n(tx_clk_out_0_n),
    .tx_frame_out_0_p(tx_frame_out_0_p),
    .tx_frame_out_0_n(tx_frame_out_0_n),
    .tx_data_out_0_p(tx_data_out_0_p),
    .tx_data_out_0_n(tx_data_out_0_n),
    //MISC
    .enable_0(enable_0),
    .txnrx_0(txnrx_0),
    .up_enable_0(gpio_enable_0),
    .up_txnrx_0(gpio_txnrx_0),
    //sync
    .tdd_sync_0_t(),
    .tdd_sync_0_i(1'b0),
    .tdd_sync_0_o(),
    //ID 1
    //RX LVDS
    .rx_clk_in_1_p(rx_clk_in_1_p),
    .rx_clk_in_1_n(rx_clk_in_1_n),
    .rx_frame_in_1_p(rx_frame_in_1_p),
    .rx_frame_in_1_n(rx_frame_in_1_n),
    .rx_data_in_1_p(rx_data_in_1_p),
    .rx_data_in_1_n(rx_data_in_1_n),
    //TX LVDS
    .tx_clk_out_1_p(tx_clk_out_1_p),
    .tx_clk_out_1_n(tx_clk_out_1_n),
    .tx_frame_out_1_p(tx_frame_out_1_p),
    .tx_frame_out_1_n(tx_frame_out_1_n),
    .tx_data_out_1_p(tx_data_out_1_p),
    .tx_data_out_1_n(tx_data_out_1_n),
    //MISC
    .enable_1(enable_1),
    .txnrx_1(txnrx_1),
    .up_enable_1(gpio_enable_1),
    .up_txnrx_1(gpio_txnrx_1),
    //sync
    .tdd_sync_1_t(),
    .tdd_sync_1_i(1'b0),
    .tdd_sync_1_o(),

    .m_axi_aclk(m_axi_aclk),

    //axi interface for the adc to the hp interface
    .adc_m_dest_axi_awaddr(adc_hp0_axi_awaddr),
    .adc_m_dest_axi_awlen(adc_hp0_axi_awlen),
    .adc_m_dest_axi_awsize(adc_hp0_axi_awsize),
    .adc_m_dest_axi_awburst(adc_hp0_axi_awburst),
    .adc_m_dest_axi_awprot(adc_hp0_axi_awprot),
    .adc_m_dest_axi_awcache(adc_hp0_axi_awcache),
    .adc_m_dest_axi_awvalid(adc_hp0_axi_awvalid),
    .adc_m_dest_axi_awready(adc_hp0_axi_awready),
    .adc_m_dest_axi_wdata(adc_hp0_axi_wdata),
    .adc_m_dest_axi_wstrb(adc_hp0_axi_wstrb),
    .adc_m_dest_axi_wready(adc_hp0_axi_wready),
    .adc_m_dest_axi_wvalid(adc_hp0_axi_wvalid),
    .adc_m_dest_axi_wlast(adc_hp0_axi_wlast),
    .adc_m_dest_axi_bvalid(adc_hp0_axi_bvalid),
    .adc_m_dest_axi_bresp(adc_hp0_axi_bresp),
    .adc_m_dest_axi_bready(adc_hp0_axi_bready),

    //axi interface for dac to the hp interface
    .dac_m_src_axi_arready(dac_hp1_axi_arready),
    .dac_m_src_axi_arvalid(dac_hp1_axi_arvalid),
    .dac_m_src_axi_araddr(dac_hp1_axi_araddr),
    .dac_m_src_axi_arlen(dac_hp1_axi_arlen),
    .dac_m_src_axi_arsize(dac_hp1_axi_arsize),
    .dac_m_src_axi_arburst(dac_hp1_axi_arburst),
    .dac_m_src_axi_arprot(dac_hp1_axi_arprot),
    .dac_m_src_axi_arcache(dac_hp1_axi_arcache),
    .dac_m_src_axi_rdata(dac_hp1_axi_rdata),
    .dac_m_src_axi_rready(dac_hp1_axi_rready),
    .dac_m_src_axi_rvalid(dac_hp1_axi_rvalid),
    .dac_m_src_axi_rresp(dac_hp1_axi_rresp),
    .dac_m_src_axi_rlast(dac_hp1_axi_rlast)
  );

  system_ps_wrapper inst_system_ps_wrapper (
    .M_AXI_araddr(w_axi_araddr),
    .M_AXI_arprot(w_axi_arprot),
    .M_AXI_arready(w_axi_arready),
    .M_AXI_arvalid(w_axi_arvalid),
    .M_AXI_awaddr(w_axi_awaddr),
    .M_AXI_awprot(w_axi_awprot),
    .M_AXI_awready(w_axi_awready),
    .M_AXI_awvalid(w_axi_awvalid),
    .M_AXI_bready(w_axi_bready),
    .M_AXI_bresp(w_axi_bresp),
    .M_AXI_bvalid(w_axi_bvalid),
    .M_AXI_rdata(w_axi_rdata),
    .M_AXI_rready(w_axi_rready),
    .M_AXI_rresp(w_axi_rresp),
    .M_AXI_rvalid(w_axi_rvalid),
    .M_AXI_wdata(w_axi_wdata),
    .M_AXI_wready(w_axi_wready),
    .M_AXI_wstrb(w_axi_wstrb),
    .M_AXI_wvalid(w_axi_wvalid),

    .S_AXI_HP0_arready(),
    .S_AXI_HP0_awready(adc_hp0_axi_awready),
    .S_AXI_HP0_bvalid(adc_hp0_axi_bvalid),
    .S_AXI_HP0_rlast(),
    .S_AXI_HP0_rvalid(),
    .S_AXI_HP0_wready(adc_hp0_axi_wready),
    .S_AXI_HP0_bresp(adc_hp0_axi_bresp),
    .S_AXI_HP0_rresp(),
    .S_AXI_HP0_bid(),
    .S_AXI_HP0_rid(),
    .S_AXI_HP0_rdata(),
    .S_AXI_HP0_ACLK(m_axi_aclk),
    .S_AXI_HP0_arvalid(1'b0),
    .S_AXI_HP0_awvalid(adc_hp0_axi_awvalid),
    .S_AXI_HP0_bready(adc_hp0_axi_bready),
    .S_AXI_HP0_rready(1'b0),
    .S_AXI_HP0_wlast(adc_hp0_axi_wlast),
    .S_AXI_HP0_wvalid(adc_hp0_axi_wvalid),
    .S_AXI_HP0_arburst(2'b01),
    .S_AXI_HP0_arlock(0),
    .S_AXI_HP0_arsize(3'b011),
    .S_AXI_HP0_awburst(adc_hp0_axi_awburst),
    .S_AXI_HP0_awlock(0),
    .S_AXI_HP0_awsize(adc_hp0_axi_awsize),
    .S_AXI_HP0_arprot(0),
    .S_AXI_HP0_awprot(adc_hp0_axi_awprot),
    .S_AXI_HP0_araddr(0),
    .S_AXI_HP0_awaddr(adc_hp0_axi_awaddr),
    .S_AXI_HP0_arcache(4'b0011),
    .S_AXI_HP0_arlen(0),
    .S_AXI_HP0_arqos(0),
    .S_AXI_HP0_awcache(adc_hp0_axi_awcache),
    .S_AXI_HP0_awlen(adc_hp0_axi_awlen),
    .S_AXI_HP0_awqos(0),
    .S_AXI_HP0_arid(0),
    .S_AXI_HP0_awid(0),
    .S_AXI_HP0_wdata(adc_hp0_axi_wdata),
    .S_AXI_HP0_wstrb(adc_hp0_axi_wstrb),
    .S_AXI_HP0_aruser(1'b0),
    .S_AXI_HP0_awuser(1'b0),

    .S_AXI_HP1_arready(dac_hp1_axi_arready),
    .S_AXI_HP1_awready(),
    .S_AXI_HP1_bvalid(),
    .S_AXI_HP1_rlast(dac_hp1_axi_rlast),
    .S_AXI_HP1_rvalid(dac_hp1_axi_rvalid),
    .S_AXI_HP1_wready(),
    .S_AXI_HP1_bresp(),
    .S_AXI_HP1_rresp(dac_hp1_axi_rresp),
    .S_AXI_HP1_bid(),
    .S_AXI_HP1_rid(),
    .S_AXI_HP1_rdata(dac_hp1_axi_rdata),
    .S_AXI_HP1_ACLK(m_axi_aclk),
    .S_AXI_HP1_arvalid(dac_hp1_axi_arvalid),
    .S_AXI_HP1_awvalid(1'b0),
    .S_AXI_HP1_bready(1'b0),
    .S_AXI_HP1_rready(dac_hp1_axi_rready),
    .S_AXI_HP1_wlast(1'b0),
    .S_AXI_HP1_wvalid(1'b0),
    .S_AXI_HP1_arburst(dac_hp1_axi_arburst),
    .S_AXI_HP1_arlock(0),
    .S_AXI_HP1_arsize(dac_hp1_axi_arsize),
    .S_AXI_HP1_awburst(2'b01),
    .S_AXI_HP1_awlock(0),
    .S_AXI_HP1_awsize(3'b011),
    .S_AXI_HP1_arprot(dac_hp1_axi_arprot),
    .S_AXI_HP1_awprot(0),
    .S_AXI_HP1_araddr(dac_hp1_axi_araddr),
    .S_AXI_HP1_awaddr(0),
    .S_AXI_HP1_arcache(dac_hp1_axi_arcache),
    .S_AXI_HP1_arlen(dac_hp1_axi_arlen),
    .S_AXI_HP1_arqos(0),
    .S_AXI_HP1_awcache(4'b0011),
    .S_AXI_HP1_awlen(0),
    .S_AXI_HP1_awqos(0),
    .S_AXI_HP1_arid(0),
    .S_AXI_HP1_awid(0),
    .S_AXI_HP1_wdata(0),
    .S_AXI_HP1_wstrb(~0),
    .S_AXI_HP1_aruser(1'b0),
    .S_AXI_HP1_awuser(1'b0),

    .gpio_i(gpio_i),
    .gpio_o(gpio_o),
    .gpio_t(),

    .peripheral_aresetn(s_axi_aresetn),
    .pl_clk0(s_axi_clk),
    .pl_clk1(m_axi_aclk),
    .pl_clk2(s_delay_clk),
    .pl_ps_irq1({{2{1'b0}}, s_adc_dma_irq, s_dac_dma_irq, {4{1'b0}}}),

    .spi0_m_i(spi_miso),
    .spi0_m_o(spi_mosi),
    .spi0_mo_t(),
    .spi0_s_i(1'b0),
    .spi0_s_o(),
    .spi0_sclk_i(1'b0),
    .spi0_sclk_o(spi_clk),
    .spi0_sclk_t(),
    .spi0_so_t(),
    .spi0_ss1_o_n(spi_ad9361_1),
    .spi0_ss2_o_n(spi_ad5355),
    .spi0_ss_i_n(1'b1),
    .spi0_ss_n_t(),
    .spi0_ss_o_n(spi_ad9361_0),

    .spi1_m_i(1'b0),
    .spi1_m_o(),
    .spi1_mo_t(),
    .spi1_s_i(1'b0),
    .spi1_s_o(),
    .spi1_sclk_i(1'b0),
    .spi1_sclk_o(),
    .spi1_sclk_t(),
    .spi1_so_t(),
    .spi1_ss1_o_n(),
    .spi1_ss2_o_n(),
    .spi1_ss_i_n(1'b1),
    .spi1_ss_n_t(),
    .spi1_ss_o_n()
  );
endmodule
