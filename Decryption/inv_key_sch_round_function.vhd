-- Secure Implementation of AES with Inversion Countermeasure in VHDL
-- @Author Yassir SEFFAR

library ieee;
use ieee.std_logic_1164.all;

entity inv_ksch_round_func is
	port (		
		subkey : in std_logic_vector(127 downto 0);
		round_const : in std_logic_vector(7 downto 0);
		next_subkey : out std_logic_vector(127 downto 0)		
	);
end inv_ksch_round_func;

architecture behavioral of inv_ksch_round_func is
	signal substitued_sk : std_logic_vector(31 downto 0);
	signal shifted_sk : std_logic_vector(31 downto 0);
	signal w3, w2, w1, w0 : std_logic_vector(31 downto 0);
begin
	w3 <= subkey(4*32 - 1 downto 3*32) xor subkey(3*32 - 1 downto 2*32);
	w2 <= subkey(3*32 - 1 downto 2*32) xor subkey(2*32 - 1 downto 32);
	w1 <= subkey(2*32 - 1 downto 1*32) xor subkey(1*32 - 1 downto 0);
	gen_sboxes : for i in 0 to 3 generate
		sbox_inst : entity work.sbox
			port map(
				input_byte  => w3((i + 1)*8 - 1 downto i*8),
				output_byte => substitued_sk((i + 1)*8 - 1 downto i*8)
			);			
	end generate gen_sboxes;
	shifted_sk <= substitued_sk(7 downto 0) & substitued_sk(31 downto 8);	
	w0(31 downto 8) <= subkey(31 downto 8) xor shifted_sk(31 downto 8);
    w0(7 downto 0) <= subkey(7 downto 0) xor round_const xor shifted_sk(7 downto 0);    
	next_subkey <= w3 & w2 & w1 & w0;
end architecture behavioral;

