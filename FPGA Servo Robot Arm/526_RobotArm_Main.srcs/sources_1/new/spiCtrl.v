/*  Aaron Joseph Nanas
**  ECE 526: 
**  Final Project: Servo-Controlled Robot Arm
**  Module: spiCtrl.v

**  Credits to: Josh Sackos (Digilent Inc.)
**  Reference: Pmod JSTK Demo Project
**  https://reference.digilentinc.com/reference/pmod/pmodjstk/reference-manual
**
**  Description:      This component manages all data transfer requests,
**                   and manages the data bytes being sent to the PmodJSTK.
**
**  				 For more information on the contents of the bytes being sent/received 
**					 see page 2 in the PmodJSTK reference manual found at the link provided
**					 below.
**
**					 http://www.digilentinc.com/Data/Products/XUPV2P-COVERS/PmodJSTK_rm_RevC.pdf
*/

`timescale 1ns / 1ps

module spiCtrl(CLK, RST, sndRec, BUSY, RxData, SS, getByte, DOUT);
    input CLK, RST;
    input sndRec; // Send/Receive, initializes data read/write
    input BUSY; // If this is active, indicate that data transfer is currently in progress
    input [7:0] RxData; // Last data byte received
    output reg SS; // Active low, slave select signal
    output getByte; // Initializes data trasfer
    output [39:0] DOUT; // All data read from the slave
    
    reg getByte = 1'b0;
    reg [39:0] DOUT = 40'h0000000000;
    
    // FSM States
    parameter [2:0]
        Idle = 3'd0,
        Init = 3'd1,
        Wait = 3'd2,
        Check = 3'd3,
        Done = 3'd4;
    
    // Present State
    reg [2:0] pState = Idle;
    reg [2:0] byteCnt = 3'd0; // Number of bits read/written
    parameter byteEndVal = 3'd5; // Number of bytes to send/receive
    reg [39:0] tmpSR = 40'h0000000000; // Temporary shift register to accumulate all five data bytes
    
    always @(negedge CLK) begin
        if (RST) begin
            SS <= 1'b1; // Active low slave select signal
            getByte <= 1'b0;
            tmpSR <= 40'h0000000000;
            DOUT <= 40'h0000000000;
            byteCnt <= 3'd0;
            pState <= Idle;
            
        end else begin
            case(pState)
                Idle: begin
                    SS <= 1'b1; // Disable slave select
                    getByte <= 1'b0; // Data is not requested when getByte is low
                    tmpSR <= 40'h0000000000; // Resets temporary data
                    DOUT <= DOUT; // Latch onto the output data
                    byteCnt <= 3'd0; // Clear byte count
                    
                    // When send receive signal received, begin data transmission
                    if (sndRec) begin
                        pState <= Init;
                    end else begin
                        pState <= Idle;
                    end
               end
               
               Init: begin
                    SS <= 1'b0; // Enable slave select
                    getByte <= 1'b1; // Initialize the data transfer
                    tmpSR <= tmpSR; // Latch onto the temporary data
                    DOUT <= DOUT; // Latch onto the output data
                    
                    if (BUSY) begin
                        pState <= Wait;
                        byteCnt <= byteCnt + 1'b1; // When busy, begin counting the incoming bits
                    end else begin
                        pState <= Init;
                    end
               end
               
               Wait: begin
                    SS <= 1'b0; // Enable slave select
                    getByte <= 1'b0; // Data transfer is active, so set getByte low
                    tmpSR <= tmpSR; // Latch onto temporary data
                    DOUT <= DOUT; // Latch onto the output data
                    byteCnt <= byteCnt; // byteCnt will latch when it is in WAIT state
                    
                    // Finish reading byte -> get data
                    if (!BUSY) begin
                        pState <= Check;
                    end else begin
                        pState <= Wait;
                    end
               end
               
               Check: begin
                    SS <= 1'b0; // Enable slave select
                    getByte <= 1'b0; // Data transfer is active, so set getByte low
                    tmpSR <= {tmpSR[31:0], RxData}; // Store the byte that was just read
                    DOUT <= DOUT;
                    byteCnt <= byteCnt;
                    
                    // When the 5 bytes of data are read, transition to DONE
                    if (byteCnt == 3'd5) begin
                        pState <= Done;
                    end else begin
                        pState <= Init;
                    end
               end
               
               Done: begin
                    SS <= 1'b1; // Disable slave select 
                    getByte <= 1'b0; // Data transfer is done
                    tmpSR <= tmpSR; 
                    DOUT[39:0] <= tmpSR[39:0]; // Updates DOUT with the temporarily stored data
                    byteCnt <= byteCnt;
                    
                    if (!sndRec) begin
                        pState <= Idle;
                    end else begin
                        pState <= Done;
                    end
               end
               
               default: begin
                    pState <= Idle;
                    SS <= 1'b0;
                    DOUT <= DOUT; // Latch onto the output data
               end
            endcase
        end
    end
               
endmodule
