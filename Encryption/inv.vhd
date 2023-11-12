-- Secure Implementation of AES with Inversion Countermeasure in VHDL
-- @Author Yassir SEFFAR

-- this code describes an inverter
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Inverter is
    port (
        Input : in std_logic_vector(127 downto 0);
        Output : out std_logic_vector(127 downto 0)
    );
end Inverter;

architecture behavior of Inverter is
begin
  
        Output <= not Input;
    
end behavior;
