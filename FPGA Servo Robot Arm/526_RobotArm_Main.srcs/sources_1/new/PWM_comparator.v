/** Aaron Joseph Nanas
 ** ECE 526
 ** Professor Orod Haghighiara
 ** Final Project: Servo-Controlled Robot Arm
 ** Module: PWM_comparator.v
 **
 ** Description: This module will output the PWM
 ** in order to drive the servos, creating a waveform.
 ** When A is less than B, the PWM output is 1. 
 ** But when A is greater than B, the PWM output is 0
**/
`timescale 1ns / 1ps
 
module PWM_comparator (A, B, PWM);
	input [19:0] A;
	input [19:0] B;
	output reg PWM;

    // The PWM output is 1 when A < B; otherwise, it is 0
    always @ (A, B) begin
	   if (A < B)
		  PWM <= 1'b1;
	   else
		  PWM <= 1'b0;
	end
endmodule