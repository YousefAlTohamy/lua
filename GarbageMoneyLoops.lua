-- #region Startup.lua (Modified by Yousef Altohamy)
-- #region Shortcuts
local J = Utils.Joaat
local F = string.format

-- #endregion

-- #region Enums

local eFeatureHash = {
    SETTINGS = 4067697962,
    TRANSLATIONS = 476570075,
    THEMES = 3578289549,
    LOAD_SETTINGS = 726878929,
    LOAD_TRANSLATION = 1079343186,
    LOAD_THEME = 2958805088,
    SESSION_TYPE = 603923874,
    LOOP_650K = J("LOOP_650K_MONEY")
}

-- #endregion

-- #region Variables

local DEFAULT_SETTINGS = "Empty"
local DEFAULT_TRANSLATION = "TranslationFile"
local DEFAULT_THEME = "Original.json"
local DEFAULT_SESSION = "Join Public Session"

local SETTINGS = nil
local TRANSLATION = nil
local THEME = nil
local SESSION = nil
local AUTO_SETTINGS = nil
local AUTO_TRANSLATION = nil
local AUTO_THEME = nil
local AUTO_SESSION = nil

local INITIALIZED = false

-- #endregion

-- #region Startup.ini

local INI_FILE_PATH = F("%s\\Lua\\Startup.ini", FileMgr.GetMenuRootPath())

local function SaveStartupIni()
    local content = F(
                        "Settings=%s\nTranslation=%s\nTheme=%s\nSession=%s\nAutoSettings=%s\nAutoTranslation=%s\nAutoTheme=%s\nAutoSession=%s",
                        SETTINGS, TRANSLATION, THEME, SESSION,
                        tostring(AUTO_SETTINGS), tostring(AUTO_TRANSLATION),
                        tostring(AUTO_THEME), tostring(AUTO_SESSION))

    if not FileMgr.WriteFileContent(INI_FILE_PATH, content, false) then
        Logger.Log("Failed to write 'Startup.ini' file due to an unknown error.")
        SetShouldUnload()
    end
end

local function LoadStartupIni()
    if not FileMgr.DoesFileExist(INI_FILE_PATH) then
        SETTINGS = DEFAULT_SETTINGS
        TRANSLATION = DEFAULT_TRANSLATION
        THEME = DEFAULT_THEME
        SESSION = DEFAULT_SESSION
        AUTO_SETTINGS = false
        AUTO_TRANSLATION = false
        AUTO_THEME = false
        AUTO_SESSION = false

        Logger.Log(
            "'Startup.ini' file doesn't exist. File created. Using defaults.")
        SaveStartupIni()
        return
    end

    local content = FileMgr.ReadFileContent(INI_FILE_PATH)

    if not content or content == "" then
        SETTINGS = DEFAULT_SETTINGS
        TRANSLATION = DEFAULT_TRANSLATION
        THEME = DEFAULT_THEME
        SESSION = DEFAULT_SESSION
        AUTO_SETTINGS = false
        AUTO_TRANSLATION = false
        AUTO_THEME = false
        AUTO_SESSION = false
        SaveStartupIni()
        Logger.Log("'Startup.ini' file is empty or corrupted. Using defaults.")
        return
    end

    for line in string.gmatch(content, "[^\r\n]+") do
        local key, value = string.match(line, "^(%w+)=(.+)$")

        if key and value then
            if key == "Settings" then SETTINGS = value end
            if key == "Translation" then TRANSLATION = value end
            if key == "Theme" then THEME = value end
            if key == "Session" then SESSION = value end
            if key == "AutoSettings" then
                AUTO_SETTINGS = (value == "true")
            end
            if key == "AutoTranslation" then
                AUTO_TRANSLATION = (value == "true")
            end
            if key == "AutoTheme" then AUTO_THEME = (value == "true") end
            if key == "AutoSession" then
                AUTO_SESSION = (value == "true")
            end
        end
    end

    local isCorrupted = false

    if SETTINGS == nil then isCorrupted = true end
    if TRANSLATION == nil then isCorrupted = true end
    if THEME == nil then isCorrupted = true end
    if SESSION == nil then isCorrupted = true end
    if AUTO_SETTINGS == nil then isCorrupted = true end
    if AUTO_TRANSLATION == nil then isCorrupted = true end
    if AUTO_THEME == nil then isCorrupted = true end
    if AUTO_SESSION == nil then isCorrupted = true end

    if isCorrupted then
        if SETTINGS == nil then
            SETTINGS = DEFAULT_SETTINGS
            AUTO_SETTINGS = false
        end

        if TRANSLATION == nil then
            TRANSLATION = DEFAULT_TRANSLATION
            AUTO_TRANSLATION = false
        end

        if THEME == nil then
            THEME = DEFAULT_THEME
            AUTO_THEME = false
        end

        if SESSION == nil then
            SESSION = DEFAULT_SESSION
            AUTO_SESSION = false
        end

        if AUTO_SETTINGS == nil then AUTO_SETTINGS = false end
        if AUTO_TRANSLATION == nil then AUTO_TRANSLATION = false end
        if AUTO_THEME == nil then AUTO_THEME = false end
        if AUTO_SESSION == nil then AUTO_SESSION = false end

        SaveStartupIni()
        Logger.Log(
            "'Startup.ini' file is corrupted. Using defaults for missing values.")
    end
end

-- #endregion

-- #region Wrappers

local _Log = Logger.Log
function Logger.Log(str)
    _Log(eLogColor.LIGHTCYAN, "Settings", str)
    GUI.AddToast("Settings", str, 7000, eToastPos.TOP_RIGHT)
end

function Feature:GetListIndexByString(str)
    local list = self:GetList()
    if not list then return nil end

    for key, value in ipairs(list) do if value == str then return key - 1 end end

    FileMgr.DeleteFile(INI_FILE_PATH)
    Logger.Log(F(
                   "'Startup.ini' references to a bad entry: '%s' in feature '%s'.",
                   str, self:GetName()))
    Logger.Log("'Startup.ini' file has been deleted to prevent further issues.")
    Logger.Log("'Startup.lua' needs to be restarted.")
    SetShouldUnload()
    return nil
end

function Feature:SetListIndexByString(str)
    local list = self:GetList()
    if not list then return self end

    for key, value in ipairs(list) do
        if value == str then
            self:SetListIndex(key - 1)
            return self
        end
    end

    FileMgr.DeleteFile(INI_FILE_PATH)
    Logger.Log(F(
                   "'Startup.ini' references to a bad entry: '%s' in feature '%s'.",
                   str, self:GetName()))
    Logger.Log("'Startup.ini' file has been deleted to prevent further issues.")
    Logger.Log("'Startup.lua' needs to be restarted.")
    SetShouldUnload()
    return self
end

-- #endregion

-- #region Features

local ftrAutoSettings = {
    hash = J("AUTO_SETTINGS"),
    name = "Auto-Load Settings",
    type = eFeatureType.Toggle,
    desc = "Auto-loads the selected settings on startup."
}

local ftrAutoTranslation = {
    hash = J("AUTO_TRANSLATION"),
    name = "Auto-Load Translation",
    type = eFeatureType.Toggle,
    desc = "Auto-loads the selected translation on startup."
}

local ftrAutoTheme = {
    hash = J("AUTO_THEME"),
    name = "Auto-Load Theme",
    type = eFeatureType.Toggle,
    desc = "Auto-loads the selected theme on startup."
}

local ftrAutoSession = {
    hash = J("AUTO_SESSION"),
    name = "Auto-Select Session Type",
    type = eFeatureType.Toggle,
    desc = "Auto-selects the selected session type on startup."
}

local ftrLoop650k = {
    hash = eFeatureHash.LOOP_650K,
    name = "650k Money Loop (No Cooldown)",
    type = eFeatureType.Toggle,
    desc = "Repeatedly triggers the 650k transaction with zero delay."
}

FeatureMgr.AddFeature(ftrAutoSettings.hash, ftrAutoSettings.name,
                      ftrAutoSettings.type, ftrAutoSettings.desc, function(f)
    if not INITIALIZED then return end

    local selectedSettings = FeatureMgr.GetCurrentFeatureListString(
                                 eFeatureHash.SETTINGS)

    if f:IsToggled() then
        if selectedSettings ~= SETTINGS then
            SETTINGS = selectedSettings
            AUTO_SETTINGS = true
        else
            AUTO_SETTINGS = true
        end
    else
        if selectedSettings == SETTINGS then AUTO_SETTINGS = false end
    end

    SaveStartupIni()
end)

FeatureMgr.AddFeature(ftrAutoTranslation.hash, ftrAutoTranslation.name,
                      ftrAutoTranslation.type, ftrAutoTranslation.desc,
                      function(f)
    if not INITIALIZED then return end

    local selectedTranslation = FeatureMgr.GetCurrentFeatureListString(
                                    eFeatureHash.TRANSLATIONS)

    if f:IsToggled() then
        if selectedTranslation ~= TRANSLATION then
            TRANSLATION = selectedTranslation
            AUTO_TRANSLATION = true
        else
            AUTO_TRANSLATION = true
        end
    else
        if selectedTranslation == TRANSLATION then
            AUTO_TRANSLATION = false
        end
    end

    SaveStartupIni()
end)

FeatureMgr.AddFeature(ftrAutoTheme.hash, ftrAutoTheme.name, ftrAutoTheme.type,
                      ftrAutoTheme.desc, function(f)
    if not INITIALIZED then return end

    local selectedTheme = FeatureMgr.GetCurrentFeatureListString(
                              eFeatureHash.THEMES)

    if f:IsToggled() then
        if selectedTheme ~= THEME then
            THEME = selectedTheme
            AUTO_THEME = true
        else
            AUTO_THEME = true
        end
    else
        if selectedTheme == THEME then AUTO_THEME = false end
    end

    SaveStartupIni()
end)

FeatureMgr.AddFeature(ftrAutoSession.hash, ftrAutoSession.name,
                      ftrAutoSession.type, ftrAutoSession.desc, function(f)
    if not INITIALIZED then return end

    local selectedSession = FeatureMgr.GetCurrentFeatureListString(
                                eFeatureHash.SESSION_TYPE)

    if f:IsToggled() then
        if selectedSession ~= SESSION then
            SESSION = selectedSession
            AUTO_SESSION = true
        else
            AUTO_SESSION = true
        end
    else
        if selectedSession == SESSION then AUTO_SESSION = false end
    end

    SaveStartupIni()
end)

FeatureMgr.AddFeature(ftrLoop650k.hash, ftrLoop650k.name, ftrLoop650k.type,
                      ftrLoop650k.desc, function(f)
    if f:IsToggled() then Logger.Log("650k Loop Activated - Be Careful!") end
end)

-- #endregion

-- #region Main

Script.QueueJob(function()
    Script.Yield(1000)

    FeatureMgr.GetFeature(eFeatureHash.SETTINGS):AddRenderAfter(
        FeatureMgr.GetFeature(ftrAutoSettings.hash))
    FeatureMgr.GetFeature(eFeatureHash.TRANSLATIONS):AddRenderAfter(
        FeatureMgr.GetFeature(ftrAutoTranslation.hash))
    FeatureMgr.GetFeature(eFeatureHash.THEMES):AddRenderAfter(
        FeatureMgr.GetFeature(ftrAutoTheme.hash))
    FeatureMgr.GetFeature(eFeatureHash.SESSION_TYPE):AddRenderAfter(
        FeatureMgr.GetFeature(ftrAutoSession.hash))
    local settingsFeature = FeatureMgr.GetFeature(eFeatureHash.SETTINGS)
    settingsFeature:AddRenderAfter(FeatureMgr.GetFeature(ftrLoop650k.hash))

    if not GUI.IsOpen() then GUI.Toggle() end

    LoadStartupIni()

    if SETTINGS == DEFAULT_SETTINGS and AUTO_SETTINGS then
        AUTO_SETTINGS = false
    end

    if AUTO_SETTINGS then
        if not FeatureMgr.GetFeature(eFeatureHash.SETTINGS):GetListIndexByString(
            SETTINGS) then return end

        FeatureMgr.GetFeature(eFeatureHash.SETTINGS):SetListIndexByString(
            SETTINGS)
        FeatureMgr.LoadSettings(SETTINGS)
        Logger.Log(F("Successfully loaded settings '%s'.",
                     SETTINGS:gsub("%.json$", "")))
    end

    if AUTO_TRANSLATION then
        if not FeatureMgr.GetFeature(eFeatureHash.TRANSLATIONS):GetListIndexByString(
            TRANSLATION) then return end

        FeatureMgr.GetFeature(eFeatureHash.TRANSLATIONS):SetListIndexByString(
            TRANSLATION)
        Script.Yield(250)
        FeatureMgr.GetFeature(eFeatureHash.LOAD_TRANSLATION):OnClick()
        Logger.Log(F("Successfully loaded translation '%s'.", TRANSLATION))
    end

    if AUTO_THEME then
        if not FeatureMgr.GetFeature(eFeatureHash.THEMES):GetListIndexByString(
            THEME) then return end

        FeatureMgr.GetFeature(eFeatureHash.THEMES):SetListIndexByString(THEME)
        Script.Yield(250)
        FeatureMgr.GetFeature(eFeatureHash.LOAD_THEME):OnClick()
        Logger.Log(F("Successfully loaded theme '%s'.",
                     THEME:gsub("%.json$", "")))
    end

    if AUTO_SESSION then
        if not FeatureMgr.GetFeature(eFeatureHash.SESSION_TYPE):GetListIndexByString(
            SESSION) then return end

        FeatureMgr.GetFeature(eFeatureHash.SESSION_TYPE):SetListIndexByString(
            SESSION)
        ClickGUI.SetActiveMenuTab(ClickTab.Session)
        Logger.Log(F("Successfully selected session type '%s'.", SESSION))
    end

    INITIALIZED = true

    while true do
        Script.Yield(250)

        if INITIALIZED then
            if FeatureMgr.GetCurrentFeatureListString(eFeatureHash.SETTINGS) ~=
                SETTINGS then
                FeatureMgr.GetFeature(ftrAutoSettings.hash):Toggle(false)
            elseif AUTO_SETTINGS then
                FeatureMgr.GetFeature(ftrAutoSettings.hash):Toggle(true)
            end

            if FeatureMgr.GetCurrentFeatureListString(eFeatureHash.TRANSLATIONS) ~=
                TRANSLATION then
                FeatureMgr.GetFeature(ftrAutoTranslation.hash):Toggle(false)
            elseif AUTO_TRANSLATION then
                FeatureMgr.GetFeature(ftrAutoTranslation.hash):Toggle(true)
            end

            if FeatureMgr.GetCurrentFeatureListString(eFeatureHash.THEMES) ~=
                THEME then
                FeatureMgr.GetFeature(ftrAutoTheme.hash):Toggle(false)
            elseif AUTO_THEME then
                FeatureMgr.GetFeature(ftrAutoTheme.hash):Toggle(true)
            end

            if FeatureMgr.GetCurrentFeatureListString(eFeatureHash.SESSION_TYPE) ~=
                SESSION then
                FeatureMgr.GetFeature(ftrAutoSession.hash):Toggle(false)
            elseif AUTO_SESSION then
                FeatureMgr.GetFeature(ftrAutoSession.hash):Toggle(true)
            end
        end
    end
end)

Script.QueueJob(function()
    -- Cache feature outside the loop
    local moneyFeature = FeatureMgr.GetFeature(eFeatureHash.LOOP_650K)

    while true do
        if moneyFeature and moneyFeature:IsToggled() then
            if not Network.IsPlayerLoggingIn() and Network.IsSessionActive() then
                local success, charIndex = Stats.GetInt(Utils.Joaat("MPPLY_LAST_MP_CHAR"))
                charIndex = success and charIndex or 0
                
                -- Execute 650k transaction for the current multiplayer character
                local statHash = Utils.Joaat("MP" .. charIndex .. "_CASINO_HEIST_MONEY")
                Stats.SetInt(statHash, 650000)

                Script.Yield(15)
            else
                Script.Yield(500)
            end
        else
            Script.Yield(500)
        end
    end
end)

-- #endregion

-- #region On Unload

EventMgr.RegisterHandler(eLuaEvent.ON_UNLOAD, function()
    FeatureMgr.GetFeature(eFeatureHash.TRANSLATIONS):RemoveRenderAfter(
        FeatureMgr.GetFeature(ftrAutoTranslation.hash))
    FeatureMgr.GetFeature(eFeatureHash.THEMES):RemoveRenderAfter(
        FeatureMgr.GetFeature(ftrAutoTheme.hash))
    FeatureMgr.GetFeature(eFeatureHash.SETTINGS):RemoveRenderAfter(
        FeatureMgr.GetFeature(ftrAutoSettings.hash))
    FeatureMgr.GetFeature(eFeatureHash.SESSION_TYPE):RemoveRenderAfter(
        FeatureMgr.GetFeature(ftrAutoSession.hash))
    FeatureMgr.GetFeature(eFeatureHash.SETTINGS):RemoveRenderAfter(
        FeatureMgr.GetFeature(ftrLoop650k.hash))
end)

-- #endregion

-- #endregion
