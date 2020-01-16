module fifo_1clk  # (
	parameter WIDTH = 8,         // considering 8X8 fifo
	DEPTH = 16,
	PTR	= 4 )          // 2**3 = 8 (DEPTH)

(
	input [7:0] datain,
	input       wen,
	input       ren,
	input       clk,
	output		empty,
	output		full,
	output[7:0] dataout );

	reg[WIDTH -1:0]		ram [DEPTH -1:0];
	wire 				wen_int;
	wire				ren_int;
	reg[PTR -1:0]		wradr;
	reg[PTR -1:0]		rdadr;
	reg[PTR -1:0]		usedw;
	reg[WIDTH -1:0]		data_out;

	assign wen_int = wen & !wrfull;
	assign ren_int = ren & !rdempty;

	assign empty = (wradr == rdadr)? 1'b1 : 1'b0;
	assign full = (wradr == rdadr -1)? 1'b1 : 1'b0;

	assign dataout = data_out;

	initial begin
		wradr <= 1'b0;
		rdadr <= 1'b0;
	end

	always @(posedge clk) begin
		if(wen_int) begin
			ram[wradr] <= datain;
			wradr <= wradr + 1;
		end
		if(ren_int) begin
			data_out <= ram[rdadr];
			rdadr <= rdadr + 1;
		end
	end

endmodule
