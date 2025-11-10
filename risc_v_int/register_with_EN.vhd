library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
	entity register_with_EN	is
		 Port (
			  clk    : in  std_logic;
			  reset  : in  std_logic;
			  EN     : in  std_logic;
			  INPUT  : in  std_logic_vector(31 downto 0);
			  OUTPUT : out std_logic_vector(31 downto 0));
	end register_with_EN; 
	
	architecture behav of register_with_EN is
		begin
		
			process(clk, reset)
			 begin
				  if reset = '0' then
						 OUTPUT <= (others => '0');
				  elsif rising_edge(clk) then
						if EN = '1' then
							  OUTPUT<= INPUT;
						end if;
				  end if;
			 end process;
	 end behav;