AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "Colt Python"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A simple, balanced revolver"
SWEP.Slot = 1
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 70

SWEP.ViewModel = "models/weapons/python/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/python/w_colt_python.mdl"

SWEP.HoldType = 'revolver'
SWEP.DrawSound = Sound("1911_draw")

SWEP.Primary.Sound = Sound("python_shot")
SWEP.Primary.RPM = 120
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Damage = 65
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.Cone = 0.025

SWEP.RecoilIncreaseX = 0.03
SWEP.RecoilIncreaseY = 0.03
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(-2.75, -6, 1.9)
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
        self:EmitSound("python_clipdraw")
    end)
    timer.Simple(0.75, function()
        self:EmitSound("python_bulletsout")
    end)
    timer.Simple(2, function()
        self:EmitSound("python_bulletsin")
    end)
    timer.Simple(2.5, function()
        self:EmitSound("python_unfold")
    end)
    timer.Simple(2.7, function()
        self:EmitSound("python_spin")
    end)
end