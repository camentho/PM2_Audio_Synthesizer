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

architecture contr of midi_controller is

-------------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- constant Declaration
-------------------------------------------------------------------------------
constant WAIT_STATUS : integer := 0;
constant WAIT_DATA1  : integer := 1;
constant WAIT_DATA2  : integer := 2;

-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
begin
	fsm : process(all)
	
	variable status : integer range 0 to 2;
	
	begin
		case status is
			when WAIT_STATUS =>
				if rising_edge(rx_data_rdy) then
					status := WAIT_DATA1;
				end if;
				
			when WAIT_DATA1 =>
				if rising_edge(rx_data_rdy) then
					status := WAIT_DATA2;
				end if;
			
			when WAIT_DATA2 =>
				if rising_edge(rx_data_rdy) then
					status := WAIT_STATUS;
				end if;
			
			when others =>
				status := WAIT_STATUS;
				
		end case;
	end process fsm;
end contr;