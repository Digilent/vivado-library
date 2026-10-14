# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"

}

proc update_PARAM_VALUE.AXI_LITE_ADDR_WIDTH { PARAM_VALUE.AXI_LITE_ADDR_WIDTH } {
	# Procedure called to update AXI_LITE_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_LITE_ADDR_WIDTH { PARAM_VALUE.AXI_LITE_ADDR_WIDTH } {
	# Procedure called to validate AXI_LITE_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_LITE_DATA_WIDTH { PARAM_VALUE.AXI_LITE_DATA_WIDTH } {
	# Procedure called to update AXI_LITE_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_LITE_DATA_WIDTH { PARAM_VALUE.AXI_LITE_DATA_WIDTH } {
	# Procedure called to validate AXI_LITE_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.M_DPTI_BOARD_INTERFACE { PARAM_VALUE.M_DPTI_BOARD_INTERFACE } {
	# Procedure called to update M_DPTI_BOARD_INTERFACE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_DPTI_BOARD_INTERFACE { PARAM_VALUE.M_DPTI_BOARD_INTERFACE } {
	# Procedure called to validate M_DPTI_BOARD_INTERFACE
	return true
}

proc update_PARAM_VALUE.AXI4_Lite_BASEADDR { PARAM_VALUE.AXI4_Lite_BASEADDR } {
	# Procedure called to update AXI4_Lite_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI4_Lite_BASEADDR { PARAM_VALUE.AXI4_Lite_BASEADDR } {
	# Procedure called to validate AXI4_Lite_BASEADDR
	return true
}

proc update_PARAM_VALUE.AXI4_Lite_HIGHADDR { PARAM_VALUE.AXI4_Lite_HIGHADDR } {
	# Procedure called to update AXI4_Lite_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI4_Lite_HIGHADDR { PARAM_VALUE.AXI4_Lite_HIGHADDR } {
	# Procedure called to validate AXI4_Lite_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_AXI_LITE_DATA_WIDTH { MODELPARAM_VALUE.C_AXI_LITE_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "C_AXI_LITE_DATA_WIDTH". Setting updated value from the model parameter.
set_property value 32 ${MODELPARAM_VALUE.C_AXI_LITE_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_AXI_LITE_ADDR_WIDTH { MODELPARAM_VALUE.C_AXI_LITE_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "C_AXI_LITE_ADDR_WIDTH". Setting updated value from the model parameter.
set_property value 4 ${MODELPARAM_VALUE.C_AXI_LITE_ADDR_WIDTH}
}

