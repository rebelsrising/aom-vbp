/*
** MEDITERRANEAN
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Mediterranean");

	// Set size.
	int axisLength = getStandardMapDimInMeters(8000);

	// Initialize map.
	initializeMap("GrassDirt25", axisLength);

	// Player placement.
	placePlayersInCircle(0.39, 0.41, 0.825);

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
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);

	// Terrain.
	int shortAvoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);
	int farAvoidImpassableLand = createTerrainDistConstraint("Land", false, 15.0);

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
	rmAddObjectDefConstraint(startingTowerID, shortAvoidImpassableLand);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	if(randChance(0.8)) {
		addObjectDefItemVerify(startingFoodID, "Chicken", rmRandInt(6, 10), 4.0);
	} else {
		addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(4, 6), 2.0);
	}
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Pig", rmRandInt(2, 4), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, shortAvoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Oak Tree", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Far berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", 10, 4.0);
	// setObjectDefDistance(farBerriesID, 70.0, 90.0); // Place in splits instead.
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidEdge);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farBerriesID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Pig", 2, 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0); // May fail to place in 3v3+ in extremely rare cases.
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Pig", 2, 4.0);
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
	rmAddObjectDefItem(randomTreeID, "Oak Tree", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Create mediterranean sea.
	int seaID = rmCreateArea("sea");
	if(cNonGaiaPlayers < 3) {
		rmSetAreaSize(seaID, 0.3);
	} else if(cNonGaiaPlayers < 5) {
		rmSetAreaSize(seaID, 0.325);
	} else {
		rmSetAreaSize(seaID, 0.35);
	}
	rmSetAreaLocation(seaID, 0.5, 0.5);
	rmSetAreaWaterType(seaID, "Mediterranean Sea");
	rmSetAreaCoherence(seaID, 0.25);
	rmSetAreaBaseHeight(seaID, 0.0);
	rmSetAreaSmoothDistance(seaID, 50);
	rmSetAreaMinBlobs(seaID, 10);
	rmSetAreaMaxBlobs(seaID, 10);
	rmSetAreaMinBlobDistance(seaID, 15);
	rmSetAreaMaxBlobDistance(seaID, 15);
	// rmAddAreaConstraint(seaID, createSymmetricBoxConstraint(rmXMetersToFraction(30.0), rmXMetersToFraction(30.0)));
	rmSetAreaWarnFailure(seaID, false);
	rmBuildArea(seaID);

	// Create bonus island.
	if(cNonGaiaPlayers > 2) {
		int bonusIslandID = rmCreateArea("bonus island");
		rmSetAreaSize(bonusIslandID, rmAreaTilesToFraction(300));
		rmSetAreaLocation(bonusIslandID, 0.5, 0.5);
		rmSetAreaTerrainType(bonusIslandID, "ShorelineMediterraneanB");
		rmSetAreaBaseHeight(bonusIslandID, 2.0);
		rmSetAreaSmoothDistance(bonusIslandID, 10);
		rmSetAreaHeightBlend(bonusIslandID, 2);
		rmSetAreaCoherence(bonusIslandID, 1.0);
		rmSetAreaWarnFailure(bonusIslandID, false);
		rmBuildArea(bonusIslandID);

		int islandEmbellishmentID = rmCreateObjectDef("island embellishment");
		rmAddObjectDefItem(islandEmbellishmentID, "Baboon", 1, 8.0);
		rmAddObjectDefItem(islandEmbellishmentID, "Palm", 1, 3.0);
		rmAddObjectDefItem(islandEmbellishmentID, "Gold Mine", 1, 6.0);
		rmPlaceObjectDefAtLoc(islandEmbellishmentID, 0, 0.5, 0.5);
	}

	// Set up player areas.
	float playerAreaSize = rmAreaTilesToFraction(3000 - 50 * cNonGaiaPlayers);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		if(cNonGaiaPlayers < 3) {
			rmSetAreaSize(playerAreaID, 0.8 * playerAreaSize);
		} else {
			rmSetAreaSize(playerAreaID, 1.125 * playerAreaSize, 1.25 * playerAreaSize);
		}
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "GrassDirt25");
		rmSetAreaCoherence(playerAreaID, 0.9);
		rmSetAreaBaseHeight(playerAreaID, 2.0);
		rmSetAreaHeightBlend(playerAreaID, 2);
		rmSetAreaSmoothDistance(playerAreaID, 20);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmAddAreaConstraint(playerAreaID, avoidPlayer);
		rmSetAreaWarnFailure(playerAreaID, false);
	}

	rmBuildAllAreas();

	// Rebuild center (sea).
	int fakeCenterID = rmCreateArea("fake center");
	rmSetAreaSize(fakeCenterID, 1.0, 1.0);
	rmSetAreaCoherence(fakeCenterID, 1.0);
	rmAddAreaToClass(fakeCenterID, classCenter);
	rmAddAreaConstraint(fakeCenterID, createTerrainDistConstraint("Land", true, 1.0));
	rmSetAreaWarnFailure(fakeCenterID, false);
	rmBuildArea(fakeCenterID);

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 1; < cPlayers) {
		beautificationID = rmCreateArea("player area beautification " + i, rmAreaID("player area " + i));
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(400), rmAreaTilesToFraction(600));
		rmSetAreaLocPlayer(beautificationID, i);
		rmSetAreaTerrainType(beautificationID, "GrassDirt50");
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 1; < 10 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaTerrainType(beautificationID, "GrassA");
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
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

	// Constraints.
	int inWaterRangeMin = createEdgeDistConstraint(fakeCenterID, 18.0);
	int inWaterRangeMax = createEdgeMaxDistConstraint(fakeCenterID, 24.0);
	int notInWaterRangeMin = createEdgeDistConstraint(fakeCenterID, 37.5);

	int closeTCFairLoc = 2;
	int farTCFairLoc = 1;

	if(cNonGaiaPlayers > 2) {
		closeTCFairLoc = 1;
		farTCFairLoc = 2;
	}

	// Decide which variation to use.
	int settleInt = rmRandInt(0, 1);

	// Try 4 times.
	int numFairLocTries = 4;

	for(i = 0; < numFairLocTries) {
		// Far settlement.
		addFairLocConstraint(shortAvoidImpassableLand, farTCFairLoc);

		// Only do common constraints for avoiding/sticking close to water for 1v1, 2v2 and 3v3.
		if(cNonGaiaPlayers < 7 && gameHasTwoEqualTeams()) {
			if(i % 2 == settleInt) {
				// In water range.
				addFairLocConstraint(inWaterRangeMin, farTCFairLoc);
				addFairLocConstraint(inWaterRangeMax, farTCFairLoc);
			} else {
				// Not in water range.
				addFairLocConstraint(notInWaterRangeMin, farTCFairLoc);
			}
		}

		if(cNonGaiaPlayers < 3) {
			enableFairLocTwoPlayerCheck(0.15, farTCFairLoc);

			// Two additional variations for 1v1 (both settlements on the same side).
			if(randChance(1.0)) {
				setFairLocInterDistMin(150.0);
				addFairLoc(85.0, 125.0, true, false, 75.0, 12.0, 12.0, false, false, false, true, farTCFairLoc);
			} else {
				// Variant currently inactive - probably too extreme.
				setFairLocInterDistMin(75.0); // Fair locs of a player have to be at least 75.0 meters apart.
				setFairLocInterDistMax(150.0); // Fair locs of a player cannot be further than 150 meters apart (to remain on same side).
				addFairLoc(120.0, 140.0, true, false, 75.0, 12.0, 12.0, false, false, false, true, farTCFairLoc);
			}
		} else if(cNonGaiaPlayers < 7 && gameHasTwoEqualTeams()) {
			// For 2v2/3v3, try stricter constraints.
			addFairLocConstraint(avoidTowerLOS, farTCFairLoc);
			if(i % 2 == settleInt) {
				// In water range.
				addFairLoc(70.0, 110.0, true, false, 80.0 - 5.0 * i, 12.0, 12.0, false, false, false, true, farTCFairLoc);
			} else {
				// Not in water range, slightly bigger max range for variation (4.0 has 130.0 here).
				addFairLoc(80.0, 120.0, true, false, 80.0 - 5.0 * i, 12.0, 12.0, false, false, false, true, farTCFairLoc);
			}
		} else {
			// For weird matchups, have easier constraints.
			addFairLocConstraint(avoidTowerLOS, farTCFairLoc);
			addFairLoc(70.0, 150.0, true, false, 50.0 - 5.0 * i, 12.0, 12.0, false, false, false, true, farTCFairLoc);
		}

		// Close settlement.
		if(cNonGaiaPlayers < 3) {
			enableFairLocTwoPlayerCheck();

			// For 1v1, force close settlement away from water.
			addFairLocConstraint(createEdgeDistConstraint(fakeCenterID, 25.0), closeTCFairLoc);
			addFairLocConstraint(avoidCorner, closeTCFairLoc);
		} else if(cNonGaiaPlayers < 7 && gameHasTwoEqualTeams()) {
			// For 2v2/3v3, force close settlemtn far away from water.
			addFairLocConstraint(createEdgeDistConstraint(fakeCenterID, 45.0), closeTCFairLoc);
		} else {
			// For weird matchups, just let it avoid water.
			addFairLocConstraint(shortAvoidImpassableLand, closeTCFairLoc);
		}

		if(cNonGaiaPlayers < 3) {
			addFairLoc(60.0, 80.0, false, true, 65.0, 12.0, 12.0, false, false, false, true, closeTCFairLoc);
		} else {
			// Be less strict for close settlements because it doesn't matter all too much as long as they aren't right on top of each other.
			addFairLocConstraint(avoidTower);
			addFairLoc(60.0, 80.0, false, true, 55.0 - 5.0 * i, 12.0, 12.0, false, false, false, true, closeTCFairLoc);
		}

		if(placeObjectAtNewFairLocs(settlementID, false, "settlements " + i, i == (numFairLocTries - 1))) { // Only log last try.
			break;
		}
	}

	progress(0.4);

	// Elevation.
	int elevationID = 0;

	for(i = 0; < 20 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 1 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(80));
		if(randChance()) {
			rmSetAreaTerrainType(elevationID, "GrassDirt50");
		}
		rmSetAreaBaseHeight(elevationID, rmRandFloat(2.0, 4.0));
		rmSetAreaHeightBlend(elevationID, 1);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 5);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 40.0);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmAddAreaConstraint(elevationID, shortAvoidImpassableLand);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	progress(0.5);

	// Gold.
	// Medium gold.
	int numMediumGold = 1;

	int mediumGoldID = createObjectDefVerify("medium gold");
	addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);

	// 4.0 parameters are incredibly aggressive, use defensive here if necessary.
	// if(cNonGaiaPlayers > 4) {
		// setSimLocBias(cBiasDefensive);
	// }

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidCorner);
	addSimLocConstraint(farAvoidImpassableLand);
	// addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(farAvoidSettlement);

	addSimLoc(60.0, 75.0, avoidGoldDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold");

	// Far gold.
	int numFarGold = 1;

	int farGoldID = createObjectDefVerify("far gold");
	addObjectDefItemVerify(farGoldID, "Gold Mine", 1, 0.0);
	rmSetObjectDefMinDistance(farGoldID, 80.0);
	rmSetObjectDefMaxDistance(farGoldID, 100.0);
	rmAddObjectDefConstraint(farGoldID, avoidAll);
	rmAddObjectDefConstraint(farGoldID, avoidEdge);
	rmAddObjectDefConstraint(farGoldID, avoidCorner);
	rmAddObjectDefConstraint(farGoldID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farGoldID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(farGoldID, farAvoidGold);
	rmAddObjectDefConstraint(farGoldID, farAvoidSettlement);

	if(cNonGaiaPlayers < 5) {
		placeObjectAtPlayerLocs(farGoldID, false, numFarGold);
	}

	// Bonus gold (anywhere in player area).
	int numBonusGold = rmRandInt(1, 2);

	if(cNonGaiaPlayers > 2) {
		numBonusGold = 1;
	}

	int bonusGoldID = createObjectDefVerify("bonus gold");
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	if(cNonGaiaPlayers < 3) {
		// This constraint is ridiculous for teamgames.
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 90.0));
	}
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classCenterline, 10.0));
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
	rmAddObjectDefConstraint(bonusGoldID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusGoldID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);

	if(cNonGaiaPlayers < 5) {
		placeObjectInPlayerSplits(bonusGoldID, false, numBonusGold);
	}

	// Place separately for > 4 players.
	if(cNonGaiaPlayers > 4) {
		// 1. Place inner bonus gold.
		for(i = 1; < cPlayers) {
			if(getPlayerTeamPos(i) == cPosCenter) {
				placeObjectDefInArea(bonusGoldID, 0, rmAreaID(cSplitName + " " + i), 1);
			}
		}

		// 2. Place outer far gold.
		for(i = 1; < cPlayers) {
			if(getPlayerTeamPos(i) != cPosCenter) {
				placeObjectAtPlayerLoc(farGoldID, false, i, 1);
			}
		}

		// 3. Place bonus gold for all.
		placeObjectInTeamSplits(bonusGoldID, false, 1);
	}

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	// storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(shortAvoidImpassableLand);
	storeObjectConstraint(farAvoidGold);

	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Close hunt.
	bool huntInStartingLOS = randChance(2.0 / 3.0);

	if(randChance()) {
		storeObjectDefItem("Boar", rmRandInt(1, 3), 2.0);
	} else {
		storeObjectDefItem("Aurochs", rmRandInt(1, 2), 2.0);
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

	if(huntInStartingLOS) {
		// If we have hunt in starting LOS, we want to force it within tower ranges so we know it's within LOS.
		storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 15.0)));
		storeObjectConstraint(avoidAll);
		storeObjectConstraint(avoidEdge);
		storeObjectConstraint(shortAvoidImpassableLand);
		storeObjectConstraint(shortAvoidGold);

		placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.
	}

	// Far hunt.
	float farHuntFloat = rmRandFloat(0.0, 1.0);

	int farHuntID = createObjectDefVerify("far hunt");
	if(farHuntFloat < 0.5) {
		addObjectDefItemVerify(farHuntID, "Boar", rmRandInt(2, 3), 2.0);
	} else if(farHuntFloat < 0.8) {
		addObjectDefItemVerify(farHuntID, "Deer", rmRandInt(6, 8), 2.0);
	} else {
		addObjectDefItemVerify(farHuntID, "Aurochs", rmRandInt(1, 3), 2.0);
	}

	float farHuntMinDist = rmRandFloat(70.0, 100.0);
	float farHuntMaxDist = farHuntMinDist + 10.0;

	if(cNonGaiaPlayers < 3) {
		// Only constrain this is for 1v1.
		rmAddObjectDefConstraint(farHuntID, createClassDistConstraint(classStartingSettlement, 70.0));
		rmAddObjectDefConstraint(farHuntID, shortAvoidSettlement);
		rmAddObjectDefConstraint(farHuntID, shortAvoidGold);
	} else {
		// Reduce distance for teamgames, fails to place for center player otherwise.
		farHuntMinDist = rmRandFloat(70.0, 85.0);
		farHuntMaxDist = farHuntMinDist + 10.0;
	}

	setObjectDefDistance(farHuntID, farHuntMinDist, farHuntMaxDist);
	rmAddObjectDefConstraint(farHuntID, avoidAll);
	rmAddObjectDefConstraint(farHuntID, avoidEdge);
	rmAddObjectDefConstraint(farHuntID, avoidTowerLOS);
	rmAddObjectDefConstraint(farHuntID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farHuntID, avoidHuntable);

	placeObjectAtPlayerLocs(farHuntID);

	// Other food.
	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

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
			if(randChance()) {
				rmSetAreaForestType(playerForestID, "Oak Forest");
			} else {
				rmSetAreaForestType(playerForestID, "Pine Forest");
			}
			rmSetAreaMinBlobs(playerForestID, 1);
			rmSetAreaMaxBlobs(playerForestID, 5);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 40.0);
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
	int numRegularForests = 12 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(25), rmAreaTilesToFraction(100));
		if(randChance()) {
			rmSetAreaForestType(forestID, "Oak Forest");
		} else {
			rmSetAreaForestType(forestID, "Pine Forest");
		}
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 40.0);
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
	placeObjectInTeamSplits(farPredatorsID);

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID, false, 2);

	// Far herdables.
	placeObjectInTeamSplits(farHerdablesID, false, 3); // Team splits because player splits can be small.

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
	int playerFishLandMin = createTerrainDistConstraint("Land", true, 17.0);
	int playerFishLandMax = createTerrainMaxDistConstraint("Land", true, 19.0);

	// Place first one dead ahead so that the other 2 fit in better.
	float axisFishDist = 65.0;
	float axisDistIncr = 1.0;

	for(i = 1; < cPlayers) {
		int axisFishID = rmCreateObjectDef("player axis fish " + i);
		rmAddObjectDefItem(axisFishID, "Fish - Mahi", 3, 5.0);
		// rmAddObjectDefConstraint(axisFishID, avoidTowerLOS);
		rmAddObjectDefConstraint(axisFishID, playerFishLandMin);
		rmAddObjectDefConstraint(axisFishID, playerFishLandMax);

		for(k = 0; < 1000) {
			float fishRadius = rmXMetersToFraction(axisFishDist + axisDistIncr * k);
			float fishAngle = rmRandFloat(0.97, 1.03) * PI;

			float x = getXFromPolarForPlayer(i, fishRadius, fishAngle);
			float z = getZFromPolarForPlayer(i, fishRadius, fishAngle);

			if(placeObjectForPlayer(axisFishID, 0, x, z)) {
				printDebug("axisFish: i = " + i + ", k = " + k, cDebugTest);
				break;
			}
		}
	}

	// Additional player fish.
	int numPlayerFish = 2;
	int avoidPlayerFish = createTypeDistConstraint("Fish", 22.0);

	float fishDist = 67.5; // Depends on player area size (consider converting the area size to a radius for this).
	float fishDistIncr = 2.5;

	if(cNonGaiaPlayers > 8) {
		numPlayerFish = 1;
	} else if(cNonGaiaPlayers > 4) {
		fishDist = 72.5;
		avoidPlayerFish = createTypeDistConstraint("Fish", 20.0);
	} else if(cNonGaiaPlayers > 2) {
		fishDist = 77.5;
	}

	// Ugly trick to place first for inside players.
	// We don't have to reset this because it will be overwritten the next time simLocs are created.
	// setSimLocInsideOut(1, false);
	setSimLocPlayerOrder(1);

	// Angle range could be further improved/adjusted based on playerTeamPos, but it's rather difficult to find a decent solution.
	setPlaceObjectAngleRange(0.7, 1.3);

	for(i = 1; < cPlayers) {
		int p = getSimLocPlayer(1, i);

		// Don't verify this. If necessary, handle separately (depending on fishFailCount).
		int playerFishID = rmCreateObjectDef("player fish " + p);
		rmAddObjectDefItem(playerFishID, "Fish - Mahi", 3, 5.0);
		rmAddObjectDefConstraint(playerFishID, playerFishLandMin);
		rmAddObjectDefConstraint(playerFishID, playerFishLandMax);
		rmAddObjectDefConstraint(playerFishID, avoidPlayerFish);

		int fishFailCount = 0;
		int oldCount = 0;
		int newCount = 0;

		for(k = 1; < 50) {
			// Use circular instead of square placement, expand search radius if we fail.
			placeObjectDefForPlayer(p, playerFishID, false, 1, fishDist, fishDist + fishDistIncr * (fishFailCount + 1), false, false, 250);

			newCount = rmGetNumberUnitsPlaced(playerFishID);

			if(newCount / 3 >= numPlayerFish) {
				printDebug("playerFish: p = " + p + ", k = " + k, cDebugTest);
				break;
			} else if(newCount == oldCount) {
				fishFailCount++;
			} else {
				printDebug("placed at k = " + k, cDebugTest);
			}

			oldCount = newCount;
		}
	}

	resetPlaceObjectAngle();

	// Center fish
	int avoidFish = createTypeDistConstraint("Fish", 18.0);
	int fishLandMin = createTerrainDistConstraint("Land", true, 14.0);

	if(cNonGaiaPlayers > 4) {
		fishLandMin = createTerrainDistConstraint("Land", true, 17.0);
	}

	// Consider verifying this for 1v1.
	int fishID = rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "Fish - Perch", 2, 9.0);
	if(cNonGaiaPlayers < 3) {
		setObjectDefDistanceToMax(fishID);
	} else {
		setObjectDefDistance(fishID, 7.5 * cNonGaiaPlayers, rmXFractionToMeters(0.5));
	}
	rmAddObjectDefConstraint(fishID, fishLandMin);
	rmAddObjectDefConstraint(fishID, avoidFish);
	if(cNonGaiaPlayers < 3) { // 1v1.
		rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 4 * cNonGaiaPlayers);
	} else if(cNonGaiaPlayers == 6) { // 3v3 (or anything with 6 players really).
		rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 3 * cNonGaiaPlayers + (cNonGaiaPlayers / 2) + ((cNonGaiaPlayers / 2) % 2));
	} else { // Everything else.
		rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 4 * cNonGaiaPlayers + (cNonGaiaPlayers / 2) + ((cNonGaiaPlayers / 2) % 2));
	}

	progress(0.9);

	// Embellishment.
	// Flower beautification. This has to be placed later than the other terrain embellishment due to objects avoiding flowers.
	for(i = 1; < 10 * cPlayers) {
		beautificationID = rmCreateArea("flower beautification " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(5), rmAreaTilesToFraction(20));
		rmSetAreaTerrainType(beautificationID, "GrassB");
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, avoidAll);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);

		int insideBeautificationID = rmCreateObjectDef("grass" + i);
		rmAddObjectDefItem(insideBeautificationID, "Grass", rmRandInt(2, 4), 5.0);
		rmAddObjectDefItem(insideBeautificationID, "Flowers", rmRandInt(0, 6), 5.0);
		rmAddObjectDefConstraint(insideBeautificationID, avoidAll);
		rmPlaceObjectDefInArea(insideBeautificationID, 0, beautificationID);
	}

	// Lone hunt.
	int loneHuntID = rmCreateObjectDef("lone hunt");
	rmAddObjectDefItem(loneHuntID, "Deer", 1, 0.0);
	setObjectDefDistanceToMax(loneHuntID);
	rmAddObjectDefConstraint(loneHuntID, avoidAll);
	rmAddObjectDefConstraint(loneHuntID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(loneHuntID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(loneHuntID, shortAvoidSettlement);
	rmAddObjectDefConstraint(loneHuntID, avoidFood);
	rmPlaceObjectDefAtLoc(loneHuntID, 0, 0.5, 0.5, cNonGaiaPlayers);

	// Grass.
	int grassID = rmCreateObjectDef("grass");
	rmAddObjectDefItem(grassID, "Grass", 3, 4.0);
	setObjectDefDistanceToMax(grassID);
	rmAddObjectDefConstraint(grassID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(grassID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(grassID, createTypeDistConstraint("Grass", 12.0));
	rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 20 * cNonGaiaPlayers);

	// Rocks.
	int avoidRock = createTypeDistConstraint("Rock Limestone Sprite", 8.0);

	int rockGrassID = rmCreateObjectDef("rock sprite and grass");
	rmAddObjectDefItem(rockGrassID, "Rock Limestone Sprite", 1, 1.0);
	rmAddObjectDefItem(rockGrassID, "Grass", 2, 1.0);
	setObjectDefDistanceToMax(rockGrassID);
	rmAddObjectDefConstraint(rockGrassID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockGrassID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(rockGrassID, avoidRock);
	rmPlaceObjectDefAtLoc(rockGrassID, 0, 0.5, 0.5, 15 * cNonGaiaPlayers);

	int rockGroupID = rmCreateObjectDef("rock group");
	rmAddObjectDefItem(rockGroupID, "Rock Limestone Sprite", 3, 2.0);
	setObjectDefDistanceToMax(rockGrassID);
	rmAddObjectDefConstraint(rockGroupID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockGroupID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(rockGroupID, avoidRock);
	rmPlaceObjectDefAtLoc(rockGroupID, 0, 0.5, 0.5, 9 * cNonGaiaPlayers);

	// Seaweed.
	int seaweedShoreMin = createTerrainDistConstraint("Land", true, 10.0);
	int seaweedShoreMax = createTerrainMaxDistConstraint("Land", true, 14.0);

	int seaweed1ID = rmCreateObjectDef("seaweed 1");
	rmAddObjectDefItem(seaweed1ID, "Seaweed", 12, 6.0);
	setObjectDefDistanceToMax(seaweed1ID);
	rmAddObjectDefConstraint(seaweed1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(seaweed1ID, seaweedShoreMin);
	rmAddObjectDefConstraint(seaweed1ID, seaweedShoreMax);
	rmPlaceObjectDefAtLoc(seaweed1ID, 0, 0.5, 0.5, 3 * cNonGaiaPlayers);

	int seaweed2ID = rmCreateObjectDef("seaweed 2");
	rmAddObjectDefItem(seaweed2ID, "Seaweed", 5, 3.0);
	setObjectDefDistanceToMax(seaweed2ID);
	rmAddObjectDefConstraint(seaweed2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(seaweed2ID, seaweedShoreMin);
	rmAddObjectDefConstraint(seaweed2ID, seaweedShoreMax);
	rmPlaceObjectDefAtLoc(seaweed2ID, 0, 0.5, 0.5, 6 * cNonGaiaPlayers);

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
