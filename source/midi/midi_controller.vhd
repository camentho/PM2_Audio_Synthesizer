-------------------------------------------------------------------------------
-- Title      : MIDI controller
-- Project    : PM2_Audio_Synthesizer
-------------------------------------------------------------------------------
-- File       : midi_controller.vhd
-- Author     : camentho
-- Company    : 
-- Created    : 2022-05-08
-- Last update:
-- Platform   : 
-- Standard   : VHDL'08
-------------------------------------------------------------------------------
-- Description: Direct Digital Synthesis
-------------------------------------------------------------------------------
-- Copyright (c) 2022
-------------------------------------------------------------------------------
-- Revisions  :
-- Date        Version  Author				Description
-- 2022-05-08  1.0      camentho				Created
-- 2022-05-10  1.1		roserraf				final version for 1 dds
-- 2022-05-14  1.2		roserraf				created version for 10 dds
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.tone_gen_pkg.all;											-- for Array type

entity midi_controller is
  port(
    clk_6m        : IN    std_logic;
	 reset_n       : IN    std_logic;
    rx_data_rdy   : IN    std_logic;
	 new_data_flag : OUT	  std_logic;                      -- new data signal
	 rx_data       : IN    std_logic_vector(7 downto 0);
	 -- 10 DDS
	 note_on			: OUT	  std_logic_vector(9 downto 0);
    note		      : OUT   t_tone_array;
    velocity      : OUT   t_tone_array
    );
end midi_controller;

architecture contr of midi_controller is

-------------------------------------------------------------------------------
-- Signal & constant Declaration
-------------------------------------------------------------------------------
 type fsm_type is (WAIT_STATUS, WAIT_DATA1, WAIT_DATA2);
 
 signal fsm_status, next_fsm_status	: fsm_type;
 
 signal status_reg,  next_status_reg   : std_logic_vector(7 downto 0);
 signal data1_reg,   next_data1_reg    : std_logic_vector(6 downto 0);
 signal data2_reg,   next_data2_reg    : std_logic_vector(6 downto 0);
 
 signal reg_note, next_reg_note				: t_tone_array;
 signal reg_velocity, next_reg_velocity	: t_tone_array;
 signal reg_note_on, next_reg_note_on		: std_logic_vector(9 downto 0);

-------------------------------------------------------------------------------
-- Begin Architecture
-------------------------------------------------------------------------------

begin

  --------------------------------------------------
  -- PROCESS FOR FLIP-FLOPS
  --------------------------------------------------
  
  flip_flops_fsm : process(all)
  begin
    if reset_n = '0' then
      fsm_status <= WAIT_STATUS;

    elsif rising_edge(clk_6m) then
      fsm_status <= next_fsm_status;

    end if;
  end process;
  
    -- Status
  flip_flops_st_reg : process(all)
  begin
    if reset_n = '0' then
      status_reg <= (others => '0');

    elsif rising_edge(clk_6m) then
      status_reg <= next_status_reg;

    end if;
  end process;
  
  -- Note
  flip_flops_data1_reg : process(all)
  begin
    if reset_n = '0' then
      data1_reg <= (others => '0');

    elsif rising_edge(clk_6m) then
      data1_reg <= next_data1_reg;

    end if;
  end process;

  -- Velocity
  flip_flops_data2_reg : process(all)
  begin
    if reset_n = '0' then
      data2_reg <= (others => '0');

    elsif rising_edge(clk_6m) then
      data2_reg <= next_data2_reg;

    end if;
  end process;
    -- reg_note_on
  flip_flops_note_on : process(all)
  begin
    if reset_n = '0' then
      reg_note_on <= (others => '0');

    elsif rising_edge(clk_6m) then
      reg_note_on <= next_reg_note_on;

    end if;
  end process;
  
  -- reg_note
  flip_flops_reg_note : process(all)
  begin
    if reset_n = '0' then
			for i in 0 to 9 loop
				reg_note(i) <= "0000000";
			end loop;

    elsif rising_edge(clk_6m) then
      reg_note <= next_reg_note;

    end if;
  end process;
  
  -- reg_velocity
  flip_flops_reg_velocity : process(all)
  begin
    if reset_n = '0' then
			for i in 0 to 9 loop
				reg_velocity(i) <= "0000000";
			end loop;

    elsif rising_edge(clk_6m) then
      reg_velocity <= next_reg_velocity;

    end if;
  end process;

  --------------------------------------------------
  -- PROCESS FOR FSM-STATE
  --------------------------------------------------
  
  
	fsm : process(all)
		
	begin
	
	 -- default statements for loop
    next_fsm_status <= fsm_status;
	 next_status_reg <= status_reg;
	 next_data1_reg <= data1_reg;
	 next_data2_reg <= data2_reg;
	 new_data_flag		<= '0';
	 
		case fsm_status is
		
			when WAIT_STATUS =>
				if (rx_data_rdy) then
					-- Status-Byte
					if rx_data(7) = '1' then
						next_status_reg <= rx_data;
						next_fsm_status <= WAIT_DATA1;
					-- No Status-Byte
					else
						next_data1_reg <= rx_data(6 downto 0);
						next_fsm_status <= WAIT_DATA2;
					end if;
				end if;
				
			-- safing note-data
			when WAIT_DATA1 =>
				if (rx_data_rdy) then
					next_data1_reg <= rx_data(6 downto 0);
					next_fsm_status <= WAIT_DATA2;
				end if;
			
			-- safing velocity-data
			when WAIT_DATA2 =>
				if (rx_data_rdy) then
					next_data2_reg <= rx_data(6 downto 0);
					next_fsm_status <= WAIT_STATUS;
					new_data_flag		<= '1';
				end if;
				
			when others =>
				next_fsm_status <= WAIT_STATUS;
				
		end case;
		
	end process fsm;
	
  --------------------------------------------------
  -- PROCESS FOR POLYPHONIE
  --------------------------------------------------
 
	polyphonie	: process (all)
	
	variable note_available	: std_logic := '0';
	variable note_written	: std_logic := '0';
	
	begin
	
	-- DEFAULT STATEMENTS
	next_reg_note_on <= reg_note_on;
	next_reg_note <= reg_note;
	next_reg_velocity <= reg_velocity;
	
		if (new_data_flag) then
		
			note_available := '0';
			note_written := '0';
		
		
			-- Überprüfung ob Note bereits im MIDI Array enthalten ist
			for i in 0 to 9 loop
			
				if reg_note(i) = data1_reg and reg_note_on(i) = '1' then 	-- Dupplikat gefunden
					
					note_available := '1';
					
					if status_reg(4) = '0' then   	-- Nicht mehr gedrückt Note off
						next_reg_note_on(i) <= '0'; 	-- Note ausschalten
					
					elsif status_reg(4) = '1' and data2_reg = "00000000" then
						
						next_reg_note_on(i) <= '0';	-- Note ausscchalten wenn velocity = 0
					
					end if;
				end if;
			
			end loop;
						

			-- Neue Note im MIDI Array setzen, wenn Platz vorhanden ist
			if note_available = '0' then 			-- Wenn diese Note noch kein Eintrag hat
			
				-- Suche nach einen neuen Platz & trage es ein
				for i in 0 to 9 loop
					if note_written = '0' then			-- Restlichen Loop ignorieren, wenn Note vorhanden ist
				
						-- Bei Freien Platz eintragen ODER als letzter Eintrag eintragen
						if (reg_note_on(i) = '0' or i = 9) and status_reg(4) = '1' then 
						
							-- Note setzen
							next_reg_note(i) <= data1_reg;
							next_reg_velocity(i) <= data2_reg;
							next_reg_note_on(i) <= '1';
						
							note_written := '1';
						end if;
					
					end if;
					
				end loop;
		
			end if;
		
		end if;
		
		
  --------------------------------------------------
  -- SET SIGNALS
  --------------------------------------------------
		for i in 0 to 9 loop
		
			note(i) 		<= reg_note(i);
			velocity(i) <= reg_velocity(i);
			note_on(i) 	<= reg_note_on(i);
		
		end loop;
  
  
	end process polyphonie;

-------------------------------------------
-- End Architecture 
------------------------------------------- 	
end contr;