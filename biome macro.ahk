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
paused := false
runTimeTick := 0
runTime := 0
pausedTick := 0
pausedTotal := 0
runTimeDisplay := 0
displayRuntime := false

if (biomeData = "") {
    biomeData := {}
    biomeData["NORMAL"]       := {color: 0,         thumbnail: "https://cdn.solsstattracker.com/biomes/NORMAL.png"}
    biomeData["WINDY"]        := {color: 10150399,  thumbnail: "https://cdn.solsstattracker.com/biomes/WINDY.png"}
    biomeData["RAINY"]        := {color: 163773,    thumbnail: "https://cdn.solsstattracker.com/biomes/RAINY.png"}
    biomeData["SNOWY"]        := {color: 14479353,  thumbnail: "https://cdn.solsstattracker.com/biomes/SNOWY.png"}
    biomeData["SAND STORM"]   := {color: 9401431,   thumbnail: "https://cdn.solsstattracker.com/biomes/SAND%20STORM.png"}
    biomeData["HELL"]         := {color: 16730905,  thumbnail: "https://cdn.solsstattracker.com/biomes/HELL.png"}
    biomeData["STARFALL"]     := {color: 72375,     thumbnail: "https://cdn.solsstattracker.com/biomes/STARFALL.png"}
    biomeData["CORRUPTION"]   := {color: 7155368,   thumbnail: "https://cdn.solsstattracker.com/biomes/CORRUPTION.png"}
    biomeData["NULL"]         := {color: 8618883,   thumbnail: "https://cdn.solsstattracker.com/biomes/NULL.png"}
    biomeData["GLITCHED"]     := {color: 12582656,  thumbnail: "https://cdn.solsstattracker.com/biomes/GLITCHED.png"}
    biomeData["DREAMSPACE"]   := {color: 15376858,  thumbnail: "https://cdn.solsstattracker.com/biomes/DREAMSPACE.png"}
    biomeData["HEAVEN"]       := {color: 16769184,  thumbnail: "https://cdn.solsstattracker.com/biomes/HEAVEN.png"}
    biomeData["CYBERSPACE"]   := {color: 663101,    thumbnail: "https://cdn.solsstattracker.com/biomes/CYBERSPACE.png"}
    biomeData["SINGULARITY"]  := {color: 13582371,  thumbnail: "https://cdn.solsstattracker.com/biomes/SINGULARITY.png"}
    biomeData["BLAZING SUN"]  := {color: 16106050,  thumbnail: "https://cdn.solsstattracker.com/biomes/BLAZING%20SUN.png"}
    biomeData["AURORA"]       := {color: 9065205,   thumbnail: "https://cdn.solsstattracker.com/biomes/AURORA.png"}
    biomeData["GRAVEYARD"]    := {color: 8421504,   thumbnail: "https://cdn.solsstattracker.com/biomes/GRAVEYARD.png"}
    biomeData["PUMPKIN MOON"] := {color: 14912571,  thumbnail: "https://cdn.solsstattracker.com/biomes/PUMPKIN%20MOON.png"}
    biomeData["BLOOD RAIN"]   := {color: 12847366,  thumbnail: "https://cdn.solsstattracker.com/biomes/BLOOD%20RAIN.png"}
    biomeData["INCINERATOR"]  := {color: 10373176,  thumbnail: "https://cdn.solsstattracker.com/biomes/INCINERATOR.png"}
    biomeData["LOST FOREST"]  := {color : 671781,   thumbnail: "https://cdn.solsstattracker.com/biomes/LOST%20FOREST.png"}
    biomeData["THE RADIANT FOREST"] := {color: 9122490, thumbnail: "https://cdn.solsstattracker.com/biomes/THE%20RADIANT%20FOREST.png"}
}

subBiomes := ["SINGULARITY", "THE RADIANT FOREST"]
rareBiomes := ["GLITCHED", "DREAMSPACE", "CYBERSPACE"]

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
        displayRuntime := (tempDisplayRuntime = "true" || tempDisplayRuntime = 1)
    }
}

Gui, Color, 0B0F1A
Gui, Margin, 0, 0

Gui, Font, s18 cFFAA00 Bold, Segoe UI
Gui, Add, Text, x35 y14 w440 h36 BackgroundTrans vTitleText, aery's biome macro v1.3

Gui, Add, Progress, x20 y60 w440 h88 Background131A2B Disabled
Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Text, x35 y69 w300 h20 BackgroundTrans, Private Server Link
Gui, Font, s10 cBlack Bold, Segoe UI
Gui, Add, Edit, x35 y92 w410 h26 -E0x200 +Border BackgroundWhite vPrivateServerInput gUpdatePrivateServer, %privateServerLink%
Gui, Font, s8 c8892A6 Normal, Segoe UI
Gui, Add, Text, x35 y124 w410 h16 BackgroundTrans, Paste your Roblox Private Server link here.

Gui, Add, Progress, x20 y160 w440 h88 Background131A2B Disabled
Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Text, x35 y168 w300 h20 BackgroundTrans, Discord Webhook URL
Gui, Font, s10 cBlack Bold, Segoe UI
Gui, Add, Edit, x35 y193 w410 h26 -E0x200 +Border BackgroundWhite vWebhookInput gUpdateWebhook, %webhookURL%
Gui, Font, s8 c8892A6 Normal, Segoe UI
Gui, Add, Text, x35 y224 w410 h16 BackgroundTrans, Paste your Discord Webhook URL here.

Gui, Add, Progress, x20 y260 w440 h66 Background131A2B Disabled
Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Text, x35 y270 w120 h20 BackgroundTrans, Show Runtime
Gui, Font, s10 c0xFF4444  Bold, Segoe UI
Gui, Add, Text, x140 y270 w60 h20 BackgroundTrans vDisplayRuntimeStatus, OFF
Gui, Font, s8 c8892A6 Normal, Segoe UI
Gui, Add, Text, x35 y294 w310 h26 BackgroundTrans, Displays your macro's runtime through biome webhooks.
Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Text, x365 y278 w80 h30 Center +0x200 Background1B2438 gToggleDisplayRuntime vDisplayRuntimeBtn, Toggle

Gui, Font, s10 cWhite Bold, Segoe UI
Gui, Add, Progress, x20 y335 w170 h41 Center Background131A2B Disabled
Gui, Add, Text, x25 y340 w160 h32 Center +0x200 Background131A2B gClearLogs, Clear Roblox Logs

Gui, Font, s13 cWhite Bold, Segoe UI
Gui, Add, Text, x20  y388 w140 h42 Center +0x200 Background00C26E gStartScript vStartBtn, ▶  Start
Gui, Add, Text, x170 y388 w140 h42 Center +0x200 BackgroundE0A100 gPauseScript vPauseBtn, ⏸  Pause
Gui, Add, Text, x320 y388 w140 h42 Center +0x200 Background3A2030 gStopScript vStopBtn Disabled, ■  Stop

if (displayRuntime) {
    GuiControl,, DisplayRuntimeStatus, ON
    GuiControl, +c0x00DD00, DisplayRuntimeStatus
} else {
    GuiControl,, DisplayRuntimeStatus, OFF
    GuiControl, +c0xFF4444, DisplayRuntimeStatus
}

Gui, Show, w480 h450, aery's biome macro v1.3
GuiControl, Focus, StartBtn
return

GuiClose:
GoSub, StopScript
return

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
    EnvGet, TempDir, TEMP
    robloxCache := TempDir "\roblox"
    Process, Exist, RobloxCrashHandler.exe
    if (ErrorLevel) {
        Process, Close, RobloxCrashHandler.exe
    }
    sleep, 25
    FileDelete, %logDir%\*.log
    FileDelete, %ROBLOX_LOGS%
    if FileExist(robloxCache) {
        FileRemoveDir, %robloxCache%, 1
    }
return

BiomeDetect:
global webhookURL, biome, prevBiome, logDir

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
        runTime := GetRuntime()
        runTimeDisplay := FormatRuntime(runTime)
        ; end webhook
        if ((prevBiome != "" && prevBiome != "Normal") && (biome != prevBiome)) {
            if (biomeData.HasKey(prevBiome)) {
                endColor := biomeData[prevBiome].color
            } else {
                endColor := 0
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
            . "    ""footer"": {""text"": ""aery's biome macro | v1.3"", ""icon_url"": ""https://github.com/knowaery/Aery-s-fishSol/raw/main/files/img/aery.png""},"
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
            } else {
                biomeColor := 0
                thumbnail_url := ""
            }

            startwebhookTime := A_NowUTC
            startTimestamp := SubStr(startwebhookTime,1,4) "-" SubStr(startwebhookTime,5,2) "-" SubStr(startwebhookTime,7,2) "T" SubStr(startwebhookTime,9,2) ":" SubStr(startwebhookTime,11,2) ":" SubStr(startwebhookTime,13,2) ".000Z"
            startwebhookUnix := A_NowUTC
            EnvSub, startwebhookUnix, 19700101000000, Seconds


            if (running) && (biome = "GLITCHED" || biome = "DREAMSPACE" || biome = "CYBERSPACE") && (state != "In Main Menu") {
                content := "@everyone"
            } else if (running) && (InArray(subBiomes, biome) || InArray(rareBiomes, biome)) && (state = "In Main Menu") {
                SetTimer, BiomeDetect, Off
                running := false
                StopMacroWebhook()
                MsgBox, 16, Error, Rare Biome deteced whilst being in Main Menu. The macro has automatically closed to prevent an accidental webhook.
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
            . "    ""footer"": {""text"": ""aery's biome macro | v1.3"", ""icon_url"": ""https://github.com/knowaery/Aery-s-fishSol/raw/main/files/img/aery.png""},"
            . "    ""timestamp"": """ startTimestamp """"
            . "  }"
            . "],"
            . """content"": """ content """"
            . "}"
            if (running) {
                try http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
                try http.Open("POST", webhookURL, false)
                try http.SetRequestHeader("Content-Type", "application/json")
                try http.Send(json)
            }
        }
        prevBiome := biome
    }
return

StartMacroWebhook() {
    global webhookURL, paused
    if (!InStr(webhookURL, "discord"))
        return

    startMacroTime := A_NowUTC
    timestamp := SubStr(startMacroTime,1,4) "-" SubStr(startMacroTime,5,2) "-" SubStr(startMacroTime,7,2) "T" SubStr(startMacroTime,9,2) ":" SubStr(startMacroTime,11,2) ":" SubStr(startMacroTime,13,2) ".000Z"
    content := ""
    color := 7909721

    if (paused) {
        title := ":green_circle: Macro Resumed!"
    } else {
        title := ":green_circle: Macro Started!"
    }

    json := "{"
    . """content"": """ content ""","
    . """embeds"": [{"
    . """title"": """ title ""","
    . """color"": " color ","
    . """footer"": {"
    . """text"": ""aery's biome macro | v1.3"","
    . """icon_url"": ""https://github.com/knowaery/Aery-s-fishSol/raw/main/files/img/aery.png"""
    . "},"
    . """timestamp"": """ timestamp """"
    . "}]"
    . "}"

    try http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
    try http.Open("POST", webhookURL, false)
    try http.SetRequestHeader("Content-Type", "application/json")
    try http.Send(json)
}

PauseMacroWebhook() {
    global webhookURL, displayRuntime, runTimeTick
    if (!InStr(webhookURL, "discord"))
        return

    endMacroTime := A_NowUTC
    timestamp := SubStr(endMacroTime,1,4) "-" SubStr(endMacroTime,5,2) "-" SubStr(endMacroTime,7,2) "T" SubStr(endMacroTime,9,2) ":" SubStr(endMacroTime,11,2) ":" SubStr(endMacroTime,13,2) ".000Z"
    content := ""
    color := 16632664

    if (displayRuntime) {
        totalRuntime := FormatRuntime(GetRuntime())
        description := "> Current " totalRuntime "  "
    } else {
        description := ""
    }

    json := "{"
    . """content"": """ content ""","
    . """embeds"": [{"
    . """title"": "":yellow_circle: Macro Paused!"","
    . """description"": """ description ""","
    . """color"": " color ","
    . """footer"": {"
    . """text"": ""aery's biome macro | v1.3"","
    . """icon_url"": ""https://github.com/knowaery/Aery-s-fishSol/raw/main/files/img/aery.png"""
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
        totalRuntime := FormatRuntime(GetRuntime())
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
    . """text"": ""aery's biome macro | v1.3"","
    . """icon_url"": ""https://github.com/knowaery/Aery-s-fishSol/raw/main/files/img/aery.png"""
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
    if (pausedTick) {
        pausedTotal += A_TickCount - pausedTick
        pausedTick := 0
    } else {
        runTimeTick := A_TickCount
        pausedTotal := 0
    }
    SetTimer, BiomeDetect, 1000
    StartMacroWebhook()
    GuiControl, Disable, StartBtn
    GuiControl, Enable, StopBtn
    GuiControl, Enable, PauseBtn
    GuiControl,, TitleText, aery's biome macro v1.3 (running)
    WinSetTitle, aery's biome macro v1.3, , aery's biome macro v1.3 (running)
    GuiControl, Focus, StopBtn
    paused := false
return

PauseScript:
if (!running)
    return

    running := false
    paused := true
    pausedTick := A_TickCount
    SetTimer, BiomeDetect, Off
    PauseMacroWebhook()
    GuiControl, Enable, StartBtn
    GuiControl, Disable, PauseBtn
    GuiControl,, TitleText, aery's biome macro v1.3 (paused)
    WinSetTitle, aery's biome macro v1.3 (running), , aery's biome macro v1.3 (paused)
return

StopScript:
    if (running || paused) {
        running := false
        paused := false
        SetTimer, BiomeDetect, Off
        StopMacroWebhook()
    }
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

GetRuntime() {
    global runTimeTick, pausedTick, pausedTotal
    if (!runTimeTick)
        return 0
    now := pausedTick ? pausedTick : A_TickCount
    return (now - runTimeTick - pausedTotal) // 1000
}

InArray(var, val) {
    for index, item in var
        if (item = val)
            return true
    return false
}
