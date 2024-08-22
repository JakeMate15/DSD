LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.all;

entity ff is
    port(
        clk : in std_logic;
        clr, pre : in std_logic;
        s, r : in std_logic;
        q, nq : inout std_logic;
        clk_out : inout std_logic;
		  aux : out std_logic
    );
end entity ff;

architecture f of ff is
    signal contador : integer := 0;
    signal q_int : std_logic := '0';
begin

    process(clk)
    begin
        if rising_edge(clk) then
            if contador = 1000000 then
                clk_out <= not clk_out;
                contador <= 0;
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;

	process(clk_out, clr, pre, r, s)
	begin

		if clr = '1' then
		q <= '0';
		nq <= '1';
			--q_int <= '0';
--		elsif pre = '1' then
	--		q_int <= '1';
		elsif rising_edge(clk_out) then
			if pre = '0' then
			q <= '1';
			nq <= '0';
			--	q_int <= '1';
		--	aux <= '1';
			elsif s<= '1' then 
			q <= '1';
			nq <= '0';
			else 
			q <= '0';
			nq <= '1';
			
				--q_int <= s;
			end if;
	end if;
		 
	--	q <= q_int;
		--nq <= not q_int;
	end process;

end architecture f;
