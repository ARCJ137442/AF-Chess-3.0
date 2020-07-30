package ac3.Chess.movement 
{
	//AF Chess
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.movement.*;
	
	//Flash
	import flash.geom.Point;
	
	//Class MoveWayPoint
	public class ChessWayPoint
	{
		//============Instance Variables============//
		public var x:int,y:int;
		public var type:ChessWayPointType;
		public var moveSpecialAbility:ChessWayPointType;
		public var condition:ChessMoveCondition;
		public var condition_not:ChessMoveCondition;
		
		//============Constructor Function============//
		public function ChessWayPoint(x:int,y:int,type:ChessWayPointType,
									  specialEvent:ChessWayPointType=null,
									  condition:ChessMoveCondition=null,
									  condition_not:ChessMoveCondition=null):void
		{
			this.x=x;
			this.y=y;
			this.type=type;
			this.moveSpecialAbility=specialEvent==null?ChessWayPointType.NULL:specialEvent;
			this.condition=condition;
			this.condition_not=condition_not;
		}
		
		//============Instance Getter And Setter============//
		public function get point():Point
		{
			return new Point(this.x,this.y);
		}
		
		public function get isHarmful():Boolean
		{
			switch(this.type)
			{
				case ChessWayPointType.ATTACK:
				case ChessWayPointType.MOVE_AND_ATTACK:
				case ChessWayPointType.THROUGH:
				case ChessWayPointType.SPECIAL_DESTROY:
				case ChessWayPointType.SPECIAL_INFLUENCE:
				case ChessWayPointType.SPECIAL_MIND_CONTOL:
				case ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL:
					return true;
			}
			return false;
		}
		
		public function get canCaptureChess():Boolean
		{
			switch(this.type)
			{
				case ChessWayPointType.ATTACK:
				case ChessWayPointType.MOVE_AND_ATTACK:
				case ChessWayPointType.THROUGH:
				case ChessWayPointType.SPECIAL_DESTROY:
				case ChessWayPointType.SPECIAL_INFLUENCE:
				case ChessWayPointType.SPECIAL_MIND_CONTOL:
				case ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL:
					return true;
			}
			return false;
		}
		
		//============Instance Functions============//
		public function equals(point:ChessWayPoint,checkPos:Boolean=true,checkInformations:Boolean=false,checkConditions:Boolean=false):Boolean
		{
			if(checkPos)
			{
				if(this.x!=point.x||this.y!=point.y) return false;
			}
			if(checkInformations)
			{
				if(this.type!=point.type||this.moveSpecialAbility!=point.moveSpecialAbility) return false;
			}
			if(checkConditions)
			{
				if(this.condition!=point.condition||this.condition_not!=point.condition_not) return false;
			}
			return true;
		}
		
		public function toString():String
		{
			return new Point(this.x,this.y).toString();
		}
		
		public function distanceOf(x:Number,y:Number):Number
		{
			return acMath.getDistance(this.x,this.y,x,y);
		}
		
		public function distanceOfPoint(point:Point):Number
		{
			return distanceOf(point.x,point.y);
		}
		
		public function distanceOfWayPoint(wayPoint:ChessWayPoint):Number
		{
			return distanceOf(wayPoint.x,wayPoint.y);
		}
		
		public function getCopy():ChessWayPoint
		{
			return new ChessWayPoint(this.x,this.y,this.type,this.moveSpecialAbility,this.condition,this.condition_not);
		}
		
		public function getCopyAndMargePosition(newX:int,newY:int):ChessWayPoint
		{
			return new ChessWayPoint(newX,newY,this.type,this.moveSpecialAbility,this.condition,this.condition_not);
		}
		
		public function margePosition(newX:int,newY:int):void
		{
			this.x=newX;this.y=newY;
		}
		
		public function chessToBoard(chess:Chess):ChessWayPoint
		{
			return new ChessWayPoint(this.x+chess.boardX,this.y+chess.boardY,this.type,this.moveSpecialAbility,this.condition,this.condition_not);
		}
		
		public function boardToChess(chess:Chess):ChessWayPoint
		{
			return new ChessWayPoint(this.x-chess.boardX,this.y-chess.boardY,this.type,this.moveSpecialAbility,this.condition,this.condition_not);
		}
		
		public function removeSpecial():ChessWayPoint
		{
			this.moveSpecialAbility=null
			return this;
		}
	}
}