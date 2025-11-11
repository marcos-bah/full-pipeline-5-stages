module register_file #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 5,
    parameter REG_COUNT  = 32
)(
    input  wire                  clk,
    input  wire                  WE3,
    input  wire [ADDR_WIDTH-1:0] A1,
    input  wire [ADDR_WIDTH-1:0] A2,
    input  wire [ADDR_WIDTH-1:0] A3,
    input  wire [DATA_WIDTH-1:0] WD3,
    output wire [DATA_WIDTH-1:0] RD1,
    output wire [DATA_WIDTH-1:0] RD2
);

    reg [DATA_WIDTH-1:0] registers [0:REG_COUNT-1];
    
    assign RD1 = (A1 != 0) ? registers[A1] : 0;
    assign RD2 = (A2 != 0) ? registers[A2] : 0;

    // sincrona
    always @(posedge clk) begin
        if (WE3 && A3 != 0)
            registers[A3] <= WD3;
    end

endmodule
