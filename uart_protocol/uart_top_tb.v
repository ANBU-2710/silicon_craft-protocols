module uart_top_tb;
reg clk,rst_n,tx_start;
	reg [7:0]tx_data;
	wire tx_busy,rx_done;
	wire [7:0]rx_data;
	uart_top top_tb(.clk(clk),.rst_n(rst_n),.tx_start(tx_start),.tx_data(tx_data),.tx_busy(tx_busy),.rx_done(rx_done),.rx_data(rx_data));
	always #10 clk = ~clk;
	initial begin 
		clk = 0;
		rst_n = 0;
		tx_start = 0;
		tx_data = 8'h00;
		#20;
		rst_n = 1;
		#20;
		tx_start = 1;
		tx_data = 8'h41;
		#20;
		tx_start = 0;
		
		wait(rx_done);
		$display("received_data = %c",rx_data);
		#50;
		$finish;
	end
	initial begin
		$dumpfile("uart.vcd");
		$dumpvars(0,uart_top_tb);
	end
endmodule
