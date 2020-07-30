package ac3.Chess.movement 
{
	/**
	 * ...
	 * @author ARCJ137442
	 */
	public class WayPointGeneraterStraight extends ChessWayPointGenerater 
	{
		
		public function get startPoint():ChessWayPoint 
		{
			return _startPoint;
		}
	
		protected var _startPoint:ChessWayPoint;
		
		public function get blockAtOnceChess():Boolean 
		{
			return _blockAtOnceChess;
		}
		
		protected var _blockAtOnceChess:Boolean
		
		public function get stepX():int 
		{
			return _stepX;
		}
		
		protected var _stepX:int=0;
		
		public function get stepY():int 
		{
			return _stepY;
		}
		
		protected var _stepY:int=0;
		
		public function WayPointGeneraterStraight(generateType:ChessWayPointGenerateType,
												firstArgumentPoint:ChessWayPoint,
												stepX:int,stepY:int,
												blockAtOnceChess:Boolean=true):void
		{
			super(generateType, firstArgumentPoint);
			this._startPoint=firstArgumentPoint;
			this._stepX=stepX;
			this._stepY=stepY;
			this._blockAtOnceChess=blockAtOnceChess;
		}
	}
}