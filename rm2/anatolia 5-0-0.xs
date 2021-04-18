/*
** ANATOLIA
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Anatolia");

	// Set size.
	int axisLength = getStandardMapDimInMeters(8000);

	// Initialize map.
	initializeMap("SandA", axisLength);

	// Set lighting.
	rmSetLightingSet("Anatolia");

	// Player placement.
	if(cNonGaiaPlayers < 3) {
		// 1v1.
		placePlayersInLine(0.12, 0.5, 0.88, 0.5);
	} else if(cTeams < 3) {
		// Competitive teamgame.
		int teamInt = rmRandInt(0, 1);
		// It's absolutely CRUCIAL to still place players in a counter clock-wise fashion!
		placeTeamInLine(teamInt, 0.16, 0.8, 0.16, 0.2);
		placeTeamInLine(1 - teamInt, 0.84, 0.2, 0.84, 0.8);
	} else {
		// Any other matchup.
		placePlayersInCircle(0.325, 0.325);
	}

	// Control areas.
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
	int classCenter = rmDefineClass("center"); // This is just a normal class here.
	int classPlayer = rmDefineClass("player");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classForest = rmDefineClass("forest");
	int classCliff = rmDefineClass("cliff");
	int classBeautification = rmDefineClass("beautification");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);
	int avoidPlayer = createClassDistConstraint(classPlayer, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);
	int stayInCenterBox = createSymmetricBoxConstraint(0.36, 0.15);

	// Settlements.
	int avoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);

	// Terrain.
	int shortAvoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);
	int mediumAvoidImpassableLand = createTerrainDistConstraint("Land", false, 17.5);
	int farAvoidImpassableLand = createTerrainDistConstraint("Land", false, 25.0);
	int avoidCliff = createClassDistConstraint(classCliff, 30.0);

	// Gold.
	int numCenterGold = rmRandInt(2, 3);

	int shortAvoidGold = createTypeDistConstraint("Gold", 10.0);
	int farAvoidGold = createTypeDistConstraint("Gold", 60.0 - 10.0 * numCenterGold); // 40.0 for 2 mines, 30.0 for 3 mines.

	// Food.
	float avoidHuntDist = 40.0;

	int avoidHuntable = createTypeDistConstraint("Huntable", avoidHuntDist);
	int avoidHerdable = createTypeDistConstraint("Herdable", 30.0);
	int avoidFood = createTypeDistConstraint("Food", 20.0);
	int avoidPredator = createTypeDistConstraint("AnimalPredator", 25.0); // Shorter than usual because the center box is small.

	// Forest.
	int avoidForest = createClassDistConstraint(classForest, 20.0);
	int forestAvoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 20.0);
	int treeAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 13.0);

	// Relics.
	int avoidRelic = createTypeDistConstraint("Relic", 70.0);

	// Buildings.
	int avoidBuildings = createTypeDistConstraint("Building", 25.0);
	int avoidTowerLOS = createTypeDistConstraint("Tower", 35.0);
	int avoidTower = createTypeDistConstraint("Tower", 25.0);

	// Embellishment.
	int avoidBeautification = createClassDistConstraint(classBeautification, 10.0);
	int embellishmentAvoidAll = createTypeDistConstraint("All", 3.0);

	// Define simple objects.
	// Starting settlement.
	int startingSettlementID = rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem(startingSettlementID, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass(startingSettlementID, classStartingSettlement);

	// Towers.
	int startingTowerID = rmCreateObjectDef("starting tower");
	rmAddObjectDefItem(startingTowerID, "Tower", 1, 0.0);
	setObjectDefDistance(startingTowerID, 23.0, 27.0);
	rmAddObjectDefConstraint(startingTowerID, avoidTower);
	rmAddObjectDefConstraint(startingTowerID, createTerrainDistConstraint("Land", false, 5.0));
	// rmAddObjectDefConstraint(startingTowerID, avoidEdge);

	// Starting gold.
	int startingGoldID = rmCreateObjectDef("starting gold");
	rmAddObjectDefItem(startingGoldID, "Gold Mine Small", 1, 0.0);
	setObjectDefDistance(startingGoldID, 21.0, 24.0);
	rmAddObjectDefConstraint(startingGoldID, avoidAll);
	rmAddObjectDefConstraint(startingGoldID, avoidEdge);
	rmAddObjectDefConstraint(startingGoldID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingGoldID, farAvoidGold);

	// Starting food.
	float startingFoodFloat = rmRandFloat(0.0, 1.0);
	int numChickens = 0;
	int numBerries = 0;

	if(startingFoodFloat < 0.25) {
		numChickens = 4;
		numBerries = 3;
	} else if(startingFoodFloat < 0.75) {
		numChickens = 8;
		numBerries = 6;
	} else {
		numChickens = 12;
		numBerries = 9;
	}

	// Use either chicken or berries.
	int startingFoodID = createObjectDefVerify("starting chicken");
	if(randChance()) {
		addObjectDefItemVerify(startingFoodID, "Chicken", numChickens, 4.0);
	} else {
		addObjectDefItemVerify(startingFoodID, "Berry Bush", numBerries, 4.0);
	}
	setObjectDefDistance(startingFoodID, 20.0, 25.0); // Uses different numbers than all other maps here.
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Goat", rmRandInt(2, 5), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, shortAvoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Pine", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Far berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", rmRandInt(8, 10), 4.0);
	rmSetObjectDefMinDistance(farBerriesID, 70.0);
	rmSetObjectDefMaxDistance(farBerriesID, 0.35 * axisLength);
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidEdge);
	rmAddObjectDefConstraint(farBerriesID, stayInCenterBox);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farBerriesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farBerriesID, avoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Goat", 2, 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Goat", 2, 4.0);
	setObjectDefDistance(farHerdablesID, 70.0, 120.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	addObjectDefItemVerify(farPredatorsID, "Wolf", rmRandInt(1, 2), 4.0);
	rmSetObjectDefMinDistance(farPredatorsID, 70.0);
	rmSetObjectDefMaxDistance(farPredatorsID, 0.5 * axisLength);
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, stayInCenterBox);
	rmAddObjectDefConstraint(farPredatorsID, mediumAvoidImpassableLand);
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(farPredatorsID, createClassDistConstraint(classStartingSettlement, 70.0));
	} else {
		rmAddObjectDefConstraint(farPredatorsID, createClassDistConstraint(classStartingSettlement, 90.0));
	}
	rmAddObjectDefConstraint(farPredatorsID, avoidPredator);
	// rmAddObjectDefConstraint(farPredatorsID, avoidSettlement);

	// Other objects.
	// Relics.
	int relicID = createObjectDefVerify("relic");
	addObjectDefItemVerify(relicID, "Relic", 1, 0.0);
	rmAddObjectDefConstraint(relicID, avoidAll);
	rmAddObjectDefConstraint(relicID, avoidEdge);
	rmAddObjectDefConstraint(relicID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random trees.
	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "Pine", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Create player areas.
	float playerAreaSize = rmAreaTilesToFraction(1600);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, 0.9 * playerAreaSize, 1.1 * playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "SnowB");
		rmAddAreaTerrainLayer(playerAreaID, "SnowSand25", 6, 10);
		rmAddAreaTerrainLayer(playerAreaID, "SnowSand50", 2, 6);
		rmAddAreaTerrainLayer(playerAreaID, "SnowSand75", 0, 2);
		rmSetAreaMinBlobs(playerAreaID, 1);
		rmSetAreaMaxBlobs(playerAreaID, 5);
		rmSetAreaMinBlobDistance(playerAreaID, 16.0);
		rmSetAreaMaxBlobDistance(playerAreaID, 40.0);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmSetAreaWarnFailure(playerAreaID, false);
		rmBuildArea(playerAreaID);
	}

	// Oceans.
	for(i = 0; < 2) {
		int oceanID = rmCreateArea("ocean " + i);
		rmSetAreaSize(oceanID, 0.1);
		rmSetAreaWaterType(oceanID, "Red Sea");
		rmSetAreaHeightBlend(oceanID, 1);
		rmSetAreaSmoothDistance(oceanID, 12);
		rmSetAreaWarnFailure(oceanID, false);

		if(i == 0) {
			rmSetAreaLocation(oceanID, 0.5, 0.01);
			rmAddAreaInfluenceSegment(oceanID, 0.0, 0.0, 1.0, 0.0);
		} else if(i == 1) {
			rmSetAreaLocation(oceanID, 0.5, 0.99);
			rmAddAreaInfluenceSegment(oceanID, 0.0, 1.0, 1.0, 1.0);
		}
	}

	rmBuildAllAreas();

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 5 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
		rmSetAreaTerrainType(beautificationID, "SnowB");
		rmAddAreaTerrainLayer(beautificationID, "SnowSand25", 2, 3);
		rmAddAreaTerrainLayer(beautificationID, "SnowSand50", 1, 2);
		rmAddAreaTerrainLayer(beautificationID, "SnowSand75", 0, 1);
		rmSetAreaCoherence(beautificationID, 0.3);
		rmSetAreaSmoothDistance(beautificationID, 8);
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaToClass(beautificationID, classBeautification);
		rmAddAreaConstraint(beautificationID, avoidPlayer);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmAddAreaConstraint(beautificationID, avoidBeautification);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaTerrainType(beautificationID, "DirtA");
		rmSetAreaCoherence(beautificationID, 0.4);
		rmSetAreaSmoothDistance(beautificationID, 8);
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaToClass(beautificationID, classBeautification);
		rmAddAreaConstraint(beautificationID, avoidPlayer);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmAddAreaConstraint(beautificationID, avoidBeautification);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	// Starting settlement.
	placeObjectAtPlayerLocs(startingSettlementID, true);

	// Towers.
	placeAndStoreObjectAtPlayerLocs(startingTowerID, true, 4, 23.0, 27.0, true); // Last parameter: Square placement.

	progress(0.3);

	// Settlements.
	int settlementID = rmCreateObjectDef("settlements");
	rmAddObjectDefItem(settlementID, "Settlement", 1, 0.0);

	// Close settlement.
	addFairLocConstraint(farAvoidImpassableLand);
	addFairLocConstraint(avoidTowerLOS);

	if(cNonGaiaPlayers > 2) {
		addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
	}

	enableFairLocTwoPlayerCheck();

	if(gameHasTwoEqualTeams()) {
		addFairLoc(60.0, 80.0, false, true, 50.0, 12.0, 12.0);
	} else {
		addFairLoc(60.0, 120.0, false, true, 40.0, 12.0, 12.0);
	}

	placeObjectAtNewFairLocs(settlementID, false, "close settlement");

	// Far settlement.
	addFairLocConstraint(farAvoidImpassableLand);
	addFairLocConstraint(rmCreateTypeDistanceConstraint("avoid back tcs", "AbstractSettlement", 70.0));

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		addFairLoc(80.0, 100.0, true, false, 75.0, 12.0, 12.0);
	} else if(cNonGaiaPlayers < 5) {
		addFairLoc(80.0, 100.0, true, randChance(), 70.0, 70.0, 70.0, false, gameHasTwoEqualTeams());
	} else if(cNonGaiaPlayers < 9) {
		addFairLoc(90.0, 130.0, true, randChance(), 65.0, 70.0, 70.0, false, gameHasTwoEqualTeams());
	} else {
		addFairLoc(90.0, 160.0, true, randChance(), 50.0, 70.0, 70.0);
	}

	placeObjectAtNewFairLocs(settlementID, false, "far settlement");

	progress(0.4);

	// Elevation.
	// int elevationID = 0;

	// for(i = 0; < 40 * cNonGaiaPlayers) {
		// elevationID = rmCreateArea("elevation 1 " + i);
		// rmSetAreaSize(elevationID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(80));
		// if(randChance()) {
			// rmSetAreaTerrainType(elevationID, "SnowSand50");
		// }
		// rmSetAreaBaseHeight(elevationID, rmRandFloat(2.0, 4.0));
		// rmSetAreaHeightBlend(elevationID, 1);
		// rmSetAreaMinBlobs(elevationID, 1);
		// rmSetAreaMaxBlobs(elevationID, 5);
		// rmSetAreaMinBlobDistance(elevationID, 16.0);
		// rmSetAreaMaxBlobDistance(elevationID, 40.0);
		// rmAddAreaConstraint(elevationID, avoidBuildings);
		// rmAddAreaConstraint(elevationID, shortAvoidImpassableLand);
		// rmSetAreaWarnFailure(elevationID, false);
		// rmBuildArea(elevationID);
	// }

	// Cliffs.
	int numCliffAttempts = 8;

	for(i = 0; < numCliffAttempts) {
		int cliffID = rmCreateArea("cliff " + i);
		rmSetAreaSize(cliffID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(500));
		rmSetAreaCliffType(cliffID, "Egyptian");
		rmSetAreaMinBlobs(cliffID, 2);
		rmSetAreaMaxBlobs(cliffID, 5);
		rmSetAreaMinBlobDistance(cliffID, 5.0);
		rmSetAreaMaxBlobDistance(cliffID, 10.0);
		rmSetAreaHeightBlend(cliffID, 2);
		rmSetAreaSmoothDistance(cliffID, 10);
		rmSetAreaCliffEdge(cliffID, 2, 0.2, 0.0, 1.0, 1);
		rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffID, -5.0, 1.0, 1.0);
		rmAddAreaToClass(cliffID, classCliff);
		rmAddAreaConstraint(cliffID, avoidEdge);
		rmAddAreaConstraint(cliffID, avoidPlayer);
		rmAddAreaConstraint(cliffID, farAvoidImpassableLand);
		rmAddAreaConstraint(cliffID, avoidCliff);
		rmAddAreaConstraint(cliffID, avoidBuildings);
		rmSetAreaWarnFailure(cliffID, false);

		rmBuildArea(cliffID);
	}

	progress(0.5);

	// Build center.
	int centerAreaID = rmCreateArea("center area");
	rmSetAreaSize(centerAreaID, 1.0);
	rmAddAreaToClass(centerAreaID, classCenter);
	rmAddAreaConstraint(centerAreaID, stayInCenterBox);
	rmSetAreaWarnFailure(centerAreaID, false);
	rmBuildArea(centerAreaID);

	// Center gold.
	int centerGoldID = createObjectDefVerify("center gold");
	addObjectDefItemVerify(centerGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(centerGoldID, farAvoidGold);
	rmAddObjectDefConstraint(centerGoldID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(centerGoldID, avoidSettlement);
	rmAddObjectDefConstraint(centerGoldID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(centerGoldID, createAreaConstraint(centerAreaID));

	// Place gold anywhere in player's team split.
	placeObjectInTeamSplits(centerGoldID, false, numCenterGold);

	// Starting gold.
	int numStartingGold = 2;

	// First starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(shortAvoidImpassableLand);

	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	// Second starting gold normal.
	placeObjectAtPlayerLocs(startingGoldID, false, numStartingGold - 1);

	progress(0.6);

	// Food.
	// Close hunt.
	bool huntInStartingLOS = randChance(2.0 / 3.0);
	float closeHuntFloat = rmRandFloat(0.0, 1.0);

	if(closeHuntFloat < 0.3) {
		storeObjectDefItem("Boar", 3, 2.0);
	} else if(closeHuntFloat < 0.9) {
		storeObjectDefItem("Boar", 4, 2.0);
	} else {
		storeObjectDefItem("Boar", 1, 0.0);
	}

	// Place outside of starting LOS if randomized, fall back to starting LOS if placement fails.
	if(huntInStartingLOS == false) {
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(shortAvoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		// addSimLocConstraint(shortAvoidGold);

		enableSimLocTwoPlayerCheck();

		addSimLoc(45.0, 50.0, avoidHuntDist, 8.0, 8.0, false, false, true);

		if(placeObjectAtNewSimLocs(createObjectFromStorage("close hunt"), false, "close hunt", false) == false) {
			huntInStartingLOS = true;
		}
	}

	// Place inside starting LOS.
	if(huntInStartingLOS) {
		// If we have hunt in starting LOS, we want to force it within tower ranges so we know it's within LOS.
		storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 15.0)));
		storeObjectConstraint(avoidAll);
		storeObjectConstraint(avoidEdge);
		storeObjectConstraint(shortAvoidImpassableLand);
		// storeObjectConstraint(shortAvoidGold);

		placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.
	}

	resetObjectStorage();

	// Medium hunt.
	int mediumHuntID = createObjectDefVerify("medium hunt");
	if(randChance()) {
		addObjectDefItemVerify(mediumHuntID, "Deer", 8, 2.0);
	} else {
		addObjectDefItemVerify(mediumHuntID, "Deer", 10, 4.0);
	}

	float mediumHuntMinDist = rmRandFloat(70.0, 90.0);
	float mediumHuntMaxDist = mediumHuntMinDist + 10.0;

	if(cNonGaiaPlayers < 3) {
		mediumHuntMinDist = 60.0;
		mediumHuntMaxDist = 85.0;
		addSimLocConstraint(avoidSettlement); // For teamgames this is irrelevant.
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(avoidCenter);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, min(mediumHuntMinDist, 70.0)));
	addSimLocConstraint(shortAvoidImpassableLand);
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(shortAvoidGold);

	enableSimLocTwoPlayerCheck();

	addSimLoc(mediumHuntMinDist, mediumHuntMaxDist, avoidHuntDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(mediumHuntID, false, "medium hunt");

	// Other food.
	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

	// Far berries.
	placeObjectAtPlayerLocs(farBerriesID);

	progress(0.7);

	// Player forest.
	int numPlayerForests = 2;

	for(i = 1; < cPlayers) {
		int playerForestAreaID = rmCreateArea("player forest area " + i);
		rmSetAreaSize(playerForestAreaID, rmAreaTilesToFraction(2200));
		rmSetAreaLocPlayer(playerForestAreaID, getPlayer(i));
		rmSetAreaCoherence(playerForestAreaID, 1.0);
		rmSetAreaWarnFailure(playerForestAreaID, false);
		rmBuildArea(playerForestAreaID);

		for(j = 0; < numPlayerForests) {
			int playerForestID = rmCreateArea("player forest " + i + " " + j, playerForestAreaID);
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(80), rmAreaTilesToFraction(120));
			if(randChance(0.25)) {
				rmSetAreaForestType(playerForestID, "Mixed Pine Forest");
			} else {
				rmSetAreaForestType(playerForestID, "Pine Forest");
			}
			rmSetAreaMinBlobs(playerForestID, 3);
			rmSetAreaMaxBlobs(playerForestID, 3);
			rmSetAreaMinBlobDistance(playerForestID, 10.0);
			rmSetAreaMaxBlobDistance(playerForestID, 10.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, avoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, shortAvoidImpassableLand);
			rmSetAreaWarnFailure(playerForestID, false);
			rmBuildArea(playerForestID);
		}
	}

	// Other forest.
	int numRegularForests = 8 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(80), rmAreaTilesToFraction(120));
		if(randChance(0.25)) {
			rmSetAreaForestType(forestID, "Mixed Pine Forest");
		} else {
			rmSetAreaForestType(forestID, "Pine Forest");
		}
		rmSetAreaMinBlobs(forestID, 3);
		rmSetAreaMaxBlobs(forestID, 3);
		rmSetAreaMinBlobDistance(forestID, 10.0);
		rmSetAreaMaxBlobDistance(forestID, 10.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, shortAvoidImpassableLand);
		rmSetAreaWarnFailure(forestID, false);

		if(rmBuildArea(forestID) == false) {
			forestFailCount++;

			if(forestFailCount == 3) {
				break;
			}
		} else {
			forestFailCount = 0;
		}
	}

	progress(0.8);

	// Predators.
	placeObjectAtPlayerLocs(farPredatorsID);

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID, false, rmRandInt(1, 2));

	// Far herdables.
	placeObjectAtPlayerLocs(farHerdablesID, false, rmRandInt(1, 2));

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectInTeamSplits(relicID); // Team splits because player splits can be small.

	// Random trees.
	placeObjectAtPlayerLocs(randomTreeID, false, 10);

	// Fish.
	int fishID = 0;

	if(cNonGaiaPlayers < 3) {
		fishID = createObjectDefVerify("fish");
		addObjectDefItemVerify(fishID, "Fish - Mahi", 3, 6.0);

		placeObjectInLine(fishID, 0, 6, 0.1, 0.025, 0.9, 0.025, 0.02);
		placeObjectInLine(fishID, 0, 6, 0.1, 0.975, 0.9, 0.975, 0.02);
	} else {
		int numFish = 1.5 * cNonGaiaPlayers;
		int fishAvoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(2), rmZTilesToFraction(2));
		int fishLand = createTerrainDistConstraint("Land", true, 6.0);
		int avoidFish = createTypeDistConstraint("Fish", 20.0);
		int fishNW = createBoxConstraint(0.01, 0.9, 0.475, 1.0);
		int fishN = createBoxConstraint(0.525, 0.9, 0.99, 1.0);
		int fishS = createBoxConstraint(0.01, 0.0, 0.475, 0.1);
		int fishSE = createBoxConstraint(0.525, 0.0, 0.99, 0.1);

		for(i = 0; < 4) {
			// Don't verify teamgame fish.
			fishID = rmCreateObjectDef("fish " + i);
			rmAddObjectDefItem(fishID, "Fish - Mahi", 3, 5.0);
			setObjectDefDistanceToMax(fishID);
			rmAddObjectDefConstraint(fishID, fishAvoidEdge);
			rmAddObjectDefConstraint(fishID, fishLand);
			rmAddObjectDefConstraint(fishID, avoidFish);

			if(i == 0) {
				rmAddObjectDefConstraint(fishID, fishNW);
				placeObjectDefInArea(fishID, 0, rmAreaID("ocean 1"), numFish);
			} else if(i == 1) {
				rmAddObjectDefConstraint(fishID, fishN);
				placeObjectDefInArea(fishID, 0, rmAreaID("ocean 1"), numFish);
			} else if(i == 2) {
				rmAddObjectDefConstraint(fishID, fishS);
				placeObjectDefInArea(fishID, 0, rmAreaID("ocean 0"), numFish);
			} else if(i == 3) {
				rmAddObjectDefConstraint(fishID, fishSE);
				placeObjectDefInArea(fishID, 0, rmAreaID("ocean 0"), numFish);
			}
		}
	}

	progress(0.9);

	// Embellishment.
	// Rocks (this actually is very expensive to place due to the constraints).
	int rockID = rmCreateObjectDef("rock sprite");
	rmAddObjectDefItem(rockID, "Rock Sandstone Sprite", 3, 2.0);
	setObjectDefDistanceToMax(rockID);
	rmAddObjectDefConstraint(rockID, avoidPlayer);
	rmAddObjectDefConstraint(rockID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(rockID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockID, avoidBeautification);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 7 * cNonGaiaPlayers);

	// Birds.
	int birdsID = rmCreateObjectDef("birds");
	rmAddObjectDefItem(birdsID, "Vulture", 1, 0.0);
	setObjectDefDistanceToMax(birdsID);
	rmPlaceObjectDefAtLoc(birdsID, 0, 0.5, 0.5, 2 * cNonGaiaPlayers);

	// Check the resources that could not be checked/verified yet.
	for(i = 1; < cPlayers) {
		addProtoPlacementCheck("Settlement Level 1", 1, i);
		addProtoPlacementCheck("Tower", 4, i);
	}
	addProtoPlacementCheck("Gold Mine Small", numStartingGold * cNonGaiaPlayers, 0);
	addProtoPlacementCheck("Settlement", 2 * cNonGaiaPlayers, 0);

	// Finalize RM X.
	rmxFinalize();

	progress(1.0);
}
