/** Aaron Joseph Nanas
 ** ECE 526
 ** Professor Orod Haghighiara
 ** Final Project: Servo-Controlled Robot Arm
 ** Module: joystick_decoder.v
 **
 ** Description: This module will read the input of the joystick, and
 ** depending on which push button is pressed, the specified servo will
 ** rotate to the calculated angle value.
**/

`timescale 1ns / 1ps

module joystick_decoder(btn, x_value, y_value, angle);
    input btn;
    input [9:0] x_value;
    input [9:0] y_value;
    output reg [8:0] angle;
    
    reg [8:0] angle_temp;
    
    // 
    always @(x_value, y_value, btn) begin
        // If the joystick moves right or up, update the angle to current joystick input data
        if (x_value > 512 || y_value > 512)
            angle_temp <= (x_value + y_value)/10;
            if (btn)
                angle <= angle_temp;
            else if (!btn)
                angle <= 9'd90;
        // If the joystick moves left or down, reset angle to 0
        else if (x_value < 300 || y_value < 300)
            angle_temp <= 9'd0;
            
    end
endmodule
