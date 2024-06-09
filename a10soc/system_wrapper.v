//******************************************************************************
/// @FILE    system_wrapper.v
/// @AUTHOR  JAY CONVERTINO
/// @DATE    2023.12.17
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

module system_wrapper #(
    parameter FPGA_TECHNOLOGY = 103,
    parameter FPGA_FAMILY = 1,
    parameter SPEED_GRADE = 2,
    parameter DEV_PACKAGE = 3,
    parameter DELAY_REFCLK_FREQUENCY = 200,
    parameter ADC_INIT_DELAY = 23,
    parameter DAC_INIT_DELAY = 0
  ) (
    // clock and resets

    input             sys_clk,
    input             sys_resetn,

    // hps-ddr4 (32)

    input             hps_ddr_ref_clk,
    output  [  0:0]   hps_ddr_clk_p,
    output  [  0:0]   hps_ddr_clk_n,
    output  [ 16:0]   hps_ddr_a,
    output  [  1:0]   hps_ddr_ba,
    output  [  0:0]   hps_ddr_bg,
    output  [  0:0]   hps_ddr_cke,
    output  [  0:0]   hps_ddr_cs_n,
    output  [  0:0]   hps_ddr_odt,
    output  [  0:0]   hps_ddr_reset_n,
    output  [  0:0]   hps_ddr_act_n,
    output  [  0:0]   hps_ddr_par,
    input   [  0:0]   hps_ddr_alert_n,
    inout   [  3:0]   hps_ddr_dqs_p,
    inout   [  3:0]   hps_ddr_dqs_n,
    inout   [ 31:0]   hps_ddr_dq,
    inout   [  3:0]   hps_ddr_dbi_n,
    input             hps_ddr_rzq,

    // hps-ethernet

    input   [  0:0]   hps_eth_rxclk,
    input   [  0:0]   hps_eth_rxctl,
    input   [  3:0]   hps_eth_rxd,
    output  [  0:0]   hps_eth_txclk,
    output  [  0:0]   hps_eth_txctl,
    output  [  3:0]   hps_eth_txd,
    output  [  0:0]   hps_eth_mdc,
    inout   [  0:0]   hps_eth_mdio,

    // hps-sdio

    output  [  0:0]   hps_sdio_clk,
    inout   [  0:0]   hps_sdio_cmd,
    inout   [  7:0]   hps_sdio_d,

    // hps-usb

    input   [  0:0]   hps_usb_clk,
    input   [  0:0]   hps_usb_dir,
    input   [  0:0]   hps_usb_nxt,
    output  [  0:0]   hps_usb_stp,
    inout   [  7:0]   hps_usb_d,

    // hps-uart

    input   [  0:0]   hps_uart_rx,
    output  [  0:0]   hps_uart_tx,

    // hps-i2c (shared w fmc-a, fmc-b)

    inout   [  0:0]   hps_i2c_sda,
    inout   [  0:0]   hps_i2c_scl,

    // hps-gpio (max-v-u16)

    inout   [  3:0]   hps_gpio,

    // gpio (max-v-u21)

    input   [  7:0]   gpio_bd_i,
    output  [  3:0]   gpio_bd_o,

    // ad9361-interface
    // ID 0
    input                   rx_clk_in_0,
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
    output                  gpio_resetb_0,
    output                  enable_0,
    output                  txnrx_0,
    output                  gpio_debug_1_0,
    output                  gpio_debug_2_0,
    output                  gpio_calsw_1_0,
    output                  gpio_calsw_2_0,

    // ID 1
    input                   rx_clk_in_1,
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

    // common
    output                  mcs_sync,
    output                  gpio_ad5355_rfen,
    input                   gpio_ad5355_lock,
    output                  spi_ad9361_0,
    output                  spi_ad9361_1,
    output                  spi_ad5355,
    output                  spi_clk,
    output                  spi_mosi,
    input                   spi_miso,

    input                   ref_clk
  );

  // internal signals

  //PS TO PL / PL TO PS signals

  wire        s_delay_clk;
  wire        s_axi_clk;
  wire        s_axi_aresetn;
  wire        s_adc_dma_irq;
  wire        s_dac_dma_irq;

  //axi h2f
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
  wire              sys_hps_resetn;
  wire              sys_resetn_s;
  wire    [ 63:0]   gpio_i;
  wire    [ 63:0]   gpio_o;
  wire    [  4:0]   spi_ssn_spacer;

  reg     [  2:0] mcs_sync_m = 'd0;

  // internal signals

  wire            s_ref_clk;
  reg             r_mcs_sync;

  // multi-chip synchronization

  always @(posedge s_ref_clk or negedge s_axi_aresetn) begin
    if (s_axi_aresetn == 1'b0) begin
      mcs_sync_m <= 3'd0;
      r_mcs_sync <= 1'd0;
    end else begin
      mcs_sync_m <= {mcs_sync_m[1:0], gpio_sync};
      r_mcs_sync <= mcs_sync_m[2] & ~mcs_sync_m[1];
    end
  end

  twentynm_clkena #(
    .clock_type("Global Clock"),
    .en_register_mode("always enabled"),
    .lpm_type("twentynm_clkena"))
  clk_buf (
    .ena(1'b1),
    .enaout(),
    .inclk(ref_clk),
    .outclk(s_ref_clk));

  // assignments

  assign mcs_sync = r_mcs_sync;
  
  assign gpio_i[63:58] = gpio_o[63:58];

  assign gpio_ad5355_rfen = gpio_o[57];
  assign gpio_calsw_4_1 = gpio_o[56];
  assign gpio_calsw_3_1 = gpio_o[55];
  assign gpio_calsw_2_0 = gpio_o[54];
  assign gpio_calsw_1_0 = gpio_o[53];
  assign gpio_txnrx_1 = gpio_o[52];
  assign gpio_enable_1 = gpio_o[51];
  assign gpio_en_agc_1 = gpio_o[50];
  assign gpio_txnrx_0 = gpio_o[49];
  assign gpio_enable_0 = gpio_o[48];
  assign gpio_en_agc_0 = gpio_o[47];
  assign gpio_resetb_0 = gpio_o[46];
  assign gpio_sync = gpio_o[45];
  assign gpio_debug_4_0 = gpio_o[44];
  assign gpio_debug_3_0 = gpio_o[43];
  assign gpio_debug_2_0 = gpio_o[42];
  assign gpio_debug_1_0 = gpio_o[41];
  assign gpio_resetb_1 = gpio_o[40];
  assign gpio_ctl_1 = gpio_o[39:36];
  assign gpio_ctl_0 = gpio_o[35:32];

  assign gpio_i[47:40] = gpio_status_0;
  assign gpio_i[39:32] = gpio_status_1;
  assign gpio_i[48] = gpio_ad5355_lock;
  assign gpio_i[31:12] = gpio_o[31:12];
  assign gpio_i[11: 4] = gpio_bd_i;
  assign gpio_i[3:0] = gpio_o[3:0];

  assign gpio_debug_3_1 = 1'b0;
  assign gpio_debug_4_1 = 1'b0;

  // board gpio

  assign gpio_bd_o = gpio_o[3:0];

  // peripheral reset

  assign sys_resetn_s = sys_resetn & sys_hps_resetn;

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
    .rx_clk_in_0_p(rx_clk_in_0),
    .rx_clk_in_0_n(1'b0),
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
    .rx_clk_in_1_p(rx_clk_in_1),
    .rx_clk_in_1_n(1'b0),
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
    .s_axi_clk_clk(s_axi_clk),
    .s_axi_aresetn_reset_n(s_axi_aresetn),
    .m_axi_awaddr(w_axi_awaddr),
    .m_axi_awprot(w_axi_awprot),
    .m_axi_awvalid(w_axi_awvalid),
    .m_axi_awready(w_axi_awready),
    .m_axi_wdata(w_axi_wdata),
    .m_axi_wstrb(w_axi_wstrb),
    .m_axi_wvalid(w_axi_wvalid),
    .m_axi_wready(w_axi_wready),
    .m_axi_bresp(w_axi_bresp),
    .m_axi_bvalid(w_axi_bvalid),
    .m_axi_bready(w_axi_bready),
    .m_axi_araddr(w_axi_araddr),
    .m_axi_arprot(w_axi_arprot),
    .m_axi_arvalid(w_axi_arvalid),
    .m_axi_arready(w_axi_arready),
    .m_axi_rdata(w_axi_rdata),
    .m_axi_rresp(w_axi_rresp),
    .m_axi_rvalid(w_axi_rvalid),
    .m_axi_rready(w_axi_rready),

    .sys_delay_clk_clk(s_delay_clk),

    .sys_clk_clk(sys_clk),

    .sys_gpio_bd_in_port(gpio_i[31:0]),
    .sys_gpio_bd_out_port(gpio_o[31:0]),
    .sys_gpio_in_export(gpio_i[63:32]),
    .sys_gpio_out_export(gpio_o[63:32]),

    .sys_hps_rstn_reset_n (sys_resetn),
    .sys_rstn_reset_n (sys_resetn_s),

    .sys_hps_io_hps_io_phery_emac0_TX_CLK (hps_eth_txclk),
    .sys_hps_io_hps_io_phery_emac0_TXD0 (hps_eth_txd[0]),
    .sys_hps_io_hps_io_phery_emac0_TXD1 (hps_eth_txd[1]),
    .sys_hps_io_hps_io_phery_emac0_TXD2 (hps_eth_txd[2]),
    .sys_hps_io_hps_io_phery_emac0_TXD3 (hps_eth_txd[3]),
    .sys_hps_io_hps_io_phery_emac0_RX_CTL (hps_eth_rxctl),
    .sys_hps_io_hps_io_phery_emac0_TX_CTL (hps_eth_txctl),
    .sys_hps_io_hps_io_phery_emac0_RX_CLK (hps_eth_rxclk),
    .sys_hps_io_hps_io_phery_emac0_RXD0 (hps_eth_rxd[0]),
    .sys_hps_io_hps_io_phery_emac0_RXD1 (hps_eth_rxd[1]),
    .sys_hps_io_hps_io_phery_emac0_RXD2 (hps_eth_rxd[2]),
    .sys_hps_io_hps_io_phery_emac0_RXD3 (hps_eth_rxd[3]),
    .sys_hps_io_hps_io_phery_emac0_MDIO (hps_eth_mdio),
    .sys_hps_io_hps_io_phery_emac0_MDC (hps_eth_mdc),
    .sys_hps_io_hps_io_phery_sdmmc_CMD (hps_sdio_cmd),
    .sys_hps_io_hps_io_phery_sdmmc_D0 (hps_sdio_d[0]),
    .sys_hps_io_hps_io_phery_sdmmc_D1 (hps_sdio_d[1]),
    .sys_hps_io_hps_io_phery_sdmmc_D2 (hps_sdio_d[2]),
    .sys_hps_io_hps_io_phery_sdmmc_D3 (hps_sdio_d[3]),
    .sys_hps_io_hps_io_phery_sdmmc_D4 (hps_sdio_d[4]),
    .sys_hps_io_hps_io_phery_sdmmc_D5 (hps_sdio_d[5]),
    .sys_hps_io_hps_io_phery_sdmmc_D6 (hps_sdio_d[6]),
    .sys_hps_io_hps_io_phery_sdmmc_D7 (hps_sdio_d[7]),
    .sys_hps_io_hps_io_phery_sdmmc_CCLK (hps_sdio_clk),
    .sys_hps_io_hps_io_phery_usb0_DATA0 (hps_usb_d[0]),
    .sys_hps_io_hps_io_phery_usb0_DATA1 (hps_usb_d[1]),
    .sys_hps_io_hps_io_phery_usb0_DATA2 (hps_usb_d[2]),
    .sys_hps_io_hps_io_phery_usb0_DATA3 (hps_usb_d[3]),
    .sys_hps_io_hps_io_phery_usb0_DATA4 (hps_usb_d[4]),
    .sys_hps_io_hps_io_phery_usb0_DATA5 (hps_usb_d[5]),
    .sys_hps_io_hps_io_phery_usb0_DATA6 (hps_usb_d[6]),
    .sys_hps_io_hps_io_phery_usb0_DATA7 (hps_usb_d[7]),
    .sys_hps_io_hps_io_phery_usb0_CLK (hps_usb_clk),
    .sys_hps_io_hps_io_phery_usb0_STP (hps_usb_stp),
    .sys_hps_io_hps_io_phery_usb0_DIR (hps_usb_dir),
    .sys_hps_io_hps_io_phery_usb0_NXT (hps_usb_nxt),
    .sys_hps_io_hps_io_phery_uart1_RX (hps_uart_rx),
    .sys_hps_io_hps_io_phery_uart1_TX (hps_uart_tx),
    .sys_hps_io_hps_io_phery_i2c1_SDA (hps_i2c_sda),
    .sys_hps_io_hps_io_phery_i2c1_SCL (hps_i2c_scl),
    .sys_hps_io_hps_io_gpio_gpio1_io5 (hps_gpio[0]),
    .sys_hps_io_hps_io_gpio_gpio1_io14 (hps_gpio[1]),
    .sys_hps_io_hps_io_gpio_gpio1_io16 (hps_gpio[2]),
    .sys_hps_io_hps_io_gpio_gpio1_io17 (hps_gpio[3]),

    .sys_hps_out_rstn_reset_n (sys_hps_resetn),
    .sys_hps_fpga_irq1_irq ({32{1'b0}}),

    .sys_hps_dma_data_awid(0),
    .sys_hps_dma_data_awaddr(adc_hp0_axi_awaddr),
    .sys_hps_dma_data_awlen(adc_hp0_axi_awlen),
    .sys_hps_dma_data_awsize(adc_hp0_axi_awsize),
    .sys_hps_dma_data_awburst(adc_hp0_axi_awburst),
    .sys_hps_dma_data_awlock(0),
    .sys_hps_dma_data_awcache(adc_hp0_axi_awcache),
    .sys_hps_dma_data_awprot(adc_hp0_axi_awprot),
    .sys_hps_dma_data_awvalid(adc_hp0_axi_awvalid),
    .sys_hps_dma_data_awready(adc_hp0_axi_awready),
    .sys_hps_dma_data_awuser(0),
    .sys_hps_dma_data_wid(0),
    .sys_hps_dma_data_wdata(adc_hp0_axi_wdata),
    .sys_hps_dma_data_wstrb(adc_hp0_axi_wstrb),
    .sys_hps_dma_data_wlast(adc_hp0_axi_wlast),
    .sys_hps_dma_data_wvalid(adc_hp0_axi_wvalid),
    .sys_hps_dma_data_wready(adc_hp0_axi_wready),
    .sys_hps_dma_data_bid(),
    .sys_hps_dma_data_bresp(adc_hp0_axi_bresp),
    .sys_hps_dma_data_bvalid(adc_hp0_axi_bvalid),
    .sys_hps_dma_data_bready(adc_hp0_axi_bready),
    .sys_hps_dma_data_arid(0),
    .sys_hps_dma_data_araddr(dac_hp1_axi_araddr),
    .sys_hps_dma_data_arlen(dac_hp1_axi_arlen),
    .sys_hps_dma_data_arsize(dac_hp1_axi_arsize),
    .sys_hps_dma_data_arburst(dac_hp1_axi_arburst),
    .sys_hps_dma_data_arlock(0),
    .sys_hps_dma_data_arcache(dac_hp1_axi_arcache),
    .sys_hps_dma_data_arprot(dac_hp1_axi_arprot),
    .sys_hps_dma_data_arvalid(dac_hp1_axi_arvalid),
    .sys_hps_dma_data_arready(dac_hp1_axi_arready),
    .sys_hps_dma_data_aruser(0),
    .sys_hps_dma_data_rid(),
    .sys_hps_dma_data_rdata(dac_hp1_axi_rdata),
    .sys_hps_dma_data_rresp(dac_hp1_axi_rresp),
    .sys_hps_dma_data_rlast(dac_hp1_axi_rlast),
    .sys_hps_dma_data_rvalid(dac_hp1_axi_rvalid),
    .sys_hps_dma_data_rready(dac_hp1_axi_rready),

    .sys_hps_ddr_mem_ck(hps_ddr_clk_p),
    .sys_hps_ddr_mem_ck_n(hps_ddr_clk_n),
    .sys_hps_ddr_mem_a(hps_ddr_a),
    .sys_hps_ddr_mem_act_n(hps_ddr_act_n),
    .sys_hps_ddr_mem_ba(hps_ddr_ba),
    .sys_hps_ddr_mem_bg(hps_ddr_bg),
    .sys_hps_ddr_mem_cke(hps_ddr_cke),
    .sys_hps_ddr_mem_cs_n(hps_ddr_cs_n),
    .sys_hps_ddr_mem_odt(hps_ddr_odt),
    .sys_hps_ddr_mem_reset_n(hps_ddr_reset_n),
    .sys_hps_ddr_mem_par(hps_ddr_par),
    .sys_hps_ddr_mem_alert_n(hps_ddr_alert_n),
    .sys_hps_ddr_mem_dqs(hps_ddr_dqs_p),
    .sys_hps_ddr_mem_dqs_n(hps_ddr_dqs_n),
    .sys_hps_ddr_mem_dq(hps_ddr_dq),
    .sys_hps_ddr_mem_dbi_n(hps_ddr_dbi_n),
    .sys_hps_ddr_oct_oct_rzqin(hps_ddr_rzq),
    .sys_hps_ddr_ref_clk_clk(hps_ddr_ref_clk),
    .sys_hps_ddr_rstn_reset_n(sys_resetn),

    .sys_spi_MISO(spi_miso),
    .sys_spi_MOSI(spi_mosi),
    .sys_spi_SCLK(spi_clk),
    .sys_spi_SS_n({spi_ssn_spacer, spi_ad5355, spi_ad9361_1, spi_ad9361_0}),
    .irq_irq({s_dac_dma_irq, s_adc_dma_irq, {2{1'b0}}})
  );
endmodule
