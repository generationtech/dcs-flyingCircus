-- Randomly spawn a different kind of aircraft at different coalition airbase up to a limit of total spawned aircraft.
-- In the ME, just designate each coalition airbase assignment on the ME airbase object, not with target zones

do
--EDIT BELOW
intervall = math.random(60,300) 	--random repeat interval between (A and B) in seconds
maxCoalition = {20, 20} 	-- maximum number of red, blue units
NamePrefix = {"Red-", "Blue-"}
numCoalition = {0, 0} -- number of active Red, Blue dynamic spawned units

-- determine the bases based on a coalition parameter
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

-- create a new aircraft based on coalition, airbase, parking type, and name prefix
function generateAirplane(coalitionIndex, spawnIndex, landIndex, parkingT, nameP)

	AircraftType = math.random(1,3) --random for airplane, heli or fighter

	if (AircraftType == 1) then
		if (coalitionIndex == 1) then
			randomAirplane = math.random(10,18) -- random for airplane type; Russian AC 10-18
		else
			randomAirplane = math.random(1,9) -- random for airplane type; Russian AC 10-18
		end

		if (randomAirplane == 1) then
			_aircrafttype = "C-17A"
			_skin = "usaf standard"
			_payload =  {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "132405",
			["flare"] = 60,
			["chaff"] = 120,
			["gun"] = 100,
			}
			_country = country.id.USA
			callsign = "BASCO"

		elseif (randomAirplane == 2) then
			_aircrafttype = "B-52H"
			_skin = "usaf standard"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
			}, -- end of [1]
			[3] =
			{
			["CLSID"] = "{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
			}, -- end of [3]
			}, -- end of ["pylons"]
			["fuel"] = "141135",
			["flare"] = 192,
			["chaff"] = 1125,
			["gun"] = 100,
			}
			_country = country.id.USA
			callsign = "DOOM"

		elseif (randomAirplane == 3) then
			_aircrafttype = "E-3A"
			_skin = "nato"
			_payload ={
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "65000",
			["flare"] = 60,
			["chaff"] = 120,
			["gun"] = 100,
			}
			_country = country.id.USA
			callsign = "MAGIC"

		elseif (randomAirplane == 4) then
			_aircrafttype = "KC-135"
			_skin = "Standard USAF"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = 90700,
			["flare"] = 60,
			["chaff"] = 120,
			["gun"] = 100,
			}
			_country = country.id.USA
			callsign = "TEXACO"

		elseif (randomAirplane == 5) then
			_aircrafttype = "C-130"
			_skin = "US Air Force"
			_payload =   {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "20830",
			["flare"] = 60,
			["chaff"] = 120,
			["gun"] = 100,
			}
			_country = country.id.USA
			callsign = "REACH"

		elseif (randomAirplane == 6) then
			_aircrafttype = "S-3B"
			_skin = "usaf standard"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "5500",
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			_country = country.id.USA
			callsign = "TOPCAT"

		elseif (randomAirplane == 7) then
			_aircrafttype = "E-2C"
			_skin = "VAW-125 Tigertails"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "5624",
			["flare"] = 60,
			["chaff"] = 120,
			["gun"] = 100,
			}
			_country = country.id.USA
			callsign = "WOLF"

		elseif (randomAirplane == 8) then
			_aircrafttype = "S-3B Tanker"
			_skin = "usaf standard"
			_payload ={
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "5500",
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			_country = country.id.USA
			callsign = "MAULER"

		elseif (randomAirplane == 9) then
			_aircrafttype = "Yak-40"
			_skin = "Georgian Airlines"
			_payload =  {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "3080",
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
			}
			_country = country.id.GEORGIA
			callsign = "GEORGIAN AIRWAYS"

		elseif (randomAirplane == 10) then
			_aircrafttype = "IL-76MD"
			_skin = "MVD aeroflot"
			_payload =  {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "80000",
			["flare"] = 96,
			["chaff"] = 96,
			["gun"] = 100,
			}
			_country = country.id.RUSSIA
			callsign = "ROSBALT"

		elseif (randomAirplane == 11) then
			_aircrafttype = "IL-78M"
			_skin = "RF Air Force aeroflot"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "90000",
			["flare"] = 96,
			["chaff"] = 96,
			["gun"] = 100,
			}
			_country = country.id.RUSSIA
			callsign = "RFF"

		elseif (randomAirplane == 12) then
			_aircrafttype = "An-26B"
			_skin = "RF Air Force"
			_payload =	{
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "5500",
			["flare"] = 384,
			["chaff"] = 384,
			["gun"] = 100,
			}
			_country = country.id.RUSSIA
			callsign = "RFF"

		elseif (randomAirplane == 13) then
			_aircrafttype = "An-30M"
			_skin = "RF Air Force"
			_payload =  {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "8300",
			["flare"] = 192,
			["chaff"] = 192,
			["gun"] = 100,
			}
			_country = country.id.RUSSIA
			callsign = "RFF"

		elseif (randomAirplane == 14) then
			_aircrafttype = "A-50"
			_skin = "RF Air Force new"
			_payload =	{
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "70000",
			["flare"] = 192,
			["chaff"] = 192,
			["gun"] = 100,
			}
			_country = country.id.RUSSIA
			callsign = "RFF"

		elseif (randomAirplane == 15) then
			_aircrafttype = "An-26B"
			_skin = "Aeroflot"
			_payload =  {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "5500",
			["flare"] = 384,
			["chaff"] = 384,
			["gun"] = 100,
			}
			_country = country.id.RUSSIA
			callsign = "RFF"

		elseif (randomAirplane == 16) then
			_aircrafttype = "Yak-40"
			_skin = "Aeroflot"
			_payload =  {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "3080",
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
			}
			_country = country.id.RUSSIA
			callsign = "ROSBALT"

		elseif (randomAirplane == 17) then
			_aircrafttype = "Tu-142"
			_skin = "af standard"
			_payload =  {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{C42EE4C3-355C-4B83-8B22-B39430B8F4AE}",
			}, -- end of [1]
			}, -- end of ["pylons"]
			["fuel"] = "87000",
			["flare"] = 48,
			["chaff"] = 48,
			["gun"] = 100,
			}
			_country = country.id.RUSSIA
			callsign = "RFF"

		elseif (randomAirplane == 18) then
			_aircrafttype = "Tu-95MS"
			_skin = "af standard"
			_payload =  {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{0290F5DE-014A-4BB1-9843-D717749B1DED}",
			}, -- end of [1]
			}, -- end of ["pylons"]
			["fuel"] = "87000",
			["flare"] = 48,
			["chaff"] = 48,
			["gun"] = 100,
			}
			_country = country.id.RUSSIA
			callsign = "RFF"
		end

	elseif (AircraftType == 2) then
		if (coalitionIndex == 1) then
			randomHeli = math.random(13,18) -- random for airplane type; Russian AC 13-18
		else
			randomHeli = math.random(1,12) -- random for airplane type; USA AC 1-12
		end

		if (randomHeli == 1) then
			_aircrafttype = "UH-1H"
			_country = country.id.USA
			_skin = "US NAVY"
			_payload ={
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "M134_L",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "XM158_MK5",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "XM158_MK5",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "M134_R",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = "631",
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "MUSSEL"

		elseif (randomHeli == 2) then
			_aircrafttype = "CH-47D"
			_country = country.id.USA
			_skin = "standard"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "3600",
			["flare"] = 120,
			["chaff"] = 120,
			["gun"] = 100,
			}
			callsign = "ARMY76"

		elseif (randomHeli == 3) then
			aircrafttype = "CH-53E"
			_country = country.id.USA
			_skin = "standard"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "1908",
			["flare"] = 60,
			["chaff"] = 60,
			["gun"] = 100,
			}
			callsign = "NAZGUL"

		elseif (randomHeli == 4) then
			_aircrafttype = "SH-60B"
			_country = country.id.USA
			_skin = "standard"
			_payload ={
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{7B8DCEB4-820B-4015-9B48-1028A4195692}",
			}, -- end of [1]
			}, -- end of ["pylons"]
			["fuel"] = "1100",
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "NAVY TANGO TANGO"

		elseif (randomHeli == 5) then
			aircrafttype = "UH-60A"
			_country = country.id.USA
			_skin = "standard"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "1100",
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "ARMY49"

		elseif (randomHeli == 6) then
			_aircrafttype = "OH-58D"
			_country = country.id.USA
			_skin = "standard"
			_payload ={
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "M260_HYDRA_WP",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "M260_HYDRA_WP",
			}, -- end of [2]
			}, -- end of ["pylons"]
			["fuel"] = 715,
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "ARMY921"

		elseif (randomHeli == 7) then
			_aircrafttype = "AH-64D"
			_country = country.id.USA
			_skin = "standard"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = "1157",
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "OUTCAST"

		elseif (randomHeli == 8) then
			_aircrafttype = "AH-64A"
			_country = country.id.USA
			_skin = "standard dirty"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{FD90A1DC-9147-49FA-BF56-CB83EF0BD32B}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{88D18A5E-99C8-4B04-B40B-1C02F2018B6E}",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = "1157",
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "SHADOWS"

		elseif (randomHeli == 9) then
			_aircrafttype = "AH-1W"
			_country = country.id.USA
			_skin = "USA Marines"
			_payload = {
			["pylons"] =
			{
			[2] =
			{
			["CLSID"] = "M260_HYDRA",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "M260_HYDRA",
			}, -- end of [3]
			}, -- end of ["pylons"]
			["fuel"] = 1250,
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "ATLAS"

		elseif (randomHeli == 10) then
			_aircrafttype = "UH-1H"
			_country = country.id.GEORGIA
			_skin = "Georgian Air Force"
			_payload =  {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "M134_L",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "XM158_MK5",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "XM158_MK5",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "M134_R",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = "631",
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "GA49"

		elseif (randomHeli == 11) then
			_aircrafttype = "Mi-8MT"
			_country = country.id.GEORGIA
			_skin = "Georgia"
			_payload ={
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "2073",
			["flare"] = 192,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "GA152"

		elseif (randomHeli == 12) then
			_aircrafttype = "Mi-24V"
			_country = country.id.GEORGIA
			_skin = "standard"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
			}, -- end of [2]
			[6] =
			{
			["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
			}, -- end of [6]
			[5] =
			{
			["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
			}, -- end of [5]
			}, -- end of ["pylons"]
			["fuel"] = 1534,
			["flare"] = 192,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "GA989"

		elseif (randomHeli == 13) then
			_aircrafttype = "Mi-26"
			_country = country.id.RUSSIA
			_skin = "Russia_FSB"
			_payload ={
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "9600",
			["flare"] = 192,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "RFF989"

		elseif (randomHeli == 14) then
			_aircrafttype = "Mi-8MT"
			_country = country.id.RUSSIA
			_skin = "Russia_MVD"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "2073",
			["flare"] = 192,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "RFF10"

		elseif (randomHeli == 15) then
			_aircrafttype = "Ka-27"
			_country = country.id.RUSSIA
			_skin = "standard"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "2616",
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "RFF89"

		elseif (randomHeli == 16) then
			_aircrafttype = "Mi-24V"
			_country = country.id.RUSSIA
			_skin = "standard 2 (faded and sun-bleached)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
			}, -- end of [2]
			[6] =
			{
			["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
			}, -- end of [6]
			[5] =
			{
			["CLSID"] = "{B919B0F4-7C25-455E-9A02-CEA51DB895E3}",
			}, -- end of [5]
			}, -- end of ["pylons"]
			["fuel"] = 1534,
			["flare"] = 192,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "RFF263"

		elseif (randomHeli == 17) then
			_aircrafttype = "Mi-28N"
			_country = country.id.RUSSIA
			_skin = "night"
			_payload ={
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
			}, -- end of [1]
			[4] =
			{
			["CLSID"] = "{57232979-8B0F-4db7-8D9A-55197E06B0F5}",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = 1500,
			["flare"] = 128,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "RFF44"

		elseif (randomHeli == 18) then
			_aircrafttype = "Ka-50"
			_country = country.id.RUSSIA
			_skin = "Russia Standard Army (Worn)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{6A4B9E69-64FE-439a-9163-3A87FB6A4D81}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{A6FD14D3-6D30-4C85-88A7-8D17BEE120E2}",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = "1450",
			["flare"] = 128,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "RFF14"
		end

	elseif (AircraftType == 3) then
		if (coalitionIndex == 1) then
			randomFighter = math.random(18,36) -- random for airplane type; Russian AC 18-36
		else
			randomFighter = math.random(1,17) -- random for airplane type; USA AC 1-17
		end

		if (randomFighter == 1) then
			_aircrafttype = "A-10A"
			_skin = "81st FS Spangdahlem AB, Germany (SP) 1"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [5]
			[7] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [10]
			[11] =
			{
			["CLSID"] = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
			}, -- end of [11]
			}, -- end of ["pylons"]
			["fuel"] = 5029,
			["flare"] = 120,
			["ammo_type"] = 1,
			["chaff"] = 240,
			["gun"] = 100,
			}
			_country = country.id.USA
			callsign = "SANDY"

		elseif (randomFighter == 2)	then
			_aircrafttype = "A-10C"
			_country = country.id.USA
			_skin = "23rd TFW England AFB (EL)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [5]
			[7] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
			}, -- end of [10]
			[11] =
			{
			["CLSID"] = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
			}, -- end of [11]
			}, -- end of ["pylons"]
			["fuel"] = 5029,
			["flare"] = 120,
			["ammo_type"] = 1,
			["chaff"] = 240,
			["gun"] = 100,
			}
			callsign = "ENFIELD"

		elseif (randomFighter == 3)	then
			_aircrafttype = "B-1B"
			_country = country.id.USA
			_skin = "usaf standard"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "MK_82*28",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "MK_82*28",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "MK_82*28",
			}, -- end of [3]
			}, -- end of ["pylons"]
			["fuel"] = "88450",
			["flare"] = 30,
			["chaff"] = 60,
			["gun"] = 100,
			}
			callsign = "BONE"

		elseif (randomFighter == 4) then
			_aircrafttype = "F-14A"
			_country = country.id.USA
			_skin = "vf-111 `sundowners`- 1"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [2]
			[4] =
			{
			["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
			}, -- end of [5]
			[8] =
			{
			["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
			}, -- end of [8]
			[11] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [11]
			[12] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [12]
			[9] =
			{
			["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
			}, -- end of [9]
			}, -- end of ["pylons"]
			["fuel"] = "7348",
			["flare"] = 15,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "SALTY DOG"

		elseif (randomFighter == 5) then
			_aircrafttype = "F-15C"
			_country = country.id.USA
			_skin = "58th Fighter SQN (EG)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
			}, -- end of [10]
			[11] =
			{
			["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
			}, -- end of [11]
			}, -- end of ["pylons"]
			["fuel"] = "6103",
			["flare"] = 60,
			["chaff"] = 120,
			["gun"] = 100,
			}
			callsign = "ARROW"

		elseif (randomFighter == 6) then
			_aircrafttype = "F-15E"
			_country = country.id.USA
			_skin = "492d Fighter SQN (LN)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{D078E3E5-30C1-444e-A09E-6EEDCD334582}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
			}, -- end of [10]
			[11] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [11]
			[12] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [12]
			[13] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [13]
			[14] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [14]
			[15] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [15]
			[16] =
			{
			["CLSID"] = "{Mk82AIR}",
			}, -- end of [16]
			[17] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [17]
			[18] =
			{
			["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
			}, -- end of [18]
			[19] =
			{
			["CLSID"] = "{34271A1E-477E-4754-8C72-DF7C1855A782}",
			}, -- end of [19]
			}, -- end of ["pylons"]
			["fuel"] = "6103",
			["flare"] = 60,
			["chaff"] = 120,
			["gun"] = 100,
			}
			callsign = "BONE"

		elseif (randomFighter == 7) then
			_aircrafttype = "F-16A"
			_country = country.id.USA
			_skin = "usaf f16 standard-1"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
			}, -- end of [4]
			[6] =
			{
			["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{C8E06185-7CD6-4C90-959F-044679E90751}",
			}, -- end of [10]
			}, -- end of ["pylons"]
			["fuel"] = "3104",
			["flare"] = 30,
			["chaff"] = 60,
			["gun"] = 100,
			}
			callsign = "CUSTER"

		elseif (randomFighter == 8) then
			_aircrafttype = "F-16C bl.52d"
			_country = country.id.USA
			_skin = "usaf 412th tw (ed) edwards afb"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [2]
			[4] =
			{
			["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
			}, -- end of [4]
			[6] =
			{
			["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{F376DBEE-4CAE-41BA-ADD9-B2910AC95DEC}",
			}, -- end of [7]
			[9] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [10]
			}, -- end of ["pylons"]
			["fuel"] = "3104",
			["flare"] = 45,
			["chaff"] = 90,
			["gun"] = 100,
			}
			callsign = "FLUSH"

		elseif (randomFighter == 9) then
			_aircrafttype = "F-5E"
			_country = country.id.USA
			_skin = "`green` paint scheme"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [7]
			}, -- end of ["pylons"]
			["fuel"] = "2000",
			["flare"] = 15,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "SNIPER"

		elseif (randomFighter == 10) then
			_aircrafttype = "F/A-18C"
			_country = country.id.USA
			_skin = "VFA-94"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{D5D51E24-348C-4702-96AF-97A714E72697}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{EFEC8201-B922-11d7-9897-000476191836}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{6C0D552F-570B-42ff-9F6D-F10D9C1D4E1C}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{EFEC8201-B922-11d7-9897-000476191836}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{EFEC8201-B922-11d7-9897-000476191836}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{D5D51E24-348C-4702-96AF-97A714E72697}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [9]
			}, -- end of ["pylons"]
			["fuel"] = "6531",
			["flare"] = 15,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "HOBO"

		elseif (randomFighter == 11) then
			_aircrafttype = "Tornado GR4"
			_country = country.id.UK
			_skin = "no. 9 squadron raf marham ab (norfolk)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{8C3F26A2-FA0F-11d5-9190-00A0249B6F00}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{E6747967-B1F0-4C77-977B-AB2E6EB0C102}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{E6747967-B1F0-4C77-977B-AB2E6EB0C102}",
			}, -- end of [4]
			[11] =
			{
			["CLSID"] = "{E6747967-B1F0-4C77-977B-AB2E6EB0C102}",
			}, -- end of [11]
			[10] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [10]
			[12] =
			{
			["CLSID"] = "{8C3F26A1-FA0F-11d5-9190-00A0249B6F00}",
			}, -- end of [12]
			[9] =
			{
			["CLSID"] = "{E6747967-B1F0-4C77-977B-AB2E6EB0C102}",
			}, -- end of [9]
			}, -- end of ["pylons"]
			["fuel"] = "4663",
			["flare"] = 45,
			["chaff"] = 90,
			["gun"] = 100,
			}
			callsign = "ROYAL"

		elseif (randomFighter == 12) then
			_aircrafttype = "Tornado IDS"
			_country = country.id.GERMANY
			_skin = "jagdbombergeschwader 32 lechfeld ab luftwaffe"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{8C3F26A1-FA0F-11d5-9190-00A0249B6F00}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
			}, -- end of [4]
			[11] =
			{
			["CLSID"] = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
			}, -- end of [11]
			[10] =
			{
			["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
			}, -- end of [10]
			[12] =
			{
			["CLSID"] = "{8C3F26A2-FA0F-11d5-9190-00A0249B6F00}",
			}, -- end of [12]
			[9] =
			{
			["CLSID"] = "{B06DD79A-F21E-4EB9-BD9D-AB3844618C93}",
			}, -- end of [9]
			}, -- end of ["pylons"]
			["fuel"] = "4663",
			["flare"] = 45,
			["chaff"] = 90,
			["gun"] = 100,
			}
			callsign = "DECK"

		elseif (randomFighter == 13) then
			_aircrafttype = "MiG-29G"
			_country = country.id.GERMANY
			_skin = "luftwaffe gray-2(worn-out)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [7]
			}, -- end of ["pylons"]
			["fuel"] = "3380",
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "POINTER"

		elseif (randomFighter == 14) then
			_aircrafttype = "F-4E"
			_country = country.id.GERMANY
			_skin = "af standard"
			_payload ={
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [4]
			[6] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{9DDF5297-94B9-42FC-A45E-6E316121CD85}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{7B4B122D-C12C-4DB4-834E-4D8BB4D863A8}",
			}, -- end of [9]
			}, -- end of ["pylons"]
			["fuel"] = "4864",
			["flare"] = 30,
			["chaff"] = 60,
			["gun"] = 100,
			}
			callsign = "ICE"

		elseif (randomFighter == 15) then
			_aircrafttype = "L-39ZA"
			_country = country.id.GEORGIA
			_skin = "Georgian Air Force"
			_payload ={
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = 980,
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "GAF24"

		elseif (randomFighter == 16) then
			_aircrafttype = "F-16A MLU"
			_country = country.id.THE_NETHERLANDS
			_skin = "CMD extended skins"
			_payload = {
			["pylons"] =
			{
			}, -- end of ["pylons"]
			["fuel"] = "3104",
			["flare"] = 30,
			["chaff"] = 60,
			["gun"] = 100,
			}
			callsign = "NAF38"

		elseif (randomFighter == 17) then
			_aircrafttype = "Mirage 2000-5"
			_country = country.id.FRANCE
			_skin = "ec1_2 spa3 `cigogne de guynemer`"
			_payload ={
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{414DA830-B61A-4F9E-B71B-C2F6832E1D7A}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{414DA830-B61A-4F9E-B71B-C2F6832E1D7A}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{0DA03783-61E4-40B2-8FAE-6AEE0A5C5AAE}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{6D778860-7BB8-4ACB-9E95-BA772C6BBC2C}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{414DA830-B61A-4F9E-B71B-C2F6832E1D7A}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{FC23864E-3B80-48E3-9C03-4DA8B1D7497B}",
			}, -- end of [9]
			}, -- end of ["pylons"]
			["fuel"] = "3160",
			["flare"] = 16,
			["chaff"] = 112,
			["gun"] = 100,
			}
			callsign = "FAF24"

		elseif (randomFighter == 18) then
			_aircrafttype = "L-39ZA"
			_country = country.id.RUSSIA
			_skin = "Russian Air Force Old"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = 980,
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "RFF214"
		elseif (randomFighter == 19) then
			_aircrafttype = "MiG-23MLD"
			_country = country.id.RUSSIA
			_skin = "af standard-3 (worn-out)"
			_payload = {
			["pylons"] =
			{
			[2] =
			{
			["CLSID"] = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{275A2855-4A79-4B2D-B082-91EA2ADF4691}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{CCF898C9-5BC7-49A4-9D1E-C3ED3D5166A1}",
			}, -- end of [6]
			}, -- end of ["pylons"]
			["fuel"] = "3800",
			["flare"] = 60,
			["chaff"] = 60,
			["gun"] = 100,
			}
			callsign = "RFF154"

		elseif (randomFighter == 20) then
			_aircrafttype = "MiG-25PD"
			_country = country.id.RUSSIA
			_skin = "af standard"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = "15245",
			["flare"] = 64,
			["chaff"] = 64,
			["gun"] = 100,
			}
			callsign = "RFF94"

		elseif (randomFighter == 21) then
			_aircrafttype = "MiG-25RBT"
			_country = country.id.RUSSIA
			_skin = "af standard"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [1]
			[4] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [4]
			}, -- end of ["pylons"]
			["fuel"] = "15245",
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "RFF54"

		elseif (randomFighter == 22) then
			_aircrafttype = "MiG-27K"
			_country = country.id.RUSSIA
			_skin = "af standard"
			_payload = {
			["pylons"] =
			{
			[2] =
			{
			["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
			}, -- end of [8]
			}, -- end of ["pylons"]
			["fuel"] = "4500",
			["flare"] = 60,
			["chaff"] = 60,
			["gun"] = 100,
			}
			callsign = "RFF311"

		elseif (randomFighter == 23) then
			_aircrafttype = "MiG-29A"
			_country = country.id.RUSSIA
			_skin = "33th iap wittstock ab (germany)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [7]
			}, -- end of ["pylons"]
			["fuel"] = "3380",
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "RFF714"

		elseif (randomFighter == 24) then
			_aircrafttype = "MiG-29S"
			_country = country.id.RUSSIA
			_skin = "115th guards regiment, termez ab"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{C0FF4842-FBAC-11d5-9190-00A0249B6F00}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{C0FF4842-FBAC-11d5-9190-00A0249B6F00}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [7]
			}, -- end of ["pylons"]
			["fuel"] = "3500",
			["flare"] = 30,
			["chaff"] = 30,
			["gun"] = 100,
			}
			callsign = "RFF914"

		elseif (randomFighter == 25) then
			_aircrafttype = "MiG-31"
			_country = country.id.RUSSIA
			_skin = "174 GvIAP_Boris Safonov"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{F1243568-8EF0-49D4-9CB5-4DA90D92BC1D}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
			}, -- end of [6]
			}, -- end of ["pylons"]
			["fuel"] = "15500",
			["flare"] = 0,
			["chaff"] = 0,
			["gun"] = 100,
			}
			callsign = "RFF434"

		elseif (randomFighter == 26) then
			_aircrafttype = "Su-17M4"
			_country = country.id.RUSSIA
			_skin = "af standard (worn-out) (RUS)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
			}, -- end of [8]
			}, -- end of ["pylons"]
			["fuel"] = "3770",
			["flare"] = 64,
			["chaff"] = 64,
			["gun"] = 100,
			}
			callsign = "RFF904"

		elseif (randomFighter == 27) then
			_aircrafttype = "Su-24M"
			_country = country.id.RUSSIA
			_skin = "af standard"
			_payload ={
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
			}, -- end of [2]
			[5] =
			{
			["CLSID"] = "{16602053-4A12-40A2-B214-AB60D481B20E}",
			}, -- end of [5]
			[7] =
			{
			["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
			}, -- end of [8]
			}, -- end of ["pylons"]
			["fuel"] = "11700",
			["flare"] = 96,
			["chaff"] = 96,
			["gun"] = 100,
			}
			callsign = "RFF234"

		elseif (randomFighter == 28) then
			_aircrafttype = "Su-24MR"
			_country = country.id.RUSSIA
			_skin = "af standard"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{B0DBC591-0F52-4F7D-AD7B-51E67725FB81}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{0519A263-0AB6-11d6-9193-00A0249B6F00}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{0519A261-0AB6-11d6-9193-00A0249B6F00}",
			}, -- end of [5]
			}, -- end of ["pylons"]
			["fuel"] = "11700",
			["flare"] = 96,
			["chaff"] = 96,
			["gun"] = 100,
			}
			callsign = "RFF924"

		elseif (randomFighter == 29) then
			_aircrafttype = "Su-25"
			_country = country.id.RUSSIA
			_skin = "field camo scheme #3 (worn-out). 960th shap"
			_payload ={
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{0180F983-C14A-11d8-9897-000476191836}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{0180F983-C14A-11d8-9897-000476191836}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [10]
			}, -- end of ["pylons"]
			["fuel"] = "2835",
			["flare"] = 128,
			["chaff"] = 128,
			["gun"] = 100,
			}
			callsign = "RFF84"

		elseif (randomFighter == 30) then
			_aircrafttype = "Su-25T"
			_country = country.id.RUSSIA
			_skin = "af standard 2"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
			}, -- end of [5]
			[7] =
			{
			["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{637334E4-AB5A-47C0-83A6-51B7F1DF3CD5}",
			}, -- end of [10]
			[11] =
			{
			["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
			}, -- end of [11]
			}, -- end of ["pylons"]
			["fuel"] = "3790",
			["flare"] = 128,
			["chaff"] = 128,
			["gun"] = 100,
			}
			callsign = "RFF66"

		elseif (randomFighter == 31) then
			_aircrafttype = "Su-27"
			_country = country.id.RUSSIA
			_skin = "Besovets AFB"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{B79C379A-9E87-4E50-A1EE-7F7E29C2E87A}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [10]
			}, -- end of ["pylons"]
			["fuel"] = "9400",
			["flare"] = 96,
			["chaff"] = 96,
			["gun"] = 100,
			}
			callsign = "RFF524"

		elseif (randomFighter == 32) then
			_aircrafttype = "Su-30"
			_country = country.id.RUSSIA
			_skin = "af standard last (worn-out)"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
			}, -- end of [10]
			}, -- end of ["pylons"]
			["fuel"] = "9400",
			["flare"] = 96,
			["chaff"] = 96,
			["gun"] = 100,
			}
			callsign = "RFF14"

		elseif (randomFighter == 33) then
			_aircrafttype = "Su-33"
			_country = country.id.RUSSIA
			_skin = "279th kiap 2nd squad navy"
			_payload =  {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
			}, -- end of [10]
			[11] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [11]
			[12] =
			{
			["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
			}, -- end of [12]
			}, -- end of ["pylons"]
			["fuel"] = "9400",
			["flare"] = 48,
			["chaff"] = 48,
			["gun"] = 100,
			}
			callsign = "RFF44"

		elseif (randomFighter == 34) then
			_aircrafttype = "Su-34"
			_country = country.id.RUSSIA
			_skin = "af standard 2"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82F}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [2]
			[3] =
			{
			["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
			}, -- end of [3]
			[4] =
			{
			["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
			}, -- end of [4]
			[5] =
			{
			["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
			}, -- end of [5]
			[6] =
			{
			["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
			}, -- end of [6]
			[7] =
			{
			["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
			}, -- end of [7]
			[8] =
			{
			["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
			}, -- end of [8]
			[9] =
			{
			["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
			}, -- end of [9]
			[10] =
			{
			["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
			}, -- end of [10]
			[11] =
			{
			["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
			}, -- end of [11]
			[12] =
			{
			["CLSID"] = "{44EE8698-89F9-48EE-AF36-5FD31896A82A}",
			}, -- end of [12]
			}, -- end of ["pylons"]
			["fuel"] = "9800",
			["flare"] = 64,
			["chaff"] = 64,
			["gun"] = 100,
			}
			callsign = "RFF22"

		elseif (randomFighter == 35) then
			_aircrafttype = "Tu-160"
			_country = country.id.RUSSIA
			_skin = "af standard"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{0290F5DE-014A-4BB1-9843-D717749B1DED}",
			}, -- end of [1]
			[2] =
			{
			["CLSID"] = "{0290F5DE-014A-4BB1-9843-D717749B1DED}",
			}, -- end of [2]
			}, -- end of ["pylons"]
			["fuel"] = "157000",
			["flare"] = 72,
			["chaff"] = 72,
			["gun"] = 100,
			}
			callsign = "RFF666"

		elseif (randomFighter == 36) then
			_aircrafttype = "Tu-22M3"
			_country = country.id.RUSSIA
			_skin = "af standard"
			_payload = {
			["pylons"] =
			{
			[1] =
			{
			["CLSID"] = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
			}, -- end of [1]
			[4] =
			{
			["CLSID"] = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
			}, -- end of [4]
			[7] =
			{
			["CLSID"] = "{12429ECF-03F0-4DF6-BCBD-5D38B6343DE1}",
			}, -- end of [7]
			}, -- end of ["pylons"]
			["fuel"] = "50000",
			["flare"] = 48,
			["chaff"] = 48,
			["gun"] = 100,
			}
			callsign = "RFF204"
		end
	end

	_spawnairdromeId = spawnIndex.id
	_spawnairbaseloc = Object.getPoint({id_=spawnIndex.id_})
	_spawnairplanepos = {}
	_spawnairplanepos.x = _spawnairbaseloc.x
	_spawnairplanepos.z = _spawnairbaseloc.z
	_spawnairplaneparking = math.random(1,40)
	_alt = 0
	_speed = 0
	_waypointtype = parkingT[1]
	_waypointaction = parkingT[2]


	_airplanedata = {
        ["modulation"] = 0,
                              ["tasks"] =
                                {
                                }, -- end of ["tasks"]
                                ["task"] = "CAS",
                                ["uncontrolled"] = false,
                                ["route"] =
                                {
                                    ["points"] =
                                    {
                                        [1] =
                                        {
                                            ["alt"] = _alt,
                                            ["type"] = _waypointtype,
                                            ["action"] = _waypointaction,
                                            ["parking"] = _spawnairplaneparking,
                                            ["alt_type"] = "RADIO",
                                            ["formation_template"] = "",
                                            ["ETA"] = 0,
											["airdromeId"] = _spawnairdromeId,
                                            ["y"] = _spawnairplanepos.z,
                                            ["x"] = _spawnairplanepos.x,
                                            ["speed"] = _speed,
                                            ["ETA_locked"] = true,
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
                                ["groupId"] = numCoalition[coalitionIndex],
                                ["hidden"] = false,
                                ["units"] =
                                {
                                    [1] =
                                    {
                                        ["alt"] = _alt,
										["heading"] = 0,
										["livery_id"] = _skin,
										["type"] = _aircrafttype,
										["psi"] = 0,
										["onboard_num"] = "10",
                                        ["parking"] = _spawnairplaneparking,
										["y"] = _spawnairplanepos.z,
										["x"] = _spawnairplanepos.x,
										["name"] =  nameP .. numCoalition[coalitionIndex].."1",
										["payload"] = _payload,
										["speed"] = _speed,
										["unitId"] =  math.random(9999,99999),
										["alt_type"] = "RADIO",
										["skill"] = "High",
									},
								},
								["y"] = _spawnairplanepos.z,
								["x"] = _spawnairplanepos.x,
								["name"] =  nameP .. numCoalition[coalitionIndex],
								["communication"] = true,
								["start_time"] = 0,
								["frequency"] = 124,

								}

	if (AircraftType == 1 or AircraftType == 3) then
		coalition.addGroup(_country, Group.Category.AIRPLANE, _airplanedata)
	else
		coalition.addGroup(_country, Group.Category.HELICOPTER, _airplanedata)

	end

	env.warning("Adding group: " .. nameP .. numCoalition[coalitionIndex] .. " At airbase: " .. spawnIndex.name, false)


	_landwaypoints = {}
	_landairdromeId = landIndex.id
	_landairbaseloc = Object.getPoint({id_=landIndex.id_})
	_landairplanepos = {}
	_landairplanepos.x = _landairbaseloc.x
	_landairplanepos.z = _landairbaseloc.z

	_turningpoint =
								{
								["alt"] = 2000,
                                ["type"] = "Turning Point",
								["action"] = "Turning Point",
								["alt_type"] = "RADIO",
                                ["formation_template"] = "",
                                ["ETA"] = 0,
                                ["y"] = _spawnairbaseloc.z+500,
                                ["x"] = _spawnairbaseloc.x+1000,
								["speed"] = 300,
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

	_landingpoint =
                    {
						["alt"] = 600,
						["type"] = "LAND",
						["action"] = "Landing",
						["alt_type"] = "RADIO",
						["formation_template"] = "",
						["ETA"] = 0,
						["y"] = _landairplanepos.z,
						["x"] = _landairplanepos.x,
						["speed"] = 250,
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


	env.warning("Adding route for group: " .. nameP .. numCoalition[coalitionIndex] .. " Land airbase: " .. landIndex.name, false)


--	if (AircraftType == 2) then
--		env.warning("Build Heli route", false)
--		_landwaypoints[#_landwaypoints+1] =  mist.heli.buildWP(_turningpoint, "Turning Point", 80, 800, "RADIO")
--		_landwaypoints[#_landwaypoints+1] =  mist.heli.buildWP(_landingpoint, "LAND", 80, 600, "RADIO")
--	else
--		env.warning("Build Plane route", false)
--		_landwaypoints[#_landwaypoints+1] =  mist.fixedWing.buildWP(_turningpoint, "Turning Point", 200, 11500, "RADIO")
--		_landwaypoints[#_landwaypoints+1] =  mist.fixedWing.buildWP(_landingpoint, "LAND", 200, 8000, "RADIO")
--	end


_landwaypoints[1] =
{
    ["action"] = "Turning Point",
    ["alt"] = 600,
    ["alt_type"] = "RADIO",
    ["speed"] = 250,
    ["type"] = "Turning Point",
    ["x"] = -2321411.734375,
    ["y"] = 545968.875
}
_landwaypoints[2] =
{
    ["action"] = "Landing",
    ["alt"] = 9,
    ["alt_type"] = "RADIO",
    ["speed"] = 250,
    ["type"] = "Land",
    ["x"] = -221411.734375,
    ["y"] = 565968.875
}

	mist.goRoute(Group.getByName(nameP .. numCoalition[coalitionIndex]), _landwaypoints)
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

	-- choose which coalition side to possibly spawn new aircraft
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

	if (lowVal > highVal) then  -- no coalition bases defined at all!
		return
	end

	coalitionSide = math.random(lowVal, highVal)  -- choose which side to spawn unit this time

	if (numCoalition[coalitionSide] < maxCoalition[coalitionSide]) then  -- is ok to spawn a new unit?

		numCoalition[coalitionSide] = numCoalition[coalitionSide] + 1

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

		-- create new aircraft
		generateAirplane(coalitionSide, airbaseSpawn, airbaseLand, parkingType, NamePrefix[coalitionSide])
	end
end


--names of red bases
redAF = getAFBases(1)
if (#redAF < 1) then
	env.warning("There are no red bases in this mission.", false)
end

--names of blue bases
blueAF = getAFBases(2)
if (#blueAF < 1) then
	env.warning("There are no blue bases in this mission.", false)
end

Spawntimer = mist.scheduleFunction(generateGroup, {}, timer.getTime() + 2, intervall)

end
