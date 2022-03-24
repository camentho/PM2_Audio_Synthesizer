-------------------------------------------
-- Block code:  output_register.vhd
-- History: 	12.12.2021 - 1st version (roserraf)
--                 <date> - <changes>  (<author>)
-- Function: output_register, with data_valid input and hex_lsb & -msb_out output. 
-- 			 The input start should be a pulse which causes the 
--				 counter to load its max-value. When start is off,
--				 the counter decrements by one every clock cycle till 
--				 count_o equals 0. Once the count_o reachs 0, the counter
--				 freezes and wait till next start pulse. 
--				 Can be used as enable for other blocks where need to 
--				 count number of iterations.
-------------------------------------------
-- Library & Use Statements
-------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

-------------------------------------------
-- Entity Declaration 
-------------------------------------------
ENTITY output_register IS
  PORT(
		clk					: IN    std_logic;
		reset_n				: IN    std_logic;
  		data_valid			: IN    std_logic;
		parallel_in       : IN    std_logic_vector(9 downto 0);
    	hex_lsb_out     	: OUT   std_logic_vector(3 downto 0);
		hex_msb_out     	: OUT   std_logic_vector(3 downto 0)
    	);
END output_register;

-------------------------------------------
-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF output_register IS

-------------------------------------------
-- Signals & Constants Declaration
-------------------------------------------
SIGNAL 		data_reg			: 	std_logic_vector(8 downto 1);
SIGNAL 		next_data_reg	: 	std_logic_vector(8 downto 1);	 

-------------------------------------------
-- Begin Architecture
-------------------------------------------
BEGIN

-------------------------------------------
-- PROCESS FOR COMBINATORIAL LOGIC
-------------------------------------------
  comb_logic: PROCESS(ALL)
  BEGIN	
	-- load	
	IF (data_valid = '1') THEN
		next_data_reg <= parallel_in(8 downto 1);
	ELSE
		next_data_reg <= data_reg;
  	END IF;
  END PROCESS comb_logic;   
  
--------------------------------------------
-- PROCESS FOR REGISTERS
--------------------------------------------
  flip_flops : PROCESS(ALL)
  BEGIN	
  	IF reset_n = '0' THEN
		data_reg <= (OTHERS => '0');
    ELSIF rising_edge(clk) THEN
		data_reg <= next_data_reg ;
    END IF;
  END PROCESS flip_flops;		
   
--------------------------------------------
-- CONCURRENT ASSIGNMENTS
--------------------------------------------
  hex_lsb_out <= data_reg(4 downto 1);
  hex_msb_out <= data_reg(8 downto 5);
  
--------------------------------------------
-- End Architecture 
--------------------------------------------
END rtl;

