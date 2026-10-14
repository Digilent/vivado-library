package require xilinx::board 1.0
namespace import ::xilinx::board::*

proc get_pmod_vlnv {} {
	return "digilentinc.com:interface:pmod_rtl:1.0"
}

# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST PROJECT_PARAM.ARCHITECTURE PROJECT_PARAM.BOARD } {
  set c_family ${PROJECT_PARAM.ARCHITECTURE}
  set board ${PROJECT_PARAM.BOARD}
  set Component_Name [ ipgui::add_param  $IPINST  -parent  $IPINST  -name Component_Name ]
  add_board_tab $IPINST
}

proc update_PARAM_VALUE.PMOD {IPINST PARAM_VALUE.PMOD PROJECT_PARAM.BOARD} {
	set param_range [get_board_interface_param_range $IPINST -name "PMOD"]
	set_property range $param_range ${PARAM_VALUE.PMOD}
}

proc validate_PARAM_VALUE.PMOD { PARAM_VALUE.PMOD PARAM_VALUE.USE_BOARD_FLOW IPINST PROJECT_PARAM.BOARD} {
	set pmod_vlnv [get_pmod_vlnv]
	set intf [ get_property value ${PARAM_VALUE.PMOD} ]
	set board ${PROJECT_PARAM.BOARD}
	return true
}


proc update_PARAM_VALUE.AXI_LITE_SPI_BASEADDR { PARAM_VALUE.AXI_LITE_SPI_BASEADDR } {
	# Procedure called to update C_AXI_LITE_SPI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_LITE_SPI_BASEADDR { PARAM_VALUE.AXI_LITE_SPI_BASEADDR } {
	# Procedure called to validate C_AXI_LITE_SPI_BASEADDR
	return true
}

proc update_PARAM_VALUE.AXI_LITE_SPI_HIGHADDR { PARAM_VALUE.AXI_LITE_SPI_HIGHADDR } {
	# Procedure called to update C_AXI_LITE_SPI_HIGHADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_AXI_LITE_SPI_HIGHADDR { PARAM_VALUE.C_AXI_LITE_SPI_HIGHADDR } {
	# Procedure called to validate C_AXI_LITE_SPI_HIGHADDR
	return true
}
