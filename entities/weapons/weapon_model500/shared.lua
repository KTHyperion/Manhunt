AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "S&W Model 500"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A simple, high damage revolver"
SWEP.Slot = 1
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 70

SWEP.ViewModel = "models/weapons/model500/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/model500/w_sw_model_500.mdl"

SWEP.HoldType = 'revolver'
SWEP.DrawSound = Sound("1911_draw")

SWEP.Primary.Sound = Sound("model500_shot")
SWEP.Primary.RPM = 90
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Damage = 75
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.Cone = 0.025

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(-1.92, -2, 0.35)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)

if CLIENT then
	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(0, 0, 0)
			local offsetAng = Angle(180, 90, 0)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			self:SetPos(newPos)
			self:SetAngles(newAng)

            self:SetupBones()
		else
			self:SetPos(self:GetPos())
			self:SetAngles(self:GetAngles())
		end

		self:DrawModel()
	end
end