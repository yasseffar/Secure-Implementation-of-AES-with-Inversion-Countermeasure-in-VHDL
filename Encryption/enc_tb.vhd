-- Secure Implementation of AES with Inversion Countermeasure in VHDL
-- @Author Yassir SEFFAR

library ieee;
use ieee.std_logic_1164.all;

entity test_enc is 
end test_enc;

architecture behavior of test_enc is
	component aes_enc
		port(
			clk        : in  std_logic;
			rst        : in  std_logic;
			key        : in  std_logic_vector(127 downto 0);
			plaintext  : in  std_logic_vector(127 downto 0);
			ciphertext : out std_logic_vector(127 downto 0);
			done       : out std_logic
		);		
	end component aes_enc;	
	-- Input signals
	signal clk : std_logic := '0';
	signal rst : std_logic := '0';
	signal plaintext : std_logic_vector(127 downto 0);
	signal key : std_logic_vector(127 downto 0);	
	
	-- Output signals
	signal done : std_logic;
	signal ciphertext : std_logic_vector(127 downto 0);	
	
	-- Clock period definition
	constant clk_period : time := 10 ns;
	
begin
	enc_inst : aes_enc
		port map(
			clk        => clk,
			rst        => rst,
			key        => key,
			plaintext  => plaintext,
			ciphertext => ciphertext,
			done       => done
		);	
	-- clock process definitions
	clk_process : process is
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
	end process clk_process;
	
	-- Simulation process
	sim_proc : process is
	begin
		
		plaintext <= x"340737e0a29831318d305a88a8f64332";
		key <= x"3c4fcf098815f7aba6d2ae2816157e2b";
		rst <= '0';
				
		wait for clk_period * 1;
		rst <= '1';
		wait until done = '1';
		wait for clk_period/2;
		if (ciphertext = x"320b6a19978511dcfb09dc021d842539") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		report "---------- Output must be: -------";
		report "320b6a19978511dcfb09dc021d842539";
			
		plaintext <= x"00000000000000000000000000000000";
		key <= x"00000000000000000000000000000000";
		rst <= '0';
			
		wait for clk_period * 1;
		rst <= '1';
		wait until done = '1';
		wait for clk_period/2;			
		if (ciphertext = x"2e2b34ca59fa4c883b2c8aefd44be966") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		report "---------- Output must be: -------";
		report "2e2b34ca59fa4c883b2c8aefd44be966";
			
		plaintext <= x"2a179373117e3de9969f402ee2bec16b";
		key <= x"3c4fcf098815f7aba6d2ae2816157e2b";
		rst <= '0';
			
		wait for clk_period * 1;
		rst <= '1';
		wait until done = '1';
		wait for clk_period/2;			
		if (ciphertext = x"97ef6624f3ca9ea860367a0db47bd73a") then
			report "---------- Passed ----------";
		else
			report "---------- Failed ----------";
		end if;
		report "---------- Output must be: -------";
		report "97ef6624f3ca9ea860367a0db47bd73a";
		wait;
	end process sim_proc;
	
end architecture behavior;

