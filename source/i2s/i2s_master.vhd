--------------------------------------------------------------------
-- Project     : DTP_Soundmachine
--
-- File Name   : i2s_master.vhd
-- Description : Konvertiert die seriellen i2s Daten in ein paralleles signal
--               und umgekehrt, Hierachie fuer clock-Teiler, state-machine, schieberegister
--
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 24.03.14 | loosean  | file created
-- 21.04.14 | loosean  | revised comments
-- 29.03.17 | dqtm     | adapt to reuse on extended DTP2 project 
--                     | Changes: reuse mod_div, combine bit_cnt & i2s_decoder into i2s_frame_generator)
-- 09.04.22 | rosraf   | modified file for pm2 project
--
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity i2s_master is
  port(
		 clk_6m   	 : in  std_logic;            				-- 6M Clock
       reset_n 	 : in  std_logic;  							-- Reset or init used for re-initialisation
       step_o 		 : out std_logic;          				-- Pulse once per audio frame 1/48kHz
       -- Verbindungen zum path_controller
		 DACDAT_pl_i : in  std_logic_vector(15 downto 0);  -- Eingang vom path_controller
       DACDAT_pr_i : in  std_logic_vector(15 downto 0);
       ADCDAT_pl_o : out std_logic_vector(15 downto 0);  -- Ausgang zum path_controller
       ADCDAT_pr_o : out std_logic_vector(15 downto 0);
       -- Verbindungen zum Audio-Codec
		 ADCDAT_s_i  : in  std_logic;       					-- Serielle Daten Eingang
       DACDAT_s_o  : out std_logic;      						-- Serielle Daten Ausgang
       WS_o        : out std_logic      						-- WordSelect (Links/Rechts)
       );
end i2s_master;

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
architecture top of i2s_master is
-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------
	signal load		     : std_logic;
	signal shift_l		  : std_logic;
	signal shift_r		  : std_logic;
	signal ser_out_left : std_logic;
	signal ser_out_right: std_logic;

-------------------------------------------------------------------------------
-- Component Declaration
-------------------------------------------------------------------------------
	component uni_shiftreg_parallel
		port(
			enable	: in  std_logic;
			reset_n	: in  std_logic;
			clk		: in  std_logic;
			ser_in	: in  std_logic;
			par_out	: out std_logic
		);
		end component uni_shiftreg_parallel;

	component uni_shiftreg_serial
		port(
			load		: in  std_logic;
			enable	: in  std_logic;
			reset_n	: in  std_logic;
			clk		: in  std_logic;
			par_in	: in  std_logic;
			ser_out	: out std_logic
		);
		end component uni_shiftreg_serial;

	component i2s_frame_generator
		port(
			reset_n	: in  std_logic;
			clk_6m	: in  std_logic;
			load		: out std_logic;
			shift_l	: out std_logic;
			shift_r	: out std_logic;
			ws_o		: out std_logic
		);
		end component i2s_frame_generator;

begin

-- Multiplexer for left and right serial channel
	step_o <= load_sig;
		 
	serial_right_left : process(ws_o, dacdat_s_o, ser_out_left, ser_out_right)
	begin
		if ws_o = '0' then					-- left serial channel
			dacdat_s_o <= ser_out_left;
		else										-- right serial channel
			dacdat_s_o <= ser_out_right;
		end if;
	end process serial_right_left;
		

	inst0 : uni_shift_serial
	port map(
		load		=> load_sig,
		enable	=> shift_l_sig,
		reset_n	=> reset_n,
		clk		=> clk_6m,
		par_in	=> dacdat_pl_i,
		ser_out	=> ser_out_left
		);

	inst1 : uni_shift_serial
	port map( 
		load		=> load_sig,
		enable	=> shift_r_sig,
		reset_n	=> reset_n,
		clk		=> clk_6m,
		par_in	=> dacdat_pr_i,
		ser_out	=> ser_out_right
		);

	inst2 : uni_shift_parallel
	port map(
		ser_in	=> adcdat_s_i,
		enable	=> shift_l_sig,
		reset_n	=> reset_n,
		clk		=> clk_6m,
		par_out	=> adcdat_pl_o
		);

	inst3 : uni_shift_parallel
	port map(
	   ser_in	=> adcdat_s_i,
		enable	=> shift_r_sig,
		reset_n	=> reset_n,
		clk		=> clk_6m,
		par_out	=> adcdat_pr_o
		);
		 
	inst4 : i2s_frame_generator
	port map(
	   reset_n	=> reset_n,
		clk		=> clk_6m,
		load		=> load_sig,
		shift_l	=> shift_l_sig,
		shift_r	=> shift_r_sig,
		ws_o		=> ws_o
		);


end top;

