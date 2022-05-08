-------------------------------------------------------------------------------
-- Title      : MIDI controller
-- Project    : PM2_Audio_Synthesizer
-------------------------------------------------------------------------------
-- File       : midi_controller.vhd
-- Author     : camentho
-- Company    : 
-- Created    : 2022-05-08
-- Last update:
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Direct Digital Synthesis
-------------------------------------------------------------------------------
-- Copyright (c) 2022
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author				Description
-- 2022-05-08  1.0      camentho				Created 
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity midi_controller is
  port(
    clk_6m        : IN    std_logic;
    rx_data       : IN    std_logic_vector(7 downto 0);
    rx_data_rdy   : IN    std_logic;
    reset_n       : IN    std_logic;
    note_l        : OUT   std_logic_vector(6 downto 0);
    velocity      : OUT   std_logic_vector(6 downto 0) 
       );
end midi_controller;


architecture comb of midi_controller is

-------------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
begin



end comb;