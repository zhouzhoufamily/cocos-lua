local AppBase = require("app.base.AppBase")
local MyApp = class("MyApp", AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    -- self:enterScene("TestScene")
    -- self:enterScene("LoadingScene")
    -- self:enterScene("LoginScene")
    -- self:enterScene("ChatScene")
    -- self:enterScene("Base3DScene")
    self:enterScene("CameraScene")
    
end

return MyApp
