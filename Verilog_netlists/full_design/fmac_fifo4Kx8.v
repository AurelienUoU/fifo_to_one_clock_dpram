//
// Copyright (C) 2018 LeWiz Communications, Inc. 
// 
// This library is free software; you can redistribute it and/or
// modify it under the terms of the GNU Lesser General Public
// License as published by the Free Software Foundation; either
// version 2.1 of the License, or (at your option) any later version.
// 
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
// Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public
// License along with this library release; if not, write to the Free Software
// Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
// 
// LeWiz can be contacted at:  support@lewiz.com
// or address:  
// PO Box 9276
// San Jose, CA 95157-9276
// www.lewiz.com
// 
//    Author: LeWiz Communications, Inc.
//    Language: Verilog
//


`timescale 1ns / 1ns
module wrapper2(
			aclr,
			clk,    	   // i,Clk for writing data    
			wrreq,    	   // i,request to write 
			data,     	   // i,Data coming in 
			wrfull,   	   // o,indicates fifo is full or not (To avoid overiding)
		    wrempty,       // o,indicates fifo is empty or not (to avoid underflow)                                                            
            wrusedw,  	   // o,number of slots currently in use for writting
			rdreq,    		// i,Request to read from FIFO
			q, 	    		// o,Data coming out
			rdempty,  		 // o,indicates fifo is empty or not (to avoid underflow) 
			rdusedw,  		  //o, number of slots currently in use for reading
			rdfull  );

	parameter WIDTH = 8,
			  DEPTH = 4096,
			  PTR	= 12;

			input wire 				    aclr;

			input  wire 				clk;  	   // Clk for writing data 
			input  wire 				wrreq;  	   // request to write 
			input  wire [WIDTH-1 : 0]	data;         // Data coming in            
			output wire					wrfull; 	   // indicates fifo is full or not (To avoid overiding)
			output wire 			    wrempty;       // indicates fifo is empty or not (to avoid underflow)                        
			output wire	[PTR : 0]		wrusedw;	  // number of slots currently in use for writting

			input  wire 				rdreq;  	  // Request to read from FIFO  
			output wire [WIDTH-1 : 0]	q; 	    	  // Data coming out  
			output wire 				rdempty;	   // indicates fifo is empty or not (to avoid underflow)
			output wire [PTR : 0] 	rdusedw;    	    // number of slots currently in use for reading
			output wire 				rdfull; 

	fmac_fifo4Kx8 DUT(
			.aclr	(aclr),

			.wrclk	(clk),    	   // i,Clk for writing data    
			.wrreq	(wrreq),    	   // i,request to write 
			.data	(data),     	   // i,Data coming in 
			.wrfull	(wrfull),   	   // o,indicates fifo is full or not (To avoid overiding)
		    .wrempty	(wrempty),       // o,indicates fifo is empty or not (to avoid underflow)                                                            
            .wrusedw	(wrusedw),  	   // o,number of slots currently in use for writting

		    .rdclk	(clk),    	    // i,Clk for reading data 
			.rdreq	(rdreq),    		// i,Request to read from FIFO
			.q		(q), 	    		// o,Data coming out
			.rdempty	(rdempty),  		 // o,indicates fifo is empty or not (to avoid underflow) 
			.rdusedw	(rdusedw),  		  //o, number of slots currently in use for reading
			.rdfull 	(rdfull) );


endmodule

module fmac_fifo4Kx8

(
			 aclr,

			wrclk,    	   // i,Clk for writing data    
			wrreq,    	   // i,request to write 
			data,     	   // i,Data coming in 
			wrfull,   	   // o,indicates fifo is full or not (To avoid overiding)
		    wrempty,       // o,indicates fifo is empty or not (to avoid underflow)                                                            
            wrusedw,  	   // o,number of slots currently in use for writting

		    rdclk,    	    // i,Clk for reading data 
			rdreq,    		// i,Request to read from FIFO
			q, 	    		// o,Data coming out
			rdempty,  		 // o,indicates fifo is empty or not (to avoid underflow) 
			rdusedw,  		  //o, number of slots currently in use for reading
			rdfull    		 // o,indicates fifo is full or not (To avoid overiding)
			
);


	parameter WIDTH = 8,
			  DEPTH = 4096,
			  PTR	= 12;
			  
			  
			input wire 				    aclr;

			input  wire 				wrclk;  	   // Clk for writing data 
			input  wire 				wrreq;  	   // request to write 
			input  wire [WIDTH-1 : 0]	data;         // Data coming in            
			output wire					wrfull; 	   // indicates fifo is full or not (To avoid overiding)
			output wire 			    wrempty;       // indicates fifo is empty or not (to avoid underflow)                        
			output wire	[PTR : 0]		wrusedw;	  // number of slots currently in use for writting

		    input  wire 				rdclk;  	  // Clk for reading data 
			input  wire 				rdreq;  	  // Request to read from FIFO  
			output wire [WIDTH-1 : 0]	q; 	    	  // Data coming out  
			output wire 				rdempty;	   // indicates fifo is empty or not (to avoid underflow)
			output wire [PTR : 0] 	rdusedw;    	    // number of slots currently in use for reading
			output wire 				rdfull; 		 // indicates fifo is full or not (To avoid overiding)


			asynch_fifo 	#(.WIDTH (8),		
					  		  .DEPTH (4096),
					 		  .PTR	 (12) )		
 											
    async_4Kx8 (
			.reset_	(~aclr),
			
			.wrclk	(wrclk),		  // Clk to write data
			.wren	(wrreq),		 	// write enable
			.datain	(data),			   // write data
			.wrfull	(wrfull),		 // indicates fifo is full or not (To avoid overiding)
			.wrempty(wrempty),		  // indicates fifo is empty or not (to avoid underflow)
			.wrusedw(wrusedw),		  // wrusedw -number of locations filled in fifo


			.rdclk	(rdclk),			// i-1, Clk to read data
			.rden	(rdreq),			// i-1, read enable of data FIFO
			.dataout(q),				// Dataout of data FIFO
			.rdfull	(rdfull),			// indicates fifo is full or not (To avoid overiding) (Not used)
			.rdempty(rdempty),			// indicates fifo is empty or not (to avoid underflow)
			.rdusedw(rdusedw),		   // rdusedw -number of locations filled in fifo (not used )

			.dbg()

		 );
endmodule
