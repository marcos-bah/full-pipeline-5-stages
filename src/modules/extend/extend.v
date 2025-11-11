module extend(
	input wire [31:7] Instr,
	input wire [1:0] ImmSrc, 
	output reg [31:0] ImmExt 
);
    wire [31:0] aux;

    assign aux[31:7] = Instr;
    assign aux[6:0] = 7'b0; //zero padding

    always@(*) begin
        case(ImmSrc)
            2'b00: begin
                ImmExt <= {{20{aux[31]}},aux[31:20]};
            end
            2'b01: begin
                ImmExt <= {{20{aux[31]}},aux[31:25],aux[11:7]};
            end
            2'b10: begin
                ImmExt <= {{20{aux[31]}},aux[7],aux[30:25],aux[11:8],1'b0};
            end
            2'b11:begin
                ImmExt <= {{12{aux[31]}},aux[19:12],aux[20],aux[30:21],1'b0};
            end
            default: ImmExt = 32'b0;
        endcase
    end
endmodule