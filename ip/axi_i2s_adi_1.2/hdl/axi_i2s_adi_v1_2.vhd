
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.math_real.all;

library axi_i2s_adi_v1_00_a;
use axi_i2s_adi_v1_00_a.i2s_controller;

library adi_common_v1_00_a;
use adi_common_v1_00_a.axi_streaming_dma_rx_fifo;
use adi_common_v1_00_a.axi_streaming_dma_tx_fifo;
use adi_common_v1_00_a.pl330_dma_fifo;
use adi_common_v1_00_a.axi_ctrlif;


entity axi_i2s_adi is
	generic (
		-- Users to add parameters here
		C_SLOT_WIDTH		: integer := 24;
		C_LRCLK_POL		: integer := 0;		-- LRCLK Polarity (0 - Falling edge, 1 - Rising edge)
		C_BCLK_POL		: integer := 0; 	-- BCLK Polarity (0 - Falling edge, 1 - Rising edge)
		C_DMA_TYPE		: integer			:= 0;
		C_NUM_CH		: integer			:= 1;
		C_HAS_TX		: integer			:= 1;
		C_HAS_RX		: integer			:= 1;
		-- User parameters ends
		-- Do not modify the parameters beyond this line


		-- Parameters of Axi Slave Bus Interface S00_AXI
		C_S00_AXI_DATA_WIDTH	: integer	:= 32;
		C_S00_AXI_ADDR_WIDTH	: integer	:= 6
	);
	port (
		-- Users to add ports here
		-- Serial Data interface
		DATA_CLK_I		: in  std_logic;
		BCLK_O			: out std_logic_vector(C_NUM_CH - 1 downto 0);
		LRCLK_O			: out std_logic_vector(C_NUM_CH - 1 downto 0);
		SDATA_O			: out std_logic_vector(C_NUM_CH - 1 downto 0);
		SDATA_I			: in  std_logic_vector(C_NUM_CH - 1 downto 0);
		MUTEN_O     : out std_logic;

		-- AXI Streaming DMA TX interface
		S_AXIS_ACLK		: in  std_logic;
		S_AXIS_TREADY		: out std_logic;
		S_AXIS_TDATA		: in  std_logic_vector(31 downto 0);
		S_AXIS_TLAST		: in  std_logic;
		S_AXIS_TVALID		: in  std_logic;

		-- AXI Streaming DMA RX interface
		M_AXIS_ACLK		: in  std_logic;
		M_AXIS_TREADY		: in  std_logic;
		M_AXIS_TDATA		: out std_logic_vector(31 downto 0);
		M_AXIS_TLAST		: out std_logic;
		M_AXIS_TVALID		: out std_logic;
		M_AXIS_TKEEP		: out std_logic_vector(3 downto 0);

		--PL330 DMA TX interface
		DMA_REQ_TX_ACLK    : in  std_logic;
		DMA_REQ_TX_RSTN    : in  std_logic;
		DMA_REQ_TX_DAVALID : in  std_logic;
		DMA_REQ_TX_DATYPE  : in  std_logic_vector(1 downto 0);
		DMA_REQ_TX_DAREADY : out std_logic;
		DMA_REQ_TX_DRVALID : out std_logic;
		DMA_REQ_TX_DRTYPE  : out std_logic_vector(1 downto 0);
		DMA_REQ_TX_DRLAST  : out std_logic;
		DMA_REQ_TX_DRREADY : in  std_logic;

		-- PL330 DMA RX interface
		DMA_REQ_RX_ACLK    : in  std_logic;
		DMA_REQ_RX_RSTN    : in  std_logic;
		DMA_REQ_RX_DAVALID : in  std_logic;
		DMA_REQ_RX_DATYPE  : in  std_logic_vector(1 downto 0);
		DMA_REQ_RX_DAREADY : out std_logic;
		DMA_REQ_RX_DRVALID : out std_logic;
		DMA_REQ_RX_DRTYPE  : out std_logic_vector(1 downto 0);
		DMA_REQ_RX_DRLAST  : out std_logic;
		DMA_REQ_RX_DRREADY : in  std_logic;
		-- User ports ends
		-- Do not modify the ports beyond this line


		-- Ports of Axi Slave Bus Interface S00_AXI
		s00_axi_aclk	: in std_logic;
		s00_axi_aresetn	: in std_logic;
		s00_axi_awaddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_awprot	: in std_logic_vector(2 downto 0);
		s00_axi_awvalid	: in std_logic;
		s00_axi_awready	: out std_logic;
		s00_axi_wdata	: in std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_wstrb	: in std_logic_vector((C_S00_AXI_DATA_WIDTH/8)-1 downto 0);
		s00_axi_wvalid	: in std_logic;
		s00_axi_wready	: out std_logic;
		s00_axi_bresp	: out std_logic_vector(1 downto 0);
		s00_axi_bvalid	: out std_logic;
		s00_axi_bready	: in std_logic;
		s00_axi_araddr	: in std_logic_vector(C_S00_AXI_ADDR_WIDTH-1 downto 0);
		s00_axi_arprot	: in std_logic_vector(2 downto 0);
		s00_axi_arvalid	: in std_logic;
		s00_axi_arready	: out std_logic;
		s00_axi_rdata	: out std_logic_vector(C_S00_AXI_DATA_WIDTH-1 downto 0);
		s00_axi_rresp	: out std_logic_vector(1 downto 0);
		s00_axi_rvalid	: out std_logic;
		s00_axi_rready	: in std_logic
	);
end axi_i2s_adi;

architecture arch_imp of axi_i2s_adi is

	-- component declaration
	component axi_i2s_adi_S_AXI is
		generic (
		C_S_AXI_DATA_WIDTH	: integer	:= 32;
		C_S_AXI_ADDR_WIDTH	: integer	:= 6
		);
		port (
		rd_addr : out integer range 0 to 12 - 1;
		rd_data : in  std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		rd_ack  : out std_logic;

		wr_addr : out integer range 0 to 12 - 1;
		wr_data : out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		wr_stb  : out std_logic;
		S_AXI_ACLK	: in std_logic;
		S_AXI_ARESETN	: in std_logic;
		S_AXI_AWADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_AWPROT	: in std_logic_vector(2 downto 0);
		S_AXI_AWVALID	: in std_logic;
		S_AXI_AWREADY	: out std_logic;
		S_AXI_WDATA	: in std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_WSTRB	: in std_logic_vector((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
		S_AXI_WVALID	: in std_logic;
		S_AXI_WREADY	: out std_logic;
		S_AXI_BRESP	: out std_logic_vector(1 downto 0);
		S_AXI_BVALID	: out std_logic;
		S_AXI_BREADY	: in std_logic;
		S_AXI_ARADDR	: in std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
		S_AXI_ARPROT	: in std_logic_vector(2 downto 0);
		S_AXI_ARVALID	: in std_logic;
		S_AXI_ARREADY	: out std_logic;
		S_AXI_RDATA	: out std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0);
		S_AXI_RRESP	: out std_logic_vector(1 downto 0);
		S_AXI_RVALID	: out std_logic;
		S_AXI_RREADY	: in std_logic
		);
	end component axi_i2s_adi_S_AXI;
	
	signal i2s_reset			: std_logic;
signal tx_fifo_reset			: std_logic;
signal tx_enable			: Boolean;
signal tx_data				: std_logic_vector(C_SLOT_WIDTH - 1 downto 0);
signal tx_ack				: std_logic;
signal tx_stb				: std_logic;
signal tx_fifo_full			: std_logic;
signal tx_fifo_empty		: std_logic;
signal tx_in_ack			: std_logic;


signal rx_enable			: Boolean;
signal rx_fifo_reset			: std_logic;
signal rx_data				: std_logic_vector(C_SLOT_WIDTH - 1 downto 0);
signal rx_ack				: std_logic;
signal rx_stb				: std_logic;
signal rx_fifo_full			: std_logic;
signal rx_fifo_empty		: std_logic;
signal rx_out_stb			: std_logic;

signal bclk_div_rate			: natural range 0 to 255;
signal lrclk_div_rate			: natural range 0 to 255;

signal period_len			: integer range 0 to 65535;

signal I2S_RESET_REG			: std_logic_vector(31 downto 0);
signal I2S_CONTROL_REG			: std_logic_vector(31 downto 0);
signal I2S_CLK_CONTROL_REG		: std_logic_vector(31 downto 0);
signal PERIOD_LEN_REG			: std_logic_vector(31 downto 0);

constant FIFO_AWIDTH			: integer := integer(ceil(log2(real(C_NUM_CH * 8))));

-- Audio samples FIFO
constant RAM_ADDR_WIDTH			: integer := 7;
type RAM_TYPE is array (0 to (2**RAM_ADDR_WIDTH - 1)) of std_logic_vector(31 downto 0);

-- RX FIFO signals
signal audio_fifo_rx			: RAM_TYPE;
signal audio_fifo_rx_wr_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal audio_fifo_rx_rd_addr		: integer range 0 to 2**RAM_ADDR_WIDTH-1;
signal tvalid				: std_logic := '0';
signal rx_tlast				: std_logic;
signal drain_tx_dma			: std_logic;

signal rx_sample			: std_logic_vector(23 downto 0);

signal wr_data : std_logic_vector(31 downto 0);
signal rd_data : std_logic_vector(31 downto 0);
signal wr_addr : integer range 0 to 11;
signal rd_addr : integer range 0 to 11;
signal wr_stb : std_logic;
signal rd_ack : std_logic;
signal tx_fifo_stb : std_logic;
signal rx_fifo_ack : std_logic;
signal cnt : integer range 0 to 2**16-1;

begin

-- Instantiation of Axi Bus Interface S00_AXI
axi_i2s_adi_S_AXI_inst : axi_i2s_adi_S_AXI
	generic map (
		C_S_AXI_DATA_WIDTH	=> C_S00_AXI_DATA_WIDTH,
		C_S_AXI_ADDR_WIDTH	=> C_S00_AXI_ADDR_WIDTH
	)
	port map (
			rd_addr			=> rd_addr,
			rd_data			=> rd_data,
			rd_ack		=> rd_ack,

			wr_addr			=> wr_addr,
			wr_data			=> wr_data,
			wr_stb			=> wr_stb,
		S_AXI_ACLK	=> s00_axi_aclk,
		S_AXI_ARESETN	=> s00_axi_aresetn,
		S_AXI_AWADDR	=> s00_axi_awaddr,
		S_AXI_AWPROT	=> s00_axi_awprot,
		S_AXI_AWVALID	=> s00_axi_awvalid,
		S_AXI_AWREADY	=> s00_axi_awready,
		S_AXI_WDATA	=> s00_axi_wdata,
		S_AXI_WSTRB	=> s00_axi_wstrb,
		S_AXI_WVALID	=> s00_axi_wvalid,
		S_AXI_WREADY	=> s00_axi_wready,
		S_AXI_BRESP	=> s00_axi_bresp,
		S_AXI_BVALID	=> s00_axi_bvalid,
		S_AXI_BREADY	=> s00_axi_bready,
		S_AXI_ARADDR	=> s00_axi_araddr,
		S_AXI_ARPROT	=> s00_axi_arprot,
		S_AXI_ARVALID	=> s00_axi_arvalid,
		S_AXI_ARREADY	=> s00_axi_arready,
		S_AXI_RDATA	=> s00_axi_rdata,
		S_AXI_RRESP	=> s00_axi_rresp,
		S_AXI_RVALID	=> s00_axi_rvalid,
		S_AXI_RREADY	=> s00_axi_rready
	);

	-- Add user logic here
process (s00_axi_aclk)
	begin
		if rising_edge(s00_axi_aclk) then
			if s00_axi_aresetn = '0' then
				cnt <= 0;
			else
				cnt <= (cnt + 1) mod 2**16;
			end if;
		end if;
	end process;

	streaming_dma_tx_gen: if C_DMA_TYPE = 0 and C_HAS_TX = 1 generate
		tx_fifo : entity axi_streaming_dma_tx_fifo	
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24
			)
			port map(
				clk => s00_axi_aclk,
				resetn => s00_axi_aresetn,
				fifo_reset => tx_fifo_reset,
				enable => tx_enable,

				S_AXIS_ACLK => S_AXIS_ACLK,
				S_AXIS_TREADY => S_AXIS_TREADY,
				S_AXIS_TDATA => S_AXIS_TDATA(31 downto 8),
				S_AXIS_TLAST => S_AXIS_TLAST,
				S_AXIS_TVALID => S_AXIS_TVALID,

				out_stb => tx_stb,
				out_ack => tx_ack,
				out_data => tx_data
			);
	end generate;

	streaming_dma_rx_gen: if C_DMA_TYPE = 0 and C_HAS_RX = 1 generate
		rx_fifo : entity axi_streaming_dma_rx_fifo	
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24
			)
			port map(
				clk => s00_axi_aclk,
				resetn => s00_axi_aresetn,
				fifo_reset => tx_fifo_reset,
				enable => tx_enable,

				period_len => period_len,

				in_stb => rx_stb,
				in_ack => rx_ack,
				in_data => rx_data,

				M_AXIS_ACLK => M_AXIS_ACLK,
				M_AXIS_TREADY => M_AXIS_TREADY,
				M_AXIS_TDATA => M_AXIS_TDATA(31 downto 8),
				M_AXIS_TLAST => M_AXIS_TLAST,
				M_AXIS_TVALID => M_AXIS_TVALID,
				M_AXIS_TKEEP => M_AXIS_TKEEP
			);

			M_AXIS_TDATA(7 downto 0) <= (others => '0');
	end generate;

	pl330_dma_tx_gen: if C_DMA_TYPE = 1 and C_HAS_TX = 1 generate
		tx_fifo_stb <= '1' when wr_addr = 11 and wr_stb = '1' else '0';

		tx_fifo: entity pl330_dma_fifo
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24,
				FIFO_DIRECTION => 0
			)
			port map (
				clk => s00_axi_aclk,
				resetn => s00_axi_aresetn,
				fifo_reset => tx_fifo_reset,
				enable => tx_enable,

				in_data => wr_data(31 downto 8),
				in_stb => tx_fifo_stb,
				in_ack => tx_in_ack,

				out_ack => tx_ack,
				out_stb => tx_stb,
				out_data => tx_data,

				dclk => DMA_REQ_TX_ACLK,
				dresetn => DMA_REQ_TX_RSTN,
				davalid => DMA_REQ_TX_DAVALID,
				daready => DMA_REQ_TX_DAREADY,
				datype => DMA_REQ_TX_DATYPE,
				drvalid => DMA_REQ_TX_DRVALID,
				drready => DMA_REQ_TX_DRREADY,
				drtype => DMA_REQ_TX_DRTYPE,
				drlast => DMA_REQ_TX_DRLAST
			);
	end generate;


	pl330_dma_rx_gen: if C_DMA_TYPE = 1 and C_HAS_RX = 1 generate
		rx_fifo_ack <= '1' when rd_addr = 10 and rd_ack = '1' else '0';

		rx_fifo: entity pl330_dma_fifo
			generic map(
				RAM_ADDR_WIDTH => FIFO_AWIDTH,
				FIFO_DWIDTH => 24,
				FIFO_DIRECTION => 1
			)
			port map (
				clk => s00_axi_aclk,
				resetn => s00_axi_aresetn,
				fifo_reset => rx_fifo_reset,
				enable => rx_enable,

				in_ack => rx_ack,
				in_stb => rx_stb,
				in_data => rx_data,

				out_data => rx_sample,
				out_ack => rx_fifo_ack,
				out_stb => rx_out_stb,

				dclk => DMA_REQ_RX_ACLK,
				dresetn => DMA_REQ_RX_RSTN,
				davalid => DMA_REQ_RX_DAVALID,
				daready => DMA_REQ_RX_DAREADY,
				datype => DMA_REQ_RX_DATYPE,
				drvalid => DMA_REQ_RX_DRVALID,
				drready => DMA_REQ_RX_DRREADY,
				drtype => DMA_REQ_RX_DRTYPE,
				drlast => DMA_REQ_RX_DRLAST
			);
	end generate;

	ctrl : entity i2s_controller
		generic map (
			C_SLOT_WIDTH => C_SLOT_WIDTH,
			C_BCLK_POL => C_BCLK_POL,
			C_LRCLK_POL => C_LRCLK_POL,
			C_NUM_CH => C_NUM_CH,
			C_HAS_TX => C_HAS_TX,
			C_HAS_RX => C_HAS_RX
		)
		port map (
			clk => s00_axi_aclk,
			resetn => s00_axi_aresetn,

			data_clk => DATA_CLK_I,
			BCLK_O => BCLK_O,
			LRCLK_O => LRCLK_O,
			SDATA_O => SDATA_O,
			SDATA_I => SDATA_I,

			tx_enable => tx_enable,
			tx_ack => tx_ack,
			tx_stb => tx_stb,
			tx_data => tx_data,

			rx_enable => rx_enable,
			rx_ack => rx_ack,
			rx_stb => rx_stb,
			rx_data => rx_data,

			bclk_div_rate => bclk_div_rate,
			lrclk_div_rate => lrclk_div_rate
		);

	
	
	tx_fifo_full	<= not(tx_in_ack);
	tx_fifo_empty	<= not(tx_stb);
	rx_fifo_full	<= not(rx_ack);
	rx_fifo_empty	<= not(rx_out_stb);
	i2s_reset		<= I2S_RESET_REG(0);
	tx_fifo_reset		<= I2S_RESET_REG(1);
	rx_fifo_reset		<= I2S_RESET_REG(2);
	tx_enable		<= I2S_CONTROL_REG(0) = '1';
	rx_enable		<= I2S_CONTROL_REG(1) = '1';
	MUTEN_O		<= not(I2S_CONTROL_REG(2));
	bclk_div_rate		<= to_integer(unsigned(I2S_CLK_CONTROL_REG(7 downto 0)));
	lrclk_div_rate		<= to_integer(unsigned(I2S_CLK_CONTROL_REG(23 downto 16)));
	period_len		<= to_integer(unsigned(PERIOD_LEN_REG(15 downto 0)));
	
	process(rd_addr)
	begin
		case rd_addr is
			when 1 => rd_data <=  I2S_CONTROL_REG and x"00000007"; 
			when 2 => rd_data <=  I2S_CLK_CONTROL_REG and x"00ff00ff"; 
			when 6 => rd_data <= PERIOD_LEN_REG and x"0000ffff";
			when 8 => rd_data <=  x"0000000" & rx_fifo_full & rx_fifo_empty & tx_fifo_full & tx_fifo_empty;
			when 10 => rd_data <= rx_sample & std_logic_vector(to_unsigned(cnt, 8));
			when others => rd_data <= (others => '0');
		end case;
	end process;

	process(s00_axi_aclk) is
	begin
		if rising_edge(s00_axi_aclk) then
			if s00_axi_aresetn = '0' then
				I2S_RESET_REG <= (others => '0');
				I2S_CONTROL_REG <= (others => '0');
				I2S_CLK_CONTROL_REG <= (others => '0');
				PERIOD_LEN_REG <= (others => '0');
			else
				-- Auto-clear the Reset Register bits
				I2S_RESET_REG(0) <= '0';
				I2S_RESET_REG(1) <= '0';
				I2S_RESET_REG(2) <= '0';
				if wr_stb = '1' then
					case wr_addr is
						when 0 => I2S_RESET_REG <= wr_data;
						when 1 => I2S_CONTROL_REG <= wr_data;
						when 2 => I2S_CLK_CONTROL_REG <= wr_data;
						when 6 => PERIOD_LEN_REG <= wr_data;
						when others => null;
					end case;
				end if;
			end if;
		end if;
	end process;
	-- User logic ends

end arch_imp;
