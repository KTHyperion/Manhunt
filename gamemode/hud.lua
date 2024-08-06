include("functions.lua")

remainingTimeLobby = nil
remainingTimeMatch = nil
stateofthematchtimer = 0

local relic_icon = surface.GetTextureID("vgui/logos/relic")
local ar2_icon = surface.GetTextureID("vgui/icon/ar2")
local crossbow_icon = surface.GetTextureID("vgui/icon/crossbow")
local crowbar_icon = surface.GetTextureID("vgui/icon/crowbar")
local pistol_icon = surface.GetTextureID("vgui/icon/pistol")
local revolver_icon = surface.GetTextureID("vgui/icon/revolver")
local rpg_icon = surface.GetTextureID("vgui/icon/rpg")
local shotgun_icon = surface.GetTextureID("vgui/icon/shotgun")
local smg_icon = surface.GetTextureID("vgui/icon/smg")

function drawRelicIcon(scx, scy)
    surface.SetTexture(relic_icon)
    local x = scx/6.5
    local y = (13*scy)/16 + scy/50
    local xsize = scx/60
    local ysize = xsize
    surface.DrawTexturedRect(x, y, xsize, ysize)
end

function drawWeaponIcon(scx, scy, icon, sizex, sizey, posx, posy)
    surface.SetTexture(icon)
    local x = posx
    local y = posy
    local xsize = sizex
    local ysize = sizey
    surface.DrawTexturedRect(x, y, xsize, ysize)
end

net.Receive("Timer4Lobby", function()
    remainingTimeLobby = net.ReadInt(6)
    stateofthematchtimer = sec_to_min(toint(remainingTimeLobby))
end)

net.Receive("Timer4Match", function()
    remainingTimeMatch = net.ReadInt(12)
    stateofthematchtimer = sec_to_min(toint(remainingTimeMatch))
end)

net.Receive("Timer4PostGame", function()
    remainingTimePostGame = net.ReadInt(6)
    stateofthematchtimer = sec_to_min(toint(remainingTimePostGame))
end)

local ho_orange = Color(255, 140, 0, 125)
local orange = Color(255,140,0,255)
local black = Color(0,0,0,255)

-- Function who paint the HUD.
function drawHUD()
    local scx = ScrW()
    local scy = ScrH()
    local client = LocalPlayer()

    draw.RoundedBox(0, scx/2 - 32, 5, 64, 30, orange)
    draw.RoundedBox(0, scx/2 - 30, 7, 60, 26, black)
    if stateofthematchtimer != nil then
        draw.SimpleText(stateofthematchtimer, "HudDefault", scx/2, 10, orange, TEXT_ALIGN_CENTER)
    end

    -- Whenever the player is dead, no other HUD should be painted, so, the function will
    -- not continue from this point onwards.
    if !client:Alive() then return end
    if client:Team() == TEAM_SPECTATOR then
        local lengx1 = (scx)/6.7
        local lengx2 = (scx)/6.7 - 4
        draw.RoundedBox(32, scx/2 - lengx1/2, (15*scy)/16 + 15, lengx1, scy/12 - toint(0.04629 * scy), ho_orange)
        draw.RoundedBox(32, scx/2 - lengx2/2, (15*scy)/16 + 18, lengx2, scy/12 - toint(0.05092 * scy), black)
        draw.SimpleText("Time until respawn: "..client:GetNWInt('spec_mode'), "HudDefault", (scx/2), (15*scy)/16 + 25, orange, TEXT_ALIGN_CENTER)
    end
    if client:GetObserverMode() != 0 then return end

    draw.RoundedBox(32, scx/32 + 10, (13*scy)/16 + 15, (6*scx)/32 - 20, scy/8 - toint(0.04629 * scy), ho_orange)
    draw.RoundedBox(32, 25*scx/32 + 10, (13*scy)/16 + 15, (6*scx)/32 - 20, scy/8 - toint(0.04629 * scy), ho_orange)
    draw.RoundedBox(32, scx/32 + 13, (13*scy)/16 + 18, (6*scx)/32 - 25, scy/8 - toint(0.05092 * scy), black)
    draw.RoundedBox(32, 25*scx/32 + 13, (13*scy)/16 + 18, (6*scx)/32 - 25, scy/8 - toint(0.05092 * scy), black)

    draw.SimpleText("Health:", "HudDefault", scx/32+50, (13*scy)/16 + 25, orange)
    drawRelicIcon(scx, scy)
    draw.SimpleText(": "..client:GetNWInt("relics"), "HudDefault", scx/5.9, (13*scy)/16 + 25, orange)

    draw.RoundedBox(0, scx/32 + toint(0.046296 * scx)/1.75, (13*scy)/16 + toint(0.055 * scy), (client:Health()/100) * ((4.25*scx)/32), toint(0.023 * scy), orange)
    if client:GetActiveWeapon() == nil then return end
    local cur_weapon = client:GetActiveWeapon()
    if (cur_weapon != NULL) then
        if (cur_weapon:GetPrintName() != nil) then
            draw.SimpleText(cur_weapon:GetPrintName(), "HudDefault", 25*scx/32+ (0.02604 * scx), (13*scy)/16 + (0.02315 * scy), orange)
            if (client:GetActiveWeapon():Clip1() != -1) and (client:GetAmmoCount(cur_weapon:GetPrimaryAmmoType()) != -1) then
                local cur_message = cur_weapon:Clip1().."/"..cur_weapon:GetMaxClip1().."  ("..client:GetAmmoCount(cur_weapon:GetPrimaryAmmoType())..")"
                draw.SimpleText(cur_message, "HudDefault", 25*scx/32+ (0.02604 * scx), (13*scy)/16 + (0.05315 * scy), orange)
            elseif (client:GetActiveWeapon():Clip1() == -1) and (client:GetAmmoCount(cur_weapon:GetPrimaryAmmoType()) != 0) then
                local cur_message = "("..client:GetAmmoCount(cur_weapon:GetPrimaryAmmoType())..")"
                draw.SimpleText(cur_message, "HudDefault", 25*scx/32+ (0.02604 * scx), (13*scy)/16 + (0.05315 * scy), orange)
            end
        end
        if cur_weapon:GetClass() == "weapon_smg1" then
            drawWeaponIcon(scx, scy, smg_icon, scx/18, scx/18, 5.75*scx/6.5, (13.1*scy)/16)
        end
        if cur_weapon:GetClass() == "weapon_rpg" then
            drawWeaponIcon(scx, scy, rpg_icon, scx/13.5, scx/13.5, 5.65*scx/6.5, (12.8*scy)/16)
        end
        if cur_weapon:GetClass() == "weapon_ar2" then
            drawWeaponIcon(scx, scy, ar2_icon, scx/17, scx/18, 5.78*scx/6.5, (13.05*scy)/16)
        end
        if cur_weapon:GetClass() == "weapon_crossbow" then
            drawWeaponIcon(scx, scy, crossbow_icon, scx/18, scx/18, 5.75*scx/6.5, (13.1*scy)/16)
        end
        if cur_weapon:GetClass() == "weapon_pistol" then
            drawWeaponIcon(scx, scy, pistol_icon, scx/19, scx/21, 5.8*scx/6.5, (13.2*scy)/16)
        end
        if cur_weapon:GetClass() == "weapon_shotgun" then
            drawWeaponIcon(scx, scy, shotgun_icon, scx/17, scx/18, 5.75*scx/6.5, (13.1*scy)/16)
        end
        if cur_weapon:GetClass() == "weapon_357" then
            drawWeaponIcon(scx, scy, revolver_icon, scx/18, scx/18, 5.8*scx/6.5, (13.08*scy)/16)
        end
        if cur_weapon:GetClass() == "weapon_crowbar" then
            drawWeaponIcon(scx, scy, crowbar_icon, scx/17, scx/21, 5.75*scx/6.5, (13.15*scy)/16)
        end
    end

end
-- Wait for whenever the HUD should be painted. Then, execute drawHUD function.
hook.Add("HUDPaint", "DrawHUD", drawHUD)

-- Function to remove Default HUDs.
function HideDefaultHUD(element)
    -- Lets iterate over every element that can be present in a HUD.
    for num, elem in pairs({"CHudHealth","CHudBattery","CHudAmmo","CHudSecondaryAmmo"}) do
        -- If the corresponding element is found, we want it to return false
        if elem == element then
            -- The "false" boolean will be called whenever an HUD element is called
            -- wherever a HUD element returns false when called, it turns itself off
            return false
        end
    end
end
-- Wait for any HUD element being called, and if it happens, execute HideDefaultHUD
-- If it corresponds to any element listed, it will return false and not appear.
hook.Add("HUDShouldDraw", "HideDefaultHUD", HideDefaultHUD)