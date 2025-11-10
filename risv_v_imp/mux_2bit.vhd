library ieee;
use ieee.std_logic_1164.all;

entity mux_2bit is
    port (
        in0     : in  std_logic_vector(31 downto 0);
        in1     : in  std_logic_vector(31 downto 0);
        in2     : in  std_logic_vector(31 downto 0);
        in3     : in  std_logic_vector(31 downto 0);
        sel     : in  std_logic_vector( 1 downto 0);
        out_mux : out std_logic_vector(31 downto 0)
    );
end mux_2bit;

architecture behavioral of mux_2bit is
begin
    process(in0, in1, in2, in3, sel)
    begin
        case sel is
            when "00" => out_mux <= in0;
            when "01" => out_mux <= in1;
            when "10" => out_mux <= in2;
            when "11" => out_mux <= in3;
            when others => out_mux <= (others => '0'); 
        end case;
    end process;
end behavioral;
