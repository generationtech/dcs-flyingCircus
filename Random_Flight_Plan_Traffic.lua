-- Randomly spawn a different kind of aircraft at different coalition airbase up to a limit of total spawned aircraft.
-- In the ME, just designate each coalition airbase assignment on the ME airbase object.


-- Possible way to remove wrecks:
--If another group has the same name new group has, that group will be destroyed and new group will take its mission ID.
--If another units has the same name an unit of new group has, that unit will be destroyed and the unit of new group will take its mission ID.
--If new group contains player's aircraft current unit that is under player's control will be destroyed.
--http://wiki.hoggit.us/view/Part_1


do
--
--EDIT BELOW
--

--FLAGS
flgRandomFuel = true				-- Random fuel loadout?		--check
flagRandomWeapons = true			-- Add weapons to aircraft?		--check
flagRandomWaypoint = true			-- Create intermediate waypoint?		--check
flgNoSpawnLandingAirbase = true		-- Don't allow spawning airbase and landing airbase to be the same?		--check
flgSetTasks = true					-- Enable general tasks appropriate for each unit (CAP, CAS, REFUEL, etc)		--check
flgRandomSkins = true				-- Randomize the skins for each aircraft (otherwise just choose 1st defined skin)
flgRandomSkill = true				-- Randomize AI pilot skill level		--check
flgRandomAltitude = true			-- Randomize altitude (otherwise use standard altitude per aircraft type)		--check
flgRandomSpeed = true				-- Randomize altitude (otherwise use standard speed per aircraft type)		--check
flgRandomParkingType = true			-- Randomize type of parking spot for spawn location		--check
flgRandomGroupSize = true			-- Randomize group size, if applicable		--check
flgRandomFormation = true			-- Randomize formations in multiple unit groups, else use default formation value		--check

--DEBUG
debugLog = true		-- write entries to the log		--check
debugScreen = true	-- write messages to screen		--check

--RANGES
randomCoalitionSpawn = 3						-- Coalition spawn style: 1=random coalition, 2=equal spawn per coalition each time, 3=fair spawn-try to keep total units equal for each coalition ( maxCoalitionAircraft{} must be equal for #3 to work)		--check
spawnIntervalLow = 15							-- Random spawn low end repeat interval		--check
spawnIntervalHigh = 30							-- Random spawn high end repeat interval		--check
checkInterval = 20								-- How frequently to check dynamic AI groups status (effective rate to remove stuck aircraft is combined with waitTime in checkStatus() function)		--check
aircraftDistribution = {20, 40, 60, 80, 100}	-- Distribution of aircraft type Utility, Bomber, Attack, Fighter, Helicopter (must be 1-100 range array)		--check
maxGroupSize = 4								-- Maximum number of groups for those units supporting formations		--check
minGroupSize = 1								-- Minimum number of groups for those units supporting formations
maxCoalitionAircraft = {20, 20}					-- Maximum number of red, blue units
NamePrefix = {"Red-", "Blue-"}					-- Prefix to use for naming groups		--check
waypointRange = {50000, 50000}					-- Maximum x,y of where to place intermediate waypoint between takeoff		--check
waitTime = 15									-- Amount to time to wait before considering aircraft to be parked or stuck		--check
minDamagedLife = 0.10							-- Minimum % amount of life for aircraft under minDamagedHeight		--check
minDamagedHeight = 20							-- Minimum height to start checking for minDamagedLife		--check
unitSkillDefault = 3							-- Default unit skill if not using randomize unitSkill[unitSkillDefault]		--check
defaultParkingSpotType = 4						-- If not randomizing spawn parking spot, which one should be used as default parkingSpotType[?/2+1]		--check
lowFuelPercent = 0.10							-- If randomizing fuel, the low end percent		--check
highFuelPercent = 0.15							-- If randomizing fuel, the high end percent		--check
parkingSpotType =
	{											-- List of waypoint styles used for spawn point (2 entries for each, one type and one for action)		--check
		"TakeOffParking", "From Parking Area",
		"TakeOffParkingHot", "From Parking Area Hot",
		"TakeOff", "From Runway",
		"Turning Point", "Turning Point",
		"Turning Point", "Turning Point"		-- Favour in-air start
	}
spawnSpeedTurningPoint = 125					-- When spawning in the air as turning point, starting speed		--check
defaultAirplaneFormation = 1					-- When not randomizing formations, the default airplane formation #
defaultHelicopterFormation = 1					-- When not randomizing formations, the default helicopter formation #
unitSkill = 									-- List of possible skill levels for AI units
	{
		"Average",
		"Good",
		"High",
		"Excellent",
		"Random"
	}
airplaneFormation =													-- Airplane formations
	{																-- {"Formation Name", "variantIndex", "name", "formationIndex", "value"}
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
helicopterFormation =												-- Helicopter formations
	{																-- {"Formation Name", "variantIndex", "zInverse", "name", "formationIndex", "value"}
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


-- Should be no need to edit these below
RATtable = {}
nameCallname = {}													-- List of radio callnames possible for that particular aircraft type
generateID = 0														-- Function ID of scheduled function to create new AI units
spawnInterval = math.random(spawnIntervalLow, spawnIntervalHigh)	-- Initial random spawn repeat interval
AB = {}																-- Coalition AirBase table

-- Inventory running limits
numCoalitionAircraft = {0, 0}										-- Current number of active coalition units
numCoalitionGroup = {0, 0}											-- Cumulative highest coalition groups

--env.setErrorMessageBoxEnabled(false)

coalitionTable = 	-- Big matrix mapping all countries to their aircraft and skins
	{	-- Countries
	[0] =													--RUSSIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {14, 1, 2},				-- A-50
				[2] = {1, 4, 5},				-- An-26B
				[3] = {2, 2},					-- An-30M
				[4] = {7, 3, 4, 5},				-- IL-76MD
				[5] = {15, 3, 4, 5},			-- IL-78M
				[6] = {9, 1},					-- MiG-25RBT
				[7] = {11, 1},					-- Su-24MR
				[8] = {12, 1},					-- TF-51D
				[9] = {13, 3},					-- Yak-40
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {21, 1},					-- Su-24M
				[2] = {26, 1},					-- Tu-142
				[3] = {27, 1},					-- Tu-160
				[4] = {24, 1},					-- Tu-22M3
				[5] = {25, 1},					-- Tu-95MS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 36, 37},				-- A-10C
				[2] = {30, 2},					-- Hawk
				[3] = {31, 3, 4, 5},			-- L-39ZA
				[4] = {32, 1},					-- MiG-27K
				[5] = {33, 1, 2},				-- Su-17M4
				[6] = {34, 2, 7, 8, 9},			-- Su-25
				[7] = {35, 1, 2, 3},			-- Su-25T
				[8] = {36, 1},					-- Su-25TM
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1]  = {45, 1},														-- F-86F Sabre
				[2]  = {47, 9},														-- FW-190D9
				[3]  = {49, 1, 2, 3, 4, 5, 6},										-- MiG-21Bis
				[4]  = {50, 1, 2, 3, 4},											-- MiG-23MLD
				[5]  = {51, 1},														-- MiG-25PD
				[6]  = {52, 3, 4, 5, 6, 7},											-- MiG-29A
				[7]  = {59, 1, 2, 3, 4, 5, 6, 7},									-- MiG-29S
				[8]  = {60, 1, 2, 3},												-- MiG-31
				[9]  = {56, 1, 2, 3, 27, 31, 32, 33, 34, 35, 36},					-- P-51D
				[10] = {57, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19},	-- Su-27
				[11] = {61, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},							-- Su-30
				[12] = {62, 1, 2, 3, 4, 5, 6, 7, 8},								-- Su-33
				[13] = {63, 1, 2},													-- Su-34
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {69, 2},														-- Ka-27
				[2] = {70, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44},		-- Ka-50
				[3] = {71, 4, 5, 6, 7},												-- Mi-24V
				[4] = {72, 3, 4, 5, 6},												-- Mi-26
				[5] = {77, 1, 2},													-- Mi-28N
				[6] = {73, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30},			-- Mi-8MT
				[7] = {76, 29, 30},													-- UH-1H
			},
		},
	[1] = 													--UKRAINE
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {1, 2},					-- An-26B
				[2] = {2, 1},					-- An-30M
				[3] = {7, 1, 2},				-- IL-76MD
				[4] = {9, 1},					-- MiG-25RBT
				[5] = {11, 1},					-- Su-24MR
				[6] = {13, 2},					-- Yak-40
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {21, 1},					-- Su-24M
				[2] = {24, 1},					-- Tu-22M3
				[3] = {25, 1},					-- Tu-95MS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 35},					-- A-10C
				[2] = {30, 2},					-- Hawk
				[3] = {31, 2},					-- L-39ZA
				[4] = {32, 1},					-- MiG-27K
				[5] = {33, 1, 2, 3},			-- Su-17M4
				[6] = {34, 3, 4, 5, 6},			-- Su-25
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {48, 1},					-- MiG-15bis
				[3] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[4] = {50, 1},					-- MiG-23MLD
				[5] = {51, 1},					-- MiG-25PD
				[6] = {52, 1, 2, 3},			-- MiG-29A
				[7] = {54, 1, 2, 3},			-- MiG-29S
				[8] = {56, 1, 2, 3, 29, 30},	-- P-51D
				[9] = {57, 1, 2, 3, 4, 50},		-- Su-27
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {69, 1},					-- Ka-27
				[2] = {70, 29, 30 ,31},			-- Ka-50
				[3] = {71, 2, 3},				-- Mi-24V
				[4] = {72, 1, 2},				-- Mi-26
				[5] = {73, 1},					-- Mi-8MT
				[6] = {76, 28},					-- UH-1H
			},
		},
	[2] = 													--USA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 1},					-- C-130
				[2] = {4, 1},					-- C-17A
				[3] = {5, 1, 2},				-- E-2C
				[4] = {6, 1, 2},				-- E-3A
				[5] = {8, 1},					-- KC-135
				[6] = {10, 1},					-- S-3B Tanker
				[7] = {12, 2, 3, 4, 5},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {16, 1},					-- B-1B
				[2] = {17, 1},					-- B-52H
				[3] = {18, 1},					-- F-117A
				[4] = {19, 1, 2},				-- F-15E
				[5] = {20, 1},					-- S-3B
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {28, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18},			-- A-10A
				[2] = {29, 2, 3, 4, 5,6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19},			-- A-10C
				[3] = {30, 2, 3, 4, 5, 6, 7},														-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1]  = {38, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},											-- F-14A
				[2]  = {39, 1, 2, 3, 4, 5, 6, 7, 8},												-- F-15C
				[3]  = {40, 1},																		-- F-16A
				[4]  = {41, 1, 2, 3, 4, 5, 6, 7, 8},												-- F-16C bl.52d
				[5]  = {44, 1, 2, 3, 4, 5, 6, 7, 8, 9},												-- F-5E
				[6]  = {45, 1},																		-- F-86F Sabre
				[7]  = {46, 2, 3, 4, 5},															-- F/A-18C
				[8]  = {47, 1},																		-- FW-190D9
				[9]  = {48, 1},																		-- MiG-15bis
				[10] = {49, 1, 2, 3, 4, 5, 6},														-- MiG-21Bis
				[11] = {56, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22},	-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1]  = {64, 1, 2, 3},								-- AH-1W
				[2]  = {65, 1, 2},									-- AH-64A
				[3]  = {66, 1},										-- AH-64D
				[4]  = {67, 1},										-- CH-47D
				[5]  = {68, 1},										-- CH-53E
				[6]  = {70, 1, 2, 3},								-- Ka-50
				[7]  = {73, 1, 2, 3},								-- Mi-8MT
				[8]  = {74, 1},										-- OH-58D
				[9]  = {75, 1},										-- SH-60B
				[10] = {76, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12},	-- UH-1H
			},
		},
	[3] = 													--TURKEY
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 11},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},					-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {58, 1},					-- F-16C bl.50
				[2] = {43, 1},					-- F-4E
				[3] = {44, 10},					-- F-5E
				[4] = {45, 1},					-- F-86F Sabre
				[5] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[6] = {56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {64, 4, 5},				-- AH-1W
				[2] = {70, 47, 48, 49, 50},		-- Ka-50
				[3] = {73, 1, 2, 33},			-- Mi-8MT
				[4] = {76, 31},					-- UH-1H
				[5] = {78, 1},					-- UH-60A
			},
		},
	[4] = 													--UK
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 10},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {22, 1, 2, 3, 4, 5, 6},	-- Tornado GR4
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},										-- A-10C
				[2] = {30, 2, 9, 10, 11, 12, 13, 14, 15, 16, 17},	-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {47, 8},					-- FW-190D9
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {65, 5},					-- AH-64A
				[2] = {66, 4},					-- AH-64D
				[3] = {67, 5},					-- CH-47D
				[4] = {70, 28},					-- Ka-50
				[5] = {73, 1, 2, 18},			-- Mi-8MT
				[6] = {76, 11},					-- UH-1H
			},
		},
	[5] = 													--FRANCE
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 5},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 24},					-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {48, 1},					-- MiG-15bis
				[3] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[4] = {55, 1, 2, 3, 4, 5, 6},	-- Mirage 2000-5
				[5] = {56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 11, 12, 13},			-- Ka-50
				[2] = {73, 1, 2, 7, 8},			-- Mi-8MT
				[3] = {76, 17},					-- UH-1H
			},
		},
	[6] = 													--GERMANY
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {23, 1, 2, 3, 4, 5},		-- Tornado IDS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 27, 28},				-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {37, 1, 2, 3, 4, 5, 6, 7},-- Bf-109K-4
				[2] = {43, 2},					-- F-4E
				[3] = {45, 1},					-- F-86F Sabre
				[4] = {47, 2, 3, 4, 5, 6, 7},	-- FW-190D9
				[5] = {48, 1},					-- MiG-15bis
				[6] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[7] = {53, 1, 2, 3, 4, 5, 6},	-- MiG-29G
				[8] = {56, 1, 2, 3, 24},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 15, 16},				-- Ka-50
				[2] = {73, 1, 2, 10},			-- Mi-8MT
				[3] = {76, 20},					-- UH-1H
			},
		},
	[8] = 													--CANADA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 3},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 21, 22, 23},			-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {46, 1},					-- F/A-18C
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[5] = {56, 1, 2, 3, 23},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 8},					-- Ka-50
				[2] = {73, 1, 2, 5},			-- Mi-8MT
				[3] = {76, 16},					-- UH-1H
			},
		},
	[9] = 													--SPAIN
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 8},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 32, 33, 34},			-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {46, 1},					-- F/A-18C
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[5] = {56, 1, 2, 3, 27},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {67, 3},					-- CH-47D
				[2] = {70, 23, 24, 25},			-- Ka-50
				[3] = {73, 1, 2, 15},			-- Mi-8MT
				[4] = {76, 25, 26},				-- UH-1H
			},
		},
	[10] = 													--THE_NETHERLANDS
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 9},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},					-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 5, 6},				-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[5] = {56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {65, 4},					-- AH-64A
				[2] = {66, 3},					-- AH-64D
				[3] = {67, 4},					-- CH-47D
				[4] = {70, 26, 27},				-- Ka-50
				[5] = {73, 1, 2, 16, 17},		-- Mi-8MT
				[6] = {76, 27},					-- UH-1H
			},
		},
	[11] = 													--BELGIUM
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 2},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},					-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 1},					-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[5] = {56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 5, 6, 7},			-- Ka-50
				[2] = {73, 4},					-- Mi-8MT
				[3] = {76, 11},					-- UH-1H
			},
		},
	[12] = 													--NORWAY
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 7},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 31},					-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 3, 4},				-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[5] = {56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 22},					-- Ka-50
				[2] = {73, 1, 2, 14},			-- Mi-8MT
				[3] = {76, 11},					-- UH-1H
			},
		},
	[13] = 													--DENMARK
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 4},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},					-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 2},					-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[5] = {56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 9, 10},				-- Ka-50
				[2] = {73, 6},					-- Mi-8MT
				[3] = {76, 11},					-- UH-1H
			},
		},
	[15] = 													--ISRAEL
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 6},					-- C-130
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {19, 3},					-- F-15E
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 29},					-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {39, 9},					-- F-15C
				[2] = {41, 9},					-- F-16C bl.52d
				[3] = {43, 1},					-- F-4E
				[4] = {45, 1},					-- F-86F Sabre
				[5] = {48, 1},					-- MiG-15bis
				[6] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[7] = {56, 1, 2, 3, 25},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {64, 1},					-- AH-1W
				[2] = {65, 3},					-- AH-64A
				[3] = {66, 2},					-- AH-64D
				[4] = {70, 17, 18, 19},			-- Ka-50
				[5] = {73, 1, 2, 11},			-- Mi-8MT
				[6] = {76, 21},					-- UH-1H
			},
		},
	[16] = 													--GEORGIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {1, 1},					-- An-26B
				[2] = {13, 1},					-- Yak-40
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 25, 26},				-- A-10C
				[2] = {30, 2},					-- Hawk
				[3] = {31, 1},					-- L-39ZA
				[4] = {34, 1, 2},				-- Su-25
				[5] = {35, 1, 2},				-- Su-25T
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {48, 1},					-- MiG-15bis
				[3] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[4] = {56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 14},					-- Ka-50
				[2] = {71, 1},					-- Mi-24V
				[3] = {73, 9},					-- Mi-8MT
				[4] = {76, 18, 19},				-- UH-1H
			},
		},
	[17] = 													--INSURGENTS			-- HANDLE INSURGENTS NO AIRCRAFT CONDITION --
		{ -- No aircraft
		},
	[18] = 													--ABKHAZIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {1, 5},					-- An-26B
				[2] = {12, 1},					-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {30, 2},					-- Hawk
				[2] = {31, 6},					-- L-39ZA
				[3] = {34, 10},					-- Su-25
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[3] = {56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 45},					-- Ka-50
				[2] = {71, 8},					-- Mi-24V
				[3] = {73, 31},					-- Mi-8MT
				[4] = {76, 11},					-- UH-1H
			},
		},
	[19] = 													--SOUTH_OSETIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 46},					-- Ka-50
				[2] = {71, 9},					-- Mi-24V
				[3] = {73, 32},					-- Mi-8MT
			},
		},
	[20] = 													--ITALY
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {23, 1, 2, 3, 4},			-- Tornado IDS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 30},					-- A-10C
				[2] = {30, 2},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 2},					-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[5] = {56, 1, 2, 3, 26},		-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {70, 20, 21},				-- Ka-50
				[2] = {73, 1, 2, 12, 13},		-- Mi-8MT
				[3] = {76, 22, 23, 24},			-- UH-1H
			},
		},
	[21] = 													--AUSTRALIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 20},					-- A-10C
				[2] = {30, 1},					-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {46, 6},					-- F/A-18C
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[5] = {56, 1, 2, 3},			-- P-51D
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[1] = {67, 2},					-- CH-47D
				[2] = {70, 4},					-- Ka-50
				[3] = {76, 13, 14, 15},			-- UH-1H
			},
		},
	}

aircraftTable =
	{
	[1] =								-- An-26B
		{
			_aircrafttype = "An-26B",
			_singleInFlight = true,

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5500",
				["flare"] = 384,
				["chaff"] = 384,
				["gun"] = 100,
			},

			_skins =
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
			_aircrafttype = "An-30M",
			_singleInFlight = true,

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "8300",
				["flare"] = 192,
				["chaff"] = 192,
				["gun"] = 100,
			},

			_skins =
			{
				"15th Transport AB",
				"RF Air Force",
			},
		},
	[3] =								-- C-130
		{
			_aircrafttype = "C-130",
			_singleInFlight = true,

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "20830",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			_skins =
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
			_aircrafttype = "C-17A",
			_singleInFlight = true,

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "132405",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			_skins =
			{
				"usaf standard",
			},
		},
	[5] =								-- E-2C
		{
			_aircrafttype = "E-2C",
			_singleInFlight = true,

			nameCallname = {"Overlord", "Magic", "Wizard", "Focus", "Darkstar"},

			_tasks =
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

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5624",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			_skins =
			{
				"E-2D Demo",
				"VAW-125 Tigertails",
			},
		},
	[6] =								-- E-3A
		{
			_aircrafttype = "E-3A",
			_singleInFlight = true,

			nameCallname = {"Overlord", "Magic", "Wizard", "Focus", "Darkstar"},

			_tasks =
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

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "65000",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			_skins =
			{
				"nato",
				"usaf standard",
			},
		},
	[7] =								-- IL-76MD
		{
			_aircrafttype = "IL-76MD",
			_singleInFlight = true,

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "80000",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			},

			_skins =
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
			_aircrafttype = "KC-135",
			_singleInFlight = true,

			nameCallname = {"Texaco", "Arco", "Shell"},

			_tasks =
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

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = 90700,
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			},

			_skins =
			{
				"Standard USAF",
			},
		},
	[9] =								-- MiG-25RBT
		{
			_aircrafttype = "MiG-25RBT",
			_singleInFlight = true,


			_task = "Reconnaissance",
			_tasks =
			{
			},

			_payload =
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

			_skins =
			{
				"af standard",
			},
		},
	[10] =								-- S-3B Tanker
		{
			_aircrafttype = "S-3B Tanker",
			_singleInFlight = true,

			nameCallname = {"Texaco", "Arco", "Shell"},

			_tasks =
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

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5500",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			_skins =
			{
				"usaf standard",
			},
		},
	[11] =								-- Su-24MR
		{
			_aircrafttype = "Su-24MR",
			_singleInFlight = true,

			_task = "Reconnaissance",
			_tasks =
			{
			},

			_payload =
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

			_skins =
			{
				"af standard",
			},
		},
	[12] =								-- TF-51D
		{
			_aircrafttype = "TF-51D",
			_singleInFlight = true,

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "501",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			_skins =
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
			_aircrafttype = "Yak-40",
			_singleInFlight = true,

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "3080",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			_skins =
			{
				"Georgian Airlines",
				"Ukrainian",
				"Aeroflot",
			},
		},
	[14] =								-- A-50
		{
			_aircrafttype = "A-50",
			_singleInFlight = true,

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "70000",
				["flare"] = 192,
				["chaff"] = 192,
				["gun"] = 100,
			},

			_skins =
			{
				"RF Air Force",
				"RF Air Force new",
			},
		},
	[15] =								-- IL-78M
		{
			_aircrafttype = "An-26B",
			_singleInFlight = true,

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "90000",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			},

			_skins =
			{
				"RF Air Force",
				"RF Air Force aeroflot",
				"RF Air Force new",
			},
		},
	[16] =								-- B-1B
		{
			_aircrafttype = "B-1B",
			_singleInFlight = true,

			_task = "Ground Attack",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"usaf standard",
			},
		},
	[17] =								-- B-52H
		{
			_aircrafttype = "B-52H",
			_singleInFlight = true,

			_task = "Ground Attack",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"usaf standard",
			},
		},
	[18] =								-- F-117A
		{
			_aircrafttype = "F-117A",
			_singleInFlight = true,

			_task = "Pinpoint Strike",
			_tasks =
			{
			},

			_payload =
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

			_skins =
			{
				"usaf standard",
			},
		},
	[19] =								-- F-15E
		{
			_aircrafttype = "F-15E",
			_singleInFlight = true,

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"335th Fighter SQN (SJ)",
				"492d Fighter SQN (LN)",
				"IDF No 69 Hammers Squadron",
			},
		},
	[20] =								-- S-3B
		{
			_aircrafttype = "S-3B",
			_singleInFlight = true,

			_task = "Ground Attack",
			_tasks =
			{
			},

			_payload =
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

			_skins =
			{
				"NAVY Standard",
			},
		},
	[21] =								-- Su-24M
		{
			_aircrafttype = "Su-24M",
			_singleInFlight = true,

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"af standard",
			},
		},
	[22] =								-- Tornado GR4
		{
			_aircrafttype = "Tornado GR4",
			_singleInFlight = true,

			_payload =
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

			_skins =
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
			_aircrafttype = "Tornado IDS",
			_singleInFlight = true,

			_payload =
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

			_skins =
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
			_aircrafttype = "Tu-22M3",
			_singleInFlight = true,

			_task = "Ground Attack",
			_tasks =
			{
			},

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
					},
					[4] =
					{
						["CLSID"] = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
					},
					[7] =
					{
						["CLSID"] = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
					},
				},
				["fuel"] = "50000",
				["flare"] = 48,
				["chaff"] = 48,
				["gun"] = 100,
			},

			_skins =
			{
				"af standard",
			},
		},
	[25] =								-- Tu-95MS
		{
			_aircrafttype = "Tu-95MS",
			_singleInFlight = true,

			_task = "Pinpoint Strike",
			_tasks =
			{
			},

			_payload =
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

			_skins =
			{
				"af standard",
			},
		},
	[26] =								-- Tu-142
		{
			_aircrafttype = "Tu-142",
			_singleInFlight = true,

			_task = "Antiship Strike",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"af standard",
			},
		},
	[27] =								-- Tu-160
		{
			_aircrafttype = "Tu-160",
			_singleInFlight = true,

			_task = "Pinpoint Strike",
			_tasks =
			{
			},

			_payload =
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

			_skins =
			{
				"af standard",
			},
		},
	[28] =								-- A-10A
		{
			_aircrafttype = "A-10A",

--			local addCallname = {"Hawg", "Boar", "Pig", "Tusk"}
--			local c = #nameCallname
--			for k,v in pairs(addCallname) do						--FIX--
--				nameCallname[c + k] = v
--			end

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "A-10C",

--			local addCallname = {"Hawg", "Boar", "Pig", "Tusk"}
--			local c = #nameCallname
--			for k,v in pairs(addCallname) do						--FIX--
--				nameCallname[c + k] = v
--			end

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "Hawk",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "L-39ZA",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "MiG-27K",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"af standard",
			},
		},
	[33] =								-- Su-17M4
		{
			_aircrafttype = "Su-17M4",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"af standard",
				"af standard (worn-out)",
				"shap limanskoye ab",
			},
		},
	[34] =								-- Su-25
		{
			_aircrafttype = "Su-25",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "Su-25T",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"af standard",
				"af standard 1",
				"su-25t test scheme",
			},
		},
	[36] =								-- Su-25TM
		{
			_aircrafttype = "Su-25TM",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"Flight Research Institute  VVS",
			},
		},
	[37] =								-- Bf-109K-4
		{
			_aircrafttype = "Bf-109K-4",

			_payload =
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

			_skins =
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
			_aircrafttype = "F-14A",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "F-15C",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "F-16A",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"usaf f16 standard-1",
			},
		},
	[41] =								-- F-16C bl.52d
		{
			_aircrafttype = "F-16C bl.52d",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "F-16A MLU",

			_payload =
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
					[3] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[4] =
					{
						["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
					},
					[5] =
					{
						["CLSID"] = "{CAAC1CFD-6745-416B-AFA4-CB57414856D0}",
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
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[10] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
				},
				["fuel"] = "3104",
				["flare"] = 30,
				["chaff"] = 60,
				["gun"] = 100,
			},

			_skins =
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
			_aircrafttype = "F-4E",

			_payload =
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

			_skins =
			{
				"",
				"af standard",
			},
		},
	[44] =								-- F-5E
		{
			_aircrafttype = "F-5E",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "F-86F Sabre",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"",
			},
		},
	[46] =								-- F/A-18C
		{
			_aircrafttype = "F/A-18C",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "FW-190D9",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "MiG-15bis",

			_payload =
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

			_skins =
			{
				"",
			},
		},
	[49] =								-- MiG-21Bis
		{
			_aircrafttype = "MiG-21Bis",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "MiG-23MLD",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"af standard",
				"af standard-1",
				"af standard-2",
				"af standard-3 (worn-out)",
			},
		},
	[51] =								-- MiG-25PD
		{
			_aircrafttype = "MiG-25PD",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"af standard",
			},
		},
	[52] =								-- MiG-29A
		{
			_aircrafttype = "MiG-29A",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
		}
	[53] = 								-- MiG-29G
		{
			_aircrafttype = "MiG-29G",

			_payload =
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

			_skins =
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
			_aircrafttype = "MiG-29S",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"14th army, vinnitsa ab",
				"9th fw belbek ab",
				"`ukrainian falcons` paint scheme",
			},
		},
	[55] =								-- Mirage 2000-5
		{
			_aircrafttype = "Mirage 2000-5",

			_payload =
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

			_skins =
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
			_aircrafttype = "P-51D",

			_tasks =
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

			_payload =
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
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			_skins =
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
			_aircrafttype = "Su-27",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "F-16C bl.50",

			_payload =
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

			_skins =
			{
				"af f16 standard",
			},
		},
	[59] =								-- MiG-29S
		{
			_aircrafttype = "MiG-29S",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "MiG-31",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"af standard",
				"174 GvIAP_Boris Safonov",
				"903_White",
			},
		},
	[61] =								-- Su-30
		{
			_aircrafttype = "Su-30",

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "Su-33,

			_task = "CAP",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "Su-34",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"af standard",
				"af standard 2",
			},
		},
	[64] =								-- AH-1W
		{
			_aircrafttype = "AH-1W",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "AH-64A",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "AH-64D",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"standard",
				"ah-64_d_isr",
				"ah-64_d_green neth",
				"ah-64_d_green uk",
			},
		},
	[67] =								-- CH-47D
		{
			_aircrafttype = "CH-47D",

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "3600",
				["flare"] = 120,
				["chaff"] = 120,
				["gun"] = 100,
			},

			_skins =
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
			_aircrafttype = "CH-53E",

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "1908",
				["flare"] = 60,
				["chaff"] = 60,
				["gun"] = 100,
			},

			_skins =
			{
				"standard",
			},
		},
	[69] =								-- Ka-27
		{
			_aircrafttype = "Ka-27",

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "2616",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			},

			_skins =
			{
				"ukraine camo 1",
				"standard",
			},
		},
	[70] =								-- Ka-50
		{
			_aircrafttype = "Ka-50",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "Mi-24V",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "Mi-26",

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "9600",
				["flare"] = 192,
				["chaff"] = 0,
				["gun"] = 100,
			},

			_skins =
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
			_aircrafttype = "Mi-8MT",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
			_aircrafttype = "OH-58D",

			_task = "AFAC",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"",
			},
		},
	[75] =								-- SH-60B
		{
			_aircrafttype = "SH-60B",

			_task = "Antiship Strike",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"standard",
			},
		},
	[76] =								-- UH-1H
		{
			_aircrafttype = "UH-1H",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
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
				"[Civilian] Standard"
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
			_aircrafttype = "Mi-28N",

			_task = "CAS",
			_tasks =
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

			_payload =
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

			_skins =
			{
				"night",
				"standard",
			},
		},
	[78] =								-- UH-60A
		{
			_aircrafttype = "UH-60A",

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "1100",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			},

			_skins =
			{
				"standard",
			},
		},
	}


-- Create a new aircraft based on coalition, airbase, and name prefix
function generateAirplane(coalitionIndex, spawnIndex, landIndex, nameP)
	_category = "AIRPLANE" -- Default to airplane type

	-- Pick a country from the given coalition
	if (coalitionIndex == 1)
		_acCountry = math.random(1, #env.mission.coalitions.red)
		_country = env.mission.coalitions.red[_acCountry]
	else
		_acCountry = math.random(1, #env.mission.coalitions.blue)
		_country = env.mission.coalitions.blue[_acCountry]
	end

	-- Pick an aircraft type from the given country
	AircraftType = math.random(1,100) --random for utility airplane, bomber, attack, fighter, or helicopter
	if ((AircraftType >= 1) and (AircraftType <= aircraftDistribution[1])) then  -- UTILITY AIRCRAFT
		_acTypeIndex = 1
	elseif ((AircraftType >= aircraftDistribution[1]) and (AircraftType <= aircraftDistribution[2])) then  -- BOMBERS
		_acTypeIndex = 2
	elseif ((AircraftType >= aircraftDistribution[2]) and (AircraftType <= aircraftDistribution[3])) then  -- ATTACK AIRCRAFT
		_acTypeIndex = 3
	elseif ((AircraftType >= aircraftDistribution[3]) and (AircraftType <= aircraftDistribution[4])) then  -- FIGHTERS
		_acTypeIndex = 4
	elseif ((AircraftType >= aircraftDistribution[4]) or (AircraftType <= aircraftDistribution[5])) then -- HELICOPTERS
		_acTypeIndex = 5
	end

	-- Pick an aircraft skin set from the given aircraft type
	_acIndex = math.random(1, #coalitionTable[_country][_acTypeIndex])

	-- Pick an aircraft from the given country and type
	_ac = coalitionTable[_country][_acTypeIndex][_acIndex][1]

	-- Pick a skin from the given aircraft
	_acSkin = math.random(2, #coalitionTable[_country][_acTypeIndex][_acIndex])

	-- The specific aircraft
	_aircrafttype = aircraftTable[_ac]._aircrafttype

	-- Formation flying or not
	if (aircraftTable[_ac]._singleInFlight) then
		_singleInFlight = true
	else
		_singleInFlight = true
	end

	-- Set callsign name
	if (aircraftTable[_ac].nameCallname) then
		nameCallname = aircraftTable[_ac].nameCallname
	else
		nameCallname = {"Enfield", "Springfield", "Uzi", "Colt", "Dodge", "Ford", "Chevy", "Pontiac"}
	end

	-- Set tasking
	if (aircraftTable[_ac]._task) then
		_task = aircraftTable[_ac]._task
	else
		_task = ""
	end

	-- Set tasks
	if (aircraftTable[_ac]._tasks) then
		_tasks = aircraftTable[_ac]._tasks
	else
		_tasks = ""
	end

	-- Set payload
	_payload = aircraftTable[_ac]._payload

	-- Set skin
	_skin = aircraftTable[_ac]._skins[_acSkin]

	-- Set full name used for messages
	_fullname = country.id[_country] .. _aircrafttype .. " - " .. _skin


	-- Randomize the fuel load
	if (flgRandomFuel) then
		_payload.fuel = math.random(_payload.fuel * lowFuelPercent, _payload.fuel * highFuelPercent)
	end

	-- Ignore tasks is flag not set
	if (not flgSetTasks) then
		_task = ""
		_tasks =
		{
		}
	end

	-- Ignore weapons is flag not set
	if (not flagRandomWeapons) then
		_payload.pylons = {}
	end

	-- Randomize unit skill if flag is set
	if (flgRandomSkill) then
		_skill = unitSkill[math.random(1,#unitSkill)]
	else
		_skill = unitSkill[unitSkillDefault]
	end

	-- Randomize altitude is flag is set
	if (flgRandomAltitude) then
		_flightalt = math.random(0,10000)
	else
		_flightalt = 2500
	end

	-- Randomize speed is flag is set
	if (flgRandomSpeed) then
		_flightspeed = math.random(100,1000)
	else
		_flightspeed = 180
	end

--FIX-----
	if (flgRandomParkingType) then
		local i = math.random(1, #parkingSpotType / 2)
		_parkingType = {parkingSpotType[i*2-1], parkingSpotType[i*2]}
	else
		_parkingType = {parkingSpotType[defaultParkingSpotType*2-1], parkingSpotType[defaultParkingSpotType*2]}
	end
--FIX-----

	-- Build up sim callsign
	if ((_country == country.id.RUSSIA) or (_country == country.id.ABKHAZIA) or (_country == country.id.SOUTH_OSETIA) or (_country == country.id.UKRAINE)) then
		_callname = numCoalitionGroup[coalitionIndex] .. 1
	else
		local a = math.random(1,#nameCallname)
		local b = math.random(1,9)
		_callname =
			{
				[1] = a,
				[2] = b,
				[3] = 1,
				["name"] = nameCallname[a] .. b .. 1,
			}
	end

	_spawnairdromeId = spawnIndex.id
	_spawnairbaseloc = Object.getPoint({id_=spawnIndex.id_})
	_spawnairplanepos = {}
	_spawnairplanepos.x = _spawnairbaseloc.x
	_spawnairplanepos.z = _spawnairbaseloc.z
	_spawnairplaneparking = math.random(1,40)

	_waypointtype = _parkingType[1]
	_waypointaction = _parkingType[2]
	if (_waypointtype == "Turning Point") then
		_spawnSpeed = spawnSpeedTurningPoint
		Pos3 = Object.getPosition({id_=spawnIndex.id_})
		_spawnHeading = (Pos3.p.y / 360) * 6.28
	else
		_spawnSpeed = 0
		_spawnHeading = 0
	end

	_landairbaseID = landIndex.id
	_landairbaseloc = Object.getPoint({id_=landIndex.id_})
	_landairplanepos = {}
	_landairplanepos.x = _landairbaseloc.x
	_landairplanepos.z = _landairbaseloc.z

	-- Compute single intermediate waypoint based on used-defined minimum deviation x/z range
	local _waypoint = {}
	_waypoint.dist = math.sqrt((_spawnairbaseloc.x - _landairbaseloc.x) * (_spawnairbaseloc.x - _landairbaseloc.x) + (_spawnairbaseloc.z - _landairbaseloc.z) * (_spawnairbaseloc.z - _landairbaseloc.z))
	if (((_waypoint.dist / 2) < waypointRange[1]) or (spawnIndex.id == landIndex.id)) then
		_waypoint.distx = waypointRange[1]
	else
		_waypoint.distx = _waypoint.dist / 2
	end
	if (((_waypoint.dist / 2) < waypointRange[2]) or (spawnIndex.id == landIndex.id)) then
		_waypoint.distz = waypointRange[2]
	else
		_waypoint.distz = _waypoint.dist / 2
	end
	_waypoint.x = _spawnairbaseloc.x + math.random(- _waypoint.distx, _waypoint.distx)
	_waypoint.z = _spawnairbaseloc.z + math.random(- _waypoint.distz, _waypoint.distz)

	_groupname = nameP .. numCoalitionGroup[coalitionIndex]

	--
	local _formationName = ''
	--

	if ((_singleInFlight == false) and (maxGroupSize > 1)) then
		local _params = {}
		local _r
		if (_category == "AIRPLANE") then
			if (flgRandomFormation) then
				_r = math.random(1, #airplaneFormation)
			else
				_r = defaultAirplaneFormation
			end
			_params =
				{
					["variantIndex"] = airplaneFormation[_r][2],
					["name"] = airplaneFormation[_r][3],
					["formationIndex"] = airplaneFormation[_r][4],
					["value"] = airplaneFormation[_r][5]
				}
			--
			_formationName = airplaneFormation[_r][1]
			--
		else
			if (flgRandomFormation) then
				_r = math.random(1, #helicopterFormation)
			else
				_r = defaultHelicopterFormation
			end
			_params =
				{
					["variantIndex"] = helicopterFormation[_r][2],
					["zInverse"] = helicopterFormation[_r][3],
					["name"] = helicopterFormation[_r][4],
					["formationIndex"] = helicopterFormation[_r][5],
					["value"] = helicopterFormation[_r][6]
				}
			--
			_formationName = helicopterFormation[_r][1]
			--
		end

		_tasks[#_tasks+1] =
		{
			["number"] = #_tasks+1,
			["auto"] = false,
			["id"] = "WrappedAction",
			["enabled"] = true,
			["params"] =
			{
				["action"] =
				{
					["id"] = "Option",
					["params"] = _params,
				},
			},
		}
	end

	_airplanedata =
	{
        ["modulation"] = 0,
		["tasks"] =
			{
			},
		["task"] = _task,
		["uncontrolled"] = false,
        ["heading"] = _spawnHeading,
		["route"] =
		{
			["points"] =
			{
				[1] =
				{
					["alt"] = 0,
					["type"] = _waypointtype,
					["action"] = _waypointaction,
					["parking"] = _spawnairplaneparking,
					["alt_type"] = "RADIO",
					["formation_template"] = "",
					["ETA"] = 0,
					["airdromeId"] = _spawnairdromeId,
					["y"] = _spawnairplanepos.z,
					["x"] = _spawnairplanepos.x,
					["speed"] = _spawnSpeed,
					["ETA_locked"] = true,
					["task"] =
					{
						["id"] = "ComboTask",
						["params"] =
						{
							["tasks"] = _tasks,
						},
					},
					["speed_locked"] = true,
				},
			},
		},
		["groupId"] = numCoalitionGroup[coalitionIndex],
		["hidden"] = false,
		["units"] =
		{
			[1] =
			{
				["alt"] = 0,
				["heading"] = 0,
				["livery_id"] = _skin,
				["type"] = _aircrafttype,
				["psi"] = 0,
				["onboard_num"] = "10",
				["parking"] = _spawnairplaneparking,
				["y"] = _spawnairplanepos.z,
				["x"] = _spawnairplanepos.x,
                ["heading"] = _spawnHeading,
				["name"] =  _groupname .. "-1",
				["callsign"] = _callname,
				["payload"] = _payload,
				["speed"] = _spawnSpeed,
				["unitId"] =  math.random(9999,99999),
				["alt_type"] = "RADIO",
				["skill"] = _skill,
			},
		},
		["y"] = _spawnairplanepos.z,
		["x"] = _spawnairplanepos.x,
		["name"] = _groupname,
		["communication"] = true,
		["start_time"] = 0,
		["frequency"] = 124,
	}

	_unitNames = {_groupname .. "-1"}
	_unitCheckTime = {0}
	_formationSize = 1

	if ((_singleInFlight == false) and (maxGroupSize > 1)) then
		_formationSize = math.random(minGroupSize, maxGroupSize)
--env.info('formation size: ' .. _formationSize, false)
		for i=2, _formationSize do
--env.info('start formation loop: ' .. i, false)
			_airplanedata.units[i] =
			{
				["alt"] = 0,
				["heading"] = 0,
				["livery_id"] = _skin,
				["type"] = _aircrafttype,
				["psi"] = 0,
				["onboard_num"] = "10",
				["y"] = _spawnairplanepos.z,
				["x"] = _spawnairplanepos.x,
				["name"] =  _groupname .. "-" .. i,
				["callsign"] = _callname,
				["payload"] = _payload,
				["speed"] = _spawnSpeed,
				["unitId"] =  math.random(9999,99999),
				["alt_type"] = "RADIO",
				["skill"] = _skill,
			}

			_unitNames[#_unitNames+1] = _groupname .. "-" .. i
			_unitCheckTime[#_unitCheckTime+1] = 0

			-- Build callsign for this unit based on group callsign
			if ((_country == country.id.RUSSIA) or (_country == country.id.ABKHAZIA) or (_country == country.id.SOUTH_OSETIA) or (_country == country.id.UKRAINE)) then
				_airplanedata.units[i].callsign = numCoalitionGroup[coalitionIndex] .. i
			else
				_airplanedata.units[i].callsign =
					{
						[1] = _airplanedata.units[1].callsign[1],
						[2] = _airplanedata.units[1].callsign[2],
						[3] = i,
						["name"] = nameCallname[_airplanedata.units[1].callsign[1]] .. _airplanedata.units[1].callsign[2] .. i,
					}
			end

			-- Randomize unit skill if flag is set
			if (flgRandomSkill) then
				_airplanedata.units[i].skill = unitSkill[math.random(1,#unitSkill)]
			else
				_airplanedata.units[i].skill = unitSkill[unitSkillDefault]
			end

			numCoalitionAircraft[coalitionIndex] = numCoalitionAircraft[coalitionIndex] + 1		-- Add one aircraft to total aircraft in use
		end
	end

	if (flagRandomWaypoint) then
		_airplanedata.route.points[2] =
		{
			["alt"] = _flightalt,
			["type"] = "Turning Point",
			["action"] = "Turning Point",
			["alt_type"] = "BARO",
			["formation_template"] = "",
			["properties"] =
			{
				["vnav"] = 1,
				["scale"] = 0,
				["angle"] = 0,
				["vangle"] = 0,
				["steer"] = 2,
			},
--					["ETA"] = 51.632064419993,
			["y"] = _waypoint.z,
			["x"] = _waypoint.x,
			["speed"] = _flightspeed,
			["ETA_locked"] = false,
			["task"] =
			{
				["id"] = "ComboTask",
				["params"] =
				{
					["tasks"] = _tasks,
				},
			},
			["speed_locked"] = true,
		}
		_airplanedata.route.points[3] =
		{
			["alt"] = _flightalt / 2,
			["type"] = "Land",
			["action"] = "Landing",
			["alt_type"] = "BARO",
			["formation_template"] = "",
			["properties"] =
			{
				["vnav"] = 1,
				["scale"] = 0,
				["angle"] = 0,
				["vangle"] = 0,
				["steer"] = 2,
			},
--					["ETA"] = 0,
			["airdromeId"] = _landairbaseID,
			["y"] = _landairbaseloc.z,
			["x"] = _landairbaseloc.x,
			["speed"] = _flightspeed,
			["ETA_locked"] = false,
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
			["speed_locked"] = true,
		}
	else
		_airplanedata.route.points[2] =
		{
			["alt"] = _flightalt / 2,
			["type"] = "Land",
			["action"] = "Landing",
			["alt_type"] = "BARO",
			["formation_template"] = "",
			["properties"] =
			{
				["vnav"] = 1,
				["scale"] = 0,
				["angle"] = 0,
				["vangle"] = 0,
				["steer"] = 2,
			},
--					["ETA"] = 0,
			["airdromeId"] = _landairbaseID,
			["y"] = _landairbaseloc.z,
			["x"] = _landairbaseloc.x,
			["speed"] = _flightspeed,
			["ETA_locked"] = false,
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
			["speed_locked"] = true,
		}
	end

	if (_category == "HELICOPTER") then
		coalition.addGroup(_country, Group.Category.HELICOPTER, _airplanedata)
	else
		coalition.addGroup(_country, Group.Category.AIRPLANE, _airplanedata)
	end

	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  callsign:' .. _groupname .. '  #red:' .. numCoalitionAircraft[1] .. '  #blue:' .. numCoalitionAircraft[2] .. '  fullname:' .. _fullname, false) end
	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  spawn:' .. spawnIndex.name .. '  land:' .. landIndex.name .. '  altitude:' .. _flightalt .. '  speed:' .. _flightspeed, false) end
--	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  heading_degree:' .. Pos3.p.y .. '  heading_pi:' .. _spawnHeading, false) end
--	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  spawnpos.x:' .. _spawnairplanepos.x .. '  waypoint.x:' .. _waypoint.x .. '  landpos.x' .. _landairplanepos.x .. '  spawnpos.z:' .. _spawnairplanepos.z .. '  waypoint.z:' .. _waypoint.z .. '  landpos.z:' .. _landairplanepos.z, false) end
--	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  delta.x:' .. _spawnairplanepos.x - _waypoint.x .. '  delta.z:' .. _spawnairplanepos.z - _waypoint.z, false) end
	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  formation:' .. _formationName, false) end
	if (debugScreen) then trigger.action.outText(' group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  callsign:' .. _groupname .. '  #red:' .. numCoalitionAircraft[1] .. '  #blue:' .. numCoalitionAircraft[2] .. '  _fullname:' .. _fullname .. '  spawn:' .. spawnIndex.name .. '  land:' .. landIndex.name .. '  altitude:' .. _flightalt .. '  speed:' .. _flightspeed, 10) end

	RATtable[#RATtable+1] =
	{
		groupname = _groupname,
		flightname = _fullname,
		actype = _aircrafttype,
		origin = spawnIndex.name,
		destination = landIndex.name,
		counter = groupcounter,
		coalition = coalitionIndex,
		unitNames = _unitNames,
		unitCheckTime = _unitCheckTime,
		groupCheckTime = 0,
		formationSize = _formationSize,	-- Store the original number of aircraft in this group
	}

end

function removeGroup (indeX, messagE, destroyflaG, aircraftgrouP)
	if (debugLog) then env.info('group:' .. RATtable[indeX].groupname .. '  type:' .. RATtable[indeX].actype .. messagE, false) end
	if (debugScreen) then trigger.action.outText('group:' .. RATtable[indeX].groupname .. '  type:' .. RATtable[indeX].actype .. messagE, 20) end

	if ((numCoalitionAircraft[RATtable[indeX].coalition] > 0) and (#RATtable[indeX].unitNames > 0)) then		-- If possible, increase the available aircraft for this coalition by the number of units remaining in the group
		if ((numCoalitionAircraft[RATtable[indeX].coalition] - #RATtable[indeX].unitNames) > 0) then
				numCoalitionAircraft[RATtable[indeX].coalition] = numCoalitionAircraft[RATtable[indeX].coalition] - #RATtable[indeX].unitNames
		else
				numCoalitionAircraft[RATtable[indeX].coalition] = 0
		end
	end

	table.remove(RATtable, indeX)	-- Group does not exist any longer for this script

	if (destroyflaG) then aircraftgrouP:destroy() end
end

function removeUnit (indexI, indexJ, removeMessage, destroyFlag, aircraftUnit)
	if (debugLog) then env.info('unit:' .. RATtable[indexI].unitNames[indexJ] .. '  type:' .. RATtable[indexI].actype .. removeMessage, false) end
	if (debugScreen) then trigger.action.outText('unit:' .. RATtable[indexI].unitNames[indexJ] .. '  type:' .. RATtable[indexI].actype .. removeMessage, 20) end

	table.remove(RATtable[indexI].unitNames, indexJ)		-- Unit does not exist any longer for this script
	table.remove(RATtable[indexI].unitCheckTime, indexJ)	-- Unit does not exist any longer for this script

	if (numCoalitionAircraft[RATtable[indexI].coalition] > 0) then		-- If possible, increase the number of available aircraft for this coalition by one
		numCoalitionAircraft[RATtable[indexI].coalition] = numCoalitionAircraft[RATtable[indexI].coalition] - 1
	end

	if (destroyFlag) then aircraftUnit:destroy() end

	if (#RATtable[indexI].unitNames == 0) then	-- There are no more units in this group, the group needs to be removed
		return true
	else
		return false
	end
end

-- Periodically check all dynamically spawned AI units for existence, movement, wandering, below ground, damage, and stuck/parked
function checkStatus()
	if (#RATtable > 0)
	then
		local RATtableLimit = #RATtable	 -- Array size may change while loop is running due to removing group
		local i = 1
		while ((i <= RATtableLimit) and (RATtableLimit > 0))
		do
			local currentaircraftgroup = Group.getByName(RATtable[i].groupname)
			if (currentaircraftgroup) == nil then		-- This group does not exist yet (just now spawning) OR removed by sim (crash or kill)
				if (RATtable[i].groupCheckTime > 0) then		-- Have we checked this group yet? (should have spawned by now)
					removeGroup(i, "  removed by sim, not script", false, nil)
					RATtableLimit = RATtableLimit - 1	-- Array shrinks
				else
					RATtable[i].groupCheckTime = RATtable[i].groupCheckTime + 1
					i = i + 1
				end
			else -- Valid group, make unit checks
--env.info('group: ' .. RATtable[i].groupname .. ' #unitnames: ' .. #RATtable[i].unitNames, false)
--env.info('random 1-4: ' .. math.random(1,4), false)
				local unitNamesLimit = #RATtable[i].unitNames
				local j = 1
				while ((j <= unitNamesLimit) and (unitNamesLimit > 0))
				do
					local currentunitname = RATtable[i].unitNames[j]
					if (Unit.getByName(currentunitname) ~= nil) then -- Valid, active unit
						local actualunit = Unit.getByName(currentunitname)
						local actualunitvel = actualunit:getVelocity()
						local absactualunitvel = math.abs(actualunitvel.x) + math.abs(actualunitvel.y) + math.abs(actualunitvel.z)

					-- Check for unit movement
						if absactualunitvel > 4 then
							RATtable[i].unitCheckTime[j] = 0 -- If it's moving, reset checktime
						else
							RATtable[i].unitCheckTime[j] = RATtable[i].unitCheckTime[j] + 1
						end

						local actualunitpos = actualunit:getPosition().p
						local actualunitheight = actualunitpos.y - land.getHeight({x = actualunitpos.x, y = actualunitpos.z})
						local lowerstatuslimit = minDamagedLife * actualunit:getLife0() -- Was 0.95. changed to 0.10
					-- Check for wandering
						if ((actualunitpos.x > 100000) or (actualunitpos.x < -500000) or (actualunitpos.z > 1100000) or (actualunitpos.z < 200000)) then
							if removeUnit(i, j, '  removed due to wandering', true, actualunit) then -- If true, then there are no more units in this group
								removeGroup(i, '  removed, no more units', true, currentaircraftgroup)
								RATtableLimit = RATtableLimit - 1
								i = i - 1 -- Subtract one now, but later in loop add one, so next run we use the same i (because current i row has been removed)
								j = unitNamesLimit	-- No need to iterate through anymore units in this group
							else
							j = j - 1	-- -1 then +1, stay on current j because table has shrunk
							unitNamesLimit = unitNamesLimit - 1 -- total unit table size has shrunk
							end
					-- Check for below ground level
						elseif (actualunitheight < 0) then
							if removeUnit(i, j, '  removed due to being below ground level', true, actualunit) then -- If true, then there are no more units in this group
								removeGroup(i, '  removed, no more units', true, currentaircraftgroup)
								RATtableLimit = RATtableLimit - 1
								i = i - 1 -- Subtract one now, but later in loop add one, so next run we use the same i (because current i row has been removed)
								j = unitNamesLimit	-- No need to iterate through anymore units in this group
							else
								j = j - 1	-- -1 then +1, stay on current j because table has shrunk
								unitNamesLimit = unitNamesLimit - 1 -- total unit table size has shrunk
							end
					-- check for damaged unit
						elseif ((actualunitheight < minDamagedHeight) and (actualunit:getLife() <= lowerstatuslimit)) then
							if removeUnit(i, j, '  removed due to damage', true, actualunit) then -- If true, then there are no more units in this group
								removeGroup(i, '  removed, no more units', true, currentaircraftgroup)
								RATtableLimit = RATtableLimit - 1
								i = i - 1 -- Subtract one now, but later in loop add one, so next run we use the same i (because current i row has been removed)
								j = unitNamesLimit	-- No need to iterate through anymore units in this group
							else
								j = j - 1	-- -1 then +1, stay on current j because table has shrunk
								unitNamesLimit = unitNamesLimit - 1 -- total unit table size has shrunk
							end
					-- Check for stuck
						elseif (RATtable[i].unitCheckTime[j] > waitTime) then
							if removeUnit(i, j, '  removed due to low speed', true, actualunit) then -- If true, then there are no more units in this group
								removeGroup(i, '  removed, no more units', true, currentaircraftgroup)
							end
							-- Lets exit the function for this cycle because an aircraft was removed.
							--  Possible for another blocked aircraft to now move.
							--  (instead that aircraft would be deleted during next run of the current loop)
							RATtableLimit = 0
							unitNamesLimit = 0
						end
					else
					-- Unit removed by sim
						if removeUnit(i, j, '  removed by sim, not script', false, actualunit) then -- If true, then there are no more units in this group
							removeGroup(i, '  removed, no more units', true, currentaircraftgroup)
							RATtableLimit = RATtableLimit - 1
							i = i - 1 -- Subtract one now, but later in loop add one, so next run we use the same i (because current i row has been removed)
							j = unitNamesLimit	-- No need to iterate through anymore units in this group
						else
							j = j - 1	-- -1 then +1, stay on current j because table has shrunk
							unitNamesLimit = unitNamesLimit - 1 -- total unit table size has shrunk
						end
					end
					j = j + 1
				end
				i = i + 1
			end
		end
	end
end

-- Determine the bases based on a coalition parameter
function getAFBases (coalitionIndex)
	local AFids = {}
	local AF = {}
	AFids = coalition.getAirbases(coalitionIndex)
	for i = 1, #AFids do
		AF[i] =
		{
			name = AFids[i]:getName(),
			id_ = AFids[i].id_,
			id = AFids[i]:getID()
		}
	end
return AF
end

-- Choose a random airbase
function chooseAirbase(AF)
	airbaseChoice = math.random(1, #AF)
return AF[airbaseChoice]
end

-- Check if possible to spawn a new group for the coalition
function checkMax(cs)
	if ((numCoalitionAircraft[cs] < maxCoalitionAircraft[cs]) and ((maxCoalitionAircraft[cs] - numCoalitionAircraft[cs]) >= maxGroupSize))then  -- Is ok to spawn a new unit?
		numCoalitionAircraft[cs] = numCoalitionAircraft[cs] + 1
		numCoalitionGroup[cs] = numCoalitionGroup[cs] + 1
		return true
	else
		return false
	end
end

-- Determine spawn and land airbases
function makeAirBase(cs)
	local ab = {}
	ab[1] = chooseAirbase(AB[cs])
	ab[2] = chooseAirbase(AB[cs])
	if ((flgNoSpawnLandingAirbase) and (#AB[cs] > 1)) then -- If flag is set and more than 1 airbase, don't let spawn and land airbase be the same
		while (ab[1] == ab[2]) do
			ab[2] = chooseAirbase(AB[cs])
		end
	end
return ab
end

-- Main scheduled function to create new coalition groups as needed
function generateGroup()
	local lowVal						-- lowest available coalition side
	local highVal						-- highest available coalition side
	local airbase = {}					-- table of spawn and landing airbases
	local flgSpawn = {false, false}		-- flags to determine which coalitions get new groups

	-- Names of red bases
	AB[1] = getAFBases(1)
	if (#AB[1] < 1) then
		env.warning("There are no red bases in this mission.", false)
	end

	-- Names of blue bases
	AB[2] = getAFBases(2)
	if (#AB[2] < 1) then
		env.warning("There are no blue bases in this mission.", false)
	end

	-- Choose which coalition side to possibly spawn new aircraft
	if (#AB[1] > 0) then
		lowVal = 1
	else
		lowVal = 2
	end

	if (#AB[2] > 0) then
		highVal = 2
	else
		highVal = 1
	end

	if (lowVal > highVal) then  -- No coalition bases defined at all!
		env.warning("There are no coalition bases defined!!! exiting dynamic spawn function.", false)
		return
	end

	if (randomCoalitionSpawn == 1) then	-- Spawn random coalition
		flgSpawn[math.random(lowVal, highVal)] = true
	else
		if ((randomCoalitionSpawn == 3) and (not (numCoalitionAircraft[1] == numCoalitionAircraft[2])) and (maxCoalitionAircraft[1] == maxCoalitionAircraft[2])) then -- Unfair situation
			if (numCoalitionAircraft[1] < numCoalitionAircraft[2]) then	-- spawn Red group
				flgSpawn = {true, false}
			else
				flgSpawn = {false, true}
			end
		else
			flgSpawn = {true, true}
		end
	end

	-- If needed, spawn new group for each coalition
	for i = 1, 2 do
		if (flgSpawn[i] == true) then
			if checkMax(i) then
				airbase = makeAirBase(i)
--env.info('Spawn loop, spawning for: ' .. airbase[1].name, false)
				generateAirplane(i, airbase[1], airbase[2], NamePrefix[i])
			end
		end
	end

	spawnInterval = math.random(spawnIntervalLow, spawnIntervalHigh) -- Choose new random spawn interval

return timer.getTime() + spawnInterval
end

--
-- MAIN PROGRAM
--
env.info("Dynamic AI group spawn script loaded.", false)
timer.scheduleFunction(generateGroup, nil, timer.getTime() + spawnInterval)
Checktimer = mist.scheduleFunction(checkStatus, {}, timer.getTime() + 4, checkInterval)
env.info("Dynamic AI group spawn script running.", false)

end
