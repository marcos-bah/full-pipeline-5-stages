module adder (
    input  wire [31:0] a,
    input  wire [31:0] b,
    input  wire cin,
    output wire [31:0] result,
    output wire cout
);
    assign {cout, result} = a + b + cin;
endmodule
