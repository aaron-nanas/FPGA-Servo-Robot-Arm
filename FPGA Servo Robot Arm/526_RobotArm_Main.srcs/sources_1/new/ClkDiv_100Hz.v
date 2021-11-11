/** Aaron Joseph Nanas
 ** ECE 526
 ** Professor Orod Haghighiara
 ** Final Project: Servo-Controlled Robot Arm
 ** Module: ClkDiv_100Hz.v
 ** Reference: https://reference.digilentinc.com/reference/pmod/pmodjstk2/reference-manual
 
 ** Description: This module will create a refresh rate of 10ms.
 ** It will divide the board's 100 MHz clock to 100 Hz.
 ** According to the reference manual of the Pmod JSTK2, the raw
 ** measured data is stored at "a rate of 100 Hz Hertz (times per second) 
 ** as a 16-bit right-justified variable in RAM with the upper 6 bits masked with zeros."
**/
`timescale 1ns / 1ps

module ClkDiv_100Hz (RST, CLK, COUNT);
	input RST;
	input CLK;
	output reg [19:0] COUNT;

	always @ (posedge CLK) begin
	    // The Zedboard has a system clock of 100 MHz. To obtain the
	    // value needed to create a refresh rate of 10 ms, the formula is:
	    // (System Clock) / (1 / (Desired Refresh Rate))
	    // (100 MHz) / (1 / (10 ms)) = 1000000
	    if ((RST) || (COUNT == 20'd1000000))
			  COUNT <= 20'b0;
		else 
		      COUNT <= COUNT + 1'b1;
	end
endmodule