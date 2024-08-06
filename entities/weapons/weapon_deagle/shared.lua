AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "Desert Eagle"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A powerful, accurate semi-automatic pistol"
SWEP.Slot = 1
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 70

SWEP.ViewModel = "models/weapons/deagle/v_pist_deagle.mdl"
SWEP.WorldModel = "models/weapons/deagle/w_pist_deagle.mdl"

SWEP.HoldType = 'pistol'
SWEP.DrawSound = Sound("deagle_deploy")

SWEP.Primary.Sound = Sound("deagle_shot")
SWEP.Primary.RPM = 267
SWEP.Primary.ClipSize = 7
SWEP.Primary.DefaultClip = 7
SWEP.Primary.Damage = 53
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0.02

SWEP.RecoilIncreaseX = 0.025
SWEP.RecoilIncreaseY = 0.025
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(-1.71, 0, 0.34)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)