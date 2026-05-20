-- File: /SCRIPTS/RGBLED/fk_led.lua

local config_file = "/SCRIPTS/RGBLED/fk_cfg.lua"
local last_read_time = 0

local config = {
    sw_src = 0, is_editing = false,
    p = {
        {anim=0, speed=8, trail=3, r_trail=0, c1=1, c2=0},
        {anim=1, speed=8, trail=3, r_trail=0, c1=2, c2=0},
        {anim=2, speed=8, trail=3, r_trail=0, c1=3, c2=0}
    }
}

local colors_rgb = { [0]={0,0,0}, [1]={255,0,0}, [2]={0,255,0}, [3]={0,0,255}, [4]={255,255,0}, [5]={0,255,255}, [6]={255,0,255}, [7]={255,255,255}, [8]={255,128,0} }
local sw_raw_names = {"sa", "sb", "sc", "sd", "se", "sf", "sg", "sh"}

local wipe_up_stages     = {{7,8,17,18}, {6,9,16,19}, {0,5,10,15}, {1,4,11,14}, {2,3,12,13}}
local wipe_down_stages   = {{2,3,12,13}, {1,4,11,14}, {0,5,10,15}, {6,9,16,19}, {7,8,17,18}}
local snake_stages       = {{7,8}, {6,9}, {0,5}, {1,4}, {2,3}, {12,13}, {11,14}, {10,15}, {16,19}, {17,18}}
local wipe_left_stages   = {{5}, {4,6}, {3,7}, {2,8}, {1,9}, {0}, {10}, {11,19}, {12,18}, {13,17}, {14,16}, {15}}
local wipe_right_stages  = {{15}, {14,16}, {13,17}, {12,18}, {11,19}, {10}, {0}, {1,9}, {2,8}, {3,7}, {4,6}, {5}}
local wipe_center_stages = {{5,15}, {4,6,14,16}, {3,7,13,17}, {2,8,12,18}, {1,9,11,19}, {0,10}}
local infinity_path      = {0,1,2,3,4,5,6,7,8,9, 10,11,12,13,14,15,16,17,18,19}

local function loadConfig()
    local chunk = loadfile(config_file)
    if chunk then
        local loaded = chunk()
        if loaded then
            config.sw_src = loaded.sw_src or 0
            config.is_editing = loaded.is_editing or false
            if loaded.p1 then config.p[1] = loaded.p1 end
            if loaded.p2 then config.p[2] = loaded.p2 end
            if loaded.p3 then config.p[3] = loaded.p3 end
        end
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

local function init() loadConfig() end

local function run()
    local t = getTime()
    if (t - last_read_time) > 100 then
        loadConfig()
        last_read_time = t
    end
    
    if config.is_editing then return end
    
    local active_idx = 1
    if config.sw_src > 0 then
        local val = getValue(sw_raw_names[config.sw_src])
        if val then
            if val < -341 then active_idx = 1
            elseif val > 341 then active_idx = 3
            else active_idx = 2 end
        end
    end
    
    local pr = config.p[active_idx]
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
end

return { run=run, init=init }