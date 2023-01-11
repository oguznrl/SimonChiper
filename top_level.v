`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/11/2023 08:23:56 PM
// Design Name: 
// Module Name: top_level
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


module top_level(clk,rstn,in_block,key,valid_in,out_block);

input clk;
input rstn;
input [63:0]in_block; 
input [127:0] key;
input valid_in;
output reg [63:0] out_block; 

reg [1:0]states=idle;

parameter idle=0;
parameter key_schedule=1;
parameter chipher_stage=2;
parameter last=3;

reg [63:0]chipher_data;
reg [127:0]key_reg;
reg ram_en=0;
reg write_en=0;
reg key_schedule_en;
reg [6:0]stage_num=0;
wire [31:0]key_schedule_out;
wire [31:0]k_out;
wire key_schedule_valid;
wire [63:0]chiphered_data;

wire simon_valid;

KeyBram bram(clk,write_en,ram_en,stage_num,key_schedule_out,k_out);
key_schedule schedule(clk,rstn,key_schedule_en,key_reg[31:0],key_reg[63:32],key_reg[123:97],stage_num,key_schedule_out,key_schedule_valid);
simon chipher(clk,rstn,k_out,chipher_data,chiphered_data,valid);


always @(posedge clk) begin
    if (rstn=='b1) begin
        case (states)
            idle:
            begin
                if(valid_in=='b1) begin
                    chipher_data<=in_block;
                    key_reg<=key;
                    write_en<=1;
                    ram_en<=1;
                    states<=key_schedule;
                end
                else
                    states<=idle;
            end
            key_schedule: begin
                key_schedule_en<='b1;
                if (key_schedule_valid=='b1) begin
                    write_en<=1;
                    states<=key_schedule;
                end
                else begin
                    write_en<=0;
                    stage_num<=0;
                    states<=key_schedule;
                end
                
                if (stage_num==44) begin
                    states<=chipher_stage;
                    write_en<=0;
                    stage_num<=0;
                end
                else begin
                    states<=key_schedule;
                    stage_num<=stage_num+1;
                end
            end
            chipher_stage: begin
                if (stage_num==44) begin
                    states<=last;
                end
                else begin
                    if (simon_valid==1) begin
                        stage_num<=stage_num+1;
                        chipher_data<=chiphered_data;
                        states<=last; 
                        states<=chipher_stage;
                    end
                    else begin
                        stage_num<=0;  
                        states<=chipher_stage;
                    end
                         
                end
                    
            end
            last: begin
                out_block<=chiphered_data;
                states<=idle;     
            end 
        endcase
    end
end

endmodule
