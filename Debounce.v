`ifndef _debounce_
`define _debounce_

module debounce(clk,rst,in,out);
parameter num = 12;

input clk,rst;
input [num-1:0] in;
output [num-1:0] out;
wire [num-1:0] prev_out,current_out;

wire dclk;
debounce_clk db_clk(clk,rst,dclk);

		FF #(12) ff1(in,prev_out,dclk,rst);
		FF #(12) ff12(prev_out,current_out,dclk,rst);


assign  out = prev_out & current_out;

endmodule 



module FF(d,q,clk,rst);
parameter num = 5;

input clk,rst;
input [num-1:0] d;
output reg[num-1:0] q;
reg [num-1:0] next_q;

always@(posedge clk)begin
		if(rst) q<= {num{1'b0}};
		else
				q<= next_q;
end

always@(*)begin
		if(rst) next_q = {num{1'b0}};
		else
				next_q = d;
end


endmodule


module debounce_clk(clk,rst,dclk);
		input clk,rst;
		output reg dclk;

		reg [15:0] count_val;
   parameter [15:0] end_val = 16'hC350;		//  Maximum counting value


   always@(posedge clk or posedge rst)begin
		if(rst)begin
				dclk <= 1'b0;
				count_val <= 16'b0;
		end
		else if(count_val == end_val)begin
				dclk <= 1'b1;
				count_val <= 16'b0;
		end
		else begin
				count_val <= count_val + 16'd1;
				dclk <= 1'b0;
		end
   end


endmodule
`endif
