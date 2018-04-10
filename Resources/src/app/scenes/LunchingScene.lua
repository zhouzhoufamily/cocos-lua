local BaseScene = require "app.scenes.BaseScene"

local LunchingScene = class("LunchingScene", BaseScene)

function LunchingScene:ctor()
    -- 父类方法实现
    if self.super then
        self.super.ctor(self)
    end
    -- 自己方法实现
    self:createScene()

end

function LunchingScene:createScene( ... )
    -- get windows size.
    local winSize = cc.Director:getInstance():getVisibleSize()

    -- add background image.
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label.
    cc.Label:createWithSystemFont("Test Scene", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

    -- add close button.
    local btnN = cc.Scale9Sprite:create("CloseNormal.png")
    local btnS = cc.Scale9Sprite:create("CloseSelected.png")
    local controlButton = cc.ControlButton:create(btnN)
    local menuSize = controlButton:getContentSize()
    controlButton:setBackgroundSpriteForState(btnS, cc.CONTROL_STATE_HIGH_LIGHTED)
    controlButton:setPosition(winSize.width - menuSize.width - 5, winSize.height - menuSize.height - 5)
    self:addChild(controlButton)
    controlButton:registerControlEventHandler(self.TouchDownAction, cc.CONTROL_EVENTTYPE_TOUCH_DOWN)

    -- play bg music.
        -- ccexp.AudioEngine:play2d("sounds/bg.mp3", true);
end

function LunchingScene:TouchDownAction()  
    cc.Director:getInstance():endToLua()
end  

-- override me for onEnter()
-- function LunchingScene:onEnter()
--     print("==> LunchingScene:onEnter")
-- end

-- override me for onExit()
-- function LunchingScene:onExit()
--     print("==> LunchingScene:onExit")
-- end

-- override me for onEnterTransitionFinish()
-- function LunchingScene:onEnterTransitionFinish()
--     print("==> LunchingScene:onEnterTransitionFinish")
-- end

-- override me for onExitTransitionStart()
-- function LunchingScene:onExitTransitionStart()
--     print("==> LunchingScene:onExitTransitionStart")
-- end

-- override me for onCleanup()
-- function LunchingScene:onCleanup()
--     print("==> LunchingScene:onCleanup")
-- end

return LunchingScene
