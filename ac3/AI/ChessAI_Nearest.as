package ac3.AI 
{
	//AF Chess 3.0
	import ac3.Chess.movement.ChessWayPoint;
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.movement.*;
	import ac3.Game.*;
	import ac3.AI.*;
	
	//Flash
	import flash.geom.Point;
	
	public class ChessAI_Nearest extends ChessAI_Common implements IChessAI 
	{
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function ChessAI_Nearest(owner:ChessPlayer=null):void
		{
			super(owner);
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function get name():String
		{
			return "AI-Nearest";
		}
		
		//============Instance Functions============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function getOutput():Vector.<Point> 
		{
			//Set Variables
			var result:Vector.<Point>=new Vector.<Point>;
			var otherChesses:Vector.<Chess>=this.host.getChessesByOwner(this._owner,true);
			var nearestChess:Chess;
			var willMovePoint:ChessWayPoint;
			var oldDistance:Number;
			//Detect
			if(!this._owner.canMoveChess) return null;
			//Get
			var willContolChess:Chess;
			var swapableChess:Chess=this.owner.randomSwapableChess;
			if(swapableChess!=null)
			{
				result.push(swapableChess.boardPoint);
				return result;
			}
			else
			{
				willContolChess=this._owner.randomControllableSelfChess;
			}
			if(willContolChess==null||otherChesses.length<=0) return null;
			result.push(willContolChess.boardPoint);
			//Way
			for each(var otherChess:Chess in otherChesses)
			{
				oldDistance=nearestChess==null?Infinity:acMath.getDistance(nearestChess.boardX,nearestChess.boardY,willContolChess.boardX,willContolChess.boardY);
				if(nearestChess==null||oldDistance>acMath.getDistance(otherChess.boardX,otherChess.boardY,willContolChess.boardX,willContolChess.boardY))
				{
					nearestChess=otherChess;
				}
			}
			willMovePoint=willContolChess.getRandomMovePlace();//new ChessWayPoint(nearestChess.boardX,nearestChess.boardY,null);
			//Operation
			for each(var wayPoint:ChessWayPoint in willContolChess.getMovePlaces())
			{
				oldDistance=acMath.getDistance(willMovePoint.x,willMovePoint.y,nearestChess.boardX,nearestChess.boardY);
				if(oldDistance>acMath.getDistance(wayPoint.x,wayPoint.y,nearestChess.boardX,nearestChess.boardY))
				{
					willMovePoint=wayPoint;
				}
			}
			//Will Move To
			result.push(willMovePoint.point);
			//Return
			return result;
		}
	}
}