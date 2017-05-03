

module top(
	input wire CLK100MHZ,
	input wire key0,
	input wire key1,
	input wire FTDI_BD0, //serial RX line 
	output wire [19:0]io
);

wire wc0;
wire wc1;
wire wlocked;
wire wpdone;
wire up_down; 
reg pstep;

//reg scanclk = 1'b0;
//always @( posedge wc0 )
//	scanclk <= ~scanclk;
wire scanclk; assign scanclk = wc0;
	
reg [7:0]cnt8;
always @( posedge scanclk )
	cnt8 <= cnt8 + 8'h01;

`ifdef IVERILOG

reg clk;
initial clk=0;
always
  #5 clk = ~clk;
assign wc0 = clk;

reg [3:0]c;
initial c = 4'b0;
reg wlocked;
initial wlocked = 1'b0;
always @(posedge clk)
begin
	c<=c+1;
	if(c==4'hF)
		wlocked <= 1'b1;
end

reg done_sim=0;
always @( posedge scanclk )
	done_sim <= pstep;
assign wpdone = ~done_sim;

`else
mypll mypll_ (
	.areset( ~key0 ),
	.inclk0(CLK100MHZ),
	.phasecounterselect( 3'b011 ),
	.phasestep( pstep ),
	.phaseupdown( up_down ),
	.scanclk(scanclk),
	.c0(wc0),
	.c1(wc1),
	.locked(wlocked),
	.phasedone( wpdone )
	);
`endif

wire [7:0]w_rx_byte;

wire w_byte_ready;
reg [1:0]byte_rdy;
always @( posedge wc0 )
	byte_rdy <= {byte_rdy[0],w_byte_ready};
	
serial receiver(
	.reset( ~wlocked ),
	.clk100( wc0 ),	//100MHz
	.rx( FTDI_BD0 ),
	.sbyte( 8'h00 ),
	.send( 1'b0 ),
	.rx_byte( w_rx_byte ),
	.rbyte_ready( w_byte_ready ),
	.tx(),
	.busy(), 
	.rb()
	);

reg  [7:0]current_pll_phase = 0;
wire [7:0]signal; assign signal = w_rx_byte[7:0];
assign up_down = signal>current_pll_phase;

reg [3:0]state = 0;
always @( negedge scanclk )
begin
	case(state)
	0: begin 
			//wait recv byte
			if( byte_rdy ) state <= 1;
		end
	1: begin 
			//do we really need to change phase?
			if( current_pll_phase==signal ) state <= 0;
			else state <= 2;
		end	
	2: begin 
			//wait phase done
			if( ~wpdone ) state <= 3;
		end
	3: begin 
			state <= 4;
		end
	4: begin 
			state <= 1;
		end
	endcase
	
	if( pstep && (~wpdone) )
		if( up_down )
			current_pll_phase <= current_pll_phase + 6'h1;
		else
			current_pll_phase <= current_pll_phase - 6'h1;
			
	if( ~wpdone )
		pstep <= 1'b0;
	else
	if( state==2 )
		pstep <= 1'b1;

end

assign io[17:0] = 0;
assign io[18] =  wc1;
assign io[19] = ~wc1;

endmodule
