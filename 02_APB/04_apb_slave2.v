///APB SLAVE_1////

module apb_slave2(
  
  //SLAVE1 INPUTS
  input PCLK,PRESETn,PENABLE,PSEL,PWRITE,
  input [8:0]PADDR,
  input [7:0] PWDATA,
  //SLAVE2 OUPUTS
  output [7:0]PRDATA2,
  output reg PREADY2
  
);
  
  reg[7:0] reg_addr;
  reg[7:0]mem[0:255];
 
  assign PRDATA2 = mem[PADDR[7:0]];
  
  always @(posedge PCLK)begin
    
    if(!PRESETn)
      PREADY2 <= 0;
    
     //read logic 
     
    else if(PSEL && PENABLE && !PWRITE)begin
      PREADY2 <= 1;
      reg_addr <= PADDR[7:0];
      end
    
    //WRITE LOGIC
    
    else if(PSEL && PENABLE && PWRITE)begin
      PREADY2 <= 1;
      mem[PADDR[7:0]] <= PWDATA;
    end
    
    else
      PREADY2 <= 0;
    
  end
  
endmodule
