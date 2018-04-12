module(..., package.seeall)  
local AppBase = require "app.base.AppBase"
local BaseScene = require "app.scenes.BaseScene"

local ChatScene = class("ChatScene", BaseScene)

-- define global module
local pomelo = require("pomelo.Pomelo").new()

function ChatScene:ctor()
    -- 父类方法实现
    if self.super then
        self.super.ctor(self)
    end
    -- 自己方法实现
    self:createScene()

end

function ChatScene:createScene()
    -- self.username = "user"..math.random(1,10000)
    -- self.rid = "rid"..math.random(1,1000)
    self.username = "Levi"
    self.rid = "111"
    printInfo("self.username=%s",self.username)
    printInfo("self.rid=%s",self.rid)
  
  self:initView()
  self:initNet()
end

function ChatScene:initView()
    local winSize = cc.Director:getInstance():getWinSize()

    local ttfConfig = {}
    ttfConfig.fontFilePath = "fonts/arial.ttf"
    ttfConfig.fontSize = 32

    local loginLabel = cc.Label:createWithTTF(ttfConfig,"login")
    local loginMenuItem = cc.MenuItemLabel:create(loginLabel)
    loginMenuItem:registerScriptTapHandler(function (tag, sender )
        self:onLoginClick()
    end)

    local sendLabel = cc.Label:createWithTTF(ttfConfig,"send")
    local sendMenuItem = cc.MenuItemLabel:create(sendLabel)
    sendMenuItem:registerScriptTapHandler(function (tag, sender )
        self:onSendMsgClick()
    end)

    local menu = cc.Menu:create(loginMenuItem,sendMenuItem)
    menu:setPosition(cc.p(0, 0))
    loginMenuItem:setPosition( cc.p( winSize.width / 2, winSize.height / 2 + 50) )
    sendMenuItem:setPosition( cc.p( winSize.width / 2, winSize.height / 2 - 50) )
    self:addChild(menu, 0)
end

function ChatScene:initNet()
    pomelo:on("onChat",handler(self,self.onChat))
    pomelo:on("onAdd",handler(self,self.onAdd))
    pomelo:on("onLeave",handler(self,self.onLeave))
end

function ChatScene:onChat(data)
    printInfo("onChat")
    printInfo("%s receive message from:%s,content:%s",data.from,data.target,data.msg)
end

function ChatScene:onAdd(data)
    printInfo("onAdd")
    printInfo("user-%s login!",json.encode(data.user))
end

function ChatScene:onLeave(data)
    printInfo("onLeave")
    printInfo("user-%s leave!",json.encode(data.user))
end

function ChatScene:onLoginClick()
    self:queryEntry(function(host,port)
        pomelo:init({host=host,port=port},
            function()
                local route = "connector.entryHandler.enter"
                pomelo:request(route,{username=self.username,rid=self.rid},
                    function(data)
                        if data.error then
                            printInfo("login fail! error=%s",data.error)
                        else
                            printInfo("login success!")
                            printInfo("ddfd data=%s",json.encode(data))
                            pomelo:on("onChat",handler(self,self.onChat))  
                            pomelo:on("onAdd",handler(self,self.onAdd))  
                            pomelo:on("onLeave",handler(self,self.onLeave)) 
                        end
                    end
                )
            end)
    end)
end

function ChatScene:onSendMsgClick()
    local route = 'chat.chatHandler.send'
    pomelo:request(route,{rid=self.rid,content="hello!",from=self.username,target="*"},
        function(data)
        end
    )
end

-- query connector
function ChatScene:queryEntry(cb) 
    pomelo:init({host="127.0.0.1",port="3014"},--自己架设服务器，参考pomelo官方文档的chatofpomelo示例
        function()
            local route = 'gate.gateHandler.queryEntry'
            pomelo:request(route,{uid=self.username},
                function(data) 
                    pomelo:disconnect()
                    printInfo("123 data=%s",json.encode(data))
                    if data.error then
                        return
                    end
                    cb(data.host,data.port)
                end)
        end
    )
end

function ChatScene:onEnter()

end

return ChatScene