library ieee;		--use this library for logic data
use ieee.std_logic_1164.all; --use this library for logic data
use ieee.std_logic_arith.all;		--use this for + and - and ...
use ieee.std_logic_unsigned.all;		--use this for using numbers

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- entity(outputs and inputs) of main circut
entity Elevator is
port	
(
		input :in std_logic_vector(3 downto 0 ); -- floors botton
	    clock,rst :in std_logic;
		output1 , output2 , curfloor:out std_logic_vector( 6 downto 0 ); --signals for led ( location and counter)
		Door , EngineU , EngineD :out std_logic --signals for working door and engine
);
end Elevator;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

architecture RunElevator of Elevator is --mechanism of elevator

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

type state is (Idle ,DoorCloseMoveDown ,ElevatorDown ,DoorCloseMoveUp ,ElevatorUp ,Moving ,Stopping ,DoorOpening ,AtFloor ,ChekingNextDestination); --states of evelator
signal PresentState	 : state ;
signal floor :std_logic_vector(3 downto 0):="0001";--store location
signal carry, notmatter :std_logic;-- use for counting
signal reset :std_logic:='1'; -- use for reseting system
signal O1 ,O2 :STD_LOGIC_vector(3 downto 0);-- output of tens and unit counter
signal tmpinput:std_logic_vector(3 downto 0 ):="0000"; -- for store input until destination

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

component sevensegment is -- a circut for convert a number to seven segment signals
port 
(
		input:in std_logic_vector(3 downto 0) ;	
		output:out std_logic_vector(6 downto 0) 
);

end component;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

component counter is -- a circut for counting number from 0 to 9 with each clock
port 
(
		reset , clock , slct : in std_logic ;
		output : out std_logic_vector(3 downto 0) := "0000";
		carry : out std_logic -- for counting tens

);
end component;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------


begin 
			cntr1 : counter port map(reset,clock,'1',o1( 3 downto 0 ),carry); -- counting unit
			cntr2 : counter port map(reset,clock,carry,o2( 3 downto 0 ),notmatter); -- counting tens
			SSM1 : sevensegment port map(o1(3 downto 0 ),output2); --seven segment monitor for counter unit
			SSM2 : sevensegment port map(o2(3 downto 0 ),output1); --seven segment monitor for counter tens    --prot map assigns the inputs and outputs of circut
			CUR1 : sevensegment port map(floor(3 downto 0 ),curfloor); --seven segment monitor for floor

			
			process(reset,clock) -- runs each time reset and clock changes
			begin
			
			if(rst='1') then
			PresentState<= Idle;  -- reset the evelator
				
			elsif(clock'event and clock='1') then	-- rising edge of clock
			
			
			case PresentState is -- study the state of elevator
			
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	
						when Idle => --duty of elevator in idle state
							
							reset<='0'; --set for counting
							tmpinput<=input;-- stores input until destination
							
							if((tmpinput="0000")or(tmpinput=floor)) then --no input or current floor Choosed
									reset<='1'; -- reset the counter
							
							elsif((o2 = "0011")and(o1 = "0000")) then --30(s) waited
									
									if(tmpinput > floor) then -- if the destination upper than location
											PresentState<= DoorCloseMoveUp ; --go to next state
											reset<='1';-- reset the counter
											
									elsif(tmpinput < floor) then -- if the destination downer than location
											presentstate<= DoorCloseMoveDown ;--go to next state
											reset<='1';-- reset the counter
									else 
										PresentState<= Idle;--stay at this state
									end if;
							end if;
							
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
							
						when DoorCloseMoveUp =>--duty of elevator in DoorCloseMoveUp state
							
							reset<='0';--set for counting
							Door<='1'; --signal for opening door
							
							if((o2 = "0000")and(o1 = "0101")) then --05(s) waited
							PresentState<=  ElevatorUp;--go to next state
							floor <= floor+1;-- go up elevator a floor
							reset <= '1';-- reset the counter
							else 
										PresentState<=  DoorCloseMoveUp;--stay at this state
							end if;
							
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
							
						when ElevatorUp =>--duty of elevator in ElevatorUp state
						
							reset<='0';--set for counting
							EngineU<='1';-- the signal for turn on the engine for going up
							
							if((o2 = "0000")and(o1 = "0001")) then --01(s) waited
							PresentState<= Moving;--go to next state
							reset<='1';-- reset the counter
							else  
										PresentState<=  ElevatorUp;--stay at this state
							end if;
							
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
							
						when DoorCloseMoveDown =>--duty of elevator in DoorCloseMoveDown state
						
							reset<='0';--set for counting
							Door<='1';--signal for opening door

							
							if((o2 = "0000")and(o1 = "0101")) then -- 05(s) waited
							PresentState<=  ElevatorDown;--go to next state
							floor <= floor-1;--go down elevator a floor
							reset <= '1';-- reset the counter
							else 
										PresentState<= DoorCloseMoveDown;--stay at this state
							end if;

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

						when ElevatorDown =>--duty of elevator in ElevatorDown state
							
							reset<='0';--set for counting
							EngineD<='1'; -- the signal for turn on the engine for going down

							
							if((o2 = "0000")and(o1 = "0001")) then -- 01(s) waited
							PresentState<= Moving;--go to next state
							reset <= '1';-- reset the counter
							else 
										PresentState<= ElevatorDown;--stay at this state
							end if;
							
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
							
						when Moving =>--duty of elevator in Moving state
							
							reset<='0';--set for counting
							
							if((o2 = "0000")and(o1 = "0101"))then -- 05(s) waited
							
								if(tmpinput = floor) then
								
									PresentState<=  Stopping;--go to next state
									reset <= '1';-- reset the counter
									
								elsif(tmpinput  > floor) then-- if location of elevator downer than choosed destination
								
									floor<=floor+1;	
									PresentState<=  Moving ;--stay at this state
									reset <= '1';-- reset the counter
									
								elsif(tmpinput < floor) then-- if location of elevator upper than choosed destination
								
									floor <= floor-1;
									PresentState<=  Moving ;--stay at this state
									reset <= '1';-- reset the counter
									
								else 
								
								PresentState<=  Moving;--stay at this state			
								
								end if;
							end if;
							
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
			
						when Stopping =>--duty of elevator in Stopping state
							
							EngineD<='1';
							EngineU<='1'; -- the both signals means braking elevator (ترمز کردن)
							
							reset<='0';--set for counting
							
							if(o2 = "0000")and(o1 = "0101") then -- 05(s) waited
								PresentState<=  DoorOpening;--go to next state
								EngineD<='0';
								EngineU<='0';--the both signals set off for full stop
								reset <= '1';-- reset the counter
							else 
										PresentState<=  Stopping;--stay at this state
							end if;
							
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
							
						when DoorOpening =>--duty of elevator in DoorOpening state

							reset<='0';--set for counting
							Door<='0';--signal for closing door
							
							if(o2 = "0000")and(o1 = "0101") then -- 05(s) waited
								PresentState<=  AtFloor;--go to next state
								reset <= '1';-- reset the counter
							else 
										PresentState<=  DoorOpening;--stay at this state
							end if;	

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

							
						when AtFloor =>--duty of elevator in AtFloor state
						
							reset<='0';--set for counting
							
							if(o2 = "0000")and(o1 = "0101") then -- 05(s) waited
								PresentState<=  ChekingNextDestination;--go to next state
								reset <= '1';-- reset the counter
								else 
										PresentState<=  AtFloor;--stay at this state
							end if;	
							
------------------------------------------------------------------------------------------------------------------------------------------------------------------------
							
						when ChekingNextDestination =>--duty of elevator in ChekingNextDestination state
							
							
							reset<='0';--set for counting
							
							tmpinput<=input;-- stores input until destination
							
							if(tmpinput="0000")then--no input
							
							if((o2 = "0100")and(o1 = "0101"))then --45(s)waited
							
									PresentState<=  Idle;--go to next state
									reset<='1';-- reset the counter
							end if;
							elsif((tmpinput > floor)and((o2 = "0011")and(o1 = "0000"))) then -- 30 (s) waited and choose destination
									PresentState<=  DoorCloseMoveUp ;--go to next state
									reset<='1';-- reset the counter
						 
							elsif((tmpinput < floor)and((o2 = "0011")and(o1 = "0000"))) then -- 30 (s) waited and choose destination
									PresentState<=  DoorCloseMoveDown ;--go to next state
									reset<='1';-- reset the counter

							else 
									PresentState <= ChekingNextDestination ;--stay at this state
							
							end if;

							
							
			end case; 	
			end if;
			end process;


end RunElevator;