-- Copyright (C) 2020  Intel Corporation. All rights reserved.
-- Your use of Intel Corporation's design tools, logic functions 
-- and other software and tools, and any partner logic 
-- functions, and any output files from any of the foregoing 
-- (including device programming or simulation files), and any 
-- associated documentation or information are expressly subject 
-- to the terms and conditions of the Intel Program License 
-- Subscription Agreement, the Intel Quartus Prime License Agreement,
-- the Intel FPGA IP License Agreement, or other applicable license
-- agreement, including, without limitation, that your use is for
-- the sole purpose of programming logic devices manufactured by
-- Intel and sold by Intel or its authorized distributors.  Please
-- refer to the applicable agreement for further details, at
-- https://fpgasoftware.intel.com/eula.

-- PROGRAM              "Quartus Prime"
-- VERSION              "Version 20.1.1 Build 720 11/11/2020 Patches 1.02i SJ Lite Edition"
-- CREATED              "Tue Dec 14 11:43:48 2021"

library ieee;
use ieee.std_logic_1164.all;

library work;

entity uart_top is
  port
    (
      clk_6M      : in  std_logic;
      reset_n     : in  std_logic;
      serial_in   : in  std_logic;
      rx_data_rdy : out std_logic;
      rx_data     : out std_logic_vector(7 downto 0);
      HEX0        : out std_logic_vector(6 downto 0);
      HEX1        : out std_logic_vector(6 downto 0);
		HEX2        : out std_logic_vector(6 downto 0);   -- Display 2
		HEX3        : out std_logic_vector(6 downto 0)    -- Display 3
      );
end uart_top;

architecture struct of uart_top is

  component flanken_detekt_vhdl
    port(data_in       : in  std_logic;
         clk           : in  std_logic;
         reset_n       : in  std_logic;
         rising_pulse  : out std_logic;
         falling_pulse : out std_logic
         );
  end component;

  component shiftreg_uart
    generic (width : integer
             );
    port(clk          : in  std_logic;
         reset_n      : in  std_logic;
         load_in      : in  std_logic;
         shift_en     : in  std_logic;
         serial_in    : in  std_logic;
         parallel_in  : in  std_logic_vector(9 downto 0);
         serial_out   : out std_logic;
         parallel_out : out std_logic_vector(9 downto 0)
         );
  end component;

  component baud_tick
    port(clk       : in  std_logic;
         reset_n   : in  std_logic;
         start_bit : in  std_logic;
         baud_tick : out std_logic
         );
  end component;

  component bit_counter
    port(clk       : in  std_logic;
         reset_n   : in  std_logic;
         baud_tick : in  std_logic;
         start_bit : in  std_logic;
         bit_count : out std_logic_vector(3 downto 0)
         );
  end component;

  component uart_controller_fsm
    port(clk           : in  std_logic;
         reset_n       : in  std_logic;
         falling_pulse : in  std_logic;
         baud_tick     : in  std_logic;
         bit_count     : in  std_logic_vector(3 downto 0);
         parallel_data : in  std_logic_vector(9 downto 0);
         shift_enable  : out std_logic;
         start_bit     : out std_logic;
         data_valid    : out std_logic
         );
  end component;

  component output_register
    port(clk        		   : in  std_logic;
         reset_n  		   : in  std_logic;
         data_valid		   : in  std_logic;
         parallel_in 		: in  std_logic_vector(9 downto 0);
         hex_lsb_out       : out std_logic_vector(3 downto 0);
         hex_msb_out       : out std_logic_vector(3 downto 0)
         );
  end component;

  component vhdl_hex2sevseg
    port(data_in  : in  std_logic_vector(3 downto 0);
         seg_o    : out std_logic_vector(6 downto 0)
         );
  end component;

  signal data                : std_logic_vector(9 downto 0);
  signal SYNTHESIZED_WIRE_32 : std_logic;
  signal SYNTHESIZED_WIRE_33 : std_logic;
  signal SYNTHESIZED_WIRE_34 : std_logic;
  signal SYNTHESIZED_WIRE_5  : std_logic;
  signal SYNTHESIZED_WIRE_6  : std_logic;
  signal SYNTHESIZED_WIRE_8  : std_logic_vector(0 to 9);
  signal SYNTHESIZED_WIRE_35 : std_logic;
  signal SYNTHESIZED_WIRE_36 : std_logic;
  signal SYNTHESIZED_WIRE_20 : std_logic;
  signal SYNTHESIZED_WIRE_22 : std_logic_vector(3 downto 0);
  signal SYNTHESIZED_WIRE_25 : std_logic;
  signal SYNTHESIZED_WIRE_26 : std_logic;
  signal SYNTHESIZED_WIRE_27 : std_logic;
  signal SYNTHESIZED_WIRE_28 : std_logic_vector(3 downto 0);
  signal SYNTHESIZED_WIRE_29 : std_logic;
  signal SYNTHESIZED_WIRE_30 : std_logic;
  signal SYNTHESIZED_WIRE_31 : std_logic_vector(3 downto 0);


begin

  SYNTHESIZED_WIRE_5  <= '0';
  SYNTHESIZED_WIRE_8  <= "0000000000";
  SYNTHESIZED_WIRE_26 <= '1';
  SYNTHESIZED_WIRE_27 <= '1';
  SYNTHESIZED_WIRE_29 <= '1';
  SYNTHESIZED_WIRE_30 <= '1';
  rx_data <= data(8 downto 1);
  rx_data_rdy <= SYNTHESIZED_WIRE_25;
  


  b2v_inst : flanken_detekt_vhdl
    port map(data_in       => serial_in,
             clk           => clk_6M,
             reset_n       => reset_n,
             falling_pulse => SYNTHESIZED_WIRE_20);


  b2v_inst10 : shiftreg_uart
    generic map(width => 10
                )
    port map(clk          => clk_6M,
             reset_n      => reset_n,
             load_in      => SYNTHESIZED_WIRE_5,
             shift_en     => SYNTHESIZED_WIRE_6,
             serial_in    => serial_in,
             parallel_in  => SYNTHESIZED_WIRE_8,
             parallel_out => data);



  b2v_inst2 : baud_tick
    port map(clk       => clk_6M,
             reset_n   => reset_n,
             start_bit => SYNTHESIZED_WIRE_35,
             baud_tick => SYNTHESIZED_WIRE_36);


  b2v_inst3 : bit_counter
    port map(clk       => clk_6M,
             reset_n   => reset_n,
             baud_tick => SYNTHESIZED_WIRE_36,
             start_bit => SYNTHESIZED_WIRE_35,
             bit_count => SYNTHESIZED_WIRE_22);



  b2v_inst5 : uart_controller_fsm
    port map(clk           => clk_6M,
             reset_n       => reset_n,
             falling_pulse => SYNTHESIZED_WIRE_20,
             baud_tick     => SYNTHESIZED_WIRE_36,
             bit_count     => SYNTHESIZED_WIRE_22,
             parallel_data => data,
             shift_enable  => SYNTHESIZED_WIRE_6,
             start_bit     => SYNTHESIZED_WIRE_35,
             data_valid    => SYNTHESIZED_WIRE_25);




end struct;
