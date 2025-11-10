 library IEEE;
 use IEEE.STD_LOGIC_1164.all;
 
 entity maindec is
    port(   op:              in  STD_LOGIC_VECTOR(6 downto 0);
				Branch,PCUpdate: out STD_LOGIC;
				RegWrite:        out STD_LOGIC;
				MemWrite:        out STD_LOGIC;
				IRWrite:         out STD_LOGIC;
				ResultSrc:       out STD_LOGIC_VECTOR(1 downto 0);
				ALUSrcB:         out STD_LOGIC_VECTOR(1 downto 0);
				ALUSrcA:         out STD_LOGIC_VECTOR(1 downto 0);
				AdrSrc:          out STD_LOGIC;
				reset:           in  STD_LOGIC;
				CLK:             in  STD_LOGIC;
            ALUOp:           out STD_LOGIC_VECTOR(1 downto 0));
 end maindec;
 
 architecture behave of maindec is
   type StateType is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10); 
   signal current_state, next_state : StateType;
	begin
              -- State register
    process(CLK, reset)
    begin
        if reset = '0' then
            current_state <= S0;
        elsif rising_edge(CLK) then
            current_state <= next_state;
        end if;
    end process;

              -- Next state
    process(current_state, op)
    begin
        case current_state is
            when S0 =>
                next_state <= S1;
                
            when S1 =>
                case op is
                    when "0000011" | "0100011" => -- lw/sw
                        next_state <= S2;
                    when "0110011" => -- R-type
                        next_state <= S6;
                    when "0010011" => -- I-type ALU
                        next_state <= S8;
                    when "1101111" => -- jal
                        next_state <= S9;
                    when "1100011" => -- beq
                        next_state <= S10;
                    when others =>
                        next_state <= S0;
                end case;
                
            when S2 =>
                if op = "0000011" then -- lw
                    next_state <= S3;
                else -- sw
                    next_state <= S5;
                end if;
                
            when S3 =>
                next_state <= S4;
                
            when S4 =>
                next_state <= S0;
                
            when S5 =>
                next_state <= S0;
                
            when S6 =>
                next_state <= S7;
                
            when S7 =>
                next_state <= S0;
                
            when S8 =>
                next_state <= S7;
                
            when S9 =>
                next_state <= S7;
                
            when S10 =>
                next_state <= S0;
                
            when others =>
                next_state <= S0;
        end case;
    end process;

			-- Output 
    process(current_state)
    begin
        -- Default values
        PCUpdate  <= '0';
        AdrSrc    <= '-';
        MemWrite  <= '0';
        IRWrite   <= '0';
        ResultSrc <= "--";
        ALUSrcA   <= "--";
        ALUSrcB   <= "--";
        ALUOp     <= "--";
        RegWrite  <= '0';
        Branch    <= '0';
        

        case current_state is               
            when S0 =>  -- Fetch
                AdrSrc    <= '0';
                IRWrite   <= '1';
                ALUSrcA   <= "00";
                ALUSrcB   <= "10";
                ALUOp     <= "00";
                ResultSrc <= "10";
                PCUpdate  <= '1';


            when S1 =>  -- Decode
                ALUSrcA  <= "01";
                ALUSrcB  <= "01";
                ALUOp    <= "00";

                
            when S2 =>  -- MemAdr
                ALUSrcA <= "10";
                ALUSrcB <= "01";
                ALUOp   <= "00";
                
            when S3 =>  -- MemRead
                ResultSrc <= "00";
                AdrSrc    <= '1';
                
            when S4 =>  -- MemWB
                ResultSrc <= "01";
                RegWrite  <= '1';
                
            when S5 =>  -- MemWrite
                ResultSrc <= "00";
                AdrSrc    <= '1';
                MemWrite  <= '1';
                
            when S6 =>  -- ExecuteR
                ALUSrcA <= "10";
                ALUSrcB <= "00";
                ALUOp   <= "10";
                
            when S7 =>  -- ALUWB
                ResultSrc <= "00";
                RegWrite  <= '1';

                
            when S8 =>  -- ExecuteI
                ALUSrcA <= "10";
                ALUSrcB <= "01";
                ALUOp   <= "10";
                
            when S9 =>  -- JAL
                ALUSrcA   <= "01";
                ALUSrcB   <= "10";
                ALUOp     <= "00";
                ResultSrc <= "00";
                PCUpdate  <= '1';
					 
            when S10 =>  -- BEQ
                ALUSrcA   <= "10";
                ALUSrcB   <= "00";
                ALUOp     <= "01";
                ResultSrc <= "00";
                Branch    <= '1';
                
        end case;
    end process;
 end behave;