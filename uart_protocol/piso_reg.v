module piso_reg #(parameter width = 10)(input clk,rst_n,shift,load,
	input [width-1:0] p_data,
	output reg serial_data);
reg[width-1:0]shift_reg;
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin
		shift_reg <= {width{1'b1}};
		serial_data <= 1'b1;
	end
	else if(load)
		shift_reg <= p_data;
	else if(shift)begin
		serial_data <= shift_reg[0];
		shift_reg <= shift_reg >> 1;
	end
end
endmodule
