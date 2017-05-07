clear

% declaring and initializing variables to store values

%state of sensor
state = 0;

%action to perform
action = 0;

% the next state
nextState = 0;

% r is reward variable
r = 0;

% the main Q matrix
QVALUES = [0 0 0 ; 0 0 0 ];

randomNum = 0;
max = 0;
c= 0;

% Alpha and discount are used in Q formula acording to algorithm
alpha = 0.2;     
discount = 0.5;		

exploration = 2; 

% connecting to lego kit using usb 
% this could be done using bluetooth
mylego =  legoev3('usb');


%checking the connection
mylego.beep();

% setting up color sensor and assigning 'color' variable to use in code
% 1 in the arguement as the port number
color  =  colorSensor(mylego , 1);

% setting up both left and right motors to port A and B respectively
leftMotor = motor( mylego , 'A');
leftMotor.Speed = 80;

rightMotor = motor(mylego , 'B');
rightMotor.Speed = 80;


%stop_motor(leftMotor , rightMotor);

%There is no main function in here this while loop is an always true loop
% all the function logic is in it

 while(true)
	% getting the current state i.e based on current sensor value 1 for black 2 otherwise
    state =  getState(color);
   % setting max to a low value so that first time its always less than default i.e 0
	max  =  -32000;
    action = 3;
    
	
	% Getting appropriate action from the Q matrix
    for c = 1:3
        if(QVALUES(state , c) > max)
            max  =  QVALUES(state , c);
            action =  c;
        end
    end
    
    randNum = rand(3);
    
    % executing the action 
    execute(action , state , leftMotor , rightMotor);
    
	% getting next state
    nextState = getState(color);
    %calculate the reward for next state
	r = getReward(nextState);
	
      max = -32000;
      
	  
	  % updating the q matrix
      for c = 1:3
          if(QVALUES(nextState,c) > max)
              max = QVALUES(nextState,c);
          end
          QVALUES(state,action) = (QVALUES(state,action)) + alpha * (r + (discount * max) - QVALUES(state,action));
      end
      
	  
	  % and finally loop back to getting current state again
	  
 end
 

% Implementing Forward Motion 
function move_forward(left , right , speed )
    left.Speed =  speed;
    right.Speed =  speed;
    for i =0:3
       start(left);
        start(right); 
    end
    stop_motor(left , right)
end

% Stoping both motors 
function stop_motor(left , right)
    stop(left);
    stop(right);
end


% Implementing left turning
function turn_left(left , right )

 for i =0:2
    left.Speed =  80;
    right.Speed = -50;
    
       start(left);
        start(right); 
 end
    stop_motor(left , right);
end


% Implementing right turning
function turn_right(left , right )

      for i =0:2 
            left.Speed =  -60;
        right.Speed = 80;
        start(left);
        start(right); 
      end
    stop_motor(left , right);
end


% Implementing reverse
function goback(left , right , j)
    left.Speed =  -80;
    right.Speed = -80;
    for i= 0:j
        start(left);
        start(right);
    end
    stop_motor(left , right);
end


% obtaining state on the base of value from the light sensor
% this sensor reads value from 1 - 100 where values 1-15 
% shows that color is black so if color is black state defined
% is 1 other wise 2
function state=getState(color)
   intensity =  readLightIntensity(color ,'reflected' );
   % 15 refers to black color 
   if(intensity < 15 )
       state = 1;
   else
       state =  2;
   end
end



% getting reward for certain state mostly the next states
% are provided to it in order to check for best next option available

function reward = getReward(state)
    if(state == 1)
        reward  =  50;
    else if(state == 2)
        reward = -20;
        end
    end
end

 
 % This function execute any action that is provided as arguement
 
 function execute(action , state , leftMotor , rightMotor)
    
    switch(action)
        case 1
            move_forward(leftMotor , rightMotor , 80);
        case 2
            turn_left(leftMotor , rightMotor);
        case 3
            turn_right(leftMotor , rightMotor);  
        %case 4
         %   goback(leftMotor , rightMotor);
    end
 
 end

 
 
