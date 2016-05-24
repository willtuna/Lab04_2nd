`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineers: Andrew Skreen
//				  Josh Sackos
// 
// Create Date:    15:20:31 06/15/2012 
// Module Name:    PmodCLS_Demo 
// Project Name:	 PmodCLS_Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: 	 Prints "Hello From Digilent" on PmodCLS connected to Nexys3
//						 on pins JA1-JA4. SPI protocol is utilized for communications
//						 between the PmodCLS and the Nexys3, hence the appropriate
//						 jumpers should be set on the PmodCLS, for details see
//						 PmodCLS reference manual.
//
// Revision: 1.0
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module PmodCLS_Demo(
    CLK,
    SW,
    JA,
	 Led
    );

	// ===========================================================================
	// 										Port Declarations
	// ===========================================================================
	input CLK;						// Onboard 100 Mhz clock signal
	input [2:0] SW;				// SW[0]=reset, SW[1]=clear, SW[2]=start
	output [3:0] JA;				// JA[0]=slave select
										// JA[1]=mosi
										// JA[2]=miso
										// JA[3]=sclk
	output [0:0] Led;

	// ===========================================================================
	// 							  Parameters, Regsiters, and Wires
	// ===========================================================================
	wire [3:0] JA;					// Output wires for SPI communication with PmodCLS
	wire [0:0] Led;

	wire slave_select;			// Active low signal for writing data to PmodCLS
	wire begin_transmission;	// Initializes data transfer with PmodCLS
	wire end_transmission;		// Handshake signal to signify data transfer done
	wire [5:0] sel;				// Selects which ASCII value to send to PmodCLS
	wire [7:0] temp_data;		// Output data from C2 to C0
	wire [7:0] send_data;		// Output data from C0 to C1
	
	wire START;						// Debounced start signal, SW[2]
	wire CLEAR;						// Debounced clear signal, SW[1]
	wire RST;						// Debounced reset signal, SW[0]
	wire GND = 0;					// Ground, i.e. logic low

	// ===========================================================================
	// 										Implementation
	// ===========================================================================

	// Debounces the input control signals from switches.
	Three_Bit_Debouncer DebounceInputs(
			.CLK(CLK),
			.RST(GND),
			.I0(SW[0]),
			.I1(SW[1]),
			.I2(SW[2]),
			.D0(RST),
			.D1(CLEAR),
			.D2(START)
	);

	// Produces signals for controlling SPI interface, and selecting output data.
	master_interface C0( 
			.begin_transmission(begin_transmission),
			.end_transmission(end_transmission),
			.clk(CLK),
			.rst(RST),
			.start(START),
			.clear(CLEAR),
			.slave_select(slave_select),
			.temp_data(temp_data),
			.send_data(send_data),
			.sel(sel)
	);

	// Interface between the PmodCLS and FPGA, proeduces SCLK signal, etc.
	spi_interface C1(
			.begin_transmission(begin_transmission),
			.slave_select(slave_select),
			.send_data(send_data),
			.miso(JA[2]),
			.clk(CLK),
			.rst(RST),
			.end_transmission(end_transmission),
			.mosi(JA[1]),
			.sclk(JA[3])
	);

	// Contains the ASCII characters for commands
	command_lookup C2(
			.sel(sel),
			.data_out(temp_data)
	);

	//  Active low slave select signal
	assign JA[0] = slave_select;

	// Assign Led[0] the value of SW[0]
	assign Led[0] = SW[0];

endmodule
