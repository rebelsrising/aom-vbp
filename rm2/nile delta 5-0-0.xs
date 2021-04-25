/*
** NILE DELTA
** RebelsRising
** Last edit: 25/04/2021
*/

include "rmx 5-0-0.xs";

// Stores the size of the largest team.
int cMaxPlayers = 0;

// Overrides 1v1 backward; careful with angles here because we're not facing the center.
mutable float randBackInsideSingle(float tol = 0.0) {
	return(randFromIntervals(0.5, 0.7, 1.3, 1.5) * PI);
}

mutable float randBackOutsideSingle(float tol = 0.0) {
	return(randFromIntervals(0.5, 0.7, 1.3, 1.5) * PI);
}

// Overrides 1v1 forward; careful with angles here because we're not facing the center.
mutable float randFwdInsideSingle(float tol = 0.0) {
	return(randFromIntervals(0.6, 1.0, 1.0, 1.4) * PI);
}

mutable float randFwdOutsideSingle(float tol = 0.0) {
	return(randFromIntervals(0.6, 1.0, 1.0, 1.4) * PI);
}

// Overrides tg forward inside.
mutable float randFwdInsideFirst(float tol = 0.0) {
	return(rmRandFloat(0.7 - 0.2 * tol, 1.0) * PI);
}

mutable float randFwdInsideLast(float tol = 0.0) {
	return(rmRandFloat(1.0, 1.3 + 0.2 * tol) * PI);
}

// Overrides tg backward inside.
mutable float randBackInsideFirst(float tol = 0.0) {
	if(cMaxPlayers == 2) {
		return(rmRandFloat(0.25 - 0.25 * tol, 0.425 + 0.075 * tol) * PI);
	} else {
		return(rmRandFloat(0.4 - 0.4 * tol, 0.55) * PI);
	}
}

mutable float randBackInsideLast(float tol = 0.0) {
	if(cMaxPlayers == 2) {
		return(rmRandFloat(1.575 - 0.075 * tol, 1.75 + 0.25 * tol) * PI);
	} else {
		return(rmRandFloat(1.45, 1.6 + 0.4 * tol) * PI);
	}
}

// Overrides tg forward center.
mutable float randFwdCenter(float tol = 0.0) {
	return(rmRandFloat(0.6 - 0.2 * tol, 1.4 + 0.2 * tol) * PI);
}

// Overrides tg backward center.
mutable float randBackCenter(float tol = 0.0) {
	if(cMaxPlayers < 4) {
		return(randFromIntervals(-0.4 - tol * 0.1, -0.15, 0.15, 0.4 + tol * 0.1) * PI);
	} else {
		return(rmRandFloat(-0.5, 0.5) * PI);
	}
}

/*
** Creates and builds areas under stored similar locations.
**
** @param simLocID: the ID of the similar location
*/
void placeAreaUnderSimLocs() {
	static int areaCount = 0;

	float areaSize = rmXMetersToFraction(0.25);

	for(i = 1; <= getNumSimLocs()) {
		for(j = 1; < cPlayers) {
			float goldX = getSimLocX(i, j);
			float goldZ = getSimLocZ(i, j);

			int sandAreaID = rmCreateArea("gold area " + areaCount);
			rmSetAreaLocation(sandAreaID, goldX, goldZ);
			rmSetAreaSize(sandAreaID, areaSize);
			rmSetAreaCoherence(sandAreaID, 1.0);
			rmSetAreaBaseHeight(sandAreaID, 5.0);
			rmSetAreaHeightBlend(sandAreaID, 2);
			rmSetAreaTerrainType(sandAreaID, "SandA");
			areaCount++;
		}
	}

	rmBuildAllAreas();
}

/*
** Should be called upon encountering an invalid map configuration.
** Creates a black map, error messages and pauses the game to encourage players to quit the map.
*/
void injectMapGenError() {
	// Initialize black map to indicate failure.
	rmTerrainInitialize("Black");

	code("rule _map_error");
	code("highFrequency");
	code("active");
	code("{");
		injectRuleInterval(0, 500); // Run after 0.5 seconds to give time for other initialization.

		if(cVersion != cVersionVanilla) {
			code("trChatHistoryClear();");
		}

		sendChatRed(cInfoLine);
		sendChatRed("");
		sendChatRed("Error: Invalid map configuration detected!");
		sendChatRed("");
		sendChatRed("This map only works for 2 teams of at most 6 players each!");
		sendChatRed("");
		sendChatRed("The game has been paused for saving.");
		sendChatRed("");
		sendChatRed(cInfoLine);

		pauseGame();

		code("xsDisableRule(\"_post_initial_note\");"); // This works even if the rule doesn't exist.
		code("xsDisableRule(\"BasicVC1\");");

		code("xsDisableSelf();");
	code("}");

	// Advance progress to 1.0 as the map script should return after this call.
	progress(1.0);
}

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Nile Delta");

	cMaxPlayers = getNumberPlayersOnTeam(0);

	for(i = 1; < cTeams) {
		cMaxPlayers = max(cMaxPlayers, getNumberPlayersOnTeam(i));
	}
	
	// Return early upon invalid configuration.
	if(cTeams > 2 || cMaxPlayers > 6) {
		injectMapGenError();
		
		return;
	}

	float dimX = 290.0 + 45.0 * min(cMaxPlayers, 3); // Limit max distance to what we have in 3v3.
	float dimZ = 270.0 + 80.0 * cMaxPlayers;

	if(cNonGaiaPlayers < 3) {
		dimX = 280.0;
		dimZ = 280.0;
	}

	// Initialize water.
	rmSetSeaLevel(0.0);
	rmSetSeaType("Egyptian Nile");

	// Initialize map.
	initializeMap("Water", dimX, dimZ);

	// Place players.
	if(cNonGaiaPlayers < 3) {
		float placementEdgeDist = rmXMetersToFraction(50.0);

		placePlayersInLine(placementEdgeDist, 0.6, 1.0 - placementEdgeDist, 0.6);
	} else {
		float placementEdgeDistX = rmXMetersToFraction(75.0);
		float placementEdgeDistZ = rmZMetersToFraction(75.0);

		// It's absolutely CRUCIAL to still place players in a counter clock-wise fashion!
		placeTeamInLine(0, placementEdgeDistX, 0.65 + 0.025 * cMaxPlayers, placementEdgeDistX, placementEdgeDistZ);
		placeTeamInLine(1, 1.0 - placementEdgeDistX, placementEdgeDistZ, 1.0 - placementEdgeDistX, 0.65 + 0.025 * cMaxPlayers);
	}

	// Control areas.
	int classSplit = initializeTeamSplit(5.0);
	int classCenter = initializeCenter();
	int classCorner = initializeCorners();
	int classCenterline = initializeCenterline(false);

	// Classes.
	int classWater = rmDefineClass("water");
	int classShore = rmDefineClass("shore");
	int classSand = rmDefineClass("sand");
	int classShallows = rmDefineClass("shallows");
	int classPlayer = rmDefineClass("player");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classForest = rmDefineClass("forest");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidPlayer = createClassDistConstraint(classPlayer, 1.0);
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);
	int avoidCenterline = createClassDistConstraint(classCenterline, 1.0);
	int shortAvoidCenter = createClassDistConstraint(classCenterline, 7.5);
	int mediumAvoidCenter = createClassDistConstraint(classCenterline, 12.5);
	int farAvoidCenter = createClassDistConstraint(classCenterline, 20.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);

	// Terrain.
	int hugeShallowBox = createBoxConstraint(0.0, 0.0, 1.0, 0.525, 0.01);
	if(cMaxPlayers > 1) {
		hugeShallowBox = createBoxConstraint(0.0, 0.0, 1.0, 0.575, 0.01);
	}
	int shallowConstraint = createClassDistConstraint(classShallows, 0.1);
	int shoreShallow = createBoxConstraint(0.45, 0.0, 0.55, 1.0, 0.01);
	int shortAvoidImpassableLand = createClassDistConstraint(classWater, 5.0);
	int mediumAvoidImpassableLand = createClassDistConstraint(classWater, 10.0);
	int farAvoidImpassableLand = createClassDistConstraint(classWater, 20.0);
	int veryFarAvoidImpassableLand = createClassDistConstraint(classWater, 35.0);
	int avoidSand = createClassDistConstraint(classSand, 20.0);
	int shoreConstraint = createClassDistConstraint(classShore, 20.0);

	// Gold.
	float avoidGoldDist = 30.0;

	int shortAvoidGold = createTypeDistConstraint("Gold", 10.0);
	int farAvoidGold = createTypeDistConstraint("Gold", avoidGoldDist);

	// Food.
	float avoidHuntDist = 35.0;

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
	int embellishmentNearShore = createTerrainMaxDistConstraint("Land", true, 5.0);

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
	rmAddObjectDefConstraint(startingTowerID, shortAvoidImpassableLand);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	if(randChance()) {
		addObjectDefItemVerify(startingFoodID, "Chicken", rmRandInt(5, 7), 2.0);
	} else {
		addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(5, 7), 2.0);
	}
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	if(randChance(0.1)) {
		// 10% chance for 5.
		rmAddObjectDefItem(startingHerdablesID, "Goat", 5, 2.0);
	} else {
		// 45% chance each for 3 and 4.
		rmAddObjectDefItem(startingHerdablesID, "Goat", rmRandInt(3, 4), 2.0);
	}
	setObjectDefDistance(startingHerdablesID, 20.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);

	// Straggler trees.
	int stragglerTreeID = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem(stragglerTreeID, "Palm", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0); // 13.0/13.0 doesn't place towards the upper X axis when using rmPlaceObjectDefPerPlayer().
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	if(randChance(0.2)) {
		rmAddObjectDefItem(mediumHerdablesID, "Goat", 3, 4.0);
	} else {
		rmAddObjectDefItem(mediumHerdablesID, "Goat", 2, 4.0);
	}
	setObjectDefDistance(mediumHerdablesID, 50.0, 70.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	if(randChance()) {
		rmAddObjectDefItem(farHerdablesID, "Goat", 1, 0.0);
	} else {
		rmAddObjectDefItem(farHerdablesID, "Goat", 2, 4.0);
	}
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);

	// Far predators 1.
	int farPredators1ID = createObjectDefVerify("far predators 1");
	if(randChance(0.75)) {
		addObjectDefItemVerify(farPredators1ID, "Lion", 1, 4.0);
	} else {
		addObjectDefItemVerify(farPredators1ID, "Hyena", rmRandInt(1, 2), 4.0);
	}
	rmAddObjectDefConstraint(farPredators1ID, avoidAll);
	rmAddObjectDefConstraint(farPredators1ID, avoidEdge);
	rmAddObjectDefConstraint(farPredators1ID, veryFarAvoidImpassableLand);
	rmAddObjectDefConstraint(farPredators1ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredators1ID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredators1ID, avoidPredator);
	if(cMaxPlayers < 4) {
		rmAddObjectDefConstraint(farPredators1ID, avoidFood);
	}

	// Far predators 2 (only verify when debugging).
	int farPredators2ID = createObjectDefVerify("far predators 2", cDebugMode >= cDebugFull);
	addObjectDefItemVerify(farPredators2ID, "Crocodile", 1, 0.0);
	rmAddObjectDefConstraint(farPredators2ID, avoidAll);
	rmAddObjectDefConstraint(farPredators2ID, avoidEdge);
	rmAddObjectDefConstraint(farPredators2ID, veryFarAvoidImpassableLand);
	rmAddObjectDefConstraint(farPredators2ID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farPredators2ID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredators2ID, avoidPredator);
	if(cMaxPlayers < 4) {
		rmAddObjectDefConstraint(farPredators2ID, avoidFood);
	}

	// Other objects.
	// Relics.
	int relicID = createObjectDefVerify("relic");
	addObjectDefItemVerify(relicID, "Relic", 1, 0.0);
	rmAddObjectDefConstraint(relicID, avoidAll);
	rmAddObjectDefConstraint(relicID, avoidEdge);
	rmAddObjectDefConstraint(relicID, avoidCorner);
	rmAddObjectDefConstraint(relicID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random trees 1.
	int randomTree1ID = rmCreateObjectDef("random tree 1");
	rmAddObjectDefItem(randomTree1ID, "Palm", 1, 0.0);
	setObjectDefDistanceToMax(randomTree1ID);
	rmAddObjectDefConstraint(randomTree1ID, avoidAll);
	rmAddObjectDefConstraint(randomTree1ID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(randomTree1ID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTree1ID, treeAvoidSettlement);

	// Random trees 2.
	int randomTree2ID = rmCreateObjectDef("random tree 2");
	rmAddObjectDefItem(randomTree2ID, "Savannah Tree", 1, 0.0);
	setObjectDefDistanceToMax(randomTree2ID);
	rmAddObjectDefConstraint(randomTree2ID, avoidAll);
	rmAddObjectDefConstraint(randomTree2ID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(randomTree2ID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTree2ID, treeAvoidSettlement);

	progress(0.1);

	/*
	 * Terrain Generation:
	 * This is a bit more complex than on the average map because we're working with shallow water.
	 * Unfortunately, this counts as regular water, so all our "avoid water" constraints don't work.
	 * However, we can simply "rebuild" the ocean as a fake area once we have the shallow part settled.
	 * This way, we can avoid the ocean (actual water) and bypass the issue perfectly.
	*/

	// 1. Make shallow box in lower half of the map.
	int shallowID = rmCreateArea("global shallow");
	rmSetAreaWarnFailure(shallowID, false);
	rmSetAreaSize(shallowID, 1.0);
	rmSetAreaLocation(shallowID, 0.5, 0.01);
	rmSetAreaCoherence(shallowID, 0.0);
	rmSetAreaBaseHeight(shallowID, -1.0);
	rmSetAreaHeightBlend(shallowID, 2);
	rmAddAreaConstraint(shallowID, hugeShallowBox);
	rmAddAreaToClass(shallowID, classShallows);
	rmBuildArea(shallowID);

	// 2. Block (= make shallow) "continents" to make space for players.
	int continentID = 0;

	for(i = 0; < 2) {
		continentID = rmCreateArea("continent 1 " + i);
		rmSetAreaBaseHeight(continentID, -1.0);
		rmSetAreaHeightBlend(continentID, 2);
		rmAddAreaToClass(continentID, classShallows);
		rmSetAreaWarnFailure(continentID, false);
		rmSetAreaCoherence(continentID, 0.6);

		if(cMaxPlayers == 1) { // 1v1.
			rmAddAreaConstraint(continentID, avoidCenterline); // Consider randomizing this/adding it to 2v2 & 3v3.
			rmSetAreaSize(continentID, 0.325);

			if(i == 0) {
				rmSetAreaLocation(continentID, 0.05, 0.475);
			} else {
				rmSetAreaLocation(continentID, 0.95, 0.475);
			}
		} else if(cMaxPlayers == 2) { // 2v2.
			rmSetAreaSize(continentID, 0.3);

			if(i == 0) {
				rmSetAreaLocation(continentID, 0.05, 0.35 + 0.1 * cMaxPlayers);
			} else {
				rmSetAreaLocation(continentID, 0.95, 0.35 + 0.1 * cMaxPlayers);
			}
		} else {
			rmSetAreaSize(continentID, 0.275);

			if(i == 0) {
				rmSetAreaLocation(continentID, 0.05, min(0.6, 0.375 + 0.065 * cMaxPlayers));
			} else {
				rmSetAreaLocation(continentID, 0.95, min(0.6, 0.375 + 0.065 * cMaxPlayers));
			}
		}
	}

	rmBuildAllAreas();

	// 3. Rebuild sea after we added all necessary areas to classShallows.
	int seaID = rmCreateArea("sea");
	rmSetAreaWarnFailure(seaID, false);
	rmSetAreaSize(seaID, 1.0);
	rmSetAreaLocation(seaID, 0.5, 1.0);
	rmAddAreaConstraint(seaID, shallowConstraint);
	rmAddAreaToClass(seaID, classWater);
	rmBuildArea(seaID);

	// 4. Redefine shore according to previously built sea area.
	int areaNearOcean = createAreaMaxDistConstraint(rmAreaID("sea"), 15.0);

	int shoreID = rmCreateArea("shore");
	rmSetAreaWarnFailure(shoreID, false);
	rmSetAreaSize(shoreID, 1.0);
	rmAddAreaConstraint(shoreID, shoreShallow);
	// rmAddAreaConstraint(shoreID, shortAvoidImpassableLand);
	// rmAddAreaConstraint(shoreID, areaNearOcean);
	rmBuildArea(shoreID);

	int avoidShoreArea = createAreaDistConstraint(rmAreaID("shore"), 0.1);

	progress(0.2);

	// 5. Build the actual shore with sand.
	for(i = 0; < 2) {
		shoreID = rmCreateArea("shore " + i);
		rmSetAreaWarnFailure(shoreID, false);
		rmSetAreaBaseHeight(shoreID, 2.0);
		rmSetAreaSize(shoreID, 1.0);
		rmSetAreaSmoothDistance(shoreID, 0);
		rmSetAreaHeightBlend(shoreID, 2);
		rmSetAreaCoherence(shoreID, 0.0);
		rmSetAreaTerrainType(shoreID, "SandA");
		// rmAddAreaConstraint(shoreID, shortAvoidImpassableLand);
		rmAddAreaConstraint(shoreID, avoidShoreArea);
		rmAddAreaConstraint(shoreID, createClassDistConstraint(classShore, 1.0));
		rmAddAreaConstraint(shoreID, createAreaDistConstraint(rmAreaID("sea"), 10.0));
		rmAddAreaConstraint(shoreID, createAreaMaxDistConstraint(rmAreaID("sea"), 20.0));
		rmAddAreaToClass(shoreID, classShore);
		rmBuildArea(shoreID);
	}

	// 6. Build lake for teamgames.
	if(cNonGaiaPlayers > 2) {
		int lakeID = rmCreateArea("lake");
		rmSetAreaSize(lakeID, 0.04);
		rmSetAreaWaterType(lakeID, "Egyptian Nile");
		rmSetAreaWarnFailure(lakeID, false);
		rmSetAreaLocation(lakeID, 0.5, 0.0625);
		rmSetAreaCoherence(lakeID, 0.4);
		rmSetAreaSmoothDistance(lakeID, 12);
		rmSetAreaHeightBlend(lakeID, 1);
		rmAddAreaToClass(lakeID, classWater);
		rmBuildArea(lakeID);

		int areaNearLake = createAreaMaxDistConstraint(rmAreaID("lake"), 15.0);

		for(i = 1; < 3) {
			shoreID = rmCreateArea("shore lake " + i);
			rmSetAreaWarnFailure(shoreID, false);
			rmSetAreaBaseHeight(shoreID, 2.0);
			rmSetAreaSize(shoreID, 1.0);
			rmSetAreaSmoothDistance(shoreID, 0);
			rmSetAreaHeightBlend(shoreID, 2);
			rmSetAreaCoherence(shoreID, 0.0);
			rmSetAreaTerrainType(shoreID, "SandA");
			rmAddAreaConstraint(shoreID, shortAvoidImpassableLand);
			rmAddAreaConstraint(shoreID, areaNearLake);
			rmAddAreaConstraint(shoreID, avoidShoreArea);
			rmAddAreaConstraint(shoreID, shoreConstraint);
			rmAddAreaToClass(shoreID, classShore);
			rmBuildArea(shoreID);
		}
	}

	// 7. Player areas.
	float playerAreaSize = rmAreaTilesToFraction(750);

	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + i);
		rmSetAreaSize(playerAreaID, playerAreaSize);
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "SandA");
		rmSetAreaCoherence(playerAreaID, 0.4);
		rmSetAreaBaseHeight(playerAreaID, 2.0);
		rmSetAreaHeightBlend(playerAreaID, 2);
		rmSetAreaSmoothDistance(playerAreaID, 5);
		rmAddAreaToClass(playerAreaID, classPlayer);
		rmAddAreaToClass(playerAreaID, classSand);
		rmSetAreaWarnFailure(playerAreaID, false);
	}

	rmBuildAllAreas();

	progress(0.3);

	// Starting settlement.
	placeObjectAtPlayerLocs(startingSettlementID, true);

	// Towers.
	placeAndStoreObjectAtPlayerLocs(startingTowerID, true, 4, 23.0, 27.0, true); // Last parameter: Square placement.

	// Settlements.
	int settlementID = rmCreateObjectDef("settlements");
	rmAddObjectDefItem(settlementID, "Settlement", 1, 0.0);

	// Far settlement.
	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(veryFarAvoidImpassableLand);

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		if(randChance(0.5)) {
			addFairLoc(70.0, 110.0, true, true, 80.0, 12.0, 12.0, false, true);
		} else {
			addFairLoc(120.0, 140.0, true, true, 80.0, 12.0, 12.0, false, true);
		}
	} else {
		float tcMinDist = rmRandFloat(60.0, 100.0);

		if(cMaxPlayers < 5) {
			addFairLoc(tcMinDist, tcMinDist + 20.0, true, true, 70.0, 12.0, 12.0, false, true, false, false);
		} else {
			addFairLoc(70.0, 120.0, true, true, 60.0, 12.0, 12.0, false, true, false, false);
		}
	}

	// Close settlement.
	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(veryFarAvoidImpassableLand);

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		addFairLocConstraint(createBoxConstraint(0.0, 0.0, 1.0, 0.75));
		addFairLoc(60.0, 100.0, false, true, 70.0, 12.0, 12.0);
	} else if(cMaxPlayers < 3) {
		addFairLoc(60.0, 100.0, false, true, 60.0, 12.0, 12.0);
	} else if(cMaxPlayers < 5) {
		addFairLoc(60.0, 100.0, false, true, 60.0, 12.0, 12.0, false, false, false, false);
	} else {
		addFairLoc(60.0, 100.0, false, true, 40.0, 12.0, 12.0);
	}

	createFairLocs("settlements");

	// Build small sandy location on fair locs.
	for(f = 1; <= getNumFairLocs()) {
		for(i = 1; < cPlayers) {
			float x = getFairLocX(f, i);
			float z = getFairLocZ(f, i);

			int settlementAreaID = rmCreateArea("settlement area " + f + " " + i);
			rmSetAreaWarnFailure(settlementAreaID, false);
			rmSetAreaBaseHeight(settlementAreaID, 2.0);
			rmSetAreaSize(settlementAreaID, areaRadiusMetersToFraction(15.0));
			rmSetAreaSmoothDistance(settlementAreaID, 5);
			rmSetAreaHeightBlend(settlementAreaID, 2);
			rmSetAreaCoherence(settlementAreaID, 0.2);
			rmSetAreaTerrainType(settlementAreaID, "SandA");
			rmAddAreaToClass(settlementAreaID, classSand);

			rmSetAreaLocation(settlementAreaID, x, z);

			rmBuildArea(settlementAreaID);
		}
	}

	placeObjectAtAllFairLocs(settlementID);

	progress(0.4);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < min(10 * cNonGaiaPlayers, 60)) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(100), rmAreaTilesToFraction(100));
		rmSetAreaTerrainType(beautificationID, "SandA");
		rmSetAreaCoherence(beautificationID, 0.0);
		rmSetAreaBaseHeight(beautificationID, 2.0);
		rmSetAreaHeightBlend(beautificationID, 2);
		rmSetAreaSmoothDistance(beautificationID, 5);
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 32.0);
		rmAddAreaConstraint(beautificationID, veryFarAvoidImpassableLand);
		rmAddAreaConstraint(beautificationID, avoidSand);
		rmAddAreaToClass(beautificationID, classSand);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	progress(0.5);

	// Gold.
	int goldID = createObjectDefVerify("medium gold");
	addObjectDefItemVerify(goldID, "Gold Mine", 1, 0.0);

	int goldBackConstraint = 0;

	if(cMaxPlayers < 3) { // 1v1, 1v2, 2v2.

		if(cMaxPlayers == 1) { // 1v1.
			goldBackConstraint = createBoxConstraint(0.1, 0.0, 0.9, 0.6);
		} else {
			goldBackConstraint = createBoxConstraint(0.25, 0.15, 0.75, 0.6);
		}

		// First (medium, aggressive).
		addSimLocConstraint(goldBackConstraint);
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(farAvoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));

		enableSimLocTwoPlayerCheck();
		// setSimLocBias(cBiasForward);

		if(cMaxPlayers == 1) {
			addSimLoc(65.0, 75.0, avoidGoldDist, 8.0, 8.0, false, true, true);
		} else {
			addSimLoc(70.0, 80.0, avoidGoldDist, 8.0, 8.0, false, true, true);
		}

		if(createSimLocs("medium gold")) {
			placeAreaUnderSimLocs();

			placeObjectAtAllSimLocs(goldID, false);
		}

		resetSimLocs();

		// Second (far, aggressive).
		addSimLocConstraint(goldBackConstraint);
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(farAvoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));

		enableSimLocTwoPlayerCheck(0.075);
		setSimLocBias(cBiasForward);

		addSimLoc(85.0, 105.0, avoidGoldDist, 8.0, 8.0, false, true, true);

		if(createSimLocs("far gold")) {
			placeAreaUnderSimLocs();

			placeObjectAtAllSimLocs(goldID, false);
		}

		resetSimLocs();

		// Third (far, aggressive).
		addSimLocConstraint(goldBackConstraint);
		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(farAvoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));

		enableSimLocTwoPlayerCheck(0.075);
		setSimLocBias(cBiasForward);

		addSimLoc(100.0, 140.0, avoidGoldDist, 8.0, 8.0, false, true, true);

		if(createSimLocs("very far gold")) {
			placeAreaUnderSimLocs();

			placeObjectAtAllSimLocs(goldID, false);
		}

		resetSimLocs();

		// Bonus gold (random).
		if(cNonGaiaPlayers < 3 && randChance()) {
			addSimLocConstraint(goldBackConstraint);
			addSimLocConstraint(avoidAll);
			addSimLocConstraint(avoidEdge);
			addSimLocConstraint(farAvoidImpassableLand);
			addSimLocConstraint(avoidTowerLOS);
			addSimLocConstraint(farAvoidSettlement);
			addSimLocConstraint(farAvoidGold);
			addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 50.0));
			addSimLocConstraint(mediumAvoidCenter);

			enableSimLocTwoPlayerCheck(0.075);

			addSimLoc(80.0, 140.0, avoidGoldDist, 8.0, 8.0, false, true, true);

			if(createSimLocs("bonus gold", false)) {
				placeAreaUnderSimLocs();

				placeObjectAtAllSimLocs(goldID, false);
			}

			resetSimLocs();
		}

	} else { // 3v3 and higher.

		goldBackConstraint = createBoxConstraint(rmXMetersToFraction(75.0) + rmXMetersToFraction(50.0), 0.2, 1.0 - rmXMetersToFraction(75.0) - rmXMetersToFraction(50.0), 0.65);

		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(farAvoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 70.0));
		addSimLocConstraint(goldBackConstraint);

		setSimLocBias(cBiasForward);

		if(cMaxPlayers < 4) {
			addSimLoc(70.0, 85.0, avoidGoldDist, 8.0, 8.0, false, true, true, false);
		} else {
			addSimLoc(70.0, 130.0, 20.0, 8.0, 8.0, false, true, true, false);
		}

		if(createSimLocs("medium gold")) {
			placeAreaUnderSimLocs();

			placeObjectAtAllSimLocs(goldID, false);
		}

		resetSimLocs();

		addSimLocConstraint(avoidAll);
		addSimLocConstraint(avoidEdge);
		addSimLocConstraint(farAvoidImpassableLand);
		addSimLocConstraint(avoidTowerLOS);
		addSimLocConstraint(farAvoidSettlement);
		addSimLocConstraint(farAvoidGold);
		addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 70.0));
		addSimLocConstraint(goldBackConstraint);

		setSimLocBias(cBiasForward);

		if(cMaxPlayers < 4) {
			addSimLoc(90.0, 140.0, avoidGoldDist, 8.0, 8.0, false, true, true, false);
		} else {
			addSimLoc(90.0, 200.0, 20.0, 8.0, 8.0, false, false, true, false);
		}

		if(createSimLocs("far gold")) {
			placeAreaUnderSimLocs();

			placeObjectAtAllSimLocs(goldID, false);
		}

		resetSimLocs();

	}

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	// storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(farAvoidGold);

	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Ocean shore hunt.
	int oceanShoreHuntID = createObjectDefVerify("ocean shore hunt", cNonGaiaPlayers < 3);
	if(randChance(0.75)) {
		addObjectDefItemVerify(oceanShoreHuntID, "Crowned Crane", rmRandInt(5, 8), 2.0);
	} else {
		addObjectDefItemVerify(oceanShoreHuntID, "Crowned Crane", rmRandInt(2, 4), 2.0);
		addObjectDefItemVerify(oceanShoreHuntID, "Hippo", rmRandInt(0, 3), 2.0);
	}
	// setObjectDefDistance(oceanShoreHuntID, 30.0, rmZFractionToMeters(1.0)); // Place via custom function for side players.
	rmAddObjectDefConstraint(oceanShoreHuntID, avoidAll);
	rmAddObjectDefConstraint(oceanShoreHuntID, avoidEdge);
	// rmAddObjectDefConstraint(oceanShoreHuntID, avoidTowerLOS);
	rmAddObjectDefConstraint(oceanShoreHuntID, areaNearOcean);
	rmAddObjectDefConstraint(oceanShoreHuntID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(oceanShoreHuntID, shortAvoidSettlement);
	rmAddObjectDefConstraint(oceanShoreHuntID, shortAvoidGold);
	rmAddObjectDefConstraint(oceanShoreHuntID, avoidHuntable);

	if(cNonGaiaPlayers < 3) {
		// Randomize angle.
		float oceanHuntAngle = randFromIntervals(1.1, 1.15, 1.45, 1.75);

		setPlaceObjectAngleRange(oceanHuntAngle - 0.05, oceanHuntAngle + 0.05);
		placeObjectDefForPlayer(1, oceanShoreHuntID, false, 1, 20.0, 120.0);

		setPlaceObjectAngleRange(2.0 - oceanHuntAngle - 0.05, 2.0 - oceanHuntAngle + 0.05);
		placeObjectDefForPlayer(cNonGaiaPlayers, oceanShoreHuntID, false, 1, 20.0, 120.0);
	} else if(cMaxPlayers < 5) {
		// rmAddObjectDefConstraint(oceanShoreHuntID, avoidTowerLOS);
		rmAddObjectDefConstraint(oceanShoreHuntID, farAvoidCenter);

		for(i = 0; < cTeams) {
			placeObjectDefInArea(oceanShoreHuntID, 0, rmAreaID(cTeamSplitName + " " + i), cMaxPlayers);
		}
	} else {
		placeObjectInTeamSplits(oceanShoreHuntID);
	}

	// Lake shore hunt.
	int lakeShoreHuntID = createObjectDefVerify("lake shore hunt");
	if(randChance(0.75)) {
		addObjectDefItemVerify(lakeShoreHuntID, "Crowned Crane", rmRandInt(5, 8), 2.0);
	} else {
		addObjectDefItemVerify(lakeShoreHuntID, "Crowned Crane", rmRandInt(2, 4), 2.0);
		addObjectDefItemVerify(lakeShoreHuntID, "Hippo", rmRandInt(0, 3), 2.0);
	}
	rmAddObjectDefConstraint(lakeShoreHuntID, avoidAll);
	rmAddObjectDefConstraint(lakeShoreHuntID, avoidEdge);
	// rmAddObjectDefConstraint(lakeShoreHuntID, avoidTowerLOS);
	rmAddObjectDefConstraint(lakeShoreHuntID, areaNearLake);
	rmAddObjectDefConstraint(lakeShoreHuntID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(lakeShoreHuntID, shortAvoidSettlement);
	rmAddObjectDefConstraint(lakeShoreHuntID, shortAvoidGold);
	// rmAddObjectDefConstraint(lakeShoreHuntID, avoidHuntable);

	if(cNonGaiaPlayers > 2) {
		rmAddObjectDefConstraint(lakeShoreHuntID, farAvoidCenter);

		for(i = 0; < cTeams) {
			placeObjectDefInArea(lakeShoreHuntID, 0, rmAreaID(cTeamSplitName + " " + i), 1);
		}
	} else if(cNonGaiaPlayers > 2) {
		placeObjectInTeamSplits(lakeShoreHuntID);
	}

	// Reset angle range.
	resetPlaceObjectAngle();

	// Close hunt.
	if(randChance(0.9)) {
		if(randChance()) {
			storeObjectDefItem("Gazelle", 4, 2.0);
		} else {
			storeObjectDefItem("Zebra", 3, 2.0);
		}
	} else {
		if(randChance()) {
			storeObjectDefItem("Gazelle", rmRandInt(5, 6), 2.0);
		} else {
			storeObjectDefItem("Zebra", rmRandInt(4, 5), 2.0);
		}
	}

	// Force it within tower ranges so we know it's within LOS.
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 15.0)));
	storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(avoidHuntable);
	storeObjectConstraint(shortAvoidGold);

	placeStoredObjectNearStoredLocs(4, false, 30.0, 32.5, 20.0, true); // Square placement for variance.

	// TG Center player bonus hunt.
	int centerStartingHuntID = createObjectDefVerify("tg pocket starting hunt");
	if(randChance()) {
		addObjectDefItemVerify(centerStartingHuntID, "Hippo", rmRandInt(2, 4), 2.0);
	} else {
		addObjectDefItemVerify(centerStartingHuntID, "Zebra", rmRandInt(2, 3), 2.0);
		addObjectDefItemVerify(centerStartingHuntID, "Gazelle", rmRandInt(2, 4), 2.0);
	}
	rmAddObjectDefConstraint(centerStartingHuntID, avoidAll);
	rmAddObjectDefConstraint(centerStartingHuntID, avoidEdge);
	rmAddObjectDefConstraint(centerStartingHuntID, shortAvoidGold);
	rmAddObjectDefConstraint(centerStartingHuntID, avoidFood);

	for(i = 1; < cPlayers) {
		if(getPlayerTeamPos(i) == cPosCenter) {
			placeObjectDefForPlayer(i, centerStartingHuntID, false, 1, 20.0, 30.0, true);
		}
	}

	// Far hunt.
	// Bonus hunt 1.
	int bonusHunt1ID = createObjectDefVerify("bonus hunt 1");
	if(randChance(0.75)) {
		// 1 group.
		if(randChance(0.25)) {
			addObjectDefItemVerify(bonusHunt1ID, "Giraffe", rmRandInt(3, 5), 2.0);
		} else {
			if(randChance(0.5)) {
				addObjectDefItemVerify(bonusHunt1ID, "Gazelle", rmRandInt(3, 5), 2.0);
			} else {
				addObjectDefItemVerify(bonusHunt1ID, "Zebra", rmRandInt(3, 6), 2.0);
			}
		}
	} else {
		// 2 groups.
		if(randChance(0.25)) {
			addObjectDefItemVerify(bonusHunt1ID, "Giraffe", rmRandInt(0, 4), 4.0);
			addObjectDefItemVerify(bonusHunt1ID, "Gazelle", rmRandInt(3, 6), 4.0);
		} else {
			if(randChance(2.0 / 3.0)) {
				addObjectDefItemVerify(bonusHunt1ID, "Zebra", rmRandInt(3, 5), 4.0);
				addObjectDefItemVerify(bonusHunt1ID, "Gazelle", rmRandInt(3, 6), 4.0);
			} else {
				addObjectDefItemVerify(bonusHunt1ID, "Giraffe", rmRandInt(0, 4), 2.0);
				addObjectDefItemVerify(bonusHunt1ID, "Zebra", rmRandInt(3, 5), 2.0);
			}
		}
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(farAvoidImpassableLand);
	addSimLocConstraint(shortAvoidSettlement);
	addSimLocConstraint(shortAvoidGold);
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
	if(cNonGaiaPlayers < 3) {
		addSimLocConstraint(goldBackConstraint);
	} else {
		setSimLocBias(cBiasBackward);
	}

	enableSimLocTwoPlayerCheck();

	addSimLoc(60.0, 80.0, avoidHuntDist, 8.0, 8.0, false, false, true);

	placeObjectAtNewSimLocs(bonusHunt1ID, false, "bonus hunt 1");

	// Bonus hunt 2.
	int bonusHunt2ID = createObjectDefVerify("bonus hunt 2");
	if(randChance(0.75)) {
		// 1 group.
		if(randChance(0.25)) {
			addObjectDefItemVerify(bonusHunt2ID, "Giraffe", rmRandInt(3, 5), 2.0);
		} else {
			if(randChance(0.5)) {
				addObjectDefItemVerify(bonusHunt2ID, "Gazelle", rmRandInt(3, 5), 2.0);
			} else {
				addObjectDefItemVerify(bonusHunt2ID, "Zebra", rmRandInt(3, 6), 2.0);
			}
		}
	} else {
		// 2 groups.
		if(randChance(0.25)) {
			addObjectDefItemVerify(bonusHunt2ID, "Giraffe", rmRandInt(0, 4), 4.0);
			addObjectDefItemVerify(bonusHunt2ID, "Gazelle", rmRandInt(3, 6), 4.0);
		} else {
			if(randChance(2.0 / 3.0)) {
				addObjectDefItemVerify(bonusHunt2ID, "Zebra", rmRandInt(3, 5), 4.0);
				addObjectDefItemVerify(bonusHunt2ID, "Gazelle", rmRandInt(3, 6), 4.0);
			} else {
				addObjectDefItemVerify(bonusHunt2ID, "Giraffe", rmRandInt(0, 4), 2.0);
				addObjectDefItemVerify(bonusHunt2ID, "Zebra", rmRandInt(3, 5), 2.0);
			}
		}
	}

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(farAvoidImpassableLand);
	addSimLocConstraint(shortAvoidSettlement);
	addSimLocConstraint(shortAvoidGold);
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 60.0));
	if(cNonGaiaPlayers > 2) {
		setSimLocBias(cBiasForward);
	}
	enableSimLocTwoPlayerCheck();

	if(cMaxPlayers <= 4) {
		addSimLoc(70.0, 90.0, avoidHuntDist, 8.0, 8.0, false, false, true);
	} else {
		addSimLoc(70.0, 120.0, avoidHuntDist, 8.0, 8.0, false, false, true);
	}

	placeObjectAtNewSimLocs(bonusHunt2ID, false, "bonus hunt 2");

	// Bonus hunt 3-4 into food zones.
	int foodZone = createBoxConstraint(0.1, 0.075, 0.9, 0.3);

	if(cNonGaiaPlayers > 2) {
		foodZone = createBoxConstraint(0.2, 0.1, 0.8, 0.7);
	}

	// Bonus hunt 3.
	int bonusHunt3ID = createObjectDefVerify("bonus hunt 3");
	if(randChance(0.75)) {
		// 1 group.
		if(randChance(0.25)) {
			addObjectDefItemVerify(bonusHunt3ID, "Giraffe", rmRandInt(3, 5), 2.0);
		} else {
			if(randChance(0.5)) {
				addObjectDefItemVerify(bonusHunt3ID, "Hippo", rmRandInt(2, 4), 2.0);
			} else {
				addObjectDefItemVerify(bonusHunt3ID, "Elephant", rmRandInt(1, 2), 2.0);
			}
		}
	} else {
		// 2 groups.
		if(randChance(0.25)) {
			addObjectDefItemVerify(bonusHunt3ID, "Giraffe", rmRandInt(0, 3), 4.0);
			if(randChance()) {
				addObjectDefItemVerify(bonusHunt3ID, "Gazelle", rmRandInt(3, 4), 4.0);
			} else {
				addObjectDefItemVerify(bonusHunt3ID, "Zebra", rmRandInt(3, 4), 4.0);
			}
		} else {
			if(randChance(2.0 / 3.0)) {
				addObjectDefItemVerify(bonusHunt3ID, "Elephant", rmRandInt(1, 2), 4.0);
				addObjectDefItemVerify(bonusHunt3ID, "Gazelle", rmRandInt(2, 3), 4.0);
			} else {
				addObjectDefItemVerify(bonusHunt3ID, "Hippo", rmRandInt(2, 4), 2.0);
				addObjectDefItemVerify(bonusHunt3ID, "Zebra", rmRandInt(2, 3), 2.0);
			}
		}
	}

	rmAddObjectDefConstraint(bonusHunt3ID, avoidAll);
	rmAddObjectDefConstraint(bonusHunt3ID, avoidEdge);
	rmAddObjectDefConstraint(bonusHunt3ID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusHunt3ID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(bonusHunt3ID, shortAvoidSettlement);
	rmAddObjectDefConstraint(bonusHunt3ID, shortAvoidGold);
	rmAddObjectDefConstraint(bonusHunt3ID, avoidHuntable);
	rmAddObjectDefConstraint(bonusHunt3ID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(bonusHunt3ID, foodZone);
	
	if(gameHasTwoEqualTeams()) {
		placeObjectInTeamSplits(bonusHunt3ID);
	}

	// Bonus hunt 4 for 1v1.
	if(cNonGaiaPlayers < 3) {
		int bonusHunt4ID = createObjectDefVerify("bonus hunt 4");
		if(randChance(0.75)) {
			// 1 group.
			if(randChance(0.25)) {
				addObjectDefItemVerify(bonusHunt4ID, "Giraffe", rmRandInt(3, 5), 2.0);
			} else {
				if(randChance(0.5)) {
					addObjectDefItemVerify(bonusHunt4ID, "Gazelle", rmRandInt(2, 5), 2.0);
				} else {
					addObjectDefItemVerify(bonusHunt4ID, "Zebra", rmRandInt(2, 6), 2.0);
				}
			}
		} else {
			// 2 groups.
			if(randChance(0.25)) {
				addObjectDefItemVerify(bonusHunt4ID, "Giraffe", rmRandInt(0, 4), 4.0);
				addObjectDefItemVerify(bonusHunt4ID, "Gazelle", rmRandInt(2, 6), 4.0);
			} else {
				if(randChance(2.0 / 3.0)) {
					addObjectDefItemVerify(bonusHunt4ID, "Zebra", rmRandInt(2, 5), 4.0);
					addObjectDefItemVerify(bonusHunt4ID, "Gazelle", rmRandInt(2, 6), 4.0);
				} else {
					addObjectDefItemVerify(bonusHunt4ID, "Giraffe", rmRandInt(0, 4), 2.0);
					addObjectDefItemVerify(bonusHunt4ID, "Zebra", rmRandInt(2, 5), 2.0);
				}
			}
		}

		rmAddObjectDefConstraint(bonusHunt4ID, avoidAll);
		rmAddObjectDefConstraint(bonusHunt4ID, avoidEdge);
		rmAddObjectDefConstraint(bonusHunt4ID, avoidTowerLOS);
		rmAddObjectDefConstraint(bonusHunt4ID, mediumAvoidImpassableLand);
		rmAddObjectDefConstraint(bonusHunt4ID, shortAvoidSettlement);
		rmAddObjectDefConstraint(bonusHunt4ID, shortAvoidGold);
		rmAddObjectDefConstraint(bonusHunt4ID, avoidHuntable);
		rmAddObjectDefConstraint(bonusHunt4ID, createClassDistConstraint(classStartingSettlement, 90.0));
		rmAddObjectDefConstraint(bonusHunt4ID, foodZone);

		placeObjectInTeamSplits(bonusHunt4ID);
	}

	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

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
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(90));
			if(randChance()) {
				rmSetAreaForestType(playerForestID, "Savannah Forest");
			} else {
				rmSetAreaForestType(playerForestID, "Palm Forest");
			}
			rmSetAreaBaseHeight(playerForestID, 4.0);
			rmSetAreaSmoothDistance(playerForestID, 5);
			rmSetAreaHeightBlend(playerForestID, 2);
			rmSetAreaMinBlobs(playerForestID, 2);
			rmSetAreaMaxBlobs(playerForestID, 4);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 32.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, avoidForest);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, farAvoidImpassableLand);
			rmSetAreaWarnFailure(playerForestID, false);
			rmBuildArea(playerForestID);
		}
	}

	// Other forest.
	int numRegularForests = 15 - numPlayerForests;

	int forestFailCount = 0;

	for(i = 0; < numRegularForests * cNonGaiaPlayers) {
		int forestID = rmCreateArea("forest " + i);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(60), rmAreaTilesToFraction(90));
		if(randChance()) {
			rmSetAreaForestType(forestID, "Savannah Forest");
		} else {
			rmSetAreaForestType(forestID, "Palm Forest");
		}
		rmSetAreaBaseHeight(forestID, 4.0);
		rmSetAreaSmoothDistance(forestID, 5);
		rmSetAreaHeightBlend(forestID, 2);
		rmSetAreaMinBlobs(forestID, 2);
		rmSetAreaMaxBlobs(forestID, 4);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 32.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, avoidForest);
		rmAddAreaConstraint(forestID, farAvoidImpassableLand);
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
	int numPreds1 = rmRandInt(1, 2);
	int numPreds2 = 3 - numPreds1;

	if(randChance(1.0 / 3.0) || cMaxPlayers > 3) {
		numPreds1 = 1;
		numPreds2 = 1;
	}

	// Only place if we don't have too many players.
	placeObjectInTeamSplits(farPredators1ID, false, numPreds1);
	placeObjectInTeamSplits(farPredators2ID, false, numPreds2);

	// Medium herdables.
	placeObjectAtPlayerLocs(mediumHerdablesID, false, 2);

	// Far herdables.
	placeObjectInTeamSplits(farHerdablesID, false, 2);

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectInTeamSplits(relicID);

	// Random trees.
	placeObjectAtPlayerLocs(randomTree1ID, false, 5);
	placeObjectAtPlayerLocs(randomTree2ID, false, 5);

	// Fish.
	// Player fish.
	int fishLandMin = createTerrainDistConstraint("Land", true, 17.0);
	int fishLandMax = createTerrainMaxDistConstraint("Land", true, 20.0);

	if(cNonGaiaPlayers < 3) {
		// Place first one dead ahead so that the other 2 fit in better.
		float axisFishDist = 50.0;
		float axisDistIncr = 1.0;

		float fishAngle = 0.0;

		for(j = 0; < 2) {
			int axisFishID = rmCreateObjectDef("player axis fish " + j);
			rmAddObjectDefItem(axisFishID, "Fish - Perch", 3, 5.0);
			rmAddObjectDefConstraint(axisFishID, fishLandMin);

			for(i = 1; < 3) {
				for(k = 0; < 1000) {
					float fishRadius = rmXMetersToFraction(axisFishDist + axisDistIncr * k);

					if(getPlayerLocXFraction(i) < 0.5) { // Southern player.
						if(j == 0) {
							fishAngle = rmRandFloat(1.275, 1.3) * PI;
						} else if(j == 1) {
							fishAngle = rmRandFloat(1.375, 1.4) * PI;
						}
					} else { // Northern player.
						if(j == 0) {
							fishAngle = rmRandFloat(0.7, 0.725) * PI;
						} else if(j == 1) {
							fishAngle = rmRandFloat(0.6, 0.625) * PI;
						}
					}

					float fishX = getXFromPolarForPlayer(i, fishRadius, fishAngle);
					float fishZ = getZFromPolarForPlayer(i, fishRadius, fishAngle);

					if(placeObjectForPlayer(axisFishID, 0, fishX, fishZ)) {
						printDebug("axisFish: i = " + i + ", k = " + k, cDebugTest);
						break;
					}
				}
			}
		}
	} else {
		int avoidFish = createTypeDistConstraint("Fish", 16.0);

		if(cMaxPlayers > 2) {
			avoidFish = createTypeDistConstraint("Fish", 20.0);
		}

		// Ocean fish.
		int oceanFishID = rmCreateObjectDef("ocean fish");
		rmAddObjectDefItem(oceanFishID, "Fish - Perch", 2, 5.0);
		// setObjectDefDistanceToMax(oceanFishID);
		rmAddObjectDefConstraint(oceanFishID, fishLandMin);
		rmAddObjectDefConstraint(oceanFishID, fishLandMax);
		rmAddObjectDefConstraint(oceanFishID, avoidFish);
		rmAddObjectDefConstraint(oceanFishID, createBoxConstraint(0.0, 0.5, 1.0, 1.0));

		placeObjectDefInArea(oceanFishID, 0, seaID, 5 * cNonGaiaPlayers);

		// Lake fish.
		int lakeFishID = rmCreateObjectDef("lake fish");
		rmAddObjectDefItem(lakeFishID, "Fish - Perch", 3, 5.0);
		// setObjectDefDistanceToMax(lakeFishID);
		rmAddObjectDefConstraint(lakeFishID, fishLandMin);
		rmAddObjectDefConstraint(lakeFishID, fishLandMax);
		rmAddObjectDefConstraint(lakeFishID, avoidFish);
		rmAddObjectDefConstraint(lakeFishID, createBoxConstraint(0.25, 0.0, 0.75, 0.5));

		placeObjectDefInArea(lakeFishID, 0, lakeID, 3 * cNonGaiaPlayers);

	}

	// Randomly place singles.
	int numLoneFish = 5;

	if(cNonGaiaPlayers < 3) {
		numLoneFish = 10;
	}

	int loneFishID = rmCreateObjectDef("lone fish");
	rmAddObjectDefItem(loneFishID, "Fish - Mahi", 1, 0.0);
	setObjectDefDistanceToMax(loneFishID);
	rmAddObjectDefConstraint(loneFishID, fishLandMin);
	rmAddObjectDefConstraint(loneFishID, createTypeDistConstraint("Fish", 12.0));
	rmPlaceObjectDefAtLoc(loneFishID, 0, 0.5, 0.5, numLoneFish * cNonGaiaPlayers);

	progress(0.9);

	// Embellishment.
	// Bushes.
	int bush1ID = rmCreateObjectDef("bush 1");
	rmAddObjectDefItem(bush1ID, "Bush", rmRandInt(2, 4), 4.0);
	rmSetObjectDefMinDistance(bush1ID);
	rmAddObjectDefConstraint(bush1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush1ID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush1ID, 0, 0.5, 0.5, 40 * cNonGaiaPlayers);

	int bush2ID = rmCreateObjectDef("bush 2");
	rmAddObjectDefItem(bush2ID, "Bush", rmRandInt(2, 4), 4.0);
	rmAddObjectDefItem(bush2ID, "Rock Sandstone Sprite", 1, 4.0);
	setObjectDefDistanceToMax(bush2ID);
	rmAddObjectDefConstraint(bush2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush2ID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 40 * cNonGaiaPlayers);

	// Rocks.
	int rockID = rmCreateObjectDef("rock sprite");
	rmAddObjectDefItem(rockID, "Rock Sandstone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rockID);
	rmAddObjectDefConstraint(rockID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 40 * cNonGaiaPlayers);

	// Grass.
	int grassID = rmCreateObjectDef("grass");
	rmAddObjectDefItem(grassID, "Grass", 1, 0.0);
	setObjectDefDistanceToMax(grassID);
	rmAddObjectDefConstraint(grassID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(grassID, shortAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 40 * cNonGaiaPlayers);

	// Water embellishment.
	int papyrus1ID = rmCreateObjectDef("papyrus 1");
	rmAddObjectDefItem(papyrus1ID, "Papyrus", 2, 4.0);
	setObjectDefDistanceToMax(papyrus1ID);
	rmAddObjectDefConstraint(papyrus1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(papyrus1ID, embellishmentNearShore);
	rmPlaceObjectDefAtLoc(papyrus1ID, 0, 0.5, 0.5, 3 * cNonGaiaPlayers);

	int papyrus2ID = rmCreateObjectDef("papyrus 2");
	rmAddObjectDefItem(papyrus2ID, "Papyrus", rmRandInt(4, 6), 4.0);
	setObjectDefDistanceToMax(papyrus2ID);
	rmAddObjectDefConstraint(papyrus2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(papyrus2ID, embellishmentNearShore);
	rmPlaceObjectDefAtLoc(papyrus2ID, 0, 0.5, 0.5, 2 * cNonGaiaPlayers);

	int waterEmbellishmentID = rmCreateObjectDef("water embellishment");
	rmAddObjectDefItem(waterEmbellishmentID, "Water Decoration", 3, 6.0);
	setObjectDefDistanceToMax(waterEmbellishmentID);
	rmAddObjectDefConstraint(waterEmbellishmentID, embellishmentAvoidAll);
	rmPlaceObjectDefAtLoc(waterEmbellishmentID, 0, 0.5, 0.5, 25 * min(cNonGaiaPlayers, 6));

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
