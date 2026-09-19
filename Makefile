RTL = rtl/and_gate.v
TB  = tb/and_gate_tb.v
SIM = sim/and_gate_sim

compile:
	iverilog -g2012 -o $(SIM) $(RTL) $(TB)

run: compile
	vvp $(SIM)

wave: run
	gtkwave sim/and_gate.vcd

synth:
	yosys -p "read_verilog $(RTL); synth -top and_gate; stat"

clean:
	rm -f $(SIM) sim/*.vcd

.PHONY: compile run wave synth clean