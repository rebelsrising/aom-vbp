/* Tropical Mirage
** Created by Errorcodebin And Hagrit
** Design by Keen_Flame
** Version 1.03.
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
	rmxInit("Tropical Mirage (by Hagrit & Flame)", false, false, false);

	SetUpMap(8500,11000,22000,2, "SandB");

	rmSetStatusText("",0.05);
	///CLASSES

	int classPlayer     	= rmDefineClass("player");
	int classTower      	= rmDefineClass("starting towers");
	int classForest			= rmDefineClass("forest");
	int classSand	 		= rmDefineClass("sand");
	int classSettleArea		= rmDefineClass("settle area");
	int classOutsideSettle	= rmDefineClass("outside settle");
	int classHippo			= rmDefineClass("hippo");
	int classCliff			= rmDefineClass("cliff");
	int classOases			= rmDefineClass("oases");
	int classOasesHunt		= rmDefineClass("oases hunt");
	int classCorner			= rmDefineClass("corner");
	int classAvoidCorner	= rmDefineClass("avoid corner");

	rmSetStatusText("",0.10);

	///CONSTRAINTS
	int AvoidEdgeShort	= rmCreateBoxConstraint			 ("0", rmXTilesToFraction(2), rmZTilesToFraction(2), 1.0-rmXTilesToFraction(2), 1.0-rmZTilesToFraction(2));
	int AvoidEdgeMed	= rmCreateBoxConstraint			 ("1", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0-rmXTilesToFraction(8), 1.0-rmZTilesToFraction(8));
	int AvoidEdgeFar	= rmCreateBoxConstraint			 ("2", rmXTilesToFraction(15), rmZTilesToFraction(15), 1.0-rmXTilesToFraction(15), 1.0-rmZTilesToFraction(15));

	int AvoidAll				= rmCreateTypeDistanceConstraint("3", "all", 6.0);
	int AvoidSettlementSlightly = rmCreateTypeDistanceConstraint("4", "AbstractSettlement", 12.0);
	int AvoidSettlementAbit		= rmCreateTypeDistanceConstraint("5", "AbstractSettlement", 20.0);
	int AvoidSettlementSomewhat = rmCreateTypeDistanceConstraint("6", "AbstractSettlement", 30.0);
	int AvoidOtherTower			= rmCreateTypeDistanceConstraint("7", "tower", 20.0);
	int AvoidGoldMed			= rmCreateTypeDistanceConstraint("8",  "gold", 15.0);
	int AvoidGoldFar			= rmCreateTypeDistanceConstraint("9", "gold", 35.0);
	int AvoidHunt				= rmCreateTypeDistanceConstraint("10", "huntable", 25.0);
	int AvoidGoat				= rmCreateTypeDistanceConstraint("11", "goat", 30.0);
	int AvoidStartingTower		= rmCreateTypeDistanceConstraint("12", "tower", 34.0);
	int AvoidHomeTC				= rmCreateTypeDistanceConstraint("13", "settlement level 1", 20.0);

	int AvoidPlayerFar 				= rmCreateClassDistanceConstraint("14", classPlayer, 35.0);
	int AvoidPlayer 				= rmCreateClassDistanceConstraint("15", classPlayer, 20.0);
	int AvoidForestShort			= rmCreateClassDistanceConstraint("18", classForest, 15.0);
	int AvoidSandArea				= rmCreateClassDistanceConstraint("22", classSand, 2);
	int AvoidSandAreaLong			= rmCreateClassDistanceConstraint("23", classSand, 5);
	int AvoidSandAreaLongest		= rmCreateClassDistanceConstraint("24", classSand, 8);
	int AvoidSettleArea				= rmCreateClassDistanceConstraint("25", classSettleArea, 2);
	int AvoidSettleAreaLong			= rmCreateClassDistanceConstraint("26", classSettleArea, 5);
	int AvoidSettleAreaLonger		= rmCreateClassDistanceConstraint("27", classSettleArea, 12);
	int AvoidOases					= rmCreateClassDistanceConstraint("28", classOases, 2);
	int AvoidOasesMed				= rmCreateClassDistanceConstraint("29", classOases, 5);
	int AvoidOasesLong				= rmCreateClassDistanceConstraint("30", classOases, 10);
	int AvoidOasesFar				= rmCreateClassDistanceConstraint("31", classOases, 20.0);
	int AvoidHippo					= rmCreateClassDistanceConstraint("32", classHippo, 60);
	int AvoidCliffLong				= rmCreateClassDistanceConstraint("33", classCliff, 40.0);
	int AvoidCliffShort				= rmCreateClassDistanceConstraint("34", classCliff, 10.0);
	int AvoidCliffShorter			= rmCreateClassDistanceConstraint("35", classCliff, 5.0);
	int AvoidCornerShort			= rmCreateClassDistanceConstraint("36", classCorner, 5.0);
	int AvoidCorner					= rmCreateClassDistanceConstraint("37", classCorner, 10.0);
	int inCorner					= rmCreateClassDistanceConstraint("38", classAvoidCorner, 1.0);

	int AvoidSettleFar				= rmCreateClassDistanceConstraint("40", classSettleArea, 12.0);

	int AvoidLand 				= rmCreateTerrainDistanceConstraint("41", "land", true, 5.0);
	int AvoidImpassableLand		= rmCreateTerrainDistanceConstraint("42", "land", false, 4.0);

	rmSetStatusText("",0.20);
	///OBJECT DEFINIIONS

	//starting
	int IDStartingSettlement  = rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem        (IDStartingSettlement, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass     (IDStartingSettlement, classPlayer);
	rmSetObjectDefMinDistance (IDStartingSettlement, 0.0);
	rmSetObjectDefMaxDistance (IDStartingSettlement, 0.0);

	int IDStartingTower 	  = rmCreateObjectDef("starting towers");
	rmAddObjectDefItem        (IDStartingTower, "tower", 1, 0.0);
	rmAddObjectDefConstraint  (IDStartingTower, AvoidOtherTower);
	rmAddObjectDefConstraint  (IDStartingTower, AvoidSandAreaLong);
	rmSetObjectDefMinDistance (IDStartingTower, 21.0);
	rmSetObjectDefMaxDistance (IDStartingTower, 30.0);

	int IDStartingGold		  = rmCreateObjectDef("starting goldmine");
	rmAddObjectDefItem        (IDStartingGold, "Gold mine small", 1, 0.0);
	rmAddObjectDefConstraint  (IDStartingGold, AvoidSandAreaLong);
	rmSetObjectDefMinDistance (IDStartingGold, 21.0);
	rmSetObjectDefMaxDistance (IDStartingGold, 24.0);

	int IDStartingBerry 	  = rmCreateObjectDef("starting berry");
	rmAddObjectDefItem        (IDStartingBerry, "berry bush", rmRandInt(5.0, 9.0), 3);
	rmSetObjectDefMinDistance (IDStartingBerry, 20.0);
	rmSetObjectDefMaxDistance (IDStartingBerry, 27.0);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidSandArea);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidAll);

	int startingHuntable	= rmRandInt(0, 100);

	int IDStartingHunt		  = rmCreateObjectDef("starting hunt");

	if(startingHuntable < 33)
	{
		rmAddObjectDefItem        (IDStartingHunt, "Gazelle", rmRandInt(4.0, 8.0), 4);
	} else if(startingHuntable < 66)
		rmAddObjectDefItem        (IDStartingHunt, "Zebra", rmRandInt(3.0, 6.0), 4);
	else
		rmAddObjectDefItem        (IDStartingHunt, "Hippo", rmRandInt(1.0, 3.0), 3);

	rmSetObjectDefMinDistance (IDStartingHunt, 24.0);
	rmSetObjectDefMaxDistance (IDStartingHunt, 28.0);
	rmAddObjectDefConstraint  (IDStartingHunt, AvoidSandAreaLong);
	rmAddObjectDefConstraint  (IDStartingHunt, AvoidAll);

	int IDStartingHerd	 	  = rmCreateObjectDef("starting goat");
	rmAddObjectDefItem        (IDStartingHerd, "goat", rmRandInt(2.0, 3.0), 4);
	rmSetObjectDefMinDistance (IDStartingHerd, 25.0);
	rmSetObjectDefMaxDistance (IDStartingHerd, 30.0);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidAll);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidSandArea);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidGoat);

	int IDStragglerTree		  = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem		  (IDStragglerTree, "savannah tree", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTree, 12.0);
	rmSetObjectDefMaxDistance (IDStragglerTree, 15.0);

	//medium
	int IDMediumGoldmine 	  	= rmCreateObjectDef("Medium goldmine");
	rmAddObjectDefItem        	(IDMediumGoldmine, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDMediumGoldmine, 52.0);
	rmSetObjectDefMaxDistance 	(IDMediumGoldmine, 80.0);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidEdgeMed);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidSettleAreaLong);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidOasesMed);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidAll);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidCliffShort);
	if (rmRandFloat(0.0,1.0) < 0.25)
		rmAddObjectDefConstraint	(IDMediumGoldmine, inCorner);
	else
		rmAddObjectDefConstraint	(IDMediumGoldmine, AvoidCorner);


	int IDMediumHunt 	 	  	= rmCreateObjectDef("Medium hunt");
	rmAddObjectDefItem        	(IDMediumHunt, "zebra", (rmRandInt(4.0, 7.0)), 4.0);
	rmSetObjectDefMinDistance 	(IDMediumHunt, 50.0);
	rmSetObjectDefMaxDistance 	(IDMediumHunt, 65.0);
	rmAddObjectDefConstraint  	(IDMediumHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint  	(IDMediumHunt, AvoidHunt);
	rmAddObjectDefConstraint  	(IDMediumHunt, AvoidSettleAreaLong);
	rmAddObjectDefConstraint  	(IDMediumHunt, AvoidOasesMed);
	rmAddObjectDefConstraint  	(IDMediumHunt, AvoidStartingTower);
	rmAddObjectDefConstraint  	(IDMediumHunt, AvoidAll);
	rmAddObjectDefConstraint  	(IDMediumHunt, AvoidCliffShorter);

	int IDMediumHerd 	 	  	= rmCreateObjectDef("Medium herd");
	rmAddObjectDefItem        	(IDMediumHerd, "goat", 2, 4.0);
	rmSetObjectDefMinDistance 	(IDMediumHerd, 50.0);
	rmSetObjectDefMaxDistance 	(IDMediumHerd, 100.0);
	rmAddObjectDefConstraint  	(IDMediumHerd, AvoidEdgeShort);
	rmAddObjectDefConstraint  	(IDMediumHerd, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDMediumHerd, AvoidGoat);
	rmAddObjectDefConstraint  	(IDMediumHerd, AvoidAll);
	rmAddObjectDefConstraint  	(IDMediumHerd, AvoidCliffShorter);

	rmSetStatusText("",0.35);
	//far

	int IDFarEllys		 	 	= rmCreateObjectDef("far ellys");
	rmAddObjectDefItem       	(IDFarEllys, "elephant", rmRandInt(1, 2), 4);
	rmSetObjectDefMinDistance	(IDFarEllys, 75.0);
	rmSetObjectDefMaxDistance	(IDFarEllys, 100.0);
	rmAddObjectDefConstraint 	(IDFarEllys, AvoidEdgeMed);
	rmAddObjectDefConstraint 	(IDFarEllys, AvoidHunt);
	rmAddObjectDefConstraint 	(IDFarEllys, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint 	(IDFarEllys, AvoidSettleAreaLong);
	rmAddObjectDefConstraint 	(IDFarEllys, AvoidOasesMed);
	rmAddObjectDefConstraint 	(IDFarEllys, AvoidAll);
	rmAddObjectDefConstraint 	(IDFarEllys, AvoidCliffShorter);

	int IDFarHippo		 	  	= rmCreateObjectDef("far hippo");

	if (rmRandInt(0, 100) < 30)
		rmAddObjectDefItem  	(IDFarHippo, "giraffe", rmRandInt(3.0, 6.0), 4);
	else
		rmAddObjectDefItem		(IDFarHippo, "giraffe", rmRandInt(3.0, 6.0), 4);

	rmSetObjectDefMinDistance	(IDFarHippo, 0.0);
	rmSetObjectDefMaxDistance	(IDFarHippo, rmXFractionToMeters(1.0));
	rmAddObjectDefToClass    	(IDFarHippo, classHippo);
	rmAddObjectDefConstraint 	(IDFarHippo, AvoidSandAreaLongest);
	rmAddObjectDefConstraint 	(IDFarHippo, AvoidOases);
	rmAddObjectDefConstraint 	(IDFarHippo, AvoidEdgeMed);
	rmAddObjectDefConstraint 	(IDFarHippo, AvoidHippo);
	rmAddObjectDefConstraint 	(IDFarHippo, AvoidPlayer);
	rmAddObjectDefConstraint 	(IDFarHippo, AvoidSettlementSlightly);

	int IDFarGold		 	  = rmCreateObjectDef("far gold");
	rmAddObjectDefItem        (IDFarGold, "gold mine", 1, 0);
	rmSetObjectDefMinDistance (IDFarGold, 75.0);
	rmSetObjectDefMaxDistance (IDFarGold, 110.0);
	rmAddObjectDefConstraint  (IDFarGold, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDFarGold, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDFarGold, AvoidSettleAreaLong);
	rmAddObjectDefConstraint  (IDFarGold, AvoidOasesMed);
	rmAddObjectDefConstraint  (IDFarGold, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarGold, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarGold, AvoidAll);
	rmAddObjectDefConstraint  (IDFarGold, AvoidCliffShort);

	if (rmRandInt(0, 100) < 60)
	{
		int IDFarBonusHunt		 	= rmCreateObjectDef("far bonus hunt");
		rmAddObjectDefItem       	(IDFarBonusHunt, "gazelle", rmRandInt(2, 5), 4);
		rmAddObjectDefItem       	(IDFarBonusHunt, "Zebra", rmRandInt(1, 4), 4);
		rmSetObjectDefMinDistance	(IDFarBonusHunt, 90.0);
		rmSetObjectDefMaxDistance	(IDFarBonusHunt, 120.0);
		rmAddObjectDefConstraint 	(IDFarBonusHunt, AvoidEdgeMed);
		rmAddObjectDefConstraint 	(IDFarBonusHunt, AvoidHunt);
		rmAddObjectDefConstraint 	(IDFarBonusHunt, AvoidSettlementSomewhat);
		rmAddObjectDefConstraint 	(IDFarBonusHunt, AvoidSettleAreaLong);
		rmAddObjectDefConstraint 	(IDFarBonusHunt, AvoidOasesFar);
		rmAddObjectDefConstraint 	(IDFarBonusHunt, AvoidAll);
		rmAddObjectDefConstraint 	(IDFarBonusHunt, AvoidCliffShorter);
	}

	int IDFarGoat		 	  = rmCreateObjectDef("far goat");
	rmAddObjectDefItem        (IDFarGoat, "goat", rmRandInt(2,3), 1);
	rmSetObjectDefMinDistance (IDFarGoat, 80);
	rmSetObjectDefMaxDistance (IDFarGoat, 140);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidSettleArea);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidOases);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidCliffShorter);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidGoat);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidAll);

	int IDFarPredator	 	  = rmCreateObjectDef("far predator");
	rmAddObjectDefItem        (IDFarPredator, "hyena", rmRandInt(2, 3), 5);
	rmSetObjectDefMinDistance (IDFarPredator, 90.0);
	rmSetObjectDefMaxDistance (IDFarPredator, 150.0);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidAll);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidCliffShorter);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidSettleAreaLonger);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidOasesLong);
	rmAddObjectDefConstraint  (IDFarPredator, rmCreateTypeDistanceConstraint("pred vs pred", "animalpredator", 50.0));

	//other
	int IDSettlementOut 	  =rmCreateObjectDef("far settlement2");
	rmAddObjectDefItem		  (IDSettlementOut, "Settlement", 1, 0.0);

	int IDHawk 			      = rmCreateObjectDef("hawks");
	rmAddObjectDefItem		  (IDHawk, "hawk", 1, 0.0);
	rmSetObjectDefMinDistance (IDHawk, 0.0);
	rmSetObjectDefMaxDistance (IDHawk, rmXFractionToMeters(0.5));

	int IDrelic				  = rmCreateObjectDef("relic");
	rmAddObjectDefItem		  (IDrelic, "relic", 1, 0.0);
	rmSetObjectDefMinDistance (IDrelic, 70.0);
	rmSetObjectDefMaxDistance (IDrelic, 150.0);
	rmAddObjectDefConstraint  (IDrelic, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDrelic, rmCreateTypeDistanceConstraint("relic vs relic", "relic", 70.0));
	rmAddObjectDefConstraint  (IDrelic, AvoidSettleAreaLonger);
	rmAddObjectDefConstraint  (IDrelic, AvoidOasesLong);
	rmAddObjectDefConstraint  (IDrelic, AvoidImpassableLand);

	int IDStragglerTrees	  = rmCreateObjectDef("straggler trees");
	rmAddObjectDefItem		  (IDStragglerTrees, "palm", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTrees, 0.0);
	rmSetObjectDefMaxDistance (IDStragglerTrees, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint  (IDStragglerTrees, AvoidAll);
	rmAddObjectDefConstraint  (IDStragglerTrees, AvoidSandArea);

	rmSetStatusText("",0.40);
	// Place players
	rmPlacePlayersCircular(0.38, 0.40, rmDegreesToRadians(3.0));

	///TERRAIN DEFINITION

	float playerFraction=rmAreaTilesToFraction(1400);
	for(i=1; <cNumberPlayers)
	{
		int AreaPlayer =rmCreateArea("Player"+i);

		rmSetPlayerArea			(i, AreaPlayer);
		rmSetAreaSize			(AreaPlayer, playerFraction, playerFraction);
		rmAddAreaToClass		(AreaPlayer, classSettleArea);
		rmAddAreaToClass		(AreaPlayer, classPlayer);
		rmSetAreaMinBlobs		(AreaPlayer, 3);
		rmSetAreaMaxBlobs		(AreaPlayer, 4);
		rmSetAreaMinBlobDistance(AreaPlayer, 20.0);
		rmSetAreaMaxBlobDistance(AreaPlayer, 25.0);
		rmSetAreaCoherence		(AreaPlayer, 0.5);
		rmSetAreaCliffType		(AreaPlayer, "Egyptian");
		rmSetAreaCliffEdge		(AreaPlayer, 2, 0.0, 0.0, 1.0, 1);
		rmSetAreaCliffHeight	(AreaPlayer, 0, 0.0, 1);
		rmSetAreaSmoothDistance (AreaPlayer, 20);
		rmSetAreaLocPlayer		(AreaPlayer, i);
		rmSetAreaTerrainType	(AreaPlayer, "GrassA");
		rmAddAreaTerrainLayer	(AreaPlayer, "GrassDirt25", 2, 3);
		rmAddAreaTerrainLayer	(AreaPlayer, "GrassDirt50", 1, 2);
		rmAddAreaTerrainLayer	(AreaPlayer, "GrassDirt75", 0, 1);

	}
	rmBuildAllAreas();

	int AreaCornerN			= rmCreateArea("cornerN");
	rmSetAreaSize			(AreaCornerN, 0.05, 0.05);
	rmSetAreaLocation		(AreaCornerN, 1.0, 1.0);
	rmSetAreaWarnFailure	(AreaCornerN, false);
	rmAddAreaToClass		(AreaCornerN, classCorner);
	rmSetAreaCoherence		(AreaCornerN, 1.0);

	rmBuildArea(AreaCornerN);

	int AreaCornerE			= rmCreateArea("cornerE");
	rmSetAreaSize			(AreaCornerE, 0.05, 0.05);
	rmSetAreaLocation		(AreaCornerE, 1.0, 0.0);
	rmSetAreaWarnFailure	(AreaCornerE, false);
	rmAddAreaToClass		(AreaCornerE, classCorner);
	rmSetAreaCoherence		(AreaCornerE, 1.0);

	rmBuildArea(AreaCornerE);

	int AreaCornerS			= rmCreateArea("cornerS");
	rmSetAreaSize			(AreaCornerS, 0.05, 0.05);
	rmSetAreaLocation		(AreaCornerS, 0.0, 1.0);
	rmSetAreaWarnFailure	(AreaCornerS, false);
	rmAddAreaToClass		(AreaCornerS, classCorner);
	rmSetAreaCoherence		(AreaCornerS, 1.0);

	rmBuildArea(AreaCornerS);

	int AreaCornerW			= rmCreateArea("cornerW");
	rmSetAreaSize			(AreaCornerW, 0.05, 0.05);
	rmSetAreaLocation		(AreaCornerW, 0.0, 0.0);
	rmSetAreaWarnFailure	(AreaCornerW, false);
	rmAddAreaToClass		(AreaCornerW, classCorner);
	rmSetAreaCoherence		(AreaCornerW, 1.0);

	rmBuildArea(AreaCornerW);

	int AreaNonCorner		= rmCreateArea("avoid corner");
	rmSetAreaSize			(AreaNonCorner, 0.7, 0.7);
	rmSetAreaLocation		(AreaNonCorner, 0.5, 0.5);
	rmSetAreaWarnFailure	(AreaNonCorner, false);
	rmAddAreaToClass		(AreaNonCorner, classAvoidCorner);
	rmAddAreaConstraint		(AreaNonCorner, AvoidCornerShort);
	rmSetAreaCoherence		(AreaNonCorner, 1.0);

	rmBuildArea(AreaNonCorner);

	rmSetStatusText("",0.55);
	///SETTLEMENTS + AREA
	rmPlaceObjectDefPerPlayer(IDStartingSettlement, true);

	int FairLocID = 0;
	if (cNumberNonGaiaPlayers < 3) {
		FairLocID = rmAddFairLoc("Settlement", false, true,  70, 90, 80, 65); //1v1
	} else if (cNumberNonGaiaPlayers > 2)
		FairLocID = rmAddFairLoc("Settlement", false, true,  60, 105, 50, 30); //2v2 ++
	rmAddFairLocConstraint	(FairLocID, AvoidPlayer);

	if (cNumberNonGaiaPlayers < 3) {
		FairLocID = rmAddFairLoc("Settlement", true, false,  85, 105, 60, 65); //1v1
	} else if (cNumberNonGaiaPlayers > 5) {
		FairLocID = rmAddFairLoc("Settlement", true, false,  85, 135, 80, 50); //3v3 ++
	} else
		FairLocID = rmAddFairLoc("Settlement", true, false,  90, 135, 100, 65);  //2v2
	rmAddFairLocConstraint	(FairLocID, AvoidPlayer);


	bool FairLocCreationSuccess = rmPlaceFairLocs();
	if (FairLocCreationSuccess)
	{
		int NumArea = 0;
		int NumTreeArea = 0;
		for (i = 1; < cNumberPlayers)
		{
			for (j = 0; < rmGetNumberFairLocs(i))
			{
				// Get Settlement Positions In Fraction
				float XPosFraction    	= rmFairLocXFraction(i, j);
				float ZPosFraction    	= rmFairLocZFraction(i, j);

				// Define an Area on those positions.
				int AreaSettlement    	= rmCreateArea("Settlement" + NumArea);
				rmSetAreaLocation    	(AreaSettlement, XPosFraction, ZPosFraction);
				rmAddAreaToClass		(AreaSettlement, classSettleArea);
				rmAddAreaToClass		(AreaSettlement, classOutsideSettle);
				rmSetAreaMinBlobs		(AreaSettlement, 0);
				rmSetAreaMaxBlobs		(AreaSettlement, 4);
				rmSetAreaMinBlobDistance(AreaSettlement, 10.0);
				rmSetAreaMaxBlobDistance(AreaSettlement, 30.0);
				rmSetAreaCoherence		(AreaSettlement, 1.0);
				rmSetAreaCliffType		(AreaSettlement, "Norse");
				rmSetAreaCliffEdge		(AreaSettlement, 2, 0.0, 0.0, 1.0, 1);
				rmSetAreaCliffHeight	(AreaSettlement, 0, 0.0, 1);
				rmSetAreaSmoothDistance	(AreaSettlement, 20);
				rmAddAreaConstraint		(AreaSettlement, AvoidSettleAreaLonger);

				rmSetAreaSize			(AreaSettlement, playerFraction/1.5, playerFraction/1.5);

				rmSetAreaTerrainType	(AreaSettlement, "GrassA");
				rmAddAreaTerrainLayer	(AreaSettlement, "GrassDirt25", 2, 3);
				rmAddAreaTerrainLayer	(AreaSettlement, "GrassDirt50", 1, 2);
				rmAddAreaTerrainLayer	(AreaSettlement, "GrassDirt75", 0, 1);

				// Build it..
				rmBuildArea(AreaSettlement);
				NumArea = NumArea + 1; // Increment Settlement Area
			}
		}

		// Place the settlements after building the settlement areas
		for(i=1; <cNumberPlayers)
		{
			for(j=0; <rmGetNumberFairLocs(i))
			{
				rmPlaceObjectDefAtLoc(IDSettlementOut, i, rmFairLocXFraction(i, j), rmFairLocZFraction(i, j), 1);
			}
		}
	}

	float OasesFraction=rmAreaTilesToFraction(400);
	int AreaOases = 0;
	int IDBonusHunt = 0;
	int failCount = 0;
	int gazelleNum = rmRandInt(6,9);

	for(i = 0; < 1*cNumberNonGaiaPlayers)
	{
		AreaOases 				= rmCreateArea("AreaOases "+i);

		rmSetAreaSize			(AreaOases, OasesFraction*1.1, OasesFraction/1.1);
		rmAddAreaToClass		(AreaOases, classOases);
		rmAddAreaConstraint		(AreaOases, AvoidSettleFar);
		rmAddAreaConstraint		(AreaOases, AvoidOasesLong);
		rmAddAreaConstraint		(AreaOases, AvoidPlayerFar);
		rmAddAreaConstraint		(AreaOases, AvoidEdgeShort);
		rmAddAreaConstraint		(AreaOases, AvoidOasesFar);
		rmSetAreaMinBlobs		(AreaOases, 0);
		rmSetAreaMaxBlobs		(AreaOases, 5);
		rmSetAreaMinBlobDistance(AreaOases, 5.0);
		rmSetAreaMaxBlobDistance(AreaOases, 10.0);
		rmSetAreaCoherence		(AreaOases, 0.0);
		rmSetAreaCliffType		(AreaOases, "Egyptian");
		rmSetAreaCliffEdge		(AreaOases, 2, 0.0, 0.0, 1.0, 1);
		rmSetAreaCliffHeight	(AreaOases, 0, 0.0, 1);
		rmSetAreaSmoothDistance (AreaOases, 25);
		rmSetAreaTerrainType	(AreaOases, "GrassA");
		rmAddAreaTerrainLayer	(AreaOases, "GrassDirt25", 2, 3);
		rmAddAreaTerrainLayer	(AreaOases, "GrassDirt50", 1, 2);
		rmAddAreaTerrainLayer	(AreaOases, "GrassDirt75", 0, 1);

		//rmBuildArea(AreaOases);

		if(rmBuildArea(AreaOases)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount == 10)
				break;
		}
		else
			failCount=0;


		IDBonusHunt				 = rmCreateObjectDef("gazelle "+i);
		rmAddObjectDefItem		 (IDBonusHunt, "gazelle", gazelleNum, 4);
		rmSetObjectDefMinDistance(IDBonusHunt, 0.0);
		rmSetObjectDefMaxDistance(IDBonusHunt, 5.0);
		rmAddObjectDefConstraint (IDBonusHunt, AvoidSandAreaLong);
		rmPlaceObjectDefInArea	 (IDBonusHunt, false, rmAreaID("AreaOases "+i));

	}

	rmSetStatusText("",0.60);

	float mapFraction=rmAreaTilesToFraction(500);
	int avoidTc=rmCreateClassDistanceConstraint("sandmap to settlements", classSettleArea, 1.0);
	int avoidOases=rmCreateClassDistanceConstraint("sandmap to oases", classOases, 1.0);

	int numTries=150*cNumberNonGaiaPlayers;
	failCount=0;
	for(i=0; <numTries)
	{
		int IDSandArea			=rmCreateArea("sandarea"+i);
		rmSetAreaSize			(IDSandArea, mapFraction, mapFraction);
		rmSetAreaTerrainType	(IDSandArea, "SandB");
		rmAddAreaToClass		(IDSandArea, classSand);
		rmAddAreaConstraint		(IDSandArea, avoidTc);
		rmAddAreaConstraint		(IDSandArea, avoidOases);
		rmSetAreaWarnFailure	(IDSandArea, false);

		if(rmBuildArea(IDSandArea)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}

	rmSetStatusText("",0.65);
	/// ELEV
	failCount = 0;
	for(i = 0; < 10*cNumberNonGaiaPlayers)
	{
		int IDelev				=rmCreateArea("elev"+i);
		rmSetAreaSize			(IDelev, rmAreaTilesToFraction(250), rmAreaTilesToFraction(300));
		rmSetAreaWarnFailure	(IDelev, false);
		rmAddAreaConstraint		(IDelev, AvoidSettlementAbit);
		rmAddAreaConstraint		(IDelev, AvoidCliffShort);

		rmSetAreaBaseHeight		(IDelev, rmRandFloat(2.0, 4.0));
		rmSetAreaHeightBlend	(IDelev, 2);
		rmSetAreaMinBlobs		(IDelev, 1);
		rmSetAreaMaxBlobs		(IDelev, 5);
		rmSetAreaMinBlobDistance(IDelev, 16.0);
		rmSetAreaMaxBlobDistance(IDelev, 40.0);
		rmSetAreaCoherence		(IDelev, 0.8);

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
	rmSetStatusText("",0.70);

	numTries = 5*cNumberNonGaiaPlayers;
	failCount = 0;
	for(i = 0; < numTries)
	{
		int IDRocky				= rmCreateArea("rocky terrain"+i);
		rmSetAreaSize			(IDRocky, rmAreaTilesToFraction(50), rmAreaTilesToFraction(100));
		rmSetAreaWarnFailure	(IDRocky, false);
		rmSetAreaMinBlobs		(IDRocky, 1);
		rmSetAreaMaxBlobs		(IDRocky, 1);
		rmSetAreaTerrainType	(IDRocky, "SandDirt50");
		rmAddAreaTerrainLayer	(IDRocky, "SandA", 0, 1);
		rmSetAreaBaseHeight		(IDRocky, rmRandFloat(3.0, 4.0));
		rmSetAreaMinBlobDistance(IDRocky, 16.0);
		rmSetAreaMaxBlobDistance(IDRocky, 20.0);
		rmSetAreaCoherence		(IDRocky, 1.0);
		rmSetAreaSmoothDistance	(IDRocky, 10);
		rmAddAreaConstraint		(IDRocky, AvoidSettleAreaLong);
		rmAddAreaConstraint		(IDRocky, avoidOases);

		if(rmBuildArea(IDRocky)==false)
		{
			failCount++;
			if(failCount == 5)
			break;
		}
		else
			failCount = 0;
	}

	///CLIFFS
	numTries = 3*cNumberNonGaiaPlayers;
	failCount = 0;
	for(k = 0; < numTries)
	{
		int IDCliff				=rmCreateArea("cliff"+k);
		rmSetAreaWarnFailure	(IDCliff, false);
		rmSetAreaSize			(IDCliff, rmAreaTilesToFraction(120), rmAreaTilesToFraction(180));
		rmSetAreaCliffType		(IDCliff, "Egyptian");
		rmAddAreaToClass		(IDCliff, classCliff);
		rmSetAreaTerrainType	(IDCliff, "CliffEgyptianA");
		rmSetAreaMinBlobs		(IDCliff, 1);
		rmSetAreaMaxBlobs		(IDCliff, 2);
		rmSetAreaCliffEdge		(IDCliff, 1.0, 1.0, 0.0, 1.0, 0);
		rmSetAreaCliffPainting	(IDCliff, true, true, true, 1.5, false);
		rmSetAreaCliffHeight	(IDCliff, 7, 1.0, 1.0);
		rmSetAreaMinBlobDistance(IDCliff, 8.0);
		rmSetAreaMaxBlobDistance(IDCliff, 16.0);
		rmSetAreaCoherence		(IDCliff, 0.25);
		rmSetAreaSmoothDistance	(IDCliff, 8);
		rmSetAreaHeightBlend	(IDCliff, 2);

		rmAddAreaConstraint		(IDCliff, AvoidSettleAreaLonger);
		rmAddAreaConstraint		(IDCliff, AvoidOasesLong);
		rmAddAreaConstraint		(IDCliff, AvoidCliffLong);

		if(rmBuildArea(IDCliff)==false)
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

	///OBJECT PLACEMENT
	rmPlaceObjectDefPerPlayer(IDStartingTower, true, 4);
	rmPlaceObjectDefPerPlayer(IDStartingGold, false);
	rmPlaceObjectDefPerPlayer(IDStartingBerry, false);
	rmPlaceObjectDefPerPlayer(IDStartingHunt, false);
	rmPlaceObjectDefPerPlayer(IDStartingHerd, true);
	rmPlaceObjectDefPerPlayer(IDStragglerTree, false, rmRandInt(2.0, 4.0));
	rmPlaceObjectDefPerPlayer(IDMediumGoldmine, false);
	rmPlaceObjectDefPerPlayer(IDMediumHunt, false);
	rmPlaceObjectDefPerPlayer(IDMediumHerd, false, rmRandInt(3.0, 4.0));
	rmPlaceObjectDefPerPlayer(IDFarEllys, false);
	rmPlaceObjectDefPerPlayer(IDFarHippo, false, 2);
	rmPlaceObjectDefPerPlayer(IDFarBonusHunt, false);
	rmPlaceObjectDefPerPlayer(IDFarGold, false, rmRandInt(2.0, 3.0));

	rmSetStatusText("",0.85);
	//FORESTS
	int forestCount = 12*cNumberNonGaiaPlayers;
	failCount = 0;

	for(i = 0; < forestCount)
	{
		int IDForest		= rmCreateArea("forest"+i);
		rmSetAreaSize		(IDForest, rmAreaTilesToFraction(60), rmAreaTilesToFraction(100));
		rmSetAreaWarnFailure(IDForest, false);
		rmSetAreaForestType (IDForest, "palm forest");
		rmAddAreaConstraint (IDForest, AvoidSandArea);
		rmAddAreaConstraint (IDForest, AvoidForestShort);
		rmAddAreaConstraint (IDForest, AvoidHomeTC);
		rmAddAreaConstraint (IDForest, AvoidSettlementSlightly);
		rmAddAreaConstraint (IDForest, AvoidAll);
		rmAddAreaToClass	(IDForest, classForest);
		rmSetAreaCoherence	(IDForest, 1.0);

		if(rmBuildArea(IDForest) == false)
		{
			failCount++;
			if(failCount == 5)
				break;
		}
		else
			failCount = 0;
	}


	rmPlaceObjectDefPerPlayer(IDFarGoat, false, rmRandInt(1.0, 2.0));
	rmPlaceObjectDefPerPlayer(IDFarPredator, false, rmRandInt(2.0, 3.0));
	rmPlaceObjectDefPerPlayer(IDrelic, false);
	rmPlaceObjectDefPerPlayer(IDHawk, false, rmRandInt(2.0, 6.0));
	rmPlaceObjectDefAtLoc(IDStragglerTrees, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);

	rmSetStatusText("",0.90);
	///BEAUTIFICATION
	int IDPyramid			 	 = rmCreateObjectDef("pyramid");
	rmAddObjectDefItem		 	 (IDPyramid, "pyramid small", 1, 0.0);
	rmSetObjectDefMinDistance	 (IDPyramid, 0.0);
	rmSetObjectDefMaxDistance	 (IDPyramid, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint 	 (IDPyramid, AvoidAll);
	rmAddObjectDefConstraint 	 (IDPyramid, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint 	 (IDPyramid, AvoidSettleAreaLonger);
	rmAddObjectDefConstraint 	 (IDPyramid, AvoidOasesLong);
	rmAddObjectDefConstraint 	 (IDPyramid, AvoidStartingTower);
	rmAddObjectDefConstraint 	 (IDPyramid, AvoidCliffLong);
	rmAddObjectDefConstraint 	 (IDPyramid, AvoidEdgeMed);
	rmAddObjectDefConstraint 	 (IDPyramid, AvoidGoldMed);
	rmAddObjectDefConstraint 	 (IDPyramid, rmCreateTypeDistanceConstraint("pyramid vs pyramid", "pyramid small", 90.0));
	rmAddObjectDefConstraint 	 (IDPyramid, rmCreateTypeDistanceConstraint("relic vs pyramid", "relic", 10.0));
	rmPlaceObjectDefPerPlayer	 (IDPyramid, false, 1);

	int IDBush					= rmCreateObjectDef("big bush patch");
	rmAddObjectDefItem			(IDBush, "bush", 3, 5.0);
	rmSetObjectDefMinDistance	(IDBush, 0.0);
	rmSetObjectDefMaxDistance	(IDBush, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDBush, AvoidImpassableLand);
	rmPlaceObjectDefAtLoc		(IDBush, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);

	int IDFlowers				= rmCreateObjectDef("flowers patch");
	rmAddObjectDefItem			(IDFlowers, "flowers", 2, 5.0);
	rmSetObjectDefMinDistance	(IDFlowers, 0.0);
	rmSetObjectDefMaxDistance	(IDFlowers, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDFlowers, AvoidAll);
	rmAddObjectDefConstraint	(IDFlowers, AvoidSandAreaLong);
	rmPlaceObjectDefAtLoc		(IDFlowers, 0, 0.5, 0.5, 30*cNumberNonGaiaPlayers);

	int IDSandStorm				= rmCreateObjectDef("sandstorm");
	rmAddObjectDefItem			(IDSandStorm, "dust devil", 1, 0.0);
	rmSetObjectDefMinDistance	(IDSandStorm, 0.0);
	rmSetObjectDefMaxDistance	(IDSandStorm, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDSandStorm, AvoidAll);
	rmAddObjectDefConstraint	(IDSandStorm, AvoidOases);
	rmAddObjectDefConstraint	(IDSandStorm, AvoidSettleAreaLong);
	rmPlaceObjectDefAtLoc		(IDSandStorm, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

	int IDGrass					= rmCreateObjectDef("grass");
	rmAddObjectDefItem			(IDGrass, "grass", 1, 0.0);
	rmSetObjectDefMinDistance	(IDGrass, 0.0);
	rmSetObjectDefMaxDistance	(IDGrass, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDGrass, AvoidAll);
	rmPlaceObjectDefAtLoc		(IDGrass, 0, 0.5, 0.5, 40*cNumberNonGaiaPlayers);

	// RM X Finalize.
	rmxFinalize();

	rmSetStatusText("",1.00);
}