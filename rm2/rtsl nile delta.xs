// NILE DELTA
// VBP 5.0

include "rmx 5-0-0.xs";

void main() {

	// Text
	rmSetStatusText("", 0.01);

	// RM X Setup.
	rmxInit("Nile Delta", false, false, false);

	// Set size
	int playerTiles = 10800;
	if (cMapSize == 1) playerTiles = 10400;
	int size = 2.0 * sqrt(cNumberNonGaiaPlayers * playerTiles / 0.9);
	if (cNumberNonGaiaPlayers < 3) rmSetMapSize(size, size);
	else if (cNumberNonGaiaPlayers < 5) rmSetMapSize(size * 0.98, size * 1.08);
	else if (cNumberNonGaiaPlayers < 7) rmSetMapSize(size * 0.81, size * 0.95);
	else rmSetMapSize(size * 0.72, size * 0.85);

	// Set up default water
	rmSetSeaLevel(3.0);
	rmSetSeaType("Egyptian Nile");

	// Init map
	rmTerrainInitialize("water");

	// Define classes
	int classLand = rmDefineClass("land");
	int classWater = rmDefineClass("water");
	int classShore = rmDefineClass("shore");
	int classBorder = rmDefineClass("border");
	int classShallows = rmDefineClass("shallows");
	int classPlayer = rmDefineClass("players");
	int classVirtualSplit = rmDefineClass("virtual split");
	int classCenterline = rmDefineClass("centerline");
	int classForest = rmDefineClass("forest");
	int classBonusHunt = rmDefineClass("bonus hunt");
	rmDefineClass("starting settlement");

	// Constraints
	// General constraints
	int shortAvoidAll = rmCreateTypeDistanceConstraint("short avoid all", "all", 5.0);
	int mediumAvoidAll = rmCreateTypeDistanceConstraint("medium avoid all", "all", 8.0);
	int edgeConstraint = rmCreateBoxConstraint("edge constraint", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0 - rmXTilesToFraction(8), 1.0 - rmZTilesToFraction(8));
	int shortEdgeConstraint = rmCreateBoxConstraint("short edge constraint", rmXTilesToFraction(2), rmZTilesToFraction(2), 1.0 - rmXTilesToFraction(2), 1.0 - rmZTilesToFraction(2));
	int virtualSplitConstraint = rmCreateClassDistanceConstraint("virtual split", classVirtualSplit, 4 * cNumberNonGaiaPlayers);
	int constructCenterline = rmCreateClassDistanceConstraint("stay away from other circles", classCenterline, 0.01);
	int centerlineConstraint = rmCreateClassDistanceConstraint("center line", classVirtualSplit, 0.01);
	int mediumCenterlineConstraint = rmCreateClassDistanceConstraint("medium avoid centerline", classCenterline, 30.0);
	int playerConstraint = rmCreateClassDistanceConstraint("stay away from players", classPlayer, 40.0);

	// Terrain constraints
	int hugeShallow = 0;
	if (cNumberNonGaiaPlayers < 5) hugeShallow = rmCreateBoxConstraint("create shallow water", 0.0, 0.0, 1.0, 0.4 + 0.05 * cNumberNonGaiaPlayers, 0.01);
	else hugeShallow = rmCreateBoxConstraint("create shallow water", 0.0, 0.0, 1.0, 0.64, 0.01);
	int shoreShallow = rmCreateBoxConstraint("shore shallow block", 0.45, 0.0, 0.55, 1.0, 0.01);
	int borderShallow = rmCreateBoxConstraint("border shallow block", 0.4, 0.0, 0.6, 1.0, 0.01);
	int shallowConstraint = rmCreateClassDistanceConstraint("avoid shallow water", classShallows, 0.1);
	int waterConstraint = rmCreateClassDistanceConstraint("avoid water", classWater, 0.1);
	int shortWaterConstraint = rmCreateClassDistanceConstraint("short avoid water", classWater, 5.0);
	int semiShortWaterConstraint = rmCreateClassDistanceConstraint("semi short avoid water", classWater, 15.0);
	int mediumWaterConstraint = rmCreateClassDistanceConstraint("medium avoid water", classWater, 25.0);
	int farWaterConstraint = rmCreateClassDistanceConstraint("far avoid water", classWater, 40.0);
	int veryFarWaterConstraint = rmCreateClassDistanceConstraint("very far avoid water", classWater, 120.0);
	int landConstraint = rmCreateClassDistanceConstraint("avoid land", classLand, 30.0);
	int shoreConstraint = rmCreateClassDistanceConstraint("avoid shore", classShore, 20.0);
	int borderConstraint = rmCreateClassDistanceConstraint("avoid border", classBorder, 20.0);

	// Settlements
	int shortAvoidSettlement = rmCreateTypeDistanceConstraint("short avoid settlement", "AbstractSettlement", 17.5);
	int mediumAvoidSettlement = rmCreateTypeDistanceConstraint("medium avoid settlement", "AbstractSettlement", 25.0);
	int startingSettleConstraint = rmCreateClassDistanceConstraint("avoid starting settlement", rmClassID("starting settlement"), 37.5);
	int farStartingSettleConstraint = rmCreateClassDistanceConstraint("far avoid starting settlement", rmClassID("starting settlement"), 47.5);
	int veryFarStartingSettleConstraint = rmCreateClassDistanceConstraint("settlements far avoid starting settlement", rmClassID("starting settlement"), 60.0);

	// Gold
	int shortAvoidGold = rmCreateTypeDistanceConstraint("short avoid gold", "gold", 10.0);
	int mediumAvoidGold = rmCreateTypeDistanceConstraint("medium avoid gold", "gold", 22.5);
	int farAvoidGold = rmCreateTypeDistanceConstraint("far avoid gold", "gold", 30.0);
	int veryFarAvoidGold = rmCreateTypeDistanceConstraint("very far avoid gold", "gold", 30.0);
	int goldZone = 0;
	if (cNumberNonGaiaPlayers > 6) goldZone = rmCreateBoxConstraint("gold zone 4v4", 0.275, 0.0, 0.725, 1.0, 0.01);
	else if (cNumberNonGaiaPlayers > 4) goldZone = rmCreateBoxConstraint("gold zone 3v3", 0.325, 0.0, 0.675, 1.0, 0.01);
	else if (cNumberNonGaiaPlayers > 2) goldZone = rmCreateBoxConstraint("gold zone 2v2", 0.35, 0.0, 0.65, 1.0, 0.01);

	// Food
	int avoidHerdable = rmCreateTypeDistanceConstraint("avoid herdable", "herdable", 50.0);
	int avoidPredator = rmCreateTypeDistanceConstraint("avoid predator", "animalPredator", 40.0);
	int avoidHunt = rmCreateTypeDistanceConstraint("avoid huntable", "huntable", 35.0);
	int avoidBonusHunt = rmCreateClassDistanceConstraint("avoid bonus huntable", classBonusHunt, 40.0);
	int foodZone = rmCreateBoxConstraint("food zone 1v1", 0.0, 0.15, 1.0, 0.15, 0.01);

	// Wood
	int forestConstraint = rmCreateClassDistanceConstraint("avoid forest", rmClassID("forest"), 27.5);
	int forestSettleConstraint = rmCreateClassDistanceConstraint("forest settle", rmClassID("starting settlement"), 20.0);

	// Building constraints
	int avoidTower = rmCreateTypeDistanceConstraint("towers avoid towers", "tower", 25.0);
	int avoidBuildings = rmCreateTypeDistanceConstraint("avoid buildings", "Building", 37.5);

	// Player placement
	if (cNumberNonGaiaPlayers < 3) rmPlacePlayersLine(0.19, 0.59, 0.81, 0.59);
	else if (cNumberTeams < 3) {
		if (cNumberNonGaiaPlayers < 5) {
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.18, 0.23, 0.21, 0.78, 5, 5);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.82, 0.23, 0.79, 0.78, 5, 5);
		}
		else if (cNumberNonGaiaPlayers < 7) {
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.18, 0.22, 0.21, 0.87, 5, 5);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.82, 0.22, 0.79, 0.87, 5, 5);
		}
		else {
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.18, 0.22, 0.21, 0.91, 5, 5);
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.82, 0.22, 0.79, 0.91, 5, 5);
		}
	}
	else {
		rmSetPlacementSection(0.16, 0.83);
		rmPlacePlayersCircular(0.36, 0.39, rmDegreesToRadians(5.0));
	}

	// Text
	rmSetStatusText("", 0.1);

	// Build shallows
	int shallowID = rmCreateArea("shallow");
	rmSetAreaWarnFailure(shallowID, false);
	rmSetAreaSize(shallowID, 1.0);
	rmSetAreaLocation(shallowID, 0.5, 0.01);
	rmSetAreaCoherence(shallowID, 0.0);
	rmSetAreaBaseHeight(shallowID, 2.0);
	rmSetAreaHeightBlend(shallowID, 2.0);
	rmAddAreaConstraint(shallowID, hugeShallow);
	rmAddAreaToClass(shallowID, classShallows);
	rmBuildArea(shallowID);

	// Build land
	for (i = 1; < 3) {
		int continentID = rmCreateArea("continent" + i);
		rmSetAreaMinBlobs(continentID, 1);
		rmSetAreaMaxBlobs(continentID, 5);
		rmSetAreaMinBlobDistance(continentID, 5.0);
		rmSetAreaMaxBlobDistance(continentID, 10.0);
		rmSetAreaBaseHeight(continentID, 2.0);
		rmSetAreaSmoothDistance(continentID, 10.0);
		rmSetAreaHeightBlend(continentID, 2.0);
		rmAddAreaToClass(continentID, classShallows);
		rmSetAreaWarnFailure(continentID, false);

		if (i == 1) {
			if (cNumberNonGaiaPlayers < 3) rmSetAreaLocation(continentID, 0.0, 0.35);
			else if (cNumberNonGaiaPlayers < 5) rmSetAreaLocation(continentID, 0.0, 0.45);
			else rmSetAreaLocation(continentID, 0.0, 0.475);
			rmSetAreaSize(continentID, 0.35);
			rmSetAreaCoherence(continentID, 0.65);
		}
		else if (i == 2) {
			if (cNumberNonGaiaPlayers < 3) rmSetAreaLocation(continentID, 1.0, 0.35);
			else if (cNumberNonGaiaPlayers < 5) rmSetAreaLocation(continentID, 1.0, 0.45);
			else rmSetAreaLocation(continentID, 1.0, 0.475);
			rmSetAreaSize(continentID, 0.35);
			rmSetAreaCoherence(continentID, 0.65);
		}
	}

	rmBuildAllAreas();

	// Build sea
	int seaID = rmCreateArea("sea");
	rmSetAreaWarnFailure(seaID, false);
	rmSetAreaSize(seaID, 1.0);
	rmSetAreaLocation(seaID, 0.5, 1.0);
	rmAddAreaConstraint(seaID, shallowConstraint);
	rmAddAreaToClass(seaID, classWater);
	rmBuildArea(seaID);

	// Build lake
	if (cNumberNonGaiaPlayers > 2 && cNumberTeams < 3) {
		int lakeID = rmCreateArea("lake");
		rmSetAreaSize(lakeID, 0.06);
		rmSetAreaWaterType(lakeID, "Egyptian Nile");
		rmSetAreaWarnFailure(lakeID, false);
		rmSetAreaLocation(lakeID, 0.5, 0.07);
		rmSetAreaCoherence(lakeID, 0.7);
		rmSetAreaSmoothDistance(lakeID, 12);
		rmSetAreaHeightBlend(lakeID, 1);
		rmAddAreaToClass(lakeID, classWater);
		rmBuildArea(lakeID);

		int nearBorder = rmCreateAreaMaxDistanceConstraint("near border", rmAreaID("lake"), 15.0);
	}

	int nearShore = rmCreateAreaMaxDistanceConstraint("near shore", rmAreaID("sea"), 15.0);

	// Define sea shore
	int shoreID = rmCreateArea("shore");
	rmSetAreaWarnFailure(shoreID, false);
	rmSetAreaSize(shoreID, 1.0);
	rmAddAreaConstraint(shoreID, shoreShallow);
	rmAddAreaConstraint(shoreID, waterConstraint);
	rmAddAreaConstraint(shoreID, nearShore);
	rmBuildArea(shoreID);

	int shoreBlock = rmCreateAreaDistanceConstraint("block shore", rmAreaID("shore"), 0.1);

	// Build shore
	for (i = 1; < 3) {
		shoreID = rmCreateArea("shore" + i);
		rmSetAreaWarnFailure(shoreID, false);
		rmSetAreaBaseHeight(shoreID, 5);
		rmSetAreaSize(shoreID, 1.0);
		rmSetAreaSmoothDistance(shoreID, 0.0);
		rmSetAreaHeightBlend(shoreID, 2.0);
		rmSetAreaCoherence(shoreID, 0.0);
		rmSetAreaTerrainType(shoreID, "SandA");
		rmAddAreaConstraint(shoreID, waterConstraint);
		rmAddAreaConstraint(shoreID, nearShore);
		rmAddAreaConstraint(shoreID, shoreBlock);
		rmAddAreaConstraint(shoreID, shoreConstraint);
		rmAddAreaToClass(shoreID, classShore);
		rmBuildArea(shoreID);
	}

	// Define lake border
	if (cNumberNonGaiaPlayers > 2 && cNumberTeams < 3) {
		int borderID = rmCreateArea("border");
		rmSetAreaWarnFailure(borderID, false);
		rmSetAreaSize(borderID, 1.0);
		rmAddAreaConstraint(borderID, borderShallow);
		rmAddAreaConstraint(borderID, waterConstraint);
		rmAddAreaConstraint(borderID, nearBorder);
		rmBuildArea(borderID);

		int borderBlock = rmCreateAreaDistanceConstraint("block border", rmAreaID("border"), 0.1);

		// Build shore
		for (i = 1; < 3) {
			borderID = rmCreateArea("border" + i);
			rmSetAreaWarnFailure(borderID, false);
			rmSetAreaBaseHeight(borderID, 5);
			rmSetAreaSize(borderID, 1.0);
			rmSetAreaSmoothDistance(borderID, 0.0);
			rmSetAreaHeightBlend(borderID, 2.0);
			rmSetAreaCoherence(borderID, 0.0);
			rmSetAreaTerrainType(borderID, "SandA");
			rmAddAreaConstraint(borderID, waterConstraint);
			rmAddAreaConstraint(borderID, nearBorder);
			rmAddAreaConstraint(borderID, borderBlock);
			rmAddAreaConstraint(borderID, borderConstraint);
			rmAddAreaToClass(borderID, classBorder);
			rmBuildArea(borderID);
		}
	}

	// Land
	for (i = 1; < 20) {
		int landID = rmCreateArea("land" + i);
		rmSetAreaWarnFailure(landID, false);
		rmSetAreaBaseHeight(landID, 5);
		rmSetAreaSize(landID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(1000));
		rmSetAreaSmoothDistance(landID, 5.0);
		rmSetAreaHeightBlend(landID, 2.0);
		rmSetAreaCoherence(landID, 0.0);
		rmSetAreaMinBlobs(landID, 5);
		rmSetAreaMaxBlobs(landID, 10);
		rmSetAreaMinBlobDistance(landID, 20.0);
		rmSetAreaMaxBlobDistance(landID, 40.0);
		rmSetAreaTerrainType(landID, "SandA");
		rmAddAreaConstraint(landID, waterConstraint);
		rmAddAreaConstraint(landID, landConstraint);
		rmAddAreaToClass(landID, classLand);
	}

	rmBuildAllAreas();

	// Text
	rmSetStatusText("", 0.2);

	// Virtual split
	for (i = 1; < cNumberPlayers) {
		int virtualSplit = rmCreateArea("virtual split" + i);
		rmSetPlayerArea(i, virtualSplit);
		rmSetAreaSize(virtualSplit, 1.0);
		rmSetAreaCoherence(virtualSplit, 1.0);
		rmSetAreaLocPlayer(virtualSplit, i);
		rmAddAreaConstraint(virtualSplit, virtualSplitConstraint);
		rmAddAreaToClass(virtualSplit, classVirtualSplit);
		rmSetAreaWarnFailure(virtualSplit, false);
	}

	rmBuildAllAreas();

	// Centerline
	int failCount = 0;
	for (i = 1; < cNumberNonGaiaPlayers * 80) {
		int centerline = rmCreateArea("centerline" + i);
		rmSetAreaSize(centerline, rmAreaTilesToFraction(10));
		rmSetAreaWarnFailure(centerline, false);
		rmAddAreaToClass(centerline, classCenterline);
		rmAddAreaConstraint(centerline, centerlineConstraint);
		rmAddAreaConstraint(centerline, constructCenterline);
		if (rmBuildArea(centerline) == false) {
			failCount++;
			if (failCount == 4) break;
		}
		else failCount = 0;
	}

	// Set up player areas
	float playerFraction = rmAreaTilesToFraction(1200);
	for (i = 1; < cNumberPlayers) {
		int id = rmCreateArea("Player" + i);
		rmSetPlayerArea(i, id);
		rmSetAreaSize(id, 0.9 * playerFraction, 1.1 * playerFraction);
		rmAddAreaToClass(id, classPlayer);
		rmSetAreaSmoothDistance(id, 5.0);
		rmSetAreaHeightBlend(id, 2.0);
		rmSetAreaBaseHeight(id, 5);
		rmSetAreaMinBlobs(id, 1);
		rmSetAreaMaxBlobs(id, 3);
		rmSetAreaMinBlobDistance(id, 10.0);
		rmSetAreaMaxBlobDistance(id, 25.0);
		rmSetAreaCoherence(id, 0.8);
		rmSetAreaTerrainType(id, "SandB");
		rmAddAreaTerrainLayer(id, "SandA", 6, 10);
		rmAddAreaTerrainLayer(id, "SandC", 2, 6);
		rmAddAreaTerrainLayer(id, "SandB", 0, 2);
		rmSetAreaLocPlayer(id, i);
	}

	rmBuildAllAreas();

	// Text
	rmSetStatusText("", 0.3);

	// Define objects
	// Close objects
	// Settlement
	int startingSettlementID = rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem(startingSettlementID, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass(startingSettlementID, rmClassID("starting settlement"));
	rmSetObjectDefMinDistance(startingSettlementID, 0.0);
	rmSetObjectDefMaxDistance(startingSettlementID, 0.0);

	// Towers
	int startingTowerID = rmCreateObjectDef("Starting tower");
	rmAddObjectDefItem(startingTowerID, "tower", 1, 0.0);
	rmSetObjectDefMinDistance(startingTowerID, 22.0);
	rmSetObjectDefMaxDistance(startingTowerID, 25.0);
	rmAddObjectDefConstraint(startingTowerID, avoidTower);

	// Starting gold
	int startingGoldID = rmCreateObjectDef("starting gold");
	rmAddObjectDefItem(startingGoldID, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance(startingGoldID, 20.0);
	rmSetObjectDefMaxDistance(startingGoldID, 20.0);
	rmAddObjectDefConstraint(startingGoldID, mediumAvoidAll);
	rmAddObjectDefConstraint(startingGoldID, mediumAvoidGold);

	// Hunt
	int startingGazelleID = rmCreateObjectDef("starting hunt");
	rmAddObjectDefItem(startingGazelleID, "Gazelle", rmRandInt(4, 7), 3.0);
	rmSetObjectDefMinDistance(startingGazelleID, 24.0);
	rmSetObjectDefMaxDistance(startingGazelleID, 26.0);
	rmAddObjectDefConstraint(startingGazelleID, mediumAvoidAll);

	// Starting food
	int startingFoodID = rmCreateObjectDef("close food");
	if (rmRandFloat(0, 1) < 0.5) rmAddObjectDefItem(startingFoodID, "berry bush", rmRandInt(5, 7), 3.5);
	else rmAddObjectDefItem(startingFoodID, "chicken", rmRandInt(5, 7), 3.5);
	rmSetObjectDefMinDistance(startingFoodID, 20.0);
	rmSetObjectDefMaxDistance(startingFoodID, 21.5);
	rmAddObjectDefConstraint(startingFoodID, mediumAvoidAll);

	// Goats
	int startingGoatsID = rmCreateObjectDef("close goats");
	rmAddObjectDefItem(startingGoatsID, "goat", 3, 2.0);
	rmSetObjectDefMinDistance(startingGoatsID, 20.0);
	rmSetObjectDefMaxDistance(startingGoatsID, 21.5);
	rmAddObjectDefConstraint(startingGoatsID, shortAvoidAll);

	// Straggler trees
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "palm", 1, 0.0);
	rmSetObjectDefMinDistance(stragglerTreeID, 12.0);
	rmSetObjectDefMaxDistance(stragglerTreeID, 15.0);
	rmAddObjectDefConstraint(stragglerTreeID, mediumAvoidAll);

	// Medium objects
	// Water hunt
	int waterHuntID = rmCreateObjectDef("water hunt");
	if (rmRandFloat(0, 1) < 0.5) rmAddObjectDefItem(waterHuntID, "hippo", rmRandInt(1, 2), 2.0);
	else rmAddObjectDefItem(waterHuntID, "crowned crane", rmRandInt(6, 9), 5.0);
	rmSetObjectDefMinDistance(waterHuntID, 15.0);
	rmSetObjectDefMaxDistance(waterHuntID, 90.0);
	rmAddObjectDefConstraint(waterHuntID, nearShore);
	rmAddObjectDefConstraint(waterHuntID, shortEdgeConstraint);
	rmAddObjectDefConstraint(waterHuntID, mediumCenterlineConstraint);
	rmAddObjectDefConstraint(waterHuntID, shortWaterConstraint);
	rmAddObjectDefConstraint(waterHuntID, avoidBuildings);

	// TG water hunt
	if (cNumberNonGaiaPlayers > 2) {
		int bonusWaterHuntID = rmCreateObjectDef("bonus water hunt");
		if (rmRandFloat(0, 1) < 0.5) rmAddObjectDefItem(bonusWaterHuntID, "hippo", rmRandInt(2, 3), 2.0);
		else rmAddObjectDefItem(bonusWaterHuntID, "crowned crane", rmRandInt(6, 9), 5.0);
		rmSetObjectDefMinDistance(bonusWaterHuntID, 25.0);
		rmSetObjectDefMaxDistance(bonusWaterHuntID, 70.0);
		rmAddObjectDefConstraint(bonusWaterHuntID, nearBorder);
		rmAddObjectDefConstraint(bonusWaterHuntID, shortEdgeConstraint);
		rmAddObjectDefConstraint(bonusWaterHuntID, mediumCenterlineConstraint);
		rmAddObjectDefConstraint(bonusWaterHuntID, shortWaterConstraint);
		rmAddObjectDefConstraint(bonusWaterHuntID, avoidBuildings);
	}

	// TG center player hunt
	if (cNumberNonGaiaPlayers > 2) {
		int pocketHuntID = rmCreateObjectDef("bonus pocket hunt");
		rmAddObjectDefItem(pocketHuntID, "hippo", rmRandInt(3, 4), 3.0);
		rmSetObjectDefMinDistance(pocketHuntID, 26.0);
		rmSetObjectDefMaxDistance(pocketHuntID, 28.0);
		rmAddObjectDefConstraint(pocketHuntID, mediumAvoidAll);
		rmAddObjectDefConstraint(pocketHuntID, veryFarWaterConstraint);
	}

	// Medium goats
	int mediumGoatsID = rmCreateObjectDef("medium Goats");
	rmAddObjectDefItem(mediumGoatsID, "goat", 2, 4.0);
	rmSetObjectDefMinDistance(mediumGoatsID, 55.0);
	rmSetObjectDefMaxDistance(mediumGoatsID, 65.0);
	rmAddObjectDefConstraint(mediumGoatsID, avoidHerdable);
	rmAddObjectDefConstraint(mediumGoatsID, edgeConstraint);
	rmAddObjectDefConstraint(mediumGoatsID, shortAvoidAll);
	rmAddObjectDefConstraint(mediumGoatsID, mediumWaterConstraint);
	rmAddObjectDefConstraint(mediumGoatsID, startingSettleConstraint);

	// Far objects
	// Bonus huntable 1
	int bonusHuntable1ID = rmCreateObjectDef("bonus huntable 1");
	if (rmRandFloat(0, 1) > 0.66) {
		rmAddObjectDefItem(bonusHuntable1ID, "gazelle", rmRandInt(4, 5), 4.0);
		rmAddObjectDefItem(bonusHuntable1ID, "giraffe", rmRandInt(2, 3), 4.0);
	}
	else rmAddObjectDefItem(bonusHuntable1ID, "gazelle", rmRandInt(6, 7), 4.0);
	if (cNumberNonGaiaPlayers < 3) {
		rmSetObjectDefMinDistance(bonusHuntable1ID, 90.0);
		rmSetObjectDefMaxDistance(bonusHuntable1ID, 100.0);
	}
	else {
		rmSetObjectDefMinDistance(bonusHuntable1ID, 97.5);
		rmSetObjectDefMaxDistance(bonusHuntable1ID, 102.5);
	}
	rmAddObjectDefConstraint(bonusHuntable1ID, shortAvoidAll);
	rmAddObjectDefConstraint(bonusHuntable1ID, edgeConstraint);
	rmAddObjectDefConstraint(bonusHuntable1ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(bonusHuntable1ID, avoidHunt);
	rmAddObjectDefConstraint(bonusHuntable1ID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusHuntable1ID, mediumWaterConstraint);
	rmAddObjectDefConstraint(bonusHuntable1ID, farStartingSettleConstraint);

	// Bonus huntable 2
	int bonusHuntable2ID = rmCreateObjectDef("bonus huntable 2");
	if (rmRandFloat(0, 1) > 0.66) {
		rmAddObjectDefItem(bonusHuntable2ID, "zebra", rmRandInt(4, 5), 4.0);
		rmAddObjectDefItem(bonusHuntable2ID, "gazelle", rmRandInt(2, 4), 4.0);
	}
	else rmAddObjectDefItem(bonusHuntable2ID, "zebra", rmRandInt(5, 6), 4.0);
	rmSetObjectDefMinDistance(bonusHuntable2ID, 90.0);
	rmSetObjectDefMaxDistance(bonusHuntable2ID, 100.0);
	rmAddObjectDefConstraint(bonusHuntable2ID, shortAvoidAll);
	rmAddObjectDefConstraint(bonusHuntable2ID, edgeConstraint);
	rmAddObjectDefConstraint(bonusHuntable2ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(bonusHuntable2ID, avoidHunt);
	rmAddObjectDefConstraint(bonusHuntable2ID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusHuntable2ID, mediumWaterConstraint);
	rmAddObjectDefConstraint(bonusHuntable2ID, farStartingSettleConstraint);

	// Far buffalos
	int buffaloID = rmCreateObjectDef("buffalos");
	rmAddObjectDefItem(buffaloID, "water buffalo", rmRandInt(2, 4), 3.0);
	rmSetObjectDefMinDistance(buffaloID, 60.0);
	rmSetObjectDefMaxDistance(buffaloID, 200.0);
	rmAddObjectDefToClass(buffaloID, classBonusHunt);
	rmAddObjectDefConstraint(buffaloID, mediumCenterlineConstraint);
	rmAddObjectDefConstraint(buffaloID, shortEdgeConstraint);
	rmAddObjectDefConstraint(buffaloID, shortAvoidAll);
	rmAddObjectDefConstraint(buffaloID, avoidBonusHunt);
	rmAddObjectDefConstraint(buffaloID, foodZone);

	// Far goats
	int farGoatsID = rmCreateObjectDef("far goats");
	rmAddObjectDefItem(farGoatsID, "goat", 2, 4.0);
	rmSetObjectDefMinDistance(farGoatsID, 75.0);
	rmSetObjectDefMaxDistance(farGoatsID, 85.0);
	rmAddObjectDefConstraint(farGoatsID, avoidHerdable);
	rmAddObjectDefConstraint(farGoatsID, edgeConstraint);
	rmAddObjectDefConstraint(farGoatsID, shortAvoidAll);
	rmAddObjectDefConstraint(farGoatsID, mediumWaterConstraint);
	rmAddObjectDefConstraint(farGoatsID, startingSettleConstraint);

	// Predator
	int predatorID1 = rmCreateObjectDef("predator");
	rmAddObjectDefItem(predatorID1, "crocodile", 1, 4.0);
	rmSetObjectDefMinDistance(predatorID1, 75.0);
	rmSetObjectDefMaxDistance(predatorID1, 87.5);
	rmAddObjectDefConstraint(predatorID1, shortAvoidAll);
	rmAddObjectDefConstraint(predatorID1, shortAvoidSettlement);
	rmAddObjectDefConstraint(predatorID1, edgeConstraint);
	rmAddObjectDefConstraint(predatorID1, avoidPredator);
	rmAddObjectDefConstraint(predatorID1, mediumWaterConstraint);
	rmAddObjectDefConstraint(predatorID1, farStartingSettleConstraint);
	rmAddObjectDefConstraint(predatorID1, shortAvoidGold);
	rmAddObjectDefConstraint(predatorID1, playerConstraint);

	// Random Trees
	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "palm", 1, 0.0);
	rmSetObjectDefMinDistance(randomTreeID, 0.0);
	rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomTreeID, rmCreateTypeDistanceConstraint("random tree", "all", 4.0));
	rmAddObjectDefConstraint(randomTreeID, shortAvoidAll);
	rmAddObjectDefConstraint(randomTreeID, shortWaterConstraint);
	rmAddObjectDefConstraint(randomTreeID, startingSettleConstraint);

	// Relics
	int relicID = rmCreateObjectDef("relics");
	rmAddObjectDefItem(relicID, "relic", 1, 5.0);
	rmAddObjectDefItem(relicID, "skeleton", 1, 5.0);
	rmAddObjectDefConstraint(relicID, rmCreateTypeDistanceConstraint("relic vs relic", "relic", 70.0));
	rmAddObjectDefConstraint(relicID, shortAvoidAll);
	rmAddObjectDefConstraint(relicID, edgeConstraint);
	rmAddObjectDefConstraint(relicID, shortWaterConstraint);
	rmAddObjectDefConstraint(relicID, rmCreateClassDistanceConstraint("very far avoid starting settlement", rmClassID("starting settlement"), 65.0));

	// Birds
	int farhawkID = rmCreateObjectDef("far hawks");
	rmAddObjectDefItem(farhawkID, "vulture", 1, 0.0);
	rmSetObjectDefMinDistance(farhawkID, 0.0);
	rmSetObjectDefMaxDistance(farhawkID, rmXFractionToMeters(0.5));

	// Text
	rmSetStatusText("", 0.4);

	// Starting settlement
	rmPlaceObjectDefPerPlayer(startingSettlementID, true);

	// Settlement 1
	if (cNumberNonGaiaPlayers < 3) id = rmAddFairLoc("Settlement", false, false, rmRandFloat(55, 65), rmRandFloat(70, 80), 30, 16, true);
	else if (cNumberNonGaiaPlayers < 5) id = rmAddFairLoc("Settlement", false, true, 60, 100, 70, 16);
	else id = rmAddFairLoc("Settlement", false, false, 60, 75, 70, 16);
	rmAddFairLocConstraint(id, startingSettleConstraint);
	rmAddFairLocConstraint(id, farWaterConstraint);

	// Settlement 2
	if (cNumberNonGaiaPlayers < 3) {
		if (rmRandFloat(0, 1) < 0.67) id = rmAddFairLoc("Settlement", true, true, rmRandFloat(70, 80), 85, 70, 80, true);
		else id = rmAddFairLoc("Settlement", false, false, 70, 130, 70, 30, true);
	}
	else if (cNumberNonGaiaPlayers < 5) id = rmAddFairLoc("Settlement", true, false, rmRandFloat(70, 75), 85, 60, 80);
	else if (cNumberNonGaiaPlayers < 7) {
		id = rmAddFairLoc("Settlement", true, false, 90, rmRandFloat(100, 105), 200, 120);
		rmAddFairLocConstraint(id, veryFarStartingSettleConstraint);
	}
	else id = rmAddFairLoc("Settlement", true, false, 75, 90, 70, 50);
	rmAddFairLocConstraint(id, startingSettleConstraint);
	rmAddFairLocConstraint(id, farWaterConstraint);

	float settleFraction = rmAreaTilesToFraction(200);
	if (rmPlaceFairLocs()) {
		id = rmCreateObjectDef("far settlement");
		rmAddObjectDefItem(id, "Settlement", 1, 0.0);
		for (i = 1; < cNumberPlayers) {
			for (j = 0; < rmGetNumberFairLocs(i)) {
				int settleArea = rmCreateArea("settlement area" + i + j);
				rmSetAreaTerrainType(settleArea, "SandB");
				rmSetAreaSize(settleArea, 0.9 * settleFraction, 1.1 * settleFraction);
				rmSetAreaSmoothDistance(settleArea, 5.0);
				rmSetAreaHeightBlend(settleArea, 2.0);
				rmSetAreaBaseHeight(settleArea, 5);
				rmSetAreaLocation(settleArea, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j));
				rmBuildArea(settleArea);
				rmPlaceObjectDefAtAreaLoc(id, i, settleArea);
			}
		}
	}

	rmResetFairLocs();

	// Text
	rmSetStatusText("", 0.5);

	// Gold
	int id1 = 0;
	if (cNumberNonGaiaPlayers < 3) {
		id1 = rmAddFairLoc("first gold", true, false, 57.5, 60, 45, 12, true);
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);

		id1 = rmAddFairLoc("second gold", true, false, 110, 120, 45, 12, true);
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);

		id1 = rmAddFairLoc("third gold", true, false, 125, 135, 45, 12, true);
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);

		int bonusGoldInt = rmRandInt(1, 6);
		switch (bonusGoldInt) {
		case 1:
			{
				id1 = rmAddFairLoc("third gold", true, false, 85, 90, 45, 12, true);
				break;
			}
		case 2:
			{
				id1 = rmAddFairLoc("fourth gold", false, false, 85, 90, 45, 12, true);
				break;
			}
		case 3:
			{
				id1 = rmAddFairLoc("fifth gold", true, true, 110, 120, 45, 12, true);
				break;
			}
		case 4:
			{
				id1 = rmAddFairLoc("seventh gold", true, false, 125, 135, 45, 12, true);
				break;
			}
		case 5:
			{
				id1 = rmAddFairLoc("eight gold", true, false, 135, 145, 45, 12, true);
				break;
			}
		case 6:
			{
				id1 = rmAddFairLoc("ninth gold", true, false, 145, 155, 45, 12, true);
				break;
			}
		}
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);
	}
	else if (cNumberNonGaiaPlayers < 5) {
		id1 = rmAddFairLoc("first gold", false, true, 60, 65, 45, 40, true);
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);

		id1 = rmAddFairLoc("second gold", true, true, 70, 80, 45, 12, true);
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);
		rmAddFairLocConstraint(id1, veryFarAvoidGold);

		id1 = rmAddFairLoc("third gold", true, true, 110, 120, 45, 12, true);
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);
		rmAddFairLocConstraint(id1, veryFarAvoidGold);
	}
	else {
		id1 = rmAddFairLoc("first gold", true, false, 100, 110, 45, 115);
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);

		id1 = rmAddFairLoc("second gold", true, false, 100, 110, 45, 115);
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);
		rmAddFairLocConstraint(id1, veryFarAvoidGold);

		id1 = rmAddFairLoc("third gold", true, false, 120, 130, 45, 115);
		rmAddFairLocConstraint(id1, startingSettleConstraint);
		rmAddFairLocConstraint(id1, farWaterConstraint);
		rmAddFairLocConstraint(id1, mediumAvoidSettlement);
		rmAddFairLocConstraint(id1, veryFarAvoidGold);
	}

	float goldFraction = rmAreaTilesToFraction(60);
	if (rmPlaceFairLocs()) {
		id1 = rmCreateObjectDef("gold");
		rmAddObjectDefItem(id1, "gold mine", 1, 0.0);
		for (i = 1; < cNumberPlayers) {
			for (j = 0; < rmGetNumberFairLocs(i)) {
				int goldArea = rmCreateArea("gold area" + i + j);
				rmSetAreaTerrainType(goldArea, "SandB");
				rmSetAreaSize(goldArea, 0.9 * goldFraction, 1.1 * goldFraction);
				rmSetAreaSmoothDistance(goldArea, 5.0);
				rmSetAreaHeightBlend(goldArea, 2.0);
				rmSetAreaBaseHeight(goldArea, 5);
				rmSetAreaLocation(goldArea, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j));
				rmBuildArea(goldArea);
				rmPlaceObjectDefAtAreaLoc(id1, i, goldArea);
			}
		}
	}

	// Text
	rmSetStatusText("", 0.6);

	// Place objects
	// Towers
	rmPlaceObjectDefPerPlayer(startingTowerID, true, 4);

	// Gold
	if (cNumberNonGaiaPlayers < 3) rmPlaceObjectDefPerPlayer(startingGoldID, false);
	else rmPlaceObjectDefPerPlayer(startingGoldID, false);

	// Hunt
	rmPlaceObjectDefPerPlayer(startingGazelleID, false);
	if (cNumberNonGaiaPlayers > 5) rmPlaceObjectDefPerPlayer(pocketHuntID, false);

	// Berries
	rmPlaceObjectDefPerPlayer(startingFoodID, false);

	// Goats
	rmPlaceObjectDefPerPlayer(startingGoatsID, true);

	// Straggler trees
	rmPlaceObjectDefPerPlayer(stragglerTreeID, false, rmRandInt(5, 7));

	// Water hunt
	if (rmRandFloat(0, 1) < 0.67) {
		rmPlaceObjectDefPerPlayer(waterHuntID, false);
		if (cNumberNonGaiaPlayers > 2) rmPlaceObjectDefPerPlayer(bonusWaterHuntID, false);
	}

	// Text
	rmSetStatusText("", 0.7);

	// Player forest
	failCount = 0;
	float forestFraction = rmAreaTilesToFraction(2000);
	for (i = 1; < cNumberPlayers) {
		int playerForestAreaID = rmCreateArea("player forest area" + i);
		rmSetAreaSize(playerForestAreaID, forestFraction);
		rmSetAreaWarnFailure(playerForestAreaID, false);
		rmSetAreaCoherence(playerForestAreaID, 0.95);
		rmSetAreaLocPlayer(playerForestAreaID, i);
		rmBuildArea(playerForestAreaID);

		failCount = 0;
		for (j = 0; < 3) {
			int playerForestID = rmCreateArea("player forest" + i + j, playerForestAreaID);
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(100));
			rmSetAreaWarnFailure(playerForestID, false);
			rmSetAreaForestType(playerForestID, "palm forest");
			rmAddAreaConstraint(playerForestID, forestSettleConstraint);
			rmAddAreaConstraint(playerForestID, mediumAvoidAll);
			rmAddAreaConstraint(playerForestID, forestConstraint);
			rmAddAreaConstraint(playerForestID, mediumWaterConstraint);
			rmAddAreaConstraint(playerForestID, shortAvoidSettlement);
			rmSetAreaSmoothDistance(playerForestID, 5.0);
			rmSetAreaHeightBlend(playerForestID, 2.0);
			rmSetAreaBaseHeight(playerForestID, 5);
			rmAddAreaToClass(playerForestID, classForest);
			rmSetAreaMinBlobs(playerForestID, 1);
			rmSetAreaMaxBlobs(playerForestID, 2);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 20.0);
			rmSetAreaCoherence(playerForestID, 0.0);

			if (rmBuildArea(playerForestID) == false) {
				failCount++;
				if (failCount == 3) break;
			}
			else failCount = 0;
		}
	}

	// Bonus huntable
	rmPlaceObjectDefPerPlayer(bonusHuntable1ID, false);
	rmPlaceObjectDefPerPlayer(bonusHuntable2ID, false);

	// Far buffalos
	rmPlaceObjectDefPerPlayer(buffaloID, false, 2);

	// Forest
	failCount = 0;
	int numTries = 12 * cNumberNonGaiaPlayers;
	for (i = 0; < numTries) {
		int forestID = rmCreateArea("forest" + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(90));
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaForestType(forestID, "palm forest");
		rmAddAreaConstraint(forestID, forestSettleConstraint);
		rmAddAreaConstraint(forestID, mediumAvoidAll);
		rmAddAreaConstraint(forestID, forestConstraint);
		rmAddAreaConstraint(forestID, semiShortWaterConstraint);
		rmAddAreaConstraint(forestID, shortAvoidSettlement);
		rmSetAreaSmoothDistance(forestID, 5.0);
		rmSetAreaHeightBlend(forestID, 2.0);
		rmSetAreaBaseHeight(forestID, 5);
		rmAddAreaToClass(forestID, classForest);
		rmSetAreaMinBlobs(forestID, 2);
		rmSetAreaMaxBlobs(forestID, 4);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 30.0);
		rmSetAreaCoherence(forestID, 0.0);

		if (rmBuildArea(forestID) == false) {
			failCount++;
			if (failCount == 3) break;
		}
		else failCount = 0;
	}

	// Medium goats
	rmPlaceObjectDefPerPlayer(mediumGoatsID, false);

	// Far goats
	rmPlaceObjectDefPerPlayer(farGoatsID, false, rmRandInt(1, 2));

	// Predators
	rmPlaceObjectDefPerPlayer(predatorID1, false, 2);

	// Relics
	if (cNumberNonGaiaPlayers < 4) {
		for (i = 1; < cNumberPlayers)
		rmPlaceObjectDefInArea(relicID, false, rmAreaID("virtual split" + i), 2);
	}
	else {
		for (i = 1; < cNumberPlayers)
		rmPlaceObjectDefInArea(relicID, false, rmAreaID("virtual split" + i));
	}

	// Text
	rmSetStatusText("", 0.8);

	// Fish
	int oceanConstraint = rmCreateBoxConstraint("limit ocean", 0.0, 0.5, 1.0, 1.0, 0.01);
	int lakeConstraint = rmCreateBoxConstraint("limit lake", 0.0, 0.0, 1.0, 0.5, 0.01);

	// Ocean fish
	// Ocean shore fish
	int playerFishLand = rmCreateTerrainDistanceConstraint("player fish land", "land", true, 9.0);
	int playerFishShore = rmCreateTerrainMaxDistanceConstraint("player fish shore", "land", true, 16.0);
	int playerFishConstraint = rmCreateTypeDistanceConstraint("player fish constraint", "fish", 22.0);

	int shoreFishID = rmCreateObjectDef("ocean shore fish");
	rmAddObjectDefItem(shoreFishID, "fish - perch", 2, 8.0);
	rmSetObjectDefMinDistance(shoreFishID, 0.0);
	rmSetObjectDefMaxDistance(shoreFishID, rmXFractionToMeters(1.0));
	rmAddObjectDefConstraint(shoreFishID, oceanConstraint);
	rmAddObjectDefConstraint(shoreFishID, playerFishLand);
	rmAddObjectDefConstraint(shoreFishID, playerFishShore);
	rmAddObjectDefConstraint(shoreFishID, edgeConstraint);
	rmAddObjectDefConstraint(shoreFishID, playerFishConstraint);
	rmPlaceObjectDefAtLoc(shoreFishID, 0, 0.5, 0.5, 8 * cNumberNonGaiaPlayers);

	// Ocean off-shore fish
	int fishLand = rmCreateTerrainDistanceConstraint("fish land", "land", true, 14.0);
	int fishShore = rmCreateTerrainMaxDistanceConstraint("fish shore", "land", true, 35.0);
	int fishConstraint = rmCreateTypeDistanceConstraint("fish constraint", "fish", 22.0);

	int fishID = rmCreateObjectDef("ocean off-shore fish");
	rmAddObjectDefItem(fishID, "fish - mahi", 3, 9.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(1.0));
	rmAddObjectDefConstraint(fishID, oceanConstraint);
	rmAddObjectDefConstraint(fishID, fishLand);
	rmAddObjectDefConstraint(fishID, fishShore);
	rmAddObjectDefConstraint(fishID, edgeConstraint);
	rmAddObjectDefConstraint(fishID, fishConstraint);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 7 * cNumberNonGaiaPlayers);

	// Lake fish
	if (cNumberNonGaiaPlayers > 2 && cNumberTeams < 3) {
		// Lake shore fish
		shoreFishID = rmCreateObjectDef("lake shore fish");
		rmAddObjectDefItem(shoreFishID, "fish - mahi", 3, 8.0);
		rmSetObjectDefMinDistance(shoreFishID, 0.0);
		rmSetObjectDefMaxDistance(shoreFishID, rmXFractionToMeters(1.0));
		rmAddObjectDefConstraint(shoreFishID, lakeConstraint);
		rmAddObjectDefConstraint(shoreFishID, playerFishLand);
		rmAddObjectDefConstraint(shoreFishID, playerFishShore);
		rmAddObjectDefConstraint(shoreFishID, edgeConstraint);
		rmAddObjectDefConstraint(shoreFishID, playerFishConstraint);
		rmPlaceObjectDefAtLoc(shoreFishID, 0, 0.5, 0.5, 8 * cNumberNonGaiaPlayers);

		// Lake off-shore fish
		fishID = rmCreateObjectDef("lake off-shore fish");
		rmAddObjectDefItem(fishID, "fish - perch", 2, 9.0);
		rmSetObjectDefMinDistance(fishID, 0.0);
		rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(1.0));
		rmAddObjectDefConstraint(fishID, lakeConstraint);
		rmAddObjectDefConstraint(fishID, fishLand);
		rmAddObjectDefConstraint(fishID, fishShore);
		rmAddObjectDefConstraint(fishID, edgeConstraint);
		rmAddObjectDefConstraint(fishID, fishConstraint);
		rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 7 * cNumberNonGaiaPlayers);
	}

	// Lone fish
	int loneFishLand = rmCreateTerrainDistanceConstraint("lone fish land", "land", true, 12.5);
	int loneFishConstraint = rmCreateTypeDistanceConstraint("lone fish constraint", "fish", 20.0);
	int loneFish = rmCreateObjectDef("lone fish");
	rmAddObjectDefItem(loneFish, "fish - mahi", 1, 1.0);
	rmSetObjectDefMinDistance(loneFish, 0.0);
	rmSetObjectDefMaxDistance(loneFish, rmXFractionToMeters(0.7));
	rmAddObjectDefConstraint(loneFish, edgeConstraint);
	rmAddObjectDefConstraint(loneFish, loneFishConstraint);
	rmAddObjectDefConstraint(loneFish, loneFishLand);
	rmPlaceObjectDefAtLoc(loneFish, 0, 0.5, 0.5, cNumberNonGaiaPlayers * 5);

	// Random trees
	rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 15 * cNumberNonGaiaPlayers);

	// Hawks
	rmPlaceObjectDefPerPlayer(farhawkID, false, 2);

	// Text
	rmSetStatusText("", 0.9);

	// Embellishment
	int rockID = rmCreateObjectDef("rock");
	rmAddObjectDefItem(rockID, "rock sandstone sprite", 1, 0.0);
	rmSetObjectDefMinDistance(rockID, 0.0);
	rmSetObjectDefMaxDistance(rockID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rockID, shortWaterConstraint);
	rmAddObjectDefConstraint(rockID, shortAvoidAll);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 30 * cNumberNonGaiaPlayers);

	int bushID = rmCreateObjectDef("big bush patch");
	rmAddObjectDefItem(bushID, "bush", 4, 3.0);
	rmSetObjectDefMinDistance(bushID, 0.0);
	rmSetObjectDefMaxDistance(bushID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bushID, shortWaterConstraint);
	rmAddObjectDefConstraint(bushID, shortAvoidAll);
	rmPlaceObjectDefAtLoc(bushID, 0, 0.5, 0.5, 5 * cNumberNonGaiaPlayers);

	int bush2ID = rmCreateObjectDef("small bush patch");
	rmAddObjectDefItem(bush2ID, "bush", 3, 2.0);
	rmAddObjectDefItem(bush2ID, "rock sandstone sprite", 1, 2.0);
	rmSetObjectDefMinDistance(bush2ID, 0.0);
	rmSetObjectDefMaxDistance(bush2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bush2ID, shortWaterConstraint);
	rmAddObjectDefConstraint(bush2ID, shortAvoidAll);
	rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 3 * cNumberNonGaiaPlayers);

	int grassID = rmCreateObjectDef("grass");
	rmAddObjectDefItem(grassID, "grass", 1, 0.0);
	rmSetObjectDefMinDistance(grassID, 0.0);
	rmSetObjectDefMaxDistance(grassID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(grassID, shortWaterConstraint);
	rmAddObjectDefConstraint(grassID, shortAvoidAll);
	rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 30 * cNumberNonGaiaPlayers);

	int embellishmentNearShore = rmCreateTerrainMaxDistanceConstraint("embellishment near shore", "land", true, 4.0);
	int papyrusID = rmCreateObjectDef("lone papyrus");
	rmAddObjectDefItem(papyrusID, "papyrus", 3, 2.0);
	rmSetObjectDefMinDistance(papyrusID, 0.0);
	rmSetObjectDefMaxDistance(papyrusID, 600);
	rmAddObjectDefConstraint(papyrusID, shortAvoidAll);
	rmAddObjectDefConstraint(papyrusID, embellishmentNearShore);
	rmPlaceObjectDefAtLoc(papyrusID, 0, 0.5, 0.5, 10 * cNumberNonGaiaPlayers - 10);

	int papyrus2ID = rmCreateObjectDef("grouped papyrus");
	rmAddObjectDefItem(papyrus2ID, "papyrus", 5, 7.0);
	rmSetObjectDefMinDistance(papyrus2ID, 0.0);
	rmSetObjectDefMaxDistance(papyrus2ID, 600);
	rmAddObjectDefConstraint(papyrus2ID, shortAvoidAll);
	rmAddObjectDefConstraint(papyrus2ID, embellishmentNearShore);
	rmPlaceObjectDefAtLoc(papyrus2ID, 0, 0.5, 0.5, 5 * cNumberNonGaiaPlayers - 5);

	int lakeBushID = rmCreateObjectDef("bushs by lake");
	rmAddObjectDefItem(lakeBushID, "bush", 3, 3.0);
	rmAddObjectDefItem(lakeBushID, "grass", 7, 8.0);
	rmSetObjectDefMinDistance(lakeBushID, 0.0);
	rmSetObjectDefMaxDistance(lakeBushID, 600);
	rmAddObjectDefConstraint(lakeBushID, shortAvoidAll);
	rmAddObjectDefConstraint(lakeBushID, embellishmentNearShore);
	rmPlaceObjectDefAtLoc(lakeBushID, 0, 0.5, 0.5, 20 * cNumberNonGaiaPlayers - 5);

	// RM X Finalize.
	rmxFinalize();

	// Text
	rmSetStatusText("", 1.00);

}