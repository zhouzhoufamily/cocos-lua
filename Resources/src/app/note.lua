-- 1.
-- pc上读取访问冲突，关闭时报错
-- ccexp.AudioEngine:play2d("sounds/bg.mp3", true);

-- 模块化
local moduleName = ...

local M = {}
_G[moduleName] = M

package.loaded[moduleName] = M

setfenv(1, M)

-- 就实现了一个继承过程
require "Object"

GameObject = class("GameObject",function ()
    return Object:new()
end)

function GameObject:create()
    return GameObject.new()
end

-- Circle 是 Shape 的继承类  
local Circle = class("Circle", Shape)  
