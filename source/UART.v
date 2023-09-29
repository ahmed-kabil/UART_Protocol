module UART  
#(parameter value_bit = 9 , bit = 8 , sb = 2)(
input clk ,
input reset_n ,
input wr_en , rd_en ,
input [bit-1 : 0]data_in ,
input [value_bit - 1 : 0]final_value ,
input start_t ,
output t_done ,
output tx ,
output [bit-1 :0]data_out ,
output r_done ,
output waiting_trans_data_full , waiting_attatch_data_full ,
output [6:0]waiting_trans_data_num , waiting_attatch_data_num ,
input rx
);

wire s_tick , clear_baud_tran , clear_baud_rece , connect;
wire [bit-1:0]fifo_out ;
wire [bit-1:0]receive_out ;
reg reset_nn ;
wire fifo_empty_next ;
reg fifo_empty_reg ;

///  D_flip-flop
always @(posedge clk or negedge fifo_empty_next )  
  begin  
     if(~fifo_empty_next)
        fifo_empty_reg <= 1'b0 ;
     else
        fifo_empty_reg <= fifo_empty_next ;
  end

reg wr_to_receiver_fifo ;
always @(posedge r_done) begin 
       wr_to_receiver_fifo <= 1'b1 ;
       @(posedge clk) wr_to_receiver_fifo <= 1'b0 ;
    end

always@(negedge reset_n)
begin
 reset_nn <= 1'b0 ;
end

always@(posedge reset_n)
begin
        repeat(2)@(posedge clk ) ;
         begin
           reset_nn <= 1'b1 ; 
         end
end

baud_rate_generator #(.value_bit(value_bit)) baut (
.clk(clk),
.clear(clear_baud_tran || clear_baud_rece ),
.final_value(final_value),
.s_tick(s_tick)
);

fifo #(.bit(bit) , .depth_bit(6)) trans_fifo (
.clk(clk) ,
.rst(!reset_n) ,
.wr_en(wr_en) ,
.rd_en(t_done) ,
.fifo_in(data_in) ,
.fifo_out(fifo_out) ,
.fifo_empty(fifo_empty_next) ,
.fifo_full(waiting_trans_data_full) ,
.fifo_counter(waiting_trans_data_num) 
);

UART_transmitter #(.bit(bit) , .sb(sb)) tra (
.clk(clk),
.reset_n(reset_nn),
.s_tick(s_tick),
.data_in(fifo_out),
.start_t(start_t && !fifo_empty_reg),
.t_done(t_done) ,
.tx(tx),
.clear_baud(clear_baud_tran)
);


UART_receiver #(.bit(bit)) rec (
.clk(clk),
.reset_n(reset_nn),
.rx(rx),
.s_tick(s_tick),
.data_out(receive_out),
.r_done(r_done),
.clear_baud(clear_baud_rece)
);

fifo #(.bit(bit) , .depth_bit(6)) rece_fifo (
.clk(clk) ,
.rst(!reset_n) ,
.wr_en(wr_to_receiver_fifo) ,
.rd_en(rd_en) ,
.fifo_in(receive_out) ,
.fifo_out(data_out) ,
.fifo_empty() ,
.fifo_full(waiting_attatch_data_full) ,
.fifo_counter(waiting_attatch_data_num) 
);
  
endmodule
