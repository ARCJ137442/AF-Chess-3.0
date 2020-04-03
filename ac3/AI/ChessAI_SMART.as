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
	
	public class ChessAI_SMART extends ChessAI_Common implements IChessAI
	{
		//============Static Functions============//
		
		//============Instance Variables============//
		
		//============Constructor Function============//
		public function ChessAI_SMART(owner:ChessPlayer=null):void
		{
			super(owner);
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function get name():String
		{
			return "AI-SMART";
		}
		
		public override function get thinkTime():uint
		{
			return acMath.random(20)+10;
		}
		
		//============Instance Functions============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function getOutput():Vector.<Point> 
		{
			//====Set Result Variables====//
			var result:Vector.<Point>=new Vector.<Point>;
			var willContolChess:Chess;
			var willMovePoint:ChessWayPoint;
			//====Set Main Variables====//
			var selfChesses:Vector.<Chess>=this.owner.handleChesses;
			var selfControllableChesses:Vector.<Chess>=this.owner.controllableSelfChesses;
			var enemyChesses:Vector.<Chess>=ChessAITools.getEnemyChessesWith(this._owner);
			var nullChesses:Vector.<Chess>=this.host.nullChesses;
			var blackChesses:Vector.<Chess>=this.host.blackChesses;
			var swapableChess:Vector.<Chess>=nullChesses.concat(this._owner.typeRaChesses);
			var captureableChesses:Vector.<Chess>=this.host.captureableChesses;
			var nowEnemyCanAttackPoints:Vector.<ChessWayPoint>=ChessAITools.getHarmfulPointsInChesses(enemyChesses);
			var nowSelfCanAttackPoints:Vector.<ChessWayPoint>=ChessAITools.getHarmfulPointsInChesses(selfControllableChesses);
			var nowSelfCanAttackEnemyChesses:Vector.<Chess>=ChessAITools.getChessesUnderWayPoints(enemyChesses,nowSelfCanAttackPoints);
			var nowSelfWillBeAttackChesses:Vector.<Chess>=ChessAITools.getChessesUnderWayPoints(selfChesses,nowEnemyCanAttackPoints);
			var nowSelfProtectedChess:Vector.<Chess>=ChessAITools.getChessesUnderWayPoints(selfChesses,nowSelfCanAttackPoints);
			var nowSelfWillBeAttackUnprotectedChesses:Vector.<Chess>=ChessAITools.removeInFilterChesses(nowSelfWillBeAttackChesses,nowSelfProtectedChess);
			var nowDangerPoints:Vector.<ChessWayPoint>=ChessAITools.removeInFilterPoints(nowEnemyCanAttackPoints,nowSelfCanAttackPoints);
			//====Set Temp Variables====//
			var tempChess:Chess;
			var tempChesses:Vector.<Chess>;
			var tempPoint:ChessWayPoint;
			var tempPoints:Vector.<ChessWayPoint>;
			var tempBoolean:Boolean;
			//====Init Variables====//
			//====Detect Before Select====//
			if(selfControllableChesses.length<1)
			{
				//If can swap chess
				if(swapableChess.length>0)
				{
					result.push(swapableChess[acMath.random(swapableChess.length)].boardPoint);
					return result;
				}
				//Else
				this.host.addLog("ChessAI_SMART:cann't move any chess!");
				return null;
			}
			//If UnprotectedChess will be attack
			else if(nowSelfWillBeAttackUnprotectedChesses.length>0)
			{
				//Find Threater
				var threaterChesses:Vector.<Chess>=ChessAITools.getCanAttackItChessesIn(theVictimChess,enemyChesses);
				var willSaveChess:Chess=ChessAITools.randomInChesses(this.getMostValueChesses(nowSelfWillBeAttackUnprotectedChesses));
				if(threaterChesses.length<1)
				{
					this.host.addLog("ChessAI_SMART:Error on fiding threaterChesses!");
				}
				else if(threaterChesses.length==1)
				{
					var thisThreaterChess:Chess=threaterChesses[0];
					tempBoolean=false;//Is Selected Chess To Attack
					//Try To Attack threaterChesses
					tempChesses=ChessAITools.getCanAttackItChessesIn(thisThreaterChess,selfControllableChesses);
					if(tempChesses.length>0)
					{
						tempBoolean=true;
						willContolChess=ChessAITools.randomInChesses(this.getMostValueChesses(tempChesses,true));
						willMovePoint=thisThreaterChess.boardWayPoint;
					}
				}
				else if(!tempBoolean)
				{
					//Move The Chess Away From Attack
					willContolChess=willSaveChess;
					willMovePoint=ChessAITools.randomInPoints(this.getMostValueWayPoints(willContolChess,willContolChess.getMovePlaces(),nowDangerPoints,false));
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
				var mostValueWays:Vector.<ChessWayPoint>=ChessAI_Hunter_II.getMostValueWayInCalm(selfChesses,enemyChesses,captureableChesses,nowDangerPoints);
				if(mostValueWays!=null)
				{
					willContolChess=this._owner.board.getChessAt(mostValueWays[0].x,mostValueWays[0].y);
					willMovePoint=mostValueWays[1];
				}
			}
			//====Select Chess And Place====//
			//====Loadin Result====//
			result.push(willContolChess.boardPoint);
			result.push(willMovePoint.point);
			//====Return====//
			return result;
		}
		
		//Functions About Values
		public function getValueWithChess(chess:Chess):int
		{
			var result:int=0;
			if(chess==null) return result;
			var tempNum:int;
			if(chess.owner==this.owner) result+=1;
			if(chess.importment)
			{
				tempNum=50;
				if(chess.hasOwner)
				{
					if(this.owner.importmentChessCount<1) tempNum=0;
					tempNum/=Math.pow(chess.owner.importmentChessCount,2);
				}
				else tempNum=0;
				result+=tempNum;
				result*=2;
			}
			result+=chess.scoreWeight*4;
			if(ChessType.getUseLevelOnTeleport(chess.type)) result+=chess.level;
			if(chess.life>0&&(chess.lifeUsingOnMove>0||chess.lifeUsingOnTurn>0))
			{
				result/=(chess.lifeUsingOnMove+chess.lifeUsingOnTurn*2)/chess.life;
			}
			return result;
		}
		
		public function getSortedValueOfChesses(chesses:Vector.<Chess>):Vector.<Chess>
		{
			var result:Vector.<Chess>=chesses.concat();
			return result.sort(this.sortValueBehavior);
		}
		
		protected function sortValueBehavior(x:Chess,y:Chess):Number
		{
			return this.getValueWithChess(y)-this.getValueWithChess(x);
		}
		
		public function getMostValueChesses(chesses:Vector.<Chess>,reverseChoice:Boolean=false):Vector.<Chess>
		{
			var result:Vector.<Chess>=new Vector.<Chess>;
			var tempValue:int;
			var mostValue:int=int.MIN_VALUE;
			for each(var tempChess:Chess in chesses)
			{
				tempValue=this.getValueWithChess(tempChess);
				if(reverseChoice?(tempValue<=mostValue):(tempValue>=mostValue))
				{
					if(tempValue!=mostValue)
					{
						result.splice(0,result.length);
						mostValue=tempValue;
					}
					result.push(tempChess);
				}
			}
			return result;
		}
		
		public function getValueWithWayPoint(willMoveChess:Chess,wayPoint:ChessWayPoint,dangerPoints:Vector.<ChessWayPoint>=null):int
		{
			var result:int=0;
			if(dangerPoints==null) dangerPoints=new Vector.<ChessWayPoint>;
			var targetChess:Chess=this.board.getChessAt(wayPoint.x,wayPoint.y);
			if(targetChess!=null) result+=5+(this.getValueWithChess(targetChess)-this.getValueWithChess(willMoveChess))*5;
			if(ChessAITools.pointInPoints(wayPoint,dangerPoints)) result-=10;
			return result;
		}
		
		public function getMostValueWayPoints(willMoveChess:Chess,wayPoints:Vector.<ChessWayPoint>,dangerWayPoints:Vector.<ChessWayPoint>,reverseChoice:Boolean=false):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			var tempValue:int;
			var mostValue:int=int.MIN_VALUE;
			for each(var tempWayPoint:ChessWayPoint in wayPoints)
			{
				tempValue=this.getValueWithWayPoint(willMoveChess,tempWayPoint,dangerWayPoints);
				if(reverseChoice?(tempValue<=mostValue):(tempValue>=mostValue))
				{
					if(tempValue!=mostValue)
					{
						result.splice(0,result.length);
						mostValue=tempValue;
					}
					result.push(tempWayPoint);
				}
			}
			return result;
		}
	}
}