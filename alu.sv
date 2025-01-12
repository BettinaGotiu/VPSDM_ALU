module alu (
    input logic [3:0] a, b,        
    input logic [2:0] op,          
    output logic [3:0] result,     
    output logic carry, zero, negative, overflow
);
  
    localparam ADD = 3'b000,
               SUB = 3'b001,
               AND = 3'b010,
               OR  = 3'b011,
               SHIFT_LEFT = 3'b100,
               SHIFT_RIGHT = 3'b101;

    always_comb begin
        carry = 0;
        overflow = 0;
        case (op)
          ADD: {carry, result} = a + b; 
          SUB: {carry, result} = a - b;
          AND: result = a & b;
          OR:  result = a | b;
          SHIFT_LEFT: result = a << 1;  // Shift cu 1
          SHIFT_RIGHT: result = a >> 1; // Shift cu 1
          default: result = 4'bxxxx; 
        endcase

        zero = (result == 4'b0000);
        negative = (result[3] == 1'b1); 

        if (op == ADD) 
            overflow = (a[3] == b[3]) && (result[3] != a[3]);
        else if (op == SUB)
            overflow = (a[3] != b[3]) && (result[3] != a[3]);
    end
endmodule