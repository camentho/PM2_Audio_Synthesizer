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
		tone_on			: IN		std_logic_vector(9 downto 0);
		note_l			: IN		t_tone_array;
		velocity_i		: IN		t_tone_array;
		dds_l_o			: OUT		t_tone_array;
		dds_r_o			: OUT		t_tone_array
		);
END tone_generator;

-------------------------------------------
-- Architecture Declaration
-------------------------------------------
ARCHITECTURE rtl OF tone_generator IS

  -----------------------------------------------------------------------------
  -- Internal signal declarations
  -----------------------------------------------------------------------------
  
	signal step_i_signal		: std_logic;
  	signal clk_signal			: std_logic;                        	
	signal reset_signal		: std_logic;
	signal tone_on_signal	: std_logic_vector(9 downto 0);
  	signal dds_o_array	 	: t_tone_array;
	signal note_l_array 	 	: t_tone_array;
	signal velocity_array 	: t_tone_array;
	
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
		 attenu      : in  std_logic_vector(2 downto 0);
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
      reset_n  => reset_signal,
      phi_incr => LUT_midi2dds(to_integer(unsigned(note_l_array))),
      step     => step_i_signal,
		tone_on 	=> tone_on_signal,
      attenu	=> velocity_i(6 downto 4),
		dds      => dds_o_array
		);

END rtl;