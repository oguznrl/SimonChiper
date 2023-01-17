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
input [15:0]k0,
input [15:0]k1,
input [15:0]k3,
input [7:0]round,
output reg [15:0]key_out, 
output reg valid_out);


reg [31:0]z0='b11111010001001010110000111001101111101000100101011000011100110;
reg [15:0]c='b1111111111111100;

wire [15:0]newC={c[15:1],c[0]^z0[round-4%62]};
wire [15:0]k3_shifted={k3[12:0],k3[15:13]};
wire [15:0]k3_shifted_xor_k1=k3_shifted^k1;
wire [15:0]k3_shifted_xor_k1_shifted_1={k3_shifted_xor_k1[14:0],k3_shifted_xor_k1[15]};
wire [15:0]k3_shifted_xor_k1_xor_k0=k3_shifted_xor_k1^k0;
wire [15:0]temp=k3_shifted_xor_k1_xor_k0^k3_shifted_xor_k1_shifted_1;
always @(posedge clk) begin
    if(rstn=='b1 && en=='b1) begin
        key_out<=temp^newC;
        valid_out<=1;
    end
    else begin
        valid_out<=0;
    end
        
end
endmodule
