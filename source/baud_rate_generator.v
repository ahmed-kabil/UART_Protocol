module baud_rate_generator
#(parameter value_bit = 10 )(
input clk,
input clear ,
input [value_bit-1:0]final_value,
output s_tick
);

reg [value_bit - 1 : 0]Q_reg , Q_next ;

always @(posedge clk , posedge clear)
  begin
    if(clear)
       Q_reg = 0 ;
    else
       Q_reg = Q_next ;
  end

assign s_tick = (Q_reg == final_value) ;

always @(*)
  begin
    Q_next = s_tick ? 'b0 : Q_reg +1 ;
  end
  
endmodule
