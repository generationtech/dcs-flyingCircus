-- CREATE RANDOM AIR TRAFFIC

-- Spawns a random aircraft for each non-neutral country
-- Randomizes aircraft type and model
-- Randomizes aircraft skin appropriate for randomly selected country
-- In ME, assign coalition country to control airbase to enable random spawn there
-- To disable a country from random spawn, assign it to the neutral coalition
-- Also flies to a random waypoint between take-off and landing airbase

-- Many other random settings: fuel, weapons, take-off waypoint, pilot skill

do

----------------------
-- GLOBAL VARIABLES --
----------------------

--DEBUG
g_debugLog             = 2			-- 0: no log file messages, 1: informational, 2: verbose
g_debugScreen          = true		-- write messages to screen

--GENERAL PARAMETERS
g_spawnIntervalLow     = 30			-- Random spawn low end repeat interval
g_spawnIntervalHigh    = 60			-- Random spawn high end repeat interval
g_maxCoalitionAircraft = {20, 20}	-- Maximum number of red, blue units
g_randomCoalitionSpawn = 3			-- Coalition spawn style: 1=random coalition, 2=equal spawn per coalition each time, 3=fair spawn-try to keep total units equal for each coalition ( g_maxCoalitionAircraft{} must be equal for #3 to work)
g_aircraftDistribution = {10, 5, 20, 100, 20}	-- Distribution of aircraft type Utility, Bomber, Attack, Fighter, Helicopter (must be 1-100 range array)
g_namePrefix           = {"Red-", "Blue-"}		-- Prefix to use for naming groups

--STUCK CONDITION CHECKING
g_checkInterval        = 20			-- How frequently to check dynamic AI groups status (effective rate to remove stuck aircraft is combined with g_waitTime in f_checkStatus() function)
g_waitTime             = 15			-- Amount to time to wait before considering aircraft to be parked or stuck
g_minDamagedLife       = 0.10		-- Minimum % amount of life for aircraft under g_minDamagedHeight
g_minDamagedHeight     = 20			-- Minimum height to start checking for g_minDamagedLife

--AIRCRAFT CONFIGURATIONS
g_flagRandomFuel       = true		-- Random fuel loadout?
g_lowFuelPercent       = 0.50		-- If randomizing fuel, the low end percent
g_highFuelPercent      = 1.00		-- If randomizing fuel, the high end percent

g_flagRandomWeapons    = true		-- Add weapons to aircraft?

g_flagRandomSkins      = true		-- Randomize the skins for each aircraft (otherwise just choose 1st defined skin)

g_flagRandomSkill      = true		-- Randomize AI pilot skill level
g_unitSkillDefault     = 4			-- Default unit skill if not using randomize unitSkill[g_unitSkillDefault]
g_unitSkill            = 			-- List of possible skill levels for AI units
						{
							"Average",
							"Good",
							"High",
							"Excellent",
							"Random"
						}

--AIRCRAFT FORMATIONS
g_flagRandomGroupSize  = true		-- Randomize group size, if applicable
g_defaultGroupSize	   = 2			-- If not randomized, group size for those units supporting formations
g_maxGroupSize         = 4			-- Maximum number of groups for those units supporting formations
g_minGroupSize         = 1			-- Minimum number of groups for those units supporting formations

g_flagRandomFormation  = true		-- Randomize formations in multiple unit groups, else use default formation value
g_defaultAirplaneFormation   = 1	-- When not randomizing formations, the default airplane formation #
g_defaultHelicopterFormation = 1	-- When not randomizing formations, the default helicopter formation #
g_airplaneFormation    =			-- Airplane formations
						{			-- {"Formation Name", "variantIndex", "name", "formationIndex", "value"}
							[1]  = {"Line Abreast - Open", 2, 5, 1, 65538},
							[2]  = {"Line Abreast - Close", 1, 5, 1, 65537},
							[3]  = {"Trail - Open", 2, 5, 2, 131074},
							[4]  = {"Trail - Close", 1, 5, 2, 131073},
							[5]  = {"Wedge - Open", 2, 5, 3, 196610},
							[6]  = {"Wedge - Close", 1, 5, 3, 196609},
							[7]  = {"Echelon Right - Open", 2, 5, 4, 262146},
							[8]  = {"Echelon Right - Close", 1, 5, 4, 262145},
							[9]  = {"Echelon Left - Open", 2, 5, 5, 327682},
							[10] = {"Echelon Left - Close", 1, 5, 5, 327681},
							[11] = {"Finger Four - Open", 2, 5, 6, 393218},
							[12] = {"Finger Four - Close", 1, 5, 6, 393217},
							[13] = {"Spread Four - Open", 2, 5, 7, 458754},
							[14] = {"Spread Four - Close", 1, 5, 7, 458753}
						}
g_helicopterFormation  =			-- Helicopter formations
						{			-- {"Formation Name", "variantIndex", "zInverse", "name", "formationIndex", "value"}
							[1]  = {"Wedge",	nil, nil, 5, 8, 8},
							[2]  = {"Right - interval 300", 1, 0, 5, 10, 655361},
							[3]  = {"Right - interval 600", 2, 0, 5, 10, 655362},
							[4]  = {"Left - interval 300", 1, 1, 5, 10, 655617},
							[5]  = {"Left - interval 600", 2, 1, 5, 10, 655618},
							[6]  = {"Echelon - Right - 50x70", 1, 0, 5, 9, 589825},
							[7]  = {"Echelon - Right - 50x300", 2, 0, 5, 9, 589826},
							[8]  = {"Echelon - Right - 50x600", 3, 0, 5, 9, 589827},
							[9]  = {"Echelon - Left - 50x70", 1, 1, 5, 9, 590081},
							[10] = {"Echelon - Left - 50x300", 2, 1, 5, 9, 590082},
							[11] = {"Echelon - Left - 50x600", 3, 1, 5, 9, 590083},
							[12] = {"Column", nil, nil, 5, 11, 720896}
						}

--AIRCRAFT FLIGHTPATH
g_flagNoSpawnLandingAirbase = true	-- Don't allow spawning airbase and landing airbase to be the same?

g_flagSetTasks              = true	-- Enable general tasks appropriate for each unit (CAP, CAS, REFUEL, etc)

g_flagRandomAltitude        = true	-- Randomize altitude (otherwise use standard altitude per aircraft type)

g_flagRandomSpeed           = true	-- Randomize altitude (otherwise use standard speed per aircraft type)
g_spawnSpeedTurningPoint    = 125	-- When spawning in the air as turning point, starting speed

g_flagRandomWaypoint        = true	-- Create intermediate waypoint?
g_waypointRange             = {40000, 40000}	-- Maximum x,y of where to place intermediate waypoint between takeoff

g_flagRandomSpawnType       = true	-- Randomize type of parking spot for spawn location
g_defaultSpawnType    		= 5		-- If not randomizing spawn parking spot, which one should be used as default g_spawnType[?/2+1]
g_spawnType           =
							{		-- List of waypoint styles used for spawn point (2 entries for each, one type and one for action)
								{"TakeOffParking", "From Parking Area"},
								{"TakeOffParkingHot", "From Parking Area Hot"},
								{"TakeOff", "From Runway"},
								{"Turning Point", "Fly Over Point"},
								{"Turning Point", "Turning Point"},
							}


-------------------------------------------
-- Should be no need to edit these below --
-------------------------------------------
g_RATtable      = {}
g_spawnInterval = math.random(g_spawnIntervalLow, g_spawnIntervalHigh)	-- Initial random spawn repeat interval
g_AB            = {}													-- Coalition AirBase table

-- Inventory running limits
g_numCoalitionAircraft = {0, 0}											-- Current number of active coalition units
g_numCoalitionGroup    = {0, 0}											-- Cumulative highest coalition groups

--env.setErrorMessageBoxEnabled(false)

g_airbasePoints = 					-- These are the start and end x,z points for each airbase runway in the direction of normal take-off traffic
	{								-- Use for the fly over points when spawning aircraft airborne
									-- {x1, z1, x2, z2, psi, heading}
		[12] = {-6495.7142857133,242167.42857143,-4321.7142857133,244091.42857143,-0.724468306690539,0.724468306690539},	-- Anapa-Vityazevo
		[13] = {11751.428571429,369204.85714286,11620.000000001,366703.71428572,1.62329544850684,-1.62329544850684},		-- Krasnodar-Center
		[14] = {-40248.857142856,279856.28571428,-41589.428571427,278650.57142857,2.40910735155739,-2.40910735155739},		-- Novorossiysk
		[15] = {-5579.7142857133,295210.57142857,-7585.9999999991,293555.14285714,2.45172058746978,-2.45172058746978},		-- Krymsk
		[16] = {-25197.428571427,459052.57142857,-27686.57142857,457036.28571429,2.46076441819486,-2.46076441819486},		-- Maykop-Khanskaya
		[17] = {-49706.57142857,298970.28571429,-51087.142857141,297810.85714286,2.44303961565279,-2.44303961565279},		-- Gelendzhik
		[18] = {-163750.28571428,463622.57142857,-165212.85714286,460870,2.05920616746982,-2.05920616746982},				-- Sochi-Adler
		[19] = {6652.2857142863,386738.57142858,8764.8571428577,389003.71428572,-0.820235909742805,0.820235909742805},		-- Krasnodar-Pashkovsky
		[20] = {-221401.14285714,566015.71428571,-219751.42857143,562707.14285714,1.10825468264437,-1.10825468264437},		-- Sukhumi-Babushara
		[21] = {-197811.42857143,517063.14285714,-195622.28571428,515849.42857143,0.506233740419563,-0.506233740419563},	-- Gudauta
		[22] = {-356549.42857143,618419.42857144,-355121.14285714,616421.14285715,0.95023583247859,-0.95023583247859},		-- Batumi
		[23] = {-281681.14285714,646054,-281882.28571429,648431.42857143,4.62798477132166,-4.62798477132166},				-- Senaki-Kolkhi
		[24] = {-318368,634520.57142858,-317545.42857143,636779.14285715,-1.22234030943342,1.22234030943342},				-- Kobuleti
		[25] = {-285233.71428571,682650.57142857,-284543.14285714,685056.85714286,-1.29132089859535,1.29132089859535},		-- Kutaisi
		[26] = {-52128.285714285,707572.28571429,-50388.857142856,703892.28571429,1.12925011719757,-1.12925011719757},		-- Mineralnye Vody
		[27] = {-125580.57142857,759479.14285715,-124274.85714286,761378.00000001,-0.968419584342998,0.968419584342998},	-- Nalchik
		[28] = {-83740.571428571,832212.57142857,-83294.857142857,835718.57142857,-1.44434563501146,1.44434563501146},		-- Mozdok
		[29] = {-316481.42857143,897668.85714286,-314624.28571428,895291.42857143,0.90765164013325,-0.90765164013325},		-- Tbilisi-Lochini
		[30] = {-316999.71428571,894496.57142857,-318664,896327.71428572,3.97469042602364,-3.97469042602364},				-- Soganlug
		[31] = {-318175.14285714,902274.28571429,-319966.57142857,904036.85714286,3.91887137165303,-3.91887137165303},		-- Vaziani
		[32] = {-148494.57142857,842108,-148685.42857143,845221.42857144,4.65116431906051,-4.65116431906051}				-- Beslan
	}


------------------------------------------------------------------
-- Big matrix mapping all countries to their aircraft and skins --
------------------------------------------------------------------
g_coalitionTable =
	{	-- Countries
	[0] =													--RUSSIA
		{ -- Aircraft types
		["name"] = "RUSSIA",
		[1] = -- Utility
			{	-- Aircraft, skins
				{14, 1, 2},				-- A-50
				{1, 4, 5},				-- An-26B
				{2, 2},					-- An-30M
				{7, 3, 4, 5},			-- IL-76MD
				{15, 1, 2, 3},			-- IL-78M
				{9, 1},					-- MiG-25RBT
				{11, 1},				-- Su-24MR
				{12, 1},				-- TF-51D
				{13, 3},				-- Yak-40
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				{21, 1},				-- Su-24M
				{26, 1},				-- Tu-142
				{27, 1},				-- Tu-160
				{24, 1},				-- Tu-22M3
				{25, 1},				-- Tu-95MS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 36, 37},			-- A-10C
				{30, 2},				-- Hawk
				{31, 3, 4, 5},			-- L-39ZA
				{32, 1},				-- MiG-27K
				{33, 1, 2},				-- Su-17M4
				{34, 2, 7, 8, 9},		-- Su-25
				{35, 1, 2, 3},			-- Su-25T
				{36, 1},				-- Su-25TM
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},													-- F-86F Sabre
				{47, 9},													-- FW-190D9
				{49, 1, 2, 3, 4, 5, 6},										-- MiG-21Bis
				{50, 1, 2, 3, 4},											-- MiG-23MLD
				{51, 1},													-- MiG-25PD
				{52, 3, 4, 5, 6, 7},										-- MiG-29A
				{59, 1, 2, 3, 4, 5, 6, 7},									-- MiG-29S
				{60, 1, 2, 3},												-- MiG-31
				{56, 1, 2, 3, 27, 31, 32, 33, 34, 35, 36},					-- P-51D
				{57, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19},	-- Su-27
				{61, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},						-- Su-30
				{62, 1, 2, 3, 4, 5, 6, 7, 8},								-- Su-33
				{63, 1, 2},													-- Su-34
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{69, 2},													-- Ka-27
				{70, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44},	-- Ka-50
				{71, 4, 5, 6, 7},											-- Mi-24V
				{72, 3, 4, 5, 6},											-- Mi-26
				{77, 1, 2},													-- Mi-28N
				{73, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},		-- Mi-8MT
				{76, 29, 30},												-- UH-1H
			},
		},
	[1] = 													--UKRAINE
		{ -- Aircraft types
		["name"] = "UKRAINE",
		[1] = -- Utility
			{	-- Aircraft, skins
				{1, 2},					-- An-26B
				{2, 1},					-- An-30M
				{7, 1, 2},				-- IL-76MD
				{9, 1},					-- MiG-25RBT
				{11, 1},				-- Su-24MR
				{13, 2},				-- Yak-40
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				{21, 1},				-- Su-24M
				{24, 1},				-- Tu-22M3
				{25, 1},				-- Tu-95MS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 35},				-- A-10C
				{30, 2},				-- Hawk
				{31, 2},				-- L-39ZA
				{32, 1},				-- MiG-27K
				{33, 1, 2, 3},			-- Su-17M4
				{34, 3, 4, 5, 6},		-- Su-25
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},				-- F-86F Sabre
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{50, 1},				-- MiG-23MLD
				{51, 1},				-- MiG-25PD
				{52, 1, 2, 3},			-- MiG-29A
				{54, 1, 2, 3},			-- MiG-29S
				{56, 1, 2, 3, 29, 30},	-- P-51D
				{57, 1, 2, 3, 4, 5},	-- Su-27
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{69, 1},				-- Ka-27
				{70, 29, 30 ,31},		-- Ka-50
				{71, 2, 3},				-- Mi-24V
				{72, 1, 2},				-- Mi-26
				{73, 1},				-- Mi-8MT
				{76, 28},				-- UH-1H
			},
		},
	[2] = 													--USA
		{ -- Aircraft types
		["name"] = "USA",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 1},					-- C-130
				{4, 1},					-- C-17A
				{5, 1, 2},				-- E-2C
				{6, 1, 2},				-- E-3A
				{8, 1},					-- KC-135
				{10, 1},				-- S-3B Tanker
				{12, 2, 3, 4, 5},		-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				{16, 1},				-- B-1B
				{17, 1},				-- B-52H
				{18, 1},				-- F-117A
				{19, 1, 2},				-- F-15E
				{20, 1},				-- S-3B
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{28, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18},		-- A-10A
				{29, 2, 3, 4, 5,6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19},		-- A-10C
				{30, 2, 3, 4, 5, 6, 7},														-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{38, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},										-- F-14A
				{39, 1, 2, 3, 4, 5, 6, 7, 8},												-- F-15C
				{40, 1},																	-- F-16A
				{41, 1, 2, 3, 4, 5, 6, 7, 8},												-- F-16C bl.52d
				{44, 1, 2, 3, 4, 5, 6, 7, 8, 9},											-- F-5E
				{45, 1},																	-- F-86F Sabre
				{46, 2, 3, 4, 5},															-- F/A-18C
				{47, 1},																	-- FW-190D9
				{48, 1},																	-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},														-- MiG-21Bis
				{56, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22},	-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{64, 1, 2, 3},								-- AH-1W
				{65, 1, 2},									-- AH-64A
				{66, 1},									-- AH-64D
				{67, 1},									-- CH-47D
				{68, 1},									-- CH-53E
				{70, 1, 2, 3},								-- Ka-50
				{73, 1, 2, 3},								-- Mi-8MT
				{74, 1},									-- OH-58D
				{75, 1},									-- SH-60B
				{76, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},-- UH-1H
			},
		},
	[3] = 													--TURKEY
		{ -- Aircraft types
		["name"] = "TURKEY",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 11},				-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 1},				-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{58, 1},				-- F-16C bl.50
				{43, 1},				-- F-4E
				{44, 10},				-- F-5E
				{45, 1},				-- F-86F Sabre
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{64, 4, 5},				-- AH-1W
				{70, 47, 48, 49, 50},	-- Ka-50
				{73, 1, 2, 33},			-- Mi-8MT
				{76, 31},				-- UH-1H
				{78, 1},				-- UH-60A
			},
		},
	[4] = 													--UK
		{ -- Aircraft types
		["name"] = "UK",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 10},				-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				{22, 1, 2, 3, 4, 5, 6},	-- Tornado GR4
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 1},									-- A-10C
				{30, 2, 9, 10, 11, 12, 13, 14, 15, 16, 17},	-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},				-- F-86F Sabre
				{47, 8},				-- FW-190D9
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{65, 5},				-- AH-64A
				{66, 4},				-- AH-64D
				{67, 5},				-- CH-47D
				{70, 28},				-- Ka-50
				{73, 1, 2, 18},			-- Mi-8MT
				{76, 11},				-- UH-1H
			},
		},
	[5] = 													--FRANCE
		{ -- Aircraft types
		["name"] = "FRANCE",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 5},					-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 24},				-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},				-- F-86F Sabre
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{55, 1, 2, 3, 4, 5, 6},	-- Mirage 2000-5
				{56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 11, 12, 13},		-- Ka-50
				{73, 1, 2, 7, 8},		-- Mi-8MT
				{76, 17},				-- UH-1H
			},
		},
	[6] = 													--GERMANY
		{ -- Aircraft types
		["name"] = "GERMANY",
		[1] = -- Utility
			{	-- Aircraft, skins
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				{23, 1, 2, 3, 4, 5},	-- Tornado IDS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 27, 28},			-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{37, 1, 2, 3, 4, 5, 6, 7},	-- Bf-109K-4
				{43, 2},				-- F-4E
				{45, 1},				-- F-86F Sabre
				{47, 2, 3, 4, 5, 6, 7},	-- FW-190D9
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{53, 1, 2, 3, 4, 5, 6},	-- MiG-29G
				{56, 1, 2, 3, 24},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 15, 16},			-- Ka-50
				{73, 1, 2, 10},			-- Mi-8MT
				{76, 20},				-- UH-1H
			},
		},
	[8] = 													--CANADA
		{ -- Aircraft types
		["name"] = "CANADA",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 3},					-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 21, 22, 23},		-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},				-- F-86F Sabre
				{46, 1},				-- F/A-18C
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3, 23},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 8},				-- Ka-50
				{73, 1, 2, 5},			-- Mi-8MT
				{76, 16},				-- UH-1H
			},
		},
	[9] = 													--SPAIN
		{ -- Aircraft types
		["name"] = "SPAIN",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 8},					-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 32, 33, 34},		-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},				-- F-86F Sabre
				{46, 1},				-- F/A-18C
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3, 27},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{67, 3},				-- CH-47D
				{70, 23, 24, 25},		-- Ka-50
				{73, 1, 2, 15},			-- Mi-8MT
				{76, 25, 26},			-- UH-1H
			},
		},
	[10] = 													--THE_NETHERLANDS
		{ -- Aircraft types
		["name"] = "THE_NETHERLANDS",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 9},					-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 1},				-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{42, 5, 6},				-- F-16A MLU
				{45, 1},				-- F-86F Sabre
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{65, 4},				-- AH-64A
				{66, 3},				-- AH-64D
				{67, 4},				-- CH-47D
				{70, 26, 27},			-- Ka-50
				{73, 1, 2, 16, 17},		-- Mi-8MT
				{76, 27},				-- UH-1H
			},
		},
	[11] = 													--BELGIUM
		{ -- Aircraft types
		["name"] = "BELGIUM",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 2},					-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 1},				-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{42, 1},				-- F-16A MLU
				{45, 1},				-- F-86F Sabre
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 5, 6, 7},			-- Ka-50
				{73, 4},				-- Mi-8MT
				{76, 11},				-- UH-1H
			},
		},
	[12] = 													--NORWAY
		{ -- Aircraft types
		["name"] = "NORWAY",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 7},					-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 31},				-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{42, 3, 4},				-- F-16A MLU
				{45, 1},				-- F-86F Sabre
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 22},				-- Ka-50
				{73, 1, 2, 14},			-- Mi-8MT
				{76, 11},				-- UH-1H
			},
		},
	[13] = 													--DENMARK
		{ -- Aircraft types
		["name"] = "DENMARK",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 4},					-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 1},				-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{42, 2},				-- F-16A MLU
				{45, 1},				-- F-86F Sabre
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 9, 10},			-- Ka-50
				{73, 6},				-- Mi-8MT
				{76, 11},				-- UH-1H
			},
		},
	[15] = 													--ISRAEL
		{ -- Aircraft types
		["name"] = "ISRAEL",
		[1] = -- Utility
			{	-- Aircraft, skins
				{3, 6},					-- C-130
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				{19, 3},				-- F-15E
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 29},				-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{39, 9},				-- F-15C
				{41, 9},				-- F-16C bl.52d
				{43, 1},				-- F-4E
				{45, 1},				-- F-86F Sabre
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3, 25},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{64, 1},				-- AH-1W
				{65, 3},				-- AH-64A
				{66, 2},				-- AH-64D
				{70, 17, 18, 19},		-- Ka-50
				{73, 1, 2, 11},			-- Mi-8MT
				{76, 21},				-- UH-1H
			},
		},
	[16] = 													--GEORGIA
		{ -- Aircraft types
		["name"] = "GEORGIA",
		[1] = -- Utility
			{	-- Aircraft, skins
				{1, 1},					-- An-26B
				{13, 1},				-- Yak-40
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 25, 26},			-- A-10C
				{30, 2},				-- Hawk
				{31, 1},				-- L-39ZA
				{34, 1, 2},				-- Su-25
				{35, 1, 2},				-- Su-25T
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},				-- F-86F Sabre
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 14},				-- Ka-50
				{71, 1},				-- Mi-24V
				{73, 9},				-- Mi-8MT
				{76, 18, 19},			-- UH-1H
			},
		},
	[17] = 													--INSURGENTS
		{ -- No aircraft
		["name"] = "INSURGENTS",
		},
	[18] = 													--ABKHAZIA
		{ -- Aircraft types
		["name"] = "ABKHAZIA",
		[1] = -- Utility
			{	-- Aircraft, skins
				{1, 5},					-- An-26B
				{12, 1},				-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{30, 2},				-- Hawk
				{31, 6},				-- L-39ZA
				{34, 10},				-- Su-25
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},				-- F-86F Sabre
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 45},				-- Ka-50
				{71, 8},				-- Mi-24V
				{73, 31},				-- Mi-8MT
				{76, 11},				-- UH-1H
			},
		},
	[19] = 													--SOUTH_OSETIA
		{ -- Aircraft types
		["name"] = "SOUTH_OSETIA",
		[1] = -- Utility
			{	-- Aircraft, skins
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},				-- F-86F Sabre
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 46},				-- Ka-50
				{71, 9},				-- Mi-24V
				{73, 32},				-- Mi-8MT
			},
		},
	[20] = 													--ITALY
		{ -- Aircraft types
		["name"] = "ITALY",
		[1] = -- Utility
			{	-- Aircraft, skins
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				{23, 1, 2, 3, 4},		-- Tornado IDS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 30},				-- A-10C
				{30, 2},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{42, 2},				-- F-16A MLU
				{45, 1},				-- F-86F Sabre
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3, 26},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{70, 20, 21},			-- Ka-50
				{73, 1, 2, 12, 13},		-- Mi-8MT
				{76, 22, 23, 24},		-- UH-1H
			},
		},
	[21] = 													--AUSTRALIA
		{ -- Aircraft types
		["name"] = "AUSTRALIA",
		[1] = -- Utility
			{	-- Aircraft, skins
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				{29, 20},				-- A-10C
				{30, 1},				-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				{45, 1},				-- F-86F Sabre
				{46, 6},				-- F/A-18C
				{48, 1},				-- MiG-15bis
				{49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				{56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				{67, 2},				-- CH-47D
				{70, 4},				-- Ka-50
				{76, 13, 14, 15},		-- UH-1H
			},
		},
	}


-----------------------------------------------
-- Big matrix for all sim aircraft and skins --
-----------------------------------------------
g_aircraftTable =
	{
	[1] =								-- An-26B
		{
			aircraftModel = "An-26B",
			category = "AIRPLANE",
			singleInFlight = true,

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5500",
				["flare"] = 384,
				["chaff"] = 384,
				["gun"] = 100,
			},

			skins =
			{
				"Georgian AF",
				"Ukraine AF",
				"RF Air Force",
				"Aeroflot",
				"Abkhazian AF",
			},
		},
	[2] =								-- An-30M
		{
			aircraftModel = "An-30M",
			category = "AIRPLANE",
			singleInFlight = true,

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "8300",
				["flare"] = 192,
				["chaff"] = 192,
				["gun"] = 100,
			},

			skins =
			{
				"15th Transport AB",
				"RF Air Force",
			},
		},
	[3] =								-- C-130
		{
			aircraftModel = "C-130",
			category = "AIRPLANE",
			singleInFlight = true,

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "20830",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			skins =
			{
				"US Air Force",
				"Belgian Air Force",
				"Canada's Air Force",
				"Royal Danish Air Force",
				"French Air Force",
				"Israel Defence Force",
				"Royal Norwegian Air Force",
				"Spanish Air Force",
				"Royal Netherlands Air Force",
				"Royal Air Force",
				"Turkish Air Force",
			},
		},
	[4] =								-- C-17A
		{
			aircraftModel = "C-17A",
			category = "AIRPLANE",
			singleInFlight = true,

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "132405",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			skins =
			{
				"usaf standard",
			},
		},
	[5] =								-- E-2C
		{
			aircraftModel = "E-2C",
			category = "AIRPLANE",
			singleInFlight = true,

			nameCallname = {"Overlord", "Magic", "Wizard", "Focus", "Darkstar"},

			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "AWACS",
					["number"] = 1,
					["params"] =
					{
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5624",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			skins =
			{
				"E-2D Demo",
				"VAW-125 Tigertails",
			},
		},
	[6] =								-- E-3A
		{
			aircraftModel = "E-3A",
			category = "AIRPLANE",
			singleInFlight = true,

			nameCallname = {"Overlord", "Magic", "Wizard", "Focus", "Darkstar"},

			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "AWACS",
					["number"] = 1,
					["params"] =
					{
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "65000",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			skins =
			{
				"nato",
				"usaf standard",
			},
		},
	[7] =								-- IL-76MD
		{
			aircraftModel = "IL-76MD",
			category = "AIRPLANE",
			singleInFlight = true,

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "80000",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			},

			skins =
			{
				"Ukrainian AF",
				"Ukrainian AF aeroflot",
				"FSB aeroflot",
				"MVD aeroflot",
				"RF Air Force",
			},
		},
	[8] =								-- KC-135
		{
			aircraftModel = "KC-135",
			category = "AIRPLANE",
			singleInFlight = true,

			nameCallname = {"Texaco", "Arco", "Shell"},

			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "Tanker",
					["number"] = 1,
					["params"] =
					{
					},
				},
				[2] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "WrappedAction",
					["number"] = 2,
					["params"] =
					{
						["action"] =
						{
							["id"] = "ActivateBeacon",
							["params"] =
							{
								["type"] = 4,
								["frequency"] = 1088000000,
								["callsign"] = "TKR",
								["channel"] = 1,
								["modeChannel"] = "X",
								["bearing"] = true,
								["system"] = 4,
							},
						},
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = 90700,
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			skins =
			{
				"Standard USAF",
			},
		},
	[9] =								-- MiG-25RBT
		{
			aircraftModel = "MiG-25RBT",
			category = "AIRPLANE",

			task = "Reconnaissance",
			tasks =
			{
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[4] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
				},
				["fuel"] = "15245",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
			},
		},
	[10] =								-- S-3B Tanker
		{
			aircraftModel = "S-3B Tanker",
			category = "AIRPLANE",
			singleInFlight = true,

			nameCallname = {"Texaco", "Arco", "Shell"},

			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "Tanker",
					["number"] = 1,
					["params"] =
					{
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5500",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"usaf standard",
			},
		},
	[11] =								-- Su-24MR
		{
			aircraftModel = "Su-24MR",
			category = "AIRPLANE",

			task = "Reconnaissance",
			tasks =
			{
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
					},
					[2] =
					{
						["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
					},
					[3] =
					{
						["CLSID"] = "{0519A262-0AB6-11d6-9193-00A0249B6F00}",
					},
					[4] =
					{
						["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
					},
					[5] =
					{
						["CLSID"] = "{0519A261-0AB6-11d6-9193-00A0249B6F00}",
					},
				},
				["fuel"] = "11700",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
			},
		},
	[12] =								-- TF-51D
		{
			aircraftModel = "TF-51D",
			category = "AIRPLANE",

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "501",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"",
				"TF -51 Glamorous Glen III",
				"TF-51 Gentleman Jim",
				"TF-51 Gunfighter",
				"TF-51 Miss Velma",
			},
		},
	[13] =								-- Yak-40
		{
			aircraftModel = "Yak-40",
			category = "AIRPLANE",
			singleInFlight = true,

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "3080",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"Georgian Airlines",
				"Ukrainian",
				"Aeroflot",
			},
		},
	[14] =								-- A-50
		{
			aircraftModel = "A-50",
			category = "AIRPLANE",
			singleInFlight = true,

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "70000",
				["flare"] = 192,
				["chaff"] = 192,
				["gun"] = 100,
			},

			skins =
			{
				"RF Air Force",
				"RF Air Force new",
			},
		},
	[15] =								-- IL-78M
		{
			aircraftModel = "IL-78M",
			category = "AIRPLANE",
			singleInFlight = true,

			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "Tanker",
					["number"] = 1,
					["params"] =
					{
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "90000",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			},

			skins =
			{
				"RF Air Force",
				"RF Air Force aeroflot",
				"RF Air Force new",
			},
		},
	[16] =								-- B-1B
		{
			aircraftModel = "B-1B",
			category = "AIRPLANE",
			singleInFlight = true,

			task = "Ground Attack",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "WrappedAction",
					["number"] = 1,
					["params"] =
					{
						["action"] =
						{
							["id"] = "EPLRS",
							["params"] =
							{
								["value"] = true,
								["groupId"] = 2,
							},
						},
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "GBU-31*8",
					},
					[2] =
					{
						["CLSID"] = "GBU-31*8",
					},
					[3] =
					{
						["CLSID"] = "GBU-31*8",
					},
				},
				["fuel"] = "88450",
				["flare"] = 30,
				["chaff"] = 60,
				["gun"] = 100,
			},

			skins =
			{
				"usaf standard",
			},
		},
	[17] =								-- B-52H
		{
			aircraftModel = "B-52H",
			category = "AIRPLANE",
			singleInFlight = true,

			task = "Ground Attack",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "WrappedAction",
					["number"] = 1,
					["params"] =
					{
						["action"] =
						{
							["id"] = "EPLRS",
							["params"] =
							{
								["value"] = true,
								["groupId"] = 2,
							},
						},
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{4CD2BB0F-5493-44EF-A927-9760350F7BA1}",
					},
					[2] =
					{
						["CLSID"] = "{6C47D097-83FF-4FB2-9496-EAB36DDF0B05}",
					},
					[3] =
					{
						["CLSID"] = "{4CD2BB0F-5493-44EF-A927-9760350F7BA1}",
					},
				},
				["fuel"] = "141135",
				["flare"] = 192,
				["chaff"] = 1125,
				["gun"] = 100,
			},

			skins =
			{
				"usaf standard",
			},
		},
	[18] =								-- F-117A
		{
			aircraftModel = "F-117A",
			category = "AIRPLANE",

			task = "Pinpoint Strike",
			tasks =
			{
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{EF0A9419-01D6-473B-99A3-BEBDB923B14D}",
					},
					[2] =
					{
						["CLSID"] = "{EF0A9419-01D6-473B-99A3-BEBDB923B14D}",
					},
				},
				["fuel"] = "3840",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 0,
			},

			skins =
			{
				"usaf standard",
			},
		},
	[19] =								-- F-15E
		{
			aircraftModel = "F-15E",
			category = "AIRPLANE",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[2] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[3] =
					{
						["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					},
					[4] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[5] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[6] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[7] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[8] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[9] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[10] =
					{
						["CLSID"] = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
					},
					[11] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[12] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[13] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[14] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[15] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[16] =
					{
						["CLSID"] = "{GBU-38}",
					},
					[17] =
					{
						["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					},
					[18] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[19] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
				},
				["fuel"] = "6103",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			skins =
			{
				"335th Fighter SQN (SJ)",
				"492d Fighter SQN (LN)",
				"IDF No 69 Hammers Squadron",
			},
		},
	[20] =								-- S-3B
		{
			aircraftModel = "S-3B",
			category = "AIRPLANE",
			singleInFlight = true,

			task = "Ground Attack",
			tasks =
			{
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
					},
					[2] =
					{
						["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					},
					[3] =
					{
						["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					},
					[4] =
					{
						["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					},
					[5] =
					{
						["CLSID"] = "{AB8B8299-F1CC-4359-89B5-2172E0CF4A5A}",
					},
					[6] =
					{
						["CLSID"] = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
					},
				},
				["fuel"] = "5500",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"NAVY Standard",
			},
		},
	[21] =								-- Su-24M
		{
			aircraftModel = "Su-24M",
			category = "AIRPLANE",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[2] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[3] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[4] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[5] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[6] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[7] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[8] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
				},
				["fuel"] = "11700",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
			},
		},
	[22] =								-- Tornado GR4
		{
			aircraftModel = "Tornado GR4",
			category = "AIRPLANE",

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{8C3F26A2-FA0F-11d5-9190-00A0249B6F00}",
					},
					[2] =
					{
						["CLSID"] = "{E6747967-B1F0-4C77-977B-AB2E6EB0C102}",
					},
					[3] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[4] =
					{
						["CLSID"] = "{E6747967-B1F0-4C77-977B-AB2E6EB0C102}",
					},
					[9] =
					{
						["CLSID"] = "{E6747967-B1F0-4C77-977B-AB2E6EB0C102}",
					},
					[10] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[11] =
					{
						["CLSID"] = "{E6747967-B1F0-4C77-977B-AB2E6EB0C102}",
					},
					[12] =
					{
						["CLSID"] = "{8C3F26A1-FA0F-11d5-9190-00A0249B6F00}",
					},
				},
				["fuel"] = "4663",
				["flare"] = 45,
				["chaff"] = 90,
				["gun"] = 100,
			},

			skins =
			{
				"bb of 14 squadron raf lossiemouth",
				"no. 9 squadron raf marham ab (norfolk)",
				"no. 12 squadron raf lossiemouth ab (morayshire)",
				"no. 14 squadron raf lossiemouth ab (morayshire)",
				"no. 617 squadron raf lossiemouth ab (morayshire)",
				"o of ii (ac) squadron raf marham",
			},
		},
	[23] =								-- Tornado IDS
		{
			aircraftModel = "Tornado IDS",
			category = "AIRPLANE",

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{8C3F26A1-FA0F-11d5-9190-00A0249B6F00}",
					},
					[2] =
					{
						["CLSID"] = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
					},
					[3] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[4] =
					{
						["CLSID"] = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
					},
					[9] =
					{
						["CLSID"] = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
					},
					[10] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[11] =
					{
						["CLSID"] = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
					},
					[12] =
					{
						["CLSID"] = "{8C3F26A2-FA0F-11d5-9190-00A0249B6F00}",
					},
				},
				["fuel"] = "4663",
				["flare"] = 45,
				["chaff"] = 90,
				["gun"] = 100,
			},

			skins =
			{
				"aufklarungsgeschwader 51 `immelmann` jagel ab luftwaffe",
				"jagdbombergeschwader 31 `boelcke` norvenich ab luftwaffe",
				"jagdbombergeschwader 32 lechfeld ab luftwaffe",
				"jagdbombergeschwader 33 buchel ab no. 43+19 experimental scheme",
				"marinefliegergeschwader 2 eggebek ab marineflieger",
				"ITA Tornado (Sesto Stormo Diavoli Rossi)",
				"ITA Tornado Black",
				"ITA Tornado MM7042",
				"ITA Tornado MM55004",
			},
		},
	[24] =								-- Tu-22M3
		{
			aircraftModel = "Tu-22M3",
			category = "AIRPLANE",
			singleInFlight = true,

			task = "Ground Attack",
			tasks =
			{
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
					},
					[2] =
					{
						["CLSID"] = "{E1AAE713-5FC3-4CAA-9FF5-3FDCFB899E33}",
					},
					[3] =
					{
						["CLSID"] = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
					},
					[4] =
					{
						["CLSID"] = "{E1AAE713-5FC3-4CAA-9FF5-3FDCFB899E33}",
					},
					[5] =
					{
						["CLSID"] = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
					},
				},
				["fuel"] = "50000",
				["flare"] = 48,
				["chaff"] = 48,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
			},
		},
	[25] =								-- Tu-95MS
		{
			aircraftModel = "Tu-95MS",
			category = "AIRPLANE",
			singleInFlight = true,

			task = "Pinpoint Strike",
			tasks =
			{
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{0290F5DE-014A-4BB1-9843-D717749B1DED}",
					},
				},
				["fuel"] = "87000",
				["flare"] = 48,
				["chaff"] = 48,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
			},
		},
	[26] =								-- Tu-142
		{
			aircraftModel = "Tu-142",
			category = "AIRPLANE",
			singleInFlight = true,

			task = "Antiship Strike",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "AntiShip",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{C42EE4C3-355C-4B83-8B22-B39430B8F4AE}",
					},
				},
				["fuel"] = "87000",
				["flare"] = 48,
				["chaff"] = 48,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
			},
		},
	[27] =								-- Tu-160
		{
			aircraftModel = "Tu-160",
			category = "AIRPLANE",
			singleInFlight = true,

			task = "Pinpoint Strike",
			tasks =
			{
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{0290F5DE-014A-4BB1-9843-D717749B1DED}",
					},
					[2] =
					{
						["CLSID"] = "{0290F5DE-014A-4BB1-9843-D717749B1DED}",
					},
				},
				["fuel"] = "157000",
				["flare"] = 72,
				["chaff"] = 72,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
			},
		},
	[28] =								-- A-10A
		{
			aircraftModel = "A-10A",
			category = "AIRPLANE",

			nameCallname = {"Enfield", "Springfield", "Uzi", "Colt", "Dodge", "Ford", "Chevy", "Pontiac", "Hawg", "Boar", "Pig", "Tusk"},

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "ALQ_184",
					},
					[2] =
					{
						["CLSID"] = "{69926055-0DA8-4530-9F2F-C86B157EA9F6}",
					},
					[3] =
					{
						["CLSID"] = "{DAC53A2F-79CA-42FF-A77A-F5649B601308}",
					},
					[4] =
					{
						["CLSID"] = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
					},
					[5] =
					{
						["CLSID"] = "{CBU-87}",
					},
					[6] =
					{
						["CLSID"] = "{CBU-87}",
					},
					[7] =
					{
						["CLSID"] = "{CBU-87}",
					},
					[8] =
					{
						["CLSID"] = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
					},
					[9] =
					{
						["CLSID"] = "{DAC53A2F-79CA-42FF-A77A-F5649B601308}",
					},
					[10] =
					{
						["CLSID"] = "{69926055-0DA8-4530-9F2F-C86B157EA9F6}",
					},
					[11] =
					{
						["CLSID"] = "{3C0745ED-8B0B-42eb-B907-5BD5C1717447}",
					},
				},
				["fuel"] = 5029,
				["flare"] = 120,
				["ammo_type"] = 1,
				["chaff"] = 240,
				["gun"] = 100,
			},

			skins =
			{
				"104th FS Maryland ANG, Baltimore (MD)",
				"118th FS Bradley ANGB, Connecticut (CT)",
				"118th FS Bradley ANGB, Connecticut (CT) N621",
				"172nd FS Battle Creek ANGB, Michigan (BC)",
				"184th FS Arkansas ANG, Fort Smith (FS)",
				"190th FS Boise ANGB, Idaho (ID)",
				"23rd TFW England AFB (EL)",
				"25th FS Osan AB, Korea (OS)",
				"354th FS Davis Monthan AFB, Arizona (DM)",
				"355th FS Eielson AFB, Alaska (AK)",
				"357th FS Davis Monthan AFB, Arizona (DM)",
				"358th FS Davis Monthan AFB, Arizona (DM)",
				"422nd TES Nellis AFB, Nevada (OT)",
				"47th FS Barksdale AFB, Louisiana (BD)",
				"66th WS Nellis AFB, Nevada (WA)",
				"74th FS Moody AFB, Georgia (FT)",
				"81st FS Spangdahlem AB, Germany (SP) 1",
				"81st FS Spangdahlem AB, Germany (SP) 2",
			},
		},
	[29] =								-- A-10C
		{
			aircraftModel = "A-10C",
			category = "AIRPLANE",

			nameCallname = {"Enfield", "Springfield", "Uzi", "Colt", "Dodge", "Ford", "Chevy", "Pontiac", "Hawg", "Boar", "Pig", "Tusk"},

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
				[2] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "WrappedAction",
					["number"] = 2,
					["params"] =
					{
						["action"] =
						{
							["id"] = "EPLRS",
							["params"] =
							{
								["value"] = true,
								["groupId"] = 1,
							},
						},
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "ALQ_184",
					},
					[3] =
					{
						["CLSID"] = "{DAC53A2F-79CA-42FF-A77A-F5649B601308}",
					},
					[4] =
					{
						["CLSID"] = "BRU-42_3*GBU-12",
					},
					[5] =
					{
						["CLSID"] = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
					},
					[7] =
					{
						["CLSID"] = "{51F9AAE5-964F-4D21-83FB-502E3BFE5F8A}",
					},
					[8] =
					{
						["CLSID"] = "BRU-42_3*GBU-12",
					},
					[9] =
					{
						["CLSID"] = "{DAC53A2F-79CA-42FF-A77A-F5649B601308}",
					},
					[10] =
					{
						["CLSID"] = "{A111396E-D3E8-4b9c-8AC9-2432489304D5}",
					},
					[11] =
					{
						["CLSID"] = "LAU-105_1*AIM-9M_R",
					},
				},
				["fuel"] = 5029,
				["flare"] = 120,
				["ammo_type"] = 1,
				["chaff"] = 240,
				["gun"] = 100,
			},

			skins =
			{
				"A-10 Grey",									--1
				"104th FS Maryland ANG, Baltimore (MD)",
				"118th FS Bradley ANGB, Connecticut (CT)",
				"118th FS Bradley ANGB, Connecticut (CT) N621",
				"172nd FS Battle Creek ANGB, Michigan (BC)",
				"184th FS Arkansas ANG, Fort Smith (FS)",
				"190th FS Boise ANGB, Idaho (ID)",
				"23rd TFW England AFB (EL)",
				"25th FS Osan AB, Korea (OS)",
				"354th FS Davis Monthan AFB, Arizona (DM)",
				"355th FS Eielson AFB, Alaska (AK)",
				"357th FS Davis Monthan AFB, Arizona (DM)",
				"358th FS Davis Monthan AFB, Arizona (DM)",
				"422nd TES Nellis AFB, Nevada (OT)",
				"47th FS Barksdale AFB, Louisiana (BD)",
				"66th WS Nellis AFB, Nevada (WA)",
				"74th FS Moody AFB, Georgia (FT)",
				"81st FS Spangdahlem AB, Germany (SP) 1",
				"81st FS Spangdahlem AB, Germany (SP) 2",		--19
				"Australia Notional RAA",						--20
				"Fictional Canadian Air Force Pixel Camo",
				"Canada RCAF 409 Squadron",
				"Canada RCAF 442 Snow Scheme",					--23
				"Fictional France Escadron de Chasse 03.003 ARDENNES",
				"Fictional Georgian Grey",
				"Fictional Georgian Olive",
				"Fictional German 3322",
				"Fictional German 3323",
				"Fictional Israel 115 Sqn Flying Dragon",
				"Fictional Italian AM (23Gruppo)",				--30
				"Fictional Royal Norwegian Air Force",
				"Fictional Spanish 12nd Wing",
				"Fictional Spanish AGA",
				"Fictional Spanish Tritonal",
				"Fictional Ukraine Air Force 1",				--35
				"Fictional Russian Air Force 1",
				"Fictional Russian Air Force 2",
			},
		},
	[30] =								-- Hawk
		{
			aircraftModel = "Hawk",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "",
					},
					[2] =
					{
						["CLSID"] = "",
					},
					[3] =
					{
						["CLSID"] = "{05544F1A-C39C-466b-BC37-5BD1D52E57BB}",
					},
					[4] =
					{
						["CLSID"] = "",
					},
					[5] =
					{
						["CLSID"] = "",
					},
				},
				["fuel"] = 1272,
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"",
				"100sqn XX189",
				"12th FTW, Randolph AFB, Texas (RA)",
				"1st RS, Beale AFB, California (BB)",
				"25th FTS, Vance AFB, Oklahoma (VN)",		--5
				"509th BS, Whitman AFB, Missouri (WM)",
				"88th FTS, Sheppard AFB, Texas (EN)",
				"NAS Meridian, Mississippi Seven (VT-7)",
				"XX218 - 208Sqn",
				"XX179 - Red Arrows 1979-2007",				--10
				"XX179 - Red Arrows 2008-2012",
				"XX159 - FRADU Royal Navy Anniversary",
				"XX175 - FRADU Royal Navy",
				"XX316 - FRADU Royal Navy",
				"XX100 - TFC",								--15
				"1018 - United Arab Emirates",
				"XX228 - VEAO",								--17

			},
		},
	[31] =
		{								-- L-39ZA
			aircraftModel = "L-39ZA",
			category = "AIRPLANE",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[2] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[3] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[4] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
				},
				["fuel"] = 980,
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"Georgian Air Force",
				"Ukraine Air Force 1",
				"Czech Air Force",
				"Russian Air Force 1",
				"Russian Air Force Old",
				"Abkhazian Air Force",
			},
		},
	[32] =								-- MiG-27K
		{
			aircraftModel = "MiG-27K",
			category = "AIRPLANE",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[2] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[3] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[4] =
					{
						["CLSID"] = "{4203753F-8198-4E85-9924-6F8FF679F9FF}",
					},
					[5] =
					{
						["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
					},
					[6] =
					{
						["CLSID"] = "{4203753F-8198-4E85-9924-6F8FF679F9FF}",
					},
					[7] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[8] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
				},
				["fuel"] = "4500",
				["flare"] = 60,
				["chaff"] = 60,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
			},
		},
	[33] =								-- Su-17M4
		{
			aircraftModel = "Su-17M4",
			category = "AIRPLANE",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[2] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[3] =
					{
						["CLSID"] = "{E92CBFE5-C153-11d8-9897-000476191836}",
					},
					[4] =
					{
						["CLSID"] = "{35B698AC-9FEF-4EC4-AD29-484A0085F62B}",
					},
					[5] =
					{
						["CLSID"] = "{35B698AC-9FEF-4EC4-AD29-484A0085F62B}",
					},
					[6] =
					{
						["CLSID"] = "{E92CBFE5-C153-11d8-9897-000476191836}",
					},
					[7] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[8] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
				},
				["fuel"] = "3770",
				["flare"] = 64,
				["chaff"] = 64,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
				"af standard (worn-out)",
				"shap limanskoye ab",
			},
		},
	[34] =								-- Su-25
		{
			aircraftModel = "Su-25",
			category = "AIRPLANE",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[2] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[3] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[4] =
					{
						["CLSID"] = "{4203753F-8198-4E85-9924-6F8FF679F9FF}",
					},
					[5] =
					{
						["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
					},
					[6] =
					{
						["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
					},
					[7] =
					{
						["CLSID"] = "{4203753F-8198-4E85-9924-6F8FF679F9FF}",
					},
					[8] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[9] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[10] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
				},
				["fuel"] = "2835",
				["flare"] = 128,
				["chaff"] = 128,
				["gun"] = 100,
			},

			skins =
			{
				"scorpion` demo scheme (native)",
				"field camo scheme #1 (native)",
				"broken camo scheme #1 (native). 299th oshap",
				"broken camo scheme #2 (native). 452th shap",
				"petal camo scheme #1 (native). 299th brigade",		--5
				"petal camo scheme #2 (native). 299th brigade",
				"field camo scheme #2 (native). 960th shap",		--7
				"field camo scheme #3 (worn-out). 960th shap",
				"forest camo scheme #1 (native)",
				"Abkhazian Air Force",								--10
			},
		},
	[35] =								-- Su-25T
		{
			aircraftModel = "Su-25T",
			category = "AIRPLANE",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82D}",
					},
					[2] =
					{
						["CLSID"] = "{0180F983-C14A-11d8-9897-000476191836}",
					},
					[3] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[4] =
					{
						["CLSID"] = "{F789E86A-EE2E-4E6B-B81E-D5E5F903B6ED}",
					},
					[5] =
					{
						["CLSID"] = "{96A7F676-F956-404A-AD04-F33FB2C74881}",
					},
					[7] =
					{
						["CLSID"] = "{96A7F676-F956-404A-AD04-F33FB2C74881}",
					},
					[8] =
					{
						["CLSID"] = "{F789E86A-EE2E-4E6B-B81E-D5E5F903B6ED}",
					},
					[9] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[10] =
					{
						["CLSID"] = "{0180F983-C14A-11d8-9897-000476191836}",
					},
					[11] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
				},
				["fuel"] = "3790",
				["flare"] = 128,
				["chaff"] = 128,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
				"af standard 1",
				"su-25t test scheme",
			},
		},
	[36] =								-- Su-25TM
		{
			aircraftModel = "Su-25TM",
			category = "AIRPLANE",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[2] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[3] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[4] =
					{
						["CLSID"] = "{4203753F-8198-4E85-9924-6F8FF679F9FF}",
					},
					[5] =
					{
						["CLSID"] = "{4203753F-8198-4E85-9924-6F8FF679F9FF}",
					},
					[7] =
					{
						["CLSID"] = "{4203753F-8198-4E85-9924-6F8FF679F9FF}",
					},
					[8] =
					{
						["CLSID"] = "{4203753F-8198-4E85-9924-6F8FF679F9FF}",
					},
					[9] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[10] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[11] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
				},
				["fuel"] = "3790",
				["flare"] = 128,
				["chaff"] = 128,
				["gun"] = 100,
			},

			skins =
			{
				"Flight Research Institute  VVS",
			},
		},
	[37] =								-- Bf-109K-4
		{
			aircraftModel = "Bf-109K-4",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "SC_501_SC500",
					},
				},
				["fuel"] = "296",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"Bf-109 K4 1.NJG  11",
				"Bf-109 K4 330xxx batch",
				"Bf-109 K4 334xxx batch",
				"Bf-109 K4 335xxx batch",
				"Bf-109 K4 9.JG27 (W10+I)",
				"Germany_standard",
				"Bf-109 K4 Jagdgeschwader 53",
			},
		},
	[38] =								-- F-14A
		{
			aircraftModel = "F-14A",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
					[2] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[3] =
					{
						["CLSID"] = "{82364E69-5564-4043-A866-E13032926C3E}",
					},
					[4] =
					{
						["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
					},
					[5] =
					{
						["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
					},
					[6] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[7] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[8] =
					{
						["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
					},
					[9] =
					{
						["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
					},
					[10] =
					{
						["CLSID"] = "{82364E69-5564-4043-A866-E13032926C3E}",
					},
					[11] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[12] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
				},
				["fuel"] = "7348",
				["flare"] = 15,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"black demo scheme",
				"vf-1 `wolfpack`",
				"vf-33 `starfighters`",
				"vf-41 `black aces`",
				"vf-84 `jolly rogers`",		--5
				"vf-111 `sundowners`- 1",
				"vf-111 `sundowners`- 2",
				"vf-142 `ghost riders`",
				"vf-143 `pukin's dogs`",
				"vf-xxx `aardvarks`",		--10
			},
		},
	[39] =								-- F-15C
		{
			aircraftModel = "F-15C",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
					[2] =
					{
						["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					},
					[3] =
					{
						["CLSID"] = "{6FBCDCD7-F984-4202-84A7-15173E02CC5B}",
					},
					[4] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[5] =
					{
						["CLSID"] = "{446E122B-8E9D-457e-AE8E-7AE88E3E566B}",
					},
					[6] =
					{
						["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					},
					[7] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[8] =
					{
						["CLSID"] = "{DA8F810A-EA40-4091-8127-CC2E026041E7}",
					},
					[9] =
					{
						["CLSID"] = "{9701DB51-AECB-42c6-A4F6-D5D8793E4D81}",
					},
					[10] =
					{
						["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					},
					[11] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
				},
				["fuel"] = "6103",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			skins =
			{
				"19th Fighter SQN (AK)",
				"58th Fighter SQN (EG)",
				"65th Agressor SQN (WA) Flanker",
				"65th Agressor SQN (WA) MiG",
				"65th Agressor SQN (WA) SUPER_Flanker",		--5
				"390th Fighter SQN",
				"493rd Fighter SQN (LN)",
				"Ferris Scheme",
				"106th SQN (8th Airbase)",					--9
			},
		},
	[40] =								-- F-16A
		{
			aircraftModel = "F-16A",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
					[2] =
					{
						["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					},
					[3] =
					{
						["CLSID"] = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
					},
					[4] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[6] =
					{
						["CLSID"] = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
					},
					[7] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[8] =
					{
						["CLSID"] = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
					},
					[9] =
					{
						["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					},
					[10] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
				},
				["fuel"] = "3104",
				["flare"] = 30,
				["chaff"] = 60,
				["gun"] = 100,
			},

			skins =
			{
				"usaf f16 standard-1",
			},
		},
	[41] =								-- F-16C bl.52d
		{
			aircraftModel = "F-16C bl.52d",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
					[2] =
					{
						["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					},
					[3] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[4] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[6] =
					{
						["CLSID"] = "{8A0BE8AE-58D4-4572-9263-3144C0D06364}",
					},
					[7] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[8] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[9] =
					{
						["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					},
					[10] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
				},
				["fuel"] = "3104",
				["flare"] = 45,
				["chaff"] = 90,
				["gun"] = 100,
			},

			skins =
			{
				"pacaf 14th fs (mj) misawa afb",
				"pacaf 35th fw (ww) misawa afb",
				"usaf 77th fs (sw) shaw afb",
				"usaf 147th fig (ef) ellington afb",
				"usaf 412th tw (ed) edwards afb",
				"usaf 414th cts (wa) nellis afb",
				"usafe 22nd fs (sp) spangdahlem afb",
				"usafe 555th fs (av) aviano afb",
				"idf_af f16c standard",
			},
		},
	[42] =								-- F-16A MLU
		{
			aircraftModel = "F-16A MLU",
			category = "AIRPLANE",

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					},
					[2] =
					{
						["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					},
					[3] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[4] =
					{
						["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
					},
					[6] =
					{
						["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
					},
					[7] =
					{
						["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
					},
					[8] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[9] =
					{
						["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					},
					[10] =
					{
						["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
					},
				},
				["fuel"] = "3104",
				["flare"] = 30,
				["chaff"] = 60,
				["gun"] = 100,
			},

			skins =
			{
				"2nd squadron `comet` florennes ab",
				"rdaf f16 standard-1",
				"norway 338 skvadron",
				"norway skv338",
				"the netherlands (313th squadron `` twenthe ab)",
				"the netherlands 313th `tigers` squadron",
--				"CMD extended skins",
			},
		},
	[43] =								-- F-4E
		{
			aircraftModel = "F-4E",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
					},
					[2] =
					{
						["CLSID"] = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
					},
					[3] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[4] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[6] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[7] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[8] =
					{
						["CLSID"] = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
					},
					[9] =
					{
						["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
					},
				},
				["fuel"] = "4864",
				["flare"] = 30,
				["chaff"] = 60,
				["gun"] = 100,
			},

			skins =
			{
				"",
				"af standard",
			},
		},
	[44] =								-- F-5E
		{
			aircraftModel = "F-5E",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
					[2] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
					[3] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[4] =
					{
						["CLSID"] = "{A021F29D-18AB-4d3e-985C-FC9C60E35E9E}",
					},
					[5] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[6] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
					[7] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
				},
				["fuel"] = "2000",
				["flare"] = 15,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"`green` paint scheme",
				"aggressor `desert` scheme",
				"aggressor `frog` scheme2",
				"aggressor `new blue ` scheme",
				"aggressor `new ghost ` scheme1",	--5
				"aggressor `new ghost ` scheme2",
				"aggressor `old blue ` scheme",
				"aggressor `sand` scheme",
				"aggressor `snake` scheme",
				"`af standard",						--10
			},
		},
	[45] =								-- F-86F Sabre
		{
			aircraftModel = "F-86F Sabre",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{HVARx2}",
					},
					[2] =
					{
						["CLSID"] = "{HVARx2}",
					},
					[4] =
					{
						["CLSID"] = "{PTB_120_F86F35}",
					},
					[5] =
					{
						["CLSID"] = "{GAR-8}",
					},
					[6] =
					{
						["CLSID"] = "{GAR-8}",
					},
					[7] =
					{
						["CLSID"] = "{PTB_120_F86F35}",
					},
					[10] =
					{
						["CLSID"] = "{HVARx2}",
					},
					[9] =
					{
						["CLSID"] = "{HVARx2}",
					},
				},
				["fuel"] = "1282",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"",
			},
		},
	[46] =								-- F/A-18C
		{
			aircraftModel = "F/A-18C",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
					[2] =
					{
						["CLSID"] = "LAU_117_AGM_65G",
					},
					[3] =
					{
						["CLSID"] = "{60CC734F-0AFA-4E2E-82B8-93B941AB11CF}",
					},
					[4] =
					{
						["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					},
					[5] =
					{
						["CLSID"] = "{EFEC8201-B922-11d7-9897-000476191836}",
					},
					[6] =
					{
						["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					},
					[7] =
					{
						["CLSID"] = "{BRU-42_3*Mk-82AIR}",
					},
					[8] =
					{
						["CLSID"] = "LAU_117_AGM_65G",
					},
					[9] =
					{
						["CLSID"] = "{9BFD8C90-F7AE-4e90-833B-BFD0CED0E536}",
					},
				},
				["fuel"] = "6531",
				["flare"] = 15,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"",
				"NSAWC_25",
				"NSAWC_44",
				"VFA-94",
				"VFC-12",
				"Australia 75 Sqn RAAF",
			},
		},
	[47] =								-- FW-190D9
		{
			aircraftModel = "FW-190D9",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "ER_4_SC50",
					},
				},
				["fuel"] = "388",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"FW-190D9_USA",
				"FW-190D9_13.JG 51_Heinz Marquardt",
				"FW-190D9_IV.JG 26_Hans Dortenmann",
				"FW-190D9_Black 4 of Stab IIJG 6",
				"FW-190D9_JG54",					--5
				"FW-190D9_5JG301",
				"FW-190D9_Red",
				"FW-190D9_GB",
				"FW-190D9_USSR",					--9
			},
		},
	[48] =								-- MiG-15bis
		{
			aircraftModel = "MiG-15bis",
			category = "AIRPLANE",

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "FAB_100M",
					},
					[2] =
					{
						["CLSID"] = "FAB_100M",
					},
				},
				["fuel"] = "1172",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"",
			},
		},
	[49] =								-- MiG-21Bis
		{
			aircraftModel = "MiG-21Bis",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[2] =
					{
						["CLSID"] = "{R-3R}",
					},
					[3] =
					{
						["CLSID"] = "{SPS-141-100}",
					},
					[4] =
					{
						["CLSID"] = "{R-3R}",
					},
					[5] =
					{
						["CLSID"] = "{R-60M 2R}",
					},
					[6] =
					{
						["CLSID"] = "{SPRD}",
					},
				},
				["fuel"] = "2280",
				["flare"] = 32,
				["chaff"] = 32,
				["gun"] = 100,
			},

			skins =
			{
				"32nd FG - Northeria",
				"101FS - Serbia",
				"Factory Test",
				"HavLLv 31 - Finland",
				"VVS Camo",
				"VVS Grey",
			},
		},
	[50] =								-- MiG-23MLD
		{
			aircraftModel = "MiG-23MLD",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[2] =
					{
						["CLSID"] = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
					},
					[3] =
					{
						["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
					},
					[4] =
					{
						["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
					},
					[5] =
					{
						["CLSID"] = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
					},
					[6] =
					{
						["CLSID"] = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
					},
				},
				["fuel"] = "3800",
				["flare"] = 60,
				["chaff"] = 60,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
				"af standard-1",
				"af standard-2",
				"af standard-3 (worn-out)",
			},
		},
	[51] =								-- MiG-25PD
		{
			aircraftModel = "MiG-25PD",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[2] =
					{
						["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
					},
					[3] =
					{
						["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
					},
					[4] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
				},
				["fuel"] = "15245",
				["flare"] = 64,
				["chaff"] = 64,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
			},
		},
	[52] =								-- MiG-29A
		{
			aircraftModel = "MiG-29A",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[2] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[3] =
					{
						["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					},
					[4] =
					{
						["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
					},
					[5] =
					{
						["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					},
					[6] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[7] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
				},
				["fuel"] = "3380",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},



			skins =
			{
				"af standard-1",
				"af standard-2",
				"40th fw `maestro` vasilkov ab",
				"120 gviap #45 domna ab",				--3
				"33th iap wittstock ab (germany)",
				"968th iap altenburg ab (germany)",
				"`swifts` team #44 kubinka ab",
				"demo paint scheme #999 mapo",
			},
		},
	[53] = 								-- MiG-29G
		{
			aircraftModel = "MiG-29G",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[2] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[3] =
					{
						["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					},
					[4] =
					{
						["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
					},
					[5] =
					{
						["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					},
					[6] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[7] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
				},
				["fuel"] = "3380",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"luftwaffe 29+20 demo",
				"luftwaffe gray early",
				"luftwaffe gray-1",
				"luftwaffe gray-2(worn-out)",
				"luftwaffe gray-3",
				"luftwaffe gray-4",
			},
		},
	[54] =								-- MiG-29S
		{
			aircraftModel = "MiG-29S",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[2] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[3] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[4] =
					{
						["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
					},
					[5] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[6] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[7] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
				},
				["fuel"] = "3500",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"14th army, vinnitsa ab",
				"9th fw belbek ab",
				"`ukrainian falcons` paint scheme",
			},
		},
	[55] =								-- Mirage 2000-5
		{
			aircraftModel = "Mirage 2000-5",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
					},
					[2] =
					{
						["CLSID"] = "{414DA830-B61A-4F9E-B71B-C2F6832E1D7A}",
					},
					[3] =
					{
						["CLSID"] = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
					},
					[4] =
					{
						["CLSID"] = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
					},
					[5] =
					{
						["CLSID"] = "{414DA830-B61A-4F9E-B71B-C2F6832E1D7A}",
					},
					[6] =
					{
						["CLSID"] = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
					},
					[7] =
					{
						["CLSID"] = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
					},
					[8] =
					{
						["CLSID"] = "{414DA830-B61A-4F9E-B71B-C2F6832E1D7A}",
					},
					[9] =
					{
						["CLSID"] = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
					},
				},
				["fuel"] = "3160",
				["flare"] = 16,
				["chaff"] = 112,
				["gun"] = 100,
			},

			skins =
			{
				"ec1_2  spa103 `cigogne de fonck`",
				"ec1_2  spa12 `cigogne a ailes ouvertes`",
				"ec1_2 spa3 `cigogne de guynemer`",
				"ec2_2 `cote d'or` spa57 `mouette`",
				"ec2_2 `cote d'or` spa65 `chimere`",
				"ec2_2 spa94 `lamort qui fauche`",
			},
		},
	[56] =								-- P-51D
		{
			aircraftModel = "P-51D",
			category = "AIRPLANE",

			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{HVAR}",
					},
					[2] =
					{
						["CLSID"] = "{HVAR}",
					},
					[3] =
					{
						["CLSID"] = "{HVAR}",
					},
					[8] =
					{
						["CLSID"] = "{HVAR}",
					},
					[10] =
					{
						["CLSID"] = "{HVAR}",
					},
					[9] =
					{
						["CLSID"] = "{HVAR}",
					},
				},
				["fuel"] = "732",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"Bare Metal",
				"Dogfight Blue",
				"Dogfight Red",
				"USAF 363rd FS, 357th FG DESERT RAT",	--4
				"USAF 364th FS, HURRY HOME HONEY",
				"USAF 344rd FS,  IRON ASS",
				"USAF 485rd FS,  MOONBEAM McSWINE",
				"USAF 302rd FS, RED TAILS",
				"USAF 363rd FS",
				"USAF 364th FS",
				"USAF 375 rd FS,",
				"USAF 485rd FS",
				"USAF 84 rd FS,",
				"Bare Metal",
				"USAF Big Beautiful Doll",
				"USAF DEE",
				"Dogfight Blue",
				"Dogfight Red",
				"USAF Ferocius Frankie",
				"USAF Gentleman Jim",
				"USAF Miss Velma",
				"USAF Voodoo AirRace",		--22
				"Canada RAF 442 Sqdn",
				"Germany Training Staffel",
				"Israeli Air Force",		--25
				"Italia Air Force",
				"SPAIN Roberto",
				"RAF 112 Sqdn",
				"Ukraine Modern",
				"Ukraine Old",
				"Russia Blueback",			-- 31
				"Russia DOSAAF",
				"Russia Green Black",
				"Russia SRI VVS USSR 1942",
				"USSR Modern",
				"USSR Old",
			},
		},
	[57] =								-- Su-27
		{
			aircraftModel = "Su-27",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
					},
					[2] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[3] =
					{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
					},
					[4] =
					{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					},
					[5] =
					{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					},
					[6] =
					{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					},
					[7] =
					{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					},
					[8] =
					{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
					},
					[9] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[10] =
					{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
					},
				},
				["fuel"] = "9400",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			},

			skins =
			{
				"Air Force Ukraine Standard",
				"Air Force Ukraine Standard Early",
				"Mirgorod AFB (831th brigade)",
				"Mirgorod AFB (Digital camo)",
				"Ozerne AFB (9th brigade)",
				"Air Force Standard",					--6
				"Air Force Standard Early",
				"Air Force Standard old",
				"Besovets AFB",
				"Besovets AFB 2 squadron",
				"Chkalovsk AFB (689 GvIAP)",
				"Hotilovo AFB",
				"Kazakhstan Air Defense Forces",
				"Kilpyavr AFB (Maresyev)",
				"Kubinka AFB (Russian Knights)",
				"Lodeynoye pole AFB (177 IAP)",
				"Lypetsk AFB (Falcons of Russia)",
				"Lypetsk AFB (Shark)",
				"M Gromov FRI",							--19
			},
		},
	[58] =								-- F-16C bl.50
		{
			aircraftModel = "F-16C bl.50",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[2] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[4] =
					{
						["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
					},
					[6] =
					{
						["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
					},
					[7] =
					{
						["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
					},
					[9] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[10] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
				},
				["fuel"] = "3104",
				["flare"] = 45,
				["chaff"] = 90,
				["gun"] = 100,
			},

			skins =
			{
				"af f16 standard",
			},
		},
	[59] =								-- MiG-29S
		{
			aircraftModel = "MiG-29S",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[2] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[3] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[4] =
					{
						["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
					},
					[5] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[6] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[7] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
				},
				["fuel"] = "3500",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"1038th guards ctc, mary ab",
				"115th guards regiment, termez ab",
				"120th guards regiment, domna ab",
				"2nd fs `swifts` team, kubinka ab",
				"4th ctc lypetsk ab",							--5
				"733th guards regiment, damgarten ab (gdr)",
				"73th guards regiment, merzeburg ab (gdr)",
			},
		},
	[60] =								-- MiG-31
		{
			aircraftModel = "MiG-31",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
					},
					[2] =
					{
						["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
					},
					[3] =
					{
						["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
					},
					[4] =
					{
						["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
					},
					[5] =
					{
						["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
					},
					[6] =
					{
						["CLSID"] = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
					},
				},
				["fuel"] = "15500",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
				"174 GvIAP_Boris Safonov",
				"903_White",
			},
		},
	[61] =								-- Su-30
		{
			aircraftModel = "Su-30",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[2] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[3] =
					{
						["CLSID"] = "{88DAC840-9F75-4531-8689-B46E64E42E53}",
					},
					[4] =
					{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
					},
					[5] =
					{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					},
					[6] =
					{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					},
					[7] =
					{
						["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
					},
					[8] =
					{
						["CLSID"] = "{88DAC840-9F75-4531-8689-B46E64E42E53}",
					},
					[9] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[10] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
				},
				["fuel"] = "9400",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			},

			skins =
			{
				"`desert` test paint scheme",
				"`russian knights` team #25",
				"`snow` test paint scheme",
				"`test-pilots` team #597",
				"adf 148th ctc savasleyka ab",
				"af standard",
				"af standard early",
				"af standard early (worn-out)",
				"af standard last",
				"af standard last (worn-out)",		--10
			},
		},
	[62] =								-- Su-33
		{
			aircraftModel = "Su-33",
			category = "AIRPLANE",

			task = "CAP",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = false,
					["id"] = "EngageTargets",
					["key"] = "CAP",
					["number"] = 1,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Air",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
					},
					[2] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[3] =
					{
						["CLSID"] = "B-8M1 - 20 S-8OFP2",
					},
					[4] =
					{
						["CLSID"] = "B-8M1 - 20 S-8OFP2",
					},
					[5] =
					{
						["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					},
					[6] =
					{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					},
					[7] =
					{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
					},
					[8] =
					{
						["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					},
					[9] =
					{
						["CLSID"] = "B-8M1 - 20 S-8OFP2",
					},
					[10] =
					{
						["CLSID"] = "B-8M1 - 20 S-8OFP2",
					},
					[11] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[12] =
					{
						["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
					},
				},
				["fuel"] = "9400",
				["flare"] = 48,
				["chaff"] = 48,
				["gun"] = 100,
			},

			skins =
			{
				"279th kiap 1st squad navy",
				"279th kiap 2nd squad navy",
				"standard-1 navy",
				"standard-2 navy",
				"t-10k-1 test paint scheme",
				"t-10k-2 test paint scheme",
				"t-10k-5 test paint scheme",
				"t-10k-9 test paint scheme",	--8
			},
		},
	[63] =								-- Su-34
		{
			aircraftModel = "Su-34",
			category = "AIRPLANE",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[2] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[3] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[4] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[5] =
					{
						["CLSID"] = "{35B698AC-9FEF-4EC4-AD29-484A0085F62B}",
					},
					[6] =
					{
						["CLSID"] = "{35B698AC-9FEF-4EC4-AD29-484A0085F62B}",
					},
					[7] =
					{
						["CLSID"] = "{35B698AC-9FEF-4EC4-AD29-484A0085F62B}",
					},
					[8] =
					{
						["CLSID"] = "{35B698AC-9FEF-4EC4-AD29-484A0085F62B}",
					},
					[9] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[10] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[11] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[12] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
				},
				["fuel"] = "9800",
				["flare"] = 64,
				["chaff"] = 64,
				["gun"] = 100,
			},

			skins =
			{
				"af standard",
				"af standard 2",
			},
		},
	[64] =								-- AH-1W
		{
			aircraftModel = "AH-1W",
			category = "HELICOPTER",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
					},
					[2] =
					{
						["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					},
					[3] =
					{
						["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					},
					[4] =
					{
						["CLSID"] = "{3EA17AB0-A805-4D9E-8732-4CE00CB00F17}",
					},
				},
				["fuel"] = 1250,
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"standard",
				"USA X Black",
				"USA Marines",
				"Turkey 1",			--4
				"Turkey 2",
			},
		},
	[65] =								-- AH-64A
		{
			aircraftModel = "AH-64A",
			category = "HELICOPTER",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
					},
					[2] =
					{
						["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					},
					[3] =
					{
						["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					},
					[4] =
					{
						["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
					},
				},
				["fuel"] = "1157",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"standard",
				"standard dirty",
				"ah-64_a_green isr",
				"ah-64_a_green neth",
				"ah-64_a_green uk",
			},
		},
	[66] =								-- AH-64D
		{
			aircraftModel = "AH-64D",
			category = "HELICOPTER",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
					},
					[2] =
					{
						["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					},
					[3] =
					{
						["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
					},
					[4] =
					{
						["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
					},
				},
				["fuel"] = "1157",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"standard",
				"ah-64_d_isr",
				"ah-64_d_green neth",
				"ah-64_d_green uk",
			},
		},
	[67] =								-- CH-47D
		{
			aircraftModel = "CH-47D",
			category = "HELICOPTER",

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "3600",
				["flare"] = 120,
				["chaff"] = 120,
				["gun"] = 100,
			},

			skins =
			{
				"standard",
				"Australia RAAF",
				"ch-47_green spain",
				"ch-47_green neth",
				"ch-47_green uk",
			},
		},
	[68] =								-- CH-53E
		{
			aircraftModel = "CH-53E",
			category = "HELICOPTER",

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "1908",
				["flare"] = 60,
				["chaff"] = 60,
				["gun"] = 100,
			},

			skins =
			{
				"standard",
			},
		},
	[69] =								-- Ka-27
		{
			aircraftModel = "Ka-27",
			category = "HELICOPTER",

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "2616",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"ukraine camo 1",
				"standard",
			},
		},
	[70] =								-- Ka-50
		{
			aircraftModel = "Ka-50",
			category = "HELICOPTER",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
					},
					[2] =
					{
						["CLSID"] = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
					},
					[3] =
					{
						["CLSID"] = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
					},
					[4] =
					{
						["CLSID"] = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
					},
				},
				["fuel"] = "1450",
				["flare"] = 128,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"us army",
				"us marines 1",
				"us marines 2",
				"Russia Worn Black",			--4
				"belgium sar",					--5
				"belgium camo",
				"belgium olive",
				"canadian forces",				--8
				"denmark camo",					--9
				"Denmark navy trainer",
				"France Armee de Terre 1",		--11
				"France Armee de Terre 2",
				"France Armee de Terre Desert",
				"georgia camo",					--14
				"german 8320",					--15
				"german 8332",
				"Israel IAF camo 1",			--17
				"Israel IAF camo 2",
				"Israel IAF camo 3",
				"Italy Aeronautica Militare",	--20
				"Italy Esercito Italiano",
				"norway camo",					--22
				"Spain SAA Arido",				--23
				"Spain SAA Boscoso",
				"Spain SAA Standard",
				"Netherlands RNAF",				--26
				"Netherlands RNAF wooded",
				"uk camo",						--28
				"Ukraine Demo",					--29
				"ukraine camo 1",
				"ukraine camo 1 dirt",
				"Russia Standard Army",			--32
				"Russia DOSAAF",
				"Russia Demo #024",
				"Russia Demo #22 `Black Shark`",
				"Russia Demo `Werewolf`",
				"Russia fictional desert scheme",
				"Russia Fictional Olive Grey",
				"Russia Fictional Snow Splatter",
				"Russia Fictional Swedish",
				"Russia Fictional Tropic Green",
				"Russia New Year",
				"Russia Standard Army (Worn)",
				"Russia Worn Black",
				"Abkhazia 1",					--45
				"South Ossetia 1",				--46
				"Turkey Fictional Light Gray",	--47
				"Turkey Fictional 1",
				"Turkey Fictional",
				"Turkey fictional desert scheme",
			},
		},
	[71] =								-- Mi-24V
		{
			aircraftModel = "Mi-24V",
			category = "HELICOPTER",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
					},
					[2] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[3] =
					{
						["CLSID"] = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
					},
					[4] =
					{
						["CLSID"] = "{FC56DF80-9B09-44C5-8976-DCFAFF219062}",
					},
					[5] =
					{
						["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
					},
					[6] =
					{
						["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
					},
				},
				["fuel"] = 1534,
				["flare"] = 192,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"standard",
				"Ukraine UN",
				"ukraine",
				"standard 1",		--4
				"standard 2 (faded and sun-bleached)",
				"Russia_FSB",
				"Russia_MVD",
				"Abkhazia",			--8
				"South Ossetia",	--9
			},
		},
	[72] =								-- Mi-26
		{
			aircraftModel = "Mi-26",
			category = "HELICOPTER",

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "9600",
				["flare"] = 192,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"7th Separate Brigade of AA (Kalinov)",
				"United Nations",
				"RF Air Force",			--3
				"Russia_FSB",
				"Russia_MVD",
				"United Nations",
			},
		},
	[73] =								-- Mi-8MT
		{
			aircraftModel = "Mi-8MT",
			category = "HELICOPTER",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[5] =
					{
						["CLSID"] = "{05544F1A-C39C-466b-BC37-5BD1D52E57BB}",
					},
					[2] =
					{
						["CLSID"] = "{05544F1A-C39C-466b-BC37-5BD1D52E57BB}",
					},
					[4] =
					{
						["CLSID"] = "B_8V20A_OFP2",
					},
					[3] =
					{
						["CLSID"] = "B_8V20A_OFP2",
					},
				},
				["fuel"] = "2073",
				["flare"] = 192,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"Standard",
				"Standart",
				"USA_AFG",
				"Belgium",				--4
				"Canada",				--5
				"Denmark",				--6
				"France ARMY",			--7
				"France NAVY",
				"Georgia",				--9
				"Germany",				--10
				"Israel",				--11
				"Italy ARMY",			--12
				"Italy NAVY",
				"Norway",				--14
				"Spain",				--15
				"Netherlands ARMY",		--16
				"Netherlands NAVY",
				"United Kingdom",		--18
				"Russia_VVS_Grey",		--19
				"Russia_VVS_Standard",
				"Russia_VVS_Standart",
				"Russia_FSB",
				"Russia_MVD_Mozdok",
				"Russia_MVD_Standard",
				"Russia_MVD_Standart",
				"Russia_UN",
				"Russia_Army_Weather",
				"Russia_Naryan-Mar",
				"Russia_Police",
				"Russia_UTair",
				"Abkhazia",				--31
				"South Ossetia",		--32
				"Turkey",				--33
			},
		},
	[74] =								-- OH-58D
		{
			aircraftModel = "OH-58D",
			category = "HELICOPTER",

			task = "AFAC",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["auto"] = true,
					["id"] = "FAC",
					["number"] = 1,
					["params"] =
					{
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "M260_HYDRA_WP",
					},
					[2] =
					{
						["CLSID"] = "M260_HYDRA_WP",
					},
				},
				["fuel"] = 715,
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"",
			},
		},
	[75] =								-- SH-60B
		{
			aircraftModel = "SH-60B",
			category = "HELICOPTER",

			task = "Antiship Strike",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "AntiShip",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{7B8DCEB4-820B-4015-9B48-1028A4195692}",
					},
				},
				["fuel"] = "1100",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"standard",
			},
		},
	[76] =								-- UH-1H
		{
			aircraftModel = "UH-1H",
			category = "HELICOPTER",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "M134_L",
					},
					[2] =
					{
						["CLSID"] = "XM158_MK5",
					},
					[6] =
					{
						["CLSID"] = "M134_R",
					},
					[5] =
					{
						["CLSID"] = "XM158_MK5",
					},
				},
				["fuel"] = "631",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"Army Standard",
				"US ARMY 1972",
				"US DOS",
				"US Ft. Rucker",
				"US NAVY",
				"USA Red Flag",
				"USA UN",
				"XW-PFJ Air America",
				"[Civilian] Medical",		--9
				"[Civilian] NASA",
				"[Civilian] Standard",
				"[Civilian] VIP",
				"Australia RAAF 171 Sqn",	--13
				"Australia RAAF 1968",
				"Australia Royal Navy",
				"Canadian Force",			--16
				"French Army",				--17
				"Georgian AF Camo",			--18
				"Georgian Air Force",
				"Luftwaffe",				--20
				"Israel Army",				--21
				"Italy 15B Stormo S.A.R -Soccorso",	--22
				"Italy E.I. 4B Regg. ALTAIR",
				"Italy Marina Militare s.n. 80951 7-20",
				"Spanish Army",				--25
				"Spanish UN",
				"Royal Netherlands AF",		--27
				"Ukrainian Army",			--28
				"RF Air Force Broken",		--29
				"RF Air Force Grey",
				"Turkish Air Force",		--30
			},
		},
	[77] =									-- Mi-28N
		{
			aircraftModel = "Mi-28N",
			category = "HELICOPTER",

			task = "CAS",
			tasks =
			{
				[1] =
				{
					["enabled"] = true,
					["key"] = "CAS",
					["id"] = "EngageTargets",
					["number"] = 1,
					["auto"] = true,
					["params"] =
					{
						["targetTypes"] =
						{
							[1] = "Helicopters",
							[2] = "Ground Units",
							[3] = "Light armed ships",
						},
						["priority"] = 0,
					},
				},
			},

			payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
					},
					[2] =
					{
						["CLSID"] = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
					},
					[3] =
					{
						["CLSID"] = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
					},
					[4] =
					{
						["CLSID"] = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
					},
				},
				["fuel"] = 1500,
				["flare"] = 128,
				["chaff"] = 0,
				["gun"] = 100,
			},

			skins =
			{
				"night",
				"standard",
			},
		},
	[78] =								-- UH-60A
		{
			aircraftModel = "UH-60A",
			category = "HELICOPTER",

			payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "1100",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			skins =
			{
				"standard",
			},
		},
	}


------------------------------------------------------------------------
-- Create a new aircraft based on coalition, airbase, and name prefix --
------------------------------------------------------------------------
function f_generateAirplane(p_coalitionIndex, p_spawnIndex, p_landIndex, p_name)
	local l_acExist = nil
	local l_acTypeIndex
	local l_acCountry
	local l_acIndex
	local l_acChosen
	local l_acSkin
	local l_acModel
	local l_acCategory
	local l_acSingle
	local l_acNumGroup
	local l_acCallname
	local l_acTask
	local l_acTasks
	local l_acPayload
	local l_acFullTextName
	local l_acSkill
	local l_acFlightAlt
	local l_acFlightSpeed
	local l_acSpawnType
	local l_acCallSign
	local l_acSpawnAirdromeID
	local l_acSpawnAirdromePos
	local l_acSpawnPos
	local l_acSpawnPSI
	local l_acSpawnHeading
	local l_acSpawnAlt
	local l_acSpawnSpeed
	local l_acLandAirdromeID
	local l_acLandAirdromePos
	local l_acLandPos
	local l_acWaypoint = {}
	local l_acGroupName
	local l_acFormation = ''
	local l_aircraftData
	local l_acUnitNames
	local l_acUnitCheckTime

	if (g_debugLog > 1)    then env.info('f_generateAirplane: starting', false) end

	while (l_acExist == nil) do	-- make sure there is actually a viable aircraft selected for the country (some countries don't have aircraft for each possible ac type)
		local l_typeDiv = {}
		local l_val = 0
		local l_jndex = 1

		-- Pick a country from the given coalition
		if (p_coalitionIndex == 1) then
			l_acCountry = env.mission.coalitions.red[math.random(1, #env.mission.coalitions.red)]
		else
			l_acCountry = env.mission.coalitions.blue[math.random(1, #env.mission.coalitions.blue)]
		end

		-- build table of current aircraft distribution values for users chosen aircraft types in g_aircraftDistribution
		for l_index=1, 5 do
			if (g_aircraftDistribution[l_index] > 0) then
				l_typeDiv[l_jndex] = {l_index, l_val + 1, g_aircraftDistribution[l_index] + l_val}
				l_val = g_aircraftDistribution[l_index] + l_val
				l_jndex = l_jndex + 1
			end
		end

		if (l_jndex == 1) then
			env.info('f_generateAirplane: error no values in g_aircraftDistribution', false)
			return
		end

		-- Random value from total range of possible types
		local l_aircraftType = math.random(1, l_typeDiv[#l_typeDiv][3])

		 --Find result chosing aircraft type of utility airplane, bomber, attack, fighter, or helicopter
		for l_index=1, #l_typeDiv do
			if ((l_aircraftType >=  l_typeDiv[l_index][2]) and (l_aircraftType <= l_typeDiv[l_index][3])) then
				l_acTypeIndex = l_typeDiv[l_index][1]
				l_index = #l_typeDiv + 1
			end
		end

		-- Pick an aircraft and skin set from the given aircraft type
		l_acIndex = math.random(1, #g_coalitionTable[l_acCountry][l_acTypeIndex])

		l_acExist = g_coalitionTable[l_acCountry][l_acTypeIndex][l_acIndex]
	end

	if (g_debugLog > 1) then env.info('f_generateAirplane: l_acCountry: ' .. l_acCountry .. ' l_acTypeIndex: ' .. l_acTypeIndex .. ' l_acIndex: ' .. l_acIndex, false) end

	-- Pick an aircraft from the given country and type
	l_acChosen = g_coalitionTable[l_acCountry][l_acTypeIndex][l_acIndex][1]

	-- Pick a skin from the given aircraft
	if (g_flagRandomSkins) then
		l_acSkin = g_aircraftTable[l_acChosen].skins[g_coalitionTable[l_acCountry][l_acTypeIndex][l_acIndex][math.random(2, #g_coalitionTable[l_acCountry][l_acTypeIndex][l_acIndex])]]
	else
		l_acSkin = g_aircraftTable[l_acChosen].skins[g_coalitionTable[l_acCountry][l_acTypeIndex][l_acIndex][2]]
	end

	-- The specific aircraft
	l_acModel = g_aircraftTable[l_acChosen].aircraftModel

	-- Set category
	l_acCategory = g_aircraftTable[l_acChosen].category

	-- Formation flying or not
	if (g_aircraftTable[l_acChosen]["singleInFlight"] ~= nil) then
		l_acSingle   = true
		l_acNumGroup = 1
	else
		l_acSingle = false
		if (g_flagRandomGroupSize) then
			l_acNumGroup = math.random(g_minGroupSize, g_maxGroupSize)
		else
			l_acNumGroup = g_defaultGroupSize
		end
	end

	-- Set callsign name
	if (g_aircraftTable[l_acChosen].nameCallname ~= nil) then
		l_acCallname = g_aircraftTable[l_acChosen].nameCallname
	else
		l_acCallname = {"Enfield", "Springfield", "Uzi", "Colt", "Dodge", "Ford", "Chevy", "Pontiac"}
	end

	-- Set tasking
	if (g_aircraftTable[l_acChosen].task ~= nil) then
		l_acTask = g_aircraftTable[l_acChosen].task
	else
		l_acTask = ""
	end

	-- Set tasks
	if (g_aircraftTable[l_acChosen].tasks ~= nil) then
		l_acTasks = g_aircraftTable[l_acChosen].tasks
	else
		l_acTasks = {}
	end

	-- Set payload
	l_acPayload = g_aircraftTable[l_acChosen].payload

	-- Set full name used for messages
	l_acFullTextName = g_coalitionTable[l_acCountry].name .. " " .. l_acModel .. " - " .. l_acSkin

	-- Randomize the fuel load
	if (g_flagRandomFuel) then
		l_acPayload.fuel = math.random(l_acPayload.fuel * g_lowFuelPercent, l_acPayload.fuel * g_highFuelPercent)
	end

	-- Ignore tasks is flag not set
	if (not g_flagSetTasks) then
		l_acTask = ""
		l_acTasks =
		{
		}
	end

	-- Ignore weapons is flag not set
	if (not g_flagRandomWeapons) then
		l_acPayload.pylons = {}
	end

	-- Randomize unit skill if flag is set
	if (g_flagRandomSkill) then
		l_acSkill = g_unitSkill[math.random(1,#g_unitSkill)]
	else
		l_acSkill = g_unitSkill[g_unitSkillDefault]
	end

	-- Randomize altitude is flag is set
	if (g_flagRandomAltitude) then
		l_acFlightAlt = math.random(0,10000)
	else
		l_acFlightAlt = 2500
	end

	-- Randomize speed is flag is set
	if (g_flagRandomSpeed) then
		l_acFlightSpeed = math.random(100,1000)
	else
		l_acFlightSpeed = 180
	end

	if (g_flagRandomSpawnType) then
		local l_index = math.random(1, #g_spawnType)

		l_acSpawnType = {g_spawnType[l_index][1], g_spawnType[l_index][2]}
	else
		l_acSpawnType = {g_spawnType[g_defaultSpawnType][1], g_spawnType[g_defaultSpawnType][2]}
	end

	-- Build up sim callsign
	if ((l_acCountry == country.id.RUSSIA) or (l_acCountry == country.id.ABKHAZIA) or (l_acCountry == country.id.SOUTH_OSETIA) or (l_acCountry == country.id.UKRAINE)) then
		l_acCallSign = g_numCoalitionGroup[p_coalitionIndex] .. 1
	else
		local l_anum = math.random(1,#l_acCallname)
		local l_bnum = math.random(1,9)

		l_acCallSign =
			{
				[1]      = l_anum,
				[2]      = l_bnum,
				[3]      = 1,
				["name"] = l_acCallname[l_anum] .. l_bnum .. 1,
			}
	end

	l_acSpawnAirdromeID = p_spawnIndex.id
	l_acSpawnPos = {}

	if (g_debugLog > 1)    then env.info('f_generateAirplane: general aircraft parameters completed', false) end

	if (l_acSpawnType[1] == "Turning Point") then
		l_acSpawnPos.x   = g_airbasePoints[l_acSpawnAirdromeID][1]
		l_acSpawnPos.z   = g_airbasePoints[l_acSpawnAirdromeID][2]
		l_acSpawnPSI     = g_airbasePoints[l_acSpawnAirdromeID][5]
		l_acSpawnHeading = g_airbasePoints[l_acSpawnAirdromeID][6]
		l_acSpawnAlt     = 29.8704
	else
		l_acSpawnAirdromePos = Object.getPoint({id_=p_spawnIndex.id_})
		l_acSpawnPos.x   = l_acSpawnAirdromePos.x
		l_acSpawnPos.z   = l_acSpawnAirdromePos.z
		l_acSpawnPSI     = 0
		l_acSpawnHeading = 0
		l_acSpawnAlt     = 0
	end

	if (g_debugLog > 1)    then env.info('f_generateAirplane: flightpath spawn pos completed', false) end

	if (l_acSpawnType[1] == "Turning Point") then
		l_acSpawnSpeed = g_spawnSpeedTurningPoint
	else
		l_acSpawnSpeed = 0
	end

	if (g_debugLog > 1)    then env.info('f_generateAirplane: flightpath spawn completed', false) end

	l_acLandAirdromeID = p_landIndex.id
	l_acLandAirdromePos = Object.getPoint({id_=p_landIndex.id_})
	l_acLandPos = {}
	l_acLandPos.x = l_acLandAirdromePos.x
	l_acLandPos.z = l_acLandAirdromePos.z

	if (g_debugLog > 1)    then env.info('f_generateAirplane: flightpath land completed', false) end

	-- Compute single intermediate waypoint based on used-defined minimum deviation x/z range
	l_acWaypoint.dist = math.sqrt((l_acSpawnPos.x - l_acLandAirdromePos.x) * (l_acSpawnPos.x - l_acLandAirdromePos.x) + (l_acSpawnPos.z - l_acLandAirdromePos.z) * (l_acSpawnPos.z - l_acLandAirdromePos.z))
	if (((l_acWaypoint.dist / 2) < g_waypointRange[1]) or (l_acSpawnAirdromeID == l_acLandAirdromeID)) then
		l_acWaypoint.distx = g_waypointRange[1]
	else
		l_acWaypoint.distx = l_acWaypoint.dist / 2
	end
	if (((l_acWaypoint.dist / 2) < g_waypointRange[2]) or (l_acSpawnAirdromeID == l_acLandAirdromeID)) then
		l_acWaypoint.distz = g_waypointRange[2]
	else
		l_acWaypoint.distz = l_acWaypoint.dist / 2
	end
	l_acWaypoint.x = l_acSpawnPos.x + math.random(- l_acWaypoint.distx, l_acWaypoint.distx)
	l_acWaypoint.z = l_acSpawnPos.z + math.random(- l_acWaypoint.distz, l_acWaypoint.distz)

	if (g_debugLog > 1)    then env.info('f_generateAirplane: flightpath waypoint completed', false) end

	l_acGroupName = p_name .. g_numCoalitionGroup[p_coalitionIndex]

	if ((l_acSingle == false) and (l_acNumGroup > 1)) then
		local l_params = {}
		local l_rndex
		if (l_acCategory == "AIRPLANE") then
			if (g_flagRandomFormation) then
				l_rndex = math.random(1, #g_airplaneFormation)
			else
				l_rndex = g_defaultAirplaneFormation
			end
			l_params =
				{
					["variantIndex"]   = g_airplaneFormation[l_rndex][2],
					["name"]           = g_airplaneFormation[l_rndex][3],
					["formationIndex"] = g_airplaneFormation[l_rndex][4],
					["value"]          = g_airplaneFormation[l_rndex][5]
				}
			l_acFormation = g_airplaneFormation[l_rndex][1]
		else
			if (g_flagRandomFormation) then
				l_rndex = math.random(1, #g_helicopterFormation)
			else
				l_rndex = g_defaultHelicopterFormation
			end
			l_params =
				{
					["variantIndex"]   = g_helicopterFormation[l_rndex][2],
					["zInverse"]       = g_helicopterFormation[l_rndex][3],
					["name"]           = g_helicopterFormation[l_rndex][4],
					["formationIndex"] = g_helicopterFormation[l_rndex][5],
					["value"]          = g_helicopterFormation[l_rndex][6]
				}
			l_acFormation = g_helicopterFormation[l_rndex][1]
		end

		l_acTasks[#l_acTasks+1] =
		{
			["number"]  = #l_acTasks+1,
			["auto"]    = false,
			["id"]      = "WrappedAction",
			["enabled"] = true,
			["params"]  =
			{
				["action"] =
				{
					["id"]     = "Option",
					["params"] = l_params,
				},
			},
		}
	end

	if (g_debugLog > 1)    then env.info('f_generateAirplane: flight group formation parameters completed', false) end

	l_aircraftData =
	{
        ["modulation"]   = 0,
		["tasks"] =
			{
			},
		["task"]         = l_acTask,
		["uncontrolled"] = false,
		["route"] =
		{
			["points"] =
			{
				[1] =
				{
					["alt"]        = l_acSpawnAlt,
					["alt_type"]   = "RADIO",
					["type"]       = l_acSpawnType[1],
					["action"]     = l_acSpawnType[2],
					["formation_template"] = "",
					["ETA"]        = 0,
					["airdromeId"] = l_acSpawnAirdromeID,
					["y"]          = l_acSpawnPos.z,
					["x"]          = l_acSpawnPos.x,
					["speed"]      = l_acSpawnSpeed,
					["ETA_locked"] = true,
					["task"] =
					{
						["id"]     = "ComboTask",
						["params"] =
						{
							["tasks"] = l_acTasks,
						},
					},
					["speed_locked"] = true,
				},
			},
		},
		["groupId"] = g_numCoalitionGroup[p_coalitionIndex],
		["hidden"]  = false,
		["units"] =
		{
			[1] =
			{
				["alt"]         = l_acSpawnAlt,
				["alt_type"]    = "RADIO",
				["livery_id"]   = l_acSkin,
				["type"]        = l_acModel,
				["psi"]         = l_acSpawnPSI,
                ["heading"]     = l_acSpawnHeading,
				["onboard_num"] = "10",
				["y"]           = l_acSpawnPos.z,
				["x"]           = l_acSpawnPos.x,
				["name"]        = l_acGroupName .. "-1",
				["callsign"]    = l_acCallSign,
				["payload"]     = l_acPayload,
				["speed"]       = l_acSpawnSpeed,
				["unitId"]      = math.random(9999,99999),
				["skill"]       = l_acSkill,
			},
		},
		["y"]             = l_acSpawnPos.z,
		["x"]             = l_acSpawnPos.x,
		["name"]          = l_acGroupName,
		["communication"] = true,
		["start_time"]    = 0,
		["frequency"]     = 124,
	}

	l_acUnitNames = {l_acGroupName .. "-1"}
	l_acUnitCheckTime = {0}

	if ((l_acSingle == false) and (l_acNumGroup > 1)) then
		for l_index=2, l_acNumGroup do
			l_aircraftData.units[l_index] =
			{
				["alt"]         = l_acSpawnAlt,
				["psi"]         = l_acSpawnPSI,
                ["heading"]     = l_acSpawnHeading,
				["livery_id"]   = l_acSkin,
				["type"]        = l_acModel,
				["onboard_num"] = "10",
				["y"]           = l_acSpawnPos.z,
				["x"]           = l_acSpawnPos.x,
				["name"]        = l_acGroupName .. "-" .. l_index,
				["callsign"]    = l_acCallSign,
				["payload"]     = l_acPayload,
				["speed"]       = l_acSpawnSpeed,
				["unitId"]      =  math.random(9999,99999),
				["alt_type"]    = "RADIO",
				["skill"]       = l_acSkill,
			}

			l_acUnitNames[#l_acUnitNames+1]         = l_acGroupName .. "-" .. l_index
			l_acUnitCheckTime[#l_acUnitCheckTime+1] = 0

			-- Build callsign for this unit based on group callsign
			if ((l_acCountry == country.id.RUSSIA) or (l_acCountry == country.id.ABKHAZIA) or (l_acCountry == country.id.SOUTH_OSETIA) or (l_acCountry == country.id.UKRAINE)) then
				l_aircraftData.units[l_index].callsign = g_numCoalitionGroup[p_coalitionIndex] .. l_index
			else
				l_aircraftData.units[l_index].callsign =
					{
						[1]      = l_aircraftData.units[1].callsign[1],
						[2]      = l_aircraftData.units[1].callsign[2],
						[3]      = l_index,
						["name"] = l_acCallname[l_aircraftData.units[1].callsign[1]] .. l_aircraftData.units[1].callsign[2] .. l_index,
					}
			end

			-- Randomize unit skill if flag is set
			if (g_flagRandomSkill) then
				l_aircraftData.units[l_index].skill = g_unitSkill[math.random(1,#g_unitSkill)]
			else
				l_aircraftData.units[l_index].skill = g_unitSkill[g_unitSkillDefault]
			end

			g_numCoalitionAircraft[p_coalitionIndex] = g_numCoalitionAircraft[p_coalitionIndex] + 1		-- Add one aircraft to total aircraft in use
		end
	end

	if (l_acSpawnType[1] == "Turning Point") then
		l_aircraftData.route.points[#l_aircraftData.route.points + 1] =
		{
			["alt"]                = l_acSpawnAlt * 3,
			["alt_type"]           = "RADIO",
			["type"]               = l_acSpawnType[1],
			["action"]             = l_acSpawnType[2],
			["formation_template"] = "",
			["properties"] =
			{
				["vnav"] = 1,
				["scale"] = 0,
				["angle"] = 0,
				["vangle"] = 0,
				["steer"] = 2,
			},
			["y"]                  = g_airbasePoints[l_acSpawnAirdromeID][4],
			["x"]                  = g_airbasePoints[l_acSpawnAirdromeID][3],
			["speed"]              = l_acFlightSpeed,
			["ETA_locked"]         = false,
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] = l_acTasks,
				},
			},
			["speed_locked"]       = true,
		}
	end

	if (g_flagRandomWaypoint ) then
		l_aircraftData.route.points[#l_aircraftData.route.points + 1] =
		{
			["alt"]                = l_acFlightAlt,
			["type"]               = "Turning Point",
			["action"]             = "Turning Point",
			["alt_type"]           = "BARO",
			["formation_template"] = "",
			["properties"] =
			{
				["vnav"] = 1,
				["scale"] = 0,
				["angle"] = 0,
				["vangle"] = 0,
				["steer"] = 2,
			},
			["y"]                  = l_acWaypoint.z,
			["x"]                  = l_acWaypoint.x,
			["speed"]              = l_acFlightSpeed,
			["ETA_locked"]         = false,
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] = l_acTasks,
				},
			},
			["speed_locked"]       = true,
		}
		l_aircraftData.route.points[#l_aircraftData.route.points + 1] =
		{
			["alt"]                = l_acFlightAlt / 2,
			["type"]               = "Land",
			["action"]             = "Landing",
			["alt_type"]           = "BARO",
			["formation_template"] = "",
			["properties"] =
			{
				["vnav"] = 1,
				["scale"] = 0,
				["angle"] = 0,
				["vangle"] = 0,
				["steer"] = 2,
			},
			["airdromeId"]         = l_acLandAirdromeID,
			["y"]                  = l_acLandAirdromePos.z,
			["x"]                  = l_acLandAirdromePos.x,
			["speed"]              = l_acFlightSpeed,
			["ETA_locked"]         = false,
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
					},
				},
			},
			["speed_locked"]       = true,
		}
	else
		l_aircraftData.route.points[#l_aircraftData.route.points + 1] =
		{
			["alt"]                = l_acFlightAlt / 2,
			["type"]               = "Land",
			["action"]             = "Landing",
			["alt_type"]           = "BARO",
			["formation_template"] = "",
			["properties"] =
			{
				["vnav"] = 1,
				["scale"] = 0,
				["angle"] = 0,
				["vangle"] = 0,
				["steer"] = 2,
			},
			["airdromeId"]         = l_acLandAirdromeID,
			["y"]                  = l_acLandAirdromePos.z,
			["x"]                  = l_acLandAirdromePos.x,
			["speed"]              = l_acFlightSpeed,
			["ETA_locked"]         = false,
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] =
					{
					},
				},
			},
			["speed_locked"]       = true,
		}
	end

	if (l_acCategory == "HELICOPTER") then
		coalition.addGroup(l_acCountry, Group.Category.HELICOPTER, l_aircraftData)
	else
		coalition.addGroup(l_acCountry, Group.Category.AIRPLANE, l_aircraftData)
	end

	if (g_debugLog)    then env.info('group:' .. l_aircraftData.name .. '  type:' .. l_acModel .. '  callsign:' .. l_acGroupName .. '  #red:' .. g_numCoalitionAircraft[1] .. '  #blue:' .. g_numCoalitionAircraft[2] .. '  fullname:' .. l_acFullTextName, false) end
	if (g_debugLog)    then env.info('group:' .. l_aircraftData.name .. '  type:' .. l_acModel .. '  spawn:' .. p_spawnIndex.name .. '  land:' .. p_landIndex.name .. '  altitude:' .. l_acFlightAlt .. '  speed:' .. l_acFlightSpeed, false) end
	if (g_debugLog)    then env.info('group:' .. l_aircraftData.name .. '  type:' .. l_acModel .. '  formation:' .. l_acFormation, false) end
	if (g_debugScreen) then trigger.action.outText(' group:' .. l_aircraftData.name .. '  type:' .. l_acModel .. '  callsign:' .. l_acGroupName .. '  #red:' .. g_numCoalitionAircraft[1] .. '  #blue:' .. g_numCoalitionAircraft[2] .. '  fullname:' .. l_acFullTextName .. '  spawn:' .. p_spawnIndex.name .. '  land:' .. p_landIndex.name .. '  altitude:' .. l_acFlightAlt .. '  speed:' .. l_acFlightSpeed, 10) end

	g_RATtable[#g_RATtable+1] =
		{
			groupName      = l_acGroupName,
			flightName     = l_acFullTextName,
			acModel        = l_acModel,
			spawn          = p_spawnIndex.name,
			land           = p_landIndex.name,
			coalition      = p_coalitionIndex,
			unitNames      = l_acUnitNames,
			unitCheckTime  = l_acUnitCheckTime,
			groupCheckTime = 0,
			formationSize  = l_acNumGroup,	-- Store the original number of aircraft in this group
		}

	if (g_debugLog > 1)    then env.info('f_generateAirplane: ending', false) end
end


---------------------------------------------------------
-- Remove a group from the table and possibly, the sim --
---------------------------------------------------------
function f_removeGroup (p_index, p_message, p_destroyFlag, p_aircraftGroup)
	if ((g_numCoalitionAircraft[g_RATtable[p_index].coalition] > 0) and (#g_RATtable[p_index].unitNames > 0)) then		-- If possible, increase the available aircraft for this coalition by the number of units remaining in the group
		if ((g_numCoalitionAircraft[g_RATtable[p_index].coalition] - #g_RATtable[p_index].unitNames) > 0) then
				g_numCoalitionAircraft[g_RATtable[p_index].coalition] = g_numCoalitionAircraft[g_RATtable[p_index].coalition] - #g_RATtable[p_index].unitNames
		else
				g_numCoalitionAircraft[g_RATtable[p_index].coalition] = 0
		end
	end

	if (g_debugLog) then env.info('group:' .. g_RATtable[p_index].groupName .. '  type:' .. g_RATtable[p_index].acModel .. p_message .. '  #red:' .. g_numCoalitionAircraft[1] .. '  #blue:' .. g_numCoalitionAircraft[2], false) end
	if (g_debugScreen) then trigger.action.outText('group:' .. g_RATtable[p_index].groupName .. '  type:' .. g_RATtable[p_index].acModel .. p_message .. '  #red:' .. g_numCoalitionAircraft[1] .. '  #blue:' .. g_numCoalitionAircraft[2], 20) end

	table.remove(g_RATtable, p_index)	-- Group does not exist any longer for this script

	if (p_destroyFlag) then p_aircraftGroup:destroy() end
end


--------------------------------------------------------
-- Remove a unit from the table and possibly, the sim --
--------------------------------------------------------
function f_removeUnit (p_index, p_jndex, p_removeMessage, p_destroyFlag, p_aircraftUnit)
	if (g_numCoalitionAircraft[g_RATtable[p_index].coalition] > 0) then		-- If possible, increase the number of available aircraft for this coalition by one
		g_numCoalitionAircraft[g_RATtable[p_index].coalition] = g_numCoalitionAircraft[g_RATtable[p_index].coalition] - 1
	end

	if (g_debugLog)    then env.info('unit:' .. g_RATtable[p_index].unitNames[p_jndex] .. '  type:' .. g_RATtable[p_index].acModel .. p_removeMessage .. '  #red:' .. g_numCoalitionAircraft[1] .. '  #blue:' .. g_numCoalitionAircraft[2], false) end
	if (g_debugScreen) then trigger.action.outText('unit:' .. g_RATtable[p_index].unitNames[p_jndex] .. '  type:' .. g_RATtable[p_index].acModel .. p_removeMessage .. '  #red:' .. g_numCoalitionAircraft[1] .. '  #blue:' .. g_numCoalitionAircraft[2], 20) end

	table.remove(g_RATtable[p_index].unitNames, p_jndex)		-- Unit does not exist any longer for this script
	table.remove(g_RATtable[p_index].unitCheckTime, p_jndex)	-- Unit does not exist any longer for this script

	if (p_destroyFlag) then p_aircraftUnit:destroy() end

	if (#g_RATtable[p_index].unitNames == 0) then	-- There are no more units in this group, the group needs to be removed
		return true
	else
		return false
	end
end


------------------------------------------------------------------------------------------------------------------------------------
-- Periodically check all dynamically spawned AI units for existence, movement, wandering, below ground, damage, and stuck/parked --
------------------------------------------------------------------------------------------------------------------------------------
function f_checkStatus()
	env.info("f_checkStatus running.", false)
	if (#g_RATtable > 0)
	then
		local l_RATtableLimit = #g_RATtable	 -- Array size may change while loop is running due to removing group
		local l_index = 1

		while ((l_index <= l_RATtableLimit) and (l_RATtableLimit > 0))
		do
			local l_currentAircraftGroup = Group.getByName(g_RATtable[l_index].groupName)

			if (l_currentAircraftGroup) == nil then		-- This group does not exist yet (just now spawning) OR removed by sim (crash or kill)
				if (g_RATtable[l_index].groupCheckTime > 0) then		-- Have we checked this group yet? (should have spawned by now)
					f_removeGroup(l_index, "  removed by sim, not script", false, nil)
					l_RATtableLimit = l_RATtableLimit - 1	-- Array shrinks
				else
					g_RATtable[l_index].groupCheckTime = g_RATtable[l_index].groupCheckTime + 1
					l_index = l_index + 1
				end
			else -- Valid group, make unit checks
				local l_unitNamesLimit = #g_RATtable[l_index].unitNames
				local l_jndex = 1

				while ((l_jndex <= l_unitNamesLimit) and (l_unitNamesLimit > 0))
				do
					local l_currentUnitName = g_RATtable[l_index].unitNames[l_jndex]

					if (Unit.getByName(l_currentUnitName) ~= nil) then -- Valid, active unit
						local l_actualUnit = Unit.getByName(l_currentUnitName)
						local l_actualUnitVel = l_actualUnit:getVelocity()
						local l_absactualUnitVel = math.abs(l_actualUnitVel.x) + math.abs(l_actualUnitVel.y) + math.abs(l_actualUnitVel.z)

					-- Check for unit movement
						if l_absactualUnitVel > 2 then
							g_RATtable[l_index].unitCheckTime[l_jndex] = 0 -- If it's moving, reset checktime
						else
							g_RATtable[l_index].unitCheckTime[l_jndex] = g_RATtable[l_index].unitCheckTime[l_jndex] + 1
						end

						local l_actualUnitPos = l_actualUnit:getPosition().p
						local l_actualUnitHeight = l_actualUnitPos.y - land.getHeight({x = l_actualUnitPos.x, y = l_actualUnitPos.z})
						local l_lowerStatusLimit = g_minDamagedLife * l_actualUnit:getLife0() -- Was 0.95. changed to 0.10

					-- Check for wandering
						if ((l_actualUnitPos.x > 100000) or (l_actualUnitPos.x < -500000) or (l_actualUnitPos.z > 1100000) or (l_actualUnitPos.z < 200000)) then
							if f_removeUnit(l_index, l_jndex, '  removed due to wandering', true, l_actualUnit) then -- If true, then there are no more units in this group
								f_removeGroup(l_index, '  removed, no more units', true, l_currentAircraftGroup)
								l_RATtableLimit = l_RATtableLimit - 1
								l_index = l_index - 1 -- Subtract one now, but later in loop add one, so next run we use the same l_index (because current l_index row has been removed)
								l_jndex = l_unitNamesLimit	-- No need to iterate through anymore units in this group
							else
							l_jndex = l_jndex - 1	-- -1 then +1, stay on current l_jndex because table has shrunk
							l_unitNamesLimit = l_unitNamesLimit - 1 -- total unit table size has shrunk
							end
					-- Check for below ground level
						elseif (l_actualUnitHeight < 0) then
							if f_removeUnit(l_index, l_jndex, '  removed due to being below ground level', true, l_actualUnit) then -- If true, then there are no more units in this group
								f_removeGroup(l_index, '  removed, no more units', true, l_currentAircraftGroup)
								l_RATtableLimit = l_RATtableLimit - 1
								l_index = l_index - 1 -- Subtract one now, but later in loop add one, so next run we use the same l_index (because current l_index row has been removed)
								l_jndex = l_unitNamesLimit	-- No need to iterate through anymore units in this group
							else
								l_jndex = l_jndex - 1	-- -1 then +1, stay on current l_jndex because table has shrunk
								l_unitNamesLimit = l_unitNamesLimit - 1 -- total unit table size has shrunk
							end
					-- check for damaged unit
						elseif ((l_actualUnitHeight < g_minDamagedHeight) and (l_actualUnit:getLife() <= l_lowerStatusLimit)) then
							if f_removeUnit(l_index, l_jndex, '  removed due to damage', true, l_actualUnit) then -- If true, then there are no more units in this group
								f_removeGroup(l_index, '  removed, no more units', true, l_currentAircraftGroup)
								l_RATtableLimit = l_RATtableLimit - 1
								l_index = l_index - 1 -- Subtract one now, but later in loop add one, so next run we use the same l_index (because current l_index row has been removed)
								l_jndex = l_unitNamesLimit	-- No need to iterate through anymore units in this group
							else
								l_jndex = l_jndex - 1	-- -1 then +1, stay on current l_jndex because table has shrunk
								l_unitNamesLimit = l_unitNamesLimit - 1 -- total unit table size has shrunk
							end
					-- Check for stuck
						elseif (g_RATtable[l_index].unitCheckTime[l_jndex] > g_waitTime) then
							if f_removeUnit(l_index, l_jndex, '  removed due to low speed', true, l_actualUnit) then -- If true, then there are no more units in this group
								f_removeGroup(l_index, '  removed, no more units', true, l_currentAircraftGroup)
							end
							-- Lets exit the function for this cycle because an aircraft was removed.
							--  Possible for another blocked aircraft to now move.
							--  (instead that aircraft would be deleted during next run of the current loop)
							l_RATtableLimit = 0
							l_unitNamesLimit = 0
						end
					else
					-- Unit removed by sim
						if f_removeUnit(l_index, l_jndex, '  removed by sim, not script', false, l_actualUnit) then -- If true, then there are no more units in this group
							f_removeGroup(l_index, '  removed, no more units', true, l_currentAircraftGroup)
							l_RATtableLimit = l_RATtableLimit - 1
							l_index = l_index - 1 -- Subtract one now, but later in loop add one, so next run we use the same l_index (because current l_index row has been removed)
							l_jndex = l_unitNamesLimit	-- No need to iterate through anymore units in this group
						else
							l_jndex = l_jndex - 1	-- -1 then +1, stay on current l_jndex because table has shrunk
							l_unitNamesLimit = l_unitNamesLimit - 1 -- total unit table size has shrunk
						end
					end
					l_jndex = l_jndex + 1
				end
				l_index = l_index + 1
			end
		end
	end

return timer.getTime() + g_checkInterval
end


--------------------------------------------------------
-- Determine the bases based on a coalition parameter --
--------------------------------------------------------
function f_getAFBases(p_coalitionIndex)
	local l_AFids = {}
	local l_AF    = {}

	l_AFids = coalition.getAirbases(p_coalitionIndex)
	for i = 1, #l_AFids do
		l_AF[i] =
		{
			name = l_AFids[i]:getName(),
			id_  = l_AFids[i].id_,
			id   = l_AFids[i]:getID()
		}
	end
return l_AF
end


-----------------------------
-- Choose a random airbase --
-----------------------------
function f_chooseAirbase(p_AF)
	local l_airbaseChoice = math.random(1, #p_AF)
return p_AF[l_airbaseChoice]
end

-- Check if possible to spawn a new group for the coalition
function f_checkMax(p_cs)
	if ((g_numCoalitionAircraft[p_cs] < g_maxCoalitionAircraft[p_cs]) and ((g_maxCoalitionAircraft[p_cs] - g_numCoalitionAircraft[p_cs]) >= g_maxGroupSize))then  -- Is ok to spawn a new unit?
		g_numCoalitionAircraft[p_cs] = g_numCoalitionAircraft[p_cs] + 1
		g_numCoalitionGroup[p_cs] = g_numCoalitionGroup[p_cs] + 1
		return true
	else
		return false
	end
end


---------------------------------------
-- Determine spawn and land airbases --
---------------------------------------
function f_makeAirBase(p_cs)
	local l_ab = {}

	l_ab[1] = f_chooseAirbase(g_AB[p_cs])
	l_ab[2] = f_chooseAirbase(g_AB[p_cs])

	if ((g_flagNoSpawnLandingAirbase) and (#g_AB[p_cs] > 1)) then -- If flag is set and more than 1 airbase, don't let spawn and land airbase be the same
		while (l_ab[1] == l_ab[2]) do
			l_ab[2] = f_chooseAirbase(g_AB[p_cs])
		end
	end
return l_ab
end


----------------------------------------------------------------------
-- Main scheduled function to create new coalition groups as needed --
----------------------------------------------------------------------
function f_generateGroup()
	local l_lowVal						-- lowest available coalition side
	local l_highVal						-- highest available coalition side
	local l_airbase   = {}				-- table of spawn and landing airbases
	local l_flagSpawn = {false, false}	-- flags to determine which coalitions get new groups

	-- Names of red bases
	g_AB[1] = f_getAFBases(1)
	if (#g_AB[1] < 1) then
		env.warning("There are no red bases in this mission.", false)
	end

	-- Names of blue bases
	g_AB[2] = f_getAFBases(2)
	if (#g_AB[2] < 1) then
		env.warning("There are no blue bases in this mission.", false)
	end

	-- Choose which coalition side to possibly spawn new aircraft
	if (#g_AB[1] > 0) then
		l_lowVal = 1
	else
		l_lowVal = 2
	end

	if (#g_AB[2] > 0) then
		l_highVal = 2
	else
		l_highVal = 1
	end

	if (l_lowVal > l_highVal) then  -- No coalition bases defined at all!
		env.warning("There are no coalition bases defined!!! exiting dynamic spawn function.", false)
		return
	end

	if (g_randomCoalitionSpawn == 1) then	-- Spawn random coalition
		l_flagSpawn[math.random(l_lowVal, l_highVal)] = true
	else
		if ((g_randomCoalitionSpawn == 3) and (not (g_numCoalitionAircraft[1] == g_numCoalitionAircraft[2])) and (g_maxCoalitionAircraft[1] == g_maxCoalitionAircraft[2]) and (l_lowVal < l_highVal)) then -- Unfair situation
			if (g_numCoalitionAircraft[1] < g_numCoalitionAircraft[2]) then	-- spawn Red group
				l_flagSpawn = {true, false}
			else
				l_flagSpawn = {false, true}
			end
		else
			if (l_lowVal == 1)  then l_flagSpawn[1] = true end
			if (l_highVal == 2) then l_flagSpawn[2] = true end
		end
	end

	-- If needed, spawn new group for each coalition
	for i = 1, 2 do
		if (l_flagSpawn[i] == true) then
			if f_checkMax(i) then
				l_airbase = f_makeAirBase(i)
				f_generateAirplane(i, l_airbase[1], l_airbase[2], g_namePrefix[i])
			end
		end
	end

	g_spawnInterval = math.random(g_spawnIntervalLow, g_spawnIntervalHigh) -- Choose new random spawn interval

return timer.getTime() + g_spawnInterval
end


------------------
-- MAIN PROGRAM --
------------------

env.info("Dynamic AI group spawn script loaded.", false)
timer.scheduleFunction(f_generateGroup, nil, timer.getTime() + g_spawnInterval)
timer.scheduleFunction(f_checkStatus, {}, timer.getTime() + g_checkInterval)
--timer.scheduleFunction(f_checkStatus, {}, timer.getTime() + 4, g_checkInterval)
env.info("Dynamic AI group spawn script running.", false)

end



-- Possible way to remove wrecks:
--If another group has the same name new group has, that group will be destroyed and new group will take its mission ID.
--If another units has the same name an unit of new group has, that unit will be destroyed and the unit of new group will take its mission ID.
--If new group contains player's aircraft current unit that is under player's control will be destroyed.
--http://wiki.hoggit.us/view/Part_1
