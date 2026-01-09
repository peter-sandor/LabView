global oriel_session settings

settings.oriel_com = 'COM8';

travel = 10; % microns

oriel_session = serial(settings.oriel_com, 'BaudRate', 19200, 'DataBits', 8, 'Terminator', 13, 'Timeout', 0.1); % \n 10; \r 13

fopen(oriel_session);
try 
    flushinput(oriel_session);

    % fprintf(oriel_session, 'R');
    % 
    % msg = [];
    % answer = fgets(oriel_session);
    % while ~isempty(answer)
    %     answer = fgets(oriel_session);
    %     msg = [msg answer];
    % end
    % 
    % 

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

    %disp(['Oriel says: ' msg_stripped]);


catch e
    fclose(oriel_session);
    throw(e);
end

fclose(oriel_session);

