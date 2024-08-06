AddCSLuaFile()

SWEP.Base = "manhunt_base"

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

SWEP.ScopeScale = 10
SWEP.Secondary.Clipsize = 0
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.IronFOV = 90
SWEP.Secondary.UseACOG			= false	
SWEP.Secondary.UseMilDot			= false		
SWEP.Secondary.UseSVD			= false	
SWEP.Secondary.UseParabolic		= false	
SWEP.Secondary.UseElcan			= false
SWEP.Secondary.UseGreenDuplex		= false	

SWEP.ReticleScale = 1
SWEP.Secondary.ScopeZoom = 10

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
	
		local iScreenWidth = surface.ScreenWidth()
		local iScreenHeight = surface.ScreenHeight()

		self.ScopeTable = {}
		self.ScopeTable.l = iScreenHeight*self.ScopeScale
		self.ScopeTable.x1 = 0.5*(iScreenWidth + self.ScopeTable.l)
		self.ScopeTable.y1 = 0.5*(iScreenHeight - self.ScopeTable.l)
		self.ScopeTable.x2 = self.ScopeTable.x1
		self.ScopeTable.y2 = 0.5*(iScreenHeight + self.ScopeTable.l)
		self.ScopeTable.x3 = 0.5*(iScreenWidth - self.ScopeTable.l)
		self.ScopeTable.y3 = self.ScopeTable.y2
		self.ScopeTable.x4 = self.ScopeTable.x3
		self.ScopeTable.y4 = self.ScopeTable.y1
		self.ScopeTable.l = (iScreenHeight + 1)*self.ScopeScale -- I don't know why this works, but it does.

		self.QuadTable = {}
		self.QuadTable.x1 = 0
		self.QuadTable.y1 = 0
		self.QuadTable.w1 = iScreenWidth
		self.QuadTable.h1 = 0.5*iScreenHeight - self.ScopeTable.l
		self.QuadTable.x2 = 0
		self.QuadTable.y2 = 0.5*iScreenHeight + self.ScopeTable.l
		self.QuadTable.w2 = self.QuadTable.w1
		self.QuadTable.h2 = self.QuadTable.h1
		self.QuadTable.x3 = 0
		self.QuadTable.y3 = 0
		self.QuadTable.w3 = 0.5*iScreenWidth - self.ScopeTable.l
		self.QuadTable.h3 = iScreenHeight
		self.QuadTable.x4 = 0.5*iScreenWidth + self.ScopeTable.l
		self.QuadTable.y4 = 0
		self.QuadTable.w4 = self.QuadTable.w3
		self.QuadTable.h4 = self.QuadTable.h3

		self.LensTable = {}
		self.LensTable.x = self.QuadTable.w3
		self.LensTable.y = self.QuadTable.h1
		self.LensTable.w = 2*self.ScopeTable.l
		self.LensTable.h = 2*self.ScopeTable.l

		self.ReticleTable = {}
		self.ReticleTable.wdivider = 3.125
		self.ReticleTable.hdivider = 1.7579/self.ReticleScale		-- Draws the texture at 512 when the resolution is 1600x900
		self.ReticleTable.x = (iScreenWidth/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.y = (iScreenHeight/2)-((iScreenHeight/self.ReticleTable.hdivider)/2)
		self.ReticleTable.w = iScreenHeight/self.ReticleTable.hdivider
		self.ReticleTable.h = iScreenHeight/self.ReticleTable.hdivider

		self.FilterTable = {}
		self.FilterTable.wdivider = 3.125
		self.FilterTable.hdivider = 1.7579/1.35	
		self.FilterTable.x = (iScreenWidth/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.y = (iScreenHeight/2)-((iScreenHeight/self.FilterTable.hdivider)/2)
		self.FilterTable.w = iScreenHeight/self.FilterTable.hdivider
		self.FilterTable.h = iScreenHeight/self.FilterTable.hdivider
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

function SWEP:DrawHUD()


	if  self:GetNWBool('Ironsight') and (!self.Owner:KeyDown(IN_SPEED) and !self.Owner:KeyDown(IN_USE)) then

			if self.Secondary.UseACOG then
			-- Draw the FAKE SCOPE THANG
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)

			-- Draw the CHEVRON
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_acogchevron"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

			-- Draw the ACOG REFERENCE LINES
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_acogcross"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)
			end

			if self.Secondary.UseMilDot then
			-- Draw the MIL DOT SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_scopesight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end

			if self.Secondary.UseSVD then
			-- Draw the SVD SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_svdsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end

			if self.Secondary.UseParabolic then
			-- Draw the PARABOLIC SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_parabolicsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end

			if self.Secondary.UseElcan then
			-- Draw the RETICLE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_elcanreticle"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)
			
			-- Draw the ELCAN SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_elcansight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end

			if self.Secondary.UseGreenDuplex then
			-- Draw the RETICLE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_nvgilluminatedduplex"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

			-- Draw the SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			end
			
			if self.Secondary.UseAimpoint then
			-- Draw the RETICLE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/aimpoint"))
			surface.DrawTexturedRect(self.ReticleTable.x, self.ReticleTable.y, self.ReticleTable.w, self.ReticleTable.h)

			-- Draw the SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/gdcw_closedsight"))
			surface.DrawTexturedRect(self.LensTable.x, self.LensTable.y, self.LensTable.w, self.LensTable.h)
			
			end
			
			if self.Secondary.UseMatador then
			
			-- Draw the SCOPE
			surface.SetDrawColor(0, 0, 0, 255)
			surface.SetTexture(surface.GetTextureID("scope/rocketscope"))
			surface.DrawTexturedRect(self.LensTable.x-1, self.LensTable.y, self.LensTable.w, self.LensTable.h)

			end

	end
end

function SWEP:AdjustMouseSensitivity() 
	if self:GetNWBool('Ironsight') then
        return (1/(self.Secondary.ScopeZoom/2))
    else 
    	return 1
    end
end