# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0" -display_name {Main}]
  ipgui::add_param $IPINST -name "TEMP_MON_EN" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "DEBUG_PORT" -parent ${Page_0} -widget comboBox
  ipgui::add_param $IPINST -name "nBANK_MACHS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "UI_EXTRA_CLOCKS" -parent ${Page_0}
  ipgui::add_param $IPINST -name "RST_ACT_LOW" -parent ${Page_0} -widget comboBox

  #Adding Page
  set Clocks [ipgui::add_page $IPINST -name "Clocks"]
  ipgui::add_param $IPINST -name "MMCM_VCO" -parent ${Clocks}
  ipgui::add_param $IPINST -name "MMCM_MULT_F" -parent ${Clocks}
  ipgui::add_param $IPINST -name "MMCM_DIVCLK_DIVIDE" -parent ${Clocks}
  ipgui::add_param $IPINST -name "MMCM_CLKOUT4_DIVIDE" -parent ${Clocks}
  ipgui::add_param $IPINST -name "MMCM_CLKOUT3_DIVIDE" -parent ${Clocks}
  ipgui::add_param $IPINST -name "MMCM_CLKOUT2_DIVIDE" -parent ${Clocks}
  ipgui::add_param $IPINST -name "MMCM_CLKOUT1_DIVIDE" -parent ${Clocks}
  ipgui::add_param $IPINST -name "MMCM_CLKOUT0_DIVIDE" -parent ${Clocks}
  ipgui::add_param $IPINST -name "MMCM_CLKOUT4_EN" -parent ${Clocks} -widget comboBox
  ipgui::add_param $IPINST -name "MMCM_CLKOUT3_EN" -parent ${Clocks} -widget comboBox
  ipgui::add_param $IPINST -name "MMCM_CLKOUT2_EN" -parent ${Clocks} -widget comboBox
  ipgui::add_param $IPINST -name "MMCM_CLKOUT1_EN" -parent ${Clocks} -widget comboBox
  ipgui::add_param $IPINST -name "MMCM_CLKOUT0_EN" -parent ${Clocks}

  #Adding Page
  set AXI_Interface [ipgui::add_page $IPINST -name "AXI Interface"]
  ipgui::add_param $IPINST -name "C_S_AXI_ADDR_WIDTH" -parent ${AXI_Interface}
  ipgui::add_param $IPINST -name "C_S_AXI_SUPPORTS_NARROW_BURST" -parent ${AXI_Interface} -widget comboBox
  ipgui::add_param $IPINST -name "C_S_AXI_DATA_WIDTH" -parent ${AXI_Interface} -widget comboBox
  ipgui::add_param $IPINST -name "C_S_AXI_MEM_SIZE" -parent ${AXI_Interface}


}

proc update_PARAM_VALUE.ADDR_CMD_MODE { PARAM_VALUE.ADDR_CMD_MODE } {
	# Procedure called to update ADDR_CMD_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_CMD_MODE { PARAM_VALUE.ADDR_CMD_MODE } {
	# Procedure called to validate ADDR_CMD_MODE
	return true
}

proc update_PARAM_VALUE.ADDR_MAP { PARAM_VALUE.ADDR_MAP } {
	# Procedure called to update ADDR_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_MAP { PARAM_VALUE.ADDR_MAP } {
	# Procedure called to validate ADDR_MAP
	return true
}

proc update_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to update ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ADDR_WIDTH { PARAM_VALUE.ADDR_WIDTH } {
	# Procedure called to validate ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.AL { PARAM_VALUE.AL } {
	# Procedure called to update AL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AL { PARAM_VALUE.AL } {
	# Procedure called to validate AL
	return true
}

proc update_PARAM_VALUE.BANK_MAP { PARAM_VALUE.BANK_MAP } {
	# Procedure called to update BANK_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BANK_MAP { PARAM_VALUE.BANK_MAP } {
	# Procedure called to validate BANK_MAP
	return true
}

proc update_PARAM_VALUE.BANK_TYPE { PARAM_VALUE.BANK_TYPE } {
	# Procedure called to update BANK_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BANK_TYPE { PARAM_VALUE.BANK_TYPE } {
	# Procedure called to validate BANK_TYPE
	return true
}

proc update_PARAM_VALUE.BANK_WIDTH { PARAM_VALUE.BANK_WIDTH } {
	# Procedure called to update BANK_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BANK_WIDTH { PARAM_VALUE.BANK_WIDTH } {
	# Procedure called to validate BANK_WIDTH
	return true
}

proc update_PARAM_VALUE.BURST_MODE { PARAM_VALUE.BURST_MODE } {
	# Procedure called to update BURST_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BURST_MODE { PARAM_VALUE.BURST_MODE } {
	# Procedure called to validate BURST_MODE
	return true
}

proc update_PARAM_VALUE.BURST_TYPE { PARAM_VALUE.BURST_TYPE } {
	# Procedure called to update BURST_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BURST_TYPE { PARAM_VALUE.BURST_TYPE } {
	# Procedure called to validate BURST_TYPE
	return true
}

proc update_PARAM_VALUE.BYTE_LANES_B0 { PARAM_VALUE.BYTE_LANES_B0 } {
	# Procedure called to update BYTE_LANES_B0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BYTE_LANES_B0 { PARAM_VALUE.BYTE_LANES_B0 } {
	# Procedure called to validate BYTE_LANES_B0
	return true
}

proc update_PARAM_VALUE.BYTE_LANES_B1 { PARAM_VALUE.BYTE_LANES_B1 } {
	# Procedure called to update BYTE_LANES_B1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BYTE_LANES_B1 { PARAM_VALUE.BYTE_LANES_B1 } {
	# Procedure called to validate BYTE_LANES_B1
	return true
}

proc update_PARAM_VALUE.BYTE_LANES_B2 { PARAM_VALUE.BYTE_LANES_B2 } {
	# Procedure called to update BYTE_LANES_B2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BYTE_LANES_B2 { PARAM_VALUE.BYTE_LANES_B2 } {
	# Procedure called to validate BYTE_LANES_B2
	return true
}

proc update_PARAM_VALUE.BYTE_LANES_B3 { PARAM_VALUE.BYTE_LANES_B3 } {
	# Procedure called to update BYTE_LANES_B3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BYTE_LANES_B3 { PARAM_VALUE.BYTE_LANES_B3 } {
	# Procedure called to validate BYTE_LANES_B3
	return true
}

proc update_PARAM_VALUE.BYTE_LANES_B4 { PARAM_VALUE.BYTE_LANES_B4 } {
	# Procedure called to update BYTE_LANES_B4 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.BYTE_LANES_B4 { PARAM_VALUE.BYTE_LANES_B4 } {
	# Procedure called to validate BYTE_LANES_B4
	return true
}

proc update_PARAM_VALUE.CALIB_BA_ADD { PARAM_VALUE.CALIB_BA_ADD } {
	# Procedure called to update CALIB_BA_ADD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CALIB_BA_ADD { PARAM_VALUE.CALIB_BA_ADD } {
	# Procedure called to validate CALIB_BA_ADD
	return true
}

proc update_PARAM_VALUE.CALIB_COL_ADD { PARAM_VALUE.CALIB_COL_ADD } {
	# Procedure called to update CALIB_COL_ADD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CALIB_COL_ADD { PARAM_VALUE.CALIB_COL_ADD } {
	# Procedure called to validate CALIB_COL_ADD
	return true
}

proc update_PARAM_VALUE.CALIB_ROW_ADD { PARAM_VALUE.CALIB_ROW_ADD } {
	# Procedure called to update CALIB_ROW_ADD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CALIB_ROW_ADD { PARAM_VALUE.CALIB_ROW_ADD } {
	# Procedure called to validate CALIB_ROW_ADD
	return true
}

proc update_PARAM_VALUE.CAL_WIDTH { PARAM_VALUE.CAL_WIDTH } {
	# Procedure called to update CAL_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CAL_WIDTH { PARAM_VALUE.CAL_WIDTH } {
	# Procedure called to validate CAL_WIDTH
	return true
}

proc update_PARAM_VALUE.CAS_MAP { PARAM_VALUE.CAS_MAP } {
	# Procedure called to update CAS_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CAS_MAP { PARAM_VALUE.CAS_MAP } {
	# Procedure called to validate CAS_MAP
	return true
}

proc update_PARAM_VALUE.CA_MIRROR { PARAM_VALUE.CA_MIRROR } {
	# Procedure called to update CA_MIRROR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CA_MIRROR { PARAM_VALUE.CA_MIRROR } {
	# Procedure called to validate CA_MIRROR
	return true
}

proc update_PARAM_VALUE.CENTER_COMP_MODE { PARAM_VALUE.CENTER_COMP_MODE } {
	# Procedure called to update CENTER_COMP_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CENTER_COMP_MODE { PARAM_VALUE.CENTER_COMP_MODE } {
	# Procedure called to validate CENTER_COMP_MODE
	return true
}

proc update_PARAM_VALUE.CKE_MAP { PARAM_VALUE.CKE_MAP } {
	# Procedure called to update CKE_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CKE_MAP { PARAM_VALUE.CKE_MAP } {
	# Procedure called to validate CKE_MAP
	return true
}

proc update_PARAM_VALUE.CKE_ODT_AUX { PARAM_VALUE.CKE_ODT_AUX } {
	# Procedure called to update CKE_ODT_AUX when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CKE_ODT_AUX { PARAM_VALUE.CKE_ODT_AUX } {
	# Procedure called to validate CKE_ODT_AUX
	return true
}

proc update_PARAM_VALUE.CKE_ODT_BYTE_MAP { PARAM_VALUE.CKE_ODT_BYTE_MAP } {
	# Procedure called to update CKE_ODT_BYTE_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CKE_ODT_BYTE_MAP { PARAM_VALUE.CKE_ODT_BYTE_MAP } {
	# Procedure called to validate CKE_ODT_BYTE_MAP
	return true
}

proc update_PARAM_VALUE.CKE_WIDTH { PARAM_VALUE.CKE_WIDTH } {
	# Procedure called to update CKE_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CKE_WIDTH { PARAM_VALUE.CKE_WIDTH } {
	# Procedure called to validate CKE_WIDTH
	return true
}

proc update_PARAM_VALUE.CK_BYTE_MAP { PARAM_VALUE.CK_BYTE_MAP } {
	# Procedure called to update CK_BYTE_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CK_BYTE_MAP { PARAM_VALUE.CK_BYTE_MAP } {
	# Procedure called to validate CK_BYTE_MAP
	return true
}

proc update_PARAM_VALUE.CK_WIDTH { PARAM_VALUE.CK_WIDTH } {
	# Procedure called to update CK_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CK_WIDTH { PARAM_VALUE.CK_WIDTH } {
	# Procedure called to validate CK_WIDTH
	return true
}

proc update_PARAM_VALUE.CL { PARAM_VALUE.CL } {
	# Procedure called to update CL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CL { PARAM_VALUE.CL } {
	# Procedure called to validate CL
	return true
}

proc update_PARAM_VALUE.CLKFBOUT_MULT { PARAM_VALUE.CLKFBOUT_MULT } {
	# Procedure called to update CLKFBOUT_MULT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLKFBOUT_MULT { PARAM_VALUE.CLKFBOUT_MULT } {
	# Procedure called to validate CLKFBOUT_MULT
	return true
}

proc update_PARAM_VALUE.CLKIN_PERIOD { PARAM_VALUE.CLKIN_PERIOD } {
	# Procedure called to update CLKIN_PERIOD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLKIN_PERIOD { PARAM_VALUE.CLKIN_PERIOD } {
	# Procedure called to validate CLKIN_PERIOD
	return true
}

proc update_PARAM_VALUE.CLKOUT0_DIVIDE { PARAM_VALUE.CLKOUT0_DIVIDE } {
	# Procedure called to update CLKOUT0_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLKOUT0_DIVIDE { PARAM_VALUE.CLKOUT0_DIVIDE } {
	# Procedure called to validate CLKOUT0_DIVIDE
	return true
}

proc update_PARAM_VALUE.CLKOUT0_PHASE { PARAM_VALUE.CLKOUT0_PHASE } {
	# Procedure called to update CLKOUT0_PHASE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLKOUT0_PHASE { PARAM_VALUE.CLKOUT0_PHASE } {
	# Procedure called to validate CLKOUT0_PHASE
	return true
}

proc update_PARAM_VALUE.CLKOUT1_DIVIDE { PARAM_VALUE.CLKOUT1_DIVIDE } {
	# Procedure called to update CLKOUT1_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLKOUT1_DIVIDE { PARAM_VALUE.CLKOUT1_DIVIDE } {
	# Procedure called to validate CLKOUT1_DIVIDE
	return true
}

proc update_PARAM_VALUE.CLKOUT2_DIVIDE { PARAM_VALUE.CLKOUT2_DIVIDE } {
	# Procedure called to update CLKOUT2_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLKOUT2_DIVIDE { PARAM_VALUE.CLKOUT2_DIVIDE } {
	# Procedure called to validate CLKOUT2_DIVIDE
	return true
}

proc update_PARAM_VALUE.CLKOUT3_DIVIDE { PARAM_VALUE.CLKOUT3_DIVIDE } {
	# Procedure called to update CLKOUT3_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CLKOUT3_DIVIDE { PARAM_VALUE.CLKOUT3_DIVIDE } {
	# Procedure called to validate CLKOUT3_DIVIDE
	return true
}

proc update_PARAM_VALUE.CMD_PIPE_PLUS1 { PARAM_VALUE.CMD_PIPE_PLUS1 } {
	# Procedure called to update CMD_PIPE_PLUS1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CMD_PIPE_PLUS1 { PARAM_VALUE.CMD_PIPE_PLUS1 } {
	# Procedure called to validate CMD_PIPE_PLUS1
	return true
}

proc update_PARAM_VALUE.COL_WIDTH { PARAM_VALUE.COL_WIDTH } {
	# Procedure called to update COL_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.COL_WIDTH { PARAM_VALUE.COL_WIDTH } {
	# Procedure called to validate COL_WIDTH
	return true
}

proc update_PARAM_VALUE.CS_MAP { PARAM_VALUE.CS_MAP } {
	# Procedure called to update CS_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CS_MAP { PARAM_VALUE.CS_MAP } {
	# Procedure called to validate CS_MAP
	return true
}

proc update_PARAM_VALUE.CS_WIDTH { PARAM_VALUE.CS_WIDTH } {
	# Procedure called to update CS_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CS_WIDTH { PARAM_VALUE.CS_WIDTH } {
	# Procedure called to validate CS_WIDTH
	return true
}

proc update_PARAM_VALUE.CWL { PARAM_VALUE.CWL } {
	# Procedure called to update CWL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.CWL { PARAM_VALUE.CWL } {
	# Procedure called to validate CWL
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

proc update_PARAM_VALUE.DATA0_MAP { PARAM_VALUE.DATA0_MAP } {
	# Procedure called to update DATA0_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA0_MAP { PARAM_VALUE.DATA0_MAP } {
	# Procedure called to validate DATA0_MAP
	return true
}

proc update_PARAM_VALUE.DATA10_MAP { PARAM_VALUE.DATA10_MAP } {
	# Procedure called to update DATA10_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA10_MAP { PARAM_VALUE.DATA10_MAP } {
	# Procedure called to validate DATA10_MAP
	return true
}

proc update_PARAM_VALUE.DATA11_MAP { PARAM_VALUE.DATA11_MAP } {
	# Procedure called to update DATA11_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA11_MAP { PARAM_VALUE.DATA11_MAP } {
	# Procedure called to validate DATA11_MAP
	return true
}

proc update_PARAM_VALUE.DATA12_MAP { PARAM_VALUE.DATA12_MAP } {
	# Procedure called to update DATA12_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA12_MAP { PARAM_VALUE.DATA12_MAP } {
	# Procedure called to validate DATA12_MAP
	return true
}

proc update_PARAM_VALUE.DATA13_MAP { PARAM_VALUE.DATA13_MAP } {
	# Procedure called to update DATA13_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA13_MAP { PARAM_VALUE.DATA13_MAP } {
	# Procedure called to validate DATA13_MAP
	return true
}

proc update_PARAM_VALUE.DATA14_MAP { PARAM_VALUE.DATA14_MAP } {
	# Procedure called to update DATA14_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA14_MAP { PARAM_VALUE.DATA14_MAP } {
	# Procedure called to validate DATA14_MAP
	return true
}

proc update_PARAM_VALUE.DATA15_MAP { PARAM_VALUE.DATA15_MAP } {
	# Procedure called to update DATA15_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA15_MAP { PARAM_VALUE.DATA15_MAP } {
	# Procedure called to validate DATA15_MAP
	return true
}

proc update_PARAM_VALUE.DATA16_MAP { PARAM_VALUE.DATA16_MAP } {
	# Procedure called to update DATA16_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA16_MAP { PARAM_VALUE.DATA16_MAP } {
	# Procedure called to validate DATA16_MAP
	return true
}

proc update_PARAM_VALUE.DATA17_MAP { PARAM_VALUE.DATA17_MAP } {
	# Procedure called to update DATA17_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA17_MAP { PARAM_VALUE.DATA17_MAP } {
	# Procedure called to validate DATA17_MAP
	return true
}

proc update_PARAM_VALUE.DATA1_MAP { PARAM_VALUE.DATA1_MAP } {
	# Procedure called to update DATA1_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA1_MAP { PARAM_VALUE.DATA1_MAP } {
	# Procedure called to validate DATA1_MAP
	return true
}

proc update_PARAM_VALUE.DATA2_MAP { PARAM_VALUE.DATA2_MAP } {
	# Procedure called to update DATA2_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA2_MAP { PARAM_VALUE.DATA2_MAP } {
	# Procedure called to validate DATA2_MAP
	return true
}

proc update_PARAM_VALUE.DATA3_MAP { PARAM_VALUE.DATA3_MAP } {
	# Procedure called to update DATA3_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA3_MAP { PARAM_VALUE.DATA3_MAP } {
	# Procedure called to validate DATA3_MAP
	return true
}

proc update_PARAM_VALUE.DATA4_MAP { PARAM_VALUE.DATA4_MAP } {
	# Procedure called to update DATA4_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA4_MAP { PARAM_VALUE.DATA4_MAP } {
	# Procedure called to validate DATA4_MAP
	return true
}

proc update_PARAM_VALUE.DATA5_MAP { PARAM_VALUE.DATA5_MAP } {
	# Procedure called to update DATA5_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA5_MAP { PARAM_VALUE.DATA5_MAP } {
	# Procedure called to validate DATA5_MAP
	return true
}

proc update_PARAM_VALUE.DATA6_MAP { PARAM_VALUE.DATA6_MAP } {
	# Procedure called to update DATA6_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA6_MAP { PARAM_VALUE.DATA6_MAP } {
	# Procedure called to validate DATA6_MAP
	return true
}

proc update_PARAM_VALUE.DATA7_MAP { PARAM_VALUE.DATA7_MAP } {
	# Procedure called to update DATA7_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA7_MAP { PARAM_VALUE.DATA7_MAP } {
	# Procedure called to validate DATA7_MAP
	return true
}

proc update_PARAM_VALUE.DATA8_MAP { PARAM_VALUE.DATA8_MAP } {
	# Procedure called to update DATA8_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA8_MAP { PARAM_VALUE.DATA8_MAP } {
	# Procedure called to validate DATA8_MAP
	return true
}

proc update_PARAM_VALUE.DATA9_MAP { PARAM_VALUE.DATA9_MAP } {
	# Procedure called to update DATA9_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA9_MAP { PARAM_VALUE.DATA9_MAP } {
	# Procedure called to validate DATA9_MAP
	return true
}

proc update_PARAM_VALUE.DATA_BUF_ADDR_WIDTH { PARAM_VALUE.DATA_BUF_ADDR_WIDTH } {
	# Procedure called to update DATA_BUF_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_BUF_ADDR_WIDTH { PARAM_VALUE.DATA_BUF_ADDR_WIDTH } {
	# Procedure called to validate DATA_BUF_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.DATA_CTL_B0 { PARAM_VALUE.DATA_CTL_B0 } {
	# Procedure called to update DATA_CTL_B0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_CTL_B0 { PARAM_VALUE.DATA_CTL_B0 } {
	# Procedure called to validate DATA_CTL_B0
	return true
}

proc update_PARAM_VALUE.DATA_CTL_B1 { PARAM_VALUE.DATA_CTL_B1 } {
	# Procedure called to update DATA_CTL_B1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_CTL_B1 { PARAM_VALUE.DATA_CTL_B1 } {
	# Procedure called to validate DATA_CTL_B1
	return true
}

proc update_PARAM_VALUE.DATA_CTL_B2 { PARAM_VALUE.DATA_CTL_B2 } {
	# Procedure called to update DATA_CTL_B2 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_CTL_B2 { PARAM_VALUE.DATA_CTL_B2 } {
	# Procedure called to validate DATA_CTL_B2
	return true
}

proc update_PARAM_VALUE.DATA_CTL_B3 { PARAM_VALUE.DATA_CTL_B3 } {
	# Procedure called to update DATA_CTL_B3 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_CTL_B3 { PARAM_VALUE.DATA_CTL_B3 } {
	# Procedure called to validate DATA_CTL_B3
	return true
}

proc update_PARAM_VALUE.DATA_CTL_B4 { PARAM_VALUE.DATA_CTL_B4 } {
	# Procedure called to update DATA_CTL_B4 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_CTL_B4 { PARAM_VALUE.DATA_CTL_B4 } {
	# Procedure called to validate DATA_CTL_B4
	return true
}

proc update_PARAM_VALUE.DATA_IO_IDLE_PWRDWN { PARAM_VALUE.DATA_IO_IDLE_PWRDWN } {
	# Procedure called to update DATA_IO_IDLE_PWRDWN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_IO_IDLE_PWRDWN { PARAM_VALUE.DATA_IO_IDLE_PWRDWN } {
	# Procedure called to validate DATA_IO_IDLE_PWRDWN
	return true
}

proc update_PARAM_VALUE.DATA_IO_PRIM_TYPE { PARAM_VALUE.DATA_IO_PRIM_TYPE } {
	# Procedure called to update DATA_IO_PRIM_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_IO_PRIM_TYPE { PARAM_VALUE.DATA_IO_PRIM_TYPE } {
	# Procedure called to validate DATA_IO_PRIM_TYPE
	return true
}

proc update_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to update DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DATA_WIDTH { PARAM_VALUE.DATA_WIDTH } {
	# Procedure called to validate DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.DEBUG_PORT { PARAM_VALUE.DEBUG_PORT } {
	# Procedure called to update DEBUG_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DEBUG_PORT { PARAM_VALUE.DEBUG_PORT } {
	# Procedure called to validate DEBUG_PORT
	return true
}

proc update_PARAM_VALUE.DIFF_TERM_REFCLK { PARAM_VALUE.DIFF_TERM_REFCLK } {
	# Procedure called to update DIFF_TERM_REFCLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIFF_TERM_REFCLK { PARAM_VALUE.DIFF_TERM_REFCLK } {
	# Procedure called to validate DIFF_TERM_REFCLK
	return true
}

proc update_PARAM_VALUE.DIFF_TERM_SYSCLK { PARAM_VALUE.DIFF_TERM_SYSCLK } {
	# Procedure called to update DIFF_TERM_SYSCLK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIFF_TERM_SYSCLK { PARAM_VALUE.DIFF_TERM_SYSCLK } {
	# Procedure called to validate DIFF_TERM_SYSCLK
	return true
}

proc update_PARAM_VALUE.DIVCLK_DIVIDE { PARAM_VALUE.DIVCLK_DIVIDE } {
	# Procedure called to update DIVCLK_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DIVCLK_DIVIDE { PARAM_VALUE.DIVCLK_DIVIDE } {
	# Procedure called to validate DIVCLK_DIVIDE
	return true
}

proc update_PARAM_VALUE.DM_WIDTH { PARAM_VALUE.DM_WIDTH } {
	# Procedure called to update DM_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DM_WIDTH { PARAM_VALUE.DM_WIDTH } {
	# Procedure called to validate DM_WIDTH
	return true
}

proc update_PARAM_VALUE.DQS_BYTE_MAP { PARAM_VALUE.DQS_BYTE_MAP } {
	# Procedure called to update DQS_BYTE_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.DQS_BYTE_MAP { PARAM_VALUE.DQS_BYTE_MAP } {
	# Procedure called to validate DQS_BYTE_MAP
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

proc update_PARAM_VALUE.FINE_PER_BIT { PARAM_VALUE.FINE_PER_BIT } {
	# Procedure called to update FINE_PER_BIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FINE_PER_BIT { PARAM_VALUE.FINE_PER_BIT } {
	# Procedure called to validate FINE_PER_BIT
	return true
}

proc update_PARAM_VALUE.FPGA_SPEED_GRADE { PARAM_VALUE.FPGA_SPEED_GRADE } {
	# Procedure called to update FPGA_SPEED_GRADE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FPGA_SPEED_GRADE { PARAM_VALUE.FPGA_SPEED_GRADE } {
	# Procedure called to validate FPGA_SPEED_GRADE
	return true
}

proc update_PARAM_VALUE.FPGA_VOLT_TYPE { PARAM_VALUE.FPGA_VOLT_TYPE } {
	# Procedure called to update FPGA_VOLT_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.FPGA_VOLT_TYPE { PARAM_VALUE.FPGA_VOLT_TYPE } {
	# Procedure called to validate FPGA_VOLT_TYPE
	return true
}

proc update_PARAM_VALUE.IBUF_LPWR_MODE { PARAM_VALUE.IBUF_LPWR_MODE } {
	# Procedure called to update IBUF_LPWR_MODE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IBUF_LPWR_MODE { PARAM_VALUE.IBUF_LPWR_MODE } {
	# Procedure called to validate IBUF_LPWR_MODE
	return true
}

proc update_PARAM_VALUE.IDELAY_ADJ { PARAM_VALUE.IDELAY_ADJ } {
	# Procedure called to update IDELAY_ADJ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IDELAY_ADJ { PARAM_VALUE.IDELAY_ADJ } {
	# Procedure called to validate IDELAY_ADJ
	return true
}

proc update_PARAM_VALUE.IODELAY_GRP0 { PARAM_VALUE.IODELAY_GRP0 } {
	# Procedure called to update IODELAY_GRP0 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IODELAY_GRP0 { PARAM_VALUE.IODELAY_GRP0 } {
	# Procedure called to validate IODELAY_GRP0
	return true
}

proc update_PARAM_VALUE.IODELAY_GRP1 { PARAM_VALUE.IODELAY_GRP1 } {
	# Procedure called to update IODELAY_GRP1 when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IODELAY_GRP1 { PARAM_VALUE.IODELAY_GRP1 } {
	# Procedure called to validate IODELAY_GRP1
	return true
}

proc update_PARAM_VALUE.IS_CLK_SHARED { PARAM_VALUE.IS_CLK_SHARED } {
	# Procedure called to update IS_CLK_SHARED when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.IS_CLK_SHARED { PARAM_VALUE.IS_CLK_SHARED } {
	# Procedure called to validate IS_CLK_SHARED
	return true
}

proc update_PARAM_VALUE.MASK0_MAP { PARAM_VALUE.MASK0_MAP } {
	# Procedure called to update MASK0_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MASK0_MAP { PARAM_VALUE.MASK0_MAP } {
	# Procedure called to validate MASK0_MAP
	return true
}

proc update_PARAM_VALUE.MASK1_MAP { PARAM_VALUE.MASK1_MAP } {
	# Procedure called to update MASK1_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MASK1_MAP { PARAM_VALUE.MASK1_MAP } {
	# Procedure called to validate MASK1_MAP
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

proc update_PARAM_VALUE.MMCM_CLKOUT0_DIVIDE { PARAM_VALUE.MMCM_CLKOUT0_DIVIDE } {
	# Procedure called to update MMCM_CLKOUT0_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT0_DIVIDE { PARAM_VALUE.MMCM_CLKOUT0_DIVIDE } {
	# Procedure called to validate MMCM_CLKOUT0_DIVIDE
	return true
}

proc update_PARAM_VALUE.MMCM_CLKOUT0_EN { PARAM_VALUE.MMCM_CLKOUT0_EN } {
	# Procedure called to update MMCM_CLKOUT0_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT0_EN { PARAM_VALUE.MMCM_CLKOUT0_EN } {
	# Procedure called to validate MMCM_CLKOUT0_EN
	return true
}

proc update_PARAM_VALUE.MMCM_CLKOUT1_DIVIDE { PARAM_VALUE.MMCM_CLKOUT1_DIVIDE } {
	# Procedure called to update MMCM_CLKOUT1_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT1_DIVIDE { PARAM_VALUE.MMCM_CLKOUT1_DIVIDE } {
	# Procedure called to validate MMCM_CLKOUT1_DIVIDE
	return true
}

proc update_PARAM_VALUE.MMCM_CLKOUT1_EN { PARAM_VALUE.MMCM_CLKOUT1_EN } {
	# Procedure called to update MMCM_CLKOUT1_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT1_EN { PARAM_VALUE.MMCM_CLKOUT1_EN } {
	# Procedure called to validate MMCM_CLKOUT1_EN
	return true
}

proc update_PARAM_VALUE.MMCM_CLKOUT2_DIVIDE { PARAM_VALUE.MMCM_CLKOUT2_DIVIDE } {
	# Procedure called to update MMCM_CLKOUT2_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT2_DIVIDE { PARAM_VALUE.MMCM_CLKOUT2_DIVIDE } {
	# Procedure called to validate MMCM_CLKOUT2_DIVIDE
	return true
}

proc update_PARAM_VALUE.MMCM_CLKOUT2_EN { PARAM_VALUE.MMCM_CLKOUT2_EN } {
	# Procedure called to update MMCM_CLKOUT2_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT2_EN { PARAM_VALUE.MMCM_CLKOUT2_EN } {
	# Procedure called to validate MMCM_CLKOUT2_EN
	return true
}

proc update_PARAM_VALUE.MMCM_CLKOUT3_DIVIDE { PARAM_VALUE.MMCM_CLKOUT3_DIVIDE } {
	# Procedure called to update MMCM_CLKOUT3_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT3_DIVIDE { PARAM_VALUE.MMCM_CLKOUT3_DIVIDE } {
	# Procedure called to validate MMCM_CLKOUT3_DIVIDE
	return true
}

proc update_PARAM_VALUE.MMCM_CLKOUT3_EN { PARAM_VALUE.MMCM_CLKOUT3_EN } {
	# Procedure called to update MMCM_CLKOUT3_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT3_EN { PARAM_VALUE.MMCM_CLKOUT3_EN } {
	# Procedure called to validate MMCM_CLKOUT3_EN
	return true
}

proc update_PARAM_VALUE.MMCM_CLKOUT4_DIVIDE { PARAM_VALUE.MMCM_CLKOUT4_DIVIDE } {
	# Procedure called to update MMCM_CLKOUT4_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT4_DIVIDE { PARAM_VALUE.MMCM_CLKOUT4_DIVIDE } {
	# Procedure called to validate MMCM_CLKOUT4_DIVIDE
	return true
}

proc update_PARAM_VALUE.MMCM_CLKOUT4_EN { PARAM_VALUE.MMCM_CLKOUT4_EN } {
	# Procedure called to update MMCM_CLKOUT4_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_CLKOUT4_EN { PARAM_VALUE.MMCM_CLKOUT4_EN } {
	# Procedure called to validate MMCM_CLKOUT4_EN
	return true
}

proc update_PARAM_VALUE.MMCM_DIVCLK_DIVIDE { PARAM_VALUE.MMCM_DIVCLK_DIVIDE } {
	# Procedure called to update MMCM_DIVCLK_DIVIDE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_DIVCLK_DIVIDE { PARAM_VALUE.MMCM_DIVCLK_DIVIDE } {
	# Procedure called to validate MMCM_DIVCLK_DIVIDE
	return true
}

proc update_PARAM_VALUE.MMCM_MULT_F { PARAM_VALUE.MMCM_MULT_F } {
	# Procedure called to update MMCM_MULT_F when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_MULT_F { PARAM_VALUE.MMCM_MULT_F } {
	# Procedure called to validate MMCM_MULT_F
	return true
}

proc update_PARAM_VALUE.MMCM_VCO { PARAM_VALUE.MMCM_VCO } {
	# Procedure called to update MMCM_VCO when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.MMCM_VCO { PARAM_VALUE.MMCM_VCO } {
	# Procedure called to validate MMCM_VCO
	return true
}

proc update_PARAM_VALUE.ODT_MAP { PARAM_VALUE.ODT_MAP } {
	# Procedure called to update ODT_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.ODT_MAP { PARAM_VALUE.ODT_MAP } {
	# Procedure called to validate ODT_MAP
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

proc update_PARAM_VALUE.OUTPUT_DRV { PARAM_VALUE.OUTPUT_DRV } {
	# Procedure called to update OUTPUT_DRV when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.OUTPUT_DRV { PARAM_VALUE.OUTPUT_DRV } {
	# Procedure called to validate OUTPUT_DRV
	return true
}

proc update_PARAM_VALUE.PARITY_MAP { PARAM_VALUE.PARITY_MAP } {
	# Procedure called to update PARITY_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PARITY_MAP { PARAM_VALUE.PARITY_MAP } {
	# Procedure called to validate PARITY_MAP
	return true
}

proc update_PARAM_VALUE.PAYLOAD_WIDTH { PARAM_VALUE.PAYLOAD_WIDTH } {
	# Procedure called to update PAYLOAD_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PAYLOAD_WIDTH { PARAM_VALUE.PAYLOAD_WIDTH } {
	# Procedure called to validate PAYLOAD_WIDTH
	return true
}

proc update_PARAM_VALUE.PHY_0_BITLANES { PARAM_VALUE.PHY_0_BITLANES } {
	# Procedure called to update PHY_0_BITLANES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PHY_0_BITLANES { PARAM_VALUE.PHY_0_BITLANES } {
	# Procedure called to validate PHY_0_BITLANES
	return true
}

proc update_PARAM_VALUE.PHY_1_BITLANES { PARAM_VALUE.PHY_1_BITLANES } {
	# Procedure called to update PHY_1_BITLANES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PHY_1_BITLANES { PARAM_VALUE.PHY_1_BITLANES } {
	# Procedure called to validate PHY_1_BITLANES
	return true
}

proc update_PARAM_VALUE.PHY_2_BITLANES { PARAM_VALUE.PHY_2_BITLANES } {
	# Procedure called to update PHY_2_BITLANES when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PHY_2_BITLANES { PARAM_VALUE.PHY_2_BITLANES } {
	# Procedure called to validate PHY_2_BITLANES
	return true
}

proc update_PARAM_VALUE.PHY_CONTROL_MASTER_BANK { PARAM_VALUE.PHY_CONTROL_MASTER_BANK } {
	# Procedure called to update PHY_CONTROL_MASTER_BANK when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PHY_CONTROL_MASTER_BANK { PARAM_VALUE.PHY_CONTROL_MASTER_BANK } {
	# Procedure called to validate PHY_CONTROL_MASTER_BANK
	return true
}

proc update_PARAM_VALUE.PI_VAL_ADJ { PARAM_VALUE.PI_VAL_ADJ } {
	# Procedure called to update PI_VAL_ADJ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.PI_VAL_ADJ { PARAM_VALUE.PI_VAL_ADJ } {
	# Procedure called to validate PI_VAL_ADJ
	return true
}

proc update_PARAM_VALUE.RANKS { PARAM_VALUE.RANKS } {
	# Procedure called to update RANKS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RANKS { PARAM_VALUE.RANKS } {
	# Procedure called to validate RANKS
	return true
}

proc update_PARAM_VALUE.RAS_MAP { PARAM_VALUE.RAS_MAP } {
	# Procedure called to update RAS_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RAS_MAP { PARAM_VALUE.RAS_MAP } {
	# Procedure called to validate RAS_MAP
	return true
}

proc update_PARAM_VALUE.REFCLK_FREQ { PARAM_VALUE.REFCLK_FREQ } {
	# Procedure called to update REFCLK_FREQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REFCLK_FREQ { PARAM_VALUE.REFCLK_FREQ } {
	# Procedure called to validate REFCLK_FREQ
	return true
}

proc update_PARAM_VALUE.REFCLK_TYPE { PARAM_VALUE.REFCLK_TYPE } {
	# Procedure called to update REFCLK_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REFCLK_TYPE { PARAM_VALUE.REFCLK_TYPE } {
	# Procedure called to validate REFCLK_TYPE
	return true
}

proc update_PARAM_VALUE.REF_CLK_MMCM_IODELAY_CTRL { PARAM_VALUE.REF_CLK_MMCM_IODELAY_CTRL } {
	# Procedure called to update REF_CLK_MMCM_IODELAY_CTRL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REF_CLK_MMCM_IODELAY_CTRL { PARAM_VALUE.REF_CLK_MMCM_IODELAY_CTRL } {
	# Procedure called to validate REF_CLK_MMCM_IODELAY_CTRL
	return true
}

proc update_PARAM_VALUE.REG_CTRL { PARAM_VALUE.REG_CTRL } {
	# Procedure called to update REG_CTRL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.REG_CTRL { PARAM_VALUE.REG_CTRL } {
	# Procedure called to validate REG_CTRL
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

proc update_PARAM_VALUE.RTT_NOM { PARAM_VALUE.RTT_NOM } {
	# Procedure called to update RTT_NOM when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RTT_NOM { PARAM_VALUE.RTT_NOM } {
	# Procedure called to validate RTT_NOM
	return true
}

proc update_PARAM_VALUE.RTT_WR { PARAM_VALUE.RTT_WR } {
	# Procedure called to update RTT_WR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.RTT_WR { PARAM_VALUE.RTT_WR } {
	# Procedure called to validate RTT_WR
	return true
}

proc update_PARAM_VALUE.SIMULATION { PARAM_VALUE.SIMULATION } {
	# Procedure called to update SIMULATION when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIMULATION { PARAM_VALUE.SIMULATION } {
	# Procedure called to validate SIMULATION
	return true
}

proc update_PARAM_VALUE.SIM_BYPASS_INIT_CAL { PARAM_VALUE.SIM_BYPASS_INIT_CAL } {
	# Procedure called to update SIM_BYPASS_INIT_CAL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SIM_BYPASS_INIT_CAL { PARAM_VALUE.SIM_BYPASS_INIT_CAL } {
	# Procedure called to validate SIM_BYPASS_INIT_CAL
	return true
}

proc update_PARAM_VALUE.SLOT_0_CONFIG { PARAM_VALUE.SLOT_0_CONFIG } {
	# Procedure called to update SLOT_0_CONFIG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SLOT_0_CONFIG { PARAM_VALUE.SLOT_0_CONFIG } {
	# Procedure called to validate SLOT_0_CONFIG
	return true
}

proc update_PARAM_VALUE.SLOT_1_CONFIG { PARAM_VALUE.SLOT_1_CONFIG } {
	# Procedure called to update SLOT_1_CONFIG when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SLOT_1_CONFIG { PARAM_VALUE.SLOT_1_CONFIG } {
	# Procedure called to validate SLOT_1_CONFIG
	return true
}

proc update_PARAM_VALUE.STARVE_LIMIT { PARAM_VALUE.STARVE_LIMIT } {
	# Procedure called to update STARVE_LIMIT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.STARVE_LIMIT { PARAM_VALUE.STARVE_LIMIT } {
	# Procedure called to validate STARVE_LIMIT
	return true
}

proc update_PARAM_VALUE.SYSCLK_TYPE { PARAM_VALUE.SYSCLK_TYPE } {
	# Procedure called to update SYSCLK_TYPE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYSCLK_TYPE { PARAM_VALUE.SYSCLK_TYPE } {
	# Procedure called to validate SYSCLK_TYPE
	return true
}

proc update_PARAM_VALUE.SYS_RST_PORT { PARAM_VALUE.SYS_RST_PORT } {
	# Procedure called to update SYS_RST_PORT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.SYS_RST_PORT { PARAM_VALUE.SYS_RST_PORT } {
	# Procedure called to validate SYS_RST_PORT
	return true
}

proc update_PARAM_VALUE.TCQ { PARAM_VALUE.TCQ } {
	# Procedure called to update TCQ when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TCQ { PARAM_VALUE.TCQ } {
	# Procedure called to validate TCQ
	return true
}

proc update_PARAM_VALUE.TEMP_MON_CONTROL { PARAM_VALUE.TEMP_MON_CONTROL } {
	# Procedure called to update TEMP_MON_CONTROL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TEMP_MON_CONTROL { PARAM_VALUE.TEMP_MON_CONTROL } {
	# Procedure called to validate TEMP_MON_CONTROL
	return true
}

proc update_PARAM_VALUE.TEMP_MON_EN { PARAM_VALUE.TEMP_MON_EN } {
	# Procedure called to update TEMP_MON_EN when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.TEMP_MON_EN { PARAM_VALUE.TEMP_MON_EN } {
	# Procedure called to validate TEMP_MON_EN
	return true
}

proc update_PARAM_VALUE.UI_EXTRA_CLOCKS { PARAM_VALUE.UI_EXTRA_CLOCKS } {
	# Procedure called to update UI_EXTRA_CLOCKS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.UI_EXTRA_CLOCKS { PARAM_VALUE.UI_EXTRA_CLOCKS } {
	# Procedure called to validate UI_EXTRA_CLOCKS
	return true
}

proc update_PARAM_VALUE.USER_REFRESH { PARAM_VALUE.USER_REFRESH } {
	# Procedure called to update USER_REFRESH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.USER_REFRESH { PARAM_VALUE.USER_REFRESH } {
	# Procedure called to validate USER_REFRESH
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

proc update_PARAM_VALUE.VDD_OP_VOLT { PARAM_VALUE.VDD_OP_VOLT } {
	# Procedure called to update VDD_OP_VOLT when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.VDD_OP_VOLT { PARAM_VALUE.VDD_OP_VOLT } {
	# Procedure called to validate VDD_OP_VOLT
	return true
}

proc update_PARAM_VALUE.WE_MAP { PARAM_VALUE.WE_MAP } {
	# Procedure called to update WE_MAP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WE_MAP { PARAM_VALUE.WE_MAP } {
	# Procedure called to validate WE_MAP
	return true
}

proc update_PARAM_VALUE.WRLVL { PARAM_VALUE.WRLVL } {
	# Procedure called to update WRLVL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.WRLVL { PARAM_VALUE.WRLVL } {
	# Procedure called to validate WRLVL
	return true
}

proc update_PARAM_VALUE.nAL { PARAM_VALUE.nAL } {
	# Procedure called to update nAL when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.nAL { PARAM_VALUE.nAL } {
	# Procedure called to validate nAL
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

proc update_PARAM_VALUE.tCKE { PARAM_VALUE.tCKE } {
	# Procedure called to update tCKE when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tCKE { PARAM_VALUE.tCKE } {
	# Procedure called to validate tCKE
	return true
}

proc update_PARAM_VALUE.tFAW { PARAM_VALUE.tFAW } {
	# Procedure called to update tFAW when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tFAW { PARAM_VALUE.tFAW } {
	# Procedure called to validate tFAW
	return true
}

proc update_PARAM_VALUE.tPRDI { PARAM_VALUE.tPRDI } {
	# Procedure called to update tPRDI when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tPRDI { PARAM_VALUE.tPRDI } {
	# Procedure called to validate tPRDI
	return true
}

proc update_PARAM_VALUE.tRAS { PARAM_VALUE.tRAS } {
	# Procedure called to update tRAS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tRAS { PARAM_VALUE.tRAS } {
	# Procedure called to validate tRAS
	return true
}

proc update_PARAM_VALUE.tRCD { PARAM_VALUE.tRCD } {
	# Procedure called to update tRCD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tRCD { PARAM_VALUE.tRCD } {
	# Procedure called to validate tRCD
	return true
}

proc update_PARAM_VALUE.tREFI { PARAM_VALUE.tREFI } {
	# Procedure called to update tREFI when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tREFI { PARAM_VALUE.tREFI } {
	# Procedure called to validate tREFI
	return true
}

proc update_PARAM_VALUE.tRFC { PARAM_VALUE.tRFC } {
	# Procedure called to update tRFC when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tRFC { PARAM_VALUE.tRFC } {
	# Procedure called to validate tRFC
	return true
}

proc update_PARAM_VALUE.tRP { PARAM_VALUE.tRP } {
	# Procedure called to update tRP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tRP { PARAM_VALUE.tRP } {
	# Procedure called to validate tRP
	return true
}

proc update_PARAM_VALUE.tRRD { PARAM_VALUE.tRRD } {
	# Procedure called to update tRRD when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tRRD { PARAM_VALUE.tRRD } {
	# Procedure called to validate tRRD
	return true
}

proc update_PARAM_VALUE.tRTP { PARAM_VALUE.tRTP } {
	# Procedure called to update tRTP when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tRTP { PARAM_VALUE.tRTP } {
	# Procedure called to validate tRTP
	return true
}

proc update_PARAM_VALUE.tWTR { PARAM_VALUE.tWTR } {
	# Procedure called to update tWTR when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tWTR { PARAM_VALUE.tWTR } {
	# Procedure called to validate tWTR
	return true
}

proc update_PARAM_VALUE.tZQCS { PARAM_VALUE.tZQCS } {
	# Procedure called to update tZQCS when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tZQCS { PARAM_VALUE.tZQCS } {
	# Procedure called to validate tZQCS
	return true
}

proc update_PARAM_VALUE.tZQI { PARAM_VALUE.tZQI } {
	# Procedure called to update tZQI when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.tZQI { PARAM_VALUE.tZQI } {
	# Procedure called to validate tZQI
	return true
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

proc update_MODELPARAM_VALUE.IS_CLK_SHARED { MODELPARAM_VALUE.IS_CLK_SHARED PARAM_VALUE.IS_CLK_SHARED } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IS_CLK_SHARED}] ${MODELPARAM_VALUE.IS_CLK_SHARED}
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

proc update_MODELPARAM_VALUE.AL { MODELPARAM_VALUE.AL PARAM_VALUE.AL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AL}] ${MODELPARAM_VALUE.AL}
}

proc update_MODELPARAM_VALUE.nAL { MODELPARAM_VALUE.nAL PARAM_VALUE.nAL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.nAL}] ${MODELPARAM_VALUE.nAL}
}

proc update_MODELPARAM_VALUE.BURST_MODE { MODELPARAM_VALUE.BURST_MODE PARAM_VALUE.BURST_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BURST_MODE}] ${MODELPARAM_VALUE.BURST_MODE}
}

proc update_MODELPARAM_VALUE.BURST_TYPE { MODELPARAM_VALUE.BURST_TYPE PARAM_VALUE.BURST_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BURST_TYPE}] ${MODELPARAM_VALUE.BURST_TYPE}
}

proc update_MODELPARAM_VALUE.CL { MODELPARAM_VALUE.CL PARAM_VALUE.CL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CL}] ${MODELPARAM_VALUE.CL}
}

proc update_MODELPARAM_VALUE.CWL { MODELPARAM_VALUE.CWL PARAM_VALUE.CWL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CWL}] ${MODELPARAM_VALUE.CWL}
}

proc update_MODELPARAM_VALUE.OUTPUT_DRV { MODELPARAM_VALUE.OUTPUT_DRV PARAM_VALUE.OUTPUT_DRV } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.OUTPUT_DRV}] ${MODELPARAM_VALUE.OUTPUT_DRV}
}

proc update_MODELPARAM_VALUE.RTT_NOM { MODELPARAM_VALUE.RTT_NOM PARAM_VALUE.RTT_NOM } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RTT_NOM}] ${MODELPARAM_VALUE.RTT_NOM}
}

proc update_MODELPARAM_VALUE.RTT_WR { MODELPARAM_VALUE.RTT_WR PARAM_VALUE.RTT_WR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RTT_WR}] ${MODELPARAM_VALUE.RTT_WR}
}

proc update_MODELPARAM_VALUE.ADDR_CMD_MODE { MODELPARAM_VALUE.ADDR_CMD_MODE PARAM_VALUE.ADDR_CMD_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_CMD_MODE}] ${MODELPARAM_VALUE.ADDR_CMD_MODE}
}

proc update_MODELPARAM_VALUE.REG_CTRL { MODELPARAM_VALUE.REG_CTRL PARAM_VALUE.REG_CTRL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REG_CTRL}] ${MODELPARAM_VALUE.REG_CTRL}
}

proc update_MODELPARAM_VALUE.CA_MIRROR { MODELPARAM_VALUE.CA_MIRROR PARAM_VALUE.CA_MIRROR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CA_MIRROR}] ${MODELPARAM_VALUE.CA_MIRROR}
}

proc update_MODELPARAM_VALUE.VDD_OP_VOLT { MODELPARAM_VALUE.VDD_OP_VOLT PARAM_VALUE.VDD_OP_VOLT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.VDD_OP_VOLT}] ${MODELPARAM_VALUE.VDD_OP_VOLT}
}

proc update_MODELPARAM_VALUE.CLKIN_PERIOD { MODELPARAM_VALUE.CLKIN_PERIOD PARAM_VALUE.CLKIN_PERIOD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLKIN_PERIOD}] ${MODELPARAM_VALUE.CLKIN_PERIOD}
}

proc update_MODELPARAM_VALUE.CLKFBOUT_MULT { MODELPARAM_VALUE.CLKFBOUT_MULT PARAM_VALUE.CLKFBOUT_MULT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLKFBOUT_MULT}] ${MODELPARAM_VALUE.CLKFBOUT_MULT}
}

proc update_MODELPARAM_VALUE.DIVCLK_DIVIDE { MODELPARAM_VALUE.DIVCLK_DIVIDE PARAM_VALUE.DIVCLK_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIVCLK_DIVIDE}] ${MODELPARAM_VALUE.DIVCLK_DIVIDE}
}

proc update_MODELPARAM_VALUE.CLKOUT0_PHASE { MODELPARAM_VALUE.CLKOUT0_PHASE PARAM_VALUE.CLKOUT0_PHASE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLKOUT0_PHASE}] ${MODELPARAM_VALUE.CLKOUT0_PHASE}
}

proc update_MODELPARAM_VALUE.CLKOUT0_DIVIDE { MODELPARAM_VALUE.CLKOUT0_DIVIDE PARAM_VALUE.CLKOUT0_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLKOUT0_DIVIDE}] ${MODELPARAM_VALUE.CLKOUT0_DIVIDE}
}

proc update_MODELPARAM_VALUE.CLKOUT1_DIVIDE { MODELPARAM_VALUE.CLKOUT1_DIVIDE PARAM_VALUE.CLKOUT1_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLKOUT1_DIVIDE}] ${MODELPARAM_VALUE.CLKOUT1_DIVIDE}
}

proc update_MODELPARAM_VALUE.CLKOUT2_DIVIDE { MODELPARAM_VALUE.CLKOUT2_DIVIDE PARAM_VALUE.CLKOUT2_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLKOUT2_DIVIDE}] ${MODELPARAM_VALUE.CLKOUT2_DIVIDE}
}

proc update_MODELPARAM_VALUE.CLKOUT3_DIVIDE { MODELPARAM_VALUE.CLKOUT3_DIVIDE PARAM_VALUE.CLKOUT3_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CLKOUT3_DIVIDE}] ${MODELPARAM_VALUE.CLKOUT3_DIVIDE}
}

proc update_MODELPARAM_VALUE.MMCM_VCO { MODELPARAM_VALUE.MMCM_VCO PARAM_VALUE.MMCM_VCO } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_VCO}] ${MODELPARAM_VALUE.MMCM_VCO}
}

proc update_MODELPARAM_VALUE.MMCM_MULT_F { MODELPARAM_VALUE.MMCM_MULT_F PARAM_VALUE.MMCM_MULT_F } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_MULT_F}] ${MODELPARAM_VALUE.MMCM_MULT_F}
}

proc update_MODELPARAM_VALUE.MMCM_DIVCLK_DIVIDE { MODELPARAM_VALUE.MMCM_DIVCLK_DIVIDE PARAM_VALUE.MMCM_DIVCLK_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_DIVCLK_DIVIDE}] ${MODELPARAM_VALUE.MMCM_DIVCLK_DIVIDE}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT0_EN { MODELPARAM_VALUE.MMCM_CLKOUT0_EN PARAM_VALUE.MMCM_CLKOUT0_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT0_EN}] ${MODELPARAM_VALUE.MMCM_CLKOUT0_EN}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT1_EN { MODELPARAM_VALUE.MMCM_CLKOUT1_EN PARAM_VALUE.MMCM_CLKOUT1_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT1_EN}] ${MODELPARAM_VALUE.MMCM_CLKOUT1_EN}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT2_EN { MODELPARAM_VALUE.MMCM_CLKOUT2_EN PARAM_VALUE.MMCM_CLKOUT2_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT2_EN}] ${MODELPARAM_VALUE.MMCM_CLKOUT2_EN}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT3_EN { MODELPARAM_VALUE.MMCM_CLKOUT3_EN PARAM_VALUE.MMCM_CLKOUT3_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT3_EN}] ${MODELPARAM_VALUE.MMCM_CLKOUT3_EN}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT4_EN { MODELPARAM_VALUE.MMCM_CLKOUT4_EN PARAM_VALUE.MMCM_CLKOUT4_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT4_EN}] ${MODELPARAM_VALUE.MMCM_CLKOUT4_EN}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT0_DIVIDE { MODELPARAM_VALUE.MMCM_CLKOUT0_DIVIDE PARAM_VALUE.MMCM_CLKOUT0_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT0_DIVIDE}] ${MODELPARAM_VALUE.MMCM_CLKOUT0_DIVIDE}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT1_DIVIDE { MODELPARAM_VALUE.MMCM_CLKOUT1_DIVIDE PARAM_VALUE.MMCM_CLKOUT1_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT1_DIVIDE}] ${MODELPARAM_VALUE.MMCM_CLKOUT1_DIVIDE}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT2_DIVIDE { MODELPARAM_VALUE.MMCM_CLKOUT2_DIVIDE PARAM_VALUE.MMCM_CLKOUT2_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT2_DIVIDE}] ${MODELPARAM_VALUE.MMCM_CLKOUT2_DIVIDE}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT3_DIVIDE { MODELPARAM_VALUE.MMCM_CLKOUT3_DIVIDE PARAM_VALUE.MMCM_CLKOUT3_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT3_DIVIDE}] ${MODELPARAM_VALUE.MMCM_CLKOUT3_DIVIDE}
}

proc update_MODELPARAM_VALUE.MMCM_CLKOUT4_DIVIDE { MODELPARAM_VALUE.MMCM_CLKOUT4_DIVIDE PARAM_VALUE.MMCM_CLKOUT4_DIVIDE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MMCM_CLKOUT4_DIVIDE}] ${MODELPARAM_VALUE.MMCM_CLKOUT4_DIVIDE}
}

proc update_MODELPARAM_VALUE.tCKE { MODELPARAM_VALUE.tCKE PARAM_VALUE.tCKE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tCKE}] ${MODELPARAM_VALUE.tCKE}
}

proc update_MODELPARAM_VALUE.tFAW { MODELPARAM_VALUE.tFAW PARAM_VALUE.tFAW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tFAW}] ${MODELPARAM_VALUE.tFAW}
}

proc update_MODELPARAM_VALUE.tPRDI { MODELPARAM_VALUE.tPRDI PARAM_VALUE.tPRDI } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tPRDI}] ${MODELPARAM_VALUE.tPRDI}
}

proc update_MODELPARAM_VALUE.tRAS { MODELPARAM_VALUE.tRAS PARAM_VALUE.tRAS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tRAS}] ${MODELPARAM_VALUE.tRAS}
}

proc update_MODELPARAM_VALUE.tRCD { MODELPARAM_VALUE.tRCD PARAM_VALUE.tRCD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tRCD}] ${MODELPARAM_VALUE.tRCD}
}

proc update_MODELPARAM_VALUE.tREFI { MODELPARAM_VALUE.tREFI PARAM_VALUE.tREFI } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tREFI}] ${MODELPARAM_VALUE.tREFI}
}

proc update_MODELPARAM_VALUE.tRFC { MODELPARAM_VALUE.tRFC PARAM_VALUE.tRFC } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tRFC}] ${MODELPARAM_VALUE.tRFC}
}

proc update_MODELPARAM_VALUE.tRP { MODELPARAM_VALUE.tRP PARAM_VALUE.tRP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tRP}] ${MODELPARAM_VALUE.tRP}
}

proc update_MODELPARAM_VALUE.tRRD { MODELPARAM_VALUE.tRRD PARAM_VALUE.tRRD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tRRD}] ${MODELPARAM_VALUE.tRRD}
}

proc update_MODELPARAM_VALUE.tRTP { MODELPARAM_VALUE.tRTP PARAM_VALUE.tRTP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tRTP}] ${MODELPARAM_VALUE.tRTP}
}

proc update_MODELPARAM_VALUE.tWTR { MODELPARAM_VALUE.tWTR PARAM_VALUE.tWTR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tWTR}] ${MODELPARAM_VALUE.tWTR}
}

proc update_MODELPARAM_VALUE.tZQI { MODELPARAM_VALUE.tZQI PARAM_VALUE.tZQI } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tZQI}] ${MODELPARAM_VALUE.tZQI}
}

proc update_MODELPARAM_VALUE.tZQCS { MODELPARAM_VALUE.tZQCS PARAM_VALUE.tZQCS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tZQCS}] ${MODELPARAM_VALUE.tZQCS}
}

proc update_MODELPARAM_VALUE.SIM_BYPASS_INIT_CAL { MODELPARAM_VALUE.SIM_BYPASS_INIT_CAL PARAM_VALUE.SIM_BYPASS_INIT_CAL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIM_BYPASS_INIT_CAL}] ${MODELPARAM_VALUE.SIM_BYPASS_INIT_CAL}
}

proc update_MODELPARAM_VALUE.SIMULATION { MODELPARAM_VALUE.SIMULATION PARAM_VALUE.SIMULATION } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SIMULATION}] ${MODELPARAM_VALUE.SIMULATION}
}

proc update_MODELPARAM_VALUE.BYTE_LANES_B0 { MODELPARAM_VALUE.BYTE_LANES_B0 PARAM_VALUE.BYTE_LANES_B0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BYTE_LANES_B0}] ${MODELPARAM_VALUE.BYTE_LANES_B0}
}

proc update_MODELPARAM_VALUE.BYTE_LANES_B1 { MODELPARAM_VALUE.BYTE_LANES_B1 PARAM_VALUE.BYTE_LANES_B1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BYTE_LANES_B1}] ${MODELPARAM_VALUE.BYTE_LANES_B1}
}

proc update_MODELPARAM_VALUE.BYTE_LANES_B2 { MODELPARAM_VALUE.BYTE_LANES_B2 PARAM_VALUE.BYTE_LANES_B2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BYTE_LANES_B2}] ${MODELPARAM_VALUE.BYTE_LANES_B2}
}

proc update_MODELPARAM_VALUE.BYTE_LANES_B3 { MODELPARAM_VALUE.BYTE_LANES_B3 PARAM_VALUE.BYTE_LANES_B3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BYTE_LANES_B3}] ${MODELPARAM_VALUE.BYTE_LANES_B3}
}

proc update_MODELPARAM_VALUE.BYTE_LANES_B4 { MODELPARAM_VALUE.BYTE_LANES_B4 PARAM_VALUE.BYTE_LANES_B4 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BYTE_LANES_B4}] ${MODELPARAM_VALUE.BYTE_LANES_B4}
}

proc update_MODELPARAM_VALUE.DATA_CTL_B0 { MODELPARAM_VALUE.DATA_CTL_B0 PARAM_VALUE.DATA_CTL_B0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_CTL_B0}] ${MODELPARAM_VALUE.DATA_CTL_B0}
}

proc update_MODELPARAM_VALUE.DATA_CTL_B1 { MODELPARAM_VALUE.DATA_CTL_B1 PARAM_VALUE.DATA_CTL_B1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_CTL_B1}] ${MODELPARAM_VALUE.DATA_CTL_B1}
}

proc update_MODELPARAM_VALUE.DATA_CTL_B2 { MODELPARAM_VALUE.DATA_CTL_B2 PARAM_VALUE.DATA_CTL_B2 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_CTL_B2}] ${MODELPARAM_VALUE.DATA_CTL_B2}
}

proc update_MODELPARAM_VALUE.DATA_CTL_B3 { MODELPARAM_VALUE.DATA_CTL_B3 PARAM_VALUE.DATA_CTL_B3 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_CTL_B3}] ${MODELPARAM_VALUE.DATA_CTL_B3}
}

proc update_MODELPARAM_VALUE.DATA_CTL_B4 { MODELPARAM_VALUE.DATA_CTL_B4 PARAM_VALUE.DATA_CTL_B4 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_CTL_B4}] ${MODELPARAM_VALUE.DATA_CTL_B4}
}

proc update_MODELPARAM_VALUE.PHY_0_BITLANES { MODELPARAM_VALUE.PHY_0_BITLANES PARAM_VALUE.PHY_0_BITLANES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PHY_0_BITLANES}] ${MODELPARAM_VALUE.PHY_0_BITLANES}
}

proc update_MODELPARAM_VALUE.PHY_1_BITLANES { MODELPARAM_VALUE.PHY_1_BITLANES PARAM_VALUE.PHY_1_BITLANES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PHY_1_BITLANES}] ${MODELPARAM_VALUE.PHY_1_BITLANES}
}

proc update_MODELPARAM_VALUE.PHY_2_BITLANES { MODELPARAM_VALUE.PHY_2_BITLANES PARAM_VALUE.PHY_2_BITLANES } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PHY_2_BITLANES}] ${MODELPARAM_VALUE.PHY_2_BITLANES}
}

proc update_MODELPARAM_VALUE.CK_BYTE_MAP { MODELPARAM_VALUE.CK_BYTE_MAP PARAM_VALUE.CK_BYTE_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CK_BYTE_MAP}] ${MODELPARAM_VALUE.CK_BYTE_MAP}
}

proc update_MODELPARAM_VALUE.ADDR_MAP { MODELPARAM_VALUE.ADDR_MAP PARAM_VALUE.ADDR_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ADDR_MAP}] ${MODELPARAM_VALUE.ADDR_MAP}
}

proc update_MODELPARAM_VALUE.BANK_MAP { MODELPARAM_VALUE.BANK_MAP PARAM_VALUE.BANK_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BANK_MAP}] ${MODELPARAM_VALUE.BANK_MAP}
}

proc update_MODELPARAM_VALUE.CAS_MAP { MODELPARAM_VALUE.CAS_MAP PARAM_VALUE.CAS_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CAS_MAP}] ${MODELPARAM_VALUE.CAS_MAP}
}

proc update_MODELPARAM_VALUE.CKE_ODT_BYTE_MAP { MODELPARAM_VALUE.CKE_ODT_BYTE_MAP PARAM_VALUE.CKE_ODT_BYTE_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CKE_ODT_BYTE_MAP}] ${MODELPARAM_VALUE.CKE_ODT_BYTE_MAP}
}

proc update_MODELPARAM_VALUE.CKE_MAP { MODELPARAM_VALUE.CKE_MAP PARAM_VALUE.CKE_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CKE_MAP}] ${MODELPARAM_VALUE.CKE_MAP}
}

proc update_MODELPARAM_VALUE.ODT_MAP { MODELPARAM_VALUE.ODT_MAP PARAM_VALUE.ODT_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ODT_MAP}] ${MODELPARAM_VALUE.ODT_MAP}
}

proc update_MODELPARAM_VALUE.CS_MAP { MODELPARAM_VALUE.CS_MAP PARAM_VALUE.CS_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CS_MAP}] ${MODELPARAM_VALUE.CS_MAP}
}

proc update_MODELPARAM_VALUE.PARITY_MAP { MODELPARAM_VALUE.PARITY_MAP PARAM_VALUE.PARITY_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PARITY_MAP}] ${MODELPARAM_VALUE.PARITY_MAP}
}

proc update_MODELPARAM_VALUE.RAS_MAP { MODELPARAM_VALUE.RAS_MAP PARAM_VALUE.RAS_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RAS_MAP}] ${MODELPARAM_VALUE.RAS_MAP}
}

proc update_MODELPARAM_VALUE.WE_MAP { MODELPARAM_VALUE.WE_MAP PARAM_VALUE.WE_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WE_MAP}] ${MODELPARAM_VALUE.WE_MAP}
}

proc update_MODELPARAM_VALUE.DQS_BYTE_MAP { MODELPARAM_VALUE.DQS_BYTE_MAP PARAM_VALUE.DQS_BYTE_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DQS_BYTE_MAP}] ${MODELPARAM_VALUE.DQS_BYTE_MAP}
}

proc update_MODELPARAM_VALUE.DATA0_MAP { MODELPARAM_VALUE.DATA0_MAP PARAM_VALUE.DATA0_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA0_MAP}] ${MODELPARAM_VALUE.DATA0_MAP}
}

proc update_MODELPARAM_VALUE.DATA1_MAP { MODELPARAM_VALUE.DATA1_MAP PARAM_VALUE.DATA1_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA1_MAP}] ${MODELPARAM_VALUE.DATA1_MAP}
}

proc update_MODELPARAM_VALUE.DATA2_MAP { MODELPARAM_VALUE.DATA2_MAP PARAM_VALUE.DATA2_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA2_MAP}] ${MODELPARAM_VALUE.DATA2_MAP}
}

proc update_MODELPARAM_VALUE.DATA3_MAP { MODELPARAM_VALUE.DATA3_MAP PARAM_VALUE.DATA3_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA3_MAP}] ${MODELPARAM_VALUE.DATA3_MAP}
}

proc update_MODELPARAM_VALUE.DATA4_MAP { MODELPARAM_VALUE.DATA4_MAP PARAM_VALUE.DATA4_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA4_MAP}] ${MODELPARAM_VALUE.DATA4_MAP}
}

proc update_MODELPARAM_VALUE.DATA5_MAP { MODELPARAM_VALUE.DATA5_MAP PARAM_VALUE.DATA5_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA5_MAP}] ${MODELPARAM_VALUE.DATA5_MAP}
}

proc update_MODELPARAM_VALUE.DATA6_MAP { MODELPARAM_VALUE.DATA6_MAP PARAM_VALUE.DATA6_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA6_MAP}] ${MODELPARAM_VALUE.DATA6_MAP}
}

proc update_MODELPARAM_VALUE.DATA7_MAP { MODELPARAM_VALUE.DATA7_MAP PARAM_VALUE.DATA7_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA7_MAP}] ${MODELPARAM_VALUE.DATA7_MAP}
}

proc update_MODELPARAM_VALUE.DATA8_MAP { MODELPARAM_VALUE.DATA8_MAP PARAM_VALUE.DATA8_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA8_MAP}] ${MODELPARAM_VALUE.DATA8_MAP}
}

proc update_MODELPARAM_VALUE.DATA9_MAP { MODELPARAM_VALUE.DATA9_MAP PARAM_VALUE.DATA9_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA9_MAP}] ${MODELPARAM_VALUE.DATA9_MAP}
}

proc update_MODELPARAM_VALUE.DATA10_MAP { MODELPARAM_VALUE.DATA10_MAP PARAM_VALUE.DATA10_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA10_MAP}] ${MODELPARAM_VALUE.DATA10_MAP}
}

proc update_MODELPARAM_VALUE.DATA11_MAP { MODELPARAM_VALUE.DATA11_MAP PARAM_VALUE.DATA11_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA11_MAP}] ${MODELPARAM_VALUE.DATA11_MAP}
}

proc update_MODELPARAM_VALUE.DATA12_MAP { MODELPARAM_VALUE.DATA12_MAP PARAM_VALUE.DATA12_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA12_MAP}] ${MODELPARAM_VALUE.DATA12_MAP}
}

proc update_MODELPARAM_VALUE.DATA13_MAP { MODELPARAM_VALUE.DATA13_MAP PARAM_VALUE.DATA13_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA13_MAP}] ${MODELPARAM_VALUE.DATA13_MAP}
}

proc update_MODELPARAM_VALUE.DATA14_MAP { MODELPARAM_VALUE.DATA14_MAP PARAM_VALUE.DATA14_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA14_MAP}] ${MODELPARAM_VALUE.DATA14_MAP}
}

proc update_MODELPARAM_VALUE.DATA15_MAP { MODELPARAM_VALUE.DATA15_MAP PARAM_VALUE.DATA15_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA15_MAP}] ${MODELPARAM_VALUE.DATA15_MAP}
}

proc update_MODELPARAM_VALUE.DATA16_MAP { MODELPARAM_VALUE.DATA16_MAP PARAM_VALUE.DATA16_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA16_MAP}] ${MODELPARAM_VALUE.DATA16_MAP}
}

proc update_MODELPARAM_VALUE.DATA17_MAP { MODELPARAM_VALUE.DATA17_MAP PARAM_VALUE.DATA17_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA17_MAP}] ${MODELPARAM_VALUE.DATA17_MAP}
}

proc update_MODELPARAM_VALUE.MASK0_MAP { MODELPARAM_VALUE.MASK0_MAP PARAM_VALUE.MASK0_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MASK0_MAP}] ${MODELPARAM_VALUE.MASK0_MAP}
}

proc update_MODELPARAM_VALUE.MASK1_MAP { MODELPARAM_VALUE.MASK1_MAP PARAM_VALUE.MASK1_MAP } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.MASK1_MAP}] ${MODELPARAM_VALUE.MASK1_MAP}
}

proc update_MODELPARAM_VALUE.SLOT_0_CONFIG { MODELPARAM_VALUE.SLOT_0_CONFIG PARAM_VALUE.SLOT_0_CONFIG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SLOT_0_CONFIG}] ${MODELPARAM_VALUE.SLOT_0_CONFIG}
}

proc update_MODELPARAM_VALUE.SLOT_1_CONFIG { MODELPARAM_VALUE.SLOT_1_CONFIG PARAM_VALUE.SLOT_1_CONFIG } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SLOT_1_CONFIG}] ${MODELPARAM_VALUE.SLOT_1_CONFIG}
}

proc update_MODELPARAM_VALUE.IBUF_LPWR_MODE { MODELPARAM_VALUE.IBUF_LPWR_MODE PARAM_VALUE.IBUF_LPWR_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IBUF_LPWR_MODE}] ${MODELPARAM_VALUE.IBUF_LPWR_MODE}
}

proc update_MODELPARAM_VALUE.DATA_IO_IDLE_PWRDWN { MODELPARAM_VALUE.DATA_IO_IDLE_PWRDWN PARAM_VALUE.DATA_IO_IDLE_PWRDWN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_IO_IDLE_PWRDWN}] ${MODELPARAM_VALUE.DATA_IO_IDLE_PWRDWN}
}

proc update_MODELPARAM_VALUE.BANK_TYPE { MODELPARAM_VALUE.BANK_TYPE PARAM_VALUE.BANK_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.BANK_TYPE}] ${MODELPARAM_VALUE.BANK_TYPE}
}

proc update_MODELPARAM_VALUE.DATA_IO_PRIM_TYPE { MODELPARAM_VALUE.DATA_IO_PRIM_TYPE PARAM_VALUE.DATA_IO_PRIM_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DATA_IO_PRIM_TYPE}] ${MODELPARAM_VALUE.DATA_IO_PRIM_TYPE}
}

proc update_MODELPARAM_VALUE.CKE_ODT_AUX { MODELPARAM_VALUE.CKE_ODT_AUX PARAM_VALUE.CKE_ODT_AUX } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CKE_ODT_AUX}] ${MODELPARAM_VALUE.CKE_ODT_AUX}
}

proc update_MODELPARAM_VALUE.USER_REFRESH { MODELPARAM_VALUE.USER_REFRESH PARAM_VALUE.USER_REFRESH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.USER_REFRESH}] ${MODELPARAM_VALUE.USER_REFRESH}
}

proc update_MODELPARAM_VALUE.WRLVL { MODELPARAM_VALUE.WRLVL PARAM_VALUE.WRLVL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.WRLVL}] ${MODELPARAM_VALUE.WRLVL}
}

proc update_MODELPARAM_VALUE.ORDERING { MODELPARAM_VALUE.ORDERING PARAM_VALUE.ORDERING } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.ORDERING}] ${MODELPARAM_VALUE.ORDERING}
}

proc update_MODELPARAM_VALUE.CALIB_ROW_ADD { MODELPARAM_VALUE.CALIB_ROW_ADD PARAM_VALUE.CALIB_ROW_ADD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CALIB_ROW_ADD}] ${MODELPARAM_VALUE.CALIB_ROW_ADD}
}

proc update_MODELPARAM_VALUE.CALIB_COL_ADD { MODELPARAM_VALUE.CALIB_COL_ADD PARAM_VALUE.CALIB_COL_ADD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CALIB_COL_ADD}] ${MODELPARAM_VALUE.CALIB_COL_ADD}
}

proc update_MODELPARAM_VALUE.CALIB_BA_ADD { MODELPARAM_VALUE.CALIB_BA_ADD PARAM_VALUE.CALIB_BA_ADD } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CALIB_BA_ADD}] ${MODELPARAM_VALUE.CALIB_BA_ADD}
}

proc update_MODELPARAM_VALUE.TCQ { MODELPARAM_VALUE.TCQ PARAM_VALUE.TCQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TCQ}] ${MODELPARAM_VALUE.TCQ}
}

proc update_MODELPARAM_VALUE.IDELAY_ADJ { MODELPARAM_VALUE.IDELAY_ADJ PARAM_VALUE.IDELAY_ADJ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IDELAY_ADJ}] ${MODELPARAM_VALUE.IDELAY_ADJ}
}

proc update_MODELPARAM_VALUE.FINE_PER_BIT { MODELPARAM_VALUE.FINE_PER_BIT PARAM_VALUE.FINE_PER_BIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FINE_PER_BIT}] ${MODELPARAM_VALUE.FINE_PER_BIT}
}

proc update_MODELPARAM_VALUE.CENTER_COMP_MODE { MODELPARAM_VALUE.CENTER_COMP_MODE PARAM_VALUE.CENTER_COMP_MODE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CENTER_COMP_MODE}] ${MODELPARAM_VALUE.CENTER_COMP_MODE}
}

proc update_MODELPARAM_VALUE.PI_VAL_ADJ { MODELPARAM_VALUE.PI_VAL_ADJ PARAM_VALUE.PI_VAL_ADJ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.PI_VAL_ADJ}] ${MODELPARAM_VALUE.PI_VAL_ADJ}
}

proc update_MODELPARAM_VALUE.IODELAY_GRP0 { MODELPARAM_VALUE.IODELAY_GRP0 PARAM_VALUE.IODELAY_GRP0 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IODELAY_GRP0}] ${MODELPARAM_VALUE.IODELAY_GRP0}
}

proc update_MODELPARAM_VALUE.IODELAY_GRP1 { MODELPARAM_VALUE.IODELAY_GRP1 PARAM_VALUE.IODELAY_GRP1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.IODELAY_GRP1}] ${MODELPARAM_VALUE.IODELAY_GRP1}
}

proc update_MODELPARAM_VALUE.SYSCLK_TYPE { MODELPARAM_VALUE.SYSCLK_TYPE PARAM_VALUE.SYSCLK_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYSCLK_TYPE}] ${MODELPARAM_VALUE.SYSCLK_TYPE}
}

proc update_MODELPARAM_VALUE.REFCLK_TYPE { MODELPARAM_VALUE.REFCLK_TYPE PARAM_VALUE.REFCLK_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REFCLK_TYPE}] ${MODELPARAM_VALUE.REFCLK_TYPE}
}

proc update_MODELPARAM_VALUE.SYS_RST_PORT { MODELPARAM_VALUE.SYS_RST_PORT PARAM_VALUE.SYS_RST_PORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.SYS_RST_PORT}] ${MODELPARAM_VALUE.SYS_RST_PORT}
}

proc update_MODELPARAM_VALUE.FPGA_SPEED_GRADE { MODELPARAM_VALUE.FPGA_SPEED_GRADE PARAM_VALUE.FPGA_SPEED_GRADE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FPGA_SPEED_GRADE}] ${MODELPARAM_VALUE.FPGA_SPEED_GRADE}
}

proc update_MODELPARAM_VALUE.CMD_PIPE_PLUS1 { MODELPARAM_VALUE.CMD_PIPE_PLUS1 PARAM_VALUE.CMD_PIPE_PLUS1 } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CMD_PIPE_PLUS1}] ${MODELPARAM_VALUE.CMD_PIPE_PLUS1}
}

proc update_MODELPARAM_VALUE.DRAM_TYPE { MODELPARAM_VALUE.DRAM_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	# WARNING: There is no corresponding user parameter named "DRAM_TYPE". Setting updated value from the model parameter.
set_property value DDR3 ${MODELPARAM_VALUE.DRAM_TYPE}
}

proc update_MODELPARAM_VALUE.CAL_WIDTH { MODELPARAM_VALUE.CAL_WIDTH PARAM_VALUE.CAL_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.CAL_WIDTH}] ${MODELPARAM_VALUE.CAL_WIDTH}
}

proc update_MODELPARAM_VALUE.STARVE_LIMIT { MODELPARAM_VALUE.STARVE_LIMIT PARAM_VALUE.STARVE_LIMIT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.STARVE_LIMIT}] ${MODELPARAM_VALUE.STARVE_LIMIT}
}

proc update_MODELPARAM_VALUE.REF_CLK_MMCM_IODELAY_CTRL { MODELPARAM_VALUE.REF_CLK_MMCM_IODELAY_CTRL PARAM_VALUE.REF_CLK_MMCM_IODELAY_CTRL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REF_CLK_MMCM_IODELAY_CTRL}] ${MODELPARAM_VALUE.REF_CLK_MMCM_IODELAY_CTRL}
}

proc update_MODELPARAM_VALUE.REFCLK_FREQ { MODELPARAM_VALUE.REFCLK_FREQ PARAM_VALUE.REFCLK_FREQ } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.REFCLK_FREQ}] ${MODELPARAM_VALUE.REFCLK_FREQ}
}

proc update_MODELPARAM_VALUE.DIFF_TERM_REFCLK { MODELPARAM_VALUE.DIFF_TERM_REFCLK PARAM_VALUE.DIFF_TERM_REFCLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIFF_TERM_REFCLK}] ${MODELPARAM_VALUE.DIFF_TERM_REFCLK}
}

proc update_MODELPARAM_VALUE.tCK { MODELPARAM_VALUE.tCK PARAM_VALUE.tCK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.tCK}] ${MODELPARAM_VALUE.tCK}
}

proc update_MODELPARAM_VALUE.nCK_PER_CLK { MODELPARAM_VALUE.nCK_PER_CLK PARAM_VALUE.nCK_PER_CLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.nCK_PER_CLK}] ${MODELPARAM_VALUE.nCK_PER_CLK}
}

proc update_MODELPARAM_VALUE.DIFF_TERM_SYSCLK { MODELPARAM_VALUE.DIFF_TERM_SYSCLK PARAM_VALUE.DIFF_TERM_SYSCLK } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DIFF_TERM_SYSCLK}] ${MODELPARAM_VALUE.DIFF_TERM_SYSCLK}
}

proc update_MODELPARAM_VALUE.UI_EXTRA_CLOCKS { MODELPARAM_VALUE.UI_EXTRA_CLOCKS PARAM_VALUE.UI_EXTRA_CLOCKS } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.UI_EXTRA_CLOCKS}] ${MODELPARAM_VALUE.UI_EXTRA_CLOCKS}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ID_WIDTH { MODELPARAM_VALUE.C_S_AXI_ID_WIDTH PARAM_VALUE.C_S_AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ID_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.C_S_AXI_MEM_SIZE { MODELPARAM_VALUE.C_S_AXI_MEM_SIZE PARAM_VALUE.C_S_AXI_MEM_SIZE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_MEM_SIZE}] ${MODELPARAM_VALUE.C_S_AXI_MEM_SIZE}
}

proc update_MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH { MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH PARAM_VALUE.C_S_AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.C_S_AXI_ADDR_WIDTH}
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

proc update_MODELPARAM_VALUE.C_S_AXI_BASEADDR { MODELPARAM_VALUE.C_S_AXI_BASEADDR PARAM_VALUE.C_S_AXI_BASEADDR } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_S_AXI_BASEADDR}] ${MODELPARAM_VALUE.C_S_AXI_BASEADDR}
}

proc update_MODELPARAM_VALUE.C_ECC_ONOFF_RESET_VALUE { MODELPARAM_VALUE.C_ECC_ONOFF_RESET_VALUE PARAM_VALUE.C_ECC_ONOFF_RESET_VALUE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ECC_ONOFF_RESET_VALUE}] ${MODELPARAM_VALUE.C_ECC_ONOFF_RESET_VALUE}
}

proc update_MODELPARAM_VALUE.C_ECC_CE_COUNTER_WIDTH { MODELPARAM_VALUE.C_ECC_CE_COUNTER_WIDTH PARAM_VALUE.C_ECC_CE_COUNTER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.C_ECC_CE_COUNTER_WIDTH}] ${MODELPARAM_VALUE.C_ECC_CE_COUNTER_WIDTH}
}

proc update_MODELPARAM_VALUE.DEBUG_PORT { MODELPARAM_VALUE.DEBUG_PORT PARAM_VALUE.DEBUG_PORT } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.DEBUG_PORT}] ${MODELPARAM_VALUE.DEBUG_PORT}
}

proc update_MODELPARAM_VALUE.TEMP_MON_CONTROL { MODELPARAM_VALUE.TEMP_MON_CONTROL PARAM_VALUE.TEMP_MON_CONTROL } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TEMP_MON_CONTROL}] ${MODELPARAM_VALUE.TEMP_MON_CONTROL}
}

proc update_MODELPARAM_VALUE.FPGA_VOLT_TYPE { MODELPARAM_VALUE.FPGA_VOLT_TYPE PARAM_VALUE.FPGA_VOLT_TYPE } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.FPGA_VOLT_TYPE}] ${MODELPARAM_VALUE.FPGA_VOLT_TYPE}
}

proc update_MODELPARAM_VALUE.RST_ACT_LOW { MODELPARAM_VALUE.RST_ACT_LOW PARAM_VALUE.RST_ACT_LOW } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.RST_ACT_LOW}] ${MODELPARAM_VALUE.RST_ACT_LOW}
}

proc update_MODELPARAM_VALUE.TEMP_MON_EN { MODELPARAM_VALUE.TEMP_MON_EN PARAM_VALUE.TEMP_MON_EN } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.TEMP_MON_EN}] ${MODELPARAM_VALUE.TEMP_MON_EN}
}

