local BaseScene = require "app.scenes.BaseScene"

local CameraScene = class("CameraScene", BaseScene)

-- config
local GAME_LAYER = 
{
    LAYER_SKYBOX = 1,
    LAYER_GAME   = 2,
    LAYER_UI     = 3,
    LAYER_ACTOR  = 4,
    LAYER_ZOOM   = 5,
    LAYER_OSD    = 6,
    LAYER_COUNT  = 7,
}

local State = 
{
    None = 0,
    Idle = 0x01,
    Move = 0x02,
    Rotate = 0x04,
    Speak = 0x08,
    MeleeAttack = 0x10,
    RemoteAttack = 0x20,
    Attack = 0x40,
}

local CameraType = 
{
    FreeCamera = 0,
    FirstCamera = 1,
    ThirdCamera = 2,
}
-- get windows size.
local winSize = cc.Director:getInstance():getVisibleSize()
-- scheduler
local scheduler = cc.Director:getInstance():getScheduler()

function CameraScene:ctor()
    -- 父类方法实现
    if self.super then
        self.super.ctor(self)
    end
    -- 自己方法实现
    self:createScene()

end

function CameraScene:createScene( ... )

    -- world
    self:create3DWorld()
    -- ui
    self:createUI()

    -- play bg music.
        -- ccexp.AudioEngine:play2d("sounds/bg.mp3", true);
end

function CameraScene:create3DWorld()

    -- Layer3D
    if self._layer3D == nil then
        self._layer3D = cc.Layer:create()
        self:addChild(self._layer3D,1)
    end

    -- add background image
    local fileNameBg = "images/bg/bg2.png"
    local layerBg = cc.Sprite:create(fileNameBg)
    layerBg:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2, 0))
    -- self._layer3D:addChild(layerBg, 0)
    -- layerBg:setCameraMask(2)

    -- Camera
    if self._layer3D._camera == nil then
        self._layer3D._camera = cc.Camera:createPerspective(60, winSize.width/winSize.height, 1, 1000)
        self._layer3D._camera:setCameraFlag(cc.CameraFlag.USER1)
        self._layer3D._camera:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2, 600))
        -- self._layer3D._camera:lookAt(cc.vec3(winSize.width/2, winSize.height/2, 0), cc.vec3(0, 1, 0))
        self._layer3D._camera:setDepth(GAME_LAYER.LAYER_UI)
        self._layer3D:addChild(self._layer3D._camera)
    end

    -- Sprite3D
    if self._sprite3D == nil then
        local fileNameSp = "material/girl.c3b"
        local sprite3D = cc.Sprite3D:create(fileNameSp)
        sprite3D:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2, 100))
        -- sprite3D:setRotation3D(cc.vec3(0,180,0))
        self._layer3D:addChild(sprite3D)
        local animation = cc.Animation3D:create(fileNameSp)
        if animation then
            local animate = cc.Animate3D:create(animation)
            sprite3D:runAction(cc.RepeatForever:create(animate))
        end

        local rotate_action = cc.RotateBy:create(1.5, cc.vec3(0,30,0))
        sprite3D:runAction(cc.RepeatForever:create(rotate_action))

        self._sprite3D = sprite3D
        self._sprite3D:setCameraMask(2)
    end

    local sp1 = cc.Sprite:create("scene/circle.png")
    sp1:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2, 0))
    sp1:setScale(1, 0.2)
    self._layer3D:addChild(sp1)

    local ps = cc.PUParticleSystem3D:create("particles/canOfWorms.pu")
    ps:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2, 0))
    ps:setScale(0.05)
    ps:startParticleSystem()
    ps:setCameraMask(2)
    self:addChild(ps)
    
    -- self:setCameraMask(2)

end

function CameraScene:createUI()  
    -- add close button.
    local btnN = cc.Scale9Sprite:create("CloseNormal.png")
    local btnS = cc.Scale9Sprite:create("CloseSelected.png")
    local controlButton = cc.ControlButton:create(btnN)
    local menuSize = controlButton:getContentSize()
    controlButton:setBackgroundSpriteForState(btnS, cc.CONTROL_STATE_HIGH_LIGHTED)
    controlButton:setPosition(winSize.width - menuSize.width - 5, winSize.height - menuSize.height - 5)
    self:addChild(controlButton)
    controlButton:registerControlEventHandler(self.TouchDownAction, cc.CONTROL_EVENTTYPE_TOUCH_DOWN)
end

function CameraScene:TouchDownAction()  
    cc.Director:getInstance():endToLua()
end

-- override me for onEnter()
-- function CameraScene:onEnter()
--     print("==> CameraScene:onEnter")
-- end

-- override me for onExit()
-- function CameraScene:onExit()
--     print("==> CameraScene:onExit")
-- end

-- override me for onEnterTransitionFinish()
-- function CameraScene:onEnterTransitionFinish()
--     print("==> CameraScene:onEnterTransitionFinish")
-- end

-- override me for onExitTransitionStart()
-- function CameraScene:onExitTransitionStart()
--     print("==> CameraScene:onExitTransitionStart")
-- end

-- override me for onCleanup()
-- function CameraScene:onCleanup()
--     print("==> CameraScene:onCleanup")
-- end

return CameraScene
