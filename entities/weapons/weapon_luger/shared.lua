AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "P08 Luger"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A accurate, high damage semi-automatic pistol"
SWEP.Slot = 1
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 75

SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/luger/v_pist_p228.mdl"
SWEP.WorldModel = "models/weapons/luger/w_pist_p228.mdl"

SWEP.HoldType = 'pistol'
SWEP.DrawSound = Sound("deagle_deploy")

SWEP.Primary.Sound = Sound("luger_shot")
SWEP.Primary.RPM = 400
SWEP.Primary.ClipSize = 9
SWEP.Primary.DefaultClip = 9
SWEP.Primary.Damage = 33
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "pistol"
SWEP.Primary.Cone = 0.06

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(2.7, -1.5, 2.1)
SWEP.IRONSIGHTSANG = Angle(-0.5, 0, 0)