/*
** GHOST LAKE
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Ghost Lake");

	// Set size.
	int axisLength = getStandardMapDimInMeters();

	// Initialize map.
	initializeMap("SnowB", axisLength);

	// Set lighting.
	rmSetLightingSet("Ghost Lake");

	// Player placement.
	if(cNonGaiaPlayers < 9) {
		placePlayersInCircle(0.35, 0.4, 0.7);
	} else {
		placePlayersInCircle(0.35, 0.4, 0.9);
	}

	// Control areas.
	int classCorner = initializeCorners();
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
	int classPlayer = rmDefineClass("player");
	int classPlayerCore = rmDefineClass("player core");
	int classCenter = rmDefineClass("center"); // This is just a normal class here.
	int classStartingSettlement = rmDefineClass("starting settlement"); // This is just a normal class here.
	int classCliff = rmDefineClass("cliff");
	int classForest = rmDefineClass("forest");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);
	int avoidPlayer = createClassDistConstraint(classPlayer, 1.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);

	// Terrain.
	int shortAvoidCenter = createClassDistConstraint(classCenter, 5.0);
	int mediumAvoidCenter = createClassDistConstraint(classCenter, 15.0);
	int farAvoidCenter = createClassDistConstraint(classCenter, 20.0);
	int shortAvoidCliff = createClassDistConstraint(classCliff, 10.0);
	int farAvoidCliff = createClassDistConstraint(classCliff, 30.0 + 5.0 * cNonGaiaPlayers);
	int avoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);

	// Gold.
	float avoidGoldDist = 35.0;

	int shortAvoidGold = createTypeDistConstraint("Gold", 10.0);
	int farAvoidGold = createTypeDistConstraint("Gold", avoidGoldDist);

	// Food.
	float avoidHuntDist = 40.0;

	int avoidHuntable = createTypeDistConstraint("Huntable", avoidHuntDist);
	int avoidHerdable = createTypeDistConstraint("Herdable", 30.0);
	int avoidFood = createTypeDistConstraint("Food", 20.0);
	int avoidPredator = createTypeDistConstraint("AnimalPredator", 40.0);

	// Forest.
	int avoidForest = createClassDistConstraint(classForest, 30.0);
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

	// Starting gold.
	int startingGoldID = rmCreateObjectDef("starting gold");
	rmAddObjectDefItem(startingGoldID, "Gold Mine Small", 1, 0.0);
	setObjectDefDistance(startingGoldID, 21.0, 24.0);
	rmAddObjectDefConstraint(startingGoldID, avoidAll);
	rmAddObjectDefConstraint(startingGoldID, avoidEdge);
	rmAddObjectDefConstraint(startingGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingGoldID, createTypeDistConstraint("Gold", 20.0));

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(4, 8), 2.0);
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, avoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Goat", rmRandInt(2, 5), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, avoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Pine Snow", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Far berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", rmRandInt(4, 10), 4.0);
	if(cNonGaiaPlayers < 5) {
		setObjectDefDistance(farBerriesID, 70.0, 90.0); // Place in team areas in 3v3+ teamgames.
	}
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidEdge);
	rmAddObjectDefConstraint(farBerriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidCenter);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farBerriesID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Goat", rmRandInt(1, 3), 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, shortAvoidCenter);
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
	addObjectDefItemVerify(farPredatorsID, "Polar Bear", rmRandInt(1, 2), 4.0);
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
	rmAddObjectDefItem(randomTreeID, "Pine Snow", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, avoidImpassableLand);
	rmAddObjectDefConstraint(randomTreeID, shortAvoidCliff);
	rmAddObjectDefConstraint(randomTreeID, shortAvoidCenter);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Set up fake player areas.
	float fakePlayerAreaSize = rmAreaTilesToFraction(110);

	for(i = 1; < cPlayers) {
		int fakePlayerAreaID = rmCreateArea("fake player area " + i);
		rmSetAreaSize(fakePlayerAreaID, fakePlayerAreaSize);
		rmSetAreaLocPlayer(fakePlayerAreaID, getPlayer(i));
		// rmSetAreaTerrainType(fakePlayerAreaID, "HadesBuildable1");
		rmSetAreaCoherence(fakePlayerAreaID, 1.0);
		rmAddAreaToClass(fakePlayerAreaID, classPlayerCore);
		rmSetAreaWarnFailure(fakePlayerAreaID, false);
	}

	rmBuildAllAreas();

	// Create ghost lake.
	int centerID = rmCreateArea("center");
	rmSetAreaSize(centerID, 0.13, 0.17);
	rmSetAreaLocation(centerID, 0.5, 0.5);
	rmSetAreaTerrainType(centerID, "IceC");
	rmAddAreaTerrainLayer(centerID, "IceB", 6, 10);
	rmAddAreaTerrainLayer(centerID, "IceA", 0, 6);
	rmSetAreaCoherence(centerID, 0.25);
	rmSetAreaBaseHeight(centerID, -1.0);
	rmSetAreaHeightBlend(centerID, 2);
	rmSetAreaSmoothDistance(centerID, 50);
	rmSetAreaMinBlobs(centerID, 8);
	rmSetAreaMaxBlobs(centerID, 10);
	rmSetAreaMaxBlobDistance(centerID, (1.0 * axisLength) / 8.0);
	rmSetAreaMinBlobDistance(centerID, (1.0 * axisLength) / 16.0);
	rmAddAreaToClass(centerID, classCenter);
	rmAddAreaConstraint(centerID, createClassDistConstraint(classPlayerCore, 40.0));
	rmSetAreaWarnFailure(centerID, false);
	rmBuildArea(centerID);

	// Decorate player areas.
	int playerAreaSize = rmAreaTilesToFraction(2000);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area beautification " + i);
		rmSetAreaSize(playerAreaID, 0.9 * playerAreaSize, 1.1 * playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "SnowGrass50");
		rmAddAreaTerrainLayer(playerAreaID, "SnowGrass25", 0, 8);
		rmSetAreaCoherence(playerAreaID, 0.4);
		rmSetAreaMinBlobs(playerAreaID, 2);
		rmSetAreaMaxBlobs(playerAreaID, 3);
		rmSetAreaMinBlobDistance(playerAreaID, 20.0);
		rmSetAreaMaxBlobDistance(playerAreaID, 20.0);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmAddAreaConstraint(playerAreaID, farAvoidCenter);
		rmSetAreaWarnFailure(playerAreaID, false);
	}

	rmBuildAllAreas();

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 10 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaTerrainType(beautificationID, "SnowGrass50");
		rmAddAreaTerrainLayer(beautificationID, "SnowGrass25", 2, 5);
		rmAddAreaTerrainLayer(beautificationID, "SnowB", 0, 2);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(200));
		rmSetAreaCoherence(beautificationID, 0.4);
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidCenter);
		rmAddAreaConstraint(beautificationID, avoidPlayer);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 10 * cPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		if(randChance()) {
			rmSetAreaTerrainType(beautificationID, "SnowA");
		} else {
			rmSetAreaTerrainType(beautificationID, "SnowSand25");
		}
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(30));
		rmSetAreaCoherence(beautificationID, 0.4);
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidCenter);
		rmAddAreaConstraint(beautificationID, avoidPlayer);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	// Center embellishment.
	for(i = 0; < 5 * cNonGaiaPlayers) {
		beautificationID = rmCreateArea("center embellishment " + i, centerID);
		rmSetAreaSize(beautificationID, 0.001, 0.01);
		rmSetAreaTerrainType(beautificationID, "IceA");
		rmAddAreaTerrainLayer(beautificationID, "IceB", 0, 3);
		rmSetAreaCoherence(beautificationID, 0.0);
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

	// Far settlement.
	addFairLocConstraint(mediumAvoidCenter);

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		setFairLocInterDistMin(90.0);
		addFairLoc(70.0, 120.0, true, false, 70.0, 12.0, 12.0, true);
	} else {
		addFairLocConstraint(avoidTowerLOS);
		addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
		addFairLoc(70.0, 110.0, true, false, 70.0, 12.0, 12.0, false, gameHasTwoEqualTeams());
	}

	// Close settlement.
	enableFairLocTwoPlayerCheck();

	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(mediumAvoidCenter);

	if(cNonGaiaPlayers < 3) {
		addFairLocConstraint(avoidCorner);
		addFairLoc(60.0, 80.0, false, true, 65.0, 12.0, 12.0);
	} else {
		addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
		addFairLoc(60.0, 80.0, false, true, 50.0, 12.0, 12.0);
	}

	placeObjectAtNewFairLocs(settlementID, false, "settlements");

	progress(0.4);

	// Elevation after cliffs.
	int elevationID = 0;

	for(i = 0; < 30 * cNonGaiaPlayers) {
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
		rmAddAreaConstraint(elevationID, shortAvoidCenter);
		rmAddAreaConstraint(elevationID, shortAvoidCliff);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	// Cliffs.
	int cliffID = 0;

	for(i = 0; < cTeams) {
		int numTeamCliffs = 0;
		int numTeamPlayers = getNumberPlayersOnTeam(i);

		if(numTeamPlayers < 2) {
			numTeamCliffs = 2;
		} else if(numTeamPlayers < 5) {
			numTeamCliffs = 3;
		} else {
			numTeamCliffs = numTeamPlayers;
		}

		for(j = 0; < numTeamCliffs) {
			if(cNonGaiaPlayers < 3) {
				// Small, in team/player area.
				cliffID = rmCreateArea("cliff " + i + " " + j, rmAreaID(cTeamSplitName + " " + i));
				rmSetAreaSize(cliffID, rmAreaTilesToFraction(200), rmAreaTilesToFraction(300));
			} else {
				// Large, not in team area.
				cliffID = rmCreateArea("cliff " + i + " " + j);
				rmSetAreaSize(cliffID, rmAreaTilesToFraction(300), rmAreaTilesToFraction(500));
			}
			rmSetAreaCliffType(cliffID, "Norse");
			rmSetAreaMinBlobs(beautificationID, 2);
			rmSetAreaMaxBlobs(beautificationID, 4);
			rmSetAreaMinBlobDistance(beautificationID, 10.0);
			rmSetAreaMaxBlobDistance(beautificationID, 10.0);
			rmSetAreaCliffEdge(cliffID, 2, 0.35, 0.0, 1.0, 1);
			rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, false);
			rmSetAreaCliffHeight(cliffID, 6.0, 1.0, 1.0);
			rmSetAreaHeightBlend(cliffID, 2);
			rmSetAreaSmoothDistance(cliffID, 10);
			rmAddAreaToClass(cliffID, classCliff);
			rmAddAreaConstraint(cliffID, mediumAvoidCenter);
			rmAddAreaConstraint(cliffID, farAvoidCliff);
			rmAddAreaConstraint(cliffID, avoidBuildings);
			rmAddAreaConstraint(cliffID, avoidTowerLOS);
			rmSetAreaWarnFailure(cliffID, false);

			rmBuildArea(cliffID);
		}
	}

	progress(0.5);

	// Starting gold.
	int numStartingGold = rmRandInt(1, 2);

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(avoidImpassableLand);
	// storeObjectConstraint(shortAvoidCenter);

	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	placeObjectAtPlayerLocs(startingGoldID, false, numStartingGold - 1);

	// Gold.
	int numBonusGold = rmRandInt(2, 4);

	if(cNonGaiaPlayers < 3 && numBonusGold == 2) {
		// In the case of only placing 2 fair mines, place one a bit closer.
		int farGoldID = createObjectDefVerify("far gold");
		addObjectDefItemVerify(farGoldID, "Gold Mine", 1, 0.0);

		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidCorner);
		addSimLocConstraint(shortAvoidCenter);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(avoidImpassableLand);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(avoidTowerLOS);

		enableSimLocTwoPlayerCheck();

		addSimLoc(50.0, 65.0, avoidGoldDist, 8.0, 8.0, false, false, true);

		placeObjectAtNewSimLocs(farGoldID, false, "far gold");

		numBonusGold = numBonusGold - 1;
	}

	// Bonus gold.
	int bonusGoldID = createObjectDefVerify("bonus gold");
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	rmAddObjectDefConstraint(bonusGoldID, shortAvoidCenter);
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
		rmAddObjectDefConstraint(bonusGoldID, avoidCenterline);
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 80.0));
	} else {
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 60.0));
	}
	rmAddObjectDefConstraint(bonusGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);

	placeObjectInPlayerSplits(bonusGoldID, false, numBonusGold);

	progress(0.6);

	// Food.
	// Close hunt.
	int numCloseHunt = rmRandInt(1, 2);

	// Total chance for starting hunt still 2/3.
	bool huntInStartingLOS = numCloseHunt == 2 || randChance(1.0 / 3.0);

	if(randChance(0.6)) {
		storeObjectDefItem("Boar", rmRandInt(1, 3), 2.0);
	} else {
		storeObjectDefItem("Aurochs", rmRandInt(1, 2), 2.0);
	}

	// Place outside of starting LOS if randomized, fall back to starting LOS if placement fails.
	if(huntInStartingLOS == false) {
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidImpassableLand);
		addSimLocConstraint(shortAvoidCenter);
		addSimLocConstraint(avoidTowerLOS);
		// addSimLocConstraint(shortAvoidGold);

		enableSimLocTwoPlayerCheck();

		addSimLoc(45.0, 50.0, avoidHuntDist, 8.0, 8.0, false, false, true);

		if(placeObjectAtNewSimLocs(createObjectFromStorage("close hunt"), false, "close hunt", false) == false) {
			huntInStartingLOS = true;
		}
	}

	if(huntInStartingLOS) {
		// In tower LOS if we have 2 close hunts or randomized accordingly.
		storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 15.0)));
		storeObjectConstraint(avoidAll);
		storeObjectConstraint(avoidEdge);
		storeObjectConstraint(avoidImpassableLand);
		storeObjectConstraint(shortAvoidCenter);
		// storeObjectConstraint(createTypeDistConstraint("Huntable", 20.0));
		storeObjectConstraint(shortAvoidGold);

		placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.

		if(numCloseHunt == 2) {
			enableSimLocTwoPlayerCheck();

			addSimLoc(30.0, 50.0, avoidHuntDist, 8.0, 8.0, false, false, true);

			// Create object from storage with verify = true, added constraints = false.
			placeObjectAtNewSimLocs(createObjectFromStorage("close hunt", true, false), false, "close hunt");
		}
	}

	resetObjectStorage();

	// Far hunt.
	int numFarHunt = rmRandInt(1, 2);

	int farHuntID = createObjectDefVerify("far hunt");
	addObjectDefItemVerify(farHuntID, "Caribou", rmRandInt(4, 10), 4.0);

	if(numFarHunt == 1 && cNonGaiaPlayers < 3) {
		// Only have one close hunt and one far hunt.

		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(avoidHuntable);
		addSimLocConstraint(shortAvoidCenter);
		addSimLocConstraint(shortAvoidCliff);
		addSimLocConstraint(shortAvoidGold);

		enableSimLocTwoPlayerCheck();

		addSimLoc(60.0, 100.0, avoidHuntDist, 8.0, 8.0, false, false, true);

		placeObjectAtNewSimLocs(farHuntID, false, "far hunt");
	} else {
		float farHuntMinDist = rmRandFloat(55.0, 80.0);
		float farHuntMaxDist = farHuntMinDist + 10.0; // + 5.0 fails too often.

		// Place both as usual if we have 2.
		if(numFarHunt == 1) {
			setObjectDefDistance(farHuntID, farHuntMinDist, farHuntMaxDist);
		} else {
			setObjectDefDistance(farHuntID, 55.0, 90.0 + 10.0 * numFarHunt);
		}
		rmAddObjectDefConstraint(farHuntID, avoidAll);
		rmAddObjectDefConstraint(farHuntID, avoidEdge);
		rmAddObjectDefConstraint(farHuntID, createClassDistConstraint(classStartingSettlement, 60.0));
		rmAddObjectDefConstraint(farHuntID, farAvoidSettlement);
		rmAddObjectDefConstraint(farHuntID, avoidTowerLOS);
		rmAddObjectDefConstraint(farHuntID, avoidHuntable);
		rmAddObjectDefConstraint(farHuntID, shortAvoidCenter);
		rmAddObjectDefConstraint(farHuntID, shortAvoidCliff);
		rmAddObjectDefConstraint(farHuntID, shortAvoidGold);

		placeObjectAtPlayerLocs(farHuntID, false, numFarHunt);
	}

	// Other food.
	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

	// Far berries.
	if(cNonGaiaPlayers < 5) {
		placeObjectAtPlayerLocs(farBerriesID);
	} else {
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
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(150));
			rmSetAreaForestType(playerForestID, "Snow Pine Forest");
			rmSetAreaCoherence(playerForestID, 0.2);
			rmSetAreaMinBlobs(playerForestID, 1);
			rmSetAreaMaxBlobs(playerForestID, 3);
			rmSetAreaMinBlobDistance(playerForestID, 10.0);
			rmSetAreaMaxBlobDistance(playerForestID, 10.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, avoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, avoidImpassableLand);
			rmAddAreaConstraint(playerForestID, shortAvoidCenter);
			rmAddAreaConstraint(playerForestID, shortAvoidCliff);
			rmSetAreaWarnFailure(playerForestID, false);
			rmBuildArea(playerForestID);
		}
	}

	// Other forest.
	int numRegularForests = 7 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(150));
		rmSetAreaForestType(forestID, "Snow Pine Forest");
		rmSetAreaCoherence(forestID, 0.2);
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 3);
		rmSetAreaMinBlobDistance(forestID, 10.0);
		rmSetAreaMaxBlobDistance(forestID, 10.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, shortAvoidCenter);
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
	placeObjectInPlayerSplits(farPredatorsID); // Center is clear.

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID, false, rmRandInt(1, 2));

	// Far herdables.
	placeObjectAtPlayerLocs(farHerdablesID, false, rmRandInt(2, 3));

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectInPlayerSplits(relicID); // Center is clear.

	// Random trees.
	placeObjectAtPlayerLocs(randomTreeID, false, 10);

	progress(0.9);

	// Embellishment.
	// Rocks.
	int rockID = rmCreateObjectDef("rocks");
	rmAddObjectDefItem(rockID, "Rock Granite Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rockID);
	rmAddObjectDefConstraint(rockID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockID, shortAvoidCenter);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 15 * cNonGaiaPlayers);

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
	addProtoPlacementCheck("Gold Mine Small", numStartingGold * cNonGaiaPlayers, 0);
	addProtoPlacementCheck("Settlement", 2 * cNonGaiaPlayers, 0);

	// Finalize RM X.
	rmxFinalize();

	progress(1.0);
}
