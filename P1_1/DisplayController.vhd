library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity DisplayController is
    Port (
        CLK : in STD_LOGIC;
        A, B, C, D, REF : in STD_LOGIC_VECTOR (1 downto 0);
        SEL : in STD_LOGIC_VECTOR (1 downto 0);
        ANODES : out STD_LOGIC_VECTOR (3 downto 0);
        CATHODES : out STD_LOGIC_VECTOR (7 downto 0)
    );
end DisplayController;

architecture Behavioral of DisplayController is
    signal digit_counter : natural range 0 to 3 := 0;
    signal clk_divider_counter : natural := 0;
    constant CLK_DIVIDER_MAX : natural := 50000;

    -- Definiciones de funciones fuera de cualquier proceso
    function decode_digit(value: STD_LOGIC_VECTOR(1 downto 0)) return STD_LOGIC_VECTOR;
    function select_input(A, B, C, D: STD_LOGIC_VECTOR(1 downto 0); SEL: STD_LOGIC_VECTOR(1 downto 0)) return STD_LOGIC_VECTOR;
    function decode_letter(SEL: STD_LOGIC_VECTOR(1 downto 0)) return STD_LOGIC_VECTOR;
    
begin

    -- Proceso de división de frecuencia y multiplexación
    clk_process : process(CLK)
    begin
        if rising_edge(CLK) then
            if clk_divider_counter < CLK_DIVIDER_MAX then
                clk_divider_counter <= clk_divider_counter + 1;
            else
                clk_divider_counter <= 0; -- Reinicia el contador
                digit_counter <= (digit_counter + 1) mod 4; -- Avanza al siguiente dígito
            end if;
        end if;
    end process;

    -- Proceso para activar el ánodo correspondiente al dígito actual
    anode_process : process(digit_counter)
    begin
        case digit_counter is
            when 0 => ANODES <= "1110"; -- Activa el primer dígito
            when 1 => ANODES <= "1101"; -- Activa el segundo dígito
            when 2 => ANODES <= "1011"; -- Activa el tercer dígito
            when 3 => ANODES <= "0111"; -- Activa el cuarto dígito
            when others => ANODES <= "1111"; -- Ningún dígito activo
        end case;
    end process;

    -- Proceso para determinar los segmentos a mostrar en cada dígito
    segment_process : process(digit_counter, A, B, C, D, REF, SEL)
    begin
        seg_digit1 <= decode_digit(select_input(A, B, C, D, SEL)); -- Para el Dígito 1
        seg_digit2 <= decode_deco_output(...); -- Debes definir cómo se genera esta señal
        seg_digit3 <= decode_digit(REF); -- Para el Dígito 3
        seg_digit4 <= decode_letter(SEL); -- Para el Dígito 4

        -- Selección del patrón de segmentos basado en el dígito activo
        case digit_counter is
            when 0 => CATHODES <= seg_digit1;
            when 1 => CATHODES
            when 1 => CATHODES <= seg_digit2; -- Para el Dígito 2
            when 2 => CATHODES <= seg_digit3; -- Para el Dígito 3
            when 3 => CATHODES <= seg_digit4; -- Para el Dígito 4
            when others => CATHODES <= "11111111"; -- Apaga todos los segmentos si es necesario
        end case;
    end process;

    -- Función para decodificar el valor numérico a segmentos del display
    decode_digit := function(value: STD_LOGIC_VECTOR(1 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case value is
            when "00" => result := "00111111"; -- 0
            when "01" => result := "00000110"; -- 1
            when "10" => result := "01011011"; -- 2
            when others => result := "00000000"; -- Apaga todos los segmentos para cualquier otro caso
        end case;
        return result;
    end function decode_digit;

    -- Función para seleccionar la entrada basada en SEL
    select_input := function(A, B, C, D: STD_LOGIC_VECTOR(1 downto 0); SEL: STD_LOGIC_VECTOR(1 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case SEL is
            when "00" => return A;
            when "01" => return B;
            when "10" => return C;
            when others => return D;
        end case;
    end function select_input;

    decode_letter := function(SEL: STD_LOGIC_VECTOR(1 downto 0)) return STD_LOGIC_VECTOR is
    begin
        case SEL is
            when "00" => result := "01000000"; -- Representación simplificada de 'A'
            when "01" => result := "01111001"; -- Representación simplificada de 'B'
            when "10" => result := "01110000"; -- Representación simplificada de 'C'
            when "11" => result := "01000000"; -- 'A' nuevamente para el caso "11", ajusta según necesidad
            when others => result := "00000000"; -- Apaga todos los segmentos
        end case;
        return result;
    end function decode_letter;

end Behavioral;
