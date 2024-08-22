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
	
	
	
		 mux0: process(cnt)
		 begin
			  case cnt is
					when "00" => d(0) <= ep(0);
					when "01" => d(0) <= esd;
					when "10" => d(0) <= q(1);
					when others => d(0) <= q(0);
			  end case;
		 end process mux0;
		 
		 mux1: Process(cnt)
		 begin
			  case cnt is
					when "00" => d(1) <= ep(1);
					when "01" => d(1) <= q(0);
					when "10" => d(1) <= q(2);
					when others => d(1) <= q(1);
			  end case;
		 end process mux1;
		 
		 mux2: Process(cnt)
		 begin
			  case cnt is
					when "00" => d(2) <= ep(2);
					when "01" => d(2) <= q(1);
					when "10" => d(2) <= q(3);
					when others => d(2) <= q(2);
			  end case;
		 end process mux2;
		 
		 mux3: Process(cnt)
		 begin
			  case cnt is
					when "00" => d(3) <= ep(3);
					when "01" => d(3) <= q(2);
					when "10" => d(3) <= esi;
					when others => d(3) <= q(3);
			  end case;
		 end process mux3;
		
		
		ff: process (clr, clk)
		begin
			if clr = '1' then
				q <= (others => '1');
			elsif rising_edge(clk) then
				q <= d;
			end if;
		end process ff;
		
end A_P8;