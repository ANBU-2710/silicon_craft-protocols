module uart_top(
input clk,rst_n,tx_start,
	input[7:0]tx_data,
	output tx_busy,rx_done,
	output[7:0]rx_data);
wire tx_rx_data;
wire baud_tick;
baud_gen #(.clk_freq(50000000),.baud_rate(9600)) baud_gen_top (.clk(clk),.rst_n(rst_n),.baud_tick(baud_tick));

uart_tx #(.width(10)) tx_top(.clk(clk),.rst_n(rst_n),.baud_tick(baud_tick),.tx_start(tx_start),.tx_data(tx_data),.tx_data_out(tx_rx_data),.tx_busy(tx_busy));

uart_rx rx_top(.clk(clk),.rst_n(rst_n),.baud_tick(baud_tick),.rx_data_in(tx_rx_data),.rx_data(rx_data),.rx_done(rx_done));

endmodule
