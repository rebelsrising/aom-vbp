/*
** SAVANNAH
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Savannah");

	// Set size.
	int axisLength = getStandardMapDimInMeters();

	// Initialize map.
	initializeMap("SavannahA", axisLength);

	// Player placement.
	if(cNonGaiaPlayers < 5) {
		placePlayersInCircle(0.35, 0.4, 0.75);
	} else if(cNonGaiaPlayers < 9) {
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
	int classSettlementArea = rmDefineClass("settlement area");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classPond = rmDefineClass("pond");
	int classForest = rmDefineClass("forest");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 17.5);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 25.0);

	// Terrain.
	int avoidImpassableLand = createTerrainDistConstraint("Land", false, 5.0);

	// Gold.
	float avoidGoldDist = 50.0;

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
	if(randChance(0.8)) {
		addObjectDefItemVerify(startingFoodID, "Chicken", rmRandInt(6, 12), 4.0);
	} else {
		addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(4, 8), 2.0);
	}
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Goat", rmRandInt(1, 3), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, avoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Savannah Tree", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Far monkeys.
	int farMonkeysID = createObjectDefVerify("far monkeys");
	addObjectDefItemVerify(farMonkeysID, "Baboon", rmRandInt(6, 10), 4.0);
	rmAddObjectDefConstraint(farMonkeysID, avoidAll);
	rmAddObjectDefConstraint(farMonkeysID, avoidEdge);
	rmAddObjectDefConstraint(farMonkeysID, avoidImpassableLand);
	rmAddObjectDefConstraint(farMonkeysID, createClassDistConstraint(classStartingSettlement, 90.0));
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidGold);
	rmAddObjectDefConstraint(farMonkeysID, avoidFood);
	rmAddObjectDefConstraint(farMonkeysID, avoidHuntable);

	// Far berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", 10, 4.0);

	float farBerryMinDist = rmRandFloat(70.0, 90.0);
	float farBerryMaxDist =  farBerryMinDist + 10.0;

	setObjectDefDistance(farBerriesID, farBerryMinDist, farBerryMaxDist);
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidEdge);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farBerriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Goat", rmRandInt(1, 3), 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Goat", rmRandInt(1, 2), 4.0);
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
	rmAddObjectDefConstraint(farPredatorsID, avoidFood);
	rmAddObjectDefConstraint(farPredatorsID, avoidPredator);

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
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Set up fake player areas to block settlements for ponds.
	float fakePlayerAreaSize = areaRadiusMetersToFraction(5.0); // About the size of a settlement.

	for(i = 1; < cPlayers) {
		int fakePlayerAreaID = rmCreateArea("fake player area " + i);
		rmSetAreaSize(fakePlayerAreaID, fakePlayerAreaSize);
		rmSetAreaLocPlayer(fakePlayerAreaID, getPlayer(i));
		// rmSetAreaTerrainType(fakePlayerAreaID, "HadesBuildable1");
		rmSetAreaCoherence(fakePlayerAreaID, 1.0);
		rmAddAreaToClass(fakePlayerAreaID, classStartingSettlement);
		rmSetAreaWarnFailure(fakePlayerAreaID, false);
	}

	rmBuildAllAreas();

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 100 * cNonGaiaPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaTerrainType(beautificationID, "SavannahB");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(40));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 30 * cNonGaiaPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaTerrainType(beautificationID, "SandA");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(50));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	progress(0.3);

	// Close settlement.
	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		addFairLoc(60.0, 80.0, false, true, 60.0, 12.0, 12.0);
	} else {
		addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
		addFairLoc(60.0, 80.0, false, true, 50.0, 12.0, 12.0);
	}

	// Far settlement.
	addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));

	if(cNonGaiaPlayers < 3) {
		setFairLocInterDistMin(70.0);

		if(randChance(0.75)) {
			enableFairLocTwoPlayerCheck();
			addFairLoc(70.0, 100.0, true, false, 80.0, 12.0, 12.0);
		} else {
			addFairLocConstraint(avoidCorner);
			addFairLoc(65.0, 100.0, false, true, 0.0, 12.0, 12.0);
		}
	} else {
		if(randChance(0.75)) {
			addFairLoc(80.0, 100.0, true, false, 70.0, 12.0, 12.0, false, cNonGaiaPlayers < 7 && gameHasTwoEqualTeams());
		} else {
			addFairLoc(60.0, 100.0, false, true, 45.0, 12.0, 12.0);
		}
	}

	createFairLocs("settlements");

	// Add the created areas to the class before placing the ponds.
	fairLocAreasToClass(classSettlementArea);

	rmBuildAllAreas();

	progress(0.4);

	// Elevation.
	int elevationID = 0;

	for(i = 0; < 40 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 1 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(80));
		rmSetAreaTerrainType(elevationID, "SavannahC");
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

	// Ponds.
	int numPond = rmRandInt(2, 4);

	if(cNonGaiaPlayers < 3) {
		numPond = 2;
	}

	float pondSize = rmAreaTilesToFraction(600);
	int avoidPond = createClassDistConstraint(classPond, 20.0);
	int pondAvoidSettlement = createClassDistConstraint(classSettlementArea, 30.0);
	int pondAvoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 70.0);

	for(i = 0; < numPond) {
		int pondID = rmCreateArea("pond " + i);

		rmSetAreaSize(pondID, pondSize);
		rmSetAreaWaterType(pondID, "Savannah Water Hole");
		rmSetAreaCoherence(pondID, 0.0);
		rmAddAreaConstraint(pondID, avoidPond);
		rmAddAreaConstraint(pondID, avoidEdge);
		rmAddAreaConstraint(pondID, pondAvoidStartingSettlement);
		rmAddAreaConstraint(pondID, pondAvoidSettlement);
		rmAddAreaToClass(pondID, classPond);
		rmSetAreaWarnFailure(pondID, false);
		rmBuildArea(pondID);
	}

	// Settlements.
	int settlementID = rmCreateObjectDef("settlements");
	rmAddObjectDefItem(settlementID, "Settlement", 1, 0.0);

	// Place settlements here so we can avoid them being erased by faulty water placement.
	placeObjectAtAllFairLocs(settlementID);

	// Reset fair locations.
	resetFairLocs();

	// Starting settlement.
	placeObjectAtPlayerLocs(startingSettlementID, true);

	// Towers.
	placeAndStoreObjectAtPlayerLocs(startingTowerID, true, 4, 23.0, 27.0, true); // Last parameter: Square placement.

	progress(0.5);

	// Gold.
	// Bonus gold, increment this value upon failing the placement of similar locations.
	int numBonusGold = rmRandInt(1, 3);

	int goldID = createObjectDefVerify("gold");
	addObjectDefItemVerify(goldID, "Gold Mine", 1, 0.0);

	// First (medium).
	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidCorner);
	addSimLocConstraint(avoidImpassableLand);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
	addSimLocConstraint(farAvoidGold);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(farAvoidSettlement);

	enableSimLocTwoPlayerCheck();

	addSimLoc(60.0, 70.0, avoidGoldDist, 8.0, 8.0, false, false, true);

	// Second (medium/far).
	if(cNonGaiaPlayers < 7 && gameHasTwoEqualTeams()) {
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidImpassableLand);
		addSimLocConstraint(avoidCorner);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 70.0));
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidSettlement);

		enableSimLocTwoPlayerCheck();

		addSimLoc(70.0, 80.0, avoidGoldDist, 8.0, 8.0, false, false, true);
	} else {
		// Too many players/weird matchup, place goldmine anywhere in team location.
		numBonusGold++;
	}

	placeObjectAtNewSimLocs(goldID, false, "medium/far gold");

	// Bonus gold (anywhere in team area).
	int bonusGoldID = createObjectDefVerify("bonus gold");
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(bonusGoldID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	if(numBonusGold < 3) {
		rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);
	} else {
		rmAddObjectDefConstraint(bonusGoldID, createTypeDistConstraint("Gold", 40.0));
	}

	placeObjectInTeamSplits(bonusGoldID, false, numBonusGold);

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	// storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(avoidImpassableLand);
	storeObjectConstraint(farAvoidGold); // Since the constraint is so small, apply it also to starting gold.
	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Close and medium hunt.
	bool huntInStartingLOS = randChance(2.0 / 3.0);

	// Close hunt (starting hunt).
	float closeHuntFloat = rmRandFloat(0.0, 1.0);

	if(closeHuntFloat < 0.1) {
		storeObjectDefItem("Zebra", rmRandInt(3, 5), 4.0);
		storeObjectDefItem("Gazelle", rmRandInt(2, 6), 4.0);
	} else if(closeHuntFloat < 0.3) {
		storeObjectDefItem("Zebra", rmRandInt(2, 3), 2.0);
	} else if(closeHuntFloat < 0.6) {
		storeObjectDefItem("Rhinocerous", 1, 0.0);
	} else if(closeHuntFloat < 0.9) {
		storeObjectDefItem("Rhinocerous", 2, 2.0);
	} else {
		storeObjectDefItem("Rhinocerous", 4, 2.0);
	}

	// Place outside of starting LOS if randomized, fall back to starting LOS if placement fails.
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

	// Place inside starting LOS.
	if(huntInStartingLOS) {
		// If we have hunt in starting LOS, we want to force it within tower ranges so we know it's within LOS.
		storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 15.0)));
		storeObjectConstraint(avoidAll);
		storeObjectConstraint(avoidEdge);
		storeObjectConstraint(avoidImpassableLand);
		storeObjectConstraint(shortAvoidGold);

		placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.
	}

	// Medium hunt.
	int mediumHuntID = createObjectDefVerify("medium hunt");
	if(randChance()) {
		addObjectDefItemVerify(mediumHuntID, "Giraffe", rmRandInt(3, 9), 2.0);
	} else {
		addObjectDefItemVerify(mediumHuntID, "Gazelle", rmRandInt(3, 9), 2.0);
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 70.0));
	addSimLocConstraint(avoidImpassableLand);
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(shortAvoidGold);
	addSimLocConstraint(shortAvoidSettlement);

	enableSimLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		setSimLocInterval(10.0);
	}

	addSimLoc(70.0, 85.0, avoidHuntDist, 8.0, 8.0, false, gameHasTwoEqualTeams(), true);

	placeObjectAtNewSimLocs(mediumHuntID, false, "medium hunt");

	// Bonus hunt.
	// Bonus hunt 1.
	float bonusHunt1Float = rmRandFloat(0.0, 1.0);

	int bonusHunt1ID = createObjectDefVerify("bonus hunt 1");
	if(bonusHunt1Float < 0.2) {
		addObjectDefItemVerify(bonusHunt1ID, "Zebra", rmRandInt(2, 4), 2.0);
		addObjectDefItemVerify(bonusHunt1ID, "Giraffe", rmRandInt(0, 2), 2.0);
	} else if(bonusHunt1Float < 0.5) {
		addObjectDefItemVerify(bonusHunt1ID, "Zebra", rmRandInt(4, 6), 2.0);
	} else if(bonusHunt1Float < 0.9) {
		addObjectDefItemVerify(bonusHunt1ID, "Giraffe", rmRandInt(3, 4), 2.0);
	} else {
		addObjectDefItemVerify(bonusHunt1ID, "Gazelle", rmRandInt(4, 7), 2.0);
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 75.0));
	addSimLocConstraint(avoidImpassableLand);
	addSimLocConstraint(shortAvoidSettlement);
	addSimLocConstraint(avoidHuntable);

	enableSimLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		setSimLocInterval(10.0);
	}

	addSimLoc(75.0, 110.0, avoidHuntDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(bonusHunt1ID, false, "bonus hunt 1");

	// Bonus hunt 2.
	float bonusHunt2Float = rmRandFloat(0.0, 1.0);

	int bonusHunt2ID = createObjectDefVerify("bonus hunt 2");
	if(bonusHunt2Float < 0.1) {
		addObjectDefItemVerify(bonusHunt2ID, "Elephant", 3, 2.0);
	} else if(bonusHunt2Float < 0.5) {
		addObjectDefItemVerify(bonusHunt2ID, "Elephant", 2, 2.0);
	} else if(bonusHunt2Float < 0.9) {
		addObjectDefItemVerify(bonusHunt2ID, "Rhinocerous", 2, 2.0);
	} else {
		addObjectDefItemVerify(bonusHunt2ID, "Rhinocerous", 4, 2.0);
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 75.0));
	addSimLocConstraint(avoidImpassableLand);
	addSimLocConstraint(shortAvoidSettlement);
	addSimLocConstraint(avoidHuntable);

	enableSimLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		setSimLocInterval(10.0);
	}

	addSimLoc(75.0, 110.0, avoidHuntDist, 8.0, 8.0, false, false, true);

	// If this fails, place it randomly in the player's area.
	if(createSimLocs("bonus hunt 2", false) == false) {
		applySimLocConstraintsToObject(bonusHunt2ID);
		placeObjectInPlayerSplits(bonusHunt2ID);
	}

	// Other food.
	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

	// Berries.
	if(randChance(0.6)) {
		placeObjectAtPlayerLocs(farBerriesID);
	}

	// Monkeys.
	if(randChance()) {
		placeObjectInPlayerSplits(farMonkeysID);
	}

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
			rmSetAreaForestType(playerForestID, "Savannah Forest");
			rmSetAreaMinBlobs(playerForestID, 3);
			rmSetAreaMaxBlobs(playerForestID, 7);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 40.0);
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
	int numRegularForests = 16 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaForestType(forestID, "Savannah Forest");
		rmSetAreaMinBlobs(forestID, 3);
		rmSetAreaMaxBlobs(forestID, 7);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 40.0);
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
	placeObjectAtPlayerLocs(mediumHerdablesID, false, 2);

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
	// Lone hunt.
	int loneHunt1ID = rmCreateObjectDef("lone hunt 1");
	rmAddObjectDefItem(loneHunt1ID, "Gazelle", 1, 0.0);
	setObjectDefDistanceToMax(loneHunt1ID);
	rmAddObjectDefConstraint(loneHunt1ID, avoidAll);
	rmAddObjectDefConstraint(loneHunt1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(loneHunt1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(loneHunt1ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(loneHunt1ID, avoidFood);
	rmAddObjectDefConstraint(loneHunt1ID, avoidEdge);
	rmPlaceObjectDefAtLoc(loneHunt1ID, 0, 0.5, 0.5, cNonGaiaPlayers);

	int loneHunt2ID = rmCreateObjectDef("lone hunt 2");
	rmAddObjectDefItem(loneHunt2ID, "Zebra", 1, 0.0);
	setObjectDefDistanceToMax(loneHunt2ID);
	rmAddObjectDefConstraint(loneHunt2ID, avoidAll);
	rmAddObjectDefConstraint(loneHunt2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(loneHunt2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(loneHunt2ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(loneHunt2ID, avoidFood);
	rmAddObjectDefConstraint(loneHunt2ID, avoidEdge);
	rmPlaceObjectDefAtLoc(loneHunt2ID, 0, 0.5, 0.5, cNonGaiaPlayers);

	// Water decoration.
	for(i = 0; < numPond) {
		int lillyID = rmCreateObjectDef("lilly " + i);
		rmAddObjectDefItem(lillyID, "Water Lilly", rmRandInt(3, 6), 6.0);
		setObjectDefDistanceToMax(lillyID);
		rmPlaceObjectDefInArea(lillyID, 0, rmAreaID("pond " + i), rmRandInt(2, 4));

		int decorationID = rmCreateObjectDef("decoration " + i);
		rmAddObjectDefItem(decorationID, "Water Decoration", rmRandInt(1, 3), 6.0);
		setObjectDefDistanceToMax(decorationID);
		rmPlaceObjectDefInArea(decorationID, 0, rmAreaID("pond " + i), rmRandInt(2, 4));
	}

	// Rocks.
	int rock1ID = rmCreateObjectDef("rock small");
	rmAddObjectDefItem(rock1ID, "Rock Sandstone Small", 1, 0.0);
	setObjectDefDistanceToMax(rock1ID);
	rmAddObjectDefConstraint(rock1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rock1ID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(rock1ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	int rock2ID = rmCreateObjectDef("rock sprite");
	rmAddObjectDefItem(rock2ID, "Rock Sandstone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rock2ID);
	rmAddObjectDefConstraint(rock2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rock2ID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(rock2ID, 0, 0.5, 0.5, 30 * cNonGaiaPlayers);

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
