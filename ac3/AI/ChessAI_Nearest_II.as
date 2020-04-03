package ac3.AI 
{
	//AF Chess 3.0
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.Way.*;
	import ac3.Game.*;
	import ac3.AI.*;
	
	//Flash
	import flash.geom.Point;
	
	public class ChessAI_Nearest_II extends ChessAI_Nearest implements IChessAI
	{
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function ChessAI_Nearest_II(owner:ChessPlayer=null):void
		{
			super(owner);
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function get name():String
		{
			return "AI-Nearest II";
		}
		
		public override function get thinkTime():uint
		{
			return 12;
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
			//Detect
			if(!this._owner.canMoveChess) return null;
			//Get
			var swapableChess:Chess=this.owner.randomSwapableChess;
			if(swapableChess!=null)
			{
				result.push(swapableChess.boardPoint);
				return result;
			}
			else
			{
				oldDistance=Infinity;
				for each(tempChess1 in selfChesses)
				{
					for each(tempChess2 in otherChesses)
					{
						nowDistance=tempChess1.distanceOfChess(tempChess2);
						if(oldDistance>nowDistance&&General.randomBoolean(4,1)||
						   oldDistance==nowDistance&&General.randomBoolean())
						{
							oldDistance=nowDistance;
							willContolChess=tempChess1;
							nearestChess=tempChess2;
						}
					}
				}
			}
			if(willContolChess==null||nearestChess==null) return null;
			result.push(willContolChess.boardPoint);
			//WayPoint
			willMovePoint=willContolChess.getRandomMovePlace();
			//Check
			if(willMovePoint==null) return null;
			//Operation
			oldDistance=nearestChess.distanceOfWayPoint(willMovePoint);
			for each(var wayPoint:ChessWayPoint in willContolChess.getMovePlaces())
			{
				nowDistance=nearestChess.distanceOfWayPoint(wayPoint);
				if(tempChess2.owner==null&&nowDistance>0) continue;
				if(oldDistance>nowDistance)
				{
					willMovePoint=wayPoint;
					oldDistance=nowDistance;
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