/** Aaron Joseph Nanas
 ** ECE 526
 ** Professor Orod Haghighiara
 ** Final Project: Servo-Controlled Robot Arm
 ** Module: angle_decoder.v
 **
 ** Description: This module will convert an angle value
 ** to a PWM constant. A servo requires a given PWM value
 ** in order to rotate to the desired degree angle
 ** 
 ** Note: Formula taken from: https://blog.digilentinc.com/how-to-control-a-servo-with-fpga/
**/

`timescale 1ns / 1ps

module angle_decoder(
    input [8:0] angle,
    output reg [19:0] value
    );
    
    // Updates every time the angle is changed
    // This will convert the angle to a constant value,
    // and will work with continuous rotation servos as well
    always @ (angle) begin
        value = (10'd944)*(angle)+ 16'd60000;
    end
endmodule
