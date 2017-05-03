// Copyright (C) 2016  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel MegaCore Function License Agreement, or other 
// applicable license agreement, including, without limitation, 
// that your use is for the sole purpose of programming logic 
// devices manufactured by Intel and sold by Intel or its 
// authorized distributors.  Please refer to the applicable 
// agreement for further details.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 16.1.0 Build 196 10/24/2016 SJ Lite Edition"
// CREATED		"Sat Jan 21 19:09:54 2017"

module max10(
	CLK100MHZ,
	key0,
	key1,
	FTDI_BD2,
	FTDI_BD0,
	ftdi_bd1,
	ftdi_bd3,
	FTC,
	FTD,
	io,
	LED
);


input wire	CLK100MHZ;
input wire	key0;
input wire	key1;
input wire	FTDI_BD2;
input wire	FTDI_BD0;
output wire	ftdi_bd1;
output wire	ftdi_bd3;
output wire	[7:0] FTC;
output wire	[7:0] FTD;
output wire	[19:0] io;
output wire	[7:0] LED;

wire	clk;
wire	[31:0] q;
wire	SYNTHESIZED_WIRE_0;

assign	ftdi_bd1 = 0;
assign	ftdi_bd3 = 0;
assign	FTC = 8'b00000000;
assign	FTD = 8'b00000000;
assign	io = 20'b00000000000000000000;






mypll	b2v_inst2(
	.inclk0(CLK100MHZ),
	.c0(clk)
	);

assign	SYNTHESIZED_WIRE_0 =  ~key1;


lpm_counter_0	b2v_inst33(
	.aclr(SYNTHESIZED_WIRE_0),
	.clock(clk),
	.cnt_en(key0),
	
	.q(q));




assign	LED[7:0] = q[31:24];

endmodule

