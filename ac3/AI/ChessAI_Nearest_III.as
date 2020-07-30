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
	
	public class ChessAI_Nearest_III extends ChessAI_Nearest_II implements IChessAI 
	{
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function ChessAI_Nearest_III(owner:ChessPlayer=null):void
		{
			super(owner);
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function get name():String
		{
			return "AI-Nearest III";
		}
		
		public override function get thinkTime():uint
		{
			return 16;
		}
		
		//============Instance Functions============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function getOutput():Vector.<Point> 
		{
			//Set Variables
			var result:Vector.<Point>=new Vector.<Point>;
			var selfChesses:Vector.<Chess>=this._owner.controllableSelfChesses;
			var otherChesses:Vector.<Chess>=this.host.getChessesByOwner(this._owner,true);
			var tempChess1:Chess,tempChess2:Chess;
			var willContolChess:Chess;
			var nearestChess:Chess;
			var willMovePoint:ChessWayPoint;
			var oldDistance:Number,nowDistance:Number;
			var wayPoint:ChessWayPoint;
			//Get
			var swapableChess:Chess=this.owner.randomSwapableChess;
			if(swapableChess!=null)
			{
				result.push(swapableChess.boardPoint);
				return result;
			}
			//Detect
			else if(!this._owner.canMoveChess) return null;
			else
			{
				oldDistance=Infinity;
				for each(tempChess1 in selfChesses)
				{
					for each(wayPoint in tempChess1.getMovePlaces())
					{
						for each(tempChess2 in otherChesses)
						{
							nowDistance=tempChess2.distanceOfWayPoint(wayPoint);
							if(tempChess2.owner==null&&nowDistance>0) continue;
							if(oldDistance>nowDistance||
							   oldDistance==nowDistance&&General.randomBoolean())
							{
								oldDistance=nowDistance;
								willContolChess=tempChess1;
								nearestChess=tempChess2;
								willMovePoint=wayPoint;
							}
						}
					}
				}
			}
			if(willContolChess==null||nearestChess==null) return null;
			result.push(willContolChess.boardPoint);
			//WayPoint
			if(willMovePoint==null)
			{
				willMovePoint=willContolChess.getRandomMovePlace();
				for each(wayPoint in willContolChess.getMovePlaces())
				{
					oldDistance=nearestChess.distanceOfWayPoint(willMovePoint);
					if(oldDistance>nearestChess.distanceOfWayPoint(wayPoint))
					{
						willMovePoint=wayPoint;
					}
				}
			}
			//Check
			if(willMovePoint==null) return null;
			//Will Move To
			result.push(willMovePoint.point);
			//Return
			return result;
		}
	}
}