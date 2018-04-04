
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("hi boy", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

        ccexp.AudioEngine:play2d("sounds/bg.mp3", true);

end

return MainScene
