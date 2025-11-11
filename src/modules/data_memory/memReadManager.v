`timescale 1ns / 100ps

module memReadManager (
    input wire [31:0] dout, 
    input wire [1:0] addr_offset, 
    input wire [1:0] size, 
    input wire sign_extend, 
    output reg [31:0] rdata 
);
    reg [7:0] byte_data;
    reg [15:0] halfword_data;
    always @(*) begin
        case (addr_offset)
            2'b00: begin
                byte_data = dout [7:0];
                halfword_data = dout [15:0];
            end
            2'b01: begin
                byte_data = dout [15:8];
                halfword_data = dout [23:8];
            end
            2'b10: begin
                byte_data = dout [23:16];
                halfword_data = dout [31:16];
            end
            2'b11: begin
                byte_data = dout [31:24];
                halfword_data = {8'b0, dout [31:24]}; 
            end
            default: begin
                byte_data = 8'b0;
                halfword_data = 16'b0;
            end
        endcase

        case (size)
            2'b00: begin // byte
                rdata = ~sign_extend ?
                {{24{ byte_data [7]}}, byte_data} :
                {24'b0, byte_data };
            end
            2'b01: begin // half -word
                rdata = ~sign_extend ?
                {{16{ halfword_data [15]}}, halfword_data} :
                {16'b0, halfword_data };
            end
            2'b10: begin // word
                rdata = dout;
            end
            default: begin 
                rdata = 32'hDEADBEEF; 
            end
        endcase
    end
endmodule