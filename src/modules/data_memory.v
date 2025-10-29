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
        //$readmemh("data_memory.mem", memory);
        for (i = 0; i < 65536; i = i + 1) begin
            memory[i] = 32'b0;
        end

        memory[0] = 0;
        memory[1] = 1;
        memory[2] = 2;
        memory[3] = 3;
        memory[4] = 4;
        memory[5] = 5;
        memory[6] = 6;
        memory[7] = 7;
        memory[8] = 8;
        memory[9] = 9;
    end
endmodule