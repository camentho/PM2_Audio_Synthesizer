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


entity dds is
  port(
		 clk_6m      : in  std_logic;
		 reset_n     : in  std_logic;
		 phi_incr    : in  std_logic_vector(N_CUM-1 downto 0);
		 step     	 : in  std_logic;
		 tone_on     : in  std_logic;
		 attenu      : in  std_logic_vector(3 downto 0);
		 dds         : out std_logic_vector(N_AUDIO-1 downto 0)
       );
end dds;


architecture comb of dds is

-------------------------------------------------------------------------------
-- Constant Declaration
-------------------------------------------------------------------------------
	

-------------------------------------------------------------------------------
-- Type Declaration
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------
signal lut_addr : integer range 0 to (L-1);
signal lut_val  : signed(N_AUDIO-1 downto 0);

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
begin

digital_loop : process (ALL)

begin


end process;

end comb;