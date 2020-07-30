package ac3.AI 
{
	//AF Chess 3.0
	import ac3.Chess.movement.ChessWayPoint;
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.movement.*;
	import ac3.Game.*;
	import ac3.AI.*;
	import ac3.AI.Functions.*;
	
	//Flash
	import flash.geom.Point;
	
	public class ChessAI_Hunter_III extends ChessAI_Hunter_II implements IChessAI
	{
		//============Static Functions============//
		
		//============Instance Variables============//
		public var sumOfCalmWay1:uint=1;
		public var sumOfCalmWay2:uint=1;
		
		//============Constructor Function============//
		public function ChessAI_Hunter_III(owner:ChessPlayer=null):void
		{
			super(owner);
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function get name():String
		{
			return "AI-Hunter III";
		}
		
		public override function get thinkTime():uint
		{
			return acMath.random(11)+10;
		}
		
		//============Instance Functions============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function getOutput():Vector.<Point> 
		{
			//====Set Result Variables====//
			var result:Vector.<Point>=new Vector.<Point>;
			var willContolChess:Chess;
			var willMovePoint:ChessWayPoint;
			//====Set Variables====//
			var selfChesses:Vector.<Chess>=this.owner.handleChesses;
			var selfControllableChesses:Vector.<Chess>=this.owner.controllableSelfChesses;
			var enemyChesses:Vector.<Chess>=ChessAITools.getEnemyChessesWith(this._owner);
			var captureableChesses:Vector.<Chess>=this.host.captureableChesses;
			var targetChesses:Vector.<Chess>=enemyChesses.concat(captureableChesses);
			var swapableChess:Vector.<Chess>=this.owner.swapableChesses;
			var selfImportmentChesses:Vector.<Chess>=this.owner.importmentChesses;
			var nowEnemyCanAttackPoints:Vector.<ChessWayPoint>=ChessAITools.getHarmfulPointsInChesses(enemyChesses,false);
			var nowSelfCanAttackPoints:Vector.<ChessWayPoint>=ChessAITools.getHarmfulPointsInChesses(selfControllableChesses,false);
			var nowSelfCanAttackEnemyChesses:Vector.<Chess>=ChessAITools.getChessesUnderWayPoints(enemyChesses,nowSelfCanAttackPoints);
			var nowSelfWillBeAttackChesses:Vector.<Chess>=ChessAITools.getChessesUnderWayPoints(selfChesses,nowEnemyCanAttackPoints);
			var nowSelfProtectedChess:Vector.<Chess>=ChessAITools.getChessesUnderWayPoints(ChessAITools.removeInFilterChesses(selfChesses,selfImportmentChesses),nowSelfCanAttackPoints);
			var nowSelfWillBeAttackUnprotectedChesses:Vector.<Chess>=ChessAITools.removeInFilterChesses(nowSelfWillBeAttackChesses,nowSelfProtectedChess);
			var nowTotalDangerPoints:Vector.<ChessWayPoint>=ChessAITools.removeInFilterPoints(nowEnemyCanAttackPoints,nowSelfCanAttackPoints);
			//====Set Temp Variables====//
			var tempChess:Chess;
			var tempChesses:Vector.<Chess>;
			var tempPoint:ChessWayPoint;
			var tempPoints:Vector.<ChessWayPoint>;
			var tempBoolean:Boolean;
			var doCalm:Boolean=true;
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
				this.host.addLog(this.localAIName+":cann't move any chess!");
				return null;
			}
			//====Select Chess And Place====//
			//If UnprotectedChess will be attack
			if(nowSelfWillBeAttackUnprotectedChesses.length>0)
			{
				//Find Threater
				var willSaveChess:Chess=ChessAITools.randomInChesses(this.getMostValueChesses(nowSelfWillBeAttackUnprotectedChesses));
				var threaterChesses:Vector.<Chess>=ChessAITools.getCanAttackItChessesIn(willSaveChess,enemyChesses);
				if(threaterChesses.length<1)
				{
					this.host.addLog(this.localAIName+":Error on fiding threaterChesses!");
				}
				else if(threaterChesses.length==1)
				{
					var thisThreaterChess:Chess=threaterChesses[0];
					tempBoolean=false;//Is Selected Chess To Attack
					//Try To Attack threaterChesses
					tempChesses=ChessAITools.getCanAttackItChessesIn(thisThreaterChess,selfControllableChesses);
					if(tempChesses.length>0)
					{
						willContolChess=ChessAITools.randomInChesses(this.getMostValueChesses(tempChesses,true));
						willMovePoint=thisThreaterChess.boardWayPoint;
						if(willContolChess!=null&&willMovePoint!=null) tempBoolean=true;
					}
				}
				if(willSaveChess.canBeContol&&!tempBoolean)
				{
					//Move The Chess Away From Attack
					willContolChess=willSaveChess;
					tempPoints=this.getDangerPointsWithChess(willContolChess,nowSelfCanAttackPoints,nowEnemyCanAttackPoints);
					willMovePoint=ChessAITools.randomInPoints(this.getMostValueWayPoints(willContolChess,willContolChess.getMovePlaces(),tempPoints,false));
				}
				if(willMovePoint!=null) doCalm=false;
			}
			//Calm:No Chess Will Be Attack
			if(doCalm)
			{
				//Swap Chess
				if(General.randomBoolean()&&this.owner.swapableChessCount>0)
				{
					result.push(this.owner.randomSwapableChess.boardPoint);
					return result;
				}
				//====These Following Codes Will Be Changed Into A New Behavior For III====//
				//Select Nearest And Safe Point
				/*var willContolChess1:Chess,willMovePoint1:ChessWayPoint;
				var willContolChess2:Chess,willMovePoint2:ChessWayPoint;
				var NFChesses:Vector.<Chess>=ChessAITools.getOneNearestOneFurthestChessesInTwoGroup(targetChesses,selfControllableChesses);
				if(NFChesses!=null&&NFChesses.length>=2)
				{
					willContolChess1=NFChesses[1];
					if(willContolChess1!=null)
					{
						willMovePoint1=this.getMostValueWayWithChess(willContolChess1,enemyChesses,captureableChesses,nowEnemyCanAttackPoints,nowSelfCanAttackPoints);
					}
				}
				var mostValueWays:Vector.<ChessWayPoint>=this.getMostValueWayInCalm(selfControllableChesses,enemyChesses,captureableChesses,nowEnemyCanAttackPoints,nowSelfCanAttackPoints);
				if(mostValueWays!=null)
				{
					willContolChess2=this.owner.board.getChessAt(mostValueWays[0].x,mostValueWays[0].y);
					willMovePoint2=mostValueWays[1];
				}
				var value1:int=this.getValueWithWayPoint(willContolChess1,willMovePoint1,nowEnemyCanAttackPoints);
				var value2:int=this.getValueWithWayPoint(willContolChess2,willMovePoint2,nowEnemyCanAttackPoints);
				if(value1>value2||General.randomBoolean(this.sumOfCalmWay2,this.sumOfCalmWay1))
				{
					willContolChess=willContolChess1;
					willMovePoint=willMovePoint1;
					this.sumOfCalmWay1++;
				}
				else
				{
					willContolChess=willContolChess2;
					willMovePoint=willMovePoint2;
					this.sumOfCalmWay2++;
				}*/
				var mostValueWays:Vector.<ChessWayPoint>=ChessAI_Hunter_II.getMostValueWayInCalm(selfControllableChesses,enemyChesses,captureableChesses,nowEnemyCanAttackPoints);
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
				tempPoints=new Vector.<ChessWayPoint>;
				for each(tempPoint in willContolChess.getMovePlaces())
				{
					//Cann't Will Be Attack
					if(ChessAITools.pointInPoints(tempPoint,nowTotalDangerPoints)) continue;
					tempPoints.push(tempPoint);
				}
				willMovePoint=ChessAITools.randomInPoints(tempPoints);
			}
			//====Products Final Move(random)====//
			else if(willContolChess==null||willMovePoint==null)
			{
				//this.host.addLog(this.localAIName+":Null point,run final move!");
				//Select Random
				return ChessAI_Random.getOutputByPlayer(this.owner);
			}
			//====Loadin Result====//
			result.push(willContolChess.boardPoint);
			result.push(willMovePoint.point);
			//====Return====//
			return result;
		}
		
		//Tool Functions
		public function getDangerPointsWithChess(willMoveChess:Chess,selfProtectedPoints:Vector.<ChessWayPoint>,enemyCanAttackPoints:Vector.<ChessWayPoint>):Vector.<ChessWayPoint>
		{
			return ChessAITools.removeInFilterPoints(enemyCanAttackPoints,ChessAITools.removeInFilterPoints(selfProtectedPoints,willMoveChess.getMovePlaces(false)));
		}
		
		public function getMostValueWayWithChess(chess:Chess,
												enemyChesses:Vector.<Chess>,
												captureableChesses:Vector.<Chess>,
												enemyCanAttackPoints:Vector.<ChessWayPoint>,
												selfProtectedPoints:Vector.<ChessWayPoint>):ChessWayPoint
		{
			//Init Variables
			var targets:Vector.<Chess>=enemyChesses.concat(captureableChesses);
			//Set Main Variables
			var result0:Chess=ChessAITools.randomInChesses(targets);
			var result:ChessWayPoint=chess.getRandomMovePlace();
			var oldValue:Number;
			var nowValue:Number;
			//Temps
			var tempWayPoints:Vector.<ChessWayPoint>;
			var tempDangerPoints:Vector.<ChessWayPoint>;
			//Operation
			tempDangerPoints=enemyCanAttackPoints//getDangerPointsWithChess(chess,selfProtectedPoints,enemyCanAttackPoints);
			tempWayPoints=ChessAITools.getChessSafeWays(chess,tempDangerPoints);
			for each(var tempWayPoint:ChessWayPoint in tempWayPoints)
			{
				for each(var tempTarget:Chess in targets)
				{
					oldValue=this.getValueWithWayPoint(chess,result,tempDangerPoints)-result0.distanceOfWayPoint(result)/2;
					nowValue=this.getValueWithWayPoint(chess,tempWayPoint,tempDangerPoints)-tempTarget.distanceOfWayPoint(tempWayPoint)/2;
					if(nowValue>oldValue||
					   nowValue==oldValue&&General.randomBoolean())
					{
						result0=tempTarget;
						result=tempWayPoint;
					}
				}
			}
			if(result0==null)
			{
				trace("ChessAI_Hunter_III/getMostValueWayWithChess():null result!")
				return null;
			}
			return result;
		}
		
		public function getMostValueWayInCalm(selfChesses:Vector.<Chess>,
											 enemyChesses:Vector.<Chess>,
											 captureableChesses:Vector.<Chess>,
											 enemyCanAttackPoints:Vector.<ChessWayPoint>,
											 selfProtectedPoints:Vector.<ChessWayPoint>):Vector.<ChessWayPoint>
		{
			//Init Variables
			var targets:Vector.<Chess>=enemyChesses.concat(captureableChesses);
			//Set Main Variables
			var result0:Chess=ChessAITools.randomInChesses(selfChesses);
			var result1:Chess=ChessAITools.randomInChesses(targets);
			var result2:ChessWayPoint=result0.getRandomMovePlace();
			var oldValue:Number;
			var nowValue:Number;
			var oldDistance:Number;
			var nowDistance:Number;
			//Temps
			var tempWayPoints:Vector.<ChessWayPoint>;
			var tempDangerPoints:Vector.<ChessWayPoint>;
			//Operation
			for each(var tempChess:Chess in selfChesses)
			{
				tempDangerPoints=getDangerPointsWithChess(tempChess,selfProtectedPoints,enemyCanAttackPoints);
				tempWayPoints=ChessAITools.getChessSafeWays(tempChess,tempDangerPoints);
				for each(var tempWayPoint:ChessWayPoint in tempWayPoints)
				{
					for each(var tempTarget:Chess in targets)
					{
						oldDistance=result1.distanceOfWayPoint(result2);
						nowDistance=tempTarget.distanceOfWayPoint(tempWayPoint);
						oldValue=this.getValueWithWayPoint(tempChess,result2,tempDangerPoints)-oldDistance/2;
						nowValue=this.getValueWithWayPoint(tempChess,tempWayPoint,tempDangerPoints)-nowDistance/2;
						if(nowDistance==0||
						   nowValue>oldValue||
						   nowValue==oldValue&&General.randomBoolean())
						{
							result0=tempChess;
							result1=tempTarget;
							result2=tempWayPoint;
						}
					}
				}
			}
			if(result0==null||result1==null)
			{
				trace("ChessAI_Hunter_III/getMostValueWayInCalm():null result!")
				return null;
			}
			//Loadin Result
			var result:Vector.<ChessWayPoint>=new <ChessWayPoint>[result0.boardWayPoint,result2];
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
			var mostValue:int=reverseChoice?int.MAX_VALUE:int.MIN_VALUE;
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
			if(targetChess!=null) result+=5+(this.getValueWithChess(targetChess)-this.getValueWithChess(willMoveChess))*10;
			if(ChessAITools.pointInPoints(wayPoint,dangerPoints)) result-=10;
			return result;
		}
		
		public function getMostValueWayPoints(willMoveChess:Chess,wayPoints:Vector.<ChessWayPoint>,dangerWayPoints:Vector.<ChessWayPoint>,reverseChoice:Boolean=false):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			var tempValue:int;
			var mostValue:int=reverseChoice?int.MAX_VALUE:int.MIN_VALUE;
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