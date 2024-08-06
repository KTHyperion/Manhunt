AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "Raging Bull"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A extremelly strong, high accuracy revolver"
SWEP.Slot = 1
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 70

SWEP.ViewModel = "models/weapons/ragingbull/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/ragingbull/w_pist_deagle.mdl"
SWEP.ViewModelFlip = true

SWEP.HoldType = 'revolver'
SWEP.DrawSound = Sound("rbull_draw")

SWEP.Primary.Sound = Sound("rbull_shot")
SWEP.Primary.RPM = 90
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Damage = 95
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "357"
SWEP.Primary.Cone = 0.025

SWEP.RecoilIncreaseX = 0.03
SWEP.RecoilIncreaseY = 0.03
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(2.77, 0, 0.84)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)

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
    self:EmitSound("rbull_reload")
end