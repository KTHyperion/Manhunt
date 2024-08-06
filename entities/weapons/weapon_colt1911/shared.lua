AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "Colt 1911"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A balanced, semi-automatic pistol"
SWEP.Slot = 1
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 70

SWEP.ViewModel = "models/weapons/colt1911/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/colt1911/w_pist_deagle.mdl"

SWEP.HoldType = 'pistol'
SWEP.DrawSound = Sound("1911_draw")

SWEP.Primary.Sound = Sound("1911_shot")
SWEP.Primary.RPM = 240
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Damage = 35
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0.025

SWEP.RecoilIncreaseX = 0.03
SWEP.RecoilIncreaseY = 0.03
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(-2.605, -2.5, 1.24)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)