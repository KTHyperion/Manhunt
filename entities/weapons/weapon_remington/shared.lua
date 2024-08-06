AddCSLuaFile()

SWEP.Base = "manhunt_scope_base"

BaseFov = 75

SWEP.PrintName = "Remington 7615p"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A pump-action sniper rifle"
SWEP.Slot = 1
SWEP.DrawCrosshair = false
--SWEP.HoldType = "pistol"

SWEP.ViewModelFOV = 60

SWEP.ViewModel = "models/weapons/remington/v_remington_7615p.mdl"
SWEP.WorldModel = "models/weapons/remington/w_remington_7615p.mdl"

SWEP.ViewModelFlip = true

SWEP.HoldType = 'crossbow'
SWEP.DrawSound = ""

SWEP.Primary.Sound = Sound("7615p_shot")
SWEP.Primary.RPM = 55
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Damage = 95
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "SniperRound"
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0
SWEP.RecoilIncreaseY = 0
SWEP.RecoilDecrease = 0

SWEP.ScopeScale = 1
SWEP.ReticleScale = 1
SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 10
SWEP.Secondary.UseACOG			= false
SWEP.Secondary.UseMilDot			= false		
SWEP.Secondary.UseSVD			= true
SWEP.Secondary.UseParabolic		= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex		= false	

SWEP.IRONSIGHTS = Vector(-2.605, -2.5, 1.24)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)

function SWEP:Reload()
    
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
	self:DefaultReload( ACT_VM_RELOAD )

    timer.Simple(0.1, function()
        self:EmitSound("7615p_clipout")
    end)
    timer.Simple(1.2, function()
        self:EmitSound("7615p_clipin")
    end)
    timer.Simple(2, function()
        self:EmitSound("7615p_pump")
    end)
end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end

    -- Play shoot sound
    self:EmitSound(self.Primary.Sound)
    self:ShootBullet(self.Primary.Damage, 1, 0, self.Primary.Ammo, 1, 0)
    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
    
    -- Player view punch
    local owner = self:GetOwner()
    if not owner:IsNPC() then
        owner:ViewPunch(Angle(-0.75, 0, 0))
    end
    -- Recoil
    self:ShootEffects()

    timer.Simple(.6, function()
        self:EmitSound("7615p_pump")
    end)

end