//******************************************************************************
/// @FILE    system_wrapper.v
/// @AUTHOR  JAY CONVERTINO
/// @DATE    2023.11.02
/// @BRIEF   System wrapper for pl and ps.
///
/// @LICENSE MIT
///  Copyright 2023 Jay Convertino
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

//copy-pasta inout from analog device system_top.v zed
module system_wrapper #(
    parameter FPGA_TECHNOLOGY = 1,
    parameter FPGA_FAMILY = 4,
    parameter SPEED_GRADE = 10,
    parameter DEV_PACKAGE = 14,
    parameter DELAY_REFCLK_FREQUENCY = 200,
    parameter ADC_INIT_DELAY = 23,
    parameter DAC_INIT_DELAY = 0
  ) (
    inout       [14:0]      ddr_addr,
    inout       [ 2:0]      ddr_ba,
    inout                   ddr_cas_n,
    inout                   ddr_ck_n,
    inout                   ddr_ck_p,
    inout                   ddr_cke,
    inout                   ddr_cs_n,
    inout       [ 3:0]      ddr_dm,
    inout       [31:0]      ddr_dq,
    inout       [ 3:0]      ddr_dqs_n,
    inout       [ 3:0]      ddr_dqs_p,
    inout                   ddr_odt,
    inout                   ddr_ras_n,
    inout                   ddr_reset_n,
    inout                   ddr_we_n,

    inout                   fixed_io_ddr_vrn,
    inout                   fixed_io_ddr_vrp,
    inout       [53:0]      fixed_io_mio,
    inout                   fixed_io_ps_clk,
    inout                   fixed_io_ps_porb,
    inout                   fixed_io_ps_srstb,

    inout       [31:0]      gpio_bd,

    input                   otg_vbusoc,

    input                   rx_clk_in_p,
    input                   rx_clk_in_n,
    input                   rx_frame_in_p,
    input                   rx_frame_in_n,
    input       [ 5:0]      rx_data_in_p,
    input       [ 5:0]      rx_data_in_n,
    output                  tx_clk_out_p,
    output                  tx_clk_out_n,
    output                  tx_frame_out_p,
    output                  tx_frame_out_n,
    output      [ 5:0]      tx_data_out_p,
    output      [ 5:0]      tx_data_out_n,

    output                  txnrx,
    output                  enable,

    inout                   gpio_muxout_tx,
    inout                   gpio_muxout_rx,
    inout                   gpio_resetb,
    inout                   gpio_sync,
    inout                   gpio_en_agc,
    inout       [ 3:0]      gpio_ctl,
    inout       [ 7:0]      gpio_status,

    output                  spi_csn,
    output                  spi_clk,
    output                  spi_mosi,
    input                   spi_miso,

    output                  spi_udc_csn_tx,
    output                  spi_udc_csn_rx,
    output                  spi_udc_sclk,
    output                  spi_udc_data
  );

  // internal signals

  wire    [63:0]  gpio_i;
  wire    [63:0]  gpio_o;
  wire    [63:0]  gpio_t;

  //PS TO PL / PL TO PS signals

  wire            s_delay_clk;
  wire            s_axi_clk;
  wire            s_axi_aresetn;
  wire            s_adc_dma_irq;
  wire            s_dac_dma_irq;

  //axi gp0
  wire        w_axi_awvalid;
  wire [31:0] w_axi_awaddr;
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
  wire [31:0] w_axi_araddr;
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
  wire [ 5:0]   adc_hp0_axi_awid;
  wire [ 1:0]   adc_hp0_axi_awlock;
  wire [63:0]   adc_hp0_axi_wdata;
  wire [ 7:0]   adc_hp0_axi_wstrb;
  wire          adc_hp0_axi_wready;
  wire          adc_hp0_axi_wvalid;
  wire          adc_hp0_axi_wlast;
  wire [ 5:0]   adc_hp0_axi_wid;
  wire          adc_hp0_axi_bvalid;
  wire [ 1:0]   adc_hp0_axi_bresp;
  wire          adc_hp0_axi_bready;
  wire [ 5:0]   adc_hp0_axi_bid;
  // Unused read interface
  wire          adc_hp0_axi_arvalid;
  wire [31:0]   adc_hp0_axi_araddr;
  wire [ 3:0]   adc_hp0_axi_arlen;
  wire [ 2:0]   adc_hp0_axi_arsize;
  wire [ 1:0]   adc_hp0_axi_arburst;
  wire [ 3:0]   adc_hp0_axi_arcache;
  wire [ 2:0]   adc_hp0_axi_arprot;
  wire          adc_hp0_axi_arready;
  wire          adc_hp0_axi_rvalid;
  wire [ 1:0]   adc_hp0_axi_rresp;
  wire [63:0]   adc_hp0_axi_rdata;
  wire          adc_hp0_axi_rready;
  wire [ 5:0]   adc_hp0_axi_arid;
  wire [ 1:0]   adc_hp0_axi_arlock;
  wire [ 5:0]   adc_hp0_axi_rid;
  wire          adc_hp0_axi_rlast;

  //axi interface for dac to the hp1 interface
  wire          dac_hp1_axi_arready;
  wire          dac_hp1_axi_arvalid;
  wire [31:0]   dac_hp1_axi_araddr;
  wire [ 3:0]   dac_hp1_axi_arlen;
  wire [ 2:0]   dac_hp1_axi_arsize;
  wire [ 1:0]   dac_hp1_axi_arburst;
  wire [ 2:0]   dac_hp1_axi_arprot;
  wire [ 3:0]   dac_hp1_axi_arcache;
  wire [ 5:0]   dac_hp1_axi_arid;
  wire [ 1:0]   dac_hp1_axi_arlock;
  wire [63:0]   dac_hp1_axi_rdata;
  wire          dac_hp1_axi_rready;
  wire          dac_hp1_axi_rvalid;
  wire [ 1:0]   dac_hp1_axi_rresp;
  wire [ 5:0]   dac_hp1_axi_rid;
  wire          dac_hp1_axi_rlast;
  // Unused write interface
  wire          dac_hp1_axi_awvalid;
  wire [31:0]   dac_hp1_axi_awaddr;
  wire [ 3:0]   dac_hp1_axi_awlen;
  wire [ 2:0]   dac_hp1_axi_awsize;
  wire [ 1:0]   dac_hp1_axi_awburst;
  wire [ 3:0]   dac_hp1_axi_awcache;
  wire [ 2:0]   dac_hp1_axi_awprot;
  wire          dac_hp1_axi_awready;
  wire          dac_hp1_axi_wvalid;
  wire [63:0]   dac_hp1_axi_wdata;
  wire [ 7:0]   dac_hp1_axi_wstrb;
  wire          dac_hp1_axi_wlast;
  wire          dac_hp1_axi_wready;
  wire          dac_hp1_axi_bvalid;
  wire [ 1:0]   dac_hp1_axi_bresp;
  wire          dac_hp1_axi_bready;
  wire [ 5:0]   dac_hp1_axi_awid;
  wire [ 1:0]   dac_hp1_axi_awlock;
  wire [ 5:0]   dac_hp1_axi_wid;
  wire [ 5:0]   dac_hp1_axi_bid;

  // instantiations... copy pasta

  ad_iobuf #(.DATA_WIDTH(49)) i_iobuf_gpio (
    .dio_t ({gpio_t[50:49], gpio_t[46:0]}),
    .dio_i ({gpio_o[50:49], gpio_o[46:0]}),
    .dio_o ({gpio_i[50:49], gpio_i[46:0]}),
    .dio_p ({ gpio_muxout_tx,
              gpio_muxout_rx,
              gpio_resetb,
              gpio_sync,
              gpio_en_agc,
              gpio_ctl,
              gpio_status,
              gpio_bd}));

  assign gpio_i[63:51] = gpio_o[63:51];
  assign gpio_i[48:47] = gpio_o[48:47];

  system_wrapper_pl #(
    .FPGA_TECHNOLOGY(FPGA_TECHNOLOGY),
    .FPGA_FAMILY(FPGA_FAMILY),
    .SPEED_GRADE(SPEED_GRADE),
    .DEV_PACKAGE(DEV_PACKAGE),
    .ADC_INIT_DELAY(ADC_INIT_DELAY),
    .DAC_INIT_DELAY(DAC_INIT_DELAY),
    .DELAY_REFCLK_FREQUENCY(DELAY_REFCLK_FREQUENCY)
  ) inst_system_wrapper_pl (
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
    //RX LVDS
    .rx_clk_in_p(rx_clk_in_p),
    .rx_clk_in_n(rx_clk_in_n),
    .rx_frame_in_p(rx_frame_in_p),
    .rx_frame_in_n(rx_frame_in_n),
    .rx_data_in_p(rx_data_in_p),
    .rx_data_in_n(rx_data_in_n),
    //TX LVDS
    .tx_clk_out_p(tx_clk_out_p),
    .tx_clk_out_n(tx_clk_out_n),
    .tx_frame_out_p(tx_frame_out_p),
    .tx_frame_out_n(tx_frame_out_n),
    .tx_data_out_p(tx_data_out_p),
    .tx_data_out_n(tx_data_out_n),
    //MISC
    .enable(enable),
    .txnrx(txnrx),
    .up_enable(gpio_o[47]),
    .up_txnrx(gpio_o[48]),
    //sync
    .tdd_sync_t(),
    .tdd_sync_i(1'b0),
    .tdd_sync_o(),

    //axi interface for the adc to the hp interface
    .adc_m_dest_axi_awaddr(adc_hp0_axi_awaddr),
    .adc_m_dest_axi_awlen(adc_hp0_axi_awlen),
    .adc_m_dest_axi_awsize(adc_hp0_axi_awsize),
    .adc_m_dest_axi_awburst(adc_hp0_axi_awburst),
    .adc_m_dest_axi_awprot(adc_hp0_axi_awprot),
    .adc_m_dest_axi_awcache(adc_hp0_axi_awcache),
    .adc_m_dest_axi_awvalid(adc_hp0_axi_awvalid),
    .adc_m_dest_axi_awready(adc_hp0_axi_awready),
    .adc_m_dest_axi_awid(adc_hp0_axi_awid),
    .adc_m_dest_axi_awlock(adc_hp0_axi_awlock),
    .adc_m_dest_axi_wdata(adc_hp0_axi_wdata),
    .adc_m_dest_axi_wstrb(adc_hp0_axi_wstrb),
    .adc_m_dest_axi_wready(adc_hp0_axi_wready),
    .adc_m_dest_axi_wvalid(adc_hp0_axi_wvalid),
    .adc_m_dest_axi_wlast(adc_hp0_axi_wlast),
    .adc_m_dest_axi_wid(adc_hp0_axi_wid),
    .adc_m_dest_axi_bvalid(adc_hp0_axi_bvalid),
    .adc_m_dest_axi_bresp(adc_hp0_axi_bresp),
    .adc_m_dest_axi_bready(adc_hp0_axi_bready),
    .adc_m_dest_axi_bid(adc_hp0_axi_bid),
    // Unused read interface
    .adc_m_dest_axi_arvalid(adc_hp0_axi_arvalid),
    .adc_m_dest_axi_araddr(adc_hp0_axi_araddr),
    .adc_m_dest_axi_arlen(adc_hp0_axi_arlen),
    .adc_m_dest_axi_arsize(adc_hp0_axi_arsize),
    .adc_m_dest_axi_arburst(adc_hp0_axi_arburst),
    .adc_m_dest_axi_arcache(adc_hp0_axi_arcache),
    .adc_m_dest_axi_arprot(adc_hp0_axi_arprot),
    .adc_m_dest_axi_arready(adc_hp0_axi_arready),
    .adc_m_dest_axi_rvalid(adc_hp0_axi_rvalid),
    .adc_m_dest_axi_rresp(adc_hp0_axi_rresp),
    .adc_m_dest_axi_rdata(adc_hp0_axi_rdata),
    .adc_m_dest_axi_rready(adc_hp0_axi_rready),
    .adc_m_dest_axi_arid(adc_hp0_axi_arid),
    .adc_m_dest_axi_arlock(adc_hp0_axi_arlock),
    .adc_m_dest_axi_rid(adc_hp0_axi_rid),
    .adc_m_dest_axi_rlast(adc_hp0_axi_rlast),

    //axi interface for dac to the hp interface
    .dac_m_src_axi_arready(dac_hp1_axi_arready),
    .dac_m_src_axi_arvalid(dac_hp1_axi_arvalid),
    .dac_m_src_axi_araddr(dac_hp1_axi_araddr),
    .dac_m_src_axi_arlen(dac_hp1_axi_arlen),
    .dac_m_src_axi_arsize(dac_hp1_axi_arsize),
    .dac_m_src_axi_arburst(dac_hp1_axi_arburst),
    .dac_m_src_axi_arprot(dac_hp1_axi_arprot),
    .dac_m_src_axi_arcache(dac_hp1_axi_arcache),
    .dac_m_src_axi_arid(dac_hp1_axi_arid),
    .dac_m_src_axi_arlock(dac_hp1_axi_arlock),
    .dac_m_src_axi_rdata(dac_hp1_axi_rdata),
    .dac_m_src_axi_rready(dac_hp1_axi_rready),
    .dac_m_src_axi_rvalid(dac_hp1_axi_rvalid),
    .dac_m_src_axi_rresp(dac_hp1_axi_rresp),
    .dac_m_src_axi_rid(dac_hp1_axi_rid),
    .dac_m_src_axi_rlast(dac_hp1_axi_rlast),
    // Unused write interface
    .dac_m_src_axi_awvalid(dac_hp1_axi_awvalid),
    .dac_m_src_axi_awaddr(dac_hp1_axi_awaddr),
    .dac_m_src_axi_awlen(dac_hp1_axi_awlen),
    .dac_m_src_axi_awsize(dac_hp1_axi_awsize),
    .dac_m_src_axi_awburst(dac_hp1_axi_awburst),
    .dac_m_src_axi_awcache(dac_hp1_axi_awcache),
    .dac_m_src_axi_awprot(dac_hp1_axi_awprot),
    .dac_m_src_axi_awready(dac_hp1_axi_awready),
    .dac_m_src_axi_wvalid(dac_hp1_axi_wvalid),
    .dac_m_src_axi_wdata(dac_hp1_axi_wdata),
    .dac_m_src_axi_wstrb(dac_hp1_axi_wstrb),
    .dac_m_src_axi_wlast(dac_hp1_axi_wlast),
    .dac_m_src_axi_wready(dac_hp1_axi_wready),
    .dac_m_src_axi_bvalid(dac_hp1_axi_bvalid),
    .dac_m_src_axi_bresp(dac_hp1_axi_bresp),
    .dac_m_src_axi_bready(dac_hp1_axi_bready),
    .dac_m_src_axi_awid(dac_hp1_axi_awid),
    .dac_m_src_axi_awlock(dac_hp1_axi_awlock),
    .dac_m_src_axi_wid(dac_hp1_axi_wid),
    .dac_m_src_axi_bid(dac_hp1_axi_bid)
  );

  system_wrapper_ps inst_system_wrapper_ps
    (
      .GPIO_I(gpio_i),
      .GPIO_O(gpio_o),
      .GPIO_T(gpio_t),
      .SPI0_SCLK_I(1'b0),
      .SPI0_SCLK_O(spi_clk),
      .SPI0_SCLK_T(), //not used
      .SPI0_MOSI_I(1'b0),
      .SPI0_MOSI_O(spi_mosi),
      .SPI0_MOSI_T(), //not used
      .SPI0_MISO_I(spi_miso),
      .SPI0_MISO_O(), //not used
      .SPI0_MISO_T(), //not used
      .SPI0_SS_I(1'b1),
      .SPI0_SS_O(spi_csn),
      .SPI0_SS1_O(), //not used
      .SPI0_SS2_O(), //not used
      .SPI0_SS_T(),  //not used
      .SPI1_SCLK_I(1'b0),
      .SPI1_SCLK_O(spi_udc_sclk),
      .SPI1_SCLK_T(), //not used
      .SPI1_MOSI_I(spi_udc_data),
      .SPI1_MOSI_O(spi_udc_data),
      .SPI1_MOSI_T(), //not used
      .SPI1_MISO_I(1'b0),
      .SPI1_MISO_O(), //not used
      .SPI1_MISO_T(), //not used
      .SPI1_SS_I(1'b1),
      .SPI1_SS_O(spi_udc_csn_tx),
      .SPI1_SS1_O(spi_udc_csn_rx),
      .SPI1_SS2_O(), //not used
      .SPI1_SS_T(),  //not used
      .USB0_VBUS_PWRFAULT(~otg_vbusoc),
      .M_AXI_GP0_ARVALID(w_axi_arvalid),
      .M_AXI_GP0_AWVALID(w_axi_awvalid),
      .M_AXI_GP0_BREADY(w_axi_bready),
      .M_AXI_GP0_RREADY(w_axi_rready),
      .M_AXI_GP0_WLAST(), //not used
      .M_AXI_GP0_WVALID(w_axi_wvalid),
      .M_AXI_GP0_ARID(), //not used
      .M_AXI_GP0_AWID(), //not used
      .M_AXI_GP0_WID(),  //not used
      .M_AXI_GP0_ARBURST(), //not used
      .M_AXI_GP0_ARLOCK(),  //not used
      .M_AXI_GP0_ARSIZE(),  //not used
      .M_AXI_GP0_AWBURST(), //not used
      .M_AXI_GP0_AWLOCK(),  //not used
      .M_AXI_GP0_AWSIZE(),  //not used
      .M_AXI_GP0_ARPROT(w_axi_arprot),
      .M_AXI_GP0_AWPROT(w_axi_awprot),
      .M_AXI_GP0_ARADDR(w_axi_araddr),
      .M_AXI_GP0_AWADDR(w_axi_awaddr),
      .M_AXI_GP0_WDATA(w_axi_wdata),
      .M_AXI_GP0_ARCACHE(), //not used
      .M_AXI_GP0_ARLEN(),   //not used
      .M_AXI_GP0_ARQOS(),   //not used
      .M_AXI_GP0_AWCACHE(), //not used
      .M_AXI_GP0_AWLEN(),   //not used
      .M_AXI_GP0_AWQOS(),   //not used
      .M_AXI_GP0_WSTRB(w_axi_wstrb),
      .M_AXI_GP0_ACLK(s_axi_clk),
      .M_AXI_GP0_ARREADY(w_axi_arready),
      .M_AXI_GP0_AWREADY(w_axi_awready),
      .M_AXI_GP0_BVALID(w_axi_bvalid),
      .M_AXI_GP0_RLAST(1'b0),  //not used
      .M_AXI_GP0_RVALID(w_axi_rvalid),
      .M_AXI_GP0_WREADY(w_axi_wready),
      .M_AXI_GP0_BID({11{1'b0}}),    //not used
      .M_AXI_GP0_RID({11{1'b0}}),    //not used
      .M_AXI_GP0_BRESP(w_axi_bresp),
      .M_AXI_GP0_RRESP(w_axi_rresp),
      .M_AXI_GP0_RDATA(w_axi_rdata),
      .S_AXI_HP0_ARREADY(adc_hp0_axi_arready),
      .S_AXI_HP0_AWREADY(adc_hp0_axi_awready),
      .S_AXI_HP0_BVALID(adc_hp0_axi_bvalid),
      .S_AXI_HP0_RLAST(adc_hp0_axi_rlast),
      .S_AXI_HP0_RVALID(adc_hp0_axi_rvalid),
      .S_AXI_HP0_WREADY(adc_hp0_axi_wready),
      .S_AXI_HP0_BRESP(adc_hp0_axi_bresp),
      .S_AXI_HP0_RRESP(adc_hp0_axi_rresp),
      .S_AXI_HP0_BID(adc_hp0_axi_bid),
      .S_AXI_HP0_RID(adc_hp0_axi_rid),
      .S_AXI_HP0_RDATA(adc_hp0_axi_rdata),
      .S_AXI_HP0_RCOUNT(), //not used
      .S_AXI_HP0_WCOUNT(), //not used
      .S_AXI_HP0_RACOUNT(), //not used
      .S_AXI_HP0_WACOUNT(), //not used
      .S_AXI_HP0_ACLK(s_axi_clk),
      .S_AXI_HP0_ARVALID(adc_hp0_axi_arvalid),
      .S_AXI_HP0_AWVALID(adc_hp0_axi_wvalid),
      .S_AXI_HP0_BREADY(adc_hp0_axi_bready),
      .S_AXI_HP0_RDISSUECAP1_EN(),  //not used
      .S_AXI_HP0_RREADY(adc_hp0_axi_rready),
      .S_AXI_HP0_WLAST(adc_hp0_axi_wlast),
      .S_AXI_HP0_WRISSUECAP1_EN(), //not used
      .S_AXI_HP0_WVALID(adc_hp0_axi_wvalid),
      .S_AXI_HP0_ARBURST(adc_hp0_axi_arburst),
      .S_AXI_HP0_ARLOCK(adc_hp0_axi_arlock),
      .S_AXI_HP0_ARSIZE(adc_hp0_axi_arsize),
      .S_AXI_HP0_AWBURST(adc_hp0_axi_awburst),
      .S_AXI_HP0_AWLOCK(adc_hp0_axi_awlock),
      .S_AXI_HP0_AWSIZE(adc_hp0_axi_awsize),
      .S_AXI_HP0_ARPROT(adc_hp0_axi_arprot),
      .S_AXI_HP0_AWPROT(adc_hp0_axi_awprot),
      .S_AXI_HP0_ARADDR(adc_hp0_axi_araddr),
      .S_AXI_HP0_AWADDR(adc_hp0_axi_awaddr),
      .S_AXI_HP0_ARCACHE(adc_hp0_axi_arcache),
      .S_AXI_HP0_ARLEN(adc_hp0_axi_arlen),
      .S_AXI_HP0_ARQOS(), //not used
      .S_AXI_HP0_AWCACHE(adc_hp0_axi_awcache),
      .S_AXI_HP0_AWLEN(adc_hp0_axi_awlen),
      .S_AXI_HP0_AWQOS(), //not used
      .S_AXI_HP0_ARID(adc_hp0_axi_arid),
      .S_AXI_HP0_AWID(adc_hp0_axi_awid),
      .S_AXI_HP0_WID(adc_hp0_axi_wid),
      .S_AXI_HP0_WDATA(adc_hp0_axi_wdata),
      .S_AXI_HP0_WSTRB(adc_hp0_axi_wstrb),
      .S_AXI_HP1_ARREADY(dac_hp1_axi_arready),
      .S_AXI_HP1_AWREADY(dac_hp1_axi_awready),
      .S_AXI_HP1_BVALID(dac_hp1_axi_bvalid),
      .S_AXI_HP1_RLAST(dac_hp1_axi_rlast),
      .S_AXI_HP1_RVALID(dac_hp1_axi_rvalid),
      .S_AXI_HP1_WREADY(dac_hp1_axi_wready),
      .S_AXI_HP1_BRESP(dac_hp1_axi_bresp),
      .S_AXI_HP1_RRESP(dac_hp1_axi_rresp),
      .S_AXI_HP1_BID(dac_hp1_axi_bid),
      .S_AXI_HP1_RID(dac_hp1_axi_rid),
      .S_AXI_HP1_RDATA(dac_hp1_axi_rdata),
      .S_AXI_HP1_RCOUNT(), //not used
      .S_AXI_HP1_WCOUNT(), //not used
      .S_AXI_HP1_RACOUNT(),//not used
      .S_AXI_HP1_WACOUNT(),//not used
      .S_AXI_HP1_ACLK(s_axi_clk),
      .S_AXI_HP1_ARVALID(dac_hp1_axi_arvalid),
      .S_AXI_HP1_AWVALID(dac_hp1_axi_awvalid),
      .S_AXI_HP1_BREADY(dac_hp1_axi_bready),
      .S_AXI_HP1_RDISSUECAP1_EN(), //not used
      .S_AXI_HP1_RREADY(dac_hp1_axi_rready),
      .S_AXI_HP1_WLAST(dac_hp1_axi_wlast),
      .S_AXI_HP1_WRISSUECAP1_EN(), //not used
      .S_AXI_HP1_WVALID(dac_hp1_axi_wvalid),
      .S_AXI_HP1_ARBURST(dac_hp1_axi_arburst),
      .S_AXI_HP1_ARLOCK(dac_hp1_axi_arlock),
      .S_AXI_HP1_ARSIZE(dac_hp1_axi_arsize),
      .S_AXI_HP1_AWBURST(dac_hp1_axi_awburst),
      .S_AXI_HP1_AWLOCK(dac_hp1_axi_awlock),
      .S_AXI_HP1_AWSIZE(dac_hp1_axi_awsize),
      .S_AXI_HP1_ARPROT(dac_hp1_axi_arprot),
      .S_AXI_HP1_AWPROT(dac_hp1_axi_awprot),
      .S_AXI_HP1_ARADDR(dac_hp1_axi_araddr),
      .S_AXI_HP1_AWADDR(dac_hp1_axi_awaddr),
      .S_AXI_HP1_ARCACHE(dac_hp1_axi_arcache),
      .S_AXI_HP1_ARLEN(dac_hp1_axi_arlen),
      .S_AXI_HP1_ARQOS(), //not used
      .S_AXI_HP1_AWCACHE(dac_hp1_axi_awcache),
      .S_AXI_HP1_AWLEN(dac_hp1_axi_awlen),
      .S_AXI_HP1_AWQOS(), //not used
      .S_AXI_HP1_ARID(dac_hp1_axi_arid),
      .S_AXI_HP1_AWID(dac_hp1_axi_awid),
      .S_AXI_HP1_WID(dac_hp1_axi_wid),
      .S_AXI_HP1_WDATA(dac_hp1_axi_wdata),
      .S_AXI_HP1_WSTRB(dac_hp1_axi_wstrb),
      .IRQ_F2P({{2{1'b0}}, s_adc_dma_irq, s_dac_dma_irq, {12{1'b0}}}),
      .FCLK_CLK0(s_axi_clk),
      .FCLK_CLK1(s_delay_clk),
      .FCLK_RESET1_N(), //not used
      .MIO(fixed_io_mio),
      .DDR_CAS_n(ddr_cas_n),
      .DDR_CKE(ddr_cke),
      .DDR_Clk_n(ddr_ck_n),
      .DDR_Clk(ddr_ck_p),
      .DDR_CS_n(ddr_cs_n),
      .DDR_DRSTB(ddr_reset_n),
      .DDR_ODT(ddr_odt),
      .DDR_RAS_n(ddr_ras_n),
      .DDR_WEB(ddr_we_n),
      .DDR_BankAddr(ddr_ba),
      .DDR_Addr(ddr_addr),
      .DDR_VRN(fixed_io_ddr_vrn),
      .DDR_VRP(fixed_io_ddr_vrp),
      .DDR_DM(ddr_dm),
      .DDR_DQ(ddr_dq),
      .DDR_DQS_n(ddr_dqs_n),
      .DDR_DQS(ddr_dqs_p),
      .PS_SRSTB(fixed_io_ps_srstb),
      .PS_CLK(fixed_io_ps_clk),
      .PS_PORB(fixed_io_ps_porb),
      .PERIPHERAL_ARESETN(s_axi_aresetn)
    );

endmodule
