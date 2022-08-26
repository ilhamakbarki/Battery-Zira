Set wshell = CreateObject("WScript.Shell")
Set myFSO = CreateObject("Scripting.FileSystemObject")
Dim checkV : checkV = 1
Dim getSpkr : getSpkr = 1
Dim getR : getR = 2
Dim setBL : setBL = "Set_Battery_Level.txt"
' Read voice status and speaker
If (myFSO.FileExists(setBL)) Then
    Set readObj = myFSO.OpenTextFile(setBL,1)
    checkV = CInt(readObj.ReadLine)
    For i=2 to 6
        getSpkr = readObj.ReadLine
    Next
    getSpkr = CInt(getSpkr)
    getR = CInt(readObj.ReadLine)
    readObj.Close
    Set readObj = nothing
End If
' Check if voice is enabled
If checkV = 1 Then
    ' Set the chosen speaker
    Set spkr = CreateObject("SAPI.spVoice")
    Set spkr.voice = spkr.GetVoices.Item(getSpkr)
    spkr.Volume = 100
    spkr.Rate = getR
    ' Set the before and after texts
    Dim bef : bef = "Welcome back"
    Dim af : af = "have a nice time ahead"
    Dim beftxt : beftxt = "pre\welcomeB.txt"
    Dim aftxt : aftxt = "post\welcomeA.txt"
    Dim noLines,rLine
    If (myFSO.FileExists(beftxt)) Then
        Set readObj = myFSO.OpenTextFile(beftxt,1)
        Do Until readObj.AtEndOfStream
            readObj.SkipLine
        Loop
        noLines = readObj.Line-1
        Randomize
        rLine = 1+Int(Rnd*noLines)
        Set readObj = myFSO.OpenTextFile(beftxt,1)
        For i=1 to rLine
            bef = readObj.ReadLine
        Next
        readObj.Close
        Set readObj = Nothing
    End If
    If (myFSO.FileExists(aftxt)) Then
        Set readObj = myFSO.OpenTextFile(aftxt,1)
        Do Until readObj.AtEndOfStream
            readObj.SkipLine
        Loop
        noLines = readObj.Line-1
        Randomize
        rLine = 1+Int(Rnd*noLines)
        Set readObj = myFSO.OpenTextFile(aftxt,1)
        For i=1 to rLine
            af = readObj.ReadLine
        Next
        readObj.Close
        Set readObj = Nothing
    End If
    Dim struser : struser = CreateObject("WScript.Network").UserName
    Dim spk : spk = bef & " " & struser & ", " & af
    spkr.speak spk
    Set spkr = nothing
End If
Dim batTV : batTV = "Battery_TaskV.bat"
If (myFSO.FileExists(batTV)) Then
    wshell.Run chr(34) & batTV & Chr(34), 0
Else
    WScript.Echo "File " & batTV & " NOT FOUND !"
End If
Set myFSO = nothing
Set wshell = nothing