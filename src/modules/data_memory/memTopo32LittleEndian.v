module memTopo32LittleEndian #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 4
    )(
    input wire clk,                         
    input wire [1:0] size,                  
    input wire [ADDRESS_WIDTH-1:0] addr,    
    input wire [DATA_WIDTH-1:0] din,        
    input wire sign_ext,                    
    input wire writeEnable,                 
    output wire [DATA_WIDTH-1:0] dout       
);
    wire [3:0] byteEnable;
    wire [31:0] mem_dout;
    wire [31:0] rdata;
    
    byteEnableDecoder decoder (
        .addr_offset(addr[1:0]),
        .size(size),
        .byteEnable(byteEnable),
        .writeEnable(writeEnable)
    );

    memByteAddressable32WF mem_inst (
        .clk(clk),
        .byteEnable(byteEnable),
        .addr(addr[3:0]), 
        .din(din),
        .dout(mem_dout)
    );

    memReadManager read_inst (
        .dout(mem_dout),
        .addr_offset(addr[1:0]),
        .size(size),
        .sign_extend(sign_ext),
        .rdata(rdata)
    );

    assign dout = rdata;
endmodule