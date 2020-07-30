package ac3.Chess.movement 
{
	public class ChessWayPointGenerateType
	{
		//============Static Variables============//
		public static const ALL_OF_BOARD:ChessWayPointGenerateType=new ChessWayPointGenerateType("ALL_OF_BOARD");
		public static const ALL_OVER_CHESS:ChessWayPointGenerateType=new ChessWayPointGenerateType("ALL_OVER_CHESS");
		public static const STRAIGHT_LINE_MOVE:ChessWayPointGenerateType=new ChessWayPointGenerateType("STRAIGHT_LINE_MOVE");
		public static const STRAIGHT_LINE_ATTACK:ChessWayPointGenerateType=new ChessWayPointGenerateType("STRAIGHT_LINE_ATTACK");
		public static const STRAIGHT_CANNON_MOVE:ChessWayPointGenerateType=new ChessWayPointGenerateType("STRAIGHT_CANNON_MOVE");
		public static const STRAIGHT_CANNON_ATTACK:ChessWayPointGenerateType=new ChessWayPointGenerateType("STRAIGHT_CANNON_ATTACK");
		public static const OBLIQUE_LINE_MOVE:ChessWayPointGenerateType=new ChessWayPointGenerateType("OBLIQUE_LINE_MOVE");
		public static const OBLIQUE_LINE_ATTACK:ChessWayPointGenerateType=new ChessWayPointGenerateType("OBLIQUE_LINE_ATTACK");
		public static const OBLIQUE_CANNON_MOVE:ChessWayPointGenerateType=new ChessWayPointGenerateType("OBLIQUE_CANNON_MOVE");
		public static const OBLIQUE_CANNON_ATTACK:ChessWayPointGenerateType=new ChessWayPointGenerateType("OBLIQUE_CANNON_ATTACK");
		public static const STRAIGHT_THROUGH:ChessWayPointGenerateType=new ChessWayPointGenerateType("STRAIGHT_THROUGH");
		public static const OBLIQUE_THROUGH:ChessWayPointGenerateType=new ChessWayPointGenerateType("OBLIQUE_THROUGH");
		public static const COPY_NEARBY_CHESS_WAYS:ChessWayPointGenerateType=new ChessWayPointGenerateType("COPY_NEARBY_CHESS_WAYS");
		public static const COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL:ChessWayPointGenerateType=new ChessWayPointGenerateType("COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL");
		public static const COPY_ALL_CHESS_WAYS:ChessWayPointGenerateType=new ChessWayPointGenerateType("COPY_ALL_CHESS_WAYS");
		public static const CHAIN_JUMP:ChessWayPointGenerateType=new ChessWayPointGenerateType("CHAIN_JUMP");
		public static const SYMMETY_POINT:ChessWayPointGenerateType=new ChessWayPointGenerateType("SYMMETY_POINT");
		
		//============Static Functions============//
		//======Tool Functions======//
		public static function isStraightSpecialType(type:ChessWayPointGenerateType):Boolean
		{
			switch(type)
			{
				case STRAIGHT_LINE_MOVE:
				case STRAIGHT_LINE_ATTACK:
				case STRAIGHT_CANNON_MOVE:
				case STRAIGHT_CANNON_ATTACK:
				case STRAIGHT_THROUGH:
					return true;
			}
			return false;
		}
		
		public static function isObliqueSpecialType(type:ChessWayPointGenerateType):Boolean
		{
			switch(type)
			{
				case OBLIQUE_LINE_MOVE:
				case OBLIQUE_LINE_ATTACK:
				case OBLIQUE_CANNON_MOVE:
				case OBLIQUE_CANNON_ATTACK:
				case OBLIQUE_THROUGH:
					return true;
			}
			return false;
		}
		
		public static function isLineSpecialType(type:ChessWayPointGenerateType):Boolean
		{
			switch(type)
			{
				case STRAIGHT_LINE_MOVE:
				case STRAIGHT_LINE_ATTACK:
				case OBLIQUE_LINE_MOVE:
				case OBLIQUE_LINE_ATTACK:
					return true;
			}
			return false;
		}
		
		public static function isCannonSpecialType(type:ChessWayPointGenerateType):Boolean
		{
			switch(type)
			{
				case STRAIGHT_CANNON_MOVE:
				case STRAIGHT_CANNON_ATTACK:
				case OBLIQUE_CANNON_MOVE:
				case OBLIQUE_CANNON_ATTACK:
					return true;
			}
			return false;
		}
		
		public static function isThroughSpecialType(type:ChessWayPointGenerateType):Boolean
		{
			switch(type)
			{
				case STRAIGHT_THROUGH:
				case OBLIQUE_THROUGH:
					return true;
			}
			return false;
		}
		
		public static function isLinedAttackSpecialType(type:ChessWayPointGenerateType):Boolean
		{
			switch(type)
			{
				case STRAIGHT_LINE_ATTACK:
				case OBLIQUE_LINE_ATTACK:
				case STRAIGHT_CANNON_ATTACK:
				case OBLIQUE_CANNON_ATTACK:
					return true;
			}
			return false;
		}
		
		public static function isLinedSpecialType(type:ChessWayPointGenerateType):Boolean
		{
			switch(type)
			{
				case STRAIGHT_LINE_MOVE:
				case STRAIGHT_LINE_ATTACK:
				case STRAIGHT_CANNON_MOVE:
				case STRAIGHT_CANNON_ATTACK:
				case OBLIQUE_LINE_MOVE:
				case OBLIQUE_LINE_ATTACK:
				case OBLIQUE_CANNON_MOVE:
				case OBLIQUE_CANNON_ATTACK:
				case STRAIGHT_THROUGH:
				case OBLIQUE_THROUGH:
					return true;
			}
			return false;
		}
		
		//============Instance Variables============//
		protected var _name:String;
		
		//============Constructor Function============//
		public function ChessWayPointGenerateType(name:String):void
		{
			this._name=name;
		}
		
		//============Instance Getter And Setter============//
		public function get name():String
		{
			return this._name;
		}
	}
}