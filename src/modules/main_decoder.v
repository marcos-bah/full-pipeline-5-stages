module main_decoder(
    input [6:0] op,
    output reg RegWrite,
    output reg [1:0] ImmSrc,
    output reg ALUSrc,
    output reg MemWrite,
    output reg [1:0] ResultSrc,
    output reg Branch,
    output reg [1:0] ALUOp,
    output reg Jump
);
always @(*) begin
    case(op)
        7'b0000011: begin
            RegWrite = 1; ImmSrc = 2'b00; ALUSrc = 1; MemWrite = 0;
            ResultSrc = 2'b01; Branch = 0; ALUOp = 2'b00; // lw
            Jump = 0;
        end
        7'b0100011: begin
            RegWrite = 0; ImmSrc = 2'b01; ALUSrc = 1; MemWrite = 1;
            ResultSrc = 2'b00; Branch = 0; ALUOp = 2'b00; // sw
            Jump = 0;
        end
        7'b0110011: begin
            RegWrite = 1; ImmSrc = 2'bxx; ALUSrc = 0; MemWrite = 0;
            ResultSrc = 2'b00; Branch = 0; ALUOp = 2'b10; // R-type
            Jump = 0;
        end
        7'b1100011: begin
            RegWrite = 0; ImmSrc = 2'b10; ALUSrc = 0; MemWrite = 0;
            ResultSrc = 2'b00; Branch = 1; ALUOp = 2'b01; // beq
            Jump = 0;
        end
        7'b0010011: begin
            RegWrite = 1; ImmSrc = 2'b00; ALUSrc = 1; MemWrite = 0;
            ResultSrc = 2'b00; Branch = 0; ALUOp = 2'b10; // addi
            Jump = 0;
        end
        7'b1101111: begin
            RegWrite = 1; ImmSrc = 2'b11; ALUSrc = 1; MemWrite = 0;
            ResultSrc = 2'b10; Branch = 0; ALUOp = 2'bxx; // jal
            Jump = 1;
        end
        default: begin
            RegWrite = 0; ImmSrc = 2'b00; ALUSrc = 0; MemWrite = 0;
            ResultSrc = 2'b00; Branch = 0; ALUOp = 2'b00;
            Jump = 0;
        end
    endcase
end
endmodule
