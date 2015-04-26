// By FailCake :D (edunad)
// A simple Thirdperson Addon. Press C (context menu) then Thirdperson

if CLIENT then
	CreateClientConVar( "simple_thirdperson_enabled", "0", true, false )
	
	CreateClientConVar( "simple_thirdperson_smooth", "1", true, false )
	CreateClientConVar( "simple_thirdperson_smooth_mult_x", "0.3", true, false )
	CreateClientConVar( "simple_thirdperson_smooth_mult_y", "0.3", true, false )
	CreateClientConVar( "simple_thirdperson_smooth_mult_z", "0.3", true, false )
	CreateClientConVar( "simple_thirdperson_smooth_delay", "10", true, false )
	
	CreateClientConVar( "simple_thirdperson_collision", "1", true, false )
	CreateClientConVar( "simple_thirdperson_cam_distance", "100", true, false )
	CreateClientConVar( "simple_thirdperson_cam_right", "0", true, false )
	CreateClientConVar( "simple_thirdperson_cam_up", "0", true, false )
	
	CreateClientConVar( "simple_thirdperson_cam_pitch", "0", true, false )
	CreateClientConVar( "simple_thirdperson_cam_yaw", "0", true, false )
	
	CreateClientConVar( "simple_thirdperson_shoulderview_dist", "50", true, false )
	CreateClientConVar( "simple_thirdperson_shoulderview_up", "0", true, false )
	CreateClientConVar( "simple_thirdperson_shoulderview_right", "40", true, false )
	CreateClientConVar( "simple_thirdperson_shoulderview", "0", true, false )
	CreateClientConVar( "simple_thirdperson_shoulderview_bump", "1", true, false )
	
	CreateClientConVar( "simple_thirdperson_fov_smooth", "1", true, false )
	CreateClientConVar( "simple_thirdperson_fov_smooth_mult", "0.3", true, false )
end

if CLIENT then	
	
	local Editor = {}

	Editor.DelayPos = nil
	Editor.ViewPos = nil
	
	Editor.ShoulderToggle = GetConVar( "simple_thirdperson_shoulderview" ):GetBool()
	Editor.EnableToggle = GetConVar( "simple_thirdperson_enabled" ):GetBool()
	Editor.CollisionToggle = GetConVar( "simple_thirdperson_collision" ):GetBool()
	Editor.FOVToggle = GetConVar( "simple_thirdperson_fov_smooth" ):GetBool()
	Editor.SmoothToggle = GetConVar( "simple_thirdperson_smooth" ):GetBool()
	Editor.ShoulderBumpToggle = GetConVar( "simple_thirdperson_shoulderview_bump" ):GetBool()
	
	list.Set(
		"DesktopWindows", 
		"ThirdPerson",
		{
			title = "Simple Third Person",
			icon = "icon32/zoom_extend.png",
			width = 300,
			height = 170,
			onewindow = true,
			init = function(icn, pnl)
				
				Editor.PANEL = pnl
				Editor.PANEL:SetPos(ScrW() - 310,40)
				
				Editor.PANEL.Sheet = Editor.PANEL:Add( "DPropertySheet" )
				Editor.PANEL.Sheet:Dock(LEFT)
				Editor.PANEL.Sheet:SetSize( 290, 0 )
				Editor.PANEL.Sheet:SetPos(5,0)
				
				Editor.PANEL.Settings = Editor.PANEL.Sheet:Add( "DPanelSelect" )
				Editor.PANEL.Sheet:AddSheet( "Settings", Editor.PANEL.Settings, "icon16/cog_edit.png" )
				
				Editor.PANEL.CameraSettings = Editor.PANEL.Sheet:Add( "DPanelSelect" )
				Editor.PANEL.Sheet:AddSheet( "Camera", Editor.PANEL.CameraSettings, "icon16/camera_edit.png" )
				
				Editor.PANEL.SmoothSettings = Editor.PANEL.Sheet:Add( "DPanelSelect" )
				Editor.PANEL.Sheet:AddSheet( "Smooth", Editor.PANEL.SmoothSettings, "icon16/chart_line.png" )
				
				Editor.PANEL.ShoulderSettings = Editor.PANEL.Sheet:Add( "DPanelSelect" )
				Editor.PANEL.Sheet:AddSheet( "Shoulder", Editor.PANEL.ShoulderSettings, "icon16/camera_go.png" )
				
				
				Editor.PANEL.EnableThrd = Editor.PANEL.Settings:Add( "DButton" )
				Editor.PANEL.EnableThrd:SizeToContents()
				
				if Editor.EnableToggle then
					Editor.PANEL.EnableThrd:SetText("Disable ThirdPerson")
					Editor.PANEL.EnableThrd:SetTextColor(Color(150,0,0))
				else
					Editor.PANEL.EnableThrd:SetText("Enable ThirdPerson")
					Editor.PANEL.EnableThrd:SetTextColor(Color(0,150,0))
				end
				
				Editor.PANEL.EnableThrd:SetPos(10,6)
				Editor.PANEL.EnableThrd:SetSize(250,20)
				Editor.PANEL.EnableThrd.DoClick = function()

					Editor.EnableToggle = !Editor.EnableToggle
					RunConsoleCommand("simple_thirdperson_enabled",BoolToInt(Editor.EnableToggle))
					
					if Editor.EnableToggle then
						Editor.PANEL.EnableThrd:SetText("Disable ThirdPerson")
						Editor.PANEL.EnableThrd:SetTextColor(Color(150,0,0))
					else
						Editor.PANEL.EnableThrd:SetText("Enable ThirdPerson")
						Editor.PANEL.EnableThrd:SetTextColor(Color(0,150,0))
					end
							
				end

				Editor.PANEL.Lbl_SPLIT = Editor.PANEL.Settings:Add("DLabel")
				Editor.PANEL.Lbl_SPLIT:SetPos(20,29)
				Editor.PANEL.Lbl_SPLIT:SetText("------------------------ RESETS ------------------------")
				Editor.PANEL.Lbl_SPLIT:SizeToContents() 
			
				Editor.PANEL.ResetCam = Editor.PANEL.Settings:Add( "DButton" )
				Editor.PANEL.ResetCam:SizeToContents()
				Editor.PANEL.ResetCam:SetText("Camera Reset")
				Editor.PANEL.ResetCam:SetPos(10,46)
				Editor.PANEL.ResetCam:SetSize(120,20)
				Editor.PANEL.ResetCam.DoClick = function()
					RunConsoleCommand("simple_thirdperson_cam_distance",100)
					RunConsoleCommand("simple_thirdperson_cam_right",0)
					RunConsoleCommand("simple_thirdperson_cam_up",0)
					RunConsoleCommand("simple_thirdperson_cam_yaw",0)
					RunConsoleCommand("simple_thirdperson_cam_pitch",0)
					chat.AddText(Color(255,255,255),"[",Color(255,155,0),"Simple ThirdPerson",Color(255,255,255),"] Camera Reset !")
					Editor.PANEL:Close()
				end
				
				Editor.PANEL.ResetShoulder = Editor.PANEL.Settings:Add( "DButton" )
				Editor.PANEL.ResetShoulder:SizeToContents()
				Editor.PANEL.ResetShoulder:SetText("ShoulderView Reset")
				Editor.PANEL.ResetShoulder:SetPos(140,46)
				Editor.PANEL.ResetShoulder:SetSize(120,20)
				Editor.PANEL.ResetShoulder.DoClick = function()
					RunConsoleCommand("simple_thirdperson_shoulderview_dist",50)
					RunConsoleCommand("simple_thirdperson_shoulderview_up",0)
					RunConsoleCommand("simple_thirdperson_shoulderview_right",40)
					chat.AddText(Color(255,255,255),"[",Color(255,155,0),"Simple ThirdPerson",Color(255,255,255),"] ShoulderView Reset !")
					Editor.PANEL:Close()
				end
				
				Editor.PANEL.ResetSmooth = Editor.PANEL.Settings:Add( "DButton" )
				Editor.PANEL.ResetSmooth:SizeToContents()
				Editor.PANEL.ResetSmooth:SetText("Smooth Settings Reset")
				Editor.PANEL.ResetSmooth:SetPos(10,76)
				Editor.PANEL.ResetSmooth:SetSize(130,20)
				Editor.PANEL.ResetSmooth.DoClick = function()
					RunConsoleCommand("simple_thirdperson_smooth",1)
					RunConsoleCommand("simple_thirdperson_smooth_mult_x",0.3)
					RunConsoleCommand("simple_thirdperson_smooth_mult_y",0.3)
					RunConsoleCommand("simple_thirdperson_smooth_mult_z",0.3)
					RunConsoleCommand("simple_thirdperson_smooth_delay",10)
					chat.AddText(Color(255,255,255),"[",Color(255,155,0),"Simple ThirdPerson",Color(255,255,255),"] Smooth Reset !")
					Editor.PANEL:Close()
				end
				
				Editor.PANEL.ResetFOV = Editor.PANEL.Settings:Add( "DButton" )
				Editor.PANEL.ResetFOV:SizeToContents()
				Editor.PANEL.ResetFOV:SetText("FOV Settings Reset")
				Editor.PANEL.ResetFOV:SetPos(145,76)
				Editor.PANEL.ResetFOV:SetSize(115,20)
				Editor.PANEL.ResetFOV.DoClick = function()
					RunConsoleCommand("simple_thirdperson_fov_smooth",1)
					RunConsoleCommand("simple_thirdperson_fov_smooth_mult",0.3)
					chat.AddText(Color(255,255,255),"[",Color(255,155,0),"Simple ThirdPerson",Color(255,255,255),"] FOV Reset !")
					Editor.PANEL:Close()
				end
				
				
				// ---------------- PANEL CAMERA ---------------- //
				
				Editor.PANEL.CollisionButton = Editor.PANEL.CameraSettings:Add( "DButton" )
				Editor.PANEL.CollisionButton:SizeToContents()
				
					if Editor.CollisionToggle then
						Editor.PANEL.CollisionButton:SetText("Disable Camera Collision")
						Editor.PANEL.CollisionButton:SetTextColor(Color(150,0,0))
					else
						Editor.PANEL.CollisionButton:SetText("Enable Camera Collision")
						Editor.PANEL.CollisionButton:SetTextColor(Color(0,150,0))
					end
					
				Editor.PANEL.CollisionButton:SetText("Toggle Camera Collision")
				Editor.PANEL.CollisionButton:SetPos(10,6)
				Editor.PANEL.CollisionButton:SetSize(250,20)
				Editor.PANEL.CollisionButton.DoClick = function()
				
					Editor.CollisionToggle = !Editor.CollisionToggle
					RunConsoleCommand("simple_thirdperson_collision",BoolToInt(Editor.CollisionToggle))	
					
					if Editor.CollisionToggle then
						Editor.PANEL.CollisionButton:SetText("Disable Camera Collision")
						Editor.PANEL.CollisionButton:SetTextColor(Color(150,0,0))
					else
						Editor.PANEL.CollisionButton:SetText("Enable Camera Collision")
						Editor.PANEL.CollisionButton:SetTextColor(Color(0,150,0))
					end
										
				end
				
				Editor.PANEL.CamDistanceTxt = Editor.PANEL.CameraSettings:Add("DLabel")
				Editor.PANEL.CamDistanceTxt:SetPos(10,35)
				Editor.PANEL.CamDistanceTxt:SetText("Camera Distance : ")
				Editor.PANEL.CamDistanceTxt:SizeToContents() 
				
				Editor.PANEL.CamDistanceLb = Editor.PANEL.CameraSettings:Add("DTextEntry")
				Editor.PANEL.CamDistanceLb:SetPos(110,30)
				Editor.PANEL.CamDistanceLb:SetValue(GetConVar( "simple_thirdperson_cam_distance" ):GetInt())
				Editor.PANEL.CamDistanceLb:SizeToContents()
				Editor.PANEL.CamDistanceLb:SetNumeric(true)
				Editor.PANEL.CamDistanceLb:SetUpdateOnType( true )
				Editor.PANEL.CamDistanceLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_cam_distance",Editor.PANEL.CamDistanceLb:GetValue())
				end
				
				Editor.PANEL.CamYawTxt = Editor.PANEL.CameraSettings:Add("DLabel")
				Editor.PANEL.CamYawTxt:SetPos(150,62)
				Editor.PANEL.CamYawTxt:SetText("| Yaw : ")
				Editor.PANEL.CamYawTxt:SizeToContents() 
				
				Editor.PANEL.CamYawLb = Editor.PANEL.CameraSettings:Add("DTextEntry")
				Editor.PANEL.CamYawLb:SetPos(190,57)
				Editor.PANEL.CamYawLb:SetValue(GetConVar( "simple_thirdperson_cam_yaw" ):GetInt())
				Editor.PANEL.CamYawLb:SizeToContents()
				Editor.PANEL.CamYawLb:SetNumeric(true)
				Editor.PANEL.CamYawLb:SetUpdateOnType( true )
				Editor.PANEL.CamYawLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_cam_yaw",Editor.PANEL.CamYawLb:GetValue())
				end

				Editor.PANEL.CamPitchTxt = Editor.PANEL.CameraSettings:Add("DLabel")
				Editor.PANEL.CamPitchTxt:SetPos(160,85)
				Editor.PANEL.CamPitchTxt:SetText("| Pitch : ")
				Editor.PANEL.CamPitchTxt:SizeToContents() 
				
				Editor.PANEL.CamPitchLb = Editor.PANEL.CameraSettings:Add("DTextEntry")
				Editor.PANEL.CamPitchLb:SetPos(200,80)
				Editor.PANEL.CamPitchLb:SetValue(GetConVar( "simple_thirdperson_cam_pitch" ):GetInt())
				Editor.PANEL.CamPitchLb:SizeToContents()
				Editor.PANEL.CamPitchLb:SetNumeric(true)
				Editor.PANEL.CamPitchLb:SetUpdateOnType( true )
				Editor.PANEL.CamPitchLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_cam_pitch",Editor.PANEL.CamPitchLb:GetValue())
				end
				
				Editor.PANEL.CamUpTxt = Editor.PANEL.CameraSettings:Add("DLabel")
				Editor.PANEL.CamUpTxt:SetPos(10,62)
				Editor.PANEL.CamUpTxt:SetText("Camera Up : ")
				Editor.PANEL.CamUpTxt:SizeToContents() 
				
				Editor.PANEL.CamUpTxtLB = Editor.PANEL.CameraSettings:Add("DTextEntry")
				Editor.PANEL.CamUpTxtLB:SetPos(80,57)
				Editor.PANEL.CamUpTxtLB:SetValue(GetConVar( "simple_thirdperson_cam_up" ):GetInt())
				Editor.PANEL.CamUpTxtLB:SizeToContents()
				Editor.PANEL.CamUpTxtLB:SetNumeric(true)
				Editor.PANEL.CamUpTxtLB:SetUpdateOnType( true )
				Editor.PANEL.CamUpTxtLB.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_cam_up",Editor.PANEL.CamUpTxtLB:GetValue())
				end
				
				Editor.PANEL.CamLeftTxt = Editor.PANEL.CameraSettings:Add("DLabel")
				Editor.PANEL.CamLeftTxt:SetPos(10,85)
				Editor.PANEL.CamLeftTxt:SetText("Camera Right : ")
				Editor.PANEL.CamLeftTxt:SizeToContents() 
				
				Editor.PANEL.CamLeftTxtLB = Editor.PANEL.CameraSettings:Add("DTextEntry")
				Editor.PANEL.CamLeftTxtLB:SetPos(90,80)
				Editor.PANEL.CamLeftTxtLB:SetValue(GetConVar( "simple_thirdperson_cam_right" ):GetInt())
				Editor.PANEL.CamLeftTxtLB:SizeToContents()
				Editor.PANEL.CamLeftTxtLB:SetNumeric(true)
				Editor.PANEL.CamLeftTxtLB:SetUpdateOnType( true )
				Editor.PANEL.CamLeftTxtLB.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_cam_right",Editor.PANEL.CamLeftTxtLB:GetValue())
				end
				
				// ---------------- PANEL SMOOTH ---------------- //
				
				Editor.PANEL.SmoothButton = Editor.PANEL.SmoothSettings:Add( "DButton" )
				Editor.PANEL.SmoothButton:SizeToContents()
				
				if Editor.SmoothToggle then
					Editor.PANEL.SmoothButton:SetText("Disable Camera Smoothing")
					Editor.PANEL.SmoothButton:SetTextColor(Color(150,0,0))
				else
					Editor.PANEL.SmoothButton:SetText("Enable Camera Smoothing")
					Editor.PANEL.SmoothButton:SetTextColor(Color(0,150,0))
				end

				Editor.PANEL.SmoothButton:SetPos(10,6)
				Editor.PANEL.SmoothButton:SetSize(250,20)
				Editor.PANEL.SmoothButton.DoClick = function()
					Editor.SmoothToggle = !Editor.SmoothToggle
					RunConsoleCommand("simple_thirdperson_smooth",BoolToInt(Editor.SmoothToggle))	

					if Editor.SmoothToggle then
						Editor.PANEL.SmoothButton:SetText("Disable Camera Smoothing")
						Editor.PANEL.SmoothButton:SetTextColor(Color(150,0,0))
					else
						Editor.PANEL.SmoothButton:SetText("Enable Camera Smoothing")
						Editor.PANEL.SmoothButton:SetTextColor(Color(0,150,0))
					end					
				end
				
				Editor.PANEL.SmoothFOVButton = Editor.PANEL.SmoothSettings:Add( "DButton" )
				Editor.PANEL.SmoothFOVButton:SizeToContents()
				
				if Editor.FOVToggle then
					Editor.PANEL.SmoothFOVButton:SetText("Disable FOV Smoothing")
					Editor.PANEL.SmoothFOVButton:SetTextColor(Color(150,0,0))
				else
					Editor.PANEL.SmoothFOVButton:SetText("Enable FOV Smoothing")
					Editor.PANEL.SmoothFOVButton:SetTextColor(Color(0,150,0))
				end
				
				Editor.PANEL.SmoothFOVButton:SetPos(10,30)
				Editor.PANEL.SmoothFOVButton:SetSize(250,20)
				Editor.PANEL.SmoothFOVButton.DoClick = function()
					Editor.FOVToggle = !Editor.FOVToggle
					RunConsoleCommand("simple_thirdperson_fov_smooth",BoolToInt(Editor.FOVToggle))

					if Editor.FOVToggle then
						Editor.PANEL.SmoothFOVButton:SetText("Disable FOV Smoothing")
						Editor.PANEL.SmoothFOVButton:SetTextColor(Color(150,0,0))
					else
						Editor.PANEL.SmoothFOVButton:SetText("Enable FOV Smoothing")
						Editor.PANEL.SmoothFOVButton:SetTextColor(Color(0,150,0))
					end					
				end
				
				Editor.PANEL.CamSmoothDeTxt = Editor.PANEL.SmoothSettings:Add("DLabel")
				Editor.PANEL.CamSmoothDeTxt:SetPos(10,60)
				Editor.PANEL.CamSmoothDeTxt:SetText("Smooth Delay : ")
				Editor.PANEL.CamSmoothDeTxt:SizeToContents() 
				
				Editor.PANEL.CamSmoDelayLb = Editor.PANEL.SmoothSettings:Add("DTextEntry")
				Editor.PANEL.CamSmoDelayLb:SetPos(90,55)
				Editor.PANEL.CamSmoDelayLb:SetValue(GetConVar( "simple_thirdperson_smooth_delay" ):GetFloat())
				Editor.PANEL.CamSmoDelayLb:SizeToContents()
				Editor.PANEL.CamSmoDelayLb:SetNumeric(true)
				Editor.PANEL.CamSmoDelayLb:SetUpdateOnType( true )
				Editor.PANEL.CamSmoDelayLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_smooth_delay",Editor.PANEL.CamSmoDelayLb:GetValue())
				end
				
				Editor.PANEL.CamSmoothMultXTxt = Editor.PANEL.SmoothSettings:Add("DLabel")
				Editor.PANEL.CamSmoothMultXTxt:SetPos(160,60)
				Editor.PANEL.CamSmoothMultXTxt:SetText("| Mult X : ")
				Editor.PANEL.CamSmoothMultXTxt:SizeToContents() 
				
				Editor.PANEL.CamSmoothMultXTxtLb = Editor.PANEL.SmoothSettings:Add("DTextEntry")
				Editor.PANEL.CamSmoothMultXTxtLb:SetPos(210,55)
				Editor.PANEL.CamSmoothMultXTxtLb:SetValue(math.Round(GetConVar( "simple_thirdperson_smooth_mult_x" ):GetFloat(),2))
				Editor.PANEL.CamSmoothMultXTxtLb:SizeToContents()
				Editor.PANEL.CamSmoothMultXTxtLb:SetNumeric(true)
				Editor.PANEL.CamSmoothMultXTxtLb:SetUpdateOnType( true )
				Editor.PANEL.CamSmoothMultXTxtLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_smooth_mult_x",Editor.PANEL.CamSmoothMultXTxtLb:GetValue())
				end
				
				Editor.PANEL.CamSmoothMultYTxt = Editor.PANEL.SmoothSettings:Add("DLabel")
				Editor.PANEL.CamSmoothMultYTxt:SetPos(10,85)
				Editor.PANEL.CamSmoothMultYTxt:SetText("Mult Y : ")
				Editor.PANEL.CamSmoothMultYTxt:SizeToContents() 
				
				Editor.PANEL.CamSmoothMultYTxtLb = Editor.PANEL.SmoothSettings:Add("DTextEntry")
				Editor.PANEL.CamSmoothMultYTxtLb:SetPos(50,80)
				Editor.PANEL.CamSmoothMultYTxtLb:SetValue(math.Round(GetConVar( "simple_thirdperson_smooth_mult_y" ):GetFloat(),2))
				Editor.PANEL.CamSmoothMultYTxtLb:SizeToContents()
				Editor.PANEL.CamSmoothMultYTxtLb:SetNumeric(true)
				Editor.PANEL.CamSmoothMultYTxtLb:SetUpdateOnType( true )
				Editor.PANEL.CamSmoothMultYTxtLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_smooth_mult_y",Editor.PANEL.CamSmoothMultYTxtLb:GetValue())
				end
				
				Editor.PANEL.CamSmoothMultZTxt = Editor.PANEL.SmoothSettings:Add("DLabel")
				Editor.PANEL.CamSmoothMultZTxt:SetPos(120,85)
				Editor.PANEL.CamSmoothMultZTxt:SetText("| Mult Z : ")
				Editor.PANEL.CamSmoothMultZTxt:SizeToContents() 
				
				Editor.PANEL.CamSmoothMultZTxtLb = Editor.PANEL.SmoothSettings:Add("DTextEntry")
				Editor.PANEL.CamSmoothMultZTxtLb:SetPos(170,80)
				Editor.PANEL.CamSmoothMultZTxtLb:SetValue(math.Round(GetConVar( "simple_thirdperson_smooth_mult_z" ):GetFloat(),2))
				Editor.PANEL.CamSmoothMultZTxtLb:SizeToContents()
				Editor.PANEL.CamSmoothMultZTxtLb:SetNumeric(true)
				Editor.PANEL.CamSmoothMultZTxtLb:SetUpdateOnType( true )
				Editor.PANEL.CamSmoothMultZTxtLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_smooth_mult_z",Editor.PANEL.CamSmoothMultZTxtLb:GetValue())
				end
				
				// ---------------- PANEL SHOULDERVIEW ---------------- //
				
				Editor.PANEL.ShoulderButton = Editor.PANEL.ShoulderSettings:Add( "DButton" )
				Editor.PANEL.ShoulderButton:SizeToContents()
				
				if Editor.ShoulderToggle then
						Editor.PANEL.ShoulderButton:SetText("Disable ShoulderView")
						Editor.PANEL.ShoulderButton:SetTextColor(Color(150,0,0))
					else
						Editor.PANEL.ShoulderButton:SetText("Enable ShoulderView")
						Editor.PANEL.ShoulderButton:SetTextColor(Color(0,150,0))
				end		
				
				Editor.PANEL.ShoulderButton:SetPos(10,6)
				Editor.PANEL.ShoulderButton:SetSize(250,20)
				Editor.PANEL.ShoulderButton.DoClick = function()
					Editor.ShoulderToggle = !Editor.ShoulderToggle
					RunConsoleCommand("simple_thirdperson_shoulderview",BoolToInt(Editor.ShoulderToggle))
					if Editor.ShoulderToggle then
						Editor.PANEL.ShoulderButton:SetText("Disable ShoulderView")
						Editor.PANEL.ShoulderButton:SetTextColor(Color(150,0,0))
					else
						Editor.PANEL.ShoulderButton:SetText("Enable ShoulderView")
						Editor.PANEL.ShoulderButton:SetTextColor(Color(0,150,0))
					end						
				end
				
				Editor.PANEL.ShoulderBumpButton = Editor.PANEL.ShoulderSettings:Add( "DButton" )
				Editor.PANEL.ShoulderBumpButton:SizeToContents()
				
				if Editor.ShoulderBumpToggle then
						Editor.PANEL.ShoulderBumpButton:SetText("Disable ShoulderView Bump")
						Editor.PANEL.ShoulderBumpButton:SetTextColor(Color(150,0,0))
				else
						Editor.PANEL.ShoulderBumpButton:SetText("Enable ShoulderView Bump")
						Editor.PANEL.ShoulderBumpButton:SetTextColor(Color(0,150,0))
				end	
				
				Editor.PANEL.ShoulderBumpButton:SetPos(10,30)
				Editor.PANEL.ShoulderBumpButton:SetSize(250,20)
				Editor.PANEL.ShoulderBumpButton.DoClick = function()
					Editor.ShoulderBumpToggle = !Editor.ShoulderBumpToggle
					RunConsoleCommand("simple_thirdperson_shoulderview_bump",BoolToInt(Editor.ShoulderBumpToggle))	
					if Editor.ShoulderBumpToggle then
							Editor.PANEL.ShoulderBumpButton:SetText("Disable ShoulderView Bump")
							Editor.PANEL.ShoulderBumpButton:SetTextColor(Color(150,0,0))
					else
							Editor.PANEL.ShoulderBumpButton:SetText("Enable ShoulderView Bump")
							Editor.PANEL.ShoulderBumpButton:SetTextColor(Color(0,150,0))
					end						
				end
				
				Editor.PANEL.ShoulderDistTxt = Editor.PANEL.ShoulderSettings:Add("DLabel")
				Editor.PANEL.ShoulderDistTxt:SetPos(10,60)
				Editor.PANEL.ShoulderDistTxt:SetText("Shoulder Dist : ")
				Editor.PANEL.ShoulderDistTxt:SizeToContents() 
				
				Editor.PANEL.ShoulderDistLb = Editor.PANEL.ShoulderSettings:Add("DTextEntry")
				Editor.PANEL.ShoulderDistLb:SetPos(90,55)
				Editor.PANEL.ShoulderDistLb:SetValue(GetConVar( "simple_thirdperson_shoulderview_dist" ):GetFloat())
				Editor.PANEL.ShoulderDistLb:SizeToContents()
				Editor.PANEL.ShoulderDistLb:SetNumeric(true)
				Editor.PANEL.ShoulderDistLb:SetUpdateOnType( true )
				Editor.PANEL.ShoulderDistLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_shoulderview_dist",Editor.PANEL.ShoulderDistLb:GetValue())
				end
				
				Editor.PANEL.ShoulderUPTxt = Editor.PANEL.ShoulderSettings:Add("DLabel")
				Editor.PANEL.ShoulderUPTxt:SetPos(10,85)
				Editor.PANEL.ShoulderUPTxt:SetText("Shoulder Up : ")
				Editor.PANEL.ShoulderUPTxt:SizeToContents() 
				
				Editor.PANEL.ShoulderUpLb = Editor.PANEL.ShoulderSettings:Add("DTextEntry")
				Editor.PANEL.ShoulderUpLb:SetPos(80,80)
				Editor.PANEL.ShoulderUpLb:SetValue(GetConVar( "simple_thirdperson_shoulderview_up" ):GetFloat())
				Editor.PANEL.ShoulderUpLb:SizeToContents()
				Editor.PANEL.ShoulderUpLb:SetNumeric(true)
				Editor.PANEL.ShoulderUpLb:SetUpdateOnType( true )
				Editor.PANEL.ShoulderUpLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_shoulderview_up",Editor.PANEL.ShoulderUpLb:GetValue())
				end
				
				Editor.PANEL.ShoulderRIGTxt = Editor.PANEL.ShoulderSettings:Add("DLabel")
				Editor.PANEL.ShoulderRIGTxt:SetPos(180,60)
				Editor.PANEL.ShoulderRIGTxt:SetText("Shoulder Right")
				Editor.PANEL.ShoulderRIGTxt:SizeToContents() 
				
				Editor.PANEL.ShoulderRIGLb = Editor.PANEL.ShoulderSettings:Add("DTextEntry")
				Editor.PANEL.ShoulderRIGLb:SetPos(182,80)
				Editor.PANEL.ShoulderRIGLb:SetValue(GetConVar( "simple_thirdperson_shoulderview_right" ):GetFloat())
				Editor.PANEL.ShoulderRIGLb:SizeToContents()
				Editor.PANEL.ShoulderRIGLb:SetNumeric(true)
				Editor.PANEL.ShoulderRIGLb:SetUpdateOnType( true )
				Editor.PANEL.ShoulderRIGLb.OnTextChanged  = function()
					RunConsoleCommand("simple_thirdperson_shoulderview_right",Editor.PANEL.ShoulderRIGLb:GetValue())
				end
				
			end
		}
	)
	
	function BoolToInt(bol)
		if bol then
			return 1
		else
			return 0
		end
	end
	
	concommand.Add( "simple_thirdperson_shoulder_toggle", function()
		Editor.ShoulderToggle = !Editor.ShoulderToggle
		RunConsoleCommand("simple_thirdperson_shoulderview",BoolToInt(Editor.ShoulderToggle))
	end)
	
	concommand.Add( "simple_thirdperson_enable_toggle", function()
		Editor.EnableToggle = !Editor.EnableToggle
		RunConsoleCommand("simple_thirdperson_enabled",BoolToInt(Editor.EnableToggle))
	end)
	
	
	hook.Add("ShouldDrawLocalPlayer", "SimpleTP.ShouldDraw", function(ply)
		if GetConVar( "simple_thirdperson_enabled" ):GetBool() then
			return true
		end
	end)

	hook.Add("HUDShouldDraw", "SimpleTP.HUDShouldDraw", function(name)
		if GetConVar( "simple_thirdperson_enabled" ):GetBool() and GetConVar( "simple_thirdperson_shoulderview" ):GetBool() then
			if name == "CHudCrosshair" then
				return false
			end
		end
	end)
	
	hook.Add("HUDPaint", "SimpleTP.HUDPaint", function()
	
		if !GetConVar( "simple_thirdperson_enabled" ):GetBool() or !GetConVar( "simple_thirdperson_shoulderview" ):GetBool() then return end
	
		local ply = LocalPlayer()
		
		local t = {}
		t.start = ply:GetShootPos()
		t.endpos = t.start + ply:GetAimVector() * 9000
		t.filter = ply
		
		local tr = util.TraceLine(t)
		local pos = tr.HitPos:ToScreen()
		
		if (tr.HitPos - t.start):Length() < 2500 then
		
			surface.SetDrawColor(255, 255, 255, 255)
			
			surface.DrawLine(pos.x - 5, pos.y, pos.x - 8, pos.y)
			surface.DrawLine(pos.x + 5, pos.y, pos.x + 8, pos.y)
			
			surface.DrawLine(pos.x - 1, pos.y, pos.x + 1, pos.y)
			surface.DrawLine(pos.x, pos.y - 1, pos.x, pos.y + 1)
			
		end
		
	end)
	
	hook.Add("CalcView","SimpleTP.CameraView",function(ply, pos, angles, fov)
	
		if GetConVar( "simple_thirdperson_enabled" ):GetBool() and IsValid(ply) then
		
			if Editor.DelayPos == nil then
				Editor.DelayPos = ply:EyePos()
			end
			
			if Editor.ViewPos == nil then
				Editor.ViewPos = ply:EyePos()
			end
			
			local view = {}
			
			local Forward = GetConVar( "simple_thirdperson_cam_distance" ):GetFloat()
			local Up = GetConVar( "simple_thirdperson_cam_up" ):GetFloat()
			local Right = GetConVar( "simple_thirdperson_cam_right" ):GetFloat()
			
			local Pitch = GetConVar( "simple_thirdperson_cam_pitch" ):GetFloat()
			local Yaw = GetConVar( "simple_thirdperson_cam_yaw" ):GetFloat()
			
			Editor.DelayFov = fov
			
			if GetConVar( "simple_thirdperson_shoulderview" ):GetBool() then
			
				if GetConVar( "simple_thirdperson_shoulderview_bump" ):GetBool() and ply:GetMoveType() != MOVETYPE_NOCLIP then
					angles.pitch = angles.pitch + (ply:GetVelocity():Length() / 300) * math.sin(CurTime() * 10)
					angles.roll = angles.roll + (ply:GetVelocity():Length() / 300) * math.cos(CurTime() * 10)
				end
				
				Forward = GetConVar( "simple_thirdperson_shoulderview_dist" ):GetFloat()
				Up = GetConVar( "simple_thirdperson_shoulderview_up" ):GetFloat()
				Right = GetConVar( "simple_thirdperson_shoulderview_right" ):GetFloat()
			else
			
				angles.p = angles.p + Pitch
				angles.y = angles.y + Yaw
			
			end
			
			if GetConVar( "simple_thirdperson_smooth" ):GetBool() then
			
				Editor.DelayPos = Editor.DelayPos + (ply:GetVelocity() * (FrameTime() / GetConVar( "simple_thirdperson_smooth_delay" ):GetFloat()))
				Editor.DelayPos.x = math.Approach(Editor.DelayPos.x, pos.x, math.abs(Editor.DelayPos.x - pos.x) * GetConVar( "simple_thirdperson_smooth_mult_x" ):GetFloat())
				Editor.DelayPos.y = math.Approach(Editor.DelayPos.y, pos.y, math.abs(Editor.DelayPos.y - pos.y) * GetConVar( "simple_thirdperson_smooth_mult_y" ):GetFloat())
				Editor.DelayPos.z = math.Approach(Editor.DelayPos.z, pos.z, math.abs(Editor.DelayPos.z - pos.z) * GetConVar( "simple_thirdperson_smooth_mult_z" ):GetFloat())
				
			else
				Editor.DelayPos = pos
			end
			
			if GetConVar( "simple_thirdperson_fov_smooth" ):GetBool() then
				Editor.DelayFov = Editor.DelayFov + 20
				fov = math.Approach(fov, Editor.DelayFov, math.abs(Editor.DelayFov - fov) * GetConVar( "simple_thirdperson_fov_smooth_mult" ):GetFloat())
			else
				fov = Editor.DelayFov
			end
			
			if GetConVar( "simple_thirdperson_collision" ):GetBool() then
			
				local traceData = {}
				traceData.start = Editor.DelayPos
				traceData.endpos = traceData.start + angles:Forward() * -Forward
				traceData.endpos = traceData.endpos + angles:Right() * Right
				traceData.endpos = traceData.endpos + angles:Up() * Up
				traceData.filter = ply
				
				local trace = util.TraceLine(traceData)
				
				pos = trace.HitPos
				
				if trace.Fraction < 1.0 then
					pos = pos + trace.HitNormal * 5
				end
				
				view.origin = pos
			else
			
				local View = Editor.DelayPos + ( angles:Forward()* -Forward )
				View = View + ( angles:Right() * Right )
				View = View + ( angles:Up() * Up )
				
				view.origin = View
				
			end

			view.angles = angles
			view.fov = fov
		 
			return view

		end
	end)
	
end