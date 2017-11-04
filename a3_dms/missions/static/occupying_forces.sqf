/*
	DMS static Mission written by Sir Joker
	difficulty selection system by Defent and eraser1 - reworked by [CiC]red_ned
	
	Mission:
	occupying forces
*/
DMS_AI_KillPercent					= 80;
// For logging purposes
_num = DMS_MissionCount;

// Set mission side (only "bandit" is supported for now)
_side = "bandit";

//** Missionspositionen
_pos = [12456.7,14223.4,0.002]; // Hotel Kiste
_pos1 = [12460.8,14242.6,0.002]; //group Hotel
_pos2 = [12173,14280,0]; // Turm Kiste
_pos3 = [12750.7,14333.9,0.002]; //Helipad Strand Kiste
_pos4 = [12672,14172,0]; //Inselmitte
_pos5 = [13267.2,13655.7,0];  //Fähre
_pos6 = [12499.5,14236.9,0]; //vehiclespawn
_pos7 = [12394.6,14230,0];  //Pat1_group
_pos7a = [12403.9,14233.3,0.00164795];//pat1
_pos8 = [13146.2,13772.5,0.002];  //pat2
_pos8a = [13135.4,13766.4,0.00140238]; //pat2_group
_pos9 = [13268.7,13737.8,0];  //MilCamp Fähre
_pos10 = [12269,13998,0]; //Ipota
_pos11 = [12191.1,14286.3,0.00151443];



//////////////////////////////////////////////////////////////////////////////////////////////////////////
//  LOOT
//** Lootkisten erstellen START ************************************************************************
private _crate = ["Exile_Container_SupplyBox",_pos] call DMS_fnc_SpawnCrate;
private _crate1 = ["I_CargoNet_01_ammo_F",_pos2] call DMS_fnc_SpawnCrate;
private _crate2 = ["I_CargoNet_01_ammo_F",_pos3] call DMS_fnc_SpawnCrate;
private _crate3 = ["I_CargoNet_01_ammo_F",_pos4] call DMS_fnc_SpawnCrate;
//** Lootkisten erstellen ENDE *************************************************************************


//** Persistente Fahrzeuge START ***********************************************************************
_pinCode = (1000 +(round (random 8999)));
_vehicle1 = ["Burnes_MK10_1",[(_pos5 select 0) -1, (_pos5 select 1) -1],_pinCode,false] call DMS_fnc_SpawnPersistentVehicle;
_vehicle2 = ["Exile_Car_QilinUnarmed",[(_pos6 select 0) -1, (_pos6 select 1) -1],_pinCode,true] call DMS_fnc_SpawnPersistentVehicle;
//** Persistente Fahrzeuge ENDE ***********************************************************************


//** Lootmenge ****************************************************************************************
_crate_weapons 		= (8 + (round (random 9)));
_crate_items 		= (8 + (round (random 10)));
_crate_backpacks 	= (4 + (round (random 1)));

//** Lootinhalt ****************************************************************************************
_crate_loot_values =
[
	_crate_weapons,
	[_crate_items,DMS_BoxBaseParts],
	_crate_backpacks
];	
// LOOT ENDE
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////////////////////////////
//  AI erstellen
//** Gruppengroesse****************************
_AICount = (5 + (round (random 5)));
_AICountVeh = 3;

//** Infantriegruppen erstellen
_group1 = [_pos1,_AICount,"hardcore","random",_side] call DMS_fnc_SpawnAIGroup; //Hotel
_group2 = [_pos11,_AICount,"hardcore","random",_side] call DMS_fnc_SpawnAIGroup; //Turm
_group3 = [_pos3,_AICount,"hardcore","random",_side] call DMS_fnc_SpawnAIGroup; //Helipad
_group4 = [_pos4,_AICount,"hardcore","random",_side] call DMS_fnc_SpawnAIGroup; //Inselmitte
_group5 = [_pos9,_AICount,"hardcore","random",_side] call DMS_fnc_SpawnAIGroup; //MilCamp Faehre
_group6 = [_pos10,_AICount,"hardcore","random",_side] call DMS_fnc_SpawnAIGroup;  //Ipota
_group7 = [_pos7a,_AICountVeh,"hardcore","random",_side] call DMS_fnc_SpawnAIGroup; // grp pat1
_group8 = [_pos8a,_AICountVeh,"hardcore","random",_side] call DMS_fnc_SpawnAIGroup; // grp pat2


//** Verstaerkung
_groupReinforcementsInfo = [];

_veh1 =
[
	[_pos7,_pos8],
	_group7,
	"assault",
	_difficulty,
	_side
] call DMS_fnc_SpawnAIVehicle;

_veh2 =
[
	[_pos8,_pos7],
	_group8,
	"assault",
	_difficulty,
	_side
] call DMS_fnc_SpawnAIVehicle;
	
// AI erstellen ENDE
/////////////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Mission Monitoring
//** Definiere MissionAIUnits
_missionAIUnits = [_group1,_group2,_group3,_group4,_group5];

//** Definiere Missions Objekte
_missionObjs = [
		[_veh1, _veh2],
		[_vehicle1, _vehicle2],
		[[_crate,_crate_loot_values],[_crate1,_crate_loot_values],[_crate2,_crate_loot_values],[_crate3,_crate_loot_values],[_vehicle1,_crate_loot_values]]
	];

// Define Mission Start message
_msgStart = ['#FFFF00', "Occupying Forces entered an Island! Eliminate them and take the supplies!"];

// Define Mission Win message
_msgWIN = ['#0080ff',format ["Convicts have successfully eliminated the Occupying Forces!  The code to claim the ferry is %1...",_pinCode]];

// Define Mission Lose message
_msgLOSE = ['#FF0000',"Occupying Forces left the island with the cargo boxes"];

// Define mission name (for map marker and logging)
_missionName = "Occupying Forces";

// Create Markers
_markers =
[
	_pos,
	_missionName,
	"hardcore"
] call DMS_fnc_CreateMarker;

// Record time here (for logging purposes, otherwise you could just put "diag_tickTime" into the "DMS_AddMissionToMonitor" parameters directly)
_time = diag_tickTime;

// Parse and add mission info to missions monitor
_added =
[
	_pos,
	[
	["kill",_group1],
	["kill",_group2],
	["kill",_group3],
	["kill",_group4],
	["kill",_group5],
	["kill",_group6],
	["kill",_group7],
	["kill",_group8],	
	["playerNear",[_crate,300]]
	],
	[],
	[
		_time,
		DMS_StaticMissionTimeOut call DMS_fnc_SelectRandomVal
	],
	_missionAIUnits,
	_missionObjs,
	[_missionName,_msgWIN,_msgLOSE],
	_markers,
	_side,
	"hardcore",
	[],
    [
        [
            [
                _vehicle2,
                {_this setVariable ["ExileMoney",15000,true]}                       
            ]
        ],
        [],
        {},
        {}
    ]
] call DMS_fnc_AddMissionToMonitor_Static;



// Check to see if it was added correctly, otherwise delete the stuff
if !(_added) exitWith
{
	diag_log format ["DMS ERROR :: Attempt to set up mission %1 with invalid parameters for DMS_fnc_AddMissionToMonitor_Static! Deleting mission objects and resetting DMS_MissionCount.",_missionName];

	_cleanup = [];
	{
		_cleanup pushBack _x;
	} forEach _missionAIUnits;

	_cleanup pushBack ((_missionObjs select 0)+(_missionObjs select 1));

	{
		_cleanup pushBack (_x select 0);
	} foreach (_missionObjs select 2);

	_cleanup call DMS_fnc_CleanUp;


	// Delete the markers directly
	{deleteMarker _x;} forEach _markers;


	// Reset the mission count
	DMS_MissionCount = DMS_MissionCount - 1;
};


// Notify players
[_missionName,_msgStart] call DMS_fnc_BroadcastMissionStatus;



if (DMS_DEBUG) then
{
	(format ["MISSION: (%1) :: Mission #%2 started at %3 with %4 AI units and %5 difficulty at time %6",_missionName,_num,_pos,26,"hardcore",_time]) call DMS_fnc_DebugLog;
};
