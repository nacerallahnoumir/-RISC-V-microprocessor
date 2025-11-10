library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
	entity registre is
		 Port (
			  clk         : in  std_logic;
			  reset       : in  std_logic;
			  INPUT       : in  std_logic_vector(31 downto 0);
			  OUTPUT      : out std_logic_vector(31 downto 0));
	end registre; 
	
	architecture behav of registre is
		begin
		
			process(clk, reset)
			 begin
				  if reset = '0' then
						 OUTPUT <= (others => '0');
				  elsif rising_edge(clk) then
							  OUTPUT<= INPUT;
				  end if;
				
			 end process;
	 end behav;