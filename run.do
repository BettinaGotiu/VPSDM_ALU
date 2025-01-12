# Compilam fisierele pentru modulul 4-bit ALU design, testbench si monitor
vlog alu.sv
vlog alu_monitor.sv
vlog alu_tb.sv

# Simulam testbench-ul
vsim +access+r alu_tb

# Rulam simularea
run -all

# Iesim din simulator
exit