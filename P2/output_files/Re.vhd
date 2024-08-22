library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity Re is
    Port (
        CLKIN : in STD_LOGIC;
        SALIDA : out STD_LOGIC
    );
end Re;

architecture Behavioral of Re is
    -- El contador debe tener suficientes bits para almacenar el valor deseado del intervalo de división.
    -- Ajusta el tamaño del contador según tus necesidades.
    signal contador: UNSIGNED(25 downto 0) := (others => '0');  -- Ejemplo para una división grande.
    constant DIVISOR: UNSIGNED(25 downto 0) := X"000FFF"; -- Ajusta este valor para cambiar la frecuencia.
begin

    RELOJ: process(CLKIN)
    begin
        if rising_edge(CLKIN) then
            if contador = DIVISOR then
                contador <= (others => '0');
                SALIDA <= not SALIDA; -- Cambia el estado del LED.
            else
                contador <= contador + 1;
            end if;
        end if;
    end process;

end Behavioral;
