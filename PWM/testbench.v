module tb_pwm_configurable;
    reg clk = 0;
    reg rst;
    reg [7:0] duty;
    reg [15:0] prescaler;
    wire pwm_out;

    // Instantiate the PWM module
    pwm_configurable dut (
        .clk(clk),
        .rst(rst),
        .duty(duty),
        .prescaler(prescaler),
        .pwm_out(pwm_out)
    );

    // Clock generation (10ns period → 100 MHz clock)
    always #5 clk = ~clk;

    initial begin
        // Initialize signals
        rst = 1;
        duty = 0;
        prescaler = 500; // Default prescaler

        #20 rst = 0; // Release reset
        
        // Test different duty cycles at the same frequency
        #50 duty = 64;   // 25% Duty Cycle
        #50 duty = 128;  // 50% Duty Cycle
        #50 duty = 192;  // 75% Duty Cycle
        #50 duty = 255;  // 100% Duty Cycle

        // Change frequency using prescaler
        #50 prescaler = 1000; // Reduce frequency
        #50 prescaler = 250;  // Increase frequency

        #100;
        $stop;
    end
endmodule
