# SPDX-FileCopyrightText: 2020 Efabless Corporation
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0

FIRMWARE_PATH = ../..
VERILOG_PATH = ../../../..
RTL_PATH = $(VERILOG_PATH)/rtl
IP_PATH = ../../../../ip
BEHAVIOURAL_MODELS = ../../ 
PROJECT_DIR = $(RTL_PATH)/wrapped_rgb_mixer/
PROJECT_FILES = $(addprefix $(PROJECT_DIR), \
	wrapper.v \
	rgb_mixer/src/rgb_mixer.v \
	rgb_mixer/src/encoder.v \
	rgb_mixer/src/pwm.v \
	rgb_mixer/src/debounce.v \
)

GCC_PATH?=/ef/apps/bin
GCC_PREFIX?=riscv32-unknown-elf
PDK_PATH?=/ef/tech/SW/sky130A

SIM?=RTL


.SUFFIXES:

PATTERN = rgb_mixer

all:  coco_test

hex:  ${PATTERN:=.hex}

coco_test: ${PATTERN}.hex
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -o sim_build/sim.vvp -s rgb_mixer_tb rgb_mixer_tb.v -DSIM -DFUNCTIONAL \
    -I $(BEHAVIOURAL_MODELS) -I $(PDK_PATH) -I $(IP_PATH) -I $(RTL_PATH) $(PROJECT_FILES)
	
	MODULE=test_rgb_mixer vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp

%.vvp: %_tb.v %.hex
ifeq ($(SIM),RTL)
	iverilog -DFUNCTIONAL -DSIM -I $(BEHAVIOURAL_MODELS) \
	-I $(PDK_PATH) -I $(IP_PATH) -I $(RTL_PATH) \
	$< -o $@
else
	iverilog -DFUNCTIONAL -DSIM -DGL -I $(BEHAVIOURAL_MODELS) \
	-I $(PDK_PATH) -I $(IP_PATH) -I $(RTL_PATH) \
	$< -o $@
endif

%.vcd: %.vvp
	vvp $<

%.elf: %.c $(FIRMWARE_PATH)/sections.lds $(FIRMWARE_PATH)/start.s
	${GCC_PATH}/${GCC_PREFIX}-gcc -march=rv32imc -mabi=ilp32 -Wl,-Bstatic,-T,$(FIRMWARE_PATH)/sections.lds,--strip-debug -ffreestanding -nostdlib -o $@ $(FIRMWARE_PATH)/start.s $<

%.hex: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O verilog $< $@ 
	# to fix flash base address
	sed -i 's/@10000000/@00000000/g' $@

%.bin: %.elf
	${GCC_PATH}/${GCC_PREFIX}-objcopy -O binary $< /dev/stdout | tail -c +1048577 > $@

# ---- Clean ----

clean:
	rm -f *.elf *.hex *.bin *.vvp *.vcd *.log

.PHONY: clean hex all
.SECONDARY: rgb_mixer.vcd