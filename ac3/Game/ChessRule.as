package ac3.Game 
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Game.*;
	import ac3.AI.*;
	
	public class ChessRule 
	{
		//============Static Variables============//
		//Use For API
		public static const STRING_DELIM:String=",";
		
		//====Default Rule====//
		//Game Global
		//for ChessTypes,null means spawn all types
		public static const d_enableDetectWin:Boolean=true;
		public static const d_swapableType:String=null;
		
		//Chess Move
		public static const d_maxActionDoingPerTrun:uint=1;
		public static const d_maxActionDoingPerChess:uint=1;
		public static const d_moveChessAfterEat:Boolean=true;
		
		//Chess Ability
		public static const d_chessMaxLevel:uint=999;
		
		//Chess Spawner
		public static const d_spawnerCanSpawnType:String=null;
		public static const d_spawnerSpawnLife:uint=10;
		public static const d_spawnerSpawnLifeUsingPerMove:uint=1;
		public static const d_spawnerSpawnLifeUsingPerTrun:uint=1;
		
		//Bonus
		public static const d_enableSpawnBonus:Boolean=false;
		public static const d_canSpawnBonusType:String=null;
		public static const d_bonusSpawnChance:Number=1/32;
		public static const d_bonusChessGroupSpawnChance:Number=1/5;
		public static const d_maxBonusChessCountAtOnce:uint=4;
		public static const d_bonusSpawnChanceModifierLess:uint=8;
		public static const d_bonusSpawnChanceModifierChance:Number=1/4;
		public static const d_bonusImportmentChance:Number=1/10;
		public static const d_bonusSpawnLimitCount:uint=64;
		public static const d_bonusSpawnLifeLeast:uint=10;
		public static const d_bonusSpawnLifeMost:uint=10;
		public static const d_bonusSpawnLifeUsePerMove:uint=0;
		public static const d_bonusSpawnLifeUsePerTrun:uint=0;
		
		//============Static Functions============//
		public static function fromString(string:String):ChessRule
		{
			var result:ChessRule=new ChessRule().loadByString(string);
			return result;
		}
		
		public static function parseBoolean(value:String):Boolean
		{
			return value==String(true);
		}
		
		public static function parseToChessTypes(value:String,defaultTypes:String):String
		{
			return (General.isEmptyString(value))?defaultTypes:value;
		}
		
		public static function parseToChessTypes2(value:String,defaultTypes:Vector.<ChessType>):String
		{
			return (General.isEmptyString(value))?ChessType.getStringFromTypes2(defaultTypes):value;
		}
		
		public static function parseTypesToString(types:String,defaultTypes:String=""):String
		{
			if(General.isEmptyString(types)) return defaultTypes;
			return types;
		}
		
		public static function parseTypesToString2(types:String,defaultTypes:Vector.<ChessType>=null):String
		{
			return parseTypesToString(types,ChessType.getStringFromTypes2(defaultTypes));
		}
		
		//============Instance Variables============//
		//Game Global
		public var enableDetectWin:Boolean=d_enableDetectWin;
		public var swapableType:String=d_swapableType;
		
		//Chess Move
		public var maxActionDoingPerTrun:uint=d_maxActionDoingPerTrun;
		public var maxActionDoingPerChess:uint=d_maxActionDoingPerChess;
		public var moveChessAfterEat:Boolean=d_moveChessAfterEat;
		
		//Chess Ability
		public var chessMaxLevel:uint=d_chessMaxLevel;
		
		//Chess Ability
		public var spawnerCanSpawnType:String=d_spawnerCanSpawnType;
		public var spawnerSpawnLife:uint=d_spawnerSpawnLife;
		public var spawnerSpawnLifeUsingPerMove:int=d_spawnerSpawnLifeUsingPerMove;
		public var spawnerSpawnLifeUsingPerTrun:int=d_spawnerSpawnLifeUsingPerTrun;
		
		//Bonus
		public var enableSpawnBonus:Boolean=d_enableSpawnBonus;
		public var canSpawnBonusType:String=d_canSpawnBonusType;
		public var bonusSpawnChance:Number=d_bonusSpawnChance;
		public var bonusChessGroupSpawnChance:Number=d_bonusChessGroupSpawnChance;
		public var maxBonusChessCountAtOnce:uint=d_maxBonusChessCountAtOnce;
		public var bonusSpawnChanceModifierLess:uint=d_bonusSpawnChanceModifierLess;
		public var bonusSpawnChanceModifierChance:Number=d_bonusSpawnChanceModifierChance;
		public var bonusImportmentChance:Number=d_bonusImportmentChance;
		public var bonusSpawnLimitCount:uint=d_bonusSpawnLimitCount;
		public var bonusSpawnLifeLeast:uint=d_bonusSpawnLifeLeast;
		public var bonusSpawnLifeMost:uint=d_bonusSpawnLifeMost;
		public var bonusSpawnLifeUsePerMove:uint=d_bonusSpawnLifeUsePerMove;
		public var bonusSpawnLifeUsePerTrun:uint=d_bonusSpawnLifeUsePerTrun;
		
		//============Constructor Function============//
		public function ChessRule():void
		{
			
		}
		
		//============Instance Getter And Setter============//
		public function get spawnableBonusTypes():Vector.<ChessType>
		{
			if(this.canSpawnBonusType==null||this.canSpawnBonusType=="")
			{
				return ChessType.ENABLE_TYPES;
			}
			return ChessType.getTypesByString(this.canSpawnBonusType);
		}
		
		public function get spawnerSpawnableTypes():Vector.<ChessType>
		{
			if(this.spawnerCanSpawnType==null||this.spawnerCanSpawnType=="")
			{
				return ChessType.SPAWNER_SPAWNABLE_TYPES;
			}
			return ChessType.getTypesByString(this.spawnerCanSpawnType);
		}
		
		public function get swapableChessTypes():Vector.<ChessType>
		{
			if(this.swapableType==null||this.swapableType=="")
			{
				return ChessType.SWAPABLE_TYPES;
			}
			return ChessType.getTypesByString(this.swapableType);
		}
		
		//============Instance Functions============//
		public function loadByMode(mode:ChessGameMode):void
		{
			if(mode==null) return;
			this.enableSpawnBonus=mode.enableBonusChess;
			this.canSpawnBonusType=parseToChessTypes2(mode.canSpawnBonusType,ChessType.ENABLE_TYPES);
			this.bonusSpawnChance=mode.bonusSpawnChance;
			this.bonusChessGroupSpawnChance=mode.bonusChessGroupSpawnChance;
			this.maxBonusChessCountAtOnce=mode.maxBonusChessCountAtOnce;
			this.spawnerCanSpawnType=parseToChessTypes2(mode.spawnerCanSpawnType,ChessType.SPAWNER_SPAWNABLE_TYPES);
			this.bonusImportmentChance=mode.bonusImportmentChance;
			this.bonusSpawnLimitCount=mode.bonusSpawnLimitCount;
		}
		
		public function getFinalBonusSpawnChance(chessCount:uint):Number
		{
			var tempPercent:Number;
			if(bonusSpawnChanceModifierLess!=0)
			{
				tempPercent=Math.max(this.bonusSpawnChanceModifierLess-chessCount,0)/this.bonusSpawnChanceModifierLess;
			}
			else
			{
				tempPercent=0;
			}
			return this.bonusSpawnChance*(1-tempPercent)+this.bonusSpawnChanceModifierChance*tempPercent;
		}
		
		//Use For API
		public function toString():String
		{
			var result:String="";
			//Loadin
			result+="bonusChessGroupSpawnChance="+this.bonusChessGroupSpawnChance+STRING_DELIM;
			result+="bonusSpawnChance="+this.bonusSpawnChance+STRING_DELIM;
			result+="bonusImportmentChance="+this.bonusImportmentChance+STRING_DELIM;
			result+="bonusSpawnChanceModifierChance="+this.bonusSpawnChanceModifierChance+STRING_DELIM;
			result+="bonusSpawnChanceModifierLess="+this.bonusSpawnChanceModifierLess+STRING_DELIM;
			result+="bonusSpawnLifeLeast="+this.bonusSpawnLifeLeast+STRING_DELIM;
			result+="bonusSpawnLifeMost="+this.bonusSpawnLifeMost+STRING_DELIM;
			result+="bonusSpawnLifeUsePerMove="+this.bonusSpawnLifeUsePerMove+STRING_DELIM;
			result+="bonusSpawnLifeUsePerTrun="+this.bonusSpawnLifeUsePerTrun+STRING_DELIM;
			result+="bonusSpawnLimitCount="+this.bonusSpawnLimitCount+STRING_DELIM;
			result+="canSpawnBonusType="+parseTypesToString2(this.canSpawnBonusType,ChessType.ENABLE_TYPES)+STRING_DELIM;
			result+="chessMaxLevel="+this.chessMaxLevel+STRING_DELIM;
			result+="enableDetectWin="+this.enableDetectWin+STRING_DELIM;
			result+="enableSpawnBonus="+this.enableSpawnBonus+STRING_DELIM;
			result+="maxBonusChessCountAtOnce="+this.maxBonusChessCountAtOnce+STRING_DELIM;
			result+="moveChessAfterEat="+this.moveChessAfterEat+STRING_DELIM;
			result+="maxActionDoingPerChess="+this.maxActionDoingPerChess+STRING_DELIM;
			result+="maxActionDoingPerTrun="+this.maxActionDoingPerTrun+STRING_DELIM;
			result+="spawnerCanSpawnType="+parseTypesToString2(this.spawnerCanSpawnType,ChessType.SPAWNER_SPAWNABLE_TYPES)+STRING_DELIM;
			result+="spawnerSpawnLife="+this.spawnerSpawnLife+STRING_DELIM;
			result+="spawnerSpawnLifeUsingPerMove="+this.spawnerSpawnLifeUsingPerMove+STRING_DELIM;
			result+="spawnerSpawnLifeUsingPerTrun="+this.spawnerSpawnLifeUsingPerTrun+STRING_DELIM;
			result+="swapableType="+parseTypesToString2(this.swapableType,ChessType.SWAPABLE_TYPES);
			//Return
			return result;
		}
		
		public function loadByString(string:String):ChessRule
		{
			//Temp Variables
			var key:String;
			var value:String;
			var keyValueArr:Array;
			//Detect String
			if(string==null) return null;
			else if(string=="") return this;
			//Start Loading
			var valueArr:Array=string.split(STRING_DELIM);
			for each(var keyValueString:String in valueArr)
			{
				keyValueArr=keyValueString.split("=");
				key=keyValueArr[0];
				value=keyValueArr[1];
				switch(key)
				{
					case "bonusChessGroupSpawnChance":
						this.bonusChessGroupSpawnChance=parseInt(value);
						break;
					case "bonusImportmentChance":
						this.bonusImportmentChance=parseFloat(value);
						break;
					case "bonusSpawnChance":
						this.bonusSpawnChance=parseFloat(value);
						break;
					case "bonusSpawnChanceModifierChance":
						this.bonusSpawnChanceModifierChance=parseFloat(value);
						break;
					case "bonusSpawnChanceModifierLess":
						this.bonusSpawnChanceModifierLess=parseInt(value);
						break;
					case "bonusSpawnLifeLeast":
						this.bonusSpawnLifeLeast=parseInt(value);
						break;
					case "bonusSpawnLifeMost":
						this.bonusSpawnLifeMost=parseInt(value);
						break;
					case "bonusSpawnLifeUsePerMove":
						this.bonusSpawnLifeUsePerMove=parseInt(value);
						break;
					case "bonusSpawnLifeUsePerTrun":
						this.bonusSpawnLifeUsePerTrun=parseInt(value);
						break;
					case "bonusSpawnLimitCount":
						this.bonusSpawnLimitCount=parseInt(value);
						break;
					case "canSpawnBonusType":
						this.canSpawnBonusType=parseToChessTypes2(value,ChessType.ENABLE_TYPES);
						break;
					case "chessMaxLevel":
						this.chessMaxLevel=parseInt(value);
						break;
					case "enableDetectWin":
						this.enableDetectWin=parseBoolean(value);
						break;
					case "enableSpawnBonus":
						this.enableSpawnBonus=parseBoolean(value);
						break;
					case "maxBonusChessCountAtOnce":
						this.maxBonusChessCountAtOnce=parseInt(value);
						break;
					case "moveChessAfterEat":
						this.moveChessAfterEat=parseBoolean(value);
						break;
					case "maxActionDoingPerChess":
					case "moveStepPerChess":
						this.maxActionDoingPerChess=parseInt(value);
						break;
					case "maxActionDoingPerTrun":
					case "moveChessCountPerTrun":
						this.maxActionDoingPerTrun=parseInt(value);
						break;
					case "spawnerCanSpawnType":
						this.spawnerCanSpawnType=parseToChessTypes2(value,ChessType.SPAWNER_SPAWNABLE_TYPES);
						break;
					case "spawnerSpawnLife":
						this.spawnerSpawnLife=parseInt(value);
						break;
					case "spawnerSpawnLifeUsingPerMove":
						this.spawnerSpawnLifeUsingPerMove=parseInt(value);
						break;
					case "spawnerSpawnLifeUsingPerTrun":
						this.spawnerSpawnLifeUsingPerTrun=parseInt(value);
						break;
					case "swapableType":
						this.swapableType=parseToChessTypes2(value,ChessType.SWAPABLE_TYPES);
						break;
				}
			}
			return this;
		}
		
		public function reset():void
		{
			var rule:ChessRule=new ChessRule();
			this.loadByString(rule.toString());
		}
	}
}