/*
** BLUE LAGOON
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Blue Lagoon (by RebelsRising & Flame)");

	// Set size.
	int axisLength = getStandardMapDimInMeters();

	// Initialize map.
	initializeMap("SandA", axisLength);

	// Player placement.
	placePlayersInCircle(0.35, 0.4, 0.875);

	// Control areas.
	int classCenter = initializeCenter();
	int classCorner = initializeCorners();
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
	int classPlayer = rmDefineClass("player");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classPond = rmDefineClass("pond");
	int classCliff = rmDefineClass("cliff");
	int classForest = rmDefineClass("forest");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);
	int avoidPlayer = createClassDistConstraint(classPlayer, 1.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int mediumAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 25.0);

	// Terrain.
	int avoidImpassableLand = createTerrainDistConstraint("Land", false, 5.0);
	int shortAvoidPond = createClassDistConstraint(classPond, 8.0);
	int farAvoidPond = createClassDistConstraint(classPond, 25.0);
	int shortAvoidCliff = createClassDistConstraint(classCliff, 8.0);
	int farAvoidCliff = createClassDistConstraint(classCliff, 25.0);

	// Gold.
	float avoidGoldDist = 45.0;

	int shortAvoidGold = createTypeDistConstraint("Gold", 10.0);
	int farAvoidGold = createTypeDistConstraint("Gold", avoidGoldDist);

	// Food.
	int avoidHuntable = createTypeDistConstraint("Huntable", 40.0);
	int avoidHerdable = createTypeDistConstraint("Herdable", 30.0);
	int avoidFood = createTypeDistConstraint("Food", 20.0);
	int avoidPredator = createTypeDistConstraint("AnimalPredator", 40.0);

	// Forest.
	int avoidForest = createClassDistConstraint(classForest, 25.0);
	int forestAvoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 20.0);
	int treeAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 13.0);

	// Relics.
	int avoidRelic = createTypeDistConstraint("Relic", 70.0);

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
	// rmAddObjectDefConstraint(startingTowerID, avoidEdge);
	rmAddObjectDefConstraint(startingTowerID, avoidTower);
	rmAddObjectDefConstraint(startingTowerID, avoidImpassableLand);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(5, 8), 2.0);
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting hunt.
	int startingHuntID = createObjectDefVerify("close hunt");
	addObjectDefItemVerify(startingHuntID, "Giraffe", rmRandInt(2, 3), 2.0);
	setObjectDefDistance(startingHuntID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingHuntID, avoidAll);
	rmAddObjectDefConstraint(startingHuntID, avoidEdge);
	rmAddObjectDefConstraint(startingHuntID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingHuntID, shortAvoidCliff);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Pig", rmRandInt(1, 3), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, avoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Savannah Tree", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Pig", rmRandInt(1, 2), 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Pig", rmRandInt(2, 3), 4.0);
	setObjectDefDistance(farHerdablesID, 80.0, 120.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, avoidImpassableLand);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	if(randChance()) {
		addObjectDefItemVerify(farPredatorsID, "Lion", 2, 4.0);
	} else {
		addObjectDefItemVerify(farPredatorsID, "Hyena", 2, 4.0);
	}
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, avoidImpassableLand);
	rmAddObjectDefConstraint(farPredatorsID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredatorsID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredatorsID, avoidPredator);
	rmAddObjectDefConstraint(farPredatorsID, avoidFood);

	// Other objects.
	// Relics.
	int relicID = createObjectDefVerify("relic");
	addObjectDefItemVerify(relicID, "Relic", 1, 0.0);
	rmAddObjectDefConstraint(relicID, avoidAll);
	rmAddObjectDefConstraint(relicID, avoidEdge);
	rmAddObjectDefConstraint(relicID, avoidCorner);
	rmAddObjectDefConstraint(relicID, avoidImpassableLand);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random trees.
	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "Savannah Tree", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(randomTreeID, shortAvoidCliff);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Set up player areas.
	float playerAreaSize = rmAreaTilesToFraction(1000);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, 0.9 * playerAreaSize, 1.1 * playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "GrassDirt25");
		rmAddAreaTerrainLayer(playerAreaID, "GrassDirt50", 3, 6);
		rmAddAreaTerrainLayer(playerAreaID, "GrassDirt75", 0, 3);
		rmSetAreaMinBlobs(playerAreaID, 1);
		rmSetAreaMaxBlobs(playerAreaID, 3);
		rmSetAreaMinBlobDistance(playerAreaID, 16.0);
		rmSetAreaMaxBlobDistance(playerAreaID, 40.0);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmAddAreaConstraint(playerAreaID, avoidPlayer);
		rmSetAreaWarnFailure(playerAreaID, false);
	}

	// Starting settlement.
	placeObjectAtPlayerLocs(startingSettlementID, true);

	// Towers.
	placeAndStoreObjectAtPlayerLocs(startingTowerID, true, 4, 23.0, 27.0, true); // Last parameter: Square placement.

	progress(0.2);

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

	addFairLoc(65.0, 80.0, false, true, 50.0, 20.0, 20.0, true);

	// Far settlement.
	addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 65.0));

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		setFairLocInterDistMin(80.0);
		addFairLoc(65.0, 80.0, true, false, 75.0, 50.0, 50.0, true);
	} else if (cNonGaiaPlayers < 5) {
		if(randChance()) {
			addFairLoc(65.0, 80.0, true, false, 70.0, 50.0, 50.0, false, gameHasTwoEqualTeams());
		} else {
			addFairLoc(65.0, 80.0, true, true, 70.0, 100.0, 100.0, false, gameHasTwoEqualTeams());
		}
	} else {
		addFairLoc(65.0, 80.0, true, false, 70.0, 50.0, 50.0, false, gameHasTwoEqualTeams());
	}

	placeObjectAtNewFairLocs(settlementID, false, "settlements");

	progress(0.3);

	// Ponds.
	int numPonds = 2 * cNonGaiaPlayers;
	int pondCount = 0;
	int numTries = 150;

	int pondAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 50.0);

	for(i = 0; < numTries) {
		int pondID = rmCreateArea("pond " + i);
		rmSetAreaSize(pondID, rmAreaTilesToFraction(400));
		if(cNonGaiaPlayers < 3) {
			rmSetAreaLocation(pondID, rmRandFloat(0.25, 0.75), rmRandFloat(0.25, 0.75));
		} else {
			rmSetAreaLocation(pondID, rmRandFloat(0.05, 0.95), rmRandFloat(0.05, 0.95));
		}
		rmSetAreaWaterType(pondID, "Egyptian Nile");
		rmSetAreaCoherence(pondID, 1.0);
		rmAddAreaToClass(pondID, classPond);
		rmAddAreaConstraint(pondID, farAvoidPond);
		rmAddAreaConstraint(pondID, pondAvoidSettlement);
		rmAddAreaConstraint(pondID, avoidTowerLOS);
		rmSetAreaWarnFailure(pondID, false);

		if(rmBuildArea(pondID)) {
			pondCount++;

			int decorationID = rmCreateObjectDef("decoration " + i);
			rmAddObjectDefItem(decorationID, "Papyrus", rmRandInt(1, 3), 5.0);
			rmAddObjectDefItem(decorationID, "Water Decoration", rmRandInt(1, 3), 6.0);
			rmPlaceObjectDefInArea(decorationID, 0, pondID, rmRandInt(2, 5));
		}

		if(pondCount >= numPonds) {
			break;
		}
	}

	progress(0.4);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 25 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaTerrainType(beautificationID, "GrassDirt50");
		rmAddAreaTerrainLayer(beautificationID, "GrassDirt75", 0, 2);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(75), rmAreaTilesToFraction(150));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, avoidPlayer);
		rmAddAreaConstraint(beautificationID, avoidImpassableLand);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	// Elevation after ponds.
	int elevationID = 0;

	for(i = 0; < 40 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 1 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(120));
		rmSetAreaBaseHeight(elevationID, rmRandFloat(1.0, 3.0));
		rmSetAreaHeightBlend(elevationID, 1);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 3);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 20.0);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmAddAreaConstraint(elevationID, avoidImpassableLand);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	// Cliffs.
	int numCliffs = 4 * cNonGaiaPlayers;

	for(i = 0; < numCliffs) {
		int cliffID = rmCreateArea("cliff " + i);
		rmSetAreaSize(cliffID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(225));
		rmSetAreaCliffType(cliffID, "Egyptian");
		rmSetAreaCoherence(cliffID, 1.0);
		rmSetAreaCliffEdge(cliffID, 2, 0.25, 0.0, 1.0, 1);
		rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffID, 4, 0.0, 1.0);
		rmSetAreaHeightBlend(cliffID, 1.0);
		rmAddAreaToClass(cliffID, classCliff);
		rmAddAreaConstraint(cliffID, avoidEdge); // This isn't really necessary, but provides cool variations.
		rmAddAreaConstraint(cliffID, shortAvoidPond);
		rmAddAreaConstraint(cliffID, farAvoidCliff);
		rmAddAreaConstraint(cliffID, mediumAvoidSettlement);
		rmAddAreaConstraint(cliffID, avoidBuildings); // For starting settlements.
		rmSetAreaWarnFailure(cliffID, false);

		rmBuildArea(cliffID);
	}

	progress(0.5);

	// Gold.
	int numBonusGold = 4;

	// Far gold (only guarantee 1 for 1v1).
	if(cNonGaiaPlayers < 3) {
		int mediumGoldID = createObjectDefVerify("medium gold");
		addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);
		setSimLocBias(cBiasForward); // We don't want any back mine.
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidCorner);
		addSimLocConstraint(shortAvoidCliff);
		addSimLocConstraint(avoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));

		enableSimLocTwoPlayerCheck();

		addSimLoc(65.0, 75.0, avoidGoldDist, 8.0, 8.0, false, false, true);

		placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold");

		numBonusGold = numBonusGold - 1;
	}

	// Bonus gold.
	// Very small chance to not place one mine in 2v2, just ignore because we have 4 mines per player anyway.
	int bonusGoldID = createObjectDefVerify("bonus gold", cNonGaiaPlayers < 3 || cDebugMode >= cDebugFull);
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classCenterline, 1.0));
	}
	rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);
	rmAddObjectDefConstraint(bonusGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, shortAvoidCliff);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 60.0));

	placeObjectInPlayerSplits(bonusGoldID, false, numBonusGold);

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(avoidImpassableLand);
	storeObjectConstraint(shortAvoidCliff);
	storeObjectConstraint(farAvoidGold);

	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Medium hunt 1.
	float mediumHunt1Float = rmRandFloat(0.0, 1.0);

	int mediumHunt1ID = createObjectDefVerify("medium hunt 1");
	if(mediumHunt1Float < 1.0 / 3.0) {
		addObjectDefItemVerify(mediumHunt1ID, "Zebra", rmRandInt(3, 6), 2.0);
	} else if(mediumHunt1Float < 2.0 / 3.0) {
		addObjectDefItemVerify(mediumHunt1ID, "Gazelle", rmRandInt(4, 8), 2.0);
	} else {
		addObjectDefItemVerify(mediumHunt1ID, "Giraffe", rmRandInt(2, 4), 2.0);
	}

	if(cNonGaiaPlayers < 3) {
		setObjectDefDistance(mediumHunt1ID, 55.0, 65.0);
	} else {
		setObjectDefDistance(mediumHunt1ID, 55.0, 70.0);
	}

	rmAddObjectDefConstraint(mediumHunt1ID, avoidAll);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidEdge);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(mediumHunt1ID, shortAvoidCliff);
	rmAddObjectDefConstraint(mediumHunt1ID, createClassDistConstraint(classStartingSettlement, 55.0));
	rmAddObjectDefConstraint(mediumHunt1ID, mediumAvoidSettlement);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidHuntable);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidTowerLOS);

	placeObjectAtPlayerLocs(mediumHunt1ID);

	// Medium hunt 2.
	int mediumHunt2ID = createObjectDefVerify("medium hunt 2");
	if(randChance()) {
		addObjectDefItemVerify(mediumHunt2ID, "Elephant", 1, 0.0);
	} else {
		addObjectDefItemVerify(mediumHunt2ID, "Rhinocerous", rmRandInt(1, 2), 2.0);
	}
	addObjectDefItemVerify(mediumHunt2ID, "Gazelle", rmRandInt(0, 3), 2.0);

	if(cNonGaiaPlayers < 3) {
		setObjectDefDistance(mediumHunt2ID, 60.0, 70.0);
	} else {
		setObjectDefDistance(mediumHunt2ID, 60.0, 75.0);
	}

	rmAddObjectDefConstraint(mediumHunt2ID, avoidAll);
	rmAddObjectDefConstraint(mediumHunt2ID, avoidEdge);
	rmAddObjectDefConstraint(mediumHunt2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(mediumHunt2ID, shortAvoidCliff);
	rmAddObjectDefConstraint(mediumHunt2ID, createClassDistConstraint(classStartingSettlement, 60.0));
	rmAddObjectDefConstraint(mediumHunt2ID, mediumAvoidSettlement);
	rmAddObjectDefConstraint(mediumHunt2ID, avoidHuntable);
	rmAddObjectDefConstraint(mediumHunt2ID, avoidTowerLOS);

	placeObjectAtPlayerLocs(mediumHunt2ID);

	// Far hunt 1.
	float farHunt1Float = rmRandFloat(0.0, 1.0);

	// Rarely fails to place in teamgames, but don't verify because there is so much hunt on the map anyway.
	int farHunt1ID = createObjectDefVerify("far hunt 1", cNonGaiaPlayers < 3 || cDebugMode >= cDebugFull);
	if(farHunt1Float < 1.0 / 3.0) {
		addObjectDefItemVerify(farHunt1ID, "Gazelle", rmRandInt(0, 4), 4.0);
		addObjectDefItemVerify(farHunt1ID, "Zebra", rmRandInt(3, 6), 4.0);
	} else if(farHunt1Float < 2.0 / 3.0) {
		addObjectDefItemVerify(farHunt1ID, "Gazelle", rmRandInt(1, 3), 2.0);
		addObjectDefItemVerify(farHunt1ID, "Giraffe", rmRandInt(2, 5), 2.0);
	} else {
		addObjectDefItemVerify(farHunt1ID, "Zebra", rmRandInt(3, 9), 2.0);
	}

	if(cNonGaiaPlayers < 3) {
		setObjectDefDistance(farHunt1ID, 70.0, 80.0);
	} else {
		setObjectDefDistance(farHunt1ID, 70.0, 85.0);
	}

	rmAddObjectDefConstraint(farHunt1ID, avoidAll);
	rmAddObjectDefConstraint(farHunt1ID, avoidEdge);
	rmAddObjectDefConstraint(farHunt1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(farHunt1ID, shortAvoidCliff);
	rmAddObjectDefConstraint(farHunt1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHunt1ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farHunt1ID, avoidHuntable);

	placeObjectAtPlayerLocs(farHunt1ID);

	// Far hunt 2.
	// Rarely fails to place in teamgames, but don't verify because there is so much hunt on the map anyway.
	int farHunt2ID = createObjectDefVerify("far hunt 2", cNonGaiaPlayers < 3 || cDebugMode >= cDebugFull);
	if(randChance()) {
		addObjectDefItemVerify(farHunt2ID, "Elephant", rmRandInt(1, 2), 2.0);
	} else {
		addObjectDefItemVerify(farHunt2ID, "Rhinocerous", rmRandInt(1, 3), 2.0);
	}
	setObjectDefDistance(farHunt2ID, 70.0, 100.0);
	rmAddObjectDefConstraint(farHunt2ID, avoidAll);
	rmAddObjectDefConstraint(farHunt2ID, avoidEdge);
	rmAddObjectDefConstraint(farHunt2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(farHunt2ID, shortAvoidCliff);
	rmAddObjectDefConstraint(farHunt2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHunt2ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farHunt2ID, avoidHuntable);

	placeObjectAtPlayerLocs(farHunt2ID);

	if(cNonGaiaPlayers > 2) {
		// Bonus tg hunt (don't verify).
		int bonusHuntID = createObjectDefVerify("bonus hunt", cDebugMode >= cDebugFull);
		addObjectDefItemVerify(bonusHuntID, "Gazelle", rmRandInt(1, 5), 2.0);
		addObjectDefItemVerify(bonusHuntID, "Giraffe", rmRandInt(2, 3), 2.0);
		rmAddObjectDefConstraint(bonusHuntID, avoidAll);
		rmAddObjectDefConstraint(bonusHuntID, avoidEdge);
		rmAddObjectDefConstraint(bonusHuntID, avoidImpassableLand);
		rmAddObjectDefConstraint(bonusHuntID, shortAvoidCliff);
		rmAddObjectDefConstraint(bonusHuntID, createClassDistConstraint(classStartingSettlement, 100.0));
		rmAddObjectDefConstraint(bonusHuntID, shortAvoidSettlement);
		rmAddObjectDefConstraint(bonusHuntID, avoidHuntable);

		placeObjectInTeamSplits(bonusHuntID);
	}

	// Other food.
	// Starting hunt.
	placeObjectAtPlayerLocs(startingHuntID);

	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

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
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(80));
			rmSetAreaForestType(playerForestID, "Savannah Forest");
			rmSetAreaMinBlobs(playerForestID, 3);
			rmSetAreaMaxBlobs(playerForestID, 5);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 32.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, avoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, avoidImpassableLand);
			rmAddAreaConstraint(playerForestID, shortAvoidCliff);
			rmSetAreaWarnFailure(playerForestID, false);
			rmBuildArea(playerForestID);
		}
	}

	// Other forest.
	int numRegularForests = 12 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(80));
		rmSetAreaForestType(forestID, "Savannah Forest");
		rmSetAreaMinBlobs(forestID, 3);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 32.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, avoidImpassableLand);
		rmAddAreaConstraint(forestID, shortAvoidCliff);
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
	placeObjectAtPlayerLocs(farHerdablesID);

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectInPlayerSplits(relicID);

	// Random trees.
	placeObjectAtPlayerLocs(randomTreeID, false, 10);

	progress(0.9);

	// Embellishment.
	int loneHuntID = rmCreateObjectDef("lone hunt");
	if(randChance()) {
		rmAddObjectDefItem(loneHuntID, "Monkey", 1, 0.0);
	} else {
		rmAddObjectDefItem(loneHuntID, "Baboon", 1, 0.0);
	}
	setObjectDefDistanceToMax(loneHuntID);
	rmAddObjectDefConstraint(loneHuntID, avoidAll);
	rmAddObjectDefConstraint(loneHuntID, avoidImpassableLand);
	rmAddObjectDefConstraint(loneHuntID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(loneHuntID, avoidFood);
	rmPlaceObjectDefAtLoc(loneHuntID, 0, 0.5, 0.5, 2 * cNonGaiaPlayers);

	// Rocks.
	int rock1ID = rmCreateObjectDef("rock small");
	rmAddObjectDefItem(rock1ID, "Rock Sandstone Small", 1, 0.0);
	setObjectDefDistanceToMax(rock1ID);
	rmAddObjectDefConstraint(rock1ID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(rock1ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	int rock2ID = rmCreateObjectDef("rock sprite");
	rmAddObjectDefItem(rock2ID, "Rock Sandstone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rock2ID);
	rmAddObjectDefConstraint(rock2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rock2ID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(rock2ID, 0, 0.5, 0.5, 30 * cNonGaiaPlayers);

	// Bushes.
	int bush1ID = rmCreateObjectDef("bush 1");
	rmAddObjectDefItem(bush1ID, "Bush", 4, 4.0);
	setObjectDefDistanceToMax(bush1ID);
	rmAddObjectDefConstraint(bush1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush1ID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush1ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	int bush2ID = rmCreateObjectDef("bush 2");
	rmAddObjectDefItem(bush2ID, "Bush", 3, 2.0);
	rmAddObjectDefItem(bush2ID, "Rock Sandstone Sprite", 1, 2.0);
	setObjectDefDistanceToMax(bush2ID);
	rmAddObjectDefConstraint(bush2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush2ID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	// Grass.
	int grassID = rmCreateObjectDef("grass");
	rmAddObjectDefItem(grassID, "Grass", 1, 0.0);
	setObjectDefDistanceToMax(grassID);
	rmAddObjectDefConstraint(grassID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(grassID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 30 * cNonGaiaPlayers);

	// Drifts.
	int driftID = rmCreateObjectDef("drift");
	rmAddObjectDefItem(driftID, "Sand Drift Patch", 1, 0.0);
	setObjectDefDistanceToMax(driftID);
	rmAddObjectDefConstraint(driftID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(driftID, avoidEdge);
	rmAddObjectDefConstraint(driftID, avoidImpassableLand);
	rmAddObjectDefConstraint(driftID, avoidBuildings);
	rmAddObjectDefConstraint(driftID, createTypeDistConstraint("Sand Drift Patch", 25.0));
	rmPlaceObjectDefAtLoc(driftID, 0, 0.5, 0.5, 3 * cNonGaiaPlayers);

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
	addProtoPlacementCheck("Gold Mine Small", cNonGaiaPlayers, 0);
	addProtoPlacementCheck("Settlement", 2 * cNonGaiaPlayers, 0);

	// Finalize RM X.
	rmxFinalize();

	progress(1.0);
}
