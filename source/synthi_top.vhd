-------------------------------------------------------------------------------
-- Title      : synthi_top
-- Project    : 
-------------------------------------------------------------------------------
-- File       : synthi_top.vhd
-- Author     : Hans-Joachim Gelke
-- Company    : 
-- Created    : 2018-03-08
-- Last update: 2022-03-30
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Top Level for Synthesizer
-------------------------------------------------------------------------------
-- Copyright (c) 2018 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author				Description
-- 2018-03-08  1.0      Hans-Joachim		Created
-- 2022-03-30  1.1		Roser					Customization	 
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
library work;
use ieee.numeric_std.all;
-------------------------------------------------------------------------------

entity synthi_top is

  port (
    CLOCK_50 	 : in std_logic;            			  -- DE2 clock from xtal 50MHz
    KEY_0    	 : in std_logic;            			  -- DE2 low_active input buttons
    KEY_1   	 : in std_logic;           			  -- DE2 low_active input buttons
    SW      	 : in std_logic_vector(9 downto 0);   -- DE2 input switches

    USB_RXD 	 : in std_logic;           			  -- USB (midi) serial_input
    USB_TXD		 : in std_logic;            			  -- USB (midi) serial_output

    BT_RXD  	 : in std_logic;            			  -- Bluetooth serial_input
    BT_TXD  	 : in std_logic;           			  -- Bluetooth serial_output
    BT_RST_N 	 : in std_logic;            			  -- Bluetooth reset_n


	 
	 AUD_ADCDAT  : in  std_logic;           			  -- audio serial data from Codec-ADC
    AUD_XCK     : out std_logic;          			  -- master clock for Audio Codec
    AUD_DACDAT  : out std_logic;              		  -- audio serial data to Codec-DAC
    AUD_BCLK    : out std_logic;          			  -- bit clock for audio serial data
    AUD_DACLRCK : out std_logic;           			  -- left/right word select for Codec-DAC
    AUD_ADCLRCK : out std_logic;           			  -- left/right word select for Codec-ADC

    AUD_SCLK 	 : out std_logic;           			  -- clock from I2C master block
    AUD_SDAT 	 : inout std_logic;         			  -- data         from I2C master block

    HEX0   		 : out std_logic_vector(6 downto 0);  -- output for HEX 0 display
    HEX1  		 : out std_logic_vector(6 downto 0);  -- output for HEX 0 display
    LEDR_0 		 : out std_logic;                     -- red LED
    LEDR_1 		 : out std_logic;                     -- red LED
    LEDR_2		 : out std_logic;                     -- red LED
    LEDR_3		 : out std_logic;                     -- red LED
    LEDR_4 		 : out std_logic;                     -- red LED
    LEDR_5 		 : out std_logic;                     -- red LED
    LEDR_6 		 : out std_logic;                     -- red LED
    LEDR_7 		 : out std_logic;                     -- red LED
    LEDR_8		 : out std_logic;                     -- red LED
    LEDR_9 		 : out std_logic                      -- red LED
    );

end entity synthi_top;


-------------------------------------------------------------------------------

architecture struct of synthi_top is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal clk_6M      : std_logic;       -- internal clock
  signal reset_n     : std_logic;       -- reset signal
  signal serial_data : std_logic;       -- serial data
  signal writes	   : std_logic;
  signal write_done  : std_logic;
  signal ack_error   : std_logic;
  signal ws				: std_logic;
  signal write_data  : std_logic_vector(15 downto 0);
  signal	dacdat_pl 	: std_logic_vector(15 downto 0);  -- path_controller
  signal dacdat_pr 	: std_logic_vector(15 downto 0);
  signal adcdat_pl 	: std_logic_vector(15 downto 0);  -- path_controller
  signal adcdat_pr 	: std_logic_vector(15 downto 0);
  signal dds_l 	 	: std_logic_vector(15 downto 0); -- Eingang vom Synthesizer
  signal dds_r 	 	: std_logic_vector(15 downto 0);
  

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component Infrastructure is
    port (
      clock_50M    : in  std_logic;     -- clock
      key_0        : in  std_logic;     -- reset button
      usb_txd      : in  std_logic;     -- midi in
      clk_6M       : out std_logic;     -- clock
		clk_12M		 : out std_logic; 	 -- clock
      reset_n      : out std_logic;     -- reset
      usb_txd_sync : out std_logic;     -- usb sync
      ledr_0       : out std_logic);    -- signal led
  end component Infrastructure;

  component uart_top is
    port (
      clk_6M       : in  std_logic;                      -- clock
      reset_n      : in  std_logic;                      -- int reset
      serial_in    : in  std_logic;                      -- data input
      hex0         : out std_logic_vector(6 downto 0);   -- Display 0
      hex1         : out std_logic_vector(6 downto 0);   -- Display 1
      rx_data      : out std_logic_vector(7 downto 0);   -- recieverd data
      rx_data_rdy  : out std_logic);                     -- data ready
  end component uart_top;
  
  component codec_controller is 
	 port (
		write_done_i : in  std_logic;       					-- Input from i2c register write_done
		ack_error_i  : in  std_logic;       					-- Inputs to check the transmission
		clk          : in  std_logic;
		reset_n      : in  std_logic;
		mode     	 : in  std_logic_vector(2 downto 0);   -- Inputs to choose Audio_MODE
		write_data_o : out std_logic_vector(15 downto 0);
		write_o      : out std_logic     					   -- Output to i2c to start transmission 	
		);
  end component codec_controller;
  
  component i2c_master is
    port (
		clk     		 : in  std_logic;
      reset_n      : in  std_logic;
      write_i      : in  std_logic;
		write_data_i : in	 std_logic_vector(15 downto 0);
		sda_io		 : inout std_logic;
   	scl_o	       : out std_logic;
		write_done_o : out std_logic;
		ack_error_o  : out std_logic
		);
	end component i2c_master;
	
	component i2s_master is 
	  port (
	   clk_6m   	 : in  std_logic;            				-- 6M Clock
      reset_n 	 	 : in  std_logic;  								-- Reset or init used for re-initialisation
      step_o 		 : out std_logic;          				-- Pulse once per audio frame 1/48kHz
      -- Verbindungen zum path_controller
		DACDAT_pl_i  : in  std_logic_vector(15 downto 0);  -- Eingang vom path_controller
      DACDAT_pr_i  : in  std_logic_vector(15 downto 0);
      ADCDAT_pl_o  : out std_logic_vector(15 downto 0);  -- Ausgang zum path_controller
      ADCDAT_pr_o  : out std_logic_vector(15 downto 0);
      -- Verbindungen zum Audio-Codec
		ADCDAT_s_i   : in  std_logic;       					-- Serielle Daten Eingang
      DACDAT_s_o   : out std_logic;      						-- Serielle Daten Ausgang
      WS_o         : out std_logic
		);
	 end component i2s_master;
	 
	 component path_control is
	  port (
	   sw_sync_3   : in  std_logic;							  	-- Wahl des Path
      -- Audio data generated inside FPGA
      dds_l_i 	 	: in  std_logic_vector(15 downto 0);  	-- Eingang vom Synthesizer
      dds_r_i 	 	: in  std_logic_vector(15 downto 0);
      -- Audio data coming from codec
      adcdat_pl_i : in  std_logic_vector(15 downto 0);   -- Eingang vom i2s_master
      adcdat_pr_i : in  std_logic_vector(15 downto 0);
      -- Audio data towards codec
      dacdat_pl_o : out std_logic_vector(15 downto 0);   -- Ausgang zum i2s_master
      dacdat_pr_o : out std_logic_vector(15 downto 0)
      );
	  end component path_control;

begin

	-----------------------------------------------------------------------------
	-- Architecture Description
	-----------------------------------------------------------------------------

  inst0 : Infrastructure
    port map (
      clock_50M    => CLOCK_50,
      key_0        => KEY_0,
      usb_txd      => USB_TXD,
      clk_6M       => clk_6M,
      reset_n      => reset_n,
      usb_txd_sync => serial_data,
      ledr_0       => LEDR_0,
		clk_12M		 => AUD_XCK
		);

  inst1 : uart_top
    port map (
      clk_6M    	 => clk_6M,
      reset_n   	 => reset_n,
      serial_in 	 => serial_data,
      hex0      	 => HEX0,
      hex1      	 => HEX1
		);
	
  inst2 : i2c_master
	 port map (
		clk    		 => clk_6M,
		reset_n		 => reset_n,
		write_i 		 => writes,
		write_data_i => write_data,
		write_done_o => write_done,
		ack_error_o  => ack_error,
		scl_o			 => AUD_SCLK,	
		sda_io		 => AUD_SDAT		
		);
	
  ins3 : i2s_master
    port map (
	   ADCDAT_s_i	 => AUD_ADCDAT,
		DACDAT_s_o	 => AUD_DACDAT,
		ADCDAT_pr_o	 => adcdat_pr,
		ADCDAT_pl_o	 => adcdat_pl,
		DACDAT_pr_i	 => dacdat_pr,
		DACDAT_pl_i	 => dacdat_pl,
		reset_n		 => reset_n,
		clk_6m		 => clk_6M,
		WS_o			 => ws
		);
	
  inst4 : codec_controller
    port map (
	   mode			 => SW(2 downto 0),
		clk			 => clk_6M,
		reset_n		 => reset_n,
		write_o		 => writes,
		write_data_o => write_data,
		write_done_i => write_done,
		ack_error_i  => ack_error
		);
	
  inst5 : path_control
    port map (
		dds_l_i		 => dds_l,				
		dds_r_i		 => dds_r,
	   dacdat_pl_o  => dacdat_pl,
		dacdat_pr_o  => dacdat_pr,
		adcdat_pl_i  => adcdat_pl,
		adcdat_pr_i  => adcdat_pr,
		sw_sync_3	 => SW(3)
		);
		

	AUD_DACLRCK			 <= ws;
	AUD_ADCLRCK			 <= ws;
	AUD_BCLK				<= clk_6M;
	
		
end architecture struct;

-------------------------------------------------------------------------------
