module router_top_tb();
reg clock, resetn, read_enb_0, read_enb_1, read_enb_2, pkt_valid;
reg [7:0]data_in;
wire [7:0]data_out_0, data_out_1, data_out_2;
wire vld_out_0, vld_out_1, vld_out_2, err, busy;
event simrdwr;
event check_vld_0;
event check_vld_1;
event check_vld_2;
parameter DELAY=10;
	 
integer i;

router_top DUT(clock, resetn, pkt_valid, read_enb_0, read_enb_1, read_enb_2, data_in, vld_out_0, vld_out_1, vld_out_2, err, busy, data_out_0, data_out_1, data_out_2);

always
begin
clock=0;
#(DELAY/2);
clock=1'b1;
#(DELAY/2);
end

task rst;
begin
resetn=0;
@(negedge clock);
resetn=1'b1;
end
endtask

task initialize;
begin
{read_enb_0, read_enb_1, read_enb_2, pkt_valid, data_in}=0;
end
endtask

task pktm_gen_8;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [13:0]payloadlen;
			reg [7:0]cparity;
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clock);
				payloadlen=8;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clock);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clock);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clock);
					pkt_valid=0;				
					data_in=parity;
			end
endtask


task pkt_gen_17;	// packet generation payload 17
			reg [7:0]header, payload_data, parity;
			reg [13:0]payloadlen;
			reg [7:0]cparity;
			begin
			parity=0;
			wait(!busy)
			begin
			@(negedge clock);
			payloadlen=17;
			pkt_valid=1'b1;
			header={payloadlen,2'b00};
			data_in=header;
			parity=parity^data_in;
			end
			@(negedge clock);
			for(i=0;i<payloadlen;i=i+1)
			begin
			wait(!busy)				
			@(negedge clock);
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^data_in;				
			end					
							
			wait(!busy)				
			@(negedge clock);
			pkt_valid=0;				
			data_in=parity;
			repeat(10)
			@(negedge clock);
			read_enb_0=1'b1;
			->check_vld_0;
			end
endtask

task pktcrpt_gen_8;	// packet generation payload 16
			reg [7:0]header,payload_data,parity;
			reg[13:0]payloadlen;

			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clock);
				payloadlen=8;
				pkt_valid=1'b1;
				header={payloadlen,2'b00};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clock);
					
				for(i=0;i<payloadlen;i=i+1)
				begin
				wait(!busy)				
				@(negedge clock);
				payload_data={$random}%256;
				data_in=payload_data;
				parity=parity^data_in;				
				end					
							
				wait(!busy)				
				@(negedge clock);
				pkt_valid=0;				
				data_in=~parity;
				repeat(10)
				@(negedge clock);
				read_enb_0=1'b1;
				->check_vld_0;
				end
endtask

task pkt_gen_16;	// packet generation payload 16
			reg [7:0]header,payload_data,parity;
			reg[13:0]payloadlen;
			reg[7:0]cparity;
			begin
			parity=0;
			wait(!busy)
			begin
			@(negedge clock);
			payloadlen=16;
			pkt_valid=1'b1;
			header={payloadlen,2'b10};
			data_in=header;
			parity=parity^data_in;
			end
			@(negedge clock);
						
			for(i=0;i<payloadlen;i=i+1)
			begin
			wait(!busy)				
			@(negedge clock);
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^data_in;				
			end					
				
			wait(!busy)				
			@(negedge clock);
			pkt_valid=0;				
			data_in=parity;
			repeat(4)
			@(negedge clock);
			read_enb_2=1'b1;
			->check_vld_2;
			end
endtask

task pkt_gen_14;	// packet generation payload 14
			reg [7:0]header,payload_data,parity;
			reg[13:0]payloadlen;
			reg[7:0]cparity;
			begin
			parity=0;
			wait(!busy)
			begin
			@(negedge clock);
			payloadlen=14;
			pkt_valid=1'b1;
			header={payloadlen,2'b10};
			data_in=header;
			parity=parity^data_in;
			end
			@(negedge clock);
					
			for(i=0;i<payloadlen;i=i+1)
			begin
			wait(!busy)				
			@(negedge clock);
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^data_in;				
			end					
				
			wait(!busy)				
			@(negedge clock);
			pkt_valid=0;				
			data_in=parity;
			repeat(10)
			@(negedge clock);
			read_enb_2=1'b1;
			-> check_vld_2;
			end
endtask

task pkt_gen_2(input [1:0]des);	// packet generation payload 2
			reg [7:0]header,payload_data,parity;
			reg[13:0]payloadlen;
			reg[7:0]cparity;
			begin
			parity=0;
			wait(!busy)
			begin
			@(negedge clock);
			payloadlen=2;
			pkt_valid=1'b1;
			header={payloadlen,des};
			data_in=header;
			parity=parity^data_in;
			end
			@(negedge clock);
				
			for(i=0;i<payloadlen;i=i+1)
			begin
			wait(!busy)				
			@(negedge clock);
			payload_data={$random}%256;
			data_in=payload_data;
			parity=parity^data_in;				
			end					
				
			wait(!busy)				
			@(negedge clock);
			pkt_valid=0;				
			data_in=parity;
			end
endtask

task pktsim_gen_8;	// packet generation payload 8
			reg [7:0]header,payload_data,parity;
			reg[13:0]payloadlen;
			reg[7:0]cparity;
			begin
			parity=0;
			wait(!busy)
			begin
			@(negedge clock);
			payloadlen=8;
			pkt_valid=1'b1;
			header={payloadlen,2'b10};
			data_in=header;
			parity=parity^data_in;
			end
			@(negedge clock);
			for(i=0;i<payloadlen;i=i+1)
			begin
			wait(!busy)				
			@(negedge clock);
			payload_data={$random}%256;
			data_in=payload_data;
			-> simrdwr;
			parity=parity^data_in;				
			end									
			wait(!busy)				
			@(negedge clock);
			pkt_valid=0;				
			data_in=parity;
			end
endtask

initial
begin
@(simrdwr);
wait(vld_out_2)
	begin
	read_enb_2 = 1'b1;
	end
end

initial			
begin				
@(check_vld_2);		
wait(~vld_out_2)
	read_enb_2=0;
end

initial
begin
@(check_vld_0);
wait(~vld_out_0)
read_enb_0=0;
end

initial
begin
@(check_vld_1);
wait(vld_out_1)
read_enb_1=0;
end

initial
begin
initialize; 
rst;
pkt_gen_14;

pkt_gen_16;
pkt_gen_17;

pktcrpt_gen_8;
pktsim_gen_8;

pkt_gen_2(00);

@(negedge clock);
pkt_gen_2(00);

@(negedge clock);
pkt_gen_2(00);
pktm_gen_8;
#1000 $finish;
end

endmodule
