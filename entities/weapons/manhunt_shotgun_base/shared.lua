AddCSLuaFile()

SWEP.Base = "manhunt_base"

BaseFov = 75

SWEP.PrintName = "Name"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "Flavour text"
SWEP.Slot = 3
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 70

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.DrawSound = Sound("")
SWEP.HoldType = ""

SWEP.ReloadSound = Sound("")

SWEP.Primary.Sound = Sound("")
SWEP.Primary.RPM = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Damage = 17
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Cone = 1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.IronFOV = 90

SWEP.IRONSIGHTS = Vector(0, 0, 0)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)

SWEP.ShotgunReloading		= false
SWEP.ShotgunFinish		= 0.5
SWEP.ShellTime		= 0.35
SWEP.InsertingShell	=		false

SWEP.NextReload	=	0

/*---------------------------------------------------------
   Name: SWEP:Think()
   Desc: Called every frame.
---------------------------------------------------------*/
function SWEP:Think()
	if not IsValid(self) then return end
	if not IsValid(self.Owner) then return end
	if not self.Owner:IsPlayer() then return end
	if self.Owner.NextReload == nil then self.Owner.NextReload = CurTime() + 1 end
	local timerName = "ShotgunReload_" ..  self.Owner:UniqueID()
	--if the owner presses shoot while the timer is in effect, then...
	if (self.Owner:KeyPressed(IN_ATTACK)) and (self.Weapon:GetNextPrimaryFire() <= CurTime()) and (timer.Exists(timerName)) and not (self.Owner:KeyDown(IN_SPEED)) then
		if self:CanPrimaryAttack() then --well first, if we actually can attack, then...
		
			timer.Destroy(timerName) -- kill the timer, and
			self:PrimaryAttack()-- ATTAAAAACK!
			
		end
	end
	
	if self.InsertingShell == true and self.Owner:Alive() then
		vm = self.Owner:GetViewModel()-- its a messy way to do it, but holy shit, it works!
		vm:ResetSequence(vm:LookupSequence("after_reload")) -- Fuck you, garry, why the hell can't I reset a sequence in multiplayer?
		vm:SetPlaybackRate(.01) -- or if I can, why does facepunch have to be such a shitty community, and your wiki have to be an unreadable goddamn mess?
		self.InsertingShell = false -- You get paid for this, what's your excuse?
	end		
end

/*---------------------------------------------------------
   Name: SWEP:Deploy()
   Desc: Whip it out.
---------------------------------------------------------*/
function SWEP:Deploy()
	self:SetDeploySpeed(0.75)
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

/*---------------------------------------------------------
   Name: SWEP:Reload()
   Desc: Reload is being pressed.
---------------------------------------------------------*/
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
					self:EmitSound(self.ReloadSound) 
					self:InsertShell()
				end
			end end)
		end
	
	elseif self.Owner:IsNPC() then
		self.Weapon:DefaultReload(ACT_VM_RELOAD) 
	end
	
end

function SWEP:InsertShell()

	if not IsValid(self) then return end
	if not IsValid(self.Owner) then return end
	if not self.Owner:IsPlayer() then return end
	
	local timerName = "ShotgunReload_" ..  self.Owner:UniqueID()
	if self.Owner:Alive() then
	
		if (self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0) then
		-- if clip is full or ammo is out, then...
			self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH) -- send the pump anim
			timer.Destroy(timerName) -- kill the timer
		elseif (self.Weapon:Clip1() <= self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) >= 0) then
			self.InsertingShell = true --well, I tried!
			timer.Simple( .05, function() self:ShellAnimCaller() end)
			self.Owner:RemoveAmmo(1, self.Primary.Ammo, false) -- out of the frying pan
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1) --  into the fire
		end
	else
		timer.Destroy(timerName) -- kill the timer
	end
	
end

function SWEP:ShellAnimCaller()
	self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
end

function SWEP:ShootBullet( damage, num_bullets, aimcone, ammo_type, force, tracer )

	local owner = self:GetOwner()

	local bullet = {}
	bullet.Num		= num_bullets
	bullet.Src		= owner:GetShootPos()			-- Source
	bullet.Dir		= owner:GetAimVector()			-- Dir of bullet
	bullet.Spread	= Vector( self.Primary.Cone, self.Primary.Cone, 0 )		-- Aim Cone
	bullet.Tracer	= tracer || 5						-- Show a tracer on every x bullets
	bullet.Force	= force || 1						-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = ammo_type || self.Primary.Ammo

	owner:FireBullets( bullet )

	self:ShootEffects()

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

end