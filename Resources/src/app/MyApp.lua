local AppBase = require("app.base.AppBase")
local MyApp = class("MyApp", AppBase)

function MyApp:ctor()
    MyApp.super.ctor(self)
end

function MyApp:run()
    self:enterScene("TestScene")
    -- self:enterScene("MainScene")
end

return MyApp
