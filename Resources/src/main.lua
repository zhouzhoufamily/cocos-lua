
cc.FileUtils:getInstance():setPopupNotify(false)

require "config"
require "cocos.init"
require "app.common.Content"
require "app.control.SceneManager"

local function main()
    require("app.MyApp").new():run()
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
