/*
** OASIS
** RebelsRising
** Last edit: 17/04/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Oasis");

	// Set size.
	int axisLength = getStandardMapDimInMeters();

	// Initialize map.
	initializeMap("SandC", axisLength);

	// Player placement.
	placePlayersInSquare(0.4);

	// Control areas.
	int classCenter = initializeCenter();
	int classCorner = initializeCorners();
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
	int classSettlementArea = rmDefineClass("settlement area");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classOasis = rmDefineClass("oasis");
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
	int avoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);
	int shortAvoidOasis = createClassDistConstraint(classOasis, 8.0);
	int mediumAvoidOasis = createClassDistConstraint(classOasis, 12.0);
	int farAvoidOasis = createClassDistConstraint(classOasis, 20.0);

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
	int avoidRelic = createTypeDistConstraint("Relic", 70.0);

	// Buildings.
	int avoidBuildings = createTypeDistConstraint("Building", 25.0);
	int avoidTowerLOS = createTypeDistConstraint("Tower", 35.0);
	int avoidTower = createTypeDistConstraint("Tower", 25.0); // May have to go lower than the usual 25.0 because the forest can cut off a lot of space.

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
	rmAddObjectDefConstraint(startingTowerID, avoidAll);
	rmAddObjectDefConstraint(startingTowerID, avoidTower);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	if(randChance()) {
		addObjectDefItemVerify(startingFoodID, "Chicken", rmRandInt(5, 8), 2.0);
	} else {
		addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(6, 8), 2.0);
	}
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidOasis);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Goat", 2, 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, shortAvoidOasis);
	rmAddObjectDefConstraint(startingHerdablesID, avoidImpassableLand);

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
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidOasis);
	rmAddObjectDefConstraint(farMonkeysID, createClassDistConstraint(classStartingSettlement, 90.0));
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidGold);
	rmAddObjectDefConstraint(farMonkeysID, avoidHuntable);

	// Berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", rmRandInt(4, 10), 4.0);
	setObjectDefDistance(farBerriesID, 70.0, 90.0);
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidEdge);
	rmAddObjectDefConstraint(farBerriesID, avoidCenter);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidOasis);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Goat", rmRandInt(0, 3), 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, shortAvoidOasis);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Goat", 2, 4.0);
	setObjectDefDistance(farHerdablesID, 80.0, 120.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, shortAvoidOasis);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	if(randChance()) {
		addObjectDefItemVerify(farPredatorsID, "Lion", rmRandInt(1, 2), 4.0);
	} else {
		addObjectDefItemVerify(farPredatorsID, "Hyena", 2, 4.0);
	}
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, shortAvoidOasis);
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
	rmAddObjectDefConstraint(relicID, shortAvoidOasis);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random trees.
	int randomTree1ID = rmCreateObjectDef("random tree 1");
	rmAddObjectDefItem(randomTree1ID, "Palm", 1, 0.0);
	setObjectDefDistanceToMax(randomTree1ID);
	rmAddObjectDefConstraint(randomTree1ID, avoidAll);
	rmAddObjectDefConstraint(randomTree1ID, shortAvoidOasis);
	rmAddObjectDefConstraint(randomTree1ID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTree1ID, treeAvoidSettlement);

	int randomTree2ID = rmCreateObjectDef("random tree 2");
	rmAddObjectDefItem(randomTree2ID, "Savannah Tree", 1, 0.0);
	setObjectDefDistanceToMax(randomTree2ID);
	rmAddObjectDefConstraint(randomTree2ID, avoidAll);
	rmAddObjectDefConstraint(randomTree2ID, shortAvoidOasis);
	rmAddObjectDefConstraint(randomTree2ID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTree2ID, treeAvoidSettlement);

	progress(0.1);

	// Create oasis.
	int oasisForestID = 0;
	int oasisLakeID = 0;
	float oasisChance = rmRandFloat(0.0, 1.0);

	if(oasisChance < 0.25) {
		// Create oasis forest 1.
		oasisForestID = rmCreateArea("oasis forest 1");
		rmSetAreaSize(oasisForestID, 0.15);
		rmSetAreaLocation(oasisForestID, 0.5, 0.5);
		rmSetAreaForestType(oasisForestID, "Palm Forest");
		rmSetAreaCoherence(oasisForestID, 0.25);
		rmSetAreaSmoothDistance(oasisForestID, 50);
		rmAddAreaToClass(oasisForestID, classOasis);
		rmAddAreaToClass(oasisForestID, classForest);
		rmSetAreaWarnFailure(oasisForestID, false);
		rmBuildArea(oasisForestID);

		// Create oasis lake 1.
		oasisLakeID = rmCreateArea("oasis lake 1");
		rmSetAreaSize(oasisLakeID, 0.06);
		rmSetAreaLocation(oasisLakeID, 0.5, 0.5);
		rmSetAreaWaterType(oasisLakeID, "Egyptian Nile");
		rmSetAreaCoherence(oasisLakeID, 0.25);
		rmSetAreaSmoothDistance(oasisLakeID, 50);
		rmAddAreaToClass(oasisLakeID, classOasis);
		rmSetAreaWarnFailure(oasisLakeID, false);
		rmBuildArea(oasisLakeID);
	} else if(oasisChance < 0.5) {
		// Create oasis forest 1.
		oasisForestID = rmCreateArea("oasis forest 1");
		rmSetAreaSize(oasisForestID, 0.075);
		rmSetAreaLocation(oasisForestID, 0.35, 0.65);
		rmSetAreaForestType(oasisForestID, "Palm Forest");
		rmSetAreaCoherence(oasisForestID, 0.25);
		rmSetAreaSmoothDistance(oasisForestID, 50);
		rmAddAreaToClass(oasisForestID, classOasis);
		rmAddAreaToClass(oasisForestID, classForest);
		rmSetAreaWarnFailure(oasisForestID, false);
		rmBuildArea(oasisForestID);

		// Create oasis forest 2.
		oasisForestID = rmCreateArea("oasis forest 2");
		rmSetAreaSize(oasisForestID, 0.075);
		rmSetAreaLocation(oasisForestID, 0.65, 0.35);
		rmSetAreaForestType(oasisForestID, "Palm Forest");
		rmSetAreaCoherence(oasisForestID, 0.25);
		rmSetAreaSmoothDistance(oasisForestID, 50);
		rmAddAreaToClass(oasisForestID, classOasis);
		rmAddAreaToClass(oasisForestID, classForest);
		rmSetAreaWarnFailure(oasisForestID, false);
		rmBuildArea(oasisForestID);

		// Create oasis lake 1.
		oasisLakeID = rmCreateArea("oasis lake 1");
		rmSetAreaSize(oasisLakeID, 0.03);
		rmSetAreaLocation(oasisLakeID, 0.35, 0.65);
		rmSetAreaWaterType(oasisLakeID, "Egyptian Nile");
		rmSetAreaCoherence(oasisLakeID, 0.25);
		rmSetAreaSmoothDistance(oasisLakeID, 50);
		rmAddAreaToClass(oasisLakeID, classOasis);
		rmSetAreaWarnFailure(oasisLakeID, false);
		rmBuildArea(oasisLakeID);

		// Create oasis lake 2.
		oasisLakeID = rmCreateArea("oasis lake 2");
		rmSetAreaSize(oasisLakeID, 0.03);
		rmSetAreaLocation(oasisLakeID, 0.65, 0.35);
		rmSetAreaWaterType(oasisLakeID, "Egyptian Nile");
		rmSetAreaCoherence(oasisLakeID, 0.25);
		rmSetAreaSmoothDistance(oasisLakeID, 50);
		rmAddAreaToClass(oasisLakeID, classOasis);
		rmSetAreaWarnFailure(oasisLakeID, false);
		rmBuildArea(oasisLakeID);
	} else if(oasisChance < 0.75) {
		// Create oasis forest 1.
		oasisForestID = rmCreateArea("oasis forest 1");
		rmSetAreaSize(oasisForestID, 0.075);
		rmSetAreaLocation(oasisForestID, 0.35, 0.35);
		rmSetAreaForestType(oasisForestID, "Palm Forest");
		rmSetAreaCoherence(oasisForestID, 0.25);
		rmSetAreaSmoothDistance(oasisForestID, 50);
		rmAddAreaToClass(oasisForestID, classOasis);
		rmAddAreaToClass(oasisForestID, classForest);
		rmSetAreaWarnFailure(oasisForestID, false);
		rmBuildArea(oasisForestID);

		// Create oasis forest 2.
		oasisForestID = rmCreateArea("oasis forest 2");
		rmSetAreaSize(oasisForestID, 0.075);
		rmSetAreaLocation(oasisForestID, 0.65, 0.65);
		rmSetAreaForestType(oasisForestID, "Palm Forest");
		rmSetAreaCoherence(oasisForestID, 0.25);
		rmSetAreaSmoothDistance(oasisForestID, 50);
		rmAddAreaToClass(oasisForestID, classOasis);
		rmAddAreaToClass(oasisForestID, classForest);
		rmSetAreaWarnFailure(oasisForestID, false);
		rmBuildArea(oasisForestID);

		// Create oasis lake 1.
		oasisLakeID = rmCreateArea("oasis lake 1");
		rmSetAreaSize(oasisLakeID, 0.03);
		rmSetAreaLocation(oasisLakeID, 0.35, 0.35);
		rmSetAreaWaterType(oasisLakeID, "Egyptian Nile");
		rmSetAreaCoherence(oasisLakeID, 0.25);
		rmSetAreaSmoothDistance(oasisLakeID, 50);
		rmAddAreaToClass(oasisLakeID, classOasis);
		rmSetAreaWarnFailure(oasisLakeID, false);
		rmBuildArea(oasisLakeID);

		// Create oasis lake 2.
		oasisLakeID = rmCreateArea("oasis lake 2");
		rmSetAreaSize(oasisLakeID, 0.03);
		rmSetAreaLocation(oasisLakeID, 0.65, 0.65);
		rmSetAreaWaterType(oasisLakeID, "Egyptian Nile");
		rmSetAreaCoherence(oasisLakeID, 0.25);
		rmSetAreaSmoothDistance(oasisLakeID, 50);
		rmAddAreaToClass(oasisLakeID, classOasis);
		rmSetAreaWarnFailure(oasisLakeID, false);
		rmBuildArea(oasisLakeID);
	} else {
		// Create oasis forest 1.
		oasisForestID = rmCreateArea("oasis forest 1");
		rmSetAreaSize(oasisForestID, 0.04);
		rmSetAreaLocation(oasisForestID, 0.5, 0.3);
		rmSetAreaForestType(oasisForestID, "Palm Forest");
		rmSetAreaCoherence(oasisForestID, 0.25);
		rmSetAreaSmoothDistance(oasisForestID, 50);
		rmAddAreaToClass(oasisForestID, classOasis);
		rmAddAreaToClass(oasisForestID, classForest);
		rmSetAreaWarnFailure(oasisForestID, false);
		rmBuildArea(oasisForestID);

		// Create oasis forest 2.
		oasisForestID = rmCreateArea("oasis forest 2");
		rmSetAreaSize(oasisForestID, 0.04);
		rmSetAreaLocation(oasisForestID, 0.5, 0.7);
		rmSetAreaForestType(oasisForestID, "Palm Forest");
		rmSetAreaCoherence(oasisForestID, 0.25);
		rmSetAreaSmoothDistance(oasisForestID, 50);
		rmAddAreaToClass(oasisForestID, classOasis);
		rmAddAreaToClass(oasisForestID, classForest);
		rmSetAreaWarnFailure(oasisForestID, false);
		rmBuildArea(oasisForestID);

		// Create oasis forest 3.
		oasisForestID = rmCreateArea("oasis forest 3");
		rmSetAreaSize(oasisForestID, 0.04);
		rmSetAreaLocation(oasisForestID, 0.3, 0.5);
		rmSetAreaForestType(oasisForestID, "Palm Forest");
		rmSetAreaCoherence(oasisForestID, 0.25);
		rmSetAreaSmoothDistance(oasisForestID, 50);
		rmAddAreaToClass(oasisForestID, classOasis);
		rmAddAreaToClass(oasisForestID, classForest);
		rmSetAreaWarnFailure(oasisForestID, false);
		rmBuildArea(oasisForestID);

		// Create oasis forest 4.
		oasisForestID = rmCreateArea("oasis forest 4");
		rmSetAreaSize(oasisForestID, 0.04);
		rmSetAreaLocation(oasisForestID, 0.7, 0.5);
		rmSetAreaForestType(oasisForestID, "Palm Forest");
		rmSetAreaCoherence(oasisForestID, 0.25);
		rmSetAreaSmoothDistance(oasisForestID, 50);
		rmAddAreaToClass(oasisForestID, classOasis);
		rmAddAreaToClass(oasisForestID, classForest);
		rmSetAreaWarnFailure(oasisForestID, false);
		rmBuildArea(oasisForestID);

		if(cNonGaiaPlayers > 4) {
			// Create oasis lake 1.
			oasisLakeID = rmCreateArea("oasis lake 1");
			rmSetAreaSize(oasisLakeID, 0.015);
			rmSetAreaLocation(oasisLakeID, 0.5, 0.3);
			rmSetAreaWaterType(oasisLakeID, "Egyptian Nile");
			rmSetAreaCoherence(oasisLakeID, 0.25);
			rmSetAreaSmoothDistance(oasisLakeID, 50);
			rmAddAreaToClass(oasisLakeID, classOasis);
			rmSetAreaWarnFailure(oasisLakeID, false);
			rmBuildArea(oasisLakeID);

			// Create oasis lake 2.
			oasisLakeID = rmCreateArea("oasis lake 2");
			rmSetAreaSize(oasisLakeID, 0.015);
			rmSetAreaLocation(oasisLakeID, 0.5, 0.7);
			rmSetAreaWaterType(oasisLakeID, "Egyptian Nile");
			rmSetAreaCoherence(oasisLakeID, 0.25);
			rmSetAreaSmoothDistance(oasisLakeID, 50);
			rmAddAreaToClass(oasisLakeID, classOasis);
			rmSetAreaWarnFailure(oasisLakeID, false);
			rmBuildArea(oasisLakeID);

			// Create oasis lake 3.
			oasisLakeID = rmCreateArea("oasis lake 3");
			rmSetAreaSize(oasisLakeID, 0.015);
			rmSetAreaLocation(oasisLakeID, 0.3, 0.5);
			rmSetAreaWaterType(oasisLakeID, "Egyptian Nile");
			rmSetAreaCoherence(oasisLakeID, 0.25);
			rmSetAreaSmoothDistance(oasisLakeID, 50);
			rmAddAreaToClass(oasisLakeID, classOasis);
			rmSetAreaWarnFailure(oasisLakeID, false);
			rmBuildArea(oasisLakeID);

			// Create oasis lake 4.
			oasisLakeID = rmCreateArea("oasis lake 4");
			rmSetAreaSize(oasisLakeID, 0.015);
			rmSetAreaLocation(oasisLakeID, 0.7, 0.5);
			rmSetAreaWaterType(oasisLakeID, "Egyptian Nile");
			rmSetAreaCoherence(oasisLakeID, 0.25);
			rmSetAreaSmoothDistance(oasisLakeID, 50);
			rmAddAreaToClass(oasisLakeID, classOasis);
			rmSetAreaWarnFailure(oasisLakeID, false);
			rmBuildArea(oasisLakeID);
		}
	}

	// Set up player areas.
	float playerAreaSize = rmAreaTilesToFraction(2000);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, 0.9 * playerAreaSize, 1.1 * playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "SandDirt50");
		rmAddAreaTerrainLayer(playerAreaID, "SandA", 1, 2);
		rmAddAreaTerrainLayer(playerAreaID, "SandB", 0, 1);
		rmSetAreaMinBlobs(playerAreaID, 1);
		rmSetAreaMaxBlobs(playerAreaID, 5);
		rmSetAreaMinBlobDistance(playerAreaID, 16.0);
		rmSetAreaMaxBlobDistance(playerAreaID, 40.0);
		rmAddAreaConstraint(playerAreaID, mediumAvoidOasis);
		rmSetAreaWarnFailure(playerAreaID, false);
	}

	rmBuildAllAreas();

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 5 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
		rmSetAreaTerrainType(beautificationID, "SandD");
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidOasis);
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
	addFairLocConstraint(farAvoidOasis);
		addFairLocConstraint(avoidTowerLOS);

	if(cNonGaiaPlayers < 3) {
		addFairLocConstraint(avoidCorner);
	}

	enableFairLocTwoPlayerCheck();

	addFairLoc(65.0, 80.0, false, true, 70.0, 12.0, 12.0);

	// Far settlement.
	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(mediumAvoidOasis);

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		addFairLoc(85.0, 110.0, true, false, 80.0, 12.0, 12.0);
	} else if(cNonGaiaPlayers < 5) {
		addFairLoc(77.5, 100.0, true, false, 70.0, 12.0, 12.0, false, gameHasTwoEqualTeams());
	} else {
		addFairLoc(70.0, 90.0, true, false, 70.0, 12.0, 12.0, false, gameHasTwoEqualTeams());
	}

	placeObjectAtNewFairLocs(settlementID, false, "settlements");

	progress(0.4);

	// Elevation.
	int elevationID = 0;

	for(i = 0; < 10 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 1 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(200));
		if(randChance()) {
			rmSetAreaTerrainType(elevationID, "SandD");
		}
		rmSetAreaBaseHeight(elevationID, rmRandFloat(4.0, 5.0));
		rmSetAreaHeightBlend(elevationID, 2);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 5);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 40.0);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmAddAreaConstraint(elevationID, shortAvoidOasis);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	for(i = 0; < 20 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 2 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(80));
		if(randChance()) {
			rmSetAreaTerrainType(elevationID, "SandD");
		}
		rmSetAreaBaseHeight(elevationID, rmRandFloat(2.0, 4.0));
		rmSetAreaHeightBlend(elevationID, 1);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 3);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 20.0);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmAddAreaConstraint(elevationID, shortAvoidOasis);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	progress(0.5);

	// Gold.
	int mediumGoldID = createObjectDefVerify("medium gold");
	addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);

	// First (medium).
	if(cNonGaiaPlayers < 3) {
		addSimLocConstraint(avoidCorner);
	}
	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(shortAvoidOasis);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(farAvoidSettlement);
	addSimLocConstraint(farAvoidGold);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));

	enableSimLocTwoPlayerCheck();

	addSimLoc(50.0, 60.0, avoidGoldDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold");

	// Bonus gold.
	int numBonusGold = 3;

	// Far gold for 1v1.
	if(cNonGaiaPlayers < 3) {
		int farGoldID = createObjectDefVerify("far gold");
		addObjectDefItemVerify(farGoldID, "Gold Mine", 1, 0.0);
		// Place 1 "fair" far mine in 1v1, randomize the other 2.
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(shortAvoidOasis);
		addSimLocConstraint(avoidCorner);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 80.0));
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(farAvoidGold);

		enableSimLocTwoPlayerCheck();

		addSimLoc(80.0, 100.0, avoidGoldDist, 8.0, 8.0, false, false, true);

		placeObjectAtNewSimLocs(farGoldID, false, "far gold");

		numBonusGold = numBonusGold - 1;
	}

	// Regular bonus gold (only verify for 1v1 because there is a lot of gold in teamgames).
	int bonusGoldID = createObjectDefVerify("bonus gold", cNonGaiaPlayers < 3 || cDebugMode >= cDebugFull);
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 80.0));
		rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
	} else {
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 60.0));
	}
	rmAddObjectDefConstraint(bonusGoldID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, shortAvoidOasis);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);

	placeObjectInPlayerSplits(bonusGoldID, false, numBonusGold);

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(avoidImpassableLand);
	storeObjectConstraint(shortAvoidOasis);
	storeObjectConstraint(farAvoidGold);

	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Close and far hunt.
	bool huntInStartingLOS = randChance(2.0 / 3.0);

	storeObjectDefItem("Zebra", rmRandInt(2, 5), 2.0);

	// Place outside of starting LOS if randomized, fall back to starting LOS if placement fails.
	if(huntInStartingLOS == false) {
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(shortAvoidOasis);
		addSimLocConstraint(avoidImpassableLand);
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
		storeObjectConstraint(shortAvoidOasis);
		storeObjectConstraint(avoidImpassableLand);
		storeObjectConstraint(shortAvoidGold);

		placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.
	}

	resetObjectStorage();

	// Far hunt.
	int farHuntID = createObjectDefVerify("far hunt");
	if(randChance()) {
		addObjectDefItemVerify(farHuntID, "Giraffe", rmRandInt(2, 3), 2.0);
		addObjectDefItemVerify(farHuntID, "Gazelle", rmRandInt(0, 4), 2.0);
	} else {
		addObjectDefItemVerify(farHuntID, "Giraffe", rmRandInt(2, 5), 2.0);
	}

	float farHuntMinDist = rmRandFloat(65.0, 95.0);
	float farHuntMaxDist = farHuntMinDist + 5.0;

	if(cNonGaiaPlayers < 3) {
		farHuntMinDist = 65.0;
		farHuntMaxDist = 100.0;
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidCenter);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
	addSimLocConstraint(mediumAvoidSettlement);
	addSimLocConstraint(shortAvoidOasis);
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(shortAvoidGold);

	enableSimLocTwoPlayerCheck();

	addSimLoc(farHuntMinDist, farHuntMaxDist, avoidHuntDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(farHuntID, false, "far hunt");

	// Other food.
	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

	// Monkeys.
	placeObjectInPlayerSplits(farMonkeysID);

	// Berries.
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
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(100));
			rmSetAreaForestType(playerForestID, "Palm Forest");
			rmSetAreaCoherence(playerForestID, 0.2);
			rmSetAreaMinBlobs(playerForestID, 1);
			rmSetAreaMaxBlobs(playerForestID, 5);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 40.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, avoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, shortAvoidOasis);
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
		rmSetAreaSize(forestID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(100));
		rmSetAreaForestType(forestID, "Palm Forest");
		rmSetAreaCoherence(forestID, 0.2);
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 40.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, shortAvoidOasis);
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
	placeObjectAtPlayerLocs(mediumHerdablesID, false, 2);

	// Far herdables.
	placeObjectAtPlayerLocs(farHerdablesID, false, 3);

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectInPlayerSplits(relicID);

	// Random trees.
	placeObjectAtPlayerLocs(randomTree1ID, false, 7);
	placeObjectAtPlayerLocs(randomTree2ID, false, 3);

	progress(0.9);

	// Embellishment.
	// Rocks.
	int rockID = rmCreateObjectDef("rocks");
	rmAddObjectDefItem(rockID, "Rock Sandstone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rockID);
	rmAddObjectDefConstraint(rockID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockID, shortAvoidOasis);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 30 * cNonGaiaPlayers);

	// Bushes.
	int bush1ID = rmCreateObjectDef("bush 1");
	rmAddObjectDefItem(bush1ID, "Bush", 4, 3.0);
	setObjectDefDistanceToMax(bush1ID);
	rmAddObjectDefConstraint(bush1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush1ID, shortAvoidOasis);
	rmPlaceObjectDefAtLoc(bush1ID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	int bush2ID = rmCreateObjectDef("bush 2");
	rmAddObjectDefItem(bush2ID, "Bush", 3, 2.0);
	rmAddObjectDefItem(bush2ID, "Rock Sandstone Sprite", 1, 2.0);
	setObjectDefDistanceToMax(bush2ID);
	rmAddObjectDefConstraint(bush2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush2ID, shortAvoidOasis);
	rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	// Grass.
	int grassID = rmCreateObjectDef("grass");
	rmAddObjectDefItem(grassID, "Grass", 1, 0.0);
	setObjectDefDistanceToMax(grassID);
	rmAddObjectDefConstraint(grassID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(grassID, shortAvoidOasis);
	rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 30 * cNonGaiaPlayers);

	// Drifts.
	int driftID = rmCreateObjectDef("drift");
	rmAddObjectDefItem(driftID, "Sand Drift Patch", 1, 0.0);
	setObjectDefDistanceToMax(driftID);
	rmAddObjectDefConstraint(driftID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(driftID, avoidEdge);
	rmAddObjectDefConstraint(driftID, shortAvoidOasis);
	rmAddObjectDefConstraint(driftID, avoidBuildings);
	rmAddObjectDefConstraint(driftID, createTypeDistConstraint("Sand Drift Patch", 25.0));
	rmPlaceObjectDefAtLoc(driftID, 0, 0.5, 0.5, 4 * cNonGaiaPlayers);

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
