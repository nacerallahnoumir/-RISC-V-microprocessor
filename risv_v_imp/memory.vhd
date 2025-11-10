library IEEE;  
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;
use ieee.std_logic_textio.all;

entity memory is
    Port ( clk : in  STD_LOGIC;
           WE  : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (31 downto 0);
           WD  : in  STD_LOGIC_VECTOR (31 downto 0);
           RD  : out STD_LOGIC_VECTOR (31 downto 0));
end memory;

architecture Behavioral of memory is

    type RAM_Type is array (0 to 100) of STD_LOGIC_VECTOR(31 downto 0);

    signal RAM : RAM_type := (
	 0  => "00000000010100000000000100010011",  
    1  => "00000000110000000000000110010011",  
    2  => "11111111011100011000001110010011",
	 3  => "00000000001000111110001000110011",
	 4  => "00000000010000011111001010110011",
	 5  => "00000000010000101000001010110011",
	 6  => "00000010011100101000100001100011",
	 7  => "00000000010000011010001000110011",
	 8  => "00000000000000100000010001100011",
    9  => "00000000000000000000001010010011",
	 10 => "00000000001000111010001000110011",
	 11 => "00000000010100100000001110110011",
	 12 => "01000000001000111000001110110011",
	 13 => "00000100011100011010101000100011",
	 14 => "00000110000000000010000100000011",
	 15 => "00000000010100010000010010110011",
	 16 => "00000000100000000000000111101111",	 
	 17 => "00000000000100000000000100010011",
	 18 => "00000000100100010000000100110011",
	 19 => "00000010001000011010000000100011",
	 20 => "00000000001000010000000001100011",

	 

	 
    others => (others => '0') 
);

begin
	 
    -- Lecture combinatoire
    RD <= RAM(to_integer(unsigned(A(31 downto 2))));

    -- Écriture synchrone
    process(clk)
    begin
        if rising_edge(clk) then
            if WE = '1' then
				    
                RAM(to_integer(unsigned(A(31 downto 2)))) <= WD;
            end if;
        end if;
    end process;

end Behavioral;
