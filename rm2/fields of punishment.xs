/* Fields of Punishment
** Created by Hagrit
** Initial design by Keen_Flame
** Version 1.00
*/

// VBP 5.0

include "rmx 5-0-0.xs";

void SetUpMap(int small = 5000, int big = 10000,int giant = 20000, float seaLevel = 0, string tileName = "GrassA")
{
	int PlayerTiles = small;
	if (cMapSize == 1)
		PlayerTiles = big;

	// Giant maps suck though..
	// but people still use it..
	if (cMapSize == 2)
		PlayerTiles = giant;

	int Size = sqrt(cNumberNonGaiaPlayers * PlayerTiles / 0.9)*2;
	rmSetMapSize(Size,Size);
	rmSetSeaLevel(seaLevel);
	rmTerrainInitialize(tileName);
}

void main()
{
	// RM X Setup.
	rmxInit("Fields of Punishment (by Hagrit & Flame)", false, false, false);

	// Setup 'basic bitch' map..
	SetUpMap(7500,11000,18500,-8,"Hadesbuildable1");
	int mapSizeMultiplier = 1;

	if (cMapSize == 2) {
		mapSizeMultiplier = 2;
	}

	rmSetLightingSet("alfheim2");
	rmSetGaiaCiv(cCivZeus);

	rmSetStatusText("",0.09);

	// DEFINE CLASSES
	int classPlayer    			  = rmDefineClass("player");
	int classForest    			  = rmDefineClass("forest");
	int classStartingSettlement   = rmDefineClass("starting tc");
	int classCenter				  = rmDefineClass("center");
	int classLava				  = rmDefineClass("lava");
	int classRelic				  = rmDefineClass("relic");
	int classOutside			  = rmDefineClass("outside");

	rmSetStatusText("",0.15);

	// CONSTRAINTS
	int AvoidEdgeShort				= rmCreateBoxConstraint			 ("edge of map", rmXTilesToFraction(4), rmZTilesToFraction(4), 1.0-rmXTilesToFraction(4), 1.0-rmZTilesToFraction(4));
	int AvoidEdgeMed				= rmCreateBoxConstraint			 ("edge of map further", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0-rmXTilesToFraction(8), 1.0-rmZTilesToFraction(8));
	int AvoidEdgeFar				= rmCreateBoxConstraint			 ("edge of map furthest", 0.20, 0.80, 0.80, 0.20, 0.01);
	int AvoidEdgeHunt				= rmCreateBoxConstraint			 ("edge of map for hunt", 0.30, 0.70, 0.70, 0.30, 0.01);

	int AvoidSettlementSlightly 	= rmCreateTypeDistanceConstraint ("0", "AbstractSettlement", 10.0);
	int AvoidSettlementSlightlyMore = rmCreateTypeDistanceConstraint ("-1", "AbstractSettlement", 18.0);
	int AvoidSettlementAbit		 	= rmCreateTypeDistanceConstraint ("1", "AbstractSettlement", 20.0);
	int AvoidSettlementSomewhat 	= rmCreateTypeDistanceConstraint ("2", "AbstractSettlement", 32.0);
	int AvoidSettlementHOLYFUCK 	= rmCreateTypeDistanceConstraint ("3", "AbstractSettlement", 90.0);
	int AvoidPlayer 				= rmCreateClassDistanceConstraint("4", classPlayer, 1.0);
	int AvoidPlayerFar 				= rmCreateClassDistanceConstraint("5", classPlayer, 25.0);
	int AvoidOtherTower				= rmCreateTypeDistanceConstraint ("7", "tower", 25.0);
	int AvoidTowerShort				= rmCreateTypeDistanceConstraint ("8", "tower", 6.0);
	int AvoidGoldShort				= rmCreateTypeDistanceConstraint ("9", "gold", 6.0);
	int AvoidGoldFar				= rmCreateTypeDistanceConstraint ("10", "gold", 40.0+cNumberNonGaiaPlayers);
	int AvoidFoodFar				= rmCreateTypeDistanceConstraint ("11", "food", 50.0);
	int AvoidFoodMed				= rmCreateTypeDistanceConstraint ("12", "food", 30.0);
	int AvoidFoodShort				= rmCreateTypeDistanceConstraint ("13", "food", 20.0);
	int AvoidGoat					= rmCreateTypeDistanceConstraint ("14", "goat", 30.0);
	int AvoidBerry					= rmCreateTypeDistanceConstraint ("16", "berry bush", 50.0);

	int AvoidForestMedium			= rmCreateClassDistanceConstraint ("17", classForest, 20.0);
	int AvoidCenter					= rmCreateClassDistanceConstraint ("18", classCenter, 15.0);
	int AvoidCenterShort			= rmCreateClassDistanceConstraint ("fuck u more", classCenter, 1.0);
	int AvoidCenterFar				= rmCreateClassDistanceConstraint ("fuck u", classCenter, 45.0);
	int AvoidStartingSettlement		= rmCreateClassDistanceConstraint ("19", classStartingSettlement, 17.0);
	int AvoidLava					= rmCreateClassDistanceConstraint ("20", classLava, 15.0*mapSizeMultiplier);
	int AvoidLavaShort				= rmCreateClassDistanceConstraint ("23", classLava, 2.0);
	int AvoidRelic					= rmCreateClassDistanceConstraint ("24", classRelic, 50.0);
	int AvoidOutside				= rmCreateClassDistanceConstraint ("25", classOutside, 10.0);
	int AvoidStartingTower			= rmCreateTypeDistanceConstraint  ("21", "tower", 34.0);
	int AvoidAll					= rmCreateTypeDistanceConstraint  ("22", "all", 7.0);

	rmSetStatusText("",0.23);

	/// OBJECT DEFINIIONS

	//STARTING OBJECTS

	int IDStartingSettlement  = rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem        (IDStartingSettlement, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass     (IDStartingSettlement, classStartingSettlement);
	rmSetObjectDefMinDistance (IDStartingSettlement, 0.0);
	rmSetObjectDefMaxDistance (IDStartingSettlement, 0.0);

	int IDStartingTower 	  = rmCreateObjectDef("starting towers");
	rmAddObjectDefItem        (IDStartingTower, "tower", 1, 0.0);
	rmAddObjectDefConstraint  (IDStartingTower, AvoidOtherTower);
	rmSetObjectDefMinDistance (IDStartingTower, 22.0);
	rmSetObjectDefMaxDistance (IDStartingTower, 27.0);

	int IDStartingBerry 	  = rmCreateObjectDef("starting berry");
	rmAddObjectDefItem        (IDStartingBerry, "berry bush", rmRandInt(5.0, 10.0), 4);
	rmSetObjectDefMinDistance (IDStartingBerry, 21.0);
	rmSetObjectDefMaxDistance (IDStartingBerry, 25.0);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidTowerShort);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidAll);

	int IDStartingGoldmine    = rmCreateObjectDef("starting goldmine");
	rmAddObjectDefItem        (IDStartingGoldmine, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance (IDStartingGoldmine, 20.0);
	rmSetObjectDefMaxDistance (IDStartingGoldmine, 24.0);
	rmAddObjectDefConstraint  (IDStartingGoldmine, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDStartingGoldmine, AvoidEdgeShort);

	int IDStartingHunt	 	  = rmCreateObjectDef("starting boar");
	rmAddObjectDefItem        (IDStartingHunt, "boar", rmRandInt(2, 3), 3);
	rmSetObjectDefMinDistance (IDStartingHunt, 23.0);
	rmSetObjectDefMaxDistance (IDStartingHunt, 27.0);
	rmAddObjectDefConstraint  (IDStartingHunt, AvoidEdgeShort);

	int IDStartingHunt2	 	  = rmCreateObjectDef("starting hunt");
	rmAddObjectDefItem        (IDStartingHunt2, "elk", rmRandInt(4, 6), 4);
	rmSetObjectDefMinDistance (IDStartingHunt2, 35.0);
	rmSetObjectDefMaxDistance (IDStartingHunt2, 45.0);
	rmAddObjectDefConstraint  (IDStartingHunt2, AvoidEdgeShort);

	int IDStartingHerd	 	  = rmCreateObjectDef("starting goat");
	rmAddObjectDefItem        (IDStartingHerd, "goat", rmRandInt(1.0, 5.0), 4);
	rmSetObjectDefMinDistance (IDStartingHerd, 25.0);
	rmSetObjectDefMaxDistance (IDStartingHerd, 30.0);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidGoat);

	int IDStragglerTree		  = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem		  (IDStragglerTree, "pine dead", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTree, 13.0);
	rmSetObjectDefMaxDistance (IDStragglerTree, 20.0);
	rmAddObjectDefConstraint  (IDStragglerTree, AvoidAll);

	rmSetStatusText("",0.30);

	//MEDIUM OBJECTS

	int IDMediumGoldmine 	  = rmCreateObjectDef("Medium goldmine");
	rmAddObjectDefItem        (IDMediumGoldmine, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance (IDMediumGoldmine, 50.0);
	rmSetObjectDefMaxDistance (IDMediumGoldmine, 65.0);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidAll);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidStartingTower);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidCenter);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidPlayer);

	int IDMediumHunt 	 	  = rmCreateObjectDef("Medium hunt");
	rmAddObjectDefItem        (IDMediumHunt, "Boar", (rmRandInt(1.0, 2.0)), 4.0);
	rmAddObjectDefItem        (IDMediumHunt, "elk", (rmRandInt(3.0, 4.0)), 4.0);
	rmSetObjectDefMinDistance (IDMediumHunt, 50.0);
	rmSetObjectDefMaxDistance (IDMediumHunt, 60.0);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidStartingTower);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidCenter);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidAll);

	rmSetStatusText("",0.36);

	///FAR OBJECTS

	int IDFarGold		 	  = rmCreateObjectDef("far gold");
	rmAddObjectDefItem        (IDFarGold, "gold mine", 1, 0);
	rmSetObjectDefMinDistance (IDFarGold, 70.0);
	rmSetObjectDefMaxDistance (IDFarGold, 90.0);
	rmAddObjectDefConstraint  (IDFarGold, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDFarGold, AvoidEdgeFar);
	rmAddObjectDefConstraint  (IDFarGold, AvoidSettlementSlightlyMore);
	rmAddObjectDefConstraint  (IDFarGold, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDFarGold, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarGold, AvoidAll);

	int IDFarGold2		 	  = rmCreateObjectDef("far gold2");
	rmAddObjectDefItem        (IDFarGold2, "gold mine", 1, 0);
	rmSetObjectDefMinDistance (IDFarGold2, 85.0);
	rmSetObjectDefMaxDistance (IDFarGold2, 110.0);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidCenterShort);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidSettlementSlightlyMore);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidAll);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidEdgeMed);

	int IDFarHunt	 	 	  = rmCreateObjectDef("far hunt");
	rmAddObjectDefItem        (IDFarHunt, "Boar", (rmRandInt(4.0, 5.0)), 5.0);
	rmSetObjectDefMinDistance (IDFarHunt, 75.0);
	rmSetObjectDefMaxDistance (IDFarHunt, 90.0);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidEdgeHunt);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidAll);

	int IDFarHunt2	 	 	  = rmCreateObjectDef("far hunt2");
	rmAddObjectDefItem        (IDFarHunt2, "Boar", (rmRandInt(3.0, 4.0)), 5.0);
	rmSetObjectDefMinDistance (IDFarHunt2, 75.0);
	rmSetObjectDefMaxDistance (IDFarHunt2, 100.0);
	rmAddObjectDefConstraint  (IDFarHunt2, AvoidCenter);
	rmAddObjectDefConstraint  (IDFarHunt2, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarHunt2, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDFarHunt2, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDFarHunt2, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDFarHunt2, AvoidAll);

	int IDFarHunt3	 	 	  = rmCreateObjectDef("far hunt3");
	rmAddObjectDefItem        (IDFarHunt3, "Boar", (rmRandInt(3.0, 4.0)), 4.0);
	rmSetObjectDefMinDistance (IDFarHunt3, 65.0);
	rmSetObjectDefMaxDistance (IDFarHunt3, 85.0);
	rmAddObjectDefConstraint  (IDFarHunt3, AvoidEdgeHunt);
	rmAddObjectDefConstraint  (IDFarHunt3, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarHunt3, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDFarHunt3, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDFarHunt3, AvoidAll);

	int IDFarHunt4			  = rmCreateObjectDef("far hunt4");
	rmAddObjectDefItem        (IDFarHunt4, "elk", rmRandInt(6, 9), 4);
	rmSetObjectDefMinDistance (IDFarHunt4, 65.0);
	rmSetObjectDefMaxDistance (IDFarHunt4, 85.0);
	rmAddObjectDefConstraint  (IDFarHunt4, AvoidEdgeHunt);
	rmAddObjectDefConstraint  (IDFarHunt4, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarHunt4, AvoidFoodMed);
	rmAddObjectDefConstraint  (IDFarHunt4, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDFarHunt4, AvoidAll);

	int IDFarGoat		 	  = rmCreateObjectDef("far goat");
	rmAddObjectDefItem        (IDFarGoat, "goat", 2, 2);
	rmSetObjectDefMinDistance (IDFarGoat, 80.0);
	rmSetObjectDefMaxDistance (IDFarGoat, 120.0);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidGoat);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidAll);

	int IDFarBerry		 	  = rmCreateObjectDef("far berry");
	rmAddObjectDefItem        (IDFarBerry, "berry bush", rmRandInt(6,8), 4);
	rmSetObjectDefMinDistance (IDFarBerry, rmXFractionToMeters(0.65));
	rmSetObjectDefMaxDistance (IDFarBerry, rmXFractionToMeters(0.85));
	rmAddObjectDefConstraint  (IDFarBerry, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidPlayerFar);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidBerry);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidCenterFar);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidSettlementSlightly);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidAll);

	int IDFarPredator	 	  = rmCreateObjectDef("far predator");
	rmAddObjectDefItem        (IDFarPredator, "walking berry bush", 1, 3);
	rmSetObjectDefMinDistance (IDFarPredator, 80.0);
	rmSetObjectDefMaxDistance (IDFarPredator, 120.0);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidAll);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidEdgeFar);
	rmAddObjectDefConstraint  (IDFarPredator, rmCreateTypeDistanceConstraint("pred vs pred", "walking berry bush", 40.0));

	int IDFarPredator2	 	  = rmCreateObjectDef("far predator2");
	rmAddObjectDefItem        (IDFarPredator2, "bear", 2, 3);
	rmSetObjectDefMinDistance (IDFarPredator2, 80.0);
	rmSetObjectDefMaxDistance (IDFarPredator2, 120.0);
	rmAddObjectDefConstraint  (IDFarPredator2, AvoidSettlementAbit);
	rmAddObjectDefConstraint  (IDFarPredator2, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarPredator2, AvoidAll);
	rmAddObjectDefConstraint  (IDFarPredator2, AvoidLavaShort);
	rmAddObjectDefConstraint  (IDFarPredator2, rmCreateTypeDistanceConstraint("pred vs pred2", "bear", 40.0));

	// OTHER

	int IDStragglerTrees	  = rmCreateObjectDef("straggler trees");
	rmAddObjectDefItem		  (IDStragglerTrees, "pine dead", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTrees, 0.0);
	rmSetObjectDefMaxDistance (IDStragglerTrees, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint  (IDStragglerTrees, rmCreateTypeDistanceConstraint("random tree", "all", 8.0));
	rmAddObjectDefConstraint  (IDStragglerTrees, AvoidSettlementSomewhat);

	int IDStragglerTrees2	  = rmCreateObjectDef("straggler trees2");
	rmAddObjectDefItem		  (IDStragglerTrees2, "pine dead burning", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTrees2, 0.0);
	rmSetObjectDefMaxDistance (IDStragglerTrees2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint  (IDStragglerTrees2, rmCreateTypeDistanceConstraint("random tree2", "all", 8.0));
	rmAddObjectDefConstraint  (IDStragglerTrees2, AvoidSettlementSomewhat);

	int IDLavaFires			  = rmCreateObjectDef("fires");
	rmAddObjectDefItem		  (IDLavaFires, "fire hades", rmRandInt(1.0,2.0), 3);
	rmAddObjectDefItem		  (IDLavaFires, "stalagmite", rmRandInt(1.0,2.0), 3);
	rmSetObjectDefMinDistance (IDLavaFires, 0.0);
	rmSetObjectDefMaxDistance (IDLavaFires, 0.0);
	rmAddObjectDefConstraint  (IDLavaFires, AvoidAll);

	//giant
	if (cMapSize == 2) {
		int IDGiantGold		 	  = rmCreateObjectDef("giant gold");
		rmAddObjectDefItem        (IDGiantGold, "gold mine", 1, 0);
		rmSetObjectDefMinDistance (IDGiantGold, 120.0);
		rmSetObjectDefMaxDistance (IDGiantGold, 180.0);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidGoldFar);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidOutside);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidSettlementSlightlyMore);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidLavaShort);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidPlayer);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidAll);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidEdgeMed);

		int IDGiantHunt	 	 	  = rmCreateObjectDef("giant hunt");
		rmAddObjectDefItem        (IDGiantHunt, "Boar", (rmRandInt(5.0, 7.0)), 5.0);
		rmSetObjectDefMinDistance (IDGiantHunt, 100.0);
		rmSetObjectDefMaxDistance (IDGiantHunt, 200.0);
		rmAddObjectDefConstraint  (IDGiantHunt, AvoidOutside);
		rmAddObjectDefConstraint  (IDGiantHunt, AvoidSettlementSomewhat);
		rmAddObjectDefConstraint  (IDGiantHunt, AvoidFoodShort);
		rmAddObjectDefConstraint  (IDGiantHunt, AvoidLavaShort);
		rmAddObjectDefConstraint  (IDGiantHunt, AvoidAll);

		int IDGiantGoat		 	  = rmCreateObjectDef("giant goat");
		rmAddObjectDefItem        (IDGiantGoat, "goat", 2, 2);
		rmSetObjectDefMinDistance (IDGiantGoat, 100.0);
		rmSetObjectDefMaxDistance (IDGiantGoat, 200.0);
		rmAddObjectDefConstraint  (IDGiantGoat, AvoidEdgeShort);
		rmAddObjectDefConstraint  (IDGiantGoat, AvoidPlayer);
		rmAddObjectDefConstraint  (IDGiantGoat, AvoidGoat);
		rmAddObjectDefConstraint  (IDGiantGoat, AvoidLavaShort);
		rmAddObjectDefConstraint  (IDGiantGoat, AvoidAll);

		int IDGiantPredator	 	  = rmCreateObjectDef("giant predator");
		rmAddObjectDefItem        (IDGiantPredator, "walking berry bush", 1, 3);
		rmSetObjectDefMinDistance (IDGiantPredator, 120.0);
		rmSetObjectDefMaxDistance (IDGiantPredator, 190.0);
		rmAddObjectDefConstraint  (IDGiantPredator, AvoidSettlementSomewhat);
		rmAddObjectDefConstraint  (IDGiantPredator, AvoidPlayer);
		rmAddObjectDefConstraint  (IDGiantPredator, AvoidAll);
		rmAddObjectDefConstraint  (IDGiantPredator, AvoidLavaShort);
		rmAddObjectDefConstraint  (IDGiantPredator, AvoidOutside);
		rmAddObjectDefConstraint  (IDGiantPredator, rmCreateTypeDistanceConstraint("pred vs pred3", "walking berry bush", 40.0));

	}

	rmSetStatusText("",0.45);
	/// DEFINE PLAYER LOCATIONS
	rmSetTeamSpacingModifier(0.90);
	rmPlacePlayersCircular(0.36, 0.38, rmDegreesToRadians(3.0));


	/// TERRAIN DEFINITION
	float playerFraction=rmAreaTilesToFraction(700);
	for(i=1; <cNumberPlayers)
	{
		int AreaPlayer =rmCreateArea("Player"+i);

		rmSetPlayerArea			(i, AreaPlayer);
		rmSetAreaSize			(AreaPlayer, playerFraction, playerFraction);
		rmAddAreaToClass		(AreaPlayer, classPlayer);
		rmSetAreaCoherence		(AreaPlayer, 0.0);
		rmSetAreaCliffType		(AreaPlayer, "Norse");
		rmSetAreaCliffEdge		(AreaPlayer, 2, 0.0, 0.0, 1.0, 1);
		rmSetAreaCliffHeight	(AreaPlayer, 0, 0.0, 1);
		rmSetAreaSmoothDistance (AreaPlayer, 20);
		rmSetAreaLocPlayer		(AreaPlayer, i);
		rmSetAreaTerrainType	(AreaPlayer, "Hadesbuildable2");

	}
	rmBuildAllAreas();

	int AreaCenter = rmCreateArea("Center");

	rmSetAreaLocation		(AreaCenter, 0.5, 0.5);
	rmSetAreaSize			(AreaCenter, 0.25, 0.25);
	rmAddAreaToClass		(AreaCenter, classCenter);
	rmSetAreaCoherence		(AreaCenter, 1.0);
	rmSetAreaTerrainType	(AreaCenter, "Hadesbuildable2");
	rmSetAreaSmoothDistance (AreaCenter, 20);
	rmSetAreaCliffEdge		(AreaCenter, 2, 0.0, 0.0, 1.0, 1);
	//rmSetAreaBaseHeight		(AreaCenter, 0.0);
	rmSetAreaHeightBlend	(AreaCenter, 2.0);


	rmBuildArea(AreaCenter);

	float mapFraction=rmAreaTilesToFraction(150*cNumberPlayers*mapSizeMultiplier);
	int numTries=100*cNumberNonGaiaPlayers;
	int failCount=0;
	for(i=0; <numTries)
	{
		int AreaOutside			=rmCreateArea("AreaOutside"+i);
		rmSetAreaSize			(AreaOutside, mapFraction, mapFraction);
		//rmSetAreaTerrainType	(AreaOutside, "SandB");
		rmAddAreaToClass		(AreaOutside, classOutside);
		rmAddAreaConstraint		(AreaOutside, AvoidCenterShort);

		if(rmBuildArea(AreaOutside)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==10)
				break;
		}
		else
			failCount=0;
	}

	numTries=6*cNumberNonGaiaPlayers*mapSizeMultiplier;
	failCount=0;
	for(i=0; <numTries)
	{
		int IDelev				=rmCreateArea("elev"+i);
		rmSetAreaSize			(IDelev, rmAreaTilesToFraction(100*mapSizeMultiplier), rmAreaTilesToFraction(200*mapSizeMultiplier));
		rmSetAreaWarnFailure	(IDelev, false);
		rmAddAreaConstraint		(IDelev, AvoidAll);

		if(rmRandFloat(0.0, 1.0)<0.8)
			rmSetAreaTerrainType(IDelev, "Hadesbuildable2");

		rmSetAreaBaseHeight		(IDelev, rmRandFloat(2.0, 4.0));
		rmSetAreaHeightBlend	(IDelev, 1);
		rmSetAreaMinBlobs		(IDelev, 1);
		rmSetAreaMaxBlobs		(IDelev, 5);
		rmSetAreaMinBlobDistance(IDelev, 16.0);
		rmSetAreaMaxBlobDistance(IDelev, 40.0);
		rmSetAreaCoherence		(IDelev, 0.2);

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

	rmSetStatusText("",0.53);


	///SETTLEMENTS
	rmPlaceObjectDefPerPlayer(IDStartingSettlement, true);

	AreaPlayer=rmAddFairLoc("Settlement", false, true,  70, 90, 80, 40);
	rmAddFairLocConstraint	(AreaPlayer, AvoidCenterShort);

	if (cNumberNonGaiaPlayers>2)
		AreaPlayer=rmAddFairLoc("Settlement", true, false,  80, 100, 60, 30);
	else if(rmRandFloat(0,1)<0.5) {
		AreaPlayer=rmAddFairLoc("Settlement", true, false, 100, 120, 80, 45);
		rmAddFairLocConstraint	(AreaPlayer, AvoidCenterShort);
	} else
		AreaPlayer=rmAddFairLoc("Settlement", false, true,  90, 110, 60, 30);

	if (cMapSize == 2) {
		AreaPlayer=rmAddFairLoc("Settlement", true, false,  100, 180, 100, 50);
		rmAddFairLocConstraint	(AreaPlayer, AvoidOutside);
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

	rmSetStatusText("",0.60);

	/// Pits

   for(i=1; <cNumberPlayers*1*mapSizeMultiplier)
	{
		int AreaLavaPatch	     = rmCreateArea("patch A"+i);
		rmSetAreaSize			(AreaLavaPatch, rmAreaTilesToFraction(120*mapSizeMultiplier), rmAreaTilesToFraction(160*mapSizeMultiplier));
		rmSetAreaTerrainType	(AreaLavaPatch, "Hades7");
		rmAddAreaTerrainLayer	(AreaLavaPatch, "Hades4", 1 , 2);
		rmAddAreaTerrainLayer	(AreaLavaPatch, "Hades6", 0 , 1);
		rmAddAreaToClass		(AreaLavaPatch, classLava);
		rmSetAreaCoherence		(AreaLavaPatch, 1.0);
		rmSetAreaBaseHeight		(AreaLavaPatch, -4.0);
		rmSetAreaHeightBlend	(AreaLavaPatch, 2.0);
		rmSetAreaSmoothDistance (AreaLavaPatch, 5);
		rmAddAreaConstraint		(AreaLavaPatch, AvoidPlayerFar);
		rmAddAreaConstraint		(AreaLavaPatch, AvoidSettlementAbit);
		rmAddAreaConstraint		(AreaLavaPatch, AvoidLava);
		rmAddAreaConstraint		(AreaLavaPatch, AvoidOutside);
		rmBuildArea(AreaLavaPatch);
		rmPlaceObjectDefAtAreaLoc(IDLavaFires, 0, rmAreaID("patch A"+i), 2);
	}

	rmSetStatusText("",0.70);

	// PLACE PLAYER OBJECTS
	rmPlaceObjectDefPerPlayer(IDStartingGoldmine, true);
	rmPlaceObjectDefPerPlayer(IDStartingTower, true, 4);
	rmPlaceObjectDefPerPlayer(IDStartingBerry, false);
	rmPlaceObjectDefPerPlayer(IDStartingHunt, false);
	if (rmRandFloat(0,1)> 0.5){
	rmPlaceObjectDefPerPlayer(IDStartingHunt2, false);
	}
	rmPlaceObjectDefPerPlayer(IDStartingHerd, true);
	rmPlaceObjectDefPerPlayer(IDStragglerTree, false, rmRandInt(4.0, 8.0));

	rmPlaceObjectDefPerPlayer(IDMediumGoldmine, false, rmRandInt(1.0,2.0));
	rmPlaceObjectDefPerPlayer(IDMediumHunt, false);

	rmPlaceObjectDefPerPlayer(IDFarGold, false, rmRandInt(2.0, 3.0));
	rmPlaceObjectDefPerPlayer(IDFarGold2, false, rmRandInt(1.0, 2.0));
	rmPlaceObjectDefPerPlayer(IDFarHunt, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarHunt2, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarHunt4, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarGoat, false, rmRandInt(2.0, 4.0));
	rmPlaceObjectDefPerPlayer(IDFarBerry, false, 2);
	rmPlaceObjectDefPerPlayer(IDFarPredator, false, 2);
	rmPlaceObjectDefPerPlayer(IDFarPredator2, false, rmRandInt(1.0, 2.0));

	if (cMapSize == 2) {
		rmPlaceObjectDefPerPlayer(IDGiantGold, false, rmRandInt(1.0, 2.0));
		rmPlaceObjectDefPerPlayer(IDGiantHunt, false, 1);
		rmPlaceObjectDefPerPlayer(IDGiantGoat, false, rmRandInt(1.0, 2.0));
		rmPlaceObjectDefPerPlayer(IDGiantPredator, false, 1);
	}

	rmSetStatusText("",0.78);
	// FORESTS.

	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 8.0);
	int forestCount=10*cNumberNonGaiaPlayers;
	failCount=0;

	for(i=0; <forestCount)
	{
		int forestID		= rmCreateArea("forest"+i);
		if (cNumberNonGaiaPlayers > 8) {
		rmSetAreaSize		(forestID, rmAreaTilesToFraction(100*mapSizeMultiplier), rmAreaTilesToFraction(200*mapSizeMultiplier));
		} else {
		rmSetAreaSize		(forestID, rmAreaTilesToFraction(60*mapSizeMultiplier), rmAreaTilesToFraction(125*mapSizeMultiplier));
		}
		rmSetAreaWarnFailure(forestID, false);
		rmSetAreaForestType (forestID, "hades forest");
		rmAddAreaConstraint (forestID, AvoidSettlementAbit);
		rmAddAreaConstraint (forestID, AvoidStartingSettlement);
		rmAddAreaConstraint (forestID, forestObjConstraint);
		rmAddAreaConstraint (forestID, AvoidForestMedium);
		rmAddAreaConstraint (forestID, AvoidCenter);
		rmAddAreaConstraint (forestID, AvoidLava);
		rmAddAreaToClass	(forestID, classForest);

		rmSetAreaMinBlobs(forestID, 1);
		rmSetAreaMaxBlobs(forestID, 2);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 25.0);
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

	rmSetStatusText("",0.85);

	///BEAUTIFICATION

	//Center relic
	int RelicAreaID=0;
	int RelicID=0;

	for(i=0; <1*cNumberNonGaiaPlayers*mapSizeMultiplier)
	{
		RelicAreaID				=rmCreateArea("relicarea "+i);
		rmSetAreaSize			(RelicAreaID, rmAreaTilesToFraction(15), rmAreaTilesToFraction(20));
		rmSetAreaTerrainType	(RelicAreaID, "HadesBuildable1");
		rmSetAreaWarnFailure	(RelicAreaID, false);
		rmSetAreaCoherence		(RelicAreaID, 1.0);
		rmAddAreaConstraint		(RelicAreaID, AvoidLava);
		rmAddAreaToClass		(RelicAreaID, classRelic);
		rmAddAreaConstraint		(RelicAreaID, AvoidSettlementAbit);
		rmAddAreaConstraint		(RelicAreaID, AvoidRelic);
		rmAddAreaConstraint		(RelicAreaID, AvoidEdgeMed);
		rmAddAreaConstraint		(RelicAreaID, AvoidAll);

		rmBuildArea(RelicAreaID);

		RelicID					 =rmCreateObjectDef("relic "+i);
		rmAddObjectDefItem		 (RelicID, "relic", 1, 2);
		rmAddObjectDefItem		 (RelicID, "taproot small", rmRandInt(1.0,3.0), 4);
		rmSetObjectDefMinDistance(RelicID, 0.0);
		rmSetObjectDefMaxDistance(RelicID, 0.0);
		rmAddObjectDefConstraint (RelicID, AvoidPlayerFar);
		rmAddObjectDefConstraint (RelicID, AvoidLava);
		rmAddObjectDefConstraint (RelicID, AvoidAll);
		rmPlaceObjectDefAtAreaLoc(RelicID, 0, rmAreaID("relicarea "+i), 1);

	}


	int farHarpyID				=rmCreateObjectDef("far birds");
	rmAddObjectDefItem			(farHarpyID, "harpy", 1, 0.0);
	rmSetObjectDefMinDistance	(farHarpyID, 0.0);
	rmSetObjectDefMaxDistance	(farHarpyID, rmXFractionToMeters(0.5));
	rmPlaceObjectDefPerPlayer	(farHarpyID, false, 3*mapSizeMultiplier);

	int IDRune				 	 = rmCreateObjectDef("runestone");
	rmAddObjectDefItem		 	 (IDRune, "runestone", 1, 0.0);
	rmSetObjectDefMinDistance	 (IDRune, 0.0);
	rmSetObjectDefMaxDistance	 (IDRune, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint 	 (IDRune, AvoidAll);
	rmAddObjectDefConstraint 	 (IDRune, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint 	 (IDRune, rmCreateTypeDistanceConstraint("Rune vs Rune", "runestone", 50.0));
	rmPlaceObjectDefAtLoc	 	 (IDRune, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDStalagmite		 	 = rmCreateObjectDef("stalagmite");
	rmAddObjectDefItem		 	 (IDStalagmite, "stalagmite", rmRandInt(1.0,3.0), 2.0);
	rmSetObjectDefMinDistance	 (IDStalagmite, 0.0);
	rmSetObjectDefMaxDistance	 (IDStalagmite, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint 	 (IDStalagmite, AvoidAll);
	rmAddObjectDefConstraint 	 (IDStalagmite, AvoidSettlementSlightly);
	rmAddObjectDefConstraint 	 (IDStalagmite, rmCreateTypeDistanceConstraint("Stalagmite ", "stalagmite", 50.0));
	rmPlaceObjectDefAtLoc	 	 (IDStalagmite, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDFog				 	 = rmCreateObjectDef("fog");
	rmAddObjectDefItem		 	 (IDFog, "mist", 1, 0.0);
	rmSetObjectDefMinDistance	 (IDFog, 0.0);
	rmSetObjectDefMaxDistance	 (IDFog, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint 	 (IDFog, AvoidAll);
	rmAddObjectDefConstraint 	 (IDFog, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint 	 (IDFog, AvoidEdgeMed);
	rmAddObjectDefConstraint 	 (IDFog, rmCreateTypeDistanceConstraint("fog vs fog", "mist", 70.0));
	rmPlaceObjectDefAtLoc	 	 (IDFog, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDRock				 	 = rmCreateObjectDef("rock");
	rmAddObjectDefItem		 	 (IDRock, "rock limestone sprite", 1, 0.0);
	rmSetObjectDefMinDistance	 (IDRock, 0.0);
	rmSetObjectDefMaxDistance	 (IDRock, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint 	 (IDRock, AvoidAll);
	rmPlaceObjectDefAtLoc	 	 (IDRock, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers*mapSizeMultiplier);

	rmSetStatusText("",0.90);

	//Straggler trees
	rmPlaceObjectDefAtLoc(IDStragglerTrees, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers*mapSizeMultiplier);
	rmPlaceObjectDefAtLoc(IDStragglerTrees2, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers*mapSizeMultiplier);

	// RM X Finalize.
	rmxFinalize();

	rmSetStatusText("",1.00);
}