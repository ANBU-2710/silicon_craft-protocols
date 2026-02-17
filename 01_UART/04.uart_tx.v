module uart_tx #(parameter width = 10)(input clk,rst_n,baud_tick,tx_start,
	input [7:0]tx_data,
	output tx_data_out,
	output reg tx_busy);
reg load_piso,shift_piso;
reg[$clog2(width):0] bit_count;
wire [width-1:0] uart_frame;
frame_gen fg_tx(.data_in(tx_data),
	.frame_out(uart_frame));
piso_reg #(.width(10)) piso_tx(.clk(clk),
	.rst_n(rst_n),
	.shift(shift_piso),
	.load(load_piso),
	.p_data(uart_frame),
	.serial_data(tx_data_out));
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		tx_busy <= 0;
		bit_count <= 0;
		load_piso <= 0;
		shift_piso <= 0;
	end
	else begin
		load_piso <= 0;
		shift_piso <= 0;
		if(tx_start && !tx_busy)begin
			tx_busy <= 1;
			bit_count <= 0;
			load_piso <= 1;
		end
		else if(tx_busy && baud_tick)begin
			shift_piso <= 1;
			bit_count <= bit_count+1;
			if(bit_count == width-1)begin
				tx_busy <= 0;
			end
		end
	end
end			
endmodule
