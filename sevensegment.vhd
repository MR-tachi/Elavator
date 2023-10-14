library ieee;		--use this library for logic data
use ieee.std_logic_1164.all; --use this library for logic data
use ieee.std_logic_arith.all;		--use this for + and - and ...
use ieee.std_logic_unsigned.all;		--use this for using numbers

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

entity sevensegment is --entity(outputs and inputs) of 7segment circut
port 
(
		input :in std_logic_vector(3 downto 0 );
		output:out std_logic_vector(6 downto 0) 


);
end sevensegment;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

architecture show of sevensegment is -- convert a 4bit number to 7signals for 7segment show

begin

		
		process(input)
		begin
				case input is  -- its like a encoder 
						when "0000" => output <= "1111110"; --"0"
						when "0001" => output <= "0110000"; --"1"
						when "0010" => output <= "1101101"; --"2"
						when "0011" => output <= "1111001"; --"3"
						when "0100" => output <= "0110011"; --"4"
						when "0101" => output <= "1011011"; --"5"
						when "0110" => output <= "1011111"; --"6"
						when "0111" => output <= "1110000"; --"7"
						when "1000" => output <= "1111111"; --"8"
						when "1001" => output <= "1111011"; --"9"
						when others => output <= "0000000"; -- "OFF"
						
						end case;
										--       1
										--		 -----
										--    |		|
										--	  6|	7  |2
										--		 -----
										--		|		|
										--	  5|   	|3
										--		 -----
										--       4
		
	  end process;

end show;