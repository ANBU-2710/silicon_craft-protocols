module uart_rx (input clk,rst_n,baud_tick,rx_data_in,output reg [7:0] rx_data,
	output reg rx_done);
reg[7:0] data_reg;
reg[3:0] bit_count;
reg rx_busy;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		bit_count <= 0;
		rx_busy <= 0;
		rx_done <= 0;
	end
	else begin
		rx_done <= 0;
		if(!rx_busy && !rx_data_in)begin
			rx_busy <= 1;
			bit_count <= 0;
		end
		else if(rx_busy && baud_tick)begin
			bit_count <= bit_count + 1;
			if(bit_count >= 1 && bit_count <= 8)
				data_reg <= {rx_data_in,data_reg[7:1]};
			if (bit_count == 9)begin
				rx_data <= data_reg;
				rx_done <= 1;
				rx_busy <= 0;
			end
		end
	end
end
endmodule
