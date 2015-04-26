local icol = Color( 255, 255, 255, 255 ) 
if CLIENT then
	killicon.Add( "m9k_bizonp19", "vgui/hud/m9k_bizonp19", icol  )
	killicon.Add( "m9k_colt1911", "vgui/hud/m9k_colt1911", icol  )
	killicon.Add( "m9k_coltpython", "vgui/hud/m9k_coltpython", icol  )
	killicon.Add( "m9k_deagle", "vgui/hud/m9k_deagle", icol  )
	killicon.Add( "m9k_glock", "vgui/hud/m9k_glock", icol  )
	killicon.Add( "m9k_hk45", "vgui/hud/m9k_hk45", icol  )
	killicon.Add( "m9k_luger", "vgui/hud/m9k_luger", icol  )
	killicon.Add( "m9k_m29satan", "vgui/hud/m9k_m29satan", icol  )
	killicon.Add( "m9k_m92beretta", "vgui/hud/m9k_m92beretta", icol  )
	killicon.Add( "m9k_model3russian", "vgui/hud/m9k_model3russian", icol  )
	killicon.Add( "m9k_mp7", "vgui/hud/m9k_mp7", icol  )
	killicon.Add( "m9k_ragingbull", "vgui/hud/m9k_ragingbull", icol  )
	killicon.Add( "m9k_remington1858", "vgui/hud/m9k_remington1858", icol  )
	killicon.Add( "m9k_sig_p229r", "vgui/hud/m9k_sig_p229r", icol  )
	killicon.Add( "m9k_smgp90", "vgui/hud/m9k_smgp90", icol  )
	killicon.Add( "m9k_sten", "vgui/hud/m9k_sten", icol  )
	killicon.Add( "m9k_thompson", "vgui/hud/m9k_thompson", icol  )
	killicon.Add( "m9k_usp", "vgui/hud/m9k_usp", icol  )
	killicon.Add( "m9k_uzi", "vgui/hud/m9k_uzi", icol  )
	killicon.Add( "m9k_model500", "vgui/hud/m9k_model500", icol  )
	killicon.Add( "m9k_model627", "vgui/hud/m9k_model627", icol  )
	killicon.Add( "m9k_ump45", "vgui/hud/m9k_ump45", icol  )
	killicon.Add( "m9k_mp9", "vgui/hud/m9k_mp9", icol  )
	killicon.Add( "m9k_vector", "vgui/hud/m9k_vector", icol  )
	killicon.Add( "m9k_tec9", "vgui/hud/m9k_tec9", icol  )
	killicon.Add( "m9k_mp5", "vgui/hud/m9k_mp5", icol  )
	killicon.Add( "m9k_kac_pdw", "vgui/hud/m9k_kac_pdw", icol  )
	killicon.Add( "m9k_honeybadger", "vgui/hud/m9k_honeybadger", icol  )
	killicon.Add( "m9k_mp5sd", "vgui/hud/m9k_mp5sd", icol  )
	killicon.Add( "m9k_magpulpdr", "vgui/hud/m9k_magpulpdr", icol  )
	killicon.Add( "m9k_scoped_taurus", "vgui/hud/m9k_scoped_taurus", icol  )
	

end

if SERVER then

	if GetConVar("M9KWeaponStrip") == nil then
		CreateConVar("M9KWeaponStrip", "0", { FCVAR_REPLICATED, FCVAR_NOTIFY, FCVAR_ARCHIVE }, "Allow empty weapon stripping? 1 for true, 0 for false")
	end
	
	if GetConVar("M9KGasEffect") == nil then
		CreateConVar("M9KGasEffect", "1", { FCVAR_ARCHIVE }, "Use gas effect when shooting? 1 for true, 0 for false")
	end
	
	if GetConVar("M9KDisablePenetration") == nil then
		CreateConVar("M9KDisablePenetration", "0", { FCVAR_ARCHIVE }, "Disable Penetration and Ricochets? 1 for true, 0 for false")
	end
	
	if ( file.Exists( "lua/autorun/m9k_small_arms.lua", "GAME" ) ) then
		timer.Simple(3, function()
			print("It looks like you have the new and old Murderthon 9000 Small Arms addons installed. To prevent errors, you should delete the old addon. Not sure which to delete? Delete both of them, and Garrys Mod will automatically download the right addon next time you load the game. Sorry for the trouble!")
			PrintMessage(HUD_PRINTTALK, "It looks like you have the new and old Murderthon 9000 Small Arms addons installed. To prevent errors, you should delete the old addon." )
		end)
		timer.Simple(3.5, function()
			PrintMessage(HUD_PRINTTALK, "Go to Steam/SteamApps/<your user name>/garrysmod/garrysmod/addons and delete the Murderthon 9000 addons. Not sure which to delete? Delete both of them, and Garrys Mod will automatically download the right addon next time you load the game.")
		end)
	end

end

//Magpul PDR
sound.Add({
	name = 			"MAG_PDR.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			{"weapons/pdr/pdr-1.wav",
						"weapons/pdr/pdr-2.wav",
						"weapons/pdr/pdr-3.wav"}
})

sound.Add({
	name = 			"Weapon_PDR.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pdr/pdr_clipin.wav"
})

sound.Add({
	name = 			"Weapon_PDR.Clipin2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pdr/pdr_clipin2.wav"
})

sound.Add({
	name = 			"Weapon_PDR.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pdr/pdr_boltpull.wav"
})

sound.Add({
	name = 			"Weapon_PDR.Boltrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pdr/pdr_boltrelease.wav"
})

sound.Add({
	name = 			"Weapon_PDR.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/pdr/pdr_clipout.wav"
})

//KAC PDW
sound.Add({
	name = 			"KAC_PDW.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kac_pdw/m4a1_unsil-1.wav"
})

sound.Add({
	name = 			"KAC_PDW.SilentSingle",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/kac_pdw/m4a1-1.wav"
})

sound.Add({
	name = 			"kac_pdw_001.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/kac_pdw/m4a1_clipout.wav"
})

sound.Add({
	name = 			"kac_pdw_001.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/kac_pdw/m4a1_clipin.wav"
})

sound.Add({
	name = 			"kac_pdw_001.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/kac_pdw/m4a1_boltpull.wav"
})

sound.Add({
	name = 			"kac_pdw_001.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/kac_pdw/m4a1_deploy.wav"
})

sound.Add({
	name = 			"kac_pdw_001.Silencer_On",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/kac_pdw/m4a1_silencer_on.wav"
})

sound.Add({
	name = 			"kac_pdw_001.Silencer_Off",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/kac_pdw/m4a1_silencer_off.wav"
})

//MP5
sound.Add({
	name = 			"mp5_navy_Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/brightmp5/mp5-1.wav"
})

sound.Add({
	name = 			"mp5_foley",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/brightmp5/foley.wav"
})

sound.Add({
	name = 			"mp5_magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/brightmp5/magout.wav"
})

sound.Add({
	name = 			"mp5_magin1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/brightmp5/magin1.wav"
})

sound.Add({
	name = 			"mp5_magin2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/brightmp5/magin2.wav"
})

sound.Add({
	name = 			"mp5_boltback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/brightmp5/boltback.wav"
})

sound.Add({
	name = 			"mp5_boltslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/brightmp5/boltslap.wav"
})

sound.Add({
	name = 			"mp5_cloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/brightmp5/cloth.wav"
})

sound.Add({
	name = 			"mp5_safety",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/brightmp5/safety.wav"
})

//tec9
sound.Add({
	name = 			"Weapon_Tec9.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tec9/ump45-1.wav"
})

sound.Add({
	name = 			"Weapon_Tec9.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_magin.wav"
})

sound.Add({
	name = 			"Weapon_Tec9.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_magout.wav"
})

sound.Add({
	name = 			"Weapon_Tec9.NewMag",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_newmag.wav"
})

sound.Add({
	name = 			"Weapon_Tec9.Charge",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tec9/tec9_charge.wav"
})

//Kriss
sound.Add({
	name = 			"kriss_vector.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/Kriss/ump45-1.wav"
})

sound.Add({
	name = 			"kriss_vector.Magrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/magrel.wav"
})

sound.Add({
	name = 			"kriss_vector.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/clipout.wav"
})

sound.Add({
	name = 			"kriss_vector.Dropclip",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/dropclip.wav"
})

sound.Add({
	name = 			"kriss_vector.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/clipin.wav"
})


sound.Add({
	name = 			"kriss_vector.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/boltpull.wav"
})

sound.Add({
	name = 			"kriss_vector.unfold",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/Kriss/unfold.wav"
})

//MP9
sound.Add({
	name = 			"Weapon_mp9.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/mp9/tmp-1.wav"
})

sound.Add({
	name = 			"Weapon_mp9.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp9/tmp_clipin.wav"
})

sound.Add({
	name = 			"Weapon_mp9.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp9/tmp_clipout.wav"
})

//ump45 
sound.Add({
	name = 			"m9k_hk_ump45.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/hk_ump45/ump45-1.wav"
})

sound.Add({
	name = 			"m9k_hk_ump45.Clipout1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_ump45/ump45_clipout1.wav"
})

sound.Add({
	name = 			"m9k_hk_ump45.Clipout2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_ump45/ump45_clipout2.wav"
})

sound.Add({
	name = 			"m9k_hk_ump45.Clipin1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_ump45/ump45_clipin1.wav"
})

sound.Add({
	name = 			"m9k_hk_ump45.Clipin2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_ump45/ump45_clipin2.wav"
})

sound.Add({
	name = 			"m9k_hk_ump45.Boltslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_ump45/ump45_boltslap.wav"
})

sound.Add({
	name = 			"m9k_hk_ump45.Cloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hk_ump45/ump45_cloth.wav"
})


//p19 Bizon
sound.Add({
	name = 			"Weapon_P19.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/p19/p90-1.wav"
})

sound.Add({
	name = 			"Weapon_P19.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p19/p90_clipout.wav"
})

sound.Add({
	name = 			"Weapon_P19.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p19/p90_clipin.wav"
})

sound.Add({
	name = 			"Weapon_P19.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p19/p90_boltpull.wav"
})

//p90
sound.Add({
	name = 			"P90_weapon.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/p90_smg/p90-1.wav"
})

sound.Add({
	name = 			"P90_weapon.unlock",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p90_smg/p90_unlock.wav"
})

sound.Add({
	name = 			"P90_weapon.magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p90_smg/p90_magout.wav"
})

sound.Add({
	name = 			"P90_weapon.magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p90_smg/p90_magin.wav"
})

sound.Add({
	name = 			"P90_weapon.cock",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/p90_smg/p90_cock.wav"
})

//sten
sound.Add({
	name = 			"Weaponsten.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/sten/mp5-1.wav"
	
})

sound.Add({
	name = 			"Weaponsten.clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sten/mp5_clipout.wav"
	
})

sound.Add({
	name = 			"Weaponsten.clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sten/mp5_clipin.wav"
	
})

sound.Add({
	name = 			"Weaponsten.boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sten/mp5_boltpull.wav"	
})

sound.Add({
	name = 			"Weaponsten.boltslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sten/mp5_boltslap.wav"
	
})

sound.Add({
	name = 			"Weapon_stengun.Slideback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/sten/mp5_slideback.wav"
	
})

//tommy gun
sound.Add({
	name = 			"Weapon_tmg.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/tmg/tmg_1.wav"
})

sound.Add({
	name = 			"Weapon_tmg.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tmg/tmg_magout.wav"
})

sound.Add({
	name = 			"Weapon_tmg.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tmg/tmg_magin.wav"
})

sound.Add({
	name = 			"Weapon_tmg.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/tmg/tmg_cock.wav"
})

//MP7
sound.Add({
	name =			"Weapon_MP7.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound =				"weapons/mp7/usp1.wav"
})

sound.Add({
	name =			"Weapon_MP7.magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp7/mp7_magout.wav"
})

sound.Add({
	name =			"Weapon_MP7.magin" ,
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp7/mp7_magin.wav"
})

sound.Add({
	name =			"Weapon_MP7.charger" ,
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/mp7/mp7_charger.wav"
})

//uzi
sound.Add({
	name = 			"Weapon_uzi.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/uzi/mac10-1.wav"
})

sound.Add({
	name = 			"imi_uzi_09mm.boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/uzi/mac10_boltpull.wav"
})

sound.Add({
	name = 			"imi_uzi_09mm.clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/uzi/mac10_clipin.wav"
})

sound.Add({
	name = 			"imi_uzi_09mm.clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/uzi/mac10_clipout.wav"
})

//MP5SD
sound.Add({
	name = 			"Weapon_hkmp5sd.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/hkmp5sd/mp5-1.wav"
})

sound.Add({
	name = 			"Weapon_hkmp5sd.magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hkmp5sd/magout.wav"
})

sound.Add({
	name = 			"Weapon_hkmp5sd.magfiddle",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hkmp5sd/magfiddle.wav"
})

sound.Add({
	name = 			"Weapon_hkmp5sd.magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hkmp5sd/magin.wav"
})

sound.Add({
	name = 			"Weapon_hkmp5sd.boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hkmp5sd/boltpull.wav"
})

sound.Add({
	name = 			"Weapon_hkmp5sd.boltrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hkmp5sd/boltrelease.wav"
})

sound.Add({
	name = 			"Weapon_hkmp5sd.cloth",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hkmp5sd/cloth.wav"
})

sound.Add({
	name = 			"Weapon_hkmp5sd.safety",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hkmp5sd/safety.wav"
})

//Honey Badger
sound.Add({
	name = 			"Weapon_HoneyB.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/hb/hb_fire.wav"
})

sound.Add({
	name = 			"Weapon_HoneyB.Magout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hb/magout.wav"
})

sound.Add({
	name = 			"Weapon_HoneyB.Magin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hb/magin.wav"
})

sound.Add({
	name = 			"Weapon_HoneyB.Boltcatch",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hb/boltcatch.wav"
})

sound.Add({
	name = 			"Weapon_HoneyB.Boltforward",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hb/boltforward.wav"
})

sound.Add({
	name = 			"Weapon_HoneyB.Boltback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/hb/boltback.wav"
})

//colt python
sound.Add({
	name = 			"Weapon_ColtPython.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/coltpython/python-1.wav"
})

sound.Add({
	name = 			"WepColtPython.clipdraw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/coltpython/clipdraw.wav"
})

sound.Add({
	name = 			"WepColtPython.blick",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/coltpython/blick.wav"
})

sound.Add({
	name = 			"WepColtPython.bulletsout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/coltpython/bulletsout.wav"
})

sound.Add({
	name = 			"WepColtPython.bulletsin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/coltpython/bulletsin.wav"
})

//Raging Bull
sound.Add({
	name = 			"weapon_r_bull.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/r_bull/r-bull-1.wav"
})

sound.Add({
	name = 			"weapons/r_bull/bullreload.wav",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/r_bull/bullreload.wav"
})

sound.Add({
	name = 			"weapons/r_bull/draw_gun.wav",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/r_bull/draw_gun.wav"
})

//smith and wesson model 3
sound.Add({
	name = 			"Model3.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/model3/model3-1.wav" 
})

sound.Add({
	name = 			"Model3.Hammer",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model3/Hammer.wav" 
})

sound.Add({
	name = 			"Model3.Break_Eject",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model3/Break_eject.wav" 
})

sound.Add({
	name = 			"Model3.bulletout_1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model3/bulletout_1.wav"
})

sound.Add({
	name = 			"Model3.bulletout_2",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model3/bulletout_2.wav"
})

sound.Add({
	name = 			"Model3.bulletout_3",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model3/bulletout_3.wav"
})

sound.Add({
	name = 			"Model3.bullets_in",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model3/bullets_in.wav"
})

sound.Add({
	name = 			"Model3.Break_close",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model3/Break_CLose.wav"	
})

//m29 satan
sound.Add({
	name = 			"Weapon_satan1.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/satan1/satan-1.wav"
})

sound.Add({
	name = 			"Weapon_satan1.blick",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/satan1/blick.wav"
})

sound.Add({
	name = 			"Weapon_satan1.unfold",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/satan1/unfold.wav"
})

sound.Add({
	name = 			"Weapon_satan1.bulletsin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/satan1/bulletsin.wav"
})

sound.Add({
	name = 			"Weapon_satan1.bulletsout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/satan1/bulletsout.wav"
})

//Remington 1858
sound.Add({
	name = 			"Remington.single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/remington/remington-1.wav" 
})

sound.Add({
	name = 			"Remington.cylinderhit",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/remington/cylinderhit.wav" 
})

sound.Add({
	name = 			"Remington.cylinderswap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/remington/cylinderswap.wav" 
})

sound.Add({
	name = 			"Remington.bounce1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/remington/bounce1.wav" 
})

sound.Add({
	name = 			"Remington.bounce1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/remington/bounce2.wav" 
})

sound.Add({
	name = 			"Remington.bounce1",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/remington/bounce3.wav" 
})

sound.Add({
	name = 			"Remington.Hammer",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/remington/hammer.wav" 
})

//BERETTAM92
sound.Add({
	name = 			"Weapon_m92b.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			")weapons/beretta92/berettam92-1.wav"
})

sound.Add({
	name = 			"Weapon_beretta92.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/beretta92/berettam92_clipout.wav"
})

sound.Add({
	name = 			"Weapon_beretta92.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/beretta92/berettam92_clipin.wav"
})

sound.Add({
	name = 			"Weapon_beretta92.Sliderelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/beretta92/berettam92_sliderelease.wav"
})

sound.Add({
	name = 			"Weapon_beretta92.Slidepull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/beretta92/berettam92_slidepull.wav"
})

sound.Add({
	name = 			"Weapon_beretta92.Slideback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/beretta92/berettam92_slideback.wav"
})

//hk45c
sound.Add({
	name = 			"Weapon_hk45.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/hk45/hk45-1.wav"
})

sound.Add({
	name = 			"HK45C.Deploy",
	channel =		CHAN_ITEM,
	volume =		1,	
	sound =			"weapons/hk45/draw.wav"
})

sound.Add({
	name = 			"HK45C.Magout",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/hk45/magout.wav"
})

sound.Add({
	name = 			"HK45C.Magin",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/hk45/magin.wav"
})

sound.Add({
	name = 			"HK45C.Release",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/hk45/sliderelease.wav"
})

sound.Add({
	name = 			"HK45C.Slidepull",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/hk45/slidepull.wav"
})

//usp
sound.Add({
	name = 			"Weapon_fokkususp.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_usp/fiveseven-1.wav" 
})

sound.Add({
	name = 			"Weapon_fokkususp.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_usp/fiveseven_clipout.wav" 
})

sound.Add({
	name = 			"Weapon_fokkususp.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_usp/fiveseven_clipin.wav" 
})

sound.Add({
	name = 			"Weapon_fokkususp.Slideback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_usp/fiveseven_slideback.wav" 
})

sound.Add({
	name = 			"Weapon_fokkususp.Slidepull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_usp/fiveseven_slidepull.wav" 
})

// Sig P228
sound.Add({
	name = 			"Sauer1_P228.Single",
	channel =		CHAN_USER_BASE+10,
	volume =		1,
	sound =			"weapons/sig_p228/p228-1.wav"
})

sound.Add({
	name = 			"Sauer1_P228.Magout",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/magout.wav" 
})

sound.Add({
	name = 			"Sauer1_P228.Magin",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/magin.wav" 
})

sound.Add({
	name = 			"Sauer1_P228.MagShove",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/magshove.wav" 
})

sound.Add({
	name = 			"Sauer1_P228.Sliderelease",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/sliderelease.wav"
})

sound.Add({
	name = 			"Sauer1_P228.Cloth",
	channel =		CHAN_ITEM,
	volume =		.5,
	sound =			"weapons/sig_p228/cloth.wav"
})

sound.Add({
	name = 			"Sauer1_P228.Shift",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/shift.wav"
})

//glock 18
sound.Add({
	name = 			"Dmgfok_glock.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/dmg_glock/mac10-1.wav" 
})

sound.Add({
	name = 			"Dmgfok_glock.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_glock/magout.wav" 
})

sound.Add({
	name = 			"Dmgfok_glock.clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_glock/magin.wav" 
})

sound.Add({
	name = 			"Dmgfok_glock.Boltpull",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_glock/boltpull.wav" 
})

sound.Add({
	name = 			"Dmgfok_glock.Boltrelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_glock/boltrelease.wav" 
})

sound.Add({
	name = 			"Dmgfok_glock.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_glock/mac10_deploy.wav" 
})

//colt 1911
sound.Add({
	name = 			"Dmgfok_co1911.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/dmg_colt1911/deagle-1.wav"
})

sound.Add({
	name = 			"Dmgfok_co1911.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_colt1911/draw.wav"
})

sound.Add({
	name = 			"Dmgfok_co1911.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_colt1911/de_clipin.wav"
})

sound.Add({
	name = 			"Dmgfok_co1911.Slideback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_colt1911/de_slideback.wav"
})

sound.Add({
	name = 			"Dmgfok_co1911.Draw",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/dmg_colt1911/draw.wav"
})

//luger
sound.Add({
	name = 			"Weapon_luger.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/luger/luger-1.wav"
})

sound.Add({
	name = 			"Weapon_luger.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/luger/luger_clipout.wav"
})

sound.Add({
	name = 			"Weapon_luger.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/luger/luger_clipin.wav"
})

sound.Add({
	name = 			"Weapon_luger.Sliderelease",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/luger/luger_sliderelease.wav"
})

//desert eagle
sound.Add({
	name = 			"Weapon_TDegle.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_deagle/deagle-1.wav" 
})

sound.Add({
	name = 			"Weapon_TDegle.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_deagle/de_clipout.wav" 
})

sound.Add({
	name = 			"Weapon_TDegle.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_deagle/de_clipin.wav" 
})

sound.Add({
	name = 			"Weapon_TDegle.Slideback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_deagle/de_slideback.wav" 
})

sound.Add({
	name = 			"Weapon_TDegle.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/fokku_tc_deagle/de_deploy.wav" 
})

// Sig P229R
sound.Add({
	name = 			"Sauer1_P228.Single",
	channel =		CHAN_USER_BASE+10,
	volume =		1,
	sound =			"weapons/sig_p228/p228-1.wav"
})

sound.Add({
	name = 			"Sauer1_P228.Magout",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/magout.wav" 
})

sound.Add({
	name = 			"Sauer1_P228.Magin",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/magin.wav" 
})

sound.Add({
	name = 			"Sauer1_P228.MagShove",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/magshove.wav" 
})

sound.Add({
	name = 			"Sauer1_P228.Sliderelease",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/sliderelease.wav"
})

sound.Add({
	name = 			"Sauer1_P228.Cloth",
	channel =		CHAN_ITEM,
	volume =		.5,
	sound =			"weapons/sig_p228/cloth.wav"
})

sound.Add({
	name = 			"Sauer1_P228.Shift",
	channel =		CHAN_ITEM,
	volume =		1,
	sound =			"weapons/sig_p228/shift.wav"
})

//Model 500
sound.Add({
	name = 			"Model_500.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound =			"weapons/model500/deagle-1.wav"		
})

sound.Add({
	name = 			"saw_model_500.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model500/de_clipin.wav"	
})

sound.Add({
	name = 			"saw_model_500.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model500/de_clipout.wav"	
})

sound.Add({
	name = 			"saw_model_500.Deploy",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model500/de_deploy.wav"	
})

sound.Add({
	name = 			"saw_model_500.Slideback",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/model500/de_slideback.wav"	
})

//S&W 627
sound.Add({
	name = 			"model_627perf.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			"weapons/627/deagle-1.wav"
})

sound.Add({
	name = 			"model_627perf.wheel_in",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/627/wheel_in.wav"
})

sound.Add({
	name = 			"model_627perf.bullets_in",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/627/bullets_in.wav"
})

sound.Add({
	name = 			"model_627perf.bulletout_3",
	channel = 		CHAN_USER_BASE+11,
	volume = 		1.0,
	sound = 			"weapons/627/bulletout_3.wav"
})

sound.Add({
	name = 			"model_627perf.bulletout_2",
	channel = 		CHAN_USER_BASE+12,
	volume = 		1.0,
	sound = 			"weapons/627/bulletout_2.wav"
})

sound.Add({
	name = 			"model_627perf.bulletout_1",
	channel = 		CHAN_USER_BASE+13,
	volume = 		1.0,
	sound = 			"weapons/627/bulletout_1.wav"
})

sound.Add({
	name = 			"model_627perf.wheel_out",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/627/wheel_out.wav"
})

//usc
sound.Add({
	name = 			"Weapon_hkusc.Single",
	channel = 		CHAN_USER_BASE+10,
	volume = 		1.0,
	sound = 			{"weapons/usc/ump45-1.wav",
						"weapons/usc/ump45-2.wav"}
})

sound.Add({
	name = 			"Weapon_hkusc.Clipout",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/usc/ump45_clipout.wav"
})

sound.Add({
	name = 			"Weapon_hkusc.Clipin",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/usc/ump45_clipin.wav"
})

sound.Add({
	name = 			"Weapon_hkusc.Boltslap",
	channel = 		CHAN_ITEM,
	volume = 		1.0,
	sound = 			"weapons/usc/ump45_boltslap.wav"
})