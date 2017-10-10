-- Randomly spawn a different kind of aircraft at different coalition airbase up to a limit of total spawned aircraft.
-- In the ME, just designate each coalition airbase assignment on the ME airbase object, not with target zones

do
--EDIT BELOW
--FLAGS
flgRandomCoalitionSpawn = true		-- Random sequence of Red/Blue coalition spawning?
flgRandomFuel = true				-- Random fuel loadout?		--check
flagRandomWeapons = true			-- Add weapons to aircraft?		--check
flagRandomWaypoint = true			-- Create intermediate waypoint?
flgAllowSpawnLandingAirbase = true	-- Allow spawning airbase and landing airbase to be the same?
flgSetTasks = true					-- Enable general tasks appropriate for each unit (CAP, CAS, REFUEL, etc)		--check
flgRandomSkins = true				-- Randomize the skins for each aircraft (otherwise just choose 1st defined skin)
flgRandomSkill = true				-- Randomize AI pilot skill level		--check
flgRandomAltitude = true			-- Randomize altitude (otherwise use standard altitude per aircraft type)		--check
flgRandomSpeed = true				-- Randomize altitude (otherwise use standard speed per aircraft type)		--check

--DEBUG
debugLog = true		-- write entries to the log		--check
debugScreen = true	-- write messages to screen		--check

--RANGES
intervall = math.random(30,30)					-- Random spawn repeat interval
aircraftDistribution = {30, 45, 70, 90, 100}	-- Distribution of aircraft type Utility, Bomber, Attack, Fighter, Helicopter (must be 1-100 range array)		--check
maxGroupSize = 4								-- Maximum number of groups for those units supporting formations
maxCoalition = {25, 25}							-- Maximum number of red, blue units		--check
NamePrefix = {"Red-", "Blue-"}					-- Prefix to use for naming groups		--check
numCoalition = {0, 0}							-- Number of active Red, Blue dynamic spawned units		--check
waypointRange = {10000, 10000}					-- Maximum x,y of where to place intermediate waypoint between takeoff and landing		--check
waitTime = 20									-- Amount to time to wait before considering aircraft to be parked or stuck		--check
minDamagedLife = 0.10							-- Minimum % amount of life for aircraft under minDamagedHeight		--check
minDamagedHeight = 20							-- Minimum height to start checking for minDamagedLife		--check
unitSkillDefault = 3							-- Default unit skill if not using randomize unitSkill[unitSkillDefault]

-- Should be no need to edit these below
RATtable = {}
nameCoalition = {0, 0} -- highest coalition name used
nameCallname = {}
unitSkill = {Average, Good, High, Excellent, Random}

--env.setErrorMessageBoxEnabled(false)

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

-- Create a new aircraft based on coalition, airbase, parking type, and name prefix
function generateAirplane(coalitionIndex, spawnIndex, landIndex, parkingT, nameP)
	nameCallname = {"Enfield", "Springfield", "Uzi", "Colt", "Dodge", "Ford", "Chevy", "Pontiac"}
	AircraftType = math.random(1,100) --random for utility airplane, bomber, attack, fighter, or helicopter

	if ((AircraftType >= 1) and (AircraftType <= aircraftDistribution[1])) then  -- UTILITY AIRCRAFT
		if (coalitionIndex == 1) then
			randomAirplane = math.random(14,23) -- random for airplane type; Red AC 14-23
		else
			randomAirplane = math.random(1,13) -- random for airplane type; Blue AC 1-13
		end

		_task = ""
		_tasks =
		{
		}

		if (randomAirplane == 1) then
			_aircrafttype = "An-26B"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GEORGIA
				_skin = "Georgian AF"
				_fullname = "GEORGIA An-26B - " .. _skin
			else
				_country = country.id.UKRAINE
				_skin = "Ukraine AF"
				_fullname = "UKRAINE An-26B - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5500",
				["flare"] = 384,
				["chaff"] = 384,
				["gun"] = 100,
			}
		elseif (randomAirplane == 2) then
			_aircrafttype = "An-30M"
			_country = country.id.UKRAINE
			_skin = "15th Transport AB"
			_fullname = "UKRAINE An-30M - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "8300",
				["flare"] = 192,
				["chaff"] = 192,
				["gun"] = 100,
			}
		elseif (randomAirplane == 3) then
			_aircrafttype = "C-130"

			subtype = math.random(1,10)
			if (subtype == 1) then
				_country = country.id.USA
				_skin = "US Air Force"
				_fullname = "USA C-130 - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.BELGIUM
				_skin = "Belgian Air Force"
				_fullname = "BELGIUM C-130 - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.CANADA
				_skin = "Canada's Air Force"
				_fullname = "CANADA C-130 - " .. _skin
			elseif (subtype == 4) then
				_country = country.id.DENMARK
				_skin = "Royal Danish Air Force"
				_fullname = "DENMARK C-130 - " .. _skin
			elseif (subtype == 5) then
				_country = country.id.FRANCE
				_skin = "French Air Force"
				_fullname = "FRANCE C-130 - " .. _skin
			elseif (subtype == 6) then
				_country = country.id.ISRAEL
				_skin = "Israel Defence Force"
				_fullname = "ISRAEL C-130 - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.NORWAY
				_skin = "Royal Norwegian Air Force"
				_fullname = "NORWAY C-130 - " .. _skin
			elseif (subtype == 8) then
				_country = country.id.SPAIN
				_skin = "Spanish Air Force"
				_fullname = "SPAIN C-130 - " .. _skin
			elseif (subtype == 9) then
				_country = country.id.THE_NETHERLANDS
				_skin = "Royal Netherlands Air Force"
				_fullname = "THE_NETHERLANDS C-130 - " .. _skin
			elseif (subtype == 10) then
				_country = country.id.UK
				_skin = "Royal Air Force"
				_fullname = "UK C-130 - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "20830",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			}
		elseif (randomAirplane == 4) then
			_aircrafttype = "C-17A"
			_country = country.id.USA
			_skin = "usaf standard"
			_fullname = "USA C-17A - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "132405",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			}
		elseif (randomAirplane == 5) then
			_aircrafttype = "E-2C"
			_country = country.id.USA

			nameCallname = {"Overlord", "Magic", "Wizard", "Focus", "Darkstar"}

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
			}

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "E-2D Demo"
			else
				_skin = "VAW-125 Tigertails"
			end

			_fullname = "USA E-2C - " .. _skin

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5624",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			}
		elseif (randomAirplane == 6) then
			_aircrafttype = "E-3A"
			_country = country.id.USA

			nameCallname = {"Overlord", "Magic", "Wizard", "Focus", "Darkstar"}

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
			}

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "nato"
			else
				_skin = "usaf standard"
			end

			_fullname = "USA E-3A - " .. _skin

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "65000",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			}
		elseif (randomAirplane == 7) then
			_aircrafttype = "IL-76MD"
			_country = country.id.UKRAINE

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "Ukrainian AF"
			else
				_skin = "Ukrainian AF aeroflot"
			end

			_fullname = "UKRAINE IL-76MD - " .. _skin

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "80000",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			}
		elseif (randomAirplane == 8) then
			_aircrafttype = "KC-135"
			_country = country.id.USA

			nameCallname = {"Texaco", "Arco", "Shell"}

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
			}

			_skin = "Standard USAF"
			_fullname = "USA KC-135 - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = 90700,
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			}
		elseif (randomAirplane == 9) then
			_aircrafttype = "MiG-25RBT"
			_country = country.id.UKRAINE

			_task = "Reconnaissance"
			_tasks =
			{
			}

			_skin = "af standard"
			_fullname = "UKRAINE MiG-25RBT - " .. _skin
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
			}
		elseif (randomAirplane == 10) then
			_aircrafttype = "S-3B Tanker"
			_country = country.id.USA

			nameCallname = {"Texaco", "Arco", "Shell"}

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
			}

			_skin = "usaf standard"
			_fullname = "USA S-3B Tanker - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5500",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			}
		elseif (randomAirplane == 11) then
			_aircrafttype = "Su-24MR"
			_country = country.id.UKRAINE

			_task = "Reconnaissance"
			_tasks =
			{
			}

			_skin = "af standard"
			_fullname = "UKRAINE Su-24MR - " .. _skin
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
			}
		elseif (randomAirplane == 12) then
			_aircrafttype = "TF-51D"
			_skin = ""

			subtype = math.random(1,1)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "TF -51 Glamorous Glen III"
				elseif (subtype1 == 2) then
					_skin = "TF-51 Gentleman Jim"
				elseif (subtype1 == 3) then
					_skin = "TF-51 Gunfighter"
				else
					_skin = "TF-51 Miss Velma"
				end

				_fullname = "USA TF-51D - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.BELGIUM
				_fullname = "BELGIUM TF-51D"
			elseif (subtype == 3) then
				_country = country.id.CANADA
				_fullname = "CANADA TF-51D"
			elseif (subtype == 4) then
				_country = country.id.DENMARK
				_fullname = "DENMARK TF-51D"
			elseif (subtype == 5) then
				_country = country.id.FRANCE
				_fullname = "FRANCE TF-51D"
			elseif (subtype == 6) then
				_country = country.id.ISRAEL
				_fullname = "ISRAEL TF-51D"
			elseif (subtype == 7) then
				_country = country.id.NORWAY
				_fullname = "NORWAY TF-51D"
			elseif (subtype == 8) then
				_country = country.id.SPAIN
				_fullname = "SPAIN TF-51D"
			elseif (subtype == 9) then
				_country = country.id.THE_NETHERLANDS
				_fullname = "THE_NETHERLANDS TF-51D"
			else
				_country = country.id.UK
				_fullname = "UK TF-51D"
			end

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "501",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomAirplane == 13) then
			_aircrafttype = "Yak-40"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GEORGIA
				_skin = "Georgian Airlines"
				_fullname = "GEORGIA Yak-40 - " .. _skin
			else
				_country = country.id.UKRAINE
				_skin = "Ukrainian"
				_fullname = "UKRAINE Yak-40 - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "3080",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomAirplane == 14) then
			_aircrafttype = "A-50"
			_country = country.id.RUSSIA

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "RF Air Force"
			else
				_skin = "RF Air Force new"
			end

			_fullname = "RUSSIA A-50 - " .. _skin

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "70000",
				["flare"] = 192,
				["chaff"] = 192,
				["gun"] = 100,
			}
		elseif (randomAirplane == 15) then
			_aircrafttype = "An-26B"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "RF Air Force"
				else
					_skin = "Aeroflot"
				end

				_fullname = "RUSSIA An-26B - " .. _skin

			else
				_country = country.id.ABKHAZIA
				_skin = "Abkhazian AF"
				_fullname = "ABKHAZIA An-26B - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "5500",
				["flare"] = 384,
				["chaff"] = 384,
				["gun"] = 100,
			}
		elseif (randomAirplane == 16) then
			_aircrafttype = "An-30M"
			_country = country.id.RUSSIA
			_skin = "RF Air Force"
			_fullname = "RUSSIA An-30M - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "8300",
				["flare"] = 192,
				["chaff"] = 192,
				["gun"] = 100,
			}
		elseif (randomAirplane == 17) then
			_aircrafttype = "C-130"
			_country = country.id.TURKEY
			_skin = "Turkish Air Force"
			_fullname = "TURKEY C-130 - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "20830",
				["flare"] = 60,
				["chaff"] = 120,
				["gun"] = 100,
			}
		elseif (randomAirplane == 18) then
			_aircrafttype = "IL-76MD"
			_country = country.id.RUSSIA

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "FSB aeroflot"
			elseif (subtype == 2) then
				_skin = "MVD aeroflot"
			else
				_skin = "RF Air Force"
			end

			_fullname = "RUSSIA IL-76MD - " .. _skin

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "80000",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			}
		elseif (randomAirplane == 19) then
			_aircrafttype = "IL-78M"
			_country = country.id.RUSSIA

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "RF Air Force"
			elseif (subtype == 2) then
				_skin = "RF Air Force aeroflot"
			else
				_skin = "RF Air Force new"
			end

			_fullname = "RUSSIA IL-78M - " .. _skin

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "90000",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			}
		elseif (randomAirplane == 20) then
			_aircrafttype = "MiG-25RBT"
			_country = country.id.RUSSIA

			_task = "Reconnaissance"
			_tasks =
			{
			}

			_skin = "af standard"
			_fullname = "RUSSIA MiG-25RBT - " .. _skin
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
			}
		elseif (randomAirplane == 21) then
			_aircrafttype = "Su-24MR"
			_country = country.id.RUSSIA

			_task = "Reconnaissance"
			_tasks =
			{
			}

			_skin = "af standard"
			_fullname = "RUSSIA Su-24MR - " .. _skin
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
			}
		elseif (randomAirplane == 22) then
			_aircrafttype = "TF-51D"
			_skin = ""

			subtype = math.random(1,3)
			if (subtype == 1) then
				_country = country.id.RUSSIA
				_fullname = "RUSSIA TF-51D"
			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_fullname = "ABKHAZIA TF-51D"
			else
				_country = country.id.TURKEY
				_fullname = "TURKEY TF-51D"
			end

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "501",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomAirplane == 23) then
			_aircrafttype = "Yak-40"
			_country = country.id.RUSSIA
			_skin = "Aeroflot"
			_fullname = "RUSSIA Yak-40 - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "3080",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		end

	elseif ((AircraftType >= aircraftDistribution[1]) and (AircraftType <= aircraftDistribution[2])) then  -- BOMBERS
		if (coalitionIndex == 1) then
			randomBomber = math.random(11,15) -- random for airplane type; Red AC 11-15
		else
			randomBomber = math.random(1,10) -- random for airplane type; Blue AC 1-10
		end

		_task = ""
		_tasks =
		{
		}

		if ((randomBomber == 1) or (randomBomber == 2)) then -- B-52 removed for now. Behaves badly on taxiway and takeoff
			_aircrafttype = "B-1B"
			_country = country.id.USA

			_task = "Ground Attack"
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
			}

			_skin = "usaf standard"
			_fullname = "USA B-1B - " .. _skin
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
			}
--		elseif (randomBomber == 2) then
--			_aircrafttype = "B-52H"
--			_country = country.id.USA
--			_task = "Ground Attack"
--			_tasks =
--			{
--				[1] =
--				{
--					["enabled"] = true,
--					["auto"] = true,
--					["id"] = "WrappedAction",
--					["number"] = 1,
--					["params"] =
--					{
--						["action"] =
--						{
--							["id"] = "EPLRS",
--							["params"] =
--							{
--								["value"] = true,
--								["groupId"] = 2,
--							},
--						},
--					},
--				},
--			}
--			_skin = "usaf standard"
--			_fullname = "USA B-52H - " .. _skin
--			_payload =
--			{
--				["pylons"] =
--				{
--					[1] =
--					{
--						["CLSID"] = "{4CD2BB0F-5493-44EF-A927-9760350F7BA1}",
--					},
--					[2] =
--					{
--						["CLSID"] = "{6C47D097-83FF-4FB2-9496-EAB36DDF0B05}",
--					},
--					[3] =
--					{
--						["CLSID"] = "{4CD2BB0F-5493-44EF-A927-9760350F7BA1}",
--					},
--				},
--				["fuel"] = "141135",
--				["flare"] = 192,
--				["chaff"] = 1125,
--				["gun"] = 100,
--			}
		elseif (randomBomber == 3) then
			_aircrafttype = "F-117A"
			_country = country.id.USA

			_task = "Pinpoint Strike"
			_tasks =
			{
			}

			_skin = "usaf standard"
			_fullname = "USA F-117A - " .. _skin
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
			}
		elseif (randomBomber == 4) then
			_aircrafttype = "F-15E"

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "335th Fighter SQN (SJ)"
				else
					_skin = "492d Fighter SQN (LN)"
				end

				_fullname = "USA F-15E - " .. _skin

			else
				_country = country.id.ISRAEL
				_skin = "IDF No 69 Hammers Squadron"
				_fullname = "ISRAEL F-15E - " .. _skin
			end

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
			}
		elseif (randomBomber == 5) then
			_aircrafttype = "S-3B"
			_country = country.id.USA

			_task = "Ground Attack"
			_tasks =
			{
			}

			_skin = "NAVY Standard"
			_fullname = "USA S-3B - " .. _skin
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
			}
		elseif (randomBomber == 6) then
			_aircrafttype = "Su-24M"
			_country = country.id.UKRAINE
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
			_skin = "af standard"
			_fullname = "UKRAINE Su-24M - " .. _skin
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
			}
		elseif (randomBomber == 7) then
			_aircrafttype = "Tornado GR4"
			_country = country.id.UK

			subtype = math.random(1,6)
			if (subtype == 1) then
				_skin = "bb of 14 squadron raf lossiemouth"
			elseif (subtype == 2) then
				_skin = "no. 9 squadron raf marham ab (norfolk)"
			elseif (subtype == 3) then
				_skin = "no. 12 squadron raf lossiemouth ab (morayshire)"
			elseif (subtype == 4) then
				_skin = "no. 14 squadron raf lossiemouth ab (morayshire)"
			elseif (subtype == 5) then
				_skin = "no. 617 squadron raf lossiemouth ab (morayshire)"
			else
				_skin = "o of ii (ac) squadron raf marham"
			end

			_fullname = "UK Tornado GR4 - " .. _skin

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
			}
		elseif (randomBomber == 8) then
			_aircrafttype = "Tornado IDS"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GERMANY

				subtype1 = math.random(1,5)
				if (subtype1 == 1) then
					_skin = "aufklarungsgeschwader 51 `immelmann` jagel ab luftwaffe"
				elseif (subtype1 == 2) then
					_skin = "jagdbombergeschwader 31 `boelcke` norvenich ab luftwaffe"
				elseif (subtype1 == 3) then
					_skin = "jagdbombergeschwader 32 lechfeld ab luftwaffe"
				elseif (subtype1 == 4) then
					_skin = "jagdbombergeschwader 33 buchel ab no. 43+19 experimental scheme"
				else
					_skin = "marinefliegergeschwader 2 eggebek ab marineflieger"
				end

				_fullname = "GERMANY Tornado IDS - " .. _skin

			else
				_country = country.id.ITALY

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "ITA Tornado (Sesto Stormo Diavoli Rossi)"
				elseif (subtype1 == 2) then
					_skin = "ITA Tornado Black"
				elseif (subtype1 == 3) then
					_skin = "ITA Tornado MM7042"
				else
					_skin = "ITA Tornado MM55004"
				end

				_fullname = "ITALY Tornado IDS - " .. _skin
			end

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
			}
		elseif (randomBomber == 9) then
			_aircrafttype = "Tu-22M3"
			_country = country.id.UKRAINE
			_task = "Ground Attack"
			_tasks =
			{
			}
			_skin = "af standard"
			_fullname = "UKRAINE Tu-22M3 - " .. _skin
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
			}
		elseif (randomBomber == 10) then
			_aircrafttype = "Tu-95MS"
			_country = country.id.UKRAINE
			_task = "Pinpoint Strike"
			_tasks =
			{
			}
			_skin = "af standard"
			_fullname = "UKRAINE Tu-95MS - " .. _skin
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
			}
		elseif (randomBomber == 11) then
			_aircrafttype = "Su-24M"
			_country = country.id.RUSSIA
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
			_skin = "af standard"
			_fullname = "RUSSIA Su-24M - " .. _skin
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
			}
		elseif (randomBomber == 12) then
			_aircrafttype = "Tu-142"
			_country = country.id.RUSSIA
			_task = "Antiship Strike"
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
			}
			_skin = "af standard"
			_fullname = "RUSSIA Tu-142 - " .. _skin
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
			}
		elseif (randomBomber == 13) then
			_aircrafttype = "Tu-160"
			_country = country.id.RUSSIA
			_task = "Pinpoint Strike"
			_tasks =
			{
			}
			_skin = "af standard"
			_fullname = "RUSSIA Tu-160 - " .. _skin
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
			}
		elseif (randomBomber == 14) then
			_aircrafttype = "Tu-22M3"
			_country = country.id.RUSSIA
			_task = "Ground Attack"
			_tasks =
			{
			}
			_skin = "af standard"
			_fullname = "RUSSIA Tu-22M3 - " .. _skin
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
			}
		elseif (randomBomber == 15) then
			_aircrafttype = "Tu-95MS"
			_country = country.id.RUSSIA
			_task = "Pinpoint Strike"
			_tasks =
			{
			}
			_skin = "af standard"
			_fullname = "RUSSIA Tu-95MS - " .. _skin
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
			}
		end

	elseif ((AircraftType >= aircraftDistribution[2]) and (AircraftType <= aircraftDistribution[3])) then  -- ATTACK AIRCRAFT
		if (coalitionIndex == 1) then
			randomAttack = math.random(9,16) -- random for airplane type; Red AC 9-16
		else
			randomAttack = math.random(1,8) -- random for airplane type; Blue AC 1-8
		end

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

		if (randomAttack == 1) then
			_aircrafttype = "A-10A"
			_country = country.id.USA

			local addCallname = {"Hawg", "Boar", "Pig", "Tusk"}
			local c = #nameCallname
			for k,v in pairs(addCallname) do
				nameCallname[c + k] = v
			end

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

			subtype = math.random(1,18)
			if (subtype == 1) then
				_skin = "104th FS Maryland ANG, Baltimore (MD)"
			elseif (subtype == 2) then
				_skin = "118th FS Bradley ANGB, Connecticut (CT)"
			elseif (subtype == 3) then
				_skin = "118th FS Bradley ANGB, Connecticut (CT) N621"
			elseif (subtype == 4) then
				_skin = "172nd FS Battle Creek ANGB, Michigan (BC)"
			elseif (subtype == 5) then
				_skin = "184th FS Arkansas ANG, Fort Smith (FS)"
			elseif (subtype == 6) then
				_skin = "190th FS Boise ANGB, Idaho (ID)"
			elseif (subtype == 7) then
				_skin = "23rd TFW England AFB (EL)"
			elseif (subtype == 8) then
				_skin = "25th FS Osan AB, Korea (OS)"
			elseif (subtype == 9) then
				_skin = "354th FS Davis Monthan AFB, Arizona (DM)"
			elseif (subtype == 10) then
				_skin = "355th FS Eielson AFB, Alaska (AK)"
			elseif (subtype == 11) then
				_skin = "357th FS Davis Monthan AFB, Arizona (DM)"
			elseif (subtype == 12) then
				_skin = "358th FS Davis Monthan AFB, Arizona (DM)"
			elseif (subtype == 13) then
				_skin = "422nd TES Nellis AFB, Nevada (OT)"
			elseif (subtype == 14) then
				_skin = "47th FS Barksdale AFB, Louisiana (BD)"
			elseif (subtype == 15) then
				_skin = "66th WS Nellis AFB, Nevada (WA)"
			elseif (subtype == 16) then
				_skin = "74th FS Moody AFB, Georgia (FT)"
			elseif (subtype == 17) then
				_skin = "81st FS Spangdahlem AB, Germany (SP) 1"
			else
				_skin = "81st FS Spangdahlem AB, Germany (SP) 2"
			end

			_fullname = "USA A-10A - " .. _skin

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
			}
		elseif (randomAttack == 2)	then
			_aircrafttype = "A-10C"

			local addCallname = {"Hawg", "Boar", "Pig", "Tusk"}
			local c = #nameCallname
			for k,v in pairs(addCallname) do
				nameCallname[c + k] = v
			end

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

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,18)
				if (subtype1 == 1) then
					_skin = "104th FS Maryland ANG, Baltimore (MD)"
				elseif (subtype1 == 2) then
					_skin = "118th FS Bradley ANGB, Connecticut (CT)"
				elseif (subtype1 == 3) then
					_skin = "118th FS Bradley ANGB, Connecticut (CT) N621"
				elseif (subtype1 == 4) then
					_skin = "172nd FS Battle Creek ANGB, Michigan (BC)"
				elseif (subtype1 == 5) then
					_skin = "184th FS Arkansas ANG, Fort Smith (FS)"
				elseif (subtype1 == 6) then
					_skin = "190th FS Boise ANGB, Idaho (ID)"
				elseif (subtype1 == 7) then
					_skin = "23rd TFW England AFB (EL)"
				elseif (subtype1 == 8) then
					_skin = "25th FS Osan AB, Korea (OS)"
				elseif (subtype1 == 9) then
					_skin = "354th FS Davis Monthan AFB, Arizona (DM)"
				elseif (subtype1 == 10) then
					_skin = "355th FS Eielson AFB, Alaska (AK)"
				elseif (subtype1 == 11) then
					_skin = "357th FS Davis Monthan AFB, Arizona (DM)"
				elseif (subtype1 == 12) then
					_skin = "358th FS Davis Monthan AFB, Arizona (DM)"
				elseif (subtype1 == 13) then
					_skin = "422nd TES Nellis AFB, Nevada (OT)"
				elseif (subtype1 == 14) then
					_skin = "47th FS Barksdale AFB, Louisiana (BD)"
				elseif (subtype1 == 15) then
					_skin = "66th WS Nellis AFB, Nevada (WA)"
				elseif (subtype1 == 16) then
					_skin = "74th FS Moody AFB, Georgia (FT)"
				elseif (subtype1 == 17) then
					_skin = "81st FS Spangdahlem AB, Germany (SP) 1"
				else
					_skin = "81st FS Spangdahlem AB, Germany (SP) 2"
				end

				_fullname = "USA A-10C - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = "Australia Notional RAAF"
				_fullname = "AUSTRALIA A-10C - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_skin = "A-10 Grey"
				_fullname = "BELGIUM A-10C - " .. _skin
			elseif (subtype == 4) then
				_country = country.id.CANADA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Fictional Canadian Air Force Pixel Camo"
				elseif (subtype1 == 2) then
					_skin = "Canada RCAF 409 Squadron"
				else
					_skin = "Canada RCAF 442 Snow Scheme"
				end

				_fullname = "CANADA A-10C - " .. _skin

			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_skin = "A-10 Grey"
				_fullname = "DENMARK A-10C - " .. _skin
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_skin = "Fictional France Escadron de Chasse 03.003 ARDENNES"
				_fullname = "FRANCE A-10C - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.GEORGIA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Fictional Georgian Grey"
				else
					_skin = "Fictional Georgian Olive"
				end

				_fullname = "GEORGIA A-10C - " .. _skin

			elseif (subtype == 8) then
				_country = country.id.GERMANY

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Fictional German 3322"
				else
					_skin = "Fictional German 3323"
				end

				_fullname = "GERMANY A-10C - " .. _skin

			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_skin = "Fictional Israel 115 Sqn Flying Dragon"
				_fullname = "ISRAEL A-10C - " .. _skin
			elseif (subtype == 10) then
				_country = country.id.ITALY
				_skin = "Fictional Italian AM (23Gruppo)"
				_fullname = "ITALY A-10C - " .. _skin
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_skin = "Fictional Royal Norwegian Air Force"
				_fullname = "NORWAY A-10C - " .. _skin
			elseif (subtype == 12) then
				_country = country.id.SPAIN

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Fictional Spanish 12nd Wing"
				elseif (subtype1 == 2) then
					_skin = "Fictional Spanish AGA"
				else
					_skin = "Fictional Spanish Tritonal"
				end

				_fullname = "SPAIN A-10C - " .. _skin

			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_skin = "A-10 Grey"
				_fullname = "THE_NETHERLANDS A-10C - " .. _skin
			elseif (subtype == 14) then
				_country = country.id.UK
				_skin = "A-10 Grey"
				_fullname = "UK A-10C - " .. _skin
			else
				_country = country.id.UKRAINE
				_skin = "Fictional Ukraine Air Force 1"
				_fullname = "UKRAINE A-10C - " .. _skin
			end

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
			}
		elseif (randomAttack == 3)	then
			_aircrafttype = "Hawk"

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

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,7)
				if (subtype1 == 1) then
					_skin = "100sqn XX189"
				elseif (subtype1 == 2) then
					_skin = "12th FTW, Randolph AFB, Texas (RA)"
				elseif (subtype1 == 3) then
					_skin = "1st RS, Beale AFB, California (BB)"
				elseif (subtype1 == 4) then
					_skin = "25th FTS, Vance AFB, Oklahoma (VN)"
				elseif (subtype1 == 5) then
					_skin = "509th BS, Whitman AFB, Missouri (WM)"
				elseif (subtype1 == 6) then
					_skin = "88th FTS, Sheppard AFB, Texas (EN)"
				else
					_skin = "NAS Meridian, Mississippi Seven (VT-7)"
				end

				_fullname = "USA Hawk - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = ""
				_fullname = "AUSTRALIA Hawk"
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_skin = "100sqn XX189"
				_fullname = "BELGIUM Hawk - " .. _skin
			elseif (subtype == 4) then
				_country = country.id.CANADA
				_skin = "100sqn XX189"
				_fullname = "CANADA Hawk - " .. _skin
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_skin = "100sqn XX189"
				_fullname = "DENMARK Hawk - " .. _skin
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_skin = "100sqn XX189"
				_fullname = "FRANCE Hawk - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.GEORGIA
				_skin = "100sqn XX189"
				_fullname = "GEORGIA Hawk - " .. _skin
			elseif (subtype == 8) then
				_country = country.id.GERMANY
				_skin = "100sqn XX189"
				_fullname = "GERMANY Hawk - " .. _skin
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_skin = "100sqn XX189"
				_fullname = "ISRAEL Hawk - " .. _skin
			elseif (subtype == 10) then
				_country = country.id.ITALY
				_skin = "100sqn XX189"
				_fullname = "ITALY Hawk - " .. _skin
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_skin = "100sqn XX189"
				_fullname = "NORWAY Hawk - " .. _skin
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				_skin = "100sqn XX189"
				_fullname = "SPAIN Hawk - " .. _skin
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_skin = "100sqn XX189"
				_fullname = "THE_NETHERLANDS Hawk - " .. _skin
			elseif (subtype == 14) then
				_country = country.id.UK

				subtype1 = math.random(1,10)
				if (subtype1 == 1) then
					_skin = "100sqn XX189"
				elseif (subtype1 == 2) then
					_skin = "XX218 - 208Sqn"
				elseif (subtype1 == 3) then
					_skin = "XX179 - Red Arrows 1979-2007"
				elseif (subtype1 == 4) then
					_skin = "XX179 - Red Arrows 2008-2012"
				elseif (subtype1 == 5) then
					_skin = "XX159 - FRADU Royal Navy Anniversary"
				elseif (subtype1 == 6) then
					_skin = "XX175 - FRADU Royal Navy"
				elseif (subtype1 == 7) then
					_skin = "XX316 - FRADU Royal Navy"
				elseif (subtype1 == 8) then
					_skin = "XX100 - TFC"
				elseif (subtype1 == 9) then
					_skin = "1018 - United Arab Emirates"
				else
					_skin = "XX228 - VEAO"
				end

				_fullname = "UK Hawk - " .. _skin

			else
				_country = country.id.UKRAINE
				_skin = "100sqn XX189"
				_fullname = "UKRAINE Hawk - " .. _skin
			end

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
			}
		elseif (randomAttack == 4)	then
			_aircrafttype = "L-39ZA"

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GEORGIA
				_skin = "Georgian Air Force"
				_fullname = "GEORGIA - " .. _skin
			else
				_country = country.id.UKRAINE
				_skin = "Ukraine Air Force 1"
				_fullname = "UKRAINE - " .. _skin
			end

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
			}
		elseif (randomAttack == 5)	then
			_aircrafttype = "MiG-27K"
			_country = country.id.UKRAINE
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
			_skin = "af standard"
			_fullname = "UKRAINE MiG-27K - " .. _skin
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
			}
		elseif (randomAttack == 6)	then
			_aircrafttype = "Su-17M4"
			_country = country.id.UKRAINE

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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "af standard"
			elseif (subtype == 2) then
				_skin = "af standard (worn-out)"
			else
				_skin = "shap limanskoye ab"
			end

			_fullname = "UKRAINE Su-17M4 - " .. _skin

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
			}
		elseif (randomAttack == 7)	then
			_aircrafttype = "Su-25"

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GEORGIA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "`scorpion` demo scheme (native)"
				else
					_skin = "field camo scheme #1 (native)"
				end

				_fullname = "GEORGIA Su-25 - " .. _skin

			else
				_country = country.id.UKRAINE

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "broken camo scheme #1 (native). 299th oshap"
				elseif (subtype1 == 2) then
					_skin = "broken camo scheme #2 (native). 452th shap"
				elseif (subtype1 == 3) then
					_skin = "petal camo scheme #1 (native). 299th brigade"
				else
					_skin = "petal camo scheme #2 (native). 299th brigade"
				end

				_fullname = "UKRAINE Su-25 - " .. _skin

			end

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
			}
		elseif (randomAttack == 8)	then
			_aircrafttype = "Su-25T"
			_country = country.id.GEORGIA

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "af standard"
			else
				_skin = "af standard 1"
			end

			_fullname = "GEORGIA Su-25T - " .. _skin

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
			}
		elseif (randomAttack == 9)	then
			_aircrafttype = "A-10C"

			local addCallname = {"Hawg", "Boar", "Pig", "Tusk"}
			local c = #nameCallname
			for k,v in pairs(addCallname) do
				nameCallname[c + k] = v
			end

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Fictional Russian Air Force 1"
				else
					_skin = "Fictional Russian Air Force 2"
				end

				_fullname = "RUSSIA A-10C - " .. _skin

			else
				_country = country.id.TURKEY
				_skin = "A-10 Grey"
				_fullname = "TURKEY A-10C - " .. _skin
			end

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
			}
		elseif (randomAttack == 10)	then
			_aircrafttype = "Hawk"

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

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.RUSSIA
				_skin = "100sqn XX189"
				_fullname = "RUSSIA Hawk - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_skin = "100sqn XX189"
				_fullname = "ABKHAZIA Hawk - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.SOUTH_OSETIA
				_skin = "100sqn XX189"
				_fullname = "SOUTH_OSETIA Hawk - " .. _skin
			else
				_country = country.id.TURKEY
				_skin = "100sqn XX189"
				_fullname = "TURKEY Hawk - " .. _skin
			end

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
			}
		elseif (randomAttack == 11)	then
			_aircrafttype = "L-39ZA"

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Czech Air Force"
				elseif (subtype1 == 2) then
					_skin = "Russian Air Force 1"
				else
					_skin = "Russian Air Force Old"
				end

				_fullname = "RUSSIA - " .. _skin

			else
				_country = country.id.ABKHAZIA
				_skin = "Abkhazian Air Force"
				_fullname = "ABKHAZIA - " .. _skin
			end

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
			}
		elseif (randomAttack == 12)	then
			_aircrafttype = "MiG-27K"
			_country = country.id.RUSSIA
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
			_skin = "af standard"
			_fullname = "RUSSIA MiG-27K - " .. _skin
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
			}
		elseif (randomAttack == 13)	then
			_aircrafttype = "Su-17M4"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "af standard"
			else
				_skin = "af standard (worn-out)"
			end

			_fullname = "RUSSIA Su-17M4 - " .. _skin

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
			}
		elseif (randomAttack == 14)	then
			_aircrafttype = "Su-25"

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "field camo scheme #1 (native)"
				elseif (subtype1 == 2) then
					_skin = "field camo scheme #2 (native). 960th shap"
				elseif (subtype1 == 3) then
					_skin = "field camo scheme #3 (worn-out). 960th shap"
				else
					_skin = "forest camo scheme #1 (native)"
				end

				_fullname = "RUSSIA Su-25 - " .. _skin

			else
				_country = country.id.ABKHAZIA
				_skin = "Abkhazian Air Force"
				_fullname = "ABKHAZIA Su-25 - " .. _skin
			end

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
			}
		elseif (randomAttack == 15)	then
			_aircrafttype = "Su-25T"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "af standard 1"
			elseif (subtype == 2) then
				_skin = "af standard 2"
			else
				_skin = "su-25t test scheme"
			end

			_fullname = "RUSSIA Su-25T - " .. _skin

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
			}
		elseif (randomAttack == 16)	then
			_aircrafttype = "Su-25TM"
			_country = country.id.RUSSIA
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
			_skin = "Flight Research Institute  VVS"
			_fullname = "RUSSIA Su-25TM - " .. _skin
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
			}
		end
	elseif ((AircraftType >= aircraftDistribution[3]) and (AircraftType <= aircraftDistribution[4])) then  -- FIGHTERS
		if (coalitionIndex == 1) then
			randomFighter = math.random(22,37) -- random for airplane type; Red AC 22-37
		else
			randomFighter = math.random(1,21) -- random for airplane type; Blue AC 1-21
		end

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

		if (randomFighter == 1) then
			_aircrafttype = "Bf-109K-4"
			_country = country.id.GERMANY

			subtype = math.random(1,7)
			if (subtype == 1) then
				_skin = "Bf-109 K4 1.NJG  11"
			elseif (subtype == 2) then
				_skin = "Bf-109 K4 330xxx batch"
			elseif (subtype == 3) then
				_skin = "Bf-109 K4 334xxx batch"
			elseif (subtype == 4) then
				_skin = "Bf-109 K4 335xxx batch"
			elseif (subtype == 5) then
				_skin = "Bf-109 K4 9.JG27 (W10+I)"
			elseif (subtype == 6) then
				_skin = "Germany_standard"
			else
				_skin = "Bf-109 K4 Jagdgeschwader 53"
			end

			_fullname = "GERMANY Bf-109K-4 - " .. _skin

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
			}
		elseif (randomFighter == 2) then
			_aircrafttype = "F-14A"
			_country = country.id.USA

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

			subtype = math.random(1,10)
			if (subtype == 1) then
				_skin = "black demo scheme"
			elseif (subtype == 2) then
				_skin = "vf-1 `wolfpack`"
			elseif (subtype == 3) then
				_skin = "vf-33 `starfighters`"
			elseif (subtype == 4) then
				_skin = "vf-41 `black aces`"
			elseif (subtype == 5) then
				_skin = "vf-84 `jolly rogers`"
			elseif (subtype == 6) then
				_skin = "vf-111 `sundowners`- 1"
			elseif (subtype == 7) then
				_skin = "vf-111 `sundowners`- 2"
			elseif (subtype == 8) then
				_skin = "vf-142 `ghost riders`"
			elseif (subtype == 9) then
				_skin = "vf-143 `pukin's dogs`"
			else
				_skin = "vf-xxx `aardvarks`"
			end

			_fullname = "USA F-14A - " .. _skin

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
			}
		elseif (randomFighter == 3)	then
			_aircrafttype = "F-15C"

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,8)
				if (subtype1 == 1) then
					_skin = "19th Fighter SQN (AK)"
				elseif (subtype1 == 2) then
					_skin = "58th Fighter SQN (EG)"
				elseif (subtype1 == 3) then
					_skin = "65th Agressor SQN (WA) Flanker"
				elseif (subtype1 == 4) then
					_skin = "65th Agressor SQN (WA) MiG"
				elseif (subtype1 == 5) then
					_skin = "65th Agressor SQN (WA) SUPER_Flanker"
				elseif (subtype1 == 6) then
					_skin = "390th Fighter SQN"
				elseif (subtype1 == 7) then
					_skin = "493rd Fighter SQN (LN)"
				else
					_skin = "Ferris Scheme"
				end

				_fullname = "USA F-15C - " .. _skin

			else
				_country = country.id.ISRAEL
				skin = "106th SQN (8th Airbase)"
				_fullname = "ISRAEL F-15C - " .. _skin
			end

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
			}
		elseif (randomFighter == 4) then
			_aircrafttype = "F-16A"
			_country = country.id.USA

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

			_skin = "usaf f16 standard-1"
			_fullname = "USA F-16A - " .. _skin
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
			}
		elseif (randomFighter == 5) then
			_aircrafttype = "F-16C bl.52d"

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,8)
				if (subtype1 == 1) then
					_skin = "pacaf 14th fs (mj) misawa afb"
				elseif (subtype1 == 2) then
					_skin = "pacaf 35th fw (ww) misawa afb"
				elseif (subtype1 == 3) then
					_skin = "usaf 77th fs (sw) shaw afb"
				elseif (subtype1 == 4) then
					_skin = "usaf 147th fig (ef) ellington afb"
				elseif (subtype1 == 5) then
					_skin = "usaf 412th tw (ed) edwards afb"
				elseif (subtype1 == 6) then
					_skin = "usaf 414th cts (wa) nellis afb"
				elseif (subtype1 == 7) then
					_skin = "usafe 22nd fs (sp) spangdahlem afb"
				else
					_skin = "usafe 555th fs (av) aviano afb"
				end

				_fullname = "USA F-16C bl.52d - " .. _skin

			else
				_country = country.id.ISRAEL
				_skin = "idf_af f16c standard"
				_fullname = "ISRAEL F-16C bl.52d - " .. _skin
			end

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
			}
		elseif (randomFighter == 6) then
			_aircrafttype = "F-16A MLU"

			subtype = math.random(1,5)
			if (subtype == 1) then
				_country = country.id.BELGIUM
				_skin = "2nd squadron `comet` florennes ab"

--				subtype1 = math.random(1,2)
--				if (subtype1 == 1) then
--					_skin = "2nd squadron `comet` florennes ab"
--				else
--					_skin = "CMD extended skins"
--				end

				_fullname = "BELGIUM F-16A MLU - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.DENMARK
				_skin = "rdaf f16 standard-1"

--				subtype1 = math.random(1,2)
--				if (subtype1 == 1) then
--					_skin = "rdaf f16 standard-1"
--				else
--					_skin = "CMD extended skins"
--				end

				_fullname = "DENMARK F-16A MLU - " .. _skin

			elseif (subtype == 3) then
				_country = country.id.ITALY
				_skin = "rdaf f16 standard-1"

--				subtype1 = math.random(1,2)
--				if (subtype1 == 1) then
--					_skin = "rdaf f16 standard-1"
--				else
--					_skin = "CMD extended skins"
--				end

				_fullname = "ITALY F-16A MLU - " .. _skin

			elseif (subtype == 4) then
				_country = country.id.NORWAY

--				subtype1 = math.random(1,3)
--				if (subtype1 == 1) then
--					_skin = "CMD extended skins"
--				elseif (subtype1 == 2) then
--					_skin = "norway 338 skvadron"
--				else
--					_skin = "norway skv338"
--				end

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "norway 338 skvadron"
				else
					_skin = "norway skv338"
				end

				_fullname = "NORWAY F-16A MLU - " .. _skin

			else
				_country = country.id.THE_NETHERLANDS

--				subtype1 = math.random(1,3)
--				if (subtype1 == 1) then
--					_skin = "CMD extended skins"
--				elseif (subtype1 == 2) then
--					_skin = "the netherlands (313th squadron `` twenthe ab)"
--				else
--					_skin = "the netherlands 313th `tigers` squadron"
--				end

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "the netherlands (313th squadron `` twenthe ab)"
				else
					_skin = "the netherlands 313th `tigers` squadron"
				end

				_fullname = "THE_NETHERLANDS F-16A MLU - " .. _skin

			end

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
			}
		elseif (randomFighter == 7) then
			_aircrafttype = "F-4E"
			_skin = ""

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GERMANY
				_skin = "af standard"
				_fullname = "GERMANY F-4E - " .. _skin
			else
				_country = country.id.ISRAEL
				_fullname = "ISRAEL F-4E"
			end

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
			}
		elseif (randomFighter == 8) then
			_aircrafttype = "F-5E"
			_country = country.id.USA

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

			subtype = math.random(1,9)
			if (subtype == 1) then
				_skin = "`green` paint scheme"
			elseif (subtype == 2) then
				_skin = "aggressor `desert` scheme"
			elseif (subtype == 3) then
				_skin = "aggressor `frog` scheme2"
			elseif (subtype == 4) then
				_skin = "aggressor `new blue ` scheme"
			elseif (subtype == 5) then
				_skin = "aggressor `new ghost ` scheme1"
			elseif (subtype == 6) then
				_skin = "aggressor `new ghost ` scheme2"
			elseif (subtype == 7) then
				_skin = "aggressor `old blue ` scheme"
			elseif (subtype == 8) then
				_skin = "aggressor `sand` scheme"
			else
				_skin = "aggressor `snake` scheme"
			end

			_fullname = "USA F-5E - " .. _skin

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
			}
		elseif (randomFighter == 9) then
			_aircrafttype = "F-86F Sabre"

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
			_skin = ""

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA
				_fullname = "USA F-86F Sabre"
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_fullname = "AUSTRALIA F-86F Sabre"
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_fullname = "BELGIUM F-86F Sabre"
			elseif (subtype == 4) then
				_country = country.id.CANADA
				_fullname = "CANADA F-86F Sabre"
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_fullname = "DENMARK F-86F Sabre"
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_fullname = "FRANCE F-86F Sabre"
			elseif (subtype == 7) then
				_country = country.id.GEORGIA
				_fullname = "GEORGIA F-86F Sabre"
			elseif (subtype == 8) then
				_country = country.id.GERMANY
				_fullname = "GERMANY F-86F Sabre"
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_fullname = "ISRAEL F-86F Sabre"
			elseif (subtype == 10) then
				_country = country.id.ITALY
				_fullname = "ITALY F-86F Sabre"
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_fullname = "NORWAY F-86F Sabre"
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				_fullname = "SPAIN F-86F Sabre"
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_fullname = "THE_NETHERLANDS F-86F Sabre"
			elseif (subtype == 14) then
				_country = country.id.UK
				_fullname = "UK F-86F Sabre"
			else
				_country = country.id.UKRAINE
				_fullname = "UKRAINE F-86F Sabre"
			end

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
			}
		elseif (randomFighter == 10) then
			_aircrafttype = "F/A-18C"

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
			_skin = ""

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "NSAWC_25"
				elseif (subtype1 == 2) then
					_skin = "NSAWC_44"
				elseif (subtype1 == 3) then
					_skin = "VFA-94"
				else
					_skin = "VFC-12"
				end

				_fullname = "USA F/A-18C - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = "Australia 75 Sqn RAAF"
				_fullname = "AUSTRALIA F/A-18C - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.CANADA
				_fullname = "CANADA F/A-18C"
			else
				_country = country.id.SPAIN
				_fullname = "SPAIN F/A-18C"
			end

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
			}
		elseif (randomFighter == 11) then
			_aircrafttype = "FW-190D9"

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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_country = country.id.USA
				_skin = "FW-190D9_USA"
				_fullname = "USA FW-190D9 - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.GERMANY

				subtype1 = math.random(1,6)
				if (subtype1 == 1) then
					_skin = "FW-190D9_13.JG 51_Heinz Marquardt"
				elseif (subtype1 == 2) then
					_skin = "FW-190D9_IV.JG 26_Hans Dortenmann"
				elseif (subtype1 == 3) then
					_skin = "FW-190D9_Black 4 of Stab IIJG 6"
				elseif (subtype1 == 4) then
					_skin = "FW-190D9_JG54"
				elseif (subtype1 == 5) then
					_skin = "FW-190D9_5JG301"
				else
					_skin = "FW-190D9_Red"
				end

				_fullname = "GERMANY FW-190D9 - " .. _skin

			else
				_country = country.id.UK
				_skin = "FW-190D9_GB"
				_fullname = "UK FW-190D9 - " .. _skin
			end

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
			}
		elseif (randomFighter == 12) then
			_aircrafttype = "MiG-15bis"
			_skin = ""

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA
				_fullname = "USA MiG-15bis"
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_fullname = "AUSTRALIA MiG-15bis"
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_fullname = "BELGIUM MiG-15bis"
			elseif (subtype == 4) then
				_country = country.id.CANADA
				_fullname = "CANADA MiG-15bis"
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_fullname = "DENMARK MiG-15bis"
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_fullname = "FRANCE MiG-15bis"
			elseif (subtype == 7) then
				_country = country.id.GERMANY
				_fullname = "GERMANY MiG-15bis"
			elseif (subtype == 8) then
				_country = country.id.GEORGIA
				_fullname = "GEORGIA MiG-15bis"
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_fullname = "ISRAEL MiG-15bis"
			elseif (subtype == 10) then
				_country = country.id.ITALY
				_fullname = "ITALY MiG-15bis"
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_fullname = "NORWAY MiG-15bis"
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				_fullname = "SPAIN MiG-15bis"
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_fullname = "THE_NETHERLANDS MiG-15bis"
			elseif (subtype == 14) then
				_country = country.id.UK
				_fullname = "UK MiG-15bis"
			else
				_country = country.id.UKRAINE
				_fullname = "UKRAINE MiG-15bis"
			end

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
			}
		elseif (randomFighter == 13) then
			_aircrafttype = "MiG-21Bis"
			_country = country.id.USA

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

			subtype = math.random(1,6)
			if (subtype == 1) then
				_skin = "32nd FG - Northeria"
			elseif (subtype == 2) then
				_skin = "101FS - Serbia"
			elseif (subtype == 3) then
				_skin = "Factory Test"
			elseif (subtype == 4) then
				_skin = "HavLLv 31 - Finland"
			elseif (subtype == 5) then
				_skin = "VVS Camo"
			else
				_skin = "VVS Grey"
			end

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA
				_fullname = "USA MiG-21BiS - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_fullname = "AUSTRALIA MiG-21BiS - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_fullname = "BELGIUM MiG-21BiS - " .. _skin
			elseif (subtype == 4) then
				_country = country.id.CANADA
				_fullname = "CANADA MiG-21BiS - " .. _skin
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_fullname = "DENMARK MiG-21BiS - " .. _skin
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_fullname = "FRANCE MiG-21BiS - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.GERMANY
				_fullname = "GERMANY MiG-21BiS - " .. _skin
			elseif (subtype == 8) then
				_country = country.id.GEORGIA
				_fullname = "GEORGIA MiG-21BiS - " .. _skin
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_fullname = "ISRAEL MiG-21BiS - " .. _skin
			elseif (subtype == 10) then
				_country = country.id.ITALY
				_fullname = "ITALY MiG-21BiS - " .. _skin
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_fullname = "NORWAY MiG-21BiS - " .. _skin
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				_fullname = "SPAIN MiG-21BiS - " .. _skin
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_fullname = "THE_NETHERLANDS MiG-21BiS - " .. _skin
			elseif (subtype == 14) then
				_country = country.id.UK
				_fullname = "UK MiG-21BiS - " .. _skin
			else
				_country = country.id.UKRAINE
				_fullname = "UKRAINE MiG-21BiS - " .. _skin
			end

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
			}
		elseif (randomFighter == 14) then
			_aircrafttype = "MiG-23MLD"
			_country = country.id.UKRAINE
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
			_skin = "af standard"
			_fullname = "UKRAINE MiG-23MLD - " .. _skin
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
			}
		elseif (randomFighter == 15) then
			_aircrafttype = "MiG-25PD"
			_country = country.id.UKRAINE
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
			_skin = "af standard"
			_fullname = "UKRAINE MiG-25PD - " .. _skin
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
			}
		elseif (randomFighter == 16) then
			_aircrafttype = "MiG-29A"
			_country = country.id.UKRAINE

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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "40th fw `maestro` vasilkov ab"
			elseif (subtype == 2) then
				_skin = "af standard-1"
			else
				_skin = "af standard-2"
			end

			_fullname = "UKRAINE MiG-29A - " .. _skin

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
			}
		elseif (randomFighter == 17) then
			_aircrafttype = "MiG-29G"
			_country = country.id.GERMANY

			subtype = math.random(1,6)
			if (subtype == 1) then
				_skin = "luftwaffe 29+20 demo"
			elseif (subtype == 2) then
				_skin = "luftwaffe gray early"
			elseif (subtype == 3) then
				_skin = "luftwaffe gray-1"
			elseif (subtype == 4) then
				_skin = "luftwaffe gray-2(worn-out)"
			elseif (subtype == 5) then
				_skin = "luftwaffe gray-3"
			else
				_skin = "luftwaffe gray-4"
			end

			_fullname = "GERMANY MiG-29G - " .. _skin

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
			}
		elseif (randomFighter == 18) then
			_aircrafttype = "MiG-29S"
			_country = country.id.UKRAINE

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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "14th army, vinnitsa ab"
			elseif (subtype == 2) then
				_skin = "9th fw belbek ab"
			else
				_skin = "`ukrainian falcons` paint scheme"
			end

			_fullname = "UKRAINE MiG-29S - " .. _skin

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
			}
		elseif (randomFighter == 19) then
			_aircrafttype = "Mirage 2000-5"
			_country = country.id.FRANCE

			subtype = math.random(1,6)
			if (subtype == 1) then
				_skin = "ec1_2  spa103 `cigogne de fonck`"
			elseif (subtype == 2) then
				_skin = "ec1_2  spa12 `cigogne a ailes ouvertes`"
			elseif (subtype == 3) then
				_skin = "ec1_2 spa3 `cigogne de guynemer`"
			elseif (subtype == 4) then
				_skin = "ec2_2 `cote d'or` spa57 `mouette`"
			elseif (subtype == 5) then
				_skin = "ec2_2 `cote d'or` spa65 `chimere`"
			else
				_skin = "ec2_2 spa94 `lamort qui fauche`"
			end

			_fullname = "FRANCE Mirage 2000-5 - " .. _skin

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
			}
		elseif (randomFighter == 20) then
			_aircrafttype = "P-51D"
			_skin = ""

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

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,19)
				if (subtype1 == 1) then
					_skin = "USAF 363rd FS, 357th FG DESERT RAT"
				elseif (subtype1 == 2) then
					_skin = "USAF 364th FS, HURRY HOME HONEY"
				elseif (subtype1 == 3) then
					_skin = "USAF 344rd FS,  IRON ASS"
				elseif (subtype1 == 4) then
					_skin = "USAF 485rd FS,  MOONBEAM McSWINE"
				elseif (subtype1 == 5) then
					_skin = "USAF 302rd FS, RED TAILS"
				elseif (subtype1 == 6) then
					_skin = "USAF 363rd FS"
				elseif (subtype1 == 7) then
					_skin = "USAF 364th FS"
				elseif (subtype1 == 8) then
					_skin = "USAF 375 rd FS,"
				elseif (subtype1 == 9) then
					_skin = "USAF 485rd FS"
				elseif (subtype1 == 10) then
					_skin = "USAF 84 rd FS,"
				elseif (subtype1 == 11) then
					_skin = "Bare Metal"
				elseif (subtype1 == 12) then
					_skin = "USAF Big Beautiful Doll"
				elseif (subtype1 == 13) then
					_skin = "USAF DEE"
				elseif (subtype1 == 14) then
					_skin = "Dogfight Blue"
				elseif (subtype1 == 15) then
					_skin = "Dogfight Red"
				elseif (subtype1 == 16) then
					_skin = "USAF Ferocius Frankie"
				elseif (subtype1 == 17) then
					_skin = "USAF Gentleman Jim"
				elseif (subtype1 == 18) then
					_skin = "USAF Miss Velma"
				else
					_skin = "USAF Voodoo AirRace"
				end

				_fullname = "USA P-51D - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "AUSTRALIA P-51D - " .. _skin

			elseif (subtype == 3) then
				_country = country.id.BELGIUM

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "BELGIUM P-51D - " .. _skin

			elseif (subtype == 4) then
				_country = country.id.CANADA

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "Canada RAF 442 Sqdn"
				elseif (subtype1 == 2) then
					_skin = "Bare Metal"
				elseif (subtype1 == 3) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "CANADA P-51D - " .. _skin

			elseif (subtype == 5) then
				_country = country.id.DENMARK

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "DENMARK P-51D - " .. _skin

			elseif (subtype == 6) then
				_country = country.id.FRANCE

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "FRANCE P-51D - " .. _skin

			elseif (subtype == 7) then
				_country = country.id.GEORGIA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "GEORGIA P-51D - " .. _skin

			elseif (subtype == 8) then
				_country = country.id.GERMANY

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				elseif (subtype1 == 3) then
					_skin = "Dogfight Red"
				else
					_skin = "Germany Training Staffel"
				end

				_fullname = "GERMANY P-51D - " .. _skin

			elseif (subtype == 9) then
				_country = country.id.ISRAEL

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				elseif (subtype1 == 3) then
					_skin = "Dogfight Red"
				else
					_skin = "Israeli Air Force"
				end

				_fullname = "ISRAEL P-51D - " .. _skin

			elseif (subtype == 10) then
				_country = country.id.ITALY

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				elseif (subtype1 == 3) then
					_skin = "Dogfight Red"
				else
					_skin = "Italia Air Force"
				end

				_fullname = "ITALY P-51D - " .. _skin

			elseif (subtype == 11) then
				_country = country.id.NORWAY

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "NORWAY P-51D - " .. _skin

			elseif (subtype == 12) then
				_country = country.id.SPAIN

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				elseif (subtype1 == 3) then
					_skin = "Dogfight Red"
				else
					_skin = "SPAIN Roberto"
				end

				_fullname = "SPAIN P-51D - " .. _skin

			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "THE_NETHERLANDS P-51D - " .. _skin

			elseif (subtype == 14) then
				_country = country.id.UK

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "RAF 112 Sqdn"
				elseif (subtype1 == 2) then
					_skin = "Bare Metal"
				elseif (subtype1 == 3) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "UK P-51D - " .. _skin

			else
				_country = country.id.UKRAINE

				subtype1 = math.random(1,5)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				elseif (subtype1 == 3) then
					_skin = "Dogfight Red"
				elseif (subtype1 == 4) then
					_skin = "Ukraine Modern"
				else
					_skin = "Ukraine Old"
				end

				_fullname = "UKRAINE P-51D - " .. _skin

			end

			_payload =
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
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomFighter == 21) then
			_aircrafttype = "Su-27"
			_country = country.id.UKRAINE

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

			subtype = math.random(1,5)
			if (subtype == 1) then
				_skin = "Air Force Ukraine Standard"
			elseif (subtype == 2) then
				_skin = "Air Force Ukraine Standard Early"
			elseif (subtype == 3) then
				_skin = "Mirgorod AFB (831th brigade)"
			elseif (subtype == 4) then
				_skin = "Mirgorod AFB (Digital camo)"
			else
				_skin = "Ozerne AFB (9th brigade)"
			end

			_fullname = "UKRAINE Su-27 - "	 .. _skin

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
			}
		elseif (randomFighter == 22) then
			_aircrafttype = "F-16C bl.50"
			_country = country.id.TURKEY
			_skin = "af f16 standard"
			_fullname = "TURKEY F-16C bl.50 - " .. _skin
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
			}
		elseif (randomFighter == 23) then
			_aircrafttype = "F-4E"
			_skin = ""
			_country = country.id.TURKEY
			_fullname = "TURKEY F-4E - " .. _skin
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
			}
		elseif (randomFighter == 24) then
			_aircrafttype = "F-5E"
			_country = country.id.TURKEY
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
			_skin = "`af standard"
			_fullname = "TURKEY F-5E - " .. _skin
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
			}
		elseif (randomFighter == 25) then
			_aircrafttype = "F-86F Sabre"

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

			_skin = ""

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.RUSSIA
				_fullname = "RUSSIA F-86F Sabre"
			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_fullname = "ABKHAZIA F-86F Sabre"
			elseif (subtype == 3) then
				_country = country.id.SOUTH_OSETIA
				_fullname = "SOUTH_OSETIA F-86F Sabre"
			else
				_country = country.id.TURKEY
				_fullname = "TURKEY F-86F Sabre"
			end

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
			}
		elseif (randomFighter == 26) then
			_aircrafttype = "FW-190D9"
			_country = country.id.RUSSIA
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
			_skin = "FW-190D9_USSR"
			_fullname = "RUSSIA FW-190D9 - " .. _skin
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
			}
		elseif (randomFighter == 27) then
			_aircrafttype = "MiG-21Bis"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,6)
			if (subtype == 1) then
				_skin = "32nd FG - Northeria"
			elseif (subtype == 2) then
				_skin = "101FS - Serbia"
			elseif (subtype == 3) then
				_skin = "Factory Test"
			elseif (subtype == 4) then
				_skin = "HavLLv 31 - Finland"
			elseif (subtype == 5) then
				_skin = "VVS Camo"
			else
				_skin = "VVS Grey"
			end

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.RUSSIA
				_fullname = "RUSSIA MiG-21BiS - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_fullname = "ABKHAZIA MiG-21BiS - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.SOUTH_OSETIA
				_fullname = "SOUTH_OSETIA MiG-21BiS - " .. _skin
			else
				_country = country.id.TURKEY
				_fullname = "TURKEY MiG-21BiS - " .. _skin
			end

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
			}
		elseif (randomFighter == 28) then
			_aircrafttype = "MiG-23MLD"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,4)
			if (subtype == 1) then
				_skin = "af standard"
			elseif (subtype == 2) then
				_skin = "af standard-1"
			elseif (subtype == 3) then
				_skin = "af standard-2"
			else
				_skin = "af standard-3 (worn-out)"
			end

			_fullname = "RUSSIA MiG-23MLD - " .. _skin

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
			}
		elseif (randomFighter == 29) then
			_aircrafttype = "MiG-25PD"
			_country = country.id.RUSSIA
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
			_skin = "af standard"
			_fullname = "RUSSIA MiG-25PD - " .. _skin
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
			}
		elseif (randomFighter == 30) then
			_aircrafttype = "MiG-29A"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,5)
			if (subtype == 1) then
				_skin = "120 gviap #45 domna ab"
			elseif (subtype == 2) then
				_skin = "33th iap wittstock ab (germany)"
			elseif (subtype == 3) then
				_skin = "968th iap altenburg ab (germany)"
			elseif (subtype == 4) then
				_skin = "`swifts` team #44 kubinka ab"
			else
				_skin = "demo paint scheme #999 mapo"
			end

			_fullname = "RUSSIA MiG-29A - " .. _skin

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
			}
		elseif (randomFighter == 31) then
			_aircrafttype = "MiG-29S"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,7)
			if (subtype == 1) then
				_skin = "1038th guards ctc, mary ab"
			elseif (subtype == 2) then
				_skin = "115th guards regiment, termez ab"
			elseif (subtype == 3) then
				_skin = "120th guards regiment, domna ab"
			elseif (subtype == 4) then
				_skin = "2nd fs `swifts` team, kubinka ab"
			elseif (subtype == 5) then
				_skin = "4th ctc lypetsk ab"
			elseif (subtype == 6) then
				_skin = "733th guards regiment, damgarten ab (gdr)"
			else
				_skin = "73th guards regiment, merzeburg ab (gdr)"
			end

			_fullname = "RUSSIA MiG-29S - " .. _skin

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
			}
		elseif (randomFighter == 32) then
			_aircrafttype = "MiG-31"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "174 GvIAP_Boris Safonov"
			elseif (subtype == 2) then
				_skin = "903_White"
			else
				_skin = "af standard"
			end

			_fullname = "RUSSIA MiG-31 - " .. _skin

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
			}
		elseif (randomFighter == 33) then
			_aircrafttype = "P-51D"

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

			_skin = ""

			subtype = math.random(1,3)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,10)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Russia Blueback"
				elseif (subtype1 == 3) then
					_skin = "Russia DOSAAF"
				elseif (subtype1 == 4) then
					_skin = "Dogfight Blue"
				elseif (subtype1 == 5) then
					_skin = "Dogfight Red"
				elseif (subtype1 == 6) then
					_skin = "Russia Green Black"
				elseif (subtype1 == 7) then
					_skin = "SPAIN Roberto"
				elseif (subtype1 == 8) then
					_skin = "Russia SRI VVS USSR 1942"
				elseif (subtype1 == 9) then
					_skin = "USSR Modern"
				else
					_skin = "USSR Old"
				end

				_fullname = "RUSSIA P-51D - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "ABKHAZIA P-51D - " .. _skin

			else
				_country = country.id.TURKEY

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Bare Metal"
				elseif (subtype1 == 2) then
					_skin = "Dogfight Blue"
				else
					_skin = "Dogfight Red"
				end

				_fullname = "TURKEY P-51D - " .. _skin

			end

			_payload =
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
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomFighter == 34) then
			_aircrafttype = "Su-27"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,14)
			if (subtype == 1) then
				_skin = "Air Force Standard"
			elseif (subtype == 2) then
				_skin = "Air Force Standard Early"
			elseif (subtype == 3) then
				_skin = "Air Force Standard old"
			elseif (subtype == 4) then
				_skin = "Besovets AFB"
			elseif (subtype == 5) then
				_skin = "Besovets AFB 2 squadron"
			elseif (subtype == 6) then
				_skin = "Chkalovsk AFB (689 GvIAP)"
			elseif (subtype == 7) then
				_skin = "Hotilovo AFB"
			elseif (subtype == 8) then
				_skin = "Kazakhstan Air Defense Forces"
			elseif (subtype == 9) then
				_skin = "Kilpyavr AFB (Maresyev)"
			elseif (subtype == 10) then
				_skin = "Kubinka AFB (Russian Knights)"
			elseif (subtype == 11) then
				_skin = "Lodeynoye pole AFB (177 IAP)"
			elseif (subtype == 12) then
				_skin = "Lypetsk AFB (Falcons of Russia)"
			elseif (subtype == 13) then
				_skin = "Lypetsk AFB (Shark)"
			else
				_skin = "M Gromov FRI"
			end

			_fullname = "RUSSIA Su-27 - " .. _skin

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
			}
		elseif (randomFighter == 35) then
			_aircrafttype = "Su-30"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,10)
			if (subtype == 1) then
				_skin = "`desert` test paint scheme"
			elseif (subtype == 2) then
				_skin = "`russian knights` team #25"
			elseif (subtype == 3) then
				_skin = "`snow` test paint scheme"
			elseif (subtype == 4) then
				_skin = "`test-pilots` team #597"
			elseif (subtype == 5) then
				_skin = "adf 148th ctc savasleyka ab"
			elseif (subtype == 6) then
				_skin = "af standard"
			elseif (subtype == 7) then
				_skin = "af standard early"
			elseif (subtype == 8) then
				_skin = "af standard early (worn-out)"
			elseif (subtype == 9) then
				_skin = "af standard last"
			else
				_skin = "af standard last (worn-out)"
			end

			_fullname = "RUSSIA Su-30 - " .. _skin

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
			}
		elseif (randomFighter == 36) then
			_aircrafttype = "Su-33"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,8)
			if (subtype == 1) then
				_skin = "279th kiap 1st squad navy"
			elseif (subtype == 2) then
				_skin = "279th kiap 2nd squad navy"
			elseif (subtype == 3) then
				_skin = "standard-1 navy"
			elseif (subtype == 4) then
				_skin = "standard-2 navy"
			elseif (subtype == 5) then
				_skin = "t-10k-1 test paint scheme"
			elseif (subtype == 6) then
				_skin = "t-10k-2 test paint scheme"
			elseif (subtype == 7) then
				_skin = "t-10k-5 test paint scheme"
			else
				_skin = "t-10k-9 test paint scheme"
			end

			_fullname = "RUSSIA Su-33 - " .. _skin

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
			}
		elseif (randomFighter == 37) then
			_aircrafttype = "Su-34"
			_country = country.id.RUSSIA

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "af standard"
			else
				_skin = "af standard 2"
			end

			_fullname = "RUSSIA Su-34 - " .. _skin

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
			}
		end
	elseif ((AircraftType >= aircraftDistribution[4]) or (AircraftType <= aircraftDistribution[5])) then -- HELICOPTERS
		if (coalitionIndex == 1) then
			randomHeli = math.random(15,23) -- random for airplane type; Red AC 15-23
		else
			randomHeli = math.random(1,14) -- random for airplane type; Blue AC 1-14
		end

		_task = ""
		_tasks =
		{
		}

		if (randomHeli == 1) then
			_aircrafttype = "AH-1W"

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "USA X Black"
				elseif (subtype1 == 2) then
					_skin = "USA Marines"
				else
					_skin = "standard"
				end

				_fullname = "USA AH-1W - " .. _skin

			else
				_country = country.id.ISRAEL
				_skin = "standard"
				_fullname = "ISRAEL AH-1W - " .. _skin
			end

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
			}
		elseif (randomHeli == 2) then
			_aircrafttype = "AH-64A"

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

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "standard"
				else
					_skin = "standard dirty"
				end

				_fullname = "USA AH-64A - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.ISRAEL
				_skin = "ah-64_a_green isr"
				_fullname = "ISRAEL AH-64A - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.THE_NETHERLANDS
				_skin = "ah-64_a_green neth"
				_fullname = "THE_NETHERLANDS AH-64A - " .. _skin
			else
				_country = country.id.UK
				_skin = "ah-64_a_green uk"
				_fullname = "UK AH-64A - " .. _skin
			end

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
			}
		elseif (randomHeli == 3) then
			_aircrafttype = "AH-64D"

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

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.USA
				_skin = "standard"
				_fullname = "USA AH-64D - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.ISRAEL
				_skin = "ah-64_d_isr"
				_fullname = "ISRAEL AH-64D - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.THE_NETHERLANDS
				_skin = "ah-64_d_green neth"
				_fullname = "THE_NETHERLANDS AH-64D - " .. _skin
			else
				_country = country.id.UK
				_skin = "ah-64_d_green uk"
				_fullname = "UK AH-64D - " .. _skin
			end

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
			}
		elseif (randomHeli == 4) then
			_aircrafttype = "CH-47D"

			subtype = math.random(1,5)
			if (subtype == 1) then
				_country = country.id.USA
				_skin = "standard"
				_fullname = "USA CH-47D - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = "Australia RAAF"
				_fullname = "AUSTRALIA CH-47D - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.SPAIN
				_skin = "ch-47_green spain"
				_fullname = "SPAIN CH-47D - " .. _skin
			elseif (subtype == 4) then
				_country = country.id.THE_NETHERLANDS
				_skin = "ch-47_green neth"
				_fullname = "THE_NETHERLANDS CH-47D - " .. _skin
			else
				_country = country.id.UK
				_skin = "ch-47_green uk"
				_fullname = "UK CH-47D - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "3600",
				["flare"] = 120,
				["chaff"] = 120,
				["gun"] = 100,
			}
		elseif (randomHeli == 5) then
			_aircrafttype = "CH-53E"
			_country = country.id.USA
			_skin = "standard"
			_fullname = "USA CH-53E - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "1908",
				["flare"] = 60,
				["chaff"] = 60,
				["gun"] = 100,
			}
		elseif (randomHeli == 6) then
			_aircrafttype = "Ka-27"
			_country = country.id.UKRAINE
			_skin = "ukraine camo 1"
			_fullname = "USA Ka-27 - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "2616",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomHeli == 7) then
			_aircrafttype = "Ka-50"
			_country = country.id.USA

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

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "us army"
				elseif (subtype1 == 2) then
					_skin = "us marines 1"
				else
					_skin = "us marines 2"
				end

				_fullname = "USA Ka-50 - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = "Russia Worn Black"
				_fullname = "AUSTRALIA Ka-50 - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.BELGIUM

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "belgium sar"
				elseif (subtype1 == 2) then
					_skin = "belgium camo"
				else
					_skin = "belgium olive"
				end

				_fullname = "BELGIUM Ka-50 - " .. _skin

			elseif (subtype == 4) then
				_country = country.id.CANADA
				_skin = "canadian forces"
				_fullname = "CANADA Ka-50 - " .. _skin
			elseif (subtype == 5) then
				_country = country.id.DENMARK

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "denmark camo"
				else
					_skin = "Denmark navy trainer"
				end

				_fullname = "DENMARK Ka-50 - " .. _skin

			elseif (subtype == 6) then
				_country = country.id.FRANCE

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "France Armee de Terre 1"
				elseif (subtype1 == 2) then
					_skin = "France Armee de Terre 2"
				else
					_skin = "France Armee de Terre Desert"
				end

				_fullname = "FRANCE Ka-50 - " .. _skin

			elseif (subtype == 7) then
				_country = country.id.GEORGIA
				_skin = "georgia camo"
				_fullname = "GEORGIA Ka-50 - " .. _skin
			elseif (subtype == 8) then
				_country = country.id.GERMANY

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "german 8320"
				else
					_skin = "german 8332"
				end

				_fullname = "GERMANY Ka-50 - " .. _skin

			elseif (subtype == 9) then
				_country = country.id.ISRAEL

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Israel IAF camo 1"
				elseif (subtype1 == 2) then
					_skin = "Israel IAF camo 2"
				else
					_skin = "Israel IAF camo 3"
				end

				_fullname = "ISRAEL Ka-50 - " .. _skin

			elseif (subtype == 10) then
				_country = country.id.ITALY

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Italy Aeronautica Militare"
				else
					_skin = "Italy Esercito Italiano"
				end

				_fullname = "ITALY Ka-50 - " .. _skin

			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_skin = "norway camo"
				_fullname = "NORWAY Ka-50 - " .. _skin
			elseif (subtype == 12) then
				_country = country.id.SPAIN

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Spain SAA Arido"
				elseif (subtype1 == 2) then
					_skin = "Spain SAA Boscoso"
				else
					_skin = "Spain SAA Standard"
				end

				_fullname = "SPAIN Ka-50 - " .. _skin

			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Netherlands RNAF"
				else
					_skin = "Netherlands RNAF wooded"
				end

				_fullname = "THE_NETHERLANDS Ka-50 - " .. _skin

			elseif (subtype == 14) then
				_country = country.id.UK
				_skin = "uk camo"
				_fullname = "UK Ka-50 - " .. _skin
			else
				_country = country.id.UKRAINE

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Ukraine Demo"
				elseif (subtype1 == 2) then
					_skin = "ukraine camo 1"
				else
					_skin = "ukraine camo 1 dirt"
				end

				_fullname = "UKRAINE Ka-50 - " .. _skin

			end

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
			}
		elseif (randomHeli == 8) then
			_aircrafttype = "Mi-24V"

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GEORGIA
				_skin = "standard"
				_fullname = "GEORGIA Mi-24V - " .. _skin
			else
				_country = country.id.UKRAINE

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Ukraine UN"
				else
					_skin = "ukraine"
				end

				_fullname = "UKRAINE Mi-24V - " .. _skin

			end

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
			}
		elseif (randomHeli == 9) then
			_aircrafttype = "Mi-26"
			_country = country.id.UKRAINE

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "7th Separate Brigade of AA (Kalinov)"
			else
				_skin = "United Nations"
			end

			_fullname = "UKRAINE Mi-26 - " .. _skin

			_payload = {
				["pylons"] =
				{
				},
				["fuel"] = "9600",
				["flare"] = 192,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomHeli == 10) then
			_aircrafttype = "Mi-8MT"

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

			subtype = math.random(1,14)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "USA_AFG"
				elseif (subtype1 == 2) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "USA Mi-8MT - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.BELGIUM
				_skin = "Belgium"
				_fullname = "BELGIUM Mi-8MT - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.CANADA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Canada"
				elseif (subtype1 == 2) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "CANADA Mi-8MT - " .. _skin

			elseif (subtype == 4) then
				_country = country.id.DENMARK
				_skin = "Denmark"
				_fullname = "DENMARK Mi-8MT - " .. _skin
			elseif (subtype == 5) then
				_country = country.id.FRANCE

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "France ARMY"
				elseif (subtype1 == 2) then
					_skin = "France NAVY"
				elseif (subtype1 == 3) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "FRANCE Mi-8MT - " .. _skin

			elseif (subtype == 6) then
				_country = country.id.GEORGIA
				_skin = "Georgia"
				_fullname = "GEORGIA Mi-8MT - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.GERMANY

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Germany"
				elseif (subtype1 == 2) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "GERMANY Mi-8MT - " .. _skin

			elseif (subtype == 8) then
				_country = country.id.ISRAEL

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Israel"
				elseif (subtype1 == 2) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "ISRAEL Mi-8MT - " .. _skin

			elseif (subtype == 9) then
				_country = country.id.ITALY

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "Italy ARMY"
				elseif (subtype1 == 2) then
					_skin = "Italy NAVY"
				elseif (subtype1 == 3) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "ITALY Mi-8MT - " .. _skin

			elseif (subtype == 10) then
				_country = country.id.NORWAY

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Norway"
				elseif (subtype1 == 2) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "NORWAY Mi-8MT - " .. _skin

			elseif (subtype == 11) then
				_country = country.id.SPAIN

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Spain"
				elseif (subtype1 == 2) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "SPAIN Mi-8MT - " .. _skin

			elseif (subtype == 12) then
				_country = country.id.THE_NETHERLANDS

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "Netherlands ARMY"
				elseif (subtype1 == 2) then
					_skin = "Netherlands NAVY"
				elseif (subtype1 == 3) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "THE_NETHERLANDS Mi-8MT - " .. _skin

			elseif (subtype == 13) then
				_country = country.id.UK

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "United Kingdom"
				elseif (subtype1 == 2) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "UK Mi-8MT - " .. _skin

			else
				_country = country.id.UKRAINE
				_skin = "Standard"
				_fullname = "UKRAINE Mi-8MT - " .. _skin
			end

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
			}
		elseif (randomHeli == 11) then
			_aircrafttype = "OH-58D"
			_country = country.id.USA
			_task = "AFAC"
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
			}
			_skin = ""
			_fullname = "USA OH-58D"
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
			}
		elseif (randomHeli == 12) then
			_aircrafttype = "SH-60B"
			_country = country.id.USA
			_task = "Antiship Strike"
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
			}
			_skin = "standard"
			_fullname = "USA SH-60B - " .. _skin
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
			}
		elseif (randomHeli == 13) then
			_aircrafttype = "UH-1H"

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

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,12)
				if (subtype1 == 1) then
					_skin = "Army Standard"
				elseif (subtype1 == 2) then
					_skin = "[Civilian] Standard"
				elseif (subtype1 == 3) then
					_skin = "US ARMY 1972"
				elseif (subtype1 == 4) then
					_skin = "US DOS"
				elseif (subtype1 == 5) then
					_skin = "US Ft. Rucker"
				elseif (subtype1 == 6) then
					_skin = "US NAVY"
				elseif (subtype1 == 7) then
					_skin = "USA Red Flag"
				elseif (subtype1 == 8) then
					_skin = "USA UN"
				elseif (subtype1 == 9) then
					_skin = "XW-PFJ Air America"
				elseif (subtype1 == 10) then
					_skin = "[Civilian] Medical"
				elseif (subtype1 == 11) then
					_skin = "[Civilian] NASA"
				else
					_skin = "[Civilian] VIP"
				end

				_fullname = "USA UH-1H - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Australia RAAF 171 Sqn"
				elseif (subtype1 == 2) then
					_skin = "Australia RAAF 1968"
				else
					_skin = "Australia Royal Navy"
				end

				_fullname = "AUSTRALIA UH-1H - " .. _skin

			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_skin = "[Civilian] Standard"
				_fullname = "BELGIUM UH-1H - " .. _skin
			elseif (subtype == 4) then
				_country = country.id.CANADA
				_skin = "Canadian Force"
				_fullname = "CANADA UH-1H - " .. _skin
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_skin = "[Civilian] Standard"
				_fullname = "DENMARK UH-1H - " .. _skin
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_skin = "French Army"
				_fullname = "FRANCE UH-1H - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.GEORGIA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Georgian AF Camo"
				else
					_skin = "Georgian Air Force"
				end

				_fullname = "GEORGIA UH-1H - " .. _skin

			elseif (subtype == 8) then
				_country = country.id.GERMANY
				_skin = "Luftwaffe"
				_fullname = "GERMANY UH-1H - " .. _skin
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_skin = "Israel Army"
				_fullname = "ISRAEL UH-1H - " .. _skin
			elseif (subtype == 10) then
				_country = country.id.ITALY

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Italy 15B Stormo S.A.R -Soccorso"
				elseif (subtype1 == 2) then
					_skin = "Italy E.I. 4B Regg. ALTAIR"
				else
					_skin = "Italy Marina Militare s.n. 80951 7-20"
				end

				_fullname = "ITALY UH-1H - " .. _skin

			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_skin = "[Civilian] Standard"
				_fullname = "NORWAY UH-1H - " .. _skin
			elseif (subtype == 12) then
				_country = country.id.SPAIN

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Spanish Army"
				else
					_skin = "Spanish UN"
				end

				_fullname = "SPAIN UH-1H - " .. _skin

			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_skin = "Royal Netherlands AF"
				_fullname = "THE_NETHERLANDS UH-1H - " .. _skin
			elseif (subtype == 14) then
				_country = country.id.UK
				_skin = "[Civilian] Standard"
				_fullname = "UK UH-1H - " .. _skin
			else
				_country = country.id.UKRAINE
				_skin = "Ukrainian Army"
				_fullname = "UKRAINE UH-1H - " .. _skin
			end

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
			}
		elseif (randomHeli == 14) then
			_aircrafttype = "UH-60A"
			_skin = ""

			subtype = math.random(1,3)
			if (subtype == 1) then
				_country = country.id.USA
				_skin = "standard"
				_fullname = "USA UH-60A - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_fullname = "AUSTRALIA UH-60A"
			else
				_country = country.id.ISRAEL

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "ISRAIL_UN"
				else
					_skin = "standard"
				end

				_fullname = "ISRAEL UH-60A - " .. _skin

			end

			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "1100",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			}
		elseif (randomHeli == 15) then
			_aircrafttype = "AH-1W"
			_country = country.id.TURKEY

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "Turkey 1"
			else
				_skin = "Turkey 2"
			end

			_fullname = "TURKEY AH-1W - " .. _skin

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
			}
		elseif (randomHeli == 16) then
			_aircrafttype = "Ka-27"
			_country = country.id.RUSSIA
			_skin = "standard"
			_fullname = "RUSSIA Ka-27 - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "2616",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomHeli == 17) then
			_aircrafttype = "Ka-50"

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

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,13)
				if (subtype1 == 1) then
					_skin = "Russia Standard Army"
				elseif (subtype1 == 2) then
					_skin = "Russia DOSAAF"
				elseif (subtype1 == 3) then
					_skin = "Russia Demo #024"
				elseif (subtype1 == 4) then
					_skin = "Russia Demo #22 `Black Shark`"
				elseif (subtype1 == 5) then
					_skin = "Russia Demo `Werewolf`"
				elseif (subtype1 == 6) then
					_skin = "Russia fictional desert scheme"
				elseif (subtype1 == 7) then
					_skin = "Russia Fictional Olive Grey"
				elseif (subtype1 == 8) then
					_skin = "Russia Fictional Snow Splatter"
				elseif (subtype1 == 9) then
					_skin = "Russia Fictional Swedish"
				elseif (subtype1 == 10) then
					_skin = "Russia Fictional Tropic Green"
				elseif (subtype1 == 11) then
					_skin = "Russia New Year"
				elseif (subtype1 == 12) then
					_skin = "Russia Standard Army (Worn)"
				else
					_skin = "Russia Worn Black"
				end

				_fullname = "RUSSIA Ka-50 - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_skin = "Abkhazia 1"
				_fullname = "ABKHAZIA Ka-50 - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.SOUTH_OSETIA
				_skin = "South Ossetia 1"
				_fullname = "SOUTH_OSETIA Ka-50 - " .. _skin
			else
				_country = country.id.TURKEY

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "Turkey Fictional Light Gray"
				elseif (subtype1 == 2) then
					_skin = "Turkey Fictional 1"
				elseif (subtype1 == 3) then
					_skin = "Turkey Fictional"
				else
					_skin = "Turkey fictional desert scheme"
				end

				_fullname = "TURKEY Ka-50 - " .. _skin

			end

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
			}
		elseif (randomHeli == 18) then
			_aircrafttype = "Mi-24V"

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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "standard 1"
				elseif (subtype1 == 2) then
					_skin = "standard 2 (faded and sun-bleached)"
				elseif (subtype1 == 3) then
					_skin = "Russia_FSB"
				else
					_skin = "Russia_MVD"
				end

				_fullname = "RUSSIA Mi-24V - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_skin = "Abkhazia"
				_fullname = "ABKHAZIA Mi-24V - " .. _skin
			else
				_country = country.id.SOUTH_OSETIA
				_skin = "South Ossetia"
				_fullname = "SOUTH_OSETIA Mi-24V - " .. _skin
			end

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
			}
		elseif (randomHeli == 19) then
			_aircrafttype = "Mi-26"
			_country = country.id.RUSSIA

			subtype = math.random(1,4)
			if (subtype == 1) then
				_skin = "RF Air Force"
			elseif (subtype == 2) then
				_skin = "Russia_FSB"
			elseif (subtype == 3) then
				_skin = "Russia_MVD"
			else
				_skin = "United Nations"
			end

			_fullname = "RUSSIA Mi-26 - " .. _skin

			_payload = {
				["pylons"] =
				{
				},
				["fuel"] = "9600",
				["flare"] = 192,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomHeli == 20) then
			_aircrafttype = "Mi-28N"
			_country = country.id.RUSSIA
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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "night"
			else
				_skin = "standard"
			end

			_fullname = "RUSSIA Mi-28N - " .. _skin

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
			}
		elseif (randomHeli == 21) then
			_aircrafttype = "Mi-8MT"

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

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,12)
				if (subtype1 == 1) then
					_skin = "Russia_VVS_Grey"
				elseif (subtype1 == 2) then
					_skin = "Russia_VVS_Standard"
				elseif (subtype1 == 3) then
					_skin = "Russia_VVS_Standart"
				elseif (subtype1 == 4) then
					_skin = "Russia_FSB"
				elseif (subtype1 == 5) then
					_skin = "Russia_MVD_Mozdok"
				elseif (subtype1 == 6) then
					_skin = "Russia_MVD_Standard"
				elseif (subtype1 == 7) then
					_skin = "Russia_MVD_Standart"
				elseif (subtype1 == 8) then
					_skin = "Russia_UN"
				elseif (subtype1 == 9) then
					_skin = "Russia_Army_Weather"
				elseif (subtype1 == 10) then
					_skin = "Russia_Naryan-Mar"
				elseif (subtype1 == 11) then
					_skin = "Russia_Police"
				else
					_skin = "Russia_UTair"
				end

				_fullname = "RUSSIA Mi-8MT - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_skin = "Abkhazia"
				_fullname = "ABKHAZIA Mi-8MT - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.SOUTH_OSETIA
				_skin = "South Ossetia"
				_fullname = "SOUTH_OSETIA Mi-8MT - " .. _skin
			else
				_country = country.id.TURKEY

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Turkey"
				elseif (subtype1 == 2) then
					_skin = "Standard"
				else
					_skin = "Standart"
				end

				_fullname = "TURKEY Mi-8MT - " .. _skin
			end

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
			}
		elseif (randomHeli == 22) then
			_aircrafttype = "UH-1H"

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

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "RF Air Force Broken"
				else
					_skin = "RF Air Force Grey"
				end

				_fullname = "RUSSIA UH-1H - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_skin = "[Civilian] Standard"
				_fullname = "ABKHAZIA UH-1H - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.SOUTH_OSETIA
				_skin = "[Civilian] Standard"
				_fullname = "SOUTH_OSETIA UH-1H - " .. _skin
			else
				_country = country.id.TURKEY
				_skin = "Turkish Air Force"
				_fullname = "TURKEY UH-1H - " .. _skin
			end

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
			}
		elseif (randomHeli == 23) then
			_aircrafttype = "UH-60A"
			_country = country.id.TURKEY
			_skin = "standard"
			_fullname = "TURKEY UH-60A - " .. _skin
			_payload =
			{
				["pylons"] =
				{
				},
				["fuel"] = "1100",
				["flare"] = 30,
				["chaff"] = 30,
				["gun"] = 100,
			}
		end
	end

	-- Randomize the fuel load
	if (flgRandomFuel) then
		_payload.fuel = math.random(_payload.fuel * 0.1, _payload.fuel)
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

	-- Build up sim callsign
	if ((_country == country.id.RUSSIA) or (_country == country.id.ABKHAZIA) or (_country == country.id.SOUTH_OSETIA) or (_country == country.id.UKRAINE)) then
		_callsign = nameCoalition[coalitionIndex] .. "1"
	else
		local a = math.random(1,#nameCallname)
		local b = math.random(1,9)
		_callsign = nameCallname[a] .. b .. "1"
		_callname =
			{
				[1] = a,
				[2] = b,
				[3] = 1,
				["name"] = _callsign,
			}
	end


	_spawnairdromeId = spawnIndex.id
	_spawnairbaseloc = Object.getPoint({id_=spawnIndex.id_})
	_spawnairplanepos = {}
	_spawnairplanepos.x = _spawnairbaseloc.x
	_spawnairplanepos.z = _spawnairbaseloc.z
	_spawnairplaneparking = math.random(1,40)

	_waypointtype = parkingT[1]
	_waypointaction = parkingT[2]

	_landairbaseID = landIndex.id
	_landairbaseloc = Object.getPoint({id_=landIndex.id_})
	_landairplanepos = {}
	_landairplanepos.x = _landairbaseloc.x
	_landairplanepos.z = _landairbaseloc.z

	-- Compute single intermediate waypoint based on used-defined minimum deviation x/z range
	local _waypoint = {}
	_waypoint.dist = math.sqrt((_spawnairbaseloc.x - _landairbaseloc.x) * (_spawnairbaseloc.x - _landairbaseloc.x) + (_spawnairbaseloc.z - _landairbaseloc.z) * (_spawnairbaseloc.z - _landairbaseloc.z))
	if ((_waypoint.dist / 2) < waypointRange[1]) then
		_waypoint.distx = waypointRange[1]
	else
		_waypoint.distx = _waypoint.dist / 2
	end
	if ((_waypoint.dist / 2) < waypointRange[2]) then
		_waypoint.distz = waypointRange[2]
	else
		_waypoint.distz = _waypoint.dist / 2
	end
	_waypoint.x = _spawnairbaseloc.x + math.random(- _waypoint.distx, _waypoint.distx)
	_waypoint.z = _spawnairbaseloc.z + math.random(- _waypoint.distz, _waypoint.distz)

	_groupname = nameP .. nameCoalition[coalitionIndex]

	_airplanedata =
	{
        ["modulation"] = 0,
		["tasks"] =
			{
			},
		["task"] = _task,
		["uncontrolled"] = false,
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
					["speed"] = 0,
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
				[2] =
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
				},
				[3] =
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
				},
			},
		},
		["groupId"] = nameCoalition[coalitionIndex],
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
				["name"] =  _groupname.."1",
				["callsign"] = _callname,
				["payload"] = _payload,
				["speed"] = 0,
				["unitId"] =  math.random(9999,99999),
				["alt_type"] = "RADIO",
				["skill"] = _skill,
			},
		},
		["y"] = _spawnairplanepos.z,
		["x"] = _spawnairplanepos.x,
		["name"] =  _groupname,
		["communication"] = true,
		["start_time"] = 0,
		["frequency"] = 124,
	}

	if (AircraftType == 1 or AircraftType == 3) then
		coalition.addGroup(_country, Group.Category.AIRPLANE, _airplanedata)
	else
		coalition.addGroup(_country, Group.Category.HELICOPTER, _airplanedata)
	end

	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  callsign:' .. _callsign .. '  #red:' .. numCoalition[1] .. '  #blue:' .. numCoalition[2] .. '  fullname:' .. _fullname, false) end
	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  spawn:' .. spawnIndex.name .. '  land:' .. landIndex.name .. '  altitude:' .. _flightalt .. '  speed:' .. _flightspeed, false) end
--	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  spawnpos.x:' .. _spawnairplanepos.x .. '  waypoint.x:' .. _waypoint.x .. '  landpos.x' .. _landairplanepos.x .. '  spawnpos.z:' .. _spawnairplanepos.z .. '  waypoint.z:' .. _waypoint.z .. '  landpos.z:' .. _landairplanepos.z, false) end
--	if (debugLog) then env.info('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  delta.x:' .. _spawnairplanepos.x - _waypoint.x .. '  delta.z:' .. _spawnairplanepos.z - _waypoint.z, false) end
	if (debugScreen) then trigger.action.outText('group:' .. _airplanedata.name .. '  type:' .. _aircrafttype .. '  callsign:' .. _callsign .. '  #red:' .. numCoalition[1] .. '  #blue:' .. numCoalition[2] .. '  _fullname:' .. _fullname .. '  spawn:' .. spawnIndex.name .. '  land:' .. landIndex.name .. '  altitude:' .. _flightalt .. '  speed:' .. _flightspeed, 10) end

	RATtable[#RATtable+1] =
	{
		groupname = _groupname,
		unitname1 = _groupname.."1",
		unitname2 = "none",
		flightname = _fullname,
		actype = _aircrafttype,
		origin = spawnIndex.name,
		destination = landIndex.name,
		counter = groupcounter,
		coalition = coalitionIndex,
		--size = groupsize,
		size = 1,
		checktime = 0,
		status = "taxiing"
	}
end

function removeGroup (indeX, messagE, destroyflaG, aircraftgrouP)
	if (debugLog) then env.info('group:' .. RATtable[indeX].groupname .. '  type:' .. RATtable[indeX].actype .. messagE, false) end
	if (debugScreen) then trigger.action.outText('group:' .. RATtable[indeX].groupname .. '  type:' .. RATtable[indeX].actype .. messagE, 20) end
	if (numCoalition[RATtable[indeX].coalition] > 0) then
		numCoalition[RATtable[indeX].coalition] = numCoalition[RATtable[indeX].coalition] - 1	-- Make sure to account for groups that become missing from the sim outside of script control
	end
	table.remove(RATtable, indeX)	-- Group does not exist any longer for this script
	if (destroyflaG) then aircraftgrouP:destroy() end
end

-- Periodically check all dynamically spawned AI units for existence, wandering, damage, and stuck/parked
function checkStatus()
	if (#RATtable > 0)
	then
		local RATtableLimit = #RATtable	 -- Array size may change while loop is running due to removing group
		local i = 1
		while (i <= RATtableLimit)
		do
			if (i <= RATtableLimit) then
				local currentaircraftgroup = Group.getByName(RATtable[i].groupname)
				if (currentaircraftgroup) == nil then		-- This group does not exist, yet (just now spawning) OR removed by sim (crash or kill)
					if (RATtable[i].checktime > 0) then		-- Have we checked this group yet? (should have spawned by now)
						removeGroup(i, "  removed by sim, not script", false, nil)
						RATtableLimit = RATtableLimit - 1	-- Array shrinks
					else
						i = i + 1
					end
				else -- Valid group, make checks
					if (RATtable[i].checktime > waitTime) then -- This group hasn't moved in a very long time
						removeGroup(i, "  removed due to low speed", true, currentaircraftgroup)
						RATtableLimit = RATtableLimit - 1
					else -- Active group
						local currentunitname1 = RATtable[i].unitname1
						if (Unit.getByName(currentunitname1) ~= nil) then -- Valid, active unit
							local actualunit = Unit.getByName(currentunitname1)
							local lowerstatuslimit = minDamagedLife * actualunit:getLife0() -- Was 0.95. changed to 0.10
							local actualunitpos = actualunit:getPosition().p
							local actualunitheight = actualunitpos.y - land.getHeight({x = actualunitpos.x, y = actualunitpos.z})
							if ((actualunitpos.x > 100000) or (actualunitpos.x < -500000) or (actualunitpos.z > 1100000) or (actualunitpos.z < 200000)) then
								removeGroup(i, "  removed due to wandering", true, Unit.getGroup(actualunit))
								RATtableLimit = RATtableLimit - 1
							elseif ((actualunitheight < minDamagedHeight) and (actualunit:getLife() <= lowerstatuslimit)) then -- check for damaged unit
								removeGroup(i, "  removed due to damage", true, Unit.getGroup(actualunit))
								RATtableLimit = RATtableLimit - 1
							else -- Valid unit, check for movement
								local actualunitvel = actualunit:getVelocity()
								local absactualunitvel = math.abs(actualunitvel.x) + math.abs(actualunitvel.y) + math.abs(actualunitvel.z)

								if absactualunitvel > 4 then
									RATtable[i].checktime = 0 -- If it's moving, reset checktime
								end
								RATtable[i].checktime = RATtable[i].checktime + 1
								i = i + 1
							end
						end
					end
				end
			end
		end
	end
end

function chooseAirbase(AF)
	airbaseChoice = math.random(1, #AF)
return AF[airbaseChoice]
end

function generateGroup()
	local lowVal
	local highVal
	local coalitionSide
	local airbaseSpawn
	local airbaseLand
	local i
	local parkingType

	-- Choose which coalition side to possibly spawn new aircraft
	if (#redAF > 0) then
		lowVal = 1
	else
		lowVal = 2
	end

	if (#blueAF > 0) then
		highVal = 2
	else
		highVal = 1
	end

	if (lowVal > highVal) then  -- No coalition bases defined at all!
		return
	end

	coalitionSide = math.random(lowVal, highVal)  -- Choose which side to spawn unit this time

	if (numCoalition[coalitionSide] < maxCoalition[coalitionSide]) then  -- Is ok to spawn a new unit?

		numCoalition[coalitionSide] = numCoalition[coalitionSide] + 1
		nameCoalition[coalitionSide] = nameCoalition[coalitionSide] + 1

		i = math.random(1, 3)
		if (i == 1) then
			parkingType = {"TakeOffParking", "From Parking Area"}
		elseif (i == 2) then
			parkingType = {"TakeOffParkingHot", "From Parking Area Hot"}
		else
			parkingType = {"TakeOff", "From Runway"}
		end

		if (coalitionSide == 1) then
			airbaseSpawn = chooseAirbase(redAF)
			airbaseLand = chooseAirbase(redAF)
		else
			airbaseSpawn = chooseAirbase(blueAF)
			airbaseLand = chooseAirbase(blueAF)
		end

		-- Create new aircraft
		generateAirplane(coalitionSide, airbaseSpawn, airbaseLand, parkingType, NamePrefix[coalitionSide])
	end
end


-- Names of red bases
redAF = getAFBases(1)
if (#redAF < 1) then
	env.warning("There are no red bases in this mission.", false)
end

-- Names of blue bases
blueAF = getAFBases(2)
if (#blueAF < 1) then
	env.warning("There are no blue bases in this mission.", false)
end

Spawntimer = mist.scheduleFunction(generateGroup, {}, timer.getTime() + 2, intervall)
Spawntimer = mist.scheduleFunction(checkStatus, {}, timer.getTime() + 4, intervall)

end
