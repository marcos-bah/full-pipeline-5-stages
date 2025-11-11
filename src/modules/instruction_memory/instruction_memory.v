module instruction_memory(
    input wire [31:0] A,
    output wire [31:0] RD
);
    reg [31:0] memory [0:1023];
    assign RD = memory[A[31:2]]; // word aligned
endmodule