# 
# script creates the schools directory
# and individual schools dirs, plus a link
# to the copy recorder script
. "${ENV:LCI}\bin\config.ps1"

$COPYRECORDER = $HOME_DIR + '\bin\copyRecorder.ps1'
$MAKEMP3S = $HOME_DIR + '\bin\wav2mp3.ps1'

$BANDS_FILE = $HOME_DIR + '\etc\bands'
$BANDS = Get-Content $BANDS_FILE

$SCHOOLS_HOME = $HOME_DIR + '\schools'
if ( ! (Test-Path $SCHOOLS_HOME) ) {
	mkdir $SCHOOLS_HOME | Out-Null
}

foreach ($SCHOOL in  $BANDS) { 
	echo "school:$SCHOOL"
	$SCHOOL_DIR = $HOME_DIR + '\schools\' + $SCHOOL
	mkdir $SCHOOL_DIR | Out-Null
	$WAV_DIR = $SCHOOL_DIR + '\wav'
	mkdir $WAV_DIR | Out-Null

	# make the copyRecorder bat file
        $GET_RECORDER_BAT = $WAV_DIR + '\copyRecorder.bat'
        $RECORDER_CMD = "powershell.exe -executionpolicy bypass -file $COPYRECORDER $SCHOOL_DIR`r
powershell.exe -executionpolicy bypass -file $MAKEMP3S $SCHOOL_DIR
" 
        Set-Content $GET_RECORDER_BAT $RECORDER_CMD -Encoding ASCII

	# make the make3s bat file
        $MAKE_MP3S_BAT = $WAV_DIR + '\make3s.bat'
        $MAKE_MP3S_CMD = "powershell.exe -executionpolicy bypass -file $MAKEMP3S $SCHOOL_DIR`r
"
        Set-Content $MAKE_MP3S_BAT $MAKE_MP3S_CMD -Encoding ASCII

	$ORIG_DIR = $WAV_DIR + '\original'
	mkdir $ORIG_DIR | Out-Null
}
