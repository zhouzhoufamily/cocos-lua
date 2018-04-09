local LoadingScene = class("LoadingScene", function()
    return display.newScene("LoadingScene")
end)

function LoadingScene:ctor()
    -- add background image
    display.newSprite("HelloWorld.png")
        :move(display.center)
        :addTo(self)

    -- add HelloWorld label
    cc.Label:createWithSystemFont("Test Scene", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)

    cc.Button:create
        -- ccexp.AudioEngine:play2d("sounds/bg.mp3", true);
end

function LoadingScene:onEnter()
end

function LoadingScene:onExit()
end

return LoadingScene
