library ieee;
use ieee.std_logic_1164.all;

entity extend_unit is 

	Port (	
				ImmSrc1 :			  in  std_logic_vector(1  downto 0);
				Input_instruction : in  std_logic_vector(24 downto 0);
				ImmExt : 			  out std_logic_vector(31 downto 0) 
			); 

end extend_unit ;


architecture comportement of extend_unit is 
signal signal_interne : std_logic_vector(31 downto 0) ;
begin 
	process(ImmSrc1)
		begin 
			-- creation d un signal de 32 bit pour simplifier le controle :
			signal_interne(6 downto 0) <= (others => '0'); 
			signal_interne(31 downto 7) <= Input_instruction; 
			--traitement: 
			case ImmSrc1 is 
				when "00" => -- cas de I 
				ImmExt <= (31 downto 12 => signal_interne(31)) & signal_interne(31 downto 20);
				when "01" => -- cas de S
				ImmExt <= (31 downto 12 => signal_interne(31)) & signal_interne(31 downto 25) & signal_interne(11 downto 7);
				when "10" =>  -- cas de B
				ImmExt <= (31 downto 12 => signal_interne(31))& signal_interne(7) & signal_interne(30 downto 25) & signal_interne(11 downto 8) & '0';
				when "11" =>  -- cas de J
				ImmExt <= (31 downto 20 => signal_interne(31))& signal_interne(19 downto 12) & signal_interne(20) & signal_interne(30 downto 21) & '0';
				when others =>
				ImmExt <= (others => '0');
			end case;

	end process;
end comportement ;


