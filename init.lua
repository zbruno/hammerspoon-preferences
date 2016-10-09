-- Define global modifier key of capslock
local hyper = {'shift', 'ctrl', 'alt', 'cmd'}

-- START HACKS TO FIX MAC OS SIERRA STUFF
  -- A global variable for the sub-key Hyper Mode
  k = hs.hotkey.modal.new({}, 'F17')

  -- Redeclare all hotkey that I use
  hyperBindings = {
    'Left', 'Right', 'Down', 'Up',
    'pad1', 'pad2',
    'f', '9', '0',
    'q', 'w', 'e', 'r', 't',
    'a', 's', 'd',
    'u', 'i',
    'm', 'z',
    'f5', 'f6', 'f7',
    '=', '-'
  }

  -- For each hotkey, trigger hyper plus key events
  for i,key in ipairs(hyperBindings) do
    k:bind({}, key, nil, function() hs.eventtap.keyStroke(hyper, key)
      k.triggered = true
    end)
  end

  -- Enter Hyper Mode when F19 (left control) is pressed
  pressedF18 = function()
    k.triggered = false
    k:enter()
  end

  -- Leave Hyper Mode when F18 (left control) is pressed,
  --   send ESCAPE if no other keys are pressed.
  releasedF18 = function()
    k:exit()
    if not k.triggered then
      hs.eventtap.keyStroke({}, 'ESCAPE')
    end
  end

  -- Bind the Hyper key
  f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
-- END HACKS TO FIX MAC OS SIERRA STUFF

-- Variables used for keeping track of position of windows
local numSplit = 0
local cornerNum = 1

-- Configuration options
hs.window.animationDuration = 0.1
hs.grid.setMargins(hs.geometry.new(nil, nil, 0, 0))

local screens = {
  primary = hs.screen.primaryScreen(),
  secondary = hs.screen.primaryScreen():previous()
}

local display_preferences = {
  {'Sublime Text', nil, screens.secondary, hs.layout.left70, nil, nil},
  {'iTerm', nil, screens.secondary, hs.layout.right30, nil, nil},
  {'Google Chrome', nil, screens.primary, hs.layout.maximized, nil, nil}
}

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

-- Set up work environment
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

-- Hotkeys to trigger window management actions
hs.hotkey.bind(hyper, 'Left', function() toggle_size('left') end)
hs.hotkey.bind(hyper, 'Right', function() toggle_size('right') end)
hs.hotkey.bind(hyper, 'Down', function() toggle_corner_placement('down') end)
hs.hotkey.bind(hyper, 'Up', function() toggle_corner_placement('up') end)
hs.hotkey.bind(hyper, 'pad1', function() hs.window.focusedWindow():moveOneScreenWest() end)
hs.hotkey.bind(hyper, 'pad2', function() hs.window.focusedWindow():moveOneScreenEast() end)
hs.hotkey.bind(hyper, 'f', function() hs.grid.maximizeWindow(hs.window.focusedWindow()) end)

-- Open all work apps
hs.hotkey.bind(hyper, '9', function() set_up_work_environment() end)

-- Hotkeys to trigger defined layouts
hs.hotkey.bind(hyper, '0', function() hs.layout.apply(display_preferences) end)

-- Hotkeys to trigger open and/or focus applications
hs.hotkey.bind(hyper, 'q', function() toggle_application('Sublime Text') end)
hs.hotkey.bind(hyper, 'w', function() toggle_application('iTerm') end)
hs.hotkey.bind(hyper, 'e', function() toggle_application('Google Chrome') end)
hs.hotkey.bind(hyper, 'r', function() toggle_application('Sequel Pro') end)
hs.hotkey.bind(hyper, 't', function() toggle_application('Tower') end)
hs.hotkey.bind(hyper, 'a', function() toggle_application('Slack') end)
hs.hotkey.bind(hyper, 's', function() toggle_application('Spotify') end)
hs.hotkey.bind(hyper, 'd', function() toggle_application('1Password') end)
hs.hotkey.bind(hyper, 'u', function() toggle_application('Unity') end)
hs.hotkey.bind(hyper, 'i', function() toggle_application('MonoDevelop') end)
hs.hotkey.bind(hyper, 'm', function() toggle_application('Messages') end)
hs.hotkey.bind(hyper, 'z', function() toggle_application('Sketch') end)

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