#
# copy source WAV file to PWD (should be lci current school wav directory)
#
# Note: there's a chance a judge hit stop and start (instead of pause)
#       so there may be more than 1 source wav file.
#
#  As admin in powershell:  Set-ExecutionPolicy Unrestricted
#
#
. "${ENV:LCI}\bin\config.ps1"

$SCHOOL_DIR = $Args[0]
$SCHOOL_WAV_DIR = $SCHOOL_DIR + '\wav'

echo "SCHOOL WAV DIR: $SCHOOL_WAV_DIR"

[System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms") | Out-Null

#
# check if were being called with an alias that indicates
# which directory of the recorder we should be processing
#    alias looks like this:  copyRecorder-B.ps1 
if ( $MyInvocation.MyCommand.Name -cmatch '-(.)\.ps1' ) {
	$RECORDER_DIR = '\' + $matches[1]
} else {
	$RECORDER_DIR = '\A'
}

$RECORDER_DRIVE = 'E:'
$SOURCE_DIR = $RECORDER_DRIVE + $RECORDER_DIR
$SOURCE_WAV_FILTER=$SOURCE_DIR + '\*.WAV'

if ( -NOT (Test-Path $SOX_BIN) ) {
	$title = 'Warning!'
	$msg = 'No SOX binary'
	[System.Windows.Forms.MessageBox]::Show($msg, $title, 0)
	exit
}

$SOURCE_WAV_FILES= get-childitem -Name $SOURCE_WAV_FILTER

# warn and quit if no files are on recorder
if ( $SOURCE_WAV_FILES.Count -eq 0 ) {
	$title = 'Warning!'
	$msg = 'No source files found in source dir: ' + $SOURCE_WAV_FILTER
	[System.Windows.Forms.MessageBox]::Show($msg, $title, 0)
   exit
} else {
	$title = 'Found Files'
	$msg = 'Found ' + $SOURCE_WAV_FILES.Count + ' files found on recorder'
	[System.Windows.Forms.MessageBox]::Show($msg, $title, 0)
}


# judge name will always be in 'A' folder
$JUDGE_FILE = get-childitem $RECORDER_DRIVE/A/*.judge
$JUDGE = (Get-Item $JUDGE_FILE).Basename
echo 'JUDDGE: ' + $JUDGE

$ORIG_DIR = $SCHOOL_WAV_DIR + '\original\' + $JUDGE
echo 'ORIG_DIR: ' + $ORIG_DIR

# make copy of originals
echo 'mkdir ' + $ORIG_DIR + ' | Out-Null'
mkdir $ORIG_DIR | Out-Null
echo 'cp ' + $SOURCE_WAV_FILTER + ' ' + $ORIG_DIR
cp $SOURCE_WAV_FILTER $ORIG_DIR

$DEST_WAV_FILE = $SCHOOL_WAV_DIR + '\' + $JUDGE + '.wav'
$FAST_WAV_FILE = $JUDGE + '_FAST.wav'

# concat wav's to <judge>.wav
cmd /c $SOX_BIN --combine concatenate $ORIG_DIR\*.WAV $DEST_WAV_FILE

# create faster recording
cmd /c $SOX_BIN $DEST_WAV_FILE $FAST_WAV_FILE tempo 1.66

# don't delete recorder if number of files differ
$ORIG_FILES = get-childitem -Name $ORIG_DIR
if ( $SOURCE_WAV_FILES.Count -ne $ORIG_FILES.Count ) {
	$title = 'Warning!'
	$msg = 'Number of files on recorder(' + $SOURCE_WAV_FILES.Count + ') does not match number of files in original dir (' + $ORIG_FILES.Count + ').  NOT Deleteing files off recorder!'
	[System.Windows.Forms.MessageBox]::Show($msg, $title, 0)
   exit
}

rm $SOURCE_WAV_FILTER

