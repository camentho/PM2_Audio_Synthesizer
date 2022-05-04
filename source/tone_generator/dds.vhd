-------------------------------------------------------------------------------
-- Title      : dds
-- Project    : PM2_Audio_Synthesizer
-------------------------------------------------------------------------------
-- File       : synthi_top.vhd
-- Author     : camentho
-- Company    : 
-- Created    : 2022-04-27
-- Last update: 2022-04-27
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Direct Digital Synthesis
-------------------------------------------------------------------------------
-- Copyright (c) 2022
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author				Description
-- 2022-04-27  1.0      camentho				Created 
-------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.tone_gen_pkg.all;

entity dds is
  port(
		 clk_6m      : in  std_logic;
		 reset_n     : in  std_logic;
		 phi_incr    : in  std_logic_vector(N_CUM-1 downto 0);
		 step     	 : in  std_logic;
		 tone_on     : in  std_logic;
		 attenu      : in  std_logic_vector(2 downto 0);
		 dds         : out std_logic_vector(N_AUDIO-1 downto 0)
       );
end dds;


architecture comb of dds is

-------------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------------
component counter_register is
  port(
		clk_6m			: IN	  std_logic;
		reset_n   		: IN    std_logic;
		tone_on			: IN    std_logic;
		next_count		: IN    unsigned(N_CUM-1 downto 0);
    	count 		  	: OUT   unsigned(N_CUM-1 downto 0)
    	);
end component counter_register;

-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------
SIGNAL count, next_count:       unsigned(N_CUM-1 downto 0);

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
begin

	count_reg : counter_register
		port map ( 
			clk_6m => clk_6m,
			reset_n => reset_n,
			tone_on => tone_on,
			next_count => next_count,
			count => count
			);

	phase_counter_logic:PROCESS(all)

	VARIABLE lut_val : signed(N_AUDIO-1 downto 0);
	VARIABLE lut_addr : integer range 0 to L-1;
	VARIABLE atte : integer range 0 to 7;
	
	begin
		-- phase counter logic
		if (step) then
			next_count <= count + unsigned(phi_incr);
		else
			next_count <= count;
		end if;
		
		lut_val := to_signed(LUT(lut_addr), N_AUDIO);
		lut_addr := to_integer(count(N_CUM-1 downto N_CUM - N_LUT));
		atte := to_integer(unsigned(attenu));
	
		case atte is
		when 7 => dds <= std_logic_vector(lut_val);
		when 6 => dds <= std_logic_vector(shift_right(lut_val, 1));
		when 5 => dds <= std_logic_vector(shift_right(lut_val, 2));
		when 4 => dds <= std_logic_vector(shift_right(lut_val, 3));
		when 3 => dds <= std_logic_vector(shift_right(lut_val, 4));
		when 2 => dds <= std_logic_vector(shift_right(lut_val, 5));
		when 1 => dds <= std_logic_vector(shift_right(lut_val, 6));
		when 0 => dds <= std_logic_vector(shift_right(lut_val, 7));

		
			
		when others => dds <= std_logic_vector(lut_val);
		end case;

	end process;

end comb;