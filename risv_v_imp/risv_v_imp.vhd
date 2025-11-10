library ieee;
use ieee.std_logic_1164.all;

entity risv_v_imp is 

port (	KEY      : 		in 	 std_logic_vector(3 downto 0);
			clock_50 : 		in 	 std_logic;
			LEDR     : 		out 	 std_logic_vector(9 downto 0);
			WriteData:     buffer std_logic_vector (31 downto 0)
);
end risv_v_imp;


architecture struct of risv_v_imp is 

component regfile  						
port(
			  clk  : in  STD_LOGIC;
			  reset: in  STD_LOGIC;
           WE3  : in  STD_LOGIC;
           A1   : in  STD_LOGIC_VECTOR (4 downto 0);
			  A2   : in  STD_LOGIC_VECTOR (4 downto 0);
           A3   : in  STD_LOGIC_VECTOR (4 downto 0);
           WD3  : in  STD_LOGIC_VECTOR (31 downto 0);
           RD1  : out STD_LOGIC_VECTOR (31 downto 0);
           RD2  : out STD_LOGIC_VECTOR (31 downto 0)
			  );	
			  
end component;

component memory   						
    Port ( clk : in  STD_LOGIC;
           WE  : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (31 downto 0);
           WD  : in  STD_LOGIC_VECTOR (31 downto 0);
           RD  : out STD_LOGIC_VECTOR (31 downto 0)
			  );
end component;


component registre 
port (
			  clk   : in  std_logic;
			  reset : in  std_logic;
			  INPUT : in  std_logic_vector(31 downto 0);
			  OUTPUT: out std_logic_vector(31 downto 0)
			  );
end component ;

component register_with_EN 
		 Port (
			  clk    : in  std_logic;
			  reset  : in  std_logic;
			  EN     : in  std_logic;
			  INPUT  : in  std_logic_vector(31 downto 0);
			  OUTPUT : out std_logic_vector(31 downto 0)
			  );
end component ;

component extend_unit 
port(
				ImmSrc1           : in  std_logic_vector(1 downto 0 );
				Input_instruction : in  std_logic_vector(24 downto 0);
				ImmExt            : out std_logic_vector(31 downto 0)
				);

end component ;

component mux_1bit 
    port (
        in0     : in  std_logic_vector(31 downto 0);
        in1     : in  std_logic_vector(31 downto 0);
        sel     : in  std_logic;
        out_mux : out std_logic_vector(31 downto 0)
		  );

end component ;

component mux_2bit 
    port (
        in0     : in  std_logic_vector(31 downto 0);
        in1     : in  std_logic_vector(31 downto 0);
        in2     : in  std_logic_vector(31 downto 0);
        in3     : in  std_logic_vector(31 downto 0);
        sel     : in  std_logic_vector( 1 downto 0);
        out_mux : out std_logic_vector(31 downto 0)
		  );
end component ; 

component alu_rv
    Port (
        a          : in     std_logic_vector(31 downto 0);
        b          : in     std_logic_vector(31 downto 0);
        alucontrol : in     std_logic_vector( 2 downto 0);
		  zero       : out    std_logic;
        result     : buffer std_logic_vector(31 downto 0)
		  );
end component ;

component controller
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
end component ;

signal instera,ALUResult,Result,SrcA,SrcB,ImmExt,A,RD1,RD2,ALUOut,Data,OldPC,instr,PC,PCNext,Adr,ReadData : STD_LOGIC_VECTOR(31 downto 0);
signal quatre :         STD_LOGIC_VECTOR(31 downto 0):="00000000000000000000000000000100";
signal Zero   :         STD_LOGIC;
signal CLK    :         STD_LOGIC;
signal reset  :         STD_LOGIC;
signal PCWrite:         STD_LOGIC;
signal RegWrite:        STD_LOGIC;
signal MemWrite:        STD_LOGIC;
signal IRWrite:         STD_LOGIC;
signal ResultSrc:       STD_LOGIC_VECTOR(1 downto 0);
signal ALUSrcB:         STD_LOGIC_VECTOR(1 downto 0);
signal ALUSrcA:         STD_LOGIC_VECTOR(1 downto 0);
signal AdrSrc:          STD_LOGIC;
signal ImmSrc:    	   STD_LOGIC_VECTOR(1 downto 0);
signal ALUControl:      STD_LOGIC_VECTOR(2 downto 0);

begin 
--using on board components
reset <= KEY(0);
CLK <= clock_50;

		--controle unit mapping
Control_unit :  controller   			port map(instr(6 downto 0),instr(14 downto 12),instr(30),Zero,CLK,reset,PCWrite,RegWrite, MemWrite,IRWrite,ResultSrc,ALUSrcB,ALUSrcA,AdrSrc,ImmSrc,ALUControl);

		--extend unit mapping
Extend_unit_v:  extend_unit  			port map(ImmSrc,instr(31 downto 7),ImmExt);
		
		--register file mapping
Register_File:  regfile     		   port map(CLK,reset,RegWrite,instr(19 downto 15),instr(24 downto 20),instr(11 downto 7),Result,RD1,RD2);
		
		--memory mapping
main_memory  :  memory      			port map(CLK,MemWrite,Adr,WriteData,ReadData);

		--enable register mapping
RD1_reg      :  registre            port map(CLK,reset,RD1,A);
RD2_reg      :  registre            port map(CLK,reset,RD2,WriteData);
AluOUT_reg   :  registre            port map(CLK,reset,ALUResult,ALUOut);
Data_reg     :  registre            port map(CLK,reset,ReadData,Data);
		
		--enable register mapping
PC_reg       :  register_with_EN    port map(CLK,reset,PCWrite,Result,PC);
IR_Instr_reg :  register_with_EN    port map(CLK,reset,IRWrite,ReadData,Instr);
IR_PC_reg    :  register_with_EN    port map(CLK,reset,IRWrite,PC,OldPC);

		--2bit mux mapping
MUX_SrcA     :  mux_2bit            port map(PC,OldPC,A,A,ALUSrcA,SrcA);
MUX_SrcB     :  mux_2bit    		   port map(WriteData,ImmExt,quatre,quatre,ALUSrcB,SrcB);
MUX_Result   :  mux_2bit            port map(ALUOut,Data,ALUResult,ALUResult,ResultSrc,Result);

		--1bit mux mapping
PC_Mux       :  mux_1bit    		   port map(PC,Result,AdrSrc,Adr);

		--ALU mapping
ALU          :  alu_rv      		   port map(SrcA,SrcB,ALUControl,Zero,ALUResult);


ledr <= WriteData(9 downto 0) ;
end struct;