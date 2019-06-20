// mfp_ahb_gpio.v
//
// General-purpose I/O module for Altera's DE2-115 and 
// Digilent's (Xilinx) Nexys4-DDR board


`include "mfp_ahb_const.vh"

module mfp_ahb_gpio(
    input                        HCLK,
    input                        HRESETn,
    input      [  3          :0] HADDR,
    input      [  1          :0] HTRANS,
    input      [ 31          :0] HWDATA,
    input                        HWRITE,
    input                        HSEL,
    output reg [ 31          :0] HRDATA,

// memory-mapped I/O
    input      [`MFP_N_SW-1  :0] IO_Switch,
    input      [`MFP_N_PB-1  :0] IO_PB,
    output reg [`MFP_N_LED-1 :0] IO_LED,
    //------------------------------------------------
    // Rojobot inputs and outputs
    // Output: IO_INT_ACK && IO_BotCtrl
    // Input:  IO_BotUpdt_Sync && IO_BotInfo
    //------------------------------------------------
    output reg             [7:0] IO_BotCtrl,
    output reg                   IO_INT_ACK,
    input                 [31:0] IO_BotInfo,
    input                        IO_BotUpdt_Sync
);

  reg  [3:0]  HADDR_d;
  reg         HWRITE_d;
  reg         HSEL_d;
  reg  [1:0]  HTRANS_d;
  wire        we;            // write enable

  // delay HADDR, HWRITE, HSEL, and HTRANS to align with HWDATA for writing
  always @ (posedge HCLK) 
  begin
    HADDR_d  <= HADDR;
	HWRITE_d <= HWRITE;
	HSEL_d   <= HSEL;
	HTRANS_d <= HTRANS;
  end
  
  // overall write enable signal
  assign we = (HTRANS_d != `HTRANS_IDLE) & HSEL_d & HWRITE_d;

    always @(posedge HCLK or negedge HRESETn)
       if (~HRESETn) begin
         IO_LED <= `MFP_N_LED'b0;  
       end else if (we)
         case (HADDR_d)
           `H_LED_IONUM: IO_LED <= HWDATA[`MFP_N_LED-1:0];
         endcase
    
	always @(posedge HCLK or negedge HRESETn)
       if (~HRESETn)
         HRDATA <= 32'h00000000;
       else
	     case (HADDR)
           `H_SW_IONUM: HRDATA <= { {32 - `MFP_N_SW {1'b0}}, IO_Switch };
           `H_PB_IONUM: HRDATA <= { {32 - `MFP_N_PB {1'b0}}, IO_PB };
           //------------------------------------------------
           // Added data assignments for rojobot along with 
           // GPIOS. 
           //------------------------------------------------
           `H_BOTINFO_IONUM: HRDATA <= IO_BotInfo;
           `H_BOTCTRL_IONUM: IO_BotCtrl <= HWDATA[7:0];
           `H_BOTUPDT_IONUM: HRDATA <= IO_BotUpdt_Sync;
           `H_INTACK_IONUM: IO_INT_ACK <= HWDATA[0];
            default:    HRDATA <= 32'h00000000;
         endcase
		 
endmodule

