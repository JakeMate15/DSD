library ieee;
use ieee.std_logic_1164.all;

entity P8 is
    port(
        esd, esi, clr, reloj: in std_logic;
        cnt: in std_logic_vector(1 downto 0);
        ep: in std_logic_vector(4 downto 0);
        q: inout std_logic_vector(4 downto 0)
    );
end P8;

architecture A_P8 of P8 is
	signal clk: std_logic := '0'; 
	constant divisor: integer := 25000000;
	signal contador: integer := 0;

	signal d: std_logic_vector(4 downto 0);
	
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
	
	
	
    -- Lógica del Registro Universal
    process (cnt, ep, esd, esi, q)
    begin
        case cnt is
            when "00" => 
                d <= ep; -- Entrada Paralela
            when "01" => -- Desplazamiento desde la derecha (esd)
                -- Inicializar d con el valor desplazado
                for i in 4 downto 1 loop
                    d(i) <= q(i-1);
                end loop;
                d(0) <= esd;
            when "10" => -- Desplazamiento desde la izquierda (esi)
                -- Inicializar d con el valor desplazado
                for i in 0 to 3 loop
                    d(i) <= q(i+1);
                end loop;
                d(4) <= esi;
            when others => 
                d <= q; -- Almacenamiento (retención)
        end case;
    end process;
		
		
		
		ff: process (clr, clk)
		begin
			if clr = '1' then
				q <= (others => '0');
			elsif rising_edge(clk) then
				q <= d;
			end if;
		end process ff;
		
end A_P8;