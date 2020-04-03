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
	
	public class ChessAI_Hunter extends ChessAI_Common implements IChessAI
	{
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function ChessAI_Hunter(owner:ChessPlayer=null):void
		{
			super(owner);
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function get name():String
		{
			return "AI-Hunter";
		}
		
		public override function get thinkTime():uint
		{
			return 28;
		}
		
		//============Instance Functions============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function getOutput():Vector.<Point> 
		{
			//Set Variables
			var result:Vector.<Point>=new Vector.<Point>;
			var willBeEatPoints:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			var willBeEatChesses:Vector.<Chess>=new Vector.<Chess>;
			var willContolChess:Chess,willMovePlaces:Vector.<ChessWayPoint>,willMoveTo:ChessWayPoint;
			var otherChess:Chess,tempChess:Chess,wayPoint:ChessWayPoint,tempWayPoint:ChessWayPoint;
			var clickOnce:Boolean=false,isWillBeEat:Boolean;
			var moveableChesses:Vector.<Chess>=this._owner.controllableSelfChesses;
			var avarageX:Number,avarageY:Number,selfChessCount:uint;
			var oldDistance:Number,newDistance:Number;
			//Try to swap
			var swapableChess:Chess=this.owner.randomSwapableChess;
			if(swapableChess!=null)
			{
				result.push(swapableChess.boardPoint);
				return result;
			}
			//Detect
			if(!this._owner.canMoveChess) return null;
			//Get
			for each(otherChess in this.board.allChesses)
			{
				if(!otherChess.hasOwner)
				{
					if(otherChess.type==ChessType.NULL)
					{
						willContolChess=otherChess;
						clickOnce=true;
					}
					continue;
				}
				else if(otherChess.owner==this._owner)
				{
					avarageX+=otherChess.boardX;
					avarageY+=otherChess.boardY;
					selfChessCount++;
					if(otherChess.type==ChessType.NULL||otherChess.type==ChessType.Ra)
					{
						willContolChess=otherChess;
						clickOnce=true;
					}
					continue;
				}
				else
				{
					for each(wayPoint in otherChess.getMovePlaces())
					{
						if(wayPoint.isHarmful)
						{
							willBeEatPoints.push(wayPoint);
							if(!this.board.hasChessAt(wayPoint.x,wayPoint.y)) continue;
							tempChess=this.board.getChessAt(wayPoint.x,wayPoint.y);
							if(tempChess.canBeContol&&tempChess.owner==this._owner)
							{
								willBeEatChesses.push(tempChess);
							}
						}
					}
				}
			}
			//Operation
			avarageX/=selfChessCount;
			avarageY/=selfChessCount;
			//Select chess
			if(willContolChess==null)
			{
				//If not has willContolChess yet
				if(willContolChess==null)
				{
					willContolChess=this._owner.randomControllableSelfChess;
				}
				//If any chess will be eat
				if(willBeEatChesses.length>0)
				{
					for each(tempChess in willBeEatChesses)
					{
						if(this._owner.importmentChessCount>0&&willContolChess.importment&&!tempChess.importment) continue;
						if(willContolChess.importment||
						   willContolChess.scoreWeight<tempChess.scoreWeight)
						{
							willContolChess=tempChess;
						}
					}
				}
				else
				{
					for each(tempChess in this._owner.controllableSelfChesses)
					{
						if(willContolChess.harmfulWayPointCount<tempChess.harmfulWayPointCount)
						{
							willContolChess=tempChess;
						}
					}
				}
			}
			//Add Will Contol Chess
			result.push(willContolChess.boardPoint);
			//Will Move Point
			if(!clickOnce)
			{
				willMovePlaces=willContolChess.getMovePlaces();
				willMoveTo=willMovePlaces[acMath.random(willMovePlaces.length)];
				for each(wayPoint in willMovePlaces)
				{
					if(wayPoint==null) continue;
					for each(tempWayPoint in willBeEatPoints)
					{
						if(wayPoint.equals(tempWayPoint))
						{
							isWillBeEat=true;
						}
					}
					if(isWillBeEat) continue;
					if(wayPoint.isHarmful&&this.board.hasChessAt(wayPoint.x,wayPoint.y))
					{
						willMoveTo=wayPoint;
					}
				}
				//Add Will Move Point
				if(willMoveTo==null)
				{
					willMoveTo=willMovePlaces[acMath.random(willMovePlaces.length)];
					for each(wayPoint in willMovePlaces)
					{
						for each(tempWayPoint in willBeEatPoints)
						{
							if(wayPoint.equals(tempWayPoint))
							{
								isWillBeEat=true;
							}
						}
						if(isWillBeEat) continue;
						oldDistance=acMath.getDistance(willMoveTo.x,willMoveTo.y,avarageX,avarageY);
						newDistance=acMath.getDistance(wayPoint.x,wayPoint.y,avarageX,avarageY);
						if(newDistance>oldDistance)
						{
							willMoveTo=wayPoint;
						}
					}
				}
				result.push(willMoveTo.point);
			}
			//Return
			return result;
		}
	}
}