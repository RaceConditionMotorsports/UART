//////////////////////////////////////////////////////////////////////////////////
// Company: RaceConditionMotorsports
// Engineer: Rufus
// 
// Create Date: 12/05/2026 08:49:00 PM
// Design Name: 
// Module Name: ring_buffer
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module ring_buffer
  #(  
      parameter int               WIDTH  = 8,
      parameter int               LENGTH = 16
  )(   
      input     logic             clk,
      input     logic             rst_n,
      
      input     logic [WIDTH-1:0] in,
      input     logic             wr_en,
      output    logic             full,
      
      output    logic [WIDTH-1:0] out,
      input     logic             rd_en,
      output    logic             empty,

      input     logic             clear
  );

  typedef logic   [WIDTH-1:0]   word_t;
  typedef word_t  [0:LENGTH-1]  buffer_t;

  localparam int PTR_WIDTH = $clog2(LENGTH);

  buffer_t                  buffer;
  logic     [PTR_WIDTH-1:0] wr_ptr;
  logic     [PTR_WIDTH-1:0] rd_ptr;
  
  // Allocate one bit more to indicate full buffer
  logic     [PTR_WIDTH:0]   count;

  assign full   = count[PTR_WIDTH];
  assign empty  = (count == '0);
  assign out    = buffer[rd_ptr];

  always_ff @(posedge clk) begin
    if (!rst_n) begin
      wr_ptr  <= '0;
      rd_ptr  <= '0;
      count   <= '0;
    // Identical but separate branch to force clean reset synthesis
    end else if (clear) begin
      wr_ptr  <= '0;
      rd_ptr  <= '0;
      count   <= '0;
    end else begin
      if (wr_en && !full) begin
        buffer[wr_ptr]  <= in;
        wr_ptr          <= wr_ptr + 1'b1;
        count           <= count  + 1'b1;
      end
      if (rd_en && !empty) begin
        rd_ptr          <= rd_ptr + 1'b1;
        count           <= count  - 1'b1;
      end
    end
  end

endmodule


