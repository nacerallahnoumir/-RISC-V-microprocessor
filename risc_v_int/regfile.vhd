library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity regfile is
    Port ( clk  : in  STD_LOGIC;
			  reset: in  STD_LOGIC;
           WE3  : in  STD_LOGIC;
           A1   : in  STD_LOGIC_VECTOR ( 4 downto 0);
			  A2   : in  STD_LOGIC_VECTOR ( 4 downto 0);
           A3   : in  STD_LOGIC_VECTOR ( 4 downto 0);
           WD3  : in  STD_LOGIC_VECTOR (31 downto 0);
           RD1  : out STD_LOGIC_VECTOR (31 downto 0);
           RD2  : out STD_LOGIC_VECTOR (31 downto 0)
			  );
end regfile;

architecture Behav of regfile is
    type reg_array is array (0 to 31) of STD_LOGIC_VECTOR(31 downto 0);
    signal rf : reg_array := (others => (others => '0')); 
begin
    process(clk,reset)
    begin
		if reset='0' then rf<=(others => (others => '0')); 
        elsif rising_edge(clk) then
            if WE3 = '1' then
                rf(to_integer(unsigned(A3))) <= WD3; 
            end if;
        
		end if;  
    end process;

    RD1 <= "00000000000000000000000000000000" when (A1 = "00000") else rf(to_integer(unsigned(A1)));  -- asynchronous reads
    RD2 <= "00000000000000000000000000000000" when (A2 = "00000") else rf(to_integer(unsigned(A2)));

end Behav;