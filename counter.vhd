library ieee;		--use this library for logic data
use ieee.std_logic_1164.all; --use this library for logic data
use ieee.std_logic_arith.all;		--use this for + and - and ...
use ieee.std_logic_unsigned.all;		--use this for using numbers
------------------------------------------------------------------------------------------------------------------------------------------------------------------------



entity counter is -- entity(outputs and inputs) of counter circut
port 
(
		reset , clock ,slct : in std_logic ;--slct for counting tens
		output : out std_logic_vector(3 downto 0) ; -- 4bit number
		carry : out std_logic:='0'--for counting tens

);
end counter;
------------------------------------------------------------------------------------------------------------------------------------------------------------------------


architecture mycounter of counter is 

signal countholder : std_logic_Vector(3 downto 0):="0000";--for changing the number in clock edge

begin 
		output <= countholder;-- assign the count to output of circut
		process ( reset , clock ) -- runs each time reset and clock changes
		begin
		
		if(countholder ="1001" ) then carry <= '1' ;-- if see 9 then the next counter(tens) start counting
					else carry<='0';-- else the next counter(tens) stopping counting
					end if;
		
			
			if ( reset = '1') then countholder <= "0000"; -- reset counter
			
			elsif ((clock'event and clock ='1' )and slct = '1') then -- slct for counting numbers in tens , thousonds and ... in rising edge clock
					
					if (countholder = "1001") then 	countholder <= "0000"; -- if counter arrived at 9 then next number is 0
																
						else countholder <= countholder +1; -- incarise number form 0 to 9
						
					end if;
			end if;	
		
		end process;
		


end mycounter; 

