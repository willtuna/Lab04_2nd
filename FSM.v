`ifndef _FSM_V
`define _FSM_V


// Finite State Machine
`define set_state			 3'b000
`define count_down_state     3'b001
`define suspend_state        3'b011
`define display_state        3'b101
`define finish_state         3'b111
`define delay_display        3'b100


module fsm(		
//         -------------- input --------------------
				clk,
				set,
				input_value,
				turn_zero,
				start,
				suspend,
				resume,
				restart,
				end_transmission,
				rst,
// ---------------------- output --------------------
				data_out,
				slave_select,
				begin_transmission,
				state
				);

//   ---------------------- inpput ----------------------
input clk,set,start,suspend,resume,restart,rst,turn_zero, end_transmission;
                                                                          
input [5:0]	input_value; // value from 0  to 63




//------------------------ output -------------------------
output reg [7:0] data_out;

output reg slave_select, begin_transmission;
//           done           done

wire  [15:0] ascii_out;
//				done
output reg [5:0] state;


//-------------------------Temporary for state or others -------------------------------
reg [5:0] set_value, current_value;
//           done         done

reg  sus_click, continue,finish, end_display;
//		done		done	done   done

reg [2:0] current_state, next_state;
//			 done			done

reg [26:0] delay_cnt;
parameter delay_cnt_max = 27'd100_000;
//  ---------------- Put the current value to output the ascii code for output
		twodigit2ascii ascii_decoder(current_value, ascii_out);




//     ----------------- State Transition FF --------------------------------------
		always@(posedge clk)begin
				if(rst)
						current_state <= `set_state;
                else
						current_state <= next_state;
		end

//							  NextState Logic Combinational Logic
		always@(clk)begin
				if(rst)begin
						next_state = `set_state;
				end
				else begin
						case(current_state) 
						`set_state : 
									if(start && set)
										next_state = `display_state;
								    else
										next_state = current_state;
						`count_down_state:
								    if	   (sus_click == 1'b1 && continue == 1'b0)
										next_state = `suspend_state;
								    else if(sus_click == 1'b0 && continue == 1'b1)
										next_state = `display_state;
								    else
										next_state = current_state;
						`suspend_state:
								    if(sus_click == 1'b0 && continue == 1'b1)
										next_state = `count_down_state;
								    else
										next_state = current_state;
						`display_state:
								    if(end_display && finish == 1'b0)
										next_state = `delay_display;
								    else if(end_display && finish == 1'b1)
										next_state = `finish_state;
								    else
										next_state = current_state;
						`delay_display://             Newly Add Display Delay
										if(delay_cnt == delay_cnt_max)
												next_state = `count_down_state;
										else
												next_state = current_state;
						`finish_state:
								    if(start==1'b0 && set== 1'b0)
										next_state = `set_state;
								    else
										next_state = current_state;
						default:
										next_state = current_state;
						endcase
				end
		end
								
// ------------------------------- CurrentValue SetValue CL logic ----------------------
//               Current Value Change for each transition of state
		always@(current_state or set  or rst)begin
				if(rst)begin
						current_value <= 6'd0;
						set_value     <= 6'd0;
				end
				else begin

						case(current_state)
								`set_state:	begin
												if(set)begin
														set_value <=  input_value; 
														current_value <= input_value;
												end
												else begin
														set_value <=  6'd0;
														current_value <= 6'd0;
												end
										end
								`count_down_state: begin
												if(turn_zero) // higher Priority
														current_value <= 6'd0;
												else if(restart)
														current_value <= set_value;
												else
														current_value <= current_value -1;
										end

								default:begin
										current_value <= current_value;
										set_value <= set_value;
								end
						endcase
				end
		end


// ----------------------------------       sus_click & continue ------------------------
		always@(*)begin
				if(suspend == 1'b1 && resume == 1'b0)begin
						sus_click = 1'b1;
						continue = 1'b0;
				end
				else	begin
						sus_click = 1'b0;
						continue = 1'b1;
				end
		end
// ----------------------------------   finish ----------------------------------
		always@(*)begin
				if(rst) finish <= 1'b0;
				else if(current_state == `count_down_state)begin
						if( current_value == 6'd0 || turn_zero == 1'b1)
								finish <= 1'b1;
						else
								finish <= 1'b0;
				end
				else
								finish <= finish;
		end

// ----------------------- Slave Select  ----------------------------------------

		always@(*)begin
				case(current_state)
					`count_down_state:
								    if(sus_click == 1'b0 && continue == 1'b1)
										slave_select <= 1'b0;
									else
										slave_select <= 1'b1;
				    `display_state:
								    if(end_display && finish == 1'b0)
										slave_select <= 1'b1;
								    else if(end_display && finish == 1'b1)
										slave_select <= 1'b1;
								    else
										slave_select <= 1'b0;
				    default:
								slave_select <= 1'b1;
				endcase
		end
//    --------------            Display Command Counter ------------------------------
		reg [3:0] count_end;

		always@(end_transmission or rst)begin
				if(rst)begin
						count_end <= 4'd0;
				end
				else if(count_end == 4'd6 )begin
						count_end <= 4'd0;
				end
				else if(end_transmission == 1'b1 && count_end < 4'd6)
						count_end <= count_end + 4'd1;
				else begin
						count_end <= count_end;
				end
		end
// -------------------------- end_display -----------------------------		
		always@(*)begin
				case(current_state)
						`display_state:
										if(count_end == 4'd6)
												end_display = 1'b1;
										else
												end_display = 1'b0;
						default:
										end_display = 1'b0;
				endcase
		end

//     --------------------- Command Line Sequence -------------------------------------

		always@(*)begin
				case(count_end)
						4'd0:			data_out[7:0]= 8'h1B;		// Esc
						4'd1:			data_out[7:0]= 8'h5B;		// [
						4'd2:			data_out[7:0]= 8'h6A;		// j
                                                      
						 // Set the cursor p_osition to row 0 column 3
						4'd3:           data_out[7:0]= ascii_out[15:8];
						4'd4:          data_out[7:0]= ascii_out[7:0];
						4'd5:          data_out[7:0]= 8'h00;       // NULL
						                    
				default:
								data_out[7:0] = 8'h00;

				endcase
		end


//                    May having Bug Issue ---------------
// ------------------------- Begin_Transmission -------------------------------
		always@(*)begin
		   case(current_state)
				`display_state:
								if(end_display == 1'b1) 
										begin_transmission = 1'b0;
								else
										begin_transmission = 1'b1;
				default:
								begin_transmission = 1'b0;
		   endcase

		end
//-----------------------------------------------------------------------	

//------------------------------ delay_cnt -------------------------------
		always@(posedge clk)begin
				if(rst)
						delay_cnt <= 'd0;
				else begin
						case(current_state)
								`delay_display:  if(delay_cnt < delay_cnt_max)
														delay_cnt <= delay_cnt + 'd1;
												 else
														delay_cnt <= 'd0;
										default:
												delay_cnt <= 'd0;
						endcase

				end
		end
//------------------------ state ------------------------------------
		always@(clk)begin
				if(rst)begin
						state = 6'b0;
				end
				else begin
						case(current_state) 
						`set_state : 
										state = 6'b000_001;
						`count_down_state:
										state = 6'b000_010;
						`suspend_state:
										state = 6'b010_000;
						`display_state:
										state = 6'b000_100;
						`delay_display://             Newly Add Display Delay
										state = 6'b001_000;
						`finish_state:
										state = 6'b100_000;
						default:
										state = 6'b000_000;
						endcase
				end
		end


endmodule










//------------------------------ Binary2ASCII module ------------------------
`define	ascii0 8'b0011_0000
`define	ascii1 8'b0011_0001
`define	ascii2 8'b0011_0010
`define	ascii3 8'b0011_0011
`define	ascii4 8'b0011_0100
`define	ascii5 8'b0011_0101
`define	ascii6 8'b0011_0110
`define	ascii7 8'b0011_0111
`define	ascii8 8'b0011_1000
`define	ascii9 8'b0011_1001


module twodigit2ascii(in, out);
		input [5:0] in; // input from 0 to 60

		output reg [15:0] out;


		reg [5:0] digit10;
		reg [5:0] digit1;
		always@(in)begin
				digit10 = in / 6'd10;		
				digit1  = in % 6'd10;
		end
// ---------------------------------- Digit10 Decode -----------------------
		always@(*)begin
				case(digit10) 
					6'd0 : out[15:8] =  `ascii0;
                    6'd1 : out[15:8] =  `ascii1;
                    6'd2 : out[15:8] =  `ascii2;
                    6'd3 : out[15:8] =  `ascii3;
                    6'd4 : out[15:8] =  `ascii4;
                    6'd5 : out[15:8] =  `ascii5;
                    6'd6 : out[15:8] =  `ascii6;
                    6'd7 : out[15:8] =  `ascii7;
                    6'd8 : out[15:8] =  `ascii8;
                    6'd9 : out[15:8] =  `ascii9;
				default :
						out[15:8] = 8'b0;
				endcase
		end


//---------------------------------- Digit1 Decode ------------------------------
		always@(*)begin
				case(digit1)
					6'd0 : out[7:0] =  `ascii0;
                    6'd1 : out[7:0] =  `ascii1;
                    6'd2 : out[7:0] =  `ascii2;
                    6'd3 : out[7:0] =  `ascii3;
                    6'd4 : out[7:0] =  `ascii4;
                    6'd5 : out[7:0] =  `ascii5;
                    6'd6 : out[7:0] =  `ascii6;
                    6'd7 : out[7:0] =  `ascii7;
                    6'd8 : out[7:0] =  `ascii8;
                    6'd9 : out[7:0] =  `ascii9;
				default :
						out[7:0] = 8'b0;
				endcase
		end
endmodule



`endif
