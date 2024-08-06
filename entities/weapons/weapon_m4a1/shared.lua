AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "M4A1"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A accurate, automatic assault rifle"
SWEP.Slot = 2
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 75

SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/m4a1/v_m4a1_iron.mdl"
SWEP.WorldModel = "models/weapons/m4a1/w_m4a1_iron.mdl"

SWEP.HoldType = 'ar2'
SWEP.DrawSound = Sound("m4a1_boltpull")

SWEP.Primary.Sound = Sound("m4a1_shot")
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Damage = 38
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.0005
SWEP.RecoilIncreaseY = 0.0005
SWEP.RecoilDecrease = 0.15

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(2.44, -2.5, 0.28)
SWEP.IRONSIGHTSANG = Angle(-0.1, -0.0061, -1)

function SWEP:Reload()

    if self:Clip1() == self.Primary.ClipSize then return end
    if self:Ammo1() == 0 then return end
	
    local owner = self:GetOwner()

	local cur_fov = owner:GetFOV()

	if self:GetNWBool('Ironsight') then
		self:SetNWBool('Ironsight', false)
		owner:SetWalkSpeed(200)
        owner:SetRunSpeed(400)
		owner:SetFOV(BaseFov, 0.15)
	end
	self:DefaultReload( ACT_VM_RELOAD )
    timer.Simple(0.35, function()
        self:EmitSound("m4a1_clipout")
    end)
    timer.Simple(1, function()
        self:EmitSound("m4a1_clipin")
    end)
    timer.Simple(2.4, function()
        self:EmitSound("ak47_MagTap")
    end)
    
end

if CLIENT then
	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(16.5, -0.4, -2.6)
			local offsetAng = Angle(190, 0, 0)
			
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