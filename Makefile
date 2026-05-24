MAKEFLAGS += --no-print-directory

# make run TOP=<name> caso seja outro nome
TOP ?= testbench

VLOG := $(wildcard rtl/*.sv  tb/*.sv )
VHDL := $(wildcard rtl/*.vhd tb/*.vhd)
INC  := ../rtl
OK   := $(patsubst %, build/%.ok, $(VLOG) $(VHDL) )

run: build/simv
	cd build && ./simv -quiet -no_save

build:
	mkdir -p build/rtl
	mkdir -p build/tb

# 'build' para garantir a criação das pastas antes do simv
build/simv: $(OK) | build
	cd build && vcs -full64 -quiet -debug_acc+all $(TOP)

# adicionado o +incdir+$(INC)
build/%.sv.ok: %.sv | build
	cd build && vlogan -full64 -q -sverilog +incdir+$(INC) ../$<
	@touch $@
        
build/%.vhd.ok: %.vhd | build
	cd build && vhdlan -full64 -q ../$<
	@touch $@

clean:
	rm -rf build
