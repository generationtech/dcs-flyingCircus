-- Randomly spawn a different kind of aircraft at different coalition airbase up to a limit of total spawned aircraft.
-- In the ME, just designate each coalition airbase assignment on the ME airbase object, not with target zones

do
--EDIT BELOW
intervall = math.random(15,30) 	--random repeat interval between (A and B) in seconds
maxCoalition = {10, 30} 	-- maximum number of red, blue units
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

	AircraftType = math.random(1,19) --random for utility airplane, bomber, attack, fighter, or helicopter

	if ((AircraftType >= 1) and (AircraftType <= 1)) then  -- UTILITY AIRCRAFT
		if (coalitionIndex == 1) then
			randomAirplane = math.random(14,23) -- random for airplane type; Red AC 14-23
		else
			randomAirplane = math.random(1,13) -- random for airplane type; Blue AC 1-13
		end

		if (randomAirplane == 1) then
			_aircrafttype = "An-26B"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GEORGIA
				_skin = "Georgian AF"
				callsign = "GEORGIA An-26B - " .. _skin
			else
				_country = country.id.UKRAINE
				_skin = "Ukraine AF"
				callsign = "UKRAINE An-26B - " .. _skin
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
			callsign = "UKRAINE An-30M - " .. _skin
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
				callsign = "USA C-130 - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.BELGIUM
				_skin = "Belgian Air Force"
				callsign = "BELGIUM C-130 - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.CANADA
				_skin = "Canada's Air Force"
				callsign = "CANADA C-130 - " .. _skin
			elseif (subtype == 4) then
				_country = country.id.DENMARK
				_skin = "Royal Danish Air Force"
				callsign = "DENMARK C-130 - " .. _skin
			elseif (subtype == 5) then
				_country = country.id.FRANCE
				_skin = "French Air Force"
				callsign = "FRANCE C-130 - " .. _skin
			elseif (subtype == 6) then
				_country = country.id.ISRAEL
				_skin = "Israel Defence Force"
				callsign = "ISRAEL C-130 - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.NORWAY
				_skin = "Royal Norwegian Air Force"
				callsign = "NORWAY C-130 - " .. _skin
			elseif (subtype == 8) then
				_country = country.id.SPAIN
				_skin = "Spanish Air Force"
				callsign = "SPAIN C-130 - " .. _skin
			elseif (subtype == 9) then
				_country = country.id.THE_NETHERLANDS
				_skin = "Royal Netherlands Air Force"
				callsign = "THE_NETHERLANDS C-130 - " .. _skin
			elseif (subtype == 10) then
				_country = country.id.UK
				_skin = "Royal Air Force"
				callsign = "UK C-130 - " .. _skin
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
			callsign = "USA C-17A - " .. _skin
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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "E-2D Demo"
			else
				_skin = "VAW-125 Tigertails"
			end

			callsign = "USA E-2C - " .. _skin

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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "nato"
			else
				_skin = "usaf standard"
			end

			callsign = "USA E-3A - " .. _skin

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

			callsign = "UKRAINE IL-76MD - " .. _skin

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
			_skin = "Standard USAF"
			callsign = "USA KC-135 - " .. _skin
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
			_skin = "af standard"
			callsign = "UKRAINE MiG-25RBT - " .. _skin
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
			_skin = "usaf standard"
			callsign = "USA S-3B Tanker - " .. _skin
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
			_skin = "af standard"
			callsign = "UKRAINE Su-24MR - " .. _skin
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
						["CLSID"] = "{0519A263-0AB6-11d6-9193-00A0249B6F00}",
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

				callsign = "USA TF-51D - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.BELGIUM
				callsign = "BELGIUM TF-51D"
			elseif (subtype == 3) then
				_country = country.id.CANADA
				callsign = "CANADA TF-51D"
			elseif (subtype == 4) then
				_country = country.id.DENMARK
				callsign = "DENMARK TF-51D"
			elseif (subtype == 5) then
				_country = country.id.FRANCE
				callsign = "FRANCE TF-51D"
			elseif (subtype == 6) then
				_country = country.id.ISRAEL
				callsign = "ISRAEL TF-51D"
			elseif (subtype == 7) then
				_country = country.id.NORWAY
				callsign = "NORWAY TF-51D"
			elseif (subtype == 8) then
				_country = country.id.SPAIN
				callsign = "SPAIN TF-51D"
			elseif (subtype == 9) then
				_country = country.id.THE_NETHERLANDS
				callsign = "THE_NETHERLANDS TF-51D"
			else
				_country = country.id.UK
				callsign = "UK TF-51D"
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
				callsign = "GEORGIA Yak-40 - " .. _skin
			else
				_country = country.id.UKRAINE
				_skin = "Ukrainian"
				callsign = "UKRAINE Yak-40 - " .. _skin
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

			callsign = "RUSSIA A-50 - " .. _skin

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

				callsign = "RUSSIA An-26B - " .. _skin

			else
				_country = country.id.ABKHAZIA
				_skin = "Abkhazian AF"
				callsign = "ABKHAZIA An-26B - " .. _skin
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
			callsign = "RUSSIA An-30M - " .. _skin
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
			callsign = "TURKEY C-130 - " .. _skin
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

			callsign = "RUSSIA IL-76MD - " .. _skin

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

			callsign = "RUSSIA IL-78M - " .. _skin

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
			_skin = "af standard"
			callsign = "RUSSIA MiG-25RBT - " .. _skin
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
						["CLSID"] = "{FB3CE165-BF07-4979-887C-92B87F13276B}",
					},
					[3] =
					{
						["CLSID"] = "{FB3CE165-BF07-4979-887C-92B87F13276B}",
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
			_skin = "af standard"
			callsign = "RUSSIA Su-24MR - " .. _skin
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
						["CLSID"] = "{0519A263-0AB6-11d6-9193-00A0249B6F00}",
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
				callsign = "RUSSIA TF-51D"
			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				callsign = "ABKHAZIA TF-51D"
			else
				_country = country.id.TURKEY
				callsign = "TURKEY TF-51D"
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
			callsign = "RUSSIA Yak-40 - " .. _skin
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

	elseif ((AircraftType >= 2) and (AircraftType <= 2)) then  -- BOMBERS
		if (coalitionIndex == 1) then
			randomBomber = math.random(11,15) -- random for airplane type; Red AC 11-15
		else
			randomBomber = math.random(1,10) -- random for airplane type; Blue AC 1-10
		end

		if (randomBomber == 1) then
			_aircrafttype = "B-1B"
			_country = country.id.USA
			_skin = "usaf standard"
			callsign = "USA B-1B - " .. _skin
			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "MK_82*28",
					},
					[2] =
					{
						["CLSID"] = "MK_82*28",
					},
					[3] =
					{
						["CLSID"] = "MK_82*28",
					},
				},
				["fuel"] = "88450",
				["flare"] = 30,
				["chaff"] = 60,
				["gun"] = 100,
			}
		elseif (randomBomber == 2) then
			_aircrafttype = "B-52H"
			_country = country.id.USA
			_skin = "usaf standard"
			callsign = "USA B-52H - " .. _skin
			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
					},
					[2] =
					{
						["CLSID"] = "{8DCAF3A3-7FCF-41B8-BB88-58DEDA878EDE}",
					},
					[3] =
					{
						["CLSID"] = "{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
					},
				},
				["fuel"] = "141135",
				["flare"] = 192,
				["chaff"] = 1125,
				["gun"] = 100,
			}
		elseif (randomBomber == 3) then
			_aircrafttype = "F-117A"
			_country = country.id.USA
			_skin = "usaf standard"
			callsign = "USA F-117A - " .. _skin
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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.USA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "335th Fighter SQN (SJ)"
				else
					_skin = "492d Fighter SQN (LN)"
				end

				callsign = "USA F-15E - " .. _skin

			else
				_country = country.id.ISRAEL
				_skin = "IDF No 69 Hammers Squadron"
				callsign = "ISRAEL F-15E - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{D078E3E5-30C1-444e-A09E-6EEDCD334582}",
					},
					[2] =
					{
						["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					},
					[3] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[4] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[5] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[6] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[7] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[8] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[9] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[10] =
					{
						["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					},
					[11] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[12] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[13] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[14] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[15] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[16] =
					{
						["CLSID"] = "{Mk82AIR}",
					},
					[17] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[18] =
					{
						["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					},
					[19] =
					{
						["CLSID"] = "{34271A1E-477E-4754-8C72-DF7C1855A782}",
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
			_skin = "NAVY Standard"
			callsign = "USA S-3B - " .. _skin
			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{A504D93B-4E80-4B4F-A533-0D9B65F2C55F}",
					},
					[2] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
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
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[6] =
					{
						["CLSID"] = "{A504D93B-4E80-4B4F-A533-0D9B65F2C55F}",
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
			_skin = "af standard"
			callsign = "UKRAINE Su-24M - " .. _skin
			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
					},
					[2] =
					{
						["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
					},
					[5] =
					{
						["CLSID"] = "{16602053-4A12-40A2-B214-AB60D481B20E}",
					},
					[7] =
					{
						["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
					},
					[8] =
					{
						["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
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

			callsign = "UK Tornado GR4 - " .. _skin

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

				callsign = "GERMANY Tornado IDS - " .. _skin

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

				callsign = "ITALY Tornado IDS - " .. _skin
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
			_skin = "af standard"
			callsign = "UKRAINE Tu-22M3 - " .. _skin
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
			_skin = "af standard"
			callsign = "UKRAINE Tu-95MS - " .. _skin
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
			_skin = "af standard"
			callsign = "RUSSIA Su-24M - " .. _skin
			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
					},
					[2] =
					{
						["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
					},
					[5] =
					{
						["CLSID"] = "{16602053-4A12-40A2-B214-AB60D481B20E}",
					},
					[7] =
					{
						["CLSID"] = "{7D7EC917-05F6-49D4-8045-61FC587DD019}",
					},
					[8] =
					{
						["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
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
			_skin = "af standard"
			callsign = "RUSSIA Tu-142 - " .. _skin
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
			_skin = "af standard"
			callsign = "RUSSIA Tu-160 - " .. _skin
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
			_skin = "af standard"
			callsign = "RUSSIA Tu-22M3 - " .. _skin
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
			_skin = "af standard"
			callsign = "RUSSIA Tu-95MS - " .. _skin
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

	elseif ((AircraftType >= 3) and (AircraftType <= 7)) then  -- ATTACK AIRCRAFT
		if (coalitionIndex == 1) then
			randomAttack = math.random(9,16) -- random for airplane type; Red AC 9-16
		else
			randomAttack = math.random(1,8) -- random for airplane type; Blue AC 1-8
		end

		if (randomAttack == 1) then
			_aircrafttype = "A-10A"
			_country = country.id.USA

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

			callsign = "USA A-10A - " .. _skin

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
					},
					[2] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[3] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[4] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[5] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[7] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[8] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[9] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[10] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[11] =
					{
						["CLSID"] = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
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

				callsign = "USA A-10C - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = "Australia Notional RAAF"
				callsign = "AUSTRALIA A-10C - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_skin = "A-10 Grey"
				callsign = "BELGIUM A-10C - " .. _skin
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

				callsign = "CANADA A-10C - " .. _skin

			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_skin = "A-10 Grey"
				callsign = "DENMARK A-10C - " .. _skin
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_skin = "Fictional France Escadron de Chasse 03.003 ARDENNES"
				callsign = "FRANCE A-10C - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.GEORGIA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Fictional Georgian Grey"
				else
					_skin = "Fictional Georgian Olive"
				end

				callsign = "GEORGIA A-10C - " .. _skin

			elseif (subtype == 8) then
				_country = country.id.GERMANY

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Fictional German 3322"
				else
					_skin = "Fictional German 3323"
				end

				callsign = "GERMANY A-10C - " .. _skin

			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_skin = "Fictional Israel 115 Sqn Flying Dragon"
				callsign = "ISRAEL A-10C - " .. _skin
			elseif (subtype == 10) then
				_country = country.id.ITALY
				_skin = "Fictional Italian AM (23Gruppo)"
				callsign = "ITALY A-10C - " .. _skin
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_skin = "Fictional Royal Norwegian Air Force"
				callsign = "NORWAY A-10C - " .. _skin
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

				callsign = "SPAIN A-10C - " .. _skin

			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_skin = "A-10 Grey"
				callsign = "THE_NETHERLANDS A-10C - " .. _skin
			elseif (subtype == 14) then
				_country = country.id.UK
				_skin = "A-10 Grey"
				callsign = "UK A-10C - " .. _skin
			else
				_country = country.id.UKRAINE
				_skin = "Fictional Ukraine Air Force 1"
				callsign = "UKRAINE A-10C - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
					},
					[2] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[3] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[4] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[5] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[7] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[8] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[9] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[10] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[11] =
					{
						["CLSID"] = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
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

				callsign = "USA Hawk - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = ""
				callsign = "AUSTRALIA Hawk"
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_skin = "100sqn XX189"
				callsign = "BELGIUM Hawk - " .. _skin
			elseif (subtype == 4) then
				_country = country.id.CANADA
				_skin = "100sqn XX189"
				callsign = "CANADA Hawk - " .. _skin
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_skin = "100sqn XX189"
				callsign = "DENMARK Hawk - " .. _skin
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_skin = "100sqn XX189"
				callsign = "FRANCE Hawk - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.GEORGIA
				_skin = "100sqn XX189"
				callsign = "GEORGIA Hawk - " .. _skin
			elseif (subtype == 8) then
				_country = country.id.GERMANY
				_skin = "100sqn XX189"
				callsign = "GERMANY Hawk - " .. _skin
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_skin = "100sqn XX189"
				callsign = "ISRAEL Hawk - " .. _skin
			elseif (subtype == 10) then
				_country = country.id.ITALY
				_skin = "100sqn XX189"
				callsign = "ITALY Hawk - " .. _skin
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_skin = "100sqn XX189"
				callsign = "NORWAY Hawk - " .. _skin
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				_skin = "100sqn XX189"
				callsign = "SPAIN Hawk - " .. _skin
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_skin = "100sqn XX189"
				callsign = "THE_NETHERLANDS Hawk - " .. _skin
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

				callsign = "UK Hawk - " .. _skin

			else
				_country = country.id.UKRAINE
				_skin = "100sqn XX189"
				callsign = "UKRAINE Hawk - " .. _skin
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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GEORGIA
				_skin = "Georgian Air Force"
				callsign = "GEORGIA - " .. _skin
			else
				_country = country.id.UKRAINE
				_skin = "Ukraine Air Force 1"
				callsign = "UKRAINE - " .. _skin
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
			_skin = "af standard"
			callsign = "UKRAINE MiG-27K - " .. _skin
			_payload =
			{
				["pylons"] =
				{
					[2] =
					{
						["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					},
					[3] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[4] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[5] =
					{
						["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
					},
					[6] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[7] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[8] =
					{
						["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "af standard"
			elseif (subtype == 2) then
				_skin = "af standard (worn-out)"
			else
				_skin = "shap limanskoye ab"
			end

			callsign = "UKRAINE Su-17M4 - " .. _skin

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[2] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[3] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[4] =
					{
						["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
					},
					[5] =
					{
						["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
					},
					[6] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[7] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[8] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
				},
				["fuel"] = "3770",
				["flare"] = 64,
				["chaff"] = 64,
				["gun"] = 100,
			}
		elseif (randomAttack == 7)	then
			_aircrafttype = "Su-25"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GEORGIA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "`scorpion` demo scheme (native)"
				else
					_skin = "field camo scheme #1 (native)"
				end

				callsign = "GEORGIA Su-25 - " .. _skin

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

				callsign = "UKRAINE Su-25 - " .. _skin

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
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[4] =
					{
						["CLSID"] = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
					},
					[5] =
					{
						["CLSID"] = "{0180F983-C14A-11d8-9897-000476191836}",
					},
					[6] =
					{
						["CLSID"] = "{0180F983-C14A-11d8-9897-000476191836}",
					},
					[7] =
					{
						["CLSID"] = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
					},
					[8] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "af standard"
			else
				_skin = "af standard 1"
			end

			callsign = "GEORGIA Su-25T - " .. _skin

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
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[4] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[5] =
					{
						["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
					},
					[7] =
					{
						["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
					},
					[8] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[9] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
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
		elseif (randomAttack == 9)	then
			_aircrafttype = "A-10C"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Fictional Russian Air Force 1"
				else
					_skin = "Fictional Russian Air Force 2"
				end

				callsign = "RUSSIA A-10C - " .. _skin

			else
				_country = country.id.TURKEY
				_skin = "A-10 Grey"
				callsign = "TURKEY A-10C - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{6D21ECEA-F85B-4E8D-9D51-31DC9B8AA4EF}",
					},
					[2] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[3] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[4] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[5] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[7] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[8] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[9] =
					{
						["CLSID"] = "{444BA8AE-82A7-4345-842E-76154EFCCA46}",
					},
					[10] =
					{
						["CLSID"] = "{BCE4E030-38E9-423E-98ED-24BE3DA87C32}",
					},
					[11] =
					{
						["CLSID"] = "{DB434044-F5D0-4F1F-9BA9-B73027E18DD3}",
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

			subtype = math.random(1,4)
			if (subtype == 1) then
				_country = country.id.RUSSIA
				_skin = "100sqn XX189"
				callsign = "RUSSIA Hawk - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_skin = "100sqn XX189"
				callsign = "ABKHAZIA Hawk - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.SOUTH_OSETIA
				_skin = "100sqn XX189"
				callsign = "SOUTH_OSETIA Hawk - " .. _skin
			else
				_country = country.id.TURKEY
				_skin = "100sqn XX189"
				callsign = "TURKEY Hawk - " .. _skin
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

				callsign = "RUSSIA - " .. _skin

			else
				_country = country.id.ABKHAZIA
				_skin = "Abkhazian Air Force"
				callsign = "ABKHAZIA - " .. _skin
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
			_skin = "af standard"
			callsign = "RUSSIA MiG-27K - " .. _skin
			_payload =
			{
				["pylons"] =
				{
					[2] =
					{
						["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
					},
					[3] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[4] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[5] =
					{
						["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
					},
					[6] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[7] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[8] =
					{
						["CLSID"] = "{37DCC01E-9E02-432F-B61D-10C166CA2798}",
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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "af standard"
			else
				_skin = "af standard (worn-out)"
			end

			callsign = "RUSSIA Su-17M4 - " .. _skin

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[2] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[3] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[4] =
					{
						["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
					},
					[5] =
					{
						["CLSID"] = "{A5BAEAB7-6FAF-4236-AF72-0FD900F493F9}",
					},
					[6] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
					[7] =
					{
						["CLSID"] = "{682A481F-0CB5-4693-A382-D00DD4A156D7}",
					},
					[8] =
					{
						["CLSID"] = "{F72F47E5-C83A-4B85-96ED-D3E46671EE9A}",
					},
				},
				["fuel"] = "3770",
				["flare"] = 64,
				["chaff"] = 64,
				["gun"] = 100,
			}
		elseif (randomAttack == 14)	then
			_aircrafttype = "Su-25"

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

				callsign = "RUSSIA Su-25 - " .. _skin

			else
				_country = country.id.ABKHAZIA
				_skin = "Abkhazian Air Force"
				callsign = "ABKHAZIA Su-25 - " .. _skin
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
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[4] =
					{
						["CLSID"] = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
					},
					[5] =
					{
						["CLSID"] = "{0180F983-C14A-11d8-9897-000476191836}",
					},
					[6] =
					{
						["CLSID"] = "{0180F983-C14A-11d8-9897-000476191836}",
					},
					[7] =
					{
						["CLSID"] = "{79D73885-0801-45a9-917F-C90FE1CE3DFC}",
					},
					[8] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "af standard 1"
			elseif (subtype == 2) then
				_skin = "af standard 2"
			else
				_skin = "su-25t test scheme"
			end

			callsign = "RUSSIA Su-25T - " .. _skin

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
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[4] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[5] =
					{
						["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
					},
					[7] =
					{
						["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
					},
					[8] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[9] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
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
		elseif (randomAttack == 16)	then
			_aircrafttype = "Su-25TM"
			_country = country.id.RUSSIA
			_skin = "Flight Research Institute  VVS"
			callsign = "RUSSIA Su-25TM - " .. _skin

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
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[4] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[5] =
					{
						["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
					},
					[6] =
					{
						["CLSID"] = "{B1EF6B0E-3D91-4047-A7A5-A99E7D8B4A8B}",
					},
					[7] =
					{
						["CLSID"] = "{E8D4652F-FD48-45B7-BA5B-2AE05BB5A9CF}",
					},
					[8] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
					},
					[9] =
					{
						["CLSID"] = "{D5435F26-F120-4FA3-9867-34ACE562EF1B}",
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

	elseif ((AircraftType >= 8) and (AircraftType <= 16)) then  -- FIGHTERS
		if (coalitionIndex == 1) then
			randomFighter = math.random(22,25) -- random for airplane type; Red AC 22-25
		else
			randomFighter = math.random(1,21) -- random for airplane type; Blue AC 1-21
		end

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

			callsign = "GERMANY Bf-109K-4 - " .. _skin

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

			callsign = "USA F-14A - " .. _skin

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
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[4] =
					{
						["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
					},
					[5] =
					{
						["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
					},
					[8] =
					{
						["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
					},
					[11] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[12] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[9] =
					{
						["CLSID"] = "{7575BA0B-7294-4844-857B-031A144B2595}",
					},
				},
				["fuel"] = "7348",
				["flare"] = 15,
				["chaff"] = 30,
				["gun"] = 100,
			}
		elseif (randomFighter == 3)	then
			_aircrafttype = "F-15C"

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

				callsign = "USA F-15C - " .. _skin

			else
				_country = country.id.ISRAEL
				skin = "106th SQN (8th Airbase)"
				callsign = "ISRAEL F-15C - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
					},
					[2] =
					{
						["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					},
					[3] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[4] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[5] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
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
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[9] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[10] =
					{
						["CLSID"] = "{E1F29B21-F291-4589-9FD8-3272EEC69506}",
					},
					[11] =
					{
						["CLSID"] = "{40EF17B7-F508-45de-8566-6FFECC0C1AB8}",
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
			_skin = "usaf f16 standard-1"
			callsign = "USA F-16A - " .. _skin
			_payload =
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
			}
		elseif (randomFighter == 5) then
			_aircrafttype = "F-16C bl.52d"

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

				callsign = "USA F-16C bl.52d - " .. _skin
			else
				_country = country.id.ISRAEL
				_skin = "idf_af f16c standard"
				callsign = "ISRAEL F-16C bl.52d - " .. _skin
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

				callsign = "BELGIUM F-16A MLU - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.DENMARK
				_skin = "rdaf f16 standard-1"

--				subtype1 = math.random(1,2)
--				if (subtype1 == 1) then
--					_skin = "rdaf f16 standard-1"
--				else
--					_skin = "CMD extended skins"
--				end

				callsign = "DENMARK F-16A MLU - " .. _skin

			elseif (subtype == 3) then
				_country = country.id.ITALY
				_skin = "rdaf f16 standard-1"

--				subtype1 = math.random(1,2)
--				if (subtype1 == 1) then
--					_skin = "rdaf f16 standard-1"
--				else
--					_skin = "CMD extended skins"
--				end

				callsign = "ITALY F-16A MLU - " .. _skin

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

				callsign = "NORWAY F-16A MLU - " .. _skin

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

				callsign = "THE_NETHERLANDS F-16A MLU - " .. _skin

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
				callsign = "GERMANY F-4E - " .. _skin
			else
				_country = country.id.ISRAEL
				callsign = "ISRAEL F-4E"
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

			callsign = "USA F-5E - " .. _skin

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
						["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					},
					[4] =
					{
						["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					},
					[5] =
					{
						["CLSID"] = "{0395076D-2F77-4420-9D33-087A4398130B}",
					},
					[6] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
					[7] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
				},
				["fuel"] = "2000",
				["flare"] = 15,
				["chaff"] = 30,
				["gun"] = 100,
			}
		elseif (randomFighter == 9) then
			_aircrafttype = "F-86F Sabre"
			_skin = ""

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA
				callsign = "USA F-86F Sabre"
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				callsign = "AUSTRALIA F-86F Sabre"
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				callsign = "BELGIUM F-86F Sabre"
			elseif (subtype == 4) then
				_country = country.id.CANADA
				callsign = "CANADA F-86F Sabre"
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				callsign = "DENMARK F-86F Sabre"
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				callsign = "FRANCE F-86F Sabre"
			elseif (subtype == 7) then
				_country = country.id.GEORGIA
				callsign = "GEORGIA F-86F Sabre"
			elseif (subtype == 8) then
				_country = country.id.GERMANY
				callsign = "GERMANY F-86F Sabre"
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				callsign = "ISRAEL F-86F Sabre"
			elseif (subtype == 10) then
				_country = country.id.ITALY
				callsign = "ITALY F-86F Sabre"
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				callsign = "NORWAY F-86F Sabre"
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				callsign = "SPAIN F-86F Sabre"
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				callsign = "THE_NETHERLANDS F-86F Sabre"
			elseif (subtype == 14) then
				_country = country.id.UK
				callsign = "UK F-86F Sabre"
			else
				_country = country.id.UKRAINE
				callsign = "UKRAINE F-86F Sabre"
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{PTB_200_F86F35}",
					},
					[2] =
					{
						["CLSID"] = "{HVAR_SMOKE_2}",
					},
					[3] =
					{
						["CLSID"] = "{HVARx2}",
					},
					[4] =
					{
						["CLSID"] = "{F86ANM64}",
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
						["CLSID"] = "{F86ANM64}",
					},
					[8] =
					{
						["CLSID"] = "{HVARx2}",
					},
					[9] =
					{
						["CLSID"] = "{HVAR_SMOKE_2}",
					},
					[10] =
					{
						["CLSID"] = "{PTB_200_F86F35}",
					},
				},
				["fuel"] = "1282",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomFighter == 10) then
			_aircrafttype = "F/A-18C"
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

				callsign = "USA F/A-18C - " .. _skin

			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = "Australia 75 Sqn RAAF"
				callsign = "AUSTRALIA F/A-18C - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.CANADA
				callsign = "CANADA F/A-18C"
			else
				_country = country.id.SPAIN
				callsign = "SPAIN F/A-18C"
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
						["CLSID"] = "{D5D51E24-348C-4702-96AF-97A714E72697}",
					},
					[3] =
					{
						["CLSID"] = "{EFEC8201-B922-11d7-9897-000476191836}",
					},
					[4] =
					{
						["CLSID"] = "{6C0D552F-570B-42ff-9F6D-F10D9C1D4E1C}",
					},
					[5] =
					{
						["CLSID"] = "{EFEC8201-B922-11d7-9897-000476191836}",
					},
					[6] =
					{
						["CLSID"] = "{8D399DDA-FF81-4F14-904D-099B34FE7918}",
					},
					[7] =
					{
						["CLSID"] = "{EFEC8201-B922-11d7-9897-000476191836}",
					},
					[8] =
					{
						["CLSID"] = "{D5D51E24-348C-4702-96AF-97A714E72697}",
					},
					[9] =
					{
						["CLSID"] = "{6CEB49FC-DED8-4DED-B053-E1F033FF72D3}",
					},
				},
				["fuel"] = "6531",
				["flare"] = 15,
				["chaff"] = 30,
				["gun"] = 100,
			}
		elseif (randomFighter == 11) then
			_aircrafttype = "FW-190D9"

			subtype = math.random(1,3)
			if (subtype == 1) then
				_country = country.id.USA
				_skin = "FW-190D9_USA"
				callsign = "USA FW-190D9 - " .. _skin
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

				callsign = "GERMANY FW-190D9 - " .. _skin

			else
				_country = country.id.UK
				_skin = "FW-190D9_GB"
				callsign = "UK FW-190D9 - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "SC_501_SC500",
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
				callsign = "USA MiG-15bis"
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				callsign = "AUSTRALIA MiG-15bis"
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				callsign = "BELGIUM MiG-15bis"
			elseif (subtype == 4) then
				_country = country.id.CANADA
				callsign = "CANADA MiG-15bis"
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				callsign = "DENMARK MiG-15bis"
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				callsign = "FRANCE MiG-15bis"
			elseif (subtype == 7) then
				_country = country.id.GERMANY
				callsign = "GERMANY MiG-15bis"
			elseif (subtype == 8) then
				_country = country.id.GEORGIA
				callsign = "GEORGIA MiG-15bis"
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				callsign = "ISRAEL MiG-15bis"
			elseif (subtype == 10) then
				_country = country.id.ITALY
				callsign = "ITALY MiG-15bis"
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				callsign = "NORWAY MiG-15bis"
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				callsign = "SPAIN MiG-15bis"
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				callsign = "THE_NETHERLANDS MiG-15bis"
			elseif (subtype == 14) then
				_country = country.id.UK
				callsign = "UK MiG-15bis"
			else
				_country = country.id.UKRAINE
				callsign = "UKRAINE MiG-15bis"
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
				callsign = "USA MiG-21BiS - " .. _skin
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				callsign = "AUSTRALIA MiG-21BiS - " .. _skin
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				callsign = "BELGIUM MiG-21BiS - " .. _skin
			elseif (subtype == 4) then
				_country = country.id.CANADA
				callsign = "CANADA MiG-21BiS - " .. _skin
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				callsign = "DENMARK MiG-21BiS - " .. _skin
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				callsign = "FRANCE MiG-21BiS - " .. _skin
			elseif (subtype == 7) then
				_country = country.id.GERMANY
				callsign = "GERMANY MiG-21BiS - " .. _skin
			elseif (subtype == 8) then
				_country = country.id.GEORGIA
				callsign = "GEORGIA MiG-21BiS - " .. _skin
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				callsign = "ISRAEL MiG-21BiS - " .. _skin
			elseif (subtype == 10) then
				_country = country.id.ITALY
				callsign = "ITALY MiG-21BiS - " .. _skin
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				callsign = "NORWAY MiG-21BiS - " .. _skin
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				callsign = "SPAIN MiG-21BiS - " .. _skin
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				callsign = "THE_NETHERLANDS MiG-21BiS - " .. _skin
			elseif (subtype == 14) then
				_country = country.id.UK
				callsign = "UK MiG-21BiS - " .. _skin
			else
				_country = country.id.UKRAINE
				callsign = "UKRAINE MiG-21BiS - " .. _skin
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{R-3R}",
					},
					[2] =
					{
						["CLSID"] = "{R-60 2L}",
					},
					[3] =
					{
						["CLSID"] = "{PTB_800_MIG21}",
					},
					[4] =
					{
						["CLSID"] = "{R-3S}",
					},
					[5] =
					{
						["CLSID"] = "{R-3R}",
					},
					[6] =
					{
						["CLSID"] = "{ASO-2}",
					},
					[7] =
					{
						["CLSID"] = "{SMOKE_WHITE}",
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
			_skin = "af standard"
			callsign = "UKRAINE MiG-23MLD - " .. _skin

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
			_skin = "af standard"
			callsign = "UKRAINE MiG-25PD - " .. _skin

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
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
						["CLSID"] = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "40th fw `maestro` vasilkov ab"
			elseif (subtype == 2) then
				_skin = "af standard-1"
			else
				_skin = "af standard-2"
			end

			callsign = "UKRAINE MiG-29A - " .. _skin

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
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[4] =
					{
						["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
					},
					[5] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
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

			callsign = "GERMANY MiG-29G - " .. _skin

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

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "14th army, vinnitsa ab"
			elseif (subtype == 2) then
				_skin = "9th fw belbek ab"
			else
				_skin = "`ukrainian falcons` paint scheme"
			end

			callsign = "UKRAINE MiG-29S - " .. _skin

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
						["CLSID"] = "{C0FF4842-FBAC-11d5-9190-00A0249B6F00}",
					},
					[4] =
					{
						["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
					},
					[5] =
					{
						["CLSID"] = "{C0FF4842-FBAC-11d5-9190-00A0249B6F00}",
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

			callsign = "FRANCE Mirage 2000-5 - " .. _skin

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

				callsign = "USA P-51D - " .. _skin

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

				callsign = "AUSTRALIA P-51D - " .. _skin

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

				callsign = "BELGIUM P-51D - " .. _skin

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

				callsign = "CANADA P-51D - " .. _skin

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

				callsign = "DENMARK P-51D - " .. _skin

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

				callsign = "FRANCE P-51D - " .. _skin

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

				callsign = "GEORGIA P-51D - " .. _skin

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

				callsign = "GERMANY P-51D - " .. _skin

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

				callsign = "ISRAEL P-51D - " .. _skin

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

				callsign = "ITALY P-51D - " .. _skin

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

				callsign = "NORWAY P-51D - " .. _skin

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

				callsign = "SPAIN P-51D - " .. _skin

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

				callsign = "THE_NETHERLANDS P-51D - " .. _skin

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

				callsign = "UK P-51D - " .. _skin

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

				callsign = "UKRAINE P-51D - " .. _skin

			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{HVAR_SMOKE_GENERATOR}",
					},
					[2] =
					{
						["CLSID"] = "{HVAR}",
					},
					[3] =
					{
						["CLSID"] = "{HVAR}",
					},
					[4] =
					{
						["CLSID"] = "{AN-M64}",
					},
					[5] =
					{
						["CLSID"] = "{HVAR}",
					},
					[6] =
					{
						["CLSID"] = "{HVAR}",
					},
					[7] =
					{
						["CLSID"] = "{AN-M64}",
					},
					[8] =
					{
						["CLSID"] = "{HVAR}",
					},
					[9] =
					{
						["CLSID"] = "{HVAR}",
					},
					[10] =
					{
						["CLSID"] = "{HVAR_SMOKE_GENERATOR}",
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

			callsign = "UKRAINE Su-27 - "	 .. _skin

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
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
				},
				["fuel"] = "9400",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			}
		elseif (randomFighter == 22) then
			_aircrafttype = "F-86F Sabre"
			_skin = ""

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.RUSSIA
				callsign = "RUSSIA F-86F Sabre"
			elseif (subtype == 2) then
			else
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{PTB_200_F86F35}",
					},
					[2] =
					{
						["CLSID"] = "{HVAR_SMOKE_2}",
					},
					[3] =
					{
						["CLSID"] = "{HVARx2}",
					},
					[4] =
					{
						["CLSID"] = "{F86ANM64}",
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
						["CLSID"] = "{F86ANM64}",
					},
					[8] =
					{
						["CLSID"] = "{HVARx2}",
					},
					[9] =
					{
						["CLSID"] = "{HVAR_SMOKE_2}",
					},
					[10] =
					{
						["CLSID"] = "{PTB_200_F86F35}",
					},
				},
				["fuel"] = "1282",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomFighter == 23) then
			_aircrafttype = "FW-190D9"

			subtype = math.random(1,3)
			if (subtype == 1) then
				_country = country.id.RUSSIA
				_skin = "FW-190D9_USSR"
				callsign = "RUSSIA FW-190D9 - " .. _skin
			elseif (subtype == 2) then

			else
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "SC_501_SC500",
					},
				},
				["fuel"] = "388",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomFighter == 24) then
			_aircrafttype = "MiG-23MLD"
			_country = country.id.RUSSIA

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

			callsign = "RUSSIA MiG-23MLD - " .. _skin

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
		elseif (randomFighter == 25) then
			_aircrafttype = "MiG-25PD"
			_country = country.id.RUSSIA
			_skin = "af standard"
			callsign = "RUSSIA MiG-25PD - " .. _skin

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
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
						["CLSID"] = "{5F26DBC2-FB43-4153-92DE-6BBCE26CB0FF}",
					},
				},
				["fuel"] = "15245",
				["flare"] = 64,
				["chaff"] = 64,
				["gun"] = 100,
			}
		elseif (randomFighter == 26) then
			_aircrafttype = "MiG-29A"
			_country = country.id.RUSSIA

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

			callsign = "RUSSIA MiG-29A - " .. _skin

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
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
					[4] =
					{
						["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
					},
					[5] =
					{
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
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
		elseif (randomFighter == 27) then
			_aircrafttype = "MiG-29S"
			_country = country.id.RUSSIA

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

			callsign = "RUSSIA MiG-29S - " .. _skin

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
						["CLSID"] = "{C0FF4842-FBAC-11d5-9190-00A0249B6F00}",
					},
					[4] =
					{
						["CLSID"] = "{2BEC576B-CDF5-4B7F-961F-B0FA4312B841}",
					},
					[5] =
					{
						["CLSID"] = "{C0FF4842-FBAC-11d5-9190-00A0249B6F00}",
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
		elseif (randomFighter == 28) then
			_aircrafttype = "MiG-31"
			_country = country.id.RUSSIA

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "174 GvIAP_Boris Safonov"
			elseif (subtype == 2) then
				_skin = "903_White"
			else
				_skin = "af standard"
			end

			callsign = "RUSSIA MiG-31 - " .. _skin

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
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
						["CLSID"] = "{4EDBA993-2E34-444C-95FB-549300BF7CAF}",
					},
				},
				["fuel"] = "15500",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomFighter == 29) then
			_aircrafttype = "P-51D"
			_skin = ""

			subtype = math.random(1,15)
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

				callsign = "RUSSIA P-51D - " .. _skin

			elseif (subtype == 2) then
			else
			end

			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{HVAR_SMOKE_GENERATOR}",
					},
					[2] =
					{
						["CLSID"] = "{HVAR}",
					},
					[3] =
					{
						["CLSID"] = "{HVAR}",
					},
					[4] =
					{
						["CLSID"] = "{AN-M64}",
					},
					[5] =
					{
						["CLSID"] = "{HVAR}",
					},
					[6] =
					{
						["CLSID"] = "{HVAR}",
					},
					[7] =
					{
						["CLSID"] = "{AN-M64}",
					},
					[8] =
					{
						["CLSID"] = "{HVAR}",
					},
					[9] =
					{
						["CLSID"] = "{HVAR}",
					},
					[10] =
					{
						["CLSID"] = "{HVAR_SMOKE_GENERATOR}",
					},
				},
				["fuel"] = "732",
				["flare"] = 0,
				["chaff"] = 0,
				["gun"] = 100,
			}
		elseif (randomFighter == 30) then
			_aircrafttype = "Su-27"
			_country = country.id.RUSSIA

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

			callsign = "RUSSIA Su-27 - " .. _skin

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
						["CLSID"] = "{FBC29BFE-3D24-4C64-B81D-941239D12249}",
					},
				},
				["fuel"] = "9400",
				["flare"] = 96,
				["chaff"] = 96,
				["gun"] = 100,
			}
		elseif (randomFighter == 31) then
			_aircrafttype = "Su-30"
			_country = country.id.RUSSIA

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

			callsign = "RUSSIA Su-30 - " .. _skin

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
						["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
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
						["CLSID"] = "{9B25D316-0434-4954-868F-D51DB1A38DF0}",
					},
					[8] =
					{
						["CLSID"] = "{E8069896-8435-4B90-95C0-01A03AE6E400}",
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
		elseif (randomFighter == 32) then
			_aircrafttype = "Su-33"
			_country = country.id.RUSSIA

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

			callsign = "RUSSIA Su-33 - " .. _skin

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
						["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
					},
					[4] =
					{
						["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
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
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[8] =
					{
						["CLSID"] = "{3C612111-C7AD-476E-8A8E-2485812F4E5C}",
					},
					[9] =
					{
						["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
					},
					[10] =
					{
						["CLSID"] = "{A0648264-4BC0-4EE8-A543-D119F6BA4257}",
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
		elseif (randomFighter == 33) then
			_aircrafttype = "Su-34"
			_country = country.id.RUSSIA

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "af standard"
			else
				_skin = "af standard 2"
			end

			callsign = "RUSSIA Su-34 - " .. _skin

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
						["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
					},
					[4] =
					{
						["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
					},
					[5] =
					{
						["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
					},
					[6] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[7] =
					{
						["CLSID"] = "{B4C01D60-A8A3-4237-BD72-CA7655BC0FE9}",
					},
					[8] =
					{
						["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
					},
					[9] =
					{
						["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
					},
					[10] =
					{
						["CLSID"] = "{6DADF342-D4BA-4D8A-B081-BA928C4AF86D}",
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
				["fuel"] = "9800",
				["flare"] = 64,
				["chaff"] = 64,
				["gun"] = 100,
			}

		end

	elseif ((AircraftType >= 17) or (AircraftType <= 19)) then -- HELICOPTERS
		if (coalitionIndex == 1) then
			randomHeli = math.random(13,18) -- random for airplane type; Red AC 13-18
		else
			randomHeli = math.random(1,12) -- random for airplane type; Blue AC 1-12
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

	_landairbaseID = landIndex.id
	_landairbaseloc = Object.getPoint({id_=landIndex.id_})
	_landairplanepos = {}
	_landairplanepos.x = _landairbaseloc.x
	_landairplanepos.z = _landairbaseloc.z
	_landalt = math.random(0,25000)
	_landspeed = math.random(175,2000)

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
										[2] =
										{
											--["alt"] = 0,
											["alt"] = _landalt,
											["type"] = "Land",
											["action"] = "Landing",
											--["alt_type"] = "RADIO",
											["alt_type"] = "BARO",
											["formation_template"] = "",
											["properties"] =
											{
												["vnav"] = 1,
												["scale"] = 0,
												["angle"] = 0,
												["vangle"] = 0,
												["steer"] = 2,
											}, -- end of ["properties"]
											--["ETA"] = 263.67692213965,
											["ETA"] = 0,
											["airdromeId"] = _landairbaseID,
											--["y"] = 683853.75717885,
											--["x"] = -284889.06283057,
											["y"] = _landairbaseloc.z,
											["x"] = _landairbaseloc.x,
											--["speed"] = 300,
											["speed"] = _landspeed,
											["ETA_locked"] = false,
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
										}, -- end of [2]
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

	env.warning('group: ' .. _airplanedata.name .. '  callsign: ' .. callsign .. '  spawn: ' .. spawnIndex.name .. '  land: ' .. landIndex.name .. '  altitude: ' .. _landalt .. '  speed: ' .. _landspeed .. '  #Red: ' .. numCoalition[1] .. '  #Blue: ' .. numCoalition[2], false)

	trigger.action.outText('group: ' .. _airplanedata.name .. '  callsign: ' .. callsign .. '  spawn: ' .. spawnIndex.name .. '  land: ' .. landIndex.name .. '  altitude: ' .. _landalt .. '  speed: ' .. _landspeed .. '  #Red: ' .. numCoalition[1] .. '  #Blue: ' .. numCoalition[2], 10)

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
