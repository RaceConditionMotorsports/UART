module ring_buffer_tb;

  parameter WIDTH = 8, LENGTH = 4;
  logic clk, rst_n, wr_en, rd_en, clear, full, empty;
  logic [WIDTH-1:0] in, out;

  ring_buffer #(WIDTH, LENGTH) dut (.*);
  always #5 clk = ~clk;

  initial begin
    clk = 0; rst_n = 0; wr_en = 0; rd_en = 0; clear = 0; in = 0;
    #20 rst_n = 1;

    // Write until full
    repeat (LENGTH) begin
      @(posedge clk);
      if (!full) begin
        wr_en = 1;
        in = in + 1;
      end
    end
    @(posedge clk)
    wr_en = 0;

    // Read until empty
    repeat (LENGTH) begin
      @(posedge clk);
      if (!empty) begin
        rd_en = 1;
      end
    end
    @(posedge clk)
    rd_en = 0;

    // Simultaneous read/write
    repeat (LENGTH) begin
      @(posedge clk);
      rd_en = 1;
      wr_en = 1;
      in = in + 1;
    end
    @(posedge clk);
    rd_en = 0;
    wr_en = 0;

    #10
    clear = 1;
    #10
    clear = 0;

    #50
    $finish;
  end

endmodule
