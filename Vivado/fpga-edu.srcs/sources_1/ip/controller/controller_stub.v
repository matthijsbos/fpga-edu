// Copyright 1986-2015 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2015.1 (win64) Build 1215546 Mon Apr 27 19:22:08 MDT 2015
// Date        : Sat May 16 22:09:01 2015
// Host        : Thinkpad-Twist running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub
//               c:/Users/Matthijs/Dropbox/Informatica/Afstuderen/fpga-edu/Vivado/fpga-edu.srcs/sources_1/ip/controller/controller_stub.v
// Design      : controller
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "microblaze_mcs,Vivado 2015.1" *)
module controller(Clk, Reset, UART_Rx, UART_Tx, UART_Interrupt, GPO1, GPI1, GPI1_Interrupt, INTC_IRQ)
/* synthesis syn_black_box black_box_pad_pin="Clk,Reset,UART_Rx,UART_Tx,UART_Interrupt,GPO1[31:0],GPI1[31:0],GPI1_Interrupt,INTC_IRQ" */;
  input Clk;
  input Reset;
  input UART_Rx;
  output UART_Tx;
  output UART_Interrupt;
  output [31:0]GPO1;
  input [31:0]GPI1;
  output GPI1_Interrupt;
  output INTC_IRQ;
endmodule
