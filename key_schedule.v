`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2023 09:51:43 PM
// Design Name: 
// Module Name: key_schedule
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


module key_schedule(input clk,
input rstn, 
input en,
input [31:0]k0,
input [31:0]k1,
input [31:0]k3,
input [7:0]round,
output reg [31:0]key_out, 
output reg valid_out);


reg [31:0]z3='b11110000101100111001010001001000000111101001100011010111011011;
reg [30:0]c='b1111111111111111111111111111110;

wire [31:0]seqC={c,z3[round-4%62]};
wire [31:0]rotated_s3= {k3[2:0],k3[31:3]};
wire [31:0]rotated_s3_xor_k1= rotated_s3^k1;
wire [31:0]rotated_s3_xor_k1_S1=rotated_s3_xor_k1>>1;
wire [31:0]rotated_s3_xor_k1_seqC=rotated_s3_xor_k1 ^ seqC;
wire k0_rotated_s3_xor_k1_S1=k0^rotated_s3_xor_k1_S1;
always @(posedge clk) begin
    if(rstn=='b1 && en=='b1) begin
        key_out<= rotated_s3_xor_k1_seqC^ k0_rotated_s3_xor_k1_S1;
        valid_out<=1;
    end
    else begin
        valid_out<=0;
    end
        
end
endmodule
