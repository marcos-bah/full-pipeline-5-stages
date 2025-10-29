module single_cycle_cpu_tb;
    reg clk;
    reg reset;

    // single_cycle_cpu uut (
    //     .clk(clk),
    //     .reset(reset)
    // );

    full_pipeline uut (
        .clk(clk),
        .reset(reset)
    );

    initial begin
        $dumpfile("single_cycle_cpu_tb.vcd");
        $dumpvars(0, uut);

        clk = 0;
        reset = 1;
        #10; reset = 0;

        #500 $finish;
    end

    always #5 clk = ~clk;
endmodule
