module register_file (
    input wire clk,
    input wire reset,                
    input wire WE3,                  
    input wire [4:0] A1, A2, A3,  
    input wire [31:0] WD3,           
    output wire [31:0] RD1, RD2      
);

    reg [31:0] registers [31:0];
    
    // Read operations
    assign RD1 = (A1 != 0) ? registers[A1] : 32'b0; // x0 is always 0
    assign RD2 = (A2 != 0) ? registers[A2] : 32'b0; // x0 is always 0

    // Write operation
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            integer i;
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 32'b0;
            end
            //registers[9] <= 32'd6;
        end else if (WE3 && (A3 != 0)) begin
            registers[A3] <= WD3; // x0 is read-only
        end
        $display("clk=%b WE3=%b A3=%d WD3=%h", clk, WE3, A3, WD3);
    end

endmodule