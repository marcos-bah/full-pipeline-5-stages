module extend(
	input wire [31:7] Instr,
	input wire [1:0] ImmSrc, 
	output wire [31:0] ImmExt 
);
    reg [31:0] ImmExtReg;

    always@(*)
    case(ImmSrc)
        //I-type
        2'b00: ImmExtReg = {{20{Instr[31]}},Instr[31:20]};
        //S-type
        2'b01: ImmExtReg = {{20{Instr[31]}},Instr[31:25],Instr[11:7]};
        //B-type
        2'b10: ImmExtReg = {{20{Instr[31]}},Instr[7],Instr[30:25],Instr[11:8],1'b0};
        //J-type
        2'b11: ImmExtReg = {{12{Instr[31]}},Instr[19:12],Instr[20],Instr[30:21],1'b0};
        default: ImmExtReg = 32'b0; 
    endcase
   
    assign ImmExt = ImmExtReg;
endmodule