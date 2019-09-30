Allwinner V3(s) action camera firmware backup instructions for Linux:

1. install 'zip' and 'adb' tools if not already installed by doing the following:

1a. open a terminal window and type the command text below and press Enter key

     sudo apt-get update ; sudo apt-get install adb zip -y

2. Connect your camera to PC with a USB cable. Select 'Charging mode' and press OK.

3. open a terminal window and type the command text below and press Enter key

        chmod 755 ./backup.sh ; ./backup.sh

or      bash ./backup.sh

3a. Answer whether or not you want to create a compressed archive 'backup.zip'
    of all firmware files. Please answer 'yes' to this question.
3b. If 'backup.sh' script does not work, try 'backup2.sh' script ((WORK IN PROGRESS))

        chmod 755 ./backup2.sh ; ./backup2.sh

or      bash ./backup2.sh

4. Wait until done.
5. See new files in current folder and in 'backup' folder
6. rename and share your 'backup.zip' file online Goprawn forums via online cloud-storage

Check Allwinner V3 section in www.Goprawn.com action cam discussion forums online
and check the Facebook group http://fb.com/241278666305379 online for more.
Send me a message directly at http://fb.com/psvangorp or by email
petesimon (at) yahoo.com . Thanks for sharing.

                   ______        ____                                      
                  / ____/____   / __ \ _____ ____ _ _      __ ____         
                 / / __ / __ \ / /_/ // ___// __ `/| | /| / // __ \        
                / /_/ // /_/ // ____// /   / /_/ / | |/ |/ // / / /        
                \____/ \____//_/    /_/    \__,_/  |__/|__//_/ /_/         
             ___          __   _                  ______                   
            /   |  _____ / /_ (_)____   ____     / ____/____ _ ____ ___    
           / /| | / ___// __// // __ \ / __ \   / /    / __ `// __ `__ \   
          / ___ |/ /__ / /_ / // /_/ // / / /  / /___ / /_/ // / / / / /   
         /_/  |_|\___/ \__//_/ \____//_/ /_/   \____/ \__,_//_/ /_/ /_/    
    __  __              __            ___        __  ___            __     
   / / / /____ _ _____ / /__ _____   ( _ )      /  |/  /____   ____/ /_____
  / /_/ // __ `// ___// //_// ___/  / __ \/|   / /|_/ // __ \ / __  // ___/
 / __  // /_/ // /__ / ,<  (__  )  / /_/  <   / /  / // /_/ // /_/ /(__  ) 
/_/ /_/ \__,_/ \___//_/|_|/____/   \____/\/  /_/  /_/ \____/ \__,_//____/  

https://www.goprawn.com

