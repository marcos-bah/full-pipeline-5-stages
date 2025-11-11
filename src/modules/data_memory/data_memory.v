module data_memory(
    input  wire        clk,
    input  wire        WE,
    input  wire [31:0] A,
    input  wire [31:0] WD,
    output wire [31:0] RD
);

    reg [31:0] mem [0:65535];

    assign RD = mem[A];

    always @(posedge clk) begin
        if (WE) begin
            mem[A] <= WD;
        end
    end

endmodule