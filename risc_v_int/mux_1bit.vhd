library ieee;
use ieee.std_logic_1164.all;

entity mux_1bit is
    port (
        in0     : in std_logic_vector(31 downto 0);
        in1     : in std_logic_vector(31 downto 0);
        sel     : in std_logic;
        out_mux : out std_logic_vector(31 downto 0)
    );
end mux_1bit;

architecture behavioral of mux_1bit is
begin
    process(in0, in1, sel)
    begin
        if sel = '0' then
            out_mux <= in0;
        else
            out_mux <= in1;
        end if;
    end process;
end behavioral;
