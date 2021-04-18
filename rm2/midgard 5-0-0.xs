/*
** MIDGARD
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

// Override forward/inside town center angles for better variations.

mutable float randFwdInsideFirst(float tol = 0.0) {
	if(cNonGaiaPlayers < 5) {
		return(rmRandFloat(0.7 - 0.3 * tol, 1.0 + 0.5 * tol) * PI);
	}

	return(rmRandFloat(0.5 - 0.25 * tol, 0.65 + 0.15 * tol) * PI);
}

mutable float randFwdInsideLast(float tol = 0.0) {
	if(cNonGaiaPlayers < 5) {
		return(rmRandFloat(1.0 - 0.5 * tol, 1.3 + 0.2 * tol) * PI);
	}

	return(rmRandFloat(1.35 - 0.15 * tol, 1.5 + 0.25 * tol) * PI);
}

mutable float randFwdCenter(float tol = 0.0) {
	if(cNonGaiaPlayers < 5) {
		if(tol == 0.0) {
			return(rmRandFloat(0.8, 1.2) * PI);
		} else {
			return(randFromIntervals(0.8 - 0.6 * tol, 0.8, 1.2, 1.2 + 0.6 * tol) * PI);
		}
	}

	return(rmRandFloat(0.65 - 0.1 * tol, 1.35 + 0.1 * tol) * PI);
}

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Midgard");

	// Set size.
	int axisLength = getStandardMapDimInMeters(12750, 1.0);

	// Randomize water type.
	float waterType = rmRandFloat(0.0, 1.0); // Needed later for embellishment.

	if(waterType < 0.5) {
		rmSetSeaType("North Atlantic Ocean");
	} else {
		rmSetSeaType("Norwegian Sea");
	}

	// Initialize map.
	initializeMap("Water", axisLength);

	// Player placement.
	if(cNonGaiaPlayers < 3) {
		placePlayersInCircle(0.25, 0.275);
	} else {
		placePlayersInCircle(0.275, 0.3);
	}

	// Control areas.
	int classCenter = initializeCenter();
	int classCorner = initializeCorners(rmXFractionToMeters(0.175 + 0.005 * cNonGaiaPlayers)); // Larger corners for fish constraint.
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
	int classPlayer = rmDefineClass("player");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classForest = rmDefineClass("forest");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(20), rmZTilesToFraction(20));
	int avoidPlayer = createClassDistConstraint(classPlayer, 1.0);
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);

	// Terrain.
	int avoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);

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
	rmAddObjectDefConstraint(startingTowerID, avoidTower);
	// rmAddObjectDefConstraint(startingTowerID, avoidEdge);
	rmAddObjectDefConstraint(startingTowerID, avoidImpassableLand);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(4, 7), 2.0);
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Cow", rmRandInt(1, 2), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, avoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Pine Snow", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Cow", rmRandInt(1, 2), 4.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, avoidImpassableLand);
	rmAddObjectDefConstraint(farHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	if(randChance()) {
		addObjectDefItemVerify(farPredatorsID, "Wolf", 2, 4.0);
	} else {
		addObjectDefItemVerify(farPredatorsID, "Bear", 1, 0.0);
	}
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, avoidImpassableLand);
	rmAddObjectDefConstraint(farPredatorsID, avoidTowerLOS);
	rmAddObjectDefConstraint(farPredatorsID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredatorsID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredatorsID, avoidFood);
	rmAddObjectDefConstraint(farPredatorsID, avoidPredator);

	// Other objects.
	// Relics.
	int relicID = createObjectDefVerify("relic");
	addObjectDefItemVerify(relicID, "Relic", 1, 0.0);
	rmAddObjectDefConstraint(relicID, avoidAll);
	rmAddObjectDefConstraint(relicID, avoidEdge);
	rmAddObjectDefConstraint(relicID, avoidImpassableLand);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random trees.
	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "Pine Snow", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Create terrain and extend with player areas to make sure towers also fit.
	// Build continent.
	int centerID = rmCreateArea("center");
	rmSetAreaSize(centerID, 0.5);
	rmSetAreaLocation(centerID, 0.5, 0.5);
	rmSetAreaTerrainType(centerID, "SnowA");
	rmSetAreaCoherence(centerID, 0.1);
	rmSetAreaBaseHeight(centerID, 2.0);
	rmSetAreaHeightBlend(centerID, 2);
	rmSetAreaSmoothDistance(centerID, 30);
	rmAddAreaConstraint(centerID, createSymmetricBoxConstraint(0.075, 0.075, 0.01));
	rmSetAreaWarnFailure(centerID, false);
	rmBuildArea(centerID);

	// Setup fake player areas so we have enough space for towers.
	float fakePlayerAreaSize = areaRadiusMetersToFraction(45.0);

	for(i = 1; < cPlayers) {
		int fakePlayerAreaID = rmCreateArea("fake player area " + i);
		rmSetAreaSize(fakePlayerAreaID, fakePlayerAreaSize, fakePlayerAreaSize);
		rmSetAreaLocPlayer(fakePlayerAreaID, getPlayer(i));
		rmSetAreaTerrainType(fakePlayerAreaID, "SnowA");
		rmSetAreaHeightBlend(fakePlayerAreaID, 2);
		rmSetAreaCoherence(fakePlayerAreaID, 1.0);
		rmSetAreaBaseHeight(fakePlayerAreaID, 2.0);
		rmSetAreaWarnFailure(fakePlayerAreaID, false);
	}

	rmBuildAllAreas();

	// Set up actual player areas
	float playerAreaSize = rmAreaTilesToFraction(3000);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, 0.9 * playerAreaSize, 1.1 * playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "SnowGrass50");
		rmAddAreaTerrainLayer(playerAreaID, "SnowGrass25", 0, 12);
		rmSetAreaMinBlobs(playerAreaID, 1);
		rmSetAreaMaxBlobs(playerAreaID, 5);
		rmSetAreaMinBlobDistance(playerAreaID, 16.0);
		rmSetAreaMaxBlobDistance(playerAreaID, 40.0);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmAddAreaConstraint(playerAreaID, avoidPlayer);
		rmAddAreaConstraint(playerAreaID, avoidImpassableLand);
		rmSetAreaWarnFailure(playerAreaID, false);
	}

	rmBuildAllAreas();

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 5 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(10));
		rmSetAreaTerrainType(beautificationID, "SnowB");
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 2);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, avoidImpassableLand);
		rmAddAreaConstraint(beautificationID, avoidPlayer);
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

	int settlementAvoidImpassableLand = createTerrainDistConstraint("Land", false, 28.0);

	// Try 4 times.
	int numFairLocTries = 2;
	bool settleBool = randChance(0.75);

	for(i = 0; < numFairLocTries) {
		// Close settlement.
		enableFairLocTwoPlayerCheck();

		if(cNonGaiaPlayers > 2) {
			addFairLocConstraint(avoidTowerLOS);
		}

		addFairLocConstraint(settlementAvoidImpassableLand);

		if(cNonGaiaPlayers < 3) {
			addFairLoc(60.0, 80.0, false, true, 70.0, 0.0, 0.0, true);
		} else {
			addFairLoc(60.0, 80.0, false, true, 55.0);
		}

		// Far settlement.
		addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
		addFairLocConstraint(settlementAvoidImpassableLand);

		enableFairLocTwoPlayerCheck();

		// For anything but 1v1, the forward/backward variation has no impact because the map is so small.
		if(cNonGaiaPlayers < 3) {
			if(settleBool) {
				addFairLoc(70.0, 120.0, true, true, 70.0);
			} else {
				addFairLoc(65.0, 100.0, false, true, 70.0);
			}
		} else if(cNonGaiaPlayers < 5) {
			addFairLoc(70.0, 80.0, true, settleBool, rmRandFloat(70.0, 80.0), 0.0, 0.0, false, gameHasTwoEqualTeams());
		} else {
			addFairLoc(70.0, 90.0, true, settleBool, 65.0, 0.0, 0.0, false, gameHasTwoEqualTeams());
		}

		if(placeObjectAtNewFairLocs(settlementID, false, "settlements " + i, i == numFairLocTries - 1)) {
			break;
		}

		if(settleBool) {
			settleBool = false;
		} else {
			settleBool = true;
		}
	}

	progress(0.4);

	// Elevation.
	int elevationID = 0;

	for(i = 0; < 10 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 1 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(80));
		if(randChance()) {
			rmSetAreaTerrainType(elevationID, "SnowGrass25");
		}
		rmSetAreaBaseHeight(elevationID, rmRandFloat(2.0, 4.0));
		rmSetAreaHeightBlend(elevationID, 1);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 5);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 40.0);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmAddAreaConstraint(elevationID, avoidImpassableLand);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	progress(0.5);

	// Gold.
	int numMediumGold = 0;
	int numBonusGold = 0;
	float goldFloat = rmRandFloat(0.0, 1.0);

	if(goldFloat < 1.0 / 3.0) {
		numMediumGold = 2;
		numBonusGold = 1;
	} else if(goldFloat < 2.0 / 3.0) {
		if(randChance()) {
			numMediumGold = 2;
			numBonusGold = 2;
		} else {
			numMediumGold = 1;
			numBonusGold = 3;
		}
	} else {
		numMediumGold = 2;
		numBonusGold = 3;
	}

	// Medium gold.
	int mediumGoldID = createObjectDefVerify("medium gold");
	addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidImpassableLand);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(farAvoidSettlement);
	addSimLocConstraint(farAvoidGold);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));

	enableSimLocTwoPlayerCheck();

	addSimLoc(50.0, 50.0 + 10.0 * numMediumGold, avoidGoldDist, 0.0, 0.0, false, false, true);

	if(numMediumGold == 2) {
		enableSimLocTwoPlayerCheck();

		addSimLocWithPrevConstraints(50.0, 50.0 + 10.0 * numMediumGold, avoidGoldDist, 0.0, 0.0, false, false, true);
	}

	placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold");

	// Bonus gold.
	// Only verify this if we have less than 5 mines.
	int bonusGoldID = createObjectDefVerify("bonus gold", numMediumGold + numBonusGold < 5 || cDebugMode >= cDebugFull);
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 70.0));

	placeObjectInPlayerSplits(bonusGoldID, false, numBonusGold);

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
	// Place walrus first.
	// Medium walrus.
	int mediumWalrusID = createObjectDefVerify("medium walrus");
	addObjectDefItemVerify(mediumWalrusID, "Walrus", rmRandInt(3, 6), 2.0);

	float mediumWalrusMinDist = rmRandFloat(60.0, 90.0);
	float mediumWalrusMaxDist = mediumWalrusMinDist + 15.0;

	if(cNonGaiaPlayers > 2) {
		mediumWalrusMinDist = rmRandFloat(60.0, 80.0);
		mediumWalrusMaxDist = mediumWalrusMinDist + 15.0;
	}

	setObjectDefDistance(mediumWalrusID, mediumWalrusMinDist, mediumWalrusMaxDist);
	rmAddObjectDefConstraint(mediumWalrusID, avoidAll);
	rmAddObjectDefConstraint(mediumWalrusID, createTerrainDistConstraint("Land", false, 1.0));
	rmAddObjectDefConstraint(mediumWalrusID, createTerrainMaxDistConstraint("Water", true, 12.0));
	rmAddObjectDefConstraint(mediumWalrusID, farAvoidSettlement);
	rmAddObjectDefConstraint(mediumWalrusID, createClassDistConstraint(classStartingSettlement, 60.0));
	rmAddObjectDefConstraint(mediumWalrusID, avoidHuntable);

	placeObjectAtPlayerLocs(mediumWalrusID, false, 1);

	// Bonus walrus.
	int numBonusWalrus = 1;

	if(randChance(0.25) && cNonGaiaPlayers < 7) {
		numBonusWalrus = 2;
	}

	// Only verify for 1v1. Rarely fails to place in teamgames we have numBonusWalrus == 2, but since we have a lot anyway it doesn't matter.
	int bonusWalrusID = createObjectDefVerify("bonus walrus", cNonGaiaPlayers < 3 || cDebugMode >= cDebugTest);
	addObjectDefItemVerify(bonusWalrusID, "Walrus", rmRandInt(2, 5), 2.0);

	rmAddObjectDefConstraint(bonusWalrusID, avoidAll);
	rmAddObjectDefConstraint(bonusWalrusID, shortAvoidSettlement);
	rmAddObjectDefConstraint(bonusWalrusID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusWalrusID, avoidHuntable);
	rmAddObjectDefConstraint(bonusWalrusID, createTerrainDistConstraint("Land", false, 1.0));
	rmAddObjectDefConstraint(bonusWalrusID, createTerrainMaxDistConstraint("Water", true, 10.0));
	// Let walrus avoid virtual centerline for fairer placement.
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(bonusWalrusID, createClassDistConstraint(classStartingSettlement, 90.0 - 15.0 * numBonusWalrus));
		rmAddObjectDefConstraint(bonusWalrusID, createClassDistConstraint(classCenterline, 15.0));
	} else {
		rmAddObjectDefConstraint(bonusWalrusID, avoidTowerLOS);
		rmAddObjectDefConstraint(bonusWalrusID, createClassDistConstraint(classStartingSettlement, 60.0));
	}

	placeObjectInPlayerSplits(bonusWalrusID, false, numBonusWalrus);

	// Medium hunt.
	int mediumHuntID = createObjectDefVerify("medium hunt");
	addObjectDefItemVerify(mediumHuntID, "Deer", rmRandInt(4, 8), 2.0);

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(shortAvoidSettlement);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
	addSimLocConstraint(avoidImpassableLand);
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(shortAvoidGold);

	enableSimLocTwoPlayerCheck();

	addSimLoc(70.0, 80.0, avoidHuntDist, 0.0, 0.0, false, false, true);

	placeObjectAtNewSimLocs(mediumHuntID, false, "medium hunt");

	// Bonus hunt.
	int bonusHuntID = createObjectDefVerify("bonus hunt");
	if(randChance()) {
		addObjectDefItemVerify(bonusHuntID, "Elk", rmRandInt(4, 9), 2.0);
	} else {
		addObjectDefItemVerify(bonusHuntID, "Caribou", rmRandInt(4, 9), 2.0);
	}
	rmAddObjectDefConstraint(bonusHuntID, avoidAll);
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(bonusHuntID, createClassDistConstraint(classCenterline, 10.0));
		rmAddObjectDefConstraint(bonusHuntID, createClassDistConstraint(classStartingSettlement, 70.0));
	} else {
		rmAddObjectDefConstraint(bonusHuntID, createClassDistConstraint(classStartingSettlement, 60.0));
	}
	rmAddObjectDefConstraint(bonusHuntID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusHuntID, farAvoidSettlement);
	rmAddObjectDefConstraint(bonusHuntID, avoidHuntable);

	placeObjectInPlayerSplits(bonusHuntID, false, 1);

	// Other food.
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
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(140));
			rmSetAreaForestType(playerForestID, "Snow Pine Forest");
			rmSetAreaMinBlobs(playerForestID, 1);
			rmSetAreaMaxBlobs(playerForestID, 4);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 25.0);
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
	int numRegularForests = 10 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(140));
		rmSetAreaForestType(forestID, "Snow Pine Forest");
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 4);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 25.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, avoidForest);
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
	placeObjectInTeamSplits(farPredatorsID);

	// Herdables.
	placeObjectInPlayerSplits(farHerdablesID, false, rmRandInt(1, 2));

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectInTeamSplits(relicID);

	// Random trees.
	placeObjectAtPlayerLocs(randomTreeID, false, 10);

	// Fish.
	int avoidFish = createTypeDistConstraint("Fish", 30.0);

	if(cNonGaiaPlayers < 5) {
		avoidFish = createTypeDistConstraint("Fish", 24.0);
	}

	int fishLandMin = createTerrainDistConstraint("Land", true, 17.0);
	int fishLandMax = createTerrainMaxDistConstraint("Land", true, 22.0);
	int fishEdgeConstraint = createSymmetricBoxConstraint(0.02, 0.02);

	// Player axis fish (from the center through/behind the player).
	float axisFishDist = 30.0;
	float axisDistIncr = 0.5;

	for(i = 1; < cPlayers) {
		int axisFishID = rmCreateObjectDef("player axis fish " + i);
		rmAddObjectDefItem(axisFishID, "Fish - Salmon", 3, 8.0);
		// rmAddObjectDefConstraint(axisFishID, avoidTowerLOS);
		rmAddObjectDefConstraint(axisFishID, fishLandMin);
		rmAddObjectDefConstraint(axisFishID, fishLandMax);
		rmAddObjectDefConstraint(axisFishID, fishEdgeConstraint);

		for(k = 0; < 1000) {
			float fishRadius = rmXMetersToFraction(axisFishDist + axisDistIncr * k);

			float x = getXFromPolarForPlayer(i, fishRadius, 0.0);
			float z = getZFromPolarForPlayer(i, fishRadius, 0.0);

			if(placeObjectForPlayer(axisFishID, 0, x, z)) {
				printDebug("axisFish: i = " + i + ", k = " + k, cDebugTest);
				break;
			}
		}
	}

	// Player fish.
	int numPlayerFish = rmRandInt(1, 2);

	if(cNonGaiaPlayers > 4) {
		numPlayerFish = 2;
	}

	float playerFishDist = 40.0;
	float playerFishDistIncr = 2.5 * cNonGaiaPlayers;

	for(i = 1; < cPlayers) {
		int playerFishID = rmCreateObjectDef("player fish " + i);
		rmAddObjectDefItem(playerFishID, "Fish - Salmon", 3, 8.0);
		rmAddObjectDefConstraint(playerFishID, avoidTowerLOS);
		rmAddObjectDefConstraint(playerFishID, fishLandMin);
		rmAddObjectDefConstraint(playerFishID, fishLandMax);
		rmAddObjectDefConstraint(playerFishID, avoidFish);
		rmAddObjectDefConstraint(playerFishID, fishEdgeConstraint);

		for(k = 0; < 25) {
			setObjectDefDistance(playerFishID, playerFishDist, playerFishDist + playerFishDistIncr * (k + 1));

			// Use original square placement for performance (custom circular placement is a lot slower here).
			placeObjectAtPlayerLoc(playerFishID, false, i);

			if(rmGetNumberUnitsPlaced(playerFishID) / 3 >= numPlayerFish) {
				printDebug("playerFish: i = " + i + ", k = " + k, cDebugTest);
				break;
			}
		}
	}

	// Other fish (don't verify).
	int numBonusFish = rmRandInt(3, 5);

	if(cNonGaiaPlayers > 4) {
		numBonusFish = 3;
	}

	for(i = 1; < cPlayers) {
		int bonusFishID = rmCreateObjectDef("bonus fish " + i);
		rmAddObjectDefItem(bonusFishID, "Fish - Salmon", 3, 8.0);
		if(cNonGaiaPlayers < 5) {
			setObjectDefDistance(bonusFishID, 85.0, 135.0);
		} else {
			setObjectDefDistance(bonusFishID, 85.0, 0.425 * axisLength);
		}
		rmAddObjectDefConstraint(bonusFishID, fishLandMin);
		rmAddObjectDefConstraint(bonusFishID, avoidFish);
		rmAddObjectDefConstraint(bonusFishID, fishEdgeConstraint);
		rmAddObjectDefConstraint(bonusFishID, avoidCorner);
		if(cNonGaiaPlayers < 7) {
			rmAddObjectDefConstraint(bonusFishID, createAreaConstraint(rmAreaID(cSplitName + " " + i)));
		}
		placeObjectAtPlayerLoc(bonusFishID, false, i, numBonusFish);
	}

	// Lone fish.
	int numLoneFish = 5;

	if(cNonGaiaPlayers > 4) {
		numLoneFish = 3;
	}

	int loneFishID = rmCreateObjectDef("lone fish");
	rmAddObjectDefItem(loneFishID, "Fish - Perch", 1, 0.0);
	setObjectDefDistanceToMax(loneFishID);
	rmAddObjectDefConstraint(loneFishID, fishLandMin);
	rmAddObjectDefConstraint(loneFishID, avoidFish);
	// rmAddObjectDefConstraint(loneFishID, fishEdgeConstraint);
	rmPlaceObjectDefAtLoc(loneFishID, 0, 0.5, 0.5, numLoneFish * cNonGaiaPlayers);

	progress(0.9);

	// Embellishment.
	// Rocks.
	int rockID = rmCreateObjectDef("rock sprite");
	rmAddObjectDefItem(rockID, "Rock Granite Sprite", 1, 1.0);
	setObjectDefDistanceToMax(rockID);
	rmAddObjectDefConstraint(rockID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 30 * cNonGaiaPlayers);

	// Orcas.
	int orcaID = rmCreateObjectDef("orca");
	rmAddObjectDefItem(orcaID, "Orca", 1, 0.0);
	setObjectDefDistanceToMax(orcaID);
	rmAddObjectDefConstraint(orcaID, createTerrainDistConstraint("Land", true, 20.0));
	rmAddObjectDefConstraint(orcaID, createTypeDistConstraint("Orca", 20.0));
	rmAddObjectDefConstraint(orcaID, avoidEdge);
	rmPlaceObjectDefAtLoc(orcaID, 0, 0.5, 0.5, cNonGaiaPlayers);

	// Seaweed.
	if(waterType >= 0.5) {
		int seaweedShoreMin = createTerrainDistConstraint("Land", true, 8.0);
		int seaweedShoreMax = createTerrainMaxDistConstraint("Land", true, 12.0);

		int seaweed1ID = rmCreateObjectDef("seaweed 1");
		rmAddObjectDefItem(seaweed1ID, "Seaweed", 5, 3.0);
		setObjectDefDistanceToMax(seaweed1ID);
		rmAddObjectDefConstraint(seaweed1ID, embellishmentAvoidAll);
		rmAddObjectDefConstraint(seaweed1ID, seaweedShoreMin);
		rmAddObjectDefConstraint(seaweed1ID, seaweedShoreMax);
		rmPlaceObjectDefAtLoc(seaweed1ID, 0, 0.5, 0.5, 8 * cNonGaiaPlayers);

		int seaweed2ID = rmCreateObjectDef("seaweed 2");
		rmAddObjectDefItem(seaweed2ID, "Seaweed", 2, 3.0);
		setObjectDefDistanceToMax(seaweed2ID);
		rmAddObjectDefConstraint(seaweed2ID, embellishmentAvoidAll);
		rmAddObjectDefConstraint(seaweed2ID, seaweedShoreMin);
		rmAddObjectDefConstraint(seaweed2ID, seaweedShoreMax);
		rmPlaceObjectDefAtLoc(seaweed2ID, 0, 0.5, 0.5, 12 * cNonGaiaPlayers);
	}

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
