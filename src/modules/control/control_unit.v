module control_unit(
    PCSrc, ResultSrc, MemWrite, ALUControl, ALUSrc, 
    ImmSrc, RegWrite, Jump, jumpAddress, Branch,
    op, funct3, funct7, Zero
);
    input       [ 6:0]  op;
    input       [ 2:0]  funct3;
    input               funct7;
    input               Zero;

    output              PCSrc;
    output reg          ResultSrc;
    output reg          MemWrite;
    output reg  [ 2:0]  ALUControl;
    output reg          ALUSrc;
    output reg  [ 1:0]  ImmSrc;
    output reg          RegWrite;
    output reg          Jump;
    output reg  [31:0]  jumpAddress;
    output reg          Branch;

    reg         [ 1:0]  alu_mode;

    assign PCSrc = Zero & Branch;

    // decodificador principal
    always @(*) begin
        ResultSrc <= 0;
        MemWrite <= 0;
        ALUControl <= 3'b000;
        ALUSrc <= 0;
        ImmSrc <= 2'b00;
        RegWrite <= 0;
        Branch <= 0;
        alu_mode <= 2'b00;

        case (op)
            7'b000_0011: begin // lw
                RegWrite <= 1;
                ALUSrc <= 1;
                ResultSrc <= 1;
                alu_mode <= 2'b00;
            end
            7'b010_0011: begin // sw
                MemWrite <= 1;
                ALUSrc <= 1;
                ImmSrc <= 2'b01;
                alu_mode <= 2'b00;
            end
            7'b011_0011: begin // r-type
                RegWrite <= 1;
                alu_mode <= 2'b10;
            end
            7'b110_0011: begin // beq
                ImmSrc <= 2'b10;
                Branch <= 1;
                alu_mode <= 2'b01;
            end
            7'b001_0011: begin // addi
                RegWrite <= 1;
                ALUSrc <= 1;
                alu_mode <= 2'b10;
            end
            7'b1101111: begin // jal
                RegWrite <= 1;
                ImmSrc <= 2'b11;
                Jump <= 1;
            end
            default: begin // def
                ResultSrc <= 0;
                MemWrite <= 0;
                ALUControl <= 3'b111;
                ALUSrc <= 0;
                ImmSrc <= 2'b00;
                RegWrite <= 0;
                Branch <= 0;
                alu_mode <= 2'b00;
                Jump <= 0;
            end
        endcase
    end

    // decodificador ALU
    always @(*) begin
        case (alu_mode)
            2'b00: ALUControl <= 3'b000; // add
            2'b01: ALUControl <= 3'b001; // sub
            2'b10: begin
                case (funct3)
                    3'b000: ALUControl <= ({op[5], funct7} == 2'b11) ? 3'b001 : 3'b000; // ? sub : add
                    3'b010: ALUControl <= 3'b101; // slt
                    3'b110: ALUControl <= 3'b011; // or
                    3'b111: ALUControl <= 3'b010; // and
                    default: ALUControl <= 3'b111;
                endcase
            end
            default: ALUControl <= 3'b111;
        endcase
    end

endmodule
