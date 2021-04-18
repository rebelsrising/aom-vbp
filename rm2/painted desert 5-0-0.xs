/*
** PAINTED DESERT
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

const int cSkewLeftRight = 0;
const int cSkewRightLeft = 1;

// Settlement connections for 1v1.
int connectionID1 = 0;
int connectionID2 = 0;

int getConnectionID(int n = 0) {
	if(n == 1) return(connectionID1);
	if(n == 2) return(connectionID2);
	return(-1);
}

void setConnectionID(int i = 0, int id = 0) {
	if(i == 1) connectionID1 = id;
	if(i == 2) connectionID2 = id;
}

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Painted Desert (by RebelsRising & Flame)");

	// Find maximum players on team.
	int maxPlayersOnTeam = getLargestTeamSize();

	// Set size; scale according to largest team instead of just using cNonGaiaPlayers.
	int axisLength = getStandardMapDimInMeters(9600, 1.0, 2.0, 1.3, min(2 * maxPlayersOnTeam, 12));
	int backAxisLength = axisLength;

	// Stretch back/front axis if any team has > 2 players.
	float stretchFactor = 1.0;

	if(maxPlayersOnTeam > 2) {
		stretchFactor = 1.1;
	}

	// Random skew.
	int skew = rmRandInt(0, 1);

	// Initialize map.
	if(skew == cSkewLeftRight) {
		initializeMap("SandC", axisLength, backAxisLength * stretchFactor);
	} else {
		initializeMap("SandC", backAxisLength * stretchFactor, axisLength);
	}

	// Player placement.
	if(cNonGaiaPlayers < 3) {
		// Potentially merge with else if section.
		if(skew == cSkewLeftRight) {
			placePlayersInLine(0.2, 0.5, 0.8, 0.5);
		} else {
			placePlayersInLine(0.5, 0.2, 0.5, 0.8);
		}
	} else if(cTeams == 2) {
		int teamInt = rmRandInt(0, 1);

		placeTeamInCircle(teamInt, 0.325, 0.10 + 0.04 * getNumberPlayersOnTeam(teamInt), 0.0 + 0.5 * PI * skew);
		placeTeamInCircle(1 - teamInt, 0.325, 0.10 + 0.04 * getNumberPlayersOnTeam(1 - teamInt), PI + 0.5 * PI * skew);
	} else {
		placePlayersInCircle(0.25);
	}

	// Control areas.
	int classCenter = initializeCenter();
	int classCorner = initializeCorners();
	int classTeamSplit = initializeTeamSplit(10.0);
	int classCenterline = initializeCenterline(false); // Build on team split.

	// Classes.
	int classConnection = rmDefineClass("connection");
	int classPlayer = rmDefineClass("player");
	int classStartingSettlement = rmDefineClass("starting settlement");
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
	int shortAvoidImpassableLand = createTerrainDistConstraint("Land", false, 5.0);
	int farAvoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);

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
	int shortAvoidForest = createClassDistConstraint(classForest, 5.0);
	int mediumAvoidForest = createClassDistConstraint(classForest, 10.0);
	int farAvoidForest = createClassDistConstraint(classForest, 20.0);
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
	rmAddObjectDefConstraint(startingTowerID, farAvoidImpassableLand);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	addObjectDefItemVerify(startingFoodID, "Chicken", rmRandInt(7, 10), 4.0);
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting hunt.
	int startingHuntID = createObjectDefVerify("starting hunt");
	if(randChance()) {
		addObjectDefItemVerify(startingHuntID, "Rhinocerous", rmRandInt(1, 2), 2.0);
		addObjectDefItemVerify(startingHuntID, "Zebra", rmRandInt(0, 2), 2.0);
	} else {
		addObjectDefItemVerify(startingHuntID, "Zebra", rmRandInt(4, 6), 2.0);
	}
	setObjectDefDistance(startingHuntID, 26.0, 29.0);
	rmAddObjectDefConstraint(startingHuntID, avoidAll);
	rmAddObjectDefConstraint(startingHuntID, avoidEdge);
	rmAddObjectDefConstraint(startingHuntID, farAvoidImpassableLand);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Goat", rmRandInt(1, 3), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, shortAvoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Palm", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Goat", rmRandInt(1, 2), 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Goat", rmRandInt(0, 3), 4.0);
	// setObjectDefDistance(farHerdablesID, 70.0, 90.0); // Place in split.
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	addObjectDefItemVerify(farPredatorsID, "Hyena", 2, 4.0);
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, shortAvoidImpassableLand);
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

	// Define 1v1 connections to third settlement.
	if(cNonGaiaPlayers < 3) {
		for(i = 1; < cPlayers) {
			int connectionID = rmCreateConnection("connection " + i);
			rmSetConnectionType(connectionID, cConnectAreas, false, 1.0);
			// rmAddConnectionTerrainReplacement(connectionID, "SandC", "HadesBuildable1");
			rmSetConnectionWidth(connectionID, 8.0, 0.0);
			rmSetConnectionCoherence(connectionID, 1.0);
			rmAddConnectionToClass(connectionID, classConnection);
			rmSetConnectionWarnFailure(connectionID, false);

			// Store in array (don't map to getPlayer()).
			setConnectionID(i, connectionID);
		}
	}

	// Set up player areas.
	float playerAreaSize = rmAreaTilesToFraction(1600);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, 0.9 * playerAreaSize, 1.1 * playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		// rmSetAreaTerrainType(playerAreaID, "HadesBuildable1");
		rmSetAreaCoherence(playerAreaID, 1.0);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmSetAreaWarnFailure(playerAreaID, false);

		// Add player area to corresponding connection for 1v1.
		if(cNonGaiaPlayers < 3) {
			rmAddConnectionArea(getConnectionID(i), playerAreaID);
		}
	}

	rmBuildAllAreas();

	// Oceans.
	float oceanOffset = 0.01; // Note that area sizes behave differently when placed at/outside of map boundaries.
	float oceanSize = 0.125;
	float tempOceanOffset = oceanOffset; // Use temp variable, leave oceanOffset as is.

	// Have this in a loop so we can easily adjust area properties.
	for(i = 0; < 2) {
		int oceanID = rmCreateArea("ocean " + i);
		rmSetAreaSize(oceanID, oceanSize);
		rmSetAreaWaterType(oceanID, "Egyptian Nile");
		rmSetAreaCoherence(oceanID, 1.0);
		rmSetAreaWarnFailure(oceanID, false);

		if(skew == cSkewLeftRight) {
			rmSetAreaLocation(oceanID, 0.5, tempOceanOffset);
			rmAddAreaInfluenceSegment(oceanID, 0.0, tempOceanOffset, 1.0, tempOceanOffset);
		} else {
			rmSetAreaLocation(oceanID, tempOceanOffset, 0.5);
			rmAddAreaInfluenceSegment(oceanID, tempOceanOffset, 0.0, tempOceanOffset, 1.0);
		}

		tempOceanOffset = 1.0 - tempOceanOffset;
	}

	rmBuildAllAreas();

	// Side forests.
	int numForests = 11;

	// Forest radius.
	float forestRadius = (0.5 * axisLength) / numForests;
	float forestRadiusFraction = smallerMetersToFraction(forestRadius); // We stretch the axis that is NOT the forest for > 4 players!

	// Forest size.
	float forestSize = areaRadiusMetersToFraction(forestRadius) / sq(stretchFactor);

	// Forest offset.
	float forestOffset = 0.11;
	float tempForestOffset = forestOffset; // Use temp variable, leave forestOffset as is.

	// Have this in a loop so we can easily adjust area properties.
	for(i = 0; < 2) {
		for(j = 0; < numForests) {
			int sideForestID = rmCreateArea("side forest " + i + " " + j);
			rmSetAreaSize(sideForestID, forestSize);
			// rmSetAreaCoherence(sideForestID, 1.0);
			rmSetAreaForestType(sideForestID, "Palm Forest");
			rmSetAreaBaseHeight(sideForestID, 2.0);
			rmSetAreaHeightBlend(sideForestID, 2);
			rmSetAreaSmoothDistance(sideForestID, 10);
			rmAddAreaToClass(sideForestID, classForest);
			rmSetAreaWarnFailure(sideForestID, false);

			// Use the forest area radius as initial offset and add i * diameter.
			if(skew == cSkewLeftRight) {
				rmSetAreaLocation(sideForestID, forestRadiusFraction + 2.0 * forestRadiusFraction * j, tempForestOffset);
			} else {
				rmSetAreaLocation(sideForestID, tempForestOffset, forestRadiusFraction + 2.0 * forestRadiusFraction * j);
			}
		}

		// Adjust offset for next iteration.
		tempForestOffset = 1.0 - forestOffset;
	}

	rmBuildAllAreas();

	// Back forest for teamgames.
	if(cTeams == 2 && cNonGaiaPlayers > 2) {
		for(i = 0; < 2) {
			int backForestID = rmCreateArea("back forest " + i);
			rmSetAreaSize(backForestID, rmAreaTilesToFraction(90), rmAreaTilesToFraction(110));
			rmSetAreaForestType(backForestID, "Palm Forest");
			rmSetAreaCoherence(backForestID, 0.0);
			rmAddAreaToClass(backForestID, classForest);
			rmSetAreaWarnFailure(backForestID, false);

			if(skew == cSkewLeftRight) {
				rmSetAreaLocation(backForestID, 0.0 + i, 0.5);
			} else {
				rmSetAreaLocation(backForestID, 0.5, 0.0 + i);
			}
		}

		rmBuildAllAreas();
	}

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaTerrainType(beautificationID, "SandB");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidForest);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 10 * cPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaTerrainType(beautificationID, "EgyptianRoadA");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(60));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidForest);
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
	addFairLocConstraint(createClassDistConstraint(classForest, 20.0));
	addFairLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
	addFairLocConstraint(avoidTowerLOS);

	enableFairLocTwoPlayerCheck();

	addFairLoc(60.0, 80.0, false, randChance(), 60.0, 12.0, 12.0);

	// Far settlement.
	addFairLocConstraint(createClassDistConstraint(classForest, 20.0));
	addFairLocConstraint(createTypeDistConstraint("AbstractSettlement", 50.0));
	addFairLocConstraint(avoidTowerLOS);

	enableFairLocTwoPlayerCheck(1.0 / 3.0);

	if(cNonGaiaPlayers < 3) {
		setFairLocInterDistMin(70.0);
		addFairLocConstraint(createClassDistConstraint(classCenterline, 35.0));

		if(randChance(0.8)) {
			addFairLoc(75.0, 95.0, true, false, 70.0, 12.0, 12.0, true);
		} else {
			addFairLoc(65.0, 85.0, false, false, 60.0, 12.0, 12.0, true);

		}
	} else if(cNonGaiaPlayers < 5) {
		addFairLoc(70.0, 90.0, true, randChance(), 75.0, 12.0, 12.0, false, gameHasTwoEqualTeams());
	} else {
		addFairLoc(70.0, 100.0, true, randChance(), 75.0, 12.0, 12.0, false, gameHasTwoEqualTeams());
	}

	createFairLocs("settlements");

	// Only actually build the connections for 1v1.
	if(cNonGaiaPlayers < 3) {
		for(i = 1; < cPlayers) {
			int settlementAreaID = rmCreateArea("far settlement area " + i);
			rmSetAreaLocation(settlementAreaID, getFairLocX(2, i), getFairLocZ(2, i)); // Second fair loc.
			rmSetAreaWarnFailure(settlementAreaID, false);
			rmBuildArea(settlementAreaID);

			// Add area to connection and build.
			rmAddConnectionArea(getConnectionID(i), settlementAreaID);
			rmBuildConnection(getConnectionID(i));
		}
	}

	placeObjectAtAllFairLocs(settlementID);

	resetFairLocs();

	progress(0.4);

	// Cliffs.
	int cliffID = -1;
	int numCliffs = 0;

	if(cNonGaiaPlayers < 3) {
		numCliffs = 3 * cNonGaiaPlayers;
	} else {
		numCliffs = 2 * cNonGaiaPlayers * stretchFactor;
	}

	int cliffAvoidCliff = createClassDistConstraint(classCliff, 30.0);
	int cliffAvoidCenterline = createClassDistConstraint(classCenterline, 12.5); // Was 17.5.
	int cliffAvoidBuildings = createTypeDistConstraint("Building", 15.0);
	int cliffAvoidPlayer = createClassDistConstraint(classPlayer, 1.0); // Was 5.0.
	int cliffAvoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(32), rmZTilesToFraction(32));
	int cliffAvoidConnection = createClassDistConstraint(classConnection, 1.0);

	for(i = 0; < numCliffs) {
		if(cTeams < 3) {
			cliffID = rmCreateArea("cliff " + i, rmAreaID(cTeamSplitName + " " + (i % 2)));
		} else {
			cliffID = rmCreateArea("cliff " + i);
		}
		rmSetAreaSize(cliffID, rmAreaTilesToFraction(140), rmAreaTilesToFraction(160));
		rmSetAreaTerrainType(cliffID, "CliffEgyptianA");
		rmSetAreaCliffType(cliffID, "Egyptian");
		rmSetAreaCoherence(cliffID, 0.25);
		rmSetAreaMinBlobs(cliffID, 2);
		rmSetAreaMaxBlobs(cliffID, 2);
		rmSetAreaMinBlobDistance(cliffID, 16.0);
		rmSetAreaMaxBlobDistance(cliffID, 20.0);
		rmSetAreaCliffEdge(cliffID, 1, 1.0, 0.0, 1.0, 0);
		rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, false);
		rmSetAreaCliffHeight(cliffID, 7, 1.0, 1.0);
		rmSetAreaHeightBlend(cliffID, 2);
		rmSetAreaSmoothDistance(cliffID, 8);
		rmAddAreaToClass(cliffID, classCliff);
		rmAddAreaConstraint(cliffID, farAvoidForest);
		rmAddAreaConstraint(cliffID, cliffAvoidCliff);
		rmAddAreaConstraint(cliffID, cliffAvoidBuildings);
		rmAddAreaConstraint(cliffID, cliffAvoidEdge);
		rmAddAreaConstraint(cliffID, cliffAvoidPlayer);
		rmAddAreaConstraint(cliffID, cliffAvoidConnection);
		if(cNonGaiaPlayers < 3) {
			// Only avoid centerline and connections for 1v1.
			rmAddAreaConstraint(cliffID, cliffAvoidCenterline);
		}
		rmSetAreaWarnFailure(cliffID, false);

		rmBuildArea(cliffID);
	}

	progress(0.5);

	// Gold.
	int numMediumGold = 0;
	int numBonusGold = 0;

	if(cNonGaiaPlayers < 3) {
		float goldFloat = rmRandFloat(0.0, 1.0);

		if(goldFloat < 0.25) {
			numMediumGold = 1;
			numBonusGold = 2;
		} else if(goldFloat < 0.5) {
			numMediumGold = 2;
			numBonusGold = 1;
		} else {
			numMediumGold = 2;
			numBonusGold = 2;
		}
	} else {
		numMediumGold = 1;
		numBonusGold = 2;
	}

	// Medium gold (sides).
	int mediumGoldID = createObjectDefVerify("medium gold");
	addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);
	setObjectDefDistance(mediumGoldID, 60.0, 60.0 + 20.0 * numMediumGold);
	rmAddObjectDefConstraint(mediumGoldID, avoidAll);
	rmAddObjectDefConstraint(mediumGoldID, createSymmetricBoxConstraint(rmXTilesToFraction(8), rmZTilesToFraction(8)));
	if(cNonGaiaPlayers < 3 || gameHasTwoEqualTeams() == false) {
		rmAddObjectDefConstraint(mediumGoldID, createClassDistConstraint(classCenterline, 60.0 - 10.0 * numMediumGold));
	} else {
		rmAddObjectDefConstraint(mediumGoldID, createClassDistConstraint(classCenterline, smallerFractionToMeters(0.25)));
	}
	rmAddObjectDefConstraint(mediumGoldID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumGoldID, mediumAvoidSettlement);
	rmAddObjectDefConstraint(mediumGoldID, farAvoidGold);
	rmAddObjectDefConstraint(mediumGoldID, mediumAvoidForest);
	rmAddObjectDefConstraint(mediumGoldID, createClassDistConstraint(classStartingSettlement, 60.0));

	placeObjectAtPlayerLocs(mediumGoldID, false, numMediumGold);

	// Bonus gold (center).
	int bonusGoldID = createObjectDefVerify("bonus gold");
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	if(skew == cSkewLeftRight) {
		rmAddObjectDefConstraint(bonusGoldID, createSymmetricBoxConstraint(0.375, 0.0));
	} else {
		rmAddObjectDefConstraint(bonusGoldID, createSymmetricBoxConstraint(0.0, 0.375));
	}
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classCenterline, 5.0));
	rmAddObjectDefConstraint(bonusGoldID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, mediumAvoidSettlement);
	if(cNonGaiaPlayers < 3) {
		rmAddObjectDefConstraint(bonusGoldID, createTypeDistConstraint("Gold", 50.0 - 10.0 * numBonusGold));
	} else {
		rmAddObjectDefConstraint(bonusGoldID, createTypeDistConstraint("Gold", 45.0 - 5.0 * numBonusGold));
	}
	rmAddObjectDefConstraint(bonusGoldID, mediumAvoidForest);

	placeObjectInTeamSplits(bonusGoldID, false, numBonusGold);

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

	// Hunt.
	// Medium hunt 1 (side/behind).
	int numMediumHunt1 = rmRandInt(1, 2);

	if(cNonGaiaPlayers > 2 || gameHasTwoEqualTeams() == false) {
		numMediumHunt1 = 1;
	}

	int mediumHunt1ID = createObjectDefVerify("medium hunt 1");
	addObjectDefItemVerify(mediumHunt1ID, "Gazelle", rmRandInt(5, 8), 2.0);
	setObjectDefDistance(mediumHunt1ID, 60.0, 60.0 + 15.0 * numMediumHunt1);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidAll);
	rmAddObjectDefConstraint(mediumHunt1ID, createSymmetricBoxConstraint(rmXTilesToFraction(8), rmZTilesToFraction(8)));
	rmAddObjectDefConstraint(mediumHunt1ID, createClassDistConstraint(classCenterline, largerFractionToMeters(0.2)));
	rmAddObjectDefConstraint(mediumHunt1ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHunt1ID, mediumAvoidSettlement);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidHuntable);
	rmAddObjectDefConstraint(mediumHunt1ID, shortAvoidGold);
	rmAddObjectDefConstraint(mediumHunt1ID, mediumAvoidForest);
	rmAddObjectDefConstraint(mediumHunt1ID, createClassDistConstraint(classStartingSettlement, 60.0));

	placeObjectAtPlayerLocs(mediumHunt1ID, false, numMediumHunt1);

	// Medium hunt 2 (not behind).
	int numMediumHunt2 = 1;

	int mediumHunt2ID = createObjectDefVerify("medium hunt 2");
	if(randChance()) {
		addObjectDefItemVerify(mediumHunt2ID, "Giraffe", rmRandInt(3, 4), 2.0);
	} else {
		addObjectDefItemVerify(mediumHunt2ID, "Zebra", rmRandInt(5, 8), 2.0);
	}

	if(skew == cSkewLeftRight) {
		addSimLocConstraint(createSymmetricBoxConstraint(0.25, 0.0));
	} else {
		addSimLocConstraint(createSymmetricBoxConstraint(0.0, 0.25));
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(shortAvoidImpassableLand);
	addSimLocConstraint(mediumAvoidSettlement);
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(shortAvoidGold);
	addSimLocConstraint(mediumAvoidForest);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 70.0));

	enableSimLocTwoPlayerCheck();
	setSimLocBias(cBiasForward);
	setSimLocInterval(10.0);

	addSimLoc(70.0, 100.0, avoidHuntDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(mediumHunt2ID, false, "medium hunt 2");

	// Bonus hunt (center).
	int numBonusHunt = 1;
	float bonusHuntFloat = rmRandFloat(0.0, 1.0);

	int bonusHuntID = createObjectDefVerify("bonus hunt");
	if(bonusHuntFloat < 1.0 /  3.0) {
		addObjectDefItemVerify(bonusHuntID, "Elephant", 1, 2.0);
		addObjectDefItemVerify(bonusHuntID, "Gazelle", rmRandInt(0, 5), 2.0);
	} else if(bonusHuntFloat < 2.0 / 3.0) {
		addObjectDefItemVerify(bonusHuntID, "Rhinocerous", rmRandInt(2, 3), 2.0);
	} else {
		addObjectDefItemVerify(bonusHuntID, "Elephant", 2, 2.0);
	}

	if(skew == cSkewLeftRight) {
		rmAddObjectDefConstraint(bonusHuntID, createSymmetricBoxConstraint(0.375, 0.0));
	} else {
		rmAddObjectDefConstraint(bonusHuntID, createSymmetricBoxConstraint(0.0, 0.375));
	}
	rmAddObjectDefConstraint(bonusHuntID, avoidAll);
	rmAddObjectDefConstraint(bonusHuntID, createClassDistConstraint(classStartingSettlement, 60.0));
	rmAddObjectDefConstraint(bonusHuntID, createClassDistConstraint(classCenterline, 1.0));
	rmAddObjectDefConstraint(bonusHuntID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusHuntID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(bonusHuntID, mediumAvoidSettlement);
	rmAddObjectDefConstraint(bonusHuntID, createTypeDistConstraint("Huntable", 30.0));
	rmAddObjectDefConstraint(bonusHuntID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusHuntID, mediumAvoidForest);

	placeObjectInTeamSplits(bonusHuntID, false, numBonusHunt);

	// Starting hunt.
	placeObjectAtPlayerLocs(startingHuntID);

	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

	progress(0.7);

	// Player forest.
	int numPlayerForests = 3;

	for(i = 1; < cPlayers) {
		int playerForestAreaID = rmCreateArea("player forest area " + i);
		rmSetAreaSize(playerForestAreaID, rmAreaTilesToFraction(1600));
		// rmSetAreaTerrainType(playerForestAreaID, "HadesBuildable1");
		rmSetAreaLocPlayer(playerForestAreaID, getPlayer(i));
		rmSetAreaCoherence(playerForestAreaID, 1.0);
		rmSetAreaWarnFailure(playerForestAreaID, false);
		rmBuildArea(playerForestAreaID);

		for(j = 0; < numPlayerForests) {
			int playerForestID = rmCreateArea("player forest " + i + " " + j, playerForestAreaID);
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(55), rmAreaTilesToFraction(65));
			rmSetAreaForestType(playerForestID, "Palm Forest");
			rmSetAreaCoherence(playerForestID, 0.5);
			rmSetAreaMinBlobs(playerForestID, 2);
			rmSetAreaMaxBlobs(playerForestID, 4);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 32.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, mediumAvoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, shortAvoidImpassableLand);
			rmSetAreaWarnFailure(playerForestID, false);
			rmBuildArea(playerForestID);
		}
	}

	progress(0.8);

	// Predators.
	placeObjectInPlayerSplits(farPredatorsID);

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID);

	// Far herdables.
	placeObjectInTeamSplits(farHerdablesID);

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectInPlayerSplits(relicID);

	// Random trees.
	placeObjectAtPlayerLocs(randomTreeID, false, 25);

	progress(0.9);

	// Embellishment.
	int loneHuntID = rmCreateObjectDef("lone hunt");
	rmAddObjectDefItem(loneHuntID, "Gazelle", 1, 0.0);
	setObjectDefDistanceToMax(loneHuntID);
	rmAddObjectDefConstraint(loneHuntID, avoidAll);
	rmAddObjectDefConstraint(loneHuntID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(loneHuntID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(loneHuntID, avoidFood);
	rmPlaceObjectDefAtLoc(loneHuntID, 0, 0.5, 0.5, cNonGaiaPlayers);

	// Bushes.
	int bush1ID = rmCreateObjectDef("bush 1");
	rmAddObjectDefItem(bush1ID, "Bush", 4, 4.0);
	setObjectDefDistanceToMax(bush1ID);
	rmAddObjectDefConstraint(bush1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush1ID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush1ID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers * stretchFactor);

	int bush2ID = rmCreateObjectDef("bush 2");
	rmAddObjectDefItem(bush2ID, "Bush", 3, 2.0);
	rmAddObjectDefItem(bush2ID, "Rock Sandstone Sprite", 1, 2.0);
	setObjectDefDistanceToMax(bush2ID);
	rmAddObjectDefConstraint(bush2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush2ID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 8 * cNonGaiaPlayers * stretchFactor);

	// Grass.
	int grassID = rmCreateObjectDef("grass");
	rmAddObjectDefItem(grassID, "Grass", 1, 0.0);
	setObjectDefDistanceToMax(grassID);
	rmAddObjectDefConstraint(grassID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(grassID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 20 * cNonGaiaPlayers * stretchFactor);

	// Drifts.
	int driftID = rmCreateObjectDef("drift");
	rmAddObjectDefItem(driftID, "Sand Drift Patch", 1, 0.0);
	setObjectDefDistanceToMax(driftID);
	rmAddObjectDefConstraint(driftID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(driftID, avoidEdge);
	rmAddObjectDefConstraint(driftID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(driftID, avoidBuildings);
	rmAddObjectDefConstraint(driftID, createTypeDistConstraint("Sand Drift Patch", 25.0));
	rmPlaceObjectDefAtLoc(driftID, 0, 0.5, 0.5, 6 * cNonGaiaPlayers * stretchFactor);

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
