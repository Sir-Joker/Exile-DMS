/*
	DMS Aquatic Mission written by Sir Joker
	difficulty selection system by Defent and eraser1 - reworked by [CiC]red_ned
	
	Mission:
	MK10
	This Mission have an MK10 prize vehicle
	depends on: Burnes MK10
*/
/** find water position **/
_posSpawnCenter = 
[
[15977.3,4972.9,0],
[6436.44,34733.1,0],
[36357.2,35870.9,0]
];
_spawnCenter = selectRandom _posSpawnCenter; 
_min = 1; // minimum distance from the center position (Number) in meters
_max = 8000; // maximum distance from the center position (Number) in meters
_mindist = 1; // minimum distance from the nearest object (Number) in meters, ie. spawn at least this distance away from anything within x meters..
_water = 2; // water mode (Number)    0: cannot be in water , 1: can either be in water or not , 2: must be in water
_shoremode = 0; // 0: does not have to be at a shore , 1: must be at a shore
_pos = [_spawnCenter,_min,_max,_mindist,_water,800,_shoremode] call BIS_fnc_findSafePos;
/**water position end **/
/*Standard DMS */
private ["_num", "_side", "_pos", "_OK", "_difficulty", "_extraParams", "_AICount", "_group", "_type", "_launcher", "_staticGuns", "_crate1", "_vehicle", "_pinCode", "_class", "_veh", "_crate_loot_values", "_missionAIUnits", "_missionObjs", "_msgStart", "_msgWIN", "_msgLOSE", "_missionName", "_markers", "_time", "_added", "_cleanup", "_baseObjs", "_crate_weapons", "_crate_weapon_list", "_crate_items", "_crate_item_list", "_crate_backpacks", "_PossibleDifficulty"];

// For logging purposes
_num = DMS_MissionCount;

// Set mission side (only "bandit" is supported for now)
_side = "bandit";

// This part is unnecessary, but exists just as an example to format the parameters for "DMS_fnc_MissionParams" if you want to explicitly define the calling parameters for DMS_fnc_FindSafePos.
// It also allows anybody to modify the default calling parameters easily.
if ((isNil "_this") || {_this isEqualTo [] || {!(_this isEqualType [])}}) then
{
	_this =
	[
		[25,0,DMS_MinSurfaceNormal,DMS_SpawnZoneNearBlacklist,DMS_TraderZoneNearBlacklist,DMS_MissionNearBlacklist,DMS_PlayerNearBlacklist,100,DMS_ThrottleBlacklists],
		[
			[]
		],
		_this
	];
};
/*Standard DMS*/


/*Standard DMS*/
// Check calling parameters for manually defined mission position.
// You can define "_extraParams" to specify the vehicle classname to spawn, either as _classname or [_classname]
_OK = (_this call DMS_fnc_MissionParams) params
[
	["_pos","_pos ERROR",[[]],[3]],
	["_extraParams",[]]
];

if !(_OK) exitWith
{
	diag_log format ["DMS ERROR :: Called MISSION bandits.sqf with invalid parameters: %1",_this];
};
/*Standard DMS*/

///////////////////////////////////////////////////////////////////////////////////////////////////
//create possible difficulty
_difficulty = "hardcore";
/////////////////////////////////////////////////////////////////////////////////////////////////////

////////////////////////////////////////////////////////////////////////////////////////////////////
// difficulty settings

_AICount = (10 + (round (random 10)));
_crate_weapons 		= (8 + (round (random 9)));
_crate_items 		= (8 + (round (random 10)));
_crate_backpacks 	= (2 + (round (random 1)));

/////////////////////////////////////////////////////////////////////////////////////

/////////////////////////////////////////////////////////////////////////////////////
// AI Spawn						
_group =
[
	_pos,					// Position of AI
	_AICount,				// Number of AI
	_difficulty,			// "random","hardcore","difficult","moderate", or "easy"
	"diver", 				// "random","assault","MG","sniper" or "unarmed" OR [_type,_launcher]
	_side 					// "bandit","hero", etc.
] call DMS_fnc_SpawnAIGroup;

// add vehicle patrol
/*
	DMS_fnc_SpawnAIVehicle
	Created by eraser1

	Usage:
	[
		[
			_spawnPos,				// The position at which the AI vehicle will spawn
			_gotoPos				// (OPTIONAL) The position to which the AI vehicle will drive to. If it isn't defined, _spawnPos is used. <--- THIS IS NOT USED. I'm not sure why I included this.
		],
		_group,						// Group to which the AI units belongs to
		_class,						// Class: "random","assault","MG","sniper" or "unarmed"
		_difficulty,				// Difficulty: "random","static","hardcore","difficult","moderate", or "easy"
		_side,						// "bandit","hero", etc.
		_vehClass					// (OPTIONAL) String: classname of the Vehicle. Use "random" to select a random one from DMS_ArmedVehicles
	] call DMS_fnc_SpawnAIVehicle;

	Returns the spawned vehicle.
*/
_veh1 =
[
	[
		[(_pos select 0) -20,(_pos select 1)+50,0]
	],
	_group,
	"random",
	_difficulty,
	_side,
	"Exile_Boat_RHIB"
] call DMS_fnc_SpawnAIVehicle;

_veh2 =
[
	[
		[(_pos select 0) -50,(_pos select 1)+50,0]
	],
	_group,
	"random",
	_difficulty,
	_side,
	"Exile_Boat_RubberDuck_CSAT"
] call DMS_fnc_SpawnAIVehicle;

_veh3 =
[
	[
		[(_pos select 0) -50,(_pos select 1)+50,0]
	],
	_group,
	"random",
	_difficulty,
	_side,
	"B_Boat_Armed_01_minigun_F"
] call DMS_fnc_SpawnAIVehicle;
//////////////////////////////////////////////////////////////////////////////////////////


/////////////////////////////////////////////////////////////////////////////////////////
// Loot
// Create Crates
_crate1 = ["Box_NATO_Wps_F",_pos] call DMS_fnc_SpawnCrate;
_crate2 = ["Box_NATO_Wps_F",_pos] call DMS_fnc_SpawnCrate;

_crate_loot_values =
[
	_crate_weapons,			// Weapons
	[_crate_items,DMS_BoxBaseParts],		// Items + selection list
	_crate_backpacks		// Backpacks
];

////////////////////////////////////////////////////////////////////////////////////////////
// prize vehicle
_pinCode = (1000 +(round (random 8999)));
_spawnATL = false;
_vehicle = ["Burnes_MK10_1",[(_pos select 0) -10, (_pos select 1) -10],_pinCode,_spawnATL] call DMS_fnc_SpawnPersistentVehicle;

/////////////////////////////////////////////////////////////////////////////////////////////
// Define mission-spawned AI Units
_missionAIUnits =
[
	_group 		// We only spawned the single group for this mission
];

/// Define mission-spawned objects and loot values
/*example
// Define mission-spawned objects and loot values
_missionObjs =
[
	_staticGuns+_baseObjs+[_veh],		// armed AI vehicle, base objects, and static guns
	[_vehicle],							//this is prize vehicle
	[[_crate1,_crate_loot_values1]]		//this is prize crate
];
*/
_missionObjs =
[
	[_veh1]+[_veh2]+[_veh3],			// armed AI vehicle, base objects, and static guns
	[_vehicle],							//this is prize vehicle
	[[_crate1,_crate_loot_values],[_crate2,_crate_loot_values]]		//this is prize crate
];

// Define Mission Start message
_msgStart = ['#FFFF00',format["A ferry lost the cargo! Go, kill the patrol, get the ferry and the cargo crates.",_difficulty]];

// Define Mission Win message
_msgWIN = ['#0080ff',format ["Convicts have eliminated the ferry patrol!  The code to claim the ferry is %1...",_pinCode]];

// Define Mission Lose message
_msgLOSE = ['#FF0000',"The patrol escaped with the ferry!"];

// Define mission name (for map markers, mission messages, and logging)
_missionName = "Ferry";

// Create Markers
_markers =
[
	_pos,
	_missionName,
	_difficulty
] call DMS_fnc_CreateMarker;

// Record time here (for logging purposes, otherwise you could just put "diag_tickTime" into the "DMS_AddMissionToMonitor" parameters directly)
_time = diag_tickTime;

// Parse and add mission info to missions monitor
_added =
[
	_pos,
	[
		[
			"kill",
			_group
		],
		[
			"playerNear",
			[_pos,DMS_playerNearRadius]
		]
	],
	[
		_time,
		(DMS_MissionTimeOut select 0) + random((DMS_MissionTimeOut select 1) - (DMS_MissionTimeOut select 0))
	],
	_missionAIUnits,
	_missionObjs,
	[_missionName,_msgWIN,_msgLOSE],
	_markers,
	_side,
	_difficulty,
	[]
] call DMS_fnc_AddMissionToMonitor;

// Check to see if it was added correctly, otherwise delete the stuff
if !(_added) exitWith
{
	diag_log format ["DMS ERROR :: Attempt to set up mission %1 with invalid parameters for DMS_AddMissionToMonitor! Deleting mission objects and resetting DMS_MissionCount.",_missionName];

	// Delete AI units and the crate. I could do it in one line but I just made a little function that should work for every mission (provided you defined everything correctly)
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
	(format ["MISSION: (%1) :: Mission #%2 started at %3 with %4 AI units and %5 difficulty at time %6",_missionName,_num,_pos,_AICount,_difficulty,_time]) call DMS_fnc_DebugLog;
};