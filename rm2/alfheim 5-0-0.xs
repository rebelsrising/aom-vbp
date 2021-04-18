/*
** ALFHEIM
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Alfheim");

	// Set size.
	int axisLength = getStandardMapDimInMeters(7500, 1.0);

	// Use Hades here for Mother Nature.
	rmSetGaiaCiv(cCivHades);

	// Initialize map.
	initializeMap("GrassA", axisLength);

	// Set lighting.
	rmSetLightingSet("Alfheim");

	// Player placement.
	if(cNonGaiaPlayers < 5) {
		placePlayersInCircle(0.35, 0.4, 0.75);
	} else if(cNonGaiaPlayers < 7) {
		placePlayersInCircle(0.3, 0.4, 0.75);
	} else {
		placePlayersInCircle(0.35, 0.4, 0.9);
	}

	// Control areas.
	int classCenter = initializeCenter();
	int classCorner = initializeCorners();
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classCliff = rmDefineClass("cliff");
	int classForest = rmDefineClass("forest");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int mediumAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 25.0);

	// Terrain.
	int avoidImpassableLand = createTerrainDistConstraint("Land", false, 7.5);

	// Gold.
	float avoidGoldDist = 40.0;

	int shortAvoidGold = createTypeDistConstraint("Gold", 10.0);
	int farAvoidGold = createTypeDistConstraint("Gold", avoidGoldDist);

	// Food.
	float avoidHuntDist = 40.0;

	int avoidHuntable = createTypeDistConstraint("Huntable", avoidHuntDist);
	int avoidHerdable = createTypeDistConstraint("Herdable", 30.0);
	int avoidFood = createTypeDistConstraint("Food", 20.0);
	int avoidPredator = createTypeDistConstraint("AnimalPredator", 40.0);

	// Forest.
	int avoidForest = createClassDistConstraint(classForest, 20.0);
	int forestAvoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 20.0);
	int treeAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 13.0);

	// Relics.
	int avoidRelic = createTypeDistConstraint("Relic", 60.0);

	// Buildings.
	int avoidBuildings = createTypeDistConstraint("Building", 25.0);
	int avoidTowerLOS = createTypeDistConstraint("Tower", 35.0);
	int avoidTower = createTypeDistConstraint("Tower", 25.0);

	// Embellishment.
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
	rmAddObjectDefConstraint(startingTowerID, avoidImpassableLand);

	// Close hunt. Randomize this here to adjust starting food constraints accordingly.
	int numCloseHunt = 1;
	if(randChance(0.1)) {
		numCloseHunt = rmRandInt(3, 6);
	}

	// Starting food.
	int numStartingObj = rmRandInt(6, 10);

	// Starting chicken.
	int startingChickenID = createObjectDefVerify("starting chicken");
	addObjectDefItemVerify(startingChickenID, "Chicken", numStartingObj, 4.0);
	setObjectDefDistance(startingChickenID, 23.0, 27.0); // Uses different numbers than all other maps here.
	rmAddObjectDefConstraint(startingChickenID, avoidAll);
	rmAddObjectDefConstraint(startingChickenID, avoidEdge);
	rmAddObjectDefConstraint(startingChickenID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingChickenID, shortAvoidGold);
	if(numCloseHunt == 1) {
		rmAddObjectDefConstraint(startingChickenID, avoidFood);
	}

	// Starting berries.
	int startingBerriesID = createObjectDefVerify("starting berries");
	addObjectDefItemVerify(startingBerriesID, "Berry Bush", numStartingObj, 4.0);
	setObjectDefDistance(startingBerriesID, 27.0, 33.0); // Uses different numbers than all other maps here.
	rmAddObjectDefConstraint(startingBerriesID, avoidAll);
	rmAddObjectDefConstraint(startingBerriesID, avoidEdge);
	rmAddObjectDefConstraint(startingBerriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingBerriesID, shortAvoidGold);
	if(numCloseHunt == 1) {
		rmAddObjectDefConstraint(startingBerriesID, avoidFood);
	}

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Cow", rmRandInt(2, 4), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, avoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Pine", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Cow", rmRandInt(1, 3), 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Cow", rmRandInt(1, 2), 4.0);
	setObjectDefDistance(farHerdablesID, 80.0, 120.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, avoidImpassableLand);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	if(randChance()) {
		addObjectDefItemVerify(farPredatorsID, "Bear", 1, 4.0);
	} else {
		addObjectDefItemVerify(farPredatorsID, "Wolf", 2, 4.0);
	}
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, avoidImpassableLand);
	rmAddObjectDefConstraint(farPredatorsID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredatorsID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredatorsID, avoidPredator);
	rmAddObjectDefConstraint(farPredatorsID, avoidFood);

	// Other objects.
	// Random trees.
	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "Pine", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Set up player areas.
	float playerAreaSize = rmAreaTilesToFraction(4000);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, 0.9 * playerAreaSize, 1.1 * playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "GrassDirt50");
		rmAddAreaTerrainLayer(playerAreaID, "GrassDirt25", 8, 20);
		rmAddAreaTerrainLayer(playerAreaID, "GrassA", 0, 8);
		rmSetAreaMinBlobs(playerAreaID, 1);
		rmSetAreaMaxBlobs(playerAreaID, 5);
		rmSetAreaMinBlobDistance(playerAreaID, 16.0);
		rmSetAreaMaxBlobDistance(playerAreaID, 40.0);
		rmSetAreaWarnFailure(playerAreaID, false);
	}

	rmBuildAllAreas();

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 1; < cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i, rmAreaID("player area " + i));
		rmSetAreaLocPlayer(beautificationID, getPlayer(i));
		rmSetAreaTerrainType(beautificationID, "GrassDirt25");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaTerrainType(beautificationID, "GrassB");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(5), rmAreaTilesToFraction(15));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 12 * cPlayers) {
		beautificationID = rmCreateArea("beautification 3 " + i);
		rmSetAreaTerrainType(beautificationID, "GrassDirt25");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(5), rmAreaTilesToFraction(20));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
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

	addFairLocConstraint(avoidTowerLOS);

	// Close settlement.
	if(cNonGaiaPlayers < 3) {
		addFairLocConstraint(avoidCorner);
	} else {
		addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
	}

	enableFairLocTwoPlayerCheck();

	addFairLoc(60.0, 80.0, false, true, 50.0, 12.0, 12.0);

	placeObjectAtNewFairLocs(settlementID, false, "close settlement");

	// Far settlement.
	addFairLocConstraint(createTypeDistConstraint("AbstractSettlement", 70.0)); // Includes starting settlements.
	addFairLocConstraint(avoidTowerLOS);

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		addFairLoc(70.0, 120.0, true, false, 80.0, 12.0, 12.0);
	} else if(cNonGaiaPlayers < 5) {
		addFairLoc(70.0, 100.0, true, false, 70.0, 30.0, 30.0, false, gameHasTwoEqualTeams());
	} else {
		// 100.0 is still pretty unfair in some cases if we randomize a radius < 0.35.
		addFairLoc(70.0, 100.0, true, false, 70.0, 30.0, 30.0, false, gameHasTwoEqualTeams());
	}

	placeObjectAtNewFairLocs(settlementID, false, "far settlement");

	progress(0.4);

	// Elevation.
	int elevationID = 0;

	for(i = 0; < 30 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 1 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(80));
		rmSetAreaBaseHeight(elevationID, rmRandFloat(2.0, 4.0));
		rmSetAreaHeightBlend(elevationID, 1);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 3);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 20.0);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	// Cliffs.
	int numCliffs = 3;
	int avoidCliff = createClassDistConstraint(classCliff, 35.0);

	for(i = 1; < cPlayers) {
		for(j = 1; <= numCliffs) {
			int cliffID = rmCreateArea("cliff " + i + " " + j, rmAreaID(cSplitName + " " + i));
			rmSetAreaSize(cliffID, rmAreaTilesToFraction(160), rmAreaTilesToFraction(180));
			rmSetAreaTerrainType(cliffID, "CliffGreekA");
			rmSetAreaCliffType(cliffID, "Greek");
			rmSetAreaCoherence(cliffID, 0.4);
			rmSetAreaCliffEdge(cliffID, 1, 1.0, 0.0, 1.0, 0);
			rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, false);
			rmSetAreaCliffHeight(cliffID, 6, 1.0, 1.0);
			rmSetAreaHeightBlend(cliffID, 2);
			rmSetAreaSmoothDistance(cliffID, 3);
			rmAddAreaToClass(cliffID, classCliff);
			rmAddAreaConstraint(cliffID, avoidCliff);
			rmAddAreaConstraint(cliffID, avoidBuildings);
			rmSetAreaWarnFailure(cliffID, false);

			rmBuildArea(cliffID);
		}
	}

	progress(0.5);

	// Gold.
	int numMediumGold = rmRandInt(1, 2);
	int numBonusGold = rmRandInt(3, 4);

	// float bonusGoldFloat = rmRandFloat(0.0, 1.0); // Uncomment this if medium gold is fixed to 2.

	// if(bonusGoldFloat < 0.25) {
		// numBonusGold = 2;
	// } else if(bonusGoldFloat < 0.75) {
		// numBonusGold = 3;
	// } else {
		// numBonusGold = 4;
	// }

	int mediumGoldID = createObjectDefVerify("medium gold");
	addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);

	// First (medium).
	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidCorner);
	addSimLocConstraint(avoidImpassableLand);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(farAvoidSettlement);
	addSimLocConstraint(farAvoidGold);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));

	enableSimLocTwoPlayerCheck();

	addSimLoc(50.0, 60.0, avoidGoldDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold 1");

	if(numMediumGold == 2) {
		// Second (medium).
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidCorner);
		addSimLocConstraint(avoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));

		if(cNonGaiaPlayers < 3) {
			enableSimLocTwoPlayerCheck();
			setSimLocInterval(10.0);
			addSimLocWithPrevConstraints(50.0, 60.0, avoidGoldDist, 8.0, 8.0, false, false, true);
		} else {
			addSimLocWithPrevConstraints(50.0, 80.0, avoidGoldDist, 8.0, 8.0, false, false, true);
		}

		if(placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold 2", false) == false) {
			numBonusGold++;
		}
	}

	int numTwoPlayerGold = 0;

	// Place first 2 bonus gold mines with similar locations in 1v1 for balance due to the cliffs.
	if(cNonGaiaPlayers < 3) {
		int farGoldID = createObjectDefVerify("far gold");
		addObjectDefItemVerify(farGoldID, "Gold Mine", 1, 0.0);

		for(i = 1; <= 2) {
			addSimLocConstraint(avoidAll);
			addSimLocConstraint(avoidEdge);
			addSimLocConstraint(avoidCorner);
			addSimLocConstraint(avoidImpassableLand);
			addSimLocConstraint(avoidTowerLOS);
			addSimLocConstraint(farAvoidSettlement);
			addSimLocConstraint(farAvoidGold);
			addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 80.0));

			enableSimLocTwoPlayerCheck();

			addSimLoc(80.0, getCornerRadiusInMeters(), avoidGoldDist, 8.0, 8.0);
		}

		placeObjectAtNewSimLocs(farGoldID, false, "far gold");

		numTwoPlayerGold = numTwoPlayerGold + 2;
	}

	// It's difficult to find similar positions for potential 5th/6th mines, only verify if we have < 5 mines.
	int bonusGoldID = createObjectDefVerify("bonus gold", numMediumGold + numBonusGold < 5 || cDebugMode >= cDebugFull);
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(bonusGoldID, avoidTowerLOS);
	// rmAddObjectDefConstraint(bonusGoldID, createTerrainDistConstraint("Land", false, 5.0));
	rmAddObjectDefConstraint(bonusGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);

	placeObjectInTeamSplits(bonusGoldID, false, numBonusGold - numTwoPlayerGold);

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(avoidImpassableLand);
	storeObjectConstraint(farAvoidGold);

	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Close and medium hunt.
	bool huntInStartingLOS = randChance(2.0 / 3.0);

	if(randChance(0.25)) {
		storeObjectDefItem("Elk", 2, 2.0);
	} else {
		storeObjectDefItem("Elk", rmRandInt(3, 5), 2.0);
	}

	if(numCloseHunt > 1) {
		// High hunt starting spawn, place anywhere.
		storeObjectConstraint(avoidAll);
		storeObjectConstraint(avoidEdge);
		storeObjectConstraint(avoidImpassableLand);
		storeObjectConstraint(createTypeDistConstraint("Huntable", 20.0));

		// Circular placement.
		placeObjectDefPerPlayer(createObjectFromStorage("close hunt"), false, numCloseHunt, 30.0, 60.0);
	} else {
		if(huntInStartingLOS == false) {
			addSimLocConstraint(avoidAll);
			addSimLocConstraint(avoidEdge);
			addSimLocConstraint(avoidImpassableLand);
			addSimLocConstraint(avoidTowerLOS);
			// addSimLocConstraint(shortAvoidGold);

			enableSimLocTwoPlayerCheck();

			addSimLoc(45.0, 50.0, avoidHuntDist, 8.0, 8.0, false, false, true);

			if(placeObjectAtNewSimLocs(createObjectFromStorage("close hunt"), false, "close hunt", false) == false) {
				huntInStartingLOS = true;
			}
		}

		if(huntInStartingLOS) {
			// If we have hunt in starting LOS, we want to force it within tower ranges so we know it's within LOS.
			storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 15.0)));
			storeObjectConstraint(avoidAll);
			storeObjectConstraint(avoidEdge);
			storeObjectConstraint(avoidImpassableLand);
			storeObjectConstraint(shortAvoidGold);

			placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.
		}
	}

	// Medium hunt.
	int mediumHuntID = createObjectDefVerify("medium hunt");
	addObjectDefItemVerify(mediumHuntID, "Deer", rmRandInt(2, 8), 2.0);

	float mediumHuntMinDist = rmRandFloat(60.0, 75.0);
	float mediumHuntMaxDist = mediumHuntMinDist + 10.0;

	if(cNonGaiaPlayers < 3) {
		mediumHuntMinDist = 60.0;
		mediumHuntMaxDist = 85.0;
	} else if(numCloseHunt > 1) {
		mediumHuntMaxDist = mediumHuntMaxDist + 10.0;
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidImpassableLand);
	addSimLocConstraint(shortAvoidSettlement);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, mediumHuntMinDist));
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(avoidTowerLOS);

	enableSimLocTwoPlayerCheck();

	addSimLoc(mediumHuntMinDist, mediumHuntMaxDist, avoidHuntDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(mediumHuntID, false, "medium hunt");

	// Bonus hunt.
	int numBonusHunt = rmRandInt(1, 2);
	float bonusHuntFloat = rmRandFloat(0.0, 1.0);

	int bonusHuntID = createObjectDefVerify("bonus hunt");
	if(bonusHuntFloat < 1.0 / 3.0) {
		addObjectDefItemVerify(bonusHuntID, "Elk", rmRandInt(2, 8), 2.0);
	} else if(bonusHuntFloat < 2.0 / 3.0) {
		addObjectDefItemVerify(bonusHuntID, "Caribou", rmRandInt(2, 6), 2.0);
	} else {
		addObjectDefItemVerify(bonusHuntID, "Aurochs", rmRandInt(2, 3), 2.0);
	}

	rmAddObjectDefConstraint(bonusHuntID, avoidAll);
	rmAddObjectDefConstraint(bonusHuntID, avoidEdge);
	rmAddObjectDefConstraint(bonusHuntID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusHuntID, createClassDistConstraint(classStartingSettlement, mediumHuntMaxDist));
	rmAddObjectDefConstraint(bonusHuntID, mediumAvoidSettlement);
	rmAddObjectDefConstraint(bonusHuntID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusHuntID, avoidHuntable);

	placeObjectInPlayerSplits(bonusHuntID, false, numBonusHunt);

	// Other food.
	// Starting food.
	placeObjectAtPlayerLocs(startingChickenID);
	placeObjectAtPlayerLocs(startingBerriesID);

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
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
			rmSetAreaForestType(playerForestID, "Pine Forest");
			rmSetAreaMinBlobs(playerForestID, 3);
			rmSetAreaMaxBlobs(playerForestID, 5);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 20.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, avoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, avoidImpassableLand);
			rmSetAreaWarnFailure(playerForestID, false);
			rmBuildArea(playerForestID);
		}
	}

	// Other forest.
	int numRegularForests = 10 - numPlayerForests; // 14 instead of 13 would also work well here.
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaForestType(forestID, "Pine Forest");
		rmSetAreaMinBlobs(forestID, 3);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 20.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, avoidImpassableLand);
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
	placeObjectInPlayerSplits(farPredatorsID);

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID);

	// Far herdables.
	placeObjectAtPlayerLocs(farHerdablesID, false, rmRandInt(1, 2));

	// Relics.
	int relicsAvoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 50.0);

	for(i = 1; < cPlayers) {
		for(j = 0; < 2) {
			int ruinID = rmCreateArea("ruins " + i + " " + j, rmAreaID(cSplitName + " " + i));
			rmSetAreaSize(ruinID, rmAreaTilesToFraction(150), rmAreaTilesToFraction(200));
			rmSetAreaTerrainType(ruinID, "GreekRoadA");
			rmAddAreaTerrainLayer(ruinID, "GrassDirt25", 0, 1);
			rmSetAreaCoherence(ruinID, 0.8);
			rmSetAreaMinBlobs(ruinID, 1);
			rmSetAreaMaxBlobs(ruinID, 4);
			rmSetAreaMinBlobDistance(ruinID, 16.0);
			rmSetAreaMaxBlobDistance(ruinID, 40.0);
			rmAddAreaConstraint(ruinID, avoidAll);
			rmAddAreaConstraint(ruinID, avoidEdge);
			rmAddAreaConstraint(ruinID, avoidImpassableLand);
			rmAddAreaConstraint(ruinID, shortAvoidSettlement);
			rmAddAreaConstraint(ruinID, relicsAvoidStartingSettlement);
			rmAddAreaConstraint(ruinID, avoidRelic);
			rmSetAreaWarnFailure(ruinID, false);
			rmBuildArea(ruinID);

			int stayInRuins = rmCreateEdgeDistanceConstraint("stay in ruins " + i + " " + j, ruinID, 1.0);

			int decorationID = rmCreateObjectDef("decoration " + i + " " + j);
			rmAddObjectDefItem(decorationID, "Rock Limestone Small", rmRandInt(2, 4), 4.0);
			rmAddObjectDefItem(decorationID, "Rock Limestone Sprite", rmRandInt(8, 12), 6.0);
			rmAddObjectDefItem(decorationID, "Grass", rmRandFloat(4, 8), 4.0);
			rmPlaceObjectDefInArea(decorationID, 0, ruinID);

			int relicID = rmCreateObjectDef("relic " + i + " " + j);
			rmAddObjectDefItem(relicID, "Relic", 1, 1.0);
			rmSetObjectDefMinDistance(relicID, 0.0);
			rmSetObjectDefMaxDistance(relicID, 5.0);
			rmAddObjectDefConstraint(relicID, stayInRuins);
			rmPlaceObjectDefInArea(relicID, 0, ruinID);

			if(rmGetNumberUnitsPlaced(relicID) < 1) {
				int backupRelicID = rmCreateObjectDef("backup relic " + i + " " + j);
				rmAddObjectDefItem(backupRelicID, "Relic", 1, 1.0);
				rmAddObjectDefConstraint(backupRelicID, avoidAll);
				rmAddObjectDefConstraint(backupRelicID, avoidEdge);
				rmAddObjectDefConstraint(backupRelicID, avoidImpassableLand);
				rmAddObjectDefConstraint(backupRelicID, relicsAvoidStartingSettlement);
				rmAddObjectDefConstraint(backupRelicID, avoidRelic);
				rmPlaceObjectDefInArea(backupRelicID, 0, rmAreaID(cSplitName + " " + i));
			}
		}
	}

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Random trees.
	placeObjectAtPlayerLocs(randomTreeID, false, 20);

	progress(0.9);

	// Embellishment.
	// Rocks.
	int rockID = rmCreateObjectDef("rocks");
	rmAddObjectDefItem(rockID, "Rock Limestone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rockID);
	rmAddObjectDefConstraint(rockID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 50 * cNonGaiaPlayers);

	// Logs.
	int logID = rmCreateObjectDef("logs");
	rmAddObjectDefItem(logID, "Rotting Log", 1, 0.0);
	setObjectDefDistanceToMax(logID);
	rmAddObjectDefConstraint(logID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(logID, avoidImpassableLand);
	rmAddObjectDefConstraint(logID, avoidTowerLOS);
	rmPlaceObjectDefAtLoc(logID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	// Birds.
	int birdsID = rmCreateObjectDef("birds");
	rmAddObjectDefItem(birdsID, "Hawk", 1, 0.0);
	setObjectDefDistanceToMax(birdsID);
	rmPlaceObjectDefAtLoc(birdsID, 0, 0.5, 0.5, 2 * cNonGaiaPlayers);

	// Check the resources that could not be checked/verified yet.
	for(i = 1; < cPlayers) {
		addProtoPlacementCheck("Settlement Level 1", 1, i);
		addProtoPlacementCheck("Tower", 4, i);
	}
	addProtoPlacementCheck("Gold Mine Small", cNonGaiaPlayers, 0);
	addProtoPlacementCheck("Settlement", 2 * cNonGaiaPlayers, 0);

	// Finalize RM X.
	rmxFinalize();

	progress(1.0);
}
