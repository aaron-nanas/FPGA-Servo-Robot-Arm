/*  Aaron Joseph Nanas
**  ECE 526: 
**  Final Project: Servo-Controlled Robot Arm
**  Module: Clk_Div_5Hz

**  Credits to: Josh Sackos (Digilent Inc.)
**  Reference: Pmod JSTK Demo Project
**  https://reference.digilentinc.com/reference/pmod/pmodjstk/reference-manual

**  Description: This module will convert the onboard 100 MHz clock to 5 Hz.
*/

`timescale 1ns / 1ps

module Clk_Div_5Hz(CLK, RST, CLKOUT);
    input CLK, RST;
    output CLKOUT;
    
    reg CLKOUT;
    reg [23:0] COUNT = 24'd000000;
    
/** The period of the 100 MHz clock is 10 ns, while the period
**  of a 5 Hz frequency is 0.2 seconds.
**  If COUNT increments by 1, every 10 ns, what value must COUNT be 
**  to get to 0.2 seconds? Since this clock divider is toggling between
**  0 and 1, it must be changed to 0.1.
**  Formula to find COUNT is: (100 MHz) / (1/(0.1s)) = 10000000
*/
    parameter cntEndVal = 24'd10000000;
    
    always @(posedge CLK) begin
        if (RST) begin
            CLKOUT <= 1'b0;
            COUNT <= 24'd000000;
        end else begin
            if (COUNT == cntEndVal) begin
                CLKOUT <= ~CLKOUT; // Toggle between 0 and 1 when the final count value is reached
                COUNT <= 24'd000000;
            end else begin
                COUNT <= COUNT + 1'b1; // Otherwise, increment COUNT
            end
        end
    end
    
    
endmodule
