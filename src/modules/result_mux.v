module result_mux (
	input wire [31:0] ALUResult,readData,PC_Plus_4,
	input wire [1:0] resultSrc,
	output wire [31:0] result
);
	assign result = resultSrc[1] ? PC_Plus_4 : (resultSrc[0] ? readData : ALUResult);
endmodule