--------------------------------------------------------------------
-- Project     : DTP_Soundmachine
--
-- File Name   : Counter_Register.vhd
-- Description : 
--
--------------------------------------------------------------------
-- Change History
--
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 27.04.22 | rosraf   | creat file for pm2 project
--
--------------------------------------------------------------------

LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-------------------------------------------
-- Entity Declaration 
-------------------------------------------
ENTITY bit_counter IS
  PORT(clk,reset_n   : IN    std_logic;
		start_bit		: IN    std_logic;
		baud_tick		: IN    std_logic;
    	bit_count   	: OUT   std_logic_vector(3 downto 0)
    	);
END bit_counter;