library IEEE;
 use IEEE.STD_LOGIC_1164.all;
 
 entity instrdec is
    port( ImmSrc: out     STD_LOGIC_VECTOR(1 downto 0);
			 op:      in     STD_LOGIC_VECTOR(6 downto 0)
	 );

 end instrdec;
 
 architecture behave of instrdec is
       signal control: STD_LOGIC_VECTOR(1 downto 0);
		 begin
			 process(op) begin
				 case op is
						when "0000011" | "0010011" => control <=  "00"; -- lw or I–type ALU
						when "0100011" 				 => control <= "01"; -- sw
						when "1100011" 				 => control <= "10"; -- beq
						when "1101111" 				 => control <= "11"; -- jal
						when others   					 => control <= "00"; -- not valid or R-type
				 end case;
			 end process;
			  ImmSrc <= control;
 end behave;
 