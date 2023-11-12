-- Secure Implementation of AES with Inversion Countermeasure in VHDL
-- @Author Yassir SEFFAR


library ieee;
use ieee.std_logic_1164.all;

entity aes_dec is
	port (
		clk : in std_logic;
		rst : in std_logic;
		dec_key : in std_logic_vector(127 downto 0);
		ciphertext : in std_logic_vector(127 downto 0);
		plaintext : out std_logic_vector(127 downto 0);
		done : out std_logic
	);
end aes_dec;

architecture rtl of aes_dec is
	signal mux_output : std_logic_vector(127 downto 0);
	signal reg_output : std_logic_vector(127 downto 0);
	signal inv_mixcol_input : std_logic_vector(127 downto 0);
	signal inv_mixcol_output : std_logic_vector(127 downto 0);
	signal invsr_input : std_logic_vector(127 downto 0);
	signal invsb_input : std_logic_vector(127 downto 0);
	signal feedback : std_logic_vector(127 downto 0);
	signal round_key : std_logic_vector(127 downto 0);
	signal round_const : std_logic_vector(7 downto 0);
	signal is_first_round : std_logic;



	signal inv_in : std_logic_vector(127 downto 0);
	signal inv_out : std_logic_vector(127 downto 0);


	signal inv_in1 : std_logic_vector(127 downto 0);
	signal inv_out1 : std_logic_vector(127 downto 0);




begin
	-- Decryption body
	mux_output <= ciphertext when rst = '0' else feedback;
	reg_inst : entity work.reg
		generic map(
			size => 128
		)
		port map(
			clk => clk,
			d   => mux_output,
			q   => reg_output
		);
	
	add_round_key_inst : entity work.add_round_key
		port map(
			input1 => reg_output,
			input2 => round_key,
			output => inv_in
		);


        inverter_inst : entity work.Inverter

                 port map(
			Input => inv_in,
			Output => inv_out
		);
        inverter_inst1 : entity work.Inverter

                 port map(
			Input => inv_out,
			Output => inv_mixcol_input
		);



	inv_mix_columns_inst : entity work.inv_mix_columns
		port map(
			input_data  => inv_mixcol_input,
			output_data => inv_mixcol_output
		);	



   


	invsr_input <= inv_mixcol_input when is_first_round = '1' else inv_mixcol_output;
	inv_shift_rows_inst : entity work.inv_shift_rows
		port map(
			input  => invsr_input,
			output => inv_in1
		);



        inverter_inst2 : entity work.Inverter

                 port map(
			Input => inv_in1,
			Output => inv_out1
		);
        inverter_inst3 : entity work.Inverter

                 port map(
			Input => inv_out1,
			Output => invsb_input
		);
	
	inv_sub_byte_inst : entity work.inv_sub_byte
		port map(
			input_data  => invsb_input,
			output_data => feedback
		);	
	 -- Keyschedule 
	 key_schedule_inst : entity work.key_schedule
	 	port map(
	 		clk         => clk,
	 		rst         => rst,
	 		key         => dec_key,
	 		round_const => round_const,
	 		round_key   => round_key
	 	);
	 -- Controller
	 controller_inst : entity work.controller
	 	port map(
	 		clk            => clk,
	 		rst            => rst,
	 		rconst         => round_const,
	 		is_first_round => is_first_round,
	 		done           => done
	 	);
	 plaintext <= inv_mixcol_input;
end architecture rtl;
