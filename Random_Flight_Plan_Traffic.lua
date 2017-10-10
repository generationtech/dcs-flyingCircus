-- Randomly spawn a different kind of aircraft at different coalition airbase up to a limit of total spawned aircraft.
-- In the ME, just designate each coalition airbase assignment on the ME airbase object, not with target zones

do
--EDIT BELOW
intervall = math.random(20,60) 	--random repeat interval between (A and B) in seconds
maxCoalition = {25, 25} 	-- maximum number of red, blue units
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

	AircraftType = math.random(5,6) --random for utility airplane, bomber, attack, fighter, or helicopter

	if ((AircraftType >= 1) and (AircraftType <= 3)) then  -- UTILITY AIRCRAFT
		if (coalitionIndex == 1) then
			randomAirplane = math.random(13,21) -- random for airplane type; Red AC 13-21
		else
			randomAirplane = math.random(1,12) -- random for airplane type; Blue AC 1-12
		end

		if (randomAirplane == 1) then
			_aircrafttype = "An-26B"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "Georgian AF"
				_country = country.id.GEORGIA
				callsign = "GEORGIA An-26B"
			else
				_skin = "Ukraine AF"
				_country = country.id.UKRAINE
				callsign = "UKRAINE  An-26B"
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
			_skin = "15th Transport AB"
			_country = country.id.UKRAINE
			callsign = "UKRAINE An-30M"
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
				_skin = "US Air Force"
				_country = country.id.USA
				callsign = "USA C-130"
			elseif (subtype == 2) then
				_skin = "Belgian Air Force"
				_country = country.id.BELGIUM
				callsign = "BELGIUM C-130"
			elseif (subtype == 3) then
				_skin = "Canada's Air Force"
				_country = country.id.CANADA
				callsign = "CANADA C-130"
			elseif (subtype == 4) then
				_skin = "Royal Danish Air Force"
				_country = country.id.DENMARK
				callsign = "DENMARK C-130"
			elseif (subtype == 5) then
				_skin = "French Air Force"
				_country = country.id.FRANCE
				callsign = "FRANCE C-130"
			elseif (subtype == 6) then
				_skin = "Israel Defence Force"
				_country = country.id.ISRAEL
				callsign = "ISRAEL C-130"
			elseif (subtype == 7) then
				_skin = "Royal Norwegian Air Force"
				_country = country.id.NORWAY
				callsign = "NORWAY C-130"
			elseif (subtype == 8) then
				_skin = "Spanish Air Force"
				_country = country.id.SPAIN
				callsign = "SPAIN C-130"
			elseif (subtype == 9) then
				_skin = "Royal Netherlands Air Force"
				_country = country.id.THE_NETHERLANDS
				callsign = "THE_NETHERLANDS C-130"
			elseif (subtype == 10) then
				_skin = "Royal Air Force"
				_country = country.id.UK
				callsign = "UK C-130"
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
			_skin = "usaf standard"
			_country = country.id.USA
			callsign = "USA C-17A"
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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "E-2D Demo"
				callsign = "USA E-2C - E-2D Demo"
			else
				_skin = "VAW-125 Tigertails"
				callsign = "USA E-2C - VAW-125 Tigertails"
			end

			_country = country.id.USA
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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "nato"
				callsign = "USA E-3A - nato"
			else
				_skin = "usaf standard"
				callsign = "USA E-3A - usaf standard"
			end

			_country = country.id.USA
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

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "Ukrainian AF"
				callsign = "UKRAINE IL-76MD - Ukrainian AF"
			else
				_skin = "Ukrainian AF aeroflot"
				callsign = "UKRAINE IL-76MD - Ukrainian AF aeroflot"
			end

			_country = country.id.UKRAINE
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
			_skin = "Standard USAF"
			_country = country.id.USA
			callsign = "USA KC-135"
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
			_skin = "af standard"
			_country = country.id.UKRAINE
			callsign = "UKRAINE MiG-25RBT"
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
			_skin = "usaf standard"
			_country = country.id.USA
			callsign = "USA S-3B Tanker"
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
			_skin = "af standard"
			_country = country.id.UKRAINE
			callsign = "UKRAINE Su-24MR"
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
			_aircrafttype = "Yak-40"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "Georgian Airlines"
				_country = country.id.GEORGIA
				callsign = "GEORGIA Yak-40"
			else
				_skin = "Ukrainian"
				_country = country.id.UKRAINE
				callsign = "UKRAINE Yak-40"
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
		elseif (randomAirplane == 13) then
			_aircrafttype = "A-50"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_skin = "RF Air Force"
				callsign = "RUSSIA A-50 - RF Air Force"
			else
				_skin = "RF Air Force new"
				callsign = "RUSSIA A-50 - RF Air Force new"
			end

			_country = country.id.RUSSIA
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
		elseif (randomAirplane == 14) then
			_aircrafttype = "An-26B"

			subtype = math.random(1,2)
			if (subtype == 1) then

				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "RF Air Force"
					callsign = "RUSSIA An-26B - RF Air Force"
				else
					_skin = "Aeroflot"
					callsign = "RUSSIA An-26B - Aeroflot"
				end

				_country = country.id.RUSSIA
			else
				_skin = "Abkhazian AF"
				_country = country.id.ABKHAZIA
				callsign = "ABKHAZIA An-26B"
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
		elseif (randomAirplane == 15) then
			_aircrafttype = "An-30M"
			_skin = "RF Air Force"
			_country = country.id.RUSSIA
			callsign = "RUSSIA An-30M"
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
		elseif (randomAirplane == 16) then
			_aircrafttype = "C-130"
			_skin = "Turkish Air Force"
			_country = country.id.TURKEY
			callsign = "TURKEY C-130"
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
		elseif (randomAirplane == 17) then
			_aircrafttype = "IL-76MD"

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "FSB aeroflot"
				callsign = "RUSSIA IL-76MD - FSB aeroflot"
			elseif (subtype == 2) then
				_skin = "MVD aeroflot"
				callsign = "RUSSIA IL-76MD - MVD aeroflot"
			else
				_skin = "RF Air Force"
				callsign = "RUSSIA IL-76MD - RF Air Force"
			end

			_country = country.id.RUSSIA
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
		elseif (randomAirplane == 18) then
			_aircrafttype = "IL-78M"

			subtype = math.random(1,3)
			if (subtype == 1) then
				_skin = "RF Air Force"
				callsign = "RUSSIA IL-78M - RF Air Force"
			elseif (subtype == 2) then
				_skin = "RF Air Force aeroflot"
				callsign = "RUSSIA IL-78M - RF Air Force aeroflot"
			else
				_skin = "RF Air Force new"
				callsign = "RUSSIA IL-78M - RF Air Force new"
			end

			_country = country.id.RUSSIA
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
		elseif (randomAirplane == 19) then
			_aircrafttype = "MiG-25RBT"
			_country = country.id.RUSSIA
			_skin = "af standard"
			callsign = "RUSSIA MiG-25RBT"
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
		elseif (randomAirplane == 20) then
			_aircrafttype = "Su-24MR"
			_country = country.id.RUSSIA
			_skin = "af standard"
			callsign = "RUSSIA Su-24MR"
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
		elseif (randomAirplane == 21) then
			_aircrafttype = "Yak-40"
			_skin = "Aeroflot"
			_country = country.id.RUSSIA
			callsign = "RUSSIA Yak-40"
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

	elseif ((AircraftType == 4) or (AircraftType == 4)) then  -- BOMBERS
		if (coalitionIndex == 1) then
			randomBomber = math.random(11,15) -- random for airplane type; Red AC 11-15
		else
			randomBomber = math.random(1,10) -- random for airplane type; Blue AC 1-10
		end

		if (randomBomber == 1) then
			_aircrafttype = "B-1B"
			_country = country.id.USA
			_skin = "usaf standard"
			callsign = "USA B-1B"
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
			_skin = "usaf standard"
			_country = country.id.USA
			callsign = "USA B-52H"
			_payload =
			{
				["pylons"] =
				{
					[1] =
					{
						["CLSID"] = "{696CFFC4-0BDE-42A8-BE4B-0BE3D9DD723C}",
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
			_skin = "usaf standard"
			_country = country.id.USA
			callsign = "USA F-117A"
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
					callsign = "USA F-15E - 335th Fighter SQN (SJ)"
				else
					_skin = "492d Fighter SQN (LN)"
					callsign = "USA F-15E - 492d Fighter SQN (LN)"
				end
			else
				_country = country.id.ISRAEL
				_skin = "IDF No 69 Hammers Squadron"
				callsign = "ISRAEL F-15E - IDF No 69 Hammers Squadron"
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
			_skin = "NAVY Standard"
			_country = country.id.USA
			callsign = "USA S-3B"
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
			callsign = "UKRAINE Su-24M"
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
				callsign = "UK Tornado GR4 - bb of 14 squadron raf lossiemouth"
			elseif (subtype == 2) then
				_skin = "no. 9 squadron raf marham ab (norfolk)"
				callsign = "UK Tornado GR4 - no. 9 squadron raf marham ab (norfolk)"
			elseif (subtype == 3) then
				_skin = "no. 12 squadron raf lossiemouth ab (morayshire)"
				callsign = "UK Tornado GR4 - no. 12 squadron raf lossiemouth ab (morayshire)"
			elseif (subtype == 4) then
				_skin = "no. 14 squadron raf lossiemouth ab (morayshire)"
				callsign = "UK Tornado GR4 - no. 14 squadron raf lossiemouth ab (morayshire)"
			elseif (subtype == 5) then
				_skin = "no. 617 squadron raf lossiemouth ab (morayshire)"
				callsign = "UK Tornado GR4 - no. 617 squadron raf lossiemouth ab (morayshire)"
			else
				_skin = "o of ii (ac) squadron raf marham"
				callsign = "UK Tornado GR4 - o of ii (ac) squadron raf marham"
			end

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
					callsign = "GERMANY Tornado IDS - aufklarungsgeschwader 51 `immelmann` jagel ab luftwaffe"
				elseif (subtype1 == 2) then
					_skin = "jagdbombergeschwader 31 `boelcke` norvenich ab luftwaffe"
					callsign = "GERMANY Tornado IDS - jagdbombergeschwader 31 `boelcke` norvenich ab luftwaffe"
				elseif (subtype1 == 3) then
					_skin = "jagdbombergeschwader 32 lechfeld ab luftwaffe"
					callsign = "GERMANY Tornado IDS - jagdbombergeschwader 32 lechfeld ab luftwaffe"
				elseif (subtype1 == 4) then
					_skin = "jagdbombergeschwader 33 buchel ab no. 43+19 experimental scheme"
					callsign = "GERMANY Tornado IDS - jagdbombergeschwader 33 buchel ab no. 43+19 experimental scheme"
				else
					_skin = "marinefliegergeschwader 2 eggebek ab marineflieger"
					callsign = "GERMANY Tornado IDS - marinefliegergeschwader 2 eggebek ab marineflieger"
				end
			else
				_country = country.id.ITALY
				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "ITA Tornado (Sesto Stormo Diavoli Rossi)"
					callsign = "ITALY Tornado IDS - ITA Tornado (Sesto Stormo Diavoli Rossi)"
				elseif (subtype1 == 2) then
					_skin = "ITA Tornado Black"
					callsign = "ITALY Tornado IDS - ITA Tornado Black"
				elseif (subtype1 == 3) then
					_skin = "ITA Tornado MM7042"
					callsign = "ITALY Tornado IDS - ITA Tornado MM7042"
				else
					_skin = "ITA Tornado MM55004"
					callsign = "ITALY Tornado IDS - ITA Tornado MM55004"
				end
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
			callsign = "UKRAINE Tu-22M3"
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
			_skin = "af standard"
			_country = country.id.UKRAINE
			callsign = "UKRAINE Tu-95MS"
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
			callsign = "RUSSIA Su-24M"
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
			_skin = "af standard"
			_country = country.id.RUSSIA
			callsign = "RUSSIA Tu-142"
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
			callsign = "RUSSIA Tu-160"
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
			callsign = "RUSSIA Tu-22M3"
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
			_skin = "af standard"
			_country = country.id.RUSSIA
			callsign = "RUSSIA Tu-95MS"
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

	elseif ((AircraftType >= 5) or (AircraftType <= 6)) then  -- ATTACK AIRCRAFT
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
				callsign = "USA A-10A - 104th FS Maryland ANG, Baltimore (MD)"
			elseif (subtype == 2) then
				_skin = "118th FS Bradley ANGB, Connecticut (CT)"
				callsign = "USA A-10A - 118th FS Bradley ANGB, Connecticut (CT)"
			elseif (subtype == 3) then
				_skin = "118th FS Bradley ANGB, Connecticut (CT) N621"
				callsign = "USA A-10A - 118th FS Bradley ANGB, Connecticut (CT) N621"
			elseif (subtype == 4) then
				_skin = "172nd FS Battle Creek ANGB, Michigan (BC)"
				callsign = "USA A-10A - 172nd FS Battle Creek ANGB, Michigan (BC)"
			elseif (subtype == 5) then
				_skin = "184th FS Arkansas ANG, Fort Smith (FS)"
				callsign = "USA A-10A - 184th FS Arkansas ANG, Fort Smith (FS)"
			elseif (subtype == 6) then
				_skin = "190th FS Boise ANGB, Idaho (ID)"
				callsign = "USA A-10A - 190th FS Boise ANGB, Idaho (ID)"
			elseif (subtype == 7) then
				_skin = "23rd TFW England AFB (EL)"
				callsign = "USA A-10A - 23rd TFW England AFB (EL)"
			elseif (subtype == 8) then
				_skin = "25th FS Osan AB, Korea (OS)"
				callsign = "USA A-10A - 25th FS Osan AB, Korea (OS)"
			elseif (subtype == 9) then
				_skin = "354th FS Davis Monthan AFB, Arizona (DM)"
				callsign = "USA A-10A - 354th FS Davis Monthan AFB, Arizona (DM)"
			elseif (subtype == 10) then
				_skin = "355th FS Eielson AFB, Alaska (AK)"
				callsign = "USA A-10A - 355th FS Eielson AFB, Alaska (AK)"
			elseif (subtype == 11) then
				_skin = "357th FS Davis Monthan AFB, Arizona (DM)"
				callsign = "USA A-10A - 357th FS Davis Monthan AFB, Arizona (DM)"
			elseif (subtype == 12) then
				_skin = "358th FS Davis Monthan AFB, Arizona (DM)"
				callsign = "USA A-10A - 358th FS Davis Monthan AFB, Arizona (DM)"
			elseif (subtype == 13) then
				_skin = "422nd TES Nellis AFB, Nevada (OT)"
				callsign = "USA A-10A - 422nd TES Nellis AFB, Nevada (OT)"
			elseif (subtype == 14) then
				_skin = "47th FS Barksdale AFB, Louisiana (BD)"
				callsign = "USA A-10A - 47th FS Barksdale AFB, Louisiana (BD)"
			elseif (subtype == 15) then
				_skin = "66th WS Nellis AFB, Nevada (WA)"
				callsign = "USA A-10A - 66th WS Nellis AFB, Nevada (WA)"
			elseif (subtype == 16) then
				_skin = "74th FS Moody AFB, Georgia (FT)"
				callsign = "USA A-10A - 74th FS Moody AFB, Georgia (FT)"
			elseif (subtype == 17) then
				_skin = "81st FS Spangdahlem AB, Germany (SP) 1"
				callsign = "USA A-10A - 81st FS Spangdahlem AB, Germany (SP) 1"
			else
				_skin = "81st FS Spangdahlem AB, Germany (SP) 2"
				callsign = "USA A-10A - 81st FS Spangdahlem AB, Germany (SP) 2"
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
		elseif (randomAttack == 2)	then
			_aircrafttype = "A-10C"

			subtype = math.random(1,15)
			if (subtype == 1) then
				_country = country.id.USA
				subtype1 = math.random(1,18)
				if (subtype1 == 1) then
					_skin = "104th FS Maryland ANG, Baltimore (MD)"
					callsign = "USA A-10C - 104th FS Maryland ANG, Baltimore (MD)"
				elseif (subtype1 == 2) then
					_skin = "118th FS Bradley ANGB, Connecticut (CT)"
					callsign = "USA A-10C - 118th FS Bradley ANGB, Connecticut (CT)"
				elseif (subtype1 == 3) then
					_skin = "118th FS Bradley ANGB, Connecticut (CT) N621"
					callsign = "USA A-10C - 118th FS Bradley ANGB, Connecticut (CT) N621"
				elseif (subtype1 == 4) then
					_skin = "172nd FS Battle Creek ANGB, Michigan (BC)"
					callsign = "USA A-10C - 172nd FS Battle Creek ANGB, Michigan (BC)"
				elseif (subtype1 == 5) then
					_skin = "184th FS Arkansas ANG, Fort Smith (FS)"
					callsign = "USA A-10C - 184th FS Arkansas ANG, Fort Smith (FS)"
				elseif (subtype1 == 6) then
					_skin = "190th FS Boise ANGB, Idaho (ID)"
					callsign = "USA A-10C - 190th FS Boise ANGB, Idaho (ID)"
				elseif (subtype1 == 7) then
					_skin = "23rd TFW England AFB (EL)"
					callsign = "USA A-10C - 23rd TFW England AFB (EL)"
				elseif (subtype1 == 8) then
					_skin = "25th FS Osan AB, Korea (OS)"
					callsign = "USA A-10C - 25th FS Osan AB, Korea (OS)"
				elseif (subtype1 == 9) then
					_skin = "354th FS Davis Monthan AFB, Arizona (DM)"
					callsign = "USA A-10C - 354th FS Davis Monthan AFB, Arizona (DM)"
				elseif (subtype1 == 10) then
					_skin = "355th FS Eielson AFB, Alaska (AK)"
					callsign = "USA A-10C - 355th FS Eielson AFB, Alaska (AK)"
				elseif (subtype1 == 11) then
					_skin = "357th FS Davis Monthan AFB, Arizona (DM)"
					callsign = "USA A-10C - 357th FS Davis Monthan AFB, Arizona (DM)"
				elseif (subtype1 == 12) then
					_skin = "358th FS Davis Monthan AFB, Arizona (DM)"
					callsign = "USA A-10C - 358th FS Davis Monthan AFB, Arizona (DM)"
				elseif (subtype1 == 13) then
					_skin = "422nd TES Nellis AFB, Nevada (OT)"
					callsign = "USA A-10C - 422nd TES Nellis AFB, Nevada (OT)"
				elseif (subtype1 == 14) then
					_skin = "47th FS Barksdale AFB, Louisiana (BD)"
					callsign = "USA A-10C - 47th FS Barksdale AFB, Louisiana (BD)"
				elseif (subtype1 == 15) then
					_skin = "66th WS Nellis AFB, Nevada (WA)"
					callsign = "USA A-10C - 66th WS Nellis AFB, Nevada (WA)"
				elseif (subtype1 == 16) then
					_skin = "74th FS Moody AFB, Georgia (FT)"
					callsign = "USA A-10C - 74th FS Moody AFB, Georgia (FT)"
				elseif (subtype1 == 17) then
					_skin = "81st FS Spangdahlem AB, Germany (SP) 1"
					callsign = "USA A-10C - 81st FS Spangdahlem AB, Germany (SP) 1"
				else
					_skin = "81st FS Spangdahlem AB, Germany (SP) 2"
					callsign = "USA A-10C - 81st FS Spangdahlem AB, Germany (SP) 2"
				end
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = "Australia Notional RAAF"
				callsign = "AUSTRALIA A-10C - Australia Notional RAAF"
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_skin = "A-10 Grey"
				callsign = "BELGIUM A-10C - A-10 Grey"
			elseif (subtype == 4) then
				_country = country.id.CANADA
				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Fictional Canadian Air Force Pixel Camo"
					callsign = "CANADA A-10C - Fictional Canadian Air Force Pixel Camo"
				elseif (subtype1 == 2) then
					_skin = "Canada RCAF 409 Squadron"
					callsign = "CANADA A-10C - Canada RCAF 409 Squadron"
				else
					_skin = "Canada RCAF 442 Snow Scheme"
					callsign = "CANADA A-10C - Canada RCAF 442 Snow Scheme"
				end
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_skin = "A-10 Grey"
				callsign = "DENMARK A-10C - A-10 Grey"
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_skin = "Fictional France Escadron de Chasse 03.003 ARDENNES"
				callsign = "FRANCE A-10C - Fictional France Escadron de Chasse 03.003 ARDENNES"
			elseif (subtype == 7) then
				_country = country.id.GEORGIA
				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Fictional Georgian Grey"
					callsign = "GEORGIA A-10C - Fictional Georgian Grey"
				else
					_skin = "Fictional Georgian Olive"
					callsign = "GEORGIA A-10C - Fictional Georgian Olive"
				end
			elseif (subtype == 8) then
				_country = country.id.GERMANY
				subtype1 = math.random(1,2)
				if (subtype1 == 1) then
					_skin = "Fictional German 3322"
					callsign = "GERMANY A-10C - Fictional German 3322"
				else
					_skin = "Fictional German 3323"
					callsign = "GERMANY A-10C - Fictional German 3323"
				end
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_skin = "Fictional Israel 115 Sqn Flying Dragon"
				callsign = "ISRAEL A-10C - Fictional Israel 115 Sqn Flying Dragon"
			elseif (subtype == 10) then
				_country = country.id.ITALY
				_skin = "Fictional Italian AM (23Gruppo)"
				callsign = "ITALY A-10C - Fictional Italian AM (23Gruppo)"
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_skin = "Fictional Royal Norwegian Air Force"
				callsign = "NORWAY A-10C - Fictional Royal Norwegian Air Force"
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Fictional Spanish 12nd Wing"
					callsign = "SPAIN A-10C - Fictional Spanish 12nd Wing"
				elseif (subtype1 == 2) then
					_skin = "Fictional Spanish AGA"
					callsign = "SPAIN A-10C - Fictional Spanish AGA"
				else
					_skin = "Fictional Spanish Tritonal"
					callsign = "SPAIN A-10C - Fictional Spanish Tritonal"
				end
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_skin = "A-10 Grey"
				callsign = "THE_NETHERLANDS A-10C - A-10 Grey"
			elseif (subtype == 14) then
				_country = country.id.UK
				_skin = "A-10 Grey"
				callsign = "UK A-10C - A-10 Grey"
			else
				_country = country.id.UKRAINE
				_skin = "Fictional Ukraine Air Force 1"
				callsign = "UKRAINE A-10C - Fictional Ukraine Air Force 1"
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
				_skin = "100sqn XX189"
				callsign = "USA Hawk - 100sqn XX189"
			elseif (subtype == 2) then
				_country = country.id.AUSTRALIA
				_skin = "100sqn XX189"
				callsign = "AUSTRALIA Hawk - 100sqn XX189"
			elseif (subtype == 3) then
				_country = country.id.BELGIUM
				_skin = "100sqn XX189"
				callsign = "BELGIUM Hawk - 100sqn XX189"
			elseif (subtype == 4) then
				_country = country.id.CANADA
				_skin = "100sqn XX189"
				callsign = "CANADA Hawk - 100sqn XX189"
			elseif (subtype == 5) then
				_country = country.id.DENMARK
				_skin = "100sqn XX189"
				callsign = "DENMARK Hawk - 100sqn XX189"
			elseif (subtype == 6) then
				_country = country.id.FRANCE
				_skin = "100sqn XX189"
				callsign = "FRANCE Hawk - 100sqn XX189"
			elseif (subtype == 7) then
				_country = country.id.GERMANY
				_skin = "100sqn XX189"
				callsign = "GERMANY Hawk - 100sqn XX189"
			elseif (subtype == 8) then
				_country = country.id.GEORGIA
				_skin = "100sqn XX189"
				callsign = "GEORGIA Hawk - 100sqn XX189"
			elseif (subtype == 9) then
				_country = country.id.ISRAEL
				_skin = "100sqn XX189"
				callsign = "ISRAEL Hawk - 100sqn XX189"
			elseif (subtype == 10) then
				_country = country.id.ITALY
				_skin = "100sqn XX189"
				callsign = "ITALY Hawk - 100sqn XX189"
			elseif (subtype == 11) then
				_country = country.id.NORWAY
				_skin = "100sqn XX189"
				callsign = "NORWAY Hawk - 100sqn XX189"
			elseif (subtype == 12) then
				_country = country.id.SPAIN
				_skin = "100sqn XX189"
				callsign = "SPAIN Hawk - 100sqn XX189"
			elseif (subtype == 13) then
				_country = country.id.THE_NETHERLANDS
				_skin = "100sqn XX189"
				callsign = "THE_NETHERLANDS Hawk - 100sqn XX189"
			elseif (subtype == 14) then
				_country = country.id.UK
				_skin = "100sqn XX189"
				callsign = "UK Hawk - 100sqn XX189"
			else
				_country = country.id.UKRAINE
				_skin = "100sqn XX189"
				callsign = "UKRAINE Hawk - 100sqn XX189"
			end

			-- no payload in liveries yet

		elseif (randomAttack == 4)	then
			_aircrafttype = "L-39ZA"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.GEORGIA
				_skin = "Georgian Air Force"
				callsign = "GEORGIA - Georgian Air Force"
			else
				_country = country.id.UKRAINE
				_skin = "Ukraine Air Force 1"
				callsign = "UKRAINE - Ukraine Air Force 1"
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
			callsign = "UKRAINE MiG-27K"
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
				callsign = "UKRAINE Su-17M4 - af standard"
			elseif (subtype == 2) then
				_skin = "af standard (worn-out)"
				callsign = "UKRAINE Su-17M4 - af standard (worn-out)"
			else
				_skin = "shap limanskoye ab"
				callsign = "UKRAINE Su-17M4 - shap limanskoye ab"
			end

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
					callsign = "GEORGIA Su-25 - `scorpion` demo scheme (native)"
				else
					_skin = "field camo scheme #1 (native)"
					callsign = "GEORGIA Su-25 - field camo scheme #1 (native)"
				end
			else
				_country = country.id.UKRAINE
				subtype1 = math.random(1,4)
				if (subtype1 == 1) then
					_skin = "broken camo scheme #1 (native). 299th oshap"
					callsign = "UKRAINE Su-25 - broken camo scheme #1 (native). 299th oshap"
				elseif (subtype1 == 2) then
					_skin = "broken camo scheme #2 (native). 452th shap"
					callsign = "UKRAINE Su-25 - broken camo scheme #2 (native). 452th shap"
				elseif (subtype1 == 3) then
					_skin = "petal camo scheme #1 (native). 299th brigade"
					callsign = "UKRAINE Su-25 - petal camo scheme #1 (native). 299th brigade"
				else
					_skin = "petal camo scheme #2 (native). 299th brigade"
					callsign = "UKRAINE Su-25 - petal camo scheme #2 (native). 299th brigade"
				end
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
				callsign = "GEORGIA Su-25T - af standard"
			else
				_skin = "af standard 1"
				callsign = "GEORGIA Su-25T - af standard 1"
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
					callsign = "RUSSIA A-10C - Fictional Russian Air Force 1"
				else
					_skin = "Fictional Russian Air Force 2"
					callsign = "RUSSIA A-10C - Fictional Russian Air Force 2"
				end
			else
				_country = country.id.TURKEY
				_skin = "A-10 Grey"
				callsign = "TURKEY A-10C - A-10 Grey"
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
				callsign = "RUSSIA Hawk - 100sqn XX189"
			elseif (subtype == 2) then
				_country = country.id.ABKHAZIA
				_skin = "100sqn XX189"
				callsign = "ABKHAZIA Hawk - 100sqn XX189"
			elseif (subtype == 3) then
				_country = country.id.SOUTH_OSETIA
				_skin = "100sqn XX189"
				callsign = "SOUTH_OSETIA Hawk - 100sqn XX189"
			else
				_country = country.id.TURKEY
				_skin = "100sqn XX189"
				callsign = "TURKEY Hawk - 100sqn XX189"
			end

			-- no payload in liveries yet

		elseif (randomAttack == 11)	then
			_aircrafttype = "L-39ZA"

			subtype = math.random(1,2)
			if (subtype == 1) then
				_country = country.id.RUSSIA

				subtype1 = math.random(1,3)
				if (subtype1 == 1) then
					_skin = "Czech Air Force"
					callsign = "RUSSIA - Czech Air Force"
				elseif (subtype1 == 2) then
					_skin = "Russian Air Force 1"
					callsign = "RUSSIA - Russian Air Force 1"
				else
					_skin = "Russian Air Force Old"
					callsign = "RUSSIA - Russian Air Force Old"
				end
			else
				_country = country.id.ABKHAZIA
				_skin = "Abkhazian Air Force"
				callsign = "ABKHAZIA - Abkhazian Air Force"
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
			callsign = "RUSSIA MiG-27K - af standard"
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
				callsign = "RUSSIA Su-17M4 - af standard"
			else
				_skin = "af standard (worn-out)"
				callsign = "RUSSIA Su-17M4 - af standard (worn-out)"
			end

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
					callsign = "RUSSIA Su-25 - field camo scheme #1 (native)"
				elseif (subtype1 == 2) then
					_skin = "field camo scheme #2 (native). 960th shap"
					callsign = "RUSSIA Su-25 - field camo scheme #2 (native). 960th shap"
				elseif (subtype1 == 3) then
					_skin = "field camo scheme #3 (worn-out). 960th shap"
					callsign = "RUSSIA Su-25 - field camo scheme #3 (worn-out). 960th shap"
				else
					_skin = "forest camo scheme #1 (native)"
					callsign = "RUSSIA Su-25 - forest camo scheme #1 (native)"
				end
			else
				_country = country.id.ABKHAZIA
				_skin = "Abkhazian Air Force"
				callsign = "ABKHAZIA Su-25 - Abkhazian Air Force"
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
				callsign = "RUSSIA Su-25T - af standard 1"
			elseif (subtype == 2) then
				_skin = "af standard 2"
				callsign = "RUSSIA Su-25T - af standard 2"
			else
				_skin = "su-25t test scheme"
				callsign = "RUSSIA Su-25T - su-25t test scheme"
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
			callsign = "RUSSIA Su-25TM - Flight Research Institute  VVS"

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

	elseif ((AircraftType >= 7) and (AircraftType <= 9)) then  -- FIGHTERS
		if (coalitionIndex == 1) then
			randomFighter = math.random(18,36) -- random for airplane type; Red AC 18-36
		else
			randomFighter = math.random(1,17) -- random for airplane type; Blue AC 1-17
		end

		if (randomFighter == 1) then






		elseif (randomFighter == 3)	then

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

		elseif (randomFighter == 12) then

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


		elseif (randomFighter == 22) then

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

		elseif (randomFighter == 27) then

		elseif (randomFighter == 29) then

		elseif (randomFighter == 30) then

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

		elseif (randomFighter == 36) then


		end

	elseif ((AircraftType >= 10) or (AircraftType <= 10)) then -- HELICOPTERS
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
