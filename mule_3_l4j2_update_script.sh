#!/bin/bash
echo "#####################################################################################";
echo "#                                                                                   #";
echo "#                                                   log4j2 mule 3.x.x update script.#";
echo "#####################################################################################";
echo "I don't take any responsibility for the contents of this script. Make sure you have backups."
echo
echo
echo "First, we'll need to verify the mule path."
echo "Then, we'll need to know the mule version."
echo "IMPORTANT: Mule needs to be shut down for this operation!"
read -p "Has mule been shut down? (y/n) :"  -n 1 -r
echo
# Usercheck if mule running
if [[ $REPLY =~ ^[Yy]$ ]]
then
    echo "Mule has been shut down. Good for you!"
    echo
    # User input of mule path, verficiation
    read -e -p "What is the path to the mule installation? (e.g. /opt/mule38/): " mulepath
    if [[ "$mulepath" =~ '/'$ ]]; then
        if test -f "${mulepath}bin/mule"; then
            echo "Mule path verified."
            mulepathtemp="${mulepath}tempdir/"
        else
            echo "Wrong path for mule, bin/mule file not found. Will exit now."
            exit
        fi
    else
        if test -f "${mulepath}/bin/mule"; then
            echo "Mule path verified."
            mulepathtemp="${mulepath}/tempdir/"
            mulepath="${mulepath}/"
        else
            echo "Wrong path for mule, bin/mule file not found. Will exit now."
            exit
        fi
    fi
    # create temporary directory, verify files, if not there, download them.
    if [[ ! -d "$mulepathtemp" ]]
    then
        mkdir $mulepathtemp
    fi
    if [[ -f "${mulepathtemp}log4j-jul-2.12.4.jar" && -f "${mulepathtemp}log4j-jcl-2.12.4.jar" && -f "${mulepathtemp}log4j-slf4j-impl-2.12.4.jar" && -f "${mulepathtemp}log4j-1.2-api-2.12.4.jar" && -f "${mulepathtemp}log4j-core-2.12.4.jar" && -f "${mulepathtemp}log4j-api-2.12.4.jar" ]]; then
        echo "Log4j2 files already in tempdir"
    else  
        if test -f "${mulepathtemp}apache-log4j-2.12.4-bin.tar.gz"; then
            echo "Apache tar already downloaded. Extracting files now."
            tar -xzvf "${mulepathtemp}apache-log4j-2.12.4-bin.tar.gz" -C $mulepathtemp --strip-components 1 apache-log4j-2.12.4-bin/log4j-jul-2.12.4.jar apache-log4j-2.12.4-bin/log4j-jcl-2.12.4.jar apache-log4j-2.12.4-bin/log4j-slf4j-impl-2.12.4.jar apache-log4j-2.12.4-bin/log4j-1.2-api-2.12.4.jar apache-log4j-2.12.4-bin/log4j-core-2.12.4.jar apache-log4j-2.12.4-bin/log4j-api-2.12.4.jar
        else
            wget https://archive.apache.org/dist/logging/log4j/2.12.4/apache-log4j-2.12.4-bin.tar.gz -P $mulepathtemp
            tar -xzvf "${mulepathtemp}apache-log4j-2.12.4-bin.tar.gz" -C $mulepathtemp --strip-components 1 apache-log4j-2.12.4-bin/log4j-jul-2.12.4.jar apache-log4j-2.12.4-bin/log4j-jcl-2.12.4.jar apache-log4j-2.12.4-bin/log4j-slf4j-impl-2.12.4.jar apache-log4j-2.12.4-bin/log4j-1.2-api-2.12.4.jar apache-log4j-2.12.4-bin/log4j-core-2.12.4.jar apache-log4j-2.12.4-bin/log4j-api-2.12.4.jar
        fi
    fi
    # Ask for mule version and download accordingly.
    echo
    read -p "What version of mule are we running? Choose a: (3.8.0-3.8.7) or b: (3.9.0-3.9.5): " -n 1 -r muleversion
    echo
    if [[ $muleversion =~ ^[aA]$ ]]
    then
        echo "mule version is: (3.8.0-3.8.7)"
        if test -f "${mulepathtemp}EE-8195-3.8.7-3.8.0-1.1.jar"; then
            echo "Mule patch already exists"
        else
            wget -O "${mulepathtemp}EE-8195-3.8.7-3.8.0-1.1.jar" https://help.mulesoft.com/servlet/servlet.FileDownload?file=0152T000002bsKR
        fi
        mulev="3.8"
    elif [[ $muleversion =~ ^[bB]$ ]]
    then
        echo "mule version is: (3.9.0-3.9.5)"
        if test -f "${mulepathtemp}EE-8195-3.9.0-3.9.5-3.0.jar"; then
            echo "Mule patch already exists"
        else
            wget -O "${mulepathtemp}EE-8195-3.9.0-3.9.5-3.0.jar" https://help.mulesoft.com/servlet/servlet.FileDownload?file=0152T000002bsXG
        fi
        mulev="3.9"
    else
        echo "Unknown mule version.."
        exit
    fi
    if test -f "${mulepathtemp}disruptor-3.4.2.jar"; then
        echo "Disruptor jar already exists"
    else
        wget -O "${mulepathtemp}disruptor-3.4.2.jar" https://help.mulesoft.com/servlet/servlet.FileDownload?file=0152T000002bsKM
    fi
    # Check for all relevant files
    echo
    echo "Checking if all files are available..."
    if [[ -f "${mulepathtemp}disruptor-3.4.2.jar" && -f "${mulepathtemp}log4j-jul-2.12.4.jar" && -f "${mulepathtemp}log4j-jcl-2.12.4.jar" && -f "${mulepathtemp}log4j-slf4j-impl-2.12.4.jar" && -f "${mulepathtemp}log4j-1.2-api-2.12.4.jar" && -f "${mulepathtemp}log4j-core-2.12.4.jar" && -f "${mulepathtemp}log4j-api-2.12.4.jar" && ( -f "${mulepathtemp}EE-8195-3.8.7-3.8.0-1.1.jar" || -f "${mulepathtemp}EE-8195-3.9.0-3.9.5-3.0.jar" ) ]]; then
        echo "All files exist!"
    else
        echo "Not all files are present!"
        exit
    fi
    echo
    # Create backup folder and copying original files into it
    mkdir "${mulepathtemp}backup"
    echo "Making a backup of all to be removed files."
    cp "${mulepath}lib/boot/log4j"*.jar "${mulepathtemp}backup/"
    cp "${mulepath}lib/boot/disruptor-3.4.2.jar" "${mulepathtemp}backup/"
    # Removal of original files
    echo "Removing files from mule directory now."
    rm "${mulepath}lib/boot/log4j-"*.jar
    rm "${mulepath}lib/boot/disruptor-"*.jar
    echo
    # Copying relevant files
    echo "Copying files to mule directories now."
    cp "${mulepathtemp}log4j"*.jar "${mulepath}lib/boot/"
    cp "${mulepathtemp}disruptor-"*.jar "${mulepath}lib/boot/"
    cp "${mulepathtemp}EE-8195-${mulev}"*.jar "${mulepath}lib/user/"
    echo "All files copied, you can start mule now and verify everything works.".
    # If verified working, remove temporary folder
    echo "If you've verified mule started correctly, the temporary files and backups will be removed."
    read -p "Does mule work correctly? (y/n) :"  -n 1 -r
    if [[ $REPLY =~ ^[Yy]$ ]]
    then
        echo
        echo "Temp and backup files will be removed now."
        rm -r "${mulepathtemp}"
    else
        echo
        echo "Script will quit now, please verify all files are copied correctly."
        ls -lah "${mulepath}lib/boot/log4j"*.jar
        ls -lah "${mulepath}lib/boot/disruptor-"*.jar
        ls -lah "${mulepath}lib/user/EE"*.jar
        exit
    fi
else
    echo "Mule has not been shut down, shut it down and rerun this script again."
fi
read -p "Press Enter to exit."