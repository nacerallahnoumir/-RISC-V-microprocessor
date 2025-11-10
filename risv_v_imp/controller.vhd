library IEEE;
 use IEEE.STD_LOGIC_1164.all;
 
 entity controller is
    port(op:     			 in     STD_LOGIC_VECTOR(6 downto 0);
			funct3: 			 in     STD_LOGIC_VECTOR(2 downto 0);
			funct7b5, Zero: in     STD_LOGIC;
			CLK:            in     STD_LOGIC;
			reset:          in     STD_LOGIC;
			PCWrite:        out    STD_LOGIC;
						--main fsm
			RegWrite:       out STD_LOGIC;
			MemWrite:       out STD_LOGIC;
			IRWrite:        out STD_LOGIC;
			ResultSrc:      out STD_LOGIC_VECTOR(1 downto 0);
			ALUSrcB:        out STD_LOGIC_VECTOR(1 downto 0);
			ALUSrcA:        out STD_LOGIC_VECTOR(1 downto 0);
			AdrSrc:         out STD_LOGIC;
						--instr decoder
			ImmSrc:    		 out    STD_LOGIC_VECTOR(1 downto 0);
			         --alu control
			ALUControl:     out    STD_LOGIC_VECTOR(2 downto 0));
 end controller;
 
 architecture struct of controller is
 
 component maindec
     port(  op:              in  STD_LOGIC_VECTOR(6 downto 0);
				Branch :         out STD_LOGIC;
				PCUpdate:        out STD_LOGIC;
				RegWrite:        out STD_LOGIC;
				MemWrite:        out STD_LOGIC;
				IRWrite:         out STD_LOGIC;
				ResultSrc:       out STD_LOGIC_VECTOR(1 downto 0);
				ALUSrcB:         out STD_LOGIC_VECTOR(1 downto 0);
				ALUSrcA:         out STD_LOGIC_VECTOR(1 downto 0);
				AdrSrc:          out STD_LOGIC;
				reset:           in  STD_LOGIC;
				CLK  :           in  STD_LOGIC;
            ALUOp:           out STD_LOGIC_VECTOR(1 downto 0));
 end component;
 
 component aludec
    port(  opb5:       in  STD_LOGIC;
           funct3:     in  STD_LOGIC_VECTOR(2 downto 0);
           funct7b5:   in  STD_LOGIC;
           ALUOp:      in  STD_LOGIC_VECTOR(1 downto 0);
           ALUControl: out STD_LOGIC_VECTOR(2 downto 0));
 end component;
		
 component instrdec
     port(ImmSrc: out     STD_LOGIC_VECTOR(1 downto 0);
				op:   in     STD_LOGIC_VECTOR(6 downto 0));
 end component;
	  
     signal ALUOp:           STD_LOGIC_VECTOR(1 downto 0);
     signal Branch,PCUpdate: STD_LOGIC;
 begin
     md: maindec  port map(op,Branch,PCUpdate,RegWrite,MemWrite,IRWrite,ResultSrc, ALUSrcB,ALUSrcA,AdrSrc,reset,CLK,ALUOp);
     ad: aludec   port map(op(5), funct3, funct7b5, ALUOp, ALUControl);
	  id: instrdec port map(ImmSrc,op);
     PCWrite <= (Branch and Zero) or PCUpdate;
 end struct; 
