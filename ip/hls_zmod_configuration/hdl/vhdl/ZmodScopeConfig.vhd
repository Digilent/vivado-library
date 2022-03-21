-- ==============================================================
-- RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
-- Version: 2021.1
-- Copyright (C) Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ZmodScopeConfig is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 7;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32 );
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    RstBusy : IN STD_LOGIC_VECTOR (0 downto 0);
    InitDoneADC : IN STD_LOGIC_VECTOR (0 downto 0);
    ConfigError : IN STD_LOGIC_VECTOR (0 downto 0);
    InitDoneRelay : IN STD_LOGIC_VECTOR (0 downto 0);
    DataOverflow : IN STD_LOGIC_VECTOR (0 downto 0);
    Ch1HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch1LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch1LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch1HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch2HgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch2LgMultCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch2LgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch2HgAddCoef : OUT STD_LOGIC_VECTOR (17 downto 0);
    Ch1Gain : OUT STD_LOGIC_VECTOR (0 downto 0);
    Ch2Gain : OUT STD_LOGIC_VECTOR (0 downto 0);
    Ch1Coupling : OUT STD_LOGIC_VECTOR (0 downto 0);
    Ch2Coupling : OUT STD_LOGIC_VECTOR (0 downto 0);
    s_axi_control_AWVALID : IN STD_LOGIC;
    s_axi_control_AWREADY : OUT STD_LOGIC;
    s_axi_control_AWADDR : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_ADDR_WIDTH-1 downto 0);
    s_axi_control_WVALID : IN STD_LOGIC;
    s_axi_control_WREADY : OUT STD_LOGIC;
    s_axi_control_WDATA : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_DATA_WIDTH-1 downto 0);
    s_axi_control_WSTRB : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_DATA_WIDTH/8-1 downto 0);
    s_axi_control_ARVALID : IN STD_LOGIC;
    s_axi_control_ARREADY : OUT STD_LOGIC;
    s_axi_control_ARADDR : IN STD_LOGIC_VECTOR (C_S_AXI_CONTROL_ADDR_WIDTH-1 downto 0);
    s_axi_control_RVALID : OUT STD_LOGIC;
    s_axi_control_RREADY : IN STD_LOGIC;
    s_axi_control_RDATA : OUT STD_LOGIC_VECTOR (C_S_AXI_CONTROL_DATA_WIDTH-1 downto 0);
    s_axi_control_RRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
    s_axi_control_BVALID : OUT STD_LOGIC;
    s_axi_control_BREADY : IN STD_LOGIC;
    s_axi_control_BRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
    interrupt : OUT STD_LOGIC );
end;


architecture behav of ZmodScopeConfig is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "ZmodScopeConfig_ZmodScopeConfig,hls_ip_2021_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7z020-clg400-1,HLS_INPUT_CLOCK=8.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=1.000000,HLS_SYN_LAT=1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=399,HLS_SYN_LUT=362,HLS_VERSION=2021_1}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (1 downto 0) := "01";
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant C_S_AXI_DATA_WIDTH : INTEGER range 63 downto 0 := 20;
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
    constant ap_const_lv32_2 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000010";
    constant ap_const_lv32_3 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000011";
    constant ap_const_boolean_1 : BOOLEAN := true;

    signal ap_rst_n_inv : STD_LOGIC;
    signal ap_start : STD_LOGIC;
    signal ap_done : STD_LOGIC;
    signal ap_idle : STD_LOGIC;
    signal ap_CS_fsm : STD_LOGIC_VECTOR (1 downto 0) := "01";
    attribute fsm_encoding : string;
    attribute fsm_encoding of ap_CS_fsm : signal is "none";
    signal ap_CS_fsm_state1 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state1 : signal is "none";
    signal ap_ready : STD_LOGIC;
    signal Ch1HgMultCoefAxil : STD_LOGIC_VECTOR (17 downto 0);
    signal Ch1LgMultCoefAxil : STD_LOGIC_VECTOR (17 downto 0);
    signal Ch1HgAddCoefAxil : STD_LOGIC_VECTOR (17 downto 0);
    signal Ch1LgAddCoefAxil : STD_LOGIC_VECTOR (17 downto 0);
    signal Ch2HgMultCoefAxil : STD_LOGIC_VECTOR (17 downto 0);
    signal Ch2LgMultCoefAxil : STD_LOGIC_VECTOR (17 downto 0);
    signal Ch2HgAddCoefAxil : STD_LOGIC_VECTOR (17 downto 0);
    signal Ch2LgAddCoefAxil : STD_LOGIC_VECTOR (17 downto 0);
    signal RelayConfigAxil : STD_LOGIC_VECTOR (3 downto 0);
    signal StatusAxil : STD_LOGIC_VECTOR (4 downto 0);
    signal Ch1HgMultCoef_1_data_reg : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
    signal Ch1HgMultCoef_1_vld_reg : STD_LOGIC := '0';
    signal Ch1HgMultCoef_1_vld_in : STD_LOGIC;
    signal Ch1HgMultCoef_1_ack_in : STD_LOGIC;
    signal Ch1LgMultCoef_1_data_reg : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
    signal Ch1LgMultCoef_1_vld_reg : STD_LOGIC := '0';
    signal Ch1LgMultCoef_1_vld_in : STD_LOGIC;
    signal Ch1LgMultCoef_1_ack_in : STD_LOGIC;
    signal Ch1LgAddCoef_1_data_reg : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
    signal Ch1LgAddCoef_1_vld_reg : STD_LOGIC := '0';
    signal Ch1LgAddCoef_1_vld_in : STD_LOGIC;
    signal Ch1LgAddCoef_1_ack_in : STD_LOGIC;
    signal Ch1HgAddCoef_1_data_reg : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
    signal Ch1HgAddCoef_1_vld_reg : STD_LOGIC := '0';
    signal Ch1HgAddCoef_1_vld_in : STD_LOGIC;
    signal Ch1HgAddCoef_1_ack_in : STD_LOGIC;
    signal Ch2HgMultCoef_1_data_reg : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
    signal Ch2HgMultCoef_1_vld_reg : STD_LOGIC := '0';
    signal Ch2HgMultCoef_1_vld_in : STD_LOGIC;
    signal Ch2HgMultCoef_1_ack_in : STD_LOGIC;
    signal Ch2LgMultCoef_1_data_reg : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
    signal Ch2LgMultCoef_1_vld_reg : STD_LOGIC := '0';
    signal Ch2LgMultCoef_1_vld_in : STD_LOGIC;
    signal Ch2LgMultCoef_1_ack_in : STD_LOGIC;
    signal Ch2LgAddCoef_1_data_reg : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
    signal Ch2LgAddCoef_1_vld_reg : STD_LOGIC := '0';
    signal Ch2LgAddCoef_1_vld_in : STD_LOGIC;
    signal Ch2LgAddCoef_1_ack_in : STD_LOGIC;
    signal Ch2HgAddCoef_1_data_reg : STD_LOGIC_VECTOR (17 downto 0) := "000000000000000000";
    signal Ch2HgAddCoef_1_vld_reg : STD_LOGIC := '0';
    signal Ch2HgAddCoef_1_vld_in : STD_LOGIC;
    signal Ch2HgAddCoef_1_ack_in : STD_LOGIC;
    signal Ch1Gain_1_data_reg : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal Ch1Gain_1_vld_reg : STD_LOGIC := '0';
    signal Ch1Gain_1_vld_in : STD_LOGIC;
    signal Ch1Gain_1_ack_in : STD_LOGIC;
    signal Ch2Gain_1_data_reg : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal Ch2Gain_1_vld_reg : STD_LOGIC := '0';
    signal Ch2Gain_1_vld_in : STD_LOGIC;
    signal Ch2Gain_1_ack_in : STD_LOGIC;
    signal Ch1Coupling_1_data_reg : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal Ch1Coupling_1_vld_reg : STD_LOGIC := '0';
    signal Ch1Coupling_1_vld_in : STD_LOGIC;
    signal Ch1Coupling_1_ack_in : STD_LOGIC;
    signal Ch2Coupling_1_data_reg : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal Ch2Coupling_1_vld_reg : STD_LOGIC := '0';
    signal Ch2Coupling_1_vld_in : STD_LOGIC;
    signal Ch2Coupling_1_ack_in : STD_LOGIC;
    signal trunc_ln674_fu_299_p1 : STD_LOGIC_VECTOR (0 downto 0);
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal ap_block_state2 : BOOLEAN;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (1 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_ST_fsm_state2_blk : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;

    component ZmodScopeConfig_control_s_axi IS
    generic (
        C_S_AXI_ADDR_WIDTH : INTEGER;
        C_S_AXI_DATA_WIDTH : INTEGER );
    port (
        AWVALID : IN STD_LOGIC;
        AWREADY : OUT STD_LOGIC;
        AWADDR : IN STD_LOGIC_VECTOR (C_S_AXI_ADDR_WIDTH-1 downto 0);
        WVALID : IN STD_LOGIC;
        WREADY : OUT STD_LOGIC;
        WDATA : IN STD_LOGIC_VECTOR (C_S_AXI_DATA_WIDTH-1 downto 0);
        WSTRB : IN STD_LOGIC_VECTOR (C_S_AXI_DATA_WIDTH/8-1 downto 0);
        ARVALID : IN STD_LOGIC;
        ARREADY : OUT STD_LOGIC;
        ARADDR : IN STD_LOGIC_VECTOR (C_S_AXI_ADDR_WIDTH-1 downto 0);
        RVALID : OUT STD_LOGIC;
        RREADY : IN STD_LOGIC;
        RDATA : OUT STD_LOGIC_VECTOR (C_S_AXI_DATA_WIDTH-1 downto 0);
        RRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
        BVALID : OUT STD_LOGIC;
        BREADY : IN STD_LOGIC;
        BRESP : OUT STD_LOGIC_VECTOR (1 downto 0);
        ACLK : IN STD_LOGIC;
        ARESET : IN STD_LOGIC;
        ACLK_EN : IN STD_LOGIC;
        Ch1HgMultCoefAxil : OUT STD_LOGIC_VECTOR (17 downto 0);
        Ch1LgMultCoefAxil : OUT STD_LOGIC_VECTOR (17 downto 0);
        Ch1HgAddCoefAxil : OUT STD_LOGIC_VECTOR (17 downto 0);
        Ch1LgAddCoefAxil : OUT STD_LOGIC_VECTOR (17 downto 0);
        Ch2HgMultCoefAxil : OUT STD_LOGIC_VECTOR (17 downto 0);
        Ch2LgMultCoefAxil : OUT STD_LOGIC_VECTOR (17 downto 0);
        Ch2HgAddCoefAxil : OUT STD_LOGIC_VECTOR (17 downto 0);
        Ch2LgAddCoefAxil : OUT STD_LOGIC_VECTOR (17 downto 0);
        RelayConfigAxil : OUT STD_LOGIC_VECTOR (3 downto 0);
        StatusAxil : IN STD_LOGIC_VECTOR (4 downto 0);
        ap_start : OUT STD_LOGIC;
        interrupt : OUT STD_LOGIC;
        ap_ready : IN STD_LOGIC;
        ap_done : IN STD_LOGIC;
        ap_idle : IN STD_LOGIC );
    end component;



begin
    control_s_axi_U : component ZmodScopeConfig_control_s_axi
    generic map (
        C_S_AXI_ADDR_WIDTH => C_S_AXI_CONTROL_ADDR_WIDTH,
        C_S_AXI_DATA_WIDTH => C_S_AXI_CONTROL_DATA_WIDTH)
    port map (
        AWVALID => s_axi_control_AWVALID,
        AWREADY => s_axi_control_AWREADY,
        AWADDR => s_axi_control_AWADDR,
        WVALID => s_axi_control_WVALID,
        WREADY => s_axi_control_WREADY,
        WDATA => s_axi_control_WDATA,
        WSTRB => s_axi_control_WSTRB,
        ARVALID => s_axi_control_ARVALID,
        ARREADY => s_axi_control_ARREADY,
        ARADDR => s_axi_control_ARADDR,
        RVALID => s_axi_control_RVALID,
        RREADY => s_axi_control_RREADY,
        RDATA => s_axi_control_RDATA,
        RRESP => s_axi_control_RRESP,
        BVALID => s_axi_control_BVALID,
        BREADY => s_axi_control_BREADY,
        BRESP => s_axi_control_BRESP,
        ACLK => ap_clk,
        ARESET => ap_rst_n_inv,
        ACLK_EN => ap_const_logic_1,
        Ch1HgMultCoefAxil => Ch1HgMultCoefAxil,
        Ch1LgMultCoefAxil => Ch1LgMultCoefAxil,
        Ch1HgAddCoefAxil => Ch1HgAddCoefAxil,
        Ch1LgAddCoefAxil => Ch1LgAddCoefAxil,
        Ch2HgMultCoefAxil => Ch2HgMultCoefAxil,
        Ch2LgMultCoefAxil => Ch2LgMultCoefAxil,
        Ch2HgAddCoefAxil => Ch2HgAddCoefAxil,
        Ch2LgAddCoefAxil => Ch2LgAddCoefAxil,
        RelayConfigAxil => RelayConfigAxil,
        StatusAxil => StatusAxil,
        ap_start => ap_start,
        interrupt => interrupt,
        ap_ready => ap_ready,
        ap_done => ap_done,
        ap_idle => ap_idle);





    ap_CS_fsm_assign_proc : process(ap_clk)
    begin
        if (ap_clk'event and ap_clk =  '1') then
            if (ap_rst_n_inv = '1') then
                ap_CS_fsm <= ap_ST_fsm_state1;
            else
                ap_CS_fsm <= ap_NS_fsm;
            end if;
        end if;
    end process;


    Ch1Coupling_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch1Gain_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch1HgAddCoef_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch1HgMultCoef_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch1LgAddCoef_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch1LgMultCoef_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch2Coupling_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch2Gain_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch2HgAddCoef_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch2HgMultCoef_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch2LgAddCoef_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Ch2LgMultCoef_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1Coupling_1_vld_in) and (ap_const_logic_1 = Ch1Coupling_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch1Coupling_1_vld_reg) and (ap_const_logic_1 = Ch1Coupling_1_vld_in)))) then
                Ch1Coupling_1_data_reg <= RelayConfigAxil(2 downto 2);
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1Gain_1_vld_in) and (ap_const_logic_1 = Ch1Gain_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch1Gain_1_vld_reg) and (ap_const_logic_1 = Ch1Gain_1_vld_in)))) then
                Ch1Gain_1_data_reg <= trunc_ln674_fu_299_p1;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1HgAddCoef_1_vld_in) and (ap_const_logic_1 = Ch1HgAddCoef_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch1HgAddCoef_1_vld_reg) and (ap_const_logic_1 = Ch1HgAddCoef_1_vld_in)))) then
                Ch1HgAddCoef_1_data_reg <= Ch1HgAddCoefAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1HgMultCoef_1_vld_in) and (ap_const_logic_1 = Ch1HgMultCoef_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch1HgMultCoef_1_vld_reg) and (ap_const_logic_1 = Ch1HgMultCoef_1_vld_in)))) then
                Ch1HgMultCoef_1_data_reg <= Ch1HgMultCoefAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch1LgAddCoef_1_vld_reg) and (ap_const_logic_1 = Ch1LgAddCoef_1_vld_in)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = Ch1LgAddCoef_1_vld_in) and (ap_const_logic_1 = Ch1LgAddCoef_1_vld_reg) and (ap_const_logic_1 = ap_const_logic_1)))) then
                Ch1LgAddCoef_1_data_reg <= Ch1LgAddCoefAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1LgMultCoef_1_vld_in) and (ap_const_logic_1 = Ch1LgMultCoef_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch1LgMultCoef_1_vld_reg) and (ap_const_logic_1 = Ch1LgMultCoef_1_vld_in)))) then
                Ch1LgMultCoef_1_data_reg <= Ch1LgMultCoefAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2Coupling_1_vld_in) and (ap_const_logic_1 = Ch2Coupling_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch2Coupling_1_vld_reg) and (ap_const_logic_1 = Ch2Coupling_1_vld_in)))) then
                Ch2Coupling_1_data_reg <= RelayConfigAxil(3 downto 3);
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2Gain_1_vld_in) and (ap_const_logic_1 = Ch2Gain_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch2Gain_1_vld_reg) and (ap_const_logic_1 = Ch2Gain_1_vld_in)))) then
                Ch2Gain_1_data_reg <= RelayConfigAxil(1 downto 1);
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2HgAddCoef_1_vld_in) and (ap_const_logic_1 = Ch2HgAddCoef_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch2HgAddCoef_1_vld_reg) and (ap_const_logic_1 = Ch2HgAddCoef_1_vld_in)))) then
                Ch2HgAddCoef_1_data_reg <= Ch2HgAddCoefAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2HgMultCoef_1_vld_in) and (ap_const_logic_1 = Ch2HgMultCoef_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch2HgMultCoef_1_vld_reg) and (ap_const_logic_1 = Ch2HgMultCoef_1_vld_in)))) then
                Ch2HgMultCoef_1_data_reg <= Ch2HgMultCoefAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2LgAddCoef_1_vld_in) and (ap_const_logic_1 = Ch2LgAddCoef_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch2LgAddCoef_1_vld_reg) and (ap_const_logic_1 = Ch2LgAddCoef_1_vld_in)))) then
                Ch2LgAddCoef_1_data_reg <= Ch2LgAddCoefAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2LgMultCoef_1_vld_in) and (ap_const_logic_1 = Ch2LgMultCoef_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Ch2LgMultCoef_1_vld_reg) and (ap_const_logic_1 = Ch2LgMultCoef_1_vld_in)))) then
                Ch2LgMultCoef_1_data_reg <= Ch2LgMultCoefAxil;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_start, ap_CS_fsm, ap_CS_fsm_state1, Ch1HgMultCoef_1_ack_in, Ch1LgMultCoef_1_ack_in, Ch1LgAddCoef_1_ack_in, Ch1HgAddCoef_1_ack_in, Ch2HgMultCoef_1_ack_in, Ch2LgMultCoef_1_ack_in, Ch2LgAddCoef_1_ack_in, Ch2HgAddCoef_1_ack_in, Ch1Gain_1_ack_in, Ch2Gain_1_ack_in, Ch1Coupling_1_ack_in, Ch2Coupling_1_ack_in, ap_CS_fsm_state2)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                    ap_NS_fsm <= ap_ST_fsm_state2;
                else
                    ap_NS_fsm <= ap_ST_fsm_state1;
                end if;
            when ap_ST_fsm_state2 => 
                if ((not(((ap_const_logic_0 = Ch1LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2Coupling_1_ack_in) or (ap_const_logic_0 = Ch1Coupling_1_ack_in) or (ap_const_logic_0 = Ch2Gain_1_ack_in) or (ap_const_logic_0 = Ch1Gain_1_ack_in) or (ap_const_logic_0 = Ch2HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch1LgAddCoef_1_ack_in))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
                    ap_NS_fsm <= ap_ST_fsm_state1;
                else
                    ap_NS_fsm <= ap_ST_fsm_state2;
                end if;
            when others =>  
                ap_NS_fsm <= "XX";
        end case;
    end process;
    Ch1Coupling <= Ch1Coupling_1_data_reg;

    Ch1Coupling_1_ack_in_assign_proc : process(Ch1Coupling_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch1Coupling_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1Coupling_1_vld_reg)))) then 
            Ch1Coupling_1_ack_in <= ap_const_logic_1;
        else 
            Ch1Coupling_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch1Coupling_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch1Coupling_1_vld_in <= ap_const_logic_1;
        else 
            Ch1Coupling_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch1Gain <= Ch1Gain_1_data_reg;

    Ch1Gain_1_ack_in_assign_proc : process(Ch1Gain_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch1Gain_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1Gain_1_vld_reg)))) then 
            Ch1Gain_1_ack_in <= ap_const_logic_1;
        else 
            Ch1Gain_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch1Gain_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch1Gain_1_vld_in <= ap_const_logic_1;
        else 
            Ch1Gain_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch1HgAddCoef <= Ch1HgAddCoef_1_data_reg;

    Ch1HgAddCoef_1_ack_in_assign_proc : process(Ch1HgAddCoef_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch1HgAddCoef_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1HgAddCoef_1_vld_reg)))) then 
            Ch1HgAddCoef_1_ack_in <= ap_const_logic_1;
        else 
            Ch1HgAddCoef_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch1HgAddCoef_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch1HgAddCoef_1_vld_in <= ap_const_logic_1;
        else 
            Ch1HgAddCoef_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch1HgMultCoef <= Ch1HgMultCoef_1_data_reg;

    Ch1HgMultCoef_1_ack_in_assign_proc : process(Ch1HgMultCoef_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch1HgMultCoef_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1HgMultCoef_1_vld_reg)))) then 
            Ch1HgMultCoef_1_ack_in <= ap_const_logic_1;
        else 
            Ch1HgMultCoef_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch1HgMultCoef_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch1HgMultCoef_1_vld_in <= ap_const_logic_1;
        else 
            Ch1HgMultCoef_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch1LgAddCoef <= Ch1LgAddCoef_1_data_reg;

    Ch1LgAddCoef_1_ack_in_assign_proc : process(Ch1LgAddCoef_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch1LgAddCoef_1_vld_reg) or ((ap_const_logic_1 = Ch1LgAddCoef_1_vld_reg) and (ap_const_logic_1 = ap_const_logic_1)))) then 
            Ch1LgAddCoef_1_ack_in <= ap_const_logic_1;
        else 
            Ch1LgAddCoef_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch1LgAddCoef_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch1LgAddCoef_1_vld_in <= ap_const_logic_1;
        else 
            Ch1LgAddCoef_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch1LgMultCoef <= Ch1LgMultCoef_1_data_reg;

    Ch1LgMultCoef_1_ack_in_assign_proc : process(Ch1LgMultCoef_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch1LgMultCoef_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch1LgMultCoef_1_vld_reg)))) then 
            Ch1LgMultCoef_1_ack_in <= ap_const_logic_1;
        else 
            Ch1LgMultCoef_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch1LgMultCoef_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch1LgMultCoef_1_vld_in <= ap_const_logic_1;
        else 
            Ch1LgMultCoef_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch2Coupling <= Ch2Coupling_1_data_reg;

    Ch2Coupling_1_ack_in_assign_proc : process(Ch2Coupling_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch2Coupling_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2Coupling_1_vld_reg)))) then 
            Ch2Coupling_1_ack_in <= ap_const_logic_1;
        else 
            Ch2Coupling_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch2Coupling_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch2Coupling_1_vld_in <= ap_const_logic_1;
        else 
            Ch2Coupling_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch2Gain <= Ch2Gain_1_data_reg;

    Ch2Gain_1_ack_in_assign_proc : process(Ch2Gain_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch2Gain_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2Gain_1_vld_reg)))) then 
            Ch2Gain_1_ack_in <= ap_const_logic_1;
        else 
            Ch2Gain_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch2Gain_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch2Gain_1_vld_in <= ap_const_logic_1;
        else 
            Ch2Gain_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch2HgAddCoef <= Ch2HgAddCoef_1_data_reg;

    Ch2HgAddCoef_1_ack_in_assign_proc : process(Ch2HgAddCoef_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch2HgAddCoef_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2HgAddCoef_1_vld_reg)))) then 
            Ch2HgAddCoef_1_ack_in <= ap_const_logic_1;
        else 
            Ch2HgAddCoef_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch2HgAddCoef_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch2HgAddCoef_1_vld_in <= ap_const_logic_1;
        else 
            Ch2HgAddCoef_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch2HgMultCoef <= Ch2HgMultCoef_1_data_reg;

    Ch2HgMultCoef_1_ack_in_assign_proc : process(Ch2HgMultCoef_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch2HgMultCoef_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2HgMultCoef_1_vld_reg)))) then 
            Ch2HgMultCoef_1_ack_in <= ap_const_logic_1;
        else 
            Ch2HgMultCoef_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch2HgMultCoef_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch2HgMultCoef_1_vld_in <= ap_const_logic_1;
        else 
            Ch2HgMultCoef_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch2LgAddCoef <= Ch2LgAddCoef_1_data_reg;

    Ch2LgAddCoef_1_ack_in_assign_proc : process(Ch2LgAddCoef_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch2LgAddCoef_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2LgAddCoef_1_vld_reg)))) then 
            Ch2LgAddCoef_1_ack_in <= ap_const_logic_1;
        else 
            Ch2LgAddCoef_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch2LgAddCoef_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch2LgAddCoef_1_vld_in <= ap_const_logic_1;
        else 
            Ch2LgAddCoef_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Ch2LgMultCoef <= Ch2LgMultCoef_1_data_reg;

    Ch2LgMultCoef_1_ack_in_assign_proc : process(Ch2LgMultCoef_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Ch2LgMultCoef_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Ch2LgMultCoef_1_vld_reg)))) then 
            Ch2LgMultCoef_1_ack_in <= ap_const_logic_1;
        else 
            Ch2LgMultCoef_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Ch2LgMultCoef_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Ch2LgMultCoef_1_vld_in <= ap_const_logic_1;
        else 
            Ch2LgMultCoef_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    StatusAxil <= ((((DataOverflow & InitDoneRelay) & ConfigError) & InitDoneADC) & RstBusy);
    ap_CS_fsm_state1 <= ap_CS_fsm(0);
    ap_CS_fsm_state2 <= ap_CS_fsm(1);

    ap_ST_fsm_state1_blk_assign_proc : process(ap_start)
    begin
        if ((ap_start = ap_const_logic_0)) then 
            ap_ST_fsm_state1_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state1_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_ST_fsm_state2_blk_assign_proc : process(Ch1HgMultCoef_1_ack_in, Ch1LgMultCoef_1_ack_in, Ch1LgAddCoef_1_ack_in, Ch1HgAddCoef_1_ack_in, Ch2HgMultCoef_1_ack_in, Ch2LgMultCoef_1_ack_in, Ch2LgAddCoef_1_ack_in, Ch2HgAddCoef_1_ack_in, Ch1Gain_1_ack_in, Ch2Gain_1_ack_in, Ch1Coupling_1_ack_in, Ch2Coupling_1_ack_in)
    begin
        if (((ap_const_logic_0 = Ch1LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2Coupling_1_ack_in) or (ap_const_logic_0 = Ch1Coupling_1_ack_in) or (ap_const_logic_0 = Ch2Gain_1_ack_in) or (ap_const_logic_0 = Ch1Gain_1_ack_in) or (ap_const_logic_0 = Ch2HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch1LgAddCoef_1_ack_in))) then 
            ap_ST_fsm_state2_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state2_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_block_state2_assign_proc : process(Ch1HgMultCoef_1_ack_in, Ch1LgMultCoef_1_ack_in, Ch1LgAddCoef_1_ack_in, Ch1HgAddCoef_1_ack_in, Ch2HgMultCoef_1_ack_in, Ch2LgMultCoef_1_ack_in, Ch2LgAddCoef_1_ack_in, Ch2HgAddCoef_1_ack_in, Ch1Gain_1_ack_in, Ch2Gain_1_ack_in, Ch1Coupling_1_ack_in, Ch2Coupling_1_ack_in)
    begin
                ap_block_state2 <= ((ap_const_logic_0 = Ch1LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2Coupling_1_ack_in) or (ap_const_logic_0 = Ch1Coupling_1_ack_in) or (ap_const_logic_0 = Ch2Gain_1_ack_in) or (ap_const_logic_0 = Ch1Gain_1_ack_in) or (ap_const_logic_0 = Ch2HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch1LgAddCoef_1_ack_in));
    end process;


    ap_done_assign_proc : process(Ch1HgMultCoef_1_ack_in, Ch1LgMultCoef_1_ack_in, Ch1LgAddCoef_1_ack_in, Ch1HgAddCoef_1_ack_in, Ch2HgMultCoef_1_ack_in, Ch2LgMultCoef_1_ack_in, Ch2LgAddCoef_1_ack_in, Ch2HgAddCoef_1_ack_in, Ch1Gain_1_ack_in, Ch2Gain_1_ack_in, Ch1Coupling_1_ack_in, Ch2Coupling_1_ack_in, ap_CS_fsm_state2)
    begin
        if ((not(((ap_const_logic_0 = Ch1LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2Coupling_1_ack_in) or (ap_const_logic_0 = Ch1Coupling_1_ack_in) or (ap_const_logic_0 = Ch2Gain_1_ack_in) or (ap_const_logic_0 = Ch1Gain_1_ack_in) or (ap_const_logic_0 = Ch2HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch1LgAddCoef_1_ack_in))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            ap_done <= ap_const_logic_1;
        else 
            ap_done <= ap_const_logic_0;
        end if; 
    end process;


    ap_idle_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            ap_idle <= ap_const_logic_1;
        else 
            ap_idle <= ap_const_logic_0;
        end if; 
    end process;


    ap_ready_assign_proc : process(Ch1HgMultCoef_1_ack_in, Ch1LgMultCoef_1_ack_in, Ch1LgAddCoef_1_ack_in, Ch1HgAddCoef_1_ack_in, Ch2HgMultCoef_1_ack_in, Ch2LgMultCoef_1_ack_in, Ch2LgAddCoef_1_ack_in, Ch2HgAddCoef_1_ack_in, Ch1Gain_1_ack_in, Ch2Gain_1_ack_in, Ch1Coupling_1_ack_in, Ch2Coupling_1_ack_in, ap_CS_fsm_state2)
    begin
        if ((not(((ap_const_logic_0 = Ch1LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2Coupling_1_ack_in) or (ap_const_logic_0 = Ch1Coupling_1_ack_in) or (ap_const_logic_0 = Ch2Gain_1_ack_in) or (ap_const_logic_0 = Ch1Gain_1_ack_in) or (ap_const_logic_0 = Ch2HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch2LgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch2HgMultCoef_1_ack_in) or (ap_const_logic_0 = Ch1HgAddCoef_1_ack_in) or (ap_const_logic_0 = Ch1LgAddCoef_1_ack_in))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;


    ap_rst_n_inv_assign_proc : process(ap_rst_n)
    begin
                ap_rst_n_inv <= not(ap_rst_n);
    end process;

    trunc_ln674_fu_299_p1 <= RelayConfigAxil(1 - 1 downto 0);
end behav;
