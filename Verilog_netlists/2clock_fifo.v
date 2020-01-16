module top_wrapper (
	input [7:0] datain,
	input       wen,
	input       ren,
	input       clk,
	output[7:0] dataout );

	asynch_fifo DUT (
		.wrclk	(clk),
		.rdclk	(clk),
		.wren	(wen),
		.rden	(ren),
		.datain	(datain),
		.dataout (dataout) );

endmodule 

module asynch_fifo # (parameter WIDTH = 8,         // considering 8X8 fifo
								DEPTH = 16,
								PTR	= 4 )          // 2**3 = 8 (DEPTH)

(
			input wire 					reset_,
			//=== Signals for WRITE
			input  wire 				wrclk,        // Clk for writing data
			input  wire 				wren,         // request to write 
			input  wire [WIDTH-1 : 0]	datain,       // Data coming in 
			output wire					wrfull,       // indicates fifo is full or not (To avoid overiding)
			output wire			 		wrempty,      // 0- some data is present (atleast 1 data is present)                                          
			output wire	[PTR  : 0]		wrusedw,      // number of slots currently in use for writing                                                                                                
                                                    
			
			//=== Signals for READ

            input  wire 				rdclk,        // Clk for reading data    
			input  wire 				rden,         // Request to read from FIFO 
			output wire [WIDTH-1 : 0]	dataout,      // Data coming out 
			output wire 				rdfull,       // 1-FIFO IS FULL (DATA AVAILABLE FOR READ is == DEPTH)
			output wire					rdempty,      // indicates fifo is empty or not (to avoid underflow)
			output wire [PTR  : 0] 		rdusedw,      // number of slots currently in use for reading

			output 	 		dbg						  //For Debug

);
			reg[WIDTH -1:0]		ram [DEPTH -1:0];
			wire 				wren_int;
			wire				rden_int;
			reg[PTR -1:0]		wradr;
			reg[PTR -1:0]		rdadr;
			reg[PTR -1:0]		usedw;
			reg[WIDTH -1:0]		data_out;

			assign wren_int = wren & !wrfull;
			assign rden_int = rden & !rdempty;

			assign rdempty = (wradr == rdadr)? 1'b1 : 1'b0;
			assign wrempty = (wradr == rdadr)? 1'b1 : 1'b0;
			assign rdfull = (wradr == rdadr -1)? 1'b1 : 1'b0;
			assign wrfull = (wradr == rdadr -1)? 1'b1 : 1'b0;

			assign dataout = data_out;

			initial begin
				wradr <= 1'b0;
				rdadr <= 1'b0;
			end

			always @(posedge wrclk) begin
				if(wren_int) begin
					ram[wradr] <= datain;
					wradr <= wradr + 1;
				end
			end

			always @(posedge rdclk) begin
				if(rden_int) begin
					data_out <= ram[rdadr];
					rdadr <= rdadr + 1;
				end
			end
endmodule
