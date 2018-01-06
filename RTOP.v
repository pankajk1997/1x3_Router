module router_top(input clock, resetn, pkt_valid, read_enb_0, read_enb_1, read_enb_2, input [7:0]data_in, output vld_out_0, vld_out_1, vld_out_2, err, busy, 

output [7:0]data_out_0, data_out_1, data_out_2);

wire [2:0]w_enb;
wire [2:0]soft_reset;
wire [2:0]read_enb; 
wire [2:0]empt;
wire [2:0]full;
wire lfd_state_w;
wire [7:0]data_out_temp[2:0];
wire [7:0]d_out;
genvar i;

generate 
for(i=0;i<3;i=i+1)

begin:fifo
	router_fifo f(.clock(clock), .resetn(resetn), .soft_reset(soft_reset[i]),
	.lfd_state(lfd_state_w), .write_enb(w_enb[i]), .data_in(d_out), .read_enb(read_enb[i]), 
	.full(full[i]), .empty(empt[i]), .data_out(data_out_temp[i]));
end
endgenerate

/*router_fifo f1(.clock(clock), .resetn(resetn), .soft_reset(soft_reset_0), .lfd_state(lfd_state), .write_enb(w_enb[0]), .data_in(d_out), .read_enb(read_enb_0), .full(full_0), .empty(empt_0), .data_out(data_out_0));
router_fifo f2(.clock(clock), .resetn(resetn), .soft_reset(soft_reset_1), .lfd_state(lfd_state), .write_enb(w_enb[1]), .data_in(d_out), .read_enb(read_enb_1), .full(full_1), .empty(empt_1), .data_out(data_out_1));
router_fifo f3(.clock(clock), .resetn(resetn), .soft_reset(soft_reset_2), .lfd_state(lfd_state), .write_enb(w_enb[2]), .data_in(d_out), .read_enb(read_enb_2), .full(full_2), .empty(empt_2), .data_out(data_out_2));*/

router_reg r1(.clock(clock), .resetn(resetn), .pkt_valid(pkt_valid), .data_in(data_in), .dout(d_out), .fifo_full(fifo_full), .detect_add(detect_add), .ld_state(ld_state),  .laf_state(laf_state), .full_state(full_state), .lfd_state(lfd_state_w), .rst_int_reg(rst_int_reg),  .err(err), .parity_done(parity_done), .low_packet_valid(low_packet_valid));

router_fsm fs1(.clock(clock), .resetn(resetn), .pkt_valid(pkt_valid), .data_in(data_in[1:0]), .soft_reset_0(soft_reset[0]), .soft_reset_1(soft_reset[1]), .soft_reset_2(soft_reset[2]), .fifo_full(fifo_full), .fifo_empty_0(empt[0]), .fifo_empty_1(empt[1]), .fifo_empty_2(empt[2]), .parity_done(parity_done), .low_packet_valid(low_packet_valid), .busy(busy), .rst_int_reg(rst_int_reg), .full_state(full_state), .lfd_state(lfd_state_w), .laf_state(laf_state), .ld_state(ld_state), .detect_add(detect_add), .write_enb_reg(write_enb_reg));

router_sync s1(.clock(clock), .resetn(resetn), .data_in(data_in[1:0]), .detect_add(detect_add), .full_0(full[0]), .full_1(full[1]), .full_2(full[2]), .read_enb_0(read_enb[0]), .read_enb_1(read_enb[1]), .read_enb_2(read_enb[2]), .write_enb_reg(write_enb_reg), .empty_0(empt[0]), .empty_1(empt[1]), .empty_2(empt[2]), .vld_out_0(vld_out_0), .vld_out_1(vld_out_1), .vld_out_2(vld_out_2), .soft_reset_0(soft_reset[0]), .soft_reset_1(soft_reset[1]), .soft_reset_2(soft_reset[2]), .write_enb(w_enb), .fifo_full(fifo_full));
 
assign read_enb[0]= read_enb_0;
assign read_enb[1]= read_enb_1;
assign read_enb[2]= read_enb_2;
assign  data_out_0=data_out_temp[0];
assign data_out_1=data_out_temp[1];
assign data_out_2=data_out_temp[2];

endmodule
