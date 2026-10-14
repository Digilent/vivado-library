# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "VID_IN_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "KGREENDEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "KBLUEDEPTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "KREDDEPTH" -parent ${Page_0}

  ipgui::add_param $IPINST -name "Component_Name"

}

proc update_PARAM_VALUE.KBLUEDEPTH { PARAM_VALUE.KBLUEDEPTH } {
	# Procedure called to update KBLUEDEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.KBLUEDEPTH { PARAM_VALUE.KBLUEDEPTH } {
	# Procedure called to validate KBLUEDEPTH
	return true
}

proc update_PARAM_VALUE.KGREENDEPTH { PARAM_VALUE.KGREENDEPTH } {
	# Procedure called to update KGREENDEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.KGREENDEPTH { PARAM_VALUE.KGREENDEPTH } {
	# Procedure called to validate KGREENDEPTH
	return true
}

proc update_PARAM_VALUE.KREDDEPTH { PARAM_VALUE.KREDDEPTH } {
	# Procedure called to update KREDDEPTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.KREDDEPTH { PARAM_VALUE.KREDDEPTH } {
	# Procedure called to validate KREDDEPTH
	return true
}

proc update_PARAM_VALUE.VGA_OUT_BOARD_INTERFACE { PARAM_VALUE.VGA_OUT_BOARD_INTERFACE } {
	# Procedure called to update VGA_OUT_BOARD_INTERFACE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VGA_OUT_BOARD_INTERFACE { PARAM_VALUE.VGA_OUT_BOARD_INTERFACE } {
	# Procedure called to validate VGA_OUT_BOARD_INTERFACE
	return true
}

proc update_PARAM_VALUE.VID_IN_DATA_WIDTH { PARAM_VALUE.VID_IN_DATA_WIDTH } {
	# Procedure called to update VID_IN_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VID_IN_DATA_WIDTH { PARAM_VALUE.VID_IN_DATA_WIDTH } {
	# Procedure called to validate VID_IN_DATA_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.VID_IN_DATA_WIDTH { MODELPARAM_VALUE.VID_IN_DATA_WIDTH PARAM_VALUE.VID_IN_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VID_IN_DATA_WIDTH}] ${MODELPARAM_VALUE.VID_IN_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.KREDDEPTH { MODELPARAM_VALUE.KREDDEPTH PARAM_VALUE.KREDDEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KREDDEPTH}] ${MODELPARAM_VALUE.KREDDEPTH}
}

proc update_MODELPARAM_VALUE.KGREENDEPTH { MODELPARAM_VALUE.KGREENDEPTH PARAM_VALUE.KGREENDEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KGREENDEPTH}] ${MODELPARAM_VALUE.KGREENDEPTH}
}

proc update_MODELPARAM_VALUE.KBLUEDEPTH { MODELPARAM_VALUE.KBLUEDEPTH PARAM_VALUE.KBLUEDEPTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.KBLUEDEPTH}] ${MODELPARAM_VALUE.KBLUEDEPTH}
}

