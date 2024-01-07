#include "script/common.lua"

pMessage = GetStringParam("message", "loc@PMESSAGE_HACKING")
pDuration = GetFloatParam("duration", 2.0)
pSound = GetStringParam("sound", "transmission.ogg")
pTriggerAlarm = GetBoolParam("alarm", false)

JOINTED_STATIC = 1
JOINTED_DYNAMIC = 2
FIXED_STATIC = 3
FIXED_DYNAMIC = 4

function init()
	body = FindBody("target")
	hackpanel = FindShape("hack")
	dynamic = IsBodyDynamic(GetShapeBody(hackpanel))
	light = FindLight("light")

	local joints = GetShapeJoints(hackpanel)
	joint = joints[1]

	if joint then
		local s = GetJointOtherShape(joint, hackpanel)
		if IsBodyDynamic(GetShapeBody(s)) then
			type = JOINTED_DYNAMIC
			initialMass = GetBodyMass(GetShapeBody(s))
		else
			type = JOINTED_STATIC
		end
	else
		if IsBodyDynamic(GetShapeBody(hackpanel)) then
			type = FIXED_DYNAMIC
			initialMass = GetBodyMass(GetShapeBody(hackpanel))
		else
			type = FIXED_STATIC
		end
	end

	SetTag(body, "interact", "loc@HACK_TARGET")
	progress = 0
	snd = LoadLoop(pSound)

	tampered = false
	hacked = false
	dispatched = false
end


function tick(dt)
	local triggerDispatch = false

	if not hacked then
		if GetPlayerInteractBody() == body and InputDown("interact") then
			progress = progress + dt
			local t = clamp(progress / pDuration, 0, 1)
			if t == 1 then
				SetTag(body, "target", "cleared")
				RemoveTag(body, "interact")
				hacked = true

				if pTriggerAlarm then --If the alarm should be triggered when the target is hacked, unlike the original script.
					SetBool("level.alarm", true) --Triggers the alarm
				end
			else
				SetBool("level.hacking", true)
				PlayLoop(snd, GetBodyTransform(body).pos)
			end
		else
			progress = 0
		end
	end

	if not tampered then
		if type == FIXED_STATIC then
			if IsBodyDynamic(GetShapeBody(hackpanel)) then
				tampered = true
			end
		elseif type == FIXED_DYNAMIC then
			local currentMass = GetBodyMass(GetShapeBody(hackpanel))
			if currentMass < 0.5 * initialMass then
				tampered = true
			end
		elseif type == JOINTED_STATIC then
			if IsJointBroken(joint) then
				tampered = true
			else
				local s = GetJointOtherShape(joint, hackpanel)
				if IsBodyDynamic(GetShapeBody(s)) then
					tampered = true
				end
			end
		elseif type == JOINTED_DYNAMIC then
			if IsJointBroken(joint) then
				tampered = true
			else
				local s = GetJointOtherShape(joint, hackpanel)
				local currentMass = GetBodyMass(GetShapeBody(s))
				if currentMass < 0.5 * initialMass then
					tampered = true
				end
			end
		end
	end

	if not dispatched and (tampered or hacked) then
		SetBool("level.dispatch", true)
		dispatched = true
	end

	local period = 0.8
	if tampered then
		period = 0.4
		if light then --In the original script, the light was required, in this one, if there's no light in the "hack" target, just ignore.
			SetLightColor(light, 1, .1, .1)
		end
	end
	if hacked then
		SetShapeEmissiveScale(hackpanel, 0)
	else
		if math.mod(GetTime(), period) < 0.1 then
			SetShapeEmissiveScale(hackpanel, 1)
		else
			SetShapeEmissiveScale(hackpanel, 0)
		end
	end
end


function draw()
	if not hacked and progress > 0 then
		UiPush()
			UiTranslate(UiCenter()-100, UiHeight()-220)
			progressBar(200, 20, progress/pDuration)
			UiTranslate(100, -10)
			UiAlign("center")
			UiFont("bold.ttf", 24)
			UiText(pMessage)
		UiPop()
	end
end
