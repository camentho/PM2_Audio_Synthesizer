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

use work.tone_gen_pkg.all;

-------------------------------------------
-- Entity Declaration 
-------------------------------------------
ENTITY counter_register IS
  PORT(
		clk_6m			: IN	  std_logic;
		reset_n   		: IN    std_logic;
		tone_on			: IN    std_logic;
		next_count		: IN    unsigned(N_CUM-1 downto 0);
    	count 		  	: OUT   unsigned(N_CUM-1 downto 0)
    	);
END counter_register;

-------------------------------------------
-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF counter_register IS

-------------------------------------------
-- Begin Architecture
-------------------------------------------
BEGIN

-------------------------------------------
-- PROCESS FOR COMBINATORIAL LOGIC
-------------------------------------------
	counter_register : PROCESS(ALL)
	BEGIN
	
		IF reset_n = '0' THEN
			count <= (OTHERS => '0');
		ELSIF rising_edge(clk_6m) THEN
			count <= next_count;
		END IF;
		
	END PROCESS counter_register;
	
END rtl;



