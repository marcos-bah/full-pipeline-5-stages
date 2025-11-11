# ======= Configurações =======
TOP = single_cycle_cpu_tb
SRC_DIR = src/modules
SRC_TOP_DIR = src/top/
BUILD_DIR = build
VCD = $(BUILD_DIR)/$(TOP).vcd
OUT = $(BUILD_DIR)/$(TOP).out

# ======= Lista de arquivos =======
SRC := $(shell find $(SRC_DIR) -type f -name '*.v' -print | tr '\n' ' ')

# ======= Comandos =======
all: run

compile:
	mkdir -p $(BUILD_DIR)
	iverilog -o $(OUT) -g2012 $(SRC) $(SRC_TOP_DIR)/$(TOP).v

run: compile
	vvp $(OUT)

wave:
	gtkwave $(VCD)

clean:
	rm -rf $(BUILD_DIR)

.PHONY: all compile run wave clean
