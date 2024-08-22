library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity P9 is
	port (
		f: in std_logic_vector(3 downto 0);
		c: inout std_logic_vector(3 downto 0);
		reloj, clr: in std_logic;
		display: inout std_logic_vector(7 downto 0);
		disSel: out std_logic_vector(3 downto 0)
	);
end entity;

architecture A_P9 of P9 is
	signal clk: std_logic := '0'; 
	constant divisor: integer := 500000;
	signal contador: integer := 0;
	
	constant d0 : std_logic_vector(7 downto 0) := "11000000";
	constant d1 : std_logic_vector(7 downto 0) := "11111001";
	constant d2 : std_logic_vector(7 downto 0) := "10100100";
	constant d3 : std_logic_vector(7 downto 0) := "10110000";
	constant d4 : std_logic_vector(7 downto 0) := "10011001";
	constant d5 : std_logic_vector(7 downto 0) := "10010010";
	constant d6 : std_logic_vector(7 downto 0) := "10000010";
	constant d7 : std_logic_vector(7 downto 0) := "11111000";
	constant d8 : std_logic_vector(7 downto 0) := "10000000";
	constant d9 : std_logic_vector(7 downto 0) := "10010000";

	constant da : std_logic_vector(7 downto 0) := "10001000";
	constant db : std_logic_vector(7 downto 0) := "10000011";
	constant dc : std_logic_vector(7 downto 0) := "11000110";
	constant dd : std_logic_vector(7 downto 0) := "10100001";

	constant as : std_logic_vector(7 downto 0) := "10001110";
	constant ga : std_logic_vector(7 downto 0) := "10000010";

	constant ap : std_logic_vector(7 downto 0) := "11111111";
	constant tod : std_logic_vector(7 downto 0) := "10000000";
	
	signal aux: std_logic_vector(7 downto 0) := "11111111";

begin
	-- Procesador de reloj
	process (reloj)
	begin
		if rising_edge(reloj) THEN
			if contador >= divisor THEN
				clk <= NOT clk;
				contador <= 0;
			else 
				contador <= contador + 1;
			end if;
		end if;
	end process;
	
	-- Procesador de anillo
	anillo: process(clk, clr)
	begin
		if clr = '0' then
			c <= "1110";
		elsif rising_edge(clk) then -- Contador de anillo izq usando c
			c <= std_logic_vector(unsigned(c(2 downto 0) & c(3)));
		end if;
	end process anillo;
	
	-- Decodificador
	deco: process(f, c)
	begin
		case f & c is
			when "0111" & "0111" => aux <= d1;
			when "0111" & "1011" => aux <= d2;
			when "0111" & "1101" => aux <= d3;
			when "0111" & "1110" => aux <= da;
			
			when "1011" & "0111" => aux <= d4;
			when "1011" & "1011" => aux <= d5;
			when "1011" & "1101" => aux <= d6;
			when "1011" & "1110" => aux <= db;
			
			when "1101" & "0111" => aux <= d7;
			when "1101" & "1011" => aux <= d8;
			when "1101" & "1101" => aux <= d9;
			when "1101" & "1110" => aux <= dc;
			
			when "1110" & "0111" => aux <= as;
			when "1110" & "1011" => aux <= d0;
			when "1110" & "1101" => aux <= ga;
			when "1110" & "1110" => aux <= ap;
			when others => aux <= tod;
		end case;
	end process;
	
	-- Procesador de display
	pipo: process (clk, clr)
	begin
		disSel <= "1110";
		
		if clr = '0' then
			display <= ap;
		elsif rising_edge(clk) then
			if f = "1111" then
				display <= display;
			else
				display <= aux;
			end if;
		end if;
	end process;
	
end A_P9;
