# Simple Arithmetic Logic Unit (ALU)

This project contains a testbench and test module for verifying the functionality of a 4-bit Arithmetic Logic Unit (ALU). The ALU is a fundamental component in digital systems, capable of performing a variety of arithmetic and logical operations.

#Testbench Overview
The testbench (alu_tb.sv) is responsible for:

Stimulus Generation: Providing the ALU with different input combinations to test its behavior.
Expected Values: Defining the expected output for each set of inputs.
Result Verification: Comparing the ALU's output with the expected values and logging any discrepancies.

#Test Module Overview
The test module (alu.sv) includes:

ALU Design: The actual implementation of the ALU, capable of performing operations such as addition, subtraction, AND, OR, shift left, and shift right.
Operation Selection: Selecting the operation to be performed based on control signals.
Output Signals: Generating the result of the operation along with flags for carry, zero, negative, and overflow conditions.

Key Features
Directed Tests: Specific test cases for each ALU operation to ensure correct functionality.
Corner Cases: Tests for edge cases such as overflow, borrow, and operations with maximal values.
Randomized Tests: Random input generation to test the ALU under various conditions.
Result Logging: Detailed logging of test results for analysis and debugging.
