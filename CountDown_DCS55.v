`include "Debounce.v"
`include "FSM.v"
`include "spi_interface.v"
module CountDown_dcs55(
				clk,
				set,
				input_value,// 6bit
				turn_zero,
				start,
				suspend,
				resume,
				restart, 
				rst,

				ss,
				mosi,
				miso,
				sclk,
				state
				);
		input clk, set, turn_zero, start, suspend, resume,restart,rst;
	    input [5:0] input_value;
		input miso;
		output ss,mosi,sclk;

		output  [5:0] state;


		wire  end_transmission;
		wire  [7:0] data_out;
		wire begin_transmission;
	//	wire [5:0] d_input_value;
		

		fsm MasterFSM(clk,set,6'd50,turn_zero,start,suspend,resume,restart,end_transmission,rst, data_out, ss ,begin_transmission, state );

		spi_interface spi(clk,rst,data_out,begin_transmission,ss,miso,end_transmission,mosi,sclk);



endmodule





