#NoEnv
#SingleInstance Force
EnvGet, LocalAppData, LOCALAPPDATA
SetWorkingDir %A_ScriptDir%
settingsFilePath := A_ScriptDir "\settings.ini"


ROBLOX_LOGS := LocalAppData "\Roblox\logs\*.log"
logDir := LocalAppData "\Roblox\logs"
biome := ""
prevBiome := "None"
running := false
runTimeTick := 0
runTime := 0
runTimeDisplay := 0
displayRuntime := false

if (biomeData = "") {
    biomeData := {}
    biomeData["NORMAL"]       := {color: 0,         thumbnail: "https://cdn.mongoosee.com/assets/biomes/NORMAL.png"}
    biomeData["WINDY"]        := {color: 10150399,  thumbnail: "https://cdn.mongoosee.com/assets/biomes/WINDY.png"}
    biomeData["RAINY"]        := {color: 163773,    thumbnail: "https://cdn.mongoosee.com/assets/biomes/RAINY.png"}
    biomeData["SNOWY"]        := {color: 14479353,  thumbnail: "https://cdn.mongoosee.com/assets/biomes/SNOWY.png"}
    biomeData["SAND STORM"]   := {color: 9401431,   thumbnail: "https://cdn.mongoosee.com/assets/biomes/SAND%20STORM.png"}
    biomeData["HELL"]         := {color: 16730905,  thumbnail: "https://cdn.mongoosee.com/assets/biomes/HELL.png"}
    biomeData["STARFALL"]     := {color: 72375,     thumbnail: "https://cdn.mongoosee.com/assets/biomes/STARFALL.png"}
    biomeData["CORRUPTION"]   := {color: 7155368,   thumbnail: "https://cdn.mongoosee.com/assets/biomes/CORRUPTION.png"}
    biomeData["NULL"]         := {color: 8618883,   thumbnail: "https://cdn.mongoosee.com/assets/biomes/NULL.png"}
    biomeData["GLITCHED"]     := {color: 12582656,  thumbnail: "https://cdn.mongoosee.com/assets/biomes/GLITCHED.png"}
    biomeData["DREAMSPACE"]   := {color: 15376858,  thumbnail: "https://cdn.mongoosee.com/assets/biomes/DREAMSPACE.png"}
    biomeData["HEAVEN"]       := {color: 16769184,  thumbnail: "https://cdn.mongoosee.com/assets/biomes/HEAVEN.png"}
    biomeData["CYBERSPACE"]   := {color: 663101,    thumbnail: "https://cdn.mongoosee.com/assets/biomes/CYBERSPACE.png"}
    biomeData["SINGULARITY"]  := {color: 13582371,  thumbnail: "https://cdn.mongoosee.com/assets/biomes/SINGULARITY.png"}
    biomeData["BLAZING SUN"]  := {color: 16106050,  thumbnail: "https://cdn.mongoosee.com/assets/biomes/BLAZING%20SUN.png"}
    biomeData["AURORA"]       := {color: 9065205, thumbnail: "https://cdn.mongoosee.com/assets/biomes/AURORA.png"}
    biomeData["GRAVEYARD"]    := {color: 0, thumbnail: "https://cdn.mongoosee.com/assets/biomes/GRAVEYARD.png"}
    biomeData["PUMPKIN MOON"] := {color: 0, thumbnail: "https://cdn.mongoosee.com/assets/biomes/PUMPKIN%20MOON.png"}
    biomeData["BLOOD RAIN"]   := {color: 0, thumbnail: "https://cdn.mongoosee.com/assets/biomes/BLOOD%20RAIN.png"}
    biomeData["INCINERATOR"]   := {color: 10373176, thumbnail: ""}
}

if (FileExist(settingsFilePath)) {
    IniRead, tempWebhookURL, %settingsFilePath%, Macro, webhookURL
    if (tempWebhookURL != "ERROR")
    {
        webhookURL := tempWebhookURL
    }
    IniRead, tempPrivateServerLink, %settingsFilePath%, Macro, privateServerLink
    if (tempPrivateServerLink != "ERROR")
    {
        privateServerLink := tempPrivateServerLink
    }
    IniRead, tempDisplayRuntime, %settingsFilePath%, Macro, displayRuntime
    if (tempDisplayRuntime != "ERROR")
    {
        displayRuntime := tempDisplayRuntime
    }
}

Gui, Color, 041024
Gui, Font, s30 cWhite Bold, Segoe UI
Gui, Font, s15 cWhite Bold, Segoe UI
Gui, Add, Text, x35 y13 w600 h30 BackgroundTrans c0xFFAA00 vTitleText, aery's biome macro v1.2
Gui, Font, s9 cWhite Normal, Segoe UI
Gui, Color, 041024
Gui, Font, s10 cWhite Normal Bold

Gui, Add, Text, x35 y45 w150 h25 BackgroundTrans, Private Server Link:
Gui, Add, Edit, x35 y70 w415 h25 vPrivateServerInput gUpdatePrivateServer Background0xD3D3D3 cBlack, %privateServerLink%
Gui, Font, s8 c0xCCCCCC Normal
Gui, Add, Text, x35 y95 w500 h15 BackgroundTrans, Paste your Roblox Private Sever Link here.

Gui, Font, s10 cWhite Normal Bold
Gui, Add, Text, x35 y110 w200 h25 BackgroundTrans, Discord Webhook URL:
Gui, Add, Edit, x35 y135 w415 h25 vWebhookInput gUpdateWebhook Background0xD3D3D3 cBlack, %webhookURL%
Gui, Font, s8 c0xCCCCCC Normal
Gui, Add, Text, x35 y160 w500 h15 BackgroundTrans, Paste your Discord Webhook URL here.

Gui, Font, s11 cWhite Bold, Segoe UI
Gui, Add, Button, x35 y185 w150 h25 gClearLogs, Clear Roblox Logs

Gui, Font, s11 cWhite Bold, Segoe UI
Gui, Add, GroupBox, x33 y215 w350 h68 cWhite, Show Runtime
Gui, Font, s10 c0xCCCCCC Normal
Gui, Add, Text, x43 y231 w515 h135 BackgroundTrans, Displays your macro's runtime via the biome webhooks.
Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Button, x43 y251 w80 h25 gToggleDisplayRuntime vDisplayRuntimeBtn, Toggle
Gui, Font, s10 c0xCCCCCC Bold, Segoe UI
Gui, Add, Text, x133 y253 w70 h25 vDisplayRuntimeStatus BackgroundTrans, OFF

Gui, Font, s13 cWhite Bold, Segoe UI
Gui, Add, Button, x35 y295 w70 h35 gStartScript vStartBtn c0x00AA00 +0x8000, Start
Gui, Add, Button, x115 y295 w70 h35 gStopScript vStopBtn Disabled c0xFF4444 +0x8000, Stop

if (displayRuntime) {
    GuiControl,, DisplayRuntimeStatus, ON
    GuiControl, +c0x00DD00, DisplayRuntimeStatus
} else {
    GuiControl,, DisplayRuntimeStatus, OFF
    GuiControl, +c0xFF4444, DisplayRuntimeStatus
}

Gui, Show, w500 h350,  aery's biome macro v1.2
GuiControl, Focus, StartBtn
return

GuiClose:
GoSub, StopScript

UpdatePrivateServer:
    Gui, Submit, NoHide
    privateServerLink := PrivateServerInput
    IniWrite, %privateServerLink%, %settingsFilePath%, Macro, privateServerLink
return

UpdateWebhook:
    Gui, Submit, nohide
    webhookURL := WebhookInput
    IniWrite, %webhookURL%, %settingsFilePath%, Macro, webhookURL
return

ToggleDisplayRuntime:
    displayRuntime := !displayRuntime
    if (displayRuntime) {
        GuiControl,, DisplayRuntimeStatus, ON
        GuiControl, +c0x00DD00, DisplayRuntimeStatus
    } else {
        GuiControl,, DisplayRuntimeStatus, OFF
        GuiControl, +c0xFF4444, DisplayRuntimeStatus
    }
    IniWrite, % (displayRuntime ? "true" : "false"), %settingsFilePath%, Macro, displayRuntime
return

ClearLogs:
    Process, Exist, RobloxCrashHandler.exe
    if (ErrorLevel) {
        Process, Close, RobloxCrashHandler.exe
    }
    sleep, 25
    FileDelete, %logDir%\*.log
    FileDelete, %ROBLOX_LOGS%
return

BiomeDetect:
global webhookURL, biome, prevBiome, logDir, runTime

    newestTime := 0
    newestFile := ""
    Loop, Files, %logDir%\*.log, F
    {
        if (A_LoopFileTimeModified > newestTime) {
            newestTime := A_LoopFileTimeModified
            newestFile := A_LoopFileFullPath
        }
    }

    if !newestFile
        return

    file := FileOpen(newestFile, "r")
    if !IsObject(file)
        return

    size := file.Length
    chunkSize := 10240
    if (size > chunkSize)
        file.Seek(-chunkSize, 2)
    content := file.Read()
    file.Close()

    lines := StrSplit(content, "`n")
    regexLine := """state"":""((?:\\.|[^""])*)"".*?""largeImage"":\{""hoverText"":""((?:\\.|[^""])*)"""
    Loop % lines.MaxIndex()
    {
        line := lines[lines.MaxIndex() - A_Index + 1]
        if InStr(line, "[BloxstrapRPC]")
        {
            if RegExMatch(line, regexLine, m) {
                state := m1
                biome := m2
                break
            }
        }
    }

    if (biome && biome != "" && biome != prevBiome) {
        runTime := runTimeTick ? (A_TickCount - runTimeTick) // 1000 : 0
        runTimeDisplay := FormatRuntime(runTime)
        ; end webhook
        if ((prevBiome != "" && prevBiome != "Normal") && (biome != prevBiome)) {
            if (biomeData.HasKey(prevBiome)) {
                endColor := biomeData[prevBiome].color
            }

            endwebhookTime := A_NowUTC
            endTimestamp := SubStr(endwebhookTime,1,4) "-" SubStr(endwebhookTime,5,2) "-" SubStr(endwebhookTime,7,2) "T" SubStr(endwebhookTime,9,2) ":" SubStr(endwebhookTime,11,2) ":" SubStr(endwebhookTime,13,2) ".000Z"
            endwebhookUnix := A_NowUTC
            EnvSub, endwebhookUnix, 19700101000000, Seconds

            if (displayRuntime) {
                enddescription := "> ### Biome Ended - " prevBiome "\n> " runTimeDisplay " " 
            } else {
                    enddescription := "> ### Biome Ended - " prevBiome " "
            }

            endJson := "{"
            . """embeds"": ["
            . "  {"
            . "    ""title"": ""<t:" endwebhookUnix ":F> (<t:" endwebhookUnix ":R>)"","
            . "    ""description"": """ enddescription ""","
            . "    ""color"": " biomeColor ","
            . "    ""footer"": {""text"": ""aery's biome macro | v1.2"", ""icon_url"": ""https://raw.githubusercontent.com/knowaery/Aery-s-Fishsol/files/img/aery.png""},"
            . "    ""timestamp"": """ endTimestamp """"
            . "  }"
            . "],"
            . """content"": """""
            . "}"

            try endHttp := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            try endHttp.Open("POST", webhookURL, false)
            try endHttp.SetRequestHeader("Content-Type", "application/json")
            try endHttp.Send(endJson)
        }

        
        ; start webhook
        if ((biome != "" || biome = "GLITCHED" || biome = "DREAMSPACE" || biome = "CYBERSPACE" || biome = "SINGULARITY") && biome != "NORMAL") {
            if (biomeData.HasKey(biome)) {
                biomeColor    := biomeData[biome].color
                thumbnail_url := biomeData[biome].thumbnail
            }

            startwebhookTime := A_NowUTC
            startTimestamp := SubStr(startwebhookTime,1,4) "-" SubStr(startwebhookTime,5,2) "-" SubStr(startwebhookTime,7,2) "T" SubStr(startwebhookTime,9,2) ":" SubStr(startwebhookTime,11,2) ":" SubStr(startwebhookTime,13,2) ".000Z"
            startwebhookUnix := A_NowUTC
            EnvSub, startwebhookUnix, 19700101000000, Seconds


            if (biome = "GLITCHED" || biome = "DREAMSPACE" || biome = "CYBERSPACE") && (state != "In Main Menu") {
                content := "<@everyone>"
            } else if (biome = "GLITCHED" || biome = "DREAMSPACE" || biome = "CYBERSPACE") && (state = "In Main Menu") {
                SetTimer, BiomeDetect, Off
                StopMacroWebhook()
                running := false
                MsgBox, 16, Error, Rare Biome deteced whilst being in Main Menu. The macro has automatically closed.
                ExitApp
                return
            } else {
                content := ""
            }

            if (displayRuntime) {
                description := "> ## Biome Started - " biome "\n> ### [Join Server](" privateServerLink ")\n> " runTimeDisplay "  "
            } else {
                description := "> ## Biome Started - " biome "\n> ### [Join Server](" privateServerLink ")  "
            }

            json := "{"
            . """embeds"": ["
            . "  {"
            . "    ""title"": ""<t:" startwebhookUnix ":F> (<t:" startwebhookUnix ":R>)"","
            . "    ""description"": """ description ""","
            . "    ""color"": " biomeColor ","
            . "    ""thumbnail"": {""url"": """ thumbnail_url """},"
            . "    ""footer"": {""text"": ""aery's biome macro | v1.2"", ""icon_url"": ""https://raw.githubusercontent.com/knowaery/Aery-s-Fishsol/files/img/aery.png""},"
            . "    ""timestamp"": """ startTimestamp """"
            . "  }"
            . "],"
            . """content"": """ content """"
            . "}"

            try http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            try http.Open("POST", webhookURL, false)
            try http.SetRequestHeader("Content-Type", "application/json")
            try http.Send(json)
        }
        prevBiome := biome
    }
return

StartMacroWebhook() {
    global webhookURL
    if (!InStr(webhookURL, "discord"))
        return

    startMacroTime := A_NowUTC
    timestamp := SubStr(startMacroTime,1,4) "-" SubStr(startMacroTime,5,2) "-" SubStr(startMacroTime,7,2) "T" SubStr(startMacroTime,9,2) ":" SubStr(startMacroTime,11,2) ":" SubStr(startMacroTime,13,2) ".000Z"
    content := ""
    color := 7909721

    json := "{"
    . """content"": """ content ""","
    . """embeds"": [{"
    . """title"": "":green_circle: Macro Started!"","
    . """color"": " color ","
    . """footer"": {"
    . """text"": ""aery's biome macro | v1.2"","
    . """icon_url"": ""https://raw.githubusercontent.com/knowaery/Aery-s-Fishsol/files/img/aery.png"""
    . "},"
    . """timestamp"": """ timestamp """"
    . "}]"
    . "}"

    try http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    try http.Open("POST", webhookURL, false)
    try http.SetRequestHeader("Content-Type", "application/json")
    try http.Send(json)
}

StopMacroWebhook() {
    global webhookURL, displayRuntime, runTimeTick
    if (!InStr(webhookURL, "discord"))
        return

    endMacroTime := A_NowUTC
    timestamp := SubStr(endMacroTime,1,4) "-" SubStr(endMacroTime,5,2) "-" SubStr(endMacroTime,7,2) "T" SubStr(endMacroTime,9,2) ":" SubStr(endMacroTime,11,2) ":" SubStr(endMacroTime,13,2) ".000Z"
    content := ""
    color := 14495300

    if (displayRuntime) {
        totalRuntime := FormatRuntime((A_TickCount - runTimeTick) // 1000)
        description := "> Total " totalRuntime "  "
    } else {
        description := ""
    }

    json := "{"
    . """content"": """ content ""","
    . """embeds"": [{"
    . """title"": "":red_circle: Macro Stopped!"","
    . """description"": """ description ""","
    . """color"": " color ","
    . """footer"": {"
    . """text"": ""aery's biome macro | v1.2"","
    . """icon_url"": ""https://raw.githubusercontent.com/knowaery/Aery-s-Fishsol/files/img/aery.png"""
    . "},"
    . """timestamp"": """ timestamp """"
    . "}]"
    . "}"

    try http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    try http.Open("POST", webhookURL, false)
    try http.SetRequestHeader("Content-Type", "application/json")
    try http.Send(json)
}

StartScript:
if (running)
    return

running := true
    SetTimer, BiomeDetect, 1000
    StartMacroWebhook()
    GuiControl, Disable, StartBtn
    GuiControl, Enable, StopBtn
    GuiControl,, TitleText, aery's biome macro v1.2 (running)
    WinSetTitle, aery's biome macro v1.2, , aery's biome macro v1.2 (running)
    GuiControl, Focus, StopBtn
    runTimeTick := A_TickCount
return

StopScript:
if (!running)
    ExitApp

running := false
    SetTimer, BiomeDetect, Off

    StopMacroWebhook()
    ExitApp
return

FormatRuntime(runTime) {
    h := runTime // 3600
    m := Mod(runTime, 3600) // 60
    s := Mod(runTime, 60)
    out := ""
    if (h > 0)
        out .= h "hr "
    if (h > 0 || m > 0)
        out .= m "m "
    out .= s "s"
    return "Runtime: " out
}
