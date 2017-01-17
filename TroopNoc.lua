if GetObjectName(myHero) ~= "Nocturne" then return end

local ver = "0.02"

local NocQ = {delay = 0.25, speed = 1200, width = 80, range = 1300}

local Move = {delay = 0.5, speed = math.huge, width = 50, range = math.huge}

require("OpenPredict")

require("DamageLib")

function AutoUpdate(data)
    if tonumber(data) > tonumber(ver) then
        print("New version found! " .. data)
        print("Downloading update, please wait...")
        DownloadFileAsync("https://raw.githubusercontent.com/TrooperHDxLeagueSharp/GoS/master/TroopNoc.lua", SCRIPT_PATH .. "TroopNoc.lua", function() print("Update Complete, please 2x F6!") return end)
    end
end

GetWebResultAsync("https://raw.githubusercontent.com/TrooperHDxLeagueSharp/GoS/master/TroopNoc.version", AutoUpdate)

local TroopNoc = Menu("Nocturne", "Nocturne")
TroopNoc:SubMenu("Combo", "Combo")
TroopNoc.Combo:Boolean("QCombNoc", "Use Q", true)
TroopNoc.Combo:Boolean("ECombNoc", "Use E", true)
TroopNoc.Combo:Boolean("HydraCombNoc", "Use Hydra", true)
TroopNoc.Combo:Boolean("TiamatCombNoc", "Use Tiamat", true)
TroopNoc.Combo:Boolean("Blade", "Use BOTRK", true)
TroopNoc.Combo:Boolean("Bilgewater", "Use Cutlass", true	)
TroopNoc.Combo:Boolean("RCombNoc", "Use R [ default off , because its situational ]", false)
TroopNoc.Combo:Slider("MinManaNoc", "Min Mana To Combo",50,0,100,1)

--harass
TroopNoc:SubMenu("Harass", "Harass", true)
TroopNoc.Harass:Boolean("QHarassNoc", "Use Q", true)
TroopNoc.Harass:Boolean("EHarassNoc", "Use E", true)
TroopNoc.Harass:Slider("HarassMinMana", "Min Mana To Harass",50,0,100,1)

--lc
TroopNoc:SubMenu("LaneClear", "LaneClear", true)
TroopNoc.LaneClear:Boolean("Qlc", "Use Q", true)
TroopNoc.LaneClear:Slider("MinManaLC", "Min Mana To LaneClear",50,0,100,1)

--misc
TroopNoc:SubMenu("Misc", "Misc")
TroopNoc.Misc:Boolean("Lvlup", "Use Auto Level", true)
TroopNoc.Misc:Boolean("Ig", "Use Auto Ignite", true)

--cc
TroopNoc:SubMenu("AutoW", "Auto W against cc")
TroopNoc.AutoW:Boolean("CC", "Use W if CC incoming", true)

--pred
TroopNoc:SubMenu("Prediction", "Prediction Settings")
TroopNoc.Prediction:Slider("Q", "Hit-Chance: Q" , 30, 0, 99,1)

-- skins
TroopNoc:SubMenu("SkinChanger", "SkinChanger")
local skinMeta = {["Nocturne"] = {"Classic", "Frozen-Terror", "Void", "Ravager", "Haunted Noc", "Eternum", "Cursed-Revenant"}}
TroopNoc.SkinChanger:DropDown('skin', myHero.charName.. " Skins", 1, skinMeta[myHero.charName], HeroSkinChanger, true)
TroopNoc.SkinChanger.skin.callback = function(model) HeroSkinChanger(myHero, model - 1) print(skinMeta[myHero.charName][model] .." ".. myHero.charName .. " Loaded!") end

--drawings
TroopNoc:SubMenu("Draw", "Drawings")
TroopNoc.Draw:Boolean("DrawQ", "Draw Q Range", true)
TroopNoc.Draw:Boolean("DrawW", "Draw W Range", true)
TroopNoc.Draw:Boolean("DrawE", "Draw E Range", true)
TroopNoc.Draw:Boolean("DrawR", "Draw R Range", true)



function Mode()
    if _G.IOW_Loaded and IOW:Mode() then
        return IOW:Mode()
        elseif _G.PW_Loaded and PW:Mode() then
        return PW:Mode()
        elseif _G.DAC_Loaded and DAC:Mode() then
        return DAC:Mode()
        elseif _G.AutoCarry_Loaded and DACR:Mode() then
        return DACR:Mode()
        elseif _G.SLW_Loaded and SLW:Mode() then
        return SLW:Mode()
    end
end



CC = {
-- Aatrox
["AatroxQ"] 					= 	{ slot = _Q , champName = "Aatrox"				, spellType = "circular" 	, projectileSpeed = 2000		, spellDelay = 600	, spellRange = 650		, spellRadius = 285		, collision = false	}, 
["AatroxE"] 					= 	{ slot = _E , champName = "Aatrox"				, spellType = "line" 		, projectileSpeed = 1250		, spellDelay = 250	, spellRange = 1075		, spellRadius = 100		, collision = false	, projectileName = "AatroxBladeofTorment_mis.troy"}, 
-- Ahri
["AhriSeduce"] 					= 	{ slot = _E , champName = "Ahri"				, spellType = "line" 	 	, projectileSpeed = 1550		, spellDelay = 250	, spellRange = 1000		, spellRadius = 60		, collision = true	, projectileName = "Ahri_Charm_mis.troy"}, 
-- Alistar
["Pulverize"] 					= 	{ slot = _Q , champName = "Alistar"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 365		, spellRadius = 365		, collision = false	},
-- Amumu
["BandageToss"] 				= 	{ slot = _Q , champName = "Amumu"				, spellType = "line" 	 	, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 1100		, spellRadius = 80		, collision = true	, projectileName = "Bandage_beam.troy"}, 
["CurseoftheSadMummy"] 			= 	{ slot = _R , champName = "Amumu"				, spellType = "aoe" 	 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 560		, spellRadius = 560		, collision = false	},
-- Anivia
["FlashFrostSpell"] 			= 	{ slot = _Q , champName = "Anivia"				, spellType = "line" 	 	, projectileSpeed = 850			, spellDelay = 250	, spellRange = 1250		, spellRadius = 110		, collision = false	, projectileName = "cryo_FlashFrost_mis.troy"}, 
-- Ashe
["EnchantedCrystalArrow"] 		= 	{ slot = _R , champName = "Ashe"				, spellType = "line" 	 	, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 20000	, spellRadius = 130		, collision = false	, projectileName = "EnchantedCrystalArrow_mis.troy"},
-- Bard
["BardQ"] 						= 	{ slot = _Q , champName = "Bard"				, spellType = "line" 	 	, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 950		, spellRadius = 60		, collision = true	, projectileName = "Bard_Base_Q_Missile_mis.troy"},
-- Blitzcrank
["RocketGrab"] 					= 	{ slot = _Q , champName = "Blitzcrank"			, spellType = "line" 	 	, projectileSpeed = 1800		, spellDelay = 250	, spellRange = 1050		, spellRadius = 70		, collision = true	, projectileName = "FistGrab_mis.troy"},
-- Braum
["BraumQ"] 						= 	{ slot = _Q , champName = "Braum"				, spellType = "line" 	 	, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1000		, spellRadius = 100		, collision = true	, projectileName = ""},
["BraumRWrapper"] 				= 	{ slot = _R , champName = "Braum"				, spellType = "line" 	 	, projectileSpeed = 1125		, spellDelay = 500	, spellRange = 1250		, spellRadius = 100		, collision = false	, projectileName = ""},
-- Cassiopeia
["CassiopeiaPetrifyingGaze"]	= 	{ slot = _R , champName = "Cassiopeia"			, spellType = "line" 	 	, projectileSpeed = math.huge	, spellDelay = 500	, spellRange = 825		, spellRadius = 150		, collision = false	, projectileName = ""},
-- Chogath
["Rupture"] 					= 	{ slot = _Q , champName = "Chogath"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1200	, spellRange = 950		, spellRadius = 250		, collision = false },
-- Darius
["DariusAxeGrabCone"] 			= 	{ slot = _E , champName = "Darius"				, spellType = "line" 		, projectileSpeed = math.huge	, spellDelay = 320	, spellRange = 570		, spellRadius = 150		, collision = false , projectileName = ""},
-- Diana
["DianaVortex"] 				= 	{ slot = _E , champName = "Diana"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 350		, spellRadius = 350		, collision = false	},
-- DrMundo
["InfectedCleaverMissileCast"] 	= 	{ slot = _Q , champName = "DrMundo"				, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 1050		, spellRadius = 60		, collision = true	, projectileName = "DrMundo_Base_Q_mis.troy"},
-- Draven
["DravenDoubleShot"] 			= 	{ slot = _E , champName = "Draven"				, spellType = "line" 		, projectileSpeed = 1400		, spellDelay = 250	, spellRange = 1100		, spellRadius = 130		, collision = false	, projectileName = "Draven_E_mis.troy"},
-- Elise
["EliseHumanE"] 				= 	{ slot = _E , champName = "Elise"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 1100		, spellRadius = 70		, collision = true	, projectileName = "Elise_human_E_mis.troy"},
-- Evelynn
["EvelynnR"] 					= 	{ slot = _R , champName = "Evelynn"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 650		, spellRadius = 350		, collision = false },
-- FiddleSticks
["Terrify"] 					= 	{ slot = _Q , champName = "FiddleSticks"		, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 575		, spellRadius = 0		, collision = false },
-- Fizz
["FizzMarinerDoom"] 			= 	{ slot = _R , champName = "Fizz"				, spellType = "line" 		, projectileSpeed = 1350		, spellDelay = 250	, spellRange = 1275		, spellRadius = 120		, collision = false , projectileName = "Fizz_UltimateMissile.troy"}, --Test
-- Galio
["GalioResoluteSmite"] 			= 	{ slot = _Q , champName = "Galio"				, spellType = "circular" 	, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1040		, spellRadius = 235		, collision = false },
["GalioIdolOfDurand"] 			= 	{ slot = _R , champName = "Galio"				, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 600		, spellRadius = 600		, collision = false },
-- Gnar
["gnarbigq"] 					= 	{ slot = _Q , champName = "Gnar"				, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 500	, spellRange = 1150		, spellRadius = 90		, collision = true  , projectileName = ""},
["GnarQ"] 						= 	{ slot = _Q , champName = "Gnar"				, spellType = "line" 		, projectileSpeed = 2400		, spellDelay = 250	, spellRange = 1185		, spellRadius = 60		, collision = true  , projectileName = ""},
["gnarbigw"] 					= 	{ slot = _W , champName = "Gnar"				, spellType = "line" 		, projectileSpeed = math.huge	, spellDelay = 600	, spellRange = 600		, spellRadius = 100		, collision = false , projectileName = ""},
["GnarR"] 						= 	{ slot = _R , champName = "Gnar"				, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 500		, spellRadius = 500		, collision = false },
-- Gragas
["GragasE"] 					= 	{ slot = _E , champName = "Gragas"				, spellType = "line" 		, projectileSpeed = 1200		, spellDelay = 0	, spellRange = 950		, spellRadius = 200		, collision = true  , projectileName = ""},
["GragasR"] 					= 	{ slot = _R , champName = "Gragas"				, spellType = "circular" 	, projectileSpeed = 1750		, spellDelay = 250	, spellRange = 1050		, spellRadius = 350		, collision = false },
-- Hecarim
["HecarimUlt"] 					= 	{ slot = _R , champName = "Hecarim"				, spellType = "circular" 	, projectileSpeed = 1100		, spellDelay = 10	, spellRange = 1500		, spellRadius = 300		, collision = false },
-- Heimerdinger
["HeimerdingerE"] 				= 	{ slot = _E , champName = "Heimerdinger"		, spellType = "circular" 	, projectileSpeed = 1750		, spellDelay = 350	, spellRange = 925		, spellRadius = 135		, collision = false },
-- Irelia
["IreliaEquilibriumStrike"] 	= 	{ slot = _E , champName = "Irelia"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 425		, spellRadius = 0		, collision = false },
-- Janna
["HowlingGale"] 				= 	{ slot = _Q , champName = "Janna"				, spellType = "line" 		, projectileSpeed = 900			, spellDelay = 0	, spellRange = 1700		, spellRadius = 120		, collision = false , projectileName = "HowlingGale_mis.troy"},
["SowTheWind"] 					= 	{ slot = _W , champName = "Janna"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false },
-- JarvanIV
["JarvanIVDragonStrike2"] 		= 	{ slot = _Q , champName = "JarvanIV"			, spellType = "line" 		, projectileSpeed = 1800		, spellDelay = 250	, spellRange = 845		, spellRadius = 120		, collision = false	, projectileName = ""},
-- Jayce
["JayceToTheSkies"] 			= 	{ slot = _Q , champName = "Jayce"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 100		, collision = false	},
["JayceThunderingBlow"] 		= 	{ slot = _E , champName = "Jayce"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 240		, spellRadius = 0		, collision = false	},
-- Karma
["KarmaQMissileMantra"] 		= 	{ slot = _Q , champName = "Karma"				, spellType = "line" 		, projectileSpeed = 1700		, spellDelay = 250	, spellRange = 1050		, spellRadius = 90		, collision = true	, projectileName = ""},
["KarmaQ"] 						= 	{ slot = _Q , champName = "Karma"				, spellType = "line" 		, projectileSpeed = 1700		, spellDelay = 250	, spellRange = 1050		, spellRadius = 90		, collision = true	, projectileName = ""},
["KarmaW"] 						= 	{ slot = _W , champName = "Karma"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 1000		, spellRadius = 0		, collision = false	}, -- Check spellname
-- Kassadin
["ForcePulse"] 					= 	{ slot = _E , champName = "Kassadin"			, spellType = "line" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 700		, spellRadius = 100		, collision = false	, projectileName = ""},
-- Kayle
["JudicatorReckoning"] 			= 	{ slot = _Q , champName = "Kayle"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 650		, spellRadius = 0		, collision = false	},
-- KhaZix
["KhazixW"] 					= 	{ slot = _W , champName = "KhaZix"				, spellType = "line" 		, projectileSpeed = 1700		, spellDelay = 250	, spellRange = 1100		, spellRadius = 70		, collision = true	, projectileName = "Khazix_W_mis_enhanced.troy"},
["khazixwlong"] 				= 	{ slot = _W , champName = "KhaZix"				, spellType = "line" 		, projectileSpeed = 1700		, spellDelay = 250	, spellRange = 1025		, spellRadius = 70		, collision = true	, projectileName = "Khazix_W_mis_enhanced.troy"},
-- KogMaw
["KogMawVoidOoze"] 				= 	{ slot = _E , champName = "KogMaw"				, spellType = "line" 		, projectileSpeed = 1400		, spellDelay = 250	, spellRange = 1360		, spellRadius = 120		, collision = false	, projectileName = "KogMawVoidOoze_mis.troy"},
-- LeBlanc
["LeblancSoulShackle"] 			= 	{ slot = _E , champName = "Leblanc"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 960		, spellRadius = 70		, collision = true	, projectileName = "leBlanc_shackle_mis.troy"},
["LeblancSoulShackleM"] 		= 	{ slot = _R , champName = "Leblanc"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 960		, spellRadius = 70		, collision = true	, projectileName = "leBlanc_shackle_mis_ult.troy"},
-- LeeSin
["BlindMonkQOne"] 				= 	{ slot = _Q , champName = "LeeSin"				, spellType = "line" 		, projectileSpeed = 1800		, spellDelay = 250	, spellRange = 1100		, spellRadius = 60		, collision = true	, projectileName = "blindMonk_Q_mis_01.troy"},
["BlindMonkRKick"] 				= 	{ slot = _R , champName = "LeeSin"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 375		, spellRadius = 0		, collision = false	},
-- Leona
["LeonaSolarFlare"] 			= 	{ slot = _R , champName = "Leona"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1000	, spellRange = 1200		, spellRadius = 300		, collision = false	},
-- Lissandra
["LissandraW"] 					= 	{ slot = _W , champName = "Lissandra"			, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 450		, spellRadius = 450		, collision = false	},
["LissandraR"] 					= 	{ slot = _R , champName = "Lissandra"			, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 550		, spellRadius = 550		, collision = false	},
-- Lulu
["LuluQ"] 						= 	{ slot = _Q , champName = "Lulu"				, spellType = "line" 		, projectileSpeed = 1450		, spellDelay = 250	, spellRange = 950		, spellRadius = 80		, collision = false	, projectileName = "Lulu_Q_Mis.troy"},
["LuluW"] 						= 	{ slot = _W , champName = "Lulu"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 925		, spellRadius = 450		, collision = false	}, -- check spellname
-- Lux
["LuxLightBinding"] 			= 	{ slot = _Q , champName = "Lux"					, spellType = "line" 		, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1300		, spellRadius = 70		, collision = true	, projectileName = "LuxLightBinding_mis.troy"},
-- Malphite
["SeismicShard"] 				= 	{ slot = _Q , champName = "Malphite"			, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 625		, spellRadius = 0		, collision = false	},
["UFSlash"] 					= 	{ slot = _R , champName = "Malphite"			, spellType = "circular" 	, projectileSpeed = 2000		, spellDelay = 0	, spellRange = 1000		, spellRadius = 300		, collision = false	},
-- Malzahar
["AlZaharNetherGrasp"] 			= 	{ slot = _R , champName = "Malzahar"			, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 700		, spellRadius = 0		, collision = false	},
-- Maokai
["MaokaiTrunkLine"] 			= 	{ slot = _Q , champName = "Maokai"				, spellType = "line" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 100		, collision = false	, projectileName = ""},
["MaokaiW"] 					= 	{ slot = _W , champName = "Maokai"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	}, -- check spellname
-- Morgana
["DarkBindingMissile"] 			= 	{ slot = _Q , champName = "Morgana"				, spellType = "line" 		, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1300		, spellRadius = 80		, collision = true	, projectileName = "DarkBinding_mis.troy"},
["SoulShackles"] 				= 	{ slot = _R , champName = "Morgana"				, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 600		, spellRadius = 600		, collision = false	},
-- Nami
["NamiQ"] 						= 	{ slot = _Q , champName = "Nami"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1000	, spellRange = 875		, spellRadius = 200		, collision = false	},
["NamiR"] 						= 	{ slot = _R , champName = "Nami"				, spellType = "line" 		, projectileSpeed = 850			, spellDelay = 500	, spellRange = 2750		, spellRadius = 250		, collision = false	, projectileName = ""},
-- Nasus
["NasusW"] 						= 	{ slot = _W , champName = "Nasus"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	},
-- Nautilus
["NautilusAnchorDrag"] 			= 	{ slot = _Q , champName = "Nautilus"			, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 1250		, spellRadius = 90		, collision = true	, projectileName = "Nautilus_Q_mis.troy"},
["NautilusR"] 					= 	{ slot = _R , champName = "Nautilus"			, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 825		, spellRadius = 0		, collision = false	}, -- check spellname
-- Nocturne
["NocturneUnspeakableHorror"]	= 	{ slot = _E , champName = "Nocturne"			, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 425		, spellRadius = 0		, collision = false	},
-- Nunu
["IceBlast"]					= 	{ slot = _E , champName = "Nunu"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 400	, spellRange = 425		, spellRadius = 0		, collision = false	},
-- Olaf
["OlafAxeThrowCast"]			= 	{ slot = _Q , champName = "Olaf"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 100		, spellRadius = 90		, collision = false	, projectileName = "olaf_axe_mis.troy"},
-- Orianna
--0
-- Pantheon
["PantheonW"]					= 	{ slot = _W , champName = "Pantheon"			, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	}, -- check spellname
-- Poppy
["PoppyHeroicCharge"]			= 	{ slot = _E , champName = "Poppy"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	},
-- Quinn
["QuinnQ"]						= 	{ slot = _Q , champName = "Quinn"				, spellType = "line" 		, projectileSpeed = 1550		, spellDelay = 250	, spellRange = 1050		, spellRadius = 80		, collision = true	, projectileName = "Quinn_Q_missile.troy"},
["QuinnE"]						= 	{ slot = _E , champName = "Quinn"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 700		, spellRadius = 0		, collision = false	},
-- Rammus
["PuncturingTaunt"]				= 	{ slot = _E , champName = "Rammus"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 325		, spellRadius = 0		, collision = false	},
-- Rengar
["RengarE"]						= 	{ slot = _E , champName = "Rengar"				, spellType = "line" 		, projectileSpeed = 1500		, spellDelay = 250	, spellRange = 1000		, spellRadius = 70		, collision = true	, projectileName = ""},
-- Riven
["RivenMartyr"]					= 	{ slot = _W , champName = "Riven"				, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 280		, spellRadius = 280		, collision = false	},
-- Rumble
["RumbleGrenade"]				= 	{ slot = _E , champName = "Rumble"				, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 950		, spellRadius = 90		, collision = true	, projectileName = "rumble_taze_mis.troy"},
-- Ryze
["RyzeW"]						= 	{ slot = _W , champName = "Ryze"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 600		, spellRadius = 0		, collision = false	},
-- Sejuani
["SejuaniArcticAssault"]		= 	{ slot = _Q , champName = "Sejuani"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 0	, spellRange = 900		, spellRadius = 70		, collision = false	, projectileName = ""},
["SejuaniGlacialPrisonCast"]	= 	{ slot = _R , champName = "Sejuani"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 1200		, spellRadius = 110		, collision = false	, projectileName = ""},
-- Shaco
["TwoShivPoison"]				= 	{ slot = _E , champName = "Shaco"				, spellType = "target" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 625		, spellRadius = 0		, collision = false	},
-- Shen
["ShenShadowDash"]				= 	{ slot = _E , champName = "Shen"				, spellType = "line" 		, projectileSpeed = 1600		, spellDelay = 0	, spellRange = 650		, spellRadius = 50		, collision = false	, projectileName = ""},
-- Shyvana
["ShyvanaTransformCast"]		= 	{ slot = _R , champName = "Shyvana"				, spellType = "line" 		, projectileSpeed = 1100		, spellDelay = 10	, spellRange = 1000		, spellRadius = 160		, collision = false	, projectileName = ""},
-- Singed
["Fling"]						= 	{ slot = _E , champName = "Singed"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 125		, spellRadius = 0		, collision = false	},
-- Skarner
["SkarnerFracture"]				= 	{ slot = _E , champName = "Skarner"				, spellType = "line" 		, projectileSpeed = 1400		, spellDelay = 250	, spellRange = 1000		, spellRadius = 60		, collision = false	, projectileName = ""},
["SkarnerImpale"]				= 	{ slot = _R , champName = "Skarner"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 350		, spellRadius = 0		, collision = false	}, -- check spellname
-- Sona
["SonaR"]						= 	{ slot = _R , champName = "Sona"				, spellType = "line" 		, projectileSpeed = 2400		, spellDelay = 250	, spellRange = 1000		, spellRadius = 140		, collision = false	, projectileName = ""},
-- Swain
["SwainQ"]						= 	{ slot = _Q , champName = "Swain"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 625		, spellRadius = 0		, collision = false	}, -- check spellname
["SwainShadowGrasp"]			= 	{ slot = _W , champName = "Swain"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1100	, spellRange = 900		, spellRadius = 250		, collision = false	},
-- Syndra
["syndrawcast"]					= 	{ slot = _W , champName = "Syndra"				, spellType = "circular" 	, projectileSpeed = 1450		, spellDelay = 250	, spellRange = 925		, spellRadius = 220		, collision = false	},
["SyndraE"]						= 	{ slot = _E , champName = "Syndra"				, spellType = "line" 		, projectileSpeed = 1500		, spellDelay = 250	, spellRange = 800		, spellRadius = 150		, collision = false	, projectileName = ""},
-- TahmKench
["TahmKenchQ"]					= 	{ slot = _Q , champName = "TahmKench"			, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 950		, spellRadius = 90		, collision = true	, projectileName = ""},
["TahmKenchE"]					= 	{ slot = _E , champName = "TahmKench"			, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 250		, spellRadius = 0		, collision = false	}, -- check spellname
-- Taric
["Dazzle"]						= 	{ slot = _E , champName = "Taric"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 625		, spellRadius = 0		, collision = false	}, -- check spellname
-- Teemo
["BlindingDart"]				= 	{ slot = _Q , champName = "Teemo"				, spellType = "target" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 580		, spellRadius = 0		, collision = false	},
-- Thresh
["ThreshQ"]						= 	{ slot = _Q , champName = "Thresh"				, spellType = "line" 		, projectileSpeed = 1900		, spellDelay = 500	, spellRange = 1100		, spellRadius = 70		, collision = true	, projectileName = ""},
["ThreshE"]						= 	{ slot = _E , champName = "Thresh"				, spellType = "line" 		, projectileSpeed = 2000		, spellDelay = 0	, spellRange = 1075/2	, spellRadius = 110		, collision = false	, projectileName = ""},
-- Tristana
["TristanaR"]					= 	{ slot = _R , champName = "Tristana"			, spellType = "target" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 669		, spellRadius = 0		, collision = false	},
-- Tryndamere
["MockingShout"] 				= 	{ slot = _W , champName = "Tryndamere"			, spellType = "aoe" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 400		, spellRadius = 400		, collision = false	},
-- Urgot
["UrgotR"]						= 	{ slot = _R , champName = "Urgot"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 250	, spellRange = 850		, spellRadius = 0		, collision = false	}, -- check spellName
-- Varus
["VarusR"]						= 	{ slot = _R , champName = "Varus"				, spellType = "line" 		, projectileSpeed = 1950		, spellDelay = 250	, spellRange = 1200		, spellRadius = 100		, collision = false	, projectileName = ""},
-- Vayne
["VayneCondemn"]				= 	{ slot = _E , champName = "Vayne"				, spellType = "target" 		, projectileSpeed = 2000		, spellDelay = 250	, spellRange = 550		, spellRadius = 0		, collision = false	},
-- Veigar
["VeigarEventHorizon"]			= 	{ slot = _E , champName = "Veigar"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 500	, spellRange = 700		, spellRadius = 425		, collision = false	},
-- VelKoz
["VelkozQMissile"]				= 	{ slot = _Q , champName = "Velkoz"				, spellType = "line" 		, projectileSpeed = 1300		, spellDelay = 250	, spellRange = 1250		, spellRadius = 50		, collision = true	, projectileName = ""},
["VelkozQMissileSplit"]			= 	{ slot = _Q , champName = "Velkoz"				, spellType = "line" 		, projectileSpeed = 2100		, spellDelay = 0	, spellRange = 1100		, spellRadius = 45		, collision = true	, projectileName = ""},
["VelkozE"]						= 	{ slot = _E , champName = "Velkoz"				, spellType = "circular" 	, projectileSpeed = 1500		, spellDelay = 0	, spellRange = 950		, spellRadius = 225		, collision = false	},
-- Vi
["ViQMissile"]					= 	{ slot = _Q , champName = "Vi"					, spellType = "line" 		, projectileSpeed = 1500		, spellDelay = 0	, spellRange = 725		, spellRadius = 90		, collision = false	, projectileName = ""},
["ViR"]							= 	{ slot = _R , champName = "Vi"					, spellType = "line" 		, projectileSpeed = 1000		, spellDelay = 250	, spellRange = 800		, spellRadius = 0		, collision = false	, projectileName = ""}, -- check spellname
-- Viktor
["ViktorGravitonField"]			= 	{ slot = _W , champName = "Viktor"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 1500	, spellRange = 625		, spellRadius = 300		, collision = false	},
-- Warwick
["InfiniteDuress"]				= 	{ slot = _R , champName = "Warwick"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 0	, spellRange = 700		, spellRadius = 0		, collision = false	}, -- check spellname
-- Xerath
["XerathArcaneBarrage2"]		= 	{ slot = _W , champName = "Xerath"				, spellType = "circular" 	, projectileSpeed = 1600		, spellDelay = 250	, spellRange = 1125		, spellRadius = 60		, collision = true	},
["XerathMageSpear"]				= 	{ slot = _E , champName = "Xerath"				, spellType = "line" 		, projectileSpeed = math.huge	, spellDelay = 750	, spellRange = 1100		, spellRadius = 280		, collision = false	, projectileName = ""},
-- Yasou
["yasuoq3w"]					= 	{ slot = _Q , champName = "Yasou"				, spellType = "line" 		, projectileSpeed = 1200		, spellDelay = 250	, spellRange = 1025		, spellRadius = 90		, collision = false	, projectileName = ""},
-- Zac
["ZacQ"]						= 	{ slot = _Q , champName = "Zac"					, spellType = "line" 		, projectileSpeed = math.huge	, spellDelay = 500	, spellRange = 550		, spellRadius = 120		, collision = false	, projectileName = ""},
["ZacE"]						= 	{ slot = _E , champName = "Zac"					, spellType = "circular" 	, projectileSpeed = 1500		, spellDelay = 0	, spellRange = 1800		, spellRadius = 300		, collision = false	}, -- check spellname, projectileSpeed
-- Ziggs
["ZiggsW"]						= 	{ slot = _W , champName = "Ziggs"				, spellType = "circular" 	, projectileSpeed = 3000		, spellDelay = 250	, spellRange = 2000		, spellRadius = 275		, collision = false	},
-- Zilean
["ZileanQ"]						= 	{ slot = _Q , champName = "Zilean"				, spellType = "circular" 	, projectileSpeed = 2000		, spellDelay = 300	, spellRange = 900		, spellRadius = 250		, collision = false	},
["TimeWarp"]					= 	{ slot = _E , champName = "Zilean"				, spellType = "target" 		, projectileSpeed = math.huge	, spellDelay = 0	, spellRange = 550		, spellRadius = 0		, collision = false	},
-- Zyra
["ZyraGraspingRoots"]			= 	{ slot = _E , champName = "Zyra"				, spellType = "line" 		, projectileSpeed = 1400		, spellDelay = 250	, spellRange = 1150		, spellRadius = 70		, collision = false	, projectileName = ""},
["ZyraBrambleZone"]				= 	{ slot = _R , champName = "Zyra"				, spellType = "circular" 	, projectileSpeed = math.huge	, spellDelay = 500	, spellRange = 700		, spellRadius = 525		, collision = false	}
}

local global_ticks = 0
local global_ticks1 = 0

function DistanceBetween(p1,p2)
return  math.sqrt(math.pow((p2.x - p1.x),2) + math.pow((p2.y - p1.y),2) + math.pow((p2.z - p1.z),2))
end

OnProcessSpell(function(unit, spellProc)
-- W
if TroopNoc.AutoW.CC:Value() then
local CCSpell = CC[spellProc.name]
	if CCSpell then
		if CCSpell.champName == GetObjectName(unit) and GetTeam(unit) ~= GetTeam(myHero) and GetObjectType(unit) == Obj_AI_Hero and CanUseSpell(myHero,_W) == READY then
			if spellProc.target == myHero and CCSpell.spellType == "target" then
				CastSpell(_W)
			end
			if CCSpell.spellType == "line" and IsInDistance(unit, CCSpell.spellRange + GetMoveSpeed(myHero)) then
				CCVector = VectorWay(spellProc.startPos, spellProc.endPos)
				CCDistanceStartEnd = DistanceBetween(spellProc.startPos, spellProc.endPos)
				CCVector = (CCVector/CCDistanceStartEnd)*CCSpell.spellRange
				CCSpellTimeNeed = ((CCSpell.spellRange / (CCSpell.projectileSpeed+50))*1000)+CCSpell.spellDelay
				WayOnTime = CCVector/CCSpellTimeNeed
				startTime = GetGameTimer()
				stargingPos = spellProc.startPos
				endingPos = spellProc.startPos + CCVector
				radius = CCSpell.spellRadius
					-- end
				--	

				--
			end
			if CCSpell.spellType == "circular" and IsInDistance(unit, CCSpell.spellRange + GetMoveSpeed(myHero)) then
				local spellTime = (DistanceBetween((GetOrigin(unit)),spellProc.endPos) / CCSpell.projectileSpeed) * 1000 + CCSpell.spellDelay
				local Ticker = GetTickCount()	
				if (global_ticks) < Ticker then
					DelayAction(function()
								
						if GetDistance(spellProc.endPos) < CCSpell.spellRadius then
							CastSpell(_W)
						end
					end, (spellTime)/1000 - 0.23)
					global_ticks = Ticker
				end	
			end
			if CCSpell.spellType == "aoe"  and IsInDistance(unit, CCSpell.spellRange) then
				CastSpell(_W)
			end
		end
	end
end

end)



OnTick(function ()
	
	local Ig = (50 + (20 * GetLevel(myHero)))
	local GetPercentMana = (GetCurrentMana(myHero) / GetMaxMana(myHero)) * 100
	local target = GetCurrentTarget()
	local Hydra = GetItemSlot(myHero, 3074)
	local Tiamat = GetItemSlot(myHero, 3077)
	local Bilgewater = GetItemSlot(myHero, 3144)
	local BOTRK = GetItemSlot(myHero, 3153)
	local movePos = GetPrediction(target,Move).castPos

		if startTime ~= nil then
			local Time = GetGameTimer() - startTime
			Time = Time*1000
			local spellPos0 = stargingPos + ((Time+25)*WayOnTime)
			local spellPos = stargingPos + (Time*WayOnTime)
			local spellPos1 = stargingPos + ((Time-150)*WayOnTime)
			local spellPos2 = stargingPos + ((Time-100)*WayOnTime)
			local spellPos3 = stargingPos + ((Time-50)*WayOnTime)
			-- DrawCircle(endingPos, radius,3,255,0xff0ffff0)
			-- DrawCircle(spellPos, radius+GetHitBox(myHero)*1.8,1,255,0xffffffff)
			-- DrawCircle(spellPos0, radius+GetHitBox(myHero)*1.8,1,255,0xffffffff)
			-- DrawCircle(spellPos1, radius+GetHitBox(myHero)*1.8,1,255,0xffffffff)
			if CanUseSpell(myHero,_W) == READY then
				if GetDistance(spellPos0) <= radius+GetHitBox(myHero)*1.2 then
					-- CastSpell(_W)
				end
				if GetDistance(spellPos) <= radius+GetHitBox(myHero)*1.2 then
					CastSpell(_W)
				end
				if GetDistance(spellPos1) <= radius+GetHitBox(myHero)*1.2 then
					CastSpell(_W)
				end
				if GetDistance(spellPos2) <= radius+GetHitBox(myHero)*1.2 then
					CastSpell(_W)
				end
				if GetDistance(spellPos3) <= radius+GetHitBox(myHero)*1.2 then
					CastSpell(_W)
				end
			end
			if Time >= CCSpellTimeNeed then
				startTime = nil
			end
		end


	     local myHeroPos = GetOrigin(myHero)

	
	if TroopNoc.Misc.Lvlup:Value() then
		spellorder = {_Q, _W, _E, _Q, _Q, _R, _Q, _E, _Q, _E, _R, _E, _E, _W, _W, _R, _W, _W}	
		if GetLevelPoints(myHero) > 0 then
			LevelSpell(spellorder[GetLevel(myHero) + 1 - GetLevelPoints(myHero)])
		end
	end


	if Mode() == "Combo" then
		
		if TroopNoc.Combo.QCombNoc:Value() and Ready(_Q) and ValidTarget(target, 1300) then
				if TroopNoc.Combo.MinManaNoc:Value() <= GetPercentMana then 
				local Qpred = GetPrediction(target, NocQ)
				if Qpred.hitChance >= (TroopNoc.Prediction.Q:Value() * 0.01) then
					CastSkillShot(_Q,Qpred.castPos)	
				end
			end
		end

		if TroopNoc.Combo.HydraCombNoc:Value() and Hydra > 0 and Ready(Hydra) and ValidTarget(target, 350) then
			CastSpell(Hydra)
		end

		if TroopNoc.Combo.TiamatCombNoc:Value() and Tiamat > 0 and Ready(Tiamat) and ValidTarget(target, 350) then
			CastSpell(Tiamat)
		end


		if TroopNoc.Combo.Blade:Value() and Ready(BOTRK) and ValidTarget(target, 550) then
			if GetPercentHP(myHero) <= 85 and GetDistance(movePos) < GetDistance(target) then
				CastTargetSpell(target, BOTRK)
			end
		end
		
		if TroopNoc.Combo.Blade:Value() and Ready(BOTRK) and ValidTarget(target, 550) then
			if GetPercentHP(myHero) > GetPercentHP(target) and GetDistance(movePos) > GetDistance(target) then
				CastTargetSpell(target, BOTRK)
			end
		end		
				

		if TroopNoc.Combo.Bilgewater:Value() and Ready(Bilgewater) and ValidTarget(target, 550) then
			if GetPercentHP(myHero) > GetPercentHP(target) and GetDistance(movePos) > GetDistance(target) then
				CastTargetSpell(target, Bilgewater)
			end
		end

		if TroopNoc.Combo.Bilgewater:Value() and Ready(Bilgewater) and ValidTarget(target, 550) then
			if GetPercentHP(myHero) >= 60 and GetDistance(movePos) < GetDistance(target) then
				CastTargetSpell(target, Bilgewater)
			end
		end

		if TroopNoc.Combo.ECombNoc:Value() and Ready(_E) and ValidTarget(target, 425) then
			if TroopNoc.Combo.MinManaNoc:Value() <= GetPercentMana then
			  	CastTargetSpell(target, _E)
			end
		end

		if TroopNoc.Combo.RCombNoc:Value() and Ready(_R) and ValidTarget(target, 2000) then
			if TroopNoc.Combo.MinManaNoc:Value() <= GetPercentMana then
			  	CastTargetSpell(target, _R)
			end
		end
	end


	if Mode() == "Harass" then

		if TroopNoc.Harass.QHarassNoc:Value() and Ready(_Q) and ValidTarget(target, 1300) then
			if TroopNoc.Harass.HarassMinMana:Value() <= GetPercentMana then
				local Qpred = GetPrediction(target, NocQ)
				if Qpred.hitChance >= (TroopNoc.Prediction.Q:Value() * 0.01) then
					CastSkillShot(_Q,Qpred.castPos)	
			end
		end

		if TroopNoc.Harass.EHarassNoc:Value() and Ready(_E) and ValidTarget(target, 425) then
			if TroopNoc.Harass.HarassMinMana:Value() <= GetPercentMana then
				CastTargetSpell(target, _E)
			end
		end
	end

end	



    if Mode() == "LaneClear" then
		
		for _, closeminion in pairs(minionManager.objects) do
			if TroopNoc.LaneClear.Qlc:Value() and ValidTarget(closeminion, 1300) then
				if GetPercentMP(myHero) >= TroopNoc.LaneClear.MinManaLC:Value() then
					CastSkillShot(_Q, closeminion)
				end
			end
		end
		
end



	for _, enemy in pairs(GetEnemyHeroes()) do
			--Auto Ignite 
	     if GetCastName(myHero, SUMMONER_1):lower():find("summonerdot") then
			if TroopNoc.Misc.Ig:Value() and Ready(SUMMONER_1) and ValidTarget(enemy, 600) then
				if GetCurrentHP(enemy) < Ig then
					CastTargetSpell(enemy, SUMMONER_1)
				end
			end
		end
	
	     if GetCastName(myHero, SUMMONER_2):lower():find("summonerdot") then
			if TroopNoc.Misc.Ig:Value() and Ready(SUMMONER_2) and ValidTarget(enemy, 600) then
				if GetCurrentHP(enemy) < Ig then
					CastTargetSpell(enemy, SUMMONER_2)
				end
			end
		end
	end
end)



function VectorWay(A,B)
WayX = B.x - A.x
WayY = B.y - A.y
WayZ = B.z - A.z
return Vector(WayX, WayY, WayZ)
end



OnDraw(function(myHero)
	local pos = GetOrigin(myHero)
	local mpos = GetMousePos()
	if TroopNoc.Draw.DrawQ:Value() then DrawCircle(pos, 1300, 1, 25, GoS.Red) end
	if TroopNoc.Draw.DrawW:Value() then DrawCircle(pos, 125, 1, 25, GoS.Blue) end
	if TroopNoc.Draw.DrawE:Value() then DrawCircle(pos, 425, 1, 25, GoS.Black) end
	if TroopNoc.Draw.DrawR:Value() then DrawCircle(pos, 2000, 1, 25, GoS.Green) end
end)

print("TroopNoc , dominate the rift!")