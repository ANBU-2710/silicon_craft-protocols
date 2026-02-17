module apb_master(
  
  //declare the input signals for master
  input PCLK,PRESETn,READ_WRITE,transfer,PREADY,
  input [7:0]apb_write_data,PRDATA,
  input [8:0]apb_write_paddr,apb_read_paddr,
  
  //output signals for master 
  output reg sel1,sel2,
  output reg PENABLE,PWRITE,
  output reg [7:0]PWDATA,apb_read_data_out,
  output reg [8:0]PADDR
  
);
  
  //declare the states
  
  reg[1:0] state,next_state;
  localparam IDLE = 2'b00, SETUP = 2'b01, ACCESS = 2'b10;
  
  //state reset logic
  
  always @(posedge PCLK or negedge PRESETn)begin
    
    if(!PRESETn) begin
      state <= IDLE;
      apb_read_data_out <= 0;
    end
    else begin
      state <= next_state;
      // Capture read data when transaction completes (PREADY high in ACCESS)
      if (state == ACCESS && PREADY && READ_WRITE)
        apb_read_data_out <= PRDATA;
    end
  end
  
  //master fsm logic
  always @(*)begin
    // Default values to prevent latches
    PENABLE = 0;
    sel1 = 0;
    sel2 = 0;
    PWRITE = 0;
    PWDATA = 0;
    PADDR = 0;
    next_state = state;
      
    case(state)
      
      //IDLE STATE LOGIC
      IDLE: begin
        if(transfer)
          next_state = SETUP;
        else
          next_state = IDLE;
      end
      
      //SETUP STATE
      SETUP: begin
        PENABLE = 0;
        PWRITE = ~READ_WRITE;
        
        if(READ_WRITE)begin
          PADDR = apb_read_paddr;
          PWDATA = 0;
        end
        else begin
          PADDR = apb_write_paddr;
          PWDATA = apb_write_data;
        end
        
        if(PADDR[8]==1'b0)begin
          sel1 = 1;
          sel2 = 0;
        end
        else begin
          sel1 = 0;
          sel2 = 1;
        end
        
        next_state = ACCESS;
      end
      
      //ACCESS STATE LOGIC
      ACCESS: begin
        // Keep address and data stable
        PENABLE = 1;
        PWRITE = ~READ_WRITE; // Keep PWRITE stable

        // Re-assert address/data/sel logic from SETUP
        // (In a Moore machine, these depend on state. Here they depend on state & inputs)
        // To be safe, we should duplicate logic or latch outputs.
        // But for APB, PADDR/PWDATA must be stable.
        
        if(READ_WRITE)begin
          PADDR = apb_read_paddr;
          PWDATA = 0;
        end
        else begin
          PADDR = apb_write_paddr;
          PWDATA = apb_write_data;
        end
        
        if(PADDR[8]==1'b0)begin
          sel1 = 1;
          sel2 = 0;
        end
        else begin
          sel1 = 0;
          sel2 = 1;
        end

        if(PREADY)begin
          if(transfer)
            next_state = SETUP;
          else
            next_state = IDLE;
        end
        else
          next_state = ACCESS;
        
      end
      
      default: next_state = IDLE;
      
    endcase
    
  end
  
endmodule
