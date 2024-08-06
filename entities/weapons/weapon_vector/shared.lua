AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "KRISS Vector"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A extremelly accurate, high RPM machine gun"
SWEP.Slot = 2
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 70

SWEP.ViewModelFlip = true
SWEP.ViewModel = "models/weapons/vector/v_smg_ump45.mdl"
SWEP.WorldModel = "models/weapons/vector/w_smg_ump45.mdl"

SWEP.HoldType = 'smg'
SWEP.DrawSound = Sound("ak47_draw")

SWEP.Primary.Sound = Sound("vector_shot")
SWEP.Primary.RPM = 750
SWEP.Primary.ClipSize = 30
SWEP.Primary.DefaultClip = 30
SWEP.Primary.Damage = 18
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "smg1"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.0005
SWEP.RecoilIncreaseY = 0.0005
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(4.0, -2.6, 1.9)
SWEP.IRONSIGHTSANG = Angle(0, 0.875, 0)