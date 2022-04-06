--------------------------------------------------------------------
-- Project     : DTP_Soundmachine
--
-- File Name   : i2s_master.vhd
-- Description : Konvertiert die seriellen i2s Daten in ein paralleles signal
--                              und umgekehrt, Hierachie f�r clock-Teiler, state-machine, schieberegister
--
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 24.03.14 | loosean  | file created
-- 21.04.14 | loosean  | revised comments
-- 29.03.17 | dqtm     | adapt to reuse on extended DTP2 project 
--                     | Changes: reuse mod_div, combine bit_cnt & i2s_decoder into i2s_frame_generator)
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


entity i2s_master is
  port(
		 clk_12m   	 : in std_logic;            				-- 12.5M Clock
       rst_n 		 : in std_logic;  							-- Reset or init used for re-initialisation
       step_o 		 : out std_logic;          				-- Pulse once per audio frame 1/48kHz
       --Verbindungen zum path_controller
		 DACDAT_pl_i : in std_logic_vector(15 downto 0);   --Eingang vom path_controller
       DACDAT_pr_i : in std_logic_vector(15 downto 0);
       ADCDAT_pl_o : out std_logic_vector(15 downto 0);  --Ausgang zum path_controller
       ADCDAT_pr_o : out std_logic_vector(15 downto 0);
       --Verbindungen zum Audio-Codec
		 ADCDAT_s_i  : in  std_logic       						--Serielle Daten Eingang
       DACDAT_s_o  : out std_logic;      						--Serielle Daten Ausgang
       WS_o        : out std_logic;      						--WordSelect (Links/Rechts)
       );
end i2s_master;


architecture top of i2s_master is

-------------------------------------------------------------------------------
-- Constant Declaration
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Type Declaration
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Signal Declaration
-------------------------------------------------------------------------------


-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------
begin


  

end top;

