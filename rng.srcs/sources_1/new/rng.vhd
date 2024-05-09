----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 05/09/2024 12:05:27 AM
-- Design Name: 
-- Module Name: rng - Behavioral
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
use IEEE.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rng is
    port(
        clk: in std_logic;
        en_p: in std_logic;
        dis_p: in std_logic;
        out_p: out std_logic;
        seg : out STD_LOGIC_VECTOR (6 downto 0);
        an : out STD_LOGIC_VECTOR (3 downto 0)
    );
end rng;



architecture Behavioral of rng is
    
    signal core_out_s: STD_LOGIC_VECTOR (15 downto 0);
    signal lcd_val_s: STD_LOGIC_VECTOR (3 downto 0);
    signal refresh_counter_s: STD_LOGIC_VECTOR (19 downto 0);
    signal sg_counter_s: std_logic_vector (1 downto 0);
    
    component rng_core
    generic (
        seed: integer;
        width: integer
    );
    Port (
        clk: in std_logic;
        en: in std_logic;
        dis: in std_logic;
        output: out STD_LOGIC_VECTOR (15 downto 0)
    );
    end component rng_core;
    
begin

    r_core: rng_core
    generic map(
        seed => 5,
        width => 16
    )
    port map(
        clk => clk,
        en => en_p,
        dis => dis_p,
        output => core_out_s
    );
    
    process(clk, dis_p)
    begin 
        if(dis_p='1') then
            refresh_counter_s <= (others => '0');
        elsif(rising_edge(clk)) then
            refresh_counter_s <= refresh_counter_s + 1;
        end if;
    end process;
    
    sg_counter_s <= refresh_counter_s(19 downto 18);
    
    process(sg_counter_s)
    begin
        case sg_counter_s is
        when "00" =>
            an <= "0111";
            lcd_val_s <= core_out_s(15 downto 12);
        when "01" =>
            an <= "1011";
            lcd_val_s <= core_out_s(11 downto 8);
        when "10" =>
            an <= "1101";
            lcd_val_s <= core_out_s(7 downto 4);
        when "11" =>
            an <= "1110";
            lcd_val_s <= core_out_s(3 downto 0);
        end case;
    end process;
    
    process(lcd_val_s)
    begin
        case lcd_val_s is
            when "0000" => seg <= "0000001"; -- "0"     
            when "0001" => seg <= "1001111"; -- "1" 
            when "0010" => seg <= "0010010"; -- "2" 
            when "0011" => seg <= "0000110"; -- "3" 
            when "0100" => seg <= "1001100"; -- "4" 
            when "0101" => seg <= "0100100"; -- "5" 
            when "0110" => seg <= "0100000"; -- "6" 
            when "0111" => seg <= "0001111"; -- "7" 
            when "1000" => seg <= "0000000"; -- "8"     
            when "1001" => seg <= "0000100"; -- "9" 
            when "1010" => seg <= "0000010"; -- a
            when "1011" => seg <= "1100000"; -- b
            when "1100" => seg <= "0110001"; -- C
            when "1101" => seg <= "1000010"; -- d
            when "1110" => seg <= "0110000"; -- E
            when "1111" => seg <= "0111000"; -- F
        end case;
    end process;


end Behavioral;