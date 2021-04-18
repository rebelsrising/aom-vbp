/* Sheltered Pass
** Created by Hagrit
** And Coda
** Initial design by Keen_Flame
** Version 1.00.
*/

// VBP 5.0

include "rmx 5-0-0.xs";

void SetUpMap(int small = 5000, int big = 10000,int giant = 20000, float seaLevel = 0, string tileName = "GrassA")
{
	int PlayerTiles = small;
	if (cMapSize == 1)
		PlayerTiles = big;

	if (cMapSize == 2)
		PlayerTiles = giant;

	int Size = sqrt(cNumberNonGaiaPlayers * PlayerTiles / 0.9)*2;
	rmSetMapSize(Size,Size);
	rmSetSeaLevel(seaLevel);
	rmTerrainInitialize(tileName, 2);
}

void main()
{
	// RM X Setup.
	rmxInit("Sheltered Pass (by Hagrit & Flame)", false, false, false);

	// Set up the map..
	SetUpMap(8000,10200,20400,0,"CliffA");
	rmSetLightingSet("Default");
	rmSetGaiaCiv(cCivZeus);

	int mapSizeMultiplier = 1;

	if (cMapSize == 2) {
		mapSizeMultiplier = 2;
	}

	rmSetStatusText("",0.09);

	// Define classes..
	int classPlayer      = rmDefineClass("player");
	int classSettlements = rmDefineClass("starting settlement");
	int classPassage	 = rmDefineClass("passage");
	int classCenterCliff = rmDefineClass("cliff");
	int classElev		 = rmDefineClass("slight elevation");
	int classFarGold 	 = rmDefineClass("gold");
	int classForest		 = rmDefineClass("forest");
	int classWrinkle	 = rmDefineClass("wrinkle");
	int classGiraffe	 = rmDefineClass("Giraffe");

	rmSetStatusText("",0.15);

	//Constraints
	int AvoidPlayer 				= rmCreateClassDistanceConstraint	("0", classPlayer, rmRandInt(25.0*mapSizeMultiplier, 35.0*mapSizeMultiplier));
	int AvoidPlayerShort 		 	= rmCreateClassDistanceConstraint	("1", classPlayer, 1.0);
	int AvoidPlayerMed	 		 	= rmCreateClassDistanceConstraint	("2", classPlayer, 6.0);
	int AvoidEdgeShort				= rmCreateBoxConstraint			 	("3", rmXTilesToFraction(4), rmZTilesToFraction(4), 1.0-rmXTilesToFraction(4), 1.0-rmZTilesToFraction(4));
	int AvoidEdgeMed				= rmCreateBoxConstraint			 	("4", rmXTilesToFraction(12), rmZTilesToFraction(12), 1.0-rmXTilesToFraction(12), 1.0-rmZTilesToFraction(12));
	int AvoidEdgeLong				= rmCreateBoxConstraint			 	("5", rmXTilesToFraction(30), rmZTilesToFraction(30), 1.0-rmXTilesToFraction(30), 1.0-rmZTilesToFraction(30));
	int AvoidCenterCliff			= rmCreateClassDistanceConstraint	("6", classCenterCliff, 20.0);
	int AvoidCenterCliffLong		= rmCreateClassDistanceConstraint	("1234", classCenterCliff, 50.0);
	int AvoidCenterCliffShort		= rmCreateClassDistanceConstraint	("7", classCenterCliff, 14.0);
	int AvoidPassage				= rmCreateClassDistanceConstraint	("8", classPassage, 20.0);
	int AvoidOtherTower				= rmCreateTypeDistanceConstraint 	("9", "tower", 26.0);
	int AvoidLion					= rmCreateTypeDistanceConstraint 	("10", "lion", 60.0);
	int AvoidElev					= rmCreateClassDistanceConstraint	("11", classElev, 3.0);
	int AvoidGoldFar				= rmCreateTypeDistanceConstraint 	("12", "gold", 40.0);
	int AvoidFoodMed				= rmCreateTypeDistanceConstraint 	("13", "food", 30.0);
	int AvoidFoodShort				= rmCreateTypeDistanceConstraint 	("14", "food", 20.0);
	int AvoidGoat					= rmCreateTypeDistanceConstraint 	("15", "goat", 35.0+cNumberNonGaiaPlayers);
	int AvoidBerry					= rmCreateTypeDistanceConstraint 	("16", "berry bush", 55.0);
	int AvoidForestMedium			= rmCreateClassDistanceConstraint	("17", classForest, 35.0);
	int AvoidAll					= rmCreateTypeDistanceConstraint 	("18", "all", 5.0);
	int AvoidStartingSettlement		= rmCreateTypeDistanceConstraint 	("19", "Settlement Level 1", 70.0);
	int AvoidWrinkle				= rmCreateClassDistanceConstraint	("20", classWrinkle, 15.0);
	int AvoidImpassableLand			= rmCreateTerrainDistanceConstraint	("21", "land", false, 8.0);
	int AvoidGiraffe				= rmCreateClassDistanceConstraint	("23", classGiraffe, 25.0*mapSizeMultiplier);

	int AvoidSettlementSlightly 	= rmCreateTypeDistanceConstraint 	("25", "AbstractSettlement", 10.0);
	int AvoidSettlementSomewhat 	= rmCreateTypeDistanceConstraint 	("26", "AbstractSettlement", 32.0);
	int AvoidSettlementHOLYFUCK 	= rmCreateTypeDistanceConstraint 	("27", "AbstractSettlement", 50.0);
	rmSetStatusText("",0.24);

	///Objects

	//Starting stuff
	int IDStartingSettlement  = rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem        (IDStartingSettlement, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass     (IDStartingSettlement, rmClassID("starting settlement"));
	rmSetObjectDefMinDistance (IDStartingSettlement, 0.0);
	rmSetObjectDefMaxDistance (IDStartingSettlement, 0.0);

	int IDStartingTower 	  = rmCreateObjectDef("starting towers");
	rmAddObjectDefItem        (IDStartingTower, "tower", 1, 0.0);
	rmAddObjectDefConstraint  (IDStartingTower, AvoidOtherTower);
	rmSetObjectDefMinDistance (IDStartingTower, 25.0);
	rmSetObjectDefMaxDistance (IDStartingTower, 28.0);

	int IDStartingGold		  = rmCreateObjectDef("starting goldmine");
	rmAddObjectDefItem        (IDStartingGold, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance (IDStartingGold, 21.0);
	rmSetObjectDefMaxDistance (IDStartingGold, 24.0);

	int IDStartingBerry 	  = rmCreateObjectDef("starting berry");
	rmAddObjectDefItem        (IDStartingBerry, "berry bush", rmRandInt(3.0, 5.0), 4);
	rmSetObjectDefMinDistance (IDStartingBerry, 20.0);
	rmSetObjectDefMaxDistance (IDStartingBerry, 24.0);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidAll);

	int IDStartingChicken 	  = rmCreateObjectDef("starting chicken");
	rmAddObjectDefItem        (IDStartingChicken, "chicken", rmRandInt(4.0, 6.0), 4);
	rmSetObjectDefMinDistance (IDStartingChicken, 22.0);
	rmSetObjectDefMaxDistance (IDStartingChicken, 26.0);
	rmAddObjectDefConstraint  (IDStartingChicken, AvoidAll);

	int IDStartingGoat	 	  = rmCreateObjectDef("starting goats");
	rmAddObjectDefItem        (IDStartingGoat, "goat", rmRandInt(1.0, 4.0), 4);
	rmSetObjectDefMinDistance (IDStartingGoat, 24.0);
	rmSetObjectDefMaxDistance (IDStartingGoat, 28.0);
	rmAddObjectDefConstraint  (IDStartingGoat, AvoidAll);

	int IDStartingHunt	 	  = rmCreateObjectDef("starting hunt");
	float startingHuntable=rmRandFloat(0, 1);
	if(startingHuntable<0.1)
	{
		rmAddObjectDefItem        (IDStartingHunt, "Giraffe", 1, 3);
		rmAddObjectDefItem        (IDStartingHunt, "Zebra", rmRandInt(1.0, 2.0), 3);
	}
	else if(startingHuntable<0.2)
		rmAddObjectDefItem        (IDStartingHunt, "Giraffe", rmRandInt(1.0, 3.0), 4);
	else if(startingHuntable<0.6)
		rmAddObjectDefItem        (IDStartingHunt, "Elephant", 1, 0);
	else if(startingHuntable<0.8)
		rmAddObjectDefItem        (IDStartingHunt, "rhinocerous", rmRandInt(1.0, 2.0), 3);
	else if(startingHuntable<1.0)
		rmAddObjectDefItem        (IDStartingHunt, "Gazelle", rmRandInt(2.0, 4.0), 4);
	rmSetObjectDefMinDistance (IDStartingHunt, 23.0);
	rmSetObjectDefMaxDistance (IDStartingHunt, 28.0);
	rmAddObjectDefConstraint  (IDStartingHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingHunt, AvoidAll);


	rmSetStatusText("",0.31);

	// Medium stuff
	int IDMedBerry			  = rmCreateObjectDef("medium berry");
	rmAddObjectDefItem		  (IDMedBerry, "berry bush", rmRandInt(4.0, 7.0), 4);
	rmSetObjectDefMinDistance (IDMedBerry, 50.0);
	rmSetObjectDefMaxDistance (IDMedBerry, 70.0);
	rmAddObjectDefConstraint  (IDMedBerry, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDMedBerry, AvoidCenterCliff);
	rmAddObjectDefConstraint  (IDMedBerry, AvoidBerry);
	rmAddObjectDefConstraint  (IDMedBerry, AvoidSettlementSomewhat);

	int IDMedGoldmine		  = rmCreateObjectDef("medium goldmine");
	rmAddObjectDefItem		  (IDMedGoldmine, "Gold mine", 1, 0);
	rmSetObjectDefMinDistance (IDMedGoldmine, 50.0);
	rmSetObjectDefMaxDistance (IDMedGoldmine, 70.0);
	rmAddObjectDefConstraint  (IDMedGoldmine, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDMedGoldmine, AvoidCenterCliff);
	rmAddObjectDefConstraint  (IDMedGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDMedGoldmine, AvoidSettlementSomewhat);

	int IDMedGiraffe		  = rmCreateObjectDef("medium giraffe");
	rmAddObjectDefItem		  (IDMedGiraffe, "giraffe", rmRandInt(5.0, 6.0), 4);
	rmSetObjectDefMinDistance (IDMedGiraffe, 65.0);
	rmSetObjectDefMaxDistance (IDMedGiraffe, 80.0);
	rmAddObjectDefConstraint  (IDMedGiraffe, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDMedGiraffe, AvoidCenterCliff);
	rmAddObjectDefConstraint  (IDMedGiraffe, AvoidFoodMed);
	rmAddObjectDefConstraint  (IDMedGiraffe, AvoidSettlementSomewhat);

	rmSetStatusText("",0.37);
	// Far stuff

	int IDFarBerry			  = rmCreateObjectDef("far berry");
	rmAddObjectDefItem		  (IDFarBerry, "berry bush", rmRandInt(4.0, 7.0), 4);
	rmSetObjectDefMinDistance (IDFarBerry, 70.0);
	rmSetObjectDefMaxDistance (IDFarBerry, 110.0);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidCenterCliff);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidBerry);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidAll);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidSettlementSomewhat);

	int IDFarRhino			  = rmCreateObjectDef("far rhino");
	rmAddObjectDefItem		  (IDFarRhino, "rhinocerous", rmRandInt(2.0, 4.0), 4);
	rmSetObjectDefMinDistance (IDFarRhino, 80.0);
	rmSetObjectDefMaxDistance (IDFarRhino, 110.0);
	rmAddObjectDefConstraint  (IDFarRhino, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarRhino, AvoidCenterCliff);
	rmAddObjectDefConstraint  (IDFarRhino, AvoidFoodMed);
	rmAddObjectDefConstraint  (IDFarRhino, AvoidSettlementSlightly);

	int IDFarZebra			  = rmCreateObjectDef("far zebra");
	rmAddObjectDefItem		  (IDFarZebra, "zebra", rmRandInt(5.0, 8.0), 4);
	rmSetObjectDefMinDistance (IDFarZebra, 70.0);
	rmSetObjectDefMaxDistance (IDFarZebra, 100.0);
	rmAddObjectDefConstraint  (IDFarZebra, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarZebra, AvoidCenterCliff);
	rmAddObjectDefConstraint  (IDFarZebra, AvoidFoodMed);
	rmAddObjectDefConstraint  (IDFarZebra, AvoidSettlementSomewhat);

	int IDFarGoat			  = rmCreateObjectDef("far goat");
	rmAddObjectDefItem		  (IDFarGoat, "goat", 2, 2);
	rmSetObjectDefMinDistance (IDFarGoat, 70.0);
	rmSetObjectDefMaxDistance (IDFarGoat, 110.0);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidCenterCliff);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidGoat);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidSettlementSomewhat);

	int IDFarLion			  = rmCreateObjectDef("far pred");
	rmAddObjectDefItem		  (IDFarLion, "lion", 2, 2);
	rmSetObjectDefMinDistance (IDFarLion, 80.0);
	rmSetObjectDefMaxDistance (IDFarLion, 160.0);
	rmAddObjectDefConstraint  (IDFarLion, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarLion, AvoidCenterCliff);
	rmAddObjectDefConstraint  (IDFarLion, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDFarLion, AvoidLion);
	rmAddObjectDefConstraint  (IDFarLion, AvoidStartingSettlement);
	rmAddObjectDefConstraint  (IDFarLion, AvoidSettlementSomewhat);

	int IDFarGoldmine		  = rmCreateObjectDef("far goldmine");
	rmAddObjectDefItem		  (IDFarGoldmine, "Gold mine", 1, 0);
	rmSetObjectDefMinDistance (IDFarGoldmine, 65.0);
	rmSetObjectDefMaxDistance (IDFarGoldmine, 90.0+(cNumberNonGaiaPlayers*4));
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidCenterCliff);
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidStartingSettlement);

	int IDStragglerTree		  = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem		  (IDStragglerTree, "palm", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTree, 12.0);
	rmSetObjectDefMaxDistance (IDStragglerTree, 15.0);
	rmAddObjectDefConstraint  (IDStragglerTree, AvoidAll);

	int IDStragglerTrees	  = rmCreateObjectDef("straggler trees");
	rmAddObjectDefItem		  (IDStragglerTrees, "palm", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTrees, 0.0);
	rmSetObjectDefMaxDistance (IDStragglerTrees, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint  (IDStragglerTrees, rmCreateTypeDistanceConstraint("random tree", "all", 10.0));
	rmAddObjectDefConstraint  (IDStragglerTrees, AvoidSettlementSomewhat);

	int IDCenterGoldmine	  = rmCreateObjectDef("center goldmine");
	rmAddObjectDefItem		  (IDCenterGoldmine, "Gold mine", 1, 0);
	rmSetObjectDefMinDistance (IDCenterGoldmine, 0.0);
	rmSetObjectDefMaxDistance (IDCenterGoldmine, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint  (IDCenterGoldmine, AvoidPlayerMed);
	rmAddObjectDefConstraint  (IDCenterGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDCenterGoldmine, AvoidImpassableLand);
	rmAddObjectDefConstraint  (IDCenterGoldmine, AvoidSettlementSomewhat);

	//giant
	if (cMapSize == 2) {
		int IDGiantGold			  = rmCreateObjectDef("giant goldmine");
		rmAddObjectDefItem		  (IDGiantGold, "Gold mine", 1, 0);
		rmSetObjectDefMinDistance (IDGiantGold, 90.0);
		rmSetObjectDefMaxDistance (IDGiantGold, 200.0);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidEdgeMed);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidCenterCliff);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidGoldFar);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidSettlementSomewhat);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidStartingSettlement);

		int IDGiantGoat			  = rmCreateObjectDef("giant goat");
		rmAddObjectDefItem		  (IDGiantGoat, "goat", 2, 2);
		rmSetObjectDefMinDistance (IDGiantGoat, 70.0);
		rmSetObjectDefMaxDistance (IDGiantGoat, 200.0);
		rmAddObjectDefConstraint  (IDGiantGoat, AvoidEdgeShort);
		rmAddObjectDefConstraint  (IDGiantGoat, AvoidCenterCliff);
		rmAddObjectDefConstraint  (IDGiantGoat, AvoidGoat);
		rmAddObjectDefConstraint  (IDGiantGoat, AvoidSettlementSomewhat);

		int IDGiantRhino		  = rmCreateObjectDef("giant rhino");
		rmAddObjectDefItem		  (IDGiantRhino, "rhinocerous", 3, 3);
		rmSetObjectDefMinDistance (IDGiantRhino, 70.0);
		rmSetObjectDefMaxDistance (IDGiantRhino, 200.0);
		rmAddObjectDefConstraint  (IDGiantRhino, AvoidEdgeShort);
		rmAddObjectDefConstraint  (IDGiantRhino, AvoidCenterCliff);
		rmAddObjectDefConstraint  (IDGiantRhino, AvoidFoodMed);
		rmAddObjectDefConstraint  (IDGiantRhino, AvoidSettlementSlightly);

		int IDGiantZebra		  = rmCreateObjectDef("giant zebra");
		rmAddObjectDefItem		  (IDGiantZebra, "zebra", rmRandInt(6.0, 10.0), 4);
		rmSetObjectDefMinDistance (IDGiantZebra, 70.0);
		rmSetObjectDefMaxDistance (IDGiantZebra, 200.0);
		rmAddObjectDefConstraint  (IDGiantZebra, AvoidEdgeShort);
		rmAddObjectDefConstraint  (IDGiantZebra, AvoidCenterCliff);
		rmAddObjectDefConstraint  (IDGiantZebra, AvoidFoodMed);
		rmAddObjectDefConstraint  (IDGiantZebra, AvoidSettlementSomewhat);
	}

	rmSetStatusText("",0.43);
	// Create Passage Definition


	int ConnectionCLiffPassage1		  =rmCreateConnection("Passage1");
	rmSetConnectionType				  (ConnectionCLiffPassage1, cConnectPlayers, false, 100);
	rmSetConnectionWidth			  (ConnectionCLiffPassage1, 30+(cNumberNonGaiaPlayers*5), 2);
	rmSetConnectionBaseHeight		  (ConnectionCLiffPassage1, 7.0);
	rmAddConnectionToClass		 	  (ConnectionCLiffPassage1, classPassage);
	rmSetConnectionSmoothDistance	  (ConnectionCLiffPassage1, 3.0);
	rmAddConnectionTerrainReplacement (ConnectionCLiffPassage1, "CliffEgyptianA" , "SandA");
	rmSetConnectionTerrainCost		  (ConnectionCLiffPassage1, "SandA", 10);
	rmSetConnectionTerrainCost		  (ConnectionCLiffPassage1, "CliffEgyptianA", 15);
	rmSetConnectionPositionVariance	  (ConnectionCLiffPassage1, -1);
	rmAddConnectionStartConstraint	  (ConnectionCLiffPassage1, AvoidPassage);
	rmAddConnectionEndConstraint	  (ConnectionCLiffPassage1, AvoidPassage);
	rmSetConnectionBaseHeight		  (ConnectionCLiffPassage1, 0);
	rmAddConnectionStartConstraint	  (ConnectionCLiffPassage1, AvoidCenterCliff);
	rmAddConnectionStartConstraint	  (ConnectionCLiffPassage1, AvoidEdgeLong);
	rmAddConnectionEndConstraint	  (ConnectionCLiffPassage1, AvoidCenterCliff);
	rmAddConnectionEndConstraint	  (ConnectionCLiffPassage1, AvoidEdgeLong);
	rmSetConnectionWarnFailure		  (ConnectionCLiffPassage1, true);
	rmSetConnectionHeightBlend		  (ConnectionCLiffPassage1, 2);

	//Create extra connection in 1v1 games
	if (cNumberNonGaiaPlayers < 3)
		{
	int ConnectionCLiffPassage2		  =rmCreateConnection("Passage2");
	rmSetConnectionWidth			  (ConnectionCLiffPassage2, 30+(cNumberNonGaiaPlayers*5*mapSizeMultiplier), 2);
	rmSetConnectionBaseHeight		  (ConnectionCLiffPassage2, 7.0);
	rmAddConnectionToClass		 	  (ConnectionCLiffPassage2, classPassage);
	rmSetConnectionSmoothDistance	  (ConnectionCLiffPassage2, 3.0);
	rmAddConnectionTerrainReplacement (ConnectionCLiffPassage2, "CliffEgyptianA" , "SandA");
	rmSetConnectionTerrainCost		  (ConnectionCLiffPassage2, "SandA", 10);
	rmSetConnectionTerrainCost		  (ConnectionCLiffPassage2, "CliffEgyptianA", 15);
	rmSetConnectionTerrainCost		  (ConnectionCLiffPassage2, "GrassA", 1);
	rmSetConnectionPositionVariance	  (ConnectionCLiffPassage2, -1);
	rmSetConnectionBaseHeight		  (ConnectionCLiffPassage2, 0);
	rmAddConnectionStartConstraint	  (ConnectionCLiffPassage2, AvoidPassage);
	rmAddConnectionEndConstraint	  (ConnectionCLiffPassage2, AvoidPassage);
	rmAddConnectionStartConstraint	  (ConnectionCLiffPassage2, AvoidCenterCliff);
	rmAddConnectionStartConstraint	  (ConnectionCLiffPassage2, AvoidEdgeLong);
	rmAddConnectionEndConstraint	  (ConnectionCLiffPassage2, AvoidCenterCliff);
	rmAddConnectionEndConstraint	  (ConnectionCLiffPassage2, AvoidEdgeLong);
	rmSetConnectionWarnFailure		  (ConnectionCLiffPassage2, true);
	rmSetConnectionHeightBlend		  (ConnectionCLiffPassage2, 2);

	}

	rmSetStatusText("",0.50);

	//player locations
	rmSetTeamSpacingModifier(0.90);
	rmPlacePlayersSquare(0.37, 0.05, 0.05);

	rmSetStatusText("",0.54);
	// Create Player Area's
	float playerFraction=rmAreaTilesToFraction(11000*mapSizeMultiplier);
	for(i=1; <cNumberPlayers)
	{
		int AreaPlayer 			=rmCreateArea("Player"+i);

		rmSetPlayerArea			(i, AreaPlayer);
		rmSetAreaSize			(AreaPlayer, playerFraction, playerFraction);
		rmAddAreaToClass		(AreaPlayer, classPlayer);
		rmSetAreaCoherence		(AreaPlayer, 0.2);
		//rmSetAreaCliffType	(AreaPlayer, "Greek");
		//rmSetAreaCliffEdge	(AreaPlayer, 2, 0.0, 0.0, 1.0, 1);
		//rmSetAreaCliffHeight	(AreaPlayer, 0, 0.0, 1);
		rmSetAreaSmoothDistance (AreaPlayer, 20);
		rmSetAreaLocPlayer		(AreaPlayer, i);
		rmSetAreaBaseHeight		(AreaPlayer, 0.0);
		rmSetAreaHeightBlend	(AreaPlayer, 1);
		rmSetAreaTerrainType	(AreaPlayer, "SandA");
		rmAddAreaConstraint 	(AreaPlayer, AvoidPlayer);
		rmSetAreaWarnFailure	(AreaPlayer, false);
		rmAddConnectionArea     (ConnectionCLiffPassage1,AreaPlayer);
		rmAddConnectionArea     (ConnectionCLiffPassage2,AreaPlayer);
	}
	rmBuildAllAreas();


	float someHugeValue 	 =rmAreaTilesToFraction(4000*cNumberNonGaiaPlayers*mapSizeMultiplier);
	int CliffArea 			 = rmCreateArea("DividerCliff");
	rmAddAreaConstraint		 (CliffArea, AvoidPlayerShort);
	rmAddAreaToClass		 (CliffArea, classCenterCliff);
	rmSetAreaSize			 (CliffArea, someHugeValue, someHugeValue);
	rmSetAreaTerrainType	 (CliffArea, "CliffEgyptianA");
	rmSetAreaBaseHeight		 (CliffArea, 5.0);
	rmSetAreaWarnFailure	 (CliffArea, false);
	rmBuildArea				 (CliffArea);

	int failCount=0;
	int numTries=8*cNumberNonGaiaPlayers*mapSizeMultiplier;
	failCount=0;
	for(i=0; <numTries)
	{
		int CliffElev			=rmCreateArea("elev"+i);
		rmSetAreaSize			(CliffElev, rmAreaTilesToFraction(35), rmAreaTilesToFraction(120));
		rmSetAreaWarnFailure	(CliffElev, false);
		rmAddAreaToClass		(CliffElev, classElev);
		rmSetAreaBaseHeight		(CliffElev, rmRandFloat(8.0, 11.0));
		rmSetAreaTerrainType	(CliffElev, "CliffEgyptianA");
		//rmSetAreaCliffType		(CliffElev, "Greek");
		rmSetAreaHeightBlend	(CliffElev, 1);
		rmSetAreaMinBlobs		(CliffElev, 1);
		rmSetAreaMaxBlobs		(CliffElev, 3);
		rmSetAreaMinBlobDistance(CliffElev, 16.0);
		rmSetAreaMaxBlobDistance(CliffElev, 20.0);
		rmSetAreaCoherence		(CliffElev, 0.0);
		rmAddAreaConstraint		(CliffElev, AvoidPlayerMed);
		rmAddAreaConstraint		(CliffElev, AvoidElev);

		if(rmBuildArea(CliffElev)==false)
		{
			// Stop trying once we fail 10 times in a row.
			failCount++;
			if(failCount==10)
				break;
		}
		else
			failCount=0;
	}


	rmBuildConnection(ConnectionCLiffPassage1);
	if (cNumberNonGaiaPlayers < 3)
	{
	rmBuildConnection(ConnectionCLiffPassage2);
	}

	numTries=10*cNumberNonGaiaPlayers;
	failCount=0;
	for(i=0; <numTries)
	{
		int elevID				=rmCreateArea("wrinkle"+i);
		rmSetAreaSize			(elevID, rmAreaTilesToFraction(15*mapSizeMultiplier), rmAreaTilesToFraction(120*mapSizeMultiplier));
		rmSetAreaWarnFailure	(elevID, false);
		rmSetAreaBaseHeight		(elevID, rmRandFloat(0.0, 1.0));
		rmSetAreaMinBlobs		(elevID, 1);
		rmSetAreaMaxBlobs		(elevID, 3);
		rmSetAreaTerrainType	(elevID, "SandD");
		rmSetAreaMinBlobDistance(elevID, 16.0);
		rmSetAreaMaxBlobDistance(elevID, 20.0);
		rmSetAreaCoherence		(elevID, 0.0);
		rmAddAreaConstraint		(elevID, AvoidCenterCliffShort);
		rmAddAreaToClass		(elevID, classWrinkle);
		rmAddAreaConstraint		(elevID, AvoidWrinkle);

		if(rmBuildArea(elevID)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}

	rmSetStatusText("",0.60);
	//Settlements
	rmPlaceObjectDefPerPlayer(IDStartingSettlement, true);

	AreaPlayer=rmAddFairLoc("Settlement", false, true,  70, 90, 80, 20);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterCliff);

	if (cNumberNonGaiaPlayers>2)
		AreaPlayer=rmAddFairLoc("Settlement", true, false,  80, 100, 80, 20);
	else if(rmRandFloat(0,1)<0.5)
		AreaPlayer=rmAddFairLoc("Settlement", true, false, 110, 130, 90, 20);
	else
		AreaPlayer=rmAddFairLoc("Settlement", false, true,  90, 110, 90, 20);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterCliff);

	if (cMapSize == 2) {
	AreaPlayer=rmAddFairLoc("Settlement", false, true,  100, 200, 120, 80);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterCliffLong);
	rmAddFairLocConstraint(AreaPlayer, AvoidStartingSettlement);
	}

	if(rmPlaceFairLocs())
	{
		AreaPlayer=rmCreateObjectDef("far settlement2");
		rmAddObjectDefItem(AreaPlayer, "Settlement", 1, 0.0);
		for(i=1; <cNumberPlayers)
		{
			for(j=0; <rmGetNumberFairLocs(i))
				rmPlaceObjectDefAtLoc(AreaPlayer, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
		}
	}

	rmSetStatusText("",0.67);
	// place player objects
	rmPlaceObjectDefPerPlayer(IDStartingTower, true, 4);
	rmPlaceObjectDefPerPlayer(IDStartingGold, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingBerry, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingHunt, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingChicken, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingGoat, true, 1);
	rmPlaceObjectDefPerPlayer(IDStragglerTree, false, rmRandInt(2.0, 3.0));
	rmPlaceObjectDefPerPlayer(IDMedGoldmine, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarGoldmine, false, 2);
	rmPlaceObjectDefPerPlayer(IDMedBerry, false, 1);
	rmPlaceObjectDefPerPlayer(IDMedGiraffe, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarBerry, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarRhino, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarZebra, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarGoat, false, 2);
	rmPlaceObjectDefPerPlayer(IDFarLion, false, rmRandInt(1, 2));
	if (cNumberNonGaiaPlayers > 3) {
	rmPlaceObjectDefPerPlayer(IDCenterGoldmine, false, 1);
	}

	if (cMapSize == 2) {
		for (i=1; <cNumberPlayers) {
			rmPlaceObjectDefInArea		(IDGiantGold, 0, rmAreaID("Player"+i), 1);
			rmPlaceObjectDefInArea		(IDGiantGoat, 0, rmAreaID("Player"+i), 1);
			rmPlaceObjectDefInArea		(IDGiantRhino, 0, rmAreaID("Player"+i), 1);
			rmPlaceObjectDefInArea		(IDGiantZebra, 0, rmAreaID("Player"+i), 1);
		}
	}

	rmSetStatusText("",0.73);
	// Ruins
	int ruinID=0;
	int columnID=0;
	int relicID=0;
	int avoidRuins=rmCreateTypeDistanceConstraint("ruin vs ruin", "relic", 90.0*mapSizeMultiplier);
	int stayInRuins=rmCreateEdgeDistanceConstraint("stay in ruins", ruinID, 4.0);

	for(i=0; <1*cNumberNonGaiaPlayers*mapSizeMultiplier)
	{
		ruinID					=rmCreateArea("ruins "+i);
		rmSetAreaSize			(ruinID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaTerrainType	(ruinID, "EgyptianRoadA");
		rmAddAreaTerrainLayer	(ruinID, "SandD", 0, 1);
		rmSetAreaMinBlobs		(ruinID, 1);
		rmSetAreaMaxBlobs		(ruinID, 2);
		rmSetAreaWarnFailure	(ruinID, false);
		rmSetAreaMinBlobDistance(ruinID, 4.0);
		rmSetAreaMaxBlobDistance(ruinID, 8.0);
		rmSetAreaCoherence		(ruinID, 0.8);
		rmSetAreaSmoothDistance	(ruinID, 20);
		rmAddAreaConstraint		(ruinID, AvoidAll);
		rmAddAreaConstraint		(ruinID, avoidRuins);
		rmAddAreaConstraint		(ruinID, stayInRuins);
		rmAddAreaConstraint		(ruinID, AvoidCenterCliffShort);
		rmAddAreaConstraint		(ruinID, AvoidSettlementHOLYFUCK);

		rmBuildArea(ruinID);

		columnID					=rmCreateObjectDef	("columns "+i);
		rmAddObjectDefItem			(columnID, "ruins", rmRandInt(0,1), 0.0);
		rmAddObjectDefItem			(columnID, "columns broken", rmRandInt(2,5), 6.0);
		rmAddObjectDefItem			(columnID, "columns", rmRandFloat(0,2), 5.0);
		rmAddObjectDefItem			(columnID, "rock sandstone small", rmRandInt(1,3), 5.0);
		rmAddObjectDefItem			(columnID, "rock sandstone sprite", rmRandInt(4,8), 7.0);
		rmAddObjectDefItem			(columnID, "bush", rmRandFloat(3,6), 5.0);
		rmSetObjectDefMinDistance	(columnID, 0.0);
		rmSetObjectDefMaxDistance	(columnID, 0.0);
		rmPlaceObjectDefInArea		(columnID, 0, rmAreaID("ruins "+i), 1);

		relicID						=rmCreateObjectDef("relics "+i);
		rmAddObjectDefItem			(relicID, "relic", 1, 0.0);
		rmSetObjectDefMinDistance	(relicID, 0.0);
		rmSetObjectDefMaxDistance	(relicID, 0.0);
		//rmAddObjectDefConstraint	(relicID, AvoidAll);
		//rmAddObjectDefConstraint	(relicID, stayInRuins);
		rmPlaceObjectDefInArea		(relicID, 0, rmAreaID("ruins "+i), 1);

		if(rmGetNumberUnitsPlaced(relicID) < 1)
		{
			rmEchoInfo("--failed to place relicID in ruins "+i+". So just dropping backup Relic.");
			rmSetAreaSize(ruinID, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
			int backupRelicID			=rmCreateObjectDef("backup relic "+i);
			rmAddObjectDefItem			(backupRelicID, "relic", 1, 0.0);
			rmSetObjectDefMinDistance	(backupRelicID, 0.0);
			rmSetObjectDefMaxDistance	(backupRelicID, rmXFractionToMeters(0.5));
			rmAddObjectDefConstraint	(backupRelicID, avoidRuins);
			rmAddObjectDefConstraint	(backupRelicID, AvoidSettlementHOLYFUCK);
			rmAddObjectDefConstraint	(backupRelicID, AvoidCenterCliffShort);
			rmPlaceObjectDefAtLoc		(backupRelicID, 0, 0.5, 0.5, 1);
		}

	}

	rmSetStatusText("",0.80);
	//Center Giraffe
	int giraffeAreaID=0;
	int giraffeID=0;

	for(i=0; <1*cNumberNonGaiaPlayers)
	{
		giraffeAreaID			=rmCreateArea("giraffe "+i);
		rmSetAreaSize			(giraffeAreaID, rmAreaTilesToFraction(8), rmAreaTilesToFraction(10));
		rmSetAreaTerrainType	(giraffeAreaID, "GrassDirt75");
		rmSetAreaWarnFailure	(giraffeAreaID, false);
		rmSetAreaCoherence		(giraffeAreaID, 1.0);
		rmAddAreaConstraint		(giraffeAreaID, AvoidImpassableLand);
		rmAddAreaConstraint		(giraffeAreaID, AvoidPlayerMed);
		rmAddAreaToClass		(giraffeAreaID, classGiraffe);
		rmAddAreaConstraint		(giraffeAreaID, AvoidGiraffe);
		rmAddAreaConstraint		(giraffeAreaID, AvoidAll);

		rmBuildArea(giraffeAreaID);

		giraffeID				 =rmCreateObjectDef("giraffe "+i);
		rmAddObjectDefItem		 (giraffeID, "giraffe", 5, 3);
		rmSetObjectDefMinDistance(giraffeID, 0.0);
		rmSetObjectDefMaxDistance(giraffeID, 0.0);
		rmAddObjectDefConstraint (giraffeID, AvoidPlayerShort);
		rmAddObjectDefConstraint (giraffeID, AvoidImpassableLand);
		rmPlaceObjectDefAtAreaLoc(giraffeID, 0, rmAreaID("giraffe "+i), 1);

	}

	rmSetStatusText("",0.86);
	// FORESTS.

	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 8.0);
	int forestTcConstraint=rmCreateTypeDistanceConstraint("forest tc", "settlement level 1", 19.0);
	int forestRelicConstraint=rmCreateTypeDistanceConstraint("forest relic", "relic", 4.0);
	int forestCount=10*cNumberNonGaiaPlayers;
	failCount=0;

	for(i=0; <forestCount)
	{
		int forestID		= rmCreateArea("forest"+i);
		if (cNumberNonGaiaPlayers > 8) {
		rmSetAreaSize		(forestID, rmAreaTilesToFraction(120*mapSizeMultiplier), rmAreaTilesToFraction(200*mapSizeMultiplier));
		} else {
		rmSetAreaSize		(forestID, rmAreaTilesToFraction(120), rmAreaTilesToFraction(160*mapSizeMultiplier));
		}
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaForestType (forestID, "palm forest");
		rmAddAreaConstraint (forestID, AvoidSettlementSlightly);
		rmAddAreaConstraint (forestID, forestObjConstraint);
		rmAddAreaConstraint (forestID, forestTcConstraint);
		rmAddAreaConstraint (forestID, forestRelicConstraint);
		rmAddAreaConstraint (forestID, AvoidForestMedium);
		rmAddAreaConstraint (forestID, AvoidCenterCliffShort);
		rmAddAreaToClass	(forestID, classForest);
		rmSetAreaCoherence(forestID, 0.2);

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

	rmSetStatusText("",0.92);
	//Straggler trees
	rmPlaceObjectDefAtLoc(IDStragglerTrees, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int bushID=rmCreateObjectDef("big bush patch");
	rmAddObjectDefItem(bushID, "bush", 3, 5.0);
	rmSetObjectDefMinDistance(bushID, 0.0);
	rmSetObjectDefMaxDistance(bushID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint(bushID, AvoidAll);
	rmPlaceObjectDefAtLoc(bushID, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers*mapSizeMultiplier);

	// RM X Finalize.
	rmxFinalize();
}