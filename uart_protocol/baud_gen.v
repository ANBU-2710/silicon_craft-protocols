module baud_gen #(parameter clk_freq = 50000000,baud_rate = 9600)(input clk,rst_n,output reg baud_tick);

localparam clk_div = clk_freq / baud_rate;//clock divider logic creates the N clock cycle

reg[$clog2(clk_div) : 0]count;
//baud_gen logic
always@(posedge clk or negedge rst_n)begin
	if(!rst_n)begin//initialy resets value of counter and baud tick  to 0 when rest is active
		count <= 0;
		baud_tick <= 0;
	end
	else if(count == clk_div-1)begin //generate the baud_tick when the counter reaches the N cycles(5208 clock cycles)//counter resets to 0
		count <= 0;
		baud_tick <= 1;
	end
	else begin//counter can counts the value untill reaches N clock cycles(5208 cycles)
		count <= count + 1;
		baud_tick <= 0;
	end
end
endmodule
