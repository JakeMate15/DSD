library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity P6 is
	port(
		clk, clr: in std_logic;
		sel, aux: out std_logic_vector(3 downto 0);
		display: out std_logic_vector(7 downto 0)
	);
end P6;

architecture P6_A of P6 is
	constant h: std_logic_vector(7 downto 0) := "10001001";
	constant o: std_logic_vector(7 downto 0) := "11000000";
	constant l: std_logic_vector(7 downto 0) := "11000111";
	constant a: std_logic_vector(7 downto 0) := "10001000";
	constant ap: std_logic_vector(7 downto 0) := "11111111";
	
	signal selContador : natural range 0 to 3 := 0;
	signal contadorSel : natural := 0;
	constant divisorSel : natural := 50000;

	constant divisorDig: natural := 25000000;
	signal contadorDigs: natural := 0;
	signal cntD0 : natural := 3;
	signal cntD1 : natural := 2;
	signal cntD2 : natural := 1;
	signal cntD3 : natural := 0;
	
	function caracter(index: natural) return std_logic_vector is
		begin
			if index = 0 then
				return h;
			elsif index = 1 or index = 8 then
            	return o;
			elsif index = 2 or index = 5 or index = 7 then
            	return l;
			elsif index = 3 or index = 6 then
            	return a;
			else
            	return ap;
			end if;
    end function;
	
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if contadorSel < divisorSel then
				contadorSel <= contadorSel + 1;
			else
				contadorSel <= 0;
				selContador <= (selContador + 1) mod 4;
			end if;
			 
			 
			if contadorDigs < divisorDig then
				contadorDigs <= contadorDigs + 1;
			else
				contadorDigs <= 0;
				cntD0 <= (cntD0 + 1) mod 10;
				cntD1 <= (cntD1 + 1) mod 10;
				cntD2 <= (cntD2 + 1) mod 10;
				cntD3 <= (cntD3 + 1) mod 10;
			end if;
			 
			 
		end if;

	end process;
	
	process (selContador)
	begin
		case selContador is
			when 0 => 
				sel <= "1110"; 
				display <= caracter(cntD0);
         when 1 => 
				sel <= "1101"; 
				display <= caracter(cntD1);
         when 2 => 
				sel <= "1011"; 
				display <= caracter(cntD2);
         when 3 => 
				sel <= "0111"; 
				display <= ap;
         when others => 
				sel <= "1111"; 	
		end case;
	end process;
	
end P6_A;