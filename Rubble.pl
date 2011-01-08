#!/usr/bin/perl
# Rubble is  very simple game whose object is to dominate your neighbor's
# kingdom.  You may do this by destroying their castle, assassinating
# their king, or destroying their army completely.

use strict;
use warnings;
use Time::HiRes;

my $InitialMenuInput = 0;
my $MainMenuResult = 0;
my $InputIsValid = 0;

my $Player1_Name = "";
my $Player2_Name = "";
my $Player1_Type = "";
my $Player2_Type = "";
my $Player1_AIType = "";
my $Player2_AIType = "";

my $RoundCounter = 1; #initializes the RoundCounter variable to 1
my $RandMessage = "Test";
my $val = 1;
my $ResourceTotal = 0;
my $round_cnt = 0;
my $cnt3 = 0;
my $SleepTime = 5; #Sleep time between round (in seconds)
my $Victor = ""; #Variable to hold the name of the victor.
my $CompDefaultAction = 1;
my $Message = "";
my $UserIntInput = 0; #Stores the integer interpretation of the users's input
my $CombatIntensity = 1.0; #Combat Intensity value
my $CombatLength = 1.0; #Combat Length value
my $SuccessfulSub = 0; # Checks the return value of subs to see if they were 
		       # executed successful
my $Trashvar = 0; # Stores garbage input from user in <pause> situations.
my $Player2Win = 0; # Did Player 2 win?
my $Player1Win = 0; # Did player 1 win?
my $TA_AttackerOriginalStrength = 0;

my $dice2 = 0;

my $Attacker_RoundSoldLoss = 0;
my $Attacker_RoundHeroLoss = 0;
my $Defender_RoundSoldLoss = 0;
my $Defender_RoundHeroLoss = 0;
my $Loss_Val = 0;

# Initialize combat variables
my $TA_AttackerLosses = 0;
my $TA_DefenderLosses = 0;
my $TA_AttackerHLosses = 0;
my $TA_DefenderHLosses = 0;
my $TA_AttackerSoldiers = 0;
my $TA_AttackerUnits = 0;
my $TA_AttackerHeroes = 0;
my $TA_DefenderSoldiers = 0;
my $TA_DefenderUnits = 0;
my $TA_DefenderHeroes = 0;
my $TA_DefenderWalls = 0;
my $TA_AttackerTotal = 0;
my $TA_DefenderTotal = 0;

# Array of AI First Names
my @AI_FirstNames = ("Blue", "Happy", "Quick", "Steely", "Random", "Quirky", "Smelly", "Red", "Heavy", "Sad", "Dangerous", "Timid", "Flawed", "Worried", "Open", "Big", "Strange", "Slow", "Tiny", "Flat", "Long", "Short", "Svelt", "Frumpy", "Scared", "Terrible", "Shiny", "Angry", "Mad", "Serious", "Sleepy", "Worried", "Green", "Yellow", "Purple", "Tired", "Serious", "Slippery", "Honest", "Flabby");

# Array of AI Middle Names
my @AI_MiddleNames = ("John", "Lisa", "Paul", "Emily", "Isaac", "Mary", "Stephen", "Helene", "Marcelus", "Flavia", "Quintus", "Cornelia", "Gaius", "Caesarea", "Edgar", "Maria", "Horrace", "Madeline", "Omar", "Christina", "Ahmed", "Phyllis", "Mohammed", "Jane", "Howard", "Amy", "Tom", "Wendy", "Mick", "Monica", "Lance", "Bethel", "Mikhail", "Eve", "Oxbow", "Mulva", "Chun", "Ingrid", "Gabic", "Elsah", "Fallow", "Aria", "Wilbur", "Cat", "Elmo", "Oriol", "Burt", "Vicky", "Walt", "Selma", "Ibrahim", "Sara", "Slayer", "Betty", "John", "Dagny", "Prince", "Edith", "Warren", "Carrol");

# Array of AI Last Names
my @AI_LastNames = ("Smith", "Michaels", "Wong", "Capulet", "Montague", "Pierre", "Dove", "Winkle", "Boyd", "Floyd", "Walpole", "Betard", "Shackleford", "Wallace", "McCloud", "Bertrand", "Sagan", "Curie", "Feynman", "Newton", "Stockton", "Reardon", "Galt", "Taggert"); 

# Array of weather types
my @WeatherTypes = ("Rainy", "Rainy", "Rainy", "Hot", "Hot", "Cold", "Freezing", "Mild", "Mild", "Mild", "Mild", "Windy", "Windy", "Mild", "Rainy", "Foggy", "Foggy", "Cool", "Mild");
my $WeatherToday = "";


# Array for storing possible number of rounds of combat in troop attack
my @PossibleRounds = (1,1,1,1,1,1,2,2,2,2,3,3,3,3,4,4,4,4,5,5,5,5,5,5,6,6,6,6,6,6,6,7,7,8,9,10,11,12,15);

# Hash for storing Computer player's assets
my %Player2_Assets = (
	soldiers => 0,
	fortifications => 0,
	assassins => 0,
	guards => 0,
	engineers => 0,
	heroes => 0,
	catapults => 0,
	food => 0,
	peasants => 0,
	gold => 0
	);

# Rubble values (Rubble is a liability, rather than an asset, and is tracked 
# independently).
my $Player2_Rubble = 0;
my $Player1_Rubble = 0;

# Hash for storing player assets
my %Player1_Assets = %Player2_Assets;

# Hash for storing cost/value of each resource type
my %AssetCost = (
	soldiers => 20,
	fortifications => 5,
	assassins => 30000,
	guards => 1000,
	engineers => 500,
	heroes => 5000,
	catapults => 25000,
	food => .1,
	peasants => 10,
	gold => 1
	);

# Hashes representing minimum percentages of resources
my %Player1_Share = (
	soldiers => 0.154,
	fortifications => 0.17,
	assassins => 0.0,
	guards => 0.05,
	engineers => 0.008,
	heroes => 0.008,
	catapults => 0.01,
	food => 0.025,
	peasants => 0.501,
	gold => 0.077
	);
my %Player2_Share = %Player1_Share;

my %Player2_ExtraShare = (
	soldiers => 0.0,
	fortifications => 0.0,
	assassins => 0.0,
	guards => 0.0,
	engineers => 0.0,
	heroes => 0.0,
	catapults => 0.0,
	food => 0.0,
	peasants => 0.0,
	gold => 0.0);

my %Player1_ExtraShare = %Player2_ExtraShare;

# Variables for keeping score
my $Player2_Score = 0;
my $Player1_Score = 0;

# Variable for tracking whose turn it is
my $TurnTracker = "Player1";
my $Attacker = "Player1";
my $Defender = "Player2";

# Hash for storing Player Action subs
my %ActionSubs = (
	1 => "TroopAttack",
	2 => "TroopRaid",
	3 => "KillCastle",
	4 => "PassTurn",
	5 => "GetSoldiers",
	6 => "GetPeasants",
	7 => "GetFood",
	8 => "GetEngineers",
	9 => "GetGuards",
	10 => "GetAssassins",
	11 => "GetFort",
	12 => "ClearRubble",
	13 => "SendAssassins",
	14 => "GetCatapults"
);

# Array for storing jingoistic exhortations
my @action_to_take = (
	"Your army awaits your orders, milord!",
	"Sire?",
	"Let us bring this pretender to his knees!",
	"Our catapults are loaded and ready, your majesty!",
	"What are your orders, sire?",
	"It is a good day to die!",
	"Let us drown the fields in blood!",
	"The omens are most ominous, your majesty.",
	"Let us use all the means at our disposal, sire.",
	"Mind the defenses, milord.",
	"Our armies grow bored, your excellency.",
	"The men are restless, sire.",
	"How shall we smite our foe, King?",
	"The omens are full of portents, my liege.",
	"An old man claims to have seen two snakes devouring each other, lord.",
	"Let us lead from behind, O king!",
	"Our spears are sharpened, and our soldiers hungry.",
	"What better day to finally end this conflict!",
	"That coward can't hide behind his walls forever!",
	"The men grow restless as this war drags on...",
	"We must send this wretch into the abyss of history!",
	"Shall we attack directly... or use the side door?",
	"Do not forget to consider all options, your majesty."
);

my $menu_item = "";

# Resource_Initializer
#
# This sub creates a random value for the total resources each player will be
# alotted.  Each player gets the same total value of resources, however which
# resources each player receives is random, with certain guaranteed minimums.
sub Resource_Initializer {
	my $RandResourceTotalVal = 0;
	
	# This loop generates a random total value for the resources
	for ($cnt3 = 15; $cnt3 >=1; $cnt3--) {
		$RandResourceTotalVal = $RandResourceTotalVal + (int(rand(300)) * int(rand(300)));
	}

	# Generate random values to divy remainder of resources for computer
	# and player
	my $Player2_ExtraTotal = 0;
	my $Player1_ExtraTotal = 0;
	for my $item (keys(%Player2_ExtraShare)) {
		$Player2_ExtraShare{$item} = rand(100);
		$Player1_ExtraShare{$item} = rand(100);
	}	
	for my $item (keys(%Player2_ExtraShare)) {
		$Player2_ExtraTotal+=$Player2_ExtraShare{$item};
		$Player1_ExtraTotal+=$Player1_ExtraShare{$item};
	}
	for my $item (keys(%Player2_ExtraShare)) {
		$Player2_ExtraShare{$item} = $Player2_ExtraShare{$item}/($Player2_ExtraTotal /.25);
		$Player1_ExtraShare{$item} = $Player1_ExtraShare{$item}/($Player1_ExtraTotal/.25);
	}
	
	# Add (randomized) ExtraShare to Share hash
	for my $item (keys(%Player1_Share)) {
		$Player1_Share{$item}+=$Player1_ExtraShare{$item};
		$Player2_Share{$item}+=$Player2_ExtraShare{$item};
	}
	
	# Convert: Share * Total Resource Value / item cost
	# This loop converts the value of the items in the _Share hashes to
	# actual assets in the _Assets hashes.
	for my $item (keys(%Player2_Assets)) {
		$Player2_Assets{$item} = int($Player2_Share{$item} * $RandResourceTotalVal / $AssetCost{$item});
		$Player1_Assets{$item} = int($Player1_Share{$item} * $RandResourceTotalVal / $AssetCost{$item});
	}
	$Player2_Assets{peasants}=int($Player2_Assets{peasants}/2);
	$Player1_Assets{peasants}=int($Player1_Assets{peasants}/2);
}

# TurnMenu
#
# This sub redraws the status screen at the beginning of each turn for the player.
sub TurnMenu {
	#system("cls");
	print "\n\n\n     ** Round Number: ", $RoundCounter, " ** \n";
	print "The weather today: ", $WeatherToday, "\n";
	print $Message, "\n";
	my $TM_TempString = "\$".$Attacker."_Name;";
	print "King ", eval $TM_TempString, "'s Turn\n";
	printf "%-18s%-30s%-30s\n", "Unit  ", "King ".$Player1_Name, "King ".$Player2_Name, "\n";
	print "----------------------------------------------------------------------\n";
	printf "%-18s%-30s%-30s\n", "Soldiers: ", $Player1_Assets{soldiers},$Player2_Assets{soldiers};
	printf "%-18s%-30s%-30s\n", "Fortifications: ", $Player1_Assets{fortifications}, $Player2_Assets{fortifications};
	printf "%-18s%-30s%-30s\n", "Rubble: ", $Player1_Rubble, $Player2_Rubble;
	printf "%-18s%-30s%-30s\n", "Assassins: ", $Player1_Assets{assassins}, $Player2_Assets{assassins};
	printf "%-18s%-30s%-30s\n", "Guards: ", $Player1_Assets{guards}, $Player2_Assets{guards};
	printf "%-18s%-30s%-30s\n", "Engineers: ", $Player1_Assets{engineers}, $Player2_Assets{engineers};
	printf "%-18s%-30s%-30s\n", "Heroes: ", $Player1_Assets{heroes},$Player2_Assets{heroes};
	printf "%-18s%-30s%-30s\n", "Catapults: ", $Player1_Assets{catapults}, $Player2_Assets{catapults};
	printf "%-18s%-30s%-30s\n", "Food: ", $Player1_Assets{food}, $Player2_Assets{food};
	printf "%-18s%-30.2f%-30.2f\n", "Food (Turns): ", FoodCalc("Player1"), FoodCalc("Player2");
	printf "%-18s%-30s%-30s\n", "Peasants: ", $Player1_Assets{peasants}, $Player2_Assets{peasants};
	printf "%-18s%-30s%-30s\n", "Gold: ", $Player1_Assets{gold}, $Player2_Assets{gold};
	ScoreCalc();
	print "----------------------------------------------------------------------\n";
#	printf "%-20s%-20s%-20s\n", "Scores: ", $Player1_Score, $Player2_Score;
	print "(1) Attack, (2) Raid, (3) Fire at Castle, (4) Pass Turn (no action),\n";
	print "(5) Draft Soldiers, (6) Release Soldiers, (7) Buy Food, (8) Recruit Engineers,\n";
	print "(9) Hire Guards, (10) Hire Assassins, (11) Build Fortifications,\n";
	print "(12) Clean up Rubble, (13) Send Assassins, (14) Buy Catapults";
	print "\n";
	print "How shall we proceed, your grace? ";
	my $user_input = <stdin>;
	return $user_input;
}

# ScoreCalc
#
# Sub totals the value of all assets for player and computer
sub ScoreCalc {
	$Player1_Score = 0;
	$Player2_Score = 0;
	
	for my $item (keys(%Player1_Assets)) {
		$Player1_Score += $Player1_Assets{$item} * $AssetCost{$item};
		# print " _Player ", $item, " - ", $Player1_Assets{$item}, " - ", $Player1_Assets{$item} * $AssetCost{$item}, "\n";
		$Player2_Score += $Player2_Assets{$item} * $AssetCost{$item};
		# print " _Computer ", $item, " - ", $Player2_Assets{$item}, " - ", $Player2_Assets{$item} * $AssetCost{$item}, "\n";
	}
}

# MotivateMessage
#
# This sub randomly picks from the available motivation messages to display
# at the top of the menu screen.
sub MotivateMessage {	
	$menu_item = int(rand(@action_to_take));
	
	$RandMessage = $action_to_take[$menu_item]; 
 	return $RandMessage;
}

# TroopAttack
#
#
sub TroopAttack {
	# Reset variables for storing lost units
	$Attacker_RoundSoldLoss = 0;
	$Attacker_RoundHeroLoss = 0;
	$Defender_RoundSoldLoss = 0;
	$Defender_RoundHeroLoss = 0;
	$TA_AttackerHLosses = 0;
	$TA_AttackerLosses = 0;
	$TA_DefenderHLosses = 0;
	$TA_DefenderLosses = 0;
	
	# Get the attacker's original strength.  This value is used to
	# determine if the attacker should retreat
	$TA_AttackerOriginalStrength = 0;
	my $TA_TempString = "\$".$Attacker."_Assets{soldiers}";
	my $TA_AttackerOriginalStrength = eval $TA_TempString;

	# Determine Base Intensity
	my $TAcnt = 0;
	$CombatIntensity = rand(40)+20;
	$CombatIntensity = int($CombatIntensity);
	
	# Apply intensity modifiers.
	if ($WeatherToday eq "Rainy") { $CombatIntensity = $CombatIntensity*1.3};
	if ($WeatherToday eq "Hot") { $CombatIntensity = $CombatIntensity*0.4 };
	if ($WeatherToday eq "Cold") { $CombatIntensity =$CombatIntensity*0.75};
	if ($WeatherToday eq "Freezing") { $CombatIntensity =$CombatIntensity*0.55 };
	if ($WeatherToday eq "Mild") { $CombatIntensity = $CombatIntensity*1.5 };
	if ($WeatherToday eq "Windy") { $CombatIntensity = $CombatIntensity*0.8};
	if ($WeatherToday eq "Foggy") { $CombatIntensity=$CombatIntensity*0.6};
	if ($WeatherToday eq "Cool") { $CombatIntensity+=20};
	
	# Determine max number of rounds from array storing possible values
	my $TA_Rounds = @PossibleRounds[int(rand(@PossibleRounds))-1];
	
	if ($TA_AttackerOriginalStrength < 100) {
		print "We have only ", $TA_AttackerOriginalStrength, " soldiers...\n";
		print "Sire, we dare not storm the walls with so few!\n";
		print "Press <enter> to continue.\n";
		$Trashvar = <stdin>;
		return 0;
	}	

	# Get the rest of the original strengths for attackers and defenders.
	# These values will be displayed at the end
	my $TA_AS = $TA_AttackerOriginalStrength;
	$TA_TempString = "\$".$Attacker."_Assets{heroes};";
	my $TA_AH = eval $TA_TempString;
	$TA_TempString = "\$".$Defender."_Assets{soldiers};";
	my $TA_DS = eval $TA_TempString;
	$TA_TempString = "\$".$Defender."_Assets{heroes};";
	my $TA_DH = eval $TA_TempString;
	
	my $TAcnt2 = 0;
	
	# Reset Loss Tracker Variables
	$TA_AttackerLosses = 0;
	$TA_DefenderLosses = 0;
	$TA_AttackerHLosses = 0;
	$TA_DefenderHLosses = 0;

	# Loop (rounds) or until attackers have lost half strength
	for ($TAcnt=1; $TAcnt<=$TA_Rounds; $TAcnt++) {
		sleep (1.0);
		# Reset variables
		$Attacker_RoundSoldLoss = 0;
		$Attacker_RoundHeroLoss = 0;
		$Defender_RoundSoldLoss = 0;
		$Defender_RoundHeroLoss = 0;

		my $Temp_Losses = 0;
		
		# Determine number of assault units of attacker
		$TA_TempString = "\$".$Attacker."_Assets{soldiers}" ;
		$TA_AttackerSoldiers = eval $TA_TempString;
		$TA_AttackerUnits = int($TA_AttackerSoldiers/100);
		# Determine number of hero units of attacker
		$TA_TempString = "\$".$Attacker."_Assets{heroes}";
		$TA_AttackerHeroes = eval $TA_TempString;
		# Determine number of defense units of attacker
		$TA_TempString = "\$".$Defender."_Assets{soldiers}" ;
		$TA_DefenderSoldiers = eval $TA_TempString;
		$TA_DefenderUnits = int($TA_DefenderSoldiers/100) + 1;
		# Determine number of fortification units of defenders
		$TA_TempString = "int(\$".$Defender."_Assets{fortifications}/2500)-1" ;
		$TA_DefenderWalls = eval $TA_TempString;

		# Soldiers can only have one wall protecting them.
		if ($TA_DefenderWalls > $TA_DefenderUnits) {
			$TA_DefenderWalls = $TA_DefenderUnits;
		}

		# Determine number of hero units of defender
		$TA_TempString = "\$".$Defender."_Assets{heroes}";
		$TA_DefenderHeroes = eval $TA_TempString;

		# Total offensive and defensive units
		$TA_AttackerTotal = $TA_AttackerUnits + $TA_AttackerHeroes;
		$TA_DefenderTotal = $TA_DefenderUnits + $TA_DefenderHeroes + $TA_DefenderWalls;
		
		print "\nPreparing our assault, milord, round ", $TAcnt, ".\n";
		print "We have ", $TA_AttackerTotal, " units.  The enemy has ", $TA_DefenderTotal, " units.\nIt begins.\n\n";
		
		if (($TA_AttackerTotal / 2) > $TA_DefenderTotal) {
			$CombatIntensity = int($CombatIntensity * ($TA_AttackerTotal / $TA_DefenderTotal));
		}

		# Run assault units
		for ($TAcnt2 = 1; $TAcnt2<=$TA_AttackerUnits; $TAcnt2++) {
			ResultDeterminer();
		};

		# Run hero assaults
		for ($TAcnt2 = 1; $TAcnt2<=$TA_AttackerHeroes; $TAcnt2++) {
			HeroResultDeterminer();
		};

		$Loss_Val = 0;
		# Subtract Lost Attacker Soldiers
		for ($TAcnt2 = 1; $TAcnt2<=$Attacker_RoundSoldLoss; $TAcnt2++) {
			$Loss_Val = int(rand($CombatIntensity)+1);
			if ($Loss_Val > 100) { $Loss_Val = 100; }
			$TA_AttackerLosses+=$Loss_Val;
			$Temp_Losses += $Loss_Val;
			$TA_TempString = "\$".$Attacker."_Assets{soldiers}-=\$Loss_Val" ;
			eval $TA_TempString;
		}
		
		print "Round ", $TAcnt, " losses:\n Attacker Soldiers lost: ", $Temp_Losses, "  Heroes lost: ", $Attacker_RoundHeroLoss, "\n";

		# Subtract Lost Attacker Heroes
		$TA_TempString = "\$".$Attacker."_Assets{heroes}-=\$Attacker_RoundHeroLoss" ;
		eval $TA_TempString;

		# Subtract Lost Defender Soldiers
		$Temp_Losses = 0;
		for ($TAcnt2 = 1; $TAcnt2<=$Defender_RoundSoldLoss; $TAcnt2++) {
			$Loss_Val = int(rand($CombatIntensity)+1);
			if ($Loss_Val > 100) { $Loss_Val = 100; }
			$Temp_Losses += $Loss_Val;
			$TA_DefenderLosses+=$Loss_Val;
			$TA_TempString = "\$".$Defender."_Assets{soldiers}-=\$Loss_Val" ;
			eval $TA_TempString;
		}

		# Make sure defender doesn't lose more soldiers than he has.
		if ($TA_DefenderLosses > $TA_DS) {
			# Calculate extra automatic hero kills
			my $TA_HeroExtraKills = int(($TA_DefenderLosses - $TA_DS)/100);
			# Set total soldier losses = original soldier value.
			$TA_TempString = "\$".$Defender."_Assets{soldiers} = 0";
			eval $TA_TempString;
			$Defender_RoundHeroLoss+=$TA_HeroExtraKills;
			if ($Defender_RoundHeroLoss > $TA_DH) { $Defender_RoundHeroLoss = $TA_DH; }
			$TA_DefenderLosses = $TA_DS;
		}

		my $DefenderHeroLoss_ThisRound = 0;
		# Subtract Lost Defender Heroes
		$TA_TempString = "\$".$Defender."_Assets{heroes}";
		$DefenderHeroLoss_ThisRound = eval $TA_TempString;
		$TA_TempString = "\$".$Defender."_Assets{heroes}-=\$Defender_RoundHeroLoss" ;
		eval $TA_TempString;
		$TA_TempString = "\$".$Defender."_Assets{heroes}";
		$DefenderHeroLoss_ThisRound -= eval $TA_TempString;
		my $TempHeroes = eval $TA_TempString;
		if ($TempHeroes < 1) {
			$TA_TempString = "\$".$Defender."_Assets{heroes} = 0";
			eval $TA_TempString;
		}

		# Clean up defender loss values and report to players
		if ($Temp_Losses > $TA_DS) { $Temp_Losses = $TA_DS; }
		print " Defender Soldiers lost: ", $Temp_Losses, "  Heroes lost: ", $DefenderHeroLoss_ThisRound, "\n";
		
		# Make sure defender doesn't lose more heroes than he has
		if ($TA_DefenderHLosses > $TA_DH) { $TA_DefenderHLosses = $TA_DH};

		# Check to see if attacker has lost more than half his force.
		# If so, he will withdraw, unless the battle is going well
		if (($TA_AttackerLosses > $TA_AS/2) && (($TA_DefenderLosses * 1.25) < ($TA_DS/2))) {
			$TAcnt = $TA_Rounds;
			print "Sire, we must fall back before we have no army left to defend our own walls!\n";
			print "Press <enter> to continue.";
			$Trashvar = <stdin>;
		}
	
		# Adjust variables used for tracking overall Hero Losses
		$TA_AttackerHLosses+=$Attacker_RoundHeroLoss;
		$TA_DefenderHLosses+=$Defender_RoundHeroLoss;
		
		# Check to see if defender has been vanquished
		if (($TA_DefenderLosses >= $TA_DS) && ($TA_DefenderHLosses >= $TA_DH)) {
			$TAcnt = $TA_Rounds;
		}
	}


	# Report outcome of assault
	# Attacker's Losses
	print "\n------------------------------------------------\n";
	print "Battle Results:\n";
	print "------------------------------------------------\n";
	printf "Sir, we attacked with %s soldiers, and %s heroes.\n", $TA_AS, $TA_AH;
	printf "%s soldiers and %s heroes were lost.\n\n", $TA_AttackerLosses, $TA_AttackerHLosses;

	# Defender's Losses
	printf "The enemy met our assault with %s soldiers, and %s heroes.\n", $TA_DS, $TA_DH;
	printf "%s of his soldiers and %s of his heroes will trouble us no longer.\n\n", $TA_DefenderLosses, $TA_DefenderHLosses;

	# Hold for user input.
	print "Press <enter> to continue.\n";
	$Trashvar = <stdin>;
	
	# Check to see if attack was successful and castle was stormed
	if (($TA_DS <= $TA_DefenderLosses) && ($TA_DH <= $TA_DefenderHLosses)) {
		return 2;
	}
	else {
		return 1;
	}
		
}


# ResultDeterminer
#
# This sub determines the result of an individual sortie of soldiers
sub ResultDeterminer {
	# $dice determines which defender the attacker is against
	my $dice = int(rand($TA_DefenderTotal)) + 1;
	# $dice2 is used to determine the outcome of the encounter
	$dice2 = int(rand(100) + 1);
	if ($dice <= $TA_DefenderUnits) {
		# Attacker encounters a soldier
		if ($dice2 < 50) {
			# Attacker wins
			$Defender_RoundSoldLoss++;
		}
		elsif ($dice2 < 100) {
			# Defender wins
			$Attacker_RoundSoldLoss++;
		}
	}
	elsif ($dice <= ($TA_DefenderUnits + $TA_DefenderHeroes)) {
		# Attacker encounters a hero 
		if ($dice2 <= 8) {
			# Defending Hero dies 
			$Defender_RoundHeroLoss++;
			print "We have slain an enemy hero!\n";
		}
		elsif ($dice2 < 80) {
			# Attacking soldier dies
			$Attacker_RoundSoldLoss++;
		}
	}
	elsif ($dice <= ($TA_DefenderUnits + $TA_DefenderHeroes + $TA_DefenderWalls)) {
		# Attacking soldier encounters a wall
		if ($dice2 < 30) {
			# Attacking Soldier dies
			$Attacker_RoundSoldLoss++;
		}
	}
}

# HeroResultDeterminer
#
# This sub determines the result of an individual sortie of a hero
sub HeroResultDeterminer {
	my $dice = int(rand($TA_DefenderTotal)) + 1;
	$dice2 = int(rand(100) + 1);
	if ($dice <= $TA_DefenderUnits) {
		# Attacking hero encounters a soldier
		if ($dice2 < 50) {
			# Attacker wins
			$Defender_RoundSoldLoss++;
		}
		elsif ($dice2 < 58) {
			# Defender wins
			$Attacker_RoundHeroLoss++;
			print "One of our heroes has fallen...\n";
		}
	}
	elsif ($dice <= ($TA_DefenderUnits + $TA_DefenderHeroes)) {
		# Attacking hero encounters a hero 
		if ($dice2 < 10) {
			# Defending Hero dies 
			$Defender_RoundHeroLoss++;
			print "Huzzah, one of their heroes is slain!\n";
		}
		elsif ($dice2 < 20) {
			# Attacking Hero dies
			$Attacker_RoundHeroLoss++;
			print "Sire... a hero is no longer with us...\n";
		}
	}
	elsif ($dice <= ($TA_DefenderUnits + $TA_DefenderHeroes + $TA_DefenderWalls)) {
		# Attacking hero encounters a wall
		if ($dice2 <= 1) {
			# Attacking Hero dies
			$Attacker_RoundHeroLoss++;
			print "Oh no!  One of our heroes has met with misfortune!\n";
		}
	}
}

# TroopRaid
#
# This command sends a raid to seize enemy materiel
sub TroopRaid {
	print "My lord, we have hand-picked the best man from each unit to launch a daring\nraid on our enemy!\n";
	my $TR_TempString = "\$".$Attacker."_Assets{heroes}";
	my $TR_AttackerHeroes = eval $TR_TempString;
	$TR_TempString = "\$".$Attacker."_Assets{soldiers}";
	my $TR_AttackerSoldiers = eval $TR_TempString;
	$TR_TempString = "\$".$Defender."_Assets{fortifications}";
	my $TR_DefenderFortifications = eval $TR_TempString;
	$TR_TempString = "\$".$Defender."_Assets{food}";
	my $TR_DefenderFood = eval $TR_TempString;
	$TR_TempString = "\$".$Defender."_Assets{soldiers}";
	my $TR_DefenderSoldiers = eval $TR_TempString;
	$TR_TempString = "\$".$Defender."_Assets{peasants}";
	my $TR_DefenderPeasants = eval $TR_TempString;
	$TR_TempString = "\$".$Defender."_Assets{guards}";
	my $TR_DefenderGuards = eval $TR_TempString;
	$TR_TempString = "\$".$Defender."_Assets{assassins}";
	my $TR_DefenderAssassins = eval $TR_TempString;
	$TR_TempString = "\$".$Defender."_Assets{catapults}";
	my $TR_DefenderCatapults = eval $TR_TempString;
	$TR_TempString = "\$".$Defender."_Assets{engineers}";
	my $TR_DefenderEngineers = eval $TR_TempString;
	$TR_TempString = "\$".$Defender."_Assets{heroes}";
	my $TR_DefenderHeroes = eval $TR_TempString;

	my $TR_Raiders = int($TR_AttackerSoldiers / 100);
	if ($TR_Raiders < 1) {
		print "Sire, with our forces stretched so thin, we dare not risk even one soldier on such a mission.\n";
		return 0; # Cannot send raid because there are too few soldiers
	}
	else {
		print "The men are good to go, sire.\nThere are ", $TR_Raiders, " raiders ready.";
	}
	
	my $TotalGuards = ($TR_DefenderGuards + (10 * $TR_DefenderHeroes));
	my $FortRatio = $TR_DefenderFortifications / $TotalGuards;
	print "Ratio is: ", $FortRatio, "\n";
	my $RaidSuccess = 25; # Tweak this number to affect chances of getting caught on approach (i.e. bonus to small raid forces)
	my $TRcnt = 0;
	my $TR_SightingVar = 0;
	for ($TRcnt = 1; $TRcnt <= $TR_Raiders; $TRcnt++) {
		$TR_SightingVar = rand(500 - $TotalGuards);
		print "Sightvar: ", $TR_SightingVar, " | SuccessVar: ", $RaidSuccess, "\n";
		if ($TR_SightingVar < $RaidSuccess) {
			print "One of our raiders was spotted: ", $TRcnt, "\n";
		}
	}
	
}

# KillCastle
#
# This command fires catapults at the enemy's fortifications.
sub KillCastle {
	# The effectiveness of firing catapults at the castle depends on
	# several factors.  First, weather can have an adverse effect on hit
	# accuracy.  Windy, rainy, and (to a lesser extent) cold days make
	# shots less likely to hit walls.  Engineers will provide a bonus not
	# just to hit accuracy, but to damage if a shot hits.
	#
	# Shots that hit are tested to see if they destroy the wall.  Engineers
	# once again provide a bonus to this roll.  If the shot destroys the 
	# wall entirely, then damage is rolled to see what is destroyed behind
	# the wall (soldiers, peasants, catapults, etc).
	#
	# Players get 3 shots per catapult, and if they get a hit, they get
	# an extra shot.  Additionally, if a shot destroys a wall entirely,
	# they get another hit.

	# Determine if attacker has catapults.  If not, abort attack.
	my $KC_TempString = "\$".$Attacker."_Assets{catapults}";
	my $KC_AttackerCatapults = eval $KC_TempString;
	if ($KC_AttackerCatapults < 1) {
		return 0; # Attack aborts due to insufficient catapults
	}

	# Initialize Defender damage variables
	my $EngineerLosses = 0;
	my $SoldierLosses = 0;
	my $GuardLosses = 0;
	my $AssassinLosses = 0;
	my $CatapultLosses = 0;
	my $FortificationLosses = 0;
	my $FoodLosses = 0;
	my $HeroLosses = 0;
	my $PeasantLosses = 0;

	# Get other Attacker and Defender stats
	$KC_TempString = "\$".$Attacker."_Assets{engineers}";
	my $KC_AttackerEngineers = eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{soldiers}";
	my $KC_DefenderSoldiers = eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{peasants}";
	my $KC_DefenderPeasants = eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{guards}";
	my $KC_DefenderGuards = eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{fortifications}";
	my $KC_DefenderFortifications = eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{assassins}";
	my $KC_DefenderAssassins = eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{catapults}";
	my $KC_DefenderCatapults = eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{food}";
	my $KC_DefenderFood = eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{heroes}";
	my $KC_DefenderHeroes = eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{engineers}";
	my $KC_DefenderEngineers = eval $KC_TempString;

	# Engineers make targeting the fortifications more effective
	# First Roll for effectiveness of bombardment (effectiveness = potential damage/shot)
	my $Effectiveness = 0;
	my $BaseEffectiveness = 20;
	my $EngineerBonus = int($KC_AttackerEngineers ** .7);
	print "\nEngineer Bonus: ", $EngineerBonus, "\n";
	
	# Effectiveness is the number that a roll must beat to hit the target
	$Effectiveness = int($BaseEffectiveness + $EngineerBonus);
	print "Effectiveness before weather: ", $Effectiveness, "\n";
	# Determine weather bonuses
	if ($WeatherToday eq "Windy") {
		$Effectiveness = int($Effectiveness/1.5);
	}
	elsif ($WeatherToday eq "Rainy") {
		$Effectiveness = int($Effectiveness/1.1);
	}
	elsif ($WeatherToday eq "Mild") {
		$Effectiveness *= 2;
	}
	elsif ($WeatherToday eq "Cold") {
		$Effectiveness -= 10;
	}
	if ($Effectiveness < 3) { 
		$Effectiveness = 3; 
	}
	print "Effectiveness post-weather: ", $Effectiveness, "\n";

	# Determine targets
	my $DefenderWalls = int(sqrt($KC_DefenderFortifications));
	print "\nDefender Walls: ", $DefenderWalls, "\n";
	my $EngineersPerWall = int(1000 * $KC_DefenderEngineers / $DefenderWalls);
	my $SoldiersPerWall = int (1000 * $KC_DefenderSoldiers / $DefenderWalls);
	my $FoodPerWall = int (1000 * $KC_DefenderFood / $DefenderWalls);
	my $AssassinsPerWall = int (1000 * $KC_DefenderAssassins / $DefenderWalls);
	my $GuardsPerWall = int (1000 * $KC_DefenderGuards / $DefenderWalls);
	my $HeroesPerWall = int (1000 * $KC_DefenderHeroes / $DefenderWalls);
	my $FortificationsPerWall = int (1000 * $KC_DefenderFortifications / $DefenderWalls) + 200;
	my $CatapultsPerWall = int (1000 * $KC_DefenderCatapults / $DefenderWalls);
	my $PeasantsPerWall = int (1000 * $KC_DefenderPeasants / $DefenderWalls);

	# Calculate chance of catapult being destroyed while firing
	my $CatapultShatter = 10;
	if ($WeatherToday eq "Cold") { $CatapultShatter *= 2; }
	if ($WeatherToday eq "Freezing") { $CatapultShatter *= 3; }

	# Next loop for each shot and determine damage
	my $KC_Shots = $KC_AttackerCatapults * 3;
	my $KC_cnt = 0;
	my $KC_TargetDice = 0;
	my $KC_Delay = 0.3;
	$KC_Delay = 0.3 - ($KC_Shots - (.2 / 30));
	if ($KC_Delay < 0.1) { $KC_Delay = 0.1; }
	for ($KC_cnt = 0; $KC_cnt < $KC_Shots; $KC_cnt++) {
		$KC_TargetDice = int(rand(100 + $Effectiveness));
		# Check to see if shot hits
		use Time::HiRes qw ( sleep );
		sleep ($KC_Delay);		
		if ($KC_TargetDice < $Effectiveness) {
			$KC_cnt--;
			# Calculate whether wall is completely destroyed:
			my $KC_WallDice = int(rand(20 + $EngineerBonus));
			my $DamageToWall = $KC_WallDice / (30 + int(sqrt($DefenderWalls)));
			# printf "Amount of wall destroyed: %s\n", $DamageToWall;
			$FortificationLosses += int($FortificationsPerWall * $DamageToWall / 300);
			# Determine Damage to non-wall assets, which happens
			# when wall is completely destroyed

			if ($DamageToWall > 1) {
				if ($DamageToWall > 1.5) {
					print "< BOOOOM! >\n";
					$DamageToWall *= (rand(2) + 1);
				}
				else {
					print "< BANG! >\n";
				}
	 			# Determine remaining damage to be distributed
	 			my $ExtraDamage = $DamageToWall - 1;
				#if ($ExtraDamage > 1) { $ExtraDamage = 1; }
			
				$HeroLosses += int(rand($HeroesPerWall * 20) * $ExtraDamage);
				$SoldierLosses += int(rand($SoldiersPerWall * 2) * $ExtraDamage);
				$EngineerLosses += int(rand($EngineersPerWall * 20) * $ExtraDamage);
				$PeasantLosses += int(rand($PeasantsPerWall * 2) * $ExtraDamage);
				$CatapultLosses += int(rand($CatapultsPerWall * 50) * $ExtraDamage);
				$AssassinLosses += int(rand($AssassinsPerWall * 2) * $ExtraDamage);
				$GuardLosses += int(rand($GuardsPerWall * 2) * $ExtraDamage);
				$FoodLosses += int(rand($FoodPerWall * 20) * $ExtraDamage);
			}
			else {
				alarm 0;
				print "< BAM! >\n";
			}
		}
		else {
			print "* MISS! *\n";
		}
		
	}
	sleep (0.3);
	sleep (0.3);
	print "\n";
	$PeasantLosses = int($PeasantLosses / 200);
	$GuardLosses = int($GuardLosses / 50);
	$AssassinLosses = int($AssassinLosses / 200);
	$SoldierLosses = int($SoldierLosses / 50);
	$HeroLosses = int($HeroLosses / 200);
	$FoodLosses = int($FoodLosses / 500);
	$CatapultLosses = int($CatapultLosses / 1000);
	$EngineerLosses = int($EngineerLosses / 500);
	
	# Check to make sure more assets aren't being destroyed than are possessed by enemy
	if ($PeasantLosses > $KC_DefenderPeasants) { $PeasantLosses = $KC_DefenderPeasants; }
	if ($GuardLosses > $KC_DefenderGuards) { $GuardLosses = $KC_DefenderGuards; }
	if ($AssassinLosses > $KC_DefenderAssassins) { $AssassinLosses = $KC_DefenderAssassins; }
	if ($SoldierLosses > $KC_DefenderSoldiers) { $SoldierLosses = $KC_DefenderSoldiers; }
	if ($HeroLosses > $KC_DefenderHeroes) { $HeroLosses = $KC_DefenderHeroes; }
	if ($FortificationLosses > $KC_DefenderFortifications) { $FortificationLosses = $KC_DefenderFortifications; }
	if ($FoodLosses > $KC_DefenderFood) { $FoodLosses = $KC_DefenderFood; }
	if ($CatapultLosses > $KC_DefenderCatapults) { $CatapultLosses = $KC_DefenderCatapults; }
	if ($EngineerLosses > $KC_DefenderEngineers) { $EngineerLosses = $KC_DefenderEngineers; }

	print "\n BOMBARDMENT REULTS:\n";
	print "------------------------------------------\n";
	print "Peasants Killed: ", $PeasantLosses, "\n";
	print "Guards Killed: ", $GuardLosses, "\n";
	print "Assassins Killed: ", $AssassinLosses, "\n";
	print "Soldiers Killed: ", $SoldierLosses, "\n";
	print "Heroes Killed: ", $HeroLosses, "\n";
	print "Fortifications Destroyed: ", $FortificationLosses, "\n";
	print "Food Wasted: ", $FoodLosses, "\n";
	print "Catapults Destroyed: ", $CatapultLosses, "\n";
	print "Engineers Killed: ", $EngineerLosses, "\n\n";

	$KC_DefenderPeasants -= $PeasantLosses;
	if ($KC_DefenderPeasants < 1) { $KC_DefenderPeasants = 0; }
	$KC_DefenderGuards -= $GuardLosses;
	if ($KC_DefenderGuards < 1) { $KC_DefenderGuards = 0; }
	$KC_DefenderAssassins -= $AssassinLosses;
	if ($KC_DefenderAssassins < 1) { $KC_DefenderAssassins = 0; }
	$KC_DefenderSoldiers -= $SoldierLosses;
	if ($KC_DefenderSoldiers < 1) { $KC_DefenderSoldiers = 0; }
	$KC_DefenderHeroes -= $HeroLosses;
	if ($KC_DefenderHeroes < 1 ) { $KC_DefenderHeroes = 0; }
	$KC_DefenderFortifications -= $FortificationLosses;
	if ($KC_DefenderFortifications < 1 ) { $KC_DefenderFortifications = 0 }
	$KC_DefenderFood -= $FoodLosses;
	if ($KC_DefenderFood < 1) { $KC_DefenderFood = 0; }
	$KC_DefenderCatapults -= $CatapultLosses;
	if ($KC_DefenderCatapults < 1) { $KC_DefenderCatapults = 0; }
	$KC_DefenderEngineers -= $EngineerLosses;
	if ($KC_DefenderEngineers < 1) { $KC_DefenderEngineers = 0; }
	
	$KC_TempString = "\$".$Defender."_Assets{soldiers} = $KC_DefenderSoldiers";
	eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{peasants} = $KC_DefenderPeasants";
	eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{guards} = $KC_DefenderGuards";
	eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{fortifications} = $KC_DefenderFortifications";
	eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{assassins} = $KC_DefenderAssassins";
	eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{catapults} = $KC_DefenderCatapults";
	eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{food} = $KC_DefenderFood";
	eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{heroes} = $KC_DefenderHeroes";
	eval $KC_TempString;
	$KC_TempString = "\$".$Defender."_Assets{engineers} = $KC_DefenderEngineers";
	eval $KC_TempString;
	
	# Add Rubble
	$KC_TempString = "\$".$Defender."_Rubble += $FortificationLosses";
	eval $KC_TempString;

	# See if enemy castle was destroyed.
	if ($FortificationLosses == $KC_DefenderFortifications) {
		print "\nSire!  We have reduced the enemy's castle to Rubble!  Victory is ours!\n";
		return 2;
	}

	# Firing catapults was successful
	return 1;
}

# PassTurn
#
# This sub passes your turn
sub PassTurn {
	print "\n\nYes, sire, sometimes discretion is the better part of valor.\n";
	return 1;
} 

# GetSoldiers
#
# This command recruits soldiers from your peasantry
sub GetSoldiers {
	# Determine percentage of peasants to be recruited
	my $RecruitShare = int(rand(5) + 1) + 10;

	# Get population data
	my $TempPlayer = $Attacker;
	my $TempString = "\$".$TempPlayer."_Assets{soldiers}";
	my $TempSoldiers = eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{peasants}";
	my $TempPeasants = eval $TempString;
	
	# Calculate new recruits
	my $NewRecruits = int($TempPeasants * ($RecruitShare/100));
	print "New recruits: ", $NewRecruits, "\n";

	# Add recruits to army.
	$TempString = "\$".$TempPlayer."_Assets{soldiers} += $NewRecruits";
	eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{peasants} -= $NewRecruits";
	eval $TempString;
	
	# Recruiting soldiers was a success
	return 1;
}

# GetPeasants
#
# This command releases soldiers from your army to become peasants
sub GetPeasants {
	my $GP_TempString = "\$".$Attacker."_Assets{soldiers}";
	my $GP_Soldiers = eval $GP_TempString;
	my $GP_Releases = int($GP_Soldiers * (40 + int(rand(20)+1)) / 100);
	print "Release: ", $GP_Releases, "\n";
	$GP_TempString = "\$".$Attacker."_Assets{soldiers}-=$GP_Releases";
	eval $GP_TempString;
	$GP_TempString = "\$".$Attacker."_Assets{peasants}+=$GP_Releases";
	eval $GP_TempString;

	# Releasing soldiers was a success.
	return 1;
}

# GetFood
# 
# This command buys food
sub GetFood {
	my $TempString = "\$".$Attacker."_Assets{food} += (\$".$Attacker."_Assets{gold}*10)";
	eval $TempString;
	$TempString = "\$".$Attacker."_Assets{gold} = 0";
	eval $TempString;

	# Purchasing Food was a success.
	return 1;
}

# GetEngineers
#
# This command recruits engineers
sub GetEngineers {
	my $TempString = "int(\$".$Attacker."_Assets{gold}/500)" ;
	my $EngCandidates = eval $TempString;
	
		# Generate success rate
	my $SuccessVal = int(rand(100)+50);
	my $NewEngineers = 0;
	my $dice2 = 0;
	
	# Roll dice for each engineer to determine success/fail
	for ($cnt3=1; $cnt3<=$EngCandidates; $cnt3++) {
		$dice2 = int(rand(100));
		if ($dice2 < $SuccessVal) {
			$NewEngineers++;
		}
	}
	
	# Add new engineers
	$TempString = "\$".$Attacker."_Assets{engineers}+=\$NewEngineers" ;
	eval $TempString;

	# Subtract gold for hiring
	$TempString = "\$".$Attacker."_Assets{gold}-=(\$EngCandidates*500)" ;
	eval $TempString;

	# Report to player
	if ($NewEngineers > 0) {
		print "\n\n-----------------------------------------------------------------\n";
		print "Your majesty, some of the recruits were not up to the task.\nWe recruited ", $EngCandidates, " candidates, but only ", $NewEngineers, " completed their training.\nWe spent ", ($EngCandidates * 500), " gold on the training.\n";
		print "-----------------------------------------------------------------\n";
	}
	else { 
		print "\n\n-----------------------------------------------------------------\n";
		print "Your majesty, despite our best efforts, we were unable to recruit any engineers.\nWe spent ", ($EngCandidates * 500), " gold on the attempt.\n";
		print "-----------------------------------------------------------------\n";
	}

	sleep (0.8);

	print "Press <enter> to continue.\n";
	$TempString = <stdin>;
	return 1; # Recruiting Engineers was a success
}

# GetGuards
#
# This command recruits guards
sub GetGuards {
	my $GG_TempString = "\$".$Attacker."_Assets{gold}";
	my $GG_TempGold = eval $GG_TempString;
	$GG_TempString = "\$".$Attacker."_Assets{guards}";
	my $GG_TempGuards = eval $GG_TempString;
	my $NewGuards = int($GG_TempGold/2000);
	$GG_TempGuards += $NewGuards;
	if ($NewGuards < 1) {
		return 1; # Purchasing Guards not successful
	}
	$GG_TempGold -= ($NewGuards * 2000);
	$GG_TempString = "\$".$Attacker."_Assets{gold} = $GG_TempGold;";
	eval $GG_TempString;
	$GG_TempString = "\$".$Attacker."_Assets{guards} += $NewGuards;";
	eval $GG_TempString;	
	return 1; # Purchasing guards successful.
}

# GetAssassins
#
# This command recruits assassins
sub GetAssassins {
	my $GA_TempString = "\$".$Attacker."_Assets{gold}";
	my $GA_TempGold = eval $GA_TempString;
	$GA_TempString = "\$".$Attacker."_Assets{assassins}";
	my $GA_TempAssassins = eval $GA_TempString;
	my $NewAssassins = int($GA_TempGold/15000);
	$GA_TempAssassins += $NewAssassins;
	if ($NewAssassins < 1) {
		return 0; # Purchasing Assassins not successful
	}
	$GA_TempGold -= ($NewAssassins * 15000);
	$GA_TempString = "\$".$Attacker."_Assets{gold} = $GA_TempGold;";
	eval $GA_TempString;
	$GA_TempString = "\$".$Attacker."_Assets{assassins} += $NewAssassins;";
	eval $GA_TempString;	
	return 1; # Purchasing assassins successful.
} 

# GetFort
#
# This command buys fortification points
sub GetFort {
	my $GF_TempString = "\$".$Attacker."_Assets{gold}";
	my $GF_Gold = eval $GF_TempString;
	my $GF_PeasantFort = int(rand(20)) + 20;
	print "PeasantFort: ", $GF_PeasantFort, "\n";
	my $FortCost = int($GF_Gold/500)*500;
	my $GF_Fortifications = int($GF_Gold/500) * $GF_PeasantFort;
	print "The peasants have added ", $GF_Fortifications, " to our defenses.\n";
	$GF_TempString = "\$".$Attacker."_Assets{gold}-=$FortCost";
	eval $GF_TempString;
	$GF_TempString = "\$".$Attacker."_Assets{fortifications}+=$GF_Fortifications";
	eval $GF_TempString;
	return 1;
}

# ClearRubble
#
# This command clears rubble from the castle
# Returns 1 if some Rubble was cleared, 0 if Rubble could not be cleared.
sub ClearRubble {
	# This command mobilizes the peasantry to clear rubble from the castle.
	# Peasants will attempt to clear Rubble.  If Rubble remains, gold is spent to continue
	# hiring peasants to remove the rubble until the rubble is removed entirely or the 
	# gold runs out.

	# Initialize sub variables
	my $CR_TempString = "\$".$Attacker."_Assets{gold}";
	my $CR_Gold = eval $CR_TempString;
	$CR_TempString = "\$".$Attacker."_Assets{peasants}";
	my $CR_Peasants = eval $CR_TempString;
	$CR_TempString = "\$".$Attacker."_Rubble";
	my $CR_Rubble = eval $CR_TempString;

	# Check to see if sub needs to be run (Is there Rubble to remove?)
	if ($CR_Rubble < 1) {
		return 0;
	}

	# Peasants work first round for free
	my $CR_PeasantSuccess = (int(rand(10) + 10) / 500);
	# print "\nPeasantSuccess = ", $CR_PeasantSuccess, "\n";
	my $CR_RubbleRemoved = int($CR_PeasantSuccess * $CR_Peasants);
	if ($CR_RubbleRemoved > $CR_Rubble) {
		$CR_RubbleRemoved = $CR_Rubble;
	}

	my $CR_TotalRubbleRemoved = 0;
	$CR_TotalRubbleRemoved += $CR_RubbleRemoved;
	
	
	print "\n\n---------------------------------------------------------------------\n";
	
	# Report peasant success
	if ($CR_RubbleRemoved > 0) {
		print "Your peasants pitch in out of love and respect for your grace!\nThey have cleared ", $CR_RubbleRemoved, " units of Rubble.\n";
	}
	else {
		print "The worthless louts were unable to clear *any* Rubble!";
	}

	# Remove Free Peasant-Cleared Rubble
	$CR_TempString = "\$".$Attacker."_Rubble -= $CR_RubbleRemoved";
	eval $CR_TempString;
	$CR_Rubble -= $CR_RubbleRemoved;
	
	my $CR_PaidRounds = 0;
	my $CR_RoundCost = $CR_Peasants;
	my $CR_TotalCost = 0;
	my $CR_EnoughFunds = 1;
	if ($CR_Rubble > $CR_RubbleRemoved) {
		print "---------------------------------------------------------------------\n";
		print "Their backs aching, the peasants have lost the will to work for free.\nWe now must pay them if we want their help.\n";
		while (($CR_Rubble > 0) && ($CR_EnoughFunds == 1)) {
			if ($CR_RoundCost < $CR_Gold) {		
				$CR_PaidRounds++;
				$CR_TotalCost += $CR_RoundCost;
				# Subtract Cost for Round
				$CR_TempString = "\$".$Attacker."_Assets{gold} -= $CR_RoundCost";
				eval $CR_TempString;
				$CR_Gold -= $CR_RoundCost;

				# Calculate Rubble cleared
				$CR_PeasantSuccess = (int(rand(10) + 10) / 500);
				$CR_RubbleRemoved = int($CR_PeasantSuccess * $CR_Peasants);
				if ($CR_RubbleRemoved > $CR_Rubble) {
					$CR_RubbleRemoved = $CR_Rubble;
				}

				# Clear Rubble
				$CR_TotalRubbleRemoved += $CR_RubbleRemoved;
				$CR_Rubble -= $CR_RubbleRemoved;
				my $CR_TempString = "\$".$Attacker."_Rubble -= $CR_RubbleRemoved";
				eval $CR_TempString;

				# Report rubble cleared
				print "For ", $CR_RoundCost, " gold, the peasants cleared ", $CR_RubbleRemoved, " Rubble.\n";
			}
			else {
				print "Unfortunately, we have run out of funds, milord.\n";
				$CR_EnoughFunds = 0;
			}
			$CR_RoundCost *= 1.2;
			$CR_RoundCost = int($CR_RoundCost);
		}
		if ($CR_PaidRounds > 0) {
			print "---------------------------------------------------------------------\n";
			print "In total, we paid the peasants ", $CR_TotalCost, " gold to remove ", $CR_TotalRubbleRemoved, " Rubble.\n\n";
		}
	}
	
	# Indicate that sub was able to run successfully
	return 1;
}

# SendAssassins
#
# This sub sends available assassins against the enemy
sub SendAssassins {

}

# GetCatapults
#
# This sub purchases catapults
sub GetCatapults {
	my $GC_TempString = "\$".$Attacker."_Assets{gold}";
	my $GC_TempGold = eval $GC_TempString;
	$GC_TempString = "\$".$Attacker."_Assets{catapults}";
	my $GC_TempCatapults = eval $GC_TempString;
	my $NewCatapults = int($GC_TempGold/35000);
	$GC_TempCatapults += $NewCatapults;
	if ($NewCatapults < 1) {
		return 0; # Purchasing Catapults not successful
	}
	$GC_TempGold -= ($NewCatapults * 35000);
	$GC_TempString = "\$".$Attacker."_Assets{gold} = $GC_TempGold;";
	eval $GC_TempString;
	$GC_TempString = "\$".$Attacker."_Assets{catapults} += $NewCatapults;";
	eval $GC_TempString;	
	return 1; # Purchasing catapults successful.
}


# FoodCalc
#
# This sub calculates the number of turns worth of food remaining.  The
# estimate could prove to be inaccurate due to population growth or death.
sub FoodCalc {
	if (shift eq "Player2") {
		my $Player2_FoodTurns = (($Player2_Assets{food}) / ($Player2_Assets{soldiers} + $Player2_Assets{assassins} + $Player2_Assets{guards} + $Player2_Assets{engineers} + $Player2_Assets{heroes} + $Player2_Assets{peasants}));
		return $Player2_FoodTurns;
	}
	else {
		my $Player1_FoodTurns = (($Player1_Assets{food}) / ($Player1_Assets{soldiers} + $Player1_Assets{assassins} + $Player1_Assets{guards} + $Player1_Assets{engineers} + $Player1_Assets{heroes} + $Player1_Assets{peasants}));
		return $Player1_FoodTurns;
	}
}

# SwitchTurns
#
# Sub for switching whose turn it is
sub SwitchTurns {
	if ($TurnTracker eq "Player2") {
		$TurnTracker = "Player1";
		$Attacker = "Player1";
		$Defender = "Player2";
	}
	else {
		$TurnTracker = "Player2";
		$Attacker = "Player2";
		$Defender = "Player1";
	}
}

# VerifyAction
#
# Sub that verifies that a valid selection was made from the main menu.
sub VerifyAction {
	my $UserInput = shift;
	if ($UserInput =~ /[^0-9\n]/) {
		return 0;
	}
	else {
		$UserIntInput = int($UserInput);
		if (($UserIntInput > 0) && ($UserIntInput < 15)) {
			return 1;
		}
		else {
			return 0;
		}
	}
}

# RainMaker
#
# Determines weather pattern
sub RainMaker {
	$WeatherToday = $WeatherTypes[int(rand(@WeatherTypes))];
}

# Extern
#
# Calculates income, food consumption, and other automatic end-of-turn actions
sub Extern {
	# Load active player's assets into temporary variables
	my $TempPlayer = shift;
	my $TempString = "\$".$TempPlayer."_Assets{soldiers}";
	my $TempSoldiers = eval $TempString;	
	$TempString = "\$".$TempPlayer."_Assets{fortifications}";
	my $TempFortifications = eval $TempString;
	$TempString = "\$".$TempPlayer."_Rubble";
	my $TempRubble = eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{assassins}";
	my $TempAssassins = eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{guards}";
	my $TempGuards = eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{engineers}";
	my $TempEngineers = eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{heroes}";
	my $TempHeroes = eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{catapults}";
	my $TempCatapults = eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{food}";
	my $TempFood = eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{peasants}";
	my $TempPeasants = eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{gold}";
	my $TempGold = eval $TempString;

	# Calculate how much the population will grow from immigration
	my $GrowthFactor = sqrt(sqrt(sqrt(sqrt(sqrt($TempFortifications / 11000)))));
	print $GrowthFactor, "\n";
	my $PeasantIncrease = int($TempPeasants * $GrowthFactor) + (int(rand(50) + 1) * $TempHeroes) + (int(rand(3) + 1) * $TempEngineers) - $TempPeasants;

	# Calculate automatic clearing of Rubble and building of walls
	my $BuildFactor = int(rand(10)+1) + int(rand(5+1)) + int(rand(3)+1) + int(rand(2)+1);
	my $RubbleDecrease = $BuildFactor * $TempEngineers;
	my $WallIncrease = 0;
	if (($TempRubble - $RubbleDecrease) < 0) {
		$WallIncrease = int(($RubbleDecrease - $TempRubble)/4);
		$RubbleDecrease = $TempRubble;
	}

	# Calculate Taxes and Upkeep
	my $GoldIncrease = $TempPeasants;
	my $Costs =  ($TempSoldiers + (10 * $TempAssassins) + (10 * $TempGuards));
	my $Desertions = 0;

	# Make sure player has enough gold to cover costs
	if (($GoldIncrease + $TempGold) < $Costs) {
		print "Costs: ", $Costs, "\n";
		print "Taxes: ", $GoldIncrease, "\n";
		print "Previous Balance: ", $TempGold, "\n";
		$Desertions = int(rand(($Costs - ($GoldIncrease + $TempGold)) * 2/3));
		$GoldIncrease = ($TempGold * -1);
	}
	else {
		$GoldIncrease = $GoldIncrease - $Costs;
	}
	
	# Calculate Food Consumption
	my $FoodDecrease = $TempPeasants + $TempSoldiers + $TempAssassins + $TempGuards + $TempEngineers + $TempHeroes;

	# Calculate Plague Chance
	my $PlagueChance = int(100 * $TempRubble / ($TempRubble + $TempFortifications));
	my $PlagueBool = 0;
	my $PlagueDice = int(rand(100));
	my $PeasantDeaths = 0;
	my $SoldierDeaths = 0;
	if ($PlagueDice < $PlagueChance) {
		$PlagueBool = 1;	
		print "-----------------------------------------\n";
		print "Sire!  We are experiencing a plague!\nWe must clean the castle of debris and garbage at once!\n";
		print "-----------------------------------------\n";
		$PeasantDeaths = int($TempPeasants * .15);
		$SoldierDeaths = int($TempSoldiers * .12);
	}


	# Decrease Rubble
	my $AutoRubble = 0;
	$AutoRubble = int((rand(3) + 1) * ($TempEngineers ^ 1.5));
	if ($AutoRubble > $TempRubble) {
		$AutoRubble = $TempRubble;
	}

	# Report to player
	print "\n King ", $Attacker, "'s";
	print " State of the Kingdom:\n";
	print "-----------------------------------------\n";
	eval $TempString;
	# Apply changes
	$TempString = "\$".$TempPlayer."_Assets{peasants}+=$PeasantIncrease";
	print "Gained Peasants: ", $PeasantIncrease, "\n";
	eval $TempString;
	$TempString = "\$".$TempPlayer."_Assets{fortifications}+=$WallIncrease";
	eval $TempString;
	print "Gained Fortifications: ", $WallIncrease, "\n";
	$TempString = "\$".$TempPlayer."_Assets{food}-=$FoodDecrease";
	eval $TempString;
	print "Ate food: ", $FoodDecrease, "\n";
	$TempString = "\$".$TempPlayer."_Assets{gold}+=$GoldIncrease";
	eval $TempString;
	print "Net Income: ", $GoldIncrease, "\n";
	$TempString = "\$".$TempPlayer."_Assets{soldiers}-=$Desertions";
	eval $TempString;
	print "Soldiers deserted: ", $Desertions, "\n";
	print "Rubble cleared: ", $AutoRubble, "\n";
	$TempString = "\$".$TempPlayer."_Rubble -= $AutoRubble";
	eval $TempString;
	if ($PlagueBool == 1) {
		$TempString = "\$".$TempPlayer."_Assets{peasants} -= $PeasantDeaths";
		eval $TempString;
		$TempString = "\$".$TempPlayer."_Assets{soldiers} -= $SoldierDeaths";
		eval $TempString;
		print $PeasantDeaths, " of our people have died from the plague.\n";
		print $SoldierDeaths, " of our soldiers also succumbed to the plague.\n";
	}

	# Wait for user input to continue
	print "Press <enter> to continue...\n";
	$Trashvar = <stdin>;
}

# InitialMenu
#
# Gives players an initial menu with help and other options.
sub InitialMenu {
	my $InitialMenuInput_Raw = "";
	while ($InitialMenuInput == 0) {
		# Display Menu
		print "\n\n\n\nWelcome to Rubble, the fiendish text-based game of adventure and high strategy.\n";
		print "Choose from the options below.\n";
		print " 1 - Quick Play (Use last configuration)\n";
		print " 2 - Play Rubble! (Pick players)\n";
		print " 3 - How to play Rubble\n";
		print " 4 - Inspect a player's win/loss record\n";
		print " 5 - Exit Rubble\n";
		# Get player input
		print "Make your selection (1-5), followed by the <enter> key: "; 
		$InitialMenuInput = <stdin>;
		# $InitialMenuInput =~ s/[[:alpha:]]|[6-9]|[0]|\n//;
		$InitialMenuInput =~ s/[9]//;
		#print "\n", $InitialMenuInput, "...\n";
	}
}

# QuickPlay
#
# Uses last configuration to start another game
sub QuickPlay {
	# Try to open quick play file
	my $QPFileOpened = open(QPFILE, "<qpfile.dat");
	if ($QPFileOpened) {
		my @QPLines = <QPFILE>;
		chomp(@QPLines);
		$Player1_Type = $QPLines[0];
		$Player1_Name = $QPLines[1];
		$Player2_Type = $QPLines[2];
		$Player2_Name = $QPLines[3];
		print "\nFile read successful.  Players loaded:\n";
		print "Player 1 Type: ", $Player1_Type, "\n";
		print "Player 1 Name: ", $Player1_Name, "\n";
		print "Player 2 Type: ", $Player2_Type, "\n";
		print "Player 2 Name: ", $Player2_Name, "\n";
		print "Press <enter> to continue.";
		my $JunkVar = <stdin>;
	}
	else {
		print "\nFile Open Error:  You must have 'qpfile.txt'\n\n";
	}
}

# SelectPlayers
#
# Picks the type of players
sub SelectPlayers {
	my $Input_Validator = 0;
	while ($Input_Validator == 0) {
		print "Select Player 1 type (H for human, C for computer): ";
		$Player1_Type = <stdin>;
		if (($Player1_Type eq "C\n") or ($Player1_Type eq "c\n")) { 
			$Player1_Type = "c";
			$Input_Validator = 1; 
		}
		elsif (($Player1_Type eq "H\n") or ($Player1_Type eq "h\n")) {
			$Player1_Type = "h";
			print "Player 1, by what name shall your subjects know you? ";
			$Player1_Name = <stdin>;
			$Player1_Name =~ s/\n//;
			print "King ", $Player1_Name, ", is that correct? (y or n) ";
			my $Confirm_Input = <stdin>;
			if (($Confirm_Input eq "y\n") or ($Confirm_Input eq "Y\n")) {
				$Input_Validator = 1;
			}
		}
	}
	if ($Player1_Type eq "c") {
		my $AI_Input_Validator = 0;
		while ($AI_Input_Validator == 0) {
			print "Select AI: (1) King Mordan, (2) King Plemis, (3) King Rocharde: ";
			$Player1_AIType = <stdin>;
			if ($Player1_AIType =~ /[^0-9\n]/) {
			}
			else {
				$Player1_AIType = int($Player1_AIType);
				$AI_Input_Validator = 1;
				print $Player1_AIType, "\n";
			}
		}
	}	

	$Input_Validator = 0;
	while ($Input_Validator == 0) {
		print "Select Player 2 type (H for human, C for computer): ";
		$Player2_Type = <stdin>;
		if (($Player2_Type eq "C\n") or ($Player2_Type eq "c\n")) { 
			$Player2_Type = "c";
			$Input_Validator = 1; 
		}
		elsif (($Player2_Type eq "H\n") or ($Player2_Type eq "h\n")) {
			$Player2_Type = "h";
			print "Player 2, by what name shall your subjects know you? ";
			$Player2_Name = <stdin>;
			$Player2_Name =~ s/\n//;
			print "King ", $Player2_Name, ", is that correct? (y or n) ";
			my $Confirm_Input = <stdin>;
			if (($Confirm_Input eq "y\n") or ($Confirm_Input eq "Y\n")) {
				$Input_Validator = 1;
			}
		}
	}
	# Write Player choices to Quick Play file
	my $SPFileOpened = open(SPFILE, ">qpfile.dat");
	if ($SPFileOpened) {
		my @SPLines = {};
		$SPLines[0] = $Player1_Type."\n";
		$SPLines[1] = $Player1_Name."\n";
		$SPLines[2] = $Player2_Type."\n";
		$SPLines[3] = $Player2_Name."\n";
		print SPFILE @SPLines;
	}
	else {
		print "\nFile 'qpfile.dat' not found!\n";
	}
}

# Main
#
# Handles the main execution loop
sub Main {
	Resource_Initializer;
	for ($round_cnt = 100; $round_cnt>=1; $round_cnt--) {
		# Generate Random Weather
		RainMaker;
		# Check to see if player is human or AI, and decide action accordingly.
		if ($Player1_Type eq "h") {
			$InputIsValid = 0;
			$Message = MotivateMessage();
			while ($InputIsValid < 1) {
				$InputIsValid = VerifyAction(TurnMenu);
				$Message = "Err... I did not understand that command, sire.";
				if ($InputIsValid == 1) {
					my $SubName = $ActionSubs{$UserIntInput};
					# Runs the sub as specified by the user input	
					$SuccessfulSub = eval $SubName;
					# Check to see if sub was successful
					if ($SuccessfulSub == 0) {
						$InputIsValid = 0;
					}
					elsif ($SuccessfulSub == 2) {
						$Player1Win = 1;
					}
				}
			};
		}
		else {
			$SuccessfulSub = AI_Move();
			if ($SuccessfulSub == 2) {
				$Player1Win = 1;
			}
			
		}

	
		# Check to see if Player 1's action defeated Player 2
		if ($Player1Win == 1 ) {
			print "King ", $Player2_Name, " has been defeated!\n\n";
			return 0;
		}
		
		# Extern for Player
		Extern("Player1");

		# Switch Players
		SwitchTurns();

		# Computer takes turn
		$InputIsValid = 0;

		if ($Player2_Type eq "h") {
			$InputIsValid = 0;
			$Message = MotivateMessage();
			while ($InputIsValid < 1) {
				$InputIsValid = VerifyAction(TurnMenu);
				$Message = "Err... I did not understand that command, sire.";
				if ($InputIsValid == 1) {
					my $SubName = $ActionSubs{$UserIntInput};
					# Runs the sub as specified by the user input	
					$SuccessfulSub = eval $SubName;
					# Check to see if sub was successful
					if ($SuccessfulSub == 0) {
						$InputIsValid = 0;
					}
					elsif ($SuccessfulSub == 2) {
						$Player2Win = 1;
					}
				}
			};
		}
		else {
			print "Player 2 is a computer\n";
			$SuccessfulSub = AI_Move();
			if ($SuccessfulSub == 2) {
				$Player2Win = 1;
			}
		}
		# Check to see if the computer's action defeated the player	
		if ($Player2Win == 1 ) {
			print "King ", $Player1_Name, " has been defeated!\n\n";
			return 0;
		}

		# Extern for Computer
		Extern("Player2");		
	
		# Switch Players (for next round)
		SwitchTurns();
		
		# Increment the round counter
		$RoundCounter++;
	}
	if ($round_cnt == 0) {
		print "After years of suffering and hardship, your people have grown tired of this\n";
		print "conflict.  Finally they urge you to meet with your enemy and forge a peace that\n";
		print "will restore prosperity to the kingdom.\n"
	}
}

# AI_Move
#
# Calculates the move to be taken by the AI
sub AI_Move {
	while ($InputIsValid < 1) {
		my $AI_Action = int(rand(14) + 1);
		print "Randomly generated action: ", $AI_Action, "\n";
		$InputIsValid = VerifyAction($AI_Action);
		if ($InputIsValid == 1) {
			print "Computer elects to: ", $ActionSubs{$AI_Action}, "\n";
			# Runs the sub as specified by the AI Algorithm	
			$SuccessfulSub = eval $ActionSubs{$AI_Action};
			# Check to see if sub was able to be ran
			print $SuccessfulSub, " is the SuccessfulSub val.\n";
			if ($SuccessfulSub == 0) {
				$InputIsValid = 0;
			}
			elsif ($SuccessfulSub == 2) {
				return 2;
			}
		}
	};
}


# Help
#
# Displays rough outline of game concepts
sub Help {
	my $GarbageInput = "";
	print "\n\n\nThe Basics of Rubble:\n\n";
	print "In Rubble, your goal is to defeat the enemy king.  You may do this by\n";
	print "destroying his fortress entirely via bombardment, killing all of his soldiers\n";
	print "and heroes during an assault, murdering the king with assassins, or by economic\n";
	print "maneuvering.  You can't take forever to do so, however, as the game will halt\n";
	print "after 100 turns and your people will force a truce upon you. \n\n";
	print "Soldiers:\n";
	print "Soldiers make up the backbone of your army and are recruited from your\n";
	print "peasantry.  You may also release soldiers back into the peasantry if you\n";
	print "have too many or grow weary of paying them (1 gold each per turn) and would\n";
	print "rather collect taxes from them.  You will need significantly more soldiers\n";
	print "than your enemy if you wish to successfully storm his walls, while your own\n";
	print "walls can be safely defended with half or less as many soldiers as your enemy's\n";
	print "army possesses.\n\n";
	print "Peasants\n";
	print "Peasants pay taxes, can be drafted into your army, and may be trained as\n";
	print "engineers.  In a pinch, you may also force your peasants to help clear rubble\n";
	print "that may have accumulated from enemy bombardment.\n\n";
	print "Press <enter> to continue...";
	$GarbageInput = <stdin>;
	print "Assassins\n";
	print "The role of the assassin is plain and simple.  These expert killers will\n";
	print "attempt to infiltrate your enemy's fortress and murder him.  Only guards\n";
	print "have a chance of stopping these shadow masters, and they too may be killed\n";
	print "even if they manage to discover the assassin.  Assassins make use of uncleared\n";
	print "rubble to provide hiding spots and aid as they sneak about castles.\n\n";
	print "Guards\n";
	print "Guards are the natural counterpoint to assassins, and your only defense\n";
	print "against them.  Guards patrol your entire castle, so make sure you have enough\n";
	print "to keep all of your passages and parapets well-staffed.  Additional guards\n";
	print "may be hired for 2000 gold, and you can never have too many, though after a\n";
	print "certain point your gold is better spent on other options.\n\n";
	print "Engineers\n";
	print "Ah, yes, the versatile engineer.  It costs 500 gold just for the chance to\n";
	print "train an engineer, but they are one of the most powerful additions to your\n";
	print "realm. These masters of the physickal realm take it upon themselves to\n";
	print "contribute to your fortress's fortifications each turn, clear rubble that may\n";
	print "have accumulated and even make your catapults more accurate when targeting\n";
	print "your enemy's castle.  No kingdom can do without these worldly wizards, and\n";
	print "they are almost always a smart buy.\n\n";
	print "Press <enter> to continue...";
	$GarbageInput = <stdin>;
	print "Fortifications:\n";
	print "Heroes:\n";
	print "Food:\n";
	print "Gold:\n";
	print "Weather:\n";
	print "Emigration:\n";
}

# MenuHandler
#
# Handles input from main menu
sub MenuHandler {
	while ($InitialMenuInput != 4) {
		InitialMenu;
		if ($InitialMenuInput == 1) {
			QuickPlay;
			Main;
		}
		elsif ($InitialMenuInput == 2) {
			SelectPlayers;
			Main;
		}
		elsif ($InitialMenuInput == 3) {
			Help;
		}
		elsif ($InitialMenuInput == 4) {
	
		}
		elsif ($InitialMenuInput == 5) {
			return 0;
		}
		$InitialMenuInput = 0;
		# Reset Player-Win flags
		$Player1Win = 0;
		$Player2Win = 0;
	}
}


$MainMenuResult = 1;
while ($MainMenuResult == 1) {
	$MainMenuResult = MenuHandler;
}
print "\n\nThanks for playing Rubble!\n";	




# To Do List:
#  Finish Help File
#  Fix Player 2 is always Human
#  Implement external AI files
#  Add assassin mini-game
#  Add hero Generation
#  Fix Hero Loss display during attacks
#  Finish Raid implementation
