local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

function MainScene:ctor()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("hi boy", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

        -- ccexp.AudioEngine:play2d("sounds/bg.mp3", true);

end

function MainScene:onEnter()
end

function MainScene:onExit()
end

return MainScene
