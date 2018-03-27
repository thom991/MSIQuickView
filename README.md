#MSIQuickView

#To get things running on Stampede2:

#Login into Stampede2

#clone the Repo (send me your git username if its denies permission):

#git -c http.sslVerify=false clone https://github.com/thom991/MSIQuickView.git

#Request an interactive node (example below for 120 minutes):

#login3.stampede2(13)$ idev -m 120

#This will start the dedicated node.

#Now lets load matlab

#c455-092[knl](16)$ module load matlab

#c455-092[knl](16)$ matlab

#This will start matlab.

#Manually add these path to MATLAB each time, annoying, it resulted from some major 
#code refactoring and will eventually be sorted out. Until then, it needs to be done 
#manually each time.

#javaaddpath(['Proven' filesep 'ProvenServerClientJavaAPI-all-1.0.jar'])

#addpath(genpath(pwd))

#MSI_QuickView_Real_Time_Visualization_GUI

#OR 

#double-click 'MSI_QuickView_Real_Time_Visualization_GUI.fig' inside "UI/m-files"

#This will open Real-time UI

#Now select Clear All and then Browse for the dataset and select the first RAW file.
#Note you will need the XCalibur software installed to process the RAW files. Julia should have it, 
#however, previous versions have only been released for Windows Platforms. To work around this, you 
#will need to perform the file conversion on a Windows machine first. MSIQuickView looks for the following file 
#structure within each dataset

#/LungMap DatasetI

###/RAW

#####/dlung1.RAW

#####/dlung2.RAW...

###/CDF

#####/dlung1.cdf

#####/dlung2.cdf...

#As long as the cdf files are present, it will run file on Stampede2.
