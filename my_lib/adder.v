(* techmap_celltype = "$alu" *)
module my_add (A, B, C, X, Y);

	input A, B, C;
	output X, Y;

	adder #() _TECHMAP_REPLACE_ (
		.a		(A),
		.b		(B),
		.cin	(C),
		.sumout	(Y),
		.cout	(X) );
	
endmodule
