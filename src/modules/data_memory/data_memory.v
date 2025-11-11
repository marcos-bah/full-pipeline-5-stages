module data_memory (
    input wire clk,
    input wire MemWrite,
    input wire [31:0] A,
    input wire [31:0] WD,
    output wire [31:0] RD
);
    reg [31:0] memory [65535:0];

    // Read operation
    assign RD = memory[A[31:2]]; // word aligned

    // Write operation
    always @(posedge clk) begin
        if (MemWrite) begin
            memory[A[31:2]] <= WD; // word aligned
        end
    end

    integer i;
    initial begin
        for (i = 0; i < 65536; i = i + 1) begin
            memory[i] = 32'b0;
        end
    end
endmodule