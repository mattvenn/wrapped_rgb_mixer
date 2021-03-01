# User config
set ::env(DESIGN_NAME) wrapper

# Change if needed
set ::env(VERILOG_FILES) "$::env(DESIGN_DIR)/wrapper.v \
    $::env(DESIGN_DIR)/rgb_mixer/src/rgb_mixer.v \
    $::env(DESIGN_DIR)/rgb_mixer/src/pwm.v \
    $::env(DESIGN_DIR)/rgb_mixer/src/debounce.v \
    $::env(DESIGN_DIR)/rgb_mixer/src/encoder.v"

set ::env(PL_TARGET_DENSITY) 0.4
set ::env(DIE_AREA) "0 0 300 300"
set ::env(FP_SIZING) absolute

set ::env(SYNTH_DEFINES) "MPRJ_IO_PADS=38"

# Fill this
set ::env(CLOCK_PERIOD) "10"
set ::env(CLOCK_PORT) "wb_clk_i"

set ::env(DESIGN_IS_CORE) 0
set ::env(GLB_RT_MAXLAYER) 5


set filename $::env(DESIGN_DIR)/$::env(PDK)_$::env(STD_CELL_LIBRARY)_config.tcl
if { [file exists $filename] == 1} {
	source $filename
}

