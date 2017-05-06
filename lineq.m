clear
state = 0;
action = 0;
nextState = 0;
r = 0;
QVALUES = [0 0 0 ; 0 0 0 ];
randomNum = 0;
max = 0;

c= 0;

 alpha = 0.2;     

        discount = 0.5;		

	exploration = 2; 

mylego =  legoev3('usb');

mylego.beep();

color  =  colorSensor(mylego , 1);

leftMotor = motor( mylego , 'A');
leftMotor.Speed = 80;

rightMotor = motor(mylego , 'B');
rightMotor.Speed = 80;


%stop_motor(leftMotor , rightMotor);

 while(true)
    state =  getState(color);
    max  =  -32000;
    action = 3;
    
    for c = 1:3
        if(QVALUES(state , c) > max)
            max  =  QVALUES(state , c);
            action =  c;
        end
    end
    
    randNum = rand(3);
    
    
    execute(action , state , leftMotor , rightMotor);
    
    nextState = getState(color);
    r = getReward(nextState);
      max = -32000;
      
      for c = 1:3
          if(QVALUES(nextState,c) > max)
              max = QVALUES(nextState,c);
          end
          QVALUES(state,action) = (QVALUES(state,action)) + alpha * (r + (discount * max) - QVALUES(state,action));
      end
      
 end
 


function move_forward(left , right , speed )
    left.Speed =  speed;
    right.Speed =  speed;
    for i =0:3
       start(left);
        start(right); 
    end
    stop_motor(left , right)
end

function stop_motor(left , right)
    stop(left);
    stop(right);
end


function turn_left(left , right )

 for i =0:2
    left.Speed =  80;
    right.Speed = -50;
    
       start(left);
        start(right); 
 end
    stop_motor(left , right);
end

function turn_right(left , right )

      for i =0:2 
            left.Speed =  -60;
        right.Speed = 80;
        start(left);
        start(right); 
      end
    stop_motor(left , right);
end

function goback(left , right , j)
    left.Speed =  -80;
    right.Speed = -80;
    for i= 0:j
        start(left);
        start(right);
    end
    stop_motor(left , right);
end



function state=getState(color)
   intensity =  readLightIntensity(color ,'reflected' );
   if(intensity < 15 )
       state = 1;
   else
       state =  2;
   end
end




function reward = getReward(state)
    if(state == 1)
        reward  =  50;
    else if(state == 2)
        reward = -20;
        end
    end
end

 
 
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

 
 
