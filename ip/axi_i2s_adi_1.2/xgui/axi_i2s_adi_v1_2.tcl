# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "C_S00_AXI_BASEADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_S00_AXI_HIGHADDR" -parent ${Page_0}
  ipgui::add_param $IPINST -name "C_LRCLK_POL" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_BCLK_POL" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_DMA_TYPE" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_HAS_TX" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "C_HAS_RX" -parent ${Page_0} -widget comboBox


}

proc update_PARAM_VALUE.C_BCLK_POL { PARAM_VALUE.C_BCLK_POL } {
	# Procedure called to update C_BCLK_POL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_BCLK_POL { PARAM_VALUE.C_BCLK_POL } {
	# Procedure called to validate C_BCLK_POL
	return true
}

proc update_PARAM_VALUE.C_DMA_TYPE { PARAM_VALUE.C_DMA_TYPE } {
	# Procedure called to update C_DMA_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_DMA_TYPE { PARAM_VALUE.C_DMA_TYPE } {
	# Procedure called to validate C_DMA_TYPE
	return true
}

proc update_PARAM_VALUE.C_HAS_RX { PARAM_VALUE.C_HAS_RX } {
	# Procedure called to update C_HAS_RX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_HAS_RX { PARAM_VALUE.C_HAS_RX } {
	# Procedure called to validate C_HAS_RX
	return true
}

proc update_PARAM_VALUE.C_HAS_TX { PARAM_VALUE.C_HAS_TX } {
	# Procedure called to update C_HAS_TX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_HAS_TX { PARAM_VALUE.C_HAS_TX } {
	# Procedure called to validate C_HAS_TX
	return true
}

proc update_PARAM_VALUE.C_LRCLK_POL { PARAM_VALUE.C_LRCLK_POL } {
	# Procedure called to update C_LRCLK_POL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_LRCLK_POL { PARAM_VALUE.C_LRCLK_POL } {
	# Procedure called to validate C_LRCLK_POL
	return true
}

proc update_PARAM_VALUE.M_I2S_BOARD_INTERFACE { PARAM_VALUE.M_I2S_BOARD_INTERFACE } {
	# Procedure called to update M_I2S_BOARD_INTERFACE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.M_I2S_BOARD_INTERFACE { PARAM_VALUE.M_I2S_BOARD_INTERFACE } {
	# Procedure called to validate M_I2S_BOARD_INTERFACE
	return true
}

proc update_PARAM_VALUE.SDATA_I_BOARD_INTERFACE { PARAM_VALUE.SDATA_I_BOARD_INTERFACE } {
	# Procedure called to update SDATA_I_BOARD_INTERFACE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SDATA_I_BOARD_INTERFACE { PARAM_VALUE.SDATA_I_BOARD_INTERFACE } {
	# Procedure called to validate SDATA_I_BOARD_INTERFACE
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to update C_S00_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_BASEADDR { PARAM_VALUE.C_S00_AXI_BASEADDR } {
	# Procedure called to validate C_S00_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to update C_S00_AXI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S00_AXI_HIGHADDR { PARAM_VALUE.C_S00_AXI_HIGHADDR } {
	# Procedure called to validate C_S00_AXI_HIGHADDR
	return true
}


proc update_MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "C_S00_AXI_DATA_WIDTH". Setting updated value from the model parameter.
set_property value 32 ${MODELPARAM_VALUE.C_S00_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "C_S00_AXI_ADDR_WIDTH". Setting updated value from the model parameter.
set_property value 6 ${MODELPARAM_VALUE.C_S00_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_SLOT_WIDTH { MODELPARAM_VALUE.C_SLOT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "C_SLOT_WIDTH". Setting updated value from the model parameter.
set_property value 24 ${MODELPARAM_VALUE.C_SLOT_WIDTH}
}

proc update_MODELPARAM_VALUE.C_LRCLK_POL { MODELPARAM_VALUE.C_LRCLK_POL PARAM_VALUE.C_LRCLK_POL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_LRCLK_POL}] ${MODELPARAM_VALUE.C_LRCLK_POL}
}

proc update_MODELPARAM_VALUE.C_BCLK_POL { MODELPARAM_VALUE.C_BCLK_POL PARAM_VALUE.C_BCLK_POL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_BCLK_POL}] ${MODELPARAM_VALUE.C_BCLK_POL}
}

proc update_MODELPARAM_VALUE.C_DMA_TYPE { MODELPARAM_VALUE.C_DMA_TYPE PARAM_VALUE.C_DMA_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_DMA_TYPE}] ${MODELPARAM_VALUE.C_DMA_TYPE}
}

proc update_MODELPARAM_VALUE.C_NUM_CH { MODELPARAM_VALUE.C_NUM_CH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "C_NUM_CH". Setting updated value from the model parameter.
set_property value 1 ${MODELPARAM_VALUE.C_NUM_CH}
}

proc update_MODELPARAM_VALUE.C_HAS_TX { MODELPARAM_VALUE.C_HAS_TX PARAM_VALUE.C_HAS_TX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_HAS_TX}] ${MODELPARAM_VALUE.C_HAS_TX}
}

proc update_MODELPARAM_VALUE.C_HAS_RX { MODELPARAM_VALUE.C_HAS_RX PARAM_VALUE.C_HAS_RX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_HAS_RX}] ${MODELPARAM_VALUE.C_HAS_RX}
}

