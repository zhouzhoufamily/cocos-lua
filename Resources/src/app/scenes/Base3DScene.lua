require "cocos.3d.3dConstants"
local BaseScene = require "app.scenes.BaseScene"

local Base3DScene = class("Base3DScene", BaseScene)

-- config
local winSize = cc.Director:getInstance():getVisibleSize()

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

local s_CF  = 
{
    cc.CameraFlag.DEFAULT,
    cc.CameraFlag.USER1,
    cc.CameraFlag.USER2,
    cc.CameraFlag.USER3,
    cc.CameraFlag.USER4,
    cc.CameraFlag.USER5,
}

local s_CM =
{
    s_CF[1],
    s_CF[2],
    s_CF[3],
    s_CF[4],
    s_CF[5],
    s_CF[6],
}


----------------------------------------
----TerrainWalkThru
----------------------------------------

local PLAER_STATE =
{
    LEFT     = 0,
    RIGHT    = 1,
    IDLE     = 2,
    FORWARD  = 3, 
    BACKWARD = 4,
}

local PLAYER_HEIGHT = 0
local camera_offset = cc.vec3(0, 45, 60)

function Base3DScene:ctor()
    -- 父类方法实现
    if self.super then
        self.super.ctor(self)
    end
    -- 自己方法实现
    self:createScene()

end

function Base3DScene:createScene( ... )
    -- get windows size.
    

    -- world
    self:create3DWorld()
    -- ui
    self:createUI()

    -- play bg music.
        -- ccexp.AudioEngine:play2d("sounds/bg.mp3", true);
end

-- create 3D world
function Base3DScene:create3DWorld()  
    -- camera
    self._camera = cc.Camera:createPerspective(60, winSize.width/winSize.height, 0.1, 200)
    self._camera:setCameraFlag(cc.CameraFlag.USER1)
    self:addChild(self._camera)

    -- skybox
    --create and set our custom shader
    local shader = cc.GLProgram:createWithFilenames("cube/cube_map.vert", "cube/cube_map.frag")
    local state  = cc.GLProgramState:create(shader)

    --create the second texture for cylinder
    self._textureCube = cc.TextureCube:create("skybox/left.jpg", "skybox/right.jpg",
                                       "skybox/top.jpg", "skybox/bottom.jpg",
                                       "skybox/front.jpg", "skybox/back.jpg")

    --set texture parameters
    local tRepeatParams = { magFilter = gl.LINEAR , minFilter = gl.LINEAR , wrapS = gl.MIRRORED_REPEAT  , wrapT = gl.MIRRORED_REPEAT }
    self._textureCube:setTexParameters(tRepeatParams)

    --pass the texture sampler to our custom shader
    state:setUniformTexture("u_cubeTex", self._textureCube)

    self._skyBox = cc.Skybox:create()
    self._skyBox:setCameraMask(s_CM[GAME_LAYER.LAYER_SKYBOX])
    self._skyBox:setTexture(self._textureCube)
    self:addChild(self._skyBox)

    -- terrain
    local detailMapR = { _detailMapSrc = "terrain/dirt.jpg", _detailMapSize = 35}
    local detailMapG = { _detailMapSrc = "terrain/Grass2.jpg", _detailMapSize = 10}
    local detailMapB = { _detailMapSrc = "terrain/road.jpg", _detailMapSize = 35}
    local detailMapA = { _detailMapSrc = "terrain/GreenSkin.jpg", _detailMapSize = 20}
    local terrainData = { _heightMapSrc = "terrain/heightmap16.jpg", _alphaMapSrc = "terrain/alphamap.png" , _detailMaps = {detailMapR, detailMapG, detailMapB, detailMapA}, _detailMapAmount = 4, _mapHeight = 40.0, _mapScale = 2.0 }

    self._terrain = cc.Terrain:create(terrainData,cc.Terrain.CrackFixedType.SKIRT)
    self._terrain:setMaxDetailMapAmount(4)
    self._terrain:setCameraMask(2)
    self._terrain:setDrawWire(false)

    self._terrain:setSkirtHeightRatio(3)
    self._terrain:setLODDistance(64,128,192)

    -- player
    -- self._player = Player:create("material/girl.c3b", self._camera, self._terrain)
    self._player = cc.Sprite3D:create("material/girl.c3b")
    self._player:setCameraMask(2)
    self._player:setScale(0.08)
    self._player:setPositionY(self._terrain:getHeight(self._player:getPositionX(), self._player:getPositionZ()) + PLAYER_HEIGHT)

    -- Sprite3D
    local bgSize = cc.size(110, 180)
    local margin = 10
    local girl = cc.Sprite3D:create("material/girl.c3b")
    girl:setScale(0.5)
    girl:setPosition(bgSize.width / 2, margin * 2)
    girl:setCameraMask(s_CM[GAME_LAYER.LAYER_ACTOR])
    self:addChild(girl)

    -- particle

end

-- create 3D ui
function Base3DScene:createUI()  
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

function Base3DScene:TouchDownAction()  
    cc.Director:getInstance():endToLua()
end

-- override me for onEnter()
-- function Base3DScene:onEnter()
--     print("==> Base3DScene:onEnter")
-- end

-- override me for onExit()
-- function Base3DScene:onExit()
--     print("==> Base3DScene:onExit")
-- end

-- override me for onEnterTransitionFinish()
-- function Base3DScene:onEnterTransitionFinish()
--     print("==> Base3DScene:onEnterTransitionFinish")
-- end

-- override me for onExitTransitionStart()
-- function Base3DScene:onExitTransitionStart()
--     print("==> Base3DScene:onExitTransitionStart")
-- end

-- override me for onCleanup()
-- function Base3DScene:onCleanup()
--     print("==> Base3DScene:onCleanup")
-- end

return Base3DScene
