`timescale 1ns / 1ps

module tb_Clk_Div_66_67kHz();
    parameter PERIOD = 10;
    parameter COUNT_FINAL = 10'b1011101110;
    integer i;
    
    reg CLK, RESET;
    wire CLK_OUT;
    
    
    Clk_Div_66_67kHz CLK_DIV_UUT (.CLK(CLK), .RESET(RESET), .CLK_OUT(CLK_OUT));
    
    initial 
        CLK = 1'b0;
    always #(PERIOD/2) CLK = ~CLK;
    
    initial begin
        RESET = 1'b1; 
        #(PERIOD) RESET = 1'b0;
        
        for (i = 0; i <= 750; i = i + 1) begin
            #(PERIOD);
        end
        
    end
endmodule
