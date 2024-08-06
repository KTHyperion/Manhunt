AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "AK-47"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A powerful, low accuracy automatic assault rifle"
SWEP.Slot = 2
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 60

SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/ak47/v_rif_ak47.mdl"
SWEP.WorldModel = "models/weapons/ak47/w_rif_ak47.mdl"

SWEP.HoldType = 'ar2'
SWEP.DrawSound = Sound("ak47_draw")

SWEP.Primary.Sound = Sound("ak47_shot")
SWEP.Primary.RPM = 600
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 36
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.005
SWEP.RecoilIncreaseY = 0.005
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Clipsize = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(4.55, -2.6, 1.5)
SWEP.IRONSIGHTSANG = Angle(-1, 0, 0)

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
    timer.Simple(0.1, function()
        self:EmitSound("ak47_MagTap")
    end)
    timer.Simple(0.35, function()
        self:EmitSound("ak47_magout")
    end)
    timer.Simple(1, function()
        self:EmitSound("ak47_magin")
    end)
    timer.Simple(1.8, function()
        self:EmitSound("ak47_bolt")
    end)
    
end