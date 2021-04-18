/*
** FROZEN WASTES
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

// Override backward town center angles because we can't place backwards.

mutable float randBackInsideFirst(float tol = 0.0) {
	return(rmRandFloat(-0.05 - 0.95 * tol, 0.3 + 0.7 * tol) * PI);
}

mutable float randBackOutsideFirst(float tol = 0.0) {
	return(rmRandFloat(1.7 - 0.7 * tol, 2.05 + 0.95 * tol) * PI);
}

mutable float randBackInsideLast(float tol = 0.0) {
	return(rmRandFloat(1.7 - 0.7 * tol, 2.05 + 0.95 * tol) * PI);
}

mutable float randBackOutsideLast(float tol = 0.0) {
	return(rmRandFloat(-0.05 - 0.95 * tol, 0.3 + 0.7 * tol) * PI);
}

mutable float randBackCenter(float tol = 0.0) {
	if(tol == 0.0) {
		return(rmRandFloat(-0.3, 0.3) * PI);
	} else {
		return(randFromIntervals(-0.3 - tol * 0.7, -0.3, 0.3, 0.3 + tol * 0.7) * PI);
	}
}

mutable float randBackInsideSingle(float tol = 0.0) {
	return(rmRandFloat(-0.4 - 0.6 * tol, 0.4 + 0.6 * tol) * PI);

}

mutable float randBackOutsideSingle(float tol = 0.0) {
	return(rmRandFloat(-0.4 - 0.6 * tol, 0.4 + 0.6 * tol) * PI);
}

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Frozen Wastes (by RebelsRising & Flame)");

	// Set size.
	int axisLength = getStandardMapDimInMeters(9600);

	// Initialize map.
	initializeMap("IceA", axisLength);

	// Set lighting.
	rmSetLightingSet("Alfheim");

	// Player placement.
	if(cNonGaiaPlayers < 3) {
		if(randChance()) {
			placePlayersInLine(0.25, 0.25, 0.75, 0.75);
		} else {
			placePlayersInLine(0.25, 0.75, 0.75, 0.25);
		}
	} else if(cNonGaiaPlayers < 5) {
		placePlayersInCircle(0.325, 0.325, 0.9);
	} else {
		placePlayersInCircle(0.375, 0.375, 0.85);
	}

	// Control areas.
	int classCenter = initializeCenter(30.0 * sqrt(1.5 * cNonGaiaPlayers)); // Normal center; scale for hunt.
	int classCorner = initializeCorners();
	int classTeamSplit = initializeTeamSplit(50.0);
	int classCenterline = initializeCenterline(false); // Build on team splits.

	// Classes.
	int classContinent = rmDefineClass("continent"); // Buildable center area.
	int classPlayer = rmDefineClass("player");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classForest = rmDefineClass("forest");

	// Build center area here already as constraints depend on it.
	int continentID = rmCreateArea("continent");
	rmSetAreaSize(continentID, 0.525);
	rmSetAreaLocation(continentID, 0.5, 0.5);
	rmSetAreaTerrainType(continentID, "SnowB");
	if(cNonGaiaPlayers > 4) {
		rmSetAreaCoherence(continentID, 0.4);
	}
	rmSetAreaSmoothDistance(continentID, 30);
	rmAddAreaToClass(continentID, classContinent);
	rmAddAreaConstraint(continentID, createSymmetricBoxConstraint(rmXTilesToFraction(12), rmZTilesToFraction(12), 0.01));
	rmSetAreaWarnFailure(continentID, false);
	rmBuildArea(continentID);

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(1), rmZTilesToFraction(1)); // Bare minimum.
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);
	int avoidPlayer = createClassDistConstraint(classPlayer, 1.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);

	// Terrain.
	int forceOnContinent = createAreaConstraint(continentID);
	int avoidContinentEdge = createEdgeDistConstraint(continentID, 5.0);
	int avoidContinent = createClassDistConstraint(classContinent, 1.0);

	// Gold.
	float avoidGoldDist = 40.0;

	int shortAvoidGold = createTypeDistConstraint("Gold", 10.0);
	int farAvoidGold = createTypeDistConstraint("Gold", avoidGoldDist);
	int goldEdgeMinDist = createEdgeDistConstraint(continentID, 10.0);
	int goldEdgeMaxDist = createEdgeMaxDistConstraint(continentID, 20.0);

	// Food.
	float avoidHuntDist = 40.0;

	int avoidHuntable = createTypeDistConstraint("Huntable", avoidHuntDist);
	int avoidHerdable = createTypeDistConstraint("Herdable", 40.0); // Higher than on other maps.
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
	rmAddObjectDefConstraint(startingTowerID, avoidAll);
	rmAddObjectDefConstraint(startingTowerID, avoidTower);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(5, 8), 2.0);
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting hunt.
	int startingHuntID = createObjectDefVerify("close hunt");
	addObjectDefItemVerify(startingHuntID, "Caribou", rmRandInt(4, 8), 2.0);
	setObjectDefDistance(startingHuntID, 25.0, 30.0);
	rmAddObjectDefConstraint(startingHuntID, avoidAll);
	rmAddObjectDefConstraint(startingHuntID, shortAvoidGold);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Goat", 2, 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Pine Snow", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Far berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", rmRandInt(6, 10), 4.0);

	float farBerryMinDist = rmRandFloat(70.0, 90.0);
	float farBerryMaxDist =  farBerryMinDist + 10.0;

	setObjectDefDistance(farBerriesID, farBerryMinDist, farBerryMaxDist);
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, forceOnContinent);
	rmAddObjectDefConstraint(farBerriesID, avoidContinentEdge);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farBerriesID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Medium herdables (only verify for 1v1 because there are so many).
	int mediumHerdablesID = createObjectDefVerify("medium herdables", cNonGaiaPlayers < 3);
	addObjectDefItemVerify(mediumHerdablesID, "Goat", 2, 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 135.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidContinent);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidContinentEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, createTypeDistConstraint("Herdable", 50.0));

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Goat", rmRandInt(2, 3), 4.0);
	setObjectDefDistance(farHerdablesID, 80.0, 120.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, forceOnContinent);
	rmAddObjectDefConstraint(farHerdablesID, createEdgeDistConstraint(continentID, 10.0));
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	addObjectDefItemVerify(farPredatorsID, "Polar Bear", 1, 0.0);
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, forceOnContinent);
	rmAddObjectDefConstraint(farPredatorsID, avoidContinentEdge);
	rmAddObjectDefConstraint(farPredatorsID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredatorsID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredatorsID, avoidFood);
	rmAddObjectDefConstraint(farPredatorsID, avoidPredator);

	// Other objects.
	// Relics.
	int relicID = createObjectDefVerify("relic");
	addObjectDefItemVerify(relicID, "Relic", 1, 0.0);
	rmAddObjectDefConstraint(relicID, avoidAll);
	rmAddObjectDefConstraint(relicID, forceOnContinent);
	rmAddObjectDefConstraint(relicID, avoidContinentEdge);
	rmAddObjectDefConstraint(relicID, avoidCorner);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random trees.
	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "Pine Snow", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, forceOnContinent);
	rmAddObjectDefConstraint(randomTreeID, avoidContinentEdge);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, treeAvoidSettlement);

	progress(0.1);

	// Set up player areas.
	float playerAreaSize = rmAreaTilesToFraction(1500);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "SnowA");
		// rmSetAreaTerrainType(playerAreaID, "HadesBuildable1");
		rmSetAreaCoherence(playerAreaID, 0.8);
		rmSetAreaSmoothDistance(playerAreaID, 5);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmSetAreaWarnFailure(playerAreaID, false);
	}

	rmBuildAllAreas();

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaTerrainType(beautificationID, "SnowA");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(75), rmAreaTilesToFraction(150));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, forceOnContinent);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaTerrainType(beautificationID, "IceB");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(75), rmAreaTilesToFraction(150));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, avoidPlayer);
		rmAddAreaConstraint(beautificationID, avoidContinent);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	progress(0.2);

	// Starting settlement.
	placeObjectAtPlayerLocs(startingSettlementID, true);

	// Towers and starting gold.
	// Starting gold.
	int numStartingGold = rmRandInt(1, 2);

	if(cNonGaiaPlayers > 2) {
		numStartingGold = 1;
	}

	// Object definition.
	int startingGoldID = rmCreateObjectDef("starting gold");
	rmAddObjectDefItem(startingGoldID, "Gold Mine Small", 1, 0.0);
	// setObjectDefDistance(startingGoldID, 21.0, 24.0); // Given as args for placeObjectDefPerPlayer().
	rmAddObjectDefConstraint(startingGoldID, avoidAll);
	rmAddObjectDefConstraint(startingGoldID, createTypeDistConstraint("Gold", 20.0));

	// Place first one within [-0.55, 0.55] * PI (backwards w.r.t. the players).
	setPlaceObjectAngleRange(-0.55, 0.55);
	placeAndStoreObjectAtPlayerLocs(startingGoldID, true, 1, 22.0, 25.0, true);

	// Place second one for 1v1 if randomized.
	if(numStartingGold == 2 && cNonGaiaPlayers < 3) {
		setPlaceObjectAngleRange(-0.55, 0.55);
		placeObjectDefPerPlayer(startingGoldID, false, 1, 22.0, 25.0, true);
	}

	// One starting tower near starting gold.
	storeObjectDefItem("Tower", 1, 0.0);
	storeObjectConstraint(avoidAll); // No need to avoid towers because it's the first one we place.

	placeStoredObjectNearStoredLocs(1, true, 23.0, 27.0, 12.5, true);

	// Remaining 3 towers.
	placeObjectAtPlayerLocs(startingTowerID, true, 3);

	progress(0.3);

	// Settlements.
	int settlementID = rmCreateObjectDef("settlements");
	rmAddObjectDefItem(settlementID, "Settlement", 1, 0.0);

	// Bonus settlement for teamgames.
	// if(cNonGaiaPlayers > 2) {
		// placeObjectDefAtLoc(settlementID, 0, 0.5, 0.5);
	// }

	// Close settlement.
	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers > 2) {
		addFairLocConstraint(avoidTowerLOS);
	}

	addFairLocConstraint(forceOnContinent);
	addFairLocConstraint(createEdgeDistConstraint(continentID, 30.0));

	if(cNonGaiaPlayers < 3) {
		addFairLoc(60.0, 65.0, false, true, 70.0, 0.0, 0.0, true);
	} else if(cNonGaiaPlayers < 5 ) {
		addFairLocConstraint(createEdgeDistConstraint(continentID, 40.0));
		addFairLoc(60.0, 80.0, false, true, 55.0, 0.0, 0.0, false, false, false, true);
	} else {
		addFairLoc(60.0, 80.0, false, true, 55.0, 0.0, 0.0, false, false, false, true);
	}

	// Far settlement.
	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(forceOnContinent);
	addFairLocConstraint(createTypeDistConstraint("AbstractSettlement", 60.0));
	addFairLocConstraint(createEdgeDistConstraint(continentID, 30.0));

	enableFairLocTwoPlayerCheck();

	// For anything but 1v1, the forward/backward variation has no impact because the map is so small.
	if(cNonGaiaPlayers < 3) {
		addFairLoc(80.0, 120.0, true, false, 70.0);
	} else if(cNonGaiaPlayers < 5) {
		addFairLoc(70.0, 85.0, true, randChance(), 70.0, 0.0, 0.0, false, gameHasTwoEqualTeams());
	} else {
		addFairLoc(75.0, 90.0, true, true, 70.0, 0.0, 0.0, false, gameHasTwoEqualTeams());
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
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmAddAreaConstraint(elevationID, forceOnContinent);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	progress(0.5);

	// Gold.
	if(cNonGaiaPlayers < 3) {
		// 1v1.
		// First (medium).
		int mediumGoldID = createObjectDefVerify("medium gold");
		addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);

		addSimLocConstraint(avoidAll);
		addSimLocConstraint(shortAvoidSettlement);
		addSimLocConstraint(forceOnContinent);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(goldEdgeMinDist);
		addSimLocConstraint(goldEdgeMaxDist);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));

		setSimLocBias(cBiasForward);
		enableSimLocTwoPlayerCheck();
		setSimLocInterval(10.0);

		// Make this dependent on staring gold (50.0 + 10.0 * numStartingGold).
		addSimLoc(50.0 + 10.0 * numStartingGold, 60.0 + 10.0 * numStartingGold, avoidGoldDist, 12.0, 12.0, false, false, true);

		placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold 1");

		addSimLocConstraint(avoidAll);
		addSimLocConstraint(shortAvoidSettlement);
		addSimLocConstraint(forceOnContinent);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(goldEdgeMinDist);
		addSimLocConstraint(goldEdgeMaxDist);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));

		setSimLocBias(cBiasForward);
		enableSimLocTwoPlayerCheck();
		setSimLocInterval(10.0);

		addSimLoc(50.0 + 10.0 * numStartingGold, 70.0 + 10.0 * numStartingGold, avoidGoldDist, 12.0, 12.0, false, false, true);

		placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold 2");

		addSimLocConstraint(avoidAll);
		addSimLocConstraint(shortAvoidSettlement);
		addSimLocConstraint(forceOnContinent);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(goldEdgeMinDist);
		addSimLocConstraint(goldEdgeMaxDist);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 70.0));

		setSimLocBias(cBiasForward);

		addSimLoc(105.0, 135.0, avoidGoldDist, 12.0, 12.0, false, false, true);

		placeObjectAtNewSimLocs(mediumGoldID, false, "far gold 1");

		if(randChance()) {
			addSimLocConstraint(avoidAll);
			addSimLocConstraint(shortAvoidSettlement);
			addSimLocConstraint(forceOnContinent);
			addSimLocConstraint(avoidTowerLOS);
			addSimLocConstraint(farAvoidGold);
			addSimLocConstraint(goldEdgeMinDist);
			addSimLocConstraint(goldEdgeMaxDist);
			addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 70.0));

			setSimLocBias(cBiasForward);

			addSimLoc(105.0, 165.0, 30.0, 12.0, 12.0, false, false, true);

			placeObjectAtNewSimLocs(mediumGoldID, false, "far gold 2", false);
		}
	} else {
		// Teamgames.
		// Ugly trick to place first for inside players.
		// We don't have to reset this because it will be overwritten the next time simLocs are created.
		setSimLocPlayerOrder(1);

		int mediumSideGoldID = createObjectDefVerify("side gold");
		addObjectDefItemVerify(mediumSideGoldID, "Gold Mine", 1, 0.0);
		rmAddObjectDefConstraint(mediumSideGoldID, avoidAll);
		rmAddObjectDefConstraint(mediumSideGoldID, createTypeDistConstraint("Gold", 30.0));
		rmAddObjectDefConstraint(mediumSideGoldID, shortAvoidSettlement);
		rmAddObjectDefConstraint(mediumSideGoldID, avoidTowerLOS);
		rmAddObjectDefConstraint(mediumSideGoldID, forceOnContinent);
		rmAddObjectDefConstraint(mediumSideGoldID, goldEdgeMinDist);
		rmAddObjectDefConstraint(mediumSideGoldID, goldEdgeMaxDist);

		for(i = 1; < cPlayers) {
			int p = getSimLocPlayer(1, i);

			// Side/single players: One on both sides.
			if(getPlayerTeamPos(p) != cPosCenter) {
				// Inner.
				if(getPlayerTeamPos(p) == cPosFirst) {
					setPlaceObjectAngleRange(0.2, 0.8);
				} else if(getPlayerTeamPos(p) == cPosLast) {
					setPlaceObjectAngleRange(1.2, 1.8);
				}

				if(cNonGaiaPlayers < 5) {
					placeObjectDefForPlayer(p, mediumSideGoldID, false, 1, 50.0, 90.0);
				} else {
					placeObjectDefForPlayer(p, mediumSideGoldID, false, 1, 50.0, 90.0);
				}

				// Outer.
				if(getPlayerTeamPos(p) == cPosFirst) {
					setPlaceObjectAngleRange(1.2, 1.8);
				} else if(getPlayerTeamPos(p) == cPosLast) {
					setPlaceObjectAngleRange(0.2, 0.8);
				}

				// Do not touch these numbers or the order here.
				if(cNonGaiaPlayers < 5) {
					placeObjectDefForPlayer(p, mediumSideGoldID, false, 1, 55.0, 80.0);
					placeObjectDefForPlayer(p, mediumSideGoldID, false, 1, 95.0, 115.0);
				} else {
					placeObjectDefForPlayer(p, mediumSideGoldID, false, 1, 105.0, 115.0);
					placeObjectDefForPlayer(p, mediumSideGoldID, false, 1, 55.0, 95.0);
				}
			} else {
				// TODO Place center player gold here?
			}
		}

		resetPlaceObjectAngle();
	}

	progress(0.6);

	// Food.
	// Bonus walrus (only verify for 1v1, plenty of objects anyway in teamgames).
	int numBonusWalrus = 1;

	if(cNonGaiaPlayers > 2) {
		numBonusWalrus = 2;
	}

	int bonusHuntID = createObjectDefVerify("bonus hunt", cNonGaiaPlayers < 3 || cDebugMode >= cDebugFull);
	addObjectDefItemVerify(bonusHuntID, "Walrus", rmRandInt(3, 4), 2.0);
	rmAddObjectDefConstraint(bonusHuntID, avoidAll);
	rmAddObjectDefConstraint(bonusHuntID, createClassDistConstraint(classStartingSettlement, 65.0));
	rmAddObjectDefConstraint(bonusHuntID, createTypeDistConstraint("Huntable", 30.0));
	rmAddObjectDefConstraint(bonusHuntID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusHuntID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusHuntID, createAreaConstraint(rmAreaID(cCenterName)));

	placeObjectInPlayerSplits(bonusHuntID, false, numBonusWalrus);

	// Medium hunt.
	int numMediumHunt = rmRandInt(1, 2);

	if(cNonGaiaPlayers > 2) {
		numMediumHunt = 1;
	}

	int mediumHuntID = createObjectDefVerify("medium hunt");
	if(randChance()) {
		addObjectDefItemVerify(mediumHuntID, "Elk", rmRandInt(5, 8), 2.0);
	} else {
		addObjectDefItemVerify(mediumHuntID, "Caribou", rmRandInt(5, 8), 2.0);
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(forceOnContinent);
	addSimLocConstraint(avoidContinentEdge);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 65.0));
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(shortAvoidGold);

	enableSimLocTwoPlayerCheck();

	addSimLoc(65.0, 80.0, avoidHuntDist, 0.0, 0.0, false, false, true);

	if(numMediumHunt == 2) {
		applySimLocConstraintsToObject(mediumHuntID);
		rmAddObjectDefConstraint(mediumHuntID, avoidCenterline);
		placeObjectInPlayerSplits(mediumHuntID, false, 2);
	} else {
		placeObjectAtNewSimLocs(mediumHuntID, false, "medium hunt");
	}

	resetSimLocs();

	// Other food.
	// Starting hunt (forward so it doesn't get on the ice).
	setPlaceObjectAngleRange(0.7, 1.3);
	placeObjectDefPerPlayer(startingHuntID, false, 1, 25.0, 30.0, true);

	// Far berries.
	placeObjectAtPlayerLocs(farBerriesID);

	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

	progress(0.7);

	// Player forest.
	int numPlayerForests = 3;

	for(i = 1; < cPlayers) {
		int playerForestAreaID = rmCreateArea("player forest area " + i);
		rmSetAreaSize(playerForestAreaID, rmAreaTilesToFraction(1500));
		rmSetAreaLocPlayer(playerForestAreaID, getPlayer(i));
		rmSetAreaCoherence(playerForestAreaID, 1.0);
		rmSetAreaWarnFailure(playerForestAreaID, false);
		rmBuildArea(playerForestAreaID);

		for(j = 0; < numPlayerForests) {
			int playerForestID = rmCreateArea("player forest " + i + " " + j, playerForestAreaID);
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
			rmSetAreaForestType(playerForestID, "Snow Pine Forest");
			rmSetAreaMinBlobs(playerForestID, 1);
			rmSetAreaMaxBlobs(playerForestID, 3);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 25.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, avoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmSetAreaWarnFailure(playerForestID, false);
			rmBuildArea(playerForestID);
		}
	}

	// Other forest.
	int numRegularForests = 11 - numPlayerForests;
	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaForestType(forestID, "Snow Pine Forest");
		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 3);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 25.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, forceOnContinent);
		rmAddAreaConstraint(forestID, avoidContinentEdge);
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
	if(cNonGaiaPlayers < 3) {
		placeObjectInPlayerSplits(farPredatorsID, false, 2);
	} else {
		placeObjectInPlayerSplits(farPredatorsID, false, 1);
	}

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID, false, 4);

	// Far herdables.
	placeObjectAtPlayerLocs(farHerdablesID, false, rmRandInt(1, 2));

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
	// Rocks
	int rock1ID = rmCreateObjectDef("rock small");
	rmAddObjectDefItem(rock1ID, "Rock Granite Small", 1, 0.0);
	setObjectDefDistanceToMax(rock1ID);
	rmAddObjectDefConstraint(rock1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rock1ID, forceOnContinent);
	rmPlaceObjectDefAtLoc(rock1ID, 0, 0.5, 0.5, 20 * cNonGaiaPlayers);

	int rock2ID = rmCreateObjectDef("rock sprite");
	rmAddObjectDefItem(rock2ID, "Rock Granite Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rock2ID);
	rmAddObjectDefConstraint(rock2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rock2ID, forceOnContinent);
	rmPlaceObjectDefAtLoc(rock2ID, 0, 0.5, 0.5, 30 * cNonGaiaPlayers);

	// Drifts
	int driftID = rmCreateObjectDef("drift");
	rmAddObjectDefItem(driftID, "Snow Drift", 1, 0.0);
	setObjectDefDistanceToMax(driftID);
	rmAddObjectDefConstraint(driftID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(driftID, forceOnContinent);
	rmAddObjectDefConstraint(driftID, avoidContinentEdge);
	rmAddObjectDefConstraint(driftID, avoidBuildings);
	rmAddObjectDefConstraint(driftID, createTypeDistConstraint("Snow Drift", 25.0));
	rmPlaceObjectDefAtLoc(driftID, 0, 0.5, 0.5, 4 * cNonGaiaPlayers);

	// Birds
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
	if(cNonGaiaPlayers < 3) {
		addProtoPlacementCheck("Settlement", 2 * cNonGaiaPlayers, 0);
	} else {
		// Adjust this if we place an additional settlement in the center.
		addProtoPlacementCheck("Settlement", 2 * cNonGaiaPlayers, 0);
	}

	// Finalize RM X.
	injectSnow(0.1);
	rmxFinalize();

	progress(1.0);
}
