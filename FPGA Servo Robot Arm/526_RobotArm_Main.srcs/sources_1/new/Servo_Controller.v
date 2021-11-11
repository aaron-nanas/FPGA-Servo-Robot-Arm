/** Aaron Joseph Nanas
 ** ECE 526
 ** Professor Orod Haghighiara
 ** Final Project: Servo-Controlled Robot Arm
 ** Module: Servo_Controller.v
 **
 ** Description: This module serves as the interface for a servo.
 ** Instantiating this module to a top-level module will add
 ** additional servos to the primary controller
**/

`timescale 1ns / 1ps

module Servo_Controller (x_value, y_value, RST, CLK, btn, PWM);
    input [9:0] x_value, y_value;
    input RST, CLK, btn;
    output PWM;
    
    // Wires needed to make connections to the
    // lower level modules
    wire [19:0] A_w, value_w;
    wire [8:0] angle_w;
    
    joystick_decoder joystick_read(
        .btn(btn),
        .x_value(x_value),
        .y_value(y_value),
        .angle(angle_w)
        );

    angle_decoder decode(
        .angle(angle_w),
        .value(value_w)
        );
    
    PWM_comparator compare_A_B(
        .A(A_w),
        .B(value_w),
        .PWM(PWM)
        );
      
    ClkDiv_100Hz Clk_100Hz(
        .RST(RST),
        .CLK(CLK),
        .COUNT(A_w)
        );
        
endmodule
