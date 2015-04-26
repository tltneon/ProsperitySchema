	

    local loaded = false
    if file.Exists( "lua/bin/gmcl_example_win32.dll", "GAME" ) then
            require( "example" )
            loaded = true
    else
            loaded = false
    end
     
    net.Receive("requestpicture", function()
            local ply = net.ReadEntity()
           
            local RCD = {}
            RCD.format = "jpeg"
            RCD.h = ScrH()
            RCD.w = ScrW()
            RCD.quality = 70
            RCD.x = 0
            RCD.y = 0
           
            local bin = render.Capture(RCD)
            local len = string.len(bin)
           
            local temp = 70
            while len > 200000 do
                    temp = temp - 5
                   
                    RCD = {}
                    RCD.format = "jpeg"
                    RCD.h = ScrH()
                    RCD.w = ScrW()
                    RCD.quality = temp
                    RCD.x = 0
                    RCD.y = 0
                   
                    bin = render.Capture(RCD)
                    len = string.len(bin)
            end
           
            local parts = math.floor(len / 50000)
            for i = 0, parts do
                    if i == parts then
                            local part = string.sub(bin, (i * 50000) + 1)
                            local len = string.len(part)
                            net.Start("sendpicture")
                                    net.WriteEntity(ply)
                                    net.WriteFloat(len)
                                    net.WriteData(part, len)
                                    net.WriteInt(1, 8)
                                    net.WriteFloat(ScrW())
                                    net.WriteFloat(ScrH())
                            net.SendToServer()
                    else
                            local part = string.sub(bin, (i * 50000) + 1, (i * 50000) + 50000)
                            local len = string.len(part)
                            net.Start("sendpicture")
                                    net.WriteEntity(ply)
                                    net.WriteFloat(len)
                                    net.WriteData(part, len)
                                    net.WriteInt(0, 8)
                            net.SendToServer()
                    end
            end
    end)
     
    local fullimage = ""
    local lastImage = {}
    net.Receive("sendpicture", function()
            local len = net.ReadFloat()
            local bin = net.ReadData(len)
            local int = net.ReadInt(8)
           
            fullimage = fullimage .. bin
            if int == 1 then
                    local w = net.ReadFloat()
                    local h = net.ReadFloat()
                   
                    local f = file.Open( "foo.txt", "wb", "DATA" )
                    f:Write( fullimage )
                    f:Close()
                   
                    lastImage.name = tostring(os.time())
                    lastImage.w = w
                    lastImage.h = h
                    if loaded then
                            if ParseJPG(lastImage.name) then
                                    LocalPlayer():PrintMessage(3, "good")
                                    ShowImage()
                            else
                                    LocalPlayer():PrintMessage(3, "problem")
                            end
                    else
                            LocalPlayer():PrintMessage(3, "You do not have the neccessary module downloaded.")
                    end
                    fullimage = ""
            end
    end)
     
    function ShowImage()
            if type(lastImage.name) == "string" and type(lastImage.w) == "number" and type(lastImage.h) == "number" then
                    local scale = 600 / lastImage.h
                    local DermaPanel = vgui.Create( "DFrame" )
                    DermaPanel:SetSize( lastImage.w * scale + 60, lastImage.h * scale + 80)
                    DermaPanel:Center()
                    DermaPanel:SetTitle( "" )
                    DermaPanel:SetVisible( true )
                    DermaPanel:SetDraggable( true )
                    DermaPanel:ShowCloseButton( true )
                    DermaPanel:MakePopup()
                    DermaPanel.Paint = function()
                            draw.RoundedBox( 8, 0, 0, DermaPanel:GetWide(), DermaPanel:GetTall(), Color( 0, 0, 0, 150 ) )
                    end
     
                    local myImage = vgui.Create("DImage", DermaPanel)
                    myImage:SetImage( lastImage.name..".jpg" )
                    myImage:SetPos(30, 30)
                    myImage:SetSize( lastImage.w * scale, lastImage.h * scale )
                   
                    local save = vgui.Create("DButton", DermaPanel)
                    save:SetSize( 60, 40 )
                    save:SetPos( DermaPanel:GetWide() / 2 - save:GetWide() - 5, DermaPanel:GetTall() - save:GetTall() - 5 )
                    save:SetText( "Save" )
                    save.DoClick = function()
                            DermaPanel:Close()
                    end
                   
                    local delete = vgui.Create("DButton", DermaPanel)
                    delete:SetSize( 60, 40 )
                    delete:SetPos( DermaPanel:GetWide() / 2 + 5, DermaPanel:GetTall() - delete:GetTall() - 5 )
                    delete:SetText( "Delete" )
                    delete.DoClick = function()
                            DeleteJPG(myImage:GetImage())
                            DermaPanel:Close()
                    end
            end
    end

