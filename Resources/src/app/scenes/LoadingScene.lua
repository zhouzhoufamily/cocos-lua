local BaseScene = require "app.scenes.BaseScene"

local LoadingScene = class("LoadingScene", BaseScene)

function LoadingScene:ctor()
    -- 父类方法实现
    if self.super then
        self.super.ctor(self)
    end
    -- 自己方法实现
    self:createScene()

end

function LoadingScene:createScene( ... )
    -- add background image
    display.newLayer(cc.c4b(87, 250, 255, 180))
        :addTo(self)

    -- add animation
    ccs.ArmatureDataManager:getInstance():addArmatureFileInfo("animation/loading/loading0.png", "animation/loading/loading0.plist", "animation/loading/loading.ExportJson");
    local armature = ccs.Armature:create("loading")
    armature:setPosition(display.center)
    self:addChild(armature)
    armature:getAnimation():playWithIndex(0)
    armature:getAnimation():setSpeedScale(0.5)
end

function LoadingScene:onEnter()
    print("==> LoadingScene:onEnter")
end

function LoadingScene:onExit()
    print("==> LoadingScene:onExit")
end

function LoadingScene:onEnterTransitionFinish()
end

function LoadingScene:onExitTransitionStart()
end

function LoadingScene:onCleanup()
end

return LoadingScene
