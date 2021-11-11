/** Aaron Joseph Nanas
**  ECE 526
**  Final Project: Servo-Controlled Robot Arm
**  Module: Clk_Div_66_67kHz.v

**  Description: This module serves as a clock divider for 
**  the Pmod JSTK2, and it will directly connect to the
**  internal serial clock. A 66.67kHz clock divider has a period of
**  15us. CLK_OUT will toggle between 0 and 1 every time
**  the counter reaches half of 15 us.
**
**  Credits to: Josh Sackos (Digilent Inc.)
**  Reference: Pmod JSTK Demo Project
**  https://reference.digilentinc.com/reference/pmod/pmodjstk/reference-manual
*/
`timescale 1ns / 1ps

module Clk_Div_66_67kHz(CLK, RESET, CLK_OUT);

    parameter COUNT_FINAL = 750;

    input CLK, RESET;
    output CLK_OUT;
    
    reg CLK_OUT = 1'b1; // Will connect directly to the internal serial clock
    reg [9:0] COUNT = 0;
    
    always @(posedge CLK) begin
        if (RESET) begin
            CLK_OUT <= 1'b0; // Active high reset
            COUNT <= 0;
        
        end else begin
            if (COUNT == COUNT_FINAL) begin
                CLK_OUT <= ~CLK_OUT; // Toggle between high and low when it reaches the final count
                COUNT <= 0; // Roll it back to 0 when it reaches the final count of 750
            end else begin
                COUNT <= COUNT + 1'b1;
            end
        end
    end
    
endmodule
