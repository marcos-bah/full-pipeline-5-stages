module mux4_1(
    input  wire [31:0] in_0,
    input  wire [31:0] in_1,
    input  wire [31:0] in_2,
    input  wire [31:0] in_3,
    input  wire [1:0]  sel,
    output wire [31:0] y
);
    assign y = (sel == 2'b00) ? in_0 :
               (sel == 2'b01) ? in_1 :
               (sel == 2'b10) ? in_2 :
               (sel == 2'b11) ? in_3 :
               32'b0; // default
endmodule