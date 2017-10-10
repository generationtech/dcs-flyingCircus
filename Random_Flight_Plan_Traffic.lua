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
		[1] =
			{	-- Aircraft types
				[1] = -- Utility
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
				[2] = -- Bomber
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
				[3] = -- Attack
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
				[4] = -- Fighter
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
				[5] = -- Helocopter
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
			},
		[2] =
			{	-- Aircraft types
				[1] = -- Utility
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
				[2] = -- Bomber
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
				[3] = -- Attack
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
				[4] = -- Fighter
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
				[5] = -- Helocopter
					{	-- Aircraft, skins
						[1] = {1, 2, 3, 4},
						[2] = {1, 2, 3, 4},
					},
			},
	}


-- Create a new aircraft based on coalition, airbase, and name prefix
function generateAirplane(coalitionIndex, spawnIndex, landIndex, nameP)
	nameCallname = {"Enfield", "Springfield", "Uzi", "Colt", "Dodge", "Ford", "Chevy", "Pontiac"}
	_singleInFlight = false	-- Default to allowing multi-aircraft formations
	_category = "AIRPLANE" -- Default to airplane type
	AircraftType = math.random(1,100) --random for utility airplane, bomber, attack, fighter, or helicopter

	if ((AircraftType >= 1) and (AircraftType <= aircraftDistribution[1])) then  -- UTILITY AIRCRAFT

		if (randomAirplane == 1) then
		elseif (randomAirplane == 2) then
		elseif (randomAirplane == 3) then
		elseif (randomAirplane == 4) then
		elseif (randomAirplane == 5) then
		elseif (randomAirplane == 6) then
		elseif (randomAirplane == 7) then
		elseif (randomAirplane == 8) then
		elseif (randomAirplane == 9) then
		elseif (randomAirplane == 10) then
		elseif (randomAirplane == 11) then
		elseif (randomAirplane == 12) then
		elseif (randomAirplane == 13) then
		elseif (randomAirplane == 14) then
		elseif (randomAirplane == 15) then
		elseif (randomAirplane == 16) then
		elseif (randomAirplane == 17) then
		elseif (randomAirplane == 18) then
		elseif (randomAirplane == 19) then
		elseif (randomAirplane == 20) then
		elseif (randomAirplane == 21) then
		elseif (randomAirplane == 22) then
		elseif (randomAirplane == 23) then

	elseif ((AircraftType >= aircraftDistribution[1]) and (AircraftType <= aircraftDistribution[2])) then  -- BOMBERS

--		if (randomBomber == 1) then -- B-52 removed for now. Behaves badly on taxiway and takeoff
		if ((randomBomber == 1) or (randomBomber == 2)) then -- B-52 removed for now. Behaves badly on taxiway and takeoff
--		elseif (randomBomber == 2) then
		elseif (randomBomber == 3) then
		elseif (randomBomber == 4) then
		elseif (randomBomber == 5) then
		elseif (randomBomber == 6) then
		elseif (randomBomber == 7) then
		elseif (randomBomber == 8) then
		elseif (randomBomber == 9) then
		elseif (randomBomber == 10) then
		elseif (randomBomber == 11) then
		elseif (randomBomber == 12) then
		elseif (randomBomber == 13) then
		elseif (randomBomber == 14) then
		elseif (randomBomber == 15) then

	elseif ((AircraftType >= aircraftDistribution[2]) and (AircraftType <= aircraftDistribution[3])) then  -- ATTACK AIRCRAFT

		if (randomAttack == 1) then
		elseif (randomAttack == 2)	then
		elseif (randomAttack == 3)	then
		elseif (randomAttack == 4)	then
		elseif (randomAttack == 5)	then
		elseif (randomAttack == 6)	then
		elseif (randomAttack == 7)	then
		elseif (randomAttack == 8)	then
		elseif (randomAttack == 9)	then
		elseif (randomAttack == 10)	then
		elseif (randomAttack == 11)	then
		elseif (randomAttack == 12)	then
		elseif (randomAttack == 13)	then
		elseif (randomAttack == 14)	then
		elseif (randomAttack == 15)	then
		elseif (randomAttack == 16)	then

	elseif ((AircraftType >= aircraftDistribution[3]) and (AircraftType <= aircraftDistribution[4])) then  -- FIGHTERS

		if (randomFighter == 1) then
		elseif (randomFighter == 2) then
		elseif (randomFighter == 3) then
		elseif (randomFighter == 4) then
		elseif (randomFighter == 5) then
		elseif (randomFighter == 6) then
		elseif (randomFighter == 7) then
		elseif (randomFighter == 8) then
		elseif (randomFighter == 9) then
		elseif (randomFighter == 10) then
		elseif (randomFighter == 11) then
		elseif (randomFighter == 12) then
		elseif (randomFighter == 13) then
		elseif (randomFighter == 14) then
		elseif (randomFighter == 15) then
		elseif (randomFighter == 16) then
		elseif (randomFighter == 17) then
		elseif (randomFighter == 18) then
		elseif (randomFighter == 19) then
		elseif (randomFighter == 20) then
		elseif (randomFighter == 21) then
		elseif (randomFighter == 22) then
		elseif (randomFighter == 23) then
		elseif (randomFighter == 24) then
		elseif (randomFighter == 25) then
		elseif (randomFighter == 26) then
		elseif (randomFighter == 27) then
		elseif (randomFighter == 28) then
		elseif (randomFighter == 29) then
		elseif (randomFighter == 30) then
		elseif (randomFighter == 31) then
		elseif (randomFighter == 32) then
		elseif (randomFighter == 33) then
		elseif (randomFighter == 34) then
		elseif (randomFighter == 35) then
		elseif (randomFighter == 36) then
		elseif (randomFighter == 37) then

	elseif ((AircraftType >= aircraftDistribution[4]) or (AircraftType <= aircraftDistribution[5])) then -- HELICOPTERS

		if (randomHeli == 1) then
		elseif (randomHeli == 2) then
		elseif (randomHeli == 3) then
		elseif (randomHeli == 4) then
		elseif (randomHeli == 5) then
		elseif (randomHeli == 6) then
		elseif (randomHeli == 7) then
		elseif (randomHeli == 8) then
		elseif (randomHeli == 9) then
		elseif (randomHeli == 10) then
		elseif (randomHeli == 11) then
		elseif (randomHeli == 12) then
		elseif (randomHeli == 13) then
		elseif (randomHeli == 15) then
		elseif (randomHeli == 16) then
		elseif (randomHeli == 17) then
		elseif (randomHeli == 18) then
		elseif (randomHeli == 19) then
		elseif (randomHeli == 20) then
		elseif (randomHeli == 21) then
		elseif (randomHeli == 22) then
		elseif (randomHeli == 23) then
	end

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
