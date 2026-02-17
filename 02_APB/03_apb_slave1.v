///APB SLAVE_1////

module apb_slave1(
  
  //SLAVE1 INPUTS
  input PCLK,PRESETn,PENABLE,PSEL,PWRITE,
  input [8:0]PADDR,
  input [7:0]PWDATA,
  //SLAVE2 OUPUTS
  output [7:0]PRDATA1,
  output reg PREADY1
  
);
  
  reg [7:0] reg_addr;
  reg [7:0] mem [0:255];
  
  assign PRDATA1 = mem[PADDR[7:0]];
  
  always @(posedge PCLK)begin
    
    if(!PRESETn)
      PREADY1 <= 0;
    
     //read logic 
     
    else if(PSEL && PENABLE && !PWRITE)begin
      PREADY1 <= 1;
      reg_addr <= PADDR[7:0];
    end
    
    //WRITE LOGIC
    
    else if(PSEL && PENABLE && PWRITE)begin
      PREADY1 <= 1;
      mem[PADDR[7:0]] <= PWDATA;
    end
    
    else
      PREADY1 <= 0;
    
  end
  
endmodule
