library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity P1 is
    Port ( 
				anodes : out  STD_LOGIC_VECTOR (3 downto 0);
				clk : in  STD_LOGIC;
				cathods : out  STD_LOGIC_VECTOR (7 downto 0));
end P1;

architecture Behavioral of P1 is
 signal digit0 :   std_logic_vector (7 downto 0);
 signal anodeval : std_logic_vector (3 downto 0);
 signal counter : natural range 0 to 9 := 0;
 signal clk_counter : natural range 0 to 100000 := 0;
 signal digit_number : natural range 0 to 4 :=0;
 
  
begin

 process(clk)
 begin 
  if rising_edge(clk) then 
   clk_counter <= clk_counter + 1; 
   if clk_counter >= 100000 then 
     clk_counter <= 0;
     digit_number <= digit_number +1;
     if digit_number >=4 then
     digit_number <=0;
     end if; 
   end if; 
  end if; 
 end process;
 
 process(digit_number)
 begin
  case digit_number is
   when 0 =>  anodeval <= "1110";
   when 1 =>  anodeval <= "1101";
   when 2 =>  anodeval <= "1011";
   when 3 =>  anodeval <= "0111";
   when 4 =>  anodeval <= "1111";
  end case;
 end process;
 
 process(digit_number)
 begin
  case digit_number is
   when 0 =>  counter <= 1;
   when 1 =>  counter <= 2;
   when 2 =>  counter <= 3;
   when 3 =>  counter <= 4;
   when 4 =>  counter <= 0;
  end case;
 end process;
-- 
 process(counter)
 begin 
  case counter is 
   when 0 => cathods <= "11000000"; --0
   when 1 => cathods <= "11111001"; --1
   when 2 => cathods <= "10100100"; --2
   when 3 => cathods <= "10110000"; --3
   when 4 => cathods <= "10011001"; --4
   when 5 => cathods <= "10010010"; --5
   when 6 => cathods <= "10000010"; --6
   when 7 => cathods <= "11111000"; --7
   when 8 => cathods <= "10000000"; --8
   when 9 => cathods <= "10010000"; --9
  end case;
 end process;
 
 
 
 anodes <= anodeval;
 --cathods  <=  digit0;

end Behavioral;