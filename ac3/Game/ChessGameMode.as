package ac3.Game 
{
	//AF Chess 3.0
	import ac3.Common.*;
	import ac3.Chess.*;
	
	public class ChessGameMode 
	{
		//============Static Variables============//
		public static const ELDER:ChessGameMode=new ChessGameMode("Elder");
		public static const DEBUG:ChessGameMode=new ChessGameMode("Debug",false);
		public static const CLASSIC:ChessGameMode=new ChessGameMode("Classic",false,null,1/64);
		public static const SQUARES:ChessGameMode=new ChessGameMode("Squares",true,"S");
		public static const STRAIGHT:ChessGameMode=new ChessGameMode("Straight",false,"S");
		public static const BONUS_STORM:ChessGameMode=new ChessGameMode("BonusStorm",true,"null/Ra",1/24,1/32,8);
		public static const X_STORM:ChessGameMode=new ChessGameMode("XStorm",false);
		public static const EPISODE:ChessGameMode=new ChessGameMode("Episode",true,null,1/64);
		public static const SWAP:ChessGameMode=new ChessGameMode("Swap",true,"null",1/16,0,1);
		public static const MAGIC:ChessGameMode=new ChessGameMode("Magic",true,null,1/64);
		public static const ADVANCE:ChessGameMode=new ChessGameMode("Advance",true,ChessType.getStringFromTypes2(ChessType.ADVANCE_BONUS_TYPES),1/32,1/8,4,null,0,32);
		public static const SURVIVAL:ChessGameMode=new ChessGameMode("Survival",true,"So",1,0,1,null,0,256);
		public static const COPYFROM:ChessGameMode=new ChessGameMode("CopyFrom",true,ChessType.getStringFromTypes2(ChessType.COPYFORM_COPYABLE_TYPES),1/64,0,1,null,0,7);
		public static const DECENTRALIZED:ChessGameMode=new ChessGameMode("Decentralized",true,null,1/64);
		public static const SURVANCE:ChessGameMode=new ChessGameMode("Survance",true,ChessType.So.name,1,0,1,null,0,256);
		public static const POWER:ChessGameMode=new ChessGameMode("Power",true,ChessType.Cw.name,1/40,1/16,4,null,0);
		public static const RANDOM_II:ChessGameMode=new ChessGameMode("RandomII");
		public static const INFLUENCE:ChessGameMode=new ChessGameMode("Influence",true,"V",1,0,0,null,0,1024);
		public static const RANDOM_III:ChessGameMode=new ChessGameMode("RandomIII");
		
		//Groups
		public static const allTypes:Vector.<ChessGameMode>=new <ChessGameMode>[
		ELDER,DEBUG,CLASSIC,SQUARES,BONUS_STORM,X_STORM,EPISODE,SWAP,MAGIC,ADVANCE,SURVIVAL,COPYFROM,DECENTRALIZED,SURVANCE,RANDOM_II,INFLUENCE,RANDOM_III];
		
		//Rules
		public static const d_enableSpawnBonus:Boolean=true;
		public static const d_canSpawnBonusType:String=null;
		public static const d_bonusSpawnChance:Number=1/32;
		public static const d_bonusChessGroupSpawnChance:Number=1/5;
		public static const d_maxBonusChessCountAtOnce:uint=4;
		public static const d_spawnerCanSpawnType:String=undefined;
		public static const d_bonusImportmentChance:Number=1/10;
		public static const d_bonusSpawnLimitCount:Number=64;
		
		//============Static Getter And Setter============//
		public static function get random():ChessGameMode
		{
			return allTypes[acMath.random(allTypes.length)];
		}
		
		//============Instance Variables============//
		protected var _name:String;
		
		protected var _enableBonusChess:Boolean;
		protected var _canSpawnBonusType:String;
		protected var _bonusSpawnChance:Number;
		protected var _bonusChessGroupSpawnChance:Number;
		protected var _maxBonusChessCountAtOnce:uint;
		protected var _spawnerCanSpawnType:String;
		protected var _bonusImportmentChance:Number;
		protected var _bonusSpawnLimitCount:uint;
		
		//============Constructor Function============//
		public function ChessGameMode(name:String,
									 enableBonusChess:Boolean=d_enableSpawnBonus,
									 canSpawnBonusType:String=d_canSpawnBonusType,
									 bonusSpawnChance:Number=d_bonusSpawnChance,
									 bonusChessGroupSpawnChance:Number=d_bonusChessGroupSpawnChance,
									 maxBonusChessCountAtOnce:uint=d_maxBonusChessCountAtOnce,
									 spawnerCanSpawnType:String=d_spawnerCanSpawnType,
									 bonusImportmentChance:Number=d_bonusImportmentChance,
									 bonusSpawnLimitCount:uint=d_bonusSpawnLimitCount):void
		{
			this._name=name;
			this._enableBonusChess=enableBonusChess;
			this._canSpawnBonusType=canSpawnBonusType;
			this._bonusSpawnChance=bonusSpawnChance;
			this._bonusChessGroupSpawnChance=bonusChessGroupSpawnChance;
			this._maxBonusChessCountAtOnce=maxBonusChessCountAtOnce;
			this._spawnerCanSpawnType=spawnerCanSpawnType;
			this._bonusImportmentChance=bonusImportmentChance;
			this._bonusSpawnLimitCount=bonusSpawnLimitCount;
		}
		
		//============Instance Getter And Setter============//
		public function get name():String
		{
			return this._name;
		}
		
		public function get enableBonusChess():Boolean
		{
			return this._enableBonusChess;
		}
		
		public function get canSpawnBonusType():String
		{
			return this._canSpawnBonusType;
		}
		
		public function get bonusSpawnChance():Number
		{
			return this._bonusSpawnChance;
		}
		
		public function get bonusChessGroupSpawnChance():Number
		{
			return this._bonusChessGroupSpawnChance;
		}
		
		public function get maxBonusChessCountAtOnce():uint
		{
			return this._maxBonusChessCountAtOnce;
		}
		
		public function get spawnerCanSpawnType():String
		{
			return this._spawnerCanSpawnType;
		}
		
		public function get bonusImportmentChance():Number
		{
			return this._bonusImportmentChance;
		}
		
		public function get bonusSpawnLimitCount():uint
		{
			return this._bonusSpawnLimitCount;
		}
	}
}