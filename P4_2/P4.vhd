LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY P4 IS
    PORT(
        clk, cnt, clr: IN STD_LOGIC;
        contador: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        aux: INOUT STD_LOGIC
    );
END ENTITY P4;

ARCHITECTURE A_P4 OF P4 IS
	constant max_count : natural := 50000000;
	signal clkout: STD_LOGIC;
	signal contadorS: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
    -- Proceso para generar clkout, el reloj dividido
	process(clk)
		variable count: natural range 0 to max_count;
		begin
			if(clk'Event and clk = '1' and count<(max_count/2)-1)then
				clkout<='1';
				count := count+1;
			elsif(clk'Event and clk = '1' and count<max_count-1)then
				clkout<='0';
				count := count+1;
			elsif(clk'Event and clk = '1' and count<max_count)then
				clkout<='1';
				count := 0;
			end if;
	end process;
    
    -- Proceso para el contador, utilizando flip-flops JK con las ecuaciones características
    process (clkout, clr)
    BEGIN     
        IF clr = '0' THEN
            contadorS <= "0000"; -- Resetea el contador
        ELSIF rising_edge(clkout) THEN
            IF cnt = '0' THEN -- El contador solo avanza cuando cnt es '0'.
						-- Flip-Flop JK para Q0 (bit menos significativo)
						contadorS(0) <= NOT contadorS(0); -- Q0 siempre hace toggle.

						-- Flip-Flop JK para Q1
						IF contadorS(0) = '1' THEN
								contadorS(1) <= NOT contadorS(1); -- Q1 hace toggle cuando Q0 es '1'.
						END IF;

						-- Flip-Flop JK para Q2
						IF contadorS(0) = '1' AND contadorS(1) = '1' THEN
								contadorS(2) <= NOT contadorS(2); -- Q2 hace toggle cuando Q0 y Q1 son '1'.
						END IF;
                
						-- Flip-Flop JK para Q3 (bit más significativo)
						IF contadorS(0) = '1' AND contadorS(1) = '1' AND contadorS(2) = '1' THEN
								contadorS(3) <= NOT contadorS(3); -- Q3 hace toggle cuando Q0, Q1, y Q2 son '1'.
						END IF;
            END IF;
        END IF;
    END PROCESS;
	 
	 contador(0) <= NOT contadorS(0);
	 contador(1) <= NOT contadorS(1);
	 contador(2) <= NOT contadorS(2);
	 contador(3) <= NOT contadorS(3);
END ARCHITECTURE A_P4;
