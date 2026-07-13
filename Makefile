BUILD_DIR = build
TB_DIR    = tb

TEST ?= alu

VCS_FLAGS = -sverilog \
            -notice \
            -q \
            -timescale=1ns/1ps \
            -Mdir=csrc \
            -o simv \
            +incdir+../rtl

all: create_dir compile run

create_dir:
	@mkdir -p $(BUILD_DIR)

compile:
	@if [ ! -f "$(TB_DIR)/$(TEST).f" ]; then \
		echo "ERROR filelist '$(TB_DIR)/$(TEST).f' does not exist!"; \
		exit 1; \
	fi
	@echo "================================================================="
	@echo " Compiling filelist: $(TB_DIR)/$(TEST).f"
	@echo "================================================================="
	cd $(BUILD_DIR) && vcs $(VCS_FLAGS) -f ../$(TB_DIR)/$(TEST).f

run:
	@echo "================================================================="
	@echo " Running sim..."
	@echo "================================================================="
	@./$(BUILD_DIR)/simv

clean:
	rm -rf $(BUILD_DIR) ucli.key vc_hdrs.h

.PHONY: all create_dir compile run clean
