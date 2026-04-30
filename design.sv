module uart_tx (
    input  wire       clk,        // system clock
    input  wire       rst,        // active high reset
    input  wire       tx_start,   // start transmission
    input  wire [7:0] tx_data,    // 8-bit data to send
    output reg        tx,         // serial output line
    output reg        tx_busy     // high while transmitting
);

    // 50MHz clock, 9600 baud
    // clk_per_bit = 50,000,000 / 9600 = 5208
    parameter CLK_PER_BIT = 5208;

    // state machine states
    parameter IDLE  = 2'b00;
    parameter START = 2'b01;
    parameter DATA  = 2'b10;
    parameter STOP  = 2'b11;

    reg [1:0]  state;
    reg [12:0] clk_count;
    reg [2:0]  bit_index;
    reg [7:0]  tx_shift_reg;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state     <= IDLE;
            tx        <= 1'b1;   // idle line is HIGH
            tx_busy   <= 1'b0;
            clk_count <= 0;
            bit_index <= 0;
        end else begin
            case (state)

                IDLE: begin
                    tx      <= 1'b1;
                    tx_busy <= 1'b0;
                    if (tx_start) begin
                        tx_shift_reg <= tx_data;
                        state        <= START;
                        tx_busy      <= 1'b1;
                        clk_count    <= 0;
                    end
                end

                START: begin
                    tx <= 1'b0;  // start bit is LOW
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        bit_index <= 0;
                        state     <= DATA;
                    end
                end

                DATA: begin
                    tx <= tx_shift_reg[bit_index];
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        if (bit_index < 7) begin
                            bit_index <= bit_index + 1;
                        end else begin
                            state <= STOP;
                        end
                    end
                end

                STOP: begin
                    tx <= 1'b1;  // stop bit is HIGH
                    if (clk_count < CLK_PER_BIT - 1) begin
                        clk_count <= clk_count + 1;
                    end else begin
                        clk_count <= 0;
                        state     <= IDLE;
                        tx_busy   <= 1'b0;
                    end
                end

            endcase
        end
    end

endmodule
