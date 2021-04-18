// LAMIA
// VBP 5.0

include "rmx 5-0-0.xs";

void main() {

	// Text
	rmSetStatusText("", 0.01);

	// RM X Setup.
	rmxInit("Lamia", false, false, false);

	// Set size.
	int playerTiles = 7500;
	if (cMapSize == 1) {
		playerTiles = 9750;
		rmEchoInfo("Large map");
	}
	int size = 2.0 * sqrt(cNumberNonGaiaPlayers * playerTiles / 0.9);
	rmEchoInfo("Map size=" + size + "m x " + size + "m");
	rmSetMapSize(size, size);

	// Set up default water.
	rmSetSeaLevel(0.0);

	// Init map.
	rmTerrainInitialize("GrassDirt25");
	// rmSetLightingSet("ghost lake");
	// Define some classes.
	int classPlayer = rmDefineClass("player");
	int classPlayerCore = rmDefineClass("player core");
	rmDefineClass("corner");
	rmDefineClass("center");
	rmDefineClass("starting settlement");
	int classCliff = rmDefineClass("cliff");

	// -------------Define constraints
	// Create a edge of map constraint.
	int edgeConstraint = rmCreateBoxConstraint("edge of map", rmXTilesToFraction(3), rmZTilesToFraction(3), 1.0 - rmXTilesToFraction(3), 1.0 - rmZTilesToFraction(3));
	int largeEdgeConstraint = rmCreateBoxConstraint("Settlements and edge of map", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0 - rmXTilesToFraction(8), 1.0 - rmZTilesToFraction(8));

	// Center constraint.
	int centerConstraint = rmCreateClassDistanceConstraint("stay away from center", rmClassID("center"), 15.0);
	int wideCenterConstraint = rmCreateClassDistanceConstraint("wide avoid center", rmClassID("center"), 20.0);
	int cliffCenterConstraint = rmCreateClassDistanceConstraint("cliff avoid center", rmClassID("center"), 20.0);

	// corner constraint.
	int cornerOverlapConstraint = rmCreateClassDistanceConstraint("don't overlap corner", rmClassID("corner"), 2.0);
	int cornerConstraint = rmCreateClassDistanceConstraint("stay away from corner", rmClassID("corner"), 10.0);

	// Settlement constraints
	int shortAvoidSettlement = rmCreateTypeDistanceConstraint("objects avoid TC by short distance", "AbstractSettlement", 10.0);
	int farAvoidSettlement = rmCreateTypeDistanceConstraint("TCs avoid TCs by long distance", "AbstractSettlement", 50.0);
	int farStartingSettleConstraint = rmCreateClassDistanceConstraint("objects avoid player TCs", rmClassID("starting settlement"), 40.0);
	int playerConstraint = rmCreateClassDistanceConstraint("stay away from players", classPlayer, 10);

	// Tower constraint.
	int avoidTower = rmCreateTypeDistanceConstraint("towers avoid towers", "tower", 25.0);
	int avoidTower2 = rmCreateTypeDistanceConstraint("objects avoid towers", "tower", 25.0);

	// Gold
	int avoidGold = rmCreateTypeDistanceConstraint("avoid gold", "gold", 20.0);
	int shortAvoidGold = rmCreateTypeDistanceConstraint("short avoid gold", "gold", 16.0);

	// Food
	int avoidHerdable = rmCreateTypeDistanceConstraint("avoid herdable", "herdable", 20.0);
	int avoidPredator = rmCreateTypeDistanceConstraint("avoid predator", "animalPredator", 20.0);
	int avoidFood = rmCreateTypeDistanceConstraint("avoid other food sources", "food", 6.0);

	// Avoid impassable land
	int avoidImpassableLand = rmCreateTerrainDistanceConstraint("avoid impassable land", "land", false, 8.0);
	int cliffConstraint = rmCreateClassDistanceConstraint("cliff v cliff", rmClassID("cliff"), 30.0);
	int shortCliffConstraint = rmCreateClassDistanceConstraint("elev v cliff", rmClassID("cliff"), 10.0);
	int shortAvoidImpassableLand = rmCreateTerrainDistanceConstraint("short avoid impassable land", "land", false, 5.0);
	int goldCliffConstraint = rmCreateClassDistanceConstraint("gold v cliff", rmClassID("cliff"), 6.0);
	int avoidBuildings = rmCreateTypeDistanceConstraint("avoid buildings", "Building", 15.0);

	// -------------Define objects
	// Close Objects
	int startingSettlementID = rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem(startingSettlementID, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass(startingSettlementID, rmClassID("starting settlement"));
	rmSetObjectDefMinDistance(startingSettlementID, 0.0);
	rmSetObjectDefMaxDistance(startingSettlementID, 0.0);

	// towers avoid other towers
	int startingTowerID = rmCreateObjectDef("Starting tower");
	rmAddObjectDefItem(startingTowerID, "tower", 1, 0.0);
	rmSetObjectDefMinDistance(startingTowerID, 22.0);
	rmSetObjectDefMaxDistance(startingTowerID, 28.0);
	rmAddObjectDefConstraint(startingTowerID, avoidTower);
	rmAddObjectDefConstraint(startingTowerID, avoidImpassableLand);

	// gold avoids gold
	int startingGoldID = rmCreateObjectDef("Starting gold");
	rmAddObjectDefItem(startingGoldID, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance(startingGoldID, 17.0);
	rmSetObjectDefMaxDistance(startingGoldID, 20.0);
	rmAddObjectDefConstraint(startingGoldID, avoidGold);
	// rmAddObjectDefConstraint(startingGoldID, centerConstraint);
	rmAddObjectDefConstraint(startingGoldID, shortAvoidSettlement);

	// goats
	int closegoatsID = rmCreateObjectDef("close goats");
	rmAddObjectDefItem(closegoatsID, "cow", rmRandInt(2, 4), 2.0);
	rmSetObjectDefMinDistance(closegoatsID, 25.0);
	rmSetObjectDefMaxDistance(closegoatsID, 30.0);
	rmAddObjectDefConstraint(closegoatsID, avoidFood);

	int closeBerriesID = rmCreateObjectDef("close berries");
	rmAddObjectDefItem(closeBerriesID, "chicken", rmRandInt(6, 8), 4.0);
	rmSetObjectDefMinDistance(closeBerriesID, 20.0);
	rmSetObjectDefMaxDistance(closeBerriesID, 25.0);
	rmAddObjectDefConstraint(closeBerriesID, avoidFood);

	int closeBoarID = rmCreateObjectDef("close Boar");
	if (rmRandFloat(0, 1) < 0.5) rmAddObjectDefItem(closeBoarID, "boar", rmRandInt(2, 4), 4.0);
	else rmAddObjectDefItem(closeBoarID, "elk", rmRandInt(6, 7), 4.0);
	rmSetObjectDefMinDistance(closeBoarID, 30.0);
	rmSetObjectDefMaxDistance(closeBoarID, 60.0);

	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Oak Tree", 1, 70.0);
	rmSetObjectDefMinDistance(stragglerTreeID, rmXFractionToMeters(0.5));
	rmSetObjectDefMaxDistance(stragglerTreeID, rmXFractionToMeters(0.5));

	// Medium Objects
	int mediumGoatsID = rmCreateObjectDef("medium goats");
	rmAddObjectDefItem(mediumGoatsID, "cow", rmRandInt(0, 2), 2.0);
	rmSetObjectDefMinDistance(mediumGoatsID, 50.0);
	rmSetObjectDefMaxDistance(mediumGoatsID, 70.0);
	rmAddObjectDefConstraint(mediumGoatsID, avoidHerdable);
	rmAddObjectDefConstraint(mediumGoatsID, edgeConstraint);
	//rmAddObjectDefConstraint(mediumGoatsID, centerConstraint);
	rmAddObjectDefConstraint(mediumGoatsID, farStartingSettleConstraint);

	// Far Objects
	// gold avoids gold, Settlements and TCs
	int farGoldID = rmCreateObjectDef("far gold");
	rmAddObjectDefItem(farGoldID, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance(farGoldID, 60.0);
	rmSetObjectDefMaxDistance(farGoldID, 90.0);
	rmAddObjectDefConstraint(farGoldID, avoidGold);
	rmAddObjectDefConstraint(farGoldID, edgeConstraint);
	// rmAddObjectDefConstraint(farGoldID, centerConstraint);
	rmAddObjectDefConstraint(farGoldID, shortAvoidSettlement);
	//rmAddObjectDefConstraint(farGoldID, goldCliffConstraint);
	rmAddObjectDefConstraint(farGoldID, farStartingSettleConstraint);

	// goats avoid TCs and other herds, since this map places a lot of goats
	int fargoatsID = rmCreateObjectDef("far goats");
	rmAddObjectDefItem(fargoatsID, "cow", rmRandInt(0, 2), 2.0);
	rmSetObjectDefMinDistance(fargoatsID, 80.0);
	rmSetObjectDefMaxDistance(fargoatsID, 150.0);
	rmAddObjectDefConstraint(fargoatsID, avoidHerdable);
	rmAddObjectDefConstraint(fargoatsID, farStartingSettleConstraint);
	rmAddObjectDefConstraint(fargoatsID, edgeConstraint);

	// pick lions or bears as predators
	// avoid TCs
	int farPredatorID = rmCreateObjectDef("far predator");
	rmAddObjectDefItem(farPredatorID, "bear", rmRandInt(1, 2), 4.0);
	rmSetObjectDefMinDistance(farPredatorID, 50.0);
	rmSetObjectDefMaxDistance(farPredatorID, 130.0);
	rmAddObjectDefConstraint(farPredatorID, avoidPredator);
	rmAddObjectDefConstraint(farPredatorID, farStartingSettleConstraint);
	rmAddObjectDefConstraint(farPredatorID, avoidImpassableLand);

	// Berries avoid TCs
	int farBerriesID = rmCreateObjectDef("far berries");
	rmAddObjectDefItem(farBerriesID, "berry bush", rmRandInt(6, 10), 4.0);
	rmSetObjectDefMinDistance(farBerriesID, 0.0);
	rmSetObjectDefMaxDistance(farBerriesID, rmXFractionToMeters(0.5));
	//rmAddObjectDefConstraint(farBerriesID, centerConstraint);
	rmAddObjectDefConstraint(farBerriesID, farStartingSettleConstraint);
	//rmAddObjectDefConstraint(farBerriesID, avoidImpassableLand);
	rmAddObjectDefConstraint(farBerriesID, edgeConstraint);

	// This map will either use boar or deer as the extra huntable food.
	int classBonusHuntable = rmDefineClass("bonus huntable");
	int avoidBonusHuntable = rmCreateClassDistanceConstraint("avoid bonus huntable", classBonusHuntable, 40.0);
	int avoidHuntable = rmCreateTypeDistanceConstraint("avoid huntable", "huntable", 20.0);

	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "Autumn Oak Tree", 10, 30.0);
	rmSetObjectDefMinDistance(randomTreeID, rmXFractionToMeters(0.5));
	rmSetObjectDefMaxDistance(randomTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(randomTreeID, rmCreateTypeDistanceConstraint("random tree", "all", 4.0));
	rmAddObjectDefConstraint(randomTreeID, shortAvoidSettlement);
	//rmAddObjectDefConstraint(randomTreeID, centerConstraint);
	//rmAddObjectDefConstraint(randomTreeID, shortAvoidImpassableLand);
	// hunted avoids hunted and TCs
	int bonusHuntableID = rmCreateObjectDef("bonus huntable");
	rmAddObjectDefItem(bonusHuntableID, "deer", rmRandInt(5, 10), 3.0);
	rmSetObjectDefMinDistance(bonusHuntableID, 60.0);
	rmSetObjectDefMaxDistance(bonusHuntableID, 100.0);
	rmAddObjectDefConstraint(bonusHuntableID, avoidBonusHuntable);
	rmAddObjectDefConstraint(bonusHuntableID, avoidHuntable);
	rmAddObjectDefToClass(bonusHuntableID, classBonusHuntable);
	rmAddObjectDefConstraint(bonusHuntableID, farStartingSettleConstraint);
	rmAddObjectDefConstraint(bonusHuntableID, avoidImpassableLand);
	rmAddObjectDefConstraint(bonusHuntableID, centerConstraint);

	// Birds
	int farhawkID = rmCreateObjectDef("far hawks");
	rmAddObjectDefItem(farhawkID, "hawk", 1, 0.0);
	rmSetObjectDefMinDistance(farhawkID, 0.0);
	rmSetObjectDefMaxDistance(farhawkID, rmXFractionToMeters(0.5));

	// Relics avoid TCs
	int relicID = rmCreateObjectDef("relic");
	rmAddObjectDefItem(relicID, "relic", 1, 0.0);
	rmSetObjectDefMinDistance(relicID, 60.0);
	rmSetObjectDefMaxDistance(relicID, 150.0);
	rmAddObjectDefConstraint(relicID, edgeConstraint);
	rmAddObjectDefConstraint(relicID, rmCreateTypeDistanceConstraint("relic vs relic", "relic", 70.0));
	rmAddObjectDefConstraint(relicID, farStartingSettleConstraint);
	rmAddObjectDefConstraint(relicID, avoidImpassableLand);

	// -------------Done defining objects
	// Cheesy "circular" placement of players.
	if (cNumberNonGaiaPlayers < 9) rmSetTeamSpacingModifier(0.70);
	else rmSetTeamSpacingModifier(0.90);
	rmPlacePlayersCircular(0.35, 0.4, rmDegreesToRadians(5.0));

	// Dumb thing to just block out player areas since placement sucks right now.
	// This area doesn't paint down anything, it just exists for blocking out the center sea.
	for (i = 1; < cNumberPlayers) {
		// Create the area.
		int id = rmCreateArea("Player core" + i);

		// Set the size.
		rmSetAreaSize(id, rmAreaTilesToFraction(110), rmAreaTilesToFraction(110));

		rmAddAreaToClass(id, classPlayerCore);

		rmSetAreaCoherence(id, 1.0);

		// Set the location.
		rmSetAreaLocPlayer(id, i);

		// Build it.
		rmBuildArea(id);
	}

	// Text
	rmSetStatusText("", 0.20);

	// Create a center water area -- the lake part.
	int centerID = rmCreateArea("center");
	int maxBlobSpacing = size / 5;
	int minBlobSpacing = size / 10;
	rmSetAreaSize(centerID, 0.10, 0.19);
	rmSetAreaLocation(centerID, 0.5, 0.5);
	rmSetAreaTerrainType(centerID, "GrassA");
	rmAddAreaTerrainLayer(centerID, "GrassDirt50", 3, 16);
	rmAddAreaTerrainLayer(centerID, "GrassDirt25", 1, 16);
	rmAddAreaToClass(centerID, rmClassID("center"));
	rmSetAreaBaseHeight(centerID, 1.0);
	rmSetAreaMinBlobs(centerID, 4);
	rmSetAreaMaxBlobs(centerID, 10);
	/* was 12 12 */
	rmSetAreaMinBlobDistance(centerID, minBlobSpacing);
	rmSetAreaMaxBlobDistance(centerID, maxBlobSpacing);
	rmSetAreaSmoothDistance(centerID, 10);
	rmSetAreaCoherence(centerID, 0.0);
	rmSetAreaHeightBlend(centerID, 2);
	rmAddAreaConstraint(centerID, rmCreateClassDistanceConstraint("center v player", classPlayerCore, 40.0));
	rmBuildArea(centerID);

	int failCount = 0;
	for (i = 1; < 10) {
		int icePatch = rmCreateArea("more ice terrain" + i, centerID);
		rmSetAreaSize(icePatch, 0.005, 0.007);
		rmSetAreaTerrainType(icePatch, "RiverGrassyC");
		rmAddAreaTerrainLayer(icePatch, "GreekCliffB", 0, 3);
		rmSetAreaCoherence(icePatch, 0.0);
		if (rmBuildArea(icePatch) == false) {
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if (failCount == 3) break;
		}
		else failCount = 0;
	}

	rmSetStatusText("", 0.40);

	// Set up player areas.
	float playerFraction = rmAreaTilesToFraction(2000);
	for (i = 1; < cNumberPlayers) {
		// Create the area.
		id = rmCreateArea("Player" + i);
		rmSetPlayerArea(i, id);
		rmSetAreaSize(id, 0.9 * playerFraction, 1.1 * playerFraction);
		rmAddAreaToClass(id, classPlayer);
		rmSetAreaMinBlobs(id, 2);
		rmSetAreaMaxBlobs(id, 3);
		rmSetAreaMinBlobDistance(id, 20.0);
		rmSetAreaMaxBlobDistance(id, 30.0);
		rmSetAreaCoherence(id, 0.4);
		rmAddAreaConstraint(id, edgeConstraint);
		rmAddAreaConstraint(id, wideCenterConstraint);
		rmSetAreaLocPlayer(id, i);
		rmSetAreaTerrainType(id, "GrassDirt50");
		rmAddAreaTerrainLayer(id, "GrassDirt25", 0, 8);
	}

	// Build the areas.
	rmBuildAllAreas();

	// Place starting settlements.
	// Close things....
	// TC
	rmPlaceObjectDefPerPlayer(startingSettlementID, true);

	// Settlements.
	id = rmAddFairLoc("Settlement", false, true, 60, 70, 40, 10);
	/* back inside */

	id = rmAddFairLoc("Settlement", true, false, 70, 100, 60, 10);
	/* forward outside */

	if (rmPlaceFairLocs()) {
		id = rmCreateObjectDef("far settlement2");
		rmAddObjectDefItem(id, "Settlement", 1, 0.0);
		for (i = 1; < cNumberPlayers) {
			for (j = 0; < rmGetNumberFairLocs(i))
			rmPlaceObjectDefAtLoc(id, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
		}
	}

	// Draw cliffs
	int cliffNumber = 0;
	if (cNumberNonGaiaPlayers < 4) cliffNumber = 6;
	else if (cNumberNonGaiaPlayers < 9) cliffNumber = 8;
	else cliffNumber = 11;

	for (i = 0; < cliffNumber) {
		int cliffID = rmCreateArea("cliff" + i);
		rmSetAreaWarnFailure(cliffID, false);
		if (cNumberNonGaiaPlayers < 4) rmSetAreaSize(cliffID, rmAreaTilesToFraction(500), rmAreaTilesToFraction(700));
		else rmSetAreaSize(cliffID, rmAreaTilesToFraction(630), rmAreaTilesToFraction(700));
		rmSetAreaCliffType(cliffID, "Greek");
		rmAddAreaConstraint(cliffID, cliffConstraint);
		// rmAddAreaConstraint(cliffID, cliffCenterConstraint);
		rmAddAreaConstraint(cliffID, playerConstraint);
		rmAddAreaConstraint(cliffID, avoidBuildings);
		rmAddAreaToClass(cliffID, classCliff);
		rmSetAreaMinBlobs(cliffID, 2);
		rmSetAreaMaxBlobs(cliffID, 6);

		rmSetAreaCliffPainting(cliffID, false, true, true, 1.5, true);
		//     if(rmRandFloat(0,1) < 0.3)
		rmSetAreaCliffEdge(cliffID, 1, 0.60, 0.6, 1.0, 2);
		//      else
		//        rmSetAreaCliffEdge(cliffID, 2, 0.40, 0.2, 1.0, 0);
		rmSetAreaCliffHeight(cliffID, rmRandInt(4, 5), 1.0, 1.0);
		rmSetAreaMinBlobDistance(cliffID, 25.0);
		rmSetAreaMaxBlobDistance(cliffID, 35.0);
		rmSetAreaCoherence(cliffID, 0.0);
		rmSetAreaSmoothDistance(cliffID, 20);
		rmSetAreaHeightBlend(cliffID, 2);
		rmBuildArea(cliffID);
	}

	for (i = 1; < cNumberPlayers * 10) {
		// Beautification sub area.
		int patchID = rmCreateArea("patch" + i);
		rmSetAreaWarnFailure(patchID, false);
		rmSetAreaSize(patchID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(200));
		rmSetAreaTerrainType(patchID, "GrassDirt75");
		rmAddAreaTerrainLayer(patchID, "GrassDirt25", 2, 5);
		rmAddAreaTerrainLayer(patchID, "GrassDirt50", 0, 2);
		rmSetAreaMinBlobs(patchID, 1);
		rmSetAreaMaxBlobs(patchID, 5);
		rmSetAreaMinBlobDistance(patchID, 16.0);
		rmSetAreaMaxBlobDistance(patchID, 40.0);
		rmSetAreaCoherence(patchID, 0.4);
		//rmAddAreaConstraint(patchID, centerConstraint);
		rmAddAreaConstraint(patchID, playerConstraint);
		rmAddAreaConstraint(patchID, shortAvoidImpassableLand);
		if (rmBuildArea(patchID) == false) {
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if (failCount == 3) break;
		}
		else failCount = 0;
	}

	for (i = 1; < cNumberPlayers * 10) {
		// Beautification sub area.
		int patch2ID = rmCreateArea("patch 2 " + i);
		rmSetAreaWarnFailure(patch2ID, false);
		rmSetAreaSize(patch2ID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(30));
		rmSetAreaTerrainType(patch2ID, "GrassDirt75");
		rmSetAreaMinBlobs(patch2ID, 1);
		rmSetAreaMaxBlobs(patch2ID, 5);
		rmSetAreaMinBlobDistance(patch2ID, 16.0);
		rmSetAreaMaxBlobDistance(patch2ID, 40.0);
		rmSetAreaCoherence(patch2ID, 0.4);
		//rmAddAreaConstraint(patch2ID, centerConstraint);
		rmAddAreaConstraint(patch2ID, playerConstraint);
		rmAddAreaConstraint(patch2ID, shortAvoidImpassableLand);
		if (rmBuildArea(patch2ID) == false) {
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if (failCount == 3) break;
		}
		else failCount = 0;
	}

	// Elev.
	int numTries = 40 * cNumberNonGaiaPlayers;
	failCount = 0;
	for (i = 0; < numTries) {
		int elevID = rmCreateArea("elev" + i);
		rmSetAreaSize(elevID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(120));
		rmSetAreaLocation(elevID, rmRandFloat(0.0, 1.0), rmRandFloat(0.0, 1.0));
		rmSetAreaWarnFailure(elevID, false);
		rmAddAreaConstraint(elevID, avoidBuildings);
		rmAddAreaConstraint(elevID, centerConstraint);
		rmAddAreaConstraint(elevID, shortCliffConstraint);
		if (rmRandFloat(0.0, 1.0) < 0.5) rmSetAreaTerrainType(elevID, "GrassB");
		rmSetAreaBaseHeight(elevID, rmRandFloat(1.0, 3.0));
		rmSetAreaMinBlobs(elevID, 1);
		rmSetAreaMaxBlobs(elevID, 5);
		rmSetAreaMinBlobDistance(elevID, 6.0);
		rmSetAreaMaxBlobDistance(elevID, 40.0);
		rmSetAreaCoherence(elevID, 0.0);

		if (rmBuildArea(elevID) == false) {
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if (failCount == 5) break;
		}
		else failCount = 0;
	}

	// Slight Elevation
	numTries = 10 * cNumberNonGaiaPlayers;
	failCount = 0;
	for (i = 0; < numTries) {
		elevID = rmCreateArea("wrinkle" + i);
		rmSetAreaSize(elevID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(120));
		rmSetAreaLocation(elevID, rmRandFloat(0.0, 1.0), rmRandFloat(0.0, 1.0));
		rmSetAreaWarnFailure(elevID, false);
		rmSetAreaBaseHeight(elevID, rmRandFloat(3.0, 4.0));
		rmSetAreaHeightBlend(elevID, 1);
		rmSetAreaMinBlobs(elevID, 1);
		rmSetAreaMaxBlobs(elevID, 3);
		rmSetAreaMinBlobDistance(elevID, 16.0);
		rmSetAreaMaxBlobDistance(elevID, 40.0);
		rmSetAreaCoherence(elevID, 0.0);
		rmAddAreaConstraint(elevID, avoidBuildings);
		// rmAddAreaConstraint(elevID, centerConstraint);
		rmAddAreaConstraint(elevID, shortCliffConstraint);
		if (rmBuildArea(elevID) == false) {
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if (failCount == 8) break;
		}
		else failCount = 0;
	}

	// Towers.
	rmPlaceObjectDefPerPlayer(startingTowerID, true, 4);

	// Straggler trees.
	rmPlaceObjectDefPerPlayer(stragglerTreeID, false, rmRandInt(30, 50));

	// Gold
	rmPlaceObjectDefPerPlayer(startingGoldID, false, 1);

	// Goats
	rmPlaceObjectDefPerPlayer(closegoatsID, true);

	// Berries
	rmPlaceObjectDefPerPlayer(closeBerriesID, true);

	// Boar.
	rmPlaceObjectDefPerPlayer(closeBoarID, false, rmRandInt(1, 2));

	// goats
	rmPlaceObjectDefPerPlayer(mediumGoatsID, false, rmRandInt(1, 4));

	// Far things.
	// Gold.
	rmPlaceObjectDefPerPlayer(farGoldID, false, rmRandInt(3, 4));

	// Hawks
	rmPlaceObjectDefPerPlayer(farhawkID, false, 2);

	// Relics
	rmPlaceObjectDefPerPlayer(relicID, false);

	// Text
	rmSetStatusText("", 0.60);

	// goats
	for (i = 1; < cNumberPlayers)
	rmPlaceObjectDefAtLoc(fargoatsID, 0, rmPlayerLocXFraction(i), rmPlayerLocZFraction(i), rmRandInt(2, 3));

	// Bonus huntable.
	rmPlaceObjectDefPerPlayer(bonusHuntableID, false, rmRandInt(1, 2));

	// Berries.
	rmPlaceObjectDefAtLoc(farBerriesID, 0, 0.5, 0.5, cNumberPlayers);

	// Predators
	rmPlaceObjectDefPerPlayer(farPredatorID, false, 1);

	// Forest
	int classForest = rmDefineClass("forest");
	int forestObjConstraint = rmCreateTypeDistanceConstraint("forest obj", "all", 5.0);
	int forestConstraint = rmCreateClassDistanceConstraint("forest v forest", rmClassID("forest"), 17.0);
	int forestSettleConstraint = rmCreateClassDistanceConstraint("forest settle", rmClassID("starting settlement"), 19.0);
	int forestCount = 6 * cNumberNonGaiaPlayers;
	failCount = 0;
	for (i = 0; < forestCount) {
		int forestID = rmCreateArea("forest" + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(130));
		rmSetAreaWarnFailure(forestID, false);
		if (rmRandFloat(0, 1) < 0.5) rmSetAreaForestType(forestID, "Autumn Oak Forest");
		else rmSetAreaForestType(forestID, "Oak Forest");
		rmAddAreaConstraint(forestID, forestSettleConstraint);
		rmAddAreaConstraint(forestID, forestObjConstraint);
		rmAddAreaConstraint(forestID, forestConstraint);
		rmAddAreaConstraint(forestID, centerConstraint);
		rmAddAreaConstraint(forestID, avoidImpassableLand);
		rmAddAreaToClass(forestID, classForest);

		rmSetAreaMinBlobs(forestID, 2);
		rmSetAreaMaxBlobs(forestID, 7);
		rmSetAreaMinBlobDistance(forestID, 10.0);
		rmSetAreaMaxBlobDistance(forestID, 30.0);
		rmSetAreaCoherence(forestID, 0.0);

		if (rmBuildArea(forestID) == false) {
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if (failCount == 5) break;
		}
		else failCount = 0;
	}

	// Random trees.
	rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 10 * cNumberNonGaiaPlayers);

	// Text
	rmSetStatusText("", 0.80);

	// Text
	rmSetStatusText("", 0.90);

	// Grass
	int avoidAll = rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);

	// Text
	rmSetStatusText("And vanquish those who worshipped other pantheons", 0.90);

	int rockID2 = rmCreateObjectDef("rock group");
	int avoidRock = rmCreateTypeDistanceConstraint("avoid rock", "rock limestone sprite", 8.0);
	rmAddObjectDefItem(rockID2, "Rock Limestone Sprite", 3, 12.0);
	rmSetObjectDefMinDistance(rockID2, 0.0);
	rmSetObjectDefMaxDistance(rockID2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(rockID2, avoidAll);
	rmAddObjectDefConstraint(rockID2, avoidImpassableLand);
	rmAddObjectDefConstraint(rockID2, centerConstraint);
	rmAddObjectDefConstraint(rockID2, avoidRock);
	rmPlaceObjectDefAtLoc(rockID2, 0, 0.5, 0.5, 8 * cNumberNonGaiaPlayers);

	int runeID = rmCreateObjectDef("runestone");
	rmAddObjectDefItem(runeID, "bush", 4, 50.0);
	rmSetObjectDefMinDistance(runeID, 0.0);
	rmSetObjectDefMaxDistance(runeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(runeID, avoidAll);
	rmAddObjectDefConstraint(runeID, avoidImpassableLand);
	//rmAddObjectDefConstraint(runeID, centerConstraint);
	rmPlaceObjectDefAtLoc(runeID, 0, 0.5, 0.5, 12 * cNumberNonGaiaPlayers);

	// RM X Finalize.
	rmxFinalize();

	// Text
	rmSetStatusText("", 1.00);

}