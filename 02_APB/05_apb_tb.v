// Code your testbench here
// or browse Examples
// Code your testbench here
// or browse Examples

`timescale 1ns/1ns

module apb_tb;
  
  reg PCLK,PRESETn,READ_WRITE,transfer;
  reg [7:0]apb_write_data;
  reg [8:0]apb_write_paddr,apb_read_paddr;
  
  wire [7:0]apb_read_data_out;
  
  apb_top dut_top(PCLK,
                  PRESETn,
                  READ_WRITE,
                  transfer,
                  apb_write_data,
                  apb_write_paddr,
                  apb_read_paddr,
                  apb_read_data_out );
  
  initial begin
    PCLK = 0;
    forever #5 PCLK = ~PCLK;
  end
  
  
  task apb_write(input[8:0] addr, input[7:0] data);
    begin
      @(posedge PCLK);
      transfer = 1;
      READ_WRITE = 0;
      apb_write_paddr = addr;
      apb_write_data = data;
      
      @(posedge PCLK);
      @(posedge PCLK);
      
      transfer = 0;
    end
  endtask
  
  //APB READ TASK
  
  task apb_read(input[8:0] addr);
    begin
      @(posedge PCLK)
      transfer = 1;
      READ_WRITE = 1;
      apb_read_paddr = addr;
      
     // @(posedge PCLK)
      //@(posedge PCLK)
      @(posedge PCLK)
      @(posedge PCLK)
      
      transfer = 0;
      #1; // Delay for display

      
      $display("apb read_data_out = %0d",apb_read_data_out);
      
    end
  endtask
  
      
    
      
  initial begin
    
    $dumpfile("apb.vcd");
    $dumpvars(0,apb_tb);
    
    PRESETn = 0;
    transfer = 0;
    READ_WRITE = 0;
    apb_write_paddr = 0;
    apb_read_paddr = 0;
    apb_write_data = 0;
    
    #12;
    
    PRESETn = 1;
    
    
    apb_write(9'd5, 8'd55);
    apb_write(9'd10, 8'd99);
    
    

    apb_write(9'd260, 8'd123); 
    apb_write(9'd300, 8'd200);
    
    
    apb_read(9'd5);
    apb_read(9'd50);

    apb_read(9'd260);
    apb_read(9'd300);
    
    #50;
    
    $finish;
    
  end
endmodule
