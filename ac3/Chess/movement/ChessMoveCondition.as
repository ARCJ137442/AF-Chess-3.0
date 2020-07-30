package ac3.Chess.movement 
{
	public class ChessMoveCondition 
	{
		//============Static Variables============//
		public static const NULL:ChessMoveCondition=null;
		public static const FULL:ChessMoveCondition=new ChessMoveCondition("full");
		
		public static const HAS_CHESS:ChessMoveCondition=new ChessMoveCondition("has_chess");
		public static const HAS_ALLY_CHESS:ChessMoveCondition=new ChessMoveCondition("has_self_chess");
		public static const HAS_OTHER_CHESS:ChessMoveCondition=new ChessMoveCondition("has_other_chess");
		public static const HAS_ENEMY_CHESS:ChessMoveCondition=new ChessMoveCondition("has_enemy_chess");
		public static const HAS_NON_ENEMY_CHESS:ChessMoveCondition=new ChessMoveCondition("has_not_enemy_chess");
		public static const HAS_BLACK_CHESS:ChessMoveCondition=new ChessMoveCondition("has_black_chess");
		public static const HAS_SAME_TYPE_CHESS:ChessMoveCondition=new ChessMoveCondition("has_same_type_chess");
		
		public static const SELF_LEVEL_GRANDER_THAN_ZERO:ChessMoveCondition=new ChessMoveCondition("self_level_grander_than_zero");
		public static const SELF_LEVEL_EQUALS_ZERO:ChessMoveCondition=new ChessMoveCondition("self_level_equals_zero");
		public static const SELF_NO_ACTION_DID:ChessMoveCondition=new ChessMoveCondition("self_no_action_did");
		
		public static const ALL_TYPES:Vector.<ChessMoveCondition>=new <ChessMoveCondition>[HAS_CHESS,HAS_BLACK_CHESS];
		
		//============Static Functions============//
		public static function isAllowType(type:ChessMoveCondition)
		{
			return ALL_TYPES.indexOf(type)>=0
		}
		
		public static function isPositionRequiredCondition(condition:ChessMoveCondition):Boolean
		{
			switch(condition)
			{
				case HAS_CHESS:
				case HAS_BLACK_CHESS:
				case HAS_ALLY_CHESS:
				case HAS_ENEMY_CHESS:
				case HAS_NON_ENEMY_CHESS:
				case HAS_OTHER_CHESS:
					return true;
				default:return false;
			}
		}
		
		public static function isChessSelfRequiredCondition(condition:ChessMoveCondition):Boolean
		{
			switch(condition)
			{
				case HAS_ALLY_CHESS:
				case HAS_ENEMY_CHESS:
				case HAS_OTHER_CHESS:
				case HAS_NON_ENEMY_CHESS:
				case SELF_LEVEL_EQUALS_ZERO:
				case SELF_LEVEL_GRANDER_THAN_ZERO:
				case SELF_NO_ACTION_DID:
					return true;
				default:return false;
			}
		}
		
		//============Instance Variables============//
		protected var _name:String;
		
		//============Constructor Function============//
		public function ChessMoveCondition(name:String):void
		{
			this._name=name;
		}
		
		//============Instance Getter And Setter============//
		public function get name():String
		{
			return this._name;
		}
		
		public function get positionRequired():Boolean
		{
			return ChessMoveCondition.isPositionRequiredCondition(this);
		}
		
		public function get chessSelfRequired():Boolean
		{
			return ChessMoveCondition.isChessSelfRequiredCondition(this);
		}
	}
}