/** Aaron Joseph Nanas
**  ECE 526
**  Final Project: Servo-Controlled Robot Arm
**  Module: PmodJSTK2_Interface.v
**  Credits to: Josh Sackos (Digilent Inc.)
**  Reference: Pmod JSTK Demo Project
**  https://reference.digilentinc.com/reference/pmod/pmodjstk/reference-manual

**  Description: This module serves as the Pmod JSTK2 interface.
**  It consists of the 66.67khZ Serial Clock module, a SPI interface,
**  and a SPI controller. The SPI interface module sends and receives
**  bytes of data to and from the Pmod JSTK2, while the SPI controller
**  will handle all the data transfer request and the bytes of data
**  that are being transferred to the Pmod JSTK2.
*/
`timescale 1ns / 1ps

module PmodJSTK2_Interface(CLK, RST, sndRec, MISO, SS, SCLK, DOUT);

    input CLK;  // 100 MHz Clock
    input RST; // Reset
    input sndRec; // Signal that initiates read/write request
    input MISO; 
    output SS; // Active low slave select signal
    output SCLK; 
    output [39:0] DOUT; // Signal that stores the data from the slave
    
    wire SCLK;
    wire [39:0] DOUT;
    
    wire getByte; // Initiates the data transfer in SPI_Int
    wire [7:0] RxData; // Receive data from SPI_Int
    wire BUSY; // Handshake signal from SPI_Int to SPI_Ctrl
    wire iSCLK; // Internal Serial Clock
    
    // SPI Controller
    spiCtrl SPI_Ctrl(.CLK(iSCLK), .RST(RST), .sndRec(sndRec), .BUSY(BUSY), .RxData(RxData), .SS(SS), .getByte(getByte), .DOUT(DOUT));
    
    // SPI Mode 0
    SPImode0 SPI_Int(.CLK(iSCLK), .RST(RST), .sndRec(getByte), .MISO(MISO), .SCLK(SCLK), .BUSY(BUSY), .DOUT(RxData));
    
    // SPI Controller Serial Clock
    Clk_Div_66_67kHz SerialClock(.CLK(CLK), .RESET(RST), .CLK_OUT(iSCLK));

endmodule
