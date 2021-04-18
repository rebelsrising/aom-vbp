/*Tundra Pools 1.02
**Made by Hagrit
**Designed by KeeN_Flame
**Party Mapset Bonusss
*/

// VBP 5.0

include "rmx 5-0-0.xs";

void main(void)
{
	///INITIALIZE MAP
	rmSetStatusText("",0.01);

	// RM X Setup.
	rmxInit("Tundra Pools (by Hagrit & Flame)", false, false, false);

	int playerTiles = 9000;
	if(cMapSize == 1)
	{
		playerTiles = 11000;
	}

	int size = 2.0*sqrt(cNumberNonGaiaPlayers*playerTiles/0.9);
	rmSetMapSize(size, size);
	int skew = rmRandInt(1,2);

	rmTerrainInitialize("TundraRockA");
	rmSetLightingSet("alfheim");

	rmSetStatusText("",0.10);
	///CLASSES
	int classPlayer			= rmDefineClass("player");
	int classCorner			= rmDefineClass("corner");
	int classForest			= rmDefineClass("forest");
	int classCenter			= rmDefineClass("center");
	int classStartingSettle	= rmDefineClass("starting settlement");
	int classPond			= rmDefineClass("pond");
	int classAvoidCorner	= rmDefineClass("non corner");

	rmSetStatusText("",0.15);
	///CONSTRAINTS
	int AvoidEdgeShort	= rmCreateBoxConstraint("B0", rmXTilesToFraction(3), rmZTilesToFraction(3), 1.0-rmXTilesToFraction(3), 1.0-rmZTilesToFraction(3));
	int AvoidEdge		= rmCreateBoxConstraint("B1", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0-rmXTilesToFraction(8), 1.0-rmZTilesToFraction(8));
	int AvoidEdgeFar	= rmCreateBoxConstraint("B2", rmXTilesToFraction(12), rmZTilesToFraction(12), 1.0-rmXTilesToFraction(12), 1.0-rmZTilesToFraction(12));

	int AvoidAll				= rmCreateTypeDistanceConstraint ("T0", "all", 6.0);
	int AvoidTower				= rmCreateTypeDistanceConstraint ("T1", "tower", 28.0);
	int AvoidGold				= rmCreateTypeDistanceConstraint ("T2", "gold", 25.0);
	int AvoidSettlementAbit		= rmCreateTypeDistanceConstraint ("T3", "AbstractSettlement", 21.0);
	int AvoidHerdable			= rmCreateTypeDistanceConstraint ("T4", "herdable", 25.0);
	int AvoidPredator			= rmCreateTypeDistanceConstraint ("T5", "animalPredator", 40.0);
	int AvoidHuntable			= rmCreateTypeDistanceConstraint ("T6", "huntable", 25.0);
	int AvoidGoldFar			= rmCreateTypeDistanceConstraint ("T7", "gold", 30.0);
	int AvoidFood				= rmCreateTypeDistanceConstraint ("T8", "food", 12.0);
	int AvoidRelic				= rmCreateTypeDistanceConstraint ("T9", "relic", 70.0);
	int AvoidHuntableFar		= rmCreateTypeDistanceConstraint ("T10", "huntable", 35.0);
	int AvoidGoldForest			= rmCreateTypeDistanceConstraint ("T11", "gold", 8.0);

	int AvoidStartingSettle		= rmCreateClassDistanceConstraint ("C0", classStartingSettle, 50.0);
	int AvoidStartingSettleTiny	= rmCreateClassDistanceConstraint ("C1", classStartingSettle, 20.0);
	int AvoidPlayer				= rmCreateClassDistanceConstraint ("C2", classPlayer, 2.0);
	int AvoidPond				= rmCreateClassDistanceConstraint ("C3", classPond, 15.0);
	int AvoidCenterShort		= rmCreateClassDistanceConstraint ("C4", classCenter, 15.0);
	int AvoidForest				= rmCreateClassDistanceConstraint ("C5", classForest, 24.0);
	int AvoidForestShort		= rmCreateClassDistanceConstraint ("C6", classForest, 20.0);
	int AvoidForestShortest		= rmCreateClassDistanceConstraint ("C7", classForest, 4.0);
	int AvoidCornerShort		= rmCreateClassDistanceConstraint ("C8", classCorner, 1.0);
	int AvoidCorner				= rmCreateClassDistanceConstraint ("C8", classCorner, 15.0);
	int inCorner				= rmCreateClassDistanceConstraint ("C10", classAvoidCorner, 1.0);
	int AvoidPlayerFar			= rmCreateClassDistanceConstraint ("C11", classPlayer, 15.0);

	int AvoidImpassableLand		= rmCreateTerrainDistanceConstraint ("TR1", "land", false, 6.0);
	int AvoidImpassableLandFar	= rmCreateTerrainDistanceConstraint ("TR2", "land", false, 28.0);
	int AvoidShore 				= rmCreateTerrainDistanceConstraint("TR4", "land", true, 12.0);

	rmSetStatusText("",0.20);
	///PLAYER LOCATION
	if(cNumberTeams < 3) {
		if(cNumberNonGaiaPlayers == 2) {
			if(skew == 1)
				rmPlacePlayersLine(0.22, 0.22, 0.78, 0.78, 5, 0);
			else
				rmPlacePlayersLine(0.22, 0.78, 0.78, 0.22, 5, 0);
		} else if(cNumberNonGaiaPlayers < 5) {
			if(skew == 1) {
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.20, 0.20, 0.80, 0.20, 0.01);
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.80, 0.80, 0.20, 0.80, 0.01);
			} else {
				rmSetPlacementTeam(0);
				rmPlacePlayersLine(0.20, 0.80, 0.20, 0.20, 0.01);
				rmSetPlacementTeam(1);
				rmPlacePlayersLine(0.80, 0.20, 0.80, 0.80, 0.01);
			}
		} else if(cNumberNonGaiaPlayers < 7) {
			if(skew == 1) {
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.23, 0.52);
				rmPlacePlayersCircular(0.37, 0.37, rmDegreesToRadians(2.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.73, 1.02);
				rmPlacePlayersCircular(0.37, 0.37, rmDegreesToRadians(2.0));
			} else {
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.47, 0.78);
				rmPlacePlayersCircular(0.37, 0.37, rmDegreesToRadians(2.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.97, 0.28);
				rmPlacePlayersCircular(0.37, 0.37, rmDegreesToRadians(2.0));
			}
		} else {
			if(skew == 1) {
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.33, 0.67);
				rmPlacePlayersCircular(0.37, 0.37, rmDegreesToRadians(2.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.83, 0.17);
				rmPlacePlayersCircular(0.37, 0.37, rmDegreesToRadians(2.0));
			} else {
				rmSetPlacementTeam(0);
				rmSetPlacementSection(0.08, 0.42);
				rmPlacePlayersCircular(0.39, 0.39, rmDegreesToRadians(2.0));
				rmSetPlacementTeam(1);
				rmSetPlacementSection(0.58, 0.92);
				rmPlacePlayersCircular(0.39, 0.39, rmDegreesToRadians(2.0));
			}
		}
	}
	else
		rmPlacePlayersSquare(0.3, 0.3, rmDegreesToRadians(5.0));

	rmSetStatusText("",0.25);
	///OBJECTS
	int IDStartingSettlement  	= rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem        	(IDStartingSettlement, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass     	(IDStartingSettlement, classStartingSettle);
	rmSetObjectDefMinDistance 	(IDStartingSettlement, 0.0);
	rmSetObjectDefMaxDistance 	(IDStartingSettlement, 0.0);

	int IDStartingTower 	  	= rmCreateObjectDef("starting towers");
	rmAddObjectDefItem        	(IDStartingTower, "tower", 1, 0.0);
	rmAddObjectDefItem			(IDStartingTower, "rock granite small", rmRandInt(0,1), 3);
	rmAddObjectDefConstraint  	(IDStartingTower, AvoidTower);
	rmAddObjectDefConstraint  	(IDStartingTower, AvoidEdgeShort);
	rmSetObjectDefMinDistance 	(IDStartingTower, 22.0);
	rmSetObjectDefMaxDistance 	(IDStartingTower, 26.0);

	int IDStartingGold			= rmCreateObjectDef("starting goldmine");
	rmAddObjectDefItem			(IDStartingGold, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDStartingGold, 21.0);
	rmSetObjectDefMaxDistance 	(IDStartingGold, 22.0);
	rmAddObjectDefConstraint  	(IDStartingGold, AvoidGold);
	rmAddObjectDefConstraint  	(IDStartingGold, AvoidAll);

	int IDStartingHunt			= rmCreateObjectDef("close hunt");

	if (rmRandInt(0,100) < 67) {
		rmAddObjectDefItem			(IDStartingHunt, "caribou", rmRandInt(4,8), 4.0);
	} else
		rmAddObjectDefItem			(IDStartingHunt, "aurochs", rmRandInt(2,3), 4.0);

	rmSetObjectDefMinDistance	(IDStartingHunt, 25.0);
	rmSetObjectDefMaxDistance	(IDStartingHunt, 30.0);
	rmAddObjectDefConstraint	(IDStartingHunt, AvoidAll);
	rmAddObjectDefConstraint	(IDStartingHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint	(IDStartingHunt, AvoidImpassableLand);

	int IDStartingBerry			= rmCreateObjectDef("starting berry");
	rmAddObjectDefItem			(IDStartingBerry, "berry bush", rmRandInt(5,9), 5.0);
	rmSetObjectDefMinDistance 	(IDStartingBerry, 25.0);
	rmSetObjectDefMaxDistance 	(IDStartingBerry, 35.0);
	rmAddObjectDefConstraint  	(IDStartingBerry, AvoidAll);

	int IDStartingGoat			= rmCreateObjectDef("starting goats");
	rmAddObjectDefItem			(IDStartingGoat, "goat", rmRandInt(4,8), 5.0);
	rmSetObjectDefMinDistance 	(IDStartingGoat, 25.0);
	rmSetObjectDefMaxDistance 	(IDStartingGoat, 35.0);
	rmAddObjectDefConstraint  	(IDStartingGoat, AvoidAll);

	int IDStragglerTree			= rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem			(IDStragglerTree, "oak autumn", 1, 0.0);
	rmSetObjectDefMinDistance	(IDStragglerTree, 12.0);
	rmSetObjectDefMaxDistance	(IDStragglerTree, 15.0);
	rmAddObjectDefConstraint  	(IDStragglerTree, AvoidGoldForest);

	//med

	// -> see object placement, due to fairloc its moved there

	int IDMediumElk				= rmCreateObjectDef("medium elks");
	rmAddObjectDefItem			(IDMediumElk, "elk", rmRandInt(3,9), 5);
	rmSetObjectDefMinDistance	(IDMediumElk, 60);
	rmSetObjectDefMaxDistance	(IDMediumElk, 90);
	rmAddObjectDefConstraint	(IDMediumElk, AvoidPlayerFar);
	rmAddObjectDefConstraint	(IDMediumElk, AvoidForestShort);
	rmAddObjectDefConstraint	(IDMediumElk, AvoidAll);
	rmAddObjectDefConstraint	(IDMediumElk, AvoidPond);
	rmAddObjectDefConstraint	(IDMediumElk, AvoidHuntable);

	//far
	int IDFarAurochs			= rmCreateObjectDef("far aurochs");
	rmAddObjectDefItem			(IDFarAurochs, "aurochs", rmRandInt(2,4), 4);
	rmSetObjectDefMinDistance	(IDFarAurochs, 70);
	rmSetObjectDefMaxDistance	(IDFarAurochs, 90);
	rmAddObjectDefConstraint	(IDFarAurochs, AvoidEdge);
	rmAddObjectDefConstraint	(IDFarAurochs, AvoidHuntable);
	rmAddObjectDefConstraint	(IDFarAurochs, AvoidAll);
	rmAddObjectDefConstraint	(IDFarAurochs, AvoidCenterShort);
	rmAddObjectDefConstraint	(IDFarAurochs, AvoidImpassableLandFar);

	int IDFarGold				= rmCreateObjectDef("far gold");
	rmAddObjectDefItem			(IDFarGold, "gold mine", 1, 0);
	rmSetObjectDefMinDistance	(IDFarGold, 55);
	rmSetObjectDefMaxDistance	(IDFarGold, 85);
	rmAddObjectDefConstraint	(IDFarGold, AvoidEdgeFar);
	rmAddObjectDefConstraint	(IDFarGold, AvoidGold);
	rmAddObjectDefConstraint	(IDFarGold, AvoidAll);
	rmAddObjectDefConstraint	(IDFarGold, AvoidForestShort);
	rmAddObjectDefConstraint	(IDFarGold, AvoidImpassableLand);
	rmAddObjectDefConstraint	(IDFarGold, AvoidSettlementAbit);
	rmAddObjectDefConstraint	(IDFarGold, AvoidPlayerFar);

	int IDCornerGold			= rmCreateObjectDef("corner gold");
	rmAddObjectDefItem			(IDCornerGold, "gold mine", 1, 0);
	rmSetObjectDefMinDistance	(IDCornerGold, 105);
	rmSetObjectDefMaxDistance	(IDCornerGold, 150);
	rmAddObjectDefConstraint	(IDCornerGold, AvoidEdgeShort);
	rmAddObjectDefConstraint	(IDCornerGold, AvoidGoldFar);
	rmAddObjectDefConstraint	(IDCornerGold, AvoidAll);
	rmAddObjectDefConstraint	(IDCornerGold, AvoidForestShort);
	rmAddObjectDefConstraint	(IDCornerGold, AvoidImpassableLandFar);
	rmAddObjectDefConstraint	(IDCornerGold, AvoidSettlementAbit);
	rmAddObjectDefConstraint	(IDCornerGold, AvoidPlayerFar);

	if (cNumberNonGaiaPlayers < 3)
		rmAddObjectDefConstraint	(IDCornerGold, inCorner);

	int IDCornerHunt			= rmCreateObjectDef("corner hunt");
	rmAddObjectDefItem			(IDCornerHunt, "elk", rmRandFloat(5,10), 5);
	rmSetObjectDefMinDistance	(IDCornerHunt, 105);
	rmSetObjectDefMaxDistance	(IDCornerHunt, 150);
	rmAddObjectDefConstraint	(IDCornerHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint	(IDCornerHunt, AvoidHuntableFar);
	rmAddObjectDefConstraint	(IDCornerHunt, AvoidAll);
	rmAddObjectDefConstraint	(IDCornerHunt, AvoidForestShort);
	rmAddObjectDefConstraint	(IDCornerHunt, AvoidImpassableLand);

	if (cNumberNonGaiaPlayers < 3)
		rmAddObjectDefConstraint	(IDCornerHunt, inCorner);

	int IDCornerPred			= rmCreateObjectDef("corner pred");
	rmAddObjectDefItem			(IDCornerPred, "bear", rmRandFloat(1,2), 3);
	rmSetObjectDefMinDistance	(IDCornerPred, 105);
	rmSetObjectDefMaxDistance	(IDCornerPred, 150);
	rmAddObjectDefConstraint	(IDCornerPred, AvoidEdgeShort);
	rmAddObjectDefConstraint	(IDCornerPred, AvoidPredator);
	rmAddObjectDefConstraint	(IDCornerPred, AvoidAll);
	rmAddObjectDefConstraint	(IDCornerPred, AvoidForestShort);
	rmAddObjectDefConstraint	(IDCornerPred, AvoidImpassableLand);

	if (cNumberNonGaiaPlayers < 3)
		rmAddObjectDefConstraint(IDCornerPred, inCorner);

	//other
	int IDBirds					= rmCreateObjectDef("far hawks");
	rmAddObjectDefItem			(IDBirds, "hawk", 1, 0.0);
	rmSetObjectDefMinDistance	(IDBirds, 0.0);
	rmSetObjectDefMaxDistance	(IDBirds, rmXFractionToMeters(0.5));

	int IDRelic					= rmCreateObjectDef("relic");
	rmAddObjectDefItem			(IDRelic, "relic", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRelic, 50.0);
	rmSetObjectDefMaxDistance	(IDRelic, 150.0);
	rmAddObjectDefConstraint	(IDRelic, AvoidEdgeShort);
	rmAddObjectDefConstraint	(IDRelic, AvoidRelic);
	rmAddObjectDefConstraint	(IDRelic, AvoidStartingSettle);
	rmAddObjectDefConstraint	(IDRelic, AvoidImpassableLand);
	rmAddObjectDefConstraint	(IDRelic, AvoidPlayer);
	rmAddObjectDefConstraint	(IDRelic, AvoidAll);

	int IDRandomTree			= rmCreateObjectDef("random tree");
	rmAddObjectDefItem			(IDRandomTree, "oak autumn", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRandomTree, 0.0);
	rmSetObjectDefMaxDistance	(IDRandomTree, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRandomTree, AvoidAll);
	rmAddObjectDefConstraint	(IDRandomTree, AvoidImpassableLand);

	int FishNum = rmRandInt(0,100);

	int IDFish					= rmCreateObjectDef("fish");

	if (cNumberNonGaiaPlayers < 5) {
		if (FishNum < 20) {
			rmAddObjectDefItem			(IDFish, "fish - perch", 4, 15.0);
		} else if (FishNum < 60) {
			rmAddObjectDefItem			(IDFish, "fish - perch", 5, 15.0);
		} else
			rmAddObjectDefItem			(IDFish, "fish - perch", 6, 15.0);
	} else if (cNumberNonGaiaPlayers < 7) {
		if (FishNum < 33) {
			rmAddObjectDefItem			(IDFish, "fish - perch", 4, 21.0);
		} else if (FishNum < 67) {
			rmAddObjectDefItem			(IDFish, "fish - perch", 6, 21.0);
		} else
			rmAddObjectDefItem			(IDFish, "fish - perch", 9, 24.0);
	} else {
		if (FishNum < 15) {
			rmAddObjectDefItem			(IDFish, "fish - perch", 4, 24.0);
		} else if (FishNum < 50) {
			rmAddObjectDefItem			(IDFish, "fish - perch", 6, 27.0);
		} else if (FishNum < 85) {
			rmAddObjectDefItem			(IDFish, "fish - perch", 7, 27.0);
		} else {
			rmAddObjectDefItem			(IDFish, "fish - perch", 8, 27.0);
		}
	}

	rmSetObjectDefMinDistance	(IDFish, 0.0);
	rmSetObjectDefMaxDistance	(IDFish, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDFish, AvoidShore);
	rmAddObjectDefConstraint	(IDFish, AvoidFood);

	int IDFish2					= rmCreateObjectDef("fish 2 for 4v4");

	if (FishNum < 25) {
			rmAddObjectDefItem			(IDFish2, "fish - perch", 4, 24.0);
		} else if (FishNum < 50) {
			rmAddObjectDefItem			(IDFish2, "fish - perch", 6, 24.0);
		} else if (FishNum < 85) {
			rmAddObjectDefItem			(IDFish2, "fish - perch", 8, 27.0);
		} else {
			rmAddObjectDefItem			(IDFish2, "fish - perch", 9, 27.0);
		}

	rmSetObjectDefMinDistance	(IDFish2, 0.0);
	rmSetObjectDefMaxDistance	(IDFish2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDFish2, AvoidShore);
	rmAddObjectDefConstraint	(IDFish2, AvoidEdgeShort);
	rmAddObjectDefConstraint	(IDFish2, AvoidFood);

	rmSetStatusText("",0.40);
	///AREA DEFINITION
	int IDCenter		= rmCreateArea("center");
	rmSetAreaSize		(IDCenter, 0.01, 0.01);
	rmSetAreaLocation	(IDCenter, 0.5, 0.5);
	rmAddAreaToClass	(IDCenter, classCenter);
	rmBuildArea			(IDCenter);

	for(i=1; <cNumberPlayers)
	{
		int IDPlayerArea		= rmCreateArea("Player"+i);
		rmSetPlayerArea			(i, IDPlayerArea);
		rmSetAreaSize			(IDPlayerArea, rmAreaTilesToFraction(300), rmAreaTilesToFraction(450));
		rmAddAreaToClass		(IDPlayerArea, classPlayer);
		rmSetAreaWarnFailure	(IDPlayerArea, false);
		rmSetAreaMinBlobs		(IDPlayerArea, 0);
		rmSetAreaMaxBlobs		(IDPlayerArea, 5);
		rmSetAreaMinBlobDistance(IDPlayerArea, 12.0);
		rmSetAreaMaxBlobDistance(IDPlayerArea, 30.0);
		rmSetAreaCoherence		(IDPlayerArea, 0.0);
		rmAddAreaConstraint		(IDPlayerArea, AvoidPlayer);
		rmSetAreaLocPlayer		(IDPlayerArea, i);
		rmSetAreaTerrainType	(IDPlayerArea, "CliffEgyptianB");
	}

	rmBuildAllAreas();

	int failCount = 0;

	for(i = 0; < cNumberPlayers*80)
	{
		int IDTundraB			= rmCreateArea("tundra b patch"+i);
		rmSetAreaSize			(IDTundraB, rmAreaTilesToFraction(20), rmAreaTilesToFraction(80));
		rmSetAreaTerrainType	(IDTundraB, "TundraGrassB");
		rmSetAreaMinBlobs		(IDTundraB, 1);
		rmSetAreaMaxBlobs		(IDTundraB, 5);
		rmSetAreaWarnFailure	(IDTundraB, false);
		rmSetAreaMinBlobDistance(IDTundraB, 16.0);
		rmSetAreaMaxBlobDistance(IDTundraB, 40.0);
		rmSetAreaCoherence		(IDTundraB, 0.0);
		rmAddAreaConstraint		(IDTundraB, AvoidForestShortest);
		rmAddAreaConstraint		(IDTundraB, AvoidPlayer);

		rmBuildArea(IDTundraB);
	}

	for (i = 0; < cNumberNonGaiaPlayers*40) {
		int IDPatchA				= rmCreateArea("tundra patch a"+i);
		rmSetAreaSize				(IDPatchA, rmAreaTilesToFraction(10), rmAreaTilesToFraction(50));
		rmSetAreaCoherence			(IDPatchA, 0.1);
		rmSetAreaTerrainType		(IDPatchA, "SavannahD");

		if (rmRandFloat(0,1) < 0.4) {
			rmSetAreaBaseHeight			(IDPatchA, rmRandFloat(4,9));
		}

		rmSetAreaHeightBlend		(IDPatchA, 2);
		rmAddAreaConstraint			(IDPatchA, AvoidImpassableLand);
		rmAddAreaConstraint			(IDPatchA, AvoidAll);
		rmAddAreaConstraint			(IDPatchA, AvoidPlayer);

		if (rmBuildArea(IDPatchA) == false) {
			failCount ++;
			if (failCount == 3)
				break;
		}
		else
			failCount = 0;
	}

	rmBuildAllAreas();

	//center forests
	int ForestSpawn = rmRandInt(0,100);

	if (cNumberTeams == 2) {
		if (cNumberNonGaiaPlayers < 3) {
			if (ForestSpawn < 33) {
				int IDCenterForestA	= rmCreateArea("center forest a");
				rmSetAreaSize		(IDCenterForestA, 0.05, 0.06);
				rmSetAreaLocation	(IDCenterForestA, 0.5, 0.5);
				rmSetAreaForestType	(IDCenterForestA, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestA, 0.9);
				rmAddAreaToClass	(IDCenterForestA, classForest);
				rmBuildArea			(IDCenterForestA);
			} else if (ForestSpawn < 67) {
				int IDCenterForestB	= rmCreateArea("center forest b");
				rmSetAreaSize		(IDCenterForestB, 0.02, 0.03);
				rmSetAreaLocation	(IDCenterForestB, 0.6, 0.4);
				rmSetAreaForestType	(IDCenterForestB, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestB, 0.9);
				rmAddAreaToClass	(IDCenterForestB, classForest);

				int IDCenterForestC	= rmCreateArea("center forest c");
				rmSetAreaSize		(IDCenterForestC, 0.02, 0.03);
				rmSetAreaLocation	(IDCenterForestC, 0.4, 0.6);
				rmSetAreaForestType	(IDCenterForestC, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestC, 0.9);
				rmAddAreaToClass	(IDCenterForestC, classForest);

				if (skew == 1) {
					rmSetAreaLocation	(IDCenterForestB, 0.4, 0.6);
					rmSetAreaLocation	(IDCenterForestC, 0.6, 0.4);
				} else {
					rmSetAreaLocation	(IDCenterForestB, 0.6, 0.6);
					rmSetAreaLocation	(IDCenterForestC, 0.4, 0.4);
				}

				rmBuildArea			(IDCenterForestB);
				rmBuildArea			(IDCenterForestC);

			} else {
				int IDCenterForestD	= rmCreateArea("center forest d");
				rmSetAreaSize		(IDCenterForestD, 0.0125, 0.015);
				rmSetAreaLocation	(IDCenterForestD, 0.5, 0.5);
				rmSetAreaForestType	(IDCenterForestD, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestD, 0.9);
				rmAddAreaToClass	(IDCenterForestD, classForest);


				int IDCenterForestE	= rmCreateArea("center forest e");
				rmSetAreaSize		(IDCenterForestE, 0.0125, 0.015);
				rmSetAreaLocation	(IDCenterForestE, 0.35, 0.65);
				rmSetAreaForestType	(IDCenterForestE, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestE, 0.9);
				rmAddAreaToClass	(IDCenterForestE, classForest);


				int IDCenterForestF	= rmCreateArea("center forest f");
				rmSetAreaSize		(IDCenterForestF, 0.0125, 0.015);
				rmSetAreaForestType	(IDCenterForestF, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestF, 0.9);
				rmAddAreaToClass	(IDCenterForestF, classForest);

				if (skew == 1) {
					rmSetAreaLocation	(IDCenterForestE, 0.65, 0.35);
					rmSetAreaLocation	(IDCenterForestF, 0.35, 0.65);
				} else {
					rmSetAreaLocation	(IDCenterForestE, 0.65, 0.65);
					rmSetAreaLocation	(IDCenterForestF, 0.35, 0.35);
				}

				rmBuildArea			(IDCenterForestD);
				rmBuildArea			(IDCenterForestE);
				rmBuildArea			(IDCenterForestF);
			}
		} else if (cNumberNonGaiaPlayers < 5) {
			if (ForestSpawn < 33) {
				int IDCenterForestG	= rmCreateArea("center forest g");
				rmSetAreaSize		(IDCenterForestG, 0.05, 0.06);
				rmSetAreaLocation	(IDCenterForestG, 0.5, 0.5);
				rmSetAreaForestType	(IDCenterForestG, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestG, 0.9);
				rmAddAreaToClass	(IDCenterForestG, classForest);
				rmBuildArea			(IDCenterForestG);
			} else if (ForestSpawn < 66) {
				int IDCenterForestH	= rmCreateArea("center forest h");
				rmSetAreaSize		(IDCenterForestH, 0.02, 0.025);
				rmSetAreaLocation	(IDCenterForestH, 0.65, 0.5);
				rmSetAreaForestType	(IDCenterForestH, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestH, 0.9);
				rmAddAreaToClass	(IDCenterForestH, classForest);
				rmBuildArea			(IDCenterForestH);

				int IDCenterForestI	= rmCreateArea("center forest i");
				rmSetAreaSize		(IDCenterForestI, 0.015, 0.02);
				rmSetAreaLocation	(IDCenterForestI, 0.35, 0.5);
				rmSetAreaForestType	(IDCenterForestI, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestI, 0.9);
				rmAddAreaToClass	(IDCenterForestI, classForest);
				rmBuildArea			(IDCenterForestI);
			} else {
				int IDCenterForestJ	= rmCreateArea("center forest j");
				rmSetAreaSize		(IDCenterForestJ, 0.015, 0.02);
				rmSetAreaLocation	(IDCenterForestJ, 0.5, 0.65);
				rmSetAreaForestType	(IDCenterForestJ, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestJ, 0.9);
				rmAddAreaToClass	(IDCenterForestJ, classForest);
				rmBuildArea			(IDCenterForestJ);

				int IDCenterForestK	= rmCreateArea("center forest k");
				rmSetAreaSize		(IDCenterForestK, 0.015, 0.02);
				rmSetAreaLocation	(IDCenterForestK, 0.5, 0.35);
				rmSetAreaForestType	(IDCenterForestK, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestK, 0.9);
				rmAddAreaToClass	(IDCenterForestK, classForest);
				rmBuildArea			(IDCenterForestK);
			}
		} else if (cNumberNonGaiaPlayers < 7) {
			if (ForestSpawn < 20) {
				int IDCenterForestL	= rmCreateArea("center forest l");
				rmSetAreaSize		(IDCenterForestL, 0.055, 0.06);
				rmSetAreaLocation	(IDCenterForestL, 0.5, 0.5);
				rmSetAreaForestType	(IDCenterForestL, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestL, 0.9);
				rmAddAreaToClass	(IDCenterForestL, classForest);
				rmBuildArea			(IDCenterForestL);
			} else if (ForestSpawn < 40) {
				int IDCenterForestM	= rmCreateArea("center forest m");
				rmSetAreaSize		(IDCenterForestM, 0.02, 0.025);
				rmSetAreaLocation	(IDCenterForestM, 0.65, 0.5);
				rmSetAreaForestType	(IDCenterForestM, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestM, 0.9);
				rmAddAreaToClass	(IDCenterForestM, classForest);
				rmBuildArea			(IDCenterForestM);

				int IDCenterForestN	= rmCreateArea("center forest n");
				rmSetAreaSize		(IDCenterForestN, 0.02, 0.025);
				rmSetAreaLocation	(IDCenterForestN, 0.35, 0.5);
				rmSetAreaForestType	(IDCenterForestN, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestN, 0.9);
				rmAddAreaToClass	(IDCenterForestN, classForest);
				rmBuildArea			(IDCenterForestN);
			} else if (ForestSpawn < 60) {
				int IDCenterForestO	= rmCreateArea("center forest o");
				rmSetAreaSize		(IDCenterForestO, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestO, 0.62, 0.62);
				rmSetAreaForestType	(IDCenterForestO, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestO, 0.9);
				rmAddAreaToClass	(IDCenterForestO, classForest);
				rmBuildArea			(IDCenterForestO);

				int IDCenterForestP	= rmCreateArea("center forest p");
				rmSetAreaSize		(IDCenterForestP, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestP, 0.5, 0.5);
				rmSetAreaForestType	(IDCenterForestP, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestP, 0.9);
				rmAddAreaToClass	(IDCenterForestP, classForest);
				rmBuildArea			(IDCenterForestP);

				int IDCenterForestQ	= rmCreateArea("center forest q");
				rmSetAreaSize		(IDCenterForestQ, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestQ, 0.38, 0.38);
				rmSetAreaForestType	(IDCenterForestQ, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestQ, 0.9);
				rmAddAreaToClass	(IDCenterForestQ, classForest);
				rmBuildArea			(IDCenterForestQ);
			} else if (ForestSpawn < 80) {
				int IDCenterForestR	= rmCreateArea("center forest r");
				rmSetAreaSize		(IDCenterForestR, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestR, 0.62, 0.62);
				rmSetAreaForestType	(IDCenterForestR, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestR, 0.9);
				rmAddAreaToClass	(IDCenterForestR, classForest);
				rmBuildArea			(IDCenterForestR);

				int IDCenterForestS	= rmCreateArea("center forest s");
				rmSetAreaSize		(IDCenterForestS, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestS, 0.5, 0.5);
				rmSetAreaForestType	(IDCenterForestS, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestS, 0.9);
				rmAddAreaToClass	(IDCenterForestS, classForest);
				rmBuildArea			(IDCenterForestS);

				int IDCenterForestT	= rmCreateArea("center forest t");
				rmSetAreaSize		(IDCenterForestT, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestT, 0.38, 0.38);
				rmSetAreaForestType	(IDCenterForestT, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestT, 0.9);
				rmAddAreaToClass	(IDCenterForestT, classForest);
				rmBuildArea			(IDCenterForestT);

				int IDCenterForestU	= rmCreateArea("center forest u");
				rmSetAreaSize		(IDCenterForestU, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestU, 0.38, 0.62);
				rmSetAreaForestType	(IDCenterForestU, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestU, 0.9);
				rmAddAreaToClass	(IDCenterForestU, classForest);
				rmBuildArea			(IDCenterForestU);

				int IDCenterForestV	= rmCreateArea("center forest v");
				rmSetAreaSize		(IDCenterForestV, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestV, 0.62, 0.38);
				rmSetAreaForestType	(IDCenterForestV, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestV, 0.9);
				rmAddAreaToClass	(IDCenterForestV, classForest);
				rmBuildArea			(IDCenterForestV);
			} else {
				int IDCenterForestW	= rmCreateArea("center forest w");
				rmSetAreaSize		(IDCenterForestW, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestW, 0.65, 0.5);
				rmSetAreaForestType	(IDCenterForestW, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestW, 0.9);
				rmAddAreaToClass	(IDCenterForestW, classForest);
				rmBuildArea			(IDCenterForestW);

				int IDCenterForestX	= rmCreateArea("center forest x");
				rmSetAreaSize		(IDCenterForestX, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestX, 0.5, 0.65);
				rmSetAreaForestType	(IDCenterForestX, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestX, 0.9);
				rmAddAreaToClass	(IDCenterForestX, classForest);
				rmBuildArea			(IDCenterForestX);

				int IDCenterForestY	= rmCreateArea("center forest y");
				rmSetAreaSize		(IDCenterForestY, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestY, 0.5, 0.35);
				rmSetAreaForestType	(IDCenterForestY, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestY, 0.9);
				rmAddAreaToClass	(IDCenterForestY, classForest);
				rmBuildArea			(IDCenterForestY);

				int IDCenterForestZ	= rmCreateArea("center forest z");
				rmSetAreaSize		(IDCenterForestZ, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestZ, 0.35, 0.5);
				rmSetAreaForestType	(IDCenterForestZ, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestZ, 0.9);
				rmAddAreaToClass	(IDCenterForestZ, classForest);
				rmBuildArea			(IDCenterForestZ);
			}
		} else {
			if (ForestSpawn < 50) {
				int IDCenterForestAA= rmCreateArea("center forest aa");
				rmSetAreaSize		(IDCenterForestAA, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestAA, 0.65, 0.5);
				rmSetAreaForestType	(IDCenterForestAA, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAA, 0.9);
				rmAddAreaToClass	(IDCenterForestAA, classForest);
				rmBuildArea			(IDCenterForestAA);

				int IDCenterForestAB= rmCreateArea("center forest ab");
				rmSetAreaSize		(IDCenterForestAB, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestAB, 0.5, 0.65);
				rmSetAreaForestType	(IDCenterForestAB, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAB, 0.9);
				rmAddAreaToClass	(IDCenterForestAB, classForest);
				rmBuildArea			(IDCenterForestAB);

				int IDCenterForestAC= rmCreateArea("center forest ac");
				rmSetAreaSize		(IDCenterForestAC, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestAC, 0.5, 0.35);
				rmSetAreaForestType	(IDCenterForestAC, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAC, 0.9);
				rmAddAreaToClass	(IDCenterForestAC, classForest);
				rmBuildArea			(IDCenterForestAC);

				int IDCenterForestAD= rmCreateArea("center forest ad");
				rmSetAreaSize		(IDCenterForestAD, 0.01, 0.011);
				rmSetAreaLocation	(IDCenterForestAD, 0.35, 0.5);
				rmSetAreaForestType	(IDCenterForestAD, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAD, 0.9);
				rmAddAreaToClass	(IDCenterForestAD, classForest);
				rmBuildArea			(IDCenterForestAD);
			} else {
				int IDCenterForestAE= rmCreateArea("center forest ae");
				rmSetAreaSize		(IDCenterForestAE, 0.01, 0.011);
				rmSetAreaForestType	(IDCenterForestAE, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAE, 0.9);
				rmAddAreaToClass	(IDCenterForestAE, classForest);

				int IDCenterForestAF= rmCreateArea("center forest af");
				rmSetAreaSize		(IDCenterForestAF, 0.01, 0.011);
				rmSetAreaForestType	(IDCenterForestAF, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAF, 0.9);
				rmAddAreaToClass	(IDCenterForestAF, classForest);

				int IDCenterForestAG= rmCreateArea("center forest ag");
				rmSetAreaSize		(IDCenterForestAG, 0.01, 0.011);
				rmSetAreaForestType	(IDCenterForestAG, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAG, 0.9);
				rmAddAreaToClass	(IDCenterForestAG, classForest);

				int IDCenterForestAH= rmCreateArea("center forest ah");
				rmSetAreaSize		(IDCenterForestAH, 0.01, 0.011);
				rmSetAreaForestType	(IDCenterForestAH, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAH, 0.9);
				rmAddAreaToClass	(IDCenterForestAH, classForest);

				int IDCenterForestAI= rmCreateArea("center forest ai");
				rmSetAreaSize		(IDCenterForestAI, 0.01, 0.011);
				rmSetAreaForestType	(IDCenterForestAI, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAI, 0.9);
				rmAddAreaToClass	(IDCenterForestAI, classForest);

				int IDCenterForestAJ= rmCreateArea("center forest aj");
				rmSetAreaSize		(IDCenterForestAJ, 0.01, 0.011);
				rmSetAreaForestType	(IDCenterForestAJ, "autumn oak forest");
				rmSetAreaCoherence	(IDCenterForestAJ, 0.9);
				rmAddAreaToClass	(IDCenterForestAJ, classForest);

				if (skew == 1) {
					rmSetAreaLocation	(IDCenterForestAE, 0.5, 0.6);
					rmSetAreaLocation	(IDCenterForestAF, 0.5, 0.4);
					rmSetAreaLocation	(IDCenterForestAG, 0.33, 0.6);
					rmSetAreaLocation	(IDCenterForestAH, 0.33, 0.4);
					rmSetAreaLocation	(IDCenterForestAI, 0.67, 0.6);
					rmSetAreaLocation	(IDCenterForestAJ, 0.67, 0.4);
				} else {
					rmSetAreaLocation	(IDCenterForestAE, 0.6, 0.5);
					rmSetAreaLocation	(IDCenterForestAF, 0.4, 0.5);
					rmSetAreaLocation	(IDCenterForestAG, 0.6, 0.33);
					rmSetAreaLocation	(IDCenterForestAH, 0.4, 0.33);
					rmSetAreaLocation	(IDCenterForestAI, 0.6, 0.67);
					rmSetAreaLocation	(IDCenterForestAJ, 0.4, 0.67);
				}
				rmBuildArea(IDCenterForestAE);
				rmBuildArea(IDCenterForestAF);
				rmBuildArea(IDCenterForestAG);
				rmBuildArea(IDCenterForestAH);
				rmBuildArea(IDCenterForestAI);
				rmBuildArea(IDCenterForestAJ);
			}
		}
	}

	//ponds
	int IDPondA				= rmCreateArea("pond a");
	rmSetAreaSize			(IDPondA, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
	rmSetAreaWaterType		(IDPondA, "tundra pool");
	rmSetAreaCoherence		(IDPondA, 0.8);
	rmAddAreaToClass		(IDPondA, classPond);


	int IDPondB				= rmCreateArea("pond b");
	rmSetAreaSize			(IDPondB, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
	rmSetAreaWaterType		(IDPondB, "tundra pool");
	rmSetAreaCoherence		(IDPondB, 0.8);
	rmAddAreaToClass		(IDPondB, classPond);


	int IDPondC				= rmCreateArea("pond c");
	rmSetAreaSize			(IDPondC, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
	rmSetAreaWaterType		(IDPondC, "tundra pool");
	rmSetAreaCoherence		(IDPondC, 0.8);
	rmAddAreaToClass		(IDPondC, classPond);


	int IDPondD				= rmCreateArea("pond d");
	rmSetAreaSize			(IDPondD, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
	rmSetAreaWaterType		(IDPondD, "tundra pool");
	rmSetAreaCoherence		(IDPondD, 0.8);
	rmAddAreaToClass		(IDPondD, classPond);

	if (cNumberNonGaiaPlayers > 5 && cNumberNonGaiaPlayers < 7) {
		if (skew == 1)
		{
			rmSetAreaLocation		(IDPondA, 0.05, 0.65);
			rmSetAreaLocation		(IDPondB, 0.95, 0.35);
			rmSetAreaLocation		(IDPondC, 0.65, 0.05);
			rmSetAreaLocation		(IDPondD, 0.35, 0.95);
		}
		else
		{
			rmSetAreaLocation		(IDPondA, 0.05, 0.35);
			rmSetAreaLocation		(IDPondB, 0.95, 0.65);
			rmSetAreaLocation		(IDPondC, 0.35, 0.05);
			rmSetAreaLocation		(IDPondD, 0.65, 0.95);
		}
	}
	else
	{
		rmSetAreaLocation		(IDPondA, 0.05, 0.5);
		rmSetAreaLocation		(IDPondB, 0.95, 0.5);
		rmSetAreaLocation		(IDPondC, 0.5, 0.05);
		rmSetAreaLocation		(IDPondD, 0.5, 0.95);
	}


	rmBuildArea				(IDPondA);
	rmBuildArea				(IDPondB);
	rmBuildArea				(IDPondC);
	rmBuildArea				(IDPondD);

	if (cNumberNonGaiaPlayers > 5 && cNumberNonGaiaPlayers < 7) {
		if (skew == 1) {
			int IDPondE				= rmCreateArea("pond e");
			rmSetAreaSize			(IDPondE, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
			rmSetAreaLocation		(IDPondE, 0.05, 0.05);
			rmSetAreaWaterType		(IDPondE, "tundra pool");
			rmSetAreaCoherence		(IDPondE, 0.8);
			rmAddAreaToClass		(IDPondE, classPond);
			rmBuildArea				(IDPondE);

			int IDPondF				= rmCreateArea("pond f");
			rmSetAreaSize			(IDPondF, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
			rmSetAreaLocation		(IDPondF, 0.95, 0.95);
			rmSetAreaWaterType		(IDPondF, "tundra pool");
			rmSetAreaCoherence		(IDPondF, 0.8);
			rmAddAreaToClass		(IDPondF, classPond);
			rmBuildArea				(IDPondF);
		} else {
			int IDPondG				= rmCreateArea("pond g");
			rmSetAreaSize			(IDPondG, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
			rmSetAreaLocation		(IDPondG, 0.95, 0.05);
			rmSetAreaWaterType		(IDPondG, "tundra pool");
			rmSetAreaCoherence		(IDPondG, 0.8);
			rmAddAreaToClass		(IDPondG, classPond);
			rmBuildArea				(IDPondG);

			int IDPondH				= rmCreateArea("pond h");
			rmSetAreaSize			(IDPondH, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
			rmSetAreaLocation		(IDPondH, 0.05, 0.95);
			rmSetAreaWaterType		(IDPondH, "tundra pool");
			rmSetAreaCoherence		(IDPondH, 0.8);
			rmAddAreaToClass		(IDPondH, classPond);
			rmBuildArea				(IDPondH);
		}
	} else if (cNumberNonGaiaPlayers > 7) {
		int IDPondI				= rmCreateArea("pond i");
		rmSetAreaSize			(IDPondI, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
		rmSetAreaLocation		(IDPondI, 0.05, 0.05);
		rmSetAreaWaterType		(IDPondI, "tundra pool");
		rmSetAreaCoherence		(IDPondI, 0.8);
		rmAddAreaToClass		(IDPondI, classPond);
		rmBuildArea				(IDPondI);

		int IDPondJ				= rmCreateArea("pond j");
		rmSetAreaSize			(IDPondJ, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
		rmSetAreaLocation		(IDPondJ, 0.95, 0.95);
		rmSetAreaWaterType		(IDPondJ, "tundra pool");
		rmSetAreaCoherence		(IDPondJ, 0.8);
		rmAddAreaToClass		(IDPondJ, classPond);
		rmBuildArea				(IDPondJ);

		int IDPondK				= rmCreateArea("pond k");
		rmSetAreaSize			(IDPondK, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
		rmSetAreaLocation		(IDPondK, 0.95, 0.05);
		rmSetAreaWaterType		(IDPondK, "tundra pool");
		rmSetAreaCoherence		(IDPondK, 0.8);
		rmAddAreaToClass		(IDPondK, classPond);
		rmBuildArea				(IDPondK);

		int IDPondL				= rmCreateArea("pond l");
		rmSetAreaSize			(IDPondL, rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)), rmAreaTilesToFraction(380+(60*cNumberNonGaiaPlayers)));
		rmSetAreaLocation		(IDPondL, 0.05, 0.95);
		rmSetAreaWaterType		(IDPondL, "tundra pool");
		rmSetAreaCoherence		(IDPondL, 0.8);
		rmAddAreaToClass		(IDPondL, classPond);
		rmBuildArea				(IDPondL);
	}

	//corners
	if (skew == 1) {
		int AreaCornerE			= rmCreateArea("cornerE");
		rmSetAreaSize			(AreaCornerE, 0.15, 0.15);
		rmSetAreaLocation		(AreaCornerE, 1.0, 0.0);
		rmSetAreaWarnFailure	(AreaCornerE, false);
		rmAddAreaToClass		(AreaCornerE, classCorner);
		rmSetAreaCoherence		(AreaCornerE, 1.0);

		rmBuildArea(AreaCornerE);

		int AreaCornerW			= rmCreateArea("cornerW");
		rmSetAreaSize			(AreaCornerW, 0.15, 0.15);
		rmSetAreaLocation		(AreaCornerW, 0.0, 1.0);
		rmSetAreaWarnFailure	(AreaCornerW, false);
		rmAddAreaToClass		(AreaCornerW, classCorner);
		rmSetAreaCoherence		(AreaCornerW, 1.0);

		rmBuildArea(AreaCornerW);
	} else {
		int AreaCornerN			= rmCreateArea("cornerN");
		rmSetAreaSize			(AreaCornerN, 0.15, 0.15);
		rmSetAreaLocation		(AreaCornerN, 1.0, 1.0);
		rmSetAreaWarnFailure	(AreaCornerN, false);
		rmAddAreaToClass		(AreaCornerN, classCorner);
		rmSetAreaCoherence		(AreaCornerN, 1.0);

		rmBuildArea(AreaCornerN);

		int AreaCornerS			= rmCreateArea("cornerS");
		rmSetAreaSize			(AreaCornerS, 0.15, 0.15);
		rmSetAreaLocation		(AreaCornerS, 0.0, 0.0);
		rmSetAreaWarnFailure	(AreaCornerS, false);
		rmAddAreaToClass		(AreaCornerS, classCorner);
		rmSetAreaCoherence		(AreaCornerS, 1.0);

		rmBuildArea(AreaCornerS);
	}

	int AreaNonCorner		= rmCreateArea("avoid corner");
	rmSetAreaSize			(AreaNonCorner, 0.8, 0.8);
	rmSetAreaLocation		(AreaNonCorner, 0.5, 0.5);
	rmSetAreaWarnFailure	(AreaNonCorner, false);
	rmAddAreaToClass		(AreaNonCorner, classAvoidCorner);
	rmAddAreaConstraint		(AreaNonCorner, AvoidCornerShort);
	rmSetAreaCoherence		(AreaNonCorner, 1.0);

	rmBuildArea(AreaNonCorner);

	rmSetStatusText("",0.55);
	///SETTLEMENTS
	rmPlaceObjectDefPerPlayer(IDStartingSettlement, true);

	int SettleNum = rmRandInt(0, 100);

	if (cNumberNonGaiaPlayers < 3)
	{
		if (SettleNum < 50)
		{
			int id = rmAddFairLoc("Settlement", false, true, 50, 70, 40, 16);
			rmAddFairLocConstraint(id, AvoidImpassableLandFar);
			rmAddFairLocConstraint(id, AvoidForestShort);
		}
		else
		{
			id = rmAddFairLoc("Settlement", true, false, 60, 80, 70, 25);
			rmAddFairLocConstraint(id, AvoidImpassableLandFar);
			rmAddFairLocConstraint(id, AvoidForestShort);
		}
	}
	else
	{
		id = rmAddFairLoc("Settlement", false, true, 55, 75, 40, 20);
		rmAddFairLocConstraint(id, AvoidImpassableLandFar);
		rmAddFairLocConstraint(id, AvoidForestShort);
	}

	int AvoidEdgeNum = rmRandInt(1,2);
	if (AvoidEdgeNum == 1)
	{
		int EdgeNum = 40;
	}
	else
	{
		EdgeNum = 110;
	}

	if (SettleNum > 50)
	{
		int TCAvoidNum = 80;
	}
	else
	{
		TCAvoidNum = 100;
	}


	if (cNumberNonGaiaPlayers > 3 && cNumberNonGaiaPlayers < 5)
	{
		id = rmAddFairLoc("Settlement", true, false,  65, 105, 80, EdgeNum);
		rmAddFairLocConstraint(id, AvoidImpassableLandFar);
		rmAddFairLocConstraint(id, AvoidForestShort);
	}
	else
	{
		id = rmAddFairLoc("Settlement", true, false,  70, 110, TCAvoidNum, 35);
		rmAddFairLocConstraint(id, AvoidImpassableLandFar);
		rmAddFairLocConstraint(id, AvoidForestShort);
	}

	if(rmPlaceFairLocs())
	{
		id = rmCreateObjectDef("far settlement");
		rmAddObjectDefItem(id, "Settlement", 1, 0.0);
		for(i = 1; < cNumberPlayers)
		{
			for(j = 0; < rmGetNumberFairLocs(i))
				rmPlaceObjectDefAtLoc(id, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
		}
	}

	rmResetFairLocs();

	rmSetStatusText("",0.65);
	///AREA DEFINITION

	rmSetStatusText("",0.70);
	///PLACE OBJECTS
	rmPlaceObjectDefPerPlayer(IDStartingTower, true, 4);
	rmPlaceObjectDefPerPlayer(IDStartingGold, false);
	rmPlaceObjectDefPerPlayer(IDStartingHunt, false);
	rmPlaceObjectDefPerPlayer(IDStartingBerry, false);
	rmPlaceObjectDefPerPlayer(IDStartingGoat, true);
	rmPlaceObjectDefPerPlayer(IDStragglerTree, false, rmRandInt(2,6));


	if (rmRandInt(0,100) < 35) {
		int IDMediumGold 		= rmAddFairLoc("Med goldmine", false, true,  50, 60, 20, 10);
		rmAddFairLocConstraint	(IDMediumGold, AvoidImpassableLand);
		rmAddFairLocConstraint	(IDMediumGold, AvoidSettlementAbit);
		rmAddFairLocConstraint	(IDMediumGold, AvoidAll);
		rmAddFairLocConstraint	(IDMediumGold, AvoidTower);


		if(rmPlaceFairLocs())
		{
			IDMediumGold = rmCreateObjectDef("medium goldmine");
			rmAddObjectDefItem(IDMediumGold, "gold mine", 1, 0.0);
			for(i = 1; < cNumberPlayers)
			{
				for(j = 0; < rmGetNumberFairLocs(i))
					rmPlaceObjectDefAtLoc(IDMediumGold, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
			}
		}

		rmResetFairLocs();
	}

	int ElkNumber = rmRandInt(4,8);

	int IDMediumHunt		= rmAddFairLoc("Med hunt", false, true,  50, 60, 20, 10);
	rmAddFairLocConstraint	(IDMediumHunt, AvoidImpassableLand);
	rmAddFairLocConstraint	(IDMediumHunt, AvoidAll);
	rmAddFairLocConstraint	(IDMediumHunt, AvoidTower);
	rmAddFairLocConstraint	(IDMediumHunt, AvoidHuntable);

	if(rmPlaceFairLocs())
	{
		IDMediumHunt = rmCreateObjectDef("medium hunt");
		rmAddObjectDefItem(IDMediumHunt, "elk", ElkNumber, 4.0);
		for(i = 1; <cNumberPlayers)
		{
			for(j=0; <rmGetNumberFairLocs(i))
				rmPlaceObjectDefAtLoc(IDMediumHunt, 0, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
		}
	}

	rmPlaceObjectDefPerPlayer(IDMediumElk, false, rmRandInt(1,2));

	rmPlaceObjectDefPerPlayer(IDFarAurochs, false, rmRandInt(1,2));
	rmPlaceObjectDefPerPlayer(IDFarGold, false);

	if (cNumberNonGaiaPlayers < 3)
		rmPlaceObjectDefPerPlayer(IDCornerGold, false, 3);
	else
		rmPlaceObjectDefPerPlayer(IDCornerGold, false, 2);

	rmPlaceObjectDefPerPlayer(IDCornerHunt, false, rmRandInt(1,2));
	rmPlaceObjectDefPerPlayer(IDRelic, false, 2);
	rmPlaceObjectDefPerPlayer(IDCornerPred, false);

	if (cNumberNonGaiaPlayers < 7) {
		rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond a"), 1);
		rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond b"), 1);
		rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond c"), 1);
		rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond d"), 1);
	} else {
		if (skew == 1) {
			rmPlaceObjectDefInArea(IDFish2, 0, rmAreaID("pond a"), 1);
			rmPlaceObjectDefInArea(IDFish2, 0, rmAreaID("pond b"), 1);
			rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond c"), 1);
			rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond d"), 1);
		} else {
			rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond a"), 1);
			rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond b"), 1);
			rmPlaceObjectDefInArea(IDFish2, 0, rmAreaID("pond c"), 1);
			rmPlaceObjectDefInArea(IDFish2, 0, rmAreaID("pond d"), 1);
		}
	}

	if (cNumberNonGaiaPlayers < 7) {
		if (skew == 1) {
			rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond e"), 1);
			rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond f"), 1);
		} else {
			rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond g"), 1);
			rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond h"), 1);
		}
	} else {
		rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond i"), 1);
		rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond j"), 1);
		rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond k"), 1);
		rmPlaceObjectDefInArea(IDFish, 0, rmAreaID("pond l"), 1);
	}


	rmSetStatusText("",0.80);
	///FORESTS
	int ForestCount = 12*cNumberNonGaiaPlayers;
	failCount = 0;

	for (i = 0; < ForestCount) {
		int IDForest			= rmCreateArea("forest"+i);
		rmSetAreaSize			(IDForest, rmAreaTilesToFraction(40), rmAreaTilesToFraction(80));
		rmSetAreaMinBlobs		(IDForest, 0);
		rmSetAreaMaxBlobs		(IDForest, 5);
		rmSetAreaMinBlobDistance(IDForest, 10);
		rmSetAreaMaxBlobDistance(IDForest, 25);
		rmSetAreaCoherence		(IDForest, 0.1);
		rmSetAreaForestType		(IDForest, "autumn oak forest");

		rmAddAreaToClass		(IDForest, classForest);
		rmAddAreaConstraint		(IDForest, AvoidImpassableLand);
		rmAddAreaConstraint		(IDForest, AvoidForest);
		rmAddAreaConstraint		(IDForest, AvoidAll);
		rmAddAreaConstraint		(IDForest, AvoidGoldForest);
		rmAddAreaConstraint		(IDForest, AvoidStartingSettleTiny);

		if (rmBuildArea(IDForest) == false) {
			failCount++;
			if (failCount == 3)
				break;

		else
			failCount = 0;
		}
	}


	rmPlaceObjectDefAtLoc(IDRandomTree, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);
	rmSetStatusText("",0.90);
	///BEAUTIFICATION
	int IDRocks					= rmCreateObjectDef("rocks");
	rmAddObjectDefItem			(IDRocks, "Rock Sandstone small", rmRandInt(2,4), 7.0);
	rmAddObjectDefItem			(IDRocks, "Rock Granite small", rmRandInt(2,4), 7.0);
	rmSetObjectDefMinDistance	(IDRocks, 0.0);
	rmSetObjectDefMaxDistance	(IDRocks, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRocks, AvoidAll);
	rmAddObjectDefConstraint	(IDRocks, AvoidImpassableLand);
	rmAddObjectDefConstraint	(IDRocks, AvoidSettlementAbit);
	rmPlaceObjectDefAtLoc		(IDRocks, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);

	int IDSmallRock				= rmCreateObjectDef("rock small");
	rmAddObjectDefItem			(IDSmallRock, "rock sandstone small", 1, 0.0);
	rmSetObjectDefMinDistance	(IDSmallRock, 0.0);
	rmSetObjectDefMaxDistance	(IDSmallRock, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDSmallRock, AvoidAll);
	rmPlaceObjectDefAtLoc		(IDSmallRock, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);

	int IDSprites				= rmCreateObjectDef("sprite");
	rmAddObjectDefItem			(IDSprites, "rock limestone sprite", 1, 0.0);
	rmSetObjectDefMinDistance	(IDSprites, 0.0);
	rmSetObjectDefMaxDistance	(IDSprites, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDSprites, AvoidAll);
	rmPlaceObjectDefAtLoc		(IDSprites, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);

	// RM X Finalize.
	rmxFinalize();

	rmSetStatusText("",1.00);
}