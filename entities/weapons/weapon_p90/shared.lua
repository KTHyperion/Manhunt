AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "P90"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A extremelly high RPM machine gun"
SWEP.Slot = 2
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 65

SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/p90/v_smg_p90.mdl"
SWEP.WorldModel = "models/weapons/p90/w_smg_p90.mdl"

SWEP.HoldType = 'smg'
SWEP.DrawSound = Sound("p90_cock")

SWEP.Primary.Sound = Sound("p90_shot")
SWEP.Primary.RPM = 857
SWEP.Primary.ClipSize = 50
SWEP.Primary.DefaultClip = 50
SWEP.Primary.Damage = 25
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.0008
SWEP.RecoilIncreaseY = 0.0008
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(2.7, -3.5, 1.9)
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

    timer.Simple(0.2, function()
        self:EmitSound("p90_cliprelease")
    end)

    timer.Simple(0.3, function()
        self:EmitSound("p90_magout")
    end)

    timer.Simple(1.55, function()
        self:EmitSound("p90_clipin")
    end)
    
    timer.Simple(2.25, function()
        self:EmitSound("p90_boltpull")
    end)
    
end