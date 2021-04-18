/*
** MARSH
** RebelsRising
** Last edit: 26/03/2021
*/

include "rmx 5-0-0.xs";

string terrainMarshPool = "Marsh Pool";
string terrainMarshReplacement = "RiverMarshA";
string objectMarshTree = "Marsh Tree";
string forestMarshForest = "Marsh Forest";
string terrainMarshA = "MarshA";
string terrainMarshB = "MarshB";
string terrainMarshC = "MarshC";
string terrainMarshD = "MarshD";
string terrainMarshE = "MarshE";

void useVanillaTextures() {
	terrainMarshPool = "Greek River";
	terrainMarshReplacement = "RiverGrassyA";
	objectMarshTree = "Oak Tree";
	forestMarshForest = "Autumn Oak Forest";
	terrainMarshA = "GrassA";
	terrainMarshB = "GrassB";
	terrainMarshC = "GrassDirt25";
	terrainMarshD = "GrassDirt50";
	terrainMarshE = "GrassDirt25";
}

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
	if(cVersion == cVersionVanilla) {
		useVanillaTextures();
		rmxInit("Marsh (Vanilla)");
	} else {
		rmxInit("Marsh");
	}

	// Set size.
	int axisLength = getStandardMapDimInMeters(9000, 0.9, 1.8);

	// Set water type.
	rmSetSeaLevel(1.0);
	rmSetSeaType(terrainMarshPool);

	// Initialize map.
	initializeMap("Water", axisLength);

	// Player placement.
	placePlayersInCircle(0.38, 0.4);

	// Control areas.
	int classCenter = initializeCenter();
	int classCorner = initializeCorners();
	int classSplit = initializeSplit();
	int classCenterline = initializeCenterline();

	// Classes.
	int classFakeCenter = rmDefineClass("fake center"); // Only to add 1 small area in the center.
	int classConnection = rmDefineClass("connection");
	int classAllyConnection = rmDefineClass("ally connection");
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
	int mediumAvoidPlayer = createClassDistConstraint(classPlayer, 10.0);
	int farAvoidPlayer = createClassDistConstraint(classPlayer, 20.0);
	int avoidFakeCenter = createClassDistConstraint(classFakeCenter, 60.0);
	int avoidConnection = createClassDistConstraint(classConnection, 1.0);
	int avoidAllyConnection = createClassDistConstraint(classAllyConnection, 1.0);
	int avoidPlayerCore = createClassDistConstraint(classPlayerCore, 60.0);
	int shortAvoidIsland = createClassDistConstraint(classIsland, 20.0);
	int mediumAvoidIsland = createClassDistConstraint(classIsland, 30.0);
	int farAvoidIsland = createClassDistConstraint(classIsland, 40.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int mediumAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 25.0);

	// Terrain.
	int shortAvoidImpassableLand = createTerrainDistConstraint("Land", false, 5.0);
	int farAvoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);
	int nearShore = createTerrainMaxDistConstraint("Water", true, 6.0);

	// Gold.
	float avoidGoldDist = 30.0;

	int shortAvoidGold = createTypeDistConstraint("Gold", 10.0);
	int farAvoidGold = createTypeDistConstraint("Gold", avoidGoldDist);

	// Food.
	float avoidHuntDist = 35.0;

	int avoidHuntable = createTypeDistConstraint("Huntable", avoidHuntDist);
	int avoidHerdable = createTypeDistConstraint("Herdable", 30.0);
	int avoidPredator = createTypeDistConstraint("AnimalPredator", 40.0);

	// Loosen constraints for anything but 1v1 as player areas become very small.
	if(cNonGaiaPlayers > 2) { // 4 players is also problematic.
		// avoidHuntable = createTypeDistConstraint("Huntable", 30.0);
		avoidHerdable = createTypeDistConstraint("Herdable", 20.0);
		// avoidPredator = createTypeDistConstraint("AnimalPredator", 20.0);
	}

	// Forest.
	int shortAvoidForest = createClassDistConstraint(classForest, 24.0);
	int farAvoidForest = createClassDistConstraint(classForest, 30.0);
	int forestAvoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 20.0);
	int treeAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 13.0);

	// Relics.
	int avoidRelic = createTypeDistConstraint("Relic", 40.0);

	// Buildings.
	int avoidBuildings = createTypeDistConstraint("Building", 25.0);
	int avoidTowerLOS = createTypeDistConstraint("Tower", 35.0);
	int avoidTower = createTypeDistConstraint("Tower", 25);

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
	addObjectDefItemVerify(startingHuntID, "Deer", rmRandInt(6, 8), 2.0);
	setObjectDefDistance(startingHuntID, 23.0, 27.0);
	rmAddObjectDefConstraint(startingHuntID, avoidAll);
	rmAddObjectDefConstraint(startingHuntID, avoidEdge);
	rmAddObjectDefConstraint(startingHuntID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(startingHuntID, createTypeDistConstraint("Huntable", 30.0));

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Pig", 4, 2.0);
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, shortAvoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Oak Tree", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Pig", rmRandInt(2, 3), 4.0);
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, shortAvoidPlayer);
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
	rmAddObjectDefConstraint(farCranesID, shortAvoidIsland);
	rmAddObjectDefConstraint(farCranesID, avoidHuntable);
	rmAddObjectDefConstraint(farCranesID, createClassDistConstraint(classStartingSettlement, 70.0));

	// Far predators 1 (near water/island), don't verify.
	int farPredators1ID = createObjectDefVerify("far predators 1", cDebugMode >= cDebugFull);
	addObjectDefItemVerify(farPredators1ID, "Crocodile", 1, 0.0);
	rmAddObjectDefConstraint(farPredators1ID, avoidAll);
	rmAddObjectDefConstraint(farPredators1ID, avoidEdge);
	rmAddObjectDefConstraint(farPredators1ID, nearShore);
	rmAddObjectDefConstraint(farPredators1ID, shortAvoidIsland);
	rmAddObjectDefConstraint(farPredators1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredators1ID, mediumAvoidSettlement);
	rmAddObjectDefConstraint(farPredators1ID, avoidPredator);

	// Far predators 2 (near water/center), don't verify.
	int farPredators2ID = createObjectDefVerify("far predators 2", cDebugMode >= cDebugFull);
	addObjectDefItemVerify(farPredators2ID, "Crocodile", 1, 0.0);
	rmAddObjectDefConstraint(farPredators2ID, avoidAll);
	rmAddObjectDefConstraint(farPredators2ID, avoidEdge);
	rmAddObjectDefConstraint(farPredators2ID, nearShore);
	rmAddObjectDefConstraint(farPredators2ID, shortAvoidPlayer);
	rmAddObjectDefConstraint(farPredators2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredators2ID, mediumAvoidSettlement);
	rmAddObjectDefConstraint(farPredators2ID, avoidPredator);

	// Other objects.
	// Relics.
	int relicID = createObjectDefVerify("relic");
	addObjectDefItemVerify(relicID, "Relic", 1, 0.0);
	setObjectDefDistanceToMax(relicID); // Don't place in splits, too many relics.
	rmAddObjectDefConstraint(relicID, avoidAll);
	rmAddObjectDefConstraint(relicID, avoidEdge);
	rmAddObjectDefConstraint(relicID, avoidCorner);
	rmAddObjectDefConstraint(relicID, shortAvoidPlayer);
	rmAddObjectDefConstraint(relicID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 50.0)); // Very short due to many relics being present.
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random tree 1.
	int randomTree1ID = rmCreateObjectDef("random tree 1");
	rmAddObjectDefItem(randomTree1ID, "Oak Tree", 1, 0.0);
	setObjectDefDistanceToMax(randomTree1ID);
	rmAddObjectDefConstraint(randomTree1ID, avoidAll);
	rmAddObjectDefConstraint(randomTree1ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomTree1ID, shortAvoidIsland);
	rmAddObjectDefConstraint(randomTree1ID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTree1ID, treeAvoidSettlement);

	// Random tree 2.
	int randomTree2ID = rmCreateObjectDef("random tree 2");
	rmAddObjectDefItem(randomTree2ID, objectMarshTree, 1, 0.0);
	setObjectDefDistanceToMax(randomTree2ID);
	rmAddObjectDefConstraint(randomTree2ID, avoidAll);
	rmAddObjectDefConstraint(randomTree2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(randomTree2ID, shortAvoidPlayer);
	rmAddObjectDefConstraint(randomTree2ID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTree2ID, treeAvoidSettlement);

	progress(0.1);

	// Connections.
	// Create player connections.
	int shallowsID = rmCreateConnection("shallows");
	rmSetConnectionType(shallowsID, cConnectAreas, false, 1.0);
	rmSetConnectionWidth(shallowsID, 28.0, 2);
	rmAddConnectionTerrainReplacement(shallowsID, terrainMarshReplacement, terrainMarshE);
	rmSetConnectionBaseHeight(shallowsID, 2.0);
	rmSetConnectionHeightBlend(shallowsID, 2);
	rmSetConnectionSmoothDistance(shallowsID, 3);
	rmSetConnectionWarnFailure(shallowsID, false);

	// Create extra connections.
	int extraShallowsID = rmCreateConnection("extra shallows");
	rmSetConnectionType(extraShallowsID, cConnectAreas, false, 0.75);
	rmSetConnectionWidth(extraShallowsID, 28.0, 2);
	rmAddConnectionTerrainReplacement(extraShallowsID, terrainMarshReplacement, terrainMarshE);
	rmSetConnectionBaseHeight(extraShallowsID, 2.0);
	rmSetConnectionHeightBlend(extraShallowsID, 2);
	rmSetConnectionSmoothDistance(extraShallowsID, 3);
	rmSetConnectionPositionVariance(extraShallowsID, -1.0);
	rmAddConnectionStartConstraint(extraShallowsID, avoidPlayerCore);
	rmAddConnectionEndConstraint(extraShallowsID, avoidPlayerCore);
	rmSetConnectionWarnFailure(extraShallowsID, false);

	// Create team connections.
	int teamShallowsID = rmCreateConnection("team shallows");
	rmSetConnectionType(teamShallowsID, cConnectAllies, false, 1.0);
	rmSetConnectionWidth(teamShallowsID, 28.0, 2);
	rmAddConnectionTerrainReplacement(teamShallowsID, terrainMarshReplacement, terrainMarshE);
	rmSetConnectionBaseHeight(teamShallowsID, 2.0);
	rmSetConnectionHeightBlend(teamShallowsID, 2);
	rmSetConnectionSmoothDistance(teamShallowsID, 3);
	rmAddConnectionToClass(teamShallowsID, classAllyConnection);
	rmSetConnectionWarnFailure(teamShallowsID, false);

	// Define 3rd settlement connections.
	for(i = 1; < cPlayers) {
		int connectionID = rmCreateConnection("settlement connection " + i);
		rmSetConnectionType(connectionID, cConnectAreas, false, 1.0);
		rmSetConnectionWidth(connectionID, 28.0, 2);
		rmAddConnectionTerrainReplacement(connectionID, terrainMarshReplacement, terrainMarshE);
		rmSetConnectionBaseHeight(connectionID, 2.0);
		rmSetConnectionHeightBlend(connectionID, 2);
		rmSetConnectionSmoothDistance(connectionID, 3.0);
		rmAddConnectionToClass(connectionID, classConnection);
		rmSetConnectionWarnFailure(connectionID, false);

		// Store in array.
		setConnectionID(i, connectionID);
	}

	// Set up fake player areas.
	float fakePlayerAreaSize = rmAreaTilesToFraction(200);

	for(i = 1; < cPlayers) {
		int fakePlayerAreaID = rmCreateArea("fake player area " + i);
		rmSetAreaSize(fakePlayerAreaID, fakePlayerAreaSize);
		rmSetAreaLocPlayer(fakePlayerAreaID, getPlayer(i));
		// rmSetAreaTerrainType(fakePlayerAreaID, "HadesBuildable1");
		rmSetAreaCoherence(fakePlayerAreaID, 1.0);
		// rmSetAreaBaseHeight(fakePlayerAreaID, 2.0);
		// rmSetAreaHeightBlend(fakePlayerAreaID, 2);
		rmAddAreaToClass(fakePlayerAreaID, classPlayerCore);
		rmSetAreaWarnFailure(fakePlayerAreaID, false);
		rmBuildArea(fakePlayerAreaID);
	}

	// Fake center.
	int fakeCenterID = rmCreateArea("fake center");
	rmSetAreaSize(fakeCenterID, 0.01);
	rmSetAreaLocation(fakeCenterID, 0.5, 0.5);
	// rmSetAreaTerrainType(fakeCenterID, "HadesBuildable1");
	// rmSetAreaBaseHeight(fakeCenterID, 2.0);
	rmSetAreaCoherence(fakeCenterID, 1.0);
	rmAddAreaToClass(fakeCenterID, classFakeCenter);
	rmSetAreaWarnFailure(fakeCenterID, false);
	rmBuildArea(fakeCenterID);

	// Center.
	int numBonusIsland = 0;
	float bonusIslandSize = rmAreaTilesToFraction(2800);

	if(cNonGaiaPlayers < 3) {
		numBonusIsland = 5;
	} else if(cNonGaiaPlayers < 5) {
		numBonusIsland = 4;
	} else {
		numBonusIsland = rmRandInt(4, 5);
	}

	float islandEdgeDist = rmXTilesToFraction(30);
	int islandAvoidEdge = createSymmetricBoxConstraint(islandEdgeDist, islandEdgeDist);

	for(i = 0; < numBonusIsland) {
		int bonusIslandID = rmCreateArea("bonus island " + i);
		rmSetAreaSize(bonusIslandID, 0.9 * bonusIslandSize, 1.1 * bonusIslandSize);
		rmSetAreaTerrainType(bonusIslandID, terrainMarshA);
		rmAddAreaTerrainLayer(bonusIslandID, terrainMarshB, 0, 6);
		rmSetAreaCoherence(bonusIslandID, 0.25);
		rmSetAreaBaseHeight(bonusIslandID, 2.0);
		rmSetAreaHeightBlend(bonusIslandID, 2);
		rmSetAreaSmoothDistance(bonusIslandID, 12);
		rmAddAreaToClass(bonusIslandID, classIsland);
		rmAddAreaConstraint(bonusIslandID, shortAvoidIsland);
		rmAddAreaConstraint(bonusIslandID, islandAvoidEdge);
		rmAddAreaConstraint(bonusIslandID, avoidPlayerCore);
		rmAddConnectionArea(extraShallowsID, bonusIslandID);
		rmAddConnectionArea(shallowsID, bonusIslandID);
		rmSetAreaWarnFailure(bonusIslandID, false);
	}

	rmBuildAllAreas();

	// Set up player areas.
	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, 0.5);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, terrainMarshD);
		rmAddAreaTerrainLayer(playerAreaID, terrainMarshD, 4, 7);
		rmAddAreaTerrainLayer(playerAreaID, terrainMarshD, 2, 4);
		rmAddAreaTerrainLayer(playerAreaID, terrainMarshE, 0, 2);
		rmSetAreaCoherence(playerAreaID, 0.5);
		rmSetAreaBaseHeight(playerAreaID, 6.0);
		rmSetAreaHeightBlend(playerAreaID, 2);
		rmSetAreaSmoothDistance(playerAreaID, 10);
		rmSetAreaMinBlobs(playerAreaID, 3);
		rmSetAreaMaxBlobs(playerAreaID, 6);
		rmSetAreaMinBlobDistance(playerAreaID, 7.0);
		rmSetAreaMaxBlobDistance(playerAreaID, 12.0);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmAddAreaConstraint(playerAreaID, avoidFakeCenter);
		rmAddAreaConstraint(playerAreaID, shortAvoidIsland);
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

	// Build the player areas here.
	rmBuildAllAreas();

	rmBuildConnection(teamShallowsID);
	rmBuildConnection(shallowsID);
	if(cNonGaiaPlayers < 3) {
		rmBuildConnection(extraShallowsID);
	}

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(40));
		rmSetAreaTerrainType(beautificationID, terrainMarshC);
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmAddAreaConstraint(beautificationID, mediumAvoidPlayer);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(40));
		rmSetAreaTerrainType(beautificationID, "GrassB");
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmAddAreaConstraint(beautificationID, shortAvoidIsland);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 20 * cPlayers) {
		beautificationID = rmCreateArea("beautification 3 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(50));
		rmSetAreaTerrainType(beautificationID, "GrassDirt50");
		rmAddAreaTerrainLayer(beautificationID, "GrassDirt25", 0, 2);
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, shortAvoidImpassableLand);
		rmAddAreaConstraint(beautificationID, shortAvoidIsland);
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
	int numFairLocTries = 4;

	for(i = 0; < numFairLocTries) {
		addFairLocConstraint(avoidTowerLOS);
		addFairLocConstraint(farAvoidImpassableLand);
		addFairLocConstraint(shortAvoidPlayer); // Was: mediumAvoidPlayer.

		if(cNonGaiaPlayers > 2 && cNonGaiaPlayers < 9 && i < 2) {
			// addFairLocConstraint(avoidAllyConnection);
		}

		enableFairLocTwoPlayerCheck();

		if(cNonGaiaPlayers < 3) {
			addFairLoc(70.0, 95.0, true, false, 80.0 - 5.0 * i, 12.0, 12.0, true);
		} else if(cNonGaiaPlayers < 5) {
			addFairLoc(70.0, 95.0 + 5.0 * i, true, true, 70.0 - 10.0 * i, 12.0, 12.0, false, gameHasTwoEqualTeams() && i < 1);
		} else if(cNonGaiaPlayers < 7) {
			addFairLoc(70.0, 110.0 + 5.0 * i, true, false, 70.0 - 5.0 * i, 12.0, 12.0, false, gameHasTwoEqualTeams() && i < 1);
		} else if(cNonGaiaPlayers < 9) {
			addFairLoc(70.0, 125.0, true, false, 60.0 - 5.0 * i, 12.0, 12.0);
		} else {
			addFairLoc(100.0, 200.0, true, false, 50.0 - 5.0 * i, 12.0, 12.0);
		}

		if(createFairLocs("far settlement " + i, i == (numFairLocTries - 1))) { // Only log last try.
			break;
		}

		resetFairLocs();
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

	// Close settlement.
	enableFairLocTwoPlayerCheck();

	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(farAvoidImpassableLand);

	// if(cNonGaiaPlayers < 3) {
		// addFairLocConstraint(avoidCorner);
	// } else {
		// addFairLocConstraint(avoidAllyConnection);
	// }

	if(cNonGaiaPlayers < 9) {
		addFairLocConstraint(shortAvoidIsland);
		addFairLocConstraint(createTypeDistConstraint("AbstractSettlement", 60.0));
		addFairLoc(60.0, 80.0, false, true, 40.0, 12.0, 12.0);
	} else {
		addFairLocConstraint(createTypeDistConstraint("AbstractSettlement", 45.0));
		addFairLoc(45.0, 80.0, false, true, 40.0, 12.0, 12.0);
	}

	placeObjectAtNewFairLocs(settlementID, false, "close settlement");

	progress(0.4);

	// Elevation.
	int elevationID = 0;

	for(i = 0; < 10 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation 1 " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(120));
		if(randChance(0.7)) {
			rmSetAreaTerrainType(elevationID, terrainMarshD);
			rmAddAreaTerrainLayer(elevationID, terrainMarshE, 0, 4);
		}
		rmSetAreaBaseHeight(elevationID, rmRandFloat(4.0, 8.0));
		rmSetAreaHeightBlend(elevationID, 2);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 3);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 40.0);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmAddAreaConstraint(elevationID, shortAvoidImpassableLand);
		rmAddAreaConstraint(elevationID, shortAvoidIsland);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	progress(0.5);

	// Gold.
	int numMediumGold = 0;
	int numFarGold = 0;
	int numBonusGold = 0;
	int mediumGoldID = -1;
	int farGoldID = -1;
	int bonusGoldID = -1;

	if(cNonGaiaPlayers < 3) {
		// 1v1 gold.
		// Medium gold.
		numMediumGold = rmRandInt(1, 2);

		mediumGoldID = createObjectDefVerify("medium gold");
		addObjectDefItemVerify(mediumGoldID, "Gold Mine", 1, 0.0);
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(avoidCorner);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidIsland);
		addSimLocConstraint(farAvoidImpassableLand);
		addSimLocConstraint(farAvoidGold);
		// addSimLocConstraint(avoidConnection);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
		addSimLocConstraint(farAvoidSettlement);

		enableSimLocTwoPlayerCheck();

		addSimLoc(50.0, 67.5, avoidGoldDist, 0.0, 0.0, false, false, true);

		placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold 1");

		if(numMediumGold == 2) {
			addSimLocConstraint(avoidAll);
			addSimLocConstraint(avoidEdge);
			addSimLocConstraint(avoidCorner);
			addSimLocConstraint(avoidTowerLOS);
			addSimLocConstraint(farAvoidIsland);
			addSimLocConstraint(farAvoidImpassableLand);
			addSimLocConstraint(farAvoidGold);
			// addSimLocConstraint(avoidConnection);
			addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
			addSimLocConstraint(mediumAvoidSettlement);

			enableSimLocTwoPlayerCheck();

			addSimLoc(50.0, 90.0, avoidGoldDist, 0.0, 0.0, false, false, true);

			if(placeObjectAtNewSimLocs(mediumGoldID, false, "medium gold 2", false) == false) { // Fail gracefully.
				numMediumGold = numMediumGold - 1;
			}
		}

		// Far gold.
		numFarGold = rmRandInt(1, 2);

		for(i = 1; < 3) {
			farGoldID = createObjectDefVerify("far gold " + i);
			addObjectDefItemVerify(farGoldID, "Gold Mine", 1, 0.0);
			setObjectDefDistance(farGoldID, 80.0, 55.0 + 35.0 * max(numMediumGold, numFarGold));
			rmAddObjectDefConstraint(farGoldID, avoidAll);
			rmAddObjectDefConstraint(farGoldID, avoidEdge);
			rmAddObjectDefConstraint(farGoldID, avoidCorner);
			rmAddObjectDefConstraint(farGoldID, shortAvoidImpassableLand);
			rmAddObjectDefConstraint(farGoldID, mediumAvoidIsland);
			rmAddObjectDefConstraint(farGoldID, createClassDistConstraint(classStartingSettlement, 80.0));
			rmAddObjectDefConstraint(farGoldID, mediumAvoidSettlement);
			rmAddObjectDefConstraint(farGoldID, farAvoidGold);
			rmAddObjectDefConstraint(farGoldID, createAreaConstraint(rmAreaID("player area " + i)));

			placeObjectAtPlayerLoc(farGoldID, false, i, numFarGold);
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

		if(numBonusGold == 1) {
			setObjectDefDistance(bonusGoldID, 70.0, 85.0);
			rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 70.0));

			placeObjectAtPlayerLocs(bonusGoldID, false, numBonusGold);
		} else {
			rmAddObjectDefConstraint(bonusGoldID, avoidTowerLOS);
			placeObjectInPlayerSplits(bonusGoldID, false, numBonusGold);
		}
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
		rmAddObjectDefConstraint(mediumGoldID, shortAvoidImpassableLand);
		rmAddObjectDefConstraint(mediumGoldID, avoidAllyConnection);
		rmAddObjectDefConstraint(mediumGoldID, farAvoidIsland);
		rmAddObjectDefConstraint(mediumGoldID, createClassDistConstraint(classStartingSettlement, 50.0));
		rmAddObjectDefConstraint(mediumGoldID, shortAvoidSettlement);
		rmAddObjectDefConstraint(mediumGoldID, farAvoidGold);

		placeObjectAtPlayerLocs(mediumGoldID, false, numMediumGold);

		// Far gold.
		if(randChance(2.0 /  3.0)) {
			numFarGold = 1;
		} else {
			numFarGold = 2;
		}

		farGoldID = createObjectDefVerify("far gold");
		addObjectDefItemVerify(farGoldID, "Gold Mine", 1, 0.0);
		rmAddObjectDefConstraint(farGoldID, avoidAll);
		rmAddObjectDefConstraint(farGoldID, avoidEdge);
		if(numFarGold == 1) {
			rmAddObjectDefConstraint(farGoldID, farAvoidImpassableLand);
		} else {
			rmAddObjectDefConstraint(farGoldID, shortAvoidImpassableLand);
		}
		// rmAddObjectDefConstraint(farGoldID, avoidAllyConnection);
		rmAddObjectDefConstraint(farGoldID, avoidTowerLOS);
		rmAddObjectDefConstraint(farGoldID, shortAvoidIsland);
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
		// rmAddObjectDefConstraint(bonusGoldID, islandAvoidEdge);
		rmAddObjectDefConstraint(bonusGoldID, farAvoidImpassableLand);
		rmAddObjectDefConstraint(bonusGoldID, shortAvoidPlayer);
		rmAddObjectDefConstraint(bonusGoldID, shortAvoidSettlement);
		rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 60.0));
		rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);

		placeObjectInTeamSplits(bonusGoldID, false, numBonusGold);
	}

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	// storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(farAvoidImpassableLand);
	storeObjectConstraint(farAvoidGold);

	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Close hunt.
	bool huntInStartingLOS = randChance(2.0 / 3.0);
	float closeHuntFloat = rmRandFloat(0.0, 1.0);

	if(closeHuntFloat < 0.3) {
		storeObjectDefItem("Hippo", 2, 2.0);
	} else if(closeHuntFloat < 0.6) {
		storeObjectDefItem("Hippo", 3, 2.0);
	} else {
		storeObjectDefItem("Water Buffalo", 2, 2.0);
	}

	// Place outside of starting LOS if randomized, fall back to starting LOS if placement fails.
	if(huntInStartingLOS == false) {
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(shortAvoidIsland);
		addSimLocConstraint(shortAvoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		// addSimLocConstraint(shortAvoidGold);

		enableSimLocTwoPlayerCheck();

		addSimLoc(45.0, 55.0, avoidHuntDist, 8.0, 8.0, false, false, true);

		if(placeObjectAtNewSimLocs(createObjectFromStorage("close hunt"), false, "close hunt", false) == false) {
			huntInStartingLOS = true;
		}
	}

	// This is uglier than it should be, but it works well.
	if(huntInStartingLOS) {
		// If we have hunt in starting LOS, we want to force it within tower ranges so we know it's within LOS.
		storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 15.0)));
		storeObjectConstraint(avoidAll);
		storeObjectConstraint(avoidEdge);
		storeObjectConstraint(farAvoidImpassableLand);
		storeObjectConstraint(shortAvoidGold);

		placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.
	}

	// Player bonus hunt.
	// Player bonus hunt 1.
	float playerBonusHunt1Float = rmRandFloat(0.0, 1.0);

	int playerBonusHunt1ID = createObjectDefVerify("player bonus hunt 1");
	if(playerBonusHunt1Float < 0.5) {
		addObjectDefItemVerify(playerBonusHunt1ID, "Water Buffalo", 2, 2.0);
	} else if(playerBonusHunt1Float < 0.75) {
		addObjectDefItemVerify(playerBonusHunt1ID, "Deer", rmRandInt(5, 6), 2.0);
	} else {
		addObjectDefItemVerify(playerBonusHunt1ID, "Hippo", rmRandInt(3, 5), 2.0);
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
	addSimLocConstraint(shortAvoidIsland);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(farAvoidImpassableLand);
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(shortAvoidGold);
	addSimLocConstraint(avoidConnection);

	addSimLoc(50.0, 90.0, avoidHuntDist, 8.0, 8.0, false, false, true);

	// Player bonus hunt 2.
	float playerBonusHunt2Float = rmRandFloat(0.0, 1.0);

	int playerBonusHunt2ID = createObjectDefVerify("player bonus hunt 2");
	if(playerBonusHunt2Float < 0.5) {
		addObjectDefItemVerify(playerBonusHunt2ID, "Hippo", 2, 2.0);
	} else if(playerBonusHunt2Float < 0.75) {
		addObjectDefItemVerify(playerBonusHunt2ID, "Water Buffalo", rmRandInt(3, 4), 2.0);
		if(randChance()) {
			addObjectDefItemVerify(playerBonusHunt2ID, "Deer", rmRandInt(2, 4), 2.0);
		}
	} else {
		addObjectDefItemVerify(playerBonusHunt2ID, "Deer", rmRandInt(6, 9), 2.0);
	}

	addSimLocWithPrevConstraints(50.0, 90.0, avoidHuntDist, 8.0, 8.0);

	if(cNonGaiaPlayers < 3) {
		createSimLocs("player bonus hunt");

		placeObjectAtSimLoc(playerBonusHunt1ID, false, 1);
		placeObjectAtSimLoc(playerBonusHunt2ID, false, 2);
	} else {
		// Apply constraints instead of placing a sim loc.
		applySimLocConstraintsToObject(playerBonusHunt1ID);
		applySimLocConstraintsToObject(playerBonusHunt2ID);

		// Place normally (anywhere in player area).
		for(i = 1; < cPlayers) {
			placeObjectDefInArea(playerBonusHunt1ID, 0, rmAreaID("player area " + i));
			placeObjectDefInArea(playerBonusHunt2ID, 0, rmAreaID("player area " + i));
		}
	}

	resetSimLocs();

	// Center hunt. Don't verify because we're placing enough anyway.
	int numBonusHunt1 = 2;
	int numBonusHunt2 = 2;
	int bonusHuntAvoidHuntable = createTypeDistConstraint("Huntable", 20.0);

	// Center hunt 1.
	float centerHunt1Float = rmRandFloat(0.0, 1.0);

	int centerHunt1ID = rmCreateObjectDef("center hunt 1");
	if(centerHunt1Float < 0.5) {
		rmAddObjectDefItem(centerHunt1ID, "Boar", 4, 2.0);
	} else if(centerHunt1Float < 0.75) {
		rmAddObjectDefItem(centerHunt1ID, "Boar", 6, 4.0);
		if(randChance()) {
			rmAddObjectDefItem(centerHunt1ID, "Crowned Crane", rmRandInt(4, 6), 4.0);
		}
	} else {
		rmAddObjectDefItem(centerHunt1ID, "Water Buffalo", rmRandInt(4, 5), 2.0);
	}

	rmAddObjectDefConstraint(centerHunt1ID, avoidAll);
	rmAddObjectDefConstraint(centerHunt1ID, avoidEdge);
	rmAddObjectDefConstraint(centerHunt1ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(centerHunt1ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(centerHunt1ID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(centerHunt1ID, bonusHuntAvoidHuntable);
	rmAddObjectDefConstraint(centerHunt1ID, shortAvoidPlayer);
	rmAddObjectDefConstraint(centerHunt1ID, avoidTowerLOS);

	placeObjectInTeamSplits(centerHunt1ID, false, numBonusHunt1);

	// Center hunt 2.
	float centerHunt2Float = rmRandFloat(0.0, 1.0);

	int centerHunt2ID = rmCreateObjectDef("center hunt 2");
	if(centerHunt2Float < 0.5) {
		rmAddObjectDefItem(centerHunt2ID, "Boar", 4, 2.0);
	} else if(centerHunt2Float < 0.75) {
		rmAddObjectDefItem(centerHunt2ID, "Boar", 6, 4.0);
		if(randChance()) {
			rmAddObjectDefItem(centerHunt2ID, "Crowned Crane", rmRandInt(4, 6), 4.0);
		}
	} else {
		rmAddObjectDefItem(centerHunt2ID, "Water Buffalo", rmRandInt(2, 3), 2.0);
	}

	rmAddObjectDefConstraint(centerHunt2ID, avoidAll);
	rmAddObjectDefConstraint(centerHunt2ID, avoidEdge);
	rmAddObjectDefConstraint(centerHunt2ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(centerHunt2ID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(centerHunt2ID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(centerHunt2ID, bonusHuntAvoidHuntable);
	rmAddObjectDefConstraint(centerHunt2ID, shortAvoidPlayer);
	rmAddObjectDefConstraint(centerHunt2ID, avoidTowerLOS);

	placeObjectInTeamSplits(centerHunt2ID, false, numBonusHunt2);

	// Other food.
	// Starting food.
	placeObjectAtPlayerLocs(startingHuntID);

	// Far cranes.
	for(i = 1; < cPlayers) {
		// Into player areas.
		placeObjectDefInArea(farCranesID, 0, rmAreaID("player area " + i));
	}

	// Center contains a lot of things, place remaining food before forests.
	// Predators (not verified).
	for(i = 1; < cPlayers) {
		// Into player areas.
		placeObjectDefInArea(farPredators1ID, 0, rmAreaID("player area " + i));
	}

	placeObjectInPlayerSplits(farPredators2ID);

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID);

	// Far herdables.
	placeObjectInTeamSplits(farHerdablesID, false, rmRandInt(1, 2));

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
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(160));
			rmSetAreaForestType(playerForestID, "Mixed Oak Forest");
			rmSetAreaMinBlobs(playerForestID, 2);
			rmSetAreaMaxBlobs(playerForestID, 4);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 20.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, farAvoidForest);
			rmAddAreaConstraint(playerForestID, shortAvoidIsland);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, shortAvoidImpassableLand);
			rmSetAreaWarnFailure(playerForestID, false);

			// if(randChance(0.6)) {
				// rmSetAreaBaseHeight(playerForestID, rmRandFloat(6.0, 8.0));
			// }
			rmSetAreaSmoothDistance(playerForestID, 6);
			rmSetAreaHeightBlend(playerForestID, 2);

			rmBuildArea(playerForestID);
		}
	}

	// Other player forest.
	int numIslandForests = 6 - numPlayerForests;

	for(p = 1; < cPlayers) {
		int forestFailCount = 0;

		for(i = 0; < numIslandForests) {
			int islandForestID = rmCreateArea("island forest " + p + " " + i, rmAreaID("player area " + p));
			rmSetAreaSize(islandForestID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(160));
			rmSetAreaForestType(islandForestID, "Mixed Oak Forest");
			rmSetAreaMinBlobs(islandForestID, 2);
			rmSetAreaMaxBlobs(islandForestID, 4);
			rmSetAreaMinBlobDistance(islandForestID, 16.0);
			rmSetAreaMaxBlobDistance(islandForestID, 20.0);
			rmAddAreaToClass(islandForestID, classForest);
			rmAddAreaConstraint(islandForestID, avoidAll);
			rmAddAreaConstraint(islandForestID, shortAvoidIsland);
			rmAddAreaConstraint(islandForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(islandForestID, farAvoidForest);
			rmAddAreaConstraint(islandForestID, shortAvoidImpassableLand);
			rmSetAreaWarnFailure(islandForestID, false);

			// if(randChance(0.6)) {
				// rmSetAreaBaseHeight(islandForestID, rmRandFloat(6.0, 8.0));
			// }
			rmSetAreaSmoothDistance(islandForestID, 6);
			rmSetAreaHeightBlend(islandForestID, 2);

			if(rmBuildArea(islandForestID) == false) {
				forestFailCount++;

				if(forestFailCount == 3) {
					break;
				}
			} else {
				forestFailCount = 0;
			}
		}
	}

	// Center forest.
	int numRegularForests = 3;
	forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("center forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaForestType(forestID, forestMarshForest);
		rmSetAreaTerrainType(forestID, terrainMarshA);
		rmAddAreaTerrainLayer(forestID, terrainMarshB, 0, 2);
		rmSetAreaBaseHeight(forestID, 0.0);
		rmSetAreaSmoothDistance(forestID, 4);
		rmSetAreaHeightBlend(forestID, 2);
		rmSetAreaMinBlobs(forestID, 2);
		rmSetAreaMaxBlobs(forestID, 4);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 20.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, shortAvoidPlayer);
		rmAddAreaConstraint(forestID, shortAvoidForest);
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

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectDefAtLoc(relicID, 0, 0.5, 0.5, 2 * cNonGaiaPlayers);

	// Random trees.
	placeObjectAtPlayerLocs(randomTree1ID, false, 10);
	placeObjectAtPlayerLocs(randomTree2ID, false, 15);

	progress(0.9);

	// Embellishment.
	// Logs.
	int logID = rmCreateObjectDef("log");
	rmAddObjectDefItem(logID, "Rotting Log", rmRandInt(1, 2), 0.0);
	rmAddObjectDefItem(logID, "Bush", 1, 2.0);
	rmAddObjectDefItem(logID, "Grass", rmRandInt(3, 5), 2.0);
	setObjectDefDistanceToMax(logID);
	rmAddObjectDefConstraint(logID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(logID, shortAvoidPlayer);
	rmAddObjectDefConstraint(logID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(logID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	// Grass.
	int grassID = rmCreateObjectDef("grass");
	rmAddObjectDefItem(grassID, "Grass", rmRandInt(3, 5), 5.0);
	rmAddObjectDefItem(grassID, "Bush", rmRandInt(1, 3), 2.0);
	rmAddObjectDefItem(grassID, "Rock Limestone Sprite", rmRandInt(2, 4), 10.0);
	setObjectDefDistanceToMax(grassID);
	rmAddObjectDefConstraint(grassID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(grassID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(grassID, shortAvoidIsland);
	rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 15 * cNonGaiaPlayers);

	// Reeds.
	int reedsID = rmCreateObjectDef("reeds");
	rmAddObjectDefItem(reedsID, "Water Reeds", rmRandInt(4, 6), 2.0);
	rmAddObjectDefItem(reedsID, "Rock Granite Big", rmRandInt(1, 3), 3.0);
	setObjectDefDistanceToMax(reedsID);
	rmAddObjectDefConstraint(reedsID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(reedsID, nearShore);
	rmPlaceObjectDefAtLoc(reedsID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	// Lillies.
	int lillyID = rmCreateObjectDef("lilly");
	rmAddObjectDefItem(lillyID, "Water Lilly", rmRandInt(3, 5), 4.0);
	setObjectDefDistanceToMax(lillyID);
	rmAddObjectDefConstraint(lillyID, embellishmentAvoidAll);
	rmPlaceObjectDefAtLoc(lillyID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	// Mist.
	int mistID = rmCreateObjectDef("mist");
	rmAddObjectDefItem(mistID, "Mist", 1, 0.0);
	setObjectDefDistance(mistID, 0.0, 600.0);
	rmAddObjectDefConstraint(mistID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(mistID, shortAvoidPlayer);
	rmAddObjectDefConstraint(mistID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(mistID, 0, 0.5, 0.5, 3 * cNonGaiaPlayers);

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
