#!/bin/bash
#
# check for any *.wav files in the schools directory
#
# only possible param is SCHOOL_DIR (default= /home/lci/schools/current )
#
. "${ENV:LCI}\bin\config.ps1"


[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null


if ( -NOT (Test-Path $CONVERT_COMMAND) ) {
	$title = 'Warning!'
	$msg = "No mpeg binary"
	[System.Windows.Forms.MessageBox]::Show($msg, $title, 0)
	exit
}

$SCHOOL_DIR = $Args[0]

mkdir "${SCHOOL_DIR}/mp3" | Out-Null

#
# foreach wav file, convert
#
Get-ChildItem "${SCHOOL_DIR}\wav" -Filter *.wav |
Foreach-Object {
	$JUDGE = $_.Basename
	$MP3_FILE = "${SCHOOL_DIR}\mp3\${JUDGE}.mp3"
	echo "cmd /c $CONVERT_COMMAND -i $_ $MP3_FILE"
	cmd /c $CONVERT_COMMAND -i $_ $MP3_FILE
}

if ( -NOT (Test-Path $CONVERT_COMMAND) ) {
	$title = 'Success!'
	$msg = "Converted WAV's to MP3's"
	[System.Windows.Forms.MessageBox]::Show($msg, $title, 0)
}

