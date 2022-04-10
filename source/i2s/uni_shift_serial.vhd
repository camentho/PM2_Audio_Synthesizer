--------------------------------------------------------------------
-- Project     : DTP_Soundmachine
--
-- File Name   : uni_shift_serial.vhd
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


entity uni_shift_serial is
        port(
            clk    : in  std_logic;
		      reset_n: in  std_logic;
				load   : in  std_logic;
				enable : in  std_logic;
				par_in : in  std_logic_vector(15 downto 0);
				ser_out: out std_logic
        );
end entity;

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
architecture rtl of uni_shift_serial is

-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------
   signal shiftreg		: std_logic_vector(15 downto 0);
	signal next_shiftreg : std_logic_vector(15 downto 0);
	
begin
  
   -- Reset and Clock-Signal 
   shift_dffs : process(all)
   begin
     if reset_n = '0' then
	    shiftreg <= (others => '0');
     elsif rising_edge(clk) then
	    shiftreg <= next_shiftreg;
     end if;
   end process shift_dffs;
	
	-- Parallen to Serielle
	parallel_serial : process(all)
	begin
	  if load = '1' then												-- load data
	    next_shiftreg <= par_in;
	  elsif enable = '1' then
	     next_shiftreg <= shiftreg(14 downto 0) & '0';
	  else
	    next_shiftreg <= shiftreg;
	  end if;
	end process parallel_serial;
	
	ser_out <= shiftreg(15);										-- konvert parallel to serial

end rtl;