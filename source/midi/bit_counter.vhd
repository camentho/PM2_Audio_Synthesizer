-------------------------------------------
-- Block code:  bit_counter.vhd
-- History: 	12.12.2021 - 1st version (roserraf)
--                 <date> - <changes>  (<author>)
-- Function: bit-counter, with start_bit input and bit_count output. 
-- 			 The input start_bit should be a pulse which causes the 
--			    counter to load its max-value. When start_bit is off,
--			    the value stands by himself.
-------------------------------------------

-------------------------------------------
-- Library & Use Statements
-------------------------------------------
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
    	bit_count     	: OUT   std_logic_vector(3 downto 0)
    	);
END bit_counter;

-------------------------------------------
-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF bit_counter IS

-------------------------------------------
-- Signals & Constants Declaration
-------------------------------------------
SIGNAL 	 		bit_count_i			:	unsigned(3 downto 0);
SIGNAL			next_bit_count_i	:	unsigned(3 downto 0);	 

-------------------------------------------
-- Begin Architecture
-------------------------------------------
BEGIN

-------------------------------------------
-- PROCESS FOR COMBINATORIAL LOGIC
-------------------------------------------
  bit_counter: PROCESS(ALL)
  BEGIN	
	-- load	
	IF (start_bit = '1') THEN
		next_bit_count_i <= x"9";
		ELSIF (baud_tick = '1' and bit_count_i > 0) THEN
			next_bit_count_i <= bit_count_i -1;
		ELSE
			next_bit_count_i <= bit_count_i;
	END IF; 	
  END PROCESS bit_counter;   

--------------------------------------------
-- PROCESS FOR REGISTERS
--------------------------------------------
  flip_flops : PROCESS(ALL)
  BEGIN	
  	IF reset_n = '0' THEN
		bit_count_i <= to_unsigned(0, 4);  -- convert integer value 0 to unsigned with 4bits
    ELSIF rising_edge(clk) THEN
		bit_count_i <= next_bit_count_i ;
    END IF;
  END PROCESS flip_flops;		
  
---------------------------------------------
-- CONCURRENT ASSIGNMENTS
---------------------------------------------
  bit_count <= std_logic_vector(bit_count_i); -- convert count from unsigned to std_logic (output data-type)
  
---------------------------------------------  
-- End Architecture 
---------------------------------------------
END rtl;