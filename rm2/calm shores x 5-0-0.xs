/*
** CALM SHORES MIRROR
** RebelsRising
** Last edit: 05/05/2021
*/

include "rmx 5-0-0.xs";

void main() {
	progress(0.0);

	// Initial map setup.
	rmxInit("Calm Shores X");

	// Set mirror mode.
	setMirrorMode(cMirrorPoint);

	// Perform mirror check.
	if(mirrorConfigIsInvalid()) {
		injectMirrorGenError();

		// Invalid configuration, quit.
		return;
	}

	// Set size.
	int mapSize = getStandardMapDimInMeters();

	// Initialize map.
	initializeMap("SandB", mapSize);

	// Place players.
	placePlayersInCircle(0.35, 0.35, 0.85);

	// Initialize areas.
	float centerRadius = 22.5;

	int classCenter = initializeCenter(centerRadius);
	int classCorner = initializeCorners(25.0);

	// Define classes.
	int classStartingSettlement = rmDefineClass("starting settlement");

	// Define global constraints.
	// General.
	int avoidAll = createTypeDistConstraint("All", 7.0);
	int avoidEdge = createSymmetricBoxConstraint(rmXTilesToFraction(4), rmZTilesToFraction(4));
	int avoidCenter = createClassDistConstraint(classCenter, 1.0);
	int avoidCorner = createClassDistConstraint(classCorner, 1.0);

	// Terrain.
	int shortAvoidWater = createTerrainDistConstraint("Land", false, 1.0);
	int mediumAvoidWater = createTerrainDistConstraint("Land", false, 5.0);
	int farAvoidWater = createTerrainDistConstraint("Land", false, 15.0);

	// Settlements.
	int avoidStartingSettlement = createClassDistConstraint(classStartingSettlement, 20.0);
	int avoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);
	int goldAvoidSettlement = createTypeDistConstraint("AbstractSettlement", 15.0);

	// Gold.
	int shortAvoidGold = createTypeDistConstraint("Gold", 10.0);
	int farAvoidGold = createTypeDistConstraint("Gold", 35.0);

	// Food.
	int avoidFood = createTypeDistConstraint("Food", 20.0);
	int avoidHuntable = createTypeDistConstraint("Huntable", 40.0);
	int avoidHerdable = createTypeDistConstraint("Herdable", 30.0);
	int avoidPredator = createTypeDistConstraint("AnimalPredator", 30.0);

	// Relics.
	int avoidRelic = createTypeDistConstraint("Relic", 80.0);

	// Buildings.
	int avoidTowerLOS = createTypeDistConstraint("Tower", 35.0);
	int farAvoidTower = createTypeDistConstraint("Tower", 25.0);
	int shortAvoidTower = createTypeDistConstraint("Tower", 15.0);

	// Embellishment.
	int embellishmentAvoidAll = createTypeDistConstraint("All", 3.0);

	// Simple objects.
	// Starting settlement.
	int startingSettlementID = rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem(startingSettlementID, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass(startingSettlementID, classStartingSettlement);

	// Towers.
	int startingTowerID = rmCreateObjectDef("starting tower");
	rmAddObjectDefItem(startingTowerID, "Tower", 1, 0.0);
	rmAddObjectDefConstraint(startingTowerID, avoidAll);
	rmAddObjectDefConstraint(startingTowerID, farAvoidWater);
	rmAddObjectDefConstraint(startingTowerID, farAvoidTower);

	int startingTowerBackupID = rmCreateObjectDef("starting tower backup");
	rmAddObjectDefItem(startingTowerBackupID, "Tower", 1, 0.0);
	rmAddObjectDefConstraint(startingTowerBackupID, avoidAll);
	rmAddObjectDefConstraint(startingTowerBackupID, farAvoidWater);
	rmAddObjectDefConstraint(startingTowerBackupID, shortAvoidTower);

	// Close hunt.
	int closeHuntID = rmCreateObjectDef("close hunt");
	rmAddObjectDefItem(closeHuntID, "Deer", rmRandInt(6, 7), 2.0);
	rmAddObjectDefConstraint(closeHuntID, avoidAll);
	rmAddObjectDefConstraint(closeHuntID, avoidEdge);
	rmAddObjectDefConstraint(closeHuntID, shortAvoidGold);
	rmAddObjectDefConstraint(closeHuntID, avoidFood);
	rmAddObjectDefConstraint(closeHuntID, mediumAvoidWater);

	// Starting food.
	int startingFoodID = rmCreateObjectDef("starting food");
	rmAddObjectDefItem(startingFoodID, "Berry Bush", rmRandInt(6, 9), 2.0);
	rmAddObjectDefConstraint(startingFoodID, avoidAll);
	rmAddObjectDefConstraint(startingFoodID, avoidEdge);
	rmAddObjectDefConstraint(startingFoodID, shortAvoidGold);
	rmAddObjectDefConstraint(startingFoodID, avoidFood);

	// Starting herdables.
	int startingHerdablesID = rmCreateObjectDef("starting herdables");
	rmAddObjectDefItem(startingHerdablesID, "Goat", rmRandInt(2, 4), 2.0);
	rmAddObjectDefConstraint(startingHerdablesID, avoidAll);
	rmAddObjectDefConstraint(startingHerdablesID, avoidEdge);

	// Straggler trees 1.
	int stragglerTree1ID = rmCreateObjectDef("straggler tree 1");
	rmAddObjectDefItem(stragglerTree1ID, "Oak Tree", 1, 0.0);
	rmAddObjectDefConstraint(stragglerTree1ID, avoidAll);

	// Straggler trees 2.
	int stragglerTree2ID = rmCreateObjectDef("straggler tree 2");
	rmAddObjectDefItem(stragglerTree2ID, "Pine", 1, 0.0);
	rmAddObjectDefConstraint(stragglerTree2ID, avoidAll);

	// Gold.
	// Medium gold.
	int mediumGoldID = rmCreateObjectDef("medium gold");
	rmAddObjectDefItem(mediumGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(mediumGoldID, avoidAll);
	rmAddObjectDefConstraint(mediumGoldID, avoidEdge);
	rmAddObjectDefConstraint(mediumGoldID, avoidCorner);
	rmAddObjectDefConstraint(mediumGoldID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumGoldID, goldAvoidSettlement);
	rmAddObjectDefConstraint(mediumGoldID, farAvoidGold);
	rmAddObjectDefConstraint(mediumGoldID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumGoldID, mediumAvoidWater);

	// Bonus gold.
	int bonusGoldID = rmCreateObjectDef("bonus gold");
	rmAddObjectDefItem(bonusGoldID, "Gold Mine", 1, 0.0);
	rmAddObjectDefConstraint(bonusGoldID, avoidAll);
	rmAddObjectDefConstraint(bonusGoldID, avoidEdge);
	rmAddObjectDefConstraint(bonusGoldID, avoidCorner);
	rmAddObjectDefConstraint(bonusGoldID, avoidCenter);
	rmAddObjectDefConstraint(bonusGoldID, createClassDistConstraint(classStartingSettlement, 65.0));
	rmAddObjectDefConstraint(bonusGoldID, goldAvoidSettlement);
	rmAddObjectDefConstraint(bonusGoldID, farAvoidGold);
	rmAddObjectDefConstraint(bonusGoldID, mediumAvoidWater);

	// Food.
	// Medium herdables.
	int mediumHerdablesID = rmCreateObjectDef("medium herdables");
	rmAddObjectDefItem(mediumHerdablesID, "Goat", 2, 4.0);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidAll);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidCenter);
	rmAddObjectDefConstraint(mediumHerdablesID, createClassDistConstraint(classStartingSettlement, 50.0));
	rmAddObjectDefConstraint(mediumHerdablesID, avoidHerdable);
	rmAddObjectDefConstraint(mediumHerdablesID, avoidTowerLOS);
	rmAddObjectDefConstraint(mediumHerdablesID, mediumAvoidWater);

	// Far herdables.
	int farHerdablesID = rmCreateObjectDef("far herdables");
	rmAddObjectDefItem(farHerdablesID, "Goat", 2, 4.0);
	rmAddObjectDefConstraint(farHerdablesID, avoidAll);
	rmAddObjectDefConstraint(farHerdablesID, avoidEdge);
	rmAddObjectDefConstraint(farHerdablesID, avoidCenter);
	rmAddObjectDefConstraint(farHerdablesID, createClassDistConstraint(classStartingSettlement, 60.0));
	rmAddObjectDefConstraint(farHerdablesID, avoidHerdable);
	rmAddObjectDefConstraint(farHerdablesID, mediumAvoidWater);

	// Far predators.
	int farPredatorsID = rmCreateObjectDef("far predators");
	rmAddObjectDefItem(farPredatorsID, "Lion", 1, 0.0);
	rmAddObjectDefConstraint(farPredatorsID, avoidAll);
	rmAddObjectDefConstraint(farPredatorsID, avoidEdge);
	rmAddObjectDefConstraint(farPredatorsID, avoidCenter);
	rmAddObjectDefConstraint(farPredatorsID, createClassDistConstraint(classStartingSettlement, 60.0));
	rmAddObjectDefConstraint(farPredatorsID, avoidPredator);
	rmAddObjectDefConstraint(farPredatorsID, createTerrainDistConstraint("Land", false, 25.0));

	// Far berries 1.
	int farBerries1ID = rmCreateObjectDef("far berries 1");
	rmAddObjectDefItem(farBerries1ID, "Berry Bush", rmRandInt(4, 7), 2.0);
	rmAddObjectDefConstraint(farBerries1ID, avoidAll);
	rmAddObjectDefConstraint(farBerries1ID, avoidEdge);
	rmAddObjectDefConstraint(farBerries1ID, avoidCenter);
	rmAddObjectDefConstraint(farBerries1ID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerries1ID, avoidFood);
	rmAddObjectDefConstraint(farBerries1ID, avoidSettlement);
	rmAddObjectDefConstraint(farBerries1ID, farAvoidWater);
	rmAddObjectDefConstraint(farBerries1ID, avoidTowerLOS);

	// Far berries 2.
	int farBerries2ID = rmCreateObjectDef("far berries 2");
	rmAddObjectDefItem(farBerries2ID, "Berry Bush", rmRandInt(5, 8), 2.0);
	rmAddObjectDefConstraint(farBerries2ID, avoidAll);
	rmAddObjectDefConstraint(farBerries2ID, avoidEdge);
	rmAddObjectDefConstraint(farBerries2ID, avoidCenter);
	rmAddObjectDefConstraint(farBerries2ID, shortAvoidGold);
	rmAddObjectDefConstraint(farBerries2ID, avoidFood);
	rmAddObjectDefConstraint(farBerries2ID, avoidSettlement);
	rmAddObjectDefConstraint(farBerries2ID, farAvoidWater);
	rmAddObjectDefConstraint(farBerries2ID, avoidTowerLOS);

	// Other objects.
	// Random trees.
	int randomTreeID = rmCreateObjectDef("random tree");
	rmAddObjectDefItem(randomTreeID, "Oak Tree", 1, 0.0);
	setObjectDefDistanceToMax(randomTreeID);
	rmAddObjectDefConstraint(randomTreeID, avoidAll);
	rmAddObjectDefConstraint(randomTreeID, avoidStartingSettlement);
	rmAddObjectDefConstraint(randomTreeID, avoidSettlement);
	rmAddObjectDefConstraint(randomTreeID, mediumAvoidWater);

	// Relics.
	int relicID = rmCreateObjectDef("relic");
	rmAddObjectDefItem(relicID, "Relic", 1, 0.0);
	rmAddObjectDefConstraint(relicID, avoidAll);
	rmAddObjectDefConstraint(relicID, avoidEdge);
	rmAddObjectDefConstraint(relicID, createClassDistConstraint(classStartingSettlement, 80.0));
	rmAddObjectDefConstraint(relicID, avoidRelic);
	rmAddObjectDefConstraint(relicID, mediumAvoidWater);

	progress(0.1);

	float lakeSize = 0.12;
	float borderSize = 0.0225;
	float borderDistScaling = 1.0;
	float radius = 0.2; // For fish placement.

	if(cNonGaiaPlayers > 2) {
		lakeSize = 0.065;
		borderSize = 0.0125;
		borderDistScaling = 0.75;
		radius = 0.15;
	}

	// 1. Create big lakes on sides.
	// This is extremely tricky because XS areas try to reach a certain fraction of the map (= rmSetAreaSize).
	// Due to this, they behave differently when being placed in corners compared to sides. Don't change this value.
	placeLocationsBetweenTeams(0.6);

	for(i = 1; <= cTeams) {
		int lakeID = rmCreateArea("lake " + i);
		rmSetAreaLocation(lakeID, getLocX(i), getLocZ(i));
		rmSetAreaSize(lakeID, lakeSize);
		rmSetAreaWaterType(lakeID, "Red Sea");
		rmSetAreaCoherence(lakeID, 1.0);
		rmSetAreaBaseHeight(lakeID, 0.0);
		rmSetAreaHeightBlend(lakeID, 2);
		rmSetAreaWarnFailure(lakeID, false);
	}

	rmBuildAllAreas();

	// Water and fish placement.
	// 2. Calculate start and end angle of the lakes.

	float locX = getLocX(1);
	float locZ = getLocZ(1);

	// Start with random angle.
	float endAngle = randRadian();
	float tempX = -1.0;
	float tempZ = -1.0;

	// Pick any angle and decrement it until it's valid.
	// Then, increment it until it gets invalid. That way, we find the end angle of the lake.
	// We could also calculate the angle between teams instead of doing this first step.
	while(isLocValid(tempX, tempZ) == false) {
		endAngle = endAngle - 0.005;
		tempX = getXFromPolar(radius, endAngle, locX);
		tempZ = getZFromPolar(radius, endAngle, locZ);
	}

	while(isLocValid(tempX, tempZ) == true) {
		endAngle = endAngle - 0.005;
		tempX = getXFromPolar(radius, endAngle, locX);
		tempZ = getZFromPolar(radius, endAngle, locZ);
	}

	float startAngle = endAngle;

	// Set temp to something valid for next while loop.
	tempX = 0.5;
	tempZ = 0.5;

	// To find the start angle, increment the end angle (go backward) until it's invalid.
	while(isLocValid(tempX, tempZ) == true) {
		startAngle = startAngle + 0.005;
		tempX = getXFromPolar(radius, startAngle, locX);
		tempZ = getZFromPolar(radius, startAngle, locZ);
	}

	// 3. Place TCs.
	placeObjectAtPlayerLocs(startingSettlementID, true);

	// 4. Create fancy borders so the lake looks nicer.
	int lakeAvoidBuildings = createTypeDistConstraint("Building", 30.0);
	int numAreas = 5 + 5 * cNonGaiaPlayers / 2;

	for(i = 0; < cTeams) {
		for(j = 0; < numAreas) {
			int borderID = rmCreateArea("border " + i + " " + j);
			rmSetAreaSize(borderID, borderSize);
			rmSetAreaWaterType(borderID, "Red Sea");
			rmSetAreaCoherence(borderID, 1.0);
			rmSetAreaBaseHeight(borderID, 0.0);
			rmSetAreaHeightBlend(borderID, 2);
			rmAddAreaConstraint(borderID, lakeAvoidBuildings);
			rmSetAreaWarnFailure(borderID, false);
		}
	}

	// 5. Place towers after water embellishment so they don't get deleted.
	// This will overwrite location storage but we don't need the previously generated areas anymore.
	placeAndStoreObjectMirrored(startingTowerID, true, 4, 23.0, 27.0, true, -1, startingTowerBackupID);

	// Step between the individual border areas.
	float diff = (startAngle - endAngle) / (numAreas - 1);
	float currAngle = 0.0;

	// 6. Place the border areas with a random radius from the loaded lake location (locX/locZ) for variation.
	for(i = 0; < numAreas) {
		currAngle = startAngle - diff * i;
		tempX = fitToMap(getXFromPolar(rmRandFloat(0.175, 0.25) * borderDistScaling, currAngle, locX));
		tempZ = fitToMap(getZFromPolar(rmRandFloat(0.175, 0.25) * borderDistScaling, currAngle, locZ));
		rmSetAreaLocation(rmAreaID("border " + 0 + " " + i), tempX, tempZ);
		rmSetAreaLocation(rmAreaID("border " + 1 + " " + i), 1.0 - tempX, 1.0 - tempZ);
	}

	rmBuildAllAreas();

	progress(0.2);

	// 7. Fish.
	int numFish = 3 + cNonGaiaPlayers / 2;

	int fishID = rmCreateObjectDef("close fish");
	rmAddObjectDefItem(fishID, "Fish - Mahi", 3, 4.0);

	float offset = rmRandFloat(0.12, 0.13) * PI;

	float adjustedStartAngle = startAngle - offset;
	float adjustedEndAngle = endAngle + offset;

	// Calculate difference and iterate over positions.
	diff = (adjustedStartAngle - adjustedEndAngle) / (numFish - 1);

	for(i = 0; < numFish) {
		currAngle = adjustedStartAngle - diff * i;
		tempX = getXFromPolar(radius, currAngle, locX);
		tempZ = getZFromPolar(radius, currAngle, locZ);
		placeObjectForPlayer(fishID, 0, tempX, tempZ);
		placeObjectForPlayer(fishID, 0, 1.0 - tempX, 1.0 - tempZ);
	}

	if(cNonGaiaPlayers > 2) {

		// Second iteration with smaller radius.
		radius = 0.1;
		offset = -0.25;

		adjustedStartAngle = startAngle - offset;
		adjustedEndAngle = endAngle + offset;

		// Calculate difference and iterate over positions.
		diff = (adjustedStartAngle - adjustedEndAngle) / (numFish - 1);

		for(i = 0; < numFish) {
			currAngle = adjustedStartAngle - diff * i;
			tempX = getXFromPolar(radius, currAngle, locX);
			tempZ = getZFromPolar(radius, currAngle, locZ);
			placeObjectForPlayer(fishID, 0, tempX, tempZ);
			placeObjectForPlayer(fishID, 0, 1.0 - tempX, 1.0 - tempZ);
		}
	}

	progress(0.3);

	// 8. Rebuild center.
	int layerSize = rmRandInt(5, 8) * cNonGaiaPlayers / 2;

	if(cNonGaiaPlayers > 5) {
		layerSize = rmRandInt(8, 10) * cNonGaiaPlayers / 3;
	}

	int beautificationID = rmCreateArea("rebuild terrain");
	rmSetAreaSize(beautificationID, 1.0);
	rmSetAreaTerrainType(beautificationID, "GrassB");
	rmAddAreaTerrainLayer(beautificationID, "GrassDirt75", 0, layerSize);
	rmAddAreaTerrainLayer(beautificationID, "GrassDirt50", layerSize, 2 * layerSize);
	rmAddAreaTerrainLayer(beautificationID, "GrassDirt25", 2 * layerSize, 3 * layerSize);
	rmAddAreaTerrainLayer(beautificationID, "GrassA", 3 * layerSize);
	rmAddAreaConstraint(beautificationID, farAvoidWater);
	rmSetAreaWarnFailure(beautificationID, false);
	rmBuildArea(beautificationID);

	// 9. Create center lake (without fish) if > 5 players.
	if(cNonGaiaPlayers > 5) {
		initAreaClass();
		setAreaWaterType("Red Sea", 16.0, 5.0);
		setAreaParams(0.0, 2);

		// Center Area.
		setAreaBlobs(20);
		setAreaCoherence(0.5, 0.5);
		setAreaSearchRadius(5.0, 5.0); // Set tiny search radius so it gets placed at the center.
		setAreaRequiredRatio(1.0);

		buildAreas(1, 0.0);
	}

	// 10. Embellishment.
	int forceSandNearWater = createTerrainMaxDistConstraint("Water", true, 30.0);

	for(i = 0; < 20 * cNonGaiaPlayers) {
		beautificationID = rmCreateArea("beautification 1 " + i);
		rmSetAreaTerrainType(beautificationID, "GrassDirt50");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(10), rmAreaTilesToFraction(50));
		rmAddAreaConstraint(beautificationID, farAvoidWater);
		rmAddAreaConstraint(beautificationID, avoidTowerLOS);
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	for(i = 0; < 20 * cNonGaiaPlayers) {
		beautificationID = rmCreateArea("beautification 2 " + i);
		rmSetAreaTerrainType(beautificationID, "GrassDirt75");
		rmSetAreaSize(beautificationID, rmAreaTilesToFraction(30), rmAreaTilesToFraction(80));
		rmAddAreaConstraint(beautificationID, forceSandNearWater);
		rmAddAreaConstraint(beautificationID, shortAvoidWater);
		rmSetAreaMinBlobs(beautificationID, 1);
		rmSetAreaMaxBlobs(beautificationID, 5);
		rmSetAreaMinBlobDistance(beautificationID, 16.0);
		rmSetAreaMaxBlobDistance(beautificationID, 40.0);
		rmSetAreaWarnFailure(beautificationID, false);
		rmBuildArea(beautificationID);
	}

	progress(0.4);

	// Settlements.
	int settlementID = rmCreateObjectDef("settlements");
	rmAddObjectDefItem(settlementID, "Settlement", 1, 0.0);

	float tcDist = 70.0;
	int settlementAvoidCenter = createClassDistConstraint(classCenter, 10.0 + 0.5 * (tcDist - 2.0 * centerRadius));

	// Close settlement.
	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(farAvoidWater);

	addFairLoc(55.0, 75.0, false, true, 65.0, 12.0, 12.0);

	// Far settlement.
	addFairLocConstraint(avoidTowerLOS);
	addFairLocConstraint(settlementAvoidCenter);
	addFairLocConstraint(farAvoidWater);

	if(cNonGaiaPlayers == 2) {
		if(randChance(0.8)) {
			addFairLoc(60.0, 90.0, true, true, 65.0, 60.0, 60.0);
		} else {
			addFairLoc(60.0, 90.0, false, false, 65.0, 12.0, 12.0);
		}
	} else {
		addFairLoc(60.0, 90.0, true, true, 75.0, 60.0, 60.0);
	}

	placeObjectAtNewFairLocs(settlementID, false, "settlements");

	progress(0.5);

	// Forests.
	initForestClass();

	// Add some margin for forests in the center because it's extremely dense anyway.
	addForestConstraint(createClassDistConstraint(classCenter, 2.5));
	addForestConstraint(avoidStartingSettlement);
	addForestConstraint(avoidAll);
	addForestConstraint(mediumAvoidWater);

	addForestType("Mixed Oak Forest", 0.7);
	addForestType("Oak Forest", 0.3);

	setForestAvoidSelf(20.0);

	setForestBlobs(9);
	setForestBlobParams(4.875, 4.25);
	setForestCoherence(-0.75, 0.75);

	// Player forest.
	setForestSearchRadius(30.0, 40.0);
	setForestMinRatio(2.0 / 3.0);

	int numPlayerForests = 3;

	buildPlayerForests(numPlayerForests, 0.1);

	progress(0.6);

	int numCenterForests = 0;

	if(cNonGaiaPlayers == 2) {
		numCenterForests = 2;

		// Center forest for 1v1.
		setForestSearchRadius(35.0, 35.0);

		buildForests(numCenterForests);
	}

	// Regular forest.
	setForestSearchRadius(40.0, -1.0);
	setForestMinRatio(2.0 / 3.0);

	int numForests = (9 - numCenterForests) * cNonGaiaPlayers / 2;

	buildForests(numForests, 0.2);

	progress(0.8);

	// Object placement.
	// Starting gold close to tower.
	storeObjectDefItem("Gold Mine Small", 1, 0.0);
	storeObjectConstraint(createTypeDistConstraint("Tower", rmRandFloat(8.0, 10.0))); // Don't get too close.
	storeObjectConstraint(avoidAll);
	storeObjectConstraint(avoidEdge);
	storeObjectConstraint(farAvoidWater);
	placeStoredObjectMirroredNearStoredLocs(4, false, 24.0, 25.0, 12.5);

	resetObjectStorage();

	// Medium gold.
	placeObjectMirrored(mediumGoldID, false, 1, 50.0, 65.0);

	// Far gold.
	placeFarObjectMirrored(bonusGoldID, false, rmRandInt(2, 3));

	// Close hunt.
	placeObjectMirrored(closeHuntID, false, 1, 25.0, 30.0, true);

	// Starting food.
	placeObjectMirrored(startingFoodID, false, 1, 22.0, 26.0);

	// Berries.
	placeFarObjectMirrored(farBerries1ID, false, 1, 50.0);
	placeFarObjectMirrored(farBerries2ID, false, 1, 35.0);

	// Straggler trees.
	placeObjectMirrored(stragglerTree1ID, false, rmRandInt(1, 3), 13.0, 13.5, true);
	placeObjectMirrored(stragglerTree2ID, false, rmRandInt(1, 3), 13.0, 13.5, true);

	// Medium herdables.
	placeObjectMirrored(mediumHerdablesID, false, rmRandInt(1, 2), 55.0, 75.0);

	// Far herdables.
	placeFarObjectMirrored(farHerdablesID, false, rmRandInt(1, 3));

	// Starting herdables.
	placeObjectMirrored(startingHerdablesID, true, 1, 20.0, 30.0);

	// Far predators.
	placeFarObjectMirrored(farPredatorsID, false, 2);

	progress(0.9);

	// Center object.
	if(cNonGaiaPlayers < 5) {
		// Center forest.
		int centerForestID = rmCreateArea("center forest");
		rmSetAreaForestType(centerForestID, "Oak Forest");
		rmSetAreaSize(centerForestID, areaRadiusMetersToFraction(rmRandFloat(2.0, 4.0)));
		rmSetAreaLocation(centerForestID, 0.5, 0.5);
		rmSetAreaCoherence(centerForestID, 1.0);
		rmBuildArea(centerForestID);
	}

	// Relics (non mirrored).
	placeObjectInPlayerSplits(relicID);

	// Random trees.
	placeObjectAtPlayerLocs(randomTreeID, false, 10);

	// Embellishment.
	// Grass.
	int grassID = rmCreateObjectDef("grass");
	rmAddObjectDefItem(grassID, "Grass", 3, 4.0);
	setObjectDefDistanceToMax(grassID);
	rmAddObjectDefConstraint(grassID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(grassID, farAvoidWater);
	rmAddObjectDefConstraint(grassID, createTypeDistConstraint("Grass", 12.0));
	rmPlaceObjectDefAtLoc(grassID, 0, 0.5, 0.5, 50 * cNonGaiaPlayers);

	// Bush.
	int bushID = rmCreateObjectDef("bush");
	rmAddObjectDefItem(bushID, "Bush", 1, 0.0);
	setObjectDefDistanceToMax(bushID);
	rmAddObjectDefConstraint(bushID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(bushID, farAvoidWater);
	rmAddObjectDefConstraint(bushID, avoidStartingSettlement);
	rmPlaceObjectDefAtLoc(bushID, 0, 0.5, 0.5, 25 * cNonGaiaPlayers);
	
	// Rock.
	int rockID = rmCreateObjectDef("rock");
	rmAddObjectDefItem(rockID, "Rock Sandstone Sprite", 1, 0.0);
	setObjectDefDistanceToMax(rockID);
	rmAddObjectDefConstraint(rockID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(rockID, createTerrainMaxDistConstraint("Water", true, 17.5));
	rmAddObjectDefConstraint(rockID, mediumAvoidWater);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 20 * cNonGaiaPlayers);

	// Lone fish.
	if(cNonGaiaPlayers > 2 && cNonGaiaPlayers < 7) {
		// Only place this for 4 and 6 players.
		int loneFishID = rmCreateObjectDef("lone fish");
		rmAddObjectDefItem(loneFishID, "Fish - Mahi", 1, 0.0);
		setObjectDefDistance(loneFishID, rmXFractionToMeters(0.0), rmXFractionToMeters(0.3));
		rmAddObjectDefConstraint(loneFishID, createTerrainDistConstraint("Land", true, 20.0));
		rmAddObjectDefConstraint(loneFishID, createTypeDistConstraint("Fish", 20.0));
		rmPlaceObjectDefAtLoc(loneFishID, 0, locX, locZ);
		rmPlaceObjectDefAtLoc(loneFishID, 0, 1.0 - locX, 1.0 - locZ);
	}

	// Seaweed.
	int seaweedShoreMin = createTerrainDistConstraint("Land", true, 10.0);
	int seaweedShoreMax = createTerrainMaxDistConstraint("Land", true, 14.0);

	int seaweed1ID = rmCreateObjectDef("seaweed 1");
	rmAddObjectDefItem(seaweed1ID, "Seaweed", rmRandInt(4, 7), 7.0);
	setObjectDefDistanceToMax(seaweed1ID);
	rmAddObjectDefConstraint(seaweed1ID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(seaweed1ID, seaweedShoreMin);
	rmAddObjectDefConstraint(seaweed1ID, seaweedShoreMax);
	rmPlaceObjectDefAtLoc(seaweed1ID, 0, 0.5, 0.5, 6 * cNonGaiaPlayers);

	if(cNonGaiaPlayers == 2) {
		int seaweed2ID = rmCreateObjectDef("seaweed 2");
		rmAddObjectDefItem(seaweed2ID, "Seaweed", rmRandInt(3, 5), 3.0);
		setObjectDefDistanceToMax(seaweed2ID);
		rmAddObjectDefConstraint(seaweed2ID, embellishmentAvoidAll);
		rmAddObjectDefConstraint(seaweed2ID, seaweedShoreMin);
		rmAddObjectDefConstraint(seaweed2ID, seaweedShoreMax);
		rmPlaceObjectDefAtLoc(seaweed2ID, 0, 0.5, 0.5, 10 * cNonGaiaPlayers);
	}

	// Whales.
	int whaleID = rmCreateObjectDef("whale");
	rmAddObjectDefItem(whaleID, "Whale", 1, 3.0);
	setObjectDefDistance(whaleID, rmXFractionToMeters(0.25), rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(whaleID, embellishmentAvoidAll);
	rmAddObjectDefConstraint(whaleID, avoidEdge);
	rmAddObjectDefConstraint(whaleID, createTypeDistConstraint("Whale", 40.0));
	rmAddObjectDefConstraint(whaleID, createTerrainDistConstraint("Land", true, 20.0));
	rmPlaceObjectDefAtLoc(whaleID, 0, 0.5, 0.5, 4);

	// Birds.
	int birdsID = rmCreateObjectDef("birds");
	rmAddObjectDefItem(birdsID, "Hawk", 1, 0.0);
	setObjectDefDistanceToMax(birdsID);
	rmPlaceObjectDefAtLoc(birdsID, 0, 0.5, 0.5, 2 * cNonGaiaPlayers);

	// Finalize RM X.
	rmxFinalize();

	progress(1.0);
}
