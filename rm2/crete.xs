/* Crete
** Created by Howard Snable
** Initial design by Keen_Flame
** Adjusted and balanced by Hagrit
** Version 1.00.
*/

// VBP 5.0

include "rmx 5-0-0.xs";

void main(void)
{
	// Text
	rmSetStatusText("",0.01);

	// RM X Setup.
	rmxInit("Crete (by Howard Snable, Hagrit & Flame)", false, false, false);

	// Set size.
	int mapSizeMultiplier = 1;
	int playerTiles=11000;
	if(cMapSize == 1)
	{
		playerTiles = 15000;
		rmEchoInfo("Large map");
	}if(cMapSize == 2)
	{
		playerTiles = 24000;
		mapSizeMultiplier = 2;
	}

	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles)+50;
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	// Set up default water.
	rmSetSeaLevel(0.0);
	float waterType=rmRandFloat(0, 1);
	if(waterType<0.4)
		rmSetSeaType("Mediterranean Sea");
	else
		rmSetSeaType("Aegean Sea");

	// Init map.
	rmTerrainInitialize("water");

	// Define some classes.
	int classPlayer			= rmDefineClass("player");
	int classIsland			= rmDefineClass("island");
	int classKnossos		= rmDefineClass("knossos");
	int classLand			= rmDefineClass("land");
	int classBonusHuntable	= rmDefineClass("bonus huntable");
	rmDefineClass("starting settlement");

	/// Constaints
	int shortAvoidSettlement = rmCreateTypeDistanceConstraint ("objects avoid TC by short distance", "AbstractSettlement", 20.0);
	int tinyAvoidSettlement	 = rmCreateTypeDistanceConstraint ("objects avoid TC by tiny distance", "AbstractSettlement", 10.0);
	int farAvoidSettlement	 = rmCreateTypeDistanceConstraint ("objects avoid TC by long distance", "AbstractSettlement", 50.0);
	int avoidTower			 = rmCreateTypeDistanceConstraint ("towers avoid towers", "tower", 20.0);
	int shortavoidTower		 = rmCreateTypeDistanceConstraint ("stuff avoid towers", "tower", 7.0);
	int avoidGold			 = rmCreateTypeDistanceConstraint ("avoid gold", "gold", 45.0);
	int shortAvoidGold		 = rmCreateTypeDistanceConstraint ("short avoid gold", "gold", 10.0);
	int avoidHerdable		 = rmCreateTypeDistanceConstraint ("avoid herdable", "herdable", 25.0);
	int avoidFood			 = rmCreateTypeDistanceConstraint ("avoid food", "food", 6.0);
	int avoidPredator		 = rmCreateTypeDistanceConstraint ("avoid predator", "animalPredator", 20.0);
	int avoidBuildings		 = rmCreateTypeDistanceConstraint ("avoid buildings", "Building", 15.0);
	int fishVsFishID		 = rmCreateTypeDistanceConstraint ("fish v fish", "fish", 21.0);

	int shortplayerConstraint		= rmCreateClassDistanceConstraint	 ("avoid players a bit", classPlayer, 5.0);
	int playerConstraint			= rmCreateClassDistanceConstraint	 ("avoid players", classPlayer, 45);
	int farPlayerConstraint			= rmCreateClassDistanceConstraint	 ("avoid players far", classPlayer, 90);
	int farStartingSettleConstraint	= rmCreateClassDistanceConstraint	 ("objects avoid player TCs", rmClassID("starting settlement"), 50.0);
	int avoidBonusHuntable			= rmCreateClassDistanceConstraint	 ("avoid bonus huntable", classBonusHuntable, 25.0);
	int landConstraint				= rmCreateClassDistanceConstraint	 ("avoid land", classLand, 5.0);

	int edgeConstraint	= rmCreateBoxConstraint	("edge of map", rmXTilesToFraction(22), rmZTilesToFraction(22), 1.0-rmXTilesToFraction(22), 1.0-rmZTilesToFraction(22), 0.01);

	int avoidWater					= rmCreateTerrainDistanceConstraint	 ("away from shore", "water", true, 23.0);
	int shortavoidWater				= rmCreateTerrainDistanceConstraint ("short away from shore", "water", true, 16.0);
	int avoidImpassableLand			= rmCreateTerrainDistanceConstraint	 ("avoid impassable land", "land", false, 10.0);
	int shortAvoidImpassableLand	= rmCreateTerrainDistanceConstraint	 ("short avoid impassable land", "land", false, 5.0);
	int fishLand 					= rmCreateTerrainDistanceConstraint ("fish land", "land", true, 6.0);

	int nearShore	= rmCreateTerrainMaxDistanceConstraint("near shore", "water", true, 6.0);



	int fishMaxLand = rmCreateTerrainMaxDistanceConstraint("fish max land", "land", true, 14.0);


	int centerID=rmCreateArea("center");
	int KnossosID=rmCreateArea("Knossos", centerID);
	int knossosConstraint	=rmCreateAreaDistanceConstraint("stay away from Knossos", KnossosID, 15.0);
	int islandConstraint	=rmCreateAreaDistanceConstraint("stay away from islands", classIsland, 20.0);

	// -------------Define objects
	// Close Objects



	int startingSettlementID	=rmCreateObjectDef("Starting settlement");
	rmAddObjectDefItem			(startingSettlementID, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass		(startingSettlementID, rmClassID("starting settlement"));
	rmAddObjectDefConstraint	(startingSettlementID, avoidWater);
	rmSetObjectDefMinDistance	(startingSettlementID, 0.0);
	rmSetObjectDefMaxDistance	(startingSettlementID, 0.0);

	int startingTowerID			=rmCreateObjectDef("Starting tower");
	rmAddObjectDefItem			(startingTowerID, "tower", 1, 0.0);
	rmSetObjectDefMinDistance	(startingTowerID, 22.0);
	rmSetObjectDefMaxDistance	(startingTowerID, 26.0);
	rmAddObjectDefConstraint	(startingTowerID, avoidTower);
	rmAddObjectDefConstraint	(startingTowerID, avoidImpassableLand);

	int startingGoldID			=rmCreateObjectDef("Starting gold");
	rmAddObjectDefItem			(startingGoldID, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance	(startingGoldID, 20.0);
	rmSetObjectDefMaxDistance	(startingGoldID, 24.0);
	rmAddObjectDefConstraint	(startingGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint	(startingGoldID, landConstraint);
	rmAddObjectDefConstraint	(startingGoldID, shortAvoidGold);

	int closePigsID				=rmCreateObjectDef("close Pigs");
	rmAddObjectDefItem			(closePigsID, "Pig", rmRandInt(2,3), 4.0);
	rmSetObjectDefMinDistance	(closePigsID, 25.0);
	rmSetObjectDefMaxDistance	(closePigsID, 30.0);
	rmAddObjectDefConstraint	(closePigsID, avoidImpassableLand);
	rmAddObjectDefConstraint	(closePigsID, avoidFood);

	int closeBerriesID			=rmCreateObjectDef("close berries");
	if(rmRandFloat(0,1)<0.5)
		rmAddObjectDefItem		(closeBerriesID, "berry bush", rmRandInt(6,9), 4.0);
	else
		rmAddObjectDefItem		(closeBerriesID, "chicken", rmRandInt(9,12), 4.0);
	rmSetObjectDefMinDistance	(closeBerriesID, 21.0);
	rmSetObjectDefMaxDistance	(closeBerriesID, 28.0);
	rmAddObjectDefConstraint	(closeBerriesID, avoidImpassableLand);
	rmAddObjectDefConstraint	(closeBerriesID, avoidFood);
	rmAddObjectDefConstraint	(closeBerriesID, shortAvoidGold);

	int numHuntable=rmRandInt(6, 10);
	int startingHuntID			=rmCreateObjectDef("starting deer");
	rmAddObjectDefItem			(startingHuntID, "deer", numHuntable, 4.0);
	rmSetObjectDefMinDistance	(startingHuntID, 23.0);
	rmSetObjectDefMaxDistance	(startingHuntID, 28.0);
	rmAddObjectDefConstraint	(startingHuntID, avoidImpassableLand);
	rmAddObjectDefConstraint	(startingHuntID, avoidFood);
	rmAddObjectDefConstraint	(startingHuntID, shortAvoidGold);
	rmAddObjectDefConstraint	(startingHuntID, tinyAvoidSettlement);
	rmAddObjectDefConstraint	(startingHuntID, knossosConstraint);

	int closeBoarID				=rmCreateObjectDef("close Boar");
	rmAddObjectDefItem			(closeBoarID, "boar", 1,  0.0);
	rmSetObjectDefMinDistance	(closeBoarID, 25.0);
	rmSetObjectDefMaxDistance	(closeBoarID, 32.0);
	rmAddObjectDefConstraint	(closeBoarID, avoidImpassableLand);

	int stragglerTreeID			=rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem			(stragglerTreeID, "palm", 1, 0.0);
	rmSetObjectDefMinDistance	(stragglerTreeID, 12.0);
	rmSetObjectDefMaxDistance	(stragglerTreeID, 15.0);


	int playerFishID			=rmCreateObjectDef("owned fish");
	rmAddObjectDefItem			(playerFishID, "fish - salmon", 3, 8.0);
	rmSetObjectDefMinDistance	(playerFishID, 0.0);
	rmSetObjectDefMaxDistance	(playerFishID, 60.0+(cNumberNonGaiaPlayers*3));
	rmAddObjectDefConstraint	(playerFishID, fishVsFishID);
	rmAddObjectDefConstraint	(playerFishID, fishLand);
	rmAddObjectDefConstraint	(playerFishID, fishMaxLand);
	rmAddObjectDefConstraint	(playerFishID, edgeConstraint);
	rmAddObjectDefConstraint	(playerFishID, islandConstraint);

	// Medium Objects
	rmSetStatusText("",0.10);

	int mediumGoldID			=rmCreateObjectDef("medium gold");
	rmAddObjectDefItem			(mediumGoldID, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance	(mediumGoldID, 50.0);
	rmSetObjectDefMaxDistance	(mediumGoldID, 65.0);
	rmAddObjectDefConstraint	(mediumGoldID, avoidGold);
	rmAddObjectDefConstraint	(mediumGoldID, shortAvoidSettlement);
	rmAddObjectDefConstraint	(mediumGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint	(mediumGoldID, shortplayerConstraint);
	rmAddObjectDefConstraint	(mediumGoldID, avoidWater);
	rmAddObjectDefConstraint	(mediumGoldID, knossosConstraint);

	int middleberries			=rmCreateObjectDef("middle berries");
	rmAddObjectDefItem			(middleberries, "Berry Bush", rmRandInt(4,8), 3.0);
	rmSetObjectDefMinDistance	(middleberries, 50);
	rmSetObjectDefMaxDistance	(middleberries, 70);
	rmAddObjectDefToClass		(middleberries, classBonusHuntable);
	rmAddObjectDefConstraint	(middleberries, avoidImpassableLand);
	rmAddObjectDefConstraint	(middleberries, shortAvoidGold);
	rmAddObjectDefConstraint	(middleberries, tinyAvoidSettlement);
	rmAddObjectDefConstraint	(middleberries, knossosConstraint);

	// Far Objects

	int farGoldID				=rmCreateObjectDef("far gold");
	rmAddObjectDefItem			(farGoldID, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance	(farGoldID, 75.0);
	rmSetObjectDefMaxDistance	(farGoldID, 100.0);
	rmAddObjectDefConstraint	(farGoldID, avoidGold);
	rmAddObjectDefConstraint	(farGoldID, avoidImpassableLand);
	rmAddObjectDefConstraint	(farGoldID, shortAvoidSettlement);
	rmAddObjectDefConstraint	(farGoldID, farStartingSettleConstraint);
	rmAddObjectDefConstraint	(farGoldID, knossosConstraint);

	int farPigID				=rmCreateObjectDef("far Pigs");
	rmAddObjectDefItem			(farPigID, "Pig", rmRandInt(2,3), 2.0);
	rmSetObjectDefMinDistance	(farPigID, 70.0);
	rmSetObjectDefMaxDistance	(farPigID, 100.0);
	rmAddObjectDefConstraint	(farPigID, farStartingSettleConstraint);
	rmAddObjectDefConstraint	(farPigID, avoidImpassableLand);
	rmAddObjectDefConstraint	(farPigID, avoidHerdable);

	int farPig2ID				=rmCreateObjectDef("far Pigs2");
	rmAddObjectDefItem			(farPig2ID, "Pig", 2, 2.0);
	rmSetObjectDefMinDistance	(farPig2ID, 100.0);
	rmSetObjectDefMaxDistance	(farPig2ID, 150.0);
	rmAddObjectDefConstraint	(farPig2ID, farPlayerConstraint);
	rmAddObjectDefConstraint	(farPig2ID, avoidImpassableLand);
	rmAddObjectDefConstraint	(farPig2ID, avoidHerdable);

	int farPredatorID			=rmCreateObjectDef("far predator");
	rmAddObjectDefItem			(farPredatorID, "bear", rmRandInt(1, 2), 2.0);
	rmSetObjectDefMinDistance	(farPredatorID, 50.0);
	rmSetObjectDefMaxDistance	(farPredatorID, 100.0);
	rmAddObjectDefConstraint	(farPredatorID, avoidPredator);
	rmAddObjectDefConstraint	(farPredatorID, farStartingSettleConstraint);
	rmAddObjectDefConstraint	(farPredatorID, avoidImpassableLand);
	rmAddObjectDefConstraint	(farPredatorID, avoidFood);
	rmAddObjectDefConstraint	(farPredatorID, knossosConstraint);

	int bonusHuntableID			=rmCreateObjectDef("bonus huntable");
	float bonusChance=rmRandFloat(0,1);
	if(bonusChance>0.3)
		rmAddObjectDefItem		(bonusHuntableID, "deer", rmRandInt(5,9), 4.0);
	else
		rmAddObjectDefItem		(bonusHuntableID, "boar", rmRandInt(3,4), 4.0);
	rmSetObjectDefMinDistance	(bonusHuntableID, 45);
	rmSetObjectDefMaxDistance	(bonusHuntableID, 60);
	rmAddObjectDefConstraint	(bonusHuntableID, avoidBonusHuntable);
	rmAddObjectDefToClass		(bonusHuntableID, classBonusHuntable);
	rmAddObjectDefConstraint	(bonusHuntableID, shortAvoidSettlement);
	rmAddObjectDefConstraint	(bonusHuntableID, avoidImpassableLand);
	rmAddObjectDefConstraint	(bonusHuntableID, shortAvoidGold);
	rmAddObjectDefConstraint	(bonusHuntableID, shortplayerConstraint);
	rmAddObjectDefConstraint	(bonusHuntableID, knossosConstraint);

	int farAurochID				=rmCreateObjectDef("far aurochs");
	rmAddObjectDefItem			(farAurochID, "aurochs", rmRandInt(2, 3), 3.0);
	rmSetObjectDefMinDistance	(farAurochID, 100.0);
	rmSetObjectDefMaxDistance	(farAurochID, 150.0+cNumberNonGaiaPlayers);
	rmAddObjectDefToClass		(farAurochID, classBonusHuntable);
	rmAddObjectDefConstraint	(farAurochID, shortAvoidSettlement);
	rmAddObjectDefConstraint	(farAurochID, avoidBonusHuntable);
	rmAddObjectDefConstraint	(farAurochID, avoidImpassableLand);
	rmAddObjectDefConstraint	(farAurochID, farPlayerConstraint);
	rmAddObjectDefConstraint	(farAurochID, avoidFood);
	rmAddObjectDefConstraint	(farAurochID, knossosConstraint);

	int randomTreeID			=rmCreateObjectDef("random tree");
	rmAddObjectDefItem			(randomTreeID, "palm", 1, 0.0);
	rmSetObjectDefMinDistance	(randomTreeID, 0.0);
	rmSetObjectDefMaxDistance	(randomTreeID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(randomTreeID, rmCreateTypeDistanceConstraint("random tree", "all", 4.0));
	rmAddObjectDefConstraint	(randomTreeID, avoidBuildings);
	rmAddObjectDefConstraint	(randomTreeID, avoidImpassableLand);

	int farhawkID				=rmCreateObjectDef("far hawks");
	rmAddObjectDefItem			(farhawkID, "hawk", 1, 0.0);
	rmSetObjectDefMinDistance	(farhawkID, 0.0);
	rmSetObjectDefMaxDistance	(farhawkID, rmXFractionToMeters(0.5));

	int relicID					=rmCreateObjectDef("relic");
	rmAddObjectDefItem			(relicID, "relic", 1, 0.0);
	rmSetObjectDefMinDistance	(relicID, 0.0);
	rmSetObjectDefMaxDistance	(relicID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(relicID, rmCreateTypeDistanceConstraint("relic vs relic", "relic", 50.0));
	rmAddObjectDefConstraint	(relicID, farStartingSettleConstraint);
	rmAddObjectDefConstraint	(relicID, shortAvoidImpassableLand);

	//giant
	if (cMapSize == 2) {
	int IDGiantGold				=rmCreateObjectDef("giant gold");
	rmAddObjectDefItem			(IDGiantGold, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance	(IDGiantGold, 120.0);
	rmSetObjectDefMaxDistance	(IDGiantGold, 160.0);
	rmAddObjectDefConstraint	(IDGiantGold, avoidGold);
	rmAddObjectDefConstraint	(IDGiantGold, avoidImpassableLand);
	rmAddObjectDefConstraint	(IDGiantGold, shortAvoidSettlement);
	rmAddObjectDefConstraint	(IDGiantGold, farStartingSettleConstraint);
	rmAddObjectDefConstraint	(IDGiantGold, knossosConstraint);

	int IDGiantAuroch			=rmCreateObjectDef("giant aurochs");
	rmAddObjectDefItem			(IDGiantAuroch, "aurochs", rmRandInt(2, 3), 3.0);
	rmSetObjectDefMinDistance	(IDGiantAuroch, 120.0);
	rmSetObjectDefMaxDistance	(IDGiantAuroch, 200.0);
	rmAddObjectDefToClass		(IDGiantAuroch, classBonusHuntable);
	rmAddObjectDefConstraint	(IDGiantAuroch, shortAvoidSettlement);
	rmAddObjectDefConstraint	(IDGiantAuroch, avoidBonusHuntable);
	rmAddObjectDefConstraint	(IDGiantAuroch, avoidImpassableLand);
	rmAddObjectDefConstraint	(IDGiantAuroch, farPlayerConstraint);
	rmAddObjectDefConstraint	(IDGiantAuroch, avoidFood);
	rmAddObjectDefConstraint	(IDGiantAuroch, knossosConstraint);

	int IDGiantRelic			=rmCreateObjectDef("giant relic");
	rmAddObjectDefItem			(IDGiantRelic, "relic", 1, 0.0);
	rmSetObjectDefMinDistance	(IDGiantRelic, 0.0);
	rmSetObjectDefMaxDistance	(IDGiantRelic, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDGiantRelic, rmCreateTypeDistanceConstraint("relic vs relic2", "relic", 50.0));
	rmAddObjectDefConstraint	(IDGiantRelic, farStartingSettleConstraint);
	rmAddObjectDefConstraint	(IDGiantRelic, shortAvoidImpassableLand);

	int IDGiantPig				=rmCreateObjectDef("giant Pigs");
	rmAddObjectDefItem			(IDGiantPig, "Pig", rmRandInt(2,3), 2.0);
	rmSetObjectDefMinDistance	(IDGiantPig, 100.0);
	rmSetObjectDefMaxDistance	(IDGiantPig, 200.0);
	rmAddObjectDefConstraint	(IDGiantPig, farStartingSettleConstraint);
	rmAddObjectDefConstraint	(IDGiantPig, avoidImpassableLand);
	rmAddObjectDefConstraint	(IDGiantPig, avoidHerdable);
	}

	// -------------Done defining objects

	//placing players
	//Different Island spawns
	int spawnType=rmRandInt(1,4);
	float distsave=0.0;
	if (cNumberPlayers<4)
		distsave=0.10;
	if (cNumberPlayers<6)
		distsave=0.03;
	if (cNumberPlayers>7)
		distsave=-0.05;
	rmSetPlacementTeam(0);
	if(spawnType==1)
		rmPlacePlayersLine(0.8-distsave/2, 0.28+distsave, 0.8-distsave/2, 0.55-distsave,0.1,0.3);
	else if (spawnType==2)
		rmPlacePlayersLine(0.8-distsave/2, 0.72-distsave, 0.8-distsave/2, 0.45+distsave,0.1,0.3);
	else if (spawnType==3)
		rmPlacePlayersLine( 0.72-distsave,0.8-distsave/2, 0.45+distsave, 0.8-distsave/2,0.1,0.3);
	else if (spawnType==4)
		rmPlacePlayersLine( 0.28+distsave,0.8-distsave/2, 0.55-distsave, 0.8-distsave/2,0.1,0.3);
	/*
	rmSetPlacementSection(0.25,0.38);
	rmPlacePlayersCircular(radius, radius+0.02, 0.1);
	*/
	rmSetPlacementTeam(1);
	if(spawnType==1)
		rmPlacePlayersLine(0.2+distsave/2, 0.28+distsave, 0.2+distsave/2,0.55-distsave,0.1,0.3);
	else if (spawnType==2)
		rmPlacePlayersLine(0.2+distsave/2, 0.72-distsave, 0.2+distsave/2, 0.45+distsave,0.1,0.3);
	else if (spawnType==3)
		rmPlacePlayersLine(0.72-distsave, 0.2+distsave/2, 0.45+distsave, 0.2+distsave/2,0.1,0.3);
	else if (spawnType==4)
		rmPlacePlayersLine(0.28+distsave, 0.2+distsave/2, 0.55-distsave, 0.2+distsave/2,0.1,0.3);
		
	if(cNumberTeams > 2) {
		rmSetPlacementTeam(-1);
		rmPlacePlayersCircular(0.125);
	}

	// Set up player areas.
	float playerFraction=rmAreaTilesToFraction(1600);
	for(i=1; <cNumberPlayers)
	{
		// Create the area.
		int IDPlayerArea		=rmCreateArea("Player"+i);
		rmSetPlayerArea			(i, IDPlayerArea);
		rmSetAreaSize			(IDPlayerArea, 0.9*playerFraction, 1.1*playerFraction);
		rmAddAreaToClass		(IDPlayerArea, classPlayer);
		rmSetAreaWarnFailure	(IDPlayerArea, false);
		rmSetAreaMinBlobs		(IDPlayerArea, 1);
		rmSetAreaMaxBlobs		(IDPlayerArea, 20);
		rmSetAreaBaseHeight		(IDPlayerArea, 2.0);
		rmSetAreaSmoothDistance	(IDPlayerArea, 30);
		rmSetAreaHeightBlend	(IDPlayerArea, 2);
		rmSetAreaMinBlobDistance(IDPlayerArea, 10.0);
		rmSetAreaMaxBlobDistance(IDPlayerArea, 20.0);
		rmSetAreaCoherence		(IDPlayerArea, 1);
		rmAddAreaConstraint		(IDPlayerArea, shortplayerConstraint);
		rmSetAreaLocPlayer		(IDPlayerArea, i);
		rmSetAreaTerrainType	(IDPlayerArea, "GrassDirt75");
		rmAddAreaTerrainLayer	(IDPlayerArea, "GrassDirt50", 6, 12);
		rmAddAreaTerrainLayer	(IDPlayerArea, "GrassDirt25", 0, 6);
	}

	// Text
	rmSetStatusText("",0.20);




	// Grow an bananashaped island.

	//refPoint
	int BananaAreaID		=rmCreateArea("Banana Center");
	rmSetAreaSize			(BananaAreaID, 0.01, 0.01 );
	if (spawnType==1)
		rmSetAreaLocation(BananaAreaID, 0.5, 0.1);
	else if (spawnType==2)
		rmSetAreaLocation(BananaAreaID, 0.5, 0.9);
	else if (spawnType==3)
		rmSetAreaLocation(BananaAreaID, 0.9, 0.5);
	else if (spawnType==4)
		rmSetAreaLocation(BananaAreaID, 0.1, 0.5);
	int BananaConstr1=rmCreateAreaDistanceConstraint("stay away from center Point", BananaAreaID, rmXFractionToMeters(0.15));
	rmAddAreaConstraint(centerID, BananaConstr1);
	rmAddAreaConstraint(centerID, rmCreateAreaMaxDistanceConstraint("stay close to center Point", BananaAreaID, rmXFractionToMeters(0.62)));
	rmBuildArea(BananaAreaID);

	rmSetAreaSize(centerID, 0.46, 0.46);
	//rmSetAreaLocation(centerID, 0.5, 0.5);
	rmSetAreaCoherence(centerID, 0.5);
	rmSetAreaBaseHeight(centerID, 2.0);
	rmSetAreaTerrainType(centerID, "GrassA");
	rmSetAreaSmoothDistance(centerID, 30);
	rmSetAreaHeightBlend(centerID, 2);
	rmAddAreaConstraint(centerID, rmCreateBoxConstraint("center-edge", 0.08, 0.08, 0.92, 0.92 , 0.01));
	rmBuildArea(centerID);

	 /// Knossos
	if (rmRandFloat(0,1)>0.6)
	{
		int centerConstraint=rmCreateBoxConstraint("centeralasas-edge", 0.45, 0.45, 0.55, 0.55, 0.01);
		rmAddAreaConstraint(KnossosID, farPlayerConstraint);
		rmSetAreaSize(KnossosID, rmAreaTilesToFraction(100*mapSizeMultiplier),rmAreaTilesToFraction(140*mapSizeMultiplier));
		rmSetAreaCoherence(KnossosID, 0.2);
		rmSetAreaTerrainType(KnossosID, "citytileA");
		rmAddAreaConstraint(KnossosID, avoidImpassableLand);
		rmAddAreaConstraint(KnossosID, centerConstraint);
		rmBuildArea(KnossosID);

		int knossosRuinsID=rmCreateObjectDef("ruinsK");
		rmAddObjectDefItem( knossosRuinsID,"ruins", 1, 1.0);
		rmPlaceObjectDefInArea(knossosRuinsID, 0, KnossosID, rmRandInt(4*mapSizeMultiplier,7*mapSizeMultiplier));

		int knossosRelicID=rmCreateObjectDef("RelicK");
		rmAddObjectDefItem(knossosRelicID,"Relic", 1, 1.0);
		rmPlaceObjectDefInArea(knossosRelicID, 0, KnossosID, rmRandInt(1*mapSizeMultiplier,2*mapSizeMultiplier));
		if (rmRandFloat(0,1)<0.2)
		{
			int knossosSiegeID=rmCreateObjectDef("siegeK");
			rmAddObjectDefItem(knossosSiegeID,"Broken Siege Weapons", 1*mapSizeMultiplier, 2.0);
			rmPlaceObjectDefInArea(knossosSiegeID, 0, KnossosID, 1);
		}
		if (rmRandFloat(0,1)<0.3)
		{
			int knossosTorchID=rmCreateObjectDef("torchK");
			rmAddObjectDefItem(knossosTorchID,"Torch", 1, 2.0);
			rmPlaceObjectDefInArea(knossosTorchID, 0, KnossosID, rmRandInt(1*mapSizeMultiplier,2*mapSizeMultiplier));
		}
		if (rmRandFloat(0,1)<0.3)
		{
			int knossosPotsID=rmCreateObjectDef("potsK");
			rmAddObjectDefItem(knossosPotsID,"Pots", rmRandInt(3,5), 3.0);
			rmPlaceObjectDefInArea(knossosPotsID, 0, KnossosID, 1*mapSizeMultiplier);
		}
		if (rmRandFloat(0,1)<0.7)
		{
			int knossosColumsID=rmCreateObjectDef("columsK");
			rmAddObjectDefItem(knossosColumsID,"Columns", 1, 3.0);
			rmPlaceObjectDefInArea(knossosColumsID, 0, KnossosID, rmRandInt(1*mapSizeMultiplier,4*mapSizeMultiplier));
		}
	}
	rmBuildAllAreas();


	for(i=1; <cNumberPlayers*3*mapSizeMultiplier)
	{
		// Beautification sub area.
		int id2=rmCreateArea("Patch"+i);
		rmSetAreaSize(id2, rmAreaTilesToFraction(80*mapSizeMultiplier), rmAreaTilesToFraction(120*mapSizeMultiplier));
		rmSetAreaTerrainType(id2, "GrassDirt75");
		rmAddAreaTerrainLayer(id2, "GrassDirt50", 0, 1);
		rmAddAreaTerrainLayer(id2, "GrassDirt25", 0, 0);
		rmSetAreaWarnFailure(id2, false);
		rmSetAreaMinBlobs(id2, 1);
		rmSetAreaMaxBlobs(id2, 4);
		rmSetAreaMinBlobDistance(id2, 16.0);
		rmSetAreaMaxBlobDistance(id2, 40.0);
		rmSetAreaCoherence(id2, 0.5);
		rmAddAreaConstraint(id2, playerConstraint);
		rmAddAreaConstraint(id2, avoidImpassableLand);
		rmAddAreaConstraint(id2, knossosConstraint);
		rmBuildArea(id2);
	}
	// Text
	rmSetStatusText("",0.40);

	// Place starting settlements.
	// Close things....
	// TC
	rmPlaceObjectDefPerPlayer(startingSettlementID, true);

	// Towers.
	rmPlaceObjectDefPerPlayer(startingTowerID, true, 4);



	int numTries=6*cNumberNonGaiaPlayers*mapSizeMultiplier;
	int failCount=0;

	// Settlements, always forward.

	if (cNumberNonGaiaPlayers>2) {
	int SettleArea=rmAddFairLoc("Settlement", true, false, 60, 90+cNumberNonGaiaPlayers, 40, 40);
	} else
	SettleArea=rmAddFairLoc("Settlement", false, true, 60, 75, 40, 40);
	rmAddFairLocConstraint(SettleArea, avoidImpassableLand);
	rmAddFairLocConstraint(SettleArea, avoidWater);
	rmAddFairLocConstraint(SettleArea, shortplayerConstraint);
	rmAddFairLocConstraint(SettleArea, knossosConstraint);

	if (cNumberNonGaiaPlayers>2) {
	SettleArea=rmAddFairLoc("Settlement", true, false, 90, 130+cNumberNonGaiaPlayers, 80, 40);
	} else
	SettleArea=rmAddFairLoc("Settlement", true, false, 75, 100, 80, 40);
	rmAddFairLocConstraint(SettleArea, avoidImpassableLand);
	rmAddFairLocConstraint(SettleArea, avoidWater);
	rmAddFairLocConstraint(SettleArea, shortplayerConstraint);
	rmAddFairLocConstraint(SettleArea, knossosConstraint);

	if (cMapSize == 2) {
		SettleArea=rmAddFairLoc("Settlement", true, false, 90, 150*mapSizeMultiplier, 80, 40);
		rmAddFairLocConstraint(SettleArea, avoidImpassableLand);
		rmAddFairLocConstraint(SettleArea, avoidWater);
		rmAddFairLocConstraint(SettleArea, shortplayerConstraint);
		rmAddFairLocConstraint(SettleArea, knossosConstraint);
	}

	//Settlements
	if(rmPlaceFairLocs())
	{
		SettleArea=rmCreateObjectDef("far settlement2");
		rmAddObjectDefItem(SettleArea, "Settlement", 1, 0.0);
		for(i=1; <cNumberPlayers)
		{
			for(j=0; <rmGetNumberFairLocs(i))
				rmPlaceObjectDefAtLoc(SettleArea, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
		}
	}


	//Islands
	if(rmRandFloat(0,1)*cNumberPlayers>0) //will always spawn
	{
		//Islands
		int islandShoreConstraint=rmCreateTerrainDistanceConstraint("avoid shore2", "land", true, 35.0);
		int islandBoxConstraint=rmCreateBoxConstraint("center-edge2", 0.03, 0.03, 0.97, 0.97, 0.01);
		int AnzInseln=cNumberPlayers*rmRandFloat(0.25 , 0.7)+2;
		for(i=0; <AnzInseln)
		{
			//place Islands
			int monkeyIslandID=rmCreateArea("monkeyisland"+i);

			rmAddAreaConstraint(monkeyIslandID, islandShoreConstraint);
			rmSetAreaSize(monkeyIslandID, rmAreaTilesToFraction(250*mapSizeMultiplier), rmAreaTilesToFraction(320*mapSizeMultiplier));
			if((rmRandFloat(0, 1)<0.4))
			{
				rmSetAreaTerrainType(monkeyIslandID, "shorelinemediterraneanb");
			}
			else
			{
				rmSetAreaTerrainType(monkeyIslandID, "grassdirt50");
			}
			rmSetAreaBaseHeight(monkeyIslandID, 2.0);
			rmAddAreaToClass(monkeyIslandID, classIsland);
			rmSetAreaSmoothDistance(monkeyIslandID, 5);
			rmSetAreaHeightBlend(monkeyIslandID, 2);
			rmSetAreaCoherence(monkeyIslandID, 1);
			rmSetAreaMaxBlobDistance(monkeyIslandID, 10.0*mapSizeMultiplier);
			rmSetAreaMinBlobDistance(monkeyIslandID, 5.0*mapSizeMultiplier);
			rmAddAreaConstraint(monkeyIslandID, islandBoxConstraint);
			rmAddAreaConstraint(monkeyIslandID, BananaConstr1);

			rmBuildArea(monkeyIslandID);

			int stayOnIsland=rmCreateTerrainDistanceConstraint("stay on island"+i, "water", true, 4.0);
			int strongstayOnIsland=rmCreateTerrainDistanceConstraint("stay a lot on island"+i, "water", true, 6.0);
			int IslandObjectConstraint=rmCreateTypeDistanceConstraint("stay away from island object"+i,"all", 3.0);
			//Gold mine
			if (rmRandFloat(0, 1)<0.7)
			{
				int monkeyGold1ID=rmCreateObjectDef("goldA"+i);
				rmAddObjectDefItem( monkeyGold1ID,"gold mine", 1, 8.0);
				rmAddObjectDefConstraint(monkeyGold1ID, strongstayOnIsland);
				rmAddObjectDefConstraint(monkeyGold1ID, IslandObjectConstraint);
				rmPlaceObjectDefInArea(monkeyGold1ID, 0, monkeyIslandID, 1);
			}
			//Animal
			if (rmRandFloat(0, 1)<0.4)
			{
				int monkeyanimalID=rmCreateObjectDef("monkey"+i);
				if (rmRandFloat(0, 1)<0.2)
				{
					rmAddObjectDefItem(monkeyanimalID, "Crocodile", 1, 2.0);
				}
				else
				{
					rmAddObjectDefItem(monkeyanimalID, "lion", 1, 2.0);
				}
				rmAddObjectDefConstraint(monkeyanimalID, stayOnIsland);
				rmAddObjectDefConstraint(monkeyanimalID, IslandObjectConstraint);
				rmPlaceObjectDefInArea(monkeyanimalID, 0, monkeyIslandID, 1*mapSizeMultiplier);
			}
			//Decoration
			int monkeydecoID=rmCreateObjectDef("monkeydeco"+i);
			float zufallszahl=rmRandFloat(0, 1);
			if (zufallszahl<0.05)
				rmAddObjectDefItem(monkeydecoID, "Fire Wood", 1, 2.0);
			else if (zufallszahl<0.1)
				rmAddObjectDefItem(monkeydecoID, "Campfire", 1, 2.0);
			else if (zufallszahl<0.35)
				rmAddObjectDefItem(monkeydecoID, "Barrel", 1, 2.0);
			else if (zufallszahl<0.4)
				rmAddObjectDefItem(monkeydecoID, "sign", 3, 0.5);
			else if (zufallszahl<0.45)
				rmAddObjectDefItem(monkeydecoID, "crate small", 3, 0.5);
			else if(zufallszahl<0.55)
				rmAddObjectDefItem(monkeydecoID, "Rotting Log", 1, 1);
			rmAddObjectDefConstraint(monkeydecoID, stayOnIsland);
			rmAddObjectDefConstraint(monkeydecoID, IslandObjectConstraint);
			rmPlaceObjectDefInArea(monkeydecoID, 0, monkeyIslandID, 1);

			// Palm.
			int palmsID=rmCreateArea("palms"+i, monkeyIslandID);
			rmSetAreaSize(palmsID, rmAreaTilesToFraction(8*mapSizeMultiplier), rmAreaTilesToFraction(14*mapSizeMultiplier));
			rmSetAreaWarnFailure(palmsID, false);
			rmSetAreaForestType(palmsID, "palm forest");
			rmAddAreaConstraint(palmsID, IslandObjectConstraint);
			rmAddAreaConstraint(palmsID, stayOnIsland);
			rmSetAreaMinBlobs(palmsID, 1);
			rmSetAreaMaxBlobs(palmsID, 5);
			rmSetAreaMinBlobDistance(palmsID, 14.0);
			rmSetAreaCoherence(palmsID, 0.4);
			rmBuildArea(palmsID);
		}

	}

	rmSetStatusText("",0.60);

	/// ELEV
	numTries=5*cNumberNonGaiaPlayers*mapSizeMultiplier;
	failCount=0;
	for(i=0; <numTries)
	{
		int IDelev				=rmCreateArea("elev"+i);
		rmSetAreaSize			(IDelev, rmAreaTilesToFraction(100*mapSizeMultiplier), rmAreaTilesToFraction(200*mapSizeMultiplier));
		rmSetAreaWarnFailure	(IDelev, false);
		rmAddAreaConstraint		(IDelev, avoidWater);
		rmAddAreaConstraint		(IDelev, shortAvoidSettlement);
		rmAddAreaConstraint		(IDelev, knossosConstraint);
		rmSetAreaBaseHeight		(IDelev, rmRandFloat(3.0, 5.0));
		rmSetAreaHeightBlend	(IDelev, 2);
		rmSetAreaMinBlobs		(IDelev, 1);
		rmSetAreaMaxBlobs		(IDelev, 5);
		rmSetAreaMinBlobDistance(IDelev, 16.0);
		rmSetAreaMaxBlobDistance(IDelev, 40.0);
		rmSetAreaCoherence		(IDelev, 0.0);

		if(rmBuildArea(IDelev)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}


	rmPlaceObjectDefPerPlayer(stragglerTreeID, false, rmRandInt(2, 5));

	if ( cNumberNonGaiaPlayers< 3) {
		rmPlaceObjectDefPerPlayer(startingGoldID, false, 2);
	} else {
	rmPlaceObjectDefPerPlayer(startingGoldID, false, 1);
	}

	rmPlaceObjectDefPerPlayer(startingHuntID, false, 1);
	rmPlaceObjectDefPerPlayer(closePigsID, true);
	rmPlaceObjectDefPerPlayer(closeBerriesID, true);
	rmPlaceObjectDefPerPlayer(playerFishID, false, 2);

	// Boar.
	bonusChance=rmRandFloat(0, 1);
	if(bonusChance>0.75)
		rmPlaceObjectDefPerPlayer(closeBoarID, false);

	rmPlaceObjectDefPerPlayer(mediumGoldID, false, 1);
	rmPlaceObjectDefPerPlayer(middleberries, false);

	rmPlaceObjectDefPerPlayer(farGoldID, false, 2);
	rmPlaceObjectDefPerPlayer(relicID, false, 1);
	rmPlaceObjectDefPerPlayer(farhawkID, false, 2);
	rmPlaceObjectDefPerPlayer(bonusHuntableID, false, 1);
	rmPlaceObjectDefPerPlayer(farPigID, false, rmRandInt(2,3));
	rmPlaceObjectDefPerPlayer(farPig2ID, false, 1);
	rmPlaceObjectDefPerPlayer(farPredatorID, false, 1);
	rmPlaceObjectDefPerPlayer(farAurochID, false, 1);

	if (cMapSize == 2) {
		rmPlaceObjectDefPerPlayer(IDGiantAuroch, false, 1);
		rmPlaceObjectDefPerPlayer(IDGiantGold, false, 2);
		rmPlaceObjectDefPerPlayer(IDGiantRelic, false, 1);
		rmPlaceObjectDefPerPlayer(IDGiantPig, false, 2);
	}

	rmSetStatusText("",0.80);
	// Forest.
	int classForest=rmDefineClass("forest");
	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 6.0);
	int forestConstraint=rmCreateClassDistanceConstraint("forest v forest", rmClassID("forest"), 20.0);
	int forestPlayerConstraint=rmCreateClassDistanceConstraint("forest player", rmClassID("starting settlement"), 20.0);
	int count=0;
	numTries=12*cNumberNonGaiaPlayers*mapSizeMultiplier;
	failCount=0;
	for(i=0; <numTries)
	{
		int forestID=rmCreateArea("forest"+i, centerID);
		rmSetAreaSize(forestID, rmAreaTilesToFraction(40*mapSizeMultiplier), rmAreaTilesToFraction(100*mapSizeMultiplier));
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaForestType(forestID, "palm forest");
		rmAddAreaConstraint(forestID, forestPlayerConstraint);
		rmAddAreaConstraint(forestID, tinyAvoidSettlement);
		rmAddAreaConstraint(forestID, forestObjConstraint);
		rmAddAreaConstraint(forestID, forestConstraint);
		rmAddAreaConstraint(forestID, avoidImpassableLand);
		rmAddAreaConstraint(forestID, knossosConstraint);
		rmAddAreaToClass(forestID, classForest);

		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 4);
		rmSetAreaMinBlobDistance(forestID, 10.0);
		rmSetAreaMaxBlobDistance(forestID, 20.0);
		rmSetAreaCoherence(forestID, 0.1);


		if(rmBuildArea(forestID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}
	int farFishLand = rmCreateTerrainDistanceConstraint("far fish land", "land", true, 30.0);
	int farFishConstraint = rmCreateTypeDistanceConstraint("far fish vs fish", "fish", 30.0);
	int farFishAvoidPlayer = rmCreateClassDistanceConstraint("far fish vs player", classPlayer, (90.0+cNumberNonGaiaPlayers));
	int fishID=rmCreateObjectDef("fish");
	rmAddObjectDefItem(fishID, "fish - salmon", 3, 9.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, farFishConstraint);
	rmAddObjectDefConstraint(fishID, farFishLand);
	rmAddObjectDefConstraint(fishID, farFishAvoidPlayer);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*2*mapSizeMultiplier);

	int sharkLand = rmCreateTerrainDistanceConstraint("shark land", "land", true, 20.0);
	int sharkVsShark=rmCreateTypeDistanceConstraint("shark v shark", "shark", 20.0);
	int orcaID=rmCreateObjectDef("shark");
	rmAddObjectDefItem(orcaID, "shark", 1, 0.0);
	rmSetObjectDefMinDistance(orcaID, 0.0);
	rmSetObjectDefMaxDistance(orcaID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(orcaID, sharkLand);
	rmAddObjectDefConstraint(orcaID, sharkVsShark);
	rmAddObjectDefConstraint(orcaID, edgeConstraint);
	rmPlaceObjectDefAtLoc(orcaID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*0.5*mapSizeMultiplier);

	int turtleID=rmCreateObjectDef("turtle");
	rmAddObjectDefItem(turtleID, "hawksbill", 1, 0.0);
	rmSetObjectDefMinDistance(turtleID, 0.0);
	rmSetObjectDefMaxDistance(turtleID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(turtleID, sharkLand);
	rmAddObjectDefConstraint(turtleID, sharkVsShark);
	rmAddObjectDefConstraint(turtleID, edgeConstraint);
	rmPlaceObjectDefAtLoc(turtleID, 0, 0.5, 0.5, cNumberNonGaiaPlayers*0.8*mapSizeMultiplier);


	// Text
	rmSetStatusText("",0.90);

	fishID=rmCreateObjectDef("fish2");
	rmAddObjectDefItem(fishID, "fish - perch", 1, 0.0);
	rmSetObjectDefMinDistance(fishID, 0.0);
	rmSetObjectDefMaxDistance(fishID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(fishID, fishVsFishID);
	/*   rmAddObjectDefConstraint(fishID, fishEdge); */
	rmAddObjectDefConstraint(fishID, fishLand);
	rmAddObjectDefConstraint(fishID, farPlayerConstraint);
	rmPlaceObjectDefAtLoc(fishID, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers*mapSizeMultiplier);

	// Random trees.
	rmPlaceObjectDefAtLoc(randomTreeID, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers*mapSizeMultiplier);

	// Rocks
	int avoidAll=rmCreateTypeDistanceConstraint("avoid all"+i, "all", 3.0);
	int rockID=rmCreateObjectDef("stone");
	rmAddObjectDefItem(rockID, "Rock Limestone Small", 1, 0.0);
	rmSetObjectDefMinDistance(rockID, 0.0);
	rmSetObjectDefMaxDistance(rockID, rmXFractionToMeters(0.5));   //rmAddObjectDefConstraint(rockID, avoidRock);
	rmAddObjectDefConstraint(rockID, avoidAll);
	rmAddObjectDefConstraint(rockID, knossosConstraint);
	rmAddObjectDefConstraint(rockID, avoidImpassableLand);
	rmPlaceObjectDefAtLoc(rockID, 0, 0.5, 0.5, 3*cNumberNonGaiaPlayers*mapSizeMultiplier);
	//Flowers
	int flowerID=rmCreateObjectDef("flowers");
	rmAddObjectDefItem(flowerID, "Flowers", 1, 0.0);
	rmSetObjectDefMinDistance(flowerID, 0.0);
	rmSetObjectDefMaxDistance(flowerID, rmXFractionToMeters(0.5));   //rmAddObjectDefConstraint(rockID, avoidRock);
	rmAddObjectDefConstraint(flowerID, avoidAll);
	rmAddObjectDefConstraint(flowerID, avoidImpassableLand);
	rmAddObjectDefConstraint(flowerID, knossosConstraint);
	rmPlaceObjectDefAtLoc(flowerID, 0, 0.5, 0.5, 6*cNumberNonGaiaPlayers*mapSizeMultiplier);

	if(waterType>=0.3)
	{
		avoidAll=rmCreateTypeDistanceConstraint("avoid all", "all", 6.0);
		int nearshore=rmCreateTerrainMaxDistanceConstraint("seaweed near shore", "land", true, 12.0);
		int farshore = rmCreateTerrainDistanceConstraint("seaweed far from shore", "land", true, 8.0);
		int kelpID=rmCreateObjectDef("seaweed");
		rmAddObjectDefItem(kelpID, "seaweed", 5, 3.0);
		rmSetObjectDefMinDistance(kelpID, 0.0);
		rmSetObjectDefMaxDistance(kelpID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(kelpID, avoidAll);
		rmAddObjectDefConstraint(kelpID, nearshore);
		rmAddObjectDefConstraint(kelpID, farshore);
		rmPlaceObjectDefAtLoc(kelpID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers*mapSizeMultiplier);

		int kelp2ID=rmCreateObjectDef("seaweed 2");
		rmAddObjectDefItem(kelp2ID, "seaweed", 2, 3.0);
		rmSetObjectDefMinDistance(kelp2ID, 0.0);
		rmSetObjectDefMaxDistance(kelp2ID, rmXFractionToMeters(0.5));
		rmAddObjectDefConstraint(kelp2ID, avoidAll);
		rmAddObjectDefConstraint(kelp2ID, nearshore);
		rmAddObjectDefConstraint(kelp2ID, farshore);
		rmPlaceObjectDefAtLoc(kelp2ID, 0, 0.5, 0.5, 4*cNumberNonGaiaPlayers*mapSizeMultiplier);
	}

	// RM X Finalize.
	rmxFinalize();

	// Text
	rmSetStatusText("",1.0);
}