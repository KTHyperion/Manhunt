AddCSLuaFile()

SWEP.Base = "manhunt_shotgun_base"

BaseFov = 75

SWEP.PrintName = "Browning Auto-5"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A semi-automatic, close-range shotgun"
SWEP.Slot = 3
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 70

SWEP.ViewModel = "models/weapons/auto5/v_brown_auto5.mdl"
SWEP.WorldModel = "models/weapons/auto5/w_browning_auto.mdl"
SWEP.ViewModelFlip = true

SWEP.HoldType = 'shotgun'
SWEP.DrawSound = Sound("auto5_deploy")

SWEP.ReloadSound = Sound("auto5_insert")

SWEP.Primary.Sound = Sound("auto5_shot")
SWEP.Primary.RPM = 120
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Damage = 19
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Cone = 0.07

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(1.95, 0, 1.3)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)

function SWEP:Deploy()
	self:SetDeploySpeed(0.65)
	if not IsValid(self) then return end
	if not IsValid(self.Owner) then return end
	if not self.Owner:IsPlayer() then return end
	
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

	self:SetHoldType(self.HoldType)
	
	local timerName = "ShotgunReload_" ..  self.Owner:UniqueID()
	if (timer.Exists(timerName)) then
		timer.Destroy(timerName)
	end

	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)

	self.Weapon:SetNextPrimaryFire(CurTime() + .25)
	self.Weapon:SetNextSecondaryFire(CurTime() + .25)
	self.ActionDelay = (CurTime() + .25)
	
	self.Owner.NextReload = CurTime() + 1

	return true
end