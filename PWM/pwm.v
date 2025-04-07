module pwm_configurable (
    input wire clk,           // System Clock
    input wire rst,           // Reset
    input wire [7:0] duty,    // Duty Cycle (0-255)
    input wire [15:0] prescaler, // Prescaler for frequency control
    output reg pwm_out        // PWM Output
);

    reg [15:0] counter;  // 16-bit counter for frequency division
    reg [7:0] pwm_counter; // 8-bit counter for PWM

    always @(posedge clk or posedge rst) begin
        if (rst)
            counter <= 0;
        else if (counter < prescaler)
            counter <= counter + 1;
        else begin
            counter <= 0;
            pwm_counter <= pwm_counter + 1;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst)
            pwm_out <= 0;
        else
            pwm_out <= (pwm_counter < duty) ? 1 : 0;
    end
endmodule
