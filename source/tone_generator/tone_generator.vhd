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
  
   type t_dds_o_array is array (0 to 9) of std_logic_vector(N_AUDIO-1 downto 0);

	SIGNAL sum_reg,next_sum_reg	: std_logic_vector(15 downto 0);
	signal step_i_signal		: std_logic;
  	signal clk_signal			: std_logic;                        	
	signal reset_signal		: std_logic;
	signal tone_on_signal	: std_logic_vector(9 downto 0);
  	signal dds_o_array	 	: t_dds_o_array;
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

  clk_signal 	<= clk;
  reset_signal	<= reset_n;
  step_i_signal<= step_i;
  velocity_array<= velocity_i;
  note_l_array <= note_l;
  tone_on_signal<= tone_on;
  dds_l_o 	 	<= sum_reg;
  dds_r_o 		<= sum_reg;
  
	dds_inst_gen : for i in 0 to 9 generate
	inst_dds : dds
		port map(
			clk_6m 		=> clk_signal,
			reset_n 		=> reset_signal,
			phi_incr		=> LUT_midi2dds(to_integer(unsigned(note_l(i)))),
			step	 		=> step_i_signal,
			tone_on	 	=> tone_on_signal(i), 						-- now std_logic_vector
			attenu	 	=> velocity_array(i)(6 downto 4),		-- temporary fixed, connect to custom logic
			dds	 		=> dds_o_array(i)
			);
		end generate dds_inst_gen;
		
  --------------------------------------------------
  -- LOGIC FOR POLYPHONY
  --------------------------------------------------
	comb_sum_output : process(all)
		variable var_sum : signed(N_AUDIO-1 downto 0);
		begin
			var_sum := (others => '0');
				if step_i = '1' then
					dds_sum_loop : for i in 0 to 9 loop
					var_sum := var_sum + signed(dds_o_array(i));	
						end loop dds_sum_loop;
					next_sum_reg <= std_logic_vector(var_sum);
				else
					next_sum_reg <= sum_reg;
				end if;
	end process comb_sum_output;
	
		reg_sum_output : process(all)
		begin
			if reset_n = '0' then
				sum_reg <= (others => '0');
			elsif rising_edge(clk) then
				sum_reg <= next_sum_reg;
			end if;
		end process reg_sum_output;
		
END rtl;