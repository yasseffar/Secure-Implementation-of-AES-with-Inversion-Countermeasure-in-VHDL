-- Secure Implementation of AES with Inversion Countermeasure in VHDL
-- @Author Yassir SEFFAR

library ieee;
use ieee.std_logic_1164.all;

entity aes_enc is 
	port (
		clk : in std_logic;
		rst : in std_logic;
		key : in std_logic_vector(127 downto 0);
		plaintext : in std_logic_vector(127 downto 0);
		ciphertext : out std_logic_vector(127 downto 0);
		done : out std_logic		
	);
end aes_enc;

architecture behavior of aes_enc is
	signal reg_input : std_logic_vector(127 downto 0);
	signal reg_output : std_logic_vector(127 downto 0);
	signal subbox_input : std_logic_vector(127 downto 0);
	signal subbox_output : std_logic_vector(127 downto 0);
	signal shiftrows_output : std_logic_vector(127 downto 0);
	signal mixcol_output : std_logic_vector(127 downto 0);
	signal feedback : std_logic_vector(127 downto 0);
	signal round_key : std_logic_vector(127 downto 0);
	signal round_const : std_logic_vector(7 downto 0);
	signal sel : std_logic;

signal inv_in : std_logic_vector(127 downto 0);
signal inv_out : std_logic_vector(127 downto 0);
signal inv_in1 : std_logic_vector(127 downto 0);
signal inv_out1 : std_logic_vector(127 downto 0);
signal shift_input : std_logic_vector(127 downto 0);
signal inv_out2 : std_logic_vector(127 downto 0);
signal mix_input : std_logic_vector(127 downto 0);




begin
	reg_input <= plaintext when rst = '0' else feedback;
	reg_inst : entity work.reg
		generic map(
			size => 128
		)
		port map(
			clk => clk,
			d   => reg_input,
			q   => reg_output
		);
	-- Encryption body
	add_round_key_inst : entity work.add_round_key
		port map(
			input1 => reg_output,
			input2 => round_key,
			output => inv_in
		);



inv_inst : entity work.Inverter
		port map(
			Input  => inv_in,
			Output => inv_out
			
		);
inv_inst1 : entity work.Inverter
		port map(
			Input  => inv_out,
			Output => subbox_input
			
		);




	sub_byte_inst : entity work.sub_byte
		port map(
			input_data  => subbox_input,
			output_data => inv_in1
			
		);


inv_inst2 : entity work.Inverter
		port map(
			Input  => inv_in1,
			output => inv_out1
			
		);
inv_inst3 : entity work.Inverter
		port map(
			Input  => inv_out1,
			output => shift_input
			
		);

	shift_rows_inst : entity work.shift_rows
		port map(
			input  => shift_input,
			output => shiftrows_output
		);


inv_inst4 : entity work.Inverter
		port map(
			Input  => shiftrows_output,
			output => inv_out2
			
		);
inv_inst5 : entity work.Inverter
		port map(
			Input  => inv_out2,
			output => mix_input
			
		);
	mix_columns_inst : entity work.mix_columns
		port map(
			input_data  => mix_input,
			output_data => mixcol_output
		);

	feedback <= mixcol_output when sel = '0' else shiftrows_output;
	ciphertext <= subbox_input;	


	-- Controller
	controller_inst : entity work.controller
		port map(
			clk            => clk,
			rst            => rst,
			rconst         => round_const,
			is_final_round => sel,
			done           => done
		);
	-- Keyschedule
	key_schedule_inst : entity work.key_schedule
		port map(
			clk         => clk,
			rst         => rst,
			key         => key,
			round_const => round_const,
			round_key   => round_key
		);	
end architecture behavior;
