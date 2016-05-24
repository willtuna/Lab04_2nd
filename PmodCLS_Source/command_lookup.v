`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Digilent Inc.
// Engineers: Andrew Skreen
//				  Josh Sackos
// 
// Create Date:    12:15:47 06/18/2012
// Module Name:    command_lookup
// Project Name: 	 PmodCLS Demo
// Target Devices: Nexys3
// Tool versions:  ISE 14.1
// Description: Contains the data commands to be sent to the PmodCLS.  Values
//					 are ASCII characters, for details on data format, etc., see
//					 the PmodCLS reference manual.
//
// Revision: 1.0
// Revision 0.01 - File Created
//
//////////////////////////////////////////////////////////////////////////////////

// ==============================================================================
// 										  Define Module
// ==============================================================================
module command_lookup(
    sel,
    data_out
    );

// ===========================================================================
// 										Port Declarations
// ===========================================================================
    input [5:0] sel;
    output [7:0] data_out;

// ===========================================================================
// 							  Parameters, Regsiters, and Wires
// ===========================================================================

	// Output wire
	wire [7:0] data_out;
	
	//  Hexadecimal values below represent ASCII characters
	parameter [7:0] command[0:33] = {
													// Clear the screen and set cursor position to home
													8'h1B,		// Esc
													8'h5B,		// [
													8'h6A,		// j

													// Set the cursor position to row 0 column 3
													8'h1B,		// Esc
													8'h5B,		// [
													8'h30,		// 0
													8'h3B,		// ;
													8'h33,		// 3
													8'h48,		// H

													// Text to print out on the screen
													8'h48,		// H
													8'h65,		// e
													8'h6C,		// l			is lowercase L, not number one
													8'h6C,		// l			is lowercase L, not number one
													8'h6F,		// o
													8'h20,		// Space
													8'h46,		// F
													8'h72,		// r
													8'h6F,		// o
													8'h6D,		// m

													// Set the cursor position to row 1 column 4
													8'h1B,		// Esc
													8'h5B,		// [
													8'h31,		// 1			is number one not L
													8'h3B,		// ;
													8'h34,		// 4
													8'h48,		// H

													// Text to print out on the screen
													8'h44,		// D
													8'h69,		// i
													8'h67,		// g
													8'h69,		// i
													8'h6C,		// l			is lowercase L, not number one
													8'h65,		// e
													8'h6E,		// n
													8'h74,		// t
													8'h00		// Null
	};
	 
// ===========================================================================
// 										Implementation
// ===========================================================================
	
	// Assign byte to output
	assign data_out = command[sel];

endmodule
