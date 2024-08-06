AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "M249"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A precise, high RPM machine gun"
SWEP.Slot = 2
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 70

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/m249/v_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/m249/w_mach_m249para.mdl"

SWEP.HoldType = 'smg'
SWEP.DrawSound = Sound("ak47_draw")

SWEP.Primary.Sound = Sound("m249_shot")
SWEP.Primary.RPM = 750
SWEP.Primary.ClipSize = 150
SWEP.Primary.DefaultClip = 150
SWEP.Primary.Damage = 27
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.0008
SWEP.RecoilIncreaseY = 0.0008
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(-4, -2.75, 1.77)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)