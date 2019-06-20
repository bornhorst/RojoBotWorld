// 
// mfp_ahb_const.vh
//
// Verilog include file with AHB definitions
// 

//---------------------------------------------------
// Physical bit-width of memory-mapped I/O interfaces
//---------------------------------------------------
`define MFP_N_LED             16
`define MFP_N_SW              16
`define MFP_N_PB              5
`define MFP_N_SEG             32


//---------------------------------------------------
// Memory-mapped I/O addresses
//---------------------------------------------------
`define H_LED_ADDR    			(32'h1f800000)
`define H_SW_ADDR   			(32'h1f800004)
`define H_PB_ADDR   			(32'h1f800008)
// 7 Segment physical address enable
`define H_7SEG_EN_ADDR          (32'h1F700000)
// 7 Segment physical address decimal points
`define H_7SEG_DP_ADDR          (32'h1F70000C)
// 7 segment physical address lower digits
`define H_7SEG_LOWER_DIG_ADDR   (32'h1F700008)
// 7 segment physical address upper digits
`define H_7SEG_UPPER_DIG_ADDR   (32'h1F700004)
// Rojobot IO_BotInfo Physical Address.
`define H_BOTINFO_ADDR          (32'h1F80000C)
// Rojobot IO_BotCtrl Physical Address.
`define H_BOTCTRL_ADDR          (32'h1F800010)
// Rojobot Bot_Update Physical Address.
`define H_BOTUPDT_ADDR          (32'h1F800014)
// Rojobot Bot Int Ack Physical Address.
`define H_INTACK_ADDR           (32'h1F800018)

`define H_LED_IONUM   			(4'h0)
`define H_SW_IONUM  			(4'h1)
`define H_PB_IONUM  			(4'h2)
`define H_BOTINFO_IONUM         (4'h3)
`define H_BOTCTRL_IONUM         (4'h4)
`define H_BOTUPDT_IONUM         (4'h5)
`define H_INTACK_IONUM          (4'h6)

//---------------------------------------------------
// RAM addresses
//---------------------------------------------------
`define H_RAM_RESET_ADDR 		(32'h1fc?????)
`define H_RAM_ADDR	 		    (32'h0???????)
`define H_RAM_RESET_ADDR_WIDTH  (8) 
`define H_RAM_ADDR_WIDTH		(16) 
`define H_7SEG_PHYS_ADDR        (32'h1f7?????)

`define H_RAM_RESET_ADDR_Match  (7'h7f)
`define H_RAM_ADDR_Match 		(1'b0)
`define H_LED_ADDR_Match		(7'h7e)
// Common MSB values of 7 segment addresses.
`define H_7SEG_ADDR_Match       (7'h7D)

//---------------------------------------------------
// AHB-Lite values used by MIPSfpga core
//---------------------------------------------------

`define HTRANS_IDLE    2'b00
`define HTRANS_NONSEQ  2'b10
`define HTRANS_SEQ     2'b11

`define HBURST_SINGLE  3'b000
`define HBURST_WRAP4   3'b010

`define HSIZE_1        3'b000
`define HSIZE_2        3'b001
`define HSIZE_4        3'b010
