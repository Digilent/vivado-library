
# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/ZmodSDRController_v1_0.gtcl]

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  ipgui::add_param $IPINST -name "kZmodID" -widget comboBox
  #Adding Page
  set General [ipgui::add_page $IPINST -name "General"]
  ipgui::add_param $IPINST -name "kCDCEFreqSel" -parent ${General} -widget comboBox
  ipgui::add_param $IPINST -name "kADC_Width" -parent ${General}
  ipgui::add_param $IPINST -name "kExtCmdInterfaceEn" -parent ${General}

  #Adding Page
  set Clock_Generator [ipgui::add_page $IPINST -name "Clock Generator"]
  ipgui::add_param $IPINST -name "kCGI2C_Addr" -parent ${Clock_Generator} -widget comboBox
  ipgui::add_param $IPINST -name "kRefSel" -parent ${Clock_Generator} -widget comboBox
  ipgui::add_param $IPINST -name "kHwSwCtrlSel" -parent ${Clock_Generator} -widget comboBox


}

proc update_PARAM_VALUE.kADC_Width { PARAM_VALUE.kADC_Width PARAM_VALUE.kZmodID } {
	# Procedure called to update kADC_Width when any of the dependent parameters in the arguments change
	
	set kADC_Width ${PARAM_VALUE.kADC_Width}
	set kZmodID ${PARAM_VALUE.kZmodID}
	set values(kZmodID) [get_property value $kZmodID]
	set_property value [gen_USERPARAMETER_kADC_Width_VALUE $values(kZmodID)] $kADC_Width
}

proc validate_PARAM_VALUE.kADC_Width { PARAM_VALUE.kADC_Width } {
	# Procedure called to validate kADC_Width
	return true
}

proc update_PARAM_VALUE.kHwSwCtrlSel { PARAM_VALUE.kHwSwCtrlSel PARAM_VALUE.kCGI2C_Addr } {
	# Procedure called to update kHwSwCtrlSel when any of the dependent parameters in the arguments change
	
	set kHwSwCtrlSel ${PARAM_VALUE.kHwSwCtrlSel}
	set kCGI2C_Addr ${PARAM_VALUE.kCGI2C_Addr}
	set values(kCGI2C_Addr) [get_property value $kCGI2C_Addr]
	if { [gen_USERPARAMETER_kHwSwCtrlSel_ENABLEMENT $values(kCGI2C_Addr)] } {
		set_property enabled true $kHwSwCtrlSel
	} else {
		set_property enabled false $kHwSwCtrlSel
	}
}

proc validate_PARAM_VALUE.kHwSwCtrlSel { PARAM_VALUE.kHwSwCtrlSel } {
	# Procedure called to validate kHwSwCtrlSel
	return true
}

proc update_PARAM_VALUE.kRefSel { PARAM_VALUE.kRefSel PARAM_VALUE.kCGI2C_Addr } {
	# Procedure called to update kRefSel when any of the dependent parameters in the arguments change
	
	set kRefSel ${PARAM_VALUE.kRefSel}
	set kCGI2C_Addr ${PARAM_VALUE.kCGI2C_Addr}
	set values(kCGI2C_Addr) [get_property value $kCGI2C_Addr]
	if { [gen_USERPARAMETER_kRefSel_ENABLEMENT $values(kCGI2C_Addr)] } {
		set_property enabled true $kRefSel
	} else {
		set_property enabled false $kRefSel
	}
}

proc validate_PARAM_VALUE.kRefSel { PARAM_VALUE.kRefSel } {
	# Procedure called to validate kRefSel
	return true
}

proc update_PARAM_VALUE.kADC_ClkDiv { PARAM_VALUE.kADC_ClkDiv } {
	# Procedure called to update kADC_ClkDiv when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kADC_ClkDiv { PARAM_VALUE.kADC_ClkDiv } {
	# Procedure called to validate kADC_ClkDiv
	return true
}

proc update_PARAM_VALUE.kCDCEFreqSel { PARAM_VALUE.kCDCEFreqSel } {
	# Procedure called to update kCDCEFreqSel when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kCDCEFreqSel { PARAM_VALUE.kCDCEFreqSel } {
	# Procedure called to validate kCDCEFreqSel
	return true
}

proc update_PARAM_VALUE.kCGI2C_Addr { PARAM_VALUE.kCGI2C_Addr } {
	# Procedure called to update kCGI2C_Addr when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kCGI2C_Addr { PARAM_VALUE.kCGI2C_Addr } {
	# Procedure called to validate kCGI2C_Addr
	return true
}

proc update_PARAM_VALUE.kCG_SimulationCmdTotal { PARAM_VALUE.kCG_SimulationCmdTotal } {
	# Procedure called to update kCG_SimulationCmdTotal when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kCG_SimulationCmdTotal { PARAM_VALUE.kCG_SimulationCmdTotal } {
	# Procedure called to validate kCG_SimulationCmdTotal
	return true
}

proc update_PARAM_VALUE.kCG_SimulationConfig { PARAM_VALUE.kCG_SimulationConfig } {
	# Procedure called to update kCG_SimulationConfig when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kCG_SimulationConfig { PARAM_VALUE.kCG_SimulationConfig } {
	# Procedure called to validate kCG_SimulationConfig
	return true
}

proc update_PARAM_VALUE.kExtCmdInterfaceEn { PARAM_VALUE.kExtCmdInterfaceEn } {
	# Procedure called to update kExtCmdInterfaceEn when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kExtCmdInterfaceEn { PARAM_VALUE.kExtCmdInterfaceEn } {
	# Procedure called to validate kExtCmdInterfaceEn
	return true
}

proc update_PARAM_VALUE.kZmodID { PARAM_VALUE.kZmodID } {
	# Procedure called to update kZmodID when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.kZmodID { PARAM_VALUE.kZmodID } {
	# Procedure called to validate kZmodID
	return true
}


proc update_MODELPARAM_VALUE.kZmodID { MODELPARAM_VALUE.kZmodID PARAM_VALUE.kZmodID } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kZmodID}] ${MODELPARAM_VALUE.kZmodID}
}

proc update_MODELPARAM_VALUE.kADC_ClkDiv { MODELPARAM_VALUE.kADC_ClkDiv PARAM_VALUE.kADC_ClkDiv } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kADC_ClkDiv}] ${MODELPARAM_VALUE.kADC_ClkDiv}
}

proc update_MODELPARAM_VALUE.kADC_Width { MODELPARAM_VALUE.kADC_Width PARAM_VALUE.kADC_Width } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kADC_Width}] ${MODELPARAM_VALUE.kADC_Width}
}

proc update_MODELPARAM_VALUE.kExtCmdInterfaceEn { MODELPARAM_VALUE.kExtCmdInterfaceEn PARAM_VALUE.kExtCmdInterfaceEn } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kExtCmdInterfaceEn}] ${MODELPARAM_VALUE.kExtCmdInterfaceEn}
}

proc update_MODELPARAM_VALUE.kRefSel { MODELPARAM_VALUE.kRefSel PARAM_VALUE.kRefSel } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kRefSel}] ${MODELPARAM_VALUE.kRefSel}
}

proc update_MODELPARAM_VALUE.kHwSwCtrlSel { MODELPARAM_VALUE.kHwSwCtrlSel PARAM_VALUE.kHwSwCtrlSel } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kHwSwCtrlSel}] ${MODELPARAM_VALUE.kHwSwCtrlSel}
}

proc update_MODELPARAM_VALUE.kCDCEFreqSel { MODELPARAM_VALUE.kCDCEFreqSel PARAM_VALUE.kCDCEFreqSel } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kCDCEFreqSel}] ${MODELPARAM_VALUE.kCDCEFreqSel}
}

proc update_MODELPARAM_VALUE.kCGI2C_Addr { MODELPARAM_VALUE.kCGI2C_Addr PARAM_VALUE.kCGI2C_Addr } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kCGI2C_Addr}] ${MODELPARAM_VALUE.kCGI2C_Addr}
}

proc update_MODELPARAM_VALUE.kCG_SimulationCmdTotal { MODELPARAM_VALUE.kCG_SimulationCmdTotal PARAM_VALUE.kCG_SimulationCmdTotal } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kCG_SimulationCmdTotal}] ${MODELPARAM_VALUE.kCG_SimulationCmdTotal}
}

proc update_MODELPARAM_VALUE.kCG_SimulationConfig { MODELPARAM_VALUE.kCG_SimulationConfig PARAM_VALUE.kCG_SimulationConfig } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.kCG_SimulationConfig}] ${MODELPARAM_VALUE.kCG_SimulationConfig}
}

