AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "MP5"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A very light, high RPM machine gun"
SWEP.Slot = 2
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 70

SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/mp5/v_smg_mp5.mdl"
SWEP.WorldModel = "models/weapons/mp5/w_smg_mp5.mdl"

SWEP.HoldType = 'smg'
SWEP.DrawSound = Sound("ak47_draw")

SWEP.Primary.Sound = Sound("mp5_shot")
SWEP.Primary.RPM = 750
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 22
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.0008
SWEP.RecoilIncreaseY = 0.0008
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(2.55, -2.75, 1.1)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)