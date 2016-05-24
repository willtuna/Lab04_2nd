`include "CountDown_dcs55.v"
`timescale 10ns/1ns

module testbench_top;
parameter cycle = 2.0;

reg clk = 1'b0;


// -------- CLK generation ------------
initial clk = 1'b0;
always#(cycle/2)
		clk = ~clk;


reg set,turn_zero,start,suspend,resume,restart,rst;
reg [5:0] input_value;
wire ss,mosi,miso,sclk;
wire [5:0] state;
CountDown_dcs55  demo(clk,set,input_value,turn_zero,start,suspend,resume,restart,rst,ss,mosi,miso,sclk,state);

assign miso = 1'b1;
initial begin
#1 rst = 1'b1; 
  {set,turn_zero,start,suspend,resume,restart} = 6'b0;
#100  input_value = 6'd40;
#10     rst = 1'b0;
//1000 unit
#49890 
{set,turn_zero,start,suspend,resume,restart} = 6'b0;

#50000  
{set,turn_zero,start,suspend,resume,restart}
		= 6'b100_000;// set

#50000  {set,turn_zero,start,suspend,resume,restart}
		= 6'b101_000;// start

//#500_000_000
#500_000
		{set,turn_zero,start,suspend,resume,restart}
		= 6'b101_100;// suspend

#500_000
		{set,turn_zero,start,suspend,resume,restart}
		= 6'b101_110;// resume

//#500_000_000
#1000_000
		{set,turn_zero,start,suspend,resume,restart}
		= 6'b101_111;// restart


#500000  {set,turn_zero,start,suspend,resume,restart}
		= 6'b101_110;//resume

#500000  {set,turn_zero,start,suspend,resume,restart}
		= 6'b111_110;//resume



//#500_000_000
#500_000 $stop;

end
		










endmodule
