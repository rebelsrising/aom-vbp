/* Snow Holes
** Created by Errorcodebin and Hagrit
** Initial design by Keen_Flame
** Version 1.03.
*/

// VBP 5.0

include "rmx 5-0-0.xs";

// Mathfunctions shamelessly stolen from:
// http://tinyurl.com/XScriptMath
// Tau represents PI*2 (Equivalent of 360deg but in radians)
const float TAU = 6.28318530717958647692;

float Fact(int n = 0) {
	float r = 1;
	for(i = n; >= 1) {r = r * i;}
	return (r);
}

float Pow(float n = 0, int x = 0) {
	float r = n;
	if(0 <= x) {
	  for(i = 1; < x) {r = r * n;}
	  return (r);
	} else {
	  for(i = 1; < 0.0-x) {r = r * n;}
	  return(1.0/r);
	}
}

float Cos(float n = 0) {
	float r = 1;
	for(i = 1; < 100) {
		int j = i * 2;
		float k = Pow(n,j) / Fact(j);
		if(k == 0) break;
		if(i % 2 == 0) r = r + k;
		if(i % 2 == 1) r = r - k;
	}
	return (r);
}

float Sin(float n = 0) {
	float r = n;
	for(i = 1; < 100) {
		int j = i * 2 + 1;
		float k = Pow(n,j) / Fact(j);
		if(k == 0) break;
		if(i % 2 == 0) r = r + k;
		if(i % 2 == 1) r = r - k;
	}
	return (r);
}

void SetUpMap(int small = 5000, int big = 10000,int giant = 20000, float seaLevel = 0, string tileName = "GrassA")
{

	int PlayerTiles = small;
	if (cMapSize == 1)
		PlayerTiles = big;

	// Giant maps suck though..
	// but people still use it..
	if (cMapSize == 2) {
		PlayerTiles = giant;
	}

	int Size = sqrt(cNumberNonGaiaPlayers * PlayerTiles / 0.9)*2;
	rmSetMapSize(Size,Size);
	rmSetSeaLevel(seaLevel);
	rmTerrainInitialize(tileName);
}

void main()
{
	// RM X Setup.
	rmxInit("Arctic Craters (by Coda, Hagrit & Flame)", false, false, false);

	// Setup 'basic bitch' map..
	SetUpMap(9400+(cNumberNonGaiaPlayers*250),11000,19000,-8,"SnowA");
	int mapSizeMultiplier = 1;
		if (cMapSize == 2) {
	mapSizeMultiplier = 2;
	}

	rmSetLightingSet("ghost lake");
	rmSetGaiaCiv(cCivZeus);

	rmSetStatusText("",0.09);

	// DEFINE CLASSES
	int classPlayer      = rmDefineClass("player");
	int classSettlements = rmDefineClass("starting settlement");
	int classTower       = rmDefineClass("starting towers");
	int classHill		 = rmDefineClass("hill");
	int classForest		 = rmDefineClass("forest");
	int classHunt		 = rmDefineClass("hunt");
	int classFood	 	 = rmDefineClass("food");
	int classFarGold 	 = rmDefineClass("gold");

	rmDefineClass("center");

	rmSetStatusText("",0.15);

	// CONSTRAINTS
	int AvoidEdgeShort				= rmCreateBoxConstraint			 ("edge of map", rmXTilesToFraction(4), rmZTilesToFraction(4), 1.0-rmXTilesToFraction(4), 1.0-rmZTilesToFraction(4));
	int AvoidEdgeMed				= rmCreateBoxConstraint			 ("edge of map further", rmXTilesToFraction(8), rmZTilesToFraction(8), 1.0-rmXTilesToFraction(8), 1.0-rmZTilesToFraction(8));

	int AvoidSettlementSlightly 	= rmCreateTypeDistanceConstraint ("0", "AbstractSettlement", 10.0);
	int AvoidSettlementAbit		 	= rmCreateTypeDistanceConstraint ("1", "AbstractSettlement", 20.0);
	int AvoidSettlementSomewhat 	= rmCreateTypeDistanceConstraint ("2", "AbstractSettlement", 32.0);
	int AvoidSettlementHOLYFUCK 	= rmCreateTypeDistanceConstraint ("3", "AbstractSettlement", 90.0);
	int AvoidPlayer 				= rmCreateClassDistanceConstraint("4", classPlayer, 20.0);
	int AvoidPlayerFar 				= rmCreateClassDistanceConstraint("5", classPlayer, 90.0);
	int AvoidOtherTower				= rmCreateTypeDistanceConstraint ("7", "tower", 25.0);
	int AvoidTowerShort				= rmCreateTypeDistanceConstraint ("8", "tower", 6.0);
	int AvoidGoldShort				= rmCreateTypeDistanceConstraint ("9", "gold", 6.0);
	int AvoidGoldFar				= rmCreateTypeDistanceConstraint ("10", "gold", 40.0+cNumberNonGaiaPlayers);
	int AvoidFoodFar				= rmCreateTypeDistanceConstraint ("11", "food", 50.0);
	int AvoidFoodMed				= rmCreateTypeDistanceConstraint ("12", "food", 30.0);
	int AvoidFoodShort				= rmCreateTypeDistanceConstraint ("13", "food", 20.0);
	int AvoidGoat					= rmCreateTypeDistanceConstraint ("14", "goat", 35.0+cNumberNonGaiaPlayers);
	int AvoidFarGold				= rmCreateClassDistanceConstraint("15", classFarGold, 120.0+cNumberNonGaiaPlayers);
	int AvoidBerry					= rmCreateTypeDistanceConstraint ("16", "berry bush", 55.0+cNumberNonGaiaPlayers);

	int AvoidForestMedium			= rmCreateClassDistanceConstraint ("17", rmClassID("forest"), 23.0);
	int AvoidForestShort			= rmCreateClassDistanceConstraint ("18", rmClassID("forest"), 15.0);
	int AvoidForestShorter			= rmCreateClassDistanceConstraint ("19", rmClassID("forest"), 8.0);
	int AvoidStartingSettlement		= rmCreateClassDistanceConstraint ("20", rmClassID("player"), 3.00000);
	int AvoidStartingTower			= rmCreateTypeDistanceConstraint  ("21", "tower", 34.0);
	int AvoidAll					= rmCreateTypeDistanceConstraint  ("22", "all", 6.0);
	int AvoidGoldMedium				= rmCreateTypeDistanceConstraint ("23", "gold", 15.0);

	rmSetStatusText("",0.23);

	/// OBJECT DEFINIIONS

	//STARTING OBJECTS
	int IDStartingSettlement  = rmCreateObjectDef("starting settlement");
	rmAddObjectDefItem        (IDStartingSettlement, "Settlement Level 1", 1, 0.0);
	rmAddObjectDefToClass     (IDStartingSettlement, rmClassID("starting settlement"));
	rmSetObjectDefMinDistance (IDStartingSettlement, 0.0);
	rmSetObjectDefMaxDistance (IDStartingSettlement, 0.0);

	int IDStartingGoldmine    = rmCreateObjectDef("starting goldmine");
	rmAddObjectDefItem        (IDStartingGoldmine, "Gold mine small", 1, 0.0);
	rmSetObjectDefMinDistance (IDStartingGoldmine, 24.0);
	rmSetObjectDefMaxDistance (IDStartingGoldmine, 25.5);
	rmAddObjectDefConstraint  (IDStartingGoldmine, AvoidGoldMedium);
	rmAddObjectDefConstraint  (IDStartingGoldmine, AvoidEdgeShort);

	int IDStartingTower 	  = rmCreateObjectDef("starting towers");
	rmAddObjectDefItem        (IDStartingTower, "tower", 1, 0.0);
	rmAddObjectDefConstraint  (IDStartingTower, AvoidOtherTower);
	rmSetObjectDefMinDistance (IDStartingTower, 23.0);
	rmSetObjectDefMaxDistance (IDStartingTower, 25.0);

	int IDStartingBerry 	  = rmCreateObjectDef("starting berry");
	rmAddObjectDefItem        (IDStartingBerry, "berry bush", rmRandInt(5.0, 7.0), 4);
	rmSetObjectDefMinDistance (IDStartingBerry, 21.0);
	rmSetObjectDefMaxDistance (IDStartingBerry, 25.0);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidTowerShort);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingBerry, AvoidAll);

	int IDStartingChicken 	  = rmCreateObjectDef("starting chicken");
	rmAddObjectDefItem        (IDStartingChicken, "Chicken", rmRandInt(6.0, 8.0), 4);
	rmAddObjectDefItem        (IDStartingChicken, "boar", 1, 4);
	rmSetObjectDefMinDistance (IDStartingChicken, 22.0);
	rmSetObjectDefMaxDistance (IDStartingChicken, 25.0);
	rmAddObjectDefConstraint  (IDStartingChicken, AvoidTowerShort);
	rmAddObjectDefConstraint  (IDStartingChicken, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDStartingChicken, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingChicken, AvoidAll);

	int IDStartingHerd	 	  = rmCreateObjectDef("starting goat");
	rmAddObjectDefItem        (IDStartingHerd, "goat", rmRandInt(1.0, 3.0), 4);
	rmSetObjectDefMinDistance (IDStartingHerd, 25.0);
	rmSetObjectDefMaxDistance (IDStartingHerd, 30.0);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDStartingHerd, AvoidGoat);

	int IDStragglerTree		  = rmCreateObjectDef("straggler tree");
	rmAddObjectDefItem		  (IDStragglerTree, "pine", 1, 0);
	rmSetObjectDefMinDistance (IDStragglerTree, 13.0);
	rmSetObjectDefMaxDistance (IDStragglerTree, 14.0);

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

	int IDMediumHunt 	 	  = rmCreateObjectDef("Medium hunt");
	rmAddObjectDefItem        (IDMediumHunt, "Caribou", (rmRandInt(5.0, 7.0)), 4.0);
	rmSetObjectDefMinDistance (IDMediumHunt, 42.0);
	rmSetObjectDefMaxDistance (IDMediumHunt, 50.0);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidStartingTower);
	rmAddObjectDefConstraint  (IDMediumHunt, AvoidAll);

	int IDMediumHunt2 	 	  = rmCreateObjectDef("Medium hunt2");
	rmAddObjectDefItem        (IDMediumHunt2, "Elk", (rmRandInt(4.0, 8.0)), 4.0);
	rmSetObjectDefMinDistance (IDMediumHunt2, 42.0);
	rmSetObjectDefMaxDistance (IDMediumHunt2, 50.0);
	rmAddObjectDefConstraint  (IDMediumHunt2, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDMediumHunt2, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDMediumHunt2, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDMediumHunt2, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDMediumHunt2, AvoidAll);
	rmAddObjectDefConstraint  (IDMediumHunt2, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDMediumHunt2, AvoidStartingTower);

	int IDMediumHunt3 	 	  = rmCreateObjectDef("Medium hunt3");
	rmAddObjectDefItem        (IDMediumHunt3, "Boar", (rmRandInt(2.0, 4.0)), 5.0);
	rmSetObjectDefMinDistance (IDMediumHunt3, 42.0);
	rmSetObjectDefMaxDistance (IDMediumHunt3, 50.0);
	rmAddObjectDefConstraint  (IDMediumHunt3, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDMediumHunt3, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDMediumHunt3, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDMediumHunt3, AvoidFoodShort);
	rmAddObjectDefConstraint  (IDMediumHunt3, AvoidAll);
	rmAddObjectDefConstraint  (IDMediumHunt3, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDMediumHunt3, AvoidStartingTower);

	int IDMediumHerd 	 	  = rmCreateObjectDef("Medium herd");
	rmAddObjectDefItem        (IDMediumHerd, "goat", (rmRandInt(2.0, 3.0)), 4.0);
	rmSetObjectDefMinDistance (IDMediumHerd, 50.0);
	rmSetObjectDefMaxDistance (IDMediumHerd, 75.0);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidFoodMed);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidGoat);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidAll);
	rmAddObjectDefConstraint  (IDMediumHerd, AvoidForestShorter);

	int IDSettlementOut 	  =rmCreateObjectDef("far settlement2");
	rmAddObjectDefItem		  (IDSettlementOut, "Settlement", 1, 0.0);

	rmSetStatusText("",0.36);

	///FAR OBJECTS
	int IDHawk 			      = rmCreateObjectDef("hawks");
	rmAddObjectDefItem		  (IDHawk, "hawk", 1, 0.0);
	rmSetObjectDefMinDistance (IDHawk, 0.0);
	rmSetObjectDefMaxDistance (IDHawk, rmXFractionToMeters(0.5));

	int IDFarBoar		 	  = rmCreateObjectDef("far boar");
	rmAddObjectDefItem        (IDFarBoar, "boar", rmRandInt(3.0, 4.0), 4);
	rmSetObjectDefMinDistance (IDFarBoar, 80.0);
	rmSetObjectDefMaxDistance (IDFarBoar, 110.0);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidFoodFar);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidAll);
	rmAddObjectDefConstraint  (IDFarBoar, AvoidForestShorter);

	int IDFarBoar2		 	  = rmCreateObjectDef("far boar2");
	rmAddObjectDefItem        (IDFarBoar2, "boar", rmRandInt(3.0, 4.0), 4);
	rmSetObjectDefMinDistance (IDFarBoar2, rmXFractionToMeters(0.55));
	rmSetObjectDefMaxDistance (IDFarBoar2, rmXFractionToMeters(0.75));
	rmAddObjectDefConstraint  (IDFarBoar2, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDFarBoar2, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarBoar2, AvoidFoodFar);
	rmAddObjectDefConstraint  (IDFarBoar2, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarBoar2, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarBoar2, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDFarBoar2, AvoidAll);

	// Caribou != Caribou or Elk
	int IDFarHunt	 		  = rmCreateObjectDef("far caribou elk");
	if(rmRandFloat(0.0, 1.0) < 0.5)
	{
		rmAddObjectDefItem    (IDFarHunt, "Caribou", rmRandInt(6.0, 8.0), 4);
	} else {
		rmAddObjectDefItem    (IDFarHunt, "Elk", rmRandInt(7.0, 9.0), 4);
	}
	rmSetObjectDefMinDistance (IDFarHunt, 70.0);
	rmSetObjectDefMaxDistance (IDFarHunt, 120.0);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidFoodFar);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidAll);
	rmAddObjectDefConstraint  (IDFarHunt, AvoidForestShorter);

	int IDFarBerry		 	  = rmCreateObjectDef("far berry");
	rmAddObjectDefItem        (IDFarBerry, "berry bush", rmRandInt(6.0, 9.0), 4);
	rmSetObjectDefMinDistance (IDFarBerry, 90.0);
	rmSetObjectDefMaxDistance (IDFarBerry, 150.0);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidAll);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidBerry);
	rmAddObjectDefConstraint  (IDFarBerry, AvoidForestShorter);

	int IDFarGold		 	  = rmCreateObjectDef("far gold");
	rmAddObjectDefItem        (IDFarGold, "gold mine", 1, 1);
	rmSetObjectDefMinDistance (IDFarGold, 75.0);
	rmSetObjectDefMaxDistance (IDFarGold, 95.0);
	rmAddObjectDefConstraint  (IDFarGold, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDFarGold, AvoidEdgeMed);
	rmAddObjectDefConstraint  (IDFarGold, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarGold, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarGold, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDFarGold, AvoidAll);

	int IDFarGoat		 	  = rmCreateObjectDef("far goat");
	rmAddObjectDefItem        (IDFarGoat, "goat", rmRandInt(1,2), 1);
	rmSetObjectDefMinDistance (IDFarGoat, 80.0);
	rmSetObjectDefMaxDistance (IDFarGoat, 150.0);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidGoat);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDFarGoat, AvoidAll);

	int IDFarPredator	 	  = rmCreateObjectDef("far predator");
	rmAddObjectDefItem        (IDFarPredator, "Polar Bear", 2, 3);
	rmSetObjectDefMinDistance (IDFarPredator, 90.0);
	rmSetObjectDefMaxDistance (IDFarPredator, 150.0);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidPlayer);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDFarPredator, AvoidAll);
	rmAddObjectDefConstraint  (IDFarPredator, rmCreateTypeDistanceConstraint("pred vs pred", "Polar Bear", 50.0));

	int IDFarGold2		 	  = rmCreateObjectDef("far gold 2");
	rmAddObjectDefItem        (IDFarGold2, "gold mine", 1, 1);
	rmSetObjectDefMinDistance (IDFarGold2, rmXFractionToMeters(0.65));
	rmSetObjectDefMaxDistance (IDFarGold2, rmXFractionToMeters(0.85));
	rmAddObjectDefToClass	  (IDFarGold2, classFarGold);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidPlayerFar);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidAll);
	rmAddObjectDefConstraint  (IDFarGold2, AvoidFarGold);

	// OTHER
	int IDRelic			 	  = rmCreateObjectDef("relics");
	rmAddObjectDefItem        (IDRelic, "Relic", 1, 1);
	rmSetObjectDefMinDistance (IDRelic, 90.0);
	rmSetObjectDefMaxDistance (IDRelic, 150.0);
	rmAddObjectDefConstraint  (IDRelic, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDRelic, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDRelic, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDRelic, rmCreateTypeDistanceConstraint("relic vs relic", "relic", 70.0));
	rmAddObjectDefConstraint  (IDRelic, AvoidPlayer);
	rmAddObjectDefConstraint  (IDRelic, AvoidAll);

	int IDBonusHunt           = rmCreateObjectDef("bonus huntable");
	if (rmRandFloat(0.0, 1.0) < 0.5)
	{
		rmAddObjectDefItem    (IDBonusHunt, "Aurochs", rmRandInt(2.0, 4.0), 4);
	}
	else
	{
		rmAddObjectDefItem    (IDBonusHunt, "Caribou", rmRandInt(4.0, 6.0), 5);
		rmAddObjectDefItem    (IDBonusHunt, "Elk", rmRandInt(4.0, 6.0), 5);
	}
	rmSetObjectDefMinDistance (IDBonusHunt, 100.0);
	rmSetObjectDefMaxDistance (IDBonusHunt, 150.0);
	rmAddObjectDefConstraint  (IDBonusHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDBonusHunt, AvoidFoodFar);
	rmAddObjectDefConstraint  (IDBonusHunt, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDBonusHunt, AvoidPlayer);
	rmAddObjectDefConstraint  (IDBonusHunt, AvoidAll);
	rmAddObjectDefConstraint  (IDBonusHunt, AvoidForestShorter);

	int IDBonusHunt2             = rmCreateObjectDef("bonus huntable 2");
	if (rmRandFloat(0.0, 1.0) < 0.5)
	{
		rmAddObjectDefItem    (IDBonusHunt2, "Aurochs", 2, 4);
	}
	else
	{
		rmAddObjectDefItem    (IDBonusHunt2, "Caribou", rmRandInt(3.0, 5.0), 5);
		rmAddObjectDefItem    (IDBonusHunt2, "Elk", rmRandInt(2.0, 4.0), 5);
	}
	rmSetObjectDefMinDistance (IDBonusHunt2, 90.0);
	rmSetObjectDefMaxDistance (IDBonusHunt2, 130.0);
	rmAddObjectDefConstraint  (IDBonusHunt2, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDBonusHunt2, AvoidFoodFar);
	rmAddObjectDefConstraint  (IDBonusHunt2, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDBonusHunt2, AvoidPlayer);
	rmAddObjectDefConstraint  (IDBonusHunt2, AvoidAll);
	rmAddObjectDefConstraint  (IDBonusHunt2, AvoidForestShorter);

	//Giant
	int IDRelicGiant		  = rmCreateObjectDef("giant relics");
	rmAddObjectDefItem        (IDRelicGiant, "Relic", 1, 1);
	rmSetObjectDefMinDistance (IDRelicGiant, 100.0);
	rmSetObjectDefMaxDistance (IDRelicGiant, 250.0);
	rmAddObjectDefConstraint  (IDRelicGiant, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDRelicGiant, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDRelicGiant, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDRelicGiant, rmCreateTypeDistanceConstraint("relic vs relic2", "relic", 70.0));
	rmAddObjectDefConstraint  (IDRelicGiant, AvoidPlayer);
	rmAddObjectDefConstraint  (IDRelicGiant, AvoidAll);

	int IDGiantPredator	 	  = rmCreateObjectDef("giant predator");
	rmAddObjectDefItem        (IDGiantPredator, "Polar Bear", 2, 3);
	rmSetObjectDefMinDistance (IDGiantPredator, 100.0);
	rmSetObjectDefMaxDistance (IDGiantPredator, 200.0);
	rmAddObjectDefConstraint  (IDGiantPredator, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDGiantPredator, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDGiantPredator, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDGiantPredator, AvoidPlayer);
	rmAddObjectDefConstraint  (IDGiantPredator, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDGiantPredator, AvoidAll);
	rmAddObjectDefConstraint  (IDGiantPredator, rmCreateTypeDistanceConstraint("pred vs pred2", "Polar Bear", 50.0));

	int IDGiantGold		 	  = rmCreateObjectDef("giant gold 2");
	rmAddObjectDefItem        (IDGiantGold, "gold mine", 1, 1);
	rmSetObjectDefMinDistance (IDGiantGold, rmXFractionToMeters(0.35));
	rmSetObjectDefMaxDistance (IDGiantGold, rmXFractionToMeters(0.75));
	rmAddObjectDefToClass	  (IDGiantGold, classFarGold);
	rmAddObjectDefConstraint  (IDGiantGold, AvoidGoldFar);
	rmAddObjectDefConstraint  (IDGiantGold, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDGiantGold, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDGiantGold, AvoidPlayerFar);
	rmAddObjectDefConstraint  (IDGiantGold, AvoidForestShorter);
	rmAddObjectDefConstraint  (IDGiantGold, AvoidAll);
	//rmAddObjectDefConstraint  (IDGiantGold, AvoidFarGold);

	int IDGiantHunt	 		  = rmCreateObjectDef("giant caribou elk");
	if(rmRandFloat(0.0, 1.0) < 0.5)
	{
		rmAddObjectDefItem    (IDGiantHunt, "Caribou", rmRandInt(6.0, 8.0), 4);
	} else {
		rmAddObjectDefItem    (IDGiantHunt, "Elk", rmRandInt(8.0, 11.0), 4);
	}
	rmSetObjectDefMinDistance (IDGiantHunt, 90.0);
	rmSetObjectDefMaxDistance (IDGiantHunt, 200.0);
	rmAddObjectDefConstraint  (IDGiantHunt, AvoidGoldShort);
	rmAddObjectDefConstraint  (IDGiantHunt, AvoidEdgeShort);
	rmAddObjectDefConstraint  (IDGiantHunt, AvoidFoodFar);
	rmAddObjectDefConstraint  (IDGiantHunt, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint  (IDGiantHunt, AvoidPlayer);
	rmAddObjectDefConstraint  (IDGiantHunt, AvoidAll);
	rmAddObjectDefConstraint  (IDGiantHunt, AvoidForestShorter);

	rmSetStatusText("",0.45);

	/// DEFINE PLAYER LOCATIONS
	rmSetTeamSpacingModifier(0.90);
	rmPlacePlayersCircular(0.35, 0.35, rmDegreesToRadians(0.0));


	/// TERRAIN DEFINITION
	float playerFraction=rmAreaTilesToFraction(1800);
	for(i=1; <cNumberPlayers)
	{
		int AreaPlayer =rmCreateArea("Player"+i);

		rmSetPlayerArea			(i, AreaPlayer);
		rmSetAreaSize			(AreaPlayer, playerFraction, playerFraction);
		rmAddAreaToClass		(AreaPlayer, classPlayer);
		rmSetAreaCoherence		(AreaPlayer, 1.0);
		rmSetAreaCliffType		(AreaPlayer, "Norse");
		rmSetAreaCliffEdge		(AreaPlayer, 2, 0.0, 0.0, 1.0, 1);
		rmSetAreaCliffHeight	(AreaPlayer, -5, 0.0, 1);
		rmSetAreaSmoothDistance (AreaPlayer, 20);
		rmSetAreaLocPlayer		(AreaPlayer, i);
		rmSetAreaTerrainType	(AreaPlayer, "GrassA");
		rmAddAreaTerrainLayer	(AreaPlayer, "SnowGrass75", 7, 12);
		rmAddAreaTerrainLayer	(AreaPlayer, "SnowGrass50", 3, 7);
		rmAddAreaTerrainLayer	(AreaPlayer, "SnowGrass25", 0, 3);

	}
	rmBuildAllAreas();

	rmSetStatusText("",0.53);

	for(i=1; <cNumberPlayers*5*mapSizeMultiplier)
	{
		int AreaSnowPatch	     = rmCreateArea("patch A"+i);
		rmSetAreaSize			(AreaSnowPatch, rmAreaTilesToFraction(75*mapSizeMultiplier), rmAreaTilesToFraction(150*mapSizeMultiplier));
		rmSetAreaTerrainType	(AreaSnowPatch, "SnowB");
		rmSetAreaMinBlobs		(AreaSnowPatch, 1);
		rmSetAreaMaxBlobs		(AreaSnowPatch, 5);
		rmSetAreaMinBlobDistance(AreaSnowPatch, 16.0);
		rmSetAreaMaxBlobDistance(AreaSnowPatch, 40.0);
		rmSetAreaCoherence		(AreaSnowPatch, 0.0);
		rmAddAreaConstraint		(AreaSnowPatch, AvoidPlayer);
		rmBuildArea(AreaSnowPatch);
	}

	for(i=1; <cNumberPlayers*5*mapSizeMultiplier)
	{
		int AreaCliffNorse		= rmCreateArea("patch B"+i);

		rmSetAreaSize			(AreaCliffNorse, rmAreaTilesToFraction(5*mapSizeMultiplier), rmAreaTilesToFraction(20*mapSizeMultiplier));
		rmSetAreaTerrainType	(AreaCliffNorse, "CliffNorseB");
		rmSetAreaMinBlobs		(AreaCliffNorse, 1);
		rmSetAreaMaxBlobs		(AreaCliffNorse, 5);
		rmSetAreaMinBlobDistance(AreaCliffNorse, 16.0);
		rmSetAreaMaxBlobDistance(AreaCliffNorse, 40.0);
		rmSetAreaCoherence		(AreaCliffNorse, 0.0);
		rmAddAreaConstraint		(AreaCliffNorse, AvoidPlayer);

		rmBuildArea(AreaCliffNorse);
	}


	rmSetStatusText("",0.60);

	///SETTLEMENTS
	rmPlaceObjectDefPerPlayer(IDStartingSettlement, true);

	int FairLocID = 0;
	if (cNumberNonGaiaPlayers < 3)
	{
	FairLocID = rmAddFairLoc("Settlement", false, true,  85, 100, 80, 33);
	FairLocID = rmAddFairLoc("Settlement", true, false,  85, 110, 130, 95);
	} else {
	FairLocID = rmAddFairLoc("Settlement", false, true,  100, 120, 95, 33);
	//rmAddFairLocConstraint	(FairLocID, AvoidPlayer);
	rmAddFairLocConstraint	(FairLocID, AvoidSettlementHOLYFUCK);

	FairLocID = rmAddFairLoc("Settlement", true, false,  100, 100+(cNumberNonGaiaPlayers*5), 95, 60);
	}
	if (cMapSize == 2) {
		FairLocID = rmAddFairLoc("Settlement", true, false,  100, 170, 95, 50);
	}


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
				rmSetAreaCoherence		(AreaSettlement, 1.0);
				rmSetAreaCliffType		(AreaSettlement, "Norse");
				rmSetAreaCliffEdge		(AreaSettlement, 2, 0.0, 0.0, 1.0, 1);
				rmSetAreaCliffHeight	(AreaSettlement, -5, 0.0, 1);
				rmSetAreaSmoothDistance	(AreaSettlement, 20);

				rmSetAreaSize			(AreaSettlement, playerFraction/2, playerFraction/2);

				rmSetAreaTerrainType	(AreaSettlement, "GrassA");
				rmAddAreaTerrainLayer	(AreaSettlement, "SnowGrass75", 6, 10);
				rmAddAreaTerrainLayer	(AreaSettlement, "SnowGrass50", 2, 6);
				rmAddAreaTerrainLayer	(AreaSettlement, "SnowGrass25", 0, 2);

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

		// Trees around settlement
		for (i = 1; < cNumberPlayers)
		{
			for (j = 0; < rmGetNumberFairLocs(i))
			{
				XPosFraction    	= rmFairLocXFraction(i, j);
				ZPosFraction    	= rmFairLocZFraction(i, j);

				int AmountOfForestsAroundSettlement = rmRandInt(5.0, 6.0);

				for (k = 0; < AmountOfForestsAroundSettlement)
				{
					// Calculate Positions around Settlements
					int   Radians 	= (TAU/(AmountOfForestsAroundSettlement)) * k;
					float Size 		= playerFraction + rmAreaTilesToFraction(350+(500*cNumberNonGaiaPlayers));
					float PositionX = XPosFraction + (Sin(Radians) * Size);
					float PositionZ = ZPosFraction + (Cos(Radians) * Size);
					float ForestSize = 60*mapSizeMultiplier;


					if (PositionX < 0 || PositionX > 1)
						continue;
					if (PositionZ < 0 || PositionZ > 1)
						continue;

					// Define Area's on those positions
					int SettlementForest			= rmCreateArea("SettlementForest"+NumTreeArea);
					rmSetAreaSize					(SettlementForest, rmAreaTilesToFraction(ForestSize-20), rmAreaTilesToFraction(ForestSize+20));
					rmSetAreaForestType				(SettlementForest, "snow pine forest");
					rmAddAreaToClass				(SettlementForest, classForest);
					rmSetAreaLocation				(SettlementForest, PositionX, PositionZ);
					rmSetAreaCoherence				(SettlementForest, 0.4);

					rmSetAreaMinBlobs		(SettlementForest, 1);
					rmSetAreaMaxBlobs		(SettlementForest, 2);
					rmSetAreaMinBlobDistance(SettlementForest, 16.0);
					rmSetAreaMaxBlobDistance(SettlementForest, 40.0);
					rmAddAreaConstraint		(SettlementForest, AvoidAll);
					rmAddAreaConstraint		(SettlementForest, AvoidForestShort);
					rmAddAreaConstraint		(SettlementForest, AvoidPlayer);
					rmAddAreaConstraint		(SettlementForest, AvoidSettlementAbit);
					// https://www.youtube.com/watch?v=0Hf2Obmci_o
					rmBuildArea(SettlementForest);

					// Increment Counters
					NumTreeArea = NumTreeArea + 1;
				}
			}
		}
	}

	/// ELEV

	int numTries=10*cNumberNonGaiaPlayers*mapSizeMultiplier;
	int failCount=0;
	for(i=0; <numTries)
	{
		int IDelev				=rmCreateArea("elev"+i);
		rmSetAreaSize			(IDelev, rmAreaTilesToFraction(100*mapSizeMultiplier), rmAreaTilesToFraction(200*mapSizeMultiplier));
		rmSetAreaWarnFailure	(IDelev, false);
		rmAddAreaConstraint		(IDelev, AvoidPlayer);
		rmAddAreaConstraint		(IDelev, AvoidAll);
		rmAddAreaConstraint		(IDelev, AvoidSettlementSomewhat);

		if(rmRandFloat(0.0, 1.0)<0.5)
			rmSetAreaTerrainType(IDelev, "SnowB");

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

	rmSetStatusText("",0.70);

	// PLACE PLAYER OBJECTSs
	rmPlaceObjectDefPerPlayer(IDStartingGoldmine, true, 2);
	rmPlaceObjectDefPerPlayer(IDStartingTower, true, 4);
	rmPlaceObjectDefPerPlayer(IDStartingBerry, false);
	rmPlaceObjectDefPerPlayer(IDStartingChicken, false);
	rmPlaceObjectDefPerPlayer(IDStartingHerd, true);
	rmPlaceObjectDefPerPlayer(IDStragglerTree, false, rmRandInt(2.0, 5.0));

	rmPlaceObjectDefPerPlayer(IDMediumGoldmine, false);
	rmPlaceObjectDefPerPlayer(IDMediumHunt, false);
	rmPlaceObjectDefPerPlayer(IDMediumHunt2, false);
	rmPlaceObjectDefPerPlayer(IDMediumHunt3, false);
	rmPlaceObjectDefPerPlayer(IDMediumHerd, false, rmRandInt(1, 2));
	rmPlaceObjectDefPerPlayer(IDHawk, false, 5);

	rmPlaceObjectDefPerPlayer(IDFarGold, false, rmRandInt(2.0, 3.0));
	rmPlaceObjectDefPerPlayer(IDFarGold2, false, 1);
	rmPlaceObjectDefPerPlayer(IDFarBoar, false, 2);
	rmPlaceObjectDefPerPlayer(IDFarBoar2, false, 2);
	rmPlaceObjectDefPerPlayer(IDFarBerry, false, rmRandInt(1.0, 2.0));
	rmPlaceObjectDefPerPlayer(IDFarHunt, false, rmRandInt(2.0, 3.0));
	rmPlaceObjectDefPerPlayer(IDFarPredator, false, rmRandInt(1.0, 2.0));
	rmPlaceObjectDefPerPlayer(IDRelic, false, 3);

	if (cMapSize == 2) {
		rmPlaceObjectDefPerPlayer(IDGiantGold, false, 3);
		rmPlaceObjectDefPerPlayer(IDRelicGiant, false, 1);
		rmPlaceObjectDefPerPlayer(IDGiantHunt, false, rmRandInt(2.0, 3.0));
		rmPlaceObjectDefPerPlayer(IDGiantPredator, false, rmRandInt(1.0, 2.0));
	}


	float bonusChance = rmRandFloat(0, 1);
	if ( bonusChance < 0.75) {
		rmPlaceObjectDefPerPlayer(IDBonusHunt, false, rmRandInt(1.0, 2.0));
	}

	float bonusChance2 = rmRandFloat(0, 1);
	if ( bonusChance2 < 0.75) {
		rmPlaceObjectDefPerPlayer(IDBonusHunt2, false, 1);
	}

	for (i=1; <cNumberPlayers)
	rmPlaceObjectDefAtLoc	 (IDFarGoat, 0, 0.5, 0.5);

	rmSetStatusText("",0.78);
	// FORESTS.

	int forestObjConstraint=rmCreateTypeDistanceConstraint("forest obj", "all", 8.0);
	int forestCount=25*cNumberNonGaiaPlayers;
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
		rmSetAreaForestType (forestID, "snow pine forest");
		rmAddAreaConstraint (forestID, AvoidSettlementSomewhat);
		rmAddAreaConstraint (forestID, AvoidStartingSettlement);
		rmAddAreaConstraint (forestID, forestObjConstraint);
		rmAddAreaConstraint (forestID, AvoidForestMedium);
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

	int IDRock				 	 = rmCreateObjectDef("rock");
	rmAddObjectDefItem		 	 (IDRock, "rock granite sprite", 1, 0.0);
	rmSetObjectDefMinDistance	 (IDRock, 0.0);
	rmSetObjectDefMaxDistance	 (IDRock, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint 	 (IDRock, AvoidAll);
	rmPlaceObjectDefAtLoc	 	 (IDRock, 0, 0.5, 0.5, 40*cNumberNonGaiaPlayers*mapSizeMultiplier);

	int IDRune				 	 = rmCreateObjectDef("runestone");
	rmAddObjectDefItem		 	 (IDRune, "runestone", 1, 0.0);
	rmSetObjectDefMinDistance	 (IDRune, 0.0);
	rmSetObjectDefMaxDistance	 (IDRune, rmXFractionToMeters(0.5));
	rmAddObjectDefConstraint 	 (IDRune, AvoidAll);
	rmAddObjectDefConstraint 	 (IDRune, AvoidSettlementSomewhat);
	rmAddObjectDefConstraint 	 (IDRune, rmCreateTypeDistanceConstraint("Rune vs Rune", "runestone", 70.0));
	rmPlaceObjectDefAtLoc	 	 (IDRune, 0, 0.5, 0.5, 2*cNumberNonGaiaPlayers*mapSizeMultiplier);

	rmSetStatusText("",0.90);

	///SNOW!
	rmCreateTrigger			 	 ("Snow_A");
	rmCreateTrigger			 	 ("Snow_backup");

	rmSwitchToTrigger		  	 (rmTriggerID("Snow_A"));
	rmSetTriggerPriority		 (2);
	rmSetTriggerLoop			 (false);
	rmAddTriggerCondition	  	 ("Timer");
	rmSetTriggerConditionParamInt("Param1", 2);

	rmAddTriggerEffect			 ("Render Snow");
	rmSetTriggerEffectParamFloat ("Percent", 0.1);

	rmAddTriggerEffect			 ("Fire Event");
	rmSetTriggerEffectParamInt	 ("EventID", rmTriggerID("Snow_backup"));

	rmSwitchToTrigger			 (rmTriggerID("Snow_backup"));
	rmSetTriggerPriority		 (2);
	rmSetTriggerActive			 (false);
	rmSetTriggerLoop			 (false);
	rmAddTriggerCondition		 ("Timer");
	rmSetTriggerConditionParamInt("Param1", 60);

	rmAddTriggerEffect			 ("Fire Event");
	rmSetTriggerEffectParamInt	 ("EventID", rmTriggerID("Snow_A"));

	// RM X Finalize.
	rmxFinalize();

	rmSetStatusText("",1.00);
}