module pc (
    input  wire        CLK,
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

    mux_4 mux_pc (
        .in0(32'd4),
        .in1(jumpAddress),
        .in2(branchOffset),
        .in3(branchOffset),
        .sel({and_out, jumpFlag}),
        .d(next_pc)
    );

    adder add_pc4 (
        .a_in(next_pc),
        .b_in(PC),
        .car_in(1'b0),
        .result(pc_add4),
        .car_out()
    );

    register #(.N(32)) reg_pc (
        .CLK(CLK),
        .rst(rst),
        .d(pc_add4),
        .q(PC)
    );

endmodule
