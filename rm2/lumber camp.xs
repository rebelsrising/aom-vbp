/* The Lumber Camp
** Created by Hagrit
** Initial design by Keen_Flame
** Version 1.00.
*/

// VBP 5.0

include "rmx 5-0-0.xs";

void main()
{

	// RM X Setup.
	rmxInit("Lumber Camp (by Hagrit & Flame)", false, false, false);

	rmSetStatusText("",0.01);
	int mapSizeMultiplier = 1;
	int PlayerTiles=5750;
	if(cMapSize == 1)
	{
		PlayerTiles = 7500;
		rmEchoInfo("Large map");
	}
	if(cMapSize == 2)
	{
		PlayerTiles = 12000;
		mapSizeMultiplier = 2;
	}

	rmSetLightingSet("Default");
	rmSetGaiaCiv(cCivZeus);

	float flipSide = rmRandFloat(0, 1);

	int sizel=0;
	int sizew=0;

	if (cNumberNonGaiaPlayers < 3)
	{
		if(flipSide>0.50)
		{
			sizel=3.0*sqrt(cNumberNonGaiaPlayers*PlayerTiles);
			sizew=2.5*sqrt(cNumberNonGaiaPlayers*PlayerTiles);
		}
		else
		{
			sizew=3.0*sqrt(cNumberNonGaiaPlayers*PlayerTiles);
			sizel=2.5*sqrt(cNumberNonGaiaPlayers*PlayerTiles);
		}
	} else {

	sizew=2.5*sqrt(cNumberNonGaiaPlayers*PlayerTiles);
	sizel=2.5*sqrt(cNumberNonGaiaPlayers*PlayerTiles);
	}

	rmEchoInfo("Map size="+sizel+"m x "+sizew+"m");
	rmSetMapSize(sizel, sizew);

	rmTerrainInitialize("GrassB");
	rmSetStatusText("",0.09);

		/// DEFINE CLASSES
	int classPlayer      		= rmDefineClass("player");
	int classStartingSettlement = rmDefineClass("starting settlement");
	int classRiver 				= rmDefineClass("center river");
	int classForest 			= rmDefineClass("forests");
	int classWoodPile			= rmDefineClass("woodpile");
	int classCenter				= rmDefineClass("center");

	rmSetStatusText("",0.15);

	/// CONSTRAINTS
	int AvoidEdgeShort				= rmCreateBoxConstraint			 ("edge of map", rmXTilesToFraction(4), rmZTilesToFraction(4), 1.0-rmXTilesToFraction(4), 1.0-rmZTilesToFraction(4));
	int AvoidEdgesSwamp				= rmCreateBoxConstraint			 ("swamp", 0.13, 0.43, 0.87, 0.57, 0.01);
	int AvoidEdgesSwamp2			= rmCreateBoxConstraint			 ("swamp2", 0.57, 0.90, 0.43, 0.13 , 0.01);
	int AvoidEdgeMed				= rmCreateBoxConstraint			 ("edge of map further", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0-rmXTilesToFraction(8), 1.0-rmZTilesToFraction(8));
	int AvoidEdgeLong				= rmCreateBoxConstraint			 ("edge of map furtherest", rmXTilesToFraction(50), rmZTilesToFraction(50), 1.0-rmXTilesToFraction(50), 1.0-rmZTilesToFraction(50));

	int AvoidSettlementSlightly 	= rmCreateTypeDistanceConstraint ("0", "AbstractSettlement", 10.0);
	int AvoidSettlementAbit		 	= rmCreateTypeDistanceConstraint ("1", "AbstractSettlement", 20.0);
	int AvoidSettlementSomewhat 	= rmCreateTypeDistanceConstraint ("2", "AbstractSettlement", 32.0);
	int AvoidSettlementHOLYFUCK 	= rmCreateTypeDistanceConstraint ("3", "AbstractSettlement", 90.0);
	int AvoidPlayer 				= rmCreateClassDistanceConstraint("4", classPlayer, 15.0);
	int AvoidPlayerShort 			= rmCreateClassDistanceConstraint("5", classPlayer, 1.0);
	int AvoidPlayerFar	 			= rmCreateClassDistanceConstraint("shit", classPlayer, 50.0);
	int AvoidOtherTower				= rmCreateTypeDistanceConstraint ("6", "tower", 25.0);
	int AvoidGoldFar				= rmCreateTypeDistanceConstraint ("fuck", "gold", 40.0);
	int AvoidGoldShort				= rmCreateTypeDistanceConstraint ("7", "gold", 10.0);
	int AvoidStartingTower			= rmCreateTypeDistanceConstraint ("8", "tower", 34.0);
	int AvoidFoodShort				= rmCreateTypeDistanceConstraint ("9", "food", 20.0);
	int AvoidFoodFar				= rmCreateTypeDistanceConstraint ("10", "food", 50.0);

	int AvoidFish					= rmCreateTypeDistanceConstraint ("fish v fish", "fish", 18.0);
	int AvoidLand 					= rmCreateTerrainDistanceConstraint("fish land", "land", true, 6.0);
	int AvoidWater 					= rmCreateTerrainDistanceConstraint("tc water", "water", true, 30.0);
	int AvoidWaterShort 			= rmCreateTerrainDistanceConstraint("avoid water short", "water", true, 8.0);
	int AvoidForestMedium			= rmCreateClassDistanceConstraint ("17", classForest, 23.0);
	int AvoidWoodPile				= rmCreateClassDistanceConstraint ("18", classWoodPile, 70.0);
	int AvoidCenter					= rmCreateClassDistanceConstraint ("19", classCenter, 3.0);

	int AvoidAll					= rmCreateTypeDistanceConstraint  ("22", "all", 4.0);
	int AvoidAllShort				= rmCreateTypeDistanceConstraint  ("24", "all", 2.0);
	int NearShore					= rmCreateTerrainMaxDistanceConstraint("near shore", "water", true, 10.0);
	int NearShoreLong				= rmCreateTerrainMaxDistanceConstraint("near shore long", "water", true, 25.0);

	int AvoidEdgesSwamp2v21			= rmCreateBoxConstraint			 ("swamp2v21", 0.20, 0.26, 0.80, 0.36, 0.01);
	int AvoidEdgesSwamp2v22			= rmCreateBoxConstraint			 ("swamp2v22", 0.20, 0.74, 0.80, 0.64 , 0.01);
	int AvoidEdgesSwamp3v31			= rmCreateBoxConstraint			 ("swamp3v31", 0.18, 0.26, 0.82, 0.36, 0.01);
	int AvoidEdgesSwamp3v32			= rmCreateBoxConstraint			 ("swamp3v32", 0.18, 0.64, 0.82, 0.74 , 0.01);

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

	int IDStartingGoldmine    = rmCreateObjectDef("starting goldmine");
	rmAddObjectDefItem        (IDStartingGoldmine, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance (IDStartingGoldmine, 20.0);
	rmSetObjectDefMaxDistance (IDStartingGoldmine, 24.0);
	rmAddObjectDefConstraint  (IDStartingGoldmine, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingGoldmine, AvoidWaterShort);

	int IDStartingHunt	 	  = rmCreateObjectDef("starting deer");
	rmAddObjectDefItem        (IDStartingHunt, "deer", rmRandInt(5.0, 9.0), 4);
	rmSetObjectDefMinDistance (IDStartingHunt, 23.0);
	rmSetObjectDefMaxDistance (IDStartingHunt, 27.0);
	rmAddObjectDefConstraint  (IDStartingHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingHunt, AvoidAll);

	int IDStartFish				=rmCreateObjectDef("start fish");
	rmAddObjectDefItem			(IDStartFish, "fish - perch", 2, 7.0);
	rmSetObjectDefMinDistance	(IDStartFish, 35.0);
	rmSetObjectDefMaxDistance	(IDStartFish, 40.0+(cNumberNonGaiaPlayers*2));
	rmAddObjectDefConstraint	(IDStartFish, AvoidFish);
	rmAddObjectDefConstraint	(IDStartFish, AvoidLand);

	int IDStartingBerry 	  = rmCreateObjectDef("starting berry");
	rmAddObjectDefItem        (IDStartingBerry, "berry bush", rmRandInt(2.0, 3.0), 5);
	rmSetObjectDefMinDistance (IDStartingBerry, 23.0);
	rmSetObjectDefMaxDistance (IDStartingBerry, 28.0);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidAll);

	int IDStartingHerdable 	  = rmCreateObjectDef("starting herd");
	rmAddObjectDefItem        (IDStartingHerdable, "Cow", rmRandInt(2.0, 3.0), 4);
	rmSetObjectDefMinDistance (IDStartingHerdable, 23.0);
	rmSetObjectDefMaxDistance (IDStartingHerdable, 28.0);
	rmAddObjectDefConstraint  (IDStartingHerdable, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingHerdable, AvoidAll);

	int IDStragglerTrees 	  = rmCreateObjectDef("straggler trees");
	rmAddObjectDefItem        (IDStragglerTrees, "oak tree", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTrees, 13.0);
	rmSetObjectDefMaxDistance (IDStragglerTrees, 16.0);

	int IDStragglerTrees2 	  = rmCreateObjectDef("straggler trees2");
	rmAddObjectDefItem        (IDStragglerTrees2, "pine", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTrees2, 13.0);
	rmSetObjectDefMaxDistance (IDStragglerTrees2, 16.0);


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
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidPlayer);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidWater);

	int IDWaterHunt		 	  = rmCreateObjectDef("water huntable");
	rmAddObjectDefItem        (IDWaterHunt, "Aurochs", rmRandInt(3.0, 4.0), 4.0);
	rmSetObjectDefMinDistance (IDWaterHunt, 60.0);
	rmSetObjectDefMaxDistance (IDWaterHunt, 90.0);
	rmAddObjectDefConstraint  (IDWaterHunt, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDWaterHunt, AvoidAll);
	rmAddObjectDefConstraint  (IDWaterHunt, AvoidStartingTower);
	rmAddObjectDefConstraint  (IDWaterHunt, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDWaterHunt, NearShore);

	int IDMediumHerd	 	  = rmCreateObjectDef("medium herd");
	rmAddObjectDefItem        (IDMediumHerd, "Cow", 2, 4.0);
	rmSetObjectDefMinDistance (IDMediumHerd, 60.0);
	rmSetObjectDefMaxDistance (IDMediumHerd, 90.0);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidAll);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidFoodShort);

	rmSetStatusText("",0.36);
	///FAR OBJECTS

	int IDFarBoar		 	  = rmCreateObjectDef("boars");
	rmAddObjectDefItem        (IDFarBoar, "Boar", rmRandInt(4.0, 6.0), 4.0);
	rmSetObjectDefMinDistance (IDFarBoar, 90.0);
	rmSetObjectDefMaxDistance (IDFarBoar, 110.0);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidAll);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidFoodFar);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidWater);

	int IDFarDeer		 	  = rmCreateObjectDef("deers");
	rmAddObjectDefItem        (IDFarDeer, "Deer", rmRandInt(7.0, 8.0), 4.0);
	rmSetObjectDefMinDistance (IDFarDeer, 100.0);
	rmSetObjectDefMaxDistance (IDFarDeer, 120.0);
	rmAddObjectDefConstraint  (IDFarDeer, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarDeer, AvoidAll);
	rmAddObjectDefConstraint  (IDFarDeer, AvoidFoodFar);
	rmAddObjectDefConstraint  (IDFarDeer, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDFarDeer, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarDeer, AvoidWater);

	int IDFarPred		 	  = rmCreateObjectDef("bear");
	rmAddObjectDefItem        (IDFarPred, "Bear", rmRandInt(1.0, 2.0), 4.0);
	rmSetObjectDefMinDistance (IDFarPred, 80.0);
	rmSetObjectDefMaxDistance (IDFarPred, 120.0);
	rmAddObjectDefConstraint  (IDFarPred, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarPred, AvoidAll);
	rmAddObjectDefConstraint  (IDFarPred, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDFarPred, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarPred, AvoidWater);

	int IDFarGold		 	  = rmCreateObjectDef("far gold");
	rmAddObjectDefItem        (IDFarGold, "gold mine", 1, 1);
	rmSetObjectDefMinDistance (IDFarGold, 80.0);
	rmSetObjectDefMaxDistance (IDFarGold, 100.0);
	rmAddObjectDefConstraint  (IDFarGold, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDFarGold, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDFarGold, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarGold, AvoidAll);
	rmAddObjectDefConstraint  (IDFarGold, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarGold, NearShoreLong);
	rmAddObjectDefConstraint  (IDFarGold, AvoidWaterShort);

	int IDFarGold2		 	  = rmCreateObjectDef("far gold2");
	rmAddObjectDefItem        (IDFarGold2, "gold mine", 1, 1);
	rmSetObjectDefMinDistance (IDFarGold2, 100.0);
	rmSetObjectDefMaxDistance (IDFarGold2, 130.0+(cNumberNonGaiaPlayers*2));
	rmAddObjectDefConstraint  (IDFarGold2, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidAll);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidWater);

	rmSetStatusText("",0.42);
	// OTHER


	int IDPerch					=rmCreateObjectDef("perch");
	rmAddObjectDefItem			(IDPerch, "fish - perch", 2, 9.0);
	rmSetObjectDefMinDistance	(IDPerch, 0.0);
	rmSetObjectDefMaxDistance	(IDPerch, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDPerch, AvoidFish);
	rmAddObjectDefConstraint	(IDPerch, AvoidLand);

	int IDMahi					=rmCreateObjectDef("mahi");
	rmAddObjectDefItem			(IDMahi, "fish - mahi", 1, 0.0);
	rmSetObjectDefMinDistance	(IDMahi, 0.0);
	rmSetObjectDefMaxDistance	(IDMahi, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDMahi, AvoidFish);
	rmAddObjectDefConstraint	(IDMahi, AvoidLand);

	rmSetStatusText("",0.50);

		/// DEFINE PLAYER LOCATIONS

	if(cNumberNonGaiaPlayers < 3) {
		if (flipSide < 0.50) {
		rmPlacePlayersLine(0.50, 1.10, 0.50, 0.10);
		} else
		rmPlacePlayersLine(0.10, 0.40, 0.90, 0.41);
	}
	if(cNumberNonGaiaPlayers < 5) {
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.10, 0.29, 0.10, 0.71, 0, 10); /* x z x2 z2 */
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.90, 0.29, 0.90, 0.71, 0, 10);
	}
	if(cNumberTeams < 3)
	{
		rmSetPlacementTeam(0);
		rmPlacePlayersLine(0.10, 0.15, 0.10, 0.85, 5, 10); /* x z x2 z2 */
		rmSetPlacementTeam(1);
		rmPlacePlayersLine(0.90, 0.15, 0.90, 0.85, 5, 10);
	}
	else
	{
		rmPlacePlayersCircular(0.35, 0.4, rmDegreesToRadians(5.0));
	}

	rmSetStatusText("",0.58);
	   /// TERRAIN DEFINITION
	float playerFraction=rmAreaTilesToFraction(800*mapSizeMultiplier);
	for(i=1; <cNumberPlayers)
	{
		int AreaPlayer =rmCreateArea("Player"+i);

		rmSetPlayerArea			(i, AreaPlayer);
		rmSetAreaSize			(AreaPlayer, playerFraction, playerFraction);
		rmAddAreaToClass		(AreaPlayer, classPlayer);
		rmSetAreaCoherence		(AreaPlayer, 0.0);
		rmSetAreaCliffType		(AreaPlayer, "Greek");
		rmSetAreaCliffEdge		(AreaPlayer, 2, 0.0, 0.0, 1.0, 1);
		rmSetAreaCliffHeight	(AreaPlayer, 0, 0.0, 1);
		rmSetAreaSmoothDistance (AreaPlayer, 20);
		rmSetAreaLocPlayer		(AreaPlayer, i);
		rmSetAreaTerrainType	(AreaPlayer, "MarshB");
		rmAddAreaTerrainLayer	(AreaPlayer, "MarshA", 6, 8);
		rmAddAreaTerrainLayer	(AreaPlayer, "MarshE", 4, 6);
		rmAddAreaTerrainLayer	(AreaPlayer, "MarshD", 2, 4);
		rmAddAreaTerrainLayer	(AreaPlayer, "GrassB", 0, 2);

	}
	rmBuildAllAreas();

	if (cNumberNonGaiaPlayers> 2) {
	int IDCenter			=rmCreateArea("CenterArea");
	rmSetAreaSize			(IDCenter, 0.25, 0.25);
	rmSetAreaLocation		(IDCenter, 0.5, 0.5);
	rmAddAreaToClass		(IDCenter, classCenter);
	rmAddAreaConstraint		(IDCenter, AvoidPlayerShort);
	rmAddAreaConstraint		(IDCenter, AvoidEdgeLong);
	rmAddAreaToClass		(IDCenter, classCenter);
	//rmSetAreaTerrainType	(IDCenter, "SnowB");
	rmSetAreaCoherence		(IDCenter, 1.0);

	rmBuildArea(IDCenter);
	}

	if (cNumberNonGaiaPlayers < 3) {
	int swampID				=rmCreateArea("center");
	rmSetAreaSize			(swampID, 0.09, 0.09);
	rmSetAreaLocation		(swampID, 0.5, 0.5);
	rmSetAreaWaterType		(swampID, "greek river");
	rmAddAreaToClass		(swampID, classRiver);
	rmAddAreaConstraint		(swampID, AvoidPlayerShort);
	if (flipSide < 0.50) {
	rmAddAreaConstraint		(swampID, AvoidEdgesSwamp2);
	} else {
	rmAddAreaConstraint		(swampID, AvoidEdgesSwamp);
	}
	rmSetAreaBaseHeight		(swampID, 1.0);
	rmSetAreaMinBlobs		(swampID, 5);
	rmSetAreaMaxBlobs		(swampID, 15);
	rmSetAreaMinBlobDistance(swampID, 20);
	rmSetAreaMaxBlobDistance(swampID, 40);
	rmSetAreaSmoothDistance	(swampID, 0);
	rmSetAreaCoherence		(swampID, 0.0);

	rmBuildArea(swampID);

	} else if (cNumberNonGaiaPlayers < 5) {
	int swampID3				=rmCreateArea("center3");
	rmSetAreaSize			(swampID3, 0.05, 0.05);
	rmSetAreaLocation		(swampID3, 0.5, 0.3);
	rmSetAreaWaterType		(swampID3, "greek river");
	rmAddAreaToClass		(swampID3, classRiver);
	rmAddAreaConstraint		(swampID3, AvoidPlayerShort);
	rmAddAreaConstraint		(swampID3, AvoidEdgesSwamp2v21);
	rmSetAreaBaseHeight		(swampID3, 1.0);
	rmSetAreaMinBlobs		(swampID3, 5);
	rmSetAreaMaxBlobs		(swampID3, 15);
	rmSetAreaMinBlobDistance(swampID3, 20);
	rmSetAreaMaxBlobDistance(swampID3, 40);
	rmSetAreaSmoothDistance	(swampID3, 0);
	rmSetAreaCoherence		(swampID3, 0.0);

	int swampID4				=rmCreateArea("center4");
	rmSetAreaSize			(swampID4, 0.05, 0.05);
	rmSetAreaLocation		(swampID4, 0.5, 0.7);
	rmSetAreaWaterType		(swampID4, "greek river");
	rmAddAreaToClass		(swampID4, classRiver);
	rmAddAreaConstraint		(swampID4, AvoidPlayerShort);
	rmAddAreaConstraint		(swampID4, AvoidEdgesSwamp2v22);
	rmSetAreaBaseHeight		(swampID4, 1.0);
	rmSetAreaMinBlobs		(swampID4, 5);
	rmSetAreaMaxBlobs		(swampID4, 15);
	rmSetAreaMinBlobDistance(swampID4, 20);
	rmSetAreaMaxBlobDistance(swampID4, 40);
	rmSetAreaSmoothDistance	(swampID4, 0);
	rmSetAreaCoherence		(swampID4, 0.0);

	rmBuildArea(swampID3);
	rmBuildArea(swampID4);

	} else if (cNumberNonGaiaPlayers < 13) {
	int swampID1				=rmCreateArea("center1");
	rmSetAreaSize			(swampID1, 0.06, 0.06);
	rmSetAreaLocation		(swampID1, 0.5, 0.35);
	rmSetAreaWaterType		(swampID1, "greek river");
	rmAddAreaToClass		(swampID1, classRiver);
	rmAddAreaConstraint		(swampID1, AvoidPlayerShort);
	rmAddAreaConstraint		(swampID1, AvoidEdgesSwamp3v31);
	rmSetAreaBaseHeight		(swampID1, 1.0);
	rmSetAreaMinBlobs		(swampID1, 5);
	rmSetAreaMaxBlobs		(swampID1, 15);
	rmSetAreaMinBlobDistance(swampID1, 20);
	rmSetAreaMaxBlobDistance(swampID1, 40);
	rmSetAreaSmoothDistance	(swampID1, 0);
	rmSetAreaCoherence		(swampID1, 0.0);

	int swampID2				=rmCreateArea("center2");
	rmSetAreaSize			(swampID2, 0.06, 0.06);
	rmSetAreaLocation		(swampID2, 0.5, 0.65);
	rmSetAreaWaterType		(swampID2, "greek river");
	rmAddAreaToClass		(swampID2, classRiver);
	rmAddAreaConstraint		(swampID2, AvoidPlayerShort);
	rmAddAreaConstraint		(swampID2, AvoidEdgesSwamp3v32);
	rmSetAreaBaseHeight		(swampID2, 1.0);
	rmSetAreaMinBlobs		(swampID2, 5);
	rmSetAreaMaxBlobs		(swampID2, 15);
	rmSetAreaMinBlobDistance(swampID2, 20);
	rmSetAreaMaxBlobDistance(swampID2, 40);
	rmSetAreaSmoothDistance	(swampID2, 0);
	rmSetAreaCoherence		(swampID2, 0.0);

	rmBuildArea(swampID1);
	rmBuildArea(swampID2);
	}

	int failCount = 0;
	int numTries = 0;

	rmSetStatusText("",0.67);
		///SETTLEMENTS
	rmPlaceObjectDefPerPlayer(IDStartingSettlement, true);

	if (cNumberNonGaiaPlayers<3 ) {
	int SettleArea=rmAddFairLoc("Settlement", true, false,  80, 100, 140, 45);
	rmAddFairLocConstraint(SettleArea, AvoidWater);

	SettleArea=rmAddFairLoc("Settlement", true, false,  100, 130, 140, 45);
	rmAddFairLocConstraint(SettleArea, AvoidWater);
	} else if (cNumberNonGaiaPlayers < 5 ) {
	SettleArea=rmAddFairLoc("Settlement", false, true,  60, 90, 50, 20);
	rmAddFairLocConstraint(SettleArea, AvoidWater);
	rmAddFairLocConstraint(SettleArea, AvoidCenter);

	SettleArea=rmAddFairLoc("Settlement", true, false,  110, 140, 150, 45);
	rmAddFairLocConstraint(SettleArea, AvoidWater);
	rmAddFairLocConstraint(SettleArea, AvoidCenter);
	} else {
	SettleArea=rmAddFairLoc("Settlement", false, true,  60, 80, 60, 20);
	rmAddFairLocConstraint(SettleArea, AvoidWater);

	SettleArea=rmAddFairLoc("Settlement", true, false,  110, 140, 150, 45);
	rmAddFairLocConstraint(SettleArea, AvoidWater);
	}

	if (cMapSize == 2) {
	SettleArea=rmAddFairLoc("Settlement", true, false,  120, 170, 100, 45);
	rmAddFairLocConstraint(SettleArea, AvoidWater);

	SettleArea=rmAddFairLoc("Settlement", true, false,  120, 170, 100, 45);
	rmAddFairLocConstraint(SettleArea, AvoidWater);
	}


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

	rmSetStatusText("",0.72);
		/// ELEV

	numTries=10*cNumberNonGaiaPlayers*mapSizeMultiplier;
	failCount=0;
	for(i=0; <numTries)
	{
		int IDelev				=rmCreateArea("elev"+i);
		rmSetAreaSize			(IDelev, rmAreaTilesToFraction(100*mapSizeMultiplier), rmAreaTilesToFraction(200*mapSizeMultiplier));
		rmSetAreaWarnFailure	(IDelev, false);
		rmAddAreaConstraint		(IDelev, AvoidWaterShort);
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

	for(i=0; <numTries)
	{
		int IDMarshArea			=rmCreateArea("marsharea"+i);
		rmSetAreaSize			(IDMarshArea, rmAreaTilesToFraction(150*mapSizeMultiplier), rmAreaTilesToFraction(200*mapSizeMultiplier));
		rmSetAreaWarnFailure	(IDMarshArea, false);
		rmAddAreaConstraint		(IDMarshArea, AvoidPlayer);
		rmAddAreaConstraint		(IDMarshArea, AvoidWaterShort);
		rmSetAreaBaseHeight		(IDMarshArea, 2);
		rmSetAreaTerrainType	(IDMarshArea, "MarshE");
		rmAddAreaTerrainLayer	(IDMarshArea, "MarshD", 0, 2);
		rmSetAreaHeightBlend	(IDMarshArea, 2);
		rmSetAreaMinBlobs		(IDMarshArea, 1);
		rmSetAreaMaxBlobs		(IDMarshArea, 5);
		rmSetAreaMinBlobDistance(IDMarshArea, 16.0);
		rmSetAreaMaxBlobDistance(IDMarshArea, 40.0);
		rmSetAreaCoherence		(IDMarshArea, 0.5);

		if(rmBuildArea(IDMarshArea)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}

	rmSetStatusText("",0.78);
		/// PLACE PLAYER OBJECTS
	rmPlaceObjectDefPerPlayer(IDStartingTower, true, 4);
	rmPlaceObjectDefPerPlayer(IDStartingGoldmine, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingHunt, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartFish, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingBerry, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingHerdable, true, 1);
	rmPlaceObjectDefPerPlayer(IDStragglerTrees, true, rmRandInt(4.0,9.0));
	rmPlaceObjectDefPerPlayer(IDStragglerTrees2, true, rmRandInt(4.0,9.0));

	rmPlaceObjectDefPerPlayer(IDMediumGoldmine, false, 1);
	rmPlaceObjectDefPerPlayer(IDWaterHunt, false, rmRandInt(1.0, 2.0));
	rmPlaceObjectDefPerPlayer(IDMediumHerd, false, 2);

	rmPlaceObjectDefPerPlayer(IDFarBoar, false, rmRandInt(1.0, 2.0));
	rmPlaceObjectDefPerPlayer(IDFarDeer, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarGold, false, 2);
	rmPlaceObjectDefPerPlayer(IDFarGold2, false, 2);
	rmPlaceObjectDefPerPlayer(IDFarPred, false, 1);

	rmPlaceObjectDefPerPlayer(IDPerch, false, 3);
	rmPlaceObjectDefPerPlayer(IDMahi, false, 2);


	rmSetStatusText("",0.84);
		/// FOREST

	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 8.0);
	int forestCount=15*cNumberNonGaiaPlayers;
	failCount=0;

	for(i=0; <forestCount)
	{
		int forestID			= rmCreateArea("forest"+i);
		rmSetAreaSize			(forestID, rmAreaTilesToFraction(100*mapSizeMultiplier), rmAreaTilesToFraction(200*mapSizeMultiplier));
		rmSetAreaWarnFailure	(forestID, false);
		rmSetAreaForestType 	(forestID, "mixed oak forest");
		rmAddAreaConstraint 	(forestID, AvoidSettlementAbit);
		rmAddAreaConstraint 	(forestID, forestObjConstraint);
		rmAddAreaConstraint 	(forestID, AvoidForestMedium);
		rmAddAreaConstraint 	(forestID, AvoidWaterShort);
		rmAddAreaToClass		(forestID, classForest);

		rmSetAreaMinBlobs		(forestID, 1);
		rmSetAreaMaxBlobs		(forestID, 2);
		rmSetAreaMinBlobDistance(forestID, 16.0);
		rmSetAreaMaxBlobDistance(forestID, 22.0);
		rmSetAreaCoherence		(forestID, 0.1);

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
	rmSetStatusText("",0.90);
		/// BEAUTIFICATION
	int IDLog					=rmCreateObjectDef("log");
	rmAddObjectDefItem			(IDLog, "rotting log", 1, 0.0);
	rmAddObjectDefItem			(IDLog, "bush", rmRandInt(0,1), 3.0);
	rmAddObjectDefItem			(IDLog, "grass", rmRandInt(6,8), 6.0);
	rmSetObjectDefMinDistance	(IDLog, 0.0);
	rmSetObjectDefMaxDistance	(IDLog, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDLog, AvoidAll);
	rmAddObjectDefConstraint	(IDLog, AvoidWaterShort);
	rmPlaceObjectDefAtLoc		(IDLog, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDWoodPile				=rmCreateObjectDef("woodpile");
	rmAddObjectDefItem			(IDWoodPile, "relic", 1, 3.0);
	rmAddObjectDefItem			(IDWoodPile, "wood pile 1", rmRandInt(0,1), 5.0);
	rmAddObjectDefItem			(IDWoodPile, "wood pile 2", rmRandInt(0,1), 5.0);
	rmAddObjectDefItem			(IDWoodPile, "wood pile 3", rmRandInt(0,1), 5.0);
	rmSetObjectDefMinDistance	(IDWoodPile, 0.0);
	rmSetObjectDefMaxDistance	(IDWoodPile, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDWoodPile, AvoidAll);
	rmAddObjectDefConstraint	(IDWoodPile, AvoidPlayerFar);
	rmAddObjectDefConstraint	(IDWoodPile, AvoidSettlementAbit);
	rmAddObjectDefConstraint	(IDWoodPile, AvoidWoodPile);
	rmAddObjectDefConstraint	(IDWoodPile, AvoidWaterShort);
	rmAddObjectDefConstraint	(IDWoodPile, AvoidGoldShort);
	rmAddObjectDefToClass		(IDWoodPile, classWoodPile);
	rmPlaceObjectDefPerPlayer	(IDWoodPile, false, 1*mapSizeMultiplier);

	int IDStumpTheTrump			=rmCreateObjectDef("trumps cant be stumped");
	rmAddObjectDefItem			(IDStumpTheTrump, "Pine Stump", 1, 0.0);
	rmSetObjectDefMinDistance	(IDStumpTheTrump, 0.0);
	rmSetObjectDefMaxDistance	(IDStumpTheTrump, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDStumpTheTrump, AvoidAllShort);
	rmAddObjectDefConstraint	(IDStumpTheTrump, AvoidWaterShort);
	rmPlaceObjectDefAtLoc		(IDStumpTheTrump, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDRandomTree			=rmCreateObjectDef("random tree");
	rmAddObjectDefItem			(IDRandomTree, "oak tree", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRandomTree, 0.0);
	rmSetObjectDefMaxDistance	(IDRandomTree, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRandomTree, rmCreateTypeDistanceConstraint("random tree", "all", 3.0));
	rmAddObjectDefConstraint	(IDRandomTree, AvoidAll);
	rmAddObjectDefConstraint	(IDRandomTree, AvoidSettlementAbit);
	rmPlaceObjectDefAtLoc		(IDRandomTree, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDRandomPine			=rmCreateObjectDef("random pine");
	rmAddObjectDefItem			(IDRandomPine, "pine", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRandomPine, 0.0);
	rmSetObjectDefMaxDistance	(IDRandomPine, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRandomPine, rmCreateTypeDistanceConstraint("random pine", "all", 3.0));
	rmAddObjectDefConstraint	(IDRandomPine, AvoidAll);
	rmAddObjectDefConstraint	(IDRandomPine, AvoidSettlementAbit);
	rmPlaceObjectDefAtLoc		(IDRandomPine, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDRock					=rmCreateObjectDef("rock group");
	rmAddObjectDefItem			(IDRock, "rock limestone sprite", rmRandInt(1.0, 3.0), 4.0);
	rmSetObjectDefMinDistance	(IDRock, 0.0);
	rmSetObjectDefMaxDistance	(IDRock, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRock, AvoidAll);
	rmPlaceObjectDefAtLoc		(IDRock, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers*mapSizeMultiplier);

	// RM X Finalize.
	rmxFinalize();

	rmSetStatusText("",1.00);
}