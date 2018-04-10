local SceneManager = ...

local M = {}
_G[SceneManager] = M

package.loaded[SceneManager] = M

local director = cc.Director:getInstance()

local configs_ = {
    scenesRoot  = "app.scenes",
}
local scenesRoot = "app.scenes"
for k, v in pairs(configs or {}) do
    configs_[k] = v
end
if type(configs_.scenesRoot) ~= "table" then
    configs_.scenesRoot = {configs_.scenesRoot}
end

setfenv(1, M)

function pushScene( ... )
    -- body
end

function popScene( ... )
    -- body
end

function replaceScene( sceneName, ... )
    local isSuccess = false
    for _, root in ipairs(configs_.scenesRoot) do
        local scenePackageName = string.format("%s.%s", root, sceneName)
        local status, sceneClass = xpcall(function()
                return require(scenePackageName)
            end, function(msg)
            if not string.find(msg, string.format("'%s' not found:", scenePackageName)) then
                print("load scene error: ", msg)
            end
        end)
        local t = type(sceneClass)
        if status and (t == "table" or t == "userdata") then
            local scene = sceneClass.new(...)
            director:replaceScene( sceneName, ... )
            isSuccess = true
        end
    end
    if not isSuccess then
        error(string.format("SceneManager:ReplaceScene() - not found scene \"%s\" in search paths \"%s\"",
        sceneName, table.concat(configs_.scenesRoot, ",")), 0)
    end
end