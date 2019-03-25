Function Get-FileName($initialDirectory)
{
    [System.Reflection.Assembly]::LoadWithPartialName("System.windows.forms") | Out-Null
    
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog -Property @{Multiselect = $true}
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.filter = "Compressed log (*.tgz)| *.tgz"
    $OpenFileDialog.ShowDialog() | Out-Null
    $OpenFileDialog.filenames
}

# Check that 7-zip is installed in the default directory
 if (Test-Path -Path c:\"program files"\7-zip\7z.exe)
 {
    # Change "C:\" to the default path that stores your log files.  That way when you run
    # the script it will default the windows picker to your log file directory.
    $inputfiles = Get-FileName "C:\"

    # Loop to process extraction and clean up of each selected arcjive(.tgz) file.
    foreach($input in $inputfiles)
    {

        # Parse the file path, file name, and file extension for passing as variables to 7-Zip.
        $filepath = split-path $input -parent
        $filename = split-path $input -leaf
        $filepathNoExt = (split-path $Input) + "\" + [io.path]::GetFileNameWithoutExtension($input)
        $tar = $filepathNoExt + ".tar"

        # Change the string below to match the pattern of the single log file to be extracted from the .tar file.
        # $log below is extracting a file name called "http-2018-01-07.log" from "logfiles-2018-01-07.tgz".
        $log = "http-" + ($filename.Split("-",2)[1]).Split(".")[0] + ".log"

        # Extract the .tgz file selected
        c:\"program files"\7-zip\7z e $input -o"$filepath"

        # Change the "c:\" to the full path and ending "\" of where you want the .log files to be extracted.
        # Extract the log file form the .tar file.
        c:\"program files"\7-zip\7z e $tar $log -o"c:\"

        # Delete the .tar file leaving the original archive(.tgz) file and extracted(.log) log file.
        del $tar
    }

 }
 else
 {
    clear-host
    write-host("7-Zip is not installed or not installed in the default directory.");
    write-host("If installed to different directory change the path values to the 7z.exe in the following lines: ");
    write-host("Line 13, Line 34, and Line 38");
 }


