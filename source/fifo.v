module fifo 
#(parameter bit = 8 , depth_bit = 6)(      
input clk, rst, wr_en, rd_en ,
input [bit-1:0]fifo_in ,
output reg [bit-1:0]fifo_out ,
output reg fifo_empty, fifo_full ,
output reg [depth_bit:0]fifo_counter
);

reg [depth_bit -1:0]wr_ptr, rd_ptr ;
reg [bit-1:0]fifo_memory[0:2**depth_bit -1] ;

always @(fifo_counter)
  begin
    fifo_empty <= (fifo_counter == 0) ;
    fifo_full <= (fifo_counter == 2**depth_bit) ;
  end 


always @ (posedge clk or posedge rst)
  begin
    if(rst)
       fifo_counter <= 0 ;
    else if((wr_en && !fifo_full)&&(rd_en && !fifo_empty))
       fifo_counter <= fifo_counter ;
    else if (wr_en && !fifo_full)
       fifo_counter <= fifo_counter + 1 ;
    else if (rd_en && !fifo_empty)
       fifo_counter <= fifo_counter - 1 ;
    else
       fifo_counter <= fifo_counter ;
  end


always @ (posedge clk or posedge rst)
  begin
    if(rst)
       begin  wr_ptr <= 0 ; rd_ptr <= 0 ; end
    else if((wr_en && !fifo_full)&&(rd_en && !fifo_empty))
       begin  wr_ptr <= wr_ptr + 1 ; rd_ptr <= rd_ptr + 1 ;  end
    else if (wr_en && !fifo_full)
       begin  wr_ptr <= wr_ptr + 1 ; rd_ptr <= rd_ptr  ;  end
    else if (rd_en && !fifo_empty)
       begin  wr_ptr <= wr_ptr  ; rd_ptr <= rd_ptr + 1 ;  end
    else
       begin  wr_ptr <= wr_ptr  ; rd_ptr <= rd_ptr ;  end
  end


always@(posedge clk or posedge rst)
  begin
    if(rst)
       fifo_memory[wr_ptr] <= 'b0 ;
    else if(wr_en && !fifo_full)
       fifo_memory[wr_ptr] <= fifo_in ;
    else
       fifo_memory[wr_ptr] <= fifo_memory[wr_ptr] ;
  end


always@(posedge clk , posedge rst)
  begin
    if(rst)
      fifo_out <= 0 ;
    else if (rd_en && !fifo_empty)
      fifo_out <= fifo_memory[rd_ptr] ;
    else
      fifo_out <= fifo_out ;
  end

endmodule
