/* Moat
** Hagrit
** Initial design by Keen_Flame
** Version 1.00.
*/

// VBP 5.0

include "rmx 5-0-0.xs";

void SetUpMap(int small = 5000, int big = 10000,int giant = 15000, float seaLevel = 2, string tileName = "GrassA")
{
	int PlayerTiles = small;
	if (cMapSize == 1)
		PlayerTiles = big;

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
	rmxInit("Moat (by Hagrit & Flame)", false, false, false);

	///INIT MAP

	SetUpMap(13500,16000,24000,2, "GrassA");
	int mapSizeMultiplier = 1;

	if (cMapSize == 2) {
		mapSizeMultiplier = 2;
	}

	rmSetStatusText("",0.07);

	int classRiver 		 = rmDefineClass("river");
	int classOuterLand 	 = rmDefineClass("outer land");
	int classInnerLand 	 = rmDefineClass("inner land");
	int classPlayer 	 = rmDefineClass("player");
	int classForest 	 = rmDefineClass("forest");
	int classStartingTC  = rmDefineClass("starting tc");
	int classBonusGold	 = rmDefineClass("bonus gold");

	rmSetStatusText("",0.13);

		///CONSTRAINTS
	int AvoidEdgeMed				= rmCreateBoxConstraint			 ("edge of map further", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10));
	int AvoidEdge					= rmCreateBoxConstraint			 ("edge of map", rmXTilesToFraction(4), rmZTilesToFraction(4), 1.0-rmXTilesToFraction(4), 1.0-rmZTilesToFraction(4));

	int AvoidSettlementSlightly 	= rmCreateTypeDistanceConstraint ("0", "AbstractSettlement", 10.0);
	int AvoidSettlementAbit		 	= rmCreateTypeDistanceConstraint ("1", "AbstractSettlement", 20.0);
	int AvoidSettlementSomewhat 	= rmCreateTypeDistanceConstraint ("2", "AbstractSettlement", 32.0);
	int AvoidOtherTower				= rmCreateTypeDistanceConstraint ("7", "tower", 25.0);
	int AvoidAll					= rmCreateTypeDistanceConstraint ("8", "all", 6.0);
	int AvoidGoldFar				= rmCreateTypeDistanceConstraint ("9", "gold", 35.0+cNumberNonGaiaPlayers);
	int AvoidGoldShort				= rmCreateTypeDistanceConstraint ("10", "gold", 8.0);
	int AvoidGoat					= rmCreateTypeDistanceConstraint ("11", "herdable", 25.0);
	int AvoidFoodShort				= rmCreateTypeDistanceConstraint ("13", "food", 20.0);
	int AvoidFood					= rmCreateTypeDistanceConstraint ("14", "food", 35.0);
	int AvoidFish					= rmCreateTypeDistanceConstraint ("15", "fish", 24.0);
	int AvoidPredator				= rmCreateTypeDistanceConstraint ("16", "bear", 24.0);
	int AvoidFishMore				= rmCreateTypeDistanceConstraint ("17", "fish", 32.0);


	int AvoidRiverShort				= rmCreateClassDistanceConstraint ("avoid river short", classRiver, 1.0);
	int AvoidRiverMed				= rmCreateClassDistanceConstraint ("avoid river long", classRiver, 10.0);
	int AvoidOuterLand				= rmCreateClassDistanceConstraint ("avoid outerland", classOuterLand, 27.0*mapSizeMultiplier);
	int AvoidInnerLand				= rmCreateClassDistanceConstraint ("avoid innerland", classInnerLand, 30.0);
	int AvoidOuterLandLong			= rmCreateClassDistanceConstraint ("avoid outerland long", classOuterLand, 40.0*mapSizeMultiplier);
	int AvoidOuterLandLongest		= rmCreateClassDistanceConstraint ("avoid outerland longest", classOuterLand, 60.0);
	int AvoidPlayer					= rmCreateClassDistanceConstraint ("avoid Player", classPlayer, 5.0);
	int AvoidForestMedium			= rmCreateClassDistanceConstraint ("17", classForest, 25.0);
	int AvoidStartingSettle			= rmCreateClassDistanceConstraint ("18", classStartingTC, 20.0);
	int AvoidBonusGold				= rmCreateClassDistanceConstraint ("19", classBonusGold, 100.0);

	int AvoidWater 					= rmCreateTerrainDistanceConstraint("tc water", "water", true, 28.0);
	int AvoidWaterShort 			= rmCreateTerrainDistanceConstraint("forest water", "water", true, 12.0);
	int AvoidWaterShortest 			= rmCreateTerrainDistanceConstraint("forest water2", "water", true, 4.0);
	int AvoidLand 					= rmCreateTerrainDistanceConstraint("fish land", "land", true, 5.0);

	int NearShore					= rmCreateTerrainMaxDistanceConstraint("near shore", "water", true, 8.0);

	rmSetStatusText("",0.22);
		/// OBJECT DEFINITION

	//STARTING OBJECTS
	int IDStartingSettlement  = rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem        (IDStartingSettlement, "Settlement Level 1", 1, 0.0);
	rmSetObjectDefMinDistance (IDStartingSettlement, 0.0);
	rmSetObjectDefMaxDistance (IDStartingSettlement, 0.0);
	rmAddObjectDefToClass     (IDStartingSettlement, classStartingTC);

	int IDStartingGoldmine    = rmCreateObjectDef("starting goldmine");
	rmAddObjectDefItem        (IDStartingGoldmine, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance (IDStartingGoldmine, 20.0);
	rmSetObjectDefMaxDistance (IDStartingGoldmine, 24.0);
	rmAddObjectDefConstraint  (IDStartingGoldmine, AvoidOuterLandLong);

	int IDStartingTower 	  = rmCreateObjectDef("starting towers");
	rmAddObjectDefItem        (IDStartingTower, "tower", 1, 0.0);
	rmAddObjectDefConstraint  (IDStartingTower, AvoidOtherTower);
	rmSetObjectDefMinDistance (IDStartingTower, 22.0);
	rmSetObjectDefMaxDistance (IDStartingTower, 26.0);

	int IDStartingBerry 	  = rmCreateObjectDef("starting berry");
	if (rmRandFloat(0.0, 1.0) < 0.5) {
	rmAddObjectDefItem        (IDStartingBerry, "berry bush", rmRandInt(3.0, 6.0), 4);
	} else {
	rmAddObjectDefItem        (IDStartingBerry, "chicken", rmRandInt(5.0, 9.0), 4);
	}
	rmSetObjectDefMinDistance (IDStartingBerry, 21.0);
	rmSetObjectDefMaxDistance (IDStartingBerry, 26.0);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidAll);

	float startingHuntable=rmRandFloat(0, 1);

	int IDStartingHunt		  = rmCreateObjectDef("starting hunt");
	if(startingHuntable<0.33)
	{
		rmAddObjectDefItem        (IDStartingHunt, "Deer", rmRandInt(3.0, 5.0), 4);
	} else if(startingHuntable<0.66)
		rmAddObjectDefItem        (IDStartingHunt, "Caribou", rmRandInt(5.0, 7.0), 4);
	else
		rmAddObjectDefItem        (IDStartingHunt, "Aurochs", 2, 3);
	rmSetObjectDefMinDistance (IDStartingHunt, 24.0);
	rmSetObjectDefMaxDistance (IDStartingHunt, 27.0);
	rmAddObjectDefConstraint  (IDStartingHunt, AvoidOuterLand);
	rmAddObjectDefConstraint  (IDStartingHunt, AvoidAll);

	int IDStartingHerd	 	  = rmCreateObjectDef("starting goat");
	rmAddObjectDefItem        (IDStartingHerd, "pig", rmRandInt(2,3), 4);
	rmSetObjectDefMinDistance (IDStartingHerd, 25.0);
	rmSetObjectDefMaxDistance (IDStartingHerd, 32.0);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidAll);

	int IDStragglerTree		  = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem		  (IDStragglerTree, "oak autumn", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTree, 12.0);
	rmSetObjectDefMaxDistance (IDStragglerTree, 15.0);

	int AvoidFishShort			= rmCreateTypeDistanceConstraint ("fish vs fish short", "fish", 9.0);

	int IDStartFish				=rmCreateObjectDef("start fish");
	rmAddObjectDefItem			(IDStartFish, "fish - perch", 2, 5.0);
	rmSetObjectDefMinDistance	(IDStartFish, 35.0);
	rmSetObjectDefMaxDistance	(IDStartFish, 50.0);
	rmAddObjectDefConstraint	(IDStartFish, AvoidFishShort);
	rmAddObjectDefConstraint	(IDStartFish, AvoidLand);

	// MEDIUM OBJECTS
	int IDMediumGoldmine 	  = rmCreateObjectDef("Medium goldmine");
	rmAddObjectDefItem        (IDMediumGoldmine, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance (IDMediumGoldmine, 50.0);
	rmSetObjectDefMaxDistance (IDMediumGoldmine, 60.0);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidSettlementAbit);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidAll);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidPlayer);
	rmAddObjectDefConstraint  (IDMediumGoldmine, AvoidOuterLandLong);

	int IDMediumHunt 	 	  = rmCreateObjectDef("Medium hunt");
	rmAddObjectDefItem        (IDMediumHunt, "Elk", (rmRandInt(5.0, 7.0)), 4.0);
	rmSetObjectDefMinDistance (IDMediumHunt, 55.0);
	rmSetObjectDefMaxDistance (IDMediumHunt, 60.0);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidSettlementAbit);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidFood);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidAll);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidOuterLandLong);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidPlayer);

	int IDMediumHerd 	 	  = rmCreateObjectDef("Medium herd");
	rmAddObjectDefItem        (IDMediumHerd, "pig", 2, 4.0);
	rmSetObjectDefMinDistance (IDMediumHerd, 65.0);
	rmSetObjectDefMaxDistance (IDMediumHerd, 80.0);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidOuterLandLong);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidGoat);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidAll);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidPlayer);

	int IDMediumFish			=rmCreateObjectDef("medium fish");
	rmAddObjectDefItem			(IDMediumFish, "fish - mahi", 2, 5.0);
	rmSetObjectDefMinDistance	(IDMediumFish, 50.0);
	rmSetObjectDefMaxDistance	(IDMediumFish, 75.0);
	rmAddObjectDefConstraint	(IDMediumFish, AvoidFish);
	rmAddObjectDefConstraint	(IDMediumFish, AvoidLand);

	// FAR OBJECTS

	int IDFarFish				=rmCreateObjectDef("far fish");
	rmAddObjectDefItem			(IDFarFish, "fish - mahi", 2, 6.0);
	rmSetObjectDefMinDistance	(IDFarFish, 0.0);
	rmSetObjectDefMaxDistance	(IDFarFish, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDFarFish, AvoidFishMore);
	rmAddObjectDefConstraint	(IDFarFish, AvoidLand);

	int IDFarPred		 	  	= rmCreateObjectDef("bear");
	rmAddObjectDefItem        	(IDFarPred, "bear", 2, 4.0);
	rmSetObjectDefMinDistance 	(IDFarPred, 80.0);
	rmSetObjectDefMaxDistance 	(IDFarPred, 110.0);
	rmAddObjectDefConstraint  	(IDFarPred, AvoidSettlementSlightly);
	rmAddObjectDefConstraint  	(IDFarPred, AvoidAll);
	rmAddObjectDefConstraint  	(IDFarPred, AvoidPlayer);
	rmAddObjectDefConstraint  	(IDFarPred, AvoidPredator);
	rmAddObjectDefConstraint  	(IDFarPred, AvoidOuterLand);

	int IDFarGoldmine 		  = rmCreateObjectDef("far goldmine");
	rmAddObjectDefItem        (IDFarGoldmine, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance (IDFarGoldmine, 65.0);
	rmSetObjectDefMaxDistance (IDFarGoldmine, 85.0);
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidSettlementAbit);
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidAll);
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarGoldmine, AvoidOuterLandLong);

	int IDFarHunt 	 		  = rmCreateObjectDef("far hunt");
	rmAddObjectDefItem        (IDFarHunt, "deer", (rmRandInt(7.0, 9.0)), 4.0);
	rmSetObjectDefMinDistance (IDFarHunt, 65.0);
	rmSetObjectDefMaxDistance (IDFarHunt, 90.0);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidSettlementAbit);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidFood);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidAll);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidOuterLandLong);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidPlayer);

	int IDShoreHunt 	 		= rmCreateObjectDef("hunt shore");
	rmAddObjectDefItem        (IDShoreHunt, "boar", (rmRandInt(3.0, 4.0)), 4.0);
	rmSetObjectDefMinDistance (IDShoreHunt, 60.0);
	rmSetObjectDefMaxDistance (IDShoreHunt, 100.0);
	rmAddObjectDefConstraint  (IDShoreHunt, AvoidSettlementAbit);
	rmAddObjectDefConstraint  (IDShoreHunt, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDShoreHunt, AvoidAll);
	rmAddObjectDefConstraint  (IDShoreHunt, AvoidOuterLand);
	rmAddObjectDefConstraint  (IDShoreHunt, AvoidPlayer);
	rmAddObjectDefConstraint  (IDShoreHunt, NearShore);

	int IDFarPig		 	  = rmCreateObjectDef("far pig");
	rmAddObjectDefItem        (IDFarPig, "pig", 2, 3);
	rmSetObjectDefMinDistance (IDFarPig, 80.0);
	rmSetObjectDefMaxDistance (IDFarPig, 120.0);
	rmAddObjectDefConstraint  (IDFarPig, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDFarPig, AvoidWaterShortest);
	rmAddObjectDefConstraint  (IDFarPig, AvoidOuterLand);
	rmAddObjectDefConstraint  (IDFarPig, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarPig, AvoidGoat);
	rmAddObjectDefConstraint  (IDFarPig, AvoidAll);

	//other
	int IDRandomTree			=rmCreateObjectDef("random tree");
	rmAddObjectDefItem			(IDRandomTree, "oak tree", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRandomTree, 0.0);
	rmSetObjectDefMaxDistance	(IDRandomTree, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRandomTree, rmCreateTypeDistanceConstraint("random tree", "all", 3.0));
	rmAddObjectDefConstraint	(IDRandomTree, AvoidAll);
	rmAddObjectDefConstraint	(IDRandomTree, AvoidWaterShortest);
	rmAddObjectDefConstraint	(IDRandomTree, AvoidSettlementAbit);

	int IDBonusGoldmine 	  	= rmCreateObjectDef("bonus goldmine");
	rmAddObjectDefItem        	(IDBonusGoldmine, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDBonusGoldmine, 0.0);
	rmSetObjectDefMaxDistance 	(IDBonusGoldmine, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint  	(IDBonusGoldmine, AvoidBonusGold);
	rmAddObjectDefToClass		(IDBonusGoldmine, classBonusGold);
	rmAddObjectDefConstraint  	(IDBonusGoldmine, AvoidAll);
	rmAddObjectDefConstraint  	(IDBonusGoldmine, AvoidPlayer);
	rmAddObjectDefConstraint  	(IDBonusGoldmine, AvoidInnerLand);
	rmAddObjectDefConstraint  	(IDBonusGoldmine, AvoidWaterShortest);
	rmAddObjectDefConstraint  	(IDBonusGoldmine, AvoidEdge);

	int IDRelic			 	  = rmCreateObjectDef("relics");
	rmAddObjectDefItem        (IDRelic, "Relic", 1, 3);
	rmAddObjectDefItem        (IDRelic, "fence stone", 1, 3);
	rmSetObjectDefMinDistance (IDRelic, 100.0);
	rmSetObjectDefMaxDistance (IDRelic, 150.0);
	rmAddObjectDefConstraint  (IDRelic, AvoidAll);
	rmAddObjectDefConstraint  (IDRelic, AvoidOuterLandLong);
	rmAddObjectDefConstraint  (IDRelic, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDRelic, rmCreateTypeDistanceConstraint("relic vs relic", "relic", 60.0));
	rmAddObjectDefConstraint  (IDRelic, AvoidPlayer);

	int IDRelicOutside		 	  = rmCreateObjectDef("relic outside");
	rmAddObjectDefItem        (IDRelicOutside, "Relic", 1, 1);
	rmSetObjectDefMinDistance (IDRelicOutside, 0.0);
	rmSetObjectDefMaxDistance (IDRelicOutside, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint  (IDRelicOutside, AvoidAll);
	rmAddObjectDefConstraint  (IDRelicOutside, AvoidInnerLand);
	rmAddObjectDefConstraint  (IDRelicOutside, AvoidWaterShortest);
	rmAddObjectDefConstraint  (IDRelicOutside, rmCreateTypeDistanceConstraint("relic vs relic outside", "relic", 120.0));

	if (cMapSize == 2){
		int IDShoreHuntGiant 	  = rmCreateObjectDef("hunt shore giant");
		rmAddObjectDefItem        (IDShoreHuntGiant, "boar", (rmRandInt(3.0, 4.0)), 4.0);
		rmSetObjectDefMinDistance (IDShoreHuntGiant, 120.0);
		rmSetObjectDefMaxDistance (IDShoreHuntGiant, 190.0);
		rmAddObjectDefConstraint  (IDShoreHuntGiant, AvoidSettlementAbit);
		rmAddObjectDefConstraint  (IDShoreHuntGiant, AvoidFoodShort);
		rmAddObjectDefConstraint  (IDShoreHuntGiant, AvoidAll);
		rmAddObjectDefConstraint  (IDShoreHuntGiant, AvoidOuterLand);
		rmAddObjectDefConstraint  (IDShoreHuntGiant, AvoidPlayer);
		rmAddObjectDefConstraint  (IDShoreHuntGiant, NearShore);

		int IDGiantPig		 	  = rmCreateObjectDef("giant pig");
		rmAddObjectDefItem        (IDGiantPig, "pig", 2, 3);
		rmSetObjectDefMinDistance (IDGiantPig, 120.0);
		rmSetObjectDefMaxDistance (IDGiantPig, 180.0);
		rmAddObjectDefConstraint  (IDGiantPig, AvoidGoldShort);
		rmAddObjectDefConstraint  (IDGiantPig, AvoidWaterShortest);
		rmAddObjectDefConstraint  (IDGiantPig, AvoidOuterLand);
		rmAddObjectDefConstraint  (IDGiantPig, AvoidPlayer);
		rmAddObjectDefConstraint  (IDGiantPig, AvoidGoat);
		rmAddObjectDefConstraint  (IDGiantPig, AvoidAll);

		int IDGiantGold 		  = rmCreateObjectDef("giant goldmine");
		rmAddObjectDefItem        (IDGiantGold, "Gold mine", 1, 0.0);
		rmSetObjectDefMinDistance (IDGiantGold, 95.0);
		rmSetObjectDefMaxDistance (IDGiantGold, 160.0);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidSettlementAbit);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidGoldFar);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidAll);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidPlayer);
		rmAddObjectDefConstraint  (IDGiantGold, AvoidOuterLandLong);
	}

	rmSetStatusText("",0.33);
		/// DEFINE TERRAIN

	int IDOuterRiver		=rmCreateArea("outer river");
	rmSetAreaSize			(IDOuterRiver, 0.70, 0.70);
	rmSetAreaLocation		(IDOuterRiver, 0.5, 0.5);
	rmSetAreaWaterType		(IDOuterRiver, "greek river");
	rmAddAreaToClass		(IDOuterRiver, classRiver);
	rmAddAreaConstraint		(IDOuterRiver, AvoidEdgeMed);
	rmSetAreaBaseHeight		(IDOuterRiver, 0.0);
	rmSetAreaSmoothDistance	(IDOuterRiver, 20);
	rmSetAreaCoherence		(IDOuterRiver, 0.5);

	rmBuildArea(IDOuterRiver);

	float mapFraction=rmAreaTilesToFraction(75*cNumberPlayers*mapSizeMultiplier);

	int numTries=100*cNumberNonGaiaPlayers;
	int failCount=0;
	for(i=0; <numTries)
	{
		int IDOuterLand			=rmCreateArea("sandarea"+i);
		rmSetAreaSize			(IDOuterLand, mapFraction, mapFraction);
		rmSetAreaTerrainType	(IDOuterLand, "GrassB");
		rmAddAreaToClass		(IDOuterLand, classOuterLand);
		rmAddAreaConstraint		(IDOuterLand, AvoidRiverShort);

		if(rmBuildArea(IDOuterLand)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==10)
				break;
		}
		else
			failCount=0;
	}
	float islandFraction = rmAreaTilesToFraction(8500*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDInnerIsland		=rmCreateArea("inner land");
	rmSetAreaSize			(IDInnerIsland, islandFraction, islandFraction);
	rmSetAreaLocation		(IDInnerIsland, 0.5, 0.5);
	rmSetAreaTerrainType	(IDInnerIsland, "GrassA");
	rmAddAreaToClass		(IDInnerIsland, classInnerLand);
	rmAddAreaConstraint		(IDInnerIsland, AvoidOuterLand);
	rmSetAreaBaseHeight		(IDInnerIsland, 0.0);
	rmSetAreaSmoothDistance	(IDInnerIsland, 20);
	rmSetAreaCoherence		(IDInnerIsland, 0.0);
	rmSetAreaHeightBlend	(IDInnerIsland, 2);
	rmSetAreaWarnFailure	(IDInnerIsland, false);

	rmBuildArea(IDInnerIsland);

	rmSetStatusText("",0.42);
		///PLAYER LOCATIONS
	rmSetTeamSpacingModifier(0.75);
	if (cNumberNonGaiaPlayers < 3) {
	rmPlacePlayersCircular(0.25, 0.25, rmDegreesToRadians(0.0));
	} else {
	rmPlacePlayersCircular(0.28, 0.28, rmDegreesToRadians(0.0));
	}
	float playerFraction=rmAreaTilesToFraction(1800);
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
		rmSetAreaTerrainType	(AreaPlayer, "GrassDirt25");
		//rmAddAreaTerrainLayer	(AreaPlayer, "SandB", 7, 12);
		//rmAddAreaTerrainLayer	(AreaPlayer, "SandC", 3, 7);
		//rmAddAreaTerrainLayer	(AreaPlayer, "GrassDirt25", 0, 3);

	}
	rmBuildAllAreas();

	for(i=1; <cNumberPlayers*5*mapSizeMultiplier)
	{
		int AreaSavannahPatch	= rmCreateArea("patch A"+i);
		rmSetAreaSize			(AreaSavannahPatch, rmAreaTilesToFraction(75*mapSizeMultiplier), rmAreaTilesToFraction(150*mapSizeMultiplier));
		rmSetAreaTerrainType	(AreaSavannahPatch, "GrassDirt50");
		rmSetAreaMinBlobs		(AreaSavannahPatch, 1);
		rmSetAreaMaxBlobs		(AreaSavannahPatch, 5);
		rmSetAreaMinBlobDistance(AreaSavannahPatch, 16.0);
		rmSetAreaMaxBlobDistance(AreaSavannahPatch, 40.0);
		rmSetAreaCoherence		(AreaSavannahPatch, 0.0);
		rmAddAreaTerrainLayer	(AreaSavannahPatch, "GrassDirt25", 0, 1);
		rmAddAreaConstraint		(AreaSavannahPatch, AvoidInnerLand);

		rmBuildArea(AreaSavannahPatch);
	}

	for(i=1; <cNumberPlayers*5*mapSizeMultiplier)
	{
		int AreaSandPatch		= rmCreateArea("patch B"+i);
		rmSetAreaSize			(AreaSandPatch, rmAreaTilesToFraction(200*mapSizeMultiplier), rmAreaTilesToFraction(300*mapSizeMultiplier));
		rmSetAreaTerrainType	(AreaSandPatch, "GrassB");
		rmSetAreaMinBlobs		(AreaSandPatch, 1);
		rmSetAreaMaxBlobs		(AreaSandPatch, 5);
		rmSetAreaMinBlobDistance(AreaSandPatch, 16.0);
		rmSetAreaMaxBlobDistance(AreaSandPatch, 40.0);
		rmSetAreaCoherence		(AreaSandPatch, 0.0);
		//rmAddAreaTerrainLayer	(AreaSandPatch, "SandC", 0, 1);
		rmAddAreaConstraint		(AreaSandPatch, AvoidOuterLand);
		rmAddAreaConstraint		(AreaSandPatch, AvoidPlayer);

		rmBuildArea(AreaSandPatch);
	}

	for(i=1; <cNumberPlayers*5*mapSizeMultiplier)
	{
		int AreaPatchRoad		= rmCreateArea("patch C"+i);
		rmSetAreaSize			(AreaPatchRoad, rmAreaTilesToFraction(60), rmAreaTilesToFraction(120));
		rmSetAreaTerrainType	(AreaPatchRoad, "GreekRoadA");
		rmSetAreaMinBlobs		(AreaPatchRoad, 1);
		rmSetAreaMaxBlobs		(AreaPatchRoad, 5);
		rmSetAreaMinBlobDistance(AreaPatchRoad, 16.0);
		rmSetAreaMaxBlobDistance(AreaPatchRoad, 40.0);
		rmSetAreaCoherence		(AreaPatchRoad, 0.0);
		rmAddAreaTerrainLayer	(AreaPatchRoad, "GrassDirt25", 0, 1);
		rmAddAreaConstraint		(AreaPatchRoad, AvoidOuterLand);
		rmAddAreaConstraint		(AreaPatchRoad, AvoidPlayer);

		rmBuildArea(AreaPatchRoad);
	}

	numTries =10*cNumberNonGaiaPlayers*mapSizeMultiplier;
	failCount =0;
	for(i=0; <numTries)
	{
		int IDelev				=rmCreateArea("elev"+i);
		rmSetAreaSize			(IDelev, rmAreaTilesToFraction(100*mapSizeMultiplier), rmAreaTilesToFraction(150*mapSizeMultiplier));
		rmSetAreaWarnFailure	(IDelev, false);
		rmAddAreaConstraint		(IDelev, AvoidPlayer);
		rmAddAreaConstraint		(IDelev, AvoidAll);
		rmAddAreaConstraint		(IDelev, AvoidSettlementAbit);
		rmAddAreaConstraint		(IDelev, AvoidWaterShortest);
		rmSetAreaBaseHeight		(IDelev, rmRandFloat(3.0, 5.0));
		rmSetAreaHeightBlend	(IDelev, 2);
		rmSetAreaMinBlobs		(IDelev, 1);
		rmSetAreaMaxBlobs		(IDelev, 5);
		rmSetAreaMinBlobDistance(IDelev, 16.0);
		rmSetAreaMaxBlobDistance(IDelev, 40.0);
		rmSetAreaCoherence		(IDelev, 1.0);

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

	rmSetStatusText("",0.52);
		///SETTLEMENTS
	rmPlaceObjectDefPerPlayer(IDStartingSettlement, true);

	int AreaSettle=rmAddFairLoc("Settlement", false, true,  60, 80, 50, 20);
	rmAddFairLocConstraint(AreaSettle, AvoidWater);

	if (cNumberNonGaiaPlayers>2)
		AreaSettle=rmAddFairLoc("Settlement", true, false,  80, 100, 80, 20);
	else if(rmRandFloat(0,1)<0.5)
		AreaSettle=rmAddFairLoc("Settlement", true, false, 100, 120, 100, 20);
	else
		AreaSettle=rmAddFairLoc("Settlement", false, true,  80, 100, 80, 20);
	rmAddFairLocConstraint(AreaSettle, AvoidWater);

	if (cMapSize == 2) {
	AreaSettle=rmAddFairLoc("Settlement", true, false,  100, 200, 90, 20);
	rmAddFairLocConstraint(AreaSettle, AvoidWater);
	}

	if(rmPlaceFairLocs())
	{
		AreaSettle=rmCreateObjectDef("far settlement2");
		rmAddObjectDefItem(AreaSettle, "Settlement", 1, 0.0);
		for(i=1; <cNumberPlayers)
		{
			for(j=0; <rmGetNumberFairLocs(i))
				rmPlaceObjectDefAtLoc(AreaSettle, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
		}
	}

	rmSetStatusText("",0.60);
		///PLACE OBJECTS

	//starting
	rmPlaceObjectDefPerPlayer(IDStartingGoldmine, true);
	rmPlaceObjectDefPerPlayer(IDStartingTower, true, 4);
	rmPlaceObjectDefPerPlayer(IDStartingBerry, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingHunt, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingHerd, true);
	rmPlaceObjectDefPerPlayer(IDStragglerTree, false, rmRandInt(2.0, 5.0));
	rmPlaceObjectDefPerPlayer(IDStartFish, false, 1);


	//medium
	rmPlaceObjectDefPerPlayer(IDMediumGoldmine, false, 1);
	rmPlaceObjectDefPerPlayer(IDMediumHunt, false, 1);
	rmPlaceObjectDefPerPlayer(IDMediumHerd, false, rmRandInt(1.0, 2.0));
	rmPlaceObjectDefPerPlayer(IDMediumFish, false, 2);

	//far
	if(rmRandFloat(0.0, 1.0) < 0.5) {
		rmPlaceObjectDefPerPlayer(IDFarFish, false, rmRandInt(4.0*mapSizeMultiplier, 5.0*mapSizeMultiplier));
	} else {
		rmPlaceObjectDefPerPlayer(IDFarFish, false, rmRandInt(4.0*mapSizeMultiplier, 5.0*mapSizeMultiplier));
	}
	rmPlaceObjectDefPerPlayer(IDFarPred, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarGoldmine, false, rmRandInt(2.0, 3.0));
	rmPlaceObjectDefPerPlayer(IDFarHunt, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarPig, false, 1);
	rmPlaceObjectDefPerPlayer(IDShoreHunt, false, 2);

	//other
	rmPlaceObjectDefPerPlayer(IDBonusGoldmine, false, 3*mapSizeMultiplier);
	rmPlaceObjectDefPerPlayer(IDRelic, false, 1*mapSizeMultiplier);
	rmPlaceObjectDefPerPlayer(IDRelicOutside, false, 1*mapSizeMultiplier);

	if (cMapSize == 2) {
		rmPlaceObjectDefPerPlayer(IDShoreHuntGiant, false, 2);
		rmPlaceObjectDefPerPlayer(IDGiantPig, false, 1);
		rmPlaceObjectDefPerPlayer(IDGiantGold, false, 1);
	}


	rmSetStatusText("",0.70);
		///FORESTS
	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 8.0);
	int forestCount=9*cNumberNonGaiaPlayers;
	failCount=0;

	for(i=0; <forestCount)
	{
		int forestID			= rmCreateArea("forest"+i);
		rmSetAreaSize			(forestID, rmAreaTilesToFraction(60*mapSizeMultiplier), rmAreaTilesToFraction(120*mapSizeMultiplier));
		rmSetAreaWarnFailure	(forestID, false);
		rmSetAreaForestType 	(forestID, "autumn oak forest");
		rmAddAreaConstraint 	(forestID, AvoidSettlementSlightly);
		rmAddAreaConstraint 	(forestID, forestObjConstraint);
		rmAddAreaConstraint 	(forestID, AvoidForestMedium);
		rmAddAreaConstraint 	(forestID, AvoidWaterShort);
		rmAddAreaConstraint 	(forestID, AvoidOuterLand);
		rmAddAreaConstraint 	(forestID, AvoidStartingSettle);
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

	int forestCount2=12*cNumberNonGaiaPlayers;
	failCount=0;

	for(i=0; <forestCount2)
	{
		int forestID2			= rmCreateArea("outsideforest"+i);
		rmSetAreaSize			(forestID2, rmAreaTilesToFraction(90*mapSizeMultiplier), rmAreaTilesToFraction(120*mapSizeMultiplier));
		rmSetAreaWarnFailure	(forestID2, false);
		rmSetAreaForestType 	(forestID2, "oak forest");
		rmAddAreaConstraint 	(forestID2, forestObjConstraint);
		rmAddAreaConstraint 	(forestID2, AvoidForestMedium);
		rmAddAreaConstraint 	(forestID2, AvoidWaterShortest);
		rmAddAreaConstraint 	(forestID2, AvoidInnerLand);
		rmAddAreaToClass		(forestID2, classForest);

		rmSetAreaMinBlobs		(forestID2, 1);
		rmSetAreaMaxBlobs		(forestID2, 2);
		rmSetAreaMinBlobDistance(forestID2, 10.0);
		rmSetAreaMaxBlobDistance(forestID2, 15.0);
		rmSetAreaCoherence		(forestID2, 0.3);

		if(rmBuildArea(forestID2)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}

	rmSetStatusText("",0.80);
	//beautification
	rmPlaceObjectDefAtLoc		(IDRandomTree, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int bushID					=rmCreateObjectDef("big bush patch");
	rmAddObjectDefItem			(bushID, "bush", 4, 4.0);
	rmSetObjectDefMinDistance	(bushID, 0.0);
	rmSetObjectDefMaxDistance	(bushID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(bushID, AvoidAll);
	rmAddObjectDefConstraint	(bushID, AvoidWaterShortest);
	rmPlaceObjectDefAtLoc		(bushID, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int bush2ID					=rmCreateObjectDef("small bush patch");
	rmAddObjectDefItem			(bush2ID, "bush", rmRandInt(1.0, 3.0), 4.0);
	rmAddObjectDefItem			(bush2ID, "rock limestone sprite", 1, 4.0);
	rmSetObjectDefMinDistance	(bush2ID, 0.0);
	rmSetObjectDefMaxDistance	(bush2ID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(bush2ID, AvoidAll);
	rmAddObjectDefConstraint	(bush2ID, AvoidWaterShortest);
	rmPlaceObjectDefAtLoc		(bush2ID, 0, 0.5, 0.5, 15*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int grassID					=rmCreateObjectDef("grass");
	rmAddObjectDefItem			(grassID, "grass", 1, 0.0);
	rmSetObjectDefMinDistance	(grassID, 0.0);
	rmSetObjectDefMaxDistance	(grassID, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(grassID, AvoidAll);
	rmAddObjectDefConstraint	(grassID, AvoidWaterShortest);
	rmPlaceObjectDefAtLoc		(grassID, 0, 0.5, 0.5, 50*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int sandDrift				=rmCreateObjectDef("blowing sand");
	rmAddObjectDefItem			(sandDrift, "rock limestone sprite", 1, 0.0);
	rmSetObjectDefMinDistance	(sandDrift, 0.0);
	rmSetObjectDefMaxDistance	(sandDrift, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(sandDrift, AvoidAll);
	rmAddObjectDefConstraint	(sandDrift, AvoidWaterShortest);
	rmPlaceObjectDefAtLoc		(sandDrift, 0, 0.5, 0.5, 75*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int flowers					=rmCreateObjectDef("flowers");
	rmAddObjectDefItem			(flowers, "flowers", rmRandInt(1.0, 3.0), 4.0);
	rmSetObjectDefMinDistance	(flowers, 0.0);
	rmSetObjectDefMaxDistance	(flowers, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(flowers, AvoidAll);
	rmAddObjectDefConstraint	(flowers, AvoidWaterShortest);
	rmPlaceObjectDefAtLoc		(flowers, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int logs					=rmCreateObjectDef("logs");
	rmAddObjectDefItem			(logs, "rotting log", 1, 0.0);
	rmSetObjectDefMinDistance	(logs, 0.0);
	rmSetObjectDefMaxDistance	(logs, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(logs, AvoidAll);
	rmAddObjectDefConstraint	(logs, AvoidWaterShortest);
	rmPlaceObjectDefAtLoc		(logs, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int destroyed				=rmCreateObjectDef("castles i guess");
	rmAddObjectDefItem			(destroyed, "destroyed buildings small", 1, 0.0);
	rmSetObjectDefMinDistance	(destroyed, 0.0);
	rmSetObjectDefMaxDistance	(destroyed, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(destroyed, AvoidAll);
	rmAddObjectDefConstraint	(destroyed, AvoidWater);
	rmAddObjectDefConstraint	(destroyed, AvoidOuterLandLongest);
	rmAddObjectDefConstraint	(destroyed, AvoidPlayer);
	rmAddObjectDefConstraint	(destroyed, AvoidSettlementAbit);
	rmPlaceObjectDefAtLoc		(destroyed, 0, 0.5, 0.5, 1*cNumberNonGaiaPlayers*mapSizeMultiplier);

	// RM X Finalize.
	rmxFinalize();

	rmSetStatusText("",1.00);
}