module byteEnableDecoder (
    input  wire [1:0] addr_offset,
    input  wire [1:0] size,
    input  wire       writeEnable,
    output reg  [3:0] byteEnable
);

    always @(*) begin
        if (!writeEnable)
            byteEnable = 4'b0000;
        else begin
            case (size)
                2'b00: byteEnable = 4'b0001 << addr_offset; // sb
                2'b01: begin // sh
                    case (addr_offset)
                        2'b00: byteEnable = 4'b0011;
                        2'b01: byteEnable = 4'b0110;
                        2'b10: byteEnable = 4'b1100;
                        default: byteEnable = 4'b0000; 
                    endcase
                end
                2'b10: byteEnable = 4'b1111; // sw
                default: byteEnable = 4'b0000; // def
            endcase
        end
    end

endmodule
