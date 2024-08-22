LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL; 

ENTITY P3 IS
    PORT (
        CLK, CLR: IN STD_LOGIC;
        CONTROL: IN STD_LOGIC_VECTOR (1 DOWNTO 0);
        RELOJ, SALIDA: INOUT STD_LOGIC; 
        c, c0, c1: OUT STD_LOGIC
    );        
END P3;

ARCHITECTURE A_P3 OF P3 IS
    SIGNAL DIVISOR: INTEGER;
    SIGNAL CONTADOR: INTEGER := 0;
BEGIN
    PROCESS (CONTROL)
    BEGIN
        CASE CONTROL IS
            WHEN "00" => DIVISOR <= 50000000000; -- 1 Hz
			WHEN "01" => DIVISOR <= 25000000000; -- 2 Hz
			WHEN "10" => DIVISOR <= 500000000;   -- 100 Hz
			WHEN OTHERS => DIVISOR <= 50000000;  -- 1 kHz

        END CASE;
    END PROCESS;

    PROCESS (CLR, CLK)
    BEGIN
        c <= CLR;
        c0 <= CONTROL(0);
        c1 <= CONTROL(1);
        IF CLR = '0' THEN
            CONTADOR <= 0; 
            SALIDA <= '0'; 
        ELSIF rising_edge(CLK) THEN 
            IF CONTADOR >= DIVISOR THEN
                SALIDA <= NOT SALIDA;
                CONTADOR <= 0;
            ELSE
                CONTADOR <= CONTADOR + 1;
            END IF;
        END IF;
    END PROCESS;

    RELOJ <= CLK;

END A_P3;
