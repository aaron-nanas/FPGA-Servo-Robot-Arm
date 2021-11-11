`timescale 1ns / 1ps

module tb_top_level_controller();
    parameter PERIOD = 10; 
    
    reg CLK;
    reg RST;
    reg btn1, btn2, btn3;
    wire JSTK_INPUT_SS_0;
    reg JSTK_INPUT_MISO_2;
    wire JSTK_INPUT_SCLK_3;
    wire PWM1, PWM2, PWM3;
    
    integer i;
    
    top_level_controller TOP_UUT(
        .CLK(CLK),
        .RST(RST),
        .btn1(btn1),
        .btn2(btn2),
        .btn3(btn3),
        .JSTK_INPUT_SS_0(JSTK_INPUT_SS_0),
        .JSTK_INPUT_MISO_2(JSTK_INPUT_MISO_2),
        .JSTK_INPUT_SCLK_3(JSTK_INPUT_SCLK_3),
        .PWM1(PWM1),
        .PWM2(PWM2),
        .PWM3(PWM3)
        );
    
    initial 
        CLK = 1'b0;
    always #(PERIOD/2) CLK = ~CLK;
    
    initial begin
        btn1 = 0; btn2 = 0; btn3 = 0; RST = 1;
        
        #(PERIOD) RST = 0;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1; btn1 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1; btn1 = 1'b0; btn2 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1; btn3 = 1'b1; btn1 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b0;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1; btn1 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b0; btn1 = 1'b0; btn2 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1; btn3 = 1'b0; btn1 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1;        
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1; btn1 = 1'b0;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b0; btn1 = 1'b0; btn2 = 1'b0;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b0; btn3 = 1'b1; btn1 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b0; btn1 = 1'b0; btn2 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1; btn3 = 1'b0; btn1 = 1'b0;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1;        
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1; btn1 = 1'b0;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b0; btn1 = 1'b1; btn2 = 1'b1; btn3 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b0; btn1 = 1'b0; btn2 = 1'b0; btn3 = 1'b0;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b0; btn3 = 1'b1; btn1 = 1'b1;
        #(PERIOD) JSTK_INPUT_MISO_2 = 1'b1;                 
    end
endmodule
