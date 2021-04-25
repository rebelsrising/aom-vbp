/*
** MIRAGE
** RebelsRising
** Last edit: 17/04/2021
*/

include "rmx 5-0-0.xs";

// Override 1v1 forward.
mutable float randFwdInsideSingle(float tol = 0.0) {
	if(randChance()) {
		return(rmRandFloat(0.7 - 0.3 * tol, 1.0 + 0.5 * tol) * PI);
	} else {
		return(rmRandFloat(1.0 - 0.5 * tol, 1.3 + 0.2 * tol) * PI);
	}
}

mutable float randFwdOutsideSingle(float tol = 0.0) {
	if(randChance()) {
		return(rmRandFloat(0.7 - 0.3 * tol, 1.0 + 0.5 * tol) * PI);
	} else {
		return(rmRandFloat(1.0 - 0.5 * tol, 1.3 + 0.2 * tol) * PI);
	}
}

// Overrides 1v1 backward.
mutable float randBackInsideSingle(float tol = 0.0) {
	return(randFromIntervals(0.45, 0.6, 1.4, 1.55) * PI);
}

mutable float randBackOutsideSingle(float tol = 0.0) {
	return(randFromIntervals(0.45, 0.6, 1.4, 1.55) * PI);
}

// Override tg forward outside.
mutable float randFwdOutsideFirst(float tol = 0.0) {
	return(rmRandFloat(1.0 - 0.2 * tol, 1.3 + 0.2 * tol) * PI);
}

mutable float randFwdOutsideLast(float tol = 0.0) {
	return(rmRandFloat(0.7 - 0.2 * tol, 1.0 + 0.2 * tol) * PI);
}

// Overrides tg forward inside.
mutable float randFwdInsideFirst(float tol = 0.0) {
	return(rmRandFloat(0.7 - 0.2 * tol, 1.0 + 0.2 * tol) * PI);
}

mutable float randFwdInsideLast(float tol = 0.0) {
	return(rmRandFloat(1.0 - 0.2 * tol, 1.3 + 0.2 * tol) * PI);
}

// Overrides tg backward outside.
mutable float randBackOutsideFirst(float tol = 0.0) {
	return(rmRandFloat(1.3 - 0.1 * tol, 1.5) * PI);
}

mutable float randBackOutsideLast(float tol = 0.0) {
	return(rmRandFloat(0.5, 0.7 + 0.1 * tol) * PI);
}

// Overrides tg backward inside.
mutable float randBackInsideFirst(float tol = 0.0) {
	return(rmRandFloat(0.45, 0.65 + 0.1 * tol) * PI);
}

mutable float randBackInsideLast(float tol = 0.0) {
	return(rmRandFloat(1.35 - 0.1 * tol, 1.55) * PI);
}

// Overrides tg center forward (remains unchanged).
mutable float randFwdCenter(float tol = 0.0) {
	return(rmRandFloat(0.8 - 0.3 * tol, 1.2 + 0.3 * tol) * PI);
}

// Overrides tg center backward.
mutable float randBackCenter(float tol = 0.0) {
	return(randFromIntervals(-0.5 - tol * 0.5, -0.5, 0.5, 0.5 + tol * 0.5) * PI);
}

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Mirage");

	int maxPlayers = getNumberPlayersOnTeam(0);

	for(i = 1; < cTeams) {
		maxPlayers = max(maxPlayers, getNumberPlayersOnTeam(i));
	}

	float dimX = 320.0 + 30.0 * maxPlayers;
	float dimZ = 80.0 + 150.0 * maxPlayers;

	// Initialize map.
	initializeMap("SandA", dimX, dimZ);

	// Player placement.
	if(cNonGaiaPlayers < 3) {
		placePlayersInLine(0.225, 0.5, 0.775, 0.5);
	} else if(cTeams < 3) {
		int teamInt = rmRandInt(0, 1);
		// It's absolutely CRUCIAL to still place players in a counter clock-wise fashion!
		placeTeamInLine(teamInt, 0.225, 1.0 - rmZMetersToFraction(100.0), 0.225, rmZMetersToFraction(100.0));
		placeTeamInLine(1 - teamInt, 0.775, rmZMetersToFraction(100.0), 0.775, 1.0 - rmZMetersToFraction(100.0));
	} else {
		placePlayersInSquare(0.3);
	}

	// Set gaia.
	rmSetGaiaCiv(cCivIsis);

	// Control areas.
	int classCenter = initializeCenter();

	// Classes.
	int classPlayer = rmDefineClass("player");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classCliff = rmDefineClass("cliff");
	int classForest = rmDefineClass("forest");

	// Global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidPlayer = createClassDistConstraint(classPlayer, 1.0);
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);

	// Settlements.
	int shortAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int farAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 20.0);

	// Terrain.
	int shortAvoidImpassableLand = createTerrainDistConstraint("Land", false, 1.0);
	int mediumAvoidImpassableLand = createTerrainDistConstraint("Land", false, 6.0);
	int farAvoidImpassableLand = createTerrainDistConstraint("Land", false, 10.0);
	int shortAvoidCliff = createClassDistConstraint(classCliff, 10.0);
	int farAvoidCliff = createClassDistConstraint(classCliff, 35.0);

	// Gold.
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
	int startingSettlementID = createObjectDefVerify("starting settlement");
	addObjectDefItemVerify(startingSettlementID, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass(startingSettlementID, classStartingSettlement);

	// Towers.
	int startingTowerID = createObjectDefVerify("starting tower");
	addObjectDefItemVerify(startingTowerID, "Tower", 1, 0.0);
	setObjectDefDistance(startingTowerID, 23.0, 27.0);
	rmAddObjectDefConstraint(startingTowerID, avoidTower);
	rmAddObjectDefConstraint(startingTowerID, mediumAvoidImpassableLand);

	// Starting hunt.
	int startingHuntID = createObjectDefVerify("starting hunt");
	addObjectDefItemVerify(startingHuntID, "Boar", 1, 0.0);
	setObjectDefDistance(startingHuntID, 18.0, 20.0);
	rmAddObjectDefConstraint(startingHuntID, avoidAll);
	rmAddObjectDefConstraint(startingHuntID, avoidEdge);

	// Starting food.
	int startingFoodID = createObjectDefVerify("starting food");
	if(randChance()) {
		addObjectDefItemVerify(startingFoodID, "Chicken", rmRandInt(5, 6), 2.0);
	} else {
		addObjectDefItemVerify(startingFoodID, "Berry Bush", rmRandInt(5, 6), 2.0);
	}
	setObjectDefDistance(startingFoodID, 20.0, 25.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, mediumAvoidImpassableLand);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);

	// Starting herdables.
	int startingHerdablesID = createObjectDefVerify("starting herdables");
	addObjectDefItemVerify(startingHerdablesID, "Cow", rmRandInt(1, 3), 2.0);
	setObjectDefDistance(startingHerdablesID, 25.0, 30.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(startingHerdablesID, shortAvoidImpassableLand);

	// Straggler trees.
	int stragglerTreeID = createObjectDefVerify("straggler tree");
	addObjectDefItemVerify(stragglerTreeID, "Palm", 1, 0.0);
	setObjectDefDistance(stragglerTreeID, 13.0, 14.0);
	rmAddObjectDefConstraint(stragglerTreeID, avoidAll);

	// Far monkeys.
	int farMonkeysID = createObjectDefVerify("far monkeys");
	if(randChance()) {
		addObjectDefItemVerify(farMonkeysID, "Monkey", rmRandInt(5, 8), 2.0);
	} else {
		addObjectDefItemVerify(farMonkeysID, "Baboon", rmRandInt(5, 8), 2.0);
	}
	rmAddObjectDefConstraint(farMonkeysID, avoidAll);
	rmAddObjectDefConstraint(farMonkeysID, avoidEdge);
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farMonkeysID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farMonkeysID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(farMonkeysID, shortAvoidGold);
	rmAddObjectDefConstraint(farMonkeysID, avoidFood);
	rmAddObjectDefConstraint(farMonkeysID, avoidHuntable);

	// Far berries.
	int farBerriesID = createObjectDefVerify("far berries");
	addObjectDefItemVerify(farBerriesID, "Berry Bush", rmRandInt(5, 8), 2.0);
	rmAddObjectDefConstraint(farBerriesID, avoidAll);
	rmAddObjectDefConstraint(farBerriesID, avoidEdge);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidSettlement);
	rmAddObjectDefConstraint(farBerriesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farBerriesID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(farBerriesID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerriesID, avoidFood);

	// Medium herdables.
	int mediumHerdablesID = createObjectDefVerify("medium herdables");
	addObjectDefItemVerify(mediumHerdablesID, "Cow", rmRandInt(2, 3), 4.0);
	setObjectDefDistance(mediumHerdablesID, 55.0, 65.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 55.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, mediumAvoidImpassableLand);

	// Far herdables.
	int farHerdablesID = createObjectDefVerify("far herdables");
	addObjectDefItemVerify(farHerdablesID, "Cow", rmRandInt(1, 2), 4.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);
	rmAddObjectDefConstraint(farHerdablesID, farAvoidImpassableLand);

	// Far predators.
	int farPredatorsID = createObjectDefVerify("far predators");
	if(randChance()) {
		addObjectDefItemVerify(farPredatorsID, "Lion", 2, 4.0);
	} else {
		addObjectDefItemVerify(farPredatorsID, "Hyena", 2, 4.0);
	}
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(farPredatorsID, farAvoidSettlement);
	rmAddObjectDefConstraint(farPredatorsID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(farPredatorsID, avoidPredator);

	// Other objects.
	// Relics.
	int relicID = createObjectDefVerify("relic");
	addObjectDefItemVerify(relicID, "Relic", 1, 0.0);
	rmAddObjectDefConstraint(relicID, avoidAll);
	rmAddObjectDefConstraint(relicID, avoidEdge);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(relicID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(relicID, avoidRelic);

	// Random trees.
	int randomTreeID = createObjectDefVerify("random tree");
	addObjectDefItemVerify(randomTreeID, "Palm", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, forestAvoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, farAvoidImpassableLand);

	progress(0.1);

	// Oceans.
	for(i = 0; < 2) {
		int oceanID = rmCreateArea("ocean " + i);
		rmSetAreaSize(oceanID, rmXMetersToFraction(45.0));
		rmSetAreaWaterType(oceanID, "Egyptian Nile");
		rmSetAreaHeightBlend(oceanID, 1);
		rmSetAreaCoherence(oceanID, 0.7);
		rmSetAreaSmoothDistance(oceanID, 1);
		rmSetAreaWarnFailure(oceanID, false);

		if(i == 0) {
			rmSetAreaLocation(oceanID, 0.01, 0.5);
			rmAddAreaInfluenceSegment(oceanID, 0.0, 0.0, 0.0, 1.0);
		} else if(i == 1) {
			rmSetAreaLocation(oceanID, 0.99, 0.5);
			rmAddAreaInfluenceSegment(oceanID, 1.0, 0.0, 1.0, 1.0);
		}
	}

	rmBuildAllAreas();

	// Set up player areas.
	for(i = 1; < cPlayers) {
		int playerAreaID = rmCreateArea("player area " + getPlayer(i));
		rmSetAreaSize(playerAreaID, rmAreaTilesToFraction(1200));
		rmSetAreaLocPlayer(playerAreaID, getPlayer(i));
		rmSetAreaTerrainType(playerAreaID, "SandA");
		rmSetAreaBaseHeight(playerAreaID, 2.0);
		rmSetAreaHeightBlend(playerAreaID, 2);
		rmSetAreaCoherence(playerAreaID, 1.0);
		rmSetAreaWarnFailure(playerAreaID, false);
		rmBuildArea(playerAreaID);
	}

	progress(0.2);

	// Beautification.
	int beautificationID = 0;

	for(i = 0; < 100 * cNonGaiaPlayers) {
		beautificationID = rmCreateArea("beautification " + i);
		rmSetAreaTerrainType(beautificationID, "SandD");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(20), rmAreaTilesToFraction(60));
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmAddAreaConstraint(beautificationID, farAvoidImpassableLand);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	progress(0.3);

	// Starting settlement.
	placeObjectAtPlayerLocs(startingSettlementID, true);

	// Towers.
	placeAndStoreObjectAtPlayerLocs(startingTowerID, true, 4, 23.0, 27.0, true);

	// Close settlement.
	int settlementID = rmCreateObjectDef("settlements");
	rmAddObjectDefItem(settlementID, "Settlement", 1, 0.0);

	if(cNonGaiaPlayers < 3) {
		addFairLocConstraint(farAvoidImpassableLand);
	} else {
		addFairLocConstraint(avoidTowerLOS);
		addFairLocConstraint(createTerrainDistConstraint("Land", false, rmRandFloat(10.0, 20.0)));
	}

	enableFairLocTwoPlayerCheck();

	addFairLoc(60.0, 80.0, false, randChance(), 60.0, 12.0, 12.0, false, false, false, false);

	// Far settlement.
	addFairLocConstraint(farAvoidImpassableLand);
	addFairLocConstraint(avoidTowerLOS);

	enableFairLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		addFairLoc(70.0, 90.0, true, randChance(), 80.0, 12.0, 12.0);
	} else {
		addFairLoc(70.0, 90.0, true, randChance(), 70.0, 12.0, 12.0);
	}

	setFairLocInterDistMin(70.0);

	placeObjectAtNewFairLocs(settlementID);

	progress(0.4);

	// Cliffs.
	for(i = 0; < 3 * cNonGaiaPlayers) {
		int cliffID = rmCreateArea("cliff " + i);
		rmSetAreaSize(cliffID, rmAreaTilesToFraction(400));
		rmSetAreaCliffType(cliffID, "Egyptian");
		rmSetAreaMinBlobs(cliffID, 2);
		rmSetAreaMaxBlobs(cliffID, 5);
		rmSetAreaMinBlobDistance(cliffID, 5.0);
		rmSetAreaMaxBlobDistance(cliffID, 10.0);
		rmSetAreaHeightBlend(cliffID, 2);
		rmSetAreaSmoothDistance(cliffID, 10);
		rmSetAreaCliffEdge(cliffID, 2, 0.2, 0.0, 1.0, 1);
		rmSetAreaCliffPainting(cliffID, true, true, true, 1.5, true);
		rmSetAreaCliffHeight(cliffID, -5, 1.0, 1.0);
		rmAddAreaToClass(cliffID, classCliff);
		rmAddAreaConstraint(cliffID, avoidEdge);
		rmAddAreaConstraint(cliffID, avoidTowerLOS);
		rmAddAreaConstraint(cliffID, farAvoidImpassableLand);
		rmAddAreaConstraint(cliffID, farAvoidCliff);
		rmAddAreaConstraint(cliffID, avoidBuildings);
		rmSetAreaWarnFailure(cliffID, false);
		rmBuildArea(cliffID);
	}

	// Elevation.
	int elevationID = 0;

	for(i = 0; < 20 * cNonGaiaPlayers) {
		elevationID = rmCreateArea("elevation " + i);
		rmSetAreaSize(elevationID, rmAreaTilesToFraction(75), rmAreaTilesToFraction(125));
		rmSetAreaBaseHeight(elevationID, rmRandFloat(0.0, 2.0));
		rmSetAreaHeightBlend(elevationID, 1);
		rmSetAreaMinBlobs(elevationID, 1);
		rmSetAreaMaxBlobs(elevationID, 5);
		rmSetAreaMinBlobDistance(elevationID, 16.0);
		rmSetAreaMaxBlobDistance(elevationID, 40.0);
		rmAddAreaConstraint(elevationID, shortAvoidCliff);
		rmAddAreaConstraint(elevationID, farAvoidImpassableLand);
		rmAddAreaConstraint(elevationID, avoidBuildings);
		rmSetAreaWarnFailure(elevationID, false);
		rmBuildArea(elevationID);
	}

	progress(0.5);

	// Gold.
	int goldID = createObjectDefVerify("gold");
	addObjectDefItemVerify(goldID, "Gold Mine", 1, 0.0);

	// Medium.
	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(farAvoidSettlement);
	addSimLocConstraint(farAvoidImpassableLand);
	addSimLocConstraint(createClassDistConstraint(classStartingSettlement, 40.0));
	addSimLocConstraint(farAvoidGold);
	addSimLocConstraint(avoidTowerLOS);

	enableSimLocTwoPlayerCheck();

	addSimLoc(50.0, 70.0, avoidGoldDist, 8.0, 8.0, false, false, true);

	if(cNonGaiaPlayers < 3) {
		enableSimLocTwoPlayerCheck();
		addSimLocWithPrevConstraints(55.0, 75.0, avoidGoldDist, 8.0, 8.0, false, false, true);
	}

	placeObjectAtNewSimLocs(goldID, false, "medium gold");

	// Bonus gold (anywhere in team area).
	int bonusGoldID = createObjectDefVerify("bonus gold", cNonGaiaPlayers < 5);
	addObjectDefItemVerify(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidSettlement);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 70.0));
	rmAddObjectDefConstraint(bonusGoldID, avoidTowerLOS);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);

	if(cNonGaiaPlayers < 3) {
		placeObjectInTeamSplits(bonusGoldID, false, rmRandInt(1, 2));
	} else {
		placeObjectInTeamSplits(bonusGoldID, false, 3);
	}

	// Starting gold near one of the towers (set last parameter to true to use square placement).
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	// storeObjectConstraint(avoidAll);
	storeObjectConstraint(farAvoidImpassableLand);
	storeObjectConstraint(farAvoidGold); // Since the constraint is so small, apply it also to starting gold.
	placeStoredObjectNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	progress(0.6);

	// Food.
	// Medium hunt.
	int mediumHuntID = createObjectDefVerify("medium hunt");
	addObjectDefItemVerify(mediumHuntID, "Gazelle", rmRandInt(6, 9), 2.0);

	addSimLocConstraint(avoidAll);
	addSimLocConstraint(avoidEdge);
	addSimLocConstraint(avoidTowerLOS);
	addSimLocConstraint(avoidHuntable);
	addSimLocConstraint(farAvoidImpassableLand);
	addSimLocConstraint(shortAvoidGold);

	enableSimLocTwoPlayerCheck();

	if(cNonGaiaPlayers < 3) {
		setSimLocInterval(10.0);
	}

	addSimLoc(50.0, 70.0, avoidHuntDist, 8.0, 8.0, false, gameHasTwoEqualTeams(), true);

	placeObjectAtNewSimLocs(mediumHuntID, false, "medium hunt");

	// Starting hunt.
	placeObjectAtPlayerLocs(startingHuntID);

	// Starting food.
	placeObjectAtPlayerLocs(startingFoodID);

	// Monkeys.
	placeObjectInPlayerSplits(farMonkeysID);

	// Berries.
	placeObjectInPlayerSplits(farBerriesID);

	progress(0.7);

	// Player forest.
	int numPlayerForests = 3;

	for(i = 1; < cPlayers) {
		int playerForestAreaID = rmCreateArea("player forest area " + getPlayer(i));
		rmSetAreaSize(playerForestAreaID, rmAreaTilesToFraction(2200));
		rmSetAreaLocPlayer(playerForestAreaID, getPlayer(i));
		rmSetAreaCoherence(playerForestAreaID, 1.0);
		rmSetAreaWarnFailure(playerForestAreaID, false);
		rmBuildArea(playerForestAreaID);

		for(j = 0; < numPlayerForests) {
			int playerForestID = rmCreateArea("player forest " + i + " " + j, playerForestAreaID);
			rmSetAreaSize(playerForestID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
			rmSetAreaForestType(playerForestID, "Palm Forest");
			rmSetAreaMinBlobs(playerForestID, 3);
			rmSetAreaMaxBlobs(playerForestID, 5);
			rmSetAreaMinBlobDistance(playerForestID, 16.0);
			rmSetAreaMaxBlobDistance(playerForestID, 40.0);
			rmAddAreaToClass(playerForestID, classForest);
			rmAddAreaConstraint(playerForestID, avoidAll);
			rmAddAreaConstraint(playerForestID, farAvoidImpassableLand);
			rmAddAreaConstraint(playerForestID, forestAvoidStartingSettlement);
			rmAddAreaConstraint(playerForestID, avoidForest);
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
		rmSetAreaForestType(forestID, "Palm Forest");
		rmSetAreaMinBlobs(forestID, 3);
		rmSetAreaMaxBlobs(forestID, 5);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 40.0);
		rmAddAreaToClass(forestID, classForest);
		rmAddAreaConstraint(forestID, avoidAll);
		rmAddAreaConstraint(forestID, farAvoidImpassableLand);
		rmAddAreaConstraint(forestID, forestAvoidStartingSettlement);
		rmAddAreaConstraint(forestID, avoidForest);
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
	placeObjectAtPlayerLocs(mediumHerdablesID);

	// Far herdables.
	placeObjectInPlayerSplits(farHerdablesID);

	// Starting herdables.
	placeObjectAtPlayerLocs(startingHerdablesID, true);

	// Straggler trees.
	placeObjectAtPlayerLocs(stragglerTreeID, false, rmRandInt(2, 5));

	// Relics.
	placeObjectInPlayerSplits(relicID);

	// Random trees.
	placeObjectAtPlayerLocs(randomTreeID, false, 10);

	// Define fish.
	int fish1ID = rmCreateObjectDef("close fish 1");
	rmAddObjectDefItem(fish1ID, "Fish - Mahi", rmRandInt(2, 3), 5.0);

	int fish2ID = rmCreateObjectDef("close fish 2");
	rmAddObjectDefItem(fish2ID, "Fish - Mahi", 2, 5.0);

	// Place fish.
	if(cTeams < 3) {

		int numFish = 3;

		float fishDist = randRadiusFromInterval(53.5 + 6.5 * maxPlayers);

		for(i = 1; < cPlayers) {
			float playerAngle = getPlayerAngle(i);
			float teamOffset = getPlayerTeamOffsetAngle(i);

			// Calculate center point for first fish.
			float fX = getXFromPolarForPlayer(i, fishDist, teamOffset);
			float fZ = getZFromPolarForPlayer(i, fishDist, teamOffset);

			for(j = 0; < numFish) {
				float fishHalfWidth = rmZMetersToFraction(25.0);

				if(j % 2 == 1) {
					rmPlaceObjectDefAtLoc(fish1ID, 0, fX, fZ - fishHalfWidth + (2.0 * fishHalfWidth) * j / (numFish - 1));
				} else {
					rmPlaceObjectDefAtLoc(fish2ID, 0, fX, fZ - fishHalfWidth + (2.0 * fishHalfWidth) * j / (numFish - 1));
				}
			}
		}

		// Far fish.
		int farFishID = rmCreateObjectDef("far fish");
		rmAddObjectDefItem(farFishID, "Fish - Perch", 2, 4.0);

		float farX = 0.0;
		float farZ = 0.0;

		if(cNonGaiaPlayers < 3) {
			// Corner fish (currently unused).
			// farX = rmXMetersToFraction(17.5);
			// farZ = rmZMetersToFraction(20.0);

			// rmPlaceObjectDefAtLoc(farFishID, 0, farX, farZ);
			// rmPlaceObjectDefAtLoc(farFishID, 0, farX, 1.0 - farZ);
			// rmPlaceObjectDefAtLoc(farFishID, 0, 1.0 - farX, farZ);
			// rmPlaceObjectDefAtLoc(farFishID, 0, 1.0 - farX, 1.0 - farZ);
		} else if(cNonGaiaPlayers < 5) {
			// Middle fish.
			farX = rmXMetersToFraction(17.5);
			farZ = 0.5;
			float farFishDist = rmXMetersToFraction(20.0);

			rmPlaceObjectDefAtLoc(farFishID, 0, farX, farZ - farFishDist);
			rmPlaceObjectDefAtLoc(farFishID, 0, farX, farZ + farFishDist);
			rmPlaceObjectDefAtLoc(farFishID, 0, 1.0 - farX, farZ - farFishDist);
			rmPlaceObjectDefAtLoc(farFishID, 0, 1.0 - farX, farZ + farFishDist);
		} else if(cNonGaiaPlayers < 7) {
			// Middle fish.
			farX = rmXMetersToFraction(17.5);

			rmPlaceObjectDefAtLoc(farFishID, 0, farX, 0.04);
			rmPlaceObjectDefAtLoc(farFishID, 0, farX, 0.35);
			rmPlaceObjectDefAtLoc(farFishID, 0, farX, 0.65);
			rmPlaceObjectDefAtLoc(farFishID, 0, farX, 0.96);
			rmPlaceObjectDefAtLoc(farFishID, 0, 1.0 - farX, 0.04);
			rmPlaceObjectDefAtLoc(farFishID, 0, 1.0 - farX, 0.35);
			rmPlaceObjectDefAtLoc(farFishID, 0, 1.0 - farX, 0.65);
			rmPlaceObjectDefAtLoc(farFishID, 0, 1.0 - farX, 0.96);
		}

	} else {

		// > 2 teams.
		rmSetObjectDefMinDistance(fish1ID, 0.0);
		rmSetObjectDefMaxDistance(fish1ID, rmZFractionToMeters(1.0));

		int fishLandMin = createTerrainDistConstraint("Land", true, 10.0);
		int avoidFish = createTypeDistConstraint("Fish", 18.0);

		rmAddObjectDefConstraint(fish1ID, fishLandMin);
		rmAddObjectDefConstraint(fish1ID, avoidFish);
		rmAddObjectDefConstraint(fish1ID, avoidAll);

		rmPlaceObjectDefAtLoc(fish1ID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	}

	progress(0.9);

	// Embellishment.
	// Temples.
	// int templeID = rmCreateObjectDef("temple");
	// rmAddObjectDefItem(templeID, "Temple", 1, 5.0);
	// rmAddObjectDefItem(templeID, "Relic", 1, 15.0);
	// setObjectDefDistanceToMax(templeID);
	// rmAddObjectDefConstraint(templeID, avoidAll);
	// rmAddObjectDefConstraint(templeID, avoidEdge);
	// rmAddObjectDefConstraint(templeID, farAvoidImpassableLand);
	// rmAddObjectDefConstraint(templeID, avoidSettlement);
	// rmAddObjectDefConstraint(templeID, createClassDistConstraint(classStartingSettlement, 80.0));
	// rmAddObjectDefConstraint(templeID, avoidRelic);
	// rmPlaceObjectDefAtLoc(templeID, 0, 0.5, 0.5, 2 * cNonGaiaPlayers);

	// Bushes.
	int bush1ID = rmCreateObjectDef("bush 1");
	rmAddObjectDefItem(bush1ID, "Bush", 4, 4.0);
	setObjectDefDistanceToMax(bush1ID);
	rmAddObjectDefConstraint(bush1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush1ID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush1ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	int bush2ID = rmCreateObjectDef("bush 2");
	rmAddObjectDefItem(bush2ID, "Bush", 3, 2.0);
	rmAddObjectDefItem(bush2ID, "Rock Sandstone Sprite", 1, 2.0);
	setObjectDefDistanceToMax(bush2ID);
	rmAddObjectDefConstraint(bush2ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bush2ID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(bush2ID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	// Rocks.
	int rockID = rmCreateObjectDef("rock sprite");
	rmAddObjectDefItem(rockID, "Rock Sandstone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rockID);
	rmAddObjectDefConstraint(rockID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockID, farAvoidImpassableLand);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	// Drifts.
	int driftID = rmCreateObjectDef("drift");
	rmAddObjectDefItem(driftID, "Sand Drift Patch", 1, 0.0);
	setObjectDefDistanceToMax(driftID);
	rmAddObjectDefConstraint(driftID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(driftID, avoidEdge);
	rmAddObjectDefConstraint(driftID, farAvoidImpassableLand);
	rmAddObjectDefConstraint(driftID, avoidBuildings);
	rmAddObjectDefConstraint(driftID, createTypeDistConstraint("Sand Drift Patch", 25.0));
	rmPlaceObjectDefAtLoc(driftID, 0, 0.5, 0.5, 5 * cNonGaiaPlayers);

	// Shore decoration.
	int riverBushID = rmCreateObjectDef("river bush");
	rmAddObjectDefItem(riverBushID, "Grass", rmRandInt(3, 7), 4.0);
	rmAddObjectDefItem(riverBushID, "Bush", rmRandInt(2, 5), 4.0);
	setObjectDefDistanceToMax(riverBushID);
	rmAddObjectDefConstraint(riverBushID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(riverBushID, shortAvoidImpassableLand);
	rmAddObjectDefConstraint(riverBushID, createTerrainMaxDistConstraint("Water", true, 10.0));
	rmPlaceObjectDefAtLoc(riverBushID, 0, 0.5, 0.5, 15 * cNonGaiaPlayers);

	// Seaweed.
	int seaweedShoreMin = createTerrainDistConstraint("Land", true, 16.0);
	int seaweedShoreMax = createTerrainMaxDistConstraint("Land", true, 30.0);

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
	rmPlaceObjectDefAtLoc(seaweed2ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);

	// Water.
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
