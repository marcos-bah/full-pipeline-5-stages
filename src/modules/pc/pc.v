module pc (
    input  wire        clk,
    input  wire        rst,
    input  wire        branchFlag,
    input  wire        zeroFlag,
    input  wire        jumpFlag,
    input  wire [31:0] jumpAddress,
    input  wire [31:0] branchOffset,
    output wire [31:0] PC,
    output wire        flush_INST_CTRL_ID
);

    wire and_out, or_out;
    wire [31:0] next_pc, pc_add4;

    and and_gate(and_out, branchFlag, zeroFlag);
    or  or_gate(or_out, and_out, jumpFlag);

    assign flush_INST_CTRL_ID = or_out;

    mux4_1 mux_pc (
        .in_0(32'd4),
        .in_1(jumpAddress),
        .in_2(branchOffset),
        .in_3(branchOffset),
        .sel({and_out, jumpFlag}),
        .y(next_pc)
    );

    adder add_pc4 (
        .a(next_pc),
        .b(PC),
        .cin(1'b0),
        .result(pc_add4),
        .cout()
    );

    register #(.N(32)) reg_pc (
        .clk(clk),
        .rst(rst),
        .d(pc_add4),
        .q(PC)
    );

endmodule
