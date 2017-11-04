/*
	Custom configs for Tanoa.
	Created by eraser1

	All of these configs exist in the main config. The configs below will simply override any config from the main config.
	Explanations to all of these configs also exist in the main config.
*/
DMS_findSafePosBlacklist append
[
	[[2901,12333],1600]		// Salt flats are blacklisted for Altis by default.
];

DMS_MinDistFromWestBorder			= 200;
DMS_MinDistFromEastBorder			= 200;
DMS_MinDistFromSouthBorder			= 200;
DMS_MinDistFromNorthBorder			= 200;

// Plenty of slopes
DMS_MinSurfaceNormal				= 0.8;

DMS_BanditMissionTypes append 
[
	["w_crates",10],
	["w_fishingboat",3],
	["w_mk10",2],
	["w_patrol",3],
	["w_udv",3]
];

DMS_StaticMissionTypes append
[
	["underwater_stash",1],
	["occupying_forces",1]
];

DMS_StaticMissionsOnServerStart append
[
	"underwater_stash",
	"occupying_forces"
];
