library ieee;
use ieee.std_logic_1164.all;
 
entity Debounce_Project_Top is
  port (
    i_Clk       : in  std_logic;
    i_Switch_1  : in  std_logic;
    o_LED_1     : out std_logic
    );
end entity Debounce_Project_Top;
 
architecture RTL of Debounce_Project_Top is
 
  signal r_LED_1    : std_logic := '0';
  signal r_Switch_1 : std_logic := '0';
  signal w_Switch_1 : std_logic;
   
begin
 
  -- Instantiate Debounce Filter
  Debounce_Inst : entity work.Debounce_Switch
    port map (
      i_Clk    => i_Clk,
      i_Switch => i_Switch_1,
      o_Switch => w_Switch_1);
 
  -- Purpose: Toggle LED output when w_Switch_1 is released.
  p_Register : process (i_Clk) is
  begin
    if rising_edge(i_Clk) then
      r_Switch_1 <= w_Switch_1;         -- Creates a Register
 
      -- This conditional expression looks for a falling edge on i_Switch_1.
      -- Here, the current value (i_Switch_1) is low, but the previous value
      -- (r_Switch_1) is high.  This means that we found a falling edge.
      if w_Switch_1 = '0' and r_Switch_1 = '1' then
        r_LED_1 <= not r_LED_1;         -- Toggle LED output
      end if;
    end if;
  end process p_Register;
 
  o_LED_1 <= r_LED_1;
 
end architecture RTL;