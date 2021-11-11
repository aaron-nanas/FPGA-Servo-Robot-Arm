/** Aaron Joseph Nanas
 ** ECE 526
 ** Professor Orod Haghighiara
 ** Final Project: Servo-Controlled Robot Arm
 ** Module: top_level_controller.v
 **
 ** Description: The top-level that serves as the main controller.
 ** This module instantiates the other lower-level servo interface
 ** modules. Currently, this controls three. Another servo module
 ** can be easily added and instantiate to control an additional servo.
 
 ** Note: When instantiating another servo module, be sure to 
 ** update the Zedboard's constraints file to include
 ** the additional PWM signal
 **/

`timescale 1ns / 1ps

module top_level_controller(
    input CLK,
    input RST,
    input btn1, btn2, btn3,
    output JSTK_INPUT_SS_0,
    input JSTK_INPUT_MISO_2,
    output JSTK_INPUT_SCLK_3,
    output wire PWM1, PWM2, PWM3
    );
    
    wire [9:0] x_value_w, y_value_w;
    
    PmodJSTK2_Input Joystick_Input(
        .CLK(CLK), 
        .RST(RST), 
        .MISO(JSTK_INPUT_MISO_2), 
        .SS(JSTK_INPUT_SS_0), 
        .SCLK(JSTK_INPUT_SCLK_3),
        .x_value(x_value_w),
        .y_value(y_value_w)
        );

    // This servo (bottom) will rotate the base
    Servo_Controller Servo1(
        .x_value(x_value_w),
        .y_value(y_value_w),
        .RST(RST),
        .CLK(CLK),
        .btn(btn1),
        .PWM(PWM1)
         );
         
    // This servo (left) will move the arm forward or backward            
    Servo_Controller Servo2(
        .x_value(x_value_w),
        .y_value(y_value_w),
        .RST(RST),
        .CLK(CLK),
        .btn(btn2),
        .PWM(PWM2)
        );
             
    // This servo (right) will lift the arm or bring it down          
    Servo_Controller Servo3(
        .x_value(x_value_w),
        .y_value(y_value_w),
        .RST(RST),
        .CLK(CLK),
        .btn(btn3),
        .PWM(PWM3)
        );       
                 
endmodule
