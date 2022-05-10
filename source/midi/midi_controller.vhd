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
use ieee.numeric_std.all;

entity midi_controller is
  port(
    clk_6m        : IN    std_logic;
    rx_data       : IN    std_logic_vector(7 downto 0);
    rx_data_rdy   : IN    std_logic;
    reset_n       : IN    std_logic;
	 note_valid		: OUT	  std_logic;
    note		      : OUT   std_logic_vector(6 downto 0);
    velocity      : OUT   std_logic_vector(6 downto 0) 
    );
end midi_controller;

architecture contr of midi_controller is

-------------------------------------------------------------------------------
-- Signal & constant Declaration
-------------------------------------------------------------------------------
 type fsm_type is (WAIT_STATUS, WAIT_DATA1, WAIT_DATA2);
 
 signal fsm_status, next_fsm_status	: fsm_type;
 
 signal status_reg,  next_status_reg   : std_logic_vector(7 downto 0);
 signal data1_reg,   next_data1_reg    : std_logic_vector(6 downto 0);
 signal data2_reg,   next_data2_reg    : std_logic_vector(6 downto 0);

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------

begin

  --------------------------------------------------
  -- PROCESS FOR FLIP-FLOPS
  --------------------------------------------------
  
  flip_flops_fsm : process(all)
  begin
    if reset_n = '0' then
      fsm_status <= WAIT_STATUS;

    elsif rising_edge(clk_6m) then
      fsm_status <= next_fsm_status;

    end if;
  end process;
  
    -- Status
  flip_flops_st_reg : process(all)
  begin
    if reset_n = '0' then
      status_reg <= (others => '0');

    elsif rising_edge(clk_6m) then
      status_reg <= next_status_reg;

    end if;
  end process;
  
  -- Note
  flip_flops_data1_reg : process(all)
  begin
    if reset_n = '0' then
      data1_reg <= (others => '0');

    elsif rising_edge(clk_6m) then
      data1_reg <= next_data1_reg;

    end if;
  end process;

  -- Velocity
  flip_flops_data2_reg : process(all)
  begin
    if reset_n = '0' then
      data2_reg <= (others => '0');

    elsif rising_edge(clk_6m) then
      data2_reg <= next_data2_reg;

    end if;
  end process;
  
  
  
	fsm : process(all)
	
	begin
	
	 -- default statements for loop
    next_fsm_status <= fsm_status;
	 next_status_reg <= status_reg;
	 next_data1_reg <= data1_reg;
	 next_data2_reg <= data2_reg;
	 
		case fsm_status is
		
			when WAIT_STATUS =>
				if (rx_data_rdy) then
					-- Status-Byte
					if rx_data(7) = '1' then
						next_status_reg <= rx_data;
						next_fsm_status <= WAIT_DATA1;
					-- No Status-Byte
					else
						next_data1_reg <= rx_data(6 downto 0);
						next_fsm_status <= WAIT_DATA2;
					end if;
				end if;
				
			-- safing note-data
			when WAIT_DATA1 =>
				if (rx_data_rdy) then
					next_data1_reg <= rx_data(6 downto 0);
					next_fsm_status <= WAIT_DATA2;
				end if;
			
			-- safing velocity-data
			when WAIT_DATA2 =>
				if (rx_data_rdy) then
					next_data2_reg <= rx_data(6 downto 0);
					next_fsm_status <= WAIT_STATUS;
				end if;
				
			when others =>
				next_fsm_status <= WAIT_STATUS;
				
		end case;
		
	end process fsm;
	
-------------------------------------------
-- End Architecture 
------------------------------------------- 	
end contr;