local BaseScene = class("BaseScene", function()
    return display.newScene("BaseScene")
end)

function BaseScene:ctor()
    self:addKeyboardEvent()
end

function BaseScene:addKeyboardEvent()  
    print("==> BaseScene:addKeyboardEvent")
    --回调方法
    local function onrelease(code, event)
        if code == cc.KeyCode.KEY_BACK then
            self:OnBackPressed()
        elseif code == cc.KeyCode.KEY_HOME then
            self:OnHomePressed()
            cc.Director:getInstance():endToLua()
        end
    end

    --监听手机返回键
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onrelease, cc.Handler.EVENT_KEYBOARD_RELEASED)

    --lua中得回调，分清谁绑定，监听谁，事件类型是什么
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end  

function BaseScene:OnBackPressed()
    print("==> BaseScene:OnBackPressed")
end

function BaseScene:OnHomePressed()
    print("==> BaseScene:OnHomePressed")
end

function BaseScene:onEnter()
    print("==> BaseScene:onEnter")
end

function BaseScene:onExit()
    print("==> BaseScene:onExit")
end

function BaseScene:onEnterTransitionFinish()
    print("==> BaseScene:onEnterTransitionFinish")
end

function BaseScene:onExitTransitionStart()
    print("==> BaseScene:onExitTransitionStart")
end

function BaseScene:onCleanup()
    print("==> BaseScene:onCleanup")
end

return BaseScene