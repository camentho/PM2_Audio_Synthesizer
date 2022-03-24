--------------------------------------------------------------------
--
-- Project     : Audio_Synth
--
-- File Name   : codec_controller.vhd
-- Description : Controller to define Audio Codec Configuration via I2C
--                                      
-- Features:    Der Baustein wartet bis das reset_n signal inaktiv wird.
--              Danach sendet dieser Codec Konfigurierungsdaten an
--              den Baustein i2c_Master
--                              
--------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|--------------------------------------------
-- 6.03.19 | gelk     | Prepared template for students
--------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.reg_table_pkg.all;


entity codec_controller is

  port (
    mode         : in  std_logic_vector(2 downto 0);  -- Inputs to choose Audio_MODE
    write_done_i : in  std_logic;       -- Input from i2c register write_done
    ack_error_i  : in  std_logic;       -- Inputs to check the transmission
    clk          : in  std_logic;
    reset_n      : in  std_logic;
    write_o      : out std_logic;       -- Output to i2c to start transmission 
    write_data_o : out std_logic_vector(15 downto 0)  -- Data_Output
    );
end codec_controller;


-- Architecture Declaration
-------------------------------------------
architecture rtl of codec_controller is
-- Signals & Constants Declaration
-------------------------------------------
type fsm_type is (st_write, st_wait, st_end);
signal fsm_state, next_fsm_state : fsm_type;
signal count, next_count : unsigned(3 downto 0);
signal reg : t_codec_register_array;

-- Begin Architecture
-------------------------------------------
begin
--flipflops state speichern und counter 2 flipflops

flipflops : process(all)
begin
	if reset_n = '0' then
	fsm_state <= st_write;
	elsif  rising_edge(clk) then
	fsm_state <= next_fsm_state;
	end if;
	
end process;

Flip_count : process(all)
begin
	if reset_n = '0' then
	count <= to_unsigned(0, 4);  -- convert integer value 0 to unsigned with 4bits
	elsif  rising_edge(clk) then
	count <= next_count;
	end if;
	
end process;

state_logic : process (all)
begin

 -- default statements
next_fsm_state <= fsm_state;
next_count <= count;
write_o <= '0';

	case fsm_state is	
		when st_write =>
			write_o <= '1';
			next_fsm_state <= st_wait;
		
		when st_wait =>
			if ack_error_i then
				next_fsm_state <= st_end;
			end if;
			if write_done_i then
				if count < 9 then
					next_count <= count + 1;
					next_fsm_state <= st_write;
				else 
					next_fsm_state <= st_end;
				end if;
			end if;
		when others =>
			next_fsm_state <= st_end;
	end case;
end process;

multiplexer : process (all)
begin
	case mode is

		when "001" => reg <= C_W8731_ANALOG_BYPASS;
		when "101" => reg <= C_W8731_ANALOG_MUTE_LEFT;
		when "011" => reg <= C_W8731_ANALOG_MUTE_RIGHT;
		when "111" => reg <= C_W8731_ANALOG_MUTE_BOTH;
		when others => reg <= C_W8731_ADC_DAC_0DB_48K;

	end case;

end process;

write_data_o <= ("000" & std_logic_vector(count) & reg(to_integer(count)));


-- End Architecture 
------------------------------------------- 
end rtl;
