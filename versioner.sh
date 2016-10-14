#!/bin/bash

OSTAMP='version: ß1.00.07.04'
FSTAMP='version: ß1.00.07.05'
TEMP=".tmp"


function getDirectoryFiles {
    #1 path of folder
    if [ "$1" ]; then
        ls -F "$1" | sed -e '/\/$/d' -E -e '/.php$|.html$|.js$|.css$/!d' | sed 's/\*$//'
    fi
}

function processDirectory {
    #1 path of folder
    [ "$1" ] || return
    local path=$(echo "${1}/" | sed 's/\/\/$/\//') #<< secure "is a dir"
    
    echo "--$path"
    
    for file in $(getDirectoryFiles "$path"); do
        echo $file
        cat "${path}$file" | sed "s/${OSTAMP}/${FSTAMP}/" > "${path}${file}$TEMP"
        rm -f "${path}$file"
        mv "${path}${file}$TEMP" "${path}$file"
    done
    
    local folders=($(ls -F $path | sed '/\/$/!d'))
    for folder in ${folders[*]}; do
        if [ "$(getDirectoryFiles "${path}$folder")" ]; then
            processDirectory "${path}$folder"           
        fi
    done
}

processDirectory "/Development/Production/TMS/TMS_Dev/site/"

