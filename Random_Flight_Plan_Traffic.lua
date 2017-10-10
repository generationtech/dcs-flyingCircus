do
--EDIT BELOW
intervall = math.random(90,180) 	--random repeat interval between (A and B) in seconds
maxCoalition = {20, 20} 	-- maximum number of red, blue units
NamePrefix = {"Red-", "Blue-"}

Nameprefix = "A-" 				--Unit and Group name should not be used in ME by other units, this prefix can be altered if used by other scripts
AF1 = 'Kutaisi'

groupcounter = 0 --counts number of spawned and provides group and unit name

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
function generateAirplane(coalitionIndex, airbaseIndex, parkingType, namePrefix)

	groupcounter = groupcounter + 1

	randomAirplane = math.random(1,9) -- random for airplane type; Russian AC 10-18

	AF1IDname = Airbase.getByName(AF1)
	AF1ID = AF1IDname:getID()


			if (randomAirplane == 1) --airplane types
			then
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

			elseif (randomAirplane == 2)
			then
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

			elseif (randomAirplane == 3)
			then
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

			elseif (randomAirplane == 4)
			then
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

			elseif (randomAirplane == 5)
			then
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

			elseif (randomAirplane == 6)
			then
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

			elseif (randomAirplane == 7)
			then
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

			elseif (randomAirplane == 8)
			then
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

			elseif (randomAirplane == 9)
			then
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

			elseif (randomAirplane == 10)
			then
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

			elseif (randomAirplane == 11)
			then
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

			elseif (randomAirplane == 12)
			then
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

			elseif (randomAirplane == 13)
			then
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

			elseif (randomAirplane == 14)
			then
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

			elseif (randomAirplane == 15)
			then
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

			elseif (randomAirplane == 16)
			then
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

			elseif (randomAirplane == 17)
			then
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

			elseif (randomAirplane == 18)
			then
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

			_spawnairplane = trigger.misc.getZone(AF1)
			_spawnairplanepos = {}
--			_spawnairplanepos.x = _spawnairplane.point.x + math.random(_spawnairplane.radius * -1, _spawnairplane.radius)
--			_spawnairplanepos.z = _spawnairplane.point.z + math.random(_spawnairplane.radius * -1, _spawnairplane.radius)
			_spawnairplanepos.x = closestairfieldlocation.x
			_spawnairplanepos.z = closestairfieldlocation.z
			_spawnairplaneparking = math.random(1,40)
			_alt = 0
			_speed = 0
--			_waypointtype = "TakeOffParking"
--			_waypointaction = "From Parking Area"
--			_waypointtype = "TakeOffParkingHot"
--			_waypointaction = "From Parking Area Hot"
			_waypointtype = "TakeOffParking"
			_waypointaction = "From Parking Area"
			_airdromeId = AF1ID
			takeoffairfield = AF1


		_airplanedata = 	{
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
											["airdromeId"] = _airdromeId,
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

                                                    }, -- end of ["tasks"]
                                                }, -- end of ["params"]
                                            }, -- end of ["task"]
                                            ["speed_locked"] = true,
                                        }, -- end of [1]
                                    }, -- end of ["points"]
                                }, -- end of ["route"]
                                ["groupId"] = groupcounter,
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
										["name"] =  Nameprefix .. groupcounter.."1",
										["payload"] = _payload,
										["speed"] = _speed,
										["unitId"] =  math.random(9999,99999),
										["alt_type"] = "RADIO",
										["skill"] = "High",
									}, -- end of [1]
								}, -- end of ["units"]
								["y"] = _spawnairplanepos.z,
								["x"] = _spawnairplanepos.x,
								["name"] =  Nameprefix .. groupcounter,
								["communication"] = true,
								["start_time"] = 0,
								["frequency"] = 124,

								}
		coalition.addGroup(_country, Group.Category.AIRPLANE, _airplanedata)
end

function chooseAirport(AF)
	airportChoice = math.random(1, #AF)
return AF[airportChoice]
end

function generateGroup()
	local lowVal
	local highVal
	local coalitionSide
	local airportChosen
	local i
	local parkingType

	-- choose which coalition side to possibly spawn new aircraft
	if #redAF > 0 then
		lowVal = 1
	else
		lowVal = 2
	end

	if #blueAF > 0 then
		highVal = 2
	else
		highVal = 1
	end

	if lowVal > highVal then  -- no coalition bases defined at all!
		return
	end

	coalitionSide = math.random(lowVal, highVal)  -- choose which side to spawn unit this time

	if numCoalition[coalitionSide] < maxCoalition[coalitionSide] then  -- is ok to spawn a new unit?

		numCoalition[coalitionSide] = numCoalition[coalitionSide] + 1

		i = math.random(1, 3)
		if i == 1 then
			parkingType = {"TakeOffParking", "From Parking Area"}
		elseif (i == 2) then
			parkingType = {"TakeOffParkingHot", "From Parking Area Hot"}
		else
			parkingType = {"TakeOff", "From Runway"}
		end

		if coalitionSide == 1 then
			airportChosen = chooseAirport(redAF)
		else
			airportChosen = chooseAirport(blueAF)
		end

		-- create new aircraft
		generateAirplane(coalitionSide, airportChosen, parkingType, NamePrefix(coalitionSide))
	end
end


--names of red bases
redAF = getAFBases(1)
if #redAF < 1 then
	env.warning("There are no red bases in this mission.", false)
end

--names of blue bases
blueAF = getAFBases(2)
if #blueAF < 1 then
	env.warning("There are no blue bases in this mission.", false)
end

--	closestairfieldname = AF[n].name
	closestairfieldname = AF1
	closestairfield = Airbase.getByName(closestairfieldname)
	closestairfieldID = closestairfield:getID()
--end
closestairfieldlocation = {}
closestairfieldlocation = Object.getPoint(closestairfield)

Spawntimer = mist.scheduleFunction(generateAirplane, {}, timer.getTime() + 2, intervall)

end
