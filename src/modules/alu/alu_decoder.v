module alu_decoder(
    input [1:0] ALUOp,
    input [2:0] funct3,
    input funct7b5, opb5,
    output reg [3:0] ALUControl
);

wire   RtypeSub;
assign RtypeSub = funct7b5 & opb5;

always@(*) begin
    // 1111 1111 1100 0100 1010 0011 0000 0011
    case(ALUOp) // 00
      2'b00: ALUControl = 4'b0000; //addition
      2'b01: ALUControl = 4'b0001; //subtraction or auipc
      2'b10:
      
      case(funct3)//R-type 
        3'b000:    
        if (RtypeSub) ALUControl = 4'b0001; //sub
        else ALUControl = 4'b0000; //add,addi
        3'b001: ALUControl = 4'b1010; // sll, slli;
        3'b010: ALUControl = 4'b0101; //slt,slti
        3'b110: ALUControl = 4'b0011; //or,ori
        3'b111: ALUControl = 4'b0010; //and,andi
        default: ALUControl = 4'bxxx; 
      endcase
      default: ALUControl = 4'bxxxx;
    endcase
end
endmodule
