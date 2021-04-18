/*The Hidden Pork Village
**Author: Hagrit
**@Version 1.0
*/

// VBP 5.0

include "rmx 5-0-0.xs";

void SetUpMap(int small = 5000, int big = 10000, float seaLevel = 1, string seaType = "Mediterranean Sea", string tileName = "GrassA" )
{
	int PlayerTiles = small;
	if (cMapSize == 1)
		PlayerTiles = big;

	int Size = sqrt(cNumberNonGaiaPlayers * PlayerTiles / 0.9)*2.0;
	rmSetMapSize(Size,Size);
	rmSetSeaLevel(seaLevel);
	rmSetSeaType(seaType);
	rmTerrainInitialize(tileName);


}


void main(void)
{
	/// INITIALIZE MAP
	rmSetStatusText("",0.01);

	// RM X Setup.
	rmxInit("Drenched River (by Hagrit & Flame)", false, false, false);

	SetUpMap(9000,12250,1, "marsh pool", "water");

	///CLASSES
	int classPlayer			= rmDefineClass("player");
	int classStartingSettle = rmDefineClass("starting tc");
	int classIsland			= rmDefineClass("island");
	int classForest			= rmDefineClass("forest");
	int classPassage		= rmDefineClass("passage");
	int classPassageHunt	= rmDefineClass("passage hunt");
	int classWater			= rmDefineClass("water not shallow");

	rmSetStatusText("",0.05);
	///CONSTRAINTS
	int AvoidEdge		= rmCreateBoxConstraint("edge of map", rmXTilesToFraction(1), rmZTilesToFraction(1), 1.0-rmXTilesToFraction(1), 1.0-rmZTilesToFraction(1));
	int AvoidEdgeMed	= rmCreateBoxConstraint("edge of map med", rmXTilesToFraction(10), rmZTilesToFraction(10), 1.0-rmXTilesToFraction(10), 1.0-rmZTilesToFraction(10));
	int AvoidEdgeShort	= rmCreateBoxConstraint("edge of map short", rmXTilesToFraction(6), rmZTilesToFraction(6), 1.0-rmXTilesToFraction(6), 1.0-rmZTilesToFraction(6));

	int AvoidAll					= rmCreateTypeDistanceConstraint 	("-49", "all", 6.0);
	int AvoidOtherTower				= rmCreateTypeDistanceConstraint 	("1", "tower", 24.0);
	int AvoidSettlementSlightly 	= rmCreateTypeDistanceConstraint 	("1230", "AbstractSettlement", 10.0);
	int AvoidSettlementAbit		 	= rmCreateTypeDistanceConstraint 	("1231", "AbstractSettlement", 22.0);
	int AvoidSettlementSomewhat 	= rmCreateTypeDistanceConstraint 	("1232", "AbstractSettlement", 32.0);
	int AvoidGoldFar				= rmCreateTypeDistanceConstraint 	("3", "gold", 35.0);
	int AvoidHerdable			 	= rmCreateTypeDistanceConstraint 	("1432", "herdable", 20.0);
	int AvoidHunt				 	= rmCreateTypeDistanceConstraint 	("142", "huntable", 20.0);
	int AvoidPredator			 	= rmCreateTypeDistanceConstraint 	("12343d", "animalPredator", 30.0);
	int AvoidRelic				 	= rmCreateTypeDistanceConstraint 	("eoghjri", "relic", 70.0);

	int AvoidPlayer					= rmCreateClassDistanceConstraint	("20", classPlayer, 50);
	int AvoidIsland					= rmCreateClassDistanceConstraint	("21", classIsland, 50+(cNumberNonGaiaPlayers*8));
	int AvoidIslandShort			= rmCreateClassDistanceConstraint	("22", classIsland, 10);
	int AvoidIslandShortest			= rmCreateClassDistanceConstraint	("23", classIsland, 1);
	int AvoidStartingSettle			= rmCreateClassDistanceConstraint	("24", classStartingSettle, 40);
	int AvoidPassageShort			= rmCreateClassDistanceConstraint	("25", classPassage, 1);
	int AvoidPassage				= rmCreateClassDistanceConstraint	("26", classPassage, 10);
	int AvoidForestMedium			= rmCreateClassDistanceConstraint	("27", classForest, 22);
	int AvoidPassageHunt			= rmCreateClassDistanceConstraint	("28", classPassageHunt, 65);
	int AvoidWater					= rmCreateClassDistanceConstraint	("29", classWater, 14+cNumberNonGaiaPlayers);

	int AvoidImpassableLandFar		= rmCreateTerrainDistanceConstraint ("avoid impassable landfar", "Land", false, 24.0);
	int AvoidImpassableLand			= rmCreateTerrainDistanceConstraint ("avoid impassable land", "Land", false, 6.0);
	int AvoidImpassableLandShort	= rmCreateTerrainDistanceConstraint ("avoid impassable landshort", "Land", false, 3.0);

	int nearShore					= rmCreateTerrainMaxDistanceConstraint ("near shore", "water", true, 6.0);

	rmSetStatusText("",0.15);
	///OBJECT DEFINITION
	int IDStartingSettlement  	= rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem        	(IDStartingSettlement, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass     	(IDStartingSettlement, classStartingSettle);
	rmSetObjectDefMinDistance 	(IDStartingSettlement, 0.0);
	rmSetObjectDefMaxDistance 	(IDStartingSettlement, 0.0);

	int IDStartingGoldmine    	= rmCreateObjectDef("starting goldmine");
	rmAddObjectDefItem        	(IDStartingGoldmine, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDStartingGoldmine, 22.0);
	rmSetObjectDefMaxDistance 	(IDStartingGoldmine, 24.0);
	rmAddObjectDefConstraint  	(IDStartingGoldmine, AvoidAll);
	rmAddObjectDefConstraint  	(IDStartingGoldmine, AvoidEdgeShort);

	int IDStartingTower 	  	= rmCreateObjectDef("starting towers");
	rmAddObjectDefItem        	(IDStartingTower, "tower", 1, 0.0);
	rmAddObjectDefConstraint  	(IDStartingTower, AvoidOtherTower);
	rmAddObjectDefConstraint  	(IDStartingTower, AvoidAll);
	rmAddObjectDefConstraint  	(IDStartingTower, AvoidEdge);
	rmSetObjectDefMinDistance 	(IDStartingTower, 22.0);
	rmSetObjectDefMaxDistance 	(IDStartingTower, 26.0);

	int IDStartingPigs	 	  	= rmCreateObjectDef("starting pig");
	rmAddObjectDefItem        	(IDStartingPigs, "pig", rmRandInt(2,5), 2.0);
	rmAddObjectDefConstraint  	(IDStartingPigs, AvoidAll);
	rmAddObjectDefConstraint  	(IDStartingPigs, AvoidEdgeShort);
	rmSetObjectDefMinDistance 	(IDStartingPigs, 22.0);
	rmSetObjectDefMaxDistance 	(IDStartingPigs, 30.0);

	float startHunt = rmRandFloat(0, 1);
	int IDStartingHunt	 	  	= rmCreateObjectDef("starting hunt");
	if (startHunt > 0.66) {
		rmAddObjectDefItem        	(IDStartingHunt, "aurochs", 1, 5.0);
		rmAddObjectDefItem        	(IDStartingHunt, "boar", rmRandInt(1,2), 5.0);
	} else if (startHunt > 0.33) {
		rmAddObjectDefItem        	(IDStartingHunt, "aurochs", rmRandInt(1,2), 4.0);
		rmAddObjectDefItem        	(IDStartingHunt, "deer", rmRandInt(3,6), 4.0);
	} else
		rmAddObjectDefItem        	(IDStartingHunt, "deer", rmRandInt(5,8), 4.0);
	rmAddObjectDefConstraint  	(IDStartingHunt, AvoidAll);
	rmAddObjectDefConstraint  	(IDStartingHunt, AvoidEdgeShort);
	rmSetObjectDefMinDistance 	(IDStartingHunt, 27.0);
	rmSetObjectDefMaxDistance 	(IDStartingHunt, 30.0);

	float startHunt2 = rmRandFloat(0, 1);
	int IDStartingHunt2	 	  	= rmCreateObjectDef("starting hunt2");
	rmAddObjectDefItem        	(IDStartingHunt2, "deer", rmRandInt(5,7), 4.0);
	rmAddObjectDefConstraint  	(IDStartingHunt2, AvoidAll);
	rmAddObjectDefConstraint  	(IDStartingHunt2, AvoidEdgeShort);
	rmSetObjectDefMinDistance 	(IDStartingHunt2, 29.0);
	rmSetObjectDefMaxDistance 	(IDStartingHunt2, 34.0);

	int IDStragglerTree			= rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem			(IDStragglerTree, "oak tree", 1, 0.0);
	rmSetObjectDefMinDistance	(IDStragglerTree, 12.0);
	rmSetObjectDefMaxDistance	(IDStragglerTree, 16.0);

	int IDStragglerTree2		= rmCreateObjectDef("straggler tree2");
	rmAddObjectDefItem			(IDStragglerTree2, "marsh tree", 1, 0.0);
	rmSetObjectDefMinDistance	(IDStragglerTree2, 12.0);
	rmSetObjectDefMaxDistance	(IDStragglerTree2, 16.0);

	//medium
	int IDMediumGoldmine 	  	= rmCreateObjectDef("Medium goldmine");
	rmAddObjectDefItem        	(IDMediumGoldmine, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDMediumGoldmine, 60.0);
	rmSetObjectDefMaxDistance 	(IDMediumGoldmine, 75.0);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidEdgeMed);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidOtherTower);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidGoldFar);
	rmAddObjectDefConstraint  	(IDMediumGoldmine, AvoidImpassableLandFar);

	int IDMediumHerd			= rmCreateObjectDef("medium herd");
	rmAddObjectDefItem			(IDMediumHerd, "pig", rmRandInt(2,3), 4.0);
	rmSetObjectDefMinDistance	(IDMediumHerd, 50.0);
	rmSetObjectDefMaxDistance	(IDMediumHerd, 75.0);
	rmAddObjectDefConstraint	(IDMediumHerd, AvoidImpassableLand);
	rmAddObjectDefConstraint	(IDMediumHerd, AvoidHerdable);
	rmAddObjectDefConstraint	(IDMediumHerd, AvoidOtherTower);
	rmAddObjectDefConstraint	(IDMediumHerd, AvoidStartingSettle);

	//far
	int IDFarGold 	  			= rmCreateObjectDef("far goldmine");
	rmAddObjectDefItem        	(IDFarGold, "Gold mine", 1, 0.0);
	rmSetObjectDefMinDistance 	(IDFarGold, 85.0);
	rmSetObjectDefMaxDistance 	(IDFarGold, 110.0);
	rmAddObjectDefConstraint  	(IDFarGold, AvoidEdgeShort);
	rmAddObjectDefConstraint  	(IDFarGold, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDFarGold, AvoidOtherTower);
	rmAddObjectDefConstraint  	(IDFarGold, AvoidGoldFar);
	rmAddObjectDefConstraint  	(IDFarGold, AvoidImpassableLandShort);
	rmAddObjectDefConstraint  	(IDFarGold, AvoidPassageShort);

	int IDFarHunt 	  			= rmCreateObjectDef("far Hunt");
	rmAddObjectDefItem        	(IDFarHunt, "Aurochs", rmRandInt(1,2), 4.0);
	rmAddObjectDefItem        	(IDFarHunt, "deer", rmRandInt(5,6), 4.0);
	rmSetObjectDefMinDistance 	(IDFarHunt, 75.0);
	rmSetObjectDefMaxDistance 	(IDFarHunt, 120.0);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidHunt);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidImpassableLand);
	rmAddObjectDefConstraint  	(IDFarHunt, AvoidPassageShort);

	int IDFarHunt2 	  			= rmCreateObjectDef("far Hunt2");
	rmAddObjectDefItem        	(IDFarHunt2, "deer", rmRandInt(7,8), 3.0);
	rmSetObjectDefMinDistance 	(IDFarHunt2, 90.0);
	rmSetObjectDefMaxDistance 	(IDFarHunt2, 120.0);
	rmAddObjectDefConstraint  	(IDFarHunt2, AvoidEdgeShort);
	rmAddObjectDefConstraint  	(IDFarHunt2, AvoidSettlementSlightly);
	rmAddObjectDefConstraint  	(IDFarHunt2, AvoidHunt);
	rmAddObjectDefConstraint  	(IDFarHunt2, AvoidImpassableLand);
	rmAddObjectDefConstraint  	(IDFarHunt2, AvoidPassageShort);

	int IDFarHunt3 	  			= rmCreateObjectDef("far Hunt3");
	rmAddObjectDefItem        	(IDFarHunt3, "boar", rmRandInt(1,3), 4.0);
	rmAddObjectDefItem        	(IDFarHunt3, "aurochs", 2, 4.0);
	rmSetObjectDefMinDistance 	(IDFarHunt3, 85.0);
	rmSetObjectDefMaxDistance 	(IDFarHunt3, 120.0);
	rmAddObjectDefConstraint  	(IDFarHunt3, AvoidEdgeShort);
	rmAddObjectDefConstraint  	(IDFarHunt3, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDFarHunt3, AvoidHunt);
	rmAddObjectDefConstraint  	(IDFarHunt3, AvoidImpassableLand);
	rmAddObjectDefConstraint  	(IDFarHunt3, AvoidPassageShort);
	rmAddObjectDefConstraint  	(IDFarHunt3, AvoidAll);

	int IDFarHerd				= rmCreateObjectDef("far herd");
	rmAddObjectDefItem			(IDFarHerd, "pig", 2, 4.0);
	rmSetObjectDefMinDistance	(IDFarHerd, 70.0);
	rmSetObjectDefMaxDistance	(IDFarHerd, 130.0);
	rmAddObjectDefConstraint	(IDFarHerd, AvoidImpassableLand);
	rmAddObjectDefConstraint	(IDFarHerd, AvoidHerdable);
	rmAddObjectDefConstraint	(IDFarHerd, AvoidEdgeShort);
	rmAddObjectDefConstraint	(IDFarHerd, AvoidAll);

	int IDFarCrane				= rmCreateObjectDef("far Crane");
	rmAddObjectDefItem			(IDFarCrane, "crowned crane", rmRandInt(6,9), 4.0);
	rmSetObjectDefMinDistance	(IDFarCrane, 80.0);
	rmSetObjectDefMaxDistance	(IDFarCrane, 200.0);
	rmAddObjectDefConstraint	(IDFarCrane, AvoidOtherTower);
	rmAddObjectDefConstraint	(IDFarCrane, nearShore);
	rmAddObjectDefConstraint	(IDFarCrane, AvoidHunt);
	rmAddObjectDefConstraint	(IDFarCrane, AvoidPassageShort);
	rmAddObjectDefConstraint	(IDFarCrane, AvoidImpassableLandShort);

	//other
	int IDRandomTree			= rmCreateObjectDef("random tree");
	rmAddObjectDefItem			(IDRandomTree, "oak tree", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRandomTree, 0.0);
	rmSetObjectDefMaxDistance	(IDRandomTree, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRandomTree, AvoidAll);
	rmAddObjectDefConstraint	(IDRandomTree, AvoidImpassableLand);
	rmAddObjectDefConstraint	(IDRandomTree, AvoidStartingSettle);

	int IDRandomTree2			= rmCreateObjectDef("random tree2");
	rmAddObjectDefItem			(IDRandomTree2, "marsh tree", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRandomTree2, 0.0);
	rmSetObjectDefMaxDistance	(IDRandomTree2, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRandomTree2, AvoidAll);
	rmAddObjectDefConstraint	(IDRandomTree2, AvoidImpassableLand);
	rmAddObjectDefConstraint	(IDRandomTree2, AvoidStartingSettle);

	int IDRelicPassage			= rmCreateObjectDef("relic passage");
	rmAddObjectDefItem			(IDRelicPassage, "relic", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRelicPassage, 0.0);
	rmSetObjectDefMaxDistance	(IDRelicPassage, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRelicPassage, AvoidRelic);
	rmAddObjectDefConstraint	(IDRelicPassage, AvoidAll);
	rmAddObjectDefConstraint	(IDRelicPassage, AvoidIslandShort);
	rmAddObjectDefConstraint	(IDRelicPassage, AvoidWater);

	int IDRelic					= rmCreateObjectDef("relic");
	rmAddObjectDefItem			(IDRelic, "relic", 1, 0.0);
	rmSetObjectDefMinDistance	(IDRelic, 0.0);
	rmSetObjectDefMaxDistance	(IDRelic, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRelic, AvoidRelic);
	rmAddObjectDefConstraint	(IDRelic, AvoidAll);
	rmAddObjectDefConstraint	(IDRelic, AvoidImpassableLand);
	rmAddObjectDefConstraint	(IDRelic, AvoidStartingSettle);

	int IDPassageHunt 			= rmCreateObjectDef("passage Hunt");
	rmAddObjectDefItem        	(IDPassageHunt, "Aurochs", rmRandInt(2,3), 6.0);
	rmAddObjectDefItem        	(IDPassageHunt, "deer", rmRandInt(7,9), 6.0);
	rmSetObjectDefMinDistance 	(IDPassageHunt, 0.0);
	rmSetObjectDefMaxDistance 	(IDPassageHunt, rmXFractionToMeters(0.5));
	rmAddObjectDefToClass		(IDPassageHunt, classPassageHunt);
	rmAddObjectDefConstraint  	(IDPassageHunt, AvoidSettlementAbit);
	rmAddObjectDefConstraint  	(IDPassageHunt, AvoidPassageHunt);
	rmAddObjectDefConstraint  	(IDPassageHunt, AvoidWater);
	rmAddObjectDefConstraint  	(IDPassageHunt, AvoidIslandShort);

	rmSetStatusText("",0.30);
	///PLAYER LOCATIONS
	float flipSide = rmRandFloat(0, 1);
	if (cNumberTeams > 2){
	rmPlacePlayersCircular(0.40, 0.44, rmDegreesToRadians(5.0));
	} else if (cNumberNonGaiaPlayers < 3) {
		if (flipSide > 0.66) {
			rmPlacePlayersLine(0.70, 0.85, 0.30, 0.15);
		} else if (flipSide > 0.33) {
			rmPlacePlayersLine(0.85, 0.70, 0.15, 0.30);
		} else
			rmPlacePlayersLine(0.80, 0.80, 0.20, 0.20);
		}
		if (cNumberNonGaiaPlayers < 5) {
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.35, 0.15, 0.15, 0.35, 0, 0); /* x z x2 z2 */
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.65, 0.85, 0.85, 0.65, 0, 0);
		}
		if (cNumberNonGaiaPlayers > 5) {
			rmSetPlacementTeam(0);
			rmPlacePlayersLine(0.35, 0.10, 0.10, 0.35, 0, 0); /* x z x2 z2 */
			rmSetPlacementTeam(1);
			rmPlacePlayersLine(0.65, 0.90, 0.90, 0.65, 0, 0);
		}

	rmSetStatusText("",0.40);
	///TERRAIN DEFINITION
		int IDLandArea			= rmCreateArea("IslandA");
		rmSetAreaLocation		(IDLandArea, 0.75, 0.75);

		rmSetAreaSize			(IDLandArea, 0.5, 0.5);

		rmAddAreaToClass		(IDLandArea, classIsland);
		rmSetAreaWarnFailure	(IDLandArea, false);
		rmSetAreaMinBlobs		(IDLandArea, 3);
		rmSetAreaMaxBlobs		(IDLandArea, 6);
		rmSetAreaMinBlobDistance(IDLandArea, 7.0);
		rmSetAreaMaxBlobDistance(IDLandArea, 12.0);
		rmSetAreaCoherence		(IDLandArea, 1.0);
		rmSetAreaBaseHeight		(IDLandArea, 3.0);
		rmSetAreaSmoothDistance	(IDLandArea, 10);
		rmSetAreaHeightBlend	(IDLandArea, 2);
		rmAddAreaConstraint		(IDLandArea, AvoidIsland);
		rmSetAreaTerrainType	(IDLandArea, "MarshD");
		rmAddAreaTerrainLayer	(IDLandArea, "MarshE", 12, 17);
		rmAddAreaTerrainLayer	(IDLandArea, "MarshA", 7, 12);
		rmAddAreaTerrainLayer	(IDLandArea, "MarshB", 4, 7);
		rmAddAreaTerrainLayer	(IDLandArea, "MarshC", 0, 4);

		int IDLandArea2			= rmCreateArea("IslandB");
		rmSetAreaLocation		(IDLandArea2, 0.25, 0.25);
		rmSetAreaSize			(IDLandArea2, 0.5, 0.5);
		rmAddAreaToClass		(IDLandArea2, classIsland);
		rmSetAreaWarnFailure	(IDLandArea2, false);
		rmSetAreaMinBlobs		(IDLandArea2, 3);
		rmSetAreaMaxBlobs		(IDLandArea2, 6);
		rmSetAreaMinBlobDistance(IDLandArea2, 7.0);
		rmSetAreaMaxBlobDistance(IDLandArea2, 12.0);
		rmSetAreaCoherence		(IDLandArea2, 1.0);
		rmSetAreaBaseHeight		(IDLandArea2, 3.0);
		rmSetAreaSmoothDistance	(IDLandArea2, 10);
		rmSetAreaHeightBlend	(IDLandArea2, 2);
		rmAddAreaConstraint		(IDLandArea2, AvoidIsland);
		rmSetAreaTerrainType	(IDLandArea2, "MarshD");
		rmAddAreaTerrainLayer	(IDLandArea2, "MarshE", 12, 17);
		rmAddAreaTerrainLayer	(IDLandArea2, "MarshA", 7, 12);
		rmAddAreaTerrainLayer	(IDLandArea2, "MarshB", 4, 7);
		rmAddAreaTerrainLayer	(IDLandArea2, "MarshC", 0, 4);

	rmBuildAllAreas();

	float playerFraction=rmAreaTilesToFraction(500);
	for(i=1; <cNumberPlayers)
	{
		// Create the area.
		int IDPlayerArea			=rmCreateArea("Player"+i);
		rmSetPlayerArea			(i, IDPlayerArea);
		rmSetAreaSize			(IDPlayerArea, playerFraction, playerFraction);
		rmAddAreaToClass		(IDPlayerArea, classIsland);
		rmAddAreaToClass		(IDPlayerArea, classPlayer);
		rmSetAreaWarnFailure	(IDPlayerArea, false);
		rmSetAreaMinBlobs		(IDPlayerArea, 3);
		rmSetAreaMaxBlobs		(IDPlayerArea, 6);
		rmSetAreaMinBlobDistance(IDPlayerArea, 7.0);
		rmSetAreaMaxBlobDistance(IDPlayerArea, 12.0);
		rmSetAreaCoherence		(IDPlayerArea, 0.5);
		rmSetAreaBaseHeight		(IDPlayerArea, 4.0);
		rmSetAreaSmoothDistance	(IDPlayerArea, 10);
		rmSetAreaHeightBlend	(IDPlayerArea, 2);
		rmSetAreaLocPlayer		(IDPlayerArea, i);
		rmSetAreaTerrainType	(IDPlayerArea, "MarshC");
		rmAddAreaTerrainLayer	(IDPlayerArea, "MarshB", 4, 7);
		rmAddAreaTerrainLayer	(IDPlayerArea, "MarshA", 2, 4);
		rmAddAreaTerrainLayer	(IDPlayerArea, "MarshE", 0, 2);
	}
	rmBuildAllAreas();

	if (cNumberNonGaiaPlayers < 3) {

	int IDPassage1			= rmCreateArea("Passage1");
	rmSetAreaLocation		(IDPassage1, 0.51, 0.5);
	rmAddAreaInfluenceSegment(IDPassage1, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage1, 0.04, 0.04);
	rmAddAreaToClass		(IDPassage1, classPassage);
	rmSetAreaWarnFailure	(IDPassage1, false);
	rmSetAreaCoherence		(IDPassage1, 1.0);
	rmSetAreaBaseHeight		(IDPassage1, 0.7);
	rmSetAreaSmoothDistance	(IDPassage1, 10);
	rmSetAreaHeightBlend	(IDPassage1, 2);
	rmAddAreaConstraint		(IDPassage1, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage1, "MarshA");

	rmBuildArea(IDPassage1);

	int IDPassage2			= rmCreateArea("Passage2");
	rmSetAreaLocation		(IDPassage2, 0.25, 0.75);
	rmAddAreaInfluenceSegment(IDPassage2, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage2, 0.04, 0.04);
	rmAddAreaToClass		(IDPassage2, classPassage);
	rmSetAreaWarnFailure	(IDPassage2, false);
	rmSetAreaCoherence		(IDPassage2, 1.0);
	rmSetAreaBaseHeight		(IDPassage2, 0.7);
	rmSetAreaSmoothDistance	(IDPassage2, 10);
	rmSetAreaHeightBlend	(IDPassage2, 2);
	rmAddAreaConstraint		(IDPassage2, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage2, "MarshA");

	rmBuildArea(IDPassage2);

	int IDPassage3			= rmCreateArea("Passage3");
	rmSetAreaLocation		(IDPassage3, 0.75, 0.25);
	rmAddAreaInfluenceSegment(IDPassage3, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage3, 0.04, 0.04);
	rmAddAreaToClass		(IDPassage3, classPassage);
	rmSetAreaWarnFailure	(IDPassage3, false);
	rmSetAreaCoherence		(IDPassage3, 1.0);
	rmSetAreaBaseHeight		(IDPassage3, 0.7);
	rmSetAreaSmoothDistance	(IDPassage3, 10);
	rmSetAreaHeightBlend	(IDPassage3, 2);
	rmAddAreaConstraint		(IDPassage3, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage3, "MarshA");

	rmBuildArea(IDPassage3);

	} else if (cNumberNonGaiaPlayers < 5) {

	int IDPassage4			= rmCreateArea("Passage4");
	rmSetAreaLocation		(IDPassage4, 0.20, 0.80);
	rmAddAreaInfluenceSegment(IDPassage4, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage4, 0.03, 0.03);
	rmAddAreaToClass		(IDPassage4, classPassage);
	rmSetAreaWarnFailure	(IDPassage4, false);
	rmSetAreaCoherence		(IDPassage4, 1.0);
	rmSetAreaBaseHeight		(IDPassage4, 0.7);
	rmSetAreaSmoothDistance	(IDPassage4, 10);
	rmSetAreaHeightBlend	(IDPassage4, 2);
	rmAddAreaConstraint		(IDPassage4, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage4, "MarshA");

	rmBuildArea(IDPassage4);

	int IDPassage5			= rmCreateArea("Passage5");
	rmSetAreaLocation		(IDPassage5, 0.40, 0.60);
	rmAddAreaInfluenceSegment(IDPassage5, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage5, 0.03, 0.03);
	rmAddAreaToClass		(IDPassage5, classPassage);
	rmSetAreaWarnFailure	(IDPassage5, false);
	rmSetAreaCoherence		(IDPassage5, 1.0);
	rmSetAreaBaseHeight		(IDPassage5, 0.7);
	rmSetAreaSmoothDistance	(IDPassage5, 10);
	rmSetAreaHeightBlend	(IDPassage5, 2);
	rmAddAreaConstraint		(IDPassage5, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage5, "MarshA");

	rmBuildArea(IDPassage5);

	int IDPassage6			= rmCreateArea("Passage6");
	rmSetAreaLocation		(IDPassage6, 0.60, 0.40);
	rmAddAreaInfluenceSegment(IDPassage6, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage6, 0.03, 0.03);
	rmAddAreaToClass		(IDPassage6, classPassage);
	rmSetAreaWarnFailure	(IDPassage6, false);
	rmSetAreaCoherence		(IDPassage6, 1.0);
	rmSetAreaBaseHeight		(IDPassage6, 0.7);
	rmSetAreaSmoothDistance	(IDPassage6, 10);
	rmSetAreaHeightBlend	(IDPassage6, 2);
	rmAddAreaConstraint		(IDPassage6, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage6, "MarshA");

	rmBuildArea(IDPassage6);

	int IDPassage7			= rmCreateArea("Passage7");
	rmSetAreaLocation		(IDPassage7, 0.80, 0.20);
	rmAddAreaInfluenceSegment(IDPassage7, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage7, 0.03, 0.03);
	rmAddAreaToClass		(IDPassage7, classPassage);
	rmSetAreaWarnFailure	(IDPassage7, false);
	rmSetAreaCoherence		(IDPassage7, 1.0);
	rmSetAreaBaseHeight		(IDPassage7, 0.7);
	rmSetAreaSmoothDistance	(IDPassage7, 10);
	rmSetAreaHeightBlend	(IDPassage7, 2);
	rmAddAreaConstraint		(IDPassage7, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage7, "MarshA");

	rmBuildArea(IDPassage7);
	} else {
	int IDPassage8		= rmCreateArea("Passage8");
	rmSetAreaLocation		(IDPassage8, 0.50, 0.50);
	rmAddAreaInfluenceSegment(IDPassage8, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage8, 0.028, 0.028);
	rmAddAreaToClass		(IDPassage8, classPassage);
	rmSetAreaWarnFailure	(IDPassage8, false);
	rmSetAreaCoherence		(IDPassage8, 1.0);
	rmSetAreaBaseHeight		(IDPassage8, 0.7);
	rmSetAreaSmoothDistance	(IDPassage8, 10);
	rmSetAreaHeightBlend	(IDPassage8, 2);
	rmAddAreaConstraint		(IDPassage8, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage8, "MarshA");

	rmBuildArea(IDPassage8);

	int IDPassage9			= rmCreateArea("Passage9");
	rmSetAreaLocation		(IDPassage9, 0.65, 0.35);
	rmAddAreaInfluenceSegment(IDPassage9, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage9, 0.028, 0.028);
	rmAddAreaToClass		(IDPassage9, classPassage);
	rmSetAreaWarnFailure	(IDPassage9, false);
	rmSetAreaCoherence		(IDPassage9, 1.0);
	rmSetAreaBaseHeight		(IDPassage9, 0.7);
	rmSetAreaSmoothDistance	(IDPassage9, 10);
	rmSetAreaHeightBlend	(IDPassage9, 2);
	rmAddAreaConstraint		(IDPassage9, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage9, "MarshA");

	rmBuildArea(IDPassage9);

	int IDPassage10			= rmCreateArea("Passage10");
	rmSetAreaLocation		(IDPassage10, 0.80, 0.20);
	rmAddAreaInfluenceSegment(IDPassage10, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage10, 0.028, 0.028);
	rmAddAreaToClass		(IDPassage10, classPassage);
	rmSetAreaWarnFailure	(IDPassage10, false);
	rmSetAreaCoherence		(IDPassage10, 1.0);
	rmSetAreaBaseHeight		(IDPassage10, 0.7);
	rmSetAreaSmoothDistance	(IDPassage10, 10);
	rmSetAreaHeightBlend	(IDPassage10, 2);
	rmAddAreaConstraint		(IDPassage10, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage10, "MarshA");

	rmBuildArea(IDPassage10);

	int IDPassage11			= rmCreateArea("Passage11");
	rmSetAreaLocation		(IDPassage11, 0.35, 0.65);
	rmAddAreaInfluenceSegment(IDPassage11, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage11, 0.028, 0.028);
	rmAddAreaToClass		(IDPassage11, classPassage);
	rmSetAreaWarnFailure	(IDPassage11, false);
	rmSetAreaCoherence		(IDPassage11, 1.0);
	rmSetAreaBaseHeight		(IDPassage11, 0.7);
	rmSetAreaSmoothDistance	(IDPassage11, 10);
	rmSetAreaHeightBlend	(IDPassage11, 2);
	rmAddAreaConstraint		(IDPassage11, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage11, "MarshA");

	rmBuildArea(IDPassage11);

	int IDPassage12			= rmCreateArea("Passage12");
	rmSetAreaLocation		(IDPassage12, 0.20, 0.80);
	rmAddAreaInfluenceSegment(IDPassage12, 0.0 ,0.5 ,0.5 ,0.0);
	rmSetAreaSize			(IDPassage12, 0.028, 0.028);
	rmAddAreaToClass		(IDPassage12, classPassage);
	rmSetAreaWarnFailure	(IDPassage12, false);
	rmSetAreaCoherence		(IDPassage12, 1.0);
	rmSetAreaBaseHeight		(IDPassage12, 0.7);
	rmSetAreaSmoothDistance	(IDPassage12, 10);
	rmSetAreaHeightBlend	(IDPassage12, 2);
	rmAddAreaConstraint		(IDPassage12, AvoidIslandShortest);
	rmSetAreaTerrainType	(IDPassage12, "MarshA");

	rmBuildArea(IDPassage12);
	}

	int numTries=50*cNumberNonGaiaPlayers;
	int failCount=0;
	for(i=0; <numTries)
	{
		int waterArea			=rmCreateArea("waterarea"+i);
		rmSetAreaSize			(waterArea, 0.03, 0.03);
		rmAddAreaToClass		(waterArea, classWater);
		rmAddAreaConstraint		(waterArea, AvoidPassageShort);
		rmAddAreaConstraint		(waterArea, AvoidIslandShortest);

		if(rmBuildArea(waterArea)==false)
		{
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}

	numTries=10*cNumberNonGaiaPlayers;
	failCount=0;
	for(i=0; <numTries)
	{
		int IDelev				=rmCreateArea("elev"+i);
		rmSetAreaSize			(IDelev, rmAreaTilesToFraction(200), rmAreaTilesToFraction(350));
		rmSetAreaWarnFailure	(IDelev, false);
		rmAddAreaConstraint		(IDelev, AvoidImpassableLand);
		rmSetAreaBaseHeight		(IDelev, rmRandFloat(5.0, 7.0));
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

	rmSetStatusText("",0.60);
	///SETTLEMENTS
	rmPlaceObjectDefPerPlayer(IDStartingSettlement, true);

	int SettleArea=rmAddFairLoc("Settlement", false, true,  65, 100, 50, 20);

	SettleArea=rmAddFairLoc("Settlement", true, false,  80, 110, 80, 45);
	rmAddFairLocConstraint(SettleArea, AvoidImpassableLandFar);

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

	rmSetStatusText("",0.70);
	///PLACE OBJECTS
	rmPlaceObjectDefPerPlayer(IDStartingTower, true, 4);
	rmPlaceObjectDefPerPlayer(IDStartingGoldmine, false);
	rmPlaceObjectDefPerPlayer(IDStartingPigs, true);
	rmPlaceObjectDefPerPlayer(IDStartingHunt, false);
	rmPlaceObjectDefPerPlayer(IDStartingHunt2, false);
	rmPlaceObjectDefPerPlayer(IDStragglerTree, false, rmRandInt(2.0,3.0));
	rmPlaceObjectDefPerPlayer(IDStragglerTree2, false, rmRandInt(2.0,4.0));

	rmPlaceObjectDefPerPlayer(IDMediumGoldmine, false);
	rmPlaceObjectDefPerPlayer(IDMediumHerd, false);

	rmPlaceObjectDefPerPlayer(IDFarGold, false, rmRandInt(2,3));
	rmPlaceObjectDefPerPlayer(IDFarCrane, false);
	rmPlaceObjectDefPerPlayer(IDFarHunt, false, rmRandInt(1,2));
	rmPlaceObjectDefPerPlayer(IDFarHunt2, false);
	rmPlaceObjectDefPerPlayer(IDFarHunt3, false);
	rmPlaceObjectDefPerPlayer(IDFarHerd, false, 2);

	rmPlaceObjectDefPerPlayer(IDRelic, false);

	int relicNum = 3;
	if (cNumberNonGaiaPlayers > 3) {
		relicNum = 4;
	}
	if (cNumberNonGaiaPlayers > 5) {
		relicNum = 5;
	}
	rmPlaceObjectDefAtLoc(IDRelicPassage, 0, 0.5, 0.5, relicNum);
	rmPlaceObjectDefAtLoc(IDPassageHunt, 0, 0.5, 0.5, relicNum);

	rmSetStatusText("",0.80);
	///FORESTS
	int forestCount = 5*cNumberNonGaiaPlayers;
	failCount = 0;
	for(i=0; <forestCount)
	{
		int IDForest			= rmCreateArea("forest"+i);
		rmSetAreaSize			(IDForest, rmAreaTilesToFraction(60), rmAreaTilesToFraction(100));
		rmSetAreaWarnFailure	(IDForest, false);
		rmSetAreaForestType 	(IDForest, "mixed oak forest");
		rmAddAreaConstraint 	(IDForest, AvoidSettlementAbit);
		rmAddAreaConstraint 	(IDForest, AvoidAll);
		rmAddAreaConstraint 	(IDForest, AvoidForestMedium);
		rmAddAreaConstraint 	(IDForest, AvoidImpassableLand);
		rmAddAreaConstraint 	(IDForest, AvoidPassage);
		rmAddAreaToClass		(IDForest, classForest);

		rmSetAreaMinBlobs		(IDForest, 1);
		rmSetAreaMaxBlobs		(IDForest, 2);
		rmSetAreaMinBlobDistance(IDForest, 16.0);
		rmSetAreaMaxBlobDistance(IDForest, 22.0);
		rmSetAreaCoherence		(IDForest, 0.1);

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

	forestCount = 5*cNumberNonGaiaPlayers;
	failCount = 0;
	for(i=0; <forestCount)
	{
		int IDMarshForest		= rmCreateArea("forestmarsh"+i);
		rmSetAreaSize			(IDMarshForest, rmAreaTilesToFraction(60), rmAreaTilesToFraction(100));
		rmSetAreaWarnFailure	(IDMarshForest, false);
		rmSetAreaForestType 	(IDMarshForest, "marsh forest");
		rmAddAreaConstraint 	(IDMarshForest, AvoidSettlementAbit);
		rmAddAreaConstraint 	(IDMarshForest, AvoidAll);
		rmAddAreaConstraint 	(IDMarshForest, AvoidForestMedium);
		rmAddAreaConstraint 	(IDMarshForest, AvoidImpassableLand);
		rmAddAreaConstraint 	(IDMarshForest, AvoidPassage);
		rmAddAreaToClass		(IDMarshForest, classForest);

		rmSetAreaMinBlobs		(IDMarshForest, 1);
		rmSetAreaMaxBlobs		(IDMarshForest, 2);
		rmSetAreaMinBlobDistance(IDMarshForest, 16.0);
		rmSetAreaMaxBlobDistance(IDMarshForest, 22.0);
		rmSetAreaCoherence		(IDMarshForest, 0.1);
		rmSetAreaSmoothDistance	(IDMarshForest, 5);

		if(rmBuildArea(IDMarshForest)==false)
		{
			// Stop trying once we fail 3 times in a row.
			failCount++;
			if(failCount==3)
				break;
		}
		else
			failCount=0;
	}

	rmPlaceObjectDefAtLoc(IDRandomTree, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers);
	rmPlaceObjectDefAtLoc(IDRandomTree2, 0, 0.5, 0.5, 20*cNumberNonGaiaPlayers);

	rmSetStatusText("",0.90);
	///BEAUTIFICATION
	int IDLog					= rmCreateObjectDef("log");
	rmAddObjectDefItem			(IDLog, "rotting log", rmRandInt(1,2), 4.0);
	rmAddObjectDefItem			(IDLog, "bush", 1, 5.0);
	rmAddObjectDefItem			(IDLog, "grass", rmRandInt(3,5), 5.0);
	rmSetObjectDefMinDistance	(IDLog, 0.0);
	rmSetObjectDefMaxDistance	(IDLog, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDLog, AvoidPassage);
	rmAddObjectDefConstraint	(IDLog, AvoidImpassableLand);
	rmAddObjectDefConstraint	(IDLog, AvoidPlayer);
	rmAddObjectDefConstraint	(IDLog, AvoidAll);
	rmPlaceObjectDefAtLoc		(IDLog, 0, 0.5, 0.5, 7*cNumberNonGaiaPlayers);

	int IDGrass					= rmCreateObjectDef("green grassy goods");
	rmAddObjectDefItem			(IDGrass, "bush", rmRandInt(1,3), 2.0);
	rmAddObjectDefItem			(IDGrass, "grass", rmRandInt(3,5), 5.0);
	rmAddObjectDefItem			(IDGrass, "rock limestone sprite", rmRandInt(2,4), 10.0);
	rmSetObjectDefMinDistance	(IDGrass, 0.0);
	rmSetObjectDefMaxDistance	(IDGrass, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDGrass, AvoidAll);
	rmAddObjectDefConstraint	(IDGrass, AvoidImpassableLandShort);
	rmPlaceObjectDefAtLoc		(IDGrass, 0, 0.5, 0.5, 12*cNumberNonGaiaPlayers);

	int IDRock					= rmCreateObjectDef("rocks");
	rmAddObjectDefItem			(IDRock, "rock limestone small", rmRandInt(2,4), 0.0);
	rmSetObjectDefMinDistance	(IDRock, 0.0);
	rmSetObjectDefMaxDistance	(IDRock, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDRock, AvoidAll);
	rmAddObjectDefConstraint	(IDRock, AvoidWater);
	rmPlaceObjectDefAtLoc		(IDRock, 0, 0.5, 0.5, 8*cNumberNonGaiaPlayers);

	int IDReeds					= rmCreateObjectDef("reeds");
	rmAddObjectDefItem			(IDReeds, "water reeds", rmRandInt(4,6), 2.0);
	rmAddObjectDefItem			(IDReeds, "rock granite big", rmRandInt(1,3), 3.0);
	rmSetObjectDefMinDistance	(IDReeds, 0.0);
	rmSetObjectDefMaxDistance	(IDReeds, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDReeds, AvoidAll);
	rmAddObjectDefConstraint	(IDReeds, nearShore);
	rmPlaceObjectDefAtLoc		(IDReeds, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

	int IDLilypads				= rmCreateObjectDef("pads");
	rmAddObjectDefItem			(IDLilypads, "water lilly", rmRandInt(3,5), 4.0);
	rmSetObjectDefMinDistance	(IDLilypads, 0.0);
	rmSetObjectDefMaxDistance	(IDLilypads, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint	(IDLilypads, AvoidAll);
	rmPlaceObjectDefAtLoc		(IDLilypads, 0, 0.5, 0.5, 5*cNumberNonGaiaPlayers);

	// RM X Finalize.
	rmxFinalize();

	rmSetStatusText("",1.00);
}