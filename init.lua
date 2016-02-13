numLeft = 0;
numRight = 0;
cornerNum = 1;

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Left", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    numRight = 0;
    
    if numLeft < 3 then
        numLeft = numLeft + 1
            
        if numLeft == 1 then
            f.w = (2 * max.w) / 3
        elseif numLeft == 2 then
            f.w = max.w / 2
        elseif numLeft == 3 then
            f.w = max.w / 3
        end
                    
        f.x = max.x
        f.y = max.y
        f.h = max.h
        win:setFrame(f)
    end
        
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Right", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    numLeft = 0;
    
    if numRight < 3 then
        numRight = numRight + 1
            
        if numRight == 1 then
            f.w = (2 * max.w) / 3
            f.x = max.x + (max.w / 3)
        elseif numRight == 2 then
            f.w = max.w / 2
            f.x = max.x + (max.w / 2)
        elseif numRight == 3 then
            f.w = max.w / 3
            f.x = max.x + (2 * max.w / 3)
        end
                    
        f.y = max.y
        f.h = max.h
        win:setFrame(f)
    end
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "F", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y
    f.w = max.w
    f.h = max.h
    win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Down", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y

    if cornerNum <= 4 and cornerNum >= 1 then

        if cornerNum > 1 then
            cornerNum = cornerNum - 1 
        end
        
        if cornerNum == 2 then
            f.x = max.x + (max.w / 2)
        elseif cornerNum == 3 then
            f.y = max.y + (max.h / 2)
        elseif cornerNum == 4 then
            f.x = max.x + (max.w / 2)
            f.y = max.y + (max.h / 2)
        end

    end

    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)

hs.hotkey.bind({"cmd", "alt", "ctrl"}, "Up", function()
    local win = hs.window.focusedWindow()
    local f = win:frame()
    local screen = win:screen()
    local max = screen:frame()

    f.x = max.x
    f.y = max.y

    if cornerNum <= 4 and cornerNum >= 1 then
        
        if cornerNum < 4 then
            cornerNum = cornerNum + 1 
        end

        if cornerNum == 2 then
            f.x = max.x + (max.w / 2)
        elseif cornerNum == 3 then
            f.y = max.y + (max.h / 2)
        elseif cornerNum == 4 then
            f.x = max.x + (max.w / 2)
            f.y = max.y + (max.h / 2)
        end

    end

    f.w = max.w / 2
    f.h = max.h / 2
    win:setFrame(f)
end)
