-------------------------------------------------------------------------------
-- Title      : Infrastructure
-- Project    : 
-------------------------------------------------------------------------------
-- File	      : Infrastructure.vhd
-- Author     :	  <jansc@IDEAFLEX-HORIZO>
-- Company    : 
-- Created    : 2022-02-24
-- Last update: 2022-02-24
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: 
-------------------------------------------------------------------------------
-- Copyright (c) 2022 
-------------------------------------------------------------------------------
-- Revisions  :
-- Date	       Version	Author	Description
-- 2022-02-24  1.0	jansc	Created
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

-------------------------------------------------------------------------------

entity Infrastructure is

  port(
   clock_50M     : in  std_logic;
	key_0	     	  : in  std_logic;
	usb_txd	     : in  std_logic;
	clk_12M       : out std_logic;
	clk_6M	     : out std_logic;
	reset_n	     : out std_logic;
	usb_txd_sync  : out std_logic;
	ledr_0	     : out std_logic
	);

end entity Infrastructure;

-------------------------------------------------------------------------------

architecture str of Infrastructure is

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------

  signal clk6 : std_logic;

  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------

  component clock_sync
    port(
		data_in  : in	std_logic;
		clk	   : in	std_logic;
		sync_out : out std_logic
		);
  end component;

  component modulo_divider
    port(
		clk	    : in  std_logic;
		clk_div12 : out std_logic;
		clk_div6  : out std_logic
		);
  end component;

  component signal_checker
    port(
		clk       : in	 std_logic;
		reset_n   : in	 std_logic;
		data_in   : in	 std_logic;
		led_blink : out std_logic
		);
  end component;


begin  -- architecture str

  clk_6M  <= clk6;

  -----------------------------------------------------------------------------
  -- Component instantiations
  -----------------------------------------------------------------------------

  inst0 : modulo_divider
    port map (
      clk     => clock_50M,
      clk_div12 => clk_12M,
		clk_div6  => clk6);

  inst1 : clock_sync
    port map (
      data_in  => key_0,
      clk      => clk6,
      sync_out => reset_n);

  inst2 : clock_sync
    port map (
      data_in  => usb_txd,
      clk      => clk6,
      sync_out => usb_txd_sync);

  inst3 : signal_checker
    port map (
      data_in	=> usb_txd,
      reset_n	=> key_0,
      clk	=> clock_50M,
      led_blink => ledr_0);

end architecture str;

-------------------------------------------------------------------------------
