package ac3.Chess 
{
	//Class MoveWayPointType
	public final class ChessSelectPlaceType
	{
		//============Static Variables============//
		public static const DIAMOND:ChessSelectPlaceType=new ChessSelectPlaceType("diamond");
		public static const CIRCLE:ChessSelectPlaceType=new ChessSelectPlaceType("circle");
		public static const RING:ChessSelectPlaceType=new ChessSelectPlaceType("ring");
		public static const SQUARE:ChessSelectPlaceType=new ChessSelectPlaceType("square");
		public static const X:ChessSelectPlaceType=new ChessSelectPlaceType("x");
		public static const CROSS:ChessSelectPlaceType=new ChessSelectPlaceType("cross");
		public static const OUTLINE:ChessSelectPlaceType=new ChessSelectPlaceType("outline");
		
		//============Instance Variables============//
		protected var _name:String;
		
		//============Constructor Function============//
		public function ChessSelectPlaceType(name:String):void
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