-- 1.
-- pc上读取访问冲突，关闭时报错
-- ccexp.AudioEngine:play2d("sounds/bg.mp3", true);

-- 模块化
local moduleName = ...

local M = {}
_G[moduleName] = M

package.loaded[moduleName] = M

setfenv(1, M)