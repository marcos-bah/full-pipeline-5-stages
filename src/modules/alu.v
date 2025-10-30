module alu(
    input [3:0] ALUControl,
    input [31:0] SrcA,
    input [31:0] SrcB,
    output reg [31:0] ALUResult,
    output reg Zero
);

    reg [31:0] ResultReg;
    wire [31:0] temp, Sum;
    wire V, slt, sltu; //overflow

    assign temp = ALUControl[0] ? ~SrcB : SrcB;

    assign Sum = SrcA + temp + ALUControl[0];

    assign V = (ALUControl[0]) ? (~(SrcA[31] ^ SrcB[31]) & (SrcA[31] ^ Sum[31])) : ((SrcA[31] ^ SrcB[31]) & (~(SrcA[31] ^ Sum[31]))); 

    assign slt = (SrcA[31] == SrcB[31]) ? (SrcA < SrcB) : SrcA[31]; 

    assign sltu = SrcA < SrcB;

    always@(*)
    case(ALUControl)
        4'b0000: ResultReg <= Sum; //add
        4'b0001: ResultReg <= Sum; //sub
        4'b0010: ResultReg <= SrcA & SrcB; //and
        4'b0011: ResultReg <= SrcA | SrcB; //or
        4'b0100: ResultReg <= SrcA ^ SrcB; //xor

        4'b0101: ResultReg <= {31'b0,slt}; //slt
        4'b0110: ResultReg <= {31'b0,sltu}; // sltu
        4'b0111: ResultReg <= {SrcA[31:12],12'b0}; //lui
        4'b1000: ResultReg <= SrcA + {SrcB[31:12],12'b0}; // AUIPC
        4'b1001: ResultReg <= {SrcB[31:12],12'b0}; // LUI

        4'b1010: ResultReg <= SrcA << SrcB; // sll, slli
        4'b1011: ResultReg <= SrcA >>> SrcB; // sra
        4'b1100: ResultReg <= SrcA >> SrcB; // srl
        default:  ResultReg <= 'bx;
    endcase

    assign Zero = (ResultReg == 32'b0);
    assign ALUResult = ResultReg;
endmodule