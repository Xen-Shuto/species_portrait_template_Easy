Dim objFSO, objFile, objFolder, objShell, objConfigFile, objSourceFolder
Dim config, baseFolder, copyFolder, source, baseSource, copySource, line, matches, flgpart, oldpart, newpart, filepath, folderpath, newfilepath, newfolderpath, extension
Dim re, reMatch, reMatches, reConfig, reConfigMatch, reConfigMatches

' 設定ファイルを読み込む
config = "config.txt"

' コピー元、コピー先ディレクトリを設定
baseFolder = "MOD_BASE"
copyFolder = "MOD"

' 作業ディレクトリを設定
Set objShell = CreateObject("WScript.Shell")
baseSource = objShell.CurrentDirectory & "\" & baseFolder
copySource = objShell.CurrentDirectory & "\" & copyFolder

' FileSystemObjectを作成
Set objFSO = CreateObject("Scripting.FileSystemObject")
Set objConfigFile = objFSO.OpenTextFile(config, 1)

' 正規表現オブジェクトを作成
Set re = CreateObject("VBScript.RegExp")
re.Pattern = "^(.*?):(.*?)=(.*)$"
re.IgnoreCase = True

' 設定ファイルの各行を処理
Do Until objConfigFile.AtEndOfStream
    line = objConfigFile.ReadLine

    If re.Test(line) Then
        Set reMatches = re.Execute(line)
        Set reMatch = reMatches(0)
        flgpart = Trim(reMatch.SubMatches(0))
        oldpart = Trim(reMatch.SubMatches(1))
        newpart = Trim(reMatch.SubMatches(2))
        If flgpart = "f" Then
            WScript.Echo "存在チェックパス: " & copySource & "\" & "*" & newpart & "*"
            ' コピー先のフォルダまたはファイルが存在しているか確認
            If isExistsFolderAndFile(copySource, "*" & newpart & "*") Then
                Dim result
                result = objShell.Popup("コピー先のフォルダまたはファイルが存在しています。" & vbCrLf  & "上書きしますか？", 0, "確認", 4 + 32)
                If result = 7 Then ' Noを選択した場合
                    WScript.Echo "処理を中止します。"
                    WScript.Quit
                Else
                    WScript.Echo "上書きで処理を続行します。"
                End If
            End If

            ' ファイルとフォルダを再帰的に処理
            Set objSourceFolder = objFSO.GetFolder(baseSource)
            ProcessFolder objSourceFolder, oldpart, newpart, baseFolder, copyFolder
        End If
    Else
        If Left(line, 1) = "#" Then
            'WScript.Echo "コメント行: " & line
        Else
            WScript.Echo "行がマッチしませんでした: " & line
        End If
    End If

Loop
objConfigFile.Close

WScript.Echo "完了しました。"
WScript.Quit

Function isExistsFolderAndFile(folderPath, chkPattern)
    Dim objFSO, objFolder, objSubFolder, objFile, re

    ' FileSystemObjectを作成
    Set objFSO = CreateObject("Scripting.FileSystemObject")

    ' 正規表現オブジェクトを作成
    Set re = CreateObject("VBScript.RegExp")
    re.Pattern = "^" & Replace(chkPattern, "*", ".*") & "$"
    re.IgnoreCase = True

    ' フォルダが存在するかチェック
    If objFSO.FolderExists(folderPath) Then
        Set objFolder = objFSO.GetFolder(folderPath)
        
        ' サブフォルダをチェック
        For Each objSubFolder In objFolder.SubFolders
            If re.Test(objSubFolder.Name) Then
                WScript.Echo "一致するフォルダが見つかりました: " & objSubFolder.Path
                isExistsFolderAndFile = True
                Exit Function
            End If
        Next
        
        ' ファイルをチェック
        For Each objFile In objFolder.Files
            If re.Test(objFile.Name) Then
                WScript.Echo "一致するファイルが見つかりました: " & objFile.Path
                isExistsFolderAndFile = True
                Exit Function
            End If
        Next
    End If

    isExistsFolderAndFile = False
End Function

Sub ProcessFolder(folder, oldpart, newpart, baseFolder, copyFolder)
    Dim subFolder, file, filepath, folderpath, newfilepath, newfolderpath, extension, objInputFile, objOutputFile, objSubConfigFile, hasBOM, firstBytes, i

    ' フォルダ内の各ファイルを処理
    For Each file In folder.Files
        filepath = file.Path
        folderpath = file.ParentFolder.Path
        newfilepath = Replace(Replace(filepath, baseFolder, copyFolder), oldpart, newpart)
        newfolderpath = Replace(Replace(folderpath, baseFolder, copyFolder), oldpart, newpart)
        extension = objFSO.GetExtensionName(file)

        If folderpath <> "" Then
            ' 新しいファイルのディレクトリを作成
            If Not objFSO.FolderExists(newfolderpath) Then
                CreateFullPath(newfolderpath)
            End If

            ' 拡張子に基づいて処理を分岐
            If LCase(extension) = "dds" Then
                ' 画像ファイルをコピー
                objFSO.CopyFile filepath, newfilepath, True
            ElseIf LCase(extension) = "txt" Then
                ' SJISのテキストファイルを処理
                If objFSO.FileExists(newfilepath) Then objFSO.DeleteFile(newfilepath)

                ' 入力ファイルを1行ずつ読み込み、置換して出力ファイルに書き込む
                Set objInputFile = objFSO.OpenTextFile(filepath, 1)
                Set objOutputFile = objFSO.CreateTextFile(newfilepath, True)
                Do Until objInputFile.AtEndOfStream
                    line = objInputFile.ReadLine
                    Set objSubConfigFile = objFSO.OpenTextFile(config, 1)
                    Do Until objSubConfigFile.AtEndOfStream
                        configLine = objSubConfigFile.ReadLine
                        If re.Test(configLine) Then
                            Set reConfigMatches = re.Execute(configLine)
                            Set reConfigMatch = reConfigMatches(0)
                            flgstr = Trim(reConfigMatch.SubMatches(0))
                            oldstr = Trim(reConfigMatch.SubMatches(1))
                            newstr = Trim(reConfigMatch.SubMatches(2))
                            If flgstr = "n" Then
                                line = Replace(line, oldstr, newstr)
                            End If
                        End If
                    Loop
                    objSubConfigFile.Close
                    objOutputFile.WriteLine line
                Loop
                objInputFile.Close
                objOutputFile.Close
            Else
                ' UTF8のテキストファイルを処理
                If objFSO.FileExists(newfilepath) Then objFSO.DeleteFile(newfilepath)

                ' ADODB.Streamオブジェクトを作成してファイルをバイナリモードで開く
                Set objStream = CreateObject("ADODB.Stream")
                objStream.Type = 1 ' adTypeBinary
                objStream.Open
                objStream.LoadFromFile(filepath)
                ' ファイルの最初の3バイトを読み取る
                firstBytes = objStream.Read(3)
                objStream.Close

                ' BOMの有無を確認
                hasBOM = (AscB(firstBytes) = Chr(&HEF) & Chr(&HBB) & Chr(&HBF))

                ' ADODB.Streamオブジェクトを作成して入力ファイルをUTF-8で開く
                Set objStream = CreateObject("ADODB.Stream")
                objStream.Type = 2 ' adTypeText
                objStream.Charset = "UTF-8"
                objStream.Open
                objStream.LoadFromFile(filepath)

                ' ADODB.Streamオブジェクトを作成して出力ファイルをUTF-8で開く
                Set objStreamOut = CreateObject("ADODB.Stream")
                objStreamOut.Type = 2 ' adTypeText
                objStreamOut.Charset = "UTF-8"
                objStreamOut.Open

                ' BOMがある場合、BOMを追加
                If hasBOM Then
                    objStreamOut.WriteText Chr(&HEF) & Chr(&HBB) & Chr(&HBF)
                End If

                ' 入力ファイルを1行ずつ読み込み、置換して出力ファイルに書き込む
                Do Until objStream.EOS
                    line = objStream.ReadText(-2) ' -2 for reading line by line
                    Set objSubConfigFile = objFSO.OpenTextFile(config, 1)
                    Do Until objSubConfigFile.AtEndOfStream
                        configLine = objSubConfigFile.ReadLine
                        If re.Test(configLine) Then
                            Set reConfigMatches = re.Execute(configLine)
                            Set reConfigMatch = reConfigMatches(0)
                            flgstr = Trim(reConfigMatch.SubMatches(0))
                            oldstr = Trim(reConfigMatch.SubMatches(1))
                            newstr = Trim(reConfigMatch.SubMatches(2))
                            If flgstr = "n" Then
                                line = Replace(line, oldstr, newstr)
                            End If
                        End If
                    Loop
                    objSubConfigFile.Close
                    objStreamOut.WriteText line & vbLf
                Loop
                objStream.Close

                ' 出力ファイルを保存
                objStreamOut.SaveToFile newfilepath, 2 ' adSaveCreateOverWrite
                objStreamOut.Close

            End If
        End If
    Next

    ' サブフォルダを再帰的に処理
    For Each subFolder In folder.SubFolders
        ProcessFolder subFolder, oldpart, newpart, baseFolder, copyFolder
    Next
End Sub

Sub CreateFullPath(path)
    Dim objFSO, arrDirs, currentPath, i
    
    ' FileSystemObjectを作成
    Set objFSO = CreateObject("Scripting.FileSystemObject")
    
    ' パスをディレクトリごとに分割
    arrDirs = Split(path, "\")
    currentPath = arrDirs(0)
    
    ' 各ディレクトリを作成
    For i = 1 To UBound(arrDirs)
        currentPath = currentPath & "\" & arrDirs(i)
        If Not objFSO.FolderExists(currentPath) Then
            objFSO.CreateFolder(currentPath)
        End If
    Next
End Sub
