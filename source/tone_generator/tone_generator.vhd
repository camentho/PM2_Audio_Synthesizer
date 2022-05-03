--------------------------------------------------------------------
-- Project     : DTP_Soundmachine
--
-- File Name   : tone_generator.vhd
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
ENTITY tone_generator IS
  PORT(
		clk				: IN		std_logic;
		reset_n			: IN		std_logic;
		step_i			: IN		std_logic;
		tone_on			: IN		std_logic; -- abhängig von der Anzahl DDS
		note_l			: IN		std_logic_vector(6 downto 0);
		velocity_i		: IN		std_logic_vector(6 downto 0);
		dds_l_o			: OUT		std_logic_vector(15 downto 0);
		dds_r_o			: OUT		std_logic_vector(15 downto 0)
		);
END tone_generator;

-------------------------------------------
-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF tone_generator IS

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  
  	signal clk_signal			: std_logic;                        	
	signal reset 				: std_logic;
  	signal dds_o_array	 	: std_logic_vector(15 downto 0);
	
	-- Signale für mehr DDS 
	-- signal note_array 	 : std_logic_vector(7 downto 0);
	-- signal velocity_array : std_logic_vector(7 downto 0);
	
  -----------------------------------------------------------------------------
  -- Component declarations
  -----------------------------------------------------------------------------
		
  COMPONENT dds IS
	 PORT (
		 clk_6m      : in  std_logic;
		 reset_n     : in  std_logic;
		 phi_incr    : in  std_logic_vector(N_CUM-1 downto 0);
		 step     	 : in  std_logic;
		 tone_on     : in  std_logic;
		 attenu      : in  std_logic_vector(3 downto 0);
		 dds         : out std_logic_vector(N_AUDIO-1 downto 0)
		 );
	 END COMPONENT dds;

-------------------------------------------
-- Begin Architecture
-------------------------------------------
BEGIN

  clk_signal <= clk;
  reset 		 <= reset_n;
  dds_l_o 	 <= dds_o_array;
  dds_r_o 	 <= dds_o_array;
  
  dds_0: dds
    port map 
	 (
      clk_6m   => clk_signal,
      reset_n  => reset,
      phi_incr => LUT_midi2dds(to_integer(unsigned(note_l))),
      step     => step_i,
		tone_on 	=> tone_on,
      attenu	=> velocity_i(6 downto 3),
		dds      => dds_o_array
		);

END rtl;