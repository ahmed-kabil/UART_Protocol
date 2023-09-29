module test_UART (    
input clk1 , clk2 ,
input reset_n ,
input wr_en1 , wr_en2 ,
input [7:0]data_in1 ,data_in2 ,
input start_transmit1 , start_transmit2 ,
input rd_en1 , rd_en2 ,
output [7:0]data_out1 , data_out2 
);

wire connect1 , connect2 ;

UART #(.value_bit(10) , .bit(8) , .sb(2)) uart1 (
  .clk(clk1),
  .reset_n(reset_n),
  .data_in(data_in1),
  .rx(connect2),
  .data_out(data_out1),
  .tx(connect1),
  .final_value(10'd379),
  .wr_en(wr_en1),
  .rd_en(rd_en1),
  .start_t(start_transmit1)
);

UART #(.value_bit(10) , .bit(8) , .sb(2)) uart2 (
  .clk(clk2),
  .reset_n(reset_n),
  .data_in(data_in2),
  .rx(connect1),
  .data_out(data_out2),
  .tx(connect2),
  .final_value(10'd253),
  .wr_en(wr_en2),
  .rd_en(rd_en2),
  .start_t(start_transmit2)
);

endmodule
