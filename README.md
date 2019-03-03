# GIT-To-NCS-Replication-Script

The  purpose of this script is to allow a user to trigger it by uploading a text file into a specified folder. In addition, the script is meant to be ran via the Windows Task Scheduler  (by passing in all of the necessary information as arguments to a command executed by a task instance).

This script was written for Digital First Media so they could commit their template changes to one location on a file server hosted by NEWSCYCLE Solutions (NCS). The script takes the commited files/folders and moves them to different target directories (all cluster, environment, and site code information is passed to the script via arguments). The script also runs an instance of Beyond Compare for each file by comparing the committed files that were checked into the source directory against the files in the target directory.

# How it works

1. Tasks should be setup and the necessary environment, cluster, and site code information  should be added to it as arguments. So the command should look like these:

ReplicateUsingBeyondCompare.cmd jrc "dev stage web" "bm dc df dl dt hr jr md mi mj mp ms nh od op pv rc ro sc st tr tt ww zz"

ReplicateUsingBeyondCompare.cmd mn1 "dev stage web" "aa ab la lb lc ld le lf lg lh li zz"

2. When these executed, the script checks a directory for a certain file. The file name determines which files are replicated over to a target directory. For example, jrcdev.txt will copy the files for JRC's Dev sites (JRC is a cluster code, Dev is the environment) See the file_templates folder for more examples of text files that can be uploaded.

3.  a.) The script reads the first argument which is the cluster code and then assigns a variable to it.
    b.) The script then loops through a list of environments (the outer loop). T
    c.) Then an inner loop is ran which for each site code.
    d.) Both of these loops contain logic for running the Beyond Compare instances and forming different strings for directory paths.

Note: The Beyond Compare program reads a configuration file called BeyondCompareUpdate.txt. This configuration file determines where the log files should be stored, which compare type should be used, etc.


4. Finally, once the script finishes going through the list of environments and site codes for each environment, it deletes the text file that was uploaded.



