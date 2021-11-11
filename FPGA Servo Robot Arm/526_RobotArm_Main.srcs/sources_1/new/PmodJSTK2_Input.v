/** Aaron Joseph Nanas
**  ECE 526
**  Final Project: Servo-Controlled Robot Arm
**  Module: PmodJSTK2_Input.v
**  Credits to: Josh Sackos (Digilent Inc.)
**  Reference: Pmod JSTK Demo Project
**  https://reference.digilentinc.com/reference/pmod/pmodjstk/reference-manual

**  Description: This module serves to instantiate the Joystick interface
**  module and the 5Hz Clock Divider module. This will be used in a
**  top-level module that will serve as the primary controller
**  for both the servos and the joystick.
*/
`timescale 1ns / 1ps

module PmodJSTK2_Input(CLK, RST, MISO, SS, SCLK, x_value, y_value);

    input CLK, RST, MISO;
    output SS, SCLK;
    output [9:0] x_value;
    output [9:0] y_value;
    
    wire SCLK;
    wire sndRec;
    wire [39:0] JSTK_DATA;
    
    PmodJSTK2_Interface JSTK_Interface(.CLK(CLK), .RST(RST), .sndRec(sndRec), .MISO(MISO), .SS(SS), .SCLK(SCLK), .DOUT(JSTK_DATA));
    Clk_Div_5Hz genSndRec(.CLK(CLK), .RST(RST), .CLKOUT(sndRec));
    
    assign x_value = {JSTK_DATA[9:8], JSTK_DATA[23:16]};
    assign y_value = {JSTK_DATA[25:24], JSTK_DATA[39:32]};
    
endmodule
