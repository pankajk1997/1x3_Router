module router_reg(input clock, resetn, pkt_valid, input [7:0] data_in, input fifo_full, detect_add, ld_state, laf_state, full_state, lfd_state, rst_int_reg,

output reg err, parity_done, low_packet_valid, output reg [7:0]dout);
reg [7:0]header_byte, internal_parity, temp_parity;
reg [7:0] data_reg;	//reg parity_done_reg;

always @(posedge clock)	 // data_out logic
	begin
		if(~resetn)
		begin
			dout<=0;
			header_byte<=0;
			data_reg<=0;
		end
		else if(detect_add && pkt_valid)
			header_byte<= data_in;
		else if(lfd_state)
			dout<= header_byte;
		else if(ld_state && ~fifo_full)
			dout<= data_in;
		else if(ld_state && fifo_full)
			data_reg<=data_in;
		else if(laf_state)
			dout<=data_reg;
end

	always@(posedge clock)	// parity done logic 
	begin
			if(~resetn)
	begin
		parity_done<=0;
	end
			else if(ld_state  && (~fifo_full && ~pkt_valid) || (laf_state && low_packet_valid && (parity_done==0)))
		parity_done<=1'b1;
			else if(detect_add)
		parity_done<=0;
	end

always@(posedge clock)	// low_packet_valid
	begin
			if(~resetn)
				low_packet_valid<=0;
			else if(ld_state && ~pkt_valid)
				low_packet_valid<=1'b1;
			else if(rst_int_reg)
				low_packet_valid<=1'b0;
	end

always@(posedge clock)	// err logic
	begin
			if(~resetn)
				err<=0;
			else if(parity_done)
	begin
		 	if(internal_parity==temp_parity)
				err<=1'b0;
			else 
				err<=1'b1;
	end
	end

always@(posedge clock)
	begin
		if(~resetn)
			internal_parity<=0;
		else if(lfd_state && pkt_valid)
			internal_parity<= internal_parity^header_byte;
		else if (ld_state && ~full_state && pkt_valid)
			internal_parity<= internal_parity^data_in;
	end

always@(posedge clock)
	begin
		if(~resetn)
			temp_parity<=0;
		else if(ld_state && ~pkt_valid)
			temp_parity<= data_in;	
	end 

endmodule
