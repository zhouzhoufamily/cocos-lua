local TestScene = class("TestScene", function()
    return display.newScene("TestScene")
end)

function TestScene:ctor()

    local winSize = cc.Director:getInstance():getVisibleSize()

    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Test Scene", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

        -- "CloseNormal.png","CloseSelected.png"
    cc.ControlButton:create()
        :setTitleForState("Load Data", 1)
        :move(winSize.width / 2, winSize.height / 2)
        -- :addTargetWithActionForControlEvents(function(sender)
        --     cclog("click...")
        -- end)
        :addTo(self)

        -- ccexp.AudioEngine:play2d("sounds/bg.mp3", true);
end

function TestScene:onEnter()
end

function TestScene:onExit()
end

return TestScene
