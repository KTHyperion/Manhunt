AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

gold = Color(255, 183, 40)

function ENT:Initialize()
    self:SetModel("models/hunter/blocks/cube025x025x025.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

    self:SetColor(gold)
    self:SetMaterial("models/shiny")

    local phys = self:GetPhysicsObject()

    if phys:IsValid() then
        phys:Wake()
    end
end

function ENT:Use(a, c)
    a:SetNWInt('relics', a:GetNWInt('relics') + 1)
    a:EmitSound("pickup_relic")
    self:Remove()
    if math.fmod(a:GetNWInt('relics'), 5) == 0 then
        for _, ply in pairs(player.GetAll()) do
            ply:ChatPrint("The player "..a:Nick().." collected "..a:GetNWInt('relics').." relics!")
        end
    end
end