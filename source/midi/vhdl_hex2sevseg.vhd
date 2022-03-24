--
-- Project     : DT
--
-- File Name   : vhdl_template
-- Description : Template for DT lessons
--
-- Features:     
--
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 15.10.14 |  dqtm    | file created
-- 15.10.14 |  rosn    | small changes, comments
-- 11.10.19 |  gelk    | adapted for 2025

--------------------------------------------------------------------

-- Library & Use Statements

library ieee;
use ieee.std_logic_1164.all;

-- Entity Declaration 

entity vhdl_hex2sevseg is
  port(
  
-- Inputs of entity

    data_in  : in  std_logic_vector(3 downto 0);
	
-- Outputs of entity	

	 seg_o : out std_logic_vector(6 downto 0));
	 
end vhdl_hex2sevseg;

-- Architecture Declaration�

architecture comb of vhdl_hex2sevseg is

  -- Signals & Constants Declaration� 
  
	constant disp_0 : std_logic_vector(6 downto 0):= "0111111";
	constant disp_1 : std_logic_vector(6 downto 0):= "0000110";
	constant disp_2 : std_logic_vector(6 downto 0):= "1011011";
	constant disp_3 : std_logic_vector(6 downto 0):= "1001111";
	constant disp_4 : std_logic_vector(6 downto 0):= "1100110";
	constant disp_5 : std_logic_vector(6 downto 0):= "1101101";
	constant disp_6 : std_logic_vector(6 downto 0):= "1111100";
	constant disp_7 : std_logic_vector(6 downto 0):= "0000111";
	constant disp_8 : std_logic_vector(6 downto 0):= "1111111";
	constant disp_9 : std_logic_vector(6 downto 0):= "1100111";
	constant disp_A : std_logic_vector(6 downto 0):= "1110111";
	constant disp_B : std_logic_vector(6 downto 0):= "1011110";
	constant disp_C : std_logic_vector(6 downto 0):= "0111001";
	constant disp_D : std_logic_vector(6 downto 0):= "1011110";
	constant disp_E : std_logic_vector(6 downto 0):= "1111001";
	constant disp_F : std_logic_vector(6 downto 0):= "1110001";

-- Begin Architecture

begin	 
	vhdl_hex2sevseg : Process (all) is 
	begin		
			Case data_in is			
			when x"0" => seg_o <= not(disp_0);
			when x"1" => seg_o <= not(disp_1);
			when x"2" => seg_o <= not(disp_2);
			when x"3" => seg_o <= not(disp_3);
			when x"4" => seg_o <= not(disp_4);
			when x"5" => seg_o <= not(disp_5);
			when x"6" => seg_o <= not(disp_6);
			when x"7" => seg_o <= not(disp_7);
			when x"8" => seg_o <= not(disp_8);
			when x"9" => seg_o <= not(disp_9);
			when x"A" => seg_o <= not(disp_A);
			when x"B" => seg_o <= not(disp_B);
			when x"C" => seg_o <= not(disp_C);
			when x"D" => seg_o <= not(disp_D);
			when x"E" => seg_o <= not(disp_E);
			when others => seg_o <= not(disp_F);			
			end case;
		end Process vhdl_hex2sevseg;
-- End Architecture 
end comb;

