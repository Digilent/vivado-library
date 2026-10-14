# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {General Settings}]
  ipgui::add_param $IPINST -name "nBANK_MACHS" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "ORDERING" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "tCK" -parent ${Page_0}

  #Adding Page
  set AXI_Interface [ipgui::add_page $IPINST -name "AXI Interface"]
  ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${AXI_Interface}
  ipgui::add_param $IPINST -name "C_S_AXI_CTRL_ADDR_WIDTH" -parent ${AXI_Interface}
  ipgui::add_param $IPINST -name "C_S_AXI_SUPPORTS_NARROW_BURST" -parent ${AXI_Interface}
  ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${AXI_Interface} -widget comboBox
  ipgui::add_param $IPINST -name "C_S_AXI_ID_WIDTH" -parent ${AXI_Interface}


}

proc update_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to update ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to validate ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.BANK_WIDTH { PARAM_VALUE.BANK_WIDTH } {
	# Procedure called to update BANK_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BANK_WIDTH { PARAM_VALUE.BANK_WIDTH } {
	# Procedure called to validate BANK_WIDTH
	return true
}

proc update_PARAM_VALUE.CKE_WIDTH { PARAM_VALUE.CKE_WIDTH } {
	# Procedure called to update CKE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CKE_WIDTH { PARAM_VALUE.CKE_WIDTH } {
	# Procedure called to validate CKE_WIDTH
	return true
}

proc update_PARAM_VALUE.CK_WIDTH { PARAM_VALUE.CK_WIDTH } {
	# Procedure called to update CK_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CK_WIDTH { PARAM_VALUE.CK_WIDTH } {
	# Procedure called to validate CK_WIDTH
	return true
}

proc update_PARAM_VALUE.COL_WIDTH { PARAM_VALUE.COL_WIDTH } {
	# Procedure called to update COL_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COL_WIDTH { PARAM_VALUE.COL_WIDTH } {
	# Procedure called to validate COL_WIDTH
	return true
}

proc update_PARAM_VALUE.CS_WIDTH { PARAM_VALUE.CS_WIDTH } {
	# Procedure called to update CS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CS_WIDTH { PARAM_VALUE.CS_WIDTH } {
	# Procedure called to validate CS_WIDTH
	return true
}

proc update_PARAM_VALUE.C_ECC_CE_COUNTER_WIDTH { PARAM_VALUE.C_ECC_CE_COUNTER_WIDTH } {
	# Procedure called to update C_ECC_CE_COUNTER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ECC_CE_COUNTER_WIDTH { PARAM_VALUE.C_ECC_CE_COUNTER_WIDTH } {
	# Procedure called to validate C_ECC_CE_COUNTER_WIDTH
	return true
}

proc update_PARAM_VALUE.C_ECC_ONOFF_RESET_VALUE { PARAM_VALUE.C_ECC_ONOFF_RESET_VALUE } {
	# Procedure called to update C_ECC_ONOFF_RESET_VALUE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_ECC_ONOFF_RESET_VALUE { PARAM_VALUE.C_ECC_ONOFF_RESET_VALUE } {
	# Procedure called to validate C_ECC_ONOFF_RESET_VALUE
	return true
}

proc update_PARAM_VALUE.C_MC_nCK_PER_CLK { PARAM_VALUE.C_MC_nCK_PER_CLK } {
	# Procedure called to update C_MC_nCK_PER_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_MC_nCK_PER_CLK { PARAM_VALUE.C_MC_nCK_PER_CLK } {
	# Procedure called to validate C_MC_nCK_PER_CLK
	return true
}

proc update_PARAM_VALUE.C_RD_WR_ARB_ALGORITHM { PARAM_VALUE.C_RD_WR_ARB_ALGORITHM } {
	# Procedure called to update C_RD_WR_ARB_ALGORITHM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_RD_WR_ARB_ALGORITHM { PARAM_VALUE.C_RD_WR_ARB_ALGORITHM } {
	# Procedure called to validate C_RD_WR_ARB_ALGORITHM
	return true
}

proc update_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to update C_S_AXI_BASEADDR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_BASEADDR { PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to validate C_S_AXI_BASEADDR
	return true
}

proc update_PARAM_VALUE.C_S_AXI_CTRL_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_CTRL_ADDR_WIDTH } {
	# Procedure called to update C_S_AXI_CTRL_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_CTRL_ADDR_WIDTH { PARAM_VALUE.C_S_AXI_CTRL_ADDR_WIDTH } {
	# Procedure called to validate C_S_AXI_CTRL_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_CTRL_DATA_WIDTH { PARAM_VALUE.C_S_AXI_CTRL_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_CTRL_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_CTRL_DATA_WIDTH { PARAM_VALUE.C_S_AXI_CTRL_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_CTRL_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to update C_S_AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_DATA_WIDTH { PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to validate C_S_AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_ID_WIDTH { PARAM_VALUE.C_S_AXI_ID_WIDTH } {
	# Procedure called to update C_S_AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_ID_WIDTH { PARAM_VALUE.C_S_AXI_ID_WIDTH } {
	# Procedure called to validate C_S_AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.C_S_AXI_MEM_SIZE { PARAM_VALUE.C_S_AXI_MEM_SIZE } {
	# Procedure called to update C_S_AXI_MEM_SIZE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_MEM_SIZE { PARAM_VALUE.C_S_AXI_MEM_SIZE } {
	# Procedure called to validate C_S_AXI_MEM_SIZE
	return true
}

proc update_PARAM_VALUE.C_S_AXI_REG_EN0 { PARAM_VALUE.C_S_AXI_REG_EN0 } {
	# Procedure called to update C_S_AXI_REG_EN0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_REG_EN0 { PARAM_VALUE.C_S_AXI_REG_EN0 } {
	# Procedure called to validate C_S_AXI_REG_EN0
	return true
}

proc update_PARAM_VALUE.C_S_AXI_REG_EN1 { PARAM_VALUE.C_S_AXI_REG_EN1 } {
	# Procedure called to update C_S_AXI_REG_EN1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_REG_EN1 { PARAM_VALUE.C_S_AXI_REG_EN1 } {
	# Procedure called to validate C_S_AXI_REG_EN1
	return true
}

proc update_PARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST { PARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST } {
	# Procedure called to update C_S_AXI_SUPPORTS_NARROW_BURST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST { PARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST } {
	# Procedure called to validate C_S_AXI_SUPPORTS_NARROW_BURST
	return true
}

proc update_PARAM_VALUE.DATA_BUF_ADDR_WIDTH { PARAM_VALUE.DATA_BUF_ADDR_WIDTH } {
	# Procedure called to update DATA_BUF_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_BUF_ADDR_WIDTH { PARAM_VALUE.DATA_BUF_ADDR_WIDTH } {
	# Procedure called to validate DATA_BUF_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DDR_MEM_INTERFACE_BOARD_INTERFACE { PARAM_VALUE.DDR_MEM_INTERFACE_BOARD_INTERFACE } {
	# Procedure called to update DDR_MEM_INTERFACE_BOARD_INTERFACE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DDR_MEM_INTERFACE_BOARD_INTERFACE { PARAM_VALUE.DDR_MEM_INTERFACE_BOARD_INTERFACE } {
	# Procedure called to validate DDR_MEM_INTERFACE_BOARD_INTERFACE
	return true
}

proc update_PARAM_VALUE.DM_WIDTH { PARAM_VALUE.DM_WIDTH } {
	# Procedure called to update DM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DM_WIDTH { PARAM_VALUE.DM_WIDTH } {
	# Procedure called to validate DM_WIDTH
	return true
}

proc update_PARAM_VALUE.DQS_CNT_WIDTH { PARAM_VALUE.DQS_CNT_WIDTH } {
	# Procedure called to update DQS_CNT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DQS_CNT_WIDTH { PARAM_VALUE.DQS_CNT_WIDTH } {
	# Procedure called to validate DQS_CNT_WIDTH
	return true
}

proc update_PARAM_VALUE.DQS_WIDTH { PARAM_VALUE.DQS_WIDTH } {
	# Procedure called to update DQS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DQS_WIDTH { PARAM_VALUE.DQS_WIDTH } {
	# Procedure called to validate DQS_WIDTH
	return true
}

proc update_PARAM_VALUE.DQ_CNT_WIDTH { PARAM_VALUE.DQ_CNT_WIDTH } {
	# Procedure called to update DQ_CNT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DQ_CNT_WIDTH { PARAM_VALUE.DQ_CNT_WIDTH } {
	# Procedure called to validate DQ_CNT_WIDTH
	return true
}

proc update_PARAM_VALUE.DQ_PER_DM { PARAM_VALUE.DQ_PER_DM } {
	# Procedure called to update DQ_PER_DM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DQ_PER_DM { PARAM_VALUE.DQ_PER_DM } {
	# Procedure called to validate DQ_PER_DM
	return true
}

proc update_PARAM_VALUE.DQ_WIDTH { PARAM_VALUE.DQ_WIDTH } {
	# Procedure called to update DQ_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DQ_WIDTH { PARAM_VALUE.DQ_WIDTH } {
	# Procedure called to validate DQ_WIDTH
	return true
}

proc update_PARAM_VALUE.DRAM_TYPE { PARAM_VALUE.DRAM_TYPE } {
	# Procedure called to update DRAM_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DRAM_TYPE { PARAM_VALUE.DRAM_TYPE } {
	# Procedure called to validate DRAM_TYPE
	return true
}

proc update_PARAM_VALUE.DRAM_WIDTH { PARAM_VALUE.DRAM_WIDTH } {
	# Procedure called to update DRAM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DRAM_WIDTH { PARAM_VALUE.DRAM_WIDTH } {
	# Procedure called to validate DRAM_WIDTH
	return true
}

proc update_PARAM_VALUE.ECC { PARAM_VALUE.ECC } {
	# Procedure called to update ECC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ECC { PARAM_VALUE.ECC } {
	# Procedure called to validate ECC
	return true
}

proc update_PARAM_VALUE.ECC_TEST { PARAM_VALUE.ECC_TEST } {
	# Procedure called to update ECC_TEST when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ECC_TEST { PARAM_VALUE.ECC_TEST } {
	# Procedure called to validate ECC_TEST
	return true
}

proc update_PARAM_VALUE.MEM_ADDR_ORDER { PARAM_VALUE.MEM_ADDR_ORDER } {
	# Procedure called to update MEM_ADDR_ORDER when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_ADDR_ORDER { PARAM_VALUE.MEM_ADDR_ORDER } {
	# Procedure called to validate MEM_ADDR_ORDER
	return true
}

proc update_PARAM_VALUE.MEM_DENSITY { PARAM_VALUE.MEM_DENSITY } {
	# Procedure called to update MEM_DENSITY when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_DENSITY { PARAM_VALUE.MEM_DENSITY } {
	# Procedure called to validate MEM_DENSITY
	return true
}

proc update_PARAM_VALUE.MEM_DEVICE_WIDTH { PARAM_VALUE.MEM_DEVICE_WIDTH } {
	# Procedure called to update MEM_DEVICE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_DEVICE_WIDTH { PARAM_VALUE.MEM_DEVICE_WIDTH } {
	# Procedure called to validate MEM_DEVICE_WIDTH
	return true
}

proc update_PARAM_VALUE.MEM_SPEEDGRADE { PARAM_VALUE.MEM_SPEEDGRADE } {
	# Procedure called to update MEM_SPEEDGRADE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MEM_SPEEDGRADE { PARAM_VALUE.MEM_SPEEDGRADE } {
	# Procedure called to validate MEM_SPEEDGRADE
	return true
}

proc update_PARAM_VALUE.ODT_WIDTH { PARAM_VALUE.ODT_WIDTH } {
	# Procedure called to update ODT_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ODT_WIDTH { PARAM_VALUE.ODT_WIDTH } {
	# Procedure called to validate ODT_WIDTH
	return true
}

proc update_PARAM_VALUE.ORDERING { PARAM_VALUE.ORDERING } {
	# Procedure called to update ORDERING when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ORDERING { PARAM_VALUE.ORDERING } {
	# Procedure called to validate ORDERING
	return true
}

proc update_PARAM_VALUE.PAYLOAD_WIDTH { PARAM_VALUE.PAYLOAD_WIDTH } {
	# Procedure called to update PAYLOAD_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PAYLOAD_WIDTH { PARAM_VALUE.PAYLOAD_WIDTH } {
	# Procedure called to validate PAYLOAD_WIDTH
	return true
}

proc update_PARAM_VALUE.PHY_CONTROL_MASTER_BANK { PARAM_VALUE.PHY_CONTROL_MASTER_BANK } {
	# Procedure called to update PHY_CONTROL_MASTER_BANK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PHY_CONTROL_MASTER_BANK { PARAM_VALUE.PHY_CONTROL_MASTER_BANK } {
	# Procedure called to validate PHY_CONTROL_MASTER_BANK
	return true
}

proc update_PARAM_VALUE.RANKS { PARAM_VALUE.RANKS } {
	# Procedure called to update RANKS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RANKS { PARAM_VALUE.RANKS } {
	# Procedure called to validate RANKS
	return true
}

proc update_PARAM_VALUE.ROW_WIDTH { PARAM_VALUE.ROW_WIDTH } {
	# Procedure called to update ROW_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ROW_WIDTH { PARAM_VALUE.ROW_WIDTH } {
	# Procedure called to validate ROW_WIDTH
	return true
}

proc update_PARAM_VALUE.RST_ACT_LOW { PARAM_VALUE.RST_ACT_LOW } {
	# Procedure called to update RST_ACT_LOW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RST_ACT_LOW { PARAM_VALUE.RST_ACT_LOW } {
	# Procedure called to validate RST_ACT_LOW
	return true
}

proc update_PARAM_VALUE.USE_CS_PORT { PARAM_VALUE.USE_CS_PORT } {
	# Procedure called to update USE_CS_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USE_CS_PORT { PARAM_VALUE.USE_CS_PORT } {
	# Procedure called to validate USE_CS_PORT
	return true
}

proc update_PARAM_VALUE.USE_DM_PORT { PARAM_VALUE.USE_DM_PORT } {
	# Procedure called to update USE_DM_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USE_DM_PORT { PARAM_VALUE.USE_DM_PORT } {
	# Procedure called to validate USE_DM_PORT
	return true
}

proc update_PARAM_VALUE.USE_ODT_PORT { PARAM_VALUE.USE_ODT_PORT } {
	# Procedure called to update USE_ODT_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USE_ODT_PORT { PARAM_VALUE.USE_ODT_PORT } {
	# Procedure called to validate USE_ODT_PORT
	return true
}

proc update_PARAM_VALUE.nBANK_MACHS { PARAM_VALUE.nBANK_MACHS } {
	# Procedure called to update nBANK_MACHS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.nBANK_MACHS { PARAM_VALUE.nBANK_MACHS } {
	# Procedure called to validate nBANK_MACHS
	return true
}

proc update_PARAM_VALUE.nCK_PER_CLK { PARAM_VALUE.nCK_PER_CLK } {
	# Procedure called to update nCK_PER_CLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.nCK_PER_CLK { PARAM_VALUE.nCK_PER_CLK } {
	# Procedure called to validate nCK_PER_CLK
	return true
}

proc update_PARAM_VALUE.nCS_PER_RANK { PARAM_VALUE.nCS_PER_RANK } {
	# Procedure called to update nCS_PER_RANK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.nCS_PER_RANK { PARAM_VALUE.nCS_PER_RANK } {
	# Procedure called to validate nCS_PER_RANK
	return true
}

proc update_PARAM_VALUE.tCK { PARAM_VALUE.tCK } {
	# Procedure called to update tCK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tCK { PARAM_VALUE.tCK } {
	# Procedure called to validate tCK
	return true
}


proc update_MODELPARAM_VALUE.tCK { MODELPARAM_VALUE.tCK PARAM_VALUE.tCK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tCK}] ${MODELPARAM_VALUE.tCK}
}

proc update_MODELPARAM_VALUE.nCK_PER_CLK { MODELPARAM_VALUE.nCK_PER_CLK PARAM_VALUE.nCK_PER_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.nCK_PER_CLK}] ${MODELPARAM_VALUE.nCK_PER_CLK}
}

proc update_MODELPARAM_VALUE.C_S_AXI_MEM_SIZE { MODELPARAM_VALUE.C_S_AXI_MEM_SIZE PARAM_VALUE.C_S_AXI_MEM_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_MEM_SIZE}] ${MODELPARAM_VALUE.C_S_AXI_MEM_SIZE}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_BASEADDR { MODELPARAM_VALUE.C_S_AXI_BASEADDR PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_BASEADDR}] ${MODELPARAM_VALUE.C_S_AXI_BASEADDR}
}

proc update_MODELPARAM_VALUE.RST_ACT_LOW { MODELPARAM_VALUE.RST_ACT_LOW PARAM_VALUE.RST_ACT_LOW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RST_ACT_LOW}] ${MODELPARAM_VALUE.RST_ACT_LOW}
}

proc update_MODELPARAM_VALUE.BANK_WIDTH { MODELPARAM_VALUE.BANK_WIDTH PARAM_VALUE.BANK_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BANK_WIDTH}] ${MODELPARAM_VALUE.BANK_WIDTH}
}

proc update_MODELPARAM_VALUE.CK_WIDTH { MODELPARAM_VALUE.CK_WIDTH PARAM_VALUE.CK_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CK_WIDTH}] ${MODELPARAM_VALUE.CK_WIDTH}
}

proc update_MODELPARAM_VALUE.COL_WIDTH { MODELPARAM_VALUE.COL_WIDTH PARAM_VALUE.COL_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.COL_WIDTH}] ${MODELPARAM_VALUE.COL_WIDTH}
}

proc update_MODELPARAM_VALUE.CS_WIDTH { MODELPARAM_VALUE.CS_WIDTH PARAM_VALUE.CS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CS_WIDTH}] ${MODELPARAM_VALUE.CS_WIDTH}
}

proc update_MODELPARAM_VALUE.nCS_PER_RANK { MODELPARAM_VALUE.nCS_PER_RANK PARAM_VALUE.nCS_PER_RANK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.nCS_PER_RANK}] ${MODELPARAM_VALUE.nCS_PER_RANK}
}

proc update_MODELPARAM_VALUE.CKE_WIDTH { MODELPARAM_VALUE.CKE_WIDTH PARAM_VALUE.CKE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CKE_WIDTH}] ${MODELPARAM_VALUE.CKE_WIDTH}
}

proc update_MODELPARAM_VALUE.DATA_BUF_ADDR_WIDTH { MODELPARAM_VALUE.DATA_BUF_ADDR_WIDTH PARAM_VALUE.DATA_BUF_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_BUF_ADDR_WIDTH}] ${MODELPARAM_VALUE.DATA_BUF_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.DQ_CNT_WIDTH { MODELPARAM_VALUE.DQ_CNT_WIDTH PARAM_VALUE.DQ_CNT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DQ_CNT_WIDTH}] ${MODELPARAM_VALUE.DQ_CNT_WIDTH}
}

proc update_MODELPARAM_VALUE.DQ_PER_DM { MODELPARAM_VALUE.DQ_PER_DM PARAM_VALUE.DQ_PER_DM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DQ_PER_DM}] ${MODELPARAM_VALUE.DQ_PER_DM}
}

proc update_MODELPARAM_VALUE.DM_WIDTH { MODELPARAM_VALUE.DM_WIDTH PARAM_VALUE.DM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DM_WIDTH}] ${MODELPARAM_VALUE.DM_WIDTH}
}

proc update_MODELPARAM_VALUE.DQ_WIDTH { MODELPARAM_VALUE.DQ_WIDTH PARAM_VALUE.DQ_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DQ_WIDTH}] ${MODELPARAM_VALUE.DQ_WIDTH}
}

proc update_MODELPARAM_VALUE.DQS_WIDTH { MODELPARAM_VALUE.DQS_WIDTH PARAM_VALUE.DQS_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DQS_WIDTH}] ${MODELPARAM_VALUE.DQS_WIDTH}
}

proc update_MODELPARAM_VALUE.DQS_CNT_WIDTH { MODELPARAM_VALUE.DQS_CNT_WIDTH PARAM_VALUE.DQS_CNT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DQS_CNT_WIDTH}] ${MODELPARAM_VALUE.DQS_CNT_WIDTH}
}

proc update_MODELPARAM_VALUE.DRAM_WIDTH { MODELPARAM_VALUE.DRAM_WIDTH PARAM_VALUE.DRAM_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DRAM_WIDTH}] ${MODELPARAM_VALUE.DRAM_WIDTH}
}

proc update_MODELPARAM_VALUE.ECC { MODELPARAM_VALUE.ECC PARAM_VALUE.ECC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ECC}] ${MODELPARAM_VALUE.ECC}
}

proc update_MODELPARAM_VALUE.DATA_WIDTH { MODELPARAM_VALUE.DATA_WIDTH PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_WIDTH}] ${MODELPARAM_VALUE.DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.ECC_TEST { MODELPARAM_VALUE.ECC_TEST PARAM_VALUE.ECC_TEST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ECC_TEST}] ${MODELPARAM_VALUE.ECC_TEST}
}

proc update_MODELPARAM_VALUE.PAYLOAD_WIDTH { MODELPARAM_VALUE.PAYLOAD_WIDTH PARAM_VALUE.PAYLOAD_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PAYLOAD_WIDTH}] ${MODELPARAM_VALUE.PAYLOAD_WIDTH}
}

proc update_MODELPARAM_VALUE.MEM_ADDR_ORDER { MODELPARAM_VALUE.MEM_ADDR_ORDER PARAM_VALUE.MEM_ADDR_ORDER } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_ADDR_ORDER}] ${MODELPARAM_VALUE.MEM_ADDR_ORDER}
}

proc update_MODELPARAM_VALUE.nBANK_MACHS { MODELPARAM_VALUE.nBANK_MACHS PARAM_VALUE.nBANK_MACHS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.nBANK_MACHS}] ${MODELPARAM_VALUE.nBANK_MACHS}
}

proc update_MODELPARAM_VALUE.RANKS { MODELPARAM_VALUE.RANKS PARAM_VALUE.RANKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RANKS}] ${MODELPARAM_VALUE.RANKS}
}

proc update_MODELPARAM_VALUE.ODT_WIDTH { MODELPARAM_VALUE.ODT_WIDTH PARAM_VALUE.ODT_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ODT_WIDTH}] ${MODELPARAM_VALUE.ODT_WIDTH}
}

proc update_MODELPARAM_VALUE.ROW_WIDTH { MODELPARAM_VALUE.ROW_WIDTH PARAM_VALUE.ROW_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ROW_WIDTH}] ${MODELPARAM_VALUE.ROW_WIDTH}
}

proc update_MODELPARAM_VALUE.ADDR_WIDTH { MODELPARAM_VALUE.ADDR_WIDTH PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_WIDTH}] ${MODELPARAM_VALUE.ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.USE_CS_PORT { MODELPARAM_VALUE.USE_CS_PORT PARAM_VALUE.USE_CS_PORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USE_CS_PORT}] ${MODELPARAM_VALUE.USE_CS_PORT}
}

proc update_MODELPARAM_VALUE.USE_DM_PORT { MODELPARAM_VALUE.USE_DM_PORT PARAM_VALUE.USE_DM_PORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USE_DM_PORT}] ${MODELPARAM_VALUE.USE_DM_PORT}
}

proc update_MODELPARAM_VALUE.USE_ODT_PORT { MODELPARAM_VALUE.USE_ODT_PORT PARAM_VALUE.USE_ODT_PORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USE_ODT_PORT}] ${MODELPARAM_VALUE.USE_ODT_PORT}
}

proc update_MODELPARAM_VALUE.PHY_CONTROL_MASTER_BANK { MODELPARAM_VALUE.PHY_CONTROL_MASTER_BANK PARAM_VALUE.PHY_CONTROL_MASTER_BANK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PHY_CONTROL_MASTER_BANK}] ${MODELPARAM_VALUE.PHY_CONTROL_MASTER_BANK}
}

proc update_MODELPARAM_VALUE.MEM_DENSITY { MODELPARAM_VALUE.MEM_DENSITY PARAM_VALUE.MEM_DENSITY } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_DENSITY}] ${MODELPARAM_VALUE.MEM_DENSITY}
}

proc update_MODELPARAM_VALUE.MEM_SPEEDGRADE { MODELPARAM_VALUE.MEM_SPEEDGRADE PARAM_VALUE.MEM_SPEEDGRADE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_SPEEDGRADE}] ${MODELPARAM_VALUE.MEM_SPEEDGRADE}
}

proc update_MODELPARAM_VALUE.MEM_DEVICE_WIDTH { MODELPARAM_VALUE.MEM_DEVICE_WIDTH PARAM_VALUE.MEM_DEVICE_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MEM_DEVICE_WIDTH}] ${MODELPARAM_VALUE.MEM_DEVICE_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ID_WIDTH { MODELPARAM_VALUE.C_S_AXI_ID_WIDTH PARAM_VALUE.C_S_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH PARAM_VALUE.C_S_AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_MC_nCK_PER_CLK { MODELPARAM_VALUE.C_MC_nCK_PER_CLK PARAM_VALUE.C_MC_nCK_PER_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_MC_nCK_PER_CLK}] ${MODELPARAM_VALUE.C_MC_nCK_PER_CLK}
}

proc update_MODELPARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST { MODELPARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST PARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST}] ${MODELPARAM_VALUE.C_S_AXI_SUPPORTS_NARROW_BURST}
}

proc update_MODELPARAM_VALUE.C_RD_WR_ARB_ALGORITHM { MODELPARAM_VALUE.C_RD_WR_ARB_ALGORITHM PARAM_VALUE.C_RD_WR_ARB_ALGORITHM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_RD_WR_ARB_ALGORITHM}] ${MODELPARAM_VALUE.C_RD_WR_ARB_ALGORITHM}
}

proc update_MODELPARAM_VALUE.C_S_AXI_REG_EN0 { MODELPARAM_VALUE.C_S_AXI_REG_EN0 PARAM_VALUE.C_S_AXI_REG_EN0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_REG_EN0}] ${MODELPARAM_VALUE.C_S_AXI_REG_EN0}
}

proc update_MODELPARAM_VALUE.C_S_AXI_REG_EN1 { MODELPARAM_VALUE.C_S_AXI_REG_EN1 PARAM_VALUE.C_S_AXI_REG_EN1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_REG_EN1}] ${MODELPARAM_VALUE.C_S_AXI_REG_EN1}
}

proc update_MODELPARAM_VALUE.C_S_AXI_CTRL_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_CTRL_ADDR_WIDTH PARAM_VALUE.C_S_AXI_CTRL_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_CTRL_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_CTRL_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_CTRL_DATA_WIDTH { MODELPARAM_VALUE.C_S_AXI_CTRL_DATA_WIDTH PARAM_VALUE.C_S_AXI_CTRL_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_CTRL_DATA_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_CTRL_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.C_ECC_ONOFF_RESET_VALUE { MODELPARAM_VALUE.C_ECC_ONOFF_RESET_VALUE PARAM_VALUE.C_ECC_ONOFF_RESET_VALUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ECC_ONOFF_RESET_VALUE}] ${MODELPARAM_VALUE.C_ECC_ONOFF_RESET_VALUE}
}

proc update_MODELPARAM_VALUE.C_ECC_CE_COUNTER_WIDTH { MODELPARAM_VALUE.C_ECC_CE_COUNTER_WIDTH PARAM_VALUE.C_ECC_CE_COUNTER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ECC_CE_COUNTER_WIDTH}] ${MODELPARAM_VALUE.C_ECC_CE_COUNTER_WIDTH}
}

proc update_MODELPARAM_VALUE.ORDERING { MODELPARAM_VALUE.ORDERING PARAM_VALUE.ORDERING } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ORDERING}] ${MODELPARAM_VALUE.ORDERING}
}

proc update_MODELPARAM_VALUE.DRAM_TYPE { MODELPARAM_VALUE.DRAM_TYPE PARAM_VALUE.DRAM_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DRAM_TYPE}] ${MODELPARAM_VALUE.DRAM_TYPE}
}

