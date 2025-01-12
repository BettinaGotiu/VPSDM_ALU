`timescale 1ns / 1ps

module alu_monitor(input logic [3:0] a, b, 
                   input logic [2:0] op, 
                   input logic [3:0] result, 
                   input logic carry, zero, negative, overflow, 
                   input logic [3:0] expected_result, 
                   input logic expected_carry, expected_zero, expected_negative, expected_overflow);

    always @(a, b, op, result, carry, zero, negative, overflow) begin
        $display("Time: %0t, Inputs - A: %b, B: %b, OP: %b, Outputs - Result: %b, Carry: %b, Zero: %b, Negative: %b, Overflow: %b", 
                 $time, a, b, op, result, carry, zero, negative, overflow);
        $display("Expected Outputs - Result: %b, Carry: %b, Zero: %b, Negative: %b, Overflow: %b", 
                 expected_result, expected_carry, expected_zero, expected_negative, expected_overflow);
    end
endmodule