//******************************************************************************
/// @FILE    system_wrapper_ps.v
/// @AUTHOR  JAY CONVERTINO
/// @DATE    2023.11.02
/// @BRIEF   System wrapper for ps system 7 arm 32bit.
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

module system_wrapper_ps
  (
    input   [63:0]  GPIO_I,
    output  [63:0]  GPIO_O,
    output  [63:0]  GPIO_T,
    input           SPI0_SCLK_I,
    output          SPI0_SCLK_O,
    output          SPI0_SCLK_T,
    input           SPI0_MOSI_I,
    output          SPI0_MOSI_O,
    output          SPI0_MOSI_T,
    input           SPI0_MISO_I,
    output          SPI0_MISO_O,
    output          SPI0_MISO_T,
    input           SPI0_SS_I,
    output          SPI0_SS_O,
    output          SPI0_SS1_O,
    output          SPI0_SS2_O,
    output          SPI0_SS_T,
    input           SPI1_SCLK_I,
    output          SPI1_SCLK_O,
    output          SPI1_SCLK_T,
    input           SPI1_MOSI_I,
    output          SPI1_MOSI_O,
    output          SPI1_MOSI_T,
    input           SPI1_MISO_I,
    output          SPI1_MISO_O,
    output          SPI1_MISO_T,
    input           SPI1_SS_I,
    output          SPI1_SS_O,
    output          SPI1_SS1_O,
    output          SPI1_SS2_O,
    output          SPI1_SS_T,
    input           USB0_VBUS_PWRFAULT,
    output          M_AXI_GP0_ARVALID,
    output          M_AXI_GP0_AWVALID,
    output          M_AXI_GP0_BREADY,
    output          M_AXI_GP0_RREADY,
    output          M_AXI_GP0_WLAST,
    output          M_AXI_GP0_WVALID,
    output  [11:0]  M_AXI_GP0_ARID,
    output  [11:0]  M_AXI_GP0_AWID,
    output  [11:0]  M_AXI_GP0_WID,
    output  [ 1:0]  M_AXI_GP0_ARBURST,
    output  [ 1:0]  M_AXI_GP0_ARLOCK,
    output  [ 2:0]  M_AXI_GP0_ARSIZE,
    output  [ 1:0]  M_AXI_GP0_AWBURST,
    output  [ 1:0]  M_AXI_GP0_AWLOCK,
    output  [ 2:0]  M_AXI_GP0_AWSIZE,
    output  [ 2:0]  M_AXI_GP0_ARPROT,
    output  [ 2:0]  M_AXI_GP0_AWPROT,
    output  [31:0]  M_AXI_GP0_ARADDR,
    output  [31:0]  M_AXI_GP0_AWADDR,
    output  [31:0]  M_AXI_GP0_WDATA,
    output  [ 3:0]  M_AXI_GP0_ARCACHE,
    output  [ 3:0]  M_AXI_GP0_ARLEN,
    output  [ 3:0]  M_AXI_GP0_ARQOS,
    output  [ 3:0]  M_AXI_GP0_AWCACHE,
    output  [ 3:0]  M_AXI_GP0_AWLEN,
    output  [ 3:0]  M_AXI_GP0_AWQOS,
    output  [ 3:0]  M_AXI_GP0_WSTRB,
    input           M_AXI_GP0_ACLK,
    input           M_AXI_GP0_ARREADY,
    input           M_AXI_GP0_AWREADY,
    input           M_AXI_GP0_BVALID,
    input           M_AXI_GP0_RLAST,
    input           M_AXI_GP0_RVALID,
    input           M_AXI_GP0_WREADY,
    input   [11:0]  M_AXI_GP0_BID,
    input   [11:0]  M_AXI_GP0_RID,
    input   [ 1:0]  M_AXI_GP0_BRESP,
    input   [ 1:0]  M_AXI_GP0_RRESP,
    input   [31:0]  M_AXI_GP0_RDATA,
    output          S_AXI_HP0_ARREADY,
    output          S_AXI_HP0_AWREADY,
    output          S_AXI_HP0_BVALID,
    output          S_AXI_HP0_RLAST,
    output          S_AXI_HP0_RVALID,
    output          S_AXI_HP0_WREADY,
    output  [ 1:0]  S_AXI_HP0_BRESP,
    output  [ 1:0]  S_AXI_HP0_RRESP,
    output  [ 5:0]  S_AXI_HP0_BID,
    output  [ 5:0]  S_AXI_HP0_RID,
    output  [63:0]  S_AXI_HP0_RDATA,
    output  [ 7:0]  S_AXI_HP0_RCOUNT,
    output  [ 7:0]  S_AXI_HP0_WCOUNT,
    output  [ 2:0]  S_AXI_HP0_RACOUNT,
    output  [ 5:0]  S_AXI_HP0_WACOUNT,
    input           S_AXI_HP0_ACLK,
    input           S_AXI_HP0_ARVALID,
    input           S_AXI_HP0_AWVALID,
    input           S_AXI_HP0_BREADY,
    input           S_AXI_HP0_RDISSUECAP1_EN,
    input           S_AXI_HP0_RREADY,
    input           S_AXI_HP0_WLAST,
    input           S_AXI_HP0_WRISSUECAP1_EN,
    input           S_AXI_HP0_WVALID,
    input   [ 1:0]  S_AXI_HP0_ARBURST,
    input   [ 1:0]  S_AXI_HP0_ARLOCK,
    input   [ 2:0]  S_AXI_HP0_ARSIZE,
    input   [ 1:0]  S_AXI_HP0_AWBURST,
    input   [ 1:0]  S_AXI_HP0_AWLOCK,
    input   [ 2:0]  S_AXI_HP0_AWSIZE,
    input   [ 2:0]  S_AXI_HP0_ARPROT,
    input   [ 2:0]  S_AXI_HP0_AWPROT,
    input   [31:0]  S_AXI_HP0_ARADDR,
    input   [31:0]  S_AXI_HP0_AWADDR,
    input   [ 3:0]  S_AXI_HP0_ARCACHE,
    input   [ 3:0]  S_AXI_HP0_ARLEN,
    input   [ 3:0]  S_AXI_HP0_ARQOS,
    input   [ 3:0]  S_AXI_HP0_AWCACHE,
    input   [ 3:0]  S_AXI_HP0_AWLEN,
    input   [ 3:0]  S_AXI_HP0_AWQOS,
    input   [ 5:0]  S_AXI_HP0_ARID,
    input   [ 5:0]  S_AXI_HP0_AWID,
    input   [ 5:0]  S_AXI_HP0_WID,
    input   [63:0]  S_AXI_HP0_WDATA,
    input   [ 7:0]  S_AXI_HP0_WSTRB,
    output          S_AXI_HP1_ARREADY,
    output          S_AXI_HP1_AWREADY,
    output          S_AXI_HP1_BVALID,
    output          S_AXI_HP1_RLAST,
    output          S_AXI_HP1_RVALID,
    output          S_AXI_HP1_WREADY,
    output  [ 1:0]  S_AXI_HP1_BRESP,
    output  [ 1:0]  S_AXI_HP1_RRESP,
    output  [ 5:0]  S_AXI_HP1_BID,
    output  [ 5:0]  S_AXI_HP1_RID,
    output  [63:0]  S_AXI_HP1_RDATA,
    output  [ 7:0]  S_AXI_HP1_RCOUNT,
    output  [ 7:0]  S_AXI_HP1_WCOUNT,
    output  [ 2:0]  S_AXI_HP1_RACOUNT,
    output  [ 5:0]  S_AXI_HP1_WACOUNT,
    input           S_AXI_HP1_ACLK,
    input           S_AXI_HP1_ARVALID,
    input           S_AXI_HP1_AWVALID,
    input           S_AXI_HP1_BREADY,
    input           S_AXI_HP1_RDISSUECAP1_EN,
    input           S_AXI_HP1_RREADY,
    input           S_AXI_HP1_WLAST,
    input           S_AXI_HP1_WRISSUECAP1_EN,
    input           S_AXI_HP1_WVALID,
    input   [ 1:0]  S_AXI_HP1_ARBURST,
    input   [ 1:0]  S_AXI_HP1_ARLOCK,
    input   [ 2:0]  S_AXI_HP1_ARSIZE,
    input   [ 1:0]  S_AXI_HP1_AWBURST,
    input   [ 1:0]  S_AXI_HP1_AWLOCK,
    input   [ 2:0]  S_AXI_HP1_AWSIZE,
    input   [ 2:0]  S_AXI_HP1_ARPROT,
    input   [ 2:0]  S_AXI_HP1_AWPROT,
    input   [31:0]  S_AXI_HP1_ARADDR,
    input   [31:0]  S_AXI_HP1_AWADDR,
    input   [ 3:0]  S_AXI_HP1_ARCACHE,
    input   [ 3:0]  S_AXI_HP1_ARLEN,
    input   [ 3:0]  S_AXI_HP1_ARQOS,
    input   [ 3:0]  S_AXI_HP1_AWCACHE,
    input   [ 3:0]  S_AXI_HP1_AWLEN,
    input   [ 3:0]  S_AXI_HP1_AWQOS,
    input   [ 5:0]  S_AXI_HP1_ARID,
    input   [ 5:0]  S_AXI_HP1_AWID,
    input   [ 5:0]  S_AXI_HP1_WID,
    input   [63:0]  S_AXI_HP1_WDATA,
    input   [ 7:0]  S_AXI_HP1_WSTRB,
    input   [15:0]  IRQ_F2P,
    output          FCLK_CLK0,
    output          FCLK_CLK1,
    output          FCLK_RESET1_N,
    inout   [53:0]  MIO,
    inout           DDR_CAS_n,
    inout           DDR_CKE,
    inout           DDR_Clk_n,
    inout           DDR_Clk,
    inout           DDR_CS_n,
    inout           DDR_DRSTB,
    inout           DDR_ODT,
    inout           DDR_RAS_n,
    inout           DDR_WEB,
    inout   [ 2:0]  DDR_BankAddr,
    inout   [14:0]  DDR_Addr,
    inout           DDR_VRN,
    inout           DDR_VRP,
    inout   [ 3:0]  DDR_DM,
    inout   [31:0]  DDR_DQ,
    inout   [ 3:0]  DDR_DQS_n,
    inout   [ 3:0]  DDR_DQS,
    inout           PS_SRSTB,
    inout           PS_CLK,
    inout           PS_PORB,
    output          PERIPHERAL_ARESETN
  );

  wire      s_fclk_reset0_n;
  wire      s_fclk_clk0;

  assign    FCLK_CLK0 = s_fclk_clk0;

  ps_sys_7 inst_ps_sys_7 (
    .GPIO_I(GPIO_I),                                      // input wire [63 : 0] GPIO_I
    .GPIO_O(GPIO_O),                                      // output wire [63 : 0] GPIO_O
    .GPIO_T(GPIO_T),                                      // output wire [63 : 0] GPIO_T
    .SPI0_SCLK_I(SPI0_SCLK_I),                            // input wire SPI0_SCLK_I
    .SPI0_SCLK_O(SPI0_SCLK_O),                            // output wire SPI0_SCLK_O
    .SPI0_SCLK_T(SPI0_SCLK_T),                            // output wire SPI0_SCLK_T
    .SPI0_MOSI_I(SPI0_MOSI_I),                            // input wire SPI0_MOSI_I
    .SPI0_MOSI_O(SPI0_MOSI_O),                            // output wire SPI0_MOSI_O
    .SPI0_MOSI_T(SPI0_MOSI_T),                            // output wire SPI0_MOSI_T
    .SPI0_MISO_I(SPI0_MISO_I),                            // input wire SPI0_MISO_I
    .SPI0_MISO_O(SPI0_MISO_O),                            // output wire SPI0_MISO_O
    .SPI0_MISO_T(SPI0_MISO_T),                            // output wire SPI0_MISO_T
    .SPI0_SS_I(SPI0_SS_I),                                // input wire SPI0_SS_I
    .SPI0_SS_O(SPI0_SS_O),                                // output wire SPI0_SS_O
    .SPI0_SS1_O(SPI0_SS1_O),                              // output wire SPI0_SS1_O
    .SPI0_SS2_O(SPI0_SS2_O),                              // output wire SPI0_SS2_O
    .SPI0_SS_T(SPI0_SS_T),                                // output wire SPI0_SS_T
    .SPI1_SCLK_I(SPI1_SCLK_I),                            // input wire SPI1_SCLK_I
    .SPI1_SCLK_O(SPI1_SCLK_O),                            // output wire SPI1_SCLK_O
    .SPI1_SCLK_T(SPI1_SCLK_T),                            // output wire SPI1_SCLK_T
    .SPI1_MOSI_I(SPI1_MOSI_I),                            // input wire SPI1_MOSI_I
    .SPI1_MOSI_O(SPI1_MOSI_O),                            // output wire SPI1_MOSI_O
    .SPI1_MOSI_T(SPI1_MOSI_T),                            // output wire SPI1_MOSI_T
    .SPI1_MISO_I(SPI1_MISO_I),                            // input wire SPI1_MISO_I
    .SPI1_MISO_O(SPI1_MISO_O),                            // output wire SPI1_MISO_O
    .SPI1_MISO_T(SPI1_MISO_T),                            // output wire SPI1_MISO_T
    .SPI1_SS_I(SPI1_SS_I),                                // input wire SPI1_SS_I
    .SPI1_SS_O(SPI1_SS_O),                                // output wire SPI1_SS_O
    .SPI1_SS1_O(SPI1_SS1_O),                              // output wire SPI1_SS1_O
    .SPI1_SS2_O(SPI1_SS2_O),                              // output wire SPI1_SS2_O
    .SPI1_SS_T(SPI1_SS_T),                                // output wire SPI1_SS_T
    .USB0_PORT_INDCTL(),                                  // output wire [1 : 0] USB0_PORT_INDCTL
    .USB0_VBUS_PWRSELECT(),                               // output wire USB0_VBUS_PWRSELECT
    .USB0_VBUS_PWRFAULT(USB0_VBUS_PWRFAULT),              // input wire USB0_VBUS_PWRFAULT
    .M_AXI_GP0_ARVALID(M_AXI_GP0_ARVALID),                // output wire M_AXI_GP0_ARVALID
    .M_AXI_GP0_AWVALID(M_AXI_GP0_AWVALID),                // output wire M_AXI_GP0_AWVALID
    .M_AXI_GP0_BREADY(M_AXI_GP0_BREADY),                  // output wire M_AXI_GP0_BREADY
    .M_AXI_GP0_RREADY(M_AXI_GP0_RREADY),                  // output wire M_AXI_GP0_RREADY
    .M_AXI_GP0_WLAST(M_AXI_GP0_WLAST),                    // output wire M_AXI_GP0_WLAST
    .M_AXI_GP0_WVALID(M_AXI_GP0_WVALID),                  // output wire M_AXI_GP0_WVALID
    .M_AXI_GP0_ARID(M_AXI_GP0_ARID),                      // output wire [11 : 0] M_AXI_GP0_ARID
    .M_AXI_GP0_AWID(M_AXI_GP0_AWID),                      // output wire [11 : 0] M_AXI_GP0_AWID
    .M_AXI_GP0_WID(M_AXI_GP0_WID),                        // output wire [11 : 0] M_AXI_GP0_WID
    .M_AXI_GP0_ARBURST(M_AXI_GP0_ARBURST),                // output wire [1 : 0] M_AXI_GP0_ARBURST
    .M_AXI_GP0_ARLOCK(M_AXI_GP0_ARLOCK),                  // output wire [1 : 0] M_AXI_GP0_ARLOCK
    .M_AXI_GP0_ARSIZE(M_AXI_GP0_ARSIZE),                  // output wire [2 : 0] M_AXI_GP0_ARSIZE
    .M_AXI_GP0_AWBURST(M_AXI_GP0_AWBURST),                // output wire [1 : 0] M_AXI_GP0_AWBURST
    .M_AXI_GP0_AWLOCK(M_AXI_GP0_AWLOCK),                  // output wire [1 : 0] M_AXI_GP0_AWLOCK
    .M_AXI_GP0_AWSIZE(M_AXI_GP0_AWSIZE),                  // output wire [2 : 0] M_AXI_GP0_AWSIZE
    .M_AXI_GP0_ARPROT(M_AXI_GP0_ARPROT),                  // output wire [2 : 0] M_AXI_GP0_ARPROT
    .M_AXI_GP0_AWPROT(M_AXI_GP0_AWPROT),                  // output wire [2 : 0] M_AXI_GP0_AWPROT
    .M_AXI_GP0_ARADDR(M_AXI_GP0_ARADDR),                  // output wire [31 : 0] M_AXI_GP0_ARADDR
    .M_AXI_GP0_AWADDR(M_AXI_GP0_AWADDR),                  // output wire [31 : 0] M_AXI_GP0_AWADDR
    .M_AXI_GP0_WDATA(M_AXI_GP0_WDATA),                    // output wire [31 : 0] M_AXI_GP0_WDATA
    .M_AXI_GP0_ARCACHE(M_AXI_GP0_ARCACHE),                // output wire [3 : 0] M_AXI_GP0_ARCACHE
    .M_AXI_GP0_ARLEN(M_AXI_GP0_ARLEN),                    // output wire [3 : 0] M_AXI_GP0_ARLEN
    .M_AXI_GP0_ARQOS(M_AXI_GP0_ARQOS),                    // output wire [3 : 0] M_AXI_GP0_ARQOS
    .M_AXI_GP0_AWCACHE(M_AXI_GP0_AWCACHE),                // output wire [3 : 0] M_AXI_GP0_AWCACHE
    .M_AXI_GP0_AWLEN(M_AXI_GP0_AWLEN),                    // output wire [3 : 0] M_AXI_GP0_AWLEN
    .M_AXI_GP0_AWQOS(M_AXI_GP0_AWQOS),                    // output wire [3 : 0] M_AXI_GP0_AWQOS
    .M_AXI_GP0_WSTRB(M_AXI_GP0_WSTRB),                    // output wire [3 : 0] M_AXI_GP0_WSTRB
    .M_AXI_GP0_ACLK(M_AXI_GP0_ACLK),                      // input wire M_AXI_GP0_ACLK
    .M_AXI_GP0_ARREADY(M_AXI_GP0_ARREADY),                // input wire M_AXI_GP0_ARREADY
    .M_AXI_GP0_AWREADY(M_AXI_GP0_AWREADY),                // input wire M_AXI_GP0_AWREADY
    .M_AXI_GP0_BVALID(M_AXI_GP0_BVALID),                  // input wire M_AXI_GP0_BVALID
    .M_AXI_GP0_RLAST(M_AXI_GP0_RLAST),                    // input wire M_AXI_GP0_RLAST
    .M_AXI_GP0_RVALID(M_AXI_GP0_RVALID),                  // input wire M_AXI_GP0_RVALID
    .M_AXI_GP0_WREADY(M_AXI_GP0_WREADY),                  // input wire M_AXI_GP0_WREADY
    .M_AXI_GP0_BID(M_AXI_GP0_BID),                        // input wire [11 : 0] M_AXI_GP0_BID
    .M_AXI_GP0_RID(M_AXI_GP0_RID),                        // input wire [11 : 0] M_AXI_GP0_RID
    .M_AXI_GP0_BRESP(M_AXI_GP0_BRESP),                    // input wire [1 : 0] M_AXI_GP0_BRESP
    .M_AXI_GP0_RRESP(M_AXI_GP0_RRESP),                    // input wire [1 : 0] M_AXI_GP0_RRESP
    .M_AXI_GP0_RDATA(M_AXI_GP0_RDATA),                    // input wire [31 : 0] M_AXI_GP0_RDATA
    .S_AXI_HP0_ARREADY(S_AXI_HP0_ARREADY),                // output wire S_AXI_HP0_ARREADY
    .S_AXI_HP0_AWREADY(S_AXI_HP0_AWREADY),                // output wire S_AXI_HP0_AWREADY
    .S_AXI_HP0_BVALID(S_AXI_HP0_BVALID),                  // output wire S_AXI_HP0_BVALID
    .S_AXI_HP0_RLAST(S_AXI_HP0_RLAST),                    // output wire S_AXI_HP0_RLAST
    .S_AXI_HP0_RVALID(S_AXI_HP0_RVALID),                  // output wire S_AXI_HP0_RVALID
    .S_AXI_HP0_WREADY(S_AXI_HP0_WREADY),                  // output wire S_AXI_HP0_WREADY
    .S_AXI_HP0_BRESP(S_AXI_HP0_BRESP),                    // output wire [1 : 0] S_AXI_HP0_BRESP
    .S_AXI_HP0_RRESP(S_AXI_HP0_RRESP),                    // output wire [1 : 0] S_AXI_HP0_RRESP
    .S_AXI_HP0_BID(S_AXI_HP0_BID),                        // output wire [5 : 0] S_AXI_HP0_BID
    .S_AXI_HP0_RID(S_AXI_HP0_RID),                        // output wire [5 : 0] S_AXI_HP0_RID
    .S_AXI_HP0_RDATA(S_AXI_HP0_RDATA),                    // output wire [63 : 0] S_AXI_HP0_RDATA
    .S_AXI_HP0_RCOUNT(S_AXI_HP0_RCOUNT),                  // output wire [7 : 0] S_AXI_HP0_RCOUNT
    .S_AXI_HP0_WCOUNT(S_AXI_HP0_WCOUNT),                  // output wire [7 : 0] S_AXI_HP0_WCOUNT
    .S_AXI_HP0_RACOUNT(S_AXI_HP0_RACOUNT),                // output wire [2 : 0] S_AXI_HP0_RACOUNT
    .S_AXI_HP0_WACOUNT(S_AXI_HP0_WACOUNT),                // output wire [5 : 0] S_AXI_HP0_WACOUNT
    .S_AXI_HP0_ACLK(S_AXI_HP0_ACLK),                      // input wire S_AXI_HP0_ACLK
    .S_AXI_HP0_ARVALID(S_AXI_HP0_ARVALID),                // input wire S_AXI_HP0_ARVALID
    .S_AXI_HP0_AWVALID(S_AXI_HP0_AWVALID),                // input wire S_AXI_HP0_AWVALID
    .S_AXI_HP0_BREADY(S_AXI_HP0_BREADY),                  // input wire S_AXI_HP0_BREADY
    .S_AXI_HP0_RDISSUECAP1_EN(S_AXI_HP0_RDISSUECAP1_EN),  // input wire S_AXI_HP0_RDISSUECAP1_EN
    .S_AXI_HP0_RREADY(S_AXI_HP0_RREADY),                  // input wire S_AXI_HP0_RREADY
    .S_AXI_HP0_WLAST(S_AXI_HP0_WLAST),                    // input wire S_AXI_HP0_WLAST
    .S_AXI_HP0_WRISSUECAP1_EN(S_AXI_HP0_WRISSUECAP1_EN),  // input wire S_AXI_HP0_WRISSUECAP1_EN
    .S_AXI_HP0_WVALID(S_AXI_HP0_WVALID),                  // input wire S_AXI_HP0_WVALID
    .S_AXI_HP0_ARBURST(S_AXI_HP0_ARBURST),                // input wire [1 : 0] S_AXI_HP0_ARBURST
    .S_AXI_HP0_ARLOCK(S_AXI_HP0_ARLOCK),                  // input wire [1 : 0] S_AXI_HP0_ARLOCK
    .S_AXI_HP0_ARSIZE(S_AXI_HP0_ARSIZE),                  // input wire [2 : 0] S_AXI_HP0_ARSIZE
    .S_AXI_HP0_AWBURST(S_AXI_HP0_AWBURST),                // input wire [1 : 0] S_AXI_HP0_AWBURST
    .S_AXI_HP0_AWLOCK(S_AXI_HP0_AWLOCK),                  // input wire [1 : 0] S_AXI_HP0_AWLOCK
    .S_AXI_HP0_AWSIZE(S_AXI_HP0_AWSIZE),                  // input wire [2 : 0] S_AXI_HP0_AWSIZE
    .S_AXI_HP0_ARPROT(S_AXI_HP0_ARPROT),                  // input wire [2 : 0] S_AXI_HP0_ARPROT
    .S_AXI_HP0_AWPROT(S_AXI_HP0_AWPROT),                  // input wire [2 : 0] S_AXI_HP0_AWPROT
    .S_AXI_HP0_ARADDR(S_AXI_HP0_ARADDR),                  // input wire [31 : 0] S_AXI_HP0_ARADDR
    .S_AXI_HP0_AWADDR(S_AXI_HP0_AWADDR),                  // input wire [31 : 0] S_AXI_HP0_AWADDR
    .S_AXI_HP0_ARCACHE(S_AXI_HP0_ARCACHE),                // input wire [3 : 0] S_AXI_HP0_ARCACHE
    .S_AXI_HP0_ARLEN(S_AXI_HP0_ARLEN),                    // input wire [3 : 0] S_AXI_HP0_ARLEN
    .S_AXI_HP0_ARQOS(S_AXI_HP0_ARQOS),                    // input wire [3 : 0] S_AXI_HP0_ARQOS
    .S_AXI_HP0_AWCACHE(S_AXI_HP0_AWCACHE),                // input wire [3 : 0] S_AXI_HP0_AWCACHE
    .S_AXI_HP0_AWLEN(S_AXI_HP0_AWLEN),                    // input wire [3 : 0] S_AXI_HP0_AWLEN
    .S_AXI_HP0_AWQOS(S_AXI_HP0_AWQOS),                    // input wire [3 : 0] S_AXI_HP0_AWQOS
    .S_AXI_HP0_ARID(S_AXI_HP0_ARID),                      // input wire [5 : 0] S_AXI_HP0_ARID
    .S_AXI_HP0_AWID(S_AXI_HP0_AWID),                      // input wire [5 : 0] S_AXI_HP0_AWID
    .S_AXI_HP0_WID(S_AXI_HP0_WID),                        // input wire [5 : 0] S_AXI_HP0_WID
    .S_AXI_HP0_WDATA(S_AXI_HP0_WDATA),                    // input wire [63 : 0] S_AXI_HP0_WDATA
    .S_AXI_HP0_WSTRB(S_AXI_HP0_WSTRB),                    // input wire [7 : 0] S_AXI_HP0_WSTRB
    .S_AXI_HP1_ARREADY(S_AXI_HP1_ARREADY),                // output wire S_AXI_HP1_ARREADY
    .S_AXI_HP1_AWREADY(S_AXI_HP1_AWREADY),                // output wire S_AXI_HP1_AWREADY
    .S_AXI_HP1_BVALID(S_AXI_HP1_BVALID),                  // output wire S_AXI_HP1_BVALID
    .S_AXI_HP1_RLAST(S_AXI_HP1_RLAST),                    // output wire S_AXI_HP1_RLAST
    .S_AXI_HP1_RVALID(S_AXI_HP1_RVALID),                  // output wire S_AXI_HP1_RVALID
    .S_AXI_HP1_WREADY(S_AXI_HP1_WREADY),                  // output wire S_AXI_HP1_WREADY
    .S_AXI_HP1_BRESP(S_AXI_HP1_BRESP),                    // output wire [1 : 0] S_AXI_HP1_BRESP
    .S_AXI_HP1_RRESP(S_AXI_HP1_RRESP),                    // output wire [1 : 0] S_AXI_HP1_RRESP
    .S_AXI_HP1_BID(S_AXI_HP1_BID),                        // output wire [5 : 0] S_AXI_HP1_BID
    .S_AXI_HP1_RID(S_AXI_HP1_RID),                        // output wire [5 : 0] S_AXI_HP1_RID
    .S_AXI_HP1_RDATA(S_AXI_HP1_RDATA),                    // output wire [63 : 0] S_AXI_HP1_RDATA
    .S_AXI_HP1_RCOUNT(S_AXI_HP1_RCOUNT),                  // output wire [7 : 0] S_AXI_HP1_RCOUNT
    .S_AXI_HP1_WCOUNT(S_AXI_HP1_WCOUNT),                  // output wire [7 : 0] S_AXI_HP1_WCOUNT
    .S_AXI_HP1_RACOUNT(S_AXI_HP1_RACOUNT),                // output wire [2 : 0] S_AXI_HP1_RACOUNT
    .S_AXI_HP1_WACOUNT(S_AXI_HP1_WACOUNT),                // output wire [5 : 0] S_AXI_HP1_WACOUNT
    .S_AXI_HP1_ACLK(S_AXI_HP1_ACLK),                      // input wire S_AXI_HP1_ACLK
    .S_AXI_HP1_ARVALID(S_AXI_HP1_ARVALID),                // input wire S_AXI_HP1_ARVALID
    .S_AXI_HP1_AWVALID(S_AXI_HP1_AWVALID),                // input wire S_AXI_HP1_AWVALID
    .S_AXI_HP1_BREADY(S_AXI_HP1_BREADY),                  // input wire S_AXI_HP1_BREADY
    .S_AXI_HP1_RDISSUECAP1_EN(S_AXI_HP1_RDISSUECAP1_EN),  // input wire S_AXI_HP1_RDISSUECAP1_EN
    .S_AXI_HP1_RREADY(S_AXI_HP1_RREADY),                  // input wire S_AXI_HP1_RREADY
    .S_AXI_HP1_WLAST(S_AXI_HP1_WLAST),                    // input wire S_AXI_HP1_WLAST
    .S_AXI_HP1_WRISSUECAP1_EN(S_AXI_HP1_WRISSUECAP1_EN),  // input wire S_AXI_HP1_WRISSUECAP1_EN
    .S_AXI_HP1_WVALID(S_AXI_HP1_WVALID),                  // input wire S_AXI_HP1_WVALID
    .S_AXI_HP1_ARBURST(S_AXI_HP1_ARBURST),                // input wire [1 : 0] S_AXI_HP1_ARBURST
    .S_AXI_HP1_ARLOCK(S_AXI_HP1_ARLOCK),                  // input wire [1 : 0] S_AXI_HP1_ARLOCK
    .S_AXI_HP1_ARSIZE(S_AXI_HP1_ARSIZE),                  // input wire [2 : 0] S_AXI_HP1_ARSIZE
    .S_AXI_HP1_AWBURST(S_AXI_HP1_AWBURST),                // input wire [1 : 0] S_AXI_HP1_AWBURST
    .S_AXI_HP1_AWLOCK(S_AXI_HP1_AWLOCK),                  // input wire [1 : 0] S_AXI_HP1_AWLOCK
    .S_AXI_HP1_AWSIZE(S_AXI_HP1_AWSIZE),                  // input wire [2 : 0] S_AXI_HP1_AWSIZE
    .S_AXI_HP1_ARPROT(S_AXI_HP1_ARPROT),                  // input wire [2 : 0] S_AXI_HP1_ARPROT
    .S_AXI_HP1_AWPROT(S_AXI_HP1_AWPROT),                  // input wire [2 : 0] S_AXI_HP1_AWPROT
    .S_AXI_HP1_ARADDR(S_AXI_HP1_ARADDR),                  // input wire [31 : 0] S_AXI_HP1_ARADDR
    .S_AXI_HP1_AWADDR(S_AXI_HP1_AWADDR),                  // input wire [31 : 0] S_AXI_HP1_AWADDR
    .S_AXI_HP1_ARCACHE(S_AXI_HP1_ARCACHE),                // input wire [3 : 0] S_AXI_HP1_ARCACHE
    .S_AXI_HP1_ARLEN(S_AXI_HP1_ARLEN),                    // input wire [3 : 0] S_AXI_HP1_ARLEN
    .S_AXI_HP1_ARQOS(S_AXI_HP1_ARQOS),                    // input wire [3 : 0] S_AXI_HP1_ARQOS
    .S_AXI_HP1_AWCACHE(S_AXI_HP1_AWCACHE),                // input wire [3 : 0] S_AXI_HP1_AWCACHE
    .S_AXI_HP1_AWLEN(S_AXI_HP1_AWLEN),                    // input wire [3 : 0] S_AXI_HP1_AWLEN
    .S_AXI_HP1_AWQOS(S_AXI_HP1_AWQOS),                    // input wire [3 : 0] S_AXI_HP1_AWQOS
    .S_AXI_HP1_ARID(S_AXI_HP1_ARID),                      // input wire [5 : 0] S_AXI_HP1_ARID
    .S_AXI_HP1_AWID(S_AXI_HP1_AWID),                      // input wire [5 : 0] S_AXI_HP1_AWID
    .S_AXI_HP1_WID(S_AXI_HP1_WID),                        // input wire [5 : 0] S_AXI_HP1_WID
    .S_AXI_HP1_WDATA(S_AXI_HP1_WDATA),                    // input wire [63 : 0] S_AXI_HP1_WDATA
    .S_AXI_HP1_WSTRB(S_AXI_HP1_WSTRB),                    // input wire [7 : 0] S_AXI_HP1_WSTRB
    .IRQ_F2P(IRQ_F2P),                                    // input wire [0 : 0] IRQ_F2P
    .FCLK_CLK0(s_fclk_clk0),                                // output wire FCLK_CLK0
    .FCLK_CLK1(FCLK_CLK1),                                // output wire FCLK_CLK1
    .FCLK_RESET0_N(s_fclk_reset0_n),                        // output wire FCLK_RESET0_N
    .FCLK_RESET1_N(FCLK_RESET1_N),                        // output wire FCLK_RESET1_N
    .MIO(MIO),                                            // inout wire [53 : 0] MIO
    .DDR_CAS_n(DDR_CAS_n),                                // inout wire DDR_CAS_n
    .DDR_CKE(DDR_CKE),                                    // inout wire DDR_CKE
    .DDR_Clk_n(DDR_Clk_n),                                // inout wire DDR_Clk_n
    .DDR_Clk(DDR_Clk),                                    // inout wire DDR_Clk
    .DDR_CS_n(DDR_CS_n),                                  // inout wire DDR_CS_n
    .DDR_DRSTB(DDR_DRSTB),                                // inout wire DDR_DRSTB
    .DDR_ODT(DDR_ODT),                                    // inout wire DDR_ODT
    .DDR_RAS_n(DDR_RAS_n),                                // inout wire DDR_RAS_n
    .DDR_WEB(DDR_WEB),                                    // inout wire DDR_WEB
    .DDR_BankAddr(DDR_BankAddr),                          // inout wire [2 : 0] DDR_BankAddr
    .DDR_Addr(DDR_Addr),                                  // inout wire [14 : 0] DDR_Addr
    .DDR_VRN(DDR_VRN),                                    // inout wire DDR_VRN
    .DDR_VRP(DDR_VRP),                                    // inout wire DDR_VRP
    .DDR_DM(DDR_DM),                                      // inout wire [3 : 0] DDR_DM
    .DDR_DQ(DDR_DQ),                                      // inout wire [31 : 0] DDR_DQ
    .DDR_DQS_n(DDR_DQS_n),                                // inout wire [3 : 0] DDR_DQS_n
    .DDR_DQS(DDR_DQS),                                    // inout wire [3 : 0] DDR_DQS
    .PS_SRSTB(PS_SRSTB),                                  // inout wire PS_SRSTB
    .PS_CLK(PS_CLK),                                      // inout wire PS_CLK
    .PS_PORB(PS_PORB)                                    // inout wire PS_PORB
  );

  ps_sys_reset inst_ps_sys_reset (
    .slowest_sync_clk(s_fclk_clk0),
    .ext_reset_in(s_fclk_reset0_n),
    .aux_reset_in(1'b1),
    .mb_debug_sys_rst(1'b0),
    .dcm_locked(1'b1),
    .mb_reset(),
    .bus_struct_reset(),
    .peripheral_reset(),
    .interconnect_aresetn(),
    .peripheral_aresetn(PERIPHERAL_ARESETN)
  );

endmodule
