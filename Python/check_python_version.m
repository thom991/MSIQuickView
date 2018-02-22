function check_python_version()
[version, executable, isloaded] = pyversion;
fprintf('Python version is %s.\n', version);
fprintf('Python exe is located at %s.\n', executable);
fprintf('Is Python loaded? %s.\n', num2str(isloaded));