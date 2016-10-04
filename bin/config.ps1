#
# common vars
$BOX_HOME_DIR = 'C:\Users\imholzj\Dropbox\LCI2016'

# HOME_DIR - where most of scripts, config, data
$HOME_DIR = $ENV:LCI

# BANDS_FILE - list of school names
$BANDS_FILE = $HOME_DIR + '\etc\bands'

# SCHOOLS_HOME - root dir for each school
$SCHOOLS_HOME = $HOME_DIR + '\schools'

# COPY_RECORDER - where is the copyRecorder script?  We create sym links to it.
$COPY_RECORDER = $HOME_DIR + '\bin\copyRecorder.ps1'


# SOX command
$SOX_BIN = $HOME_DIR + '\bin\sox\sox.exe'

# MPEG command
$CONVERT_COMMAND = $HOME_DIR + '\bin\ffmpeg.exe'
