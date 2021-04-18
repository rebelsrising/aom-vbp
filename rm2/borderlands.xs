/*@Borderlands
**@Made by Hagrit
**@Inspired by KeeN Flame
**@Version 1.1
*/

// VBP 5.0

include "rmx 5-0-0.xs";

void main(void)
{
	// Text
	rmSetStatusText("",0.01);

	// RM X Setup.
	rmxInit("Borderlands (by Hagrit & Flame)", false, false, false);

	// INIT MAP
	int mapSizeMultiplier = 1;
	int playerTiles=8500;
	if(cMapSize == 1)
	{
		playerTiles = 9750;
		rmEchoInfo("Large map");
	}
	if (cMapSize == 2)
	{
		playerTiles = 16500;
		mapSizeMultiplier = 2;
	}
	int size=2.0*sqrt(cNumberNonGaiaPlayers*playerTiles);
	rmEchoInfo("Map size="+size+"m x "+size+"m");
	rmSetMapSize(size, size);

	rmTerrainInitialize("snowB");
	rmSetLightingSet("alfheim");
	rmSetGaiaCiv(cCivZeus);

	///CLASSES
	int classPlayer      	= rmDefineClass("player");
	int classPlayerCore    	= rmDefineClass("player core");
	int classStartingSettle	= rmDefineClass("starting settlement");
	int classCenterForest	= rmDefineClass("center forest");
	int classMainForest		= rmDefineClass("main forest");
	int classCenter			= rmDefineClass("center area");
	int classCenterCore		= rmDefineClass("center core");
	int classPatch			= rmDefineClass("sand patch");
	int classForest			= rmDefineClass("forest");

   rmSetStatusText("",0.10);
	///CONSTRAINTS
	int AvoidEdge		= rmCreateBoxConstraint	("-2", 0.15, 0.15, 0.85, 0.85, 0.01);
	int AvoidEdgeMed	= rmCreateBoxConstraint	("-1", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0-rmXTilesToFraction(8), 1.0-rmZTilesToFraction(8));


	int AvoidAll					= rmCreateTypeDistanceConstraint 	("-49", "all", 6.0);
	int AvoidAllShort				= rmCreateTypeDistanceConstraint 	("0", "all", 4.0);
	int AvoidOtherTower				= rmCreateTypeDistanceConstraint 	("1", "tower", 22.0);
	int AvoidGoldShort				= rmCreateTypeDistanceConstraint 	("2", "gold", 15.0);
	int AvoidGoldFar				= rmCreateTypeDistanceConstraint 	("3", "gold", 30.0);
	int AvoidSettlementSlightly 	= rmCreateTypeDistanceConstraint 	("1230", "AbstractSettlement", 10.0);
	int AvoidSettlementAbit		 	= rmCreateTypeDistanceConstraint 	("1231", "AbstractSettlement", 22.0);
	int AvoidSettlementSomewhat 	= rmCreateTypeDistanceConstraint 	("1232", "AbstractSettlement", 32.0);
	int AvoidTowerLOS			 	= rmCreateTypeDistanceConstraint 	("12342", "Tower", 30.0);
	int AvoidFood				 	= rmCreateTypeDistanceConstraint 	("1412", "Food", 25.0);
	int AvoidHerdable			 	= rmCreateTypeDistanceConstraint 	("1432", "herdable", 25.0);

	int AvoidCenter					= rmCreateClassDistanceConstraint	("4", classCenter, 1.0);
	int AvoidPlayer 				= rmCreateClassDistanceConstraint	("5", classPlayer, 22);
	int AvoidPlayerShort 		 	= rmCreateClassDistanceConstraint	("6", classPlayer, 1.0);
	int AvoidPlayerMed	 		 	= rmCreateClassDistanceConstraint	("7", classPlayer, 6.0);
	int AvoidMainForest	 		 	= rmCreateClassDistanceConstraint	("8", classMainForest, 40.0);
	int AvoidCenterForest		 	= rmCreateClassDistanceConstraint	("9", classCenterForest, 55.0);
	int AvoidCenterForestShort	 	= rmCreateClassDistanceConstraint	("10", classCenterForest, 3.0);
	int AvoidCenterForestMed	 	= rmCreateClassDistanceConstraint	("130", classCenterForest, 28.0);
	int AvoidCenterForestTower	 	= rmCreateClassDistanceConstraint	("140", classCenterForest, 12.0);
	int AvoidSandPatch			 	= rmCreateClassDistanceConstraint	("11", classPatch, 20.0);
	int AvoidCenterMed				= rmCreateClassDistanceConstraint	("12", classCenter, 22.0);
	int AvoidPlayerCore				= rmCreateClassDistanceConstraint	("13", classPlayerCore, 2.0);
	int AvoidForest					= rmCreateClassDistanceConstraint	("14", classForest, 25.0);
	int AvoidStartingSettle			= rmCreateClassDistanceConstraint	("15", classStartingSettle, 16.0);
	int AvoidStartingSettleFar		= rmCreateClassDistanceConstraint	("16", classStartingSettle, 50.0);

   rmSetStatusText("",0.20);
	///OBJECT DEFINITION
	int IDStartingSettlement  	= rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem        	(IDStartingSettlement, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass     	(IDStartingSettlement, classStartingSettle);
	rmSetObjectDefMinDistance 	(IDStartingSettlement, 0.0);
	rmSetObjectDefMaxDistance 	(IDStartingSettlement, 0.0);

	int IDStartingGoldmine    	= rmCreateObjectDef("starting goldmine");
	rmAddObjectDefItem        	(IDStartingGoldmine, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDStartingGoldmine, 21.0);
	rmSetObjectDefMaxDistance 	(IDStartingGoldmine, 23.5);
	rmAddObjectDefConstraint  	(IDStartingGoldmine, AvoidAll);
	rmAddObjectDefConstraint  	(IDStartingGoldmine, AvoidCenterMed);
	rmAddObjectDefConstraint  	(IDStartingGoldmine, AvoidGoldShort);

	int IDStartingTower 	  	= rmCreateObjectDef("starting towers");
	rmAddObjectDefItem        	(IDStartingTower, "tower", 1, 0.0);
	rmAddObjectDefConstraint  	(IDStartingTower, AvoidOtherTower);
	rmAddObjectDefConstraint  	(IDStartingTower, AvoidAll);
	rmAddObjectDefConstraint  	(IDStartingTower, AvoidCenterForestTower);
	rmSetObjectDefMinDistance 	(IDStartingTower, 22.0);
	rmSetObjectDefMaxDistance 	(IDStartingTower, 27.0);

	int IDStartingFood 	 		= rmCreateObjectDef("starting food");
	float startSpecies = rmRandFloat(0,1);
	if (startSpecies<0.3) {
		rmAddObjectDefItem        (IDStartingFood, "berry bush", rmRandInt(9.0, 12.0), 4);
		rmAddObjectDefItem        (IDStartingFood, "Walrus", 1, 5);
		} else if (startSpecies<0.66) {
		rmAddObjectDefItem        (IDStartingFood, "berry bush", rmRandInt(6.0, 9.0), 4);
		rmAddObjectDefItem        (IDStartingFood, "Walrus", 2, 5);
		} else {
		rmAddObjectDefItem        (IDStartingFood, "berry bush", rmRandInt(3.0, 6.0), 4);
		rmAddObjectDefItem        (IDStartingFood, "Walrus", 3, 5);
	}
	rmSetObjectDefMinDistance 	(IDStartingFood, 22.0);
	rmSetObjectDefMaxDistance 	(IDStartingFood, 27.0);
	rmAddObjectDefConstraint  	(IDStartingFood, AvoidAll);

	int IDStartingHerd	 	  	= rmCreateObjectDef("starting cow");
	rmAddObjectDefItem        	(IDStartingHerd, "cow", rmRandInt(2.0, 4.0), 4);
	rmSetObjectDefMinDistance 	(IDStartingHerd, 25.0);
	rmSetObjectDefMaxDistance 	(IDStartingHerd, 30.0);
	rmAddObjectDefConstraint  	(IDStartingHerd, AvoidAll);
	rmAddObjectDefConstraint  	(IDStartingHerd, AvoidCenter);

	int IDStragglerTree		  	= rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem		  	(IDStragglerTree, "pine snow", 1, 0);
	rmSetObjectDefMinDistance 	(IDStragglerTree, 12.0);
	rmSetObjectDefMaxDistance 	(IDStragglerTree, 16.0);

	//medium
	int IDMediumGoldmine 	  	= rmCreateObjectDef("Medium goldmine");
	rmAddObjectDefItem        	(IDMediumGoldmine, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDMediumGoldmine, 50.0);
	rmSetObjectDefMaxDistance 	(IDMediumGoldmine, 70.0);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidEdgeMed);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidCenterForestMed);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidCenter);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidTowerLOS);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidAll);

	int IDMediumHunt 	 	 	 = rmCreateObjectDef("Medium hunt");
	rmAddObjectDefItem       	 (IDMediumHunt, "Caribou", (rmRandInt(6.0, 7.0)), 4.0);
	rmSetObjectDefMinDistance	 (IDMediumHunt, 45.0);
	rmSetObjectDefMaxDistance	 (IDMediumHunt, 60.0);
	rmAddObjectDefConstraint 	 (IDMediumHunt, AvoidEdgeMed);
	rmAddObjectDefConstraint 	 (IDMediumHunt, AvoidSettlementAbit);
	rmAddObjectDefConstraint 	 (IDMediumHunt, AvoidTowerLOS);
	rmAddObjectDefConstraint 	 (IDMediumHunt, AvoidFood);
	rmAddObjectDefConstraint 	 (IDMediumHunt, AvoidCenter);
	rmAddObjectDefConstraint 	 (IDMediumHunt, AvoidAll);

	//far
	int IDFarGoldmine 		  	= rmCreateObjectDef("Far goldmine");
	rmAddObjectDefItem        	(IDFarGoldmine, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDFarGoldmine, 50.0);
	rmSetObjectDefMaxDistance 	(IDFarGoldmine, 100.0);
	rmAddObjectDefConstraint  	(IDFarGoldmine, AvoidEdgeMed);
	rmAddObjectDefConstraint  	(IDFarGoldmine, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDFarGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  	(IDFarGoldmine, AvoidCenterForestTower);
	rmAddObjectDefConstraint  	(IDFarGoldmine, AvoidCenter);
	rmAddObjectDefConstraint  	(IDFarGoldmine, AvoidTowerLOS);
	rmAddObjectDefConstraint  	(IDFarGoldmine, AvoidAll);

	int IDFarHunt 	 	 		= rmCreateObjectDef("far hunt");
	if (startSpecies < 0.5){
		rmAddObjectDefItem        (IDFarHunt, "Elk", (rmRandInt(7.0, 10.0)), 4.0);
	} else {
		rmAddObjectDefItem        (IDFarHunt, "walrus", (rmRandInt(4.0, 5.0)), 4.0);
	}
	rmSetObjectDefMinDistance 	(IDFarHunt, 80.0);
	rmSetObjectDefMaxDistance 	(IDFarHunt, 100.0);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidEdgeMed);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidTowerLOS);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidFood);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidCenter);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidAll);

	int IDFarBoar 	 	  		= rmCreateObjectDef("far boar");
	rmAddObjectDefItem        	(IDFarBoar, "boar", (rmRandInt(3.0, 5.0)), 4.0);
	rmSetObjectDefMinDistance 	(IDFarBoar, 75.0);
	rmSetObjectDefMaxDistance 	(IDFarBoar, 100.0);
	rmAddObjectDefConstraint  	(IDFarBoar, AvoidEdgeMed);
	rmAddObjectDefConstraint  	(IDFarBoar, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDFarBoar, AvoidTowerLOS);
	rmAddObjectDefConstraint  	(IDFarBoar, AvoidFood);
	rmAddObjectDefConstraint  	(IDFarBoar, AvoidCenter);
	rmAddObjectDefConstraint  	(IDFarBoar, AvoidAll);

	int IDFarHerdable 	 	  	= rmCreateObjectDef("far herd");
	rmAddObjectDefItem        	(IDFarHerdable, "cow", 2, 3.0);
	rmSetObjectDefMinDistance 	(IDFarHerdable, 75.0);
	rmSetObjectDefMaxDistance 	(IDFarHerdable, 120.0);
	rmAddObjectDefConstraint  	(IDFarHerdable, AvoidEdgeMed);
	rmAddObjectDefConstraint  	(IDFarHerdable, AvoidTowerLOS);
	rmAddObjectDefConstraint  	(IDFarHerdable, AvoidHerdable);
	rmAddObjectDefConstraint  	(IDFarHerdable, AvoidCenter);
	rmAddObjectDefConstraint  	(IDFarHerdable, AvoidAll);

	int IDFarBerry	 	 	  	= rmCreateObjectDef("far berry");
	rmAddObjectDefItem        	(IDFarBerry, "berry bush", rmRandInt(6,10), 4.0);
	rmSetObjectDefMinDistance 	(IDFarBerry, 75.0);
	rmSetObjectDefMaxDistance 	(IDFarBerry, 120.0);
	rmAddObjectDefConstraint  	(IDFarBerry, AvoidEdgeMed);
	rmAddObjectDefConstraint  	(IDFarBerry, AvoidTowerLOS);
	rmAddObjectDefConstraint  	(IDFarBerry, AvoidFood);
	rmAddObjectDefConstraint  	(IDFarBerry, AvoidCenter);
	rmAddObjectDefConstraint  	(IDFarBerry, AvoidAll);
	rmAddObjectDefConstraint  	(IDFarBerry, AvoidStartingSettleFar);

	int IDRelic					=rmCreateObjectDef("relic");
	rmAddObjectDefItem        	(IDRelic, "relic", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDRelic, 50.0);
	rmSetObjectDefMaxDistance 	(IDRelic, 150.0);
	rmAddObjectDefConstraint  	(IDRelic, AvoidCenter);
	rmAddObjectDefConstraint  	(IDRelic, AvoidAll);
	rmAddObjectDefConstraint  	(IDRelic, AvoidCenterForestShort);
	rmAddObjectDefConstraint  	(IDRelic, AvoidTowerLOS);
	rmAddObjectDefConstraint  	(IDRelic, rmCreateTypeDistanceConstraint("ruin vs ruin", "relic", 60.0));

	int IDRandomTree			=rmCreateObjectDef("random tree");
	rmAddObjectDefItem			(IDRandomTree, "pine snow", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRandomTree, 0.0);
	rmSetObjectDefMaxDistance	(IDRandomTree, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRandomTree, rmCreateTypeDistanceConstraint("random tree", "all", 3.0));
	rmAddObjectDefConstraint	(IDRandomTree, AvoidAll);
	rmAddObjectDefConstraint	(IDRandomTree, AvoidSettlementAbit);

	rmSetStatusText("",0.30);
	///PLAYER LOCATIONS
	//rmSetTeamSpacingModifier(0.95);
	if (cNumberNonGaiaPlayers > 2) {
		rmPlacePlayersCircular(0.26, 0.27, rmDegreesToRadians(0.0));
	} else
	rmPlacePlayersCircular(0.15, 0.16, rmDegreesToRadians(0.0));

	rmSetStatusText("",0.35);
	///TERRAIN DEFINITION

	float playerFraction=rmAreaTilesToFraction(8500*mapSizeMultiplier);
	for(i=1; <cNumberPlayers)
	{
		int AreaPlayer 			=rmCreateArea("Player"+i);

		rmSetPlayerArea			(i, AreaPlayer);
		rmSetAreaSize			(AreaPlayer, playerFraction, playerFraction);
		rmAddAreaToClass		(AreaPlayer, classPlayer);
		rmSetAreaCoherence		(AreaPlayer, 1.0);
		rmSetAreaSmoothDistance (AreaPlayer, 20);
		rmSetAreaLocPlayer		(AreaPlayer, i);
		rmSetAreaBaseHeight		(AreaPlayer, 2.0);
		rmSetAreaHeightBlend	(AreaPlayer, 1);
		rmSetAreaTerrainType	(AreaPlayer, "snowA");
		rmAddAreaConstraint 	(AreaPlayer, AvoidPlayer);
		rmSetAreaWarnFailure	(AreaPlayer, false);
	}
	rmBuildAllAreas();

	for(i=1; <cNumberPlayers)
	{
		int AreaPlayerCore 			=rmCreateArea("Playercore"+i);

		rmSetPlayerArea			(i, AreaPlayerCore);
		rmSetAreaSize			(AreaPlayerCore, rmAreaTilesToFraction(150*mapSizeMultiplier), rmAreaTilesToFraction(450*mapSizeMultiplier));
		rmAddAreaToClass		(AreaPlayerCore, classPlayer);
		rmAddAreaToClass		(AreaPlayerCore, classPlayerCore);
		rmSetAreaCoherence		(AreaPlayerCore, 0.2);
		rmSetAreaSmoothDistance (AreaPlayerCore, 10);
		rmSetAreaLocPlayer		(AreaPlayerCore, i);
		rmSetAreaTerrainType	(AreaPlayerCore, "egyptianroadA");
		rmAddAreaTerrainLayer	(AreaPlayerCore, "snowsand50", 0,1);
		rmAddAreaTerrainLayer	(AreaPlayerCore, "snowsand75", 1,2);
		rmSetAreaWarnFailure	(AreaPlayerCore, false);
	}
	rmBuildAllAreas();

	float someHugeValue 		=rmAreaTilesToFraction(rmRandInt(550,600));

	int ForestArea 				= rmCreateArea("DividerForest");
	rmAddAreaConstraint			(ForestArea, AvoidPlayerShort);
	rmAddAreaToClass			(ForestArea, classCenterForest);
	rmAddAreaToClass			(ForestArea, classMainForest);
	rmSetAreaLocation 			(ForestArea, 0.5, 0.5);
	rmSetAreaSize				(ForestArea, someHugeValue*mapSizeMultiplier, someHugeValue*mapSizeMultiplier);
	rmSetAreaForestType			(ForestArea, "snow pine forest");
	rmSetAreaBaseHeight			(ForestArea, 2.0);
	rmSetAreaWarnFailure		(ForestArea, false);
	rmSetAreaCoherence			(ForestArea, 0.4);

if (cNumberNonGaiaPlayers< 3) {
		rmBuildArea			(ForestArea);
	}

	int CenterArea 				= rmCreateArea("Center Area");
	//rmAddAreaConstraint			(CenterArea, AvoidPlayerShort);
	rmAddAreaToClass			(CenterArea, classCenter);
	rmSetAreaLocation 			(CenterArea, 0.5, 0.5);
	rmSetAreaSize				(CenterArea, 0.06, 0.06);
	rmSetAreaWarnFailure		(CenterArea, false);
	rmSetAreaTerrainType		(CenterArea, "sandA");
	rmAddAreaTerrainLayer		(CenterArea, "snowsand25", 0,6);
	rmAddAreaTerrainLayer		(CenterArea, "snowsand50", 6,10);
	rmAddAreaTerrainLayer		(CenterArea, "snowsand75", 10,13);
	rmSetAreaCoherence			(CenterArea, 0.8);

	if (cNumberNonGaiaPlayers> 2) {
			rmBuildArea			(CenterArea);
	}

	int CenterAreaCore			= rmCreateArea("Center Area Core");
	//rmAddAreaConstraint			(CenterArea, AvoidPlayerShort);
	rmAddAreaToClass			(CenterAreaCore, classCenterCore);
	rmSetAreaLocation 			(CenterAreaCore, 0.5, 0.5);
	rmSetAreaSize				(CenterAreaCore, 0.0075, 0.0075);
	rmSetAreaWarnFailure		(CenterAreaCore, false);
	rmSetAreaCoherence			(CenterAreaCore, 1.0);

	if (cNumberNonGaiaPlayers> 2) {
			rmBuildArea			(CenterAreaCore);
	}


	someHugeValue 		=rmAreaTilesToFraction(500*(cNumberNonGaiaPlayers/2));
	int forestCount=1*cNumberNonGaiaPlayers;
	int failCount=0;
	for(i=0; <forestCount)
	{
		int ForestArea2		= rmCreateArea("forestA"+i);
		rmSetAreaSize		(ForestArea2, someHugeValue*0.9*mapSizeMultiplier, someHugeValue*1.1*mapSizeMultiplier);
		rmSetAreaWarnFailure(ForestArea2, false);
		rmSetAreaForestType (ForestArea2, "snow pine forest");
		rmAddAreaToClass	(ForestArea2, classCenterForest);
		rmAddAreaConstraint	(ForestArea2, AvoidPlayerShort);
		rmAddAreaConstraint	(ForestArea2, AvoidMainForest);
		rmAddAreaConstraint	(ForestArea2, AvoidCenter);
		rmAddAreaConstraint	(ForestArea2, AvoidCenterForest);

		if (cNumberNonGaiaPlayers > 2) {
		rmAddAreaConstraint	(ForestArea2, AvoidEdge);
		}
		rmSetAreaCoherence	(ForestArea2, 0.4);

		if(rmBuildArea(ForestArea2)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==10)
				break;
		}
		else
			failCount=0;
	}

	if (cNumberNonGaiaPlayers>2) {
		someHugeValue 		=rmAreaTilesToFraction(200*(cNumberNonGaiaPlayers/1.5));
		forestCount=1*cNumberNonGaiaPlayers;
		failCount=0;
		for(i=0; <forestCount)
		{
			int ForestArea3			= rmCreateArea("forestB"+i);
			rmSetAreaSize			(ForestArea3, someHugeValue*mapSizeMultiplier, someHugeValue*mapSizeMultiplier);
			rmSetAreaWarnFailure	(ForestArea3, false);
			rmSetAreaForestType 	(ForestArea3, "snow pine forest");
			rmAddAreaToClass		(ForestArea3, classCenterForest);
			rmAddAreaConstraint		(ForestArea3, AvoidPlayerShort);
			rmAddAreaConstraint		(ForestArea3, AvoidMainForest);
			rmAddAreaConstraint		(ForestArea3, AvoidCenter);
			rmAddAreaConstraint		(ForestArea3, AvoidCenterForest);
			rmSetAreaCoherence		(ForestArea3, 0.4);

			if(rmBuildArea(ForestArea3)==false)
			{
				// Stop trying once we fail 3 times in a row.
				failCount++;
				if(failCount==10)
					break;
			}
			else
				failCount=0;
		}
	}
	int numTries =6*cNumberNonGaiaPlayers*mapSizeMultiplier;

	for(i=0; <numTries)
	{
		int IDSnowPatch1		=rmCreateArea("sandarea"+i);
		rmSetAreaSize			(IDSnowPatch1, rmAreaTilesToFraction(200*mapSizeMultiplier), rmAreaTilesToFraction(300*mapSizeMultiplier));
		rmSetAreaWarnFailure	(IDSnowPatch1, false);
		//rmAddAreaConstraint		(IDSnowPatch1, AvoidPlayer);
		rmAddAreaConstraint		(IDSnowPatch1, AvoidCenterForestShort);
		rmAddAreaConstraint		(IDSnowPatch1, AvoidSandPatch);
		rmAddAreaConstraint		(IDSnowPatch1, AvoidCenter);
		rmAddAreaConstraint		(IDSnowPatch1, AvoidPlayerCore);
		rmAddAreaToClass		(IDSnowPatch1, classPatch);
		rmSetAreaBaseHeight		(IDSnowPatch1, rmRandInt(3.0,5.0));
		rmSetAreaTerrainType	(IDSnowPatch1, "sandA");
		rmAddAreaTerrainLayer	(IDSnowPatch1, "snowSand75", 4, 6);
		rmAddAreaTerrainLayer	(IDSnowPatch1, "snowSand50", 2, 4);
		rmAddAreaTerrainLayer	(IDSnowPatch1, "snowSand25", 0, 2);
		rmSetAreaHeightBlend	(IDSnowPatch1, 2);
		rmSetAreaMinBlobs		(IDSnowPatch1, 1);
		rmSetAreaMaxBlobs		(IDSnowPatch1, 5);
		rmSetAreaMinBlobDistance(IDSnowPatch1, 16.0);
		rmSetAreaMaxBlobDistance(IDSnowPatch1, 40.0);
		rmSetAreaCoherence		(IDSnowPatch1, 0.5);

		if(rmBuildArea(IDSnowPatch1)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}
	rmSetStatusText("",0.50);
	///SETTLEMENTS
	rmPlaceObjectDefPerPlayer(IDStartingSettlement, true);
	rmPlaceObjectDefPerPlayer(IDStartingGoldmine, false, rmRandInt(1.0,2.0));
	rmPlaceObjectDefPerPlayer(IDStartingTower, true, 4);

	AreaPlayer=rmAddFairLoc("Settlement", false, true,  60, 90+cNumberNonGaiaPlayers, 60, 20);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterForestMed);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterMed);
	rmAddFairLocConstraint(AreaPlayer, AvoidTowerLOS);

	if (cNumberNonGaiaPlayers>2)
		AreaPlayer=rmAddFairLoc("Settlement", false, true,  70, 90+cNumberNonGaiaPlayers, 80, 20);
	else if(rmRandFloat(0,1)<0.5)
		AreaPlayer=rmAddFairLoc("Settlement", true, false, 100, 120, 90, 20);
	else
		AreaPlayer=rmAddFairLoc("Settlement", false, true,  90, 110, 90, 20);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterForest);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterMed);
	rmAddFairLocConstraint(AreaPlayer, AvoidTowerLOS);

	if (cMapSize == 2) {
	AreaPlayer=rmAddFairLoc("Settlement", false, true,  100, 160, 100, 20);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterForest);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterMed);
	rmAddFairLocConstraint(AreaPlayer, AvoidTowerLOS);

	AreaPlayer=rmAddFairLoc("Settlement", false, true,  100, 160, 120, 20);
	rmAddFairLocConstraint(AreaPlayer, AvoidCenterForest);
	rmAddFairLocConstraint(AreaPlayer, AvoidTowerLOS);
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
	///PLACE OBJECTS

	rmPlaceObjectDefPerPlayer(IDStartingFood, false, 1);
	rmPlaceObjectDefPerPlayer(IDStartingHerd, true, 1);
	rmPlaceObjectDefPerPlayer(IDStragglerTree, false, rmRandInt(3.0,8.0));

	rmPlaceObjectDefPerPlayer(IDMediumGoldmine, false, 1);

	for(i=1; <cNumberPlayers) {
	rmPlaceObjectDefInArea	(IDMediumGoldmine, 0, rmAreaID("Player"+i), 1);
	rmPlaceObjectDefInArea	(IDMediumHunt, 0, rmAreaID("Player"+i), 1);
	rmPlaceObjectDefInArea	(IDFarGoldmine, 0, rmAreaID("Player"+i), 3);
	rmPlaceObjectDefInArea	(IDFarHunt, 0, rmAreaID("Player"+i), 1);
	rmPlaceObjectDefInArea	(IDFarBoar, 0, rmAreaID("Player"+i), 1);
	rmPlaceObjectDefInArea	(IDFarHerdable, 0, rmAreaID("Player"+i), 3);
	rmPlaceObjectDefInArea	(IDFarBerry, 0, rmAreaID("Player"+i), 2);
	rmPlaceObjectDefInArea	(IDRelic, 0, rmAreaID("Player"+i), 1);
	}

	if (cMapSize == 2) {
		for(i=1; <cNumberPlayers) {
		rmPlaceObjectDefInArea	(IDFarGoldmine, 0, rmAreaID("Player"+i), 1);
		rmPlaceObjectDefInArea	(IDFarHunt, 0, rmAreaID("Player"+i), 1);
		rmPlaceObjectDefInArea	(IDFarHerdable, 0, rmAreaID("Player"+i), 1);
		rmPlaceObjectDefInArea	(IDFarBerry, 0, rmAreaID("Player"+i), 1);
		rmPlaceObjectDefInArea	(IDRelic, 0, rmAreaID("Player"+i), 1);
		}
	}
	if (cNumberNonGaiaPlayers>2) {
	int IDCenterHunt 	 	 	= rmCreateObjectDef("center hunt");
	rmAddObjectDefItem       	(IDCenterHunt, "giraffe", (rmRandInt(8.0*mapSizeMultiplier, 12.0*mapSizeMultiplier)), 4.0*mapSizeMultiplier);
	rmSetObjectDefMinDistance	(IDCenterHunt, 0.0);
	rmSetObjectDefMaxDistance	(IDCenterHunt, 0.0);
	rmPlaceObjectDefInArea		(IDCenterHunt, 0, rmAreaID("Center Area Core"), 1);

	int IDCenterGold 	 	 	= rmCreateObjectDef("center gold");
	rmAddObjectDefItem       	(IDCenterGold, "gold mine", 1, 0.0);
	rmSetObjectDefMinDistance	(IDCenterGold, 0.0);
	rmSetObjectDefMaxDistance	(IDCenterGold, 0.0);
	rmAddObjectDefConstraint	(IDCenterGold, AvoidAllShort);
	rmPlaceObjectDefInArea		(IDCenterGold, 0, rmAreaID("Center Area Core"), 0.5*cNumberNonGaiaPlayers*mapSizeMultiplier);
	}
	rmSetStatusText("",0.75);
	///FORESTS
	forestCount=9*cNumberNonGaiaPlayers*mapSizeMultiplier;
	failCount=0;

	for(i=0; <forestCount)
	{
		int IDForest			= rmCreateArea("forest"+i);
		rmSetAreaSize			(IDForest, rmAreaTilesToFraction(80*mapSizeMultiplier), rmAreaTilesToFraction(140*mapSizeMultiplier));
		rmSetAreaWarnFailure	(IDForest, false);
		rmSetAreaForestType 	(IDForest, "snow pine forest");
		rmAddAreaConstraint 	(IDForest, AvoidSettlementAbit);
		rmAddAreaConstraint 	(IDForest, AvoidAll);
		rmAddAreaConstraint 	(IDForest, AvoidForest);
		rmAddAreaConstraint 	(IDForest, AvoidCenterForestMed);
		rmAddAreaConstraint 	(IDForest, AvoidStartingSettle);
		rmAddAreaConstraint 	(IDForest, AvoidCenterMed);
		rmAddAreaToClass		(IDForest, classForest);
		rmSetAreaCoherence		(IDForest, 0.2);
		rmSetAreaSmoothDistance	(IDForest, 3);

		if(rmBuildArea(IDForest)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}

	rmPlaceObjectDefAtLoc		(IDRandomTree, 0, 0.5, 0.5, 15*cNumberNonGaiaPlayers*mapSizeMultiplier);
	rmSetStatusText("",0.85);
	///BEAUTIFICATION
	int IDRock					=rmCreateObjectDef("rock group");
	rmAddObjectDefItem			(IDRock, "rock granite sprite", 3, 3.0);
	rmSetObjectDefMinDistance	(IDRock, 0.0);
	rmSetObjectDefMaxDistance	(IDRock, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRock, AvoidAll);
	rmPlaceObjectDefAtLoc		(IDRock, 0, 0.5, 0.5, 10*cNumberNonGaiaPlayers);

	int IDLog					=rmCreateObjectDef("logs");
	rmAddObjectDefItem			(IDLog, "rotting log", 1, 0.0);
	rmSetObjectDefMinDistance	(IDLog, 0.0);
	rmSetObjectDefMaxDistance	(IDLog, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDLog, AvoidAll);
	rmAddObjectDefConstraint	(IDLog, AvoidSandPatch);
	rmAddObjectDefConstraint	(IDLog, AvoidPlayerCore);
	rmAddObjectDefConstraint	(IDLog, AvoidCenter);
	rmAddObjectDefConstraint	(IDLog, rmCreateTypeDistanceConstraint("log constraint", "rotting log", 15.0));
	rmPlaceObjectDefAtLoc		(IDLog, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDCampfire					=rmCreateObjectDef("campfire");
	rmAddObjectDefItem			(IDCampfire, "campfire", 1, 0.0);
	rmSetObjectDefMinDistance	(IDCampfire, 0.0);
	rmSetObjectDefMaxDistance	(IDCampfire, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDCampfire, AvoidAll);
	rmAddObjectDefConstraint	(IDCampfire, AvoidSandPatch);
	rmAddObjectDefConstraint	(IDCampfire, AvoidPlayerCore);
	rmAddObjectDefConstraint	(IDCampfire, rmCreateTypeDistanceConstraint("campfire constraint", "campfire", 60.0));
	rmPlaceObjectDefAtLoc		(IDCampfire, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers*mapSizeMultiplier);

	// RM X Finalize.
	rmxFinalize();

	rmSetStatusText("",1.00);
}