-- File: /SCRIPTS/TOOLS/fk_ui.lua

local config_file = "/SCRIPTS/RGBLED/fk_cfg.lua"

local config = {
    sw_src = 0, is_editing = false,
    p = {
        {anim=0, speed=8, trail=3, r_trail=0, c1=1, c2=0},
        {anim=1, speed=8, trail=3, r_trail=0, c1=2, c2=0},
        {anim=2, speed=8, trail=3, r_trail=0, c1=3, c2=0}
    }
}

local color_names = { [0]="Black (Off)", [1]="Red", [2]="Green", [3]="Blue", [4]="Yellow", [5]="Cyan", [6]="Magenta", [7]="White", [8]="Orange" }
local colors_rgb = { [0]={0,0,0}, [1]={255,0,0}, [2]={0,255,0}, [3]={0,0,255}, [4]={255,255,0}, [5]={0,255,255}, [6]={255,0,255}, [7]={255,255,255}, [8]={255,128,0} }
local anim_names = { [0]="Wipe Up", [1]="Infinity", [2]="Wipe Down", [3]="Wipe Left", [4]="Wipe Right", [5]="Wipe Center", [6]="Alternating", [7]="Infinity Wipe", [8]="Solid", [9]="Breath", [10]="Rainbow" }
local sw_names = {[0]="None (Always UP)", [1]="SA", [2]="SB", [3]="SC", [4]="SD", [5]="SE", [6]="SF", [7]="SG", [8]="SH"}
local sw_raw_names = {"sa", "sb", "sc", "sd", "se", "sf", "sg", "sh"}

-- KOORDINAT ANIMASI (Wipe Center sudah diperbaiki)
local wipe_up_stages     = {{7,8,17,18}, {6,9,16,19}, {0,5,10,15}, {1,4,11,14}, {2,3,12,13}}
local wipe_down_stages   = {{2,3,12,13}, {1,4,11,14}, {0,5,10,15}, {6,9,16,19}, {7,8,17,18}}
local snake_stages       = {{7,8}, {6,9}, {0,5}, {1,4}, {2,3}, {12,13}, {11,14}, {10,15}, {16,19}, {17,18}}
local wipe_left_stages   = {{5}, {4,6}, {3,7}, {2,8}, {1,9}, {0}, {10}, {11,19}, {12,18}, {13,17}, {14,16}, {15}}
local wipe_right_stages  = {{15}, {14,16}, {13,17}, {12,18}, {11,19}, {10}, {0}, {1,9}, {2,8}, {3,7}, {4,6}, {5}}
local wipe_center_stages = {{5,15}, {4,6,14,16}, {3,7,13,17}, {2,8,12,18}, {1,9,11,19}, {0,10}}
local infinity_path      = {0,1,2,3,4,5,6,7,8,9, 10,11,12,13,14,15,16,17,18,19}

local PAGE_MAIN = 0; local PAGE_EDIT = 1
local current_page = PAGE_MAIN; local active_profile = 1
local selected = 1; local editing = false

local function loadConfig()
    local chunk = loadfile(config_file)
    if chunk then
        local loaded = chunk()
        if loaded then
            config.sw_src = loaded.sw_src or 0
            if loaded.p1 then config.p[1] = loaded.p1 end
            if loaded.p2 then config.p[2] = loaded.p2 end
            if loaded.p3 then config.p[3] = loaded.p3 end
        end
    end
end

local function saveConfig()
    local f = io.open(config_file, "w")
    if f ~= nil then
        io.write(f, "return {\n")
        io.write(f, "  sw_src=" .. config.sw_src .. ", is_editing=" .. tostring(config.is_editing) .. ",\n")
        for i=1,3 do
            local pr = config.p[i]
            io.write(f, "  p"..i.."={anim="..pr.anim..", speed="..pr.speed..", trail="..pr.trail..", r_trail="..(pr.r_trail or 0)..", c1="..pr.c1..", c2="..pr.c2.."},\n")
        end
        io.write(f, "}\n")
        io.close(f)
    end
end

local function getRGB(idx)
    local c = colors_rgb[idx] or colors_rgb[0]
    return c[1], c[2], c[3]
end

local function wheel(pos)
    pos = math.floor(pos % 256)
    if pos < 85 then return 255 - pos * 3, 0, pos * 3 end
    if pos < 170 then pos = pos - 85; return 0, pos * 3, 255 - pos * 3 end
    pos = pos - 170; return pos * 3, 255 - pos * 3, 0
end

local function runWipe(t, stages, pr)
    local steps = #stages + 12 
    local head = math.floor(t / pr.speed) % steps
    local r1, g1, b1 = getRGB(pr.c1); local r2, g2, b2 = getRGB(pr.c2)
    for i = 1, #stages do
        local dist = head - (i - 1)
        if dist < 0 then dist = dist + steps end
        if dist < pr.trail then
            local intensity = 1.0 - (dist / pr.trail)
            if pr.r_trail == 1 then r1, g1, b1 = wheel((t / pr.speed * 2) + (dist * 20)) end
            local r = math.floor((r1 * intensity) + (r2 * (1 - intensity)))
            local g = math.floor((g1 * intensity) + (g2 * (1 - intensity)))
            local b = math.floor((b1 * intensity) + (b2 * (1 - intensity)))
            for _, led_idx in ipairs(stages[i]) do setRGBLedColor(led_idx, r, g, b) end
        end
    end
end

local function runInfinity(t, pr)
    local steps = #infinity_path
    local head = math.floor(t / pr.speed) % steps
    local r1, g1, b1 = getRGB(pr.c1); local r2, g2, b2 = getRGB(pr.c2)
    for i = 1, steps do
        local led_idx = infinity_path[i]
        local dist = head - (i - 1)
        if dist < 0 then dist = dist + steps end
        if dist < pr.trail then
            local intensity = 1.0 - (dist / pr.trail)
            if pr.r_trail == 1 then r1, g1, b1 = wheel((t / pr.speed * 2) + (dist * 20)) end
            local r = math.floor((r1 * intensity) + (r2 * (1 - intensity)))
            local g = math.floor((g1 * intensity) + (g2 * (1 - intensity)))
            local b = math.floor((b1 * intensity) + (b2 * (1 - intensity)))
            setRGBLedColor(led_idx, r, g, b)
        end
    end
end

local function runInfinityWipe(t, pr)
    local leds = #infinity_path
    local head = math.floor(t / pr.speed) % (leds * 2)
    local r1, g1, b1 = getRGB(pr.c1)
    for i = 1, leds do
        local led_idx = infinity_path[i]
        local is_primary = false
        if head < leds then is_primary = (i <= head + 1) else is_primary = (i > head - leds + 1) end
        if pr.r_trail == 1 then r1, g1, b1 = wheel((i * 12) + (t / pr.speed * 4)) end
        if is_primary then setRGBLedColor(led_idx, r1, g1, b1) end
    end
end

local function runSolid(pr)
    local r1, g1, b1 = getRGB(pr.c1)
    if pr.r_trail == 1 then r1, g1, b1 = wheel(getTime() / pr.speed * 2) end
    for i = 0, LED_STRIP_LENGTH - 1 do setRGBLedColor(i, r1, g1, b1) end
end

local function runBreath(t, pr)
    local r1, g1, b1 = getRGB(pr.c1); local r2, g2, b2 = getRGB(pr.c2)
    local intensity = (math.sin(t / (pr.speed * 4)) + 1) / 2
    if pr.r_trail == 1 then r1, g1, b1 = wheel(t / pr.speed * 2) end
    local r = math.floor((r1 * intensity) + (r2 * (1 - intensity)))
    local g = math.floor((g1 * intensity) + (g2 * (1 - intensity)))
    local b = math.floor((b1 * intensity) + (b2 * (1 - intensity)))
    for i = 0, LED_STRIP_LENGTH - 1 do setRGBLedColor(i, r, g, b) end
end

local function runRainbow(t, pr)
    for i = 0, LED_STRIP_LENGTH - 1 do
        local r, g, b = wheel((i * 256 / 20) + (t / pr.speed * 4))
        setRGBLedColor(i, r, g, b)
    end
end

local function init() 
    loadConfig() 
    config.is_editing = true; saveConfig()
end

local function run(event, touchState)
    lcd.clear() 
    
    local title = "FK LED > MAIN MENU"
    if current_page == PAGE_EDIT then 
        local pos_name = (active_profile==1) and "UP" or (active_profile==2) and "MID" or "DOWN"
        title = "FK LED > EDIT PROFILE: " .. pos_name
    end
    
    lcd.drawText(60, 15, title, 0)
    lcd.drawLine(60, 40, 740, 40, SOLID, 0) 
    
    local y_start = 55; local spacing = 58; local max_items = 0
    
    local function drawButton(index, label, val_text, color_idx)
        local y = y_start + ((index - 1) * spacing)
        local is_sel = (selected == index)
        lcd.drawRectangle(60, y, 680, 50, 0, is_sel and 3 or 1)
        if is_sel then lcd.drawFilledRectangle(60, y, 8, 50, 0) end
        lcd.drawText(85, y + 15, label, 0)
        
        if editing and is_sel and color_idx ~= nil then
            local box_size = 28
            local start_x = 300
            for i = 0, 8 do
                local c = colors_rgb[i]
                local cx = start_x + (i * (box_size + 6))
                local cy = y + 11
                lcd.setColor(CUSTOM_COLOR, lcd.RGB(c[1], c[2], c[3]))
                lcd.drawFilledRectangle(cx, cy, box_size, box_size, CUSTOM_COLOR)
                if i == color_idx then
                    lcd.setColor(CUSTOM_COLOR, lcd.RGB(255, 255, 255)) 
                    lcd.drawRectangle(cx-2, cy-2, box_size+4, box_size+4, CUSTOM_COLOR, 3)
                else lcd.drawRectangle(cx, cy, box_size, box_size, 0, 1) end
            end
        else
            if val_text then
                local text_x = 460 
                if editing and is_sel and color_idx == nil then
                    lcd.drawText(text_x - 30, y + 15, "-   " .. val_text .. "   +", 0)
                else lcd.drawText(text_x, y + 15, val_text, 0) end
                
                if color_idx ~= nil then
                    local c = colors_rgb[color_idx]
                    lcd.setColor(CUSTOM_COLOR, lcd.RGB(c[1], c[2], c[3]))
                    lcd.drawFilledRectangle(text_x - 45, y + 9, 32, 32, CUSTOM_COLOR)
                    lcd.drawRectangle(text_x - 45, y + 9, 32, 32, 0, 1)
                end
            end
        end
    end

    if current_page == PAGE_MAIN then
        max_items = 4
        drawButton(1, "Input Switch", sw_names[config.sw_src])
        drawButton(2, "Setup Position UP", "Enter >")
        drawButton(3, "Setup Position MID", "Enter >")
        drawButton(4, "Setup Position DOWN", "Enter >")
    elseif current_page == PAGE_EDIT then
        max_items = 7
        local pr = config.p[active_profile]
        drawButton(1, "Animation Mode", anim_names[pr.anim])
        drawButton(2, "Speed (Lower=Faster)", pr.speed)
        drawButton(3, "Trail Length", pr.trail)
        drawButton(4, "Rainbow Dynamic FX", pr.r_trail == 1 and "ON" or "OFF")
        drawButton(5, "Primary Colour", color_names[pr.c1], pr.c1)
        drawButton(6, "Background Colour", color_names[pr.c2], pr.c2)
        drawButton(7, "[ < Back & Save Profile ]")
    end

    local step = 0; local enter = false; local back = false

    if event == EVT_VIRTUAL_ENTER then enter = true
    elseif event == EVT_VIRTUAL_EXIT then back = true
    elseif event == EVT_VIRTUAL_INC or event == EVT_ROT_RIGHT or event == EVT_VIRTUAL_NEXT then step = 1
    elseif event == EVT_VIRTUAL_DEC or event == EVT_ROT_LEFT or event == EVT_VIRTUAL_PREV then step = -1
    
    elseif touchState and touchState.x and (event == EVT_TOUCH_TAP or event == EVT_TOUCH_BREAK) then
        local tx = touchState.x; local ty = touchState.y; local row = 0
        for i = 1, max_items do
            local item_y = y_start + ((i-1) * spacing)
            if ty >= item_y and ty <= item_y + 55 then row = i; break end
        end
        if row > 0 then
            if selected == row then
                if editing then
                    if current_page == PAGE_EDIT and (row == 5 or row == 6) then
                        local start_x = 300
                        if tx >= start_x and tx <= start_x + (9 * 34) then
                            local clicked_idx = math.floor((tx - start_x) / 34)
                            if clicked_idx >= 0 and clicked_idx <= 8 then
                                if row == 5 then config.p[active_profile].c1 = clicked_idx
                                elseif row == 6 then config.p[active_profile].c2 = clicked_idx end
                            end
                        else editing = false end
                    else
                        if tx > 460 then step = 1
                        elseif tx < 460 then step = -1
                        else editing = false end
                    end
                else enter = true end
            else selected = row; editing = false end
        end
    end

    if back then
        if current_page == PAGE_MAIN then config.is_editing = false; saveConfig(); return 1 
        else saveConfig(); current_page = PAGE_MAIN; selected = 1; editing = false end
    end

    if enter then
        if current_page == PAGE_MAIN then
            if selected == 1 then editing = not editing
            elseif selected >= 2 and selected <= 4 then active_profile = selected - 1; current_page = PAGE_EDIT; selected = 1 end
        elseif current_page == PAGE_EDIT then
            if selected == 7 then saveConfig(); current_page = PAGE_MAIN; selected = 1 
            else editing = not editing end
        end
    end

    if step ~= 0 then
        if not editing then
            selected = selected + step
            if selected > max_items then selected = 1 end
            if selected < 1 then selected = max_items end
        else
            if current_page == PAGE_MAIN and selected == 1 then
                config.sw_src = (config.sw_src + step) % 9; if config.sw_src < 0 then config.sw_src = 8 end
            elseif current_page == PAGE_EDIT then
                local pr = config.p[active_profile]
                if selected == 1 then pr.anim = (pr.anim + step) % 11; if pr.anim < 0 then pr.anim = 10 end
                elseif selected == 2 then pr.speed = math.max(1, pr.speed + step)
                elseif selected == 3 then pr.trail = math.max(1, pr.trail + step)
                elseif selected == 4 then pr.r_trail = (pr.r_trail == 0) and 1 or 0
                elseif selected == 5 then pr.c1 = (pr.c1 + step) % 9; if pr.c1 < 0 then pr.c1 = 8 end
                elseif selected == 6 then pr.c2 = (pr.c2 + step) % 9; if pr.c2 < 0 then pr.c2 = 8 end
                end
            end
        end
    end
    
    local preview_idx = 1
    if current_page == PAGE_EDIT then preview_idx = active_profile
    else
        if config.sw_src > 0 then
            local val = getValue(sw_raw_names[config.sw_src])
            if val then
                if val < -341 then preview_idx = 1
                elseif val > 341 then preview_idx = 3
                else preview_idx = 2 end
            end
        end
    end
    
    local pr = config.p[preview_idx]
    local t = getTime()
    local r2, g2, b2 = getRGB(pr.c2)
    local num_leds = LED_STRIP_LENGTH or 20
    for i = 0, num_leds - 1 do setRGBLedColor(i, r2, g2, b2) end
    
    if pr.anim == 0 then runWipe(t, wipe_up_stages, pr)
    elseif pr.anim == 1 then runInfinity(t, pr)
    elseif pr.anim == 2 then runWipe(t, wipe_down_stages, pr)
    elseif pr.anim == 3 then runWipe(t, wipe_left_stages, pr)
    elseif pr.anim == 4 then runWipe(t, wipe_right_stages, pr)
    elseif pr.anim == 5 then runWipe(t, wipe_center_stages, pr)
    elseif pr.anim == 6 then runWipe(t, snake_stages, pr)
    elseif pr.anim == 7 then runInfinityWipe(t, pr)
    elseif pr.anim == 8 then runSolid(pr)
    elseif pr.anim == 9 then runBreath(t, pr)
    elseif pr.anim == 10 then runRainbow(t, pr)
    end
    
    applyRGBLedColors()
    return 0 
end

return { name = "FK LED", init = init, run = run }