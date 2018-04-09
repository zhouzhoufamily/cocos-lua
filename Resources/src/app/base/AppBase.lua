
local AppBase = class("AppBase")

function AppBase:ctor()
    self.configs_ = {
        scenesRoot  = "app.scenes",
        viewsRoot  = "app.views",
        modelsRoot = "app.models",
        defaultSceneName = "MainScene",
    }

    for k, v in pairs(configs or {}) do
        self.configs_[k] = v
    end

    if type(self.configs_.scenesRoot) ~= "table" then
        self.configs_.scenesRoot = {self.configs_.scenesRoot}
    end
    if type(self.configs_.viewsRoot) ~= "table" then
        self.configs_.viewsRoot = {self.configs_.viewsRoot}
    end
    if type(self.configs_.modelsRoot) ~= "table" then
        self.configs_.modelsRoot = {self.configs_.modelsRoot}
    end

    if DEBUG > 1 then
        dump(self.configs_, "AppBase configs")
    end

    if CC_SHOW_FPS then
        cc.Director:getInstance():setDisplayStats(true)
    end

    -- event
    self:onCreate()
end

function AppBase:run()
    initSceneName = initSceneName or self.configs_.defaultSceneName
    self:enterScene(initSceneName)
end

function AppBase:exit()
    cc.Director:getInstance():endToLua()
    if device.platform == "windows" or device.platform == "mac" then
        os.exit()
    end
end

function AppBase:enterScene(sceneName, transitionType, time, more, ...)
    local isSuccess = false
    for _, root in ipairs(self.configs_.scenesRoot) do
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
            display.runScene(scene, transitionType, time, more)
            isSuccess = true
        end
    end
    if not isSuccess then
        error(string.format("AppBase:enterScene() - not found scene \"%s\" in search paths \"%s\"",
        sceneName, table.concat(self.configs_.scenesRoot, ",")), 0)
    end
end

function AppBase:createView(viewName, ...)
    for _, root in ipairs(self.configs_.viewsRoot) do
        local packageName = string.format("%s.%s", root, viewName)
        local status, view = xpcall(function()
                return require(packageName)
            end, function(msg)
            if not string.find(msg, string.format("'%s' not found:", packageName)) then
                print("load view error: ", msg)
            end
        end)
        local t = type(view)
        if status and (t == "table" or t == "userdata") then
            return view:create(self, viewName)
        end
    end
    error(string.format("AppBase:createView() - not found view \"%s\" in search paths \"%s\"",
    viewName, table.concat(self.configs_.viewsRoot, ",")), 0)
end

function AppBase:onCreate()
    local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
    local customListenerBg = cc.EventListenerCustom:create("APP_ENTER_BACKGROUND_EVENT", function()
		audio.pauseAll()
		self:onEnterBackground()
	end)
    eventDispatcher:addEventListenerWithFixedPriority(customListenerBg, 1)
    local customListenerFg = cc.EventListenerCustom:create("APP_ENTER_FOREGROUND_EVENT", function()
		audio.resumeAll()
		self:onEnterForeground()
	end)
    eventDispatcher:addEventListenerWithFixedPriority(customListenerFg, 1)
end

-- override me
function AppBase:onEnterBackground()
end

-- override me
function AppBase:onEnterForeground()
end

return AppBase
