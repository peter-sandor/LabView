function msg = oriel_getter(cmd)
    % This function sends message and will read everything from serial port until timeout
    % concatenate all the messages in one string 'msg'
    global oriel_session
    
    fprintf(oriel_session, cmd);

    msg = [];
    answer = fgets(oriel_session);
    while ~isempty(answer)
        answer = fgets(oriel_session);
        msg = [msg answer];
    end
end