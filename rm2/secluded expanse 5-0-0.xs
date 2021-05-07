/*
** SECLUDED EXPANSE
** RebelsRising
** Last edit: 17/04/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Secluded Expanse");

	// Set size.
	int mapSize = getStandardMapDimInMeters();

	// Initialize map.
	initializeMap("SandDirt50b", mapSize);

	// Player placement.
	placePlayersInCircle(0.35, 0.375, 0.875);

	// Control areas.
	int classCenter = initializeCenter();
	int classCorner = initializeCorners(50.0);
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
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
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 17.5);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 22.5);

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
	int avoidForest = createClassDistConstraint(classForest, 25.0);
	int forestAvoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 20.0);
	int treeAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 13.0);

	// Relics.
	int avoidRelic = createTypeDistConstraint("Relic", 80.0);

	// Buildings.
	int avoidBuildings = createTypeDistConstraint("Building", 25.0);
	int avoidTowerLOS = createTypeDistConstraint("Tower", 35.0);
	int avoidTower = createTypeDistConstraint("Tower", 25.0);

	// Embellishment.
	int embellishmentAvoidAll = createTypeDistConstraint("All", 3.0);

	// Define simple objects.
	// Starting settlement.
	int startingSettlementID = createObjectDefVerify("starting settlement");
	addObjectDefItemVerify(startingSettlementID, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass(startingSettlementID, classStartingSettlement);

	// Towers.
	int startingTowerID = createObjectDefVerify("starting tower");
	addObjectDefItemVerify(startingTowerID, "Tower", 1, 0.0);
	setObjectDefDistance(startingTowerID, 23.0, 27.0);
	rmAddObjectDefConstraint(startingTowerID, avoidTower);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	if(randChance()) {
		addObjectDefItemVerify(startingFoodID, "Chicken", rmRandInt(5, 8), 2.0);
	} else {
		addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(5, 8), 2.0);
	}
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Goat", 2, 2.0);
	setObjectDefDistance(startingHerdablesID, 25.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);

	// Straggler trees.
	int stragglerTreeID = createObjectDefVerify("straggler tree");
	addObjectDefItemVerify(stragglerTreeID, "Palm", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0);
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Far monkeys.
	int farMonkeysID = createObjectDefVerify("far monkeys");
	if(randChance()) {
		addObjectDefItemVerify(farMonkeysID, "Monkey", rmRandInt(5, 8), 2.0);
	} else {
		addObjectDefItemVerify(farMonkeysID, "Baboon", rmRandInt(5, 8), 2.0);
	}
	rmAddObjectDefConstraint(farMonkeysID, avoidAll);
	rmAddObjectDefConstraint(farMonkeysID, avoidEdge);
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farMonkeysID, createClassDistConstraint(classStartingSettlement, 90.0));
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidGold);
	rmAddObjectDefConstraint(farMonkeysID, avoidFood);
	rmAddObjectDefConstraint(farMonkeysID, avoidHuntable);

	// Far berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", rmRandInt(5, 10), 4.0);

	float farBerryMinDist = rmRandFloat(70.0, 90.0);
	float farBerryMaxDist =  farBerryMinDist + 10.0;

	setObjectDefDistance(farBerriesID, farBerryMinDist, farBerryMaxDist);
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidEdge);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farBerriesID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Goat", 2, 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables 1.
	int farHerdables1ID = createObjectDefVerify("far herdables 1");
	addObjectDefItemVerify(farHerdables1ID, "Goat", 2, 4.0);
	setObjectDefDistance(farHerdables1ID, 70.0, 110.0);
	rmAddObjectDefConstraint(farHerdables1ID, avoidAll);
	rmAddObjectDefConstraint(farHerdables1ID, avoidEdge);
	rmAddObjectDefConstraint(farHerdables1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdables1ID, avoidHerdable);

	// Far herdables 2.
	int farHerdables2ID = createObjectDefVerify("far herdables 2");
	addObjectDefItemVerify(farHerdables2ID, "Goat", rmRandInt(1, 3), 4.0);
	setObjectDefDistance(farHerdables2ID, 70.0, 110.0);
	rmAddObjectDefConstraint(farHerdables2ID, avoidAll);
	rmAddObjectDefConstraint(farHerdables2ID, avoidEdge);
	rmAddObjectDefConstraint(farHerdables2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdables2ID, avoidHerdable);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	addObjectDefItemVerify(farPredatorsID, "Lion", 2, 4.0);
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredatorsID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredatorsID, avoidPredator);

	// Other objects.
	// Relics.
	int relicID = createObjectDefVerify("relic");
	addObjectDefItemVerify(relicID, "Relic", 1, 0.0);
	rmAddObjectDefConstraint(relicID, avoidAll);
	rmAddObjectDefConstraint(relicID, avoidEdge);
	rmAddObjectDefConstraint(relicID, avoidCorner);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random trees.
	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "Palm", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Set up player area.
	float playerAreaSize = rmAreaTilesToFraction(1500);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + getPlayer(i));
		rmSetAreaSize(playerAreaID, 0.9 * playerAreaSize, 1.1 * playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "GrassA");
		rmAddAreaTerrainLayer(playerAreaID, "GrassDirt50", 0, 3);
		rmAddAreaTerrainLayer(playerAreaID, "GrassDirt25", 3, 6);
		rmSetAreaMinBlobs(playerAreaID, 1);
		rmSetAreaMaxBlobs(playerAreaID, 3);
		rmSetAreaMinBlobDistance(playerAreaID, 16.0);
		rmSetAreaMaxBlobDistance(playerAreaID, 40.0);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmAddAreaConstraint(playerAreaID, avoidPlayer);
		rmSetAreaWarnFailure(playerAreaID, false);
	}

	rmBuildAllAreas();

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 1; < 40 * cNonGaiaPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaTerrainType(beautificationID, "SandA");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(75), rmAreaTilesToFraction(150));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, avoidPlayer);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	progress(0.3);

	// Starting settlement.
	placeObjectAtPlayerLocs(startingSettlementID, true);

	// Towers.
	placeAndStoreObjectAtPlayerLocs(startingTowerID, true, 4, 23.0, 27.0, true);

	// Close settlement.
	int settlementID = rmCreateObjectDef("settlements");
	rmAddObjectDefItem(settlementID, "Settlement", 1, 0.0);

	if(cNonGaiaPlayers < 3) {
		addFairLocConstraint(avoidCorner);
	} else {
		addFairLocConstraint(avoidTowerLOS);
	}

	enableFairLocTwoPlayerCheck();

	addFairLoc(60.0, 80.0, false, true, 70.0, 12.0, 12.0);

	placeObjectAtNewFairLocs(settlementID);

	// Far settlement.
	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(createTypeDistConstraint("AbstractSettlement", 70.0));

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		addFairLoc(60.0, 90.0, true, true, 80.0, 12.0, 12.0);
	} else if(cNonGaiaPlayers < 9) {
		if(randChance()) {
			addFairLoc(70.0, 80.0, true, true, 75.0, 24.0, 24.0);
		} else {
			addFairLoc(70.0, 80.0, true, false, 75.0, 12.0, 12.0);
		}
	} else {
		addFairLoc(70.0, 120.0, true, false, 40.0, 12.0, 12.0);
	}

	placeObjectAtNewFairLocs(settlementID);

	progress(0.4);

	// Elevation.
	int elevationID = 0;

	for(i = 0; < 40 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(75));
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

	progress(0.5);

	// Gold.
	int goldID = createObjectDefVerify("gold");
	addObjectDefItemVerify(goldID, "Gold Mine", 1, 0.0);

	// Medium.
	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidCorner);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
	addSimLocConstraint(farAvoidGold);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(farAvoidSettlement);

	enableSimLocTwoPlayerCheck();
	addSimLoc(50.0, 65.0, avoidGoldDist, 8.0, 8.0, false, false, true);

	enableSimLocTwoPlayerCheck();
	addSimLocWithPrevConstraints(50.0, 65.0, avoidGoldDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(goldID, false, "medium gold");

	// Bonus gold (anywhere in team area).
	int bonusGoldID = createObjectDefVerify("bonus gold");
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(bonusGoldID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);

	placeObjectInTeamSplits(bonusGoldID, false, rmRandInt(2, 3));

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	// storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(farAvoidGold); // Since the constraint is so small, apply it also to starting gold.
	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Close and medium hunt.
	bool huntInStartingLOS = randChance(2.0 / 3.0);

	// Consider using randSmallInt() here to prefer smaller values.
	if(randChance()) {
		storeObjectDefItem("Zebra", rmRandInt(2, 5), 2.0);
	} else {
		storeObjectDefItem("Gazelle", rmRandInt(3, 6), 2.0);
	}

	// Place outside of starting LOS if randomized, fall back to starting LOS if placement fails.
	if(huntInStartingLOS == false) {
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(shortAvoidGold);

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
		storeObjectConstraint(shortAvoidGold);

		placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.
	}

	// Medium hunt.
	int mediumHuntID = createObjectDefVerify("medium hunt");
	if(randChance()) {
		addObjectDefItemVerify(mediumHuntID, "Gazelle", rmRandInt(4, 8), 2.0);
	} else {
		addObjectDefItemVerify(mediumHuntID, "Giraffe", rmRandInt(2, 4), 2.0);
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(shortAvoidGold);
	addSimLocConstraint(shortAvoidSettlement);

	enableSimLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		setSimLocInterval(10.0);
	}

	addSimLoc(60.0, 90.0, avoidHuntDist, 8.0, 8.0, false, gameHasTwoEqualTeams(), true);

	placeObjectAtNewSimLocs(mediumHuntID, false, "medium hunt");

	// Other food.
	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

	// Berries.
	placeObjectAtPlayerLocs(farBerriesID);

	// Monkeys.
	if(randChance()) {
		placeObjectInPlayerSplits(farMonkeysID);
	}

	progress(0.7);

	// Player forest.
	int numPlayerForests = 2;

	for(i = 1; < cPlayers) {
		int playerForestAreaID = rmCreateArea("player forest area " + getPlayer(i));
		rmSetAreaSize(playerForestAreaID, rmAreaTilesToFraction(2200));
		rmSetAreaLocPlayer(playerForestAreaID, getPlayer(i));
		rmSetAreaCoherence(playerForestAreaID, 1.0);
		rmSetAreaWarnFailure(playerForestAreaID, false);
		rmBuildArea(playerForestAreaID);

		for(j = 0; < numPlayerForests) {
			int playerForestID = rmCreateArea("player forest " + getPlayer(i) + " " + j, playerForestAreaID);
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(80));
			if(randChance()) {
				rmSetAreaForestType(playerForestID, "Mixed Palm Forest");
			} else {
				rmSetAreaForestType(playerForestID, "Palm Forest");
			}
			rmSetAreaMinBlobs(playerForestID, 1);
			rmSetAreaMaxBlobs(playerForestID, 3);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 20.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, avoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmSetAreaWarnFailure(playerForestID, false);
			rmBuildArea(playerForestID);
		}
	}

	// Other forest.
	int numRegularForests = 12 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(40), rmAreaTilesToFraction(90));
		if(randChance()) {
			rmSetAreaForestType(forestID, "Mixed Palm Forest");
		} else {
			rmSetAreaForestType(forestID, "Palm Forest");
		}
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 3);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 40.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
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
	placeObjectInTeamSplits(farPredatorsID, false, 2);

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID, false, 2);

	// Far herdables.
	placeObjectInPlayerSplits(farHerdables1ID, false, rmRandInt(1, 2));
	placeObjectInPlayerSplits(farHerdables2ID, false, 1);

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
	// Rocks.
	int rock1ID = rmCreateObjectDef("rock small");
	rmAddObjectDefItem(rock1ID, "Rock Sandstone Small", 1, 0.0);
	setObjectDefDistanceToMax(rock1ID);
	rmAddObjectDefConstraint(rock1ID, embellishmentAvoidAll);
	rmPlaceObjectDefAtLoc(rock1ID, 0, 0.5, 0.5, 20 * cNonGaiaPlayers);

	// Bushes.
	int bush1ID = rmCreateObjectDef("bush 1");
	rmAddObjectDefItem(bush1ID, "Bush", 4, 3.0);
	setObjectDefDistanceToMax(bush1ID);
	rmAddObjectDefConstraint(bush1ID, embellishmentAvoidAll);
	rmPlaceObjectDefAtLoc(bush1ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	int bush2ID = rmCreateObjectDef("bush 2");
	rmAddObjectDefItem(bush2ID, "Bush", 3, 2.0);
	rmAddObjectDefItem(bush2ID, "Rock Sandstone Sprite", 1, 2.0);
	setObjectDefDistanceToMax(bush2ID);
	rmAddObjectDefConstraint(bush2ID, embellishmentAvoidAll);
	rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	// Grass.
	int grassID = rmCreateObjectDef("grass");
	rmAddObjectDefItem(grassID, "Grass", 1, 0.0);
	setObjectDefDistanceToMax(grassID);
	rmAddObjectDefConstraint(grassID, embellishmentAvoidAll);
	rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 50 * cNonGaiaPlayers);

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
