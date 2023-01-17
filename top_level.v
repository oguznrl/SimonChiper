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
input [31:0]in_block; 
input [63:0] key;
input valid_in;
output reg [31:0] out_block; 

reg [1:0]states=idle;

parameter idle=0;
parameter key_schedule=1;
parameter chipher_stage=2;

reg [31:0]chipher_data;
reg [15:0]k0,k1,k2,k3;
reg ram_en=0;
reg write_en=0;
reg [6:0]stage_num=0;
wire [15:0]key_schedule_out;
wire [15:0]k_out;
wire key_schedule_valid;
wire [31:0]chiphered_data;
wire simon_valid;

KeyBram bram(clk,write_en,ram_en,stage_num,key_schedule_out,k_out);
key_schedule schedule(clk,rstn,write_en,k0,k1,k3,stage_num,key_schedule_out,key_schedule_valid);
simon chipher(clk,rstn,k_out,chipher_data,chiphered_data,simon_valid);


always @(posedge clk) begin
    if (rstn=='b1) begin
        case (states)
            idle:begin
                if(valid_in=='b1) begin
                    chipher_data<=in_block;
                    k0<=key[15:0];
                    k1<=key[31:16];
                    k2<=key[47:32];
                    k3<=key[63:48];
                    write_en<=1;
                    ram_en<=1;
                    states<=key_schedule;
                end
                else begin
                    states<=idle;
                end
                    
            end
            key_schedule: begin
                if (key_schedule_valid=='b1) begin
                    if (stage_num==32) begin
                        write_en<=0;
                        states<=chipher_stage;
                    end
                    else begin
                        stage_num<=stage_num+1;
                        k3<=key_schedule_out;
                        k2<=k3;
                        k1<=k2;
                        k0<=k1;
                    end
                end
                else begin
                    states<=chipher_stage;
                end
                    
            end
            chipher_stage: begin
                if (stage_num==32) begin
                    out_block<=chiphered_data;
                    states<=idle; 
                    ram_en<=0;
                end
                else begin
                    if (simon_valid==1) begin
                        stage_num<=stage_num+1;
                        chipher_data<=chiphered_data;
                        states<=chipher_stage;
                    end
                    else begin
                        stage_num<=0;  
                        states<=chipher_stage;
                    end
                         
                end
                    
            end
        endcase
    end
    else begin
        states<=idle;  
    end
end

endmodule
