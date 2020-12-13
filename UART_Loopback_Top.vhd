library ieee;
use ieee.std_logic_1164.all;
 
entity UART_Loopback_Top is
  port (
    -- Main Clock (25 MHz)
    i_Clk         : in std_logic;
 
    -- UART Data
    i_UART_RX : in  std_logic;
    o_UART_TX : out std_logic;
     
    -- Segment1 is upper digit, Segment2 is lower digit
    o_Segment1_A  : out std_logic;
    o_Segment1_B  : out std_logic;
    o_Segment1_C  : out std_logic;
    o_Segment1_D  : out std_logic;
    o_Segment1_E  : out std_logic;
    o_Segment1_F  : out std_logic;
    o_Segment1_G  : out std_logic;
     
    o_Segment2_A  : out std_logic;
    o_Segment2_B  : out std_logic;
    o_Segment2_C  : out std_logic;
    o_Segment2_D  : out std_logic;
    o_Segment2_E  : out std_logic;
    o_Segment2_F  : out std_logic;
    o_Segment2_G  : out std_logic
    );
end entity UART_Loopback_Top;
 
architecture RTL of UART_Loopback_Top is
 
  signal w_RX_DV     : std_logic;
  signal w_RX_Byte   : std_logic_vector(7 downto 0);
  signal w_TX_Active : std_logic;
  signal w_TX_Serial : std_logic;
   
  signal w_Segment1_A, w_Segment2_A : std_logic;
  signal w_Segment1_B, w_Segment2_B : std_logic;
  signal w_Segment1_C, w_Segment2_C : std_logic;
  signal w_Segment1_D, w_Segment2_D : std_logic;
  signal w_Segment1_E, w_Segment2_E : std_logic;
  signal w_Segment1_F, w_Segment2_F : std_logic;
  signal w_Segment1_G, w_Segment2_G : std_logic;
 
begin
 
  UART_RX_Inst : entity work.UART_RX
    generic map (
      g_CLKS_PER_BIT => 217)            -- 25,000,000 / 115,200
    port map (
      i_Clk       => i_Clk,
      i_RX_Serial => i_UART_RX,
      o_RX_DV     => w_RX_DV,
      o_RX_Byte   => w_RX_Byte);
 
 
  -- Creates a simple loopback to test TX and RX
  UART_TX_Inst : entity work.UART_TX
    generic map (
      g_CLKS_PER_BIT => 217)               -- 25,000,000 / 115,200 = 217
    port map (
      i_Clk       => i_Clk,
      i_TX_DV     => w_RX_DV,
      i_TX_Byte   => w_RX_Byte,
      o_TX_Active => w_TX_Active,
      o_TX_Serial => w_TX_Serial,
      o_TX_Done   => open
      );
 
  -- Drive UART line high when transmitter is not active
  o_UART_TX <= w_TX_Serial when w_TX_Active = '1' else '1';
   
  
  -- Binary to 7-Segment Converter for Upper Digit
  SevenSeg1_Inst : entity work.Binary_To_7Segment
    port map (
      i_Clk        => i_Clk,
      i_Binary_Num => w_RX_Byte(7 downto 4),
      o_Segment_A  => w_Segment1_A,
      o_Segment_B  => w_Segment1_B,
      o_Segment_C  => w_Segment1_C,
      o_Segment_D  => w_Segment1_D,
      o_Segment_E  => w_Segment1_E,
      o_Segment_F  => w_Segment1_F,
      o_Segment_G  => w_Segment1_G
      );
   
  o_Segment1_A <= not w_Segment1_A;
  o_Segment1_B <= not w_Segment1_B;
  o_Segment1_C <= not w_Segment1_C;
  o_Segment1_D <= not w_Segment1_D;
  o_Segment1_E <= not w_Segment1_E;
  o_Segment1_F <= not w_Segment1_F;
  o_Segment1_G <= not w_Segment1_G;
   
   
  -- Binary to 7-Segment Converter for Lower Digit
  SevenSeg2_Inst : entity work.Binary_To_7Segment
    port map (
      i_Clk        => i_Clk,
      i_Binary_Num => w_RX_Byte(3 downto 0),
      o_Segment_A  => w_Segment2_A,
      o_Segment_B  => w_Segment2_B,
      o_Segment_C  => w_Segment2_C,
      o_Segment_D  => w_Segment2_D,
      o_Segment_E  => w_Segment2_E,
      o_Segment_F  => w_Segment2_F,
      o_Segment_G  => w_Segment2_G
      );
   
  o_Segment2_A <= not w_Segment2_A;
  o_Segment2_B <= not w_Segment2_B;
  o_Segment2_C <= not w_Segment2_C;
  o_Segment2_D <= not w_Segment2_D;
  o_Segment2_E <= not w_Segment2_E;
  o_Segment2_F <= not w_Segment2_F;
  o_Segment2_G <= not w_Segment2_G;
   
end architecture RTL;
