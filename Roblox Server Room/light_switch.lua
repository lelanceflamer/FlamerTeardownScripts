--[[CREDITS: DO NOT DELETE IF POSSIBLE!! / NE PAS SUPPRIMER SI POSSIBLE!!
Made by Le lance Flamer (lelanceflamer) on Discord. / Fait par Le lance Flamer (lelanceflamer) sur Discord.
]]

function init()
    allLights = FindLights("light")
    DebugPrint(FindShape("lightSwitch"))
    lightSwitch = FindShape("lightSwitch")
    SetTag(lightSwitch, "interact", BoolString(true, "Turn on", "Turn off"))
end

lit = true
function tick()
    if GetPlayerInteractShape() == lightSwitch and InputPressed("interact") then
        lit = not lit
        ForEach(allLights, function(item)
            local lightShape = GetLightShape(item)
            if not IsShapeBroken(lightShape) then
                SetLightEnabled(item, lit)
            end
        end)
        
        SetTag(lightSwitch, "interact", BoolString(lit, "Turn on", "Turn off"))
    end
end

--Random functions lol
function ForEach(items, func)
    for i, v in ipairs(items) do
        func(v)
    end
end

function BoolString(value, falseReturn, trueReturn)
    if value ~= nil then
        local fString = "False"
        local tString = "True"
        if falseReturn ~= nil then
            fString = falseReturn
        end

        if trueReturn ~= nil then
            tString = trueReturn
        end

        if value == false then
            return fString
        else
            return tString
        end
    end

    return nil
end
