library ieee;
use ieee.std_logic_1164.all;
use IEEE.numeric_std.all;

entity p5 is
    port(
        clk, clr: in std_logic;
        control: in std_logic_vector(1 downto 0);
        prioridad: in std_logic_vector(9 downto 0);
        display: inout std_logic_vector(11 downto 0);
		  aux: out std_logic_vector(3 downto 0)
    );
end entity;

architecture a_p5 of p5 is
	constant d0 : STD_LOGIC_VECTOR(11 downto 0) := "110000001110"; -- 0
   constant d1 : STD_LOGIC_VECTOR(11 downto 0) := "111110011110"; -- 1
   constant d2 : STD_LOGIC_VECTOR(11 downto 0) := "101001001110"; -- 2
   constant d3 : STD_LOGIC_VECTOR(11 downto 0) := "101100001110"; -- 3
   constant d4 : STD_LOGIC_VECTOR(11 downto 0) := "100110011110"; -- 4
   constant d5 : STD_LOGIC_VECTOR(11 downto 0) := "100100101110"; -- 5
   constant d6 : STD_LOGIC_VECTOR(11 downto 0) := "100000101110"; -- 6
   constant d7 : STD_LOGIC_VECTOR(11 downto 0) := "111110001110"; -- 7
   constant d8 : STD_LOGIC_VECTOR(11 downto 0) := "100000001110"; -- 8
   constant d9 : STD_LOGIC_VECTOR(11 downto 0) := "100100001110"; -- 9
   constant off : STD_LOGIC_VECTOR(11 downto 0) := "111111111110"; 
	
	constant max_count : natural := 50000000;
	signal clkout: STD_LOGIC;
	signal entrada: std_logic_vector(3 downto 0);
	
begin

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
	 
	 
	process(prioridad)

	begin
		entrada <= "0000";
		for i in 9 downto 0 loop
			if prioridad(i) = '1' then
				entrada <= std_logic_vector(to_unsigned(i, 4));
				exit; 
			 end if;
		end loop;
	end process;
	 
	 
	process(clkout, clr, entrada, control)
	
	begin
		aux <= not entrada;
	
		if clr = '0' then
			display <= d0;
		elsif rising_edge(clkout) then
			case control is
				when "00" =>
					case entrada is
						when "0000" => display <= d0; -- 0
						when "0001" => display <= d1; -- 1
						when "0010" => display <= d2; -- 2
						when "0011" => display <= d3; -- 3
						when "0100" => display <= d4; -- 4
						when "0101" => display <= d5; -- 5
						when "0110" => display <= d6; -- 6
						when "0111" => display <= d7; -- 7
						when "1000" => display <= d8; -- 8
						when "1001" => display <= d9; -- 9
						when others => display <= "111111111110";
					end case;
					
				when "01" => --a
					case display is
						when d0 => display <= d1; -- 0
						when d1 => display <= d2; -- 1
						when d2 => display <= d3; -- 2
						when d3 => display <= d4; -- 3
						when d4 => display <= d5; -- 4
						when d5 => display <= d6; -- 5
						when d6 => display <= d7; -- 6
						when d7 => display <= d8; -- 7
						when d8 => display <= d9; -- 8
						when d9 => display <= d0; -- 9
						when others => display <= "111111111110";
					end case;

					
				when "10" =>
					case display is
						when d0 => display <= d9; -- 0
						when d1 => display <= d0; -- 1
						when d2 => display <= d1; -- 2
						when d3 => display <= d2; -- 3
						when d4 => display <= d3; -- 4
						when d5 => display <= d4; -- 5
						when d6 => display <= d5; -- 6
						when d7 => display <= d6; -- 7
						when d8 => display <= d7; -- 8
						when d9 => display <= d8; -- 9
						when others => display <= "111111111110";
					end case;
					
					when others => display <= display;
			end case;
		end if;
	end process;


end architecture;