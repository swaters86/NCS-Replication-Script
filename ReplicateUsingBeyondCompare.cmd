@echo off 

	REM Setting display settings for the command-prompt window  
	mode con:cols=89 lines=90

	REM Getting arguments from the task instance 
	set clustercode=%1

	set environments_string=%2

	for /f "tokens=*" %%x in (%environments_string%) do (
		set environments=%%x
	) 
	REM End FOR loop for getting list of environments from task arguments 

	REM End FOR loop for getting list of site codes from task arguments

for %%e in (%environments%) do (

	setlocal enabledelayedexpansion

	echo.
	echo Checking to see if file exist for %%e ...
	echo.

	set environment_path=\\sxatl\mn1\sites\MN1\Z_Temp_Checkout_Folder\CheckMeBeforeYouRun\%clustercode%%%e.txt

	if exist !environment_path! (
		
		echo.
		echo #########################################################################################
		echo. 
		echo ############### Starting Compare for Global Files for %%e ###############################
		echo. 
		echo #########################################################################################
		echo.

		set globals_source_path=\\sxatl\mn1\sites\MN1\Z_Temp_Checkout_Folder\%%e\Globals

		set globals_destination_path=\\sxatl\mn1\sites\MN1\Z_Temp_Checkout_Folder\Target\%%e\globals

		REM Checking if a folder for the global templates exist 

		if not exist !globals_destination_path! (

			echo -----------------------------------------------------------------------------------------
			echo.
			echo Creating directory !globals_destination_path!
			echo.
			echo -----------------------------------------------------------------------------------------

			mkdir !globals_destination_path! 

		) else (

			echo *****************************************************************************************
			echo.
			echo A global directory for %%e already exist or it could not be created.
			echo.
			echo *****************************************************************************************

		)

		REM Comparing source folder to destination folder contents by using Beyond Compare. 

		echo.
		echo comparing !globals_source_path! to !globals_destination_path! 
		echo.

		"C:\Program Files (x86)\Beyond Compare 3\BCompare.exe" /closescript  "@e:\Scripts\DFM_Template_Replication\BeyondCompareUpdate.txt" !globals_source_path! !globals_destination_path! 

		echo.
		echo Files moved for global files 
		echo.

		echo.
		echo #########################################################################################
		echo. 
		echo ############### Starting Compare for Site Code Folders in %%e ###########################
		echo. 
		echo #########################################################################################
		echo.

		REM iterate through sitecodes and create necessary site code folders 
		REM and/or or start comparing the source folder and the destination folder by using Beyond Compare

		for /f "delims=, tokens=1,2" %%s in (\\sxjoutl001\e$\Files\%clustercode%SiteCodes.txt) do (

			set source_path=\\sxatl\mn1\sites\MN1\Z_Temp_Checkout_Folder\%%e\%clustercode%\%%s

			set destination_path=\\sxatl\mn1\sites\MN1\Z_Temp_Checkout_Folder\Target\%%e\%clustercode%\%%s

			if not exist !destination_path! (

			echo -----------------------------------------------------------------------------------------
			echo.
			echo Creating directory !destination_path!
			echo.
			echo -----------------------------------------------------------------------------------------

			mkdir !destination_path!

			) else (

				echo *****************************************************************************************
				echo.
				echo Directory for site %%s in %%e already exist or it could not be created. 
				echo.
				echo *****************************************************************************************
				
			)	

			echo.
			echo comparing !source_path! to !destination_path!
			echo.

			"C:\Program Files (x86)\Beyond Compare 3\BCompare.exe" /closescript  "@e:\Scripts\DFM_Template_Replication\BeyondCompareUpdate.txt" !source_path! !destination_path!

		)
		
		echo.
		echo Files moved for site specific folders
		echo.

		echo.
		echo File found for %%e
		echo.

		echo.
		echo #########################################################################################
		echo. 
		echo ############### Starting Compare for Config Files for %%e ###############################
		echo. 
		echo #########################################################################################
		echo. 

		set config_source_path=\\sxatl\mn1\sites\MN1\Z_Temp_Checkout_Folder\%%e\%clustercode%\configFiles

		set config_destination_path=\\sxatl\mn1\sites\MN1\Z_Temp_Checkout_Folder\Target\%%e\%clustercode%\configFiles

		REM Checking if a folder for the config files exist

		if not exist !config_destination_path! (

			echo -----------------------------------------------------------------------------------------
			echo.
			echo Creating directory !config_destination_path! 
			echo.
			echo -----------------------------------------------------------------------------------------

			mkdir !config_destination_path!

		) else (

			echo *****************************************************************************************
			echo.
			echo Directory for config files directory for %%e already exist or it could not be created.
			echo.
			echo *****************************************************************************************

		)

		REM Comparing source folder to destination folder contents by using Beyond Compare

		echo.
		echo comparing !config_source_path! to !config_destination_path!
		echo.

		"C:\Program Files (x86)\Beyond Compare 3\BCompare.exe" /closescript  "@e:\Scripts\DFM_Template_Replication\BeyondCompareUpdate.txt" !config_source_path! !config_destination_path! 

		echo.
		echo Files moved for config files
		echo.


	) else (

		echo *****************************************************************************************
		echo.
		echo file NOT found for %%e
		echo.
		echo *****************************************************************************************

	)
	
	REM End of the decision that checks to see if the customer uploaded text file exists for each environment

	REM Removing the customer uploaded text files 

	if exist !environment_path! (

	del !environment_path!

	echo -----------------------------------------------------------------------------------------
	echo.
	echo !environment_path! was deleted
	echo.
	echo -----------------------------------------------------------------------------------------

	) else (

		echo.
		echo !environment_path! doesn't exist so it cannot be deleted
		echo.

	)

) 
 REM End FOR loop for getting each environment from the environments_string variable




