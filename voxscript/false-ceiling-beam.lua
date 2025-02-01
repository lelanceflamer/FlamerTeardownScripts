--[[ false-ceiling-beam.lua
    Voxscript made by Le lance Flamer to make perpendicular beams on dropped ceilings easier to put, prevent the common issue where the shape is trimmed entirely
    instead of making one hole inside.
    ///////
    Parameter explanation:
    size: the size of the beam for the dropped ceiling.
    step:
      L First number is the step, that is the default length between each beam.
      L Second number is the step size, this is the size of the space between each part of the beam after each step unit.
    color: the rgb color of the metal beam.
    offset: the X offset for the beam. It is used to make it so when the perimeter of the room isn't perfect so you can center the false ceiling accordingly like in
            real life.
    
    If you'd like to understand the parameters better (I explain like garbage, I admit it), check my maps in the editor, in particular Flamer's random building and
    Flamer's Mall (once it comes out :p, it's WIP).
    ///////
    Free to use for anyone in their map, it's okay to use without including these credits but I'd be thankful if you keep them.
]]

local sx, sy, sz = GetInt("size", 50, 1, 1)
local step, stepSize = GetInt("step", 10, 1)
local cr, cg, cb, _ = GetColor("color", 0.67, 0.64, 0.64)
local offset = GetInt("offset", 0) --offset to apply on the initial beam to add.

function init()
    local metalMat = CreateMaterial("metal", cr, cg, cb, 1, 0, 0, 0.15, 0)
    local stepAmount = math.ceil(sx / step) --moved from math.floor to math.ceil, caused unexpected issues with the offset.
    local additionalSize = (sx / step - stepAmount) * sx
    local currentSize = 0
    --[[
    DebugPrint("Additional size: " .. additionalSize)
    DebugPrint("Step amount: " .. stepAmount)
    DebugPrint("Step length: " .. step)
    DebugPrint("Step size: " .. stepSize)

    DebugPrint("Offset: " .. offset)
    ]]--

    --initial x offset check
    if offset < 0 then
        offset = -offset
    end
    if offset > sx - 1 then
        offset = sx - 1
    end

    Material(metalMat)
    local latestStep = 0
    local tooFar = false
    for i=0, stepAmount do
        latestStep = i
        if i == 0 then
            Vox(0, 0, 0)
            currentSize = step
            local s = step

            s = step - offset --applying the offset.

            if currentSize > sx then
                s = sx
                currentSize = sx
                tooFar = true
            end

            currentSize = s
            --DebugPrint("Calculated size (current size): " .. s)
            Box(0, 0, 0, s, sy, sz)
        else
            if tooFar then
                break
            end
            currentSize = currentSize + step + stepSize
            --DebugPrint("Current size: " .. currentSize)
            local s = step
            if currentSize > sx then --size exceeded
                --DebugPrint(currentSize .. " > " .. sx)
                tooFar = true
                local diff = currentSize - sx
                s = s - diff
                if s <= 0 then
                    break
                end
                currentSize = s
            end
            --DebugPrint("Calculated size: " .. s)

            local pos = (step + stepSize) * i
            --DebugPrint("Initial position: " .. pos)
            if offset > 0 then
                pos = pos - offset
            end
            --DebugPrint("Calculated position: " .. pos)
            Vox(pos, 0, 0)
            Box(0, 0, 0, s, sy, sz)
        end
    end

    if math.floor(additionalSize) > 0 and not tooFar then
        currentSize = currentSize + additionalSize

        Vox((step + stepSize) * latestStep)
        Box(0, 0, 0, additionalSize, sy, sz)
    end
end
