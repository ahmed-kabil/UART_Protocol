module UART_transmitter    
#(parameter bit = 8 , sb = 2 )(
input clk,
input reset_n ,
input s_tick ,
input [bit-1 : 0]data_in ,
input start_t ,
output reg t_done ,
output reg tx ,
output reg clear_baud
);

reg [bit-1:0] in_reg ;
reg [$clog2(sb*10-1)-1:0] s_reg , s_next ;
reg [$clog2(bit)-1:0] n_reg , n_next ;
localparam s0 =0 , s1 = 1 , s2 = 2 , s3 = 3 , s4 = 4 ;
reg [2:0]state_reg , state_next ;


always @(negedge reset_n)
begin
         in_reg <= 0 ;
         clear_baud <= 1'b1 ;
         s_reg <= 0 ;
         n_reg <= 0 ;
         state_reg <= 'bx ;
         t_done <= 1'b1 ;
         tx <=1'b1 ;
end
 
always @(posedge reset_n)  begin t_done <= 1'b0 ; state_reg = s0 ; end
always @(posedge clk )
  begin
    if (reset_n)  begin
       state_reg <=state_next ; 
       s_reg <= s_next ;
       n_reg <= n_next ;
       end
  end

always @ (*)
  begin
    case(state_reg)
    s0:
      begin
           if (~start_t)
              begin
                  state_next = s0 ;
                  tx <=1'b1 ;
                  clear_baud <= 1'b0;
              end
           else if (start_t) 
              begin
                  state_next <= s1 ;
                  s_next <= 0 ;
                  in_reg <= 'b0 ;
                  clear_baud <= 1'b1;
                  t_done <= 1'b0 ;  
                  tx <=1'b1 ; 
              end
       end
    s1 : begin  clear_baud = 1'b0 ; tx = 1'b0 ;  end
    s2 :begin  tx = in_reg[n_reg]  ; end
    s3 :  tx = 1'b1 ; 
    default : tx = 1'b1 ;
    endcase
 end

always@(posedge s_tick)            
             begin

    case(state_reg)
      s1 :  begin
                if( s_reg != 9 )
                   begin 
                     state_next <= s1 ;
                     s_next <= s_reg + 1 ; 
                   end
                else if (s_reg == 9 )
                   begin
                     state_next <= s2  ;
                     s_next <= 0 ;
                     n_next <= 0 ;
                     in_reg <= data_in ;
                   end
            end

      s2 : 
            begin
              if(s_reg != 9)
                 begin
                   state_next <= s2 ;
                   s_next <= s_reg +1 ;
                 end
              else if (s_reg == 9 )
                 begin
                   if (n_reg!= bit-1)
                      begin
                        state_next <= s2 ;
                        s_next <= 0 ;
                        n_next <= n_reg+1 ;
                      end
                   else if (n_reg == bit-1) 
                      begin
                        state_next <= s3 ;
                        s_next <= 0 ;
                        n_next <= 0 ;
                      end
                 end
            end

      s3 : 
          begin
             if (s_reg != 10*sb-1 ) 
                begin 
                  state_next <= s3 ;
                  s_next <= s_reg + 1 ;
                end
             else if (s_reg == 10*sb-1) 
                begin 
                  t_done <= 1'b1 ;
                  state_next <= s0 ;
                  s_next <=0 ;
                end 
          end 
             
      default : state_next <= s0 ;
   endcase
end
  
endmodule
