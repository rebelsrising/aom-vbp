/*
** WATERING HOLE
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

// Connection array.
int connectionID1 = 0; int connectionID2  = 0; int connectionID3  = 0; int connectionID4  = 0;
int connectionID5 = 0; int connectionID6  = 0; int connectionID7  = 0; int connectionID8  = 0;
int connectionID9 = 0; int connectionID10 = 0; int connectionID11 = 0; int connectionID12 = 0;

int getConnectionID(int n = 0) {
	if(n == 1) return(connectionID1); if(n == 2)  return(connectionID2);  if(n == 3)  return(connectionID3);  if(n == 4)  return(connectionID4);
	if(n == 5) return(connectionID5); if(n == 6)  return(connectionID6);  if(n == 7)  return(connectionID7);  if(n == 8)  return(connectionID8);
	if(n == 9) return(connectionID9); if(n == 10) return(connectionID10); if(n == 11) return(connectionID11); if(n == 12) return(connectionID12);
	return(-1);
}

void setConnectionID(int i = 0, int id = 0) {
	if(i == 1) connectionID1 = id; if(i == 2)  connectionID2  = id; if(i == 3)  connectionID3  = id; if(i == 4)  connectionID4  = id;
	if(i == 5) connectionID5 = id; if(i == 6)  connectionID6  = id; if(i == 7)  connectionID7  = id; if(i == 8)  connectionID8  = id;
	if(i == 9) connectionID9 = id; if(i == 10) connectionID10 = id; if(i == 11) connectionID11 = id; if(i == 12) connectionID12 = id;
}

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Watering Hole");

	// Set size.
	int axisLength = getStandardMapDimInMeters(9000);

	if(cNonGaiaPlayers < 3) {
		axisLength = getStandardMapDimInMeters(9600);
	}

	// Set water type.
	rmSetSeaType("Savannah Water Hole");

	// Initialize map.
	initializeMap("Water", axisLength);

	// Player placement.
	float frac = placePlayersInCircle(0.40, 0.44);

	// Control areas.
	int classCenter = initializeCenter();
	int classCorner = initializeCorners();
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
	int classSettlementArea = rmDefineClass("settlement area");
	int classConnection = rmDefineClass("connection");
	int classPlayer = rmDefineClass("player");
	int classPlayerCore = rmDefineClass("player core");
	int classIsland = rmDefineClass("island");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classForest = rmDefineClass("forest");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);
	int shortAvoidPlayer = createClassDistConstraint(classPlayer, 1.0);
	int farAvoidPlayer = createClassDistConstraint(classPlayer, 20.0);
	int avoidConnection = createClassDistConstraint(classConnection, 1.0);
	int avoidIsland = createClassDistConstraint(classIsland, 20.0);
	int avoidPlayerCore = createClassDistConstraint(classPlayerCore, 1.0);

	// Different generation for non-1v1.
	if(cNonGaiaPlayers > 2) {
		avoidPlayerCore = createClassDistConstraint(classPlayerCore, 70.0);
	}

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int mediumAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 25.0);

	// Terrain.
	int shortAvoidImpassableLand = createTerrainDistConstraint("Land", false, 5.0);
	int mediumAvoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);
	int farAvoidImpassableLand = createTerrainDistConstraint("Land", false, 15.0);
	int nearShore = createTerrainMaxDistConstraint("Water", true, 6.0);

	// Gold.
	float avoidGoldDist = 40.0;

	int shortAvoidGold = createTypeDistConstraint("Gold", 10.0);
	int farAvoidGold = createTypeDistConstraint("Gold", avoidGoldDist);

	// Food.
	float avoidHuntDist = 35.0;

	int avoidHuntable = createTypeDistConstraint("Huntable", avoidHuntDist);
	int avoidHerdable = createTypeDistConstraint("Herdable", 30.0);
	int avoidFood = createTypeDistConstraint("Food", 20.0);
	int avoidPredator = createTypeDistConstraint("AnimalPredator", 40.0);

	// Loosen constraints for anything but 1v1 as player areas become very small.
	if(cNonGaiaPlayers > 2) { // 4 players is also problematic.
		avoidHuntDist = 30.0;

		avoidHuntable = createTypeDistConstraint("Huntable", avoidHuntDist);
		avoidHerdable = createTypeDistConstraint("Herdable", 20.0);
		avoidPredator = createTypeDistConstraint("AnimalPredator", 20.0);
	}

	// Forest.
	int avoidForest = createClassDistConstraint(classForest, 20.0);
	int forestAvoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 20.0);
	int treeAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 13.0);

	// Relics.
	int avoidRelic = createTypeDistConstraint("Relic", 70.0);

	// Buildings.
	int avoidBuildings = createTypeDistConstraint("Building", 22.5);
	int avoidTowerLOS = createTypeDistConstraint("Tower", 35.0);
	int avoidTower = createTypeDistConstraint("Tower", 20.0 + (45.0 - 100.0 * frac));

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

	// Starting hunt.
	int startingHuntID = createObjectDefVerify("starting hunt");
	addObjectDefItemVerify(startingHuntID, "Gazelle", rmRandInt(3, 8), 2.0);
	setObjectDefDistance(startingHuntID, 23.0, 27.0);
	rmAddObjectDefConstraint(startingHuntID, avoidAll);
	rmAddObjectDefConstraint(startingHuntID, avoidEdge);
	rmAddObjectDefConstraint(startingHuntID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(startingHuntID, createTypeDistConstraint("Huntable", 30.0));

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Pig", rmRandInt(0, 2), 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, shortAvoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Savannah Tree", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Pig", rmRandInt(2, 3), 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidIsland);
	rmAddObjectDefConstraint(mediumHerdablesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Pig", rmRandInt(1, 2), 4.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, shortAvoidPlayer);
	rmAddObjectDefConstraint(farHerdablesID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far cranes (near water/island), don't verify.
	int farCranesID = createObjectDefVerify("far cranes", cDebugMode >= cDebugFull);
	addObjectDefItemVerify(farCranesID, "Crowned Crane", rmRandInt(6, 8), 2.0);
	rmAddObjectDefConstraint(farCranesID, avoidAll);
	rmAddObjectDefConstraint(farCranesID, avoidEdge);
	rmAddObjectDefConstraint(farCranesID, createTerrainDistConstraint("Land", false, 1.0));
	rmAddObjectDefConstraint(farCranesID, nearShore);
	rmAddObjectDefConstraint(farCranesID, avoidIsland);
	rmAddObjectDefConstraint(farCranesID, avoidHuntable);
	rmAddObjectDefConstraint(farCranesID, createClassDistConstraint(classStartingSettlement, 70.0));

	// Far predators 1 (player islands).
	int farPredators1ID = createObjectDefVerify("far predators 1");
	if(randChance()) {
		addObjectDefItemVerify(farPredators1ID, "Lion", 2, 4.0);
	} else {
		addObjectDefItemVerify(farPredators1ID, "Hyena", 2, 4.0);
	}
	rmAddObjectDefConstraint(farPredators1ID, avoidAll);
	rmAddObjectDefConstraint(farPredators1ID, avoidEdge);
	rmAddObjectDefConstraint(farPredators1ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farPredators1ID, avoidIsland);
	rmAddObjectDefConstraint(farPredators1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredators1ID, mediumAvoidSettlement);
	// rmAddObjectDefConstraint(farPredators1ID, avoidFood);
	rmAddObjectDefConstraint(farPredators1ID, avoidPredator);

	// Far predators 2 (center islands).
	int farPredators2ID = createObjectDefVerify("far predators 2");
	if(randChance()) {
		addObjectDefItemVerify(farPredators2ID, "Lion", 2, 4.0);
	} else {
		addObjectDefItemVerify(farPredators2ID, "Hyena", 2, 4.0);
	}
	rmAddObjectDefConstraint(farPredators2ID, avoidAll);
	rmAddObjectDefConstraint(farPredators2ID, avoidEdge);
	rmAddObjectDefConstraint(farPredators2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(farPredators2ID, shortAvoidPlayer);
	rmAddObjectDefConstraint(farPredators2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredators2ID, mediumAvoidSettlement);
	// rmAddObjectDefConstraint(farPredators2ID, avoidFood);
	rmAddObjectDefConstraint(farPredators2ID, avoidPredator);

	// Far predators 3 (near water).
	int farPredators3ID = createObjectDefVerify("far predators 3");
	addObjectDefItemVerify(farPredators3ID, "Crocodile", 1, 0.0);
	rmAddObjectDefConstraint(farPredators3ID, avoidAll);
	rmAddObjectDefConstraint(farPredators3ID, avoidEdge);
	rmAddObjectDefConstraint(farPredators3ID, nearShore);
	rmAddObjectDefConstraint(farPredators3ID, avoidIsland);
	rmAddObjectDefConstraint(farPredators3ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredators3ID, mediumAvoidSettlement);
	// rmAddObjectDefConstraint(farPredators3ID, avoidFood);
	rmAddObjectDefConstraint(farPredators3ID, avoidPredator);

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

	// Random tree 1.
	int randomTree1ID = rmCreateObjectDef("random tree 1");
	rmAddObjectDefItem(randomTree1ID, "Savannah Tree", 1, 0.0);
	setObjectDefDistanceToMax(randomTree1ID);
	rmAddObjectDefConstraint(randomTree1ID, avoidAll);
	rmAddObjectDefConstraint(randomTree1ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomTree1ID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTree1ID, treeAvoidSettlement);

	// Random tree 2.
	int randomTree2ID = rmCreateObjectDef("random tree 2");
	rmAddObjectDefItem(randomTree2ID, "Palm", 1, 0.0);
	setObjectDefDistanceToMax(randomTree2ID);
	rmAddObjectDefConstraint(randomTree2ID, avoidAll);
	rmAddObjectDefConstraint(randomTree2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomTree2ID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTree2ID, treeAvoidSettlement);

	progress(0.1);

	// Connections.
	// Define shallows.
	int shallowsID = rmCreateConnection("shallows");
	rmSetConnectionType(shallowsID, cConnectAreas, false);
	rmSetConnectionWidth(shallowsID, 20.0, 2);
	rmAddConnectionTerrainReplacement(shallowsID, "RiverSandyA", "SavannahC");
	// rmSetConnectionCoherence(shallowsID, 1.0);
	rmSetConnectionBaseHeight(shallowsID, 2.0);
	rmSetConnectionHeightBlend(shallowsID, 2);
	rmSetConnectionSmoothDistance(shallowsID, 3);
	rmAddConnectionToClass(shallowsID, classConnection);
	rmSetConnectionWarnFailure(shallowsID, false);

	// Define extra shallows.
	int extraShallowsID = rmCreateConnection("extra shallows");
	rmSetConnectionType(extraShallowsID, cConnectAreas, false);
	rmSetConnectionWidth(extraShallowsID, 10.0, 2);
	rmAddConnectionTerrainReplacement(extraShallowsID, "RiverSandyA", "SavannahC");
	// rmSetConnectionCoherence(extraShallowsID, 1.0);
	rmSetConnectionBaseHeight(extraShallowsID, 2.0);
	rmSetConnectionHeightBlend(extraShallowsID, 2);
	rmSetConnectionSmoothDistance(extraShallowsID, 3);
	rmSetConnectionPositionVariance(extraShallowsID, -1.0);
	rmAddConnectionStartConstraint(extraShallowsID, avoidPlayerCore);
	rmAddConnectionEndConstraint(extraShallowsID, avoidPlayerCore);
	rmAddConnectionToClass(extraShallowsID, classConnection);
	rmSetConnectionWarnFailure(extraShallowsID, false);

	// Define team shallows.
	int teamShallowsID = rmCreateConnection("team shallows");
	rmSetConnectionType(teamShallowsID, cConnectAllies, false);
	rmSetConnectionWidth(teamShallowsID, 16.0, 2);
	rmAddConnectionTerrainReplacement(teamShallowsID, "RiverSandyA", "SavannahC");
	// rmSetConnectionCoherence(teamShallowsID, 1.0);
	rmSetConnectionBaseHeight(teamShallowsID, 2.0);
	rmSetConnectionHeightBlend(teamShallowsID, 2);
	rmSetConnectionSmoothDistance(teamShallowsID, 3);
	rmAddConnectionToClass(teamShallowsID, classConnection);
	rmSetConnectionWarnFailure(teamShallowsID, false);

	// Define 3rd settlement connections.
	for(i = 1; < cPlayers) {
		int connectionID = rmCreateConnection("settlement connection " + i);
		rmSetConnectionType(connectionID, cConnectAreas, false, 1.0);
		rmSetConnectionWidth(connectionID, 16.0, 2);
		rmAddConnectionTerrainReplacement(connectionID, "RiverSandyA", "SavannahC");
		rmSetConnectionBaseHeight(connectionID, 2.0);
		rmSetConnectionHeightBlend(connectionID, 2);
		rmSetConnectionSmoothDistance(connectionID, 3.0);
		rmAddConnectionToClass(connectionID, classConnection);
		rmSetConnectionWarnFailure(connectionID, false);

		// Store in array.
		setConnectionID(i, connectionID);
	}

	// Set up fake player areas.
	for(i = 1; < cPlayers) {
		int fakePlayerAreaID = rmCreateArea("fake player area " + i);
		if(cNonGaiaPlayers < 3) {
			rmSetAreaSize(fakePlayerAreaID, rmAreaTilesToFraction(3000));
		} else {
			rmSetAreaSize(fakePlayerAreaID, rmAreaTilesToFraction(200));
		}
		rmSetAreaLocPlayer(fakePlayerAreaID, getPlayer(i));
		//rmSetAreaTerrainType(fakePlayerAreaID, "SavannahB");
		rmSetAreaCoherence(fakePlayerAreaID, 1.0);
		//rmSetAreaBaseHeight(fakePlayerAreaID, 2.0);
		rmSetAreaHeightBlend(fakePlayerAreaID, 2);
		rmAddAreaToClass(fakePlayerAreaID, classPlayerCore);
		rmSetAreaWarnFailure(fakePlayerAreaID, false);
		rmBuildArea(fakePlayerAreaID);
	}

	// Center.
	int bonusIslandID = 0;
	int numBonusIsland = 4;

	float islandEdgeDist = rmXTilesToFraction(20);

	if(cNonGaiaPlayers > 2) {
		islandEdgeDist = rmXTilesToFraction(30);
		numBonusIsland = 0;
	}

	int islandAvoidEdge = createSymmetricBoxConstraint(islandEdgeDist, islandEdgeDist);

	// 1v1.
	for(i = 0; < numBonusIsland) {
		float randX = rmRandFloat(0.325, 0.675);
		float randZ = rmRandFloat(0.325, 0.675);

		for(j = 0; < 2) {
			bonusIslandID = rmCreateArea("bonus island " + j + " " + i);
			rmSetAreaSize(bonusIslandID, rmAreaTilesToFraction(3000));
			if(j == 0) {
				rmSetAreaLocation(bonusIslandID, randX, randZ);
			} else if(j == 1) {
				rmSetAreaLocation(bonusIslandID, 1.0 - randX, 1.0 - randZ);
			}
			rmSetAreaTerrainType(bonusIslandID, "SavannahB");
			rmAddAreaTerrainLayer(bonusIslandID, "SavannahC", 0, 6);
			rmSetAreaCoherence(bonusIslandID, 1.0);
			rmSetAreaBaseHeight(bonusIslandID, 2.0);
			rmSetAreaHeightBlend(bonusIslandID, 2);
			rmSetAreaSmoothDistance(bonusIslandID, 12);
			rmAddAreaToClass(bonusIslandID, classIsland);
			rmAddAreaConstraint(bonusIslandID, avoidPlayerCore);
			rmAddAreaConstraint(bonusIslandID, islandAvoidEdge);
			rmAddConnectionArea(extraShallowsID, bonusIslandID);
			rmAddConnectionArea(shallowsID, bonusIslandID);
			rmSetAreaWarnFailure(bonusIslandID, false);
			rmBuildArea(bonusIslandID);
		}
	}

	// Anything but 1v1.
	if(cNonGaiaPlayers > 2) {
		bonusIslandID = rmCreateArea("center bonus island");
		rmSetAreaSize(bonusIslandID, rmAreaTilesToFraction(3500 * cNonGaiaPlayers));
		rmSetAreaLocation(bonusIslandID, 0.5, 0.5);
		rmSetAreaTerrainType(bonusIslandID, "SavannahB");
		rmAddAreaTerrainLayer(bonusIslandID, "SavannahC", 0, 6);
		rmSetAreaCoherence(bonusIslandID, 1.0);
		rmSetAreaBaseHeight(bonusIslandID, 2.0);
		rmSetAreaHeightBlend(bonusIslandID, 2);
		rmSetAreaSmoothDistance(bonusIslandID, 12);
		rmAddAreaToClass(bonusIslandID, classIsland);
		rmAddAreaConstraint(bonusIslandID, avoidPlayerCore);
		rmAddAreaConstraint(bonusIslandID, islandAvoidEdge);
		rmAddConnectionArea(extraShallowsID, bonusIslandID);
		rmAddConnectionArea(shallowsID, bonusIslandID);
		rmSetAreaWarnFailure(bonusIslandID, false);
		rmBuildArea(bonusIslandID);
	}

	// Set up player areas.
	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, 1.0);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "SavannahB");
		rmAddAreaTerrainLayer(playerAreaID, "SavannahC", 0, 12);
		rmSetAreaCoherence(playerAreaID, 0.6);
		rmSetAreaBaseHeight(playerAreaID, 2.0);
		rmSetAreaHeightBlend(playerAreaID, 2);
		rmSetAreaSmoothDistance(playerAreaID, 10);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmAddAreaConstraint(playerAreaID, avoidIsland);
		rmAddAreaConstraint(playerAreaID, farAvoidPlayer);
		rmSetAreaWarnFailure(playerAreaID, false);
	}
	
	/*
	 * Add the previously defined areas in a new order to the connection.
	 * The reason we do this is because connections are always built from 1 (blue) -> 2 (red) -> 3 (green), regardless of their team/position.
	 * This is the main reason why Marsh has such a random center - it depends on how the players are teamed/placed.
	*/
	int currPlayer = 0;

	for(i = 1; < cPlayers) {
		int nextPlayer = INF;
		int nextPlayerID = -1;

		for(j = 1; < cPlayers) {
			int tempPlayer = getPlayer(j);

			if(tempPlayer < nextPlayer && tempPlayer > currPlayer) {
				nextPlayer = tempPlayer;
				nextPlayerID = j;
			}
		}

		int tempPlayerAreaID = rmAreaID("player area " + nextPlayerID);

		rmAddConnectionArea(shallowsID, tempPlayerAreaID);
		rmAddConnectionArea(extraShallowsID, tempPlayerAreaID);
		rmAddConnectionArea(getConnectionID(nextPlayerID), tempPlayerAreaID);

		currPlayer = nextPlayer;
	}

	rmBuildAllAreas();

	// Rebuild center.
	int fakeCenterID = rmCreateArea("fake center");
	rmSetAreaSize(fakeCenterID, 0.5);
	// rmSetAreaTerrainType(fakeCenterID, "SnowA");
	rmSetAreaLocation(fakeCenterID, 0.5, 0.5);
	rmAddAreaConstraint(fakeCenterID, shortAvoidImpassableLand);
	rmAddAreaConstraint(fakeCenterID, shortAvoidPlayer);
	rmSetAreaWarnFailure(fakeCenterID, false);
	rmBuildArea(fakeCenterID);

	// Build connections.
	rmBuildConnection(teamShallowsID);
	rmBuildConnection(shallowsID);

	if(cNonGaiaPlayers < 3) {
		rmBuildConnection(extraShallowsID);
	// Don't do this - I don't think this 2v2 variation is any good.
	// } else if(cNonGaiaPlayers < 5) {
		// if(randChance()) {
			// rmBuildConnection(extraShallowsID);
		// }
	}

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 50 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(40));
		rmSetAreaTerrainType(beautificationID, "SavannahA");
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 15 * cPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(50));
		rmSetAreaTerrainType(beautificationID, "SandA");
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

	addFairLocConstraint(avoidTowerLOS);

	// Close settlement.
	if(cNonGaiaPlayers < 9) {
		enableFairLocTwoPlayerCheck();
		addFairLocConstraint(mediumAvoidImpassableLand);
		addFairLocConstraint(avoidIsland);
		addFairLoc(65.0, 80.0, false, true, 40.0, 20.0, 20.0);
	} else {
		addFairLocConstraint(shortAvoidImpassableLand);
		addFairLoc(45.0, 80.0, false, true, 40.0, 12.0, 12.0);
	}

	placeObjectAtNewFairLocs(settlementID, false, "close settlement");

	progress(0.4);

	// Try 4 times.
	int numFairLocTries = 4;

	for(i = 0; < numFairLocTries) {
		// Far settlement.
		addFairLocConstraint(shortAvoidPlayer);

		if(cNonGaiaPlayers < 3) {
			addFairLocConstraint(farAvoidImpassableLand);
		} else {
			addFairLocConstraint(mediumAvoidImpassableLand); // Consider using farAvoidImpassableLand here.
			addFairLocConstraint(avoidConnection);
		}

		enableFairLocTwoPlayerCheck();

		// Use 70.0 as low value. This is not actually possible, but favors lower values.
		if(cNonGaiaPlayers < 3) {
			addFairLoc(70.0, 125.0, true, true, 80.0 - 5.0 * i, 12.0, 12.0);
		} else if(cNonGaiaPlayers < 5) {
			addFairLoc(70.0, 115.0 + 5.0 * i, true, true, 70.0 - 5.0 * i, 12.0, 12.0, false, gameHasTwoEqualTeams() && i < 2);
		} else if(cNonGaiaPlayers < 7) {
			// 100.0 creates better variations by not pulling in the forward settlement too much.
			addFairLoc(100.0, 135.0 + 5.0 * i, true, true, 70.0 - 5.0 * i, 12.0, 12.0, false, gameHasTwoEqualTeams() && i < 2);
		} else if(cNonGaiaPlayers < 9) {
			addFairLoc(70.0, 145.0 + 5.0 * i, true, true, 65.0 - 5.0 * i, 12.0, 12.0);
		} else {
			// Do whatever here.
			addFairLoc(70.0, 200.0, true, true, 65.0 - 5.0 * i, 12.0, 12.0);
		}

		if(createFairLocs("far settlement " + i, i == (numFairLocTries - 1))) { // Only log last try.
			break;
		}

		resetFairLocs();
	}

	progress(0.5);

	// Build center ponds.
	if(cNonGaiaPlayers > 5) {
		fairLocAreasToClass(classSettlementArea);

		int pondAvoidSettlement = createClassDistConstraint(classSettlementArea, 45.0);

		int numPondTries = cNonGaiaPlayers;
		float pondSize = rmAreaTilesToFraction(500); // Don't make them too big or they may block settlements despite the area constraint (why though?).

		for(i = 0; < numPondTries) {
			int pondID = rmCreateArea("pond " + i);
			rmSetAreaSize(pondID, pondSize);
			rmSetAreaWaterType(pondID, "Savannah Water Hole");
			rmSetAreaBaseHeight(pondID, 1.0);
			rmSetAreaSmoothDistance(pondID, 5);
			rmSetAreaHeightBlend(pondID, 1);
			rmAddAreaConstraint(pondID, shortAvoidPlayer);
			rmAddAreaConstraint(pondID, farAvoidImpassableLand);
			rmAddAreaConstraint(pondID, pondAvoidSettlement);
			rmSetAreaWarnFailure(pondID, false);
		}

		rmBuildAllAreas();
	}

	// Create areas and place settlements.
	if(cNonGaiaPlayers > 2) {
		for(i = 1; < cPlayers) {
			int settlementAreaID = rmCreateArea("far settlement area " + i);
			rmSetAreaLocation(settlementAreaID, getFairLocX(1, i), getFairLocZ(1, i));
			rmSetAreaWarnFailure(settlementAreaID, false);
			rmBuildArea(settlementAreaID);

			// Add area to connection and build.
			rmAddConnectionArea(getConnectionID(i), settlementAreaID);
			rmBuildConnection(getConnectionID(i));
		}
	}

	placeObjectAtFairLoc(settlementID);

	resetFairLocs();

	// Elevation.
	int elevationID = 0;

	for(i = 0; < 15 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 1 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(80));
		if(randChance(0.7)) {
			rmSetAreaTerrainType(elevationID, "SavannahC");
		}
		rmSetAreaBaseHeight(elevationID, rmRandFloat(2.0, 4.0));
		rmSetAreaHeightBlend(elevationID, 1);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 3);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 40.0);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmAddAreaConstraint(elevationID, mediumAvoidImpassableLand);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	progress(0.6);

	// Gold.
	int numMediumGold = 0;
	int numFarGold = 0;
	int numBonusGold = 0;
	int mediumGoldID = -1;
	int farGoldID = -1;
	int bonusGoldID = -1;

	if(cNonGaiaPlayers < 3) {
		// 1v1 gold.
		float goldFloat = rmRandFloat(0.0, 1.0);

		if(goldFloat < 1.0 / 3.0) {
			numMediumGold = 2;
			numFarGold = 1;
		} else if(goldFloat < 2.0 / 3.0) {
			numMediumGold = 1;
			numFarGold = 2;
		} else {
			numMediumGold = 1;
			numFarGold = 1;
		}

		// Medium gold.
		mediumGoldID = createObjectDefVerify("medium gold");
		addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);
		setObjectDefDistance(mediumGoldID, 50.0, 50.0 + 20.0 * numMediumGold);
		rmAddObjectDefConstraint(mediumGoldID, avoidAll);
		rmAddObjectDefConstraint(mediumGoldID, avoidEdge);
		// rmAddObjectDefConstraint(mediumGoldID, avoidCorner);
		rmAddObjectDefConstraint(mediumGoldID, avoidTowerLOS);
		rmAddObjectDefConstraint(mediumGoldID, avoidIsland);
		rmAddObjectDefConstraint(mediumGoldID, mediumAvoidImpassableLand);
		rmAddObjectDefConstraint(mediumGoldID, farAvoidGold);
		// rmAddObjectDefConstraint(mediumGoldID, avoidConnection);
		rmAddObjectDefConstraint(mediumGoldID, createClassDistConstraint(classStartingSettlement, 50.0));
		if(numMediumGold == 1) {
			rmAddObjectDefConstraint(mediumGoldID, mediumAvoidSettlement);
		} else {
			rmAddObjectDefConstraint(mediumGoldID, shortAvoidSettlement);
		}

		placeObjectAtPlayerLocs(mediumGoldID, false, numMediumGold);

		// Far gold.
		farGoldID = createObjectDefVerify("far gold");
		addObjectDefItemVerify(farGoldID, "Gold Mine", 1, 0.0);
		rmAddObjectDefConstraint(farGoldID, avoidAll);
		rmAddObjectDefConstraint(farGoldID, avoidEdge);
		// rmAddObjectDefConstraint(farGoldID, avoidCorner);
		rmAddObjectDefConstraint(farGoldID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(farGoldID, avoidIsland);
		rmAddObjectDefConstraint(farGoldID, createClassDistConstraint(classStartingSettlement, 110.0));
		rmAddObjectDefConstraint(farGoldID, mediumAvoidSettlement);
		rmAddObjectDefConstraint(farGoldID, farAvoidGold);

		for(i = 1; < cPlayers) {
			placeObjectDefInArea(farGoldID, 0, rmAreaID("player area " + i), numFarGold);
		}

		// Bonus gold.
		numBonusGold = rmRandInt(1, 2);

		bonusGoldID = createObjectDefVerify("bonus gold");
		addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
		rmAddObjectDefConstraint(bonusGoldID, avoidAll);
		rmAddObjectDefConstraint(bonusGoldID, farAvoidPlayer);
		rmAddObjectDefConstraint(bonusGoldID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(bonusGoldID, mediumAvoidSettlement);
		rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classCenterline, 10.0));
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 80.0));

		placeObjectInPlayerSplits(bonusGoldID, false, numBonusGold);
	} else {
		// Teamgame gold: 1 medium, 1-2 bonus randomly in team area.

		// Medium gold.
		numMediumGold = 1;

		mediumGoldID = createObjectDefVerify("medium gold");
		addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);
		rmSetObjectDefMinDistance(mediumGoldID, 50.0);
		rmSetObjectDefMaxDistance(mediumGoldID, 65.0);
		rmAddObjectDefConstraint(mediumGoldID, avoidAll);
		rmAddObjectDefConstraint(mediumGoldID, avoidEdge);
		rmAddObjectDefConstraint(mediumGoldID, avoidTowerLOS);
		rmAddObjectDefConstraint(mediumGoldID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(mediumGoldID, avoidConnection);
		rmAddObjectDefConstraint(mediumGoldID, createClassDistConstraint(classIsland, 40.0));
		rmAddObjectDefConstraint(mediumGoldID, createClassDistConstraint(classStartingSettlement, 50.0));
		rmAddObjectDefConstraint(mediumGoldID, shortAvoidSettlement);
		rmAddObjectDefConstraint(mediumGoldID, farAvoidGold);

		placeObjectAtPlayerLocs(mediumGoldID, false, numMediumGold);

		// Far gold.
		if(randChance(2.0 / 3.0)) {
			numFarGold = 1;
		} else {
			numFarGold = 2;
		}

		farGoldID = createObjectDefVerify("far gold");
		addObjectDefItemVerify(farGoldID, "Gold Mine", 1, 0.0);
		rmAddObjectDefConstraint(farGoldID, avoidAll);
		rmAddObjectDefConstraint(farGoldID, avoidEdge);
		rmAddObjectDefConstraint(farGoldID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(farGoldID, avoidConnection);
		rmAddObjectDefConstraint(farGoldID, avoidTowerLOS);
		rmAddObjectDefConstraint(farGoldID, avoidIsland);
		rmAddObjectDefConstraint(farGoldID, createClassDistConstraint(classStartingSettlement, 60.0));
		rmAddObjectDefConstraint(farGoldID, shortAvoidSettlement);
		rmAddObjectDefConstraint(farGoldID, farAvoidGold);

		for(i = 1; < cPlayers) {
			placeObjectDefInArea(farGoldID, 0, rmAreaID("player area " + i), numFarGold);
		}

		// Bonus gold.
		numBonusGold = rmRandInt(1, 2);

		bonusGoldID = createObjectDefVerify("bonus gold");
		addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
		rmAddObjectDefConstraint(bonusGoldID, avoidAll);
		rmAddObjectDefConstraint(bonusGoldID, shortAvoidImpassableLand);
		// rmAddObjectDefConstraint(bonusGoldID, islandAvoidEdge);
		rmAddObjectDefConstraint(bonusGoldID, shortAvoidPlayer);
		rmAddObjectDefConstraint(bonusGoldID, shortAvoidSettlement);
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 80.0));
		rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);

		placeObjectInPlayerSplits(bonusGoldID, false, numBonusGold);
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

	progress(0.7);

	// Food.
	// Close hunt.
	bool huntInStartingLOS = randChance(2.0 / 3.0);
	float closeHuntFloat = rmRandFloat(0.0, 1.0);

	if(closeHuntFloat < 0.3) {
		storeObjectDefItem("Hippo", 2, 2.0);
	} else if(closeHuntFloat < 0.6) {
		storeObjectDefItem("Hippo", 3, 2.0);
	} else {
		storeObjectDefItem("Rhinocerous", 2, 2.0);
	}

	// Place outside of starting LOS if randomized, fall back to starting LOS if placement fails.
	if(huntInStartingLOS == false) {
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidIsland);
		addSimLocConstraint(shortAvoidImpassableLand);
		// addSimLocConstraint(shortAvoidGold);
		addSimLocConstraint(avoidTowerLOS);

		addSimLoc(45.0, 55.0, avoidHuntDist, 0.0, 0.0, false, false, true);

		enableSimLocTwoPlayerCheck();

		// Fall back to LOS placement if this should happen to fail.
		if(placeObjectAtNewSimLocs(createObjectFromStorage("close hunt"), false, "close hunt", false) == false) {
			huntInStartingLOS = true;
		}
	}

	// If we have hunt in starting LOS, we want to force it within tower ranges so we know it's within LOS.
	if(huntInStartingLOS) {
		storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 15.0)));
		storeObjectConstraint(avoidAll);
		storeObjectConstraint(avoidEdge);
		storeObjectConstraint(shortAvoidImpassableLand);
		// storeObjectConstraint(shortAvoidGold);

		placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.
	}

	// Medium hunt.
	int numMediumHunt = rmRandInt(6, 10);

	// 50% Chance for first, 40% chance for second, 10% chance for both.
	float mediumHuntFloat = rmRandFloat(0.0, 1.0);

	float mediumHunt1MinDist = rmRandFloat(50.0, 70.0);
	float mediumHunt1MaxDist = mediumHunt1MinDist + 15.0;

	// Medium hunt 1.
	int mediumHunt1ID = createObjectDefVerify("medium hunt 1");
	setObjectDefDistance(mediumHunt1ID, mediumHunt1MinDist, mediumHunt1MaxDist);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidAll);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidEdge);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidIsland);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidConnection);
	rmAddObjectDefConstraint(mediumHunt1ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHunt1ID, createClassDistConstraint(classStartingSettlement, mediumHunt1MinDist));
	rmAddObjectDefConstraint(mediumHunt1ID, createTypeDistConstraint("AbstractSettlement", 10.0));
	rmAddObjectDefConstraint(mediumHunt1ID, avoidHuntable);
	rmAddObjectDefConstraint(mediumHunt1ID, avoidTowerLOS);

	// Medium hunt 2.
	int mediumHunt2ID = createObjectDefVerify("medium hunt 2");


	if(randChance()) {
		addObjectDefItemVerify(mediumHunt1ID, "Gazelle", numMediumHunt, 4.0);
		addObjectDefItemVerify(mediumHunt2ID, "Zebra", numMediumHunt, 4.0);
	} else {
		addObjectDefItemVerify(mediumHunt2ID, "Gazelle", numMediumHunt, 4.0);
		addObjectDefItemVerify(mediumHunt1ID, "Zebra", numMediumHunt, 4.0);
	}

	if(mediumHuntFloat < 0.9) {
		placeObjectAtPlayerLocs(mediumHunt1ID);
	} else {
		placeObjectAtPlayerLocs(mediumHunt1ID);

		// Place second one atomically in case it fails.
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidIsland);
		addSimLocConstraint(avoidConnection);
		addSimLocConstraint(shortAvoidImpassableLand);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
		addSimLocConstraint(createTypeDistConstraint("AbstractSettlement", 10.0));
		addSimLocConstraint(createTypeDistConstraint("Huntable", 20.0));
		addSimLocConstraint(avoidTowerLOS);

		enableSimLocTwoPlayerCheck();

		addSimLoc(50.0, 90.0, avoidHuntDist, 0.0, 0.0, false, false, true);

		placeObjectAtNewSimLocs(mediumHunt2ID, false, "extra medium hunt 2", false);
	}

	// Player bonus hunt.
	float playerBonusHuntFloat = rmRandFloat(0.0, 1.0);

	int playerBonusHuntID = createObjectDefVerify("player bonus hunt");
	if(playerBonusHuntFloat < 0.5) {
		addObjectDefItemVerify(playerBonusHuntID, "Elephant", 2, 2.0);
	} else if(playerBonusHuntFloat < 0.75) {
		addObjectDefItemVerify(playerBonusHuntID, "Zebra", rmRandInt(3, 4), 2.0);
	} else {
		addObjectDefItemVerify(playerBonusHuntID, "Hippo", rmRandInt(3, 5), 2.0);
	}

	rmAddObjectDefConstraint(playerBonusHuntID, avoidAll);
	rmAddObjectDefConstraint(playerBonusHuntID, avoidEdge);
	rmAddObjectDefConstraint(playerBonusHuntID, avoidIsland);
	rmAddObjectDefConstraint(playerBonusHuntID, avoidConnection);
	rmAddObjectDefConstraint(playerBonusHuntID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(playerBonusHuntID, createClassDistConstraint(classStartingSettlement, 75.0));
	rmAddObjectDefConstraint(playerBonusHuntID, avoidHuntable);

	// Place normally (anywhere in player area).
	for(i = 1; < cPlayers) {
		placeObjectDefInArea(playerBonusHuntID, 0, rmAreaID("player area " + i));
	}

	// Center hunt.
	int numBonusHunt1 = 1;
	int numBonusHunt2 = 1;
	int bonusHuntAvoidHuntable = avoidHuntable; // Adjust this for 1v1 if it causes problems.

	if(cNonGaiaPlayers < 3) {
		if(randChance()) {
			numBonusHunt1 = rmRandInt(1, 2);
			numBonusHunt2 = 3 - numBonusHunt1;
			bonusHuntAvoidHuntable = createTypeDistConstraint("Huntable", 40.0);
		} else {
			numBonusHunt1 = 2;
			numBonusHunt2 = 2;
			bonusHuntAvoidHuntable = createTypeDistConstraint("Huntable", 30.0);
		}
	}

	// Center hunt 1.
	float centerHunt1Float = rmRandFloat(0.0, 1.0);

	int centerHunt1ID = createObjectDefVerify("center hunt 1");
	if(centerHunt1Float < 0.5) {
		addObjectDefItemVerify(centerHunt1ID, "Elephant", 2, 2.0);
	} else if(centerHunt1Float < 0.75) {
		addObjectDefItemVerify(centerHunt1ID, "Water Buffalo", rmRandInt(5, 6), 4.0);
		if(randChance()) {
			addObjectDefItemVerify(centerHunt1ID, "Zebra", rmRandInt(2, 4), 4.0);
		}
	} else {
		addObjectDefItemVerify(centerHunt1ID, "Gazelle", rmRandInt(6, 9), 2.0);
	}

	rmAddObjectDefConstraint(centerHunt1ID, avoidAll);
	rmAddObjectDefConstraint(centerHunt1ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(centerHunt1ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(centerHunt1ID, createClassDistConstraint(classStartingSettlement, 60.0));
	rmAddObjectDefConstraint(centerHunt1ID, bonusHuntAvoidHuntable);
	rmAddObjectDefConstraint(centerHunt1ID, farAvoidPlayer);

	placeObjectInPlayerSplits(centerHunt1ID, false, numBonusHunt1);

	// Center hunt 2.
	float centerHunt2Float = rmRandFloat(0.0, 1.0);

	int centerHunt2ID = createObjectDefVerify("center hunt 2");
	if(centerHunt2Float < 0.5) {
		addObjectDefItemVerify(centerHunt2ID, "Hippo", 3, 2.0);
	} else if(centerHunt2Float < 0.75) {
		addObjectDefItemVerify(centerHunt2ID, "Zebra", rmRandInt(4, 6), 4.0);
		if(randChance()) {
			addObjectDefItemVerify(centerHunt2ID, "Giraffe", rmRandInt(2, 4), 4.0);
		}
	} else {
		addObjectDefItemVerify(centerHunt2ID, "Rhinocerous", rmRandInt(2, 4), 2.0);
	}

	rmAddObjectDefConstraint(centerHunt2ID, avoidAll);
	rmAddObjectDefConstraint(centerHunt2ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(centerHunt2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(centerHunt2ID, createClassDistConstraint(classStartingSettlement, 60.0));
	rmAddObjectDefConstraint(centerHunt2ID, bonusHuntAvoidHuntable);
	rmAddObjectDefConstraint(centerHunt2ID, farAvoidPlayer);

	placeObjectInPlayerSplits(centerHunt2ID, false, numBonusHunt2);

	// Other food.
	// Starting food.
	placeObjectAtPlayerLocs(startingHuntID);

	// Far cranes.
	for(i = 1; < cPlayers) {
		// Into player areas.
		placeObjectDefInArea(farCranesID, 0, rmAreaID("player area " + i));
	}

	// Center contains a lot of things, place remaining food before forests.
	// Predators.
	for(i = 1; < cPlayers) {
		// Into player areas.
		placeObjectDefInArea(farPredators3ID, 0, rmAreaID("player area " + i), 2);
	}

	for(i = 1; < cPlayers) {
		// Into player areas.
		placeObjectDefInArea(farPredators1ID, 0, rmAreaID("player area " + i));
	}

	// Regularily place predators 2 (avoid player).
	placeObjectInPlayerSplits(farPredators2ID, false);

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID);

	// Far herdables.
	placeObjectInPlayerSplits(farHerdablesID, false, rmRandInt(1, 2));

	progress(0.8);

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
			if(randChance(0.8)) {
				rmSetAreaForestType(playerForestID, "Savannah Forest");
			} else {
				rmSetAreaForestType(playerForestID, "Palm Forest");
			}
			rmSetAreaMinBlobs(playerForestID, 2);
			rmSetAreaMaxBlobs(playerForestID, 4);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 20.0);
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
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		if(randChance(0.8)) {
			rmSetAreaForestType(forestID, "Savannah Forest");
		} else {
			rmSetAreaForestType(forestID, "Palm Forest");
		}
		rmSetAreaMinBlobs(forestID, 2);
		rmSetAreaMaxBlobs(forestID, 4);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 20.0);
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

	progress(0.9);

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	for(i = 1; < cPlayers) {
		// Into player areas.
		placeObjectDefInArea(relicID, 0, rmAreaID("player area " + i));
	}

	// Random trees.
	placeObjectAtPlayerLocs(randomTree1ID, false, 5);
	placeObjectAtPlayerLocs(randomTree2ID, false, 2);

	// Embellishment.
	// Bushes.
	int bush1ID = rmCreateObjectDef("bush 1");
	rmAddObjectDefItem(bush1ID, "Bush", 4, 4.0);
	rmSetObjectDefMinDistance(bush1ID);
	rmAddObjectDefConstraint(bush1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush1ID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush1ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	int bush2ID = rmCreateObjectDef("bush 2");
	rmAddObjectDefItem(bush2ID, "Bush", 3, 2.0);
	rmAddObjectDefItem(bush2ID, "Rock Sandstone Sprite", 1, 2.0);
	setObjectDefDistanceToMax(bush2ID);
	rmAddObjectDefConstraint(bush2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush2ID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	// Rocks.
	int rock1ID = rmCreateObjectDef("rock small");
	rmAddObjectDefItem(rock1ID, "Rock Sandstone Small", 3, 2.0);
	rmAddObjectDefItem(rock1ID, "Rock Limestone Sprite", 4, 3.0);
	setObjectDefDistanceToMax(rock1ID);
	rmAddObjectDefConstraint(rock1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rock1ID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(rock1ID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	int rock2ID = rmCreateObjectDef("rock sprite");
	rmAddObjectDefItem(rock2ID, "Rock Sandstone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rock2ID);
	rmAddObjectDefConstraint(rock2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rock2ID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(rock2ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	// Skeletons.
	int skeletonID = rmCreateObjectDef("skeleton");
	rmAddObjectDefItem(skeletonID, "Skeleton Animal", 1, 0.0);
	setObjectDefDistanceToMax(skeletonID);
	rmAddObjectDefConstraint(skeletonID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(skeletonID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(skeletonID, 0, 0.5, 0.5, 3 * cNonGaiaPlayers);

	// Water embellishment.
	int lilly1ID = rmCreateObjectDef("lilly 1");
	rmAddObjectDefItem(lilly1ID, "Water Lilly", 1, 0.0);
	setObjectDefDistanceToMax(lilly1ID);
	rmAddObjectDefConstraint(lilly1ID, embellishmentAvoidAll);
	rmPlaceObjectDefAtLoc(lilly1ID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	int lilly2ID = rmCreateObjectDef("lilly 2");
	rmAddObjectDefItem(lilly2ID, "Water Lilly", 4, 2.0);
	setObjectDefDistanceToMax(lilly2ID);
	rmAddObjectDefConstraint(lilly2ID, embellishmentAvoidAll);
	rmPlaceObjectDefAtLoc(lilly2ID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	int waterEmbellishmentID = rmCreateObjectDef("water embellishment");
	rmAddObjectDefItem(waterEmbellishmentID, "Water Decoration", 3, 6.0);
	setObjectDefDistanceToMax(waterEmbellishmentID);
	rmAddObjectDefConstraint(waterEmbellishmentID, embellishmentAvoidAll);
	rmPlaceObjectDefAtLoc(waterEmbellishmentID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

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
