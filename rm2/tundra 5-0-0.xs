/*
** TUNDRA
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

string terrainTundraPool = "Tundra Pool";
string objectTundraTree = "Tundra Tree";
string objectTundraWolf = "Wolf Arctic 2";
string forestTundraForest = "Tundra Forest";
string terrainTundraRockA = "TundraRockA";
string terrainTundraGrassA = "TundraGrassA";
string terrainTundraGrassB = "TundraGrassB";

/*
** Vanilla textures.
*/
void useVanillaTextures() {
	terrainTundraPool = "Norwegian Sea";
	objectTundraTree = "Pine Snow";
	objectTundraWolf = "Wolf";
	forestTundraForest = "Snow Pine Forest";
	terrainTundraRockA = "SnowA";
	terrainTundraGrassA = "SnowB";
	terrainTundraGrassB = "SnowC";
}

void main() {
	progress(0.0);

	// Initial map setup.
	if(cVersion == cVersionVanilla) {
		useVanillaTextures();
		rmxInit("Tundra (Vanilla)");
	} else {
		rmxInit("Tundra");
	}

	// Set size.
	int axisLength = getStandardMapDimInMeters();

	// Initialize map.
	initializeMap(terrainTundraRockA, axisLength);

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
	int classPlayer = rmDefineClass("player");
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

	// Starting hunt.
	int startingHuntID = createObjectDefVerify("starting hunt");
	addObjectDefItemVerify(startingHuntID, "Caribou", 6, 2.0);
	setObjectDefDistance(startingHuntID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingHuntID, avoidAll);
	rmAddObjectDefConstraint(startingHuntID, avoidEdge);
	rmAddObjectDefConstraint(startingHuntID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingHuntID, createTypeDistConstraint("Huntable", 20.0));

	// Starting food.
	bool hasStartingGoats = randChance(0.8);

	int startingFoodID = createObjectDefVerify("starting food");
	if(hasStartingGoats) {
		addObjectDefItemVerify(startingFoodID, "Goat", rmRandInt(6, 8), 2.0);
	} else {
		addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(6, 8), 2.0);
	}
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, objectTundraTree, 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Far berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", rmRandInt(8, 10), 4.0);
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidEdge);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(farBerriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Far predators.
	// Far predators 1.
	int farPredators1ID = createObjectDefVerify("far predators 1");
	if(randChance()) {
		addObjectDefItemVerify(farPredators1ID, "Polar Bear", 1, 0.0);
	} else {
		addObjectDefItemVerify(farPredators1ID, objectTundraWolf, 2, 4.0);
	}
	rmAddObjectDefConstraint(farPredators1ID, avoidAll);
	rmAddObjectDefConstraint(farPredators1ID, avoidEdge);
	rmAddObjectDefConstraint(farPredators1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(farPredators1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredators1ID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredators1ID, avoidFood);
	rmAddObjectDefConstraint(farPredators1ID, avoidPredator);

	// Far predators 2.
	int farPredators2ID = createObjectDefVerify("far predators 2");
	addObjectDefItemVerify(farPredators2ID, objectTundraWolf, 2, 4.0);
	rmAddObjectDefConstraint(farPredators2ID, avoidAll);
	rmAddObjectDefConstraint(farPredators2ID, avoidEdge);
	rmAddObjectDefConstraint(farPredators2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(farPredators2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredators2ID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredators2ID, avoidFood);
	rmAddObjectDefConstraint(farPredators2ID, avoidPredator);

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
	rmAddObjectDefItem(randomTreeID, objectTundraTree, 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Set up fake player areas to block settlements and player areas for ponds.
	float fakePlayerAreaSize = areaRadiusMetersToFraction(5.0); // About the size of a settlement.
	float largeFakePlayerAreaSize = rmAreaTilesToFraction(4000);

	for(i = 1; < cPlayers) {
		int fakePlayerAreaID = rmCreateArea("fake player area " + i);
		rmSetAreaSize(fakePlayerAreaID, fakePlayerAreaSize);
		rmSetAreaLocPlayer(fakePlayerAreaID, getPlayer(i));
		// rmSetAreaTerrainType(fakePlayerAreaID, "HadesBuildable1");
		rmSetAreaCoherence(fakePlayerAreaID, 1.0);
		rmAddAreaToClass(fakePlayerAreaID, classStartingSettlement);
		rmSetAreaWarnFailure(fakePlayerAreaID, false);

		fakePlayerAreaID = rmCreateArea("large fake player area " + i);
		rmSetAreaSize(fakePlayerAreaID, largeFakePlayerAreaSize);
		rmSetAreaLocPlayer(fakePlayerAreaID, getPlayer(i));
		// rmSetAreaTerrainType(fakePlayerAreaID, "HadesBuildable1");
		rmSetAreaMinBlobs(fakePlayerAreaID, 1);
		rmSetAreaMaxBlobs(fakePlayerAreaID, 5);
		rmSetAreaMinBlobDistance(fakePlayerAreaID, 16.0);
		rmSetAreaMaxBlobDistance(fakePlayerAreaID, 40.0);
		rmAddAreaToClass(fakePlayerAreaID, classPlayer);
		rmSetAreaWarnFailure(fakePlayerAreaID, false);
	}

	rmBuildAllAreas();

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 100 * cNonGaiaPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaTerrainType(beautificationID, terrainTundraGrassB);
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
		rmSetAreaTerrainType(beautificationID, terrainTundraGrassA);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(70));
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
		addFairLocConstraint(avoidCorner);
		addFairLoc(65.0, 80.0, false, true, 60.0, 12.0, 12.0);
	} else {
		addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
		addFairLoc(60.0, 80.0, false, true, 50.0, 12.0, 12.0);
	}

	// Far settlement.
	addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		addFairLoc(70.0, 100.0, true, false, 80.0, 12.0, 12.0, false, gameHasTwoEqualTeams());
	} else {
		addFairLoc(80.0, 100.0, true, false, 70.0, 12.0, 12.0, false, gameHasTwoEqualTeams());
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
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(80));
		rmSetAreaTerrainType(elevationID, terrainTundraGrassA);
		rmSetAreaBaseHeight(elevationID, rmRandFloat(4.0, 5.0));
		rmSetAreaHeightBlend(elevationID, 2);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 3);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 20.0);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	// Ponds.
	int numPondTries = 30 * cNonGaiaPlayers;
	float pondSize = rmAreaTilesToFraction(400);

	int avoidPond = createClassDistConstraint(classPond, 25.0);
	int pondAvoidSettlement = createClassDistConstraint(classSettlementArea, 45.0);
	int pondAvoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 60.0);
	int pondAvoidPlayer = createClassDistConstraint(classPlayer, 20.0);

	for(i = 0; < numPondTries) {
		int pondID = rmCreateArea("pond " + i);

		rmSetAreaSize(pondID, pondSize);
		rmSetAreaLocation(pondID, rmRandFloat(0.1, 0.9), rmRandFloat(0.1, 0.9));
		rmSetAreaWaterType(pondID, terrainTundraPool);
		rmSetAreaMinBlobs(pondID, 1);
		rmSetAreaMaxBlobs(pondID, 1);
		rmAddAreaConstraint(pondID, avoidPond);
		rmAddAreaConstraint(pondID, pondAvoidPlayer);
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
	// Medium gold.
	int numMediumGold = rmRandInt(1, 2);

	// Bonus gold, increment this value upon failing the placement of similar locations.
	int numBonusGold = rmRandInt(2, 4);

	// Adjust extreme case for balance.
	if(numMediumGold == 1 && numBonusGold == 2) {
		numMediumGold = 2;
		numBonusGold = 1;
	}

	int mediumGoldID = createObjectDefVerify("medium gold");
	addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);

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

	// Second (medium).
	if(numMediumGold == 2 && gameHasTwoEqualTeams()) {
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidCorner);
		addSimLocConstraint(avoidImpassableLand);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidSettlement);

		enableSimLocTwoPlayerCheck();

		addSimLoc(60.0, 80.0, avoidGoldDist, 8.0, 8.0, false, false, true);
	}

	placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold");

	// Bonus gold (anywhere in team area).
	// Only verify if we have < 5 mines per player, otherwise it won't matter too much.
	int bonusGoldID = createObjectDefVerify("bonus gold", numMediumGold + numBonusGold < 5 || cDebugMode >= cDebugFull);
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(bonusGoldID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
	}

	if(numBonusGold < 3) {
		rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);
	} else {
		rmAddObjectDefConstraint(bonusGoldID, createTypeDistConstraint("Gold", 40.0));
	}

	placeObjectInTeamSplits(bonusGoldID, false, numBonusGold);

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	storeObjectConstraint(avoidAll);
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
		storeObjectDefItem("Elk", rmRandInt(5, 6), 4.0);
		storeObjectDefItem("Caribou", rmRandInt(5, 6), 4.0);
	} else if(closeHuntFloat < 0.3) {
		storeObjectDefItem("Elk", rmRandInt(2, 3), 2.0);
	} else if(closeHuntFloat < 0.6) {
		storeObjectDefItem("Aurochs", 2, 2.0);
	} else if(closeHuntFloat < 0.9) {
		storeObjectDefItem("Aurochs", 3, 2.0);
	} else {
		storeObjectDefItem("Aurochs", 4, 2.0);
	}

	if(huntInStartingLOS == false) {
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		// addSimLocConstraint(shortAvoidGold);

		addSimLoc(45.0, 55.0, avoidHuntDist, 8.0, 8.0);

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

	resetObjectStorage();

	// This map has so much hunt that we don't have to rely on similar locations.
	// Medium hunt.
	int mediumHuntID = createObjectDefVerify("medium hunt");
	addObjectDefItemVerify(mediumHuntID, "Caribou", rmRandInt(4, 5), 2.0);

	float mediumHuntMin = rmRandFloat(60.0, 70.0);
	float mediumHuntMax = mediumHuntMin + 5.0;

	setObjectDefDistance(mediumHuntID, mediumHuntMin, mediumHuntMax);
	rmAddObjectDefConstraint(mediumHuntID, avoidAll);
	rmAddObjectDefConstraint(mediumHuntID, avoidEdge);
	rmAddObjectDefConstraint(mediumHuntID, createClassDistConstraint(classStartingSettlement, 60.0));
	rmAddObjectDefConstraint(mediumHuntID, avoidImpassableLand);
	rmAddObjectDefConstraint(mediumHuntID, shortAvoidSettlement);
	rmAddObjectDefConstraint(mediumHuntID, avoidHuntable);
	rmAddObjectDefConstraint(mediumHuntID, avoidTowerLOS);

	placeObjectAtPlayerLocs(mediumHuntID, false, 1);

	// Far hunt.
	int farHuntID = createObjectDefVerify("far hunt 3");
	addObjectDefItemVerify(farHuntID, "Elk", rmRandInt(4, 9), 2.0);

	float farHuntMin = rmRandFloat(60.0, 70.0);
	float farHuntMax = farHuntMin + 10.0;

	setObjectDefDistance(farHuntID, farHuntMin, farHuntMax);
	rmAddObjectDefConstraint(farHuntID, avoidAll);
	rmAddObjectDefConstraint(farHuntID, avoidEdge);
	rmAddObjectDefConstraint(farHuntID, createClassDistConstraint(classStartingSettlement, 60.0));
	rmAddObjectDefConstraint(farHuntID, avoidImpassableLand);
	rmAddObjectDefConstraint(farHuntID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farHuntID, avoidHuntable);
	rmAddObjectDefConstraint(farHuntID, avoidTowerLOS);

	placeObjectAtPlayerLocs(farHuntID, false, 1);

	// Bonus hunt.
	// There is so much hunt on this map, just place bonus hunt anywhere in player areas.
	// Bonus hunt 1.
	int bonusHunt1ID = createObjectDefVerify("bonus hunt 1");
	addObjectDefItemVerify(bonusHunt1ID, "Aurochs", rmRandInt(2, 3), 2.0);

	rmAddObjectDefConstraint(bonusHunt1ID, avoidAll);
	rmAddObjectDefConstraint(bonusHunt1ID, avoidEdge);
	rmAddObjectDefConstraint(bonusHunt1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(bonusHunt1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusHunt1ID, shortAvoidSettlement);
	// rmAddObjectDefConstraint(bonusHunt1ID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusHunt1ID, avoidHuntable);

	placeObjectInPlayerSplits(bonusHunt1ID);

	// Bonus hunt 2.
	float bonusHunt2Float = rmRandFloat(0.0, 1.0);

	int bonusHunt2ID = createObjectDefVerify("bonus hunt 2");
	if(bonusHunt2Float < 0.2) {
		addObjectDefItemVerify(bonusHunt2ID, "Caribou", rmRandInt(4, 5), 2.0);
		addObjectDefItemVerify(bonusHunt2ID, "Aurochs", rmRandInt(0, 2), 2.0);
	} else if(bonusHunt2Float < 0.5) {
		addObjectDefItemVerify(bonusHunt2ID, "Elk", rmRandInt(4, 6), 2.0);
	} else if(bonusHunt2Float < 0.9) {
		addObjectDefItemVerify(bonusHunt2ID, "Aurochs", rmRandInt(2, 3), 2.0);
	} else {
		addObjectDefItemVerify(bonusHunt2ID, "Caribou", rmRandInt(4, 7), 2.0);
	}

	rmAddObjectDefConstraint(bonusHunt2ID, avoidAll);
	rmAddObjectDefConstraint(bonusHunt2ID, avoidEdge);
	rmAddObjectDefConstraint(bonusHunt2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(bonusHunt2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusHunt2ID, shortAvoidSettlement);
	// rmAddObjectDefConstraint(bonusHunt2ID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusHunt2ID, avoidHuntable);

	placeObjectInPlayerSplits(bonusHunt2ID);

	// Bonus hunt 3.
	int bonusHunt3ID = createObjectDefVerify("bonus hunt 3");
	if(randChance(0.2)) {
		addObjectDefItemVerify(bonusHunt3ID, "Aurochs", 3, 2.0);
	} else {
		addObjectDefItemVerify(bonusHunt3ID, "Aurochs", 2, 2.0);
	}

	rmAddObjectDefConstraint(bonusHunt3ID, avoidAll);
	rmAddObjectDefConstraint(bonusHunt3ID, avoidEdge);
	rmAddObjectDefConstraint(bonusHunt3ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(bonusHunt3ID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusHunt3ID, shortAvoidSettlement);
	// rmAddObjectDefConstraint(bonusHunt3ID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusHunt3ID, avoidHuntable);

	placeObjectInPlayerSplits(bonusHunt3ID);

	// Other food.
	// Starting hunt.
	placeObjectAtPlayerLocs(startingHuntID);

	// Starting food.
	if(hasStartingGoats) {
		placeObjectAtPlayerLocs(startingFoodID, true);
	} else {
		placeObjectAtPlayerLocs(startingFoodID);
	}

	// Berries.
	if(randChance(0.6)) {
		placeObjectInPlayerSplits(farBerriesID);
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
			rmSetAreaForestType(playerForestID, forestTundraForest);
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
	int numRegularForests = 15 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaForestType(forestID, forestTundraForest);
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
	placeObjectInPlayerSplits(farPredators1ID);
	placeObjectInPlayerSplits(farPredators2ID);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectInPlayerSplits(relicID);

	// Random trees.
	placeObjectAtPlayerLocs(randomTreeID, false, 20);

	progress(0.9);

	// Embellishment.
	// Lone hunt.
	int loneHunt1ID = rmCreateObjectDef("lone hunt 1");
	rmAddObjectDefItem(loneHunt1ID, "Caribou", 1, 0.0);
	setObjectDefDistanceToMax(loneHunt1ID);
	rmAddObjectDefConstraint(loneHunt1ID, avoidAll);
	rmAddObjectDefConstraint(loneHunt1ID, avoidImpassableLand);
	rmAddObjectDefConstraint(loneHunt1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(loneHunt1ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(loneHunt1ID, avoidFood);
	rmAddObjectDefConstraint(loneHunt1ID, avoidEdge);
	rmPlaceObjectDefAtLoc(loneHunt1ID, 0, 0.5, 0.5, cNonGaiaPlayers);

	int loneHunt2ID = rmCreateObjectDef("lone hunt 2");
	rmAddObjectDefItem(loneHunt2ID, "Elk", 1, 0.0);
	setObjectDefDistanceToMax(loneHunt2ID);
	rmAddObjectDefConstraint(loneHunt2ID, avoidAll);
	rmAddObjectDefConstraint(loneHunt2ID, avoidImpassableLand);
	rmAddObjectDefConstraint(loneHunt2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(loneHunt2ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(loneHunt2ID, avoidFood);
	rmAddObjectDefConstraint(loneHunt2ID, avoidEdge);
	rmPlaceObjectDefAtLoc(loneHunt2ID, 0, 0.5, 0.5, cNonGaiaPlayers);

	// Rocks.
	int rock1ID = rmCreateObjectDef("rock small");
	rmAddObjectDefItem(rock1ID, "Rock Sandstone Small", 1, 0.0);
	setObjectDefDistanceToMax(rock1ID);
	rmAddObjectDefConstraint(rock1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rock1ID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(rock1ID, 0, 0.5, 0.5, 20 * cNonGaiaPlayers);

	int rock2ID = rmCreateObjectDef("rock sprite");
	rmAddObjectDefItem(rock2ID, "Rock Limestone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rock2ID);
	rmAddObjectDefConstraint(rock2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rock2ID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(rock2ID, 0, 0.5, 0.5, 40 * cNonGaiaPlayers);

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
	injectSnow(0.1);
	rmxFinalize();

	progress(1.0);
}
