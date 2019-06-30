-- Define global modifier key of capslock
local hyper = {'shift', 'ctrl', 'alt', 'cmd'}

-- Variables used for keeping track of position of windows
local numSplit = 0
local cornerNum = 1

-- Variables for Chrome Tabs
local appsArray = {
  {'Gmail', 'd', 'browser'},
  {'Calendar', 'c', 'browser'},
  {'Slack', 'a', 'browser'},
  {'Sublime Text', 'q', 'app'},
  {'iTerm', 'w', 'app'},
  {'Google Chrome', 'e', 'app'},
  {'Sequel Pro', 'r', 'app'},
  {'Tower', 't', 'app'},
  {'Spotify', 's', 'app'},
  {'Things3', 'f', 'app'},
  {'Messages', 'm', 'app'},
}
for k,v in pairs(appsArray) do
   hs.hotkey.bind(hyper, v[2], function() focus_a_thing(v, k) end)
end


-- Configuration options
hs.window.animationDuration = 0.1
hs.grid.setMargins(hs.geometry.new(nil, nil, 0, 0))

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
    numSplit = numSplit + 1

    if numSplit == 1 then
      win:moveToUnit(hs.layout.left70)
    elseif numSplit == 2 then
      win:moveToUnit(hs.layout.left50)
    elseif numSplit == 3 then
      win:moveToUnit(hs.layout.left30)
      numSplit = 0;
    end

  elseif _direction == 'right' then
    numSplit = numSplit + 1

    if numSplit == 1 then
      win:moveToUnit(hs.layout.right70)
    elseif numSplit == 2 then
      win:moveToUnit(hs.layout.right50)
    elseif numSplit == 3 then
      win:moveToUnit(hs.layout.right30)
      numSplit = 0
    end
  end
end

-- Change volume
function change_system_volume(direction)
  local curVol = hs.audiodevice.defaultOutputDevice():volume()

  if (direction == 'up') then
    curVol = curVol + 5
    hs.audiodevice.defaultOutputDevice():setVolume(curVol)
  elseif (direction == 'down') then
    curVol = curVol - 5
    hs.audiodevice.defaultOutputDevice():setVolume(curVol)
  end
end

-- Bring specifc applications to focus
function focus_application(_app)
  hs.application.launchOrFocus(_app)
end

function focus_tab(index)
  focus_application('Google Chrome')

  if (index > 8) then
    hs.eventtap.keyStroke('cmd', '8')
    hs.eventtap.keyStroke('ctrl', 'tab')
  else
    hs.eventtap.keyStroke('cmd', tostring(index))
  end
end

-- Open App
function focus_a_thing(value, index)
  if (value[3] == 'browser') then
    focus_tab(index)
  else
    focus_application(value[1])
  end
end

-- Hotkeys to trigger window management actions
hs.hotkey.bind(hyper, 'Left', function() toggle_size('left') end)
hs.hotkey.bind(hyper, 'Right', function() toggle_size('right') end)
hs.hotkey.bind(hyper, 'Down', function() toggle_corner_placement('down') end)
hs.hotkey.bind(hyper, 'Up', function() toggle_corner_placement('up') end)
hs.hotkey.bind(hyper, 'pad1', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind(hyper, 'pad2', function() hs.window.focusedWindow():moveOneScreenEast() end)
hs.hotkey.bind(hyper, 'f', function() hs.grid.maximizeWindow(hs.window.focusedWindow()) end)

-- Hotkeys to trigger Spotify Actions
hs.hotkey.bind(hyper, 'f5', function() hs.spotify.previous() end)
hs.hotkey.bind(hyper, 'f6', function() hs.spotify.playpause() end)
hs.hotkey.bind(hyper, 'f7', function() hs.spotify.next() end)

-- Hotkeys to trigger Volumne Actions (For when not using Mac Keyboard)
hs.hotkey.bind(hyper, '=', function() change_system_volume('up') end)
hs.hotkey.bind(hyper, '-', function() change_system_volume('down') end)

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

configFileWatcher = hs.pathwatcher.new(os.getenv('HOME') .. '/.hammerspoon/', reloadConfig)
configFileWatcher:start()

-- Notify that config is loaded and Hammerspoon is working
hs.notify.show('Hammerspoon', '', 'Config Loaded', '')
