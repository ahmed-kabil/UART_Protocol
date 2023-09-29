module test_UART_tb (); 
reg clk1 , clk2 ;
reg reset_n ;
reg wr_en1 , wr_en2 ;
reg [7:0]data_in1 ,data_in2 ;
reg start_transmit1 , start_transmit2 ;
reg rd_en1 , rd_en2 ;
wire [7:0]data_out1 , data_out2 ;

test_UART UUT (
.clk1(clk1),
.clk2(clk2),
.reset_n(reset_n),
.wr_en1(wr_en1),
.wr_en2(wr_en2),
.data_in1(data_in1),
.data_in2(data_in2),
.start_transmit1(start_transmit1) ,
.start_transmit2(start_transmit2) ,
.rd_en1(rd_en1),
.rd_en2(rd_en2),
.data_out1(data_out1),
.data_out2(data_out2)
);

parameter T1 = 20 , T2 = 30 ;

always
begin
clk1 = 1'b0 ; #(T1/2)
clk1 = 1'b1 ; #(T1/2) ;
end

always
begin
clk2 = 1'b0 ; #(T2/2)
clk2 = 1'b1 ; #(T2/2) ;
end

initial   begin
reset_n = 1'b0 ;
wr_en1 = 1'b1 ;
wr_en2 = 1'b1 ;
rd_en1 = 1'b1 ;
rd_en2 = 1'b1 ;
start_transmit1 = 1'b1 ;
start_transmit2 = 1'b1 ;
 #5 ;
reset_n = 1'b1 ;
end

initial   begin
#5
data_in1 = 8'd20 ; #T1 
data_in1 = 8'd40 ; #T1
data_in1 = 8'd60 ; #T1
data_in1 = 8'd80 ; #T1
data_in1 = 8'd100 ; #T1
data_in1 = 8'd120 ; #T1
data_in1 = 8'd140 ; #T1
data_in1 = 8'd160 ; #T1
data_in1 = 8'd180 ; #T1
data_in1 = 8'd200 ; #T1
wr_en1 = 1'b0 ;
end

initial   begin
#5
data_in2 = 8'd10 ; #T2 ;
data_in2 = 8'd30 ; #T2
data_in2 = 8'd50 ; #T2
data_in2 = 8'd70 ; #T2
data_in2 = 8'd90 ; #T2
data_in2 = 8'd110 ; #T2
data_in2 = 8'd130 ; #T2
data_in2 = 8'd150 ; #T2
data_in2 = 8'd170 ; #T2
data_in2 = 8'd190 ; #T2
wr_en2 = 1'b0 ;
end  

endmodule
