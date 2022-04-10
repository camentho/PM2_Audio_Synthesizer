--------------------------------------------------------------------
-- Project     : DTP_Soundmachine
--
-- File Name   : i2s_frame_generator.vhd
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


entity i2s_frame_generator is
        port(
            clk    	: in  std_logic;
		      reset_n	: in  std_logic;
				load   	: out std_logic;
				shift_l	: out std_logic;
				shift_r	: out std_logic;
				ws     	: out std_logic
        );
end entity;

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
architecture rtl of i2s_frame_generator is

-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------
	signal next_bit_counter	: unsigned(7 downto 0);
   signal bit_counter		: unsigned(7 downto 0);
	
begin
  
  --Reset Funktion und Clock-Signal überprüft
  shift_dffs : process(all)
  begin
    if reset_n = '0' then
      bit_counter <= x"00";
    elsif rising_edge(clk) then
      bit_counter <= next_bit_counter;
    end if;
  end process shift_dffs;
  
  --Bit_counter wird überprüft, load gesetzt 
  counter : process(all)
  begin
     --Default Statement
     load <= '0';
	   
	   if (bit_counter = x"00") then
	     load <= '1';
	   end if;

     --bit_counter wird zurückgesetzt
     if bit_counter = x"7F" then
	    next_bit_counter <= x"00";

	  --bit_counter zählt auf
	  else
	    next_bit_counter <= bit_counter + 1;
	  end if;
  end process counter;
  
  --shift_l, shift_r und ws werden gesetzt
  right_left : process(all)
  begin
     --Default Statements
     shift_l <= '0';
     shift_r <= '0';
     ws  <= '0';
	  
     --Linke Signal
	  if (bit_counter >= x"01") and (bit_counter <= x"10")  then
		 shift_l <= '1';
			
	  --Rechte Signal
	  elsif (bit_counter >= x"41") and (bit_counter <= x"50")  then
		 shift_r <= '1';
	  end if;
	  
	  --WS rechte Signal
	  if (bit_counter >= x"40") then
	    ws <= '1';
	  end if;
	end process right_left;


end rtl;