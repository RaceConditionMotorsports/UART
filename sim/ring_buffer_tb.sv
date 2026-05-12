module ring_buffer_tb;

  parameter WIDTH = 8, LENGTH = 4;
  logic clk, rst_n, wr_en, rd_en, clear, full, empty;
  logic [WIDTH-1:0] in, out;

  ring_buffer #(WIDTH, LENGTH) dut (.*);

  // --- Input assertions for integration tests ---
  property p_no_overflow;
    @(posedge clk) disable iff (!rst_n || clear)
    (dut.wr_en && dut.full) |-> !($realtime > 0)
  endproperty
  assert property (p_no_overflow) else $error("TIME:%t | ERROR: FIFO OVERFLOW", $realtime);

  property p_no_underflow;
    @(posedge clk) disable iff (!rst_n || clear)
    (dut.rd_en && dut.empty) |-> !($realtime > 0)
  endproperty
  assert property (p_no_underflow) else $error("TIME:%t | ERROR: FIFO UNDERFLOW", $realtime);

  // --- Behavioural test ---
  property p_empty_signal;
    @(posedge clk) disable iff (!rst_n || clear)
    (dut.count == 0) |-> dut.empty;
  endproperty
  assert property (p_empty_signal) else $error("Logic Error: Empty flag not set on count 0");

  property p_count_increment;
    @(posedge clk) disable iff (!rst_n || clear)
    // SV magic mothafucka
    (wr_en && !dut.full && !rd_en) |=> (dut.count == $past(dut.count) + 1);
  endproperty
  assert property (p_count_increment) else $error("Logic Error: Counter not incremented on write");

  property p_simultaneous_rw;
    @(posedge clk) disable iff (!rst_n || clear)
    (wr_en && !dut.full && rd_en && !dut.empty) |=> (dut.count == $past(dut.count));
  endproperty
  assert property (p_simultaneous_rw) else $error("Logic error: Counter incremented during Simultaneous read/write");

  property p_full_signal;
    @(posedge clk) disable iff (!rst_n || clear)
    (dut.count == LENGTH) |-> dut.full;
  endproperty
  assert property (p_full_signal) else $error("Logic Error: Full flag not set on count %0d", LENGTH);

  // --- Stimuli ---
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
