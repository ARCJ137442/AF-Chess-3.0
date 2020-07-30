package ac3.AI.Functions 
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
	
	public class ChessAITools
	{
		//============Tool Functions============//
		public static function pointInPoints(point:ChessWayPoint,points:Vector.<ChessWayPoint>):Boolean
		{
			if(point==null||points==null||points.length<1) return false;
			return pointInPoints2(point.x,point.y,points);
		}
		
		public static function pointInPoints2(x:int,y:int,points:Vector.<ChessWayPoint>):Boolean
		{
			if(points==null||points.length<1) return false;
			for each(var tempPoint:ChessWayPoint in points)
			{
				if(tempPoint.x==x&&tempPoint.y==y) return true;
			}
			return false;
		}
		
		public static function randomInPoints(points:Vector.<ChessWayPoint>):ChessWayPoint
		{
			if(points==null||points.length<1) return null;
			return points[acMath.random(points.length)];
		}
		
		public static function randomInChesses(chesses:Vector.<Chess>):Chess
		{
			if(chesses==null||chesses.length<1) return null;
			return chesses[acMath.random(chesses.length)];
		}
		
		public static function mostValueChessIn(chesses:Vector.<Chess>):Chess
		{
			if(chesses==null||chesses.length<1) return null;
			var result:Chess=randomInChesses(chesses);
			var tempValue:uint;
			for each(var tempChess:Chess in chesses)
			{
				tempValue=ChessType.getScoreWeight(result.type);
				if(ChessType.getScoreWeight(tempChess.type)>tempValue)
				{
					result=tempChess;
				}
			}
			return result;
		}
		
		public static function getChessSafeWayCount(chess:Chess,dangerPoints:Vector.<ChessWayPoint>):uint
		{
			return getChessSafeWays(chess,dangerPoints).length;
		}
		
		public static function mostValueAndSafeChessIn(chesses:Vector.<Chess>,dangerPoints:Vector.<ChessWayPoint>):Chess
		{
			if(chesses==null||chesses.length<1) return null;
			var result:Chess=randomInChesses(chesses);
			var tempValue:uint;
			for each(var tempChess:Chess in chesses)
			{
				tempValue=ChessType.getScoreWeight(result.type);
				if(getChessSafeWayCount(tempChess,dangerPoints)<1) continue;
				if(ChessType.getScoreWeight(tempChess.type)>tempValue)
				{
					result=tempChess;
				}
			}
			return result;
		}
		
		public static function getChessSafeWays(chess:Chess,dangerPoints:Vector.<ChessWayPoint>):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			for each(var tempPoint:ChessWayPoint in chess.getMovePlaces())
			{
				if(!pointInPoints(tempPoint,dangerPoints)) result.push(tempPoint);
			}
			return result;
		}
		
		public static function getNearestChessIn(chess:Chess,chesses:Vector.<Chess>):Chess
		{
			if(chess==null||chesses==null||chesses.length<1) return null;
			var result:Chess=randomInChesses(chesses);
			var tempDistance:Number;
			for each(var tempChess:Chess in chesses)
			{
				tempDistance=chess.distanceOfChess(result);
				if(tempChess.distanceOfChess(result)<tempDistance)
				{
					result=tempChess;
				}
			}
			return result;
		}
		
		public static function getNearestPointTo(chess:Chess,target:ChessWayPoint):ChessWayPoint
		{
			if(chess==null||target==null) return null;
			var movePlaces:Vector.<ChessWayPoint>=chess.getMovePlaces();
			var result:ChessWayPoint=randomInPoints(movePlaces);
			var tempDistance:Number;
			for each(var tempPoint:ChessWayPoint in movePlaces)
			{
				tempDistance=result.distanceOfWayPoint(target);
				if(tempPoint.distanceOfWayPoint(target)<tempDistance)
				{
					result=tempPoint;
				}
			}
			return result;
		}
		
		public static function getNearestChessesInTwoGroup(group1:Vector.<Chess>,group2:Vector.<Chess>):Vector.<Chess>
		{
			if(group1==null||group1.length<1||group2==null||group2.length<1) return null;
			var result:Vector.<Chess>=new <Chess>[randomInChesses(group1),randomInChesses(group2)];
			var oldDistance:Number;
			var nowDistance:Number;
			for each(var tempChess1:Chess in group1)
			{
				for each(var tempChess2:Chess in group2)
				{
					oldDistance=result[0].distanceOfChess(result[1]);
					nowDistance=tempChess1.distanceOfChess(tempChess2);
					if(nowDistance<oldDistance)
					{
						result[0]=tempChess1;
						result[1]=tempChess2;
					}
				}
			}
			return result;
		}
		
		public static function getOneNearestOneFurthestChessesInTwoGroup(groupN:Vector.<Chess>,groupF:Vector.<Chess>):Vector.<Chess>
		{
			if(groupN==null||groupN.length<1||groupF==null||groupF.length<1) return null;
			var result:Vector.<Chess>=new <Chess>[randomInChesses(groupN),randomInChesses(groupF)];
			var oldDistance:Number;
			var nowDistance:Number;
			var tempChess2:Chess;
			for each(var tempChess1:Chess in groupF)
			{
				tempChess2=getNearestChessIn(tempChess1,groupN);
				oldDistance=result[0].distanceOfChess(result[1]);
				nowDistance=tempChess1.distanceOfChess(tempChess2);
				if(nowDistance>oldDistance)
				{
					result[0]=tempChess2;
					result[1]=tempChess1;//Sort As [N,F]
				}
			}
			return result;
		}
		
		public static function getNearestChessWayInGroup(chesses:Vector.<Chess>,targets:Vector.<Chess>,requiredSafe:Boolean=true,dangerPoints:Vector.<ChessWayPoint>=null):Vector.<ChessWayPoint>
		{
			if(chesses==null||chesses.length<1||targets==null||targets.length<1) return null;
			if(requiredSafe&&dangerPoints==null)
			{
				throw new Error("Required safe,but danger points is null");
				return null;
			}
			var result0:Chess=randomInChesses(chesses);
			var result1:Chess=randomInChesses(targets);
			var result2:ChessWayPoint=result0.getRandomMovePlace();
			var oldDistance:Number;
			var nowDistance:Number;
			//Temps
			var tempWayPoints:Vector.<ChessWayPoint>;
			//Operation
			for each(var tempChess:Chess in chesses)
			{
				tempWayPoints=requiredSafe?getChessSafeWays(tempChess,dangerPoints):tempChess.getMovePlaces();
				for each(var tempWayPoint:ChessWayPoint in tempWayPoints)
				{
					for each(var tempTarget:Chess in targets)
					{
						oldDistance=result1.distanceOfWayPoint(result2);
						nowDistance=tempTarget.distanceOfWayPoint(tempWayPoint);
						if(nowDistance==0||
						   nowDistance<oldDistance||
						   nowDistance==oldDistance&&General.randomBoolean())
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
				trace("ChessAITools/getNearestChessWayInGroup():null result!")
				return null;
			}
			//Loadin Result
			var result:Vector.<ChessWayPoint>=new <ChessWayPoint>[result0.boardWayPoint,result2];
			return result;
		}
		
		public static function getEnemyChessesWith(player:ChessPlayer):Vector.<Chess>
		{
			return player.host.getChessesByOwner(player,true,false);
		}
		
		public static function getNearestSafePointTo(chess:Chess,target:ChessWayPoint,dangerPoints:Vector.<ChessWayPoint>):ChessWayPoint
		{
			if(chess==null||target==null) return null;
			var movePlaces:Vector.<ChessWayPoint>=chess.getMovePlaces();
			var result:ChessWayPoint=randomInPoints(movePlaces);
			var tempDistance:Number;
			for each(var tempPoint:ChessWayPoint in movePlaces)
			{
				tempDistance=result.distanceOfWayPoint(target);
				if(pointInPoints(tempPoint,dangerPoints)) continue;
				if(tempPoint.distanceOfWayPoint(target)<tempDistance)
				{
					result=tempPoint;
				}
			}
			return result;
		}
		
		public static function getIsCanAttackChess(chess:Chess,targetChess:Chess):Boolean
		{
			if(chess==null||targetChess==null) return false;
			for each(var tempPoint:ChessWayPoint in chess.getMovePlaces())
			{
				if(tempPoint.equals(targetChess.boardWayPoint,true,false,false)) return true;
			}
			return false;
		}
		
		public static function getCanAttackItChessesIn(targetChess:Chess,chesses:Vector.<Chess>):Vector.<Chess>
		{
			var result:Vector.<Chess>=new Vector.<Chess>;
			if(targetChess==null||chesses==null||chesses.length<1) return result;
			for each(var tempChess:Chess in chesses)
			{
				if(getIsCanAttackChess(tempChess,targetChess))
				{
					result.push(tempChess);
				}
			}
			return result;
		}
		
		public static function getMovePointsInChesses(chesses:Vector.<Chess>,ignoreChessOnCurrentWayPoint:Boolean=false):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			for each(var chess:Chess in chesses)
			{
				result=result.concat(chess.getMovePlaces(ignoreChessOnCurrentWayPoint));
			}
			return result;
		}
		
		public static function getHarmfulPointsInChesses(chesses:Vector.<Chess>,ignoreChessOnCurrentWayPoint:Boolean=false):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			for each(var chess:Chess in chesses)
			{
				result=result.concat(chess.getHarmfulMovePlaces(ignoreChessOnCurrentWayPoint));
			}
			return result;
		}
		
		public static function isInPoints(point:Point,points:Vector.<Point>):Boolean
		{
			if(point==null||points==null||points.length<1) return false;
			for each(var tempPoint:Point in points)
			{
				if(point.equals(tempPoint)) return true;
			}
			return false;
		}
		
		public static function isInWayPoints(point:ChessWayPoint,points:Vector.<ChessWayPoint>):Boolean
		{
			if(point==null||points==null||points.length<1) return false;
			for each(var tempPoint:ChessWayPoint in points)
			{
				if(point.equals(tempPoint,true,false,false)) return true;
			}
			return false;
		}
		
		public static function getChessesUnderWayPoints(chesses:Vector.<Chess>,points:Vector.<ChessWayPoint>):Vector.<Chess>
		{
			var result:Vector.<Chess>=new Vector.<Chess>;
			if(chesses==null||chesses.length<1||points==null||points.length<1) return result;
			for each(var tempChess:Chess in chesses)
			{
				for each(var tempPoint:ChessWayPoint in points)
				{
					if(result.indexOf(tempChess)>=0) break;
					if(tempChess.boardWayPoint.equals(tempPoint,true,false,false))
					{
						result.push(tempChess);
					}
				}
			}
			return result;
		}
		
		public static function getIntersectChesses(chesses1:Vector.<Chess>,chesses2:Vector.<Chess>):Vector.<Chess>
		{
			var result:Vector.<Chess>=new Vector.<Chess>;
			for each(var tempChess:Chess in chesses1)
			{
				for each(var tempChess2:Chess in chesses2)
				{
					if(tempChess===tempChess2) result.push(tempChess);
				}
			}
			return result;
		}
		
		public static function chessesToBoardWayPoints(chesses:Vector.<Chess>):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			var tempChess:Chess;
			for(var i:uint=0;i<chesses.length;i++)
			{
				tempChess=chesses[i];
				result.push(tempChess.boardWayPoint);
			}
			return result;
		}
		
		public static function removeInFilterChesses(chesses:Vector.<Chess>,filter:Vector.<Chess>):Vector.<Chess>
		{
			var result:Vector.<Chess>=new Vector.<Chess>;
			for each(var tempChess:Chess in chesses)
			{
				if(filter.indexOf(tempChess)>=0)
				{
					continue;
				}
				result.push(tempChess);
			}
			return result;
		}
		
		public static function removeInFilterPoints(points:Vector.<ChessWayPoint>,filter:Vector.<ChessWayPoint>):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			mainLoop:for each(var tempPoint:ChessWayPoint in points)
			{
				for each(var tempPoint2:ChessWayPoint in filter)
				{
					if(tempPoint.equals(tempPoint2))
					{
						continue mainLoop;
					}
				}
				result.push(tempPoint);
			}
			return result;
		}
	}
}