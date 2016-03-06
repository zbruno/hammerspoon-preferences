-- Define global modifier key of capslock
local hyper = {'shift', 'ctrl', 'alt', 'cmd'}

local numLeft = 0
local numRight = 0
local cornerNum = 1

hs.window.animationDuration = 0.1

hs.hotkey.bind(hyper, 'space', function()
    local isFocused = hs.appfinder.appFromName('Google Chrome')
    local isRFocused = isFocused:isFrontmost()
 
    local log = hs.logger.new('mymodule','debug')
    print(hs.screen.mainScreen())
    for i=10,1,-1 do print(i) end
end)

hs.eventtap.new({otherMouseUp}, function()
    local log = hs.logger.new('mymodule','debug')
    log.i('lol')
end)

-- Toggle fullscreen of focused window
function toggle_fullscreen()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end

-- Toggle corner placement of focused window
function toggle_corner_placement(_direction)
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    local positions = {
      {},
      {w = max.w/3},
      {x = max.x + (max.w/2)},
      {w = max.w/3, x = max.x + (2*max.w/3)},
      {y = max.y + (max.h/2)},
      {w = max.w/3, y = max.y + (max.h/2)},
      {x = max.x + (max.w/2), y = max.y + (max.h/2)},
      {w = max.w/3, x = max.x + (2*max.w/3), y = max.y + (max.h/2)}
    }

    if (_direction == 'down') then
      if (cornerNum == 1) then
        cornerNum = 2
      end
      cornerNum = cornerNum - 1
    else
      if (cornerNum == 8) then
        cornerNum = 7
      end
      cornerNum = cornerNum + 1
    end

    f.x = positions[cornerNum].x or max.x
    f.y = positions[cornerNum].y or max.y
    f.w = positions[cornerNum].w or max.w/2
    f.h = positions[cornerNum].h or max.h/2

    win:setFrame(f)
end

-- Change size of active window
function toggle_size(_direction)
    local win = hs.window.focusedWindow()

    if _direction == 'left' then
        numRight = 0
        numLeft = numLeft + 1

        if numLeft == 1 then
            win:moveToUnit(hs.layout.left70)
        elseif numLeft == 2 then
            win:moveToUnit(hs.layout.left50)
        elseif numLeft == 3 then
            win:moveToUnit(hs.layout.left30)
            numLeft = 0;
        end

    elseif _direction == 'right' then
        numLeft = 0
        numRight = numRight + 1

        if numRight == 1 then
            win:moveToUnit(hs.layout.right70)
        elseif numRight == 2 then
            win:moveToUnit(hs.layout.right50)
        elseif numRight == 3 then
            win:moveToUnit(hs.layout.right30)
            numRight = 0
        end
    end
end

-- Bring specifc applications to focus
function toggle_application(_app)
    hs.application.launchOrFocus(_app)
end

-- Set up work environment
function set_up_work_environment()
    toggle_application('Sublime Text')
    toggle_application('iTerm')
    toggle_application('Google Chrome')
end



hs.hotkey.bind(hyper, 'Left', function() toggle_size('left') end)
hs.hotkey.bind(hyper, 'Right', function() toggle_size('right') end)

hs.hotkey.bind(hyper, 'Down', function() toggle_corner_placement('down') end)
hs.hotkey.bind(hyper, 'Up', function() toggle_corner_placement('up') end)

hs.hotkey.bind(hyper, 'pad1', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind(hyper, 'pad2', function() hs.window.focusedWindow():moveOneScreenEast() end)

hs.hotkey.bind(hyper, 'f', function() toggle_fullscreen() end)

hs.hotkey.bind(hyper, 'q', function() toggle_application('Sublime Text') end)
hs.hotkey.bind(hyper, 'w', function() toggle_application('iTerm') end)
hs.hotkey.bind(hyper, 'e', function() toggle_application('Google Chrome') end)
hs.hotkey.bind(hyper, 'r', function() toggle_application('Sequel Pro') end)
hs.hotkey.bind(hyper, 't', function() toggle_application('Tower') end)

hs.hotkey.bind(hyper, 'f5', function() hs.spotify.previous() end)
hs.hotkey.bind(hyper, 'f6', function() hs.spotify.playpause() end)
hs.hotkey.bind(hyper, 'f7', function() hs.spotify.next() end)

-- function navigateBrowserWithMouseButtons()
--     local chrome = hs.appfinder.appFromName('Chrome')
--     if not chrome then
--         return
--     end

--     local lastapp = nil
--     if not skype:isFrontmost() then
--         lastapp = hs.application.frontmostApplication()
--         skype:activate()
--     end

--     if not skype:selectMenuItem({'Conversations', 'Mute Microphone'}) then
--         skype:selectMenuItem({'Conversations', 'Unmute Microphone'})
--     end

--     if lastapp then
--         lastapp:activate()
--     end
-- end

-- hs.eventtap.event.newMouseEvent(otherMouseUp)


-- Reload config on change
function reloadConfig(paths)
    doReload = false
    for _,file in pairs(paths) do
        if file:sub(-4) == '.lua' then
            print('reloading hammerspoon config')
            doReload = true
            hs.reload()
        end 
    end
end

configFileWatcher = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig)
configFileWatcher:start()

-- Notify that config is loaded and Hammerspoon is working
hs.notify.show('Hammerspoon', '', 'Config Loaded', '')