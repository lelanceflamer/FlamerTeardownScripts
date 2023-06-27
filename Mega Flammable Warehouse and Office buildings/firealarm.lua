fireAlarms = {}
function init()
    warehouseTrigger = FindTrigger("warehouse", true)
    --officeTrigger = FindTrigger("office")
    warehouseTMin, warehouseTMax = GetTriggerBounds(warehouseTrigger)
    --officeTMin, officeTMax = GetTriggerBounds(officeTrigger)
    fireAlarms["warehouse"] = {}
    fireAlarms["warehouse"]["sound"] = LoadLoop("MOD/sounds/firealarm_France.ogg", 15.0)
    fireAlarms["warehouse"]["shapes"] = FindShapes("wh-firealarm")

    --fireAlarms["office"] = {}
    --fireAlarms["office"]["sound"] = LoadLoop("Mod/sounds/firealarm_France.ogg")
    --fireAlarms["office"]["shapes"] = FindShapes("off-firealarm")
end

maxWarehouseFires = 8
--maxOfficeFires = 5

warehouseFires = 0
--officeFires = 0

function tick()
    warehouseFires = QueryAabbFireCount(warehouseTMin, warehouseTMax)
    --officeFires = QueryAabbFireCount(officeTMin, officeTMax)
    if warehouseFires >= maxWarehouseFires then
        FireAlarm("warehouse")
    end

    --[[
    if officeFires >= maxOfficeFires then
        FireAlarm("office")
    end
    ]]
end

--Other functions
fireAlarmTransform = nil
function FireAlarm(building)
    if fireAlarms[building] then
         for i, fireAlarm in ipairs(fireAlarms[building]["shapes"]) do
            if not IsShapeBroken(fireAlarm) then
                DebugPrint(fireAlarm)
                fireAlarmTransform = GetShapeWorldTransform(fireAlarm)
                PlayLoop(fireAlarms[building]["sound"], fireAlarmTransform.pos, 2.5) 
            end
         end
    end
end