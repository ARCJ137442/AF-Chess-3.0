package ac3.Chess.Way 
{
	//Class MoveWayPointType
	public final class ChessWayPointType
	{
		//============Static Variables============//
		public static const NULL:ChessWayPointType=null;
		
		public static const MOVE:ChessWayPointType=new ChessWayPointType("move");
		public static const ATTACK:ChessWayPointType=new ChessWayPointType("attack");
		public static const MOVE_AND_ATTACK:ChessWayPointType=new ChessWayPointType("moveAndAttack");
		public static const SWAP:ChessWayPointType=new ChessWayPointType("swap");
		public static const CONDITION:ChessWayPointType=new ChessWayPointType("condition");
		public static const TELEPORT:ChessWayPointType=new ChessWayPointType("teleport");
		public static const ABSORPTION_LEVEL:ChessWayPointType=new ChessWayPointType("absorptionLevel");
		public static const TRANSFER_LEVEL:ChessWayPointType=new ChessWayPointType("transferLevel");
		public static const THROUGH:ChessWayPointType=new ChessWayPointType("moveThroughChesses");
		
		public static const SPECIAL_NULL:ChessWayPointType=null;
		public static const SPECIAL_INFLUENCE:ChessWayPointType=new ChessWayPointType("special_influence");
		public static const SPECIAL_MIND_CONTOL:ChessWayPointType=new ChessWayPointType("special_mindContol");
		public static const SPECIAL_MOVE_OTHER_CHESS:ChessWayPointType=new ChessWayPointType("special_moveOtherChess");
		public static const SPECIAL_SUMMON_LIFED_CHESS:ChessWayPointType=new ChessWayPointType("special_summonLifedChess");
		public static const SPECIAL_CREATE_MOVE_PLACES:ChessWayPointType=new ChessWayPointType("special_createMovePlaces");
		public static const SPECIAL_DESTROY:ChessWayPointType=new ChessWayPointType("special_destroy");
		public static const SPECIAL_CONVER_OWNER_TO_NULL:ChessWayPointType=new ChessWayPointType("special_converOwnerToNull");
		
		//============Instance Variables============//
		protected var _name:String;
		
		//============Constructor Function============//
		public function ChessWayPointType(name:String):void
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