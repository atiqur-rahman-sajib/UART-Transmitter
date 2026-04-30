`timescale 1ns/1ns

module tb_uart_tx;

    // inputs
    reg        clk;
    reg        rst;
    reg        tx_start;
    reg [7:0]  tx_data;

    // outputs
    wire       tx;
    wire       tx_busy;

    // instantiate the UART TX design
    uart_tx #(.CLK_PER_BIT(5208)) uut (
        .clk      (clk),
        .rst      (rst),
        .tx_start (tx_start),
        .tx_data  (tx_data),
        .tx       (tx),
        .tx_busy  (tx_busy)
    );

    // generate 50MHz clock (period = 20ns)
    initial clk = 0;
    always #10 clk = ~clk;

    // main test
    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, tb_uart_tx);

        // reset
        rst      = 1;
        tx_start = 0;
        tx_data  = 8'h00;
        #100;
        rst = 0;
        #100;

        // Test 1: send letter 'A' (0x41)
        $display("Test 1: Sending 0x41 (A)");
        tx_data  = 8'h41;
        tx_start = 1;
        #20;
        tx_start = 0;

        // wait for transmission to finish
        wait(tx_busy == 0);
        $display("Test 1 PASSED: Transmission complete");
        #1000;

        // Test 2: send 0xFF
        $display("Test 2: Sending 0xFF");
        tx_data  = 8'hFF;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait(tx_busy == 0);
        $display("Test 2 PASSED: Transmission complete");
        #1000;

        // Test 3: send 0x00
        $display("Test 3: Sending 0x00");
        tx_data  = 8'h00;
        tx_start = 1;
        #20;
        tx_start = 0;

        wait(tx_busy == 0);
        $display("Test 3 PASSED: Transmission complete");
        #1000;

        $display("All tests PASSED!");
        $finish;
    end

endmodule
