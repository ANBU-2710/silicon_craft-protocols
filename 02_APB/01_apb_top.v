`timescale 1ns/1ps

`include "apb_master.v"
`include "apb_slave1.v"
`include "apb_slave2.v"

module apb_top(
  
  //input signals
  
  input PCLK,PRESETn,READ_WRITE,transfer,
  input [7:0]apb_write_data,
  input [8:0]apb_write_paddr,apb_read_paddr,
  
  //ouput 
  
  output [7:0]apb_read_data_out
  
);
  
  wire [7:0]PWDATA,PRDATA,PRDATA1,PRDATA2;
  wire [8:0]PADDR;
  wire PREADY,PREADY1,PREADY2,PENABLE,PSEL1,PSEL2,PWRITE;
  
  assign PREADY = PADDR[8] ? PREADY2 : PREADY1;
  assign PRDATA = READ_WRITE ? (PADDR[8] ? PRDATA2 : PRDATA1) : 8'bx;
  
  //MASTER
  
  apb_master dut_master(.PCLK(PCLK), 
             .PRESETn(PRESETn), 
             .READ_WRITE(READ_WRITE), 
             .transfer(transfer), 
             .PREADY(PREADY),
             .apb_write_data(apb_write_data),
             .PRDATA(PRDATA),
             .apb_write_paddr(apb_write_paddr),
             .apb_read_paddr(apb_read_paddr),
             .sel1(PSEL1),
             .sel2(PSEL2),
             .PENABLE(PENABLE),
             .PWRITE(PWRITE),
             .PWDATA(PWDATA),
             .apb_read_data_out(apb_read_data_out),
             .PADDR(PADDR)
             
            );
  
  //SLAVE1
  
  apb_slave1 dut_slave1(.PCLK(PCLK),
                        .PRESETn(PRESETn),
                        .PENABLE(PENABLE),
                        .PSEL(PSEL1),
                        .PWRITE(PWRITE),
                        .PADDR(PADDR),
                        .PWDATA(PWDATA),
                        .PRDATA1(PRDATA1),
                        .PREADY1(PREADY1)
                        
                       );
  
  //SLAVE2
  
  apb_slave2 dut_slave2(.PCLK(PCLK),
                        .PRESETn(PRESETn),
                        .PENABLE(PENABLE),
                        .PSEL(PSEL2),
                        .PWRITE(PWRITE),
                        .PADDR(PADDR),
                        .PWDATA(PWDATA),
                        .PRDATA2(PRDATA2),
                        .PREADY2(PREADY2)
                        
                       );
  
endmodule
