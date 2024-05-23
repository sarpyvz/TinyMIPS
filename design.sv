// Code your design here
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:23:43 05/03/2024 
// Design Name: 
// Module Name:    TinyMIPS 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module TinyMIPS(clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);
	input clk, rst;
	output reg wrEn;
	input [15:0] data_fromRAM;
	output reg [15:0] data_toRAM;
	output reg [7:0] addr_toRAM;

	reg [2:0] st, stN;
	reg [7:0] PC, PCN;
	reg [15:0] IW, IWN;
	reg [15:0] T1, T1N, T2, T2N;

	reg [15:0] RF [7:0];

	always @(posedge clk) begin
		st <= stN;
		PC <= PCN;
		IW <= IWN;
		T1 <= T1N;
		T2 <= T2N;
	end

	always @ * begin
		if (rst) begin
			stN = 3'd0;
			PCN = 8'd0;
		end
		else begin
			wrEn = 1'b0;
			PCN = PC;
			IWN = IW;
			stN = 3'dx;
			addr_toRAM = 8'hX;
			data_toRAM = 16'hX;
			T1N = 16'hX;
			T2N = 16'hX;
			
			case (st)
				3'd0: begin // S0: Fetch State
					addr_toRAM = PC;
					stN = 3'd1;
				end
				3'd1: begin // S1 State
					IWN = data_fromRAM;
					if(data_fromRAM[15:12] == 4'b0000) begin // ADD
						T1N = RF[data_fromRAM[8:6]];
						stN = 3'd2;
					end
					else if(data_fromRAM[15:12] == 4'b0001) begin // ADDi
						T1N = RF[data_fromRAM[8:6]];
						stN = 3'd2;
					end
					else if(data_fromRAM[15:12] == 4'b0111) begin // CPi
						RF[data_fromRAM[11:9]] = {7'd0,data_fromRAM[8:0]};
						PCN = PC + 8'd1;
						stN = 3'd0;
					end
					else if(data_fromRAM[15:12] == 4'b1001) begin // BLT
						T1N = RF[data_fromRAM[11:9]];
						stN = 3'd2;
					end
                  	else if(data_fromRAM[15:12] == 4'b0010) begin // MUL 
                  		T1N = RF[data_fromRAM[8:6]];
                    	stN = 3'd2;
                  	end
                  	else if(data_fromRAM[15:12] == 4'b0011)begin // SRL
                    	T1N = RF[data_fromRAM[8:6]];
                    	stN = 3'd2;
                 	 end
                  	else if ( data_fromRAM[15:12] == 4'b0100)begin // LD
						T1N = RF[data_fromRAM[8:6]];
						stN = 3'd2;
                  	end
                  	else if (data_fromRAM[15:12] == 4'b0101) begin // ST
						T1N = RF[data_fromRAM[8:6]];
						stN = 3'd2;
                  	end
                    else if (data_fromRAM[15:12] == 4'b0110) begin // CP
                    	T1N = RF[data_fromRAM[8:6]];
						stN = 3'd2;
                  	end
                    else if (data_fromRAM[15:12] == 4'b1000) begin // BEQ
                        T1N = RF[data_fromRAM[11:9]];
                      	stN = 3'd2;
                  	end
                   else if (data_fromRAM[15:12] == 4'b1010) begin // BGT
                        T1N = RF[data_fromRAM[11:9]];
                     	stN = 3'd2;
                  	end   	
				end
				3'd2: begin // S2 State
					if (IW[15:12]==4'b0000) begin // ADD
						T1N = T1;
						T2N = RF[IW[5:3]];
						stN = 3'd3;
					end
					else if (IW[15:12]==4'b0001) begin // ADDi
						RF[IW[11:9]] = T1 + {{2{IW[5]}}, IW[5:0]};
						PCN = PC + 8'd1;
						stN = 3'd0;
					end
					else if(IW[15:12] == 4'b1001) begin // BLT
						T2N = RF[IW[8:6]];
						T1N = T1;
						stN = 3'd3;
					end
                  	else if (IW[15:12] == 4'b0010) begin // MUL
                      	T1N = T1;
                      	T2N = RF[IW[5:3]];
						stN = 3'd3;
                    end
                  	else if (IW[15:12] == 4'b0011) begin // SRL
                      	T2N = RF[IW[5:3]];
                      	T1N = T1;
                      	stN =3'd3;
                    end
                  	else if (IW[15:12] == 4'b0100) begin // LD
                      	T2N = T1 + IW[5:0];
                      	T1N = T1;
                      	stN = 3'd3;
                      
                    end
                  	else if (IW[15:12] == 4'b0101)begin // ST
                      	T2N = T1 + IW[5:0];
                      	T1N = T1;
                      	stN = 3'd3;
                    end
                  	else if (IW[15:12]  == 4'b0110 )begin // CP
                        RF[IW[11:9]]  = T1;
                        PCN = PC + 8'd1;
                      	stN = 3'd0;
                  	end
                  	else if (IW[15:12]  == 4'b1000)begin // BEQ
                      	T2N = RF[IW[8:6]];
                      	T1N = T1;
                      	stN = 3'd3;
                    end
                  	else if (IW[15:12] == 4'b1010)begin //BGT
                      	T2N = RF[IW[8:6]];
                      	T1N = T1;
                      	stN = 3'd3;
                    end
                end
				3'd3: begin // S3 State
					if (IW[15:12]==4'b0000) begin // ADD
						RF[IW[11:9]] = T1 + T2;
						PCN = PC + 8'd1;
						stN = 3'd0;
					end
					else if (IW[15:12]==4'b1001) begin // BLT
						PCN = (T1 < T2) ? (PC + {{2{IW[5]}}, IW[5:0]}) : (PC + 8'd1);// PC+signext(imm) or PC+1
						stN = 3'd0;
					end
                  	else if(IW[15:12] == 4'b0010) begin //MUL
                      RF[IW[11:9]] = T1 * T2;
                      PCN = PC + 8'd1;
                      stN = 3'd0;
                    end
                  	else if(IW[15:12] == 4'b0011) begin	// SRL
                      RF[IW[11:9]] = ( T2 < 32 ) ? (T1 >> T2) : (T1 << (T2-32));
					  PCN = PC + 8'd1;
                      stN = 3'd0;
                    end
                 	else if(IW[15:12] == 4'b0100) begin	// LD
                      RF[IW[11:9]] = data_fromRAM[T2];
                      PCN = PC + 8'd1;
					  addr_toRAM = T2;
                      stN = 3'd0;
                    end
                  	else if(IW[15:12] == 4'b0101) begin	// ST
                      data_toRAM[T2] = RF[IW[11:9]];
                      PCN = PC + 8'd1;
                      addr_toRAM = T2;
                      stN = 3'd0;
                    end
                  	else if(IW[15:12] == 4'b1000) begin	// BEQ
                      PCN = (T1 == T2) ? (PC + {{2{IW[5]}}, IW[5:0]}): (PC + 8'd1);
                      stN = 3'd0;
                    end
                  	else if(IW[15:12] == 4'b1010) begin	// BGT
                      PCN = (T1 > T2) ? (PC + {{2{IW[5]}}, IW[5:0]}): (PC + 8'd1);
                      stN = 3'd0;
                    end
    			end
			endcase
		end // else
	end // always
endmodule

module blram(clk, rst, we, addr, din, dout);
	parameter SIZE = 8, DEPTH = 2**SIZE;
	input clk;
	input rst;
	input we;
	input [SIZE-1:0] addr;
	input [15:0] din;
	output reg [15:0] dout;
	
	reg [15:0] mem [DEPTH-1:0];
 
	always @(posedge clk) begin
		dout <= mem[addr[SIZE-1:0]];
		if (we)
			mem[addr[SIZE-1:0]] <= din;
	end
endmodule