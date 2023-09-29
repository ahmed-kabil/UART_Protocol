module UART_receiver   
#(parameter bit = 8 ) (
input clk ,
input reset_n ,
input rx ,
input s_tick ,
output reg [bit-1 :0]data_out,
output reg r_done,
output reg clear_baud
);

reg [bit-1 :0]out_reg ;
reg [3:0] s_reg , s_next ;
reg [$clog2(bit):0] n_reg , n_next ;

localparam s0 = 0 , s1 = 1 , s2 = 2 , s3 = 3 ;
reg [1:0] state_reg , state_next ;

always @(*)
begin
if(~reset_n)
         state_reg = s0 ;
         out_reg <= 'b0 ;
         s_reg <= 0 ;
         n_reg <= 0 ;
         clear_baud <= 1'b1 ;
end
 
always @(posedge reset_n)  begin state_reg = s0 ; end
always @(posedge clk )
  begin
    if (reset_n)
       state_reg <= state_next ; 
       s_reg <= s_next ;
       n_reg <= n_next ;
  end

always @(*)
  begin
    case(state_reg)
      s0 : begin
           if(rx)
              begin
              clear_baud <= 1'b0;
              state_next <= s0 ;
              end
           else if (~rx)
              begin 
                state_next <= s1 ;
                s_next <= 0 ;
                n_next <= 0 ;
                r_done <= 1'b0 ;
                data_out <= 'bx ; 
                clear_baud <= 1'b1 ;
              end
           end
      s1 : clear_baud <= 1'b0 ;
      s2 : begin state_next <= s3 ;  out_reg [n_reg] <= rx ; end
      default : state_next <= state_next ;
    endcase
   end

always @(posedge s_tick)
  begin
    case(state_reg)
      s1 :  begin
              if (s_reg!=14)
                 begin
                    s_next <= s_reg+1 ;
                    state_next <= s1 ;
                 end
              else if (s_reg==14)
                 begin
                    state_next <= s2 ;
                    s_next <= 0 ;
                 end
            end

      s3 : begin
              if (s_reg==4) begin n_next <= n_reg+1 ; s_next <= s_reg+1 ; end
              else if( s_reg != 4 ) 
                 begin 
                    if(s_reg != 9)begin s_next <= s_reg+1 ; state_next <= s2 ; end
                    else if (s_reg == 9) 
                       begin
                         if (n_reg!=bit) begin state_next <= s2 ; s_next <=0 ;  end
                         else if (n_reg == bit) 
                             begin 
                                n_next <= 0 ;
                                s_next <= 0 ;
                                data_out <= out_reg ;
                                r_done <= 1 ;
                                state_next <= s0 ;
                             end
                       end
                 end
            end  

      default : state_next = state_next ;
    endcase
  end
  
endmodule
