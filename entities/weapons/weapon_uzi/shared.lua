AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "UZI"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A very light, low accuracy machine gun"
SWEP.Slot = 2
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 70

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/uzi/v_smg_mac10.mdl"
SWEP.WorldModel = "models/weapons/uzi/w_uzi_imi.mdl"

SWEP.HoldType = 'smg'
SWEP.DrawSound = Sound("ak47_draw")

SWEP.Primary.Sound = Sound("ak47_shot")
SWEP.Primary.RPM = 800
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 17
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.0005
SWEP.RecoilIncreaseY = 0.0005
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(-2.99, -2, 1.6)
SWEP.IRONSIGHTSANG = Angle(0, -0.85, 0)