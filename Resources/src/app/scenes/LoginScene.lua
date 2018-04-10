module(..., package.seeall)  
local AppBase = require "app.base.AppBase"
local BaseScene = require "app.scenes.BaseScene"

local LoginScene = class("LoginScene", BaseScene)

function LoginScene:ctor()
    -- 父类方法实现
    if self.super then
        self.super.ctor(self)
    end
    -- 自己方法实现
    self:createScene()

end

function LoginScene:createScene( ... )
    -- get windows size.
    local winSize = cc.Director:getInstance():getVisibleSize()

    -- add background image.
    display.newLayer(cc.c4b(100, 100, 255, 180))
        :addTo(self)

    -- add HelloWorld label.
    cc.Label:createWithSystemFont("Test Scene", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

    -- add content.
    local node = cc.CSLoader:createNode("images/LoginLayer.csb")
        :addTo(self)

    -- add registEventHandler
    local btnTraveler = node:getChildByName("btn_traveler")
    btnTraveler:addTouchEventListener(function(event,type)
            if type == ccui.TouchEventType.began then
                print("began")
            end
            if type == ccui.TouchEventType.ended then
                print("ended")
                self:goToMainScene()
            end
        end)

    local btnWeiXin = node:getChildByName("btn_weixin")

    -- play bg music.
        -- ccexp.AudioEngine:play2d("sounds/bg.mp3", true);
end

function LoginScene:goToMainScene()
    AppBase.new():enterScene("TestScene")
    -- SceneManager:replaceScene("TestScene")
end

function LoginScene:OnBackPressed()
    cc.Director:getInstance():endToLua()
end

return LoginScene
