# Mule-3.x.x standalone log4j2 update-script

*This is my first time writing a shell script, so I don't take any responsibility for anything. Neither the contents, nor your system, before or after using this script.
Please make a backup, beforehand.*

## About <a name = "about"></a>

This script will automate the steps laid out by mulesoft to update the log4j2 binaries in the mule 3.x.x standalone package. To remedy the log4shell vulnerabilities up to CVE-2021-44832.
https://logging.apache.org/log4j/2.x/


## Description <a name = "desc"></a>

Mulesoft has released some instructions on how to update the log4j2 version of various mulesoft products to a version that has incorporated all patches up until now. Unfortunately this is behind a login wall and not easy to find. You'll need an anypoint platform account, I believe also expired trial accounts work. The log4j2 version we will be using is 2.12.4 for the mule 3.x versions.

Anyway, for the mule 3.x standalone package the instructions are the following (our script does all that for you):

    Verify mule service has been stopped
    Remove the log4j jars in the (mule_home)/lib/boot/ directory
    Remove the disruptor jar in the (mule_home)/lib/boot/ directory
    Download the binaries from the 2.12.4 release
    Download the new disruptor jar from the mulesoft helpcenter
    Download the mule patch from the mulesoft helpcenter
    Move log4j and disruptor jars to (mule_home)/lib/boot directory
    Move mule patch to (mule_home)/lib/user/ directory
    Start the mule service and verify everything is working

Our script does basically that. These are the steps taken in the script:

1. Ask the user if mule has been stopped. If yes: continue. If not: stop script.
2. Ask the user for the path to mule_home.
3. Verify if the path is correct (by checking for (mule_home)/bin/mule). If correct: continue. If not: stop script.
4. Create temporary directory inside mule_home.
5. Check if the relevant jars have been extracted into the temporary directory. If they have: continue. if not:
   - Check if the apache binaries tar.gz archive is inside of the temporary directory. If it is: continue. If it isn't: download the archive from apache servers.
   - Extract the relevant jars to the temp directory.

7. Ask the user for input on the mule version. Option a: (3.8.0-3.8.7) or option b: (3.9.0-3.9.5). The script will stop if anything other than a or b is entered.
   - *I've found that option a also works on 3.8.8*
8. Depending on the choice, the relevant mule patch will be downloaded to the temporary directory. If it doesn't already exist.
9. If it doesn't already exist, download the new disruptor jar.
10. Check if all relevant files are located in the temporary directory.
11. Create backup directory inside of the temporary directory.
12. Copy the files that will be replaced from the mule directory, into the backup directory.
13. Remove all files that will be replaced from the mule directory.
14. Copy all relevant files from the temporary directory into the mule directories.
15. Ask the user to start the mule service and verify everything has been deployed correctly. 
*(Open a second terminal window/ssh connection for this)*
16. If the user responds with y, the temporary directory will be removed. If the user responds with n, the script will be stopped and the contents of the relevant mule directories will be shown.

### Prerequisites

- wget
- tar
- access to the outside internet for downloading necessary files.

  If you clone this repo locally, upload the contents to your server and follow the installation below, none of the above are required.

### Installing

Clone this repo to your server, or wget the raw script only. The script will download all dependencies.
The repo will have the necessary dependencies aswell, but the script will download them anyway, unless you copy the temporary directory from this repo into your mule_home directory.

## Usage <a name = "usage"></a>
>wget https://raw.githubusercontent.com/yhorndt/mule-3.x-log4j-update-script/master/mule_3_l4j2_update_script.sh

>chmod +x mule_3_l4j2_update_script.sh

>sudo ./mule_3_l4j2_update_script.sh
