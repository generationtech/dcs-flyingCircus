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
		"Turning Point", "Turning Point"		-- Favor in-air start
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
	[0] =											--RUSSIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {14, 1, 2},		-- A-50
				[2] = {1, 4, 5},		-- An-26B
				[3] = {2, 2},			-- An-30M
				[4] = {7, 3, 4, 5},		-- IL-76MD
				[5] = {15, 3, 4, 5},	-- IL-78M
				[6] = {9, 1},			-- MiG-25RBT
				[7] = {11, 1},			-- Su-24MR
				[8] = {12, 1},			-- TF-51D
				[9] = {13, 3},			-- Yak-40
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {21, 1},			-- Su-24M
				[2] = {26, 1},			-- Tu-142
				[3] = {27, 1},			-- Tu-160
				[4] = {24, 1},			-- Tu-22M3
				[5] = {25, 1},			-- Tu-95MS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 36, 37},		-- A-10C
				[2] = {30, 2},			-- Hawk
				[3] = {31, 3, 4, 5},	-- L-39ZA
				[4] = {32, 1},			-- MiG-27K
				[5] = {33, 1, 2},		-- Su-17M4
				[6] = {34, 2, 7, 8, 9},	-- Su-25
				[7] = {35, 1, 2, 3},	-- Su-25T
				[8] = {36, 1},			-- Su-25TM
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[1] = 											--UKRAINE
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {1, 2},			-- An-26B
				[2] = {2, 1},			-- An-30M
				[3] = {7, 1, 2},		-- IL-76MD
				[4] = {9, 1},			-- MiG-25RBT
				[5] = {11, 1},			-- Su-24MR
				[6] = {13, 2},			-- Yak-40
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {21, 1},			-- Su-24M
				[2] = {24, 1},			-- Tu-22M3
				[3] = {25, 1},			-- Tu-95MS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 35},			-- A-10C
				[2] = {30, 2},			-- Hawk
				[3] = {31, 2},			-- L-39ZA
				[4] = {32, 1},			-- MiG-27K
				[5] = {33, 1, 2, 3},	-- Su-17M4
				[6] = {34, 3, 4, 5, 6},	-- Su-25
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {48, 1},					-- MiG-15bis
				[3] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[2] = 											--USA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 1},			-- C-130
				[2] = {4, 1},			-- C-17A
				[3] = {5, 1, 2},		-- E-2C
				[4] = {6, 1, 2},		-- E-3A
				[5] = {8, 1},			-- KC-135
				[6] = {10, 1},			-- S-3B Tanker
				[7] = {12, 2, 3, 4, 5},	-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {16, 1},			-- B-1B
				[2] = {17, 1},			-- B-52H
				[3] = {18, 1},			-- F-117A
				[4] = {19, 1, 2},		-- F-15E
				[5] = {20, 1},			-- S-3B
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {28, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18},	-- A-10A
				[2] = {29, 2, 3, 4, 5,6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19},	-- A-10C
				[3] = {30, 2, 3, 4, 5, 6, 7},	-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1]  = {38, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10},	-- F-14A
				[2]  = {39, 1, 2, 3, 4, 5, 6, 7, 8},		-- F-15C
				[3]  = {40, 1},								-- F-16A
				[4]  = {41, 1, 2, 3, 4, 5, 6, 7, 8},		-- F-16C bl.52d
				[5]  = {44, 1, 2, 3, 4, 5, 6, 7, 8, 9},		-- F-5E
				[6]  = {45, 1},								-- F-86F Sabre
				[7]  = {46, 2, 3, 4, 5},					-- F/A-18C
				[8]  = {47, 1},								-- FW-190D9
				[9]  = {48, 1},								-- MiG-15bis
				[10] = {49, 1, 2, 3, 4, 5, 6},				-- MiG-21Bis
				[0] = {0, 0},								--
				[0] = {0, 0},								--
				[0] = {0, 0},								--
				[0] = {0, 0},								--
				[0] = {0, 0},								--
				[0] = {0, 0},								--
				[0] = {0, 0},								--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[3] = 											--TURKEY
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 11},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},			-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[4] = 											--UK
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 10},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {22, 1, 2, 3, 4, 5, 6},	-- Tornado GR4
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},			-- A-10C
				[2] = {30, 2, 9, 10, 11, 12, 13, 14, 15, 16, 17},	-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {47, 8},					-- FW-190D9
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[5] = 											--FRANCE
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 5},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 24},			-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {48, 1},					-- MiG-15bis
				[3] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[6] = 											--GERMANY
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {23, 1, 2, 3, 4, 5},	-- Tornado IDS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 27, 28},		-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {37, 1, 2, 3, 4, 5, 6, 7},	-- Bf-109K-4
				[2] = {43, 2},						-- F-4E
				[3] = {45, 1},						-- F-86F Sabre
				[4] = {47, 2, 3, 4, 5, 6, 7},		-- FW-190D9
				[5] = {48, 1},						-- MiG-15bis
				[6] = {49, 1, 2, 3, 4, 5, 6},		-- MiG-21Bis
				[0] = {0, 0},						--
				[0] = {0, 0},						--
				[0] = {0, 0},						--
				[0] = {0, 0},						--
				[0] = {0, 0},						--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[8] = 											--CANADA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 3},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 21, 22, 23},	-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {46, 1},					-- F/A-18C
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[9] = 											--SPAIN
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 8},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 32, 33, 34},	-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {46, 1},					-- F/A-18C
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[10] = 											--THE_NETHERLANDS
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 9},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},			-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 5, 6},				-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[11] = 											--BELGIUM
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 2},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},			-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 1},					-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[12] = 											--NORWAY
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 7},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 31},			-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 3, 4},				-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[13] = 											--DENMARK
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 4},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 1},			-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 2},					-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[15] = 											--ISRAEL
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {3, 6},			-- C-130
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {19, 3},			-- F-15E
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 29},			-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {39, 9},					-- F-15C
				[2] = {41, 9},					-- F-16C bl.52d
				[3] = {43, 1},					-- F-4E
				[4] = {45, 1},					-- F-86F Sabre
				[5] = {48, 1},					-- MiG-15bis
				[6] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[16] = 											--GEORGIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {1, 1},			-- An-26B
				[2] = {13, 1},			-- Yak-40
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 25, 26},		-- A-10C
				[2] = {30, 2},			-- Hawk
				[3] = {31, 1},			-- L-39ZA
				[4] = {34, 1, 2},		-- Su-25
				[5] = {35, 1, 2},		-- Su-25T
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {48, 1},					-- MiG-15bis
				[3] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[17] = 											--INSURGENTS			-- HANDLE INSURGENTS NO AIRCRAFT CONDITION --
		{ -- No aircraft
		},
	[18] = 											--ABKHAZIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins
				[1] = {1, 5},			-- An-26B
				[2] = {12, 1},			-- TF-51D
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {30, 2},			-- Hawk
				[2] = {31, 6},			-- L-39ZA
				[3] = {34, 10},			-- Su-25
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[19] = 											--SOUTH_OSETIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
				[0] = {0, 0},			--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[20] = 											--ITALY
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[2] = -- Bomber
			{	-- Aircraft, skins
				[1] = {23, 1, 2, 3, 4},	-- Tornado IDS
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 30},			-- A-10C
				[2] = {30, 2},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {42, 2},					-- F-16A MLU
				[2] = {45, 1},					-- F-86F Sabre
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
			},
		},
	[21] = 											--AUSTRALIA
		{ -- Aircraft types
		[1] = -- Utility
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[2] = -- Bomber
			{	-- Aircraft, skins			-- HANDLE THIS NO AC-TYPE CONDITION --
			},
		[3] = -- Attack
			{	-- Aircraft, skins
				[1] = {29, 20},			-- A-10C
				[2] = {30, 1},			-- Hawk
			},
		[4] = -- Fighter
			{	-- Aircraft, skins
				[1] = {45, 1},					-- F-86F Sabre
				[2] = {46, 6},					-- F/A-18C
				[3] = {48, 1},					-- MiG-15bis
				[4] = {49, 1, 2, 3, 4, 5, 6},	-- MiG-21Bis
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
				[0] = {0, 0},					--
			},
		[5] = -- Helicopter
			{	-- Aircraft, skins
				[0] = {0, 0},			--
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

			_task = "CAS"
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
			}

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

			_task = "CAS"
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
			}

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

			_task = "CAP"
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
			}

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

			_task = "CAS"
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
			}

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

			_task = "CAS"
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
			}

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

			_task = "CAS"
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
			}

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

			_task = "CAS"
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
			}

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

			_task = "CAS"
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
			}

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

			_task = "CAS"
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
			}

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

			_task = "CAP"
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
			}

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

			_task = "CAP"
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
			}

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

			_task = "CAP"
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
			}

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

			_task = "CAP"
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
			}

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

			_task = "CAP"
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
			}

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
				"aggressor `new ghost ` scheme1",
				"aggressor `new ghost ` scheme2",
				"aggressor `old blue ` scheme",
				"aggressor `sand` scheme",
				"aggressor `snake` scheme"
			},
		},
	[45] =								-- F-86F Sabre
		{
			_aircrafttype = "F-86F Sabre",

			_task = "CAP"
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
			}

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

			_task = "CAP"
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
			}

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

			_task = "CAP"
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
			}

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
				"FW-190D9_JG54",
				"FW-190D9_5JG301",
				"FW-190D9_Red",
				"FW-190D9_GB",
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

			_task = "CAP"
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
			}

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
	[50] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[51] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[52] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[53] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[54] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[55] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[56] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[57] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[58] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[59] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	[60] =
		{
			_aircrafttype = "An-26B",

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
			},
		},
	}


-- Create a new aircraft based on coalition, airbase, and name prefix
function generateAirplane(coalitionIndex, spawnIndex, landIndex, nameP)
	nameCallname = {"Enfield", "Springfield", "Uzi", "Colt", "Dodge", "Ford", "Chevy", "Pontiac"}
	_singleInFlight = false	-- Default to allowing multi-aircraft formations
	_category = "AIRPLANE" -- Default to airplane type
	AircraftType = math.random(1,100) --random for utility airplane, bomber, attack, fighter, or helicopter


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
