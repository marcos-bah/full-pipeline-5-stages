module mux2_1 (
    input  wire [31:0] in0,
    input  wire [31:0] in1,
    input  wire sel,
    output wire [31:0] d
);
    assign d = sel ? in1 : in0;
endmodule
