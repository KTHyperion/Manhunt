AddCSLuaFile()

SWEP.Base = "manhunt_shotgun_base"

BaseFov = 75

SWEP.PrintName = "Benelli M3"
SWEP.Spawnable = true
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "A pump-action shotgun"
SWEP.Slot = 3
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 70

SWEP.ViewModel = "models/weapons/m3/v_benelli_m3_s90.mdl"
SWEP.WorldModel = "models/weapons/m3/w_benelli_m3.mdl"
SWEP.ViewModelFlip = true

SWEP.HoldType = 'shotgun'
SWEP.DrawSound = Sound("1911_draw")

SWEP.ReloadSound = Sound("m3_insertshell")

SWEP.Primary.Sound = Sound("m3_shot")
SWEP.Primary.RPM = 55
SWEP.Primary.ClipSize = 8
SWEP.Primary.DefaultClip = 8
SWEP.Primary.Damage = 17
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = "Buckshot"
SWEP.Primary.Cone = 0.07

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.IronFOV = 60

SWEP.IRONSIGHTS = Vector(2.27, 0, 1.3)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)

function SWEP:Deploy()
	self:SetDeploySpeed(1.5)
    timer.Simple(0.15, function()
        self:EmitSound("m3_pump")
    end)
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

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end

    -- Play shoot sound
    self:EmitSound(self.Primary.Sound)
    self:ShootBullet(self.Primary.Damage, 9, 0, self.Primary.Ammo, 1, 0)
    self:TakePrimaryAmmo(1)
    self:SetNextPrimaryFire(CurTime() + 1 / (self.Primary.RPM / 60))
    
    -- Player view punch
    local owner = self:GetOwner()
    if not owner:IsNPC() then
        owner:ViewPunch(Angle(-0.75, 0, 0))
    end
    -- Recoil
    self:ShootEffects()

    timer.Simple(0.45, function()
        self:EmitSound("m3_pump")
    end)
end

function SWEP:Reload()

	if not IsValid(self) then return end
	if not IsValid(self.Owner) then return end
	if not self.Owner:IsPlayer() then return end

	if self:Clip1() == self.Primary.ClipSize then return end
    if self:Ammo1() == 0 then return end

	local maxcap = self.Primary.ClipSize
	local spaceavail = self.Weapon:Clip1()
	local shellz = (maxcap) - (spaceavail) + 1

	if (timer.Exists("ShotgunReload_" ..  self.Owner:UniqueID())) or self.Owner.NextReload > CurTime() or maxcap == spaceavail then return end
	
	if self.Owner:IsPlayer() then 

		if self.Weapon:GetNextPrimaryFire() <= (CurTime()+2) then
			self.Weapon:SetNextPrimaryFire(CurTime() + 2) -- wait TWO seconds before you can shoot again
		end
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START) -- sending start reload anim
		self.Owner:SetAnimation( PLAYER_RELOAD )
		
		self.Owner.NextReload = CurTime() + 1
	
		local owner = self:GetOwner()
		local cur_fov = owner:GetFOV()
	
		if self:GetNWBool('Ironsight') then
			self:SetNWBool('Ironsight', false)
			owner:SetWalkSpeed(200)
			owner:SetRunSpeed(400)
			owner:SetFOV(BaseFov, 0.15)
		end
	
		if SERVER and self.Owner:Alive() then   
			local timerName = "ShotgunReload_" ..  self.Owner:UniqueID()
			timer.Create(timerName, 
			(self.ShellTime + .05), 
			shellz,
			function() if not IsValid(self) then return end 
			    if IsValid(self.Owner) and IsValid(self.Weapon) then 
				    if self.Owner:Alive() then
                        self:InsertShell()
					    self:EmitSound(self.ReloadSound) 
				    end
			    end
            end)
		end
	
	elseif self.Owner:IsNPC() then
		self.Weapon:DefaultReload(ACT_VM_RELOAD) 
	end
	
end