`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2023 11:32:58 PM
// Design Name: 
// Module Name: simon
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module simon(clk,rstn,key,input_text,chipher_text,valid);
input  clk,rstn;
input  [15:0] key;
input  [31:0]input_text;
output reg [31:0]chipher_text;
output reg valid;

wire [15:0]left_side=input_text[31:16];
wire [15:0]right_side=input_text[15:0];
wire [15:0]rl_1={left_side[14:0],left_side[15]};
wire [15:0]rl_8={left_side[7:0],left_side[15:8]};
wire [15:0]rl_2={left_side[13:0],left_side[15:14]};
wire [15:0]rl_1_and_rl_8=rl_1 & rl_8;
wire [15:0]rl_1_and_rl_8_xor_right_side=rl_1_and_rl_8 ^right_side;
wire [15:0]rl_1_and_rl_8_xor_right_side_xor_rl2=rl_1_and_rl_8_xor_right_side ^ rl_2;
wire [15:0] new_left=rl_1_and_rl_8_xor_right_side_xor_rl2 ^ key;
always @(posedge clk) begin
    if (rstn!='b0) begin
        chipher_text<={new_left,left_side};
        valid<=1;
    end
    else begin
        valid<=0;
    end
    
end
endmodule
