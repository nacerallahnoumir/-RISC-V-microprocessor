library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity alu_rv is
    Port (
        a          : in  std_logic_vector(31 downto 0);
        b          : in  std_logic_vector(31 downto 0);
        alucontrol : in  std_logic_vector( 2 downto 0);
		  zero       : out std_logic;
        result     : buffer std_logic_vector(31 downto 0)
    );
end alu_rv;

architecture Behavioral of alu_rv is
    signal condinvb : std_logic_vector(31 downto 0);
    signal sum      : std_logic_vector(31 downto 0);
	 signal temp     : std_logic_vector(31 downto 0);
    signal cout     : std_logic;
    signal overflow : std_logic;
    signal slt_bit  : std_logic;
    signal b_invert : std_logic;
    signal temp_sum : unsigned(32 downto 0);
begin


	 temp <=  std_logic_vector(unsigned(not b) + "00000000000000000000000000000001");
	  
    -- Conditionally invert B
    condinvb <= temp when alucontrol(0) = '1' else b;

    -- Full Adder
    temp_sum <= unsigned('0' & a) + unsigned('0' & condinvb) ;
    sum      <= std_logic_vector(temp_sum(31 downto 0));
    cout     <= temp_sum(32);

    -- Overflow detection for signed numbers
    overflow <= (a(31) and not condinvb(31) and not sum(31)) or
                (not a(31) and condinvb(31) and sum(31));

    -- SLT logic: sign bit XOR overflow
    slt_bit <= '1'                           when signed(sum) < "00000000000000000000000000000000" else
					'0' ;

    -- ALU Output
    result <= sum                            when alucontrol = "000" else   -- add
              sum                            when alucontrol = "001" else   -- sub
              a and b                        when alucontrol = "010" else   -- and
              a or b                         when alucontrol = "011" else   -- or
              (31 downto 1 => '0') & slt_bit when alucontrol = "101" else   -- slt
              (others => '-'); -- default
				  
	 --zero control 
	 zero <= '1' when result = "00000000000000000000000000000000" else 
				'0' ;

end Behavioral;
