
module tb_uart;
    reg clk = 0;
    reg rst;
    reg tx_start;
    reg [7:0] tx_data;
    wire tx, tx_done;
    wire [7:0] rx_data;
    wire data_valid;
    
    uart_top uut (
        .clk(clk),
        .rst(rst),
        .tx_start(tx_start),
        .tx_data(tx_data),
        .rx(tx),
        .tx(tx),
        .rx_data(rx_data),
        .tx_done(tx_done),
        .data_valid(data_valid)
    );

    always #10 clk = ~clk; // 50MHz clock
    
    initial begin
        rst = 1;
        tx_start = 0;
        tx_data = 8'h55;
        #50 rst = 0;
        
        #100 tx_start = 1; // Send data
        #20 tx_start = 0;
        
        wait(tx_done);
        #200;
        
        if (data_valid)
            $display("Received Data: %h", rx_data);
        
        $stop;
    end
endmodule
