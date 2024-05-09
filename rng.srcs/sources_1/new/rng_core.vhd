----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2024 12:04:05 AM
-- Design Name: 
-- Module Name: rng_core - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rng_core is
    generic (
    seed: integer;
    width: integer
    );
    Port (
        clk: in std_logic;
        en: in std_logic;
        dis: in std_logic;
        output: out std_logic_vector(width-1 downto 0)
    );
end rng_core;

architecture Behavioral of rng_core is

    signal count: std_logic_vector (width-1 downto 0):= std_logic_vector(to_unsigned(seed, width));
    signal linear_feedback :std_logic;
    
    
begin
    linear_feedback <= not(count(width-1) xor count(width/2));
  process(clk, en) 
    variable is_enabled: std_logic;
    variable time_counter: integer range 0 to 500000000;
  begin

    if rising_edge(clk) then
    time_counter := time_counter + 1;
      if en = '1' then
        is_enabled := '1';
      end if;

      if dis = '1' then
        is_enabled := '0';
        
      end if;

      if is_enabled = '1' then 
          if time_counter > 40000000 then
                count(width-1 downto 1) <= count(width-2 downto 0);
                count(0) <= linear_feedback;
                time_counter := 0;
          end if;     
      else
            count <= (others=>'0');
      end if;  
    end if;
    output <= count;

  end process;
end Behavioral;
