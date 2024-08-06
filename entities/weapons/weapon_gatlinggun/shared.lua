AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "M134 Gatling Gun"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A extremely high RPM, low accurate machine gun"
SWEP.Slot = 2
SWEP.DrawCrosshair = true

SWEP.ViewModelFOV = 70

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/gatlinggun/v_mach_m249para.mdl"
SWEP.WorldModel = "models/weapons/gatlinggun/w_mach_m249para.mdl"

SWEP.HoldType = 'smg'
SWEP.DrawSound = Sound("ak47_draw")

SWEP.Primary.Sound = Sound("gg_shot")
SWEP.Primary.RPM = 1500
SWEP.Primary.ClipSize = 200
SWEP.Primary.DefaultClip = 200
SWEP.Primary.Damage = 22
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.0008
SWEP.RecoilIncreaseY = 0.0008
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(-4.5, 0, 1)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)