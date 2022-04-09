--------------------------------------------------------------------
-- Project     : DTP_Soundmachine
--
-- File Name   : uni_shift_parallel.vhd
-- Description : 
--
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 09.04.22 | rosraf   | creat file for pm2 project
--
--------------------------------------------------------------------
library ieee;
  use ieee.std_logic_1164.all;
  use ieee.numeric_std.all;


entity uni_shift_parallel is
        port(
            clk     : in std_logic;
		      reset_n : in std_logic;
				ser_in  : in std_logic;
				enable  : in std_logic;
				par_out : out std_logic_vector(15 downto 0)
        );
end entity;

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
architecture rtl of uni_shift_parallel is

-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------
   signal shiftreg		: std_logic_vector(15 downto 0);
	signal next_shiftreg : std_logic_vector(15 downto 0);
	
begin
  
    --Reset Funktion und Clock-Signal überprüft
   shift_dffs : process(all)
   begin
     if reset_n = '0' then
	    shiftreg <= (others => '0');
     elsif rising_edge(clk) then
	    shiftreg <= next_shiftreg;
     end if;
   end process shift_dffs;
	
	--Seriell zu Parallel
	serial_parallel : process(all)
	begin
	  --Daten werden parallel abgespeichert
	  if enable = '1' then
	    next_shiftreg <= shiftreg(14 downto 0) & ser_in; 
	  --Keine Daten werden herausgelesen
	  else
	    next_shiftreg <= shiftreg;
	  end if;
	end process serial_parallel;
	
	par_out <= shiftreg;  --Daten werden parallel herausgelesen
  
end rtl;


