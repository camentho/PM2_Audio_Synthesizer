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


-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
begin

digital_loop : process (ALL)

begin


end process;

end comb;