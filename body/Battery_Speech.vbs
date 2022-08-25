Set myFSO = CreateObject("Scripting.FileSystemObject")
Dim bati : bati = "Battery_Info.txt"
' Check if info to be read exists
If (myFSO.FileExists(bati)) Then
	Dim getSpkr : getSpkr = 1
	Dim getR : getR = 2
	Dim setBL : setBL = "Set_Battery_Level.txt"
	' Set the chosen speaker
	If (myFSO.FileExists(setBL)) Then
		Set readObj = myFSO.OpenTextFile(setBL,1)
		For i=1 to 6
			getSpkr = readObj.ReadLine
		Next
		getSpkr = CInt(getSpkr)
		getR = CInt(readObj.ReadLine)
		readObj.Close
	End If
	Set spkr = CreateObject("SAPI.spVoice")
	Set spkr.voice = spkr.GetVoices.Item(getSpkr)
	spkr.Volume = 100
	spkr.Rate = getR
	' Set the before text
	Dim bef : bef = "Battery level is"
	Dim beftxt : beftxt = "pre\bsB.txt"
	Dim noLines,rLine
	If (myFSO.FileExists(beftxt)) Then
		Set readTxt = myFSO.OpenTextFile(beftxt,1)
		Do Until readTxt.AtEndOfStream
			readTxt.SkipLine
		Loop
		noLines = readTxt.Line-1
		Randomize
		rLine = 1+Int(Rnd*noLines)
		Set readTxt = myFSO.OpenTextFile(beftxt,1)
		For i=1 to rLine
			bef = readTxt.ReadLine
		Next
		readTxt.Close
		Set readTxt = Nothing
	End If
	Set readObj = myFSO.OpenTextFile(bati,1)
	' Read 1st line from info file
	Dim S : S = readObj.ReadLine
	bef = bef & " " & S
	' Read 2nd line from info file
	S = readObj.ReadLine
	Dim af,aftxt
	' Set the after text (Charging/Discharging)
	If (StrComp(S,"charging") = 0) Then
		af = "Plugged in, charging"
		aftxt = "post\bsAC.txt"
		If (myFSO.FileExists(aftxt)) Then
			Set readTxt = myFSO.OpenTextFile(aftxt,1)
			Do Until readTxt.AtEndOfStream
				readTxt.SkipLine
			Loop
			noLines = readTxt.Line-1
			Randomize
			rLine = 1+Int(Rnd*noLines)
			Set readTxt = myFSO.OpenTextFile(aftxt,1)
			For i=1 to rLine
				af = readTxt.ReadLine
			Next
			readTxt.Close
			Set readTxt = Nothing
		End If
	Else
		af = "Estimated time left is"
		aftxt = "post\bsAD.txt"
		If (myFSO.FileExists(aftxt)) Then
			Set readTxt = myFSO.OpenTextFile(aftxt,1)
			Do Until readTxt.AtEndOfStream
				readTxt.SkipLine
			Loop
			noLines = readTxt.Line-1
			Randomize
			rLine = 1+Int(Rnd*noLines)
			Set readTxt = myFSO.OpenTextFile(aftxt,1)
			For i=1 to rLine
				af = readTxt.ReadLine
			Next
			readTxt.Close
			Set readTxt = Nothing
		End If
		af = af & " " & S
	End If
	spkr.speak bef
	spkr.speak af
	readObj.Close
	Set readObj = nothing
	Set spkr = nothing
End If
Set myFSO = nothing