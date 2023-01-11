`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/10/2023 09:12:16 PM
// Design Name: 
// Module Name: simon_cipher
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


module #(parameter round=32,parameter key_standart=128) simon_cipher(clk,rstn,in_bit,encyp_bits);

parameter idle=0;
parameter round=1;
parameter last=2;

reg state[1:0];
process @(posedge clk) begin
    if (rstn!='b0) begin
        case (state)
        idle: begin
            
        end
        round:begin
            
        end
        last:begin
            
        end 

        default: 
    endcase
    end
    
end
endmodule
