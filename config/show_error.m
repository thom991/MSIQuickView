function show_error(MExc)
    disp(getReport(MExc, 'extended'))
    msgbox('Please check error file for details','Unexpected Error','error');
    stop_logging();
    
function stop_logging()
    diary off
end

end