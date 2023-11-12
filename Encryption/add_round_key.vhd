-- Secure Implementation of AES with Inversion Countermeasure in VHDL
-- @Author Yassir SEFFAR


library ieee;
use ieee.std_logic_1164.all;

entity add_round_key is
	port (
		input1 : in std_logic_vector(127 downto 0);
		input2 : in std_logic_vector(127 downto 0);
		output : out std_logic_vector(127 downto 0)
	);
end add_round_key;

architecture behavior of add_round_key is
	
begin
	output <= input1 xor input2;		
end architecture behavior;
