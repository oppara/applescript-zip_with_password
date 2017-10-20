property APP_NAME : "zip_with_password"
property ARCHIVE_NAME : "archive.zip"
property DROPPED_FILES : {}

on clearDroppedFiles()
    set DROPPED_FILES to {}
end clearDroppedFiles

on makeTmpDir()
	return do shell script ("mktemp -d /tmp/" & APP_NAME & ".XXXXXXXX")
end makeTmpDir

on deleteTmpDir()
	do shell script ("rm -rf /tmp/" & APP_NAME & ".*")
end deleteTmpDir

on removeTrailingSlash(thePath)
	do shell script "perl -e '\"" & thePath & "\"=~ m@^(.*?)/?$@;print $1;'"
end removeTrailingSlash

on escapeSpace(thePath)
	do shell script "echo " & thePath & " | perl -pe 's/ /\\\\ /g;'"
end escapeSpace

on chooseTargetPath()
	set theDesktopPath to POSIX path of ((path to home folder) & "Desktop:" as string)
	set theTargetAlias to choose folder with prompt "保存先を選択" default location theDesktopPath as string
	return POSIX path of (theTargetAlias as string)
end chooseTargetPath

on getExcludePath()
	return POSIX path of (path to me as string) & "Contents/Resources/exclude.lst"
end getExcludePath

on getPassword()
	repeat
		display dialog "パスワードを入力
半角英数字、アンダーバー、ハイフン" default answer "" with icon note
		set thePassword to text returned of result

		if (thePassword is equal to "") then
			exit repeat
		end if

		set theResult to do shell script "echo " & thePassword & " | perl -ne 'print if /^[0-9a-zA-Z_-]+$/'"
		if (theResult is not equal to "") then
			exit repeat
		end if

	end repeat

	return thePassword
end getPassword


on open theList
    deleteTmpDir()
    set DROPPED_FILES to DROPPED_FILES & theList
end open

on quit
    try
        set thePassword to getPassword()
        set theTmpPath to makeTmpDir() & "/"

        repeat with theTarget in DROPPED_FILES
            set thePath to removeTrailingSlash(POSIX path of (theTarget as string))
            set theSrc to escapeSpace(thePath)
            do shell script ("cp -rp " & theSrc & " " & theTmpPath)
        end repeat

        set theTargetDirPath to chooseTargetPath()
        set theTargetPath to escapeSpace(theTargetDirPath) & ARCHIVE_NAME

        set theExcludePath to getExcludePath()
        set theCmd to "zip -r " & theTargetPath & " * -x@" & theExcludePath
        if (thePassword is not equal to "") then
            set theCmd to theCmd & " -P " & thePassword
        end if

        do shell script ("rm -rf " & theTargetPath & " 2>/dev/null")
        do shell script ("cd " & theTmpPath & " && " & theCmd)

        deleteTmpDir()

    on error
        clearDroppedFiles()
    end try

    clearDroppedFiles()

    continue quit

end quit
