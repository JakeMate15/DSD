library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity P7 is 
	port(
		reloj, clr: in std_logic;
		entrada : in std_logic_vector(3 downto 0);
		sal: inout std_logic_vector(3 downto 0); 
		control: in std_logic_vector(2 downto 0)
	);
end P7;

architecture A_P7 of P7 is
	signal clk: std_logic := '0'; 
	constant divisor: integer := 25000000;
	signal contador: integer := 0;
	
	signal salida: std_logic_vector(3 downto 0); 
begin

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

	
	process (clk, control, clr, entrada)
		variable aux: unsigned(3 downto 0) := (others => '0');
	begin
		if clr = '0' then
			aux := (others => '0');
			salida <= std_logic_vector(aux);
		elsif rising_edge(clk) then
			case control is
				when "000" =>	-- Retener
					salida <= salida;
					aux := unsigned(salida);
				when "001" =>	-- +
					aux := aux + 1;
					salida <= std_logic_vector(aux);
				when "010" =>	-- -
					aux := aux - 1;
					salida <= std_logic_vector(aux);
				when "011" =>	-- Leer
					salida <= entrada;
					aux := unsigned(entrada);
				when "100" =>	-- Anillo der
					aux := unsigned(salida(0) & salida(3 downto 1));
					salida <= std_logic_vector(aux);
				when "101" => -- Anillo izq
					aux := unsigned(salida(2 downto 0) & salida(3));
					salida <= std_logic_vector(aux);
				when "110" => -- Gray
					aux := aux + 1;
					salida <= std_logic_vector(aux xor shift_right(aux, 1));
				when "111" =>
					aux := aux - 1;
					salida <= std_logic_vector(aux xor shift_right(aux, 1));
			end case;
		end if;
		
	end process;
	
	sal <= not salida;

end A_P7;
