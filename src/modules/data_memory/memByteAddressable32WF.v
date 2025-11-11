module memByteAddressable32WF #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 4
    )(
    input wire clk,
    input wire [3:0] byteEnable,
    input wire [ADDRESS_WIDTH-1:0] addr,
    input wire [DATA_WIDTH-1:0] din,
    output wire [DATA_WIDTH-1:0] dout
);
    memory_write_first #(
        .DATA_WIDTH(8),
        .ADDRESS_WIDTH(4)
    ) mem_byte0( 
        .clk(clk),
        .we(byteEnable[0]),
        .addr(addr),
        .din(din[7:0]),
        .dout(dout[7:0])
    );
    
    memory_write_first #(
        .DATA_WIDTH(8),
        .ADDRESS_WIDTH(4)
    ) mem_byte1( 
        .clk(clk),
        .we(byteEnable[1]),
        .addr(addr),
        .din(din[15:8]),
        .dout(dout[15:8])
    );

    memory_write_first #(
        .DATA_WIDTH(8),
        .ADDRESS_WIDTH(4)
    ) mem_byte2( 
        .clk(clk),
        .we(byteEnable[2]),
        .addr(addr),
        .din(din[23:16]),
        .dout(dout[23:16])
    );

    memory_write_first #(
        .DATA_WIDTH(8),
        .ADDRESS_WIDTH(4)
    ) mem_byte3( 
        .clk(clk),
        .we(byteEnable[3]),
        .addr(addr),
        .din(din[31:24]),
        .dout(dout[31:24])
    );
endmodule