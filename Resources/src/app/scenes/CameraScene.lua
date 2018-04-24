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
-- offset_pos
local s_camera_posto_player = cc.vec3(0, 200, 200)

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

    -- scheduler
    if self.schedulerEntry ~= nil then
        scheduler:unscheduleScriptEntry(self.schedulerEntry)
    end

    self.schedulerEntry = scheduler:scheduleScriptFunc(function(dt)
        self:update(dt)
    end, 0.0, false)

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
    local layerBg = cc.LayerColor:create(cc.c4b(255,255,255,180))
    layerBg:setPosition3D(cc.vec3(0, 0, 0))
    layerBg:setRotation3D(cc.vec3(-75,0,0))
    layerBg:setGlobalZOrder(0)
    layerBg:setCameraMask(2)
    self._layer3D:addChild(layerBg, 0)

    -- Camera
    if self._camera == nil then
        self._camera = cc.Camera:createPerspective(60, winSize.width/winSize.height, 1, 600)
        self._camera:setCameraFlag(cc.CameraFlag.USER1)
        self._camera:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2, 600))
        self._camera:lookAt(cc.vec3(winSize.width/2, winSize.height/2, 0), cc.vec3(0, 1, 1))
        self._camera:setDepth(GAME_LAYER.LAYER_UI)
        self:addChild(self._camera)

        -- local mv = cc.Sequence:create(cc.MoveTo:create(2.0, cc.vec3(winSize.width/2, winSize.height/2, 480)),cc.MoveTo:create(2.0, cc.vec3(winSize.width/2, winSize.height/2, 520)))
        -- self._layer3D._camera:runAction(cc.RepeatForever:create(mv))
    end

    -- light
    if self._light == nil and true then
        
        local light = cc.PointLight:create(cc.vec3(winSize.width/2, winSize.height/2, 500), cc.c3b(255, 255, 255), 1000.0)
        light:setCameraMask(2)
        light:setGlobalZOrder(1)
        self._layer3D:addChild(light)

        self._light = light
        self._light.radius = 400.0
        self._light.angle = 0.0
        self._light.reverseDir = false
    end

    -- Sprite3D
    if self._player3D == nil then
        local fileNameSp = "material/girl.c3b"
        local sprite3D = cc.Sprite3D:create(fileNameSp)
        sprite3D:setScale(0.2)
        sprite3D:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2, 50))
        sprite3D:setCameraMask(2)
        sprite3D:setLightMask(0)
        -- sprite3D:setBlendFunc(cc.blendFunc(gl.ONE, gl.ONE_MINUS_SRC_ALPHA))
        sprite3D:setGlobalZOrder(1)
        self._layer3D:addChild(sprite3D, 1)
        local animation = cc.Animation3D:create(fileNameSp)
        if animation then
            local animate = cc.Animate3D:create(animation)
            sprite3D:runAction(cc.RepeatForever:create(animate))
        end

        -- local rotate_action = cc.RotateBy:create(1.5, cc.vec3(0,30,0))
        local t = 2.0
        local mv1 = cc.MoveTo:create(t, cc.vec3(winSize.width/2+50, winSize.height/2, 0))
        local mv2 = cc.MoveTo:create(t, cc.vec3(winSize.width/2, winSize.height/2+50, 0))
        local mv3 = cc.MoveTo:create(t, cc.vec3(winSize.width/2-50, winSize.height/2, 0))
        local mv4 = cc.MoveTo:create(t, cc.vec3(winSize.width/2, winSize.height/2-50, 0))
        local seq = cc.Sequence:create(mv1, mv2, mv3, mv4)
        -- sprite3D:runAction(cc.RepeatForever:create(seq))

        self._player3D = sprite3D
    end

    if self._ball3D == nil then
        local fileNameSp = "material/ball.c3b"
        local ball3D = cc.Sprite3D:create(fileNameSp)
        -- ball3D:setScale(0.2)
        ball3D:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2 + 130, 0))
        ball3D:setCameraMask(2)
        ball3D:setGlobalZOrder(1)
        self._layer3D:addChild(ball3D)
        local animation = cc.Animation3D:create(fileNameSp)
        if animation then
            local animate = cc.Animate3D:create(animation)
            ball3D:runAction(cc.RepeatForever:create(animate))
        end
        self._ball3D = ball3D
    end

    if self._cicle == nil then
        local sp1 = cc.Sprite:create("scene/circle.png")
        sp1:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2, 0))
        sp1:setRotation3D(cc.vec3(75,0,0))
        sp1:setCameraMask(2)
        self._layer3D:addChild(sp1, 1)

        self._cicle = sp1

        local seq = cc.Sequence:create(cc.ScaleTo:create(2.0, 0.9), cc.ScaleTo:create(2.0, 1.1))
        sp1:runAction(cc.RepeatForever:create(seq))
    end

    local ps = cc.PUParticleSystem3D:create("particles/canOfWorms.pu")
    ps:setPosition3D(cc.vec3(winSize.width/2, winSize.height/2, 0))
    ps:setScale(1, 0.2)
    ps:startParticleSystem()
    self:addChild(ps)

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

function CameraScene:update(dt)
    if self._camera and self._player3D then
        local pos3D = self._player3D:getPosition3D()
        self._cicle:setPosition3D(pos3D)
        self._ball3D:setPosition3D(cc.vec3add(pos3D, cc.vec3(0, 80, 0)))
        self._camera:setPosition3D(cc.vec3add(pos3D, s_camera_posto_player))
        self._camera:lookAt(pos3D, cc.vec3(0, 1, 0))
    end
    -- self:updateLight(dt)
end

function CameraScene:updateLight(dt)
    if self._light and self._player3D then
        local pos3D = self._player3D:getPosition3D()
        local mvPos = cc.vec3(self._light.radius * math.cos(self._light.angle), 100.0, self._light.radius * math.sin(self._light.angle))
        self._light:setPosition3D(cc.vec3add(mvPos, pos3D))
        if self._light.reverseDir == true then
            self._light.angle = self._light.angle - 0.01
            if self._light.angle < 0.0 then
                self._light.reverseDir = false
            end
        else
            self._light.angle = self._light.angle + 0.01
            if 3.14159 < self._light.angle then
                self._light.reverseDir = true
            end
        end
    end
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
