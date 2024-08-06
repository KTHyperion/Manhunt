AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "FN FAL"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A semi-automatic, high accuracy assault rifle"
SWEP.Slot = 2
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 65

SWEP.ViewModelFlip = false
SWEP.ViewModel = "models/weapons/fnfal/v_rif_galil.mdl"
SWEP.WorldModel = "models/weapons/fnfal/w_rif_galil.mdl"

SWEP.HoldType = 'ar2'
SWEP.DrawSound = Sound("ak47_draw")

SWEP.Primary.Sound = Sound("fnfal_shot")
SWEP.Primary.RPM = 759
SWEP.Primary.ClipSize = 20
SWEP.Primary.DefaultClip = 20
SWEP.Primary.Damage = 55
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "AR2"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.02
SWEP.RecoilIncreaseY = 0.02
SWEP.RecoilDecrease = 0.025

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(-3.164, -2.6, 1.295)
SWEP.IRONSIGHTSANG = Angle(-0, 0, 0)