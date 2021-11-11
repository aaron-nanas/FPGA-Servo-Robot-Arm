/*  Aaron Joseph Nanas
**  ECE 526: 
**  Final Project: Servo-Controlled Robot Arm
**  Module: SPImode0.v

** Credits to: Josh Sackos (Digilent Inc.)
**  Reference: Pmod JSTK Demo Project
**  https://reference.digilentinc.com/reference/pmod/pmodjstk/reference-manual
** Description:      This module provides the interface for sending and receiving data
**					 to and from the PmodJSTK, SPI mode 0 is used for communication.  The
**					 master (Nexys3) reads the data on the MISO input on rising edges, the
**					 slave (PmodJSTK) reads the data on the MOSI output on rising edges.
**					 Output data to the slave is changed on falling edges, and input data
**					 from the slave changes on falling edges.
**
**					 To initialize a data transfer between the master and the slave simply
**					 assert the sndRec input.  While the data transfer is in progress the
**					 BUSY output is asserted to indicate to other componenets that a data
**					 transfer is in progress.  Data to send to the slave is input on the 
**					 DIN input, and data read from the slave is output on the DOUT output.
**
**					 Once a sndRec signal has been received a byte of data will be sent
**					 to the PmodJSTK, and a byte will be read from the PmodJSTK.  The
**					 data that is sent comes from the DIN input. Received data is output
**					 on the DOUT output.
*/

`timescale 1ns / 1ps

module SPImode0(
    input CLK,						// 66.67kHz serial clock
    input RST,                        // Reset
    input sndRec,                    // Send receive, initializes data read/write
    input MISO,                        // Master input slave output
    output wire SCLK,                    // Serial clock
    output reg BUSY,                    // Busy if sending/receiving data
    output wire [7:0] DOUT            // Current data byte read from the slave    
    );

    // FSM States
    parameter [1:0] Idle = 2'd0,
                    Init = 2'd1,
                    RxTx = 2'd2,
                    Done = 2'd3;

    reg [4:0] bitCount; // Number bits read/written
    reg [7:0] rSR = 8'h00; // Read shift register
    reg [1:0] pState = Idle; // Present state

    reg CE = 0; // Clock enable, controls serial clock signal sent to slave  
    
	// Serial clock output, allow if clock enable asserted
    assign SCLK = (CE == 1'b1) ? CLK : 1'b0;
    // Master out slave in, value always stored in MSB of write shift register
    // Connect data output bus to read shift register
    assign DOUT = rSR;    

        /* Read Shift Register
        ** Master reads on rising edges,
        ** Slave changes data on falling edges
        */
        always @(posedge CLK) begin
            if (RST) begin
                rSR <= 8'h00;
                
            end else begin
                // Enable shift during RxTx state only
                case (pState)
                    Idle: begin
                        rSR <= rSR;
                    end
                    
                    Init: begin
                        rSR <= rSR;
                    end
                    
                    RxTx: begin
                        if (CE) begin
                            rSR <= {rSR[6:0], MISO};
                        end
                    end
                    
                    Done: begin
                        rSR <= rSR;
                    end 
               endcase   
            end
        end

        /* SPI Mode 0 FSM */
        always @(negedge CLK) begin
        
            if (RST) begin
                CE <= 1'b0;
                BUSY <= 1'b0;
                bitCount <= 4'h0;
                pState <= Idle;
            
            end else begin   
            
                case (pState)
                    
                    Idle: begin
                        CE <= 1'b0;
                        BUSY <= 1'b0;
                        bitCount <= 4'h0;
                        
                        if (sndRec) begin
                            pState <= Init;
                            
                        end else begin
                            pState <= Idle;
                        end
                        
                    end
                    
                    Init: begin
                        BUSY <= 1'b1; // When initiated, it will output a busy signal
                        bitCount <= 4'h0; // bitCount is 0 since no Read/Write has happened yet
                        CE <= 1'b0; // Disable the serial clock
                        pState <= RxTx; // Next state, receive transmit
                    end
                    
                    RxTx: begin
                        BUSY <= 1'b1;
                        bitCount <= bitCount + 1'b1; // Begin counting bits received/written
                        
                        // When all the bits to the slave are written, prevent another falling edge
                        if (bitCount >= 4'd8) begin
                            CE <= 1'b0;
                        end else begin
                            CE <= 1'b1;
                        end
                        
                        if (bitCount == 4'd8) begin
                            pState  <= Done;
                        end else begin
                            pState <= RxTx;
                        end
                    end
                        
                    Done: begin
                        CE <= 1'b0; // When done, disable the serial clock
                        BUSY <= 1'b1; // Set the BUSY signal
                        bitCount <= 4'd0; // Clear the number of bits read or written
                        pState <= Idle;
                    end
                        
                    default: pState <= Idle;
                    
            endcase
        end
    end       
                 
endmodule

