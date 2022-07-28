-- ==============================================================
-- RTL generated by Vitis HLS - High-Level Synthesis from C, C++ and OpenCL v2021.1 (64-bit)
-- Version: 2021.1
-- Copyright (C) Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
-- 
-- ===========================================================

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TriggerControl is
generic (
    C_S_AXI_CONTROL_ADDR_WIDTH : INTEGER := 6;
    C_S_AXI_CONTROL_DATA_WIDTH : INTEGER := 32 );
port (
    ap_clk : IN STD_LOGIC;
    ap_rst_n : IN STD_LOGIC;
    Start_r : OUT STD_LOGIC_VECTOR (0 downto 0);
    Idle : IN STD_LOGIC_VECTOR (0 downto 0);
    TriggerEnable : OUT STD_LOGIC_VECTOR (31 downto 0);
    TriggerDetected : IN STD_LOGIC_VECTOR (31 downto 0);
    TriggerToLastBeats : OUT STD_LOGIC_VECTOR (31 downto 0);
    PrebufferBeats : OUT STD_LOGIC_VECTOR (31 downto 0);
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


architecture behav of TriggerControl is 
    attribute CORE_GENERATION_INFO : STRING;
    attribute CORE_GENERATION_INFO of behav : architecture is
    "TriggerControl_TriggerControl,hls_ip_2021_1,{HLS_INPUT_TYPE=cxx,HLS_INPUT_FLOAT=0,HLS_INPUT_FIXED=0,HLS_INPUT_PART=xc7z020-clg400-1,HLS_INPUT_CLOCK=8.000000,HLS_INPUT_ARCH=others,HLS_SYN_CLOCK=1.000000,HLS_SYN_LAT=1,HLS_SYN_TPT=none,HLS_SYN_MEM=0,HLS_SYN_DSP=0,HLS_SYN_FF=334,HLS_SYN_LUT=316,HLS_VERSION=2021_1}";
    constant ap_const_logic_1 : STD_LOGIC := '1';
    constant ap_const_logic_0 : STD_LOGIC := '0';
    constant ap_ST_fsm_state1 : STD_LOGIC_VECTOR (1 downto 0) := "01";
    constant ap_ST_fsm_state2 : STD_LOGIC_VECTOR (1 downto 0) := "10";
    constant ap_const_lv32_0 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    constant C_S_AXI_DATA_WIDTH : INTEGER range 63 downto 0 := 20;
    constant ap_const_lv32_1 : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000001";
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
    signal ControlAxil : STD_LOGIC_VECTOR (0 downto 0);
    signal TriggerEnableAxil : STD_LOGIC_VECTOR (31 downto 0);
    signal TriggerToLastBeatsAxil : STD_LOGIC_VECTOR (31 downto 0);
    signal PrebufferBeatsAxil : STD_LOGIC_VECTOR (31 downto 0);
    signal Start_r_1_data_reg : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal Start_r_1_vld_reg : STD_LOGIC := '0';
    signal Start_r_1_vld_in : STD_LOGIC;
    signal Start_r_1_ack_in : STD_LOGIC;
    signal Idle_0_data_reg : STD_LOGIC_VECTOR (0 downto 0) := "0";
    signal Idle_0_vld_reg : STD_LOGIC := '0';
    signal Idle_0_ack_out : STD_LOGIC;
    signal TriggerEnable_1_data_reg : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal TriggerEnable_1_vld_reg : STD_LOGIC := '0';
    signal TriggerEnable_1_vld_in : STD_LOGIC;
    signal TriggerEnable_1_ack_in : STD_LOGIC;
    signal TriggerDetected_0_data_reg : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal TriggerDetected_0_vld_reg : STD_LOGIC := '0';
    signal TriggerDetected_0_ack_out : STD_LOGIC;
    signal TriggerToLastBeats_1_data_reg : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal TriggerToLastBeats_1_vld_reg : STD_LOGIC := '0';
    signal TriggerToLastBeats_1_vld_in : STD_LOGIC;
    signal TriggerToLastBeats_1_ack_in : STD_LOGIC;
    signal PrebufferBeats_1_data_reg : STD_LOGIC_VECTOR (31 downto 0) := "00000000000000000000000000000000";
    signal PrebufferBeats_1_vld_reg : STD_LOGIC := '0';
    signal PrebufferBeats_1_vld_in : STD_LOGIC;
    signal PrebufferBeats_1_ack_in : STD_LOGIC;
    signal ap_CS_fsm_state2 : STD_LOGIC;
    attribute fsm_encoding of ap_CS_fsm_state2 : signal is "none";
    signal ap_block_state2 : BOOLEAN;
    signal ap_NS_fsm : STD_LOGIC_VECTOR (1 downto 0);
    signal ap_ST_fsm_state1_blk : STD_LOGIC;
    signal ap_ST_fsm_state2_blk : STD_LOGIC;
    signal ap_ce_reg : STD_LOGIC;

    component TriggerControl_control_s_axi IS
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
        ControlAxil : OUT STD_LOGIC_VECTOR (0 downto 0);
        StatusAxil : IN STD_LOGIC_VECTOR (0 downto 0);
        TriggerEnableAxil : OUT STD_LOGIC_VECTOR (31 downto 0);
        TriggerDetectedAxil : IN STD_LOGIC_VECTOR (31 downto 0);
        TriggerToLastBeatsAxil : OUT STD_LOGIC_VECTOR (31 downto 0);
        PrebufferBeatsAxil : OUT STD_LOGIC_VECTOR (31 downto 0);
        ap_start : OUT STD_LOGIC;
        interrupt : OUT STD_LOGIC;
        ap_ready : IN STD_LOGIC;
        ap_done : IN STD_LOGIC;
        ap_idle : IN STD_LOGIC );
    end component;



begin
    control_s_axi_U : component TriggerControl_control_s_axi
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
        ControlAxil => ControlAxil,
        StatusAxil => Idle_0_data_reg,
        TriggerEnableAxil => TriggerEnableAxil,
        TriggerDetectedAxil => TriggerDetected_0_data_reg,
        TriggerToLastBeatsAxil => TriggerToLastBeatsAxil,
        PrebufferBeatsAxil => PrebufferBeatsAxil,
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


    Idle_0_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    PrebufferBeats_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    Start_r_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    TriggerDetected_0_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    TriggerEnable_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;

    TriggerToLastBeats_1_vld_reg_assign_proc : process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = Idle_0_ack_out) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Idle_0_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Idle_0_vld_reg) and (ap_const_logic_1 = ap_const_logic_1)))) then
                Idle_0_data_reg <= Idle;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = PrebufferBeats_1_vld_in) and (ap_const_logic_1 = PrebufferBeats_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = PrebufferBeats_1_vld_reg) and (ap_const_logic_1 = PrebufferBeats_1_vld_in)))) then
                PrebufferBeats_1_data_reg <= PrebufferBeatsAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Start_r_1_vld_in) and (ap_const_logic_1 = Start_r_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = Start_r_1_vld_reg) and (ap_const_logic_1 = Start_r_1_vld_in)))) then
                Start_r_1_data_reg <= ControlAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = TriggerDetected_0_ack_out) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = TriggerDetected_0_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = TriggerDetected_0_vld_reg) and (ap_const_logic_1 = ap_const_logic_1)))) then
                TriggerDetected_0_data_reg <= TriggerDetected;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = TriggerEnable_1_vld_in) and (ap_const_logic_1 = TriggerEnable_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = TriggerEnable_1_vld_reg) and (ap_const_logic_1 = TriggerEnable_1_vld_in)))) then
                TriggerEnable_1_data_reg <= TriggerEnableAxil;
            end if;
        end if;
    end process;
    process (ap_clk)
    begin
        if (ap_clk'event and ap_clk = '1') then
            if (((not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = TriggerToLastBeats_1_vld_in) and (ap_const_logic_1 = TriggerToLastBeats_1_vld_reg)) or (not(((ap_start = ap_const_logic_0) and (ap_const_logic_1 = ap_CS_fsm_state1))) and (ap_const_logic_0 = TriggerToLastBeats_1_vld_reg) and (ap_const_logic_1 = TriggerToLastBeats_1_vld_in)))) then
                TriggerToLastBeats_1_data_reg <= TriggerToLastBeatsAxil;
            end if;
        end if;
    end process;

    ap_NS_fsm_assign_proc : process (ap_start, ap_CS_fsm, ap_CS_fsm_state1, Start_r_1_ack_in, TriggerEnable_1_ack_in, TriggerToLastBeats_1_ack_in, PrebufferBeats_1_ack_in, ap_CS_fsm_state2)
    begin
        case ap_CS_fsm is
            when ap_ST_fsm_state1 => 
                if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then
                    ap_NS_fsm <= ap_ST_fsm_state2;
                else
                    ap_NS_fsm <= ap_ST_fsm_state1;
                end if;
            when ap_ST_fsm_state2 => 
                if ((not(((ap_const_logic_0 = TriggerEnable_1_ack_in) or (ap_const_logic_0 = Start_r_1_ack_in) or (ap_const_logic_0 = PrebufferBeats_1_ack_in) or (ap_const_logic_0 = TriggerToLastBeats_1_ack_in))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then
                    ap_NS_fsm <= ap_ST_fsm_state1;
                else
                    ap_NS_fsm <= ap_ST_fsm_state2;
                end if;
            when others =>  
                ap_NS_fsm <= "XX";
        end case;
    end process;

    Idle_0_ack_out_assign_proc : process(Start_r_1_ack_in, TriggerEnable_1_ack_in, TriggerToLastBeats_1_ack_in, PrebufferBeats_1_ack_in, ap_CS_fsm_state2)
    begin
        if ((not(((ap_const_logic_0 = TriggerEnable_1_ack_in) or (ap_const_logic_0 = Start_r_1_ack_in) or (ap_const_logic_0 = PrebufferBeats_1_ack_in) or (ap_const_logic_0 = TriggerToLastBeats_1_ack_in))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            Idle_0_ack_out <= ap_const_logic_1;
        else 
            Idle_0_ack_out <= ap_const_logic_0;
        end if; 
    end process;

    PrebufferBeats <= PrebufferBeats_1_data_reg;

    PrebufferBeats_1_ack_in_assign_proc : process(PrebufferBeats_1_vld_reg)
    begin
        if (((ap_const_logic_0 = PrebufferBeats_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = PrebufferBeats_1_vld_reg)))) then 
            PrebufferBeats_1_ack_in <= ap_const_logic_1;
        else 
            PrebufferBeats_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    PrebufferBeats_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            PrebufferBeats_1_vld_in <= ap_const_logic_1;
        else 
            PrebufferBeats_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    Start_r <= Start_r_1_data_reg;

    Start_r_1_ack_in_assign_proc : process(Start_r_1_vld_reg)
    begin
        if (((ap_const_logic_0 = Start_r_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = Start_r_1_vld_reg)))) then 
            Start_r_1_ack_in <= ap_const_logic_1;
        else 
            Start_r_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    Start_r_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            Start_r_1_vld_in <= ap_const_logic_1;
        else 
            Start_r_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;


    TriggerDetected_0_ack_out_assign_proc : process(Start_r_1_ack_in, TriggerEnable_1_ack_in, TriggerToLastBeats_1_ack_in, PrebufferBeats_1_ack_in, ap_CS_fsm_state2)
    begin
        if ((not(((ap_const_logic_0 = TriggerEnable_1_ack_in) or (ap_const_logic_0 = Start_r_1_ack_in) or (ap_const_logic_0 = PrebufferBeats_1_ack_in) or (ap_const_logic_0 = TriggerToLastBeats_1_ack_in))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            TriggerDetected_0_ack_out <= ap_const_logic_1;
        else 
            TriggerDetected_0_ack_out <= ap_const_logic_0;
        end if; 
    end process;

    TriggerEnable <= TriggerEnable_1_data_reg;

    TriggerEnable_1_ack_in_assign_proc : process(TriggerEnable_1_vld_reg)
    begin
        if (((ap_const_logic_0 = TriggerEnable_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = TriggerEnable_1_vld_reg)))) then 
            TriggerEnable_1_ack_in <= ap_const_logic_1;
        else 
            TriggerEnable_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    TriggerEnable_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            TriggerEnable_1_vld_in <= ap_const_logic_1;
        else 
            TriggerEnable_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

    TriggerToLastBeats <= TriggerToLastBeats_1_data_reg;

    TriggerToLastBeats_1_ack_in_assign_proc : process(TriggerToLastBeats_1_vld_reg)
    begin
        if (((ap_const_logic_0 = TriggerToLastBeats_1_vld_reg) or ((ap_const_logic_1 = ap_const_logic_1) and (ap_const_logic_1 = TriggerToLastBeats_1_vld_reg)))) then 
            TriggerToLastBeats_1_ack_in <= ap_const_logic_1;
        else 
            TriggerToLastBeats_1_ack_in <= ap_const_logic_0;
        end if; 
    end process;


    TriggerToLastBeats_1_vld_in_assign_proc : process(ap_start, ap_CS_fsm_state1)
    begin
        if (((ap_start = ap_const_logic_1) and (ap_const_logic_1 = ap_CS_fsm_state1))) then 
            TriggerToLastBeats_1_vld_in <= ap_const_logic_1;
        else 
            TriggerToLastBeats_1_vld_in <= ap_const_logic_0;
        end if; 
    end process;

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


    ap_ST_fsm_state2_blk_assign_proc : process(Start_r_1_ack_in, TriggerEnable_1_ack_in, TriggerToLastBeats_1_ack_in, PrebufferBeats_1_ack_in)
    begin
        if (((ap_const_logic_0 = TriggerEnable_1_ack_in) or (ap_const_logic_0 = Start_r_1_ack_in) or (ap_const_logic_0 = PrebufferBeats_1_ack_in) or (ap_const_logic_0 = TriggerToLastBeats_1_ack_in))) then 
            ap_ST_fsm_state2_blk <= ap_const_logic_1;
        else 
            ap_ST_fsm_state2_blk <= ap_const_logic_0;
        end if; 
    end process;


    ap_block_state2_assign_proc : process(Start_r_1_ack_in, TriggerEnable_1_ack_in, TriggerToLastBeats_1_ack_in, PrebufferBeats_1_ack_in)
    begin
                ap_block_state2 <= ((ap_const_logic_0 = TriggerEnable_1_ack_in) or (ap_const_logic_0 = Start_r_1_ack_in) or (ap_const_logic_0 = PrebufferBeats_1_ack_in) or (ap_const_logic_0 = TriggerToLastBeats_1_ack_in));
    end process;


    ap_done_assign_proc : process(Start_r_1_ack_in, TriggerEnable_1_ack_in, TriggerToLastBeats_1_ack_in, PrebufferBeats_1_ack_in, ap_CS_fsm_state2)
    begin
        if ((not(((ap_const_logic_0 = TriggerEnable_1_ack_in) or (ap_const_logic_0 = Start_r_1_ack_in) or (ap_const_logic_0 = PrebufferBeats_1_ack_in) or (ap_const_logic_0 = TriggerToLastBeats_1_ack_in))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
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


    ap_ready_assign_proc : process(Start_r_1_ack_in, TriggerEnable_1_ack_in, TriggerToLastBeats_1_ack_in, PrebufferBeats_1_ack_in, ap_CS_fsm_state2)
    begin
        if ((not(((ap_const_logic_0 = TriggerEnable_1_ack_in) or (ap_const_logic_0 = Start_r_1_ack_in) or (ap_const_logic_0 = PrebufferBeats_1_ack_in) or (ap_const_logic_0 = TriggerToLastBeats_1_ack_in))) and (ap_const_logic_1 = ap_CS_fsm_state2))) then 
            ap_ready <= ap_const_logic_1;
        else 
            ap_ready <= ap_const_logic_0;
        end if; 
    end process;


    ap_rst_n_inv_assign_proc : process(ap_rst_n)
    begin
                ap_rst_n_inv <= not(ap_rst_n);
    end process;

end behav;
