library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity max5 is
	port 
	(
	--clock cleaner  
	clk_50m           : in    std_logic;
	spi_clk           : out   std_logic;  --LMK SPI interface
	spi_sdio          : out   std_logic;
	spi_csn           : out   std_logic;
	lmk_reset         : in    std_logic;
	usb_maxv_d        : inout std_logic_vector(7 downto 0);
	usb_maxv_wr       : out   std_logic;
	usb_maxv_rdn      : out   std_logic;
	usb_maxv_txen     : out   std_logic; 
	usb_maxv_rxfn     : out   std_logic;
	usb_maxv_reset    : out   std_logic;
		
    --display port  
    dp_on             : out   std_logic;       -- Display port power enable
	dp_hot_plug       : in    std_logic; 
	
	--SDI  
	--23544
	sdi_xhd_rate           : in    std_logic;
	sdi_mf4_status         : in    std_logic;
	sdi_mf3_mosi           : in    std_logic;  
	sdi_mf0_bypass_present : out   std_logic;
	sdi_mf1_sleep_miso     : out   std_logic;
	sdi_mf2_mute_sclk      : out   std_logic;
	sdi_xcs_cs             : out   std_logic;
	
	--23428
	sdi_tx_sd_hdn          : out   std_logic;
	sdi_spi_cs0            : out   std_logic;    
	sdi_spi_mosi           : out   std_logic;
	sdi_spi_miso           : out   std_logic;
	sdi_spi_clk            : out   std_logic;	
	
	sdi_clk148_up          : out   std_logic;
	sdi_clk148_down        : out   std_logic;
	si516_fs               : out   std_logic;
	
	--ethernet
	eneta_reset            : out   std_logic;
	enetb_reset            : out   std_logic;
	eneta_intn             : in    std_logic;
	enetb_intn             : in    std_logic;
	
	pcie1v8_perstn         : out   std_logic;   -- connected to NPERSTL0 in A10, Dedicated fundamental reset pin for A10 soc Bottom Left PCIe HIP & CvP
	pcie1v8_perst1n        : out   std_logic;   -- connected to NPERSTL1 in A10, Dedicated fundamental reset pin for A10 soc Top Left PCIe HIP (When available);
	pcie_wake_n            : in    std_logic;
	pcie_prsnt2n           : in    std_logic;
	
	maxv_to_maxv           : inout std_logic_vector(13 downto 0);
	fpgaio_p               : inout std_logic_vector(12 downto 0);
	fpgaio_n               : inout std_logic_vector(12 downto 0);
	faprsnt_n              : in    std_logic;
	fbprsnt_n              : in    std_logic;
	faclkdir               : inout std_logic;
	fahbp_12_11            : inout std_logic_vector(12 downto 11);
	fahbp_21_14            : inout std_logic_vector(21 downto 14);
	fahbn_12_11            : inout std_logic_vector(12 downto 11);
	fahbn_21_14            : inout std_logic_vector(21 downto 14);
	fbhbp_21_18            : inout std_logic_vector(21 downto 18);
	fbhbn_21_18            : inout std_logic_vector(21 downto 18);
	fblap_33_28            : inout std_logic_vector(33 downto 28);
	fblan_33_28            : inout std_logic_vector(33 downto 28)
	
    );
end entity;

architecture rtl of max5 is

constant MAX_VER : std_logic_vector(15 downto 0) := x"C004";
constant PROJ_ID : std_logic_vector(15 downto 0) := x"AD5E";-- 6xx- 44382  A10 SOC Dev Kit  

signal   reset_n         : std_logic;
signal   sdi_status      : std_logic_vector(7 downto 0);

component   reset_generator is
    port (
    clk               : in  std_logic;
    reset_n_in        : in  std_logic;
    reset_n_out       : out std_logic
    );
end component;

component  q_sys is 
    port(
	clk_clk                             : in std_logic;
	reset_reset_n                       : in std_logic;
	system_max_id_0_sdi_status_export   : in std_logic_vector(7  downto 0);
	system_max_id_0_project_id_export   : in std_logic_vector(15 downto 0);
	system_max_id_0_version_export      : in std_logic_vector(15 downto 0)
	);
end component;

			
begin

--Glue logic for clock cleaner chip LMK04828     
spi_clk		    <=	usb_maxv_d(0);
spi_sdio	    <=	usb_maxv_d(1); -- In 4 wire spi mode this becomes spi_sdi
spi_csn		    <=	usb_maxv_d(2);		
usb_maxv_d(4)   <=	lmk_reset;	   -- In 4 wire spi mode this is spi_sdo
usb_maxv_d(3)   <=	'Z';	  
usb_maxv_d(5)   <=	'Z';	  
usb_maxv_d(6)   <=	'Z';	  
usb_maxv_d(7)   <=	'Z';
usb_maxv_wr		<=	'Z';
usb_maxv_rdn	<=	'Z';
usb_maxv_txen	<=	'Z';
usb_maxv_rxfn	<=	'Z';
usb_maxv_reset	<=	'Z';	
-----------------------------------------------------------------------------------------
maxv_to_maxv(0) <= fpgaio_p(0);     --fpgaio_p(0) -> maxv_to_maxv(0) -> user_led_fpga0
maxv_to_maxv(1) <= fpgaio_n(0);     --fpgaio_n(0) -> maxv_to_maxv(1) -> user_led_fpga1
maxv_to_maxv(2) <= fpgaio_p(1);     --fpgaio_p(1) -> maxv_to_maxv(2) -> user_led_fpga2
maxv_to_maxv(3) <= fpgaio_n(1);     --fpgaio_n(1) -> maxv_to_maxv(3) -> user_led_fpga3
fpgaio_p(2)     <= maxv_to_maxv(4); -- user_pb_fpga0 -> maxv_to_maxv(4)  -> fpgaio_p(2)
fpgaio_n(2)     <= maxv_to_maxv(5); -- user_pb_fpga1 -> maxv_to_maxv(5)  -> fpgaio_n(2)
fpgaio_p(3)     <= maxv_to_maxv(6); -- user_pb_fpga2 -> maxv_to_maxv(6)  -> fpgaio_p(3)
fpgaio_n(3)     <= maxv_to_maxv(7); -- user_pb_fpga3 -> maxv_to_maxv(7)  -> fpgaio_n(3)
fpgaio_p(4)     <= maxv_to_maxv(8)  ; --user_dipsw_fpga0 -> maxv_to_maxv(8)  -> fpgaio_p(4)
fpgaio_n(4)     <= maxv_to_maxv(9)  ; --user_dipsw_fpga1 -> maxv_to_maxv(9)  -> fpgaio_n(4)
fpgaio_p(5)     <= maxv_to_maxv(10) ; --user_dipsw_fpga2 -> maxv_to_maxv(10) -> fpgaio_p(5)  
fpgaio_n(5)     <= maxv_to_maxv(11) ; --user_dipsw_fpga3 -> maxv_to_maxv(11) -> fpgaio_n(5)
-----------------------------------------------------------------------------------------


eneta_reset     <= fpgaio_p(6) ; 
enetb_reset     <= fpgaio_p(7) ;        
fpgaio_n(6)     <= eneta_intn  ;   
fpgaio_n(7)     <= enetb_intn  ;   

--SDI mode  
sdi_clk148_up          <= fpgaio_n(11);   
sdi_clk148_down        <= fpgaio_p(12);   
si516_fs               <= fpgaio_n(12);  

--23428
sdi_tx_sd_hdn          <= fpgaio_p(11);    --SD_xHD      '0': set HD/3G/6G/12G data rate 
sdi_spi_clk            <= '0';             --MF3
sdi_spi_miso           <= '0';             --MF2
sdi_spi_mosi           <= '0';             --MF1  
sdi_spi_cs0            <= '0';             --MF0

--23544
sdi_mf0_bypass_present  <= '0';             -- MF0  
sdi_mf1_sleep_miso      <= '0';             -- MF1     --'0' Equalizer is always active
sdi_mf2_mute_sclk       <= '0';             -- MF2  
fpgaio_p(10)            <= sdi_mf3_mosi;    -- MF3     --Signal Detect Complement , '0':present
fpgaio_n(9)             <= sdi_mf4_status;  -- MF4     --loss of lock  '0': lock
fpgaio_p(9)             <= sdi_xhd_rate;     -- SD_xHD  --'0': HD/3G/6G/12G data rate detected 
sdi_xcs_cs <= '0';    
sdi_status <= "00000" & sdi_mf3_mosi & sdi_mf4_status & sdi_xhd_rate ;
   
--DP 
dp_on        <= fpgaio_p(8);                   
fpgaio_n(8)  <= dp_hot_plug; 

--PCIE 
pcie1v8_perst1n <= 'Z';
pcie1v8_perstn  <= fblap_33_28(33) ;  
fblan_33_28(33) <= 'Z';
fblap_33_28(32) <= 'Z';
fblan_33_28(32) <= 'Z';

--FMC
fblap_33_28(29) <= fpgaio_n(10);

 q_sys_inst:   q_sys port map
 (
	clk_clk                             => clk_50m,
	reset_reset_n                       => '1',
	system_max_id_0_sdi_status_export   => sdi_status,
	system_max_id_0_project_id_export   => PROJ_ID,
	system_max_id_0_version_export      => MAX_VER
	);



end rtl;
