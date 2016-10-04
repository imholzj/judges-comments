# 
# script creates symbolic links to the copyRecorder script with
# a different alias for each recorder directory (in case of Rain)
# 
# assuming that we do up to 4 bands on one set of recorders using the 
# recorder directorys A, B, C, and D.  Then copy off the recorders in batch.
#

. "${ENV:LCI}\bin\config.ps1"

$COPYRECORDER = $HOME_DIR + '\bin\copyRecorder.ps1'

$BANDS_FILE = $HOME_DIR + '\etc\bands'
$BANDS = Get-Content $BANDS_FILE

$SCHOOLS_HOME = $HOME_DIR + '\schools'
if ( ! (Test-Path $SCHOOLS_HOME) ) {
	mkdir $SCHOOLS_HOME | Out-Null
}

foreach ($SCHOOL in  $BANDS) { 
	echo "school:$SCHOOL"
	$SCHOOL_DIR = $HOME_DIR + '\schools\' + $SCHOOL
	$WAV_DIR = $SCHOOL_DIR + '\wav'
        $LINK_TARGET = $WAV_DIR + '\copyRecorder-A.ps1'
	cmd /c mklink $LINK_TARGET $COPYRECORDER | Out-Null
        $LINK_TARGET = $WAV_DIR + '\copyRecorder-B.ps1'
	cmd /c mklink $LINK_TARGET $COPYRECORDER | Out-Null
        $LINK_TARGET = $WAV_DIR + '\copyRecorder-C.ps1'
	cmd /c mklink $LINK_TARGET $COPYRECORDER | Out-Null
        $LINK_TARGET = $WAV_DIR + '\copyRecorder-D.ps1'
	cmd /c mklink $LINK_TARGET $COPYRECORDER | Out-Null
}
