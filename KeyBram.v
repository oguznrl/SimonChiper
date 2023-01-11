`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2023 08:36:50 PM
// Design Name: 
// Module Name: KeyBram
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


module KeyBram(clk, we, en, addr, di, dout); 

input clk;
input we;
input en;
input [6:0] addr;
input [31:0] di;
output [31:0] dout;
reg [31:0] RAM [0:43];
reg [31:0] dout;

always @(posedge clk)

begin

if (en) begin
    if (we)
        RAM[addr] <= di;
    else
        dout <= RAM[addr];
end

end 
endmodule
