package require xilinx::board 1.0
namespace import ::xilinx::board::*

# Loading additional proc with user specified bodies to compute parameter values.
source [file join [file dirname [file dirname [info script]]] gui/pmod_bridge_v1_1.gtcl]

proc get_pmod_vlnv {} {
	return "digilentinc.com:interface:pmod_rtl:1.0"
}

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.BOARD } {
    set c_family ${PROJECT_PARAM.ARCHITECTURE}
    set board ${PROJECT_PARAM.BOARD}
    set Component_Name [ ipgui::add_param $IPINST -parent $IPINST -name Component_Name ]
    ipgui::add_param $IPINST -name "Component_Name"
    #Adding Page
    set Interfaces [ipgui::add_page $IPINST -name "Interfaces"]
    set_property tooltip {Choose input interfaces} ${Interfaces}
    ipgui::add_param $IPINST -name "Top_Row_Interface" -parent ${Interfaces} -widget comboBox
    ipgui::add_param $IPINST -name "Bottom_Row_Interface" -parent ${Interfaces} -widget comboBox
    set Use_Pullups_Top_Row [ipgui::add_param $IPINST -name "Use_Pullups_Top_Row" -parent ${Interfaces}]
    set_property tooltip {Enable Pullup Resistors on Pins 3 & 4} ${Use_Pullups_Top_Row}
    set Use_Pullups_Bottom_Row [ipgui::add_param $IPINST -name "Use_Pullups_Bottom_Row" -parent ${Interfaces}]
    set_property tooltip {Enable Pullup Resistors on Pins 6 & 7} ${Use_Pullups_Bottom_Row}
    add_board_tab $IPINST
}

proc update_PARAM_VALUE.Use_Pullups_Top_Row { PARAM_VALUE.Use_Pullups_Top_Row PARAM_VALUE.Top_Row_Interface } {
	# Procedure called to update Use_Pullups_Top_Row when any of the dependent parameters in the arguments change
	set Use_Pullups_Top_Row ${PARAM_VALUE.Use_Pullups_Top_Row}
	set Top_Row_Interface ${PARAM_VALUE.Top_Row_Interface}
	set values(Top_Row_Interface) [get_property value $Top_Row_Interface]
	if { [gen_USERPARAMETER_Use_Pullups_Top_Row_ENABLEMENT $values(Top_Row_Interface)] } {
		set_property enabled true $Use_Pullups_Top_Row
	} else {
		set_property enabled false $Use_Pullups_Top_Row
	}
}

proc validate_PARAM_VALUE.Use_Pullups_Top_Row { PARAM_VALUE.Use_Pullups_Top_Row } {
	# Procedure called to validate Use_Pullups_Top_Row
	return true
}

proc update_PARAM_VALUE.Use_Pullups_Bottom_Row { PARAM_VALUE.Use_Pullups_Bottom_Row PARAM_VALUE.Bottom_Row_Interface } {
	# Procedure called to update Use_Pullups_Bottom_Row when any of the dependent parameters in the arguments change
	set Use_Pullups_Bottom_Row ${PARAM_VALUE.Use_Pullups_Bottom_Row}
	set Bottom_Row_Interface ${PARAM_VALUE.Bottom_Row_Interface}
	set values(Bottom_Row_Interface) [get_property value $Bottom_Row_Interface]
	if { [gen_USERPARAMETER_Use_Pullups_Bottom_Row_ENABLEMENT $values(Bottom_Row_Interface)] } {
		set_property enabled true $Use_Pullups_Bottom_Row
	} else {
		set_property enabled false $Use_Pullups_Bottom_Row
	}
}

proc validate_PARAM_VALUE.Use_Pullups_Bottom_Row { PARAM_VALUE.Use_Pullups_Bottom_Row } {
	# Procedure called to validate Use_Pullups_Bottom_Row
	return true
}

proc update_PARAM_VALUE.Bottom_Row_Interface { PARAM_VALUE.Bottom_Row_Interface } {
	# Procedure called to update Bottom_Row_Interface when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Bottom_Row_Interface { PARAM_VALUE.Bottom_Row_Interface } {
	# Procedure called to validate Bottom_Row_Interface
	return true
}

proc update_PARAM_VALUE.PMOD { IPINST PARAM_VALUE.PMOD PROJECT_PARAM.BOARD } {
	# Procedure called to update PMOD when any of the dependent parameters in the arguments change
	set param_range [get_board_interface_param_range $IPINST -name "PMOD"]
	set_property range $param_range ${PARAM_VALUE.PMOD}
}

proc validate_PARAM_VALUE.PMOD { PARAM_VALUE.PMOD PARAM_VALUE.USE_BOARD_FLOW IPINST PROJECT_PARAM.BOARD } {
	# Procedure called to validate PMOD
	set pmod_vlnv [get_pmod_vlnv]
	set intf [ get_property value ${PARAM_VALUE.PMOD} ]
	set board ${PROJECT_PARAM.BOARD}
	return true
}

proc update_PARAM_VALUE.Top_Row_Interface { PARAM_VALUE.Top_Row_Interface } {
	# Procedure called to update Top_Row_Interface when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.Top_Row_Interface { PARAM_VALUE.Top_Row_Interface } {
	# Procedure called to validate Top_Row_Interface
	return true
}

proc update_PARAM_VALUE.USE_BOARD_FLOW { PARAM_VALUE.USE_BOARD_FLOW } {
	# Procedure called to update USE_BOARD_FLOW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USE_BOARD_FLOW { PARAM_VALUE.USE_BOARD_FLOW } {
	# Procedure called to validate USE_BOARD_FLOW
	return true
}

proc update_MODELPARAM_VALUE.Top_Row_Interface { MODELPARAM_VALUE.Top_Row_Interface PARAM_VALUE.Top_Row_Interface } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Top_Row_Interface}] ${MODELPARAM_VALUE.Top_Row_Interface}
}

proc update_MODELPARAM_VALUE.Bottom_Row_Interface { MODELPARAM_VALUE.Bottom_Row_Interface PARAM_VALUE.Bottom_Row_Interface } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.Bottom_Row_Interface}] ${MODELPARAM_VALUE.Bottom_Row_Interface}
}