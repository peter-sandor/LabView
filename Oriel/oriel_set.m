global oriel_session settings counter

global pos
settings.oriel_com = 'COM8';
counter = 0;

motor = 1;
val1 = 150;
val2 = 160;
if pos == val1
    pos = val2;
else
    pos = val1;
end
waiting = 0.1;

warning('off','all');

% oriel_session = serial(settings.oriel_com, 'BaudRate', 19200, 'DataBits', 8, 'Terminator', 13, 'Timeout', 0.1); % \n 10; \r 13
temp=instrfind;
% fopen(oriel_session);
oriel_session = temp(7);

%%
try 
    flushinput(oriel_session);

    if counter == 0
        % if at the beginning of the scan, make sure the controller is in
        % remote
        % set the controller to remote mode
        msg = oriel_getter('R');

        if isempty(msg)
            msg_stripped = '';
            disp('Oriel now REMOTE, was REMOTE');
        else
            msg_stripped = strip(msg);
            disp(['Oriel message: ' msg_stripped]);
            disp('Oriel now REMOTE, was LOCAL');
        end
    end
    tic;
    % select motor
    cmd = ['M' num2str(motor, '%d') 13];
    msg = oriel_getter(cmd);

    tic;
    cmd = ['G' num2str(pos, '%1.1f') 13];
    %disp(cmd);
    fprintf(oriel_session, cmd);
    
    % give it time to react
    pause(0.05);
    % clear buffer from the move command answer
    flushinput(oriel_session);
    
    % monitor state of motion with 'Z' command
    cmd = ['Z'];
    fprintf(oriel_session, cmd);
    answer = strip(fgets(oriel_session));
    
    disp(answer);
    while answer~='a'
        
        fprintf(oriel_session, cmd);
        answer = strip(fgets(oriel_session));
        %disp(answer);
        pause(waiting);
    end
    toc
    warning('on','all');
catch e
    fclose(oriel_session);
    throw(e);
end

fclose(oriel_session);

