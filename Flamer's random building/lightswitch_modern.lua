--[[
    Improved version of the lightswitch.lua script, by Le lance Flamer obviously.
    It's better because, on top of the original script's features, this script supports:
    1. Moving the switch itself, using a joint
    2. Can make lights turn off / on by default when the script has been initiated using a parameter
    3. Sounds for making the switch move
    4. More understandable code (I hope), but please have some Teardown scripting experience
       => Better variables, script parameters, functions names; No useless loops / values
	   
	This script doesn't use #include "utils.lua" since I want to make it easy to use for everyone in their own map, then free to modify.
]]--

--#region Classes
---@class lightswitch_light
---@field shape number The light's parent shape handle
---@field light number The light's own handle

---@class lightswitch
---@field shape number The light switch's shape handle
---@field joint number The joint's shape handle
---@field joint_min number How far the light switch shape can go when the lights are turned off
---@field joint_max number How far the light switch shape can go when the lights are turned on
---@field light_switch_state boolean
--#endregion

--Script params
pChildLights = GetStringParam("child_lights", "") --The tag of the lights to be turned on / off using the light switch, if left empty, then it commands all child lights or all lights in the scene.
pGlobal = GetBoolParam("global", false) --Whether the lights should be obtained globally or inside the script's scope.
pDefaultState = GetBoolParam("default_state", true) --The default light enabled state, true for on, otherwise false for off.

function init()
    ---@type lightswitch_light[]
    lights = {}
    ---@type lightswitch[]
    lightSwitches = {}
    currentState = pDefaultState --Current lights state
    --DebugPrint(pDefaultState)

    obtainedLights = FindLights(boolVal(pChildLights:len() == 0, nil, pChildLights), pGlobal)
    for i=1, #obtainedLights do
        local light = obtainedLights[i]
        local lightShape = GetLightShape(light)

        local lightState = IsLightActive(light)
        if lightState ~= pDefaultState then
            SetLightEnabled(light, pDefaultState)
        end

        table.insert(lights, {
            shape = lightShape,
            light = light
        })
    end

    --Now gets the light switches because yes
    local obtainedLightSwitches = FindShapes("lightswitch")
    local obtainedLightSwitchJoints = FindJoints("lightswitch_joint")
    for i=1, #obtainedLightSwitches do
        --assuming that the joints are in the same order as the switches
        local switch = obtainedLightSwitches[i]
        local joint = obtainedLightSwitchJoints[i]

        local joint_min, joint_max = GetJointLimits(joint)
        joint_min, joint_max = math.round(joint_min, 2), math.round(joint_max, 2)

        local jointMovement = math.round(GetJointMovement(joint), 2)
        --DebugPrint(jointMovement)
        --DebugPrint(joint_min .. " " .. joint_max)
        if pDefaultState == true then --If lights should be enabled by default
            --DebugPrint("Enabled")
            if jointMovement < joint_max then
                --DebugPrint("Moving...")
                SetJointMotorTarget(joint, joint_max, 7)
            end
        else
            --DebugPrint("Disabled")
            if jointMovement > joint_min then
                --DebugPrint("Moving...")
                SetJointMotorTarget(joint, joint_min, 7)
            end
        end

        SetTag(switch, "interact", boolVal(pDefaultState, "Turn off", "Turn on"))

        table.insert(lightSwitches, {
            shape = switch,
            joint = joint,
            joint_min = joint_min,
            joint_max = joint_max,
            light_switch_state = pDefaultState
        })
    end

    broken = false
end

function tick()
    if broken then
        return --do nothing if the main (first) light switch broke
    end

    local foundLightSwitch = findLightSwitch(GetPlayerInteractShape())
    for i=1, #lightSwitches do --Checks if any of them is broken and if they're the main (first) light switch
        local lightSwitch = lightSwitches[i]
        if not IsHandleValid(lightSwitch.shape) or IsShapeBroken(lightSwitch.shape) or not IsHandleValid(lightSwitch.joint) or IsJointBroken(lightSwitch.joint) then
            if i == 1 then --if it's the main (first) light switch
                broken = true

                if currentState then
                    toggleLights() --turn all lights off if they're on
                end
            end

            RemoveTag(lightSwitch.shape, "interact") --removes the interact tag if broken
        end

        if broken then
            RemoveTag(lightSwitch.shape, "interact") --removes the interact tag if broken, even if it already has been removed for the current light switch.
        end
    end

    if foundLightSwitch and InputPressed("interact") then
        --If the light switch's joint is not broken and still exists in the scene and also that the light switch isn't broken and still exists in the scene, then we cn proceed.
        if IsHandleValid(foundLightSwitch.joint) and not IsJointBroken(foundLightSwitch.joint) and IsHandleValid(foundLightSwitch.shape) and not IsShapeBroken(foundLightSwitch.shape) then
            toggleLights()

            if currentState then --If lights are enabled
                if foundLightSwitch.light_switch_state then --if it has been configured to on
                    SetJointMotorTarget(foundLightSwitch.joint, -foundLightSwitch.joint_max, 7)
                else --otherwise to off, like expected
                    SetJointMotorTarget(foundLightSwitch.joint, foundLightSwitch.joint_max, 7)
                end
            else
                if foundLightSwitch.light_switch_state then --if it's on like expected
                    SetJointMotorTarget(foundLightSwitch.joint, foundLightSwitch.joint_min, 7)
                else --or off
                    SetJointMotorTarget(foundLightSwitch.joint, -foundLightSwitch.joint_min, 7)
                end
            end

            foundLightSwitch.light_switch_state = not foundLightSwitch.light_switch_state

            for i=1, #lightSwitches do
                --Toggle lightswitches state but do not move them
                SetTag(lightSwitches[i].shape, "interact", boolVal(currentState, "Turn off", "Turn on"))
            end
        end
    end
end

function toggleLights()
    --invert the state
    currentState = not currentState

    for i=1, #lights do
        local light = lights[i]
        --If the light still exists and that its parent shape still exists and isn't broken, then we can toggle the state
        if IsHandleValid(light.light) and IsHandleValid(light.shape) and not IsShapeBroken(light.shape) then
            SetLightEnabled(light.light, currentState)
        end
    end
end


---comment
---@param handle number Interact shape handle
---@return lightswitch? foundlight
function findLightSwitch(handle)
    return table.find(lightSwitches, function (value)
        return value.shape == handle
    end)
end

---#region utils
---comment
---@param value boolean
---@param true_val any
---@param false_val any
function boolVal(value, true_val, false_val)
    if value == true then
        return true_val
    elseif value == false then
        return false_val
    end

    return nil --If the provided value isn't a boolean value, then return nil.
end

---comment
---@param number number
---@param decimals number?
---@return number
function math.round(number, decimals)
    decimals = decimals or 0
    local multiplier = 10 ^ decimals
    return math.floor(number * multiplier + 0.5) / multiplier
end

---#endregion