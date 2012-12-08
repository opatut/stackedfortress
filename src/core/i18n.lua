require("core/helper")

Lang = class("Lang")

function Lang:__init(lang)
    self.available = {}
    self.languages = {}
    self:scan()
    if not lang then lang = "en_US" end
    self:setLanguage(lang)
end

function Lang:setLanguage(lang)
    if self.currentLanguage == lang then return true end
    if not self.available[lang] then
        print("Could not set language "..lang..": not available.")
        return false
    end
    if not self.languages[lang] then
        if not self:load(lang) then
            print("Could not load language " .. lang .. ".")
            return false
        end
    end
    self.currentLanguage = lang
    return true
end

function Lang:scan()
    local folder = "i18n"
    local files = love.filesystem.enumerate(folder)
    for i,v in ipairs(files) do
        local file = folder.."/"..v
        local lang = string.sub(v, 1, -5)
        self.available[lang] = file
    end
end

function Lang:load(lang)
    ok, chunk = pcall(love.filesystem.load, self.available[lang])
    if not ok then return false end

    ok, contents = pcall(chunk)
    if not ok then return false end

    self.languages[lang] = contents
    return true
end

function Lang:_(key)
    local l = self.languages[self.currentLanguage]
    if not l then print("Cannot use language") return "?" end
    if l[key] then return l[key] else return "<" .. key .. ">" end
end
