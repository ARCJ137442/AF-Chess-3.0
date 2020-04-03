package ac3.AI 
{
	//AF Chess 3.0
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.Way.*;
	import ac3.Game.*;
	import ac3.AI.*;
	import ac3.AI.Functions.*;
	
	//Flash
	import flash.geom.Point;
	
	public class ChessAI_Hunter_II extends ChessAI_Hunter implements IChessAI
	{
		//============Static Functions============//
		//Tool Function
		public static function getMostValueWayInCalm(selfChesses:Vector.<Chess>,
													enemyChesses:Vector.<Chess>,
													captureableChesses:Vector.<Chess>,
													dangerPoints:Vector.<ChessWayPoint>=null):Vector.<ChessWayPoint>
		{
			//Define Main Variables
			return ChessAITools.getNearestChessWayInGroup(selfChesses,enemyChesses.concat(captureableChesses),true,dangerPoints);
		}
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function ChessAI_Hunter_II(owner:ChessPlayer=null):void
		{
			super(owner);
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function get name():String
		{
			return "AI-Hunter II";
		}
		
		public override function get thinkTime():uint
		{
			return 20;
		}
		
		//============Instance Functions============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function getOutput():Vector.<Point> 
		{
			//====Set Main Variables====//
			var result:Vector.<Point>=new Vector.<Point>;
			var selfChesses:Vector.<Chess>=this.owner.controllableSelfChesses;
			var otherChesses:Vector.<Chess>=this.host.getChessesByOwner(this.owner,true,true);
			var enemyChesses:Vector.<Chess>=ChessAITools.getEnemyChessesWith(this.owner);
			var captureableChesses:Vector.<Chess>=this.host.captureableChesses;
			var willBeAttackPoints:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			var willBeAttackChesses:Vector.<Chess>=new Vector.<Chess>;
			var willContolChess:Chess;
			var willMovePoint:ChessWayPoint;
			//====Set Temp Variables====//
			var tempChess:Chess,tempChess2:Chess;
			var tempWayPoint:ChessWayPoint;
			var tempWayPoints:Vector.<ChessWayPoint>;
			var tempSelected:Boolean;
			//====Init Variables====//
			for each(tempChess in enemyChesses)
			{
				for each(tempWayPoint in tempChess.getHarmfulMovePlaces(true))
				{
					willBeAttackPoints.push(tempWayPoint);
				}
				for each(tempWayPoint in tempChess.getHarmfulMovePlaces(false))
				{
					if(this.board.getChessOwnerAt(tempWayPoint.x,tempWayPoint.y)==this._owner)
					{
						tempChess2=this.board.getChessAt(tempWayPoint.x,tempWayPoint.y);
						if(tempChess2.canBeContol)
						{
							willBeAttackChesses.push(tempChess2);
						}
					}
				}
			}
			//====Detect Before Select====//
			if(selfChesses.length<1)
			{
				//If can swap chess
				if(this.owner.randomSwapableChess!=null)
				{
					result.push(this.owner.randomSwapableChess.boardPoint);
					return result;
				}
				//Else
				this.host.addLog(this.localAIName+":cann't move any chess!");
				return null;
			}
			//====Select Chess And Place====//
			//If some self's chess will be attack
			if(willBeAttackChesses.length>0)
			{
				var theVictimChess:Chess;
				//Select Victim
				//If the most importment chess will be attack
				if(this._owner.onlyHasOneImportmentChess&&
				   willBeAttackChesses.indexOf(this._owner.randomImportmentChess)>=0)
				{
					theVictimChess=this._owner.randomImportmentChess;
				}
				//If another chess will be attack
				else
				{
					theVictimChess=ChessAITools.mostValueAndSafeChessIn(willBeAttackChesses,willBeAttackPoints);
				}
				if(theVictimChess==null)
				{
					this.host.addLog(this.localAIName+":Null Victim!");
				}
				var killerChesses:Vector.<Chess>=ChessAITools.getCanAttackItChessesIn(theVictimChess,enemyChesses);
				//Detect Killer Chess Count
				if(killerChesses.length>1)
				{
					//Move Away From Killer Chess
					willContolChess=theVictimChess;
					willMovePoint=ChessAITools.randomInPoints(ChessAITools.getChessSafeWays(willContolChess,willBeAttackPoints));
				}
				else if(killerChesses.length==1)
				{
					var thisKillerChess:Chess=killerChesses[0];
					tempSelected=false;
					//Try To Eat KillerChess
					if(!ChessAITools.pointInPoints(thisKillerChess.boardWayPoint,willBeAttackPoints))
					{
						for each(tempChess in selfChesses)
						{
							if(ChessAITools.getIsCanAttackChess(tempChess,thisKillerChess))
							{
								willContolChess=tempChess;
								willMovePoint=thisKillerChess.boardWayPoint;
								tempSelected=true;
								break;
							}
						}
					}
					if(!tempSelected)
					{
						//If Not,Move Away From Killer Chess
						willContolChess=theVictimChess;
						willMovePoint=ChessAITools.randomInPoints(ChessAITools.getChessSafeWays(willContolChess,willBeAttackPoints));
					}
				}
				else
				{
					this.host.addLog(this.localAIName+":Null killer!");
				}
			}
			//Calm:No Chess Will Be Attack
			else
			{
				//Swap Chess
				if(this.owner.swapableChessCount>0)
				{
					result.push(this.owner.randomSwapableChess.boardPoint);
					return result;
				}
				//Select Nearest And Safe Point
				/*var nearestChesses:Vector.<Chess>=getNearestChessesInTwoGroup(selfChesses,enemyChesses);
				willContolChess=nearestChesses[0];
				willMovePoint=getNearestSafePointTo(willContolChess,nearestChesses[1].boardWayPoint,willBeAttackPoints);*/
				var mostValueWays:Vector.<ChessWayPoint>=getMostValueWayInCalm(selfChesses,enemyChesses,captureableChesses,willBeAttackPoints);
				if(mostValueWays!=null)
				{
					willContolChess=this._owner.board.getChessAt(mostValueWays[0].x,mostValueWays[0].y);
					willMovePoint=mostValueWays[1];
				}
			}
			//====Products Default Move====//
			if(willContolChess!=null&&willMovePoint==null)
			{
				//this.host.addLog(this.localAIName+":Null point,run default move!");
				//Select Random
				tempWayPoints=new Vector.<ChessWayPoint>;
				for each(tempWayPoint in willContolChess.getMovePlaces())
				{
					//Cann't Will Be Attack
					if(ChessAITools.pointInPoints(tempWayPoint,willBeAttackPoints)) continue;
					tempWayPoints.push(tempWayPoint);
				}
				willMovePoint=ChessAITools.randomInPoints(tempWayPoints);
			}
			//====Products Final Move(random)====//
			if(willContolChess!=null&&willMovePoint==null)
			{
				//this.host.addLog(this.localAIName+":Null point,run final move!");
				//Select Random
				willMovePoint=ChessAITools.randomInPoints(willContolChess.getMovePlaces());
			}
			//====Check Settings====//
			if(willContolChess==null||willMovePoint==null)
			{
				this.host.addLog(this.localAIName+":Null error!");
				return null;
			}
			//====Loadin Result====//
			result.push(willContolChess.boardPoint);
			result.push(willMovePoint.point);
			//====Return====//
			return result;
		}
	}
}