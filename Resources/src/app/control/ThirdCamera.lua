local ThirdCamera = class("ThirdCamera", cc.Node)

function ThirdCamera:ctor()
    -- 父类方法实现
    if self.super then
        self.super.ctor(self)
    end
    -- 自己方法实现
    self:createScene()

end

function ThirdCamera:createScene( ... )

end

-- override me for onEnter()
-- function ThirdCamera:onEnter()
--     print("==> ThirdCamera:onEnter")
-- end

-- override me for onExit()
-- function ThirdCamera:onExit()
--     print("==> ThirdCamera:onExit")
-- end

-- override me for onEnterTransitionFinish()
-- function ThirdCamera:onEnterTransitionFinish()
--     print("==> ThirdCamera:onEnterTransitionFinish")
-- end

-- override me for onExitTransitionStart()
-- function ThirdCamera:onExitTransitionStart()
--     print("==> ThirdCamera:onExitTransitionStart")
-- end

-- override me for onCleanup()
-- function ThirdCamera:onCleanup()
--     print("==> ThirdCamera:onCleanup")
-- end

return ThirdCamera
