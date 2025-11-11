module alu(
    input  wire [31:0] SrcA,
    input  wire [31:0] SrcB,
    input  wire [2:0]  ALUControl,
    output wire        Zero,
    output reg  [31:0] ALUResult
);

    wire [31:0] b_mux;
    wire        adder_cin;
    wire [31:0] adder_out;
    wire [31:0] and_out;
    wire [31:0] or_out;
    wire [31:0] slt_out;

    adder add(
        .a   (SrcA),
        .b   (b_mux),
        .cin (adder_cin),
        .result (adder_out),
        .cout ()
    );

    assign Zero = (ALUResult == 32'h00000000);
    assign b_mux     = (!ALUControl[1] && ALUControl[0]) ? (~SrcB) : SrcB;
    assign adder_cin = (!ALUControl[1] && ALUControl[0]);
    assign and_out   = SrcA & SrcB;
    assign or_out    = SrcA | SrcB;

    assign slt_out[31:1] = {31{1'b0}};
    assign slt_out[0] = (SrcA[31] ^ SrcB[31]) ? SrcA[31] : adder_out[31];

    always @(*) begin
        case(ALUControl)
            3'b000:  ALUResult = adder_out; // soma
            3'b001:  ALUResult = adder_out; // sub
            3'b010:  ALUResult = and_out;   // and
            3'b011:  ALUResult = or_out;    // or
            3'b101:  ALUResult = slt_out;   // slt
            default: ALUResult = 32'h00000000; // def
        endcase
    end

endmodule
