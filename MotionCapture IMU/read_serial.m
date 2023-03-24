clc
clear all
delete(instrfindall);
%% Create serial object for Arduino
baudrate = 38400;
%baudrate = 1200;
b = serial('COM4','BaudRate',baudrate); % change the COM Port number as needed
b.ReadAsyncMode = 'manual';
set(b,'InputBufferSize',255);

c=0;
data(1) = 'a';
%% Connect the serial port to Arduino
try
    fopen(b);
catch err
    fclose(instrfind);
    error('Make sure you select the correct COM Port where the Arduino is connected.');
end

Flag_Initializing = true;

while(Flag_Initializing &&(c<=6000))
    while(strcmp(b.TransferStatus,'read'))
        pause(0.01);
    end    
    
   c=c+1;
   
    readasync(b);
    sms = fscanf(b);
    fprintf(sms)
%     if ~strcmp(sms(1:3),'ypr')
%         fprintf(sms)
%     else
%         Flag_Initializing = false;
%     end

    data(c) = sms;
end

Flag_Initializing = false;


fclose(b);
delete(instrfindall);

