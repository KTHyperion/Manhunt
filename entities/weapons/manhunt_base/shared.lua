AddCSLuaFile()

SWEP.PrintName = "Name"
SWEP.Spawnable = false
SWEP.AdminSpawnable = false
SWEP.BobScale = 0.2

BaseFov = 75

SWEP.Category = "Hyperion"
SWEP.Author = "Hyperion"
SWEP.Purpose = "Flavour text"
SWEP.Slot = 1
SWEP.DrawCrosshair = false

SWEP.ViewModelFOV = 70

SWEP.ViewModel = ""
SWEP.WorldModel = ""

SWEP.DrawSound = Sound("")
SWEP.HoldType = ""

SWEP.Primary.Sound = Sound("")
SWEP.Primary.RPM = 1
SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Damage = 35
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Cone = 0

SWEP.RecoilIncreaseX = 0.003
SWEP.RecoilIncreaseY = 0.003
SWEP.RecoilDecrease = 0.1

SWEP.Secondary.Clipsize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.IronFOV = 60
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "none"

SWEP.IRONSIGHTS = Vector(0, 0, 0)
SWEP.IRONSIGHTSANG = Angle(0, 0, 0)

function SWEP:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)

	self:SetDeploySpeed(0.75)

	self:SetNWBool('Ironsight', false)
	self:SetNWInt('ConeX', self.Primary.Cone)
	self:SetNWInt('ConeY', self.Primary.Cone)

	self.Reloadaftershoot = 0 				-- Can't reload when firing
	self:SetHoldType(self.HoldType)
	self.OrigCrossHair = self.DrawCrosshair
	if SERVER and self.Owner:IsNPC() then
		self:SetNPCMinBurst(3)			
		self:SetNPCMaxBurst(10)			-- None of this really matters but you need it here anyway
		self:SetNPCFireRate(1)	
		self:SetCurrentWeaponProficiency( WEAPON_PROFICIENCY_VERY_GOOD )
	end
	
	if CLIENT then
	
		if IsValid(self.Owner) and self.Owner:IsPlayer() then
		if self.Owner:Alive() then
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				-- // Init viewmodel visibility
				if (self.ShowViewModel == nil or self.ShowViewModel) then
					vm:SetColor(Color(255,255,255,255))
				else
					-- // however for some reason the view model resets to render mode 0 every frame so we just apply a debug material to prevent it from drawing
					vm:SetMaterial("Debug/hsv")			
				end
			end
			
		end
		end
		
	end
end

function SWEP:Think()
	local ply = self:GetOwner()
	if !IsValid(ply) then return end
	
	if ply:KeyDown( 1 ) and self:GetNWBool('Ironsight') then
		self:SetNWInt('ConeX', self:GetNWInt('ConeX') + (self.RecoilIncreaseX/1.1))
		self:SetNWInt('ConeY', self:GetNWInt('ConeY') + (self.RecoilIncreaseY/1.1))
		return
	end
	if ply:KeyDown( 1 ) and !self:GetNWBool('Ironsight') then
		self:SetNWInt('ConeX', self:GetNWInt('ConeX') + self.RecoilIncreaseX)
		self:SetNWInt('ConeY', self:GetNWInt('ConeY') + self.RecoilIncreaseY)
		return 
	end

	if self:GetNWInt('ConeX') > 0 then
		self:SetNWInt('ConeX', self:GetNWInt('ConeX') - self.RecoilDecrease)
		if self:GetNWInt('ConeX') < 0 then
			self:SetNWInt('ConeX', 0)
		end
	end
	if self:GetNWInt('ConeY') > 0 then
		self:SetNWInt('ConeY', self:GetNWInt('ConeY') - self.RecoilDecrease)
		if self:GetNWInt('ConeY') < 0 then
			self:SetNWInt('ConeY', 0)
		end
	end
	
end

-- Ajuste do WorldModel para a arma aparecer na mão invés da virilha
if CLIENT then
	function SWEP:DrawWorldModel()
		local _Owner = self:GetOwner()

		if (IsValid(_Owner)) then
            -- Specify a good position
			local offsetVec = Vector(0, 0, 0)
			local offsetAng = Angle(180, 180, 0)
			
			local boneid = _Owner:LookupBone("ValveBiped.Bip01_R_Hand") -- Right Hand
			if !boneid then return end

			local matrix = _Owner:GetBoneMatrix(boneid)
			if !matrix then return end

			local newPos, newAng = LocalToWorld(offsetVec, offsetAng, matrix:GetTranslation(), matrix:GetAngles())

			self:SetPos(newPos)
			self:SetAngles(newAng)

            self:SetupBones()
		else
			self:SetPos(self:GetPos())
			self:SetAngles(self:GetAngles())
		end

		self:DrawModel()
	end
end

function SWEP:ShootEffects()

	self.Weapon:SendWeaponAnim( ACT_VM_PRIMARYATTACK )  -- View model animation
	self:GetOwner():MuzzleFlash() -- Crappy muzzle light
	self:GetOwner():SetAnimation( PLAYER_ATTACK1 ) -- 3rd Person Animation

end

function SWEP:ShootBullet( damage, num_bullets, aimcone, ammo_type, force, tracer )

	local owner = self:GetOwner()

	local bullet = {}
	bullet.Num		= num_bullets
	bullet.Src		= owner:GetShootPos()			-- Source
	bullet.Dir		= owner:GetAimVector()			-- Dir of bullet
	bullet.Spread	= Vector( self:GetNWInt('ConeX'), self:GetNWInt('ConeY'), 0 )		-- Aim Cone
	bullet.Tracer	= tracer || 5						-- Show a tracer on every x bullets
	bullet.Force	= force || 1						-- Amount of force to give to phys objects
	bullet.Damage	= damage
	bullet.AmmoType = ammo_type || self.Primary.Ammo

	owner:FireBullets( bullet )

	self:ShootEffects()

end

function SWEP:PrimaryAttack()

	if not self:CanPrimaryAttack() then return end
	if not self:GetOwner():IsValid() then return end

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

end

function SWEP:SecondaryAttack()
    if not IsFirstTimePredicted() then return end

    if self:GetNextSecondaryFire() > CurTime() then return end

    self:SetNextSecondaryFire(CurTime() + 0.3) -- Cooldown between toggles
	if not self:GetNWBool('Ironsight') then
        self:SetNWBool('Ironsight', true)
    else
        self:SetNWBool('Ironsight', false)
    end

	local owner = self:GetOwner()
	local cur_fov = owner:GetFOV()
	
	if SERVER then
        -- Adjust player's movement speed if on server
        if self:GetNWBool('Ironsight') then
            owner:SetWalkSpeed(150) -- Halve walk speed
            owner:SetRunSpeed(150)
			owner:SetFOV(self.Secondary.IronFOV, 0.15)
        else
            -- Restore original movement speed
            owner:SetWalkSpeed(200)
            owner:SetRunSpeed(400)
			owner:SetFOV(BaseFov, 0.15)
        end
    end
end

-- Override CalcViewModelView to adjust view model position
function SWEP:CalcViewModelView(vm, oldPos, oldAng, pos, ang)
    local owner = self:GetOwner()
    if self:GetNWBool('Ironsight') then
        -- Calculate the new position and angle for the view model
        pos = pos + self.IRONSIGHTS.x * ang:Right() + self.IRONSIGHTS.y * ang:Forward() + self.IRONSIGHTS.z * ang:Up()
        ang = ang + self.IRONSIGHTSANG
    elseif not self:GetNWBool('Ironsight') then
        -- Smoothly transition back to default position and angle when not aiming down sights
        pos = LerpVector(FrameTime() * 10, pos, oldPos)
        ang = LerpAngle(FrameTime() * 10, ang, oldAng)
    end

    -- Apply the position and angle adjustments
    return pos, ang
end

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
end

function SWEP:Holster()
	return true
end

function SWEP:Deploy()
	self:SendWeaponAnim(ACT_VM_DRAW)
    self:EmitSound(self.DrawSound)
	self:SetDeploySpeed(0.75)
	return true
end

function SWEP:ShootEffects()

	local owner = self:GetOwner()

	self:SendWeaponAnim( ACT_VM_PRIMARYATTACK )		-- View model animation
	owner:MuzzleFlash()						-- Crappy muzzle light
	owner:SetAnimation( PLAYER_ATTACK1 )		-- 3rd Person Animation

end

function SWEP:CanPrimaryAttack()
	if ( self:Clip1() <= 0 ) then
		self:EmitSound( "Weapon_Pistol.Empty" )
		self:SetNextPrimaryFire( CurTime() + 0.2 )
		self:Reload()
		return false
	end

	return true
end