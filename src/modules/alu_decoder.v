module alu_decoder(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7b5,
    output reg [2:0] ALUControl
);
always @(*) begin
    case(ALUOp)
        2'b00: ALUControl = 3'b000; // add (para lw/sw)
        2'b01: ALUControl = 3'b001; // sub (para beq)
        2'b10: begin
            case({funct7b5, funct3})
                4'b0000: ALUControl = 3'b000; // add
                4'b1000: ALUControl = 3'b001; // sub
                4'b0111: ALUControl = 3'b010; // and
                4'b0110: ALUControl = 3'b011; // or
                4'b0010: ALUControl = 3'b101; // slt
                default: ALUControl = 3'b000;
            endcase
        end
        default: ALUControl = 3'b000;
    endcase
end
endmodule
