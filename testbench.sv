// Code your testbench here
// or browse Examples
`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:49:42 05/03/2024
// Design Name:   TinyMIPS
// Module Name:   C:/Users/gurhan/Desktop/gurhan/CSE224/sp24/Project/TinyMIPS/tb_TinyMIPS.v
// Project Name:  TinyMIPS
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: TinyMIPS
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tb_TinyMIPS;
	parameter SIZE = 8, DEPTH = 2**SIZE;
	reg clk, rst;
	wire wrEn;
	wire [SIZE-1:0] addr_toRAM;
	wire [15:0] data_toRAM, data_fromRAM;
	
	TinyMIPS uut1 (clk, rst, data_fromRAM, wrEn, addr_toRAM, data_toRAM);

	blram #(SIZE, DEPTH) uut2 (clk, rst, wrEn, addr_toRAM, data_toRAM, data_fromRAM);

	initial begin
		clk = 1;
		forever
			#5 clk = ~clk;
	end

	initial begin
		rst = 1;
		repeat (10) @(posedge clk);
		rst <= #1 0;
		repeat (600) @(posedge clk);
		$finish;
	end
  
  	// I HAVE DONE THE WAVEFORMS SCREENSHOTS ONE BY ONE BUT TO SHOW IT WHEN CLICKED IN MY LINK I HAVE WRITTEN IT ALL TESTS IN ONE PAGE
	initial begin
		// Test 1: Sum of 1 to 5
      uut2.mem[0] = 16'b0111001000000001; // CPi R1 1 // i = 1
      uut2.mem[1] = 16'b0111010000000000; // CPi R2 0 // sum = 0
      uut2.mem[2] = 16'b0111011000000110; // CPi R3 6 // max = 6
      uut2.mem[3] = 16'b0000010010001000; // ADD R2 R2 R1 // sum = sum + i
      uut2.mem[4] = 16'b0001001001000001; // ADDi R1 R1 1 // i++
      uut2.mem[5] = 16'b1001001011111110; // BLT R1 R3 -2 // if (i < max) then go back to address 5-2=3
     end

  	initial begin
// Test 2: Sum of 5 numbers in the memory
// The result is stored at address 15
		uut2.mem[0] = 16'b0111001000000000;
		uut2.mem[1] = 16'b0111010000000000;
		uut2.mem[2] = 16'b0111011000000101;
        uut2.mem[3] = 16'b0100100001001010;
        uut2.mem[4] = 16'b0000010010100000;
		uut2.mem[5] = 16'b0001001001000001;
        uut2.mem[6] = 16'b1001001011111101;
        uut2.mem[7] = 16'b0101010001001010;
        //uut2.mem[8] = 16'b0111011000000110;
        //uut2.mem[9] = 16'b0000010010001000;
        uut2.mem[10] = 16'b0000000000000101;
        uut2.mem[11] = 16'b0000000000001000;
        uut2.mem[12] = 16'b0000000000001111;
        uut2.mem[13] = 16'b0000000000010001;
        uut2.mem[14] = 16'b0000000000010110;
        uut2.mem[15] = 16'b0000000000000000;
    end
 
  initial begin
      // Test 3: Factorial of 5
      	uut2.mem[0] = 16'b0111001000000001;
		uut2.mem[1] = 16'b0110010001000000;
		uut2.mem[2] = 16'b0111011000000110;
      	uut2.mem[3] = 16'b0010010010001000;
      	uut2.mem[4] = 16'b0001001001000001;
		uut2.mem[5] = 16'b1001001011111110;
    end
	initial begin
      // Test 4: In-place memory update
		uut2.mem[0] = 16'b0111001000000101;
		uut2.mem[1] = 16'b0111010000000000;
		uut2.mem[2] = 16'b0110011010000000;
      	uut2.mem[3] = 16'b0111100000000010;
      	uut2.mem[4] = 16'b0100101001001110;
		uut2.mem[5] = 16'b1000101011000100;
      	uut2.mem[6] = 16'b0001101101000101;
        uut2.mem[7] = 16'b0011101101100000;
        uut2.mem[8] = 16'b0101101001001110;
        uut2.mem[9] = 16'b0001001001111111;
        uut2.mem[10] = 16'b1010001010111010;
      	uut2.mem[15] = 16'b0000000000000101;
        uut2.mem[16] = 16'b0000000000000000;
        uut2.mem[17] = 16'b0000000000001111;
        uut2.mem[18] = 16'b0000000000010001;
        uut2.mem[19] = 16'b0000000000010110;
    end

  
	initial begin
    $dumpfile("dump.vcd"); $dumpvars;
    #1000 $finish;
  	end
  
endmodule

      
      
      
      
      
      
      
      
      