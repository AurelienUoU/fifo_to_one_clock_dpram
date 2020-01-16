//////////////////////////
//      Flip-Flops      //
//////////////////////////

module \$_DFF_P_ (D, C, Q);
input D, C;
output reg Q;

	DFF _TECHMAP_REPLACE_ (
		.D		(D),
		.clk	(C),
		.Q		(Q) );
		
endmodule

//---------------------------------------------------------

module \$_DFF_N_ (D, C, Q);
input D, C;
output reg Q;

	DFFN _TECHMAP_REPLACE_ (
		.D		(D),
		.clk	(C),
		.Q		(Q) );
		
endmodule
