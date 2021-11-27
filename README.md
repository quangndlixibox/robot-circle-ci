# lixibox-auto-api

This is the first source code for automation API for LIXIBOX Project

Setup instruction to run in local:

- Install Python 3.9 or above
- Install Pycharm (optional, if you just need to run Test script you do not need to install Pycharm)
- Install Robot Framework 4.1 or above and relevant library in requirements file, using command line:

```
pip3 install -r requirements.txt
```

To run the Test Case, using command line:

```
robot -v URL:https://api.lxb-qa.cf -L debug -T -d Results TestCase/TestCase.robot
```
Where:
- `-v URL:https://api.lxb-qa.cf` is variable for URL, we can replace with others URL 
- `-L debug` (optional) is running the code and show the log file in debug mode
- `-T` (optional) is time-stamp which will be added to report file name.
- `-d Results` is location where the report file will locate
- `TestCase/TestCase.robot` is the path to selected test case file need to run. If we need to 
