library ieee;
use ieee.std_logic_1164.all;

entity P8 is
    port(
        esd, esi, clr, reloj: in std_logic;
        cnt: in std_logic_vector(1 downto 0);
        ep: in std_logic_vector(3 downto 0);
        q: inout std_logic_vector(3 downto 0)
    );
end P8;

architecture A_P8 of P8 is
	signal clk: std_logic := '0'; 
	constant divisor: integer := 25000000;
	signal contador: integer := 0;

	signal d: std_logic_vector(3 downto 0);
	
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
	
	
	
    process (cnt, ep, esd, esi, q)
    begin
        case cnt is
            when "00" => 
                d <= ep; 
            when "01" => 
                for i in 3 downto 1 loop
                    d(i) <= q(i-1);
                end loop;
                d(0) <= esd;
            when "10" =>
                for i in 0 to 2 loop
                    d(i) <= q(i+1);
                end loop;
                d(3) <= esi;
            when others => 
                d <= q; 
        end case;
    end process;
		
		
		
		ff: process (clr, clk)
		begin
			if clr = '1' then
				q <= (others => '1');
			elsif rising_edge(clk) then
				q <= d;
			end if;
		end process ff;
		
end A_P8;