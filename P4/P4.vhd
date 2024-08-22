LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY P4 IS
		PORT(
				clk, cnt, clr: IN STD_LOGIC;
				clkout, cntA: INOUT STD_LOGIC;
				contador: INOUT STD_LOGIC_VECTOR(3 DOWNTO 0);
				jk2, jk1, jk0, jk3: inout STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
END ENTITY P4;

ARCHITECTURE A_P4 OF P4 IS
		SIGNAL divisor: INTEGER := 50000000000;
		SIGNAL contadorI: INTEGER := 0;
		signal contadorS: STD_LOGIC_VECTOR(3 DOWNTO 0);
BEGIN
		process (clk)
		BEGIN
				IF rising_edge(clk) THEN
						IF contadorI >= divisor THEN
								clkout <= NOT clkout;
								contadorI <= 0;
						ELSE 
								contadorI <= contadorI + 1;
						END IF;
				END IF;
		END PROCESS;
    
		process (clkout, clr, cnt)
		BEGIN
				
				IF clr = '1' THEN
						contadorS <= ("0000");
				ELSE
						IF rising_edge(clkout) THEN
								jk3(0) <= NOT cnt AND contadorS(2) AND contadorS(1) AND contadorS(0);
								jk3(1) <= jk3(0);
						
								jk2(0) <= NOT cnt AND contadorS(1) AND contadorS(0);
								jk2(1) <= jk2(0);
								
								jk1(0) <= NOT cnt AND contadorS(0);
								jk1(1) <= jk1(0);
								
								jk0(0) <= NOT cnt;
								jk0(1) <= jk0(0);
								
								contadorS(2) <= ((NOT jk2(0)) AND contadorS(2)) OR (jk2(1) AND (NOT contadorS(2)));
								contadorS(1) <= ((NOT jk1(0)) AND contadorS(1)) OR (jk1(1) AND (NOT contadorS(1)));
								contadorS(0) <= ((NOT jk0(0)) AND contadorS(0)) OR (jk0(1) AND (NOT contadorS(0)));
								
						END IF;
				END IF;
				
		END PROCESS;
		
		contador(0) <= NOT contadorS(0);
		contador(1) <= NOT contadorS(1);
		contador(2) <= NOT contadorS(2);
		contador(3) <= NOT contadorS(3);
	 
END A_P4;
