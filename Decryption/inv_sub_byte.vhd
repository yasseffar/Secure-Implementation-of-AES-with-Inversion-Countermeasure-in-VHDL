-- Secure Implementation of AES with Inversion Countermeasure in VHDL
-- @Author Yassir SEFFAR

library ieee;
use ieee.std_logic_1164.all;

entity inv_sub_byte is
	port (
		input_data : in std_logic_vector(127 downto 0);
		output_data : out std_logic_vector(127 downto 0)
	);
end inv_sub_byte;

architecture behavioral of inv_sub_byte is
	
begin
	gen : for i in 0 to 15 generate
		sbox_inst : entity work.inv_sbox
			port map(
				input_byte  => input_data((i + 1)*8 - 1 downto i*8),
				output_byte => output_data((i + 1)*8 - 1 downto i*8)
			);		
	end generate gen;
	
end architecture behavioral;
