module frame_gen(input [7:0]data_in,output[9:0] frame_out);
assign frame_out ={1'b1,data_in,1'b0};
endmodule
