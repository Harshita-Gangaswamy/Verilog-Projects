
module uart_top (
    input wire clk,
    input wire rst,
    input wire tx_start,
    input wire [7:0] tx_data,
    input wire rx,
    output wire tx,
    output wire [7:0] rx_data,
    output wire tx_done,
    output wire data_valid
);
    
    uart_tx transmitter (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .data(tx_data),
        .tx(tx),
        .tx_done(tx_done)
    );

    uart_rx receiver (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .data(rx_data),
        .data_valid(data_valid)
    );

endmodule
