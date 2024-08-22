library ieee;
use ieee.std_logic_1164.all;

entity P1 is 
    port (
        A, B, C, D, REF, SEL: in std_logic_vector(1 downto 0);
        DIG1, DIG2, DIG3, DIG4: out std_logic; -- Salidas para seleccionar el dígito activo
        SEG: out std_logic_vector(7 downto 0) -- Salidas para los segmentos del display y el punto decimal
    );
end P1;

architecture A_P1 of P1 is
    signal dato: std_logic_vector(1 downto 0);
    signal MA, ME, I: std_logic; -- Salidas del comparador
begin 
    -- Multiplexor
    with SEL select
        dato <= A when "00",
                B when "01",
                C when "10",
                D when others;

    -- Comparador
    CM: process(dato, REF)
    begin
        if dato > REF then
            MA <= '1';
            ME <= '0';
            I  <= '0';
        elsif dato < REF then
            MA <= '0';
            ME <= '1';
            I  <= '0';
        else -- Son iguales
            MA <= '0';
            ME <= '0';
            I  <= '1';
        end if;
    end process CM;
    
    -- Decodificador
    DECO: process(MA, ME, I)
    begin
        -- Inicializamos todos los segmentos apagados
        SEG <= (others => '1');
        
        if MA = '1' then
            -- a, b, c, d encendidos
            SEG <= "11110000"; 
        elsif ME = '1' then
            -- Representación de a, f, e, d encendidos
            SEG <= "11000110"; 
        elsif I = '1' then
            -- a y d encendidos
            SEG <= "11110110"; 
        end if;

        -- Asumiendo que queremos mostrar el resultado en DIG2
        DIG1 <= '1';
        DIG2 <= '0'; -- Encendemos DIG2 con un '0'
        DIG3 <= '1';
        DIG4 <= '1';
    end process DECO;

end A_P1;
