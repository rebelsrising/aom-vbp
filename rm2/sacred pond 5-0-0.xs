/*
** SACRED POND
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Sacred Pond (by RebelsRising & Flame)");

	// Set size.
	int axisLength = getStandardMapDimInMeters(7500);

	// Initialize map.
	initializeMap("SandD", axisLength);

	// Player placement.
	if(cNonGaiaPlayers < 3) {
		if(randChance()) {
			placePlayersInLine(0.2, 0.2, 0.8, 0.8);
		} else {
			placePlayersInLine(0.2, 0.8, 0.8, 0.2);
		}
	} else {
		placePlayersInCircle(0.4, 0.4, 0.85);
	}

	// Control areas.
	int classCorner = initializeCorners();
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
	int classCenter = rmDefineClass("center"); // This is just a normal class here.
	int classPlayer = rmDefineClass("player");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classForest = rmDefineClass("forest");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidPlayer = createClassDistConstraint(classPlayer, 1.0);
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);

	// Terrain.
	int shortAvoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);
	int mediumAvoidImpassableLand = createTerrainDistConstraint("Land", false, 15.0);
	int farAvoidImpassableLand = createTerrainDistConstraint("Land", false, 25.0);

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
	int shortAvoidForest = createClassDistConstraint(classForest, 12.0);
	int farAvoidForest = createClassDistConstraint(classForest, 25.0);
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
	rmAddObjectDefConstraint(startingTowerID, shortAvoidImpassableLand);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(7, 8), 2.0);
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting hunt.
	int startingHuntID = createObjectDefVerify("starting hunt");
	addObjectDefItemVerify(startingHuntID, "Gazelle", rmRandInt(4, 6), 2.0);
	addObjectDefItemVerify(startingHuntID, "Crowned Crane", rmRandInt(1, 3), 2.0);
	setObjectDefDistance(startingHuntID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingHuntID, avoidAll);
	rmAddObjectDefConstraint(startingHuntID, avoidEdge);
	rmAddObjectDefConstraint(startingHuntID, farAvoidImpassableLand);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Pig", rmRandInt(1, 3), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, shortAvoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Palm", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Monkeys.
	int farMonkeysID = createObjectDefVerify("far monkeys");
	if(randChance()) {
		addObjectDefItemVerify(farMonkeysID, "Baboon", rmRandInt(4, 6), 2.0);
	} else {
		addObjectDefItemVerify(farMonkeysID, "Monkey", rmRandInt(5, 8), 2.0);
	}
	rmAddObjectDefConstraint(farMonkeysID, avoidAll);
	rmAddObjectDefConstraint(farMonkeysID, avoidEdge);
	rmAddObjectDefConstraint(farMonkeysID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(farMonkeysID, createClassDistConstraint(classStartingSettlement, 70.0));
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(farMonkeysID, shortAvoidSettlement);
	}
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidGold);
	rmAddObjectDefConstraint(farMonkeysID, avoidHuntable);

	// Cranes.
	int farCranesID = createObjectDefVerify("far cranes");
	addObjectDefItemVerify(farCranesID, "Crowned Crane", rmRandInt(4, 6), 2.0);
	rmAddObjectDefConstraint(farCranesID, avoidAll);
	rmAddObjectDefConstraint(farCranesID, avoidEdge);
	rmAddObjectDefConstraint(farCranesID, createTerrainDistConstraint("Land", false, 1.0));
	rmAddObjectDefConstraint(farCranesID, createTerrainMaxDistConstraint("Land", false, 10.0));
	rmAddObjectDefConstraint(farCranesID, createClassDistConstraint(classStartingSettlement, 70.0));

	// Far berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", rmRandInt(8, 10), 4.0);
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidEdge);
	rmAddObjectDefConstraint(farBerriesID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farBerriesID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Pig", 2, 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Pig", rmRandInt(1, 3), 4.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	addObjectDefItemVerify(farPredatorsID, "Lion", 2, 4.0);
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, shortAvoidImpassableLand);
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
	rmAddObjectDefConstraint(relicID, avoidCorner);
	rmAddObjectDefConstraint(relicID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random trees.
	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "Palm", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Create sea.
	int seaID = rmCreateArea("sea");
	rmSetAreaSize(seaID, 0.1);
	rmSetAreaLocation(seaID, 0.5, 0.5);
	rmSetAreaWaterType(seaID, "Egyptian Nile");
	rmSetAreaCoherence(seaID, 0.1);
	rmSetAreaBaseHeight(seaID, 0.0);
	rmSetAreaSmoothDistance(seaID, 50);
	rmSetAreaWarnFailure(seaID, false);
	rmBuildArea(seaID);

	// Center forests.
	int numCenterForests = 15;
	int centerForestFailCount = 0;

	float centerForestSize = rmAreaTilesToFraction(40 + 5 * cNonGaiaPlayers);

	int forestShoreMin = createEdgeDistConstraint(seaID, 8.0);
	int forestShoreMax = createEdgeMaxDistConstraint(seaID, 22.0);
	int avoidCenterForest = createClassDistConstraint(classForest, 12.0);

	for(i = 0; < numCenterForests * cNonGaiaPlayers) {
		int centerForestID = rmCreateArea("center forest " + i);
		rmSetAreaSize(centerForestID, centerForestSize);
		rmSetAreaForestType(centerForestID, "Palm Forest");
		rmSetAreaCoherence(centerForestID, 1.0);
		rmAddAreaToClass(centerForestID, classForest);
		rmAddAreaConstraint(centerForestID, forestShoreMin);
		rmAddAreaConstraint(centerForestID, forestShoreMax);
		rmAddAreaConstraint(centerForestID, avoidCenterForest);
		rmSetAreaWarnFailure(centerForestID, false);

		if(rmBuildArea(centerForestID) == false) {
			centerForestFailCount++;

			if(centerForestFailCount == 3) {
				break;
			}
		} else {
			centerForestFailCount = 0;
		}
	}

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 1; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaTerrainType(beautificationID, "SandC");
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, avoidAll);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 1; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaTerrainType(beautificationID, "SandB");
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, avoidAll);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
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
	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(shortAvoidForest);
	addFairLocConstraint(farAvoidImpassableLand);

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		addFairLoc(60.0, 80.0, false, true, 60.0, 12.0, 12.0);
	} else {
		addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
		addFairLoc(60.0, 80.0, false, true, 50.0, 12.0, 12.0);
	}

	// Far settlement.
	addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
	addFairLocConstraint(shortAvoidForest);
	addFairLocConstraint(farAvoidImpassableLand);

	if(cNonGaiaPlayers < 3) {
		enableFairLocTwoPlayerCheck();
		setFairLocInterDistMin(80.0);

		addFairLoc(70.0, 120.0, true, false, 80.0, 12.0, 12.0);
	} else {
		addFairLoc(80.0, 100.0, true, false, 70.0, 12.0, 12.0, false, cNonGaiaPlayers < 7 && gameHasTwoEqualTeams());
	}

	placeObjectAtNewFairLocs(settlementID, false, "settlements");

	progress(0.4);
	
	// Elevation.
	int elevationID = 0;

	for(i = 0; < 40 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 1 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(100));
		rmSetAreaBaseHeight(elevationID, rmRandFloat(1.0, 3.0));
		rmSetAreaHeightBlend(elevationID, 1);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 5);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 40.0);
		rmAddAreaConstraint(elevationID, avoidAll);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmAddAreaConstraint(elevationID, farAvoidImpassableLand);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	progress(0.5);

	// Gold.
	// Medium gold.
	int numMediumGold = rmRandInt(1, 2);

	if(cNonGaiaPlayers > 2) {
		numMediumGold = 1;
	}

	int mediumGoldID = createObjectDefVerify("medium gold");
	addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);
	setObjectDefDistance(mediumGoldID, 50.0, 30.0 + 30.0 * numMediumGold);
	rmAddObjectDefConstraint(mediumGoldID, avoidAll);
	rmAddObjectDefConstraint(mediumGoldID, avoidEdge);
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(mediumGoldID, avoidCorner);
	}
	rmAddObjectDefConstraint(mediumGoldID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumGoldID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumGoldID, farAvoidSettlement);
	rmAddObjectDefConstraint(mediumGoldID, farAvoidGold);
	rmAddObjectDefConstraint(mediumGoldID, shortAvoidForest);

	placeObjectAtPlayerLocs(mediumGoldID, false, numMediumGold);

	if(cNonGaiaPlayers < 3) {
		// Bonus gold.
		int numBonusGold = 2;

		int bonusGoldID = createObjectDefVerify("far gold");
		addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
		rmAddObjectDefConstraint(bonusGoldID, avoidAll);
		rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
		if(cNonGaiaPlayers < 3) {
			rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
			rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classCenterline, 10.0));
		}
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 90.0));
		rmAddObjectDefConstraint(bonusGoldID, farAvoidImpassableLand);
		rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
		rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);
		rmAddObjectDefConstraint(bonusGoldID, shortAvoidForest);

		placeObjectInTeamSplits(bonusGoldID, false, numBonusGold);
	} else {
		// Far gold.
		int numFarGold = 2;

		int farGoldID = createObjectDefVerify("far gold");
		addObjectDefItemVerify(farGoldID, "Gold Mine", 1, 0.0);
		setObjectDefDistance(farGoldID, 70.0, 100.0);
		rmAddObjectDefConstraint(farGoldID, avoidAll);
		rmAddObjectDefConstraint(farGoldID, avoidEdge);
		rmAddObjectDefConstraint(farGoldID, avoidCorner);
		rmAddObjectDefConstraint(farGoldID, createClassDistConstraint(classStartingSettlement, 70.0));
		rmAddObjectDefConstraint(farGoldID, farAvoidImpassableLand);
		rmAddObjectDefConstraint(farGoldID, farAvoidSettlement);
		rmAddObjectDefConstraint(farGoldID, farAvoidGold);
		rmAddObjectDefConstraint(farGoldID, shortAvoidForest);

		placeObjectAtPlayerLocs(farGoldID, false, numFarGold);
	}

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(farAvoidImpassableLand);
	storeObjectConstraint(farAvoidGold);

	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Medium hunt 1.
	int mediumHunt1ID = createObjectDefVerify("medium hunt 1");
	addObjectDefItemVerify(mediumHunt1ID, "Gazelle", rmRandInt(1, 2), 2.0);
	addObjectDefItemVerify(mediumHunt1ID, "Giraffe", rmRandInt(2, 3), 2.0);
	setObjectDefDistance(mediumHunt1ID, 65.0, 85.0);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidAll);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidEdge);
	rmAddObjectDefConstraint(mediumHunt1ID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHunt1ID, shortAvoidForest);
	rmAddObjectDefConstraint(mediumHunt1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(mediumHunt1ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidHuntable);

	placeObjectAtPlayerLocs(mediumHunt1ID);

	// Medium hunt 2.
	int mediumHunt2ID = createObjectDefVerify("medium hunt 2");
	if(randChance()) {
		addObjectDefItemVerify(mediumHunt2ID, "Gazelle", rmRandInt(7, 9), 4.0);
		addObjectDefItemVerify(mediumHunt2ID, "Giraffe", rmRandInt(0, 1), 4.0);
	} else {
		addObjectDefItemVerify(mediumHunt2ID, "Giraffe", rmRandInt(3, 4), 2.0);
	}
	setObjectDefDistance(mediumHunt2ID, 75.0, 95.0);
	rmAddObjectDefConstraint(mediumHunt2ID, avoidAll);
	rmAddObjectDefConstraint(mediumHunt2ID, avoidEdge);
	rmAddObjectDefConstraint(mediumHunt2ID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHunt2ID, shortAvoidForest);
	rmAddObjectDefConstraint(mediumHunt2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(mediumHunt2ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(mediumHunt2ID, avoidHuntable);

	placeObjectAtPlayerLocs(mediumHunt2ID);

	// Other food.
	// Starting hunt.
	placeObjectAtPlayerLocs(startingHuntID);

	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

	// Far monkeys.
	placeObjectInPlayerSplits(farMonkeysID);

	// Far cranes.
	placeObjectInPlayerSplits(farCranesID);

	// Far berries.
	placeObjectInPlayerSplits(farBerriesID);

	progress(0.7);

	// Player forest.
	int numPlayerForests = 3;

	for(i = 1; < cPlayers) {
		int playerForestAreaID = rmCreateArea("player forest area " + i);
		rmSetAreaSize(playerForestAreaID, rmAreaTilesToFraction(2200));
		rmSetAreaLocPlayer(playerForestAreaID, getPlayer(i));
		rmSetAreaCoherence(playerForestAreaID, 1.0);
		rmSetAreaWarnFailure(playerForestAreaID, false);
		rmBuildArea(playerForestAreaID);

		for(j = 0; < numPlayerForests) {
			int playerForestID = rmCreateArea("player forest " + i + " " + j, playerForestAreaID);
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(100));
			rmSetAreaForestType(playerForestID, "Palm Forest");
			rmSetAreaMinBlobs(playerForestID, 1);
			rmSetAreaMaxBlobs(playerForestID, 4);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 32.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, farAvoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, shortAvoidImpassableLand);
			rmSetAreaWarnFailure(playerForestID, false);
			rmBuildArea(playerForestID);
		}
	}

	// Other forest.
	int numRegularForests = 12 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(100));
		rmSetAreaForestType(forestID, "Palm Forest");
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 4);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 32.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, farAvoidForest);
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
	placeObjectInTeamSplits(farPredatorsID);

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID);

	// Far herdables.
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

	// Player fish.
	int playerFishSize = 3;

	int playerFishLandMin = createTerrainDistConstraint("Land", true, 10.0);
	int playerFishLandMax = createTerrainMaxDistConstraint("Land", true, 16.0);

	if(cNonGaiaPlayers > 2) {
		playerFishLandMin = createTerrainDistConstraint("Land", true, 12.0);
	}

	// Place first one dead ahead so that the other 2 fit in better.
	float axisFishDist = 60.0;
	float axisDistIncr = 1.0;

	for(i = 1; < cPlayers) {
		int axisFishID = rmCreateObjectDef("player axis fish " + i);
		rmAddObjectDefItem(axisFishID, "Fish - Mahi", playerFishSize, 6.0);
		rmAddObjectDefConstraint(axisFishID, playerFishLandMin);
		rmAddObjectDefConstraint(axisFishID, playerFishLandMax);

		for(k = 0; < 1000) {
			float fishRadius = rmXMetersToFraction(axisFishDist + axisDistIncr * k);
			float fishAngle = PI;

			float x = getXFromPolarForPlayer(i, fishRadius, fishAngle);
			float z = getZFromPolarForPlayer(i, fishRadius, fishAngle);

			if(placeObjectForPlayer(axisFishID, 0, x, z)) {
				printDebug("axisFish: i = " + i + ", k = " + k, cDebugTest);
				break;
			}
		}
	}

	// Normal fish.
	int centerFishSize = rmRandInt(2, 3);

	int avoidPlayerFish = createTypeDistConstraint("Fish", 12.0);

	if(cNonGaiaPlayers > 2) {
		avoidPlayerFish = createTypeDistConstraint("Fish", 16.0);
	}

	// Inside out placement.
	setSimLocPlayerOrder(1);
	int p = -1;

	for(i = 1; < cPlayers) {
		p = getSimLocPlayer(1, i);

		int centerFishID = rmCreateObjectDef("center fish " + p);
		rmAddObjectDefItem(centerFishID, "Fish - Mahi", centerFishSize, 6.0);
		setObjectDefDistanceToMax(centerFishID);
		rmAddObjectDefConstraint(centerFishID, playerFishLandMin);
		rmAddObjectDefConstraint(centerFishID, avoidPlayerFish);
		if(cNonGaiaPlayers < 3) {
			rmAddObjectDefConstraint(centerFishID, avoidCenterline);
		}
		rmAddObjectDefConstraint(centerFishID, createAreaConstraint(rmAreaID(cTeamSplitName + " " + rmGetPlayerTeam(getPlayer(p)))));
		rmPlaceObjectDefAtLoc(centerFishID, 0, 0.5, 0.5, 2);
	}

	// Bonus fish.
	if(cNonGaiaPlayers > 2) {
		int bonusFishSize = rmRandInt(1, 2);

		int bonusFishID = rmCreateObjectDef("bonus fish");
		rmAddObjectDefItem(bonusFishID, "Fish - Perch", bonusFishSize, 6.0);
		setObjectDefDistanceToMax(bonusFishID);
		rmAddObjectDefConstraint(bonusFishID, playerFishLandMin);
		rmAddObjectDefConstraint(bonusFishID, avoidPlayerFish);
		rmPlaceObjectDefAtLoc(bonusFishID, 0, 0.5, 0.5, cNonGaiaPlayers);
	}

	progress(0.9);

	// Lone hunt.
	int loneHuntID = rmCreateObjectDef("lone hunt");
	rmAddObjectDefItem(loneHuntID, "Zebra", 1, 0.0);
	setObjectDefDistanceToMax(loneHuntID);
	rmAddObjectDefConstraint(loneHuntID, avoidAll);
	rmAddObjectDefConstraint(loneHuntID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(loneHuntID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(loneHuntID, shortAvoidSettlement);
	rmAddObjectDefConstraint(loneHuntID, avoidFood);
	rmPlaceObjectDefAtLoc(loneHuntID, 0, 0.5, 0.5, cNonGaiaPlayers);

	// Bushes.
	int bush1ID = rmCreateObjectDef("bush 1");
	rmAddObjectDefItem(bush1ID, "Bush", 1, 0.0);
	setObjectDefDistanceToMax(bush1ID);
	rmAddObjectDefConstraint(bush1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush1ID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush1ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	int bush2ID = rmCreateObjectDef("bush 2");
	rmAddObjectDefItem(bush2ID, "Bush", 2, 4.0);
	setObjectDefDistanceToMax(bush2ID);
	rmAddObjectDefConstraint(bush2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush2ID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 8 * cNonGaiaPlayers);

	// Rocks.
	int rockGroupID = rmCreateObjectDef("rock group");
	rmAddObjectDefItem(rockGroupID, "Rock Sandstone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rockGroupID);
	rmAddObjectDefConstraint(rockGroupID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockGroupID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(rockGroupID, 0, 0.5, 0.5, 15 * cNonGaiaPlayers);

	int rockID = rmCreateObjectDef("rock");
	rmAddObjectDefItem(rockID, "Rock Sandstone Small", 1, 0.0);
	setObjectDefDistanceToMax(rockID);
	rmAddObjectDefConstraint(rockID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(rockID, avoidAll);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 12 * cNonGaiaPlayers);

	// Papyrus.
	int shoreMin = createTerrainDistConstraint("Land", true, 7.0);
	int shoreMax = createTerrainMaxDistConstraint("Land", true, 10.0);

	int papyrus1ID = rmCreateObjectDef("papyrus 1");
	rmAddObjectDefItem(papyrus1ID, "Papyrus", 1, 0.0);
	setObjectDefDistanceToMax(papyrus1ID);
	rmAddObjectDefConstraint(papyrus1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(papyrus1ID, shoreMin);
	rmAddObjectDefConstraint(papyrus1ID, shoreMax);
	rmPlaceObjectDefAtLoc(papyrus1ID, 0, 0.5, 0.5, 4 * cNonGaiaPlayers);

	int papyrus2ID = rmCreateObjectDef("papyrus 2");
	rmAddObjectDefItem(papyrus2ID, "Papyrus", 2, 4.0);
	setObjectDefDistanceToMax(papyrus2ID);
	rmAddObjectDefConstraint(papyrus2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(papyrus2ID, shoreMin);
	rmAddObjectDefConstraint(papyrus2ID, shoreMax);
	rmPlaceObjectDefAtLoc(papyrus2ID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	// Lillies.
	int lillyID = rmCreateObjectDef("lilly");
	rmAddObjectDefItem(lillyID, "Water Lilly", rmRandInt(1, 2), 4.0);
	setObjectDefDistanceToMax(lillyID);
	rmAddObjectDefConstraint(lillyID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(lillyID, shoreMin);
	rmPlaceObjectDefAtLoc(lillyID, 0, 0.5, 0.5, 6 * cNonGaiaPlayers);

	// River bush.
	int riverBushID = rmCreateObjectDef("river bush");
	rmAddObjectDefItem(riverBushID, "Grass", rmRandInt(3, 7), 4.0);
	rmAddObjectDefItem(riverBushID, "Bush", rmRandInt(2, 5), 4.0);
	setObjectDefDistanceToMax(riverBushID);
	rmAddObjectDefConstraint(riverBushID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(riverBushID, createTerrainDistConstraint("Land", false, 2.0));
	rmAddObjectDefConstraint(riverBushID, createTerrainMaxDistConstraint("Land", false, 12.0));
	rmPlaceObjectDefAtLoc(riverBushID, 0, 0.5, 0.5, 12 * cNonGaiaPlayers);

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
