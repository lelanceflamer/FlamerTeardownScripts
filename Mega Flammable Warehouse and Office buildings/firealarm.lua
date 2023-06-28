--[[CREDITS: DO NOT DELETE IF POSSIBLE!! / NE PAS SUPPRIMER SI POSSIBLE!!
Made by Le lance Flamer (lelanceflamer) on Discord. / Fait par Le lance Flamer (lelanceflamer) sur Discord.
]]

fireAlarms = {}
function init()
    warehouseTrigger = FindTrigger("warehouse", true)
    --officeTrigger = FindTrigger("office")
    warehouseTMin, warehouseTMax = GetTriggerBounds(warehouseTrigger)
    --officeTMin, officeTMax = GetTriggerBounds(officeTrigger)
    fireAlarms.warehouse = {}
    fireAlarms.warehouse.sound = LoadLoop("MOD/sounds/firealarm_France.ogg", 15.0)
    fireAlarms.warehouse.shapes = FindShapes("wh-firealarm")
    fireAlarms.warehouse.box = {}
    fireAlarms.warehouse.box.shape = FindShape("wh-firealarm_box", true)
    fireAlarms.warehouse.box.isEnabledFromBox = "Default"
    fireAlarms.warehouse.box.isEnabledFromBoxValues = {[1] = "Default", [2] = "Asked", [3] = "Disabled"}
    SetTag(fireAlarms.warehouse.box.shape, "interact", "Default")

    --[[
    fireAlarms.office = {}
    fireAlarms.office.sound = LoadLoop("MOD/sounds/firealarm_France.ogg", 15.0)
    fireAlarms.office.shapes = FindShapes("off-firealarm")
    fireAlarms.office.box = {}
    fireAlarms.office.box.shape = FindShape("off-firealarm_box", true)
    fireAlarms.office.box.isEnabledFromBox = false
    ]]--
end

maxWarehouseFires = 8
--maxOfficeFires = 5

warehouseFires = 0
--officeFires = 0

function tick()
    warehouseFires = QueryAabbFireCount(warehouseTMin, warehouseTMax)
    --officeFires = QueryAabbFireCount(officeTMin, officeTMax)
    if (not IsShapeBroken(fireAlarms.warehouse.box.shape) and (fireAlarms.warehouse.box.isEnabledFromBox == "Default" and warehouseFires >= maxWarehouseFires)) or fireAlarms.warehouse.box.isEnabledFromBox == "Asked" then
        
        FireAlarm("warehouse")
    end

    if GetPlayerInteractShape() == fireAlarms.warehouse.box.shape and InputPressed("interact") then
        local nextValue = GetNextTableValue(fireAlarms.warehouse.box.isEnabledFromBoxValues, fireAlarms.warehouse.box.isEnabledFromBox)
        SetTag(fireAlarms.warehouse.box.shape, "interact", nextValue)
        fireAlarms.warehouse.box.isEnabledFromBox = nextValue
    end

    --[[
    if officeFires >= maxOfficeFires then
        FireAlarm("office")
    end
    ]]
end

--Other functions
local currentFireAlarmTransform = nil
function FireAlarm(building)
    if fireAlarms[building] then
         for i, fireAlarm in ipairs(fireAlarms[building]["shapes"]) do
            if not IsShapeBroken(fireAlarm) then
                currentFireAlarmTransform = GetShapeWorldTransform(fireAlarm)
                PlayLoop(fireAlarms[building]["sound"], currentFireAlarmTransform.pos, 2.5) 
            end
         end
    end
end

function GetNextTableValue(table, currentValue)
    local val = nil

    for i, v in pairs(table) do
        if table[i + 1] ~= currentValue and table[i] == currentValue then
            if table[i + 1] == nil then
                val = table[1]
                break
            else
                val = table[i + 1]
                break
            end
        end
    end

    return val
end
