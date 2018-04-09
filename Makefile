# Project setup
project = demo
# 1k,8k
device  = 8k


sources = demo.v


# Internal variables
BUILD     = ./bin
ifeq (8k,$(device))
	pcffile = ice40hx8k-bb.pcf
else
	pcffile = icestick.pcf
endif


all: burn

$(BUILD)/$(project).blif: $(sources) Makefile
	mkdir -p $(BUILD)
	# Synthesize using Yosys
	yosys -p "synth_ice40 -blif $@" $(sources)


%.asc: %.blif $(pcffile) Makefile
	# Place and route using arachne
	arachne-pnr \
		-d $(device) \
		-p $(pcffile) \
		-o $@ \
		$<

%.bin: %.asc
	# Convert to bitstream using IcePack
	icepack $< $@


burn: $(BUILD)/$(project).bin
	sudo iceprog $(ICEPROG_ARGS) $<

clean:
	rm -rf $(BUILD)

