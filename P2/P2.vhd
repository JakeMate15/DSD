library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.ALL;
use IEEE.std_logic_unsigned.ALL;

entity P2 is
	port(
			CLOCK : in std_logic;
			SEL, JK, SR : in STD_LOGIC_VECTOR(1 downto 0);
			Q, NQ: inout STD_LOGIC;
			D, CLR, PRE, T : in STD_LOGIC
	);
end P2;

architecture PP2 of P2 is
	constant max_count : natural := 50000000;
	signal clk: STD_LOGIC;
begin
	process(CLOCK)
		variable count: natural range 0 to max_count;
		begin
			if(CLOCK'Event and CLOCK = '1' and count<(max_count/2)-1)then
				clk<='1';
				count := count+1;
			elsif(CLOCK'Event and CLOCK = '1' and count<max_count-1)then
				clk<='0';
				count := count+1;
			elsif(CLOCK'Event and CLOCK = '1' and count<max_count)then
				clk<='1';
				count := 0;
			end if;
	end process;
		
	process (clk, clr, sel, d, t, jk, sr)
	begin
	
		if clr = '1' then
			q <= '0';
			nq <= '1';
		elsif clk'Event and clk = '1' then
--			if pre = '1' then
--				q <= '1';
--				nq <= '0';
--			else
				case SEL is
					when "11" => --JK
						q <= ((NOT JK(0)) AND Q) OR (JK(1) AND (NOT Q));
						nq <= NOT (((NOT JK(0)) AND Q) OR (JK(1) AND (NOT Q)));
					when "00" => -- D
						q <= not D;
						nq <= D;
					when "01" => -- T
						q <= ((NOT T) AND Q) OR (T AND (NOT Q));
						nq <= NOT(((NOT T) AND Q) OR (T AND (NOT Q)));
					when others => -- SR
						if sr(1) = '1' and sr(0) = '1' then
							q <= '0';
							nq <= '0';
						else 
							q <= SR(1) OR ((NOT SR(0)) AND Q); 
							nq <= NOT (SR(1) OR ((NOT SR(0)) AND Q));
						end if;
				end case;
--			end if;
		end if;
	end process;
		
end PP2;



LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;

ENTITY P4 IS
    PORT(
        clk, cnt, clr: IN STD_LOGIC;
        contador: INOUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        aux: INOUT STD_LOGIC
    );
END ENTITY P4;

ARCHITECTURE A_P4 OF P4 IS
	constant max_count : natural := 50000000;
	signal clkout: STD_LOGIC;
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
            contador <= "111"; -- Resetea el contador
        ELSIF rising_edge(clkout) THEN
            IF cnt = '0' THEN -- El contador solo avanza cuando cnt es '0'.
                -- Flip-Flop JK para Q0 (bit menos significativo)
                contador(0) <= NOT contador(0); -- Q0 siempre hace toggle.
                
                -- Flip-Flop JK para Q1
                IF contador(0) = '1' THEN
                    contador(1) <= NOT contador(1); -- Q1 hace toggle cuando Q0 es '1'.
                END IF;
                
                -- Flip-Flop JK para Q2 (bit más significativo)
                IF contador(0) = '1' AND contador(1) = '1' THEN
                    contador(2) <= NOT contador(2); -- Q2 hace toggle cuando Q0 y Q1 son '1'.
                END IF;
            END IF;
        END IF;
    END PROCESS;
END ARCHITECTURE A_P4;
