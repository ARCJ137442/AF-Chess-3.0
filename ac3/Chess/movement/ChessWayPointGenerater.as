package ac3.Chess.movement 
{
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.movement.*;
	import ac3.Game.*;
	
	public class ChessWayPointGenerater
	{
		//============Static Variables============//
		public static const ALL_OF_BOARD:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.ALL_OF_BOARD,new ChessWayPoint(0,0,ChessWayPointType.MOVE_AND_ATTACK));
		
		public static const STRAIGHT_LINE_MOVE:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.STRAIGHT_LINE_MOVE,new ChessWayPoint(0,0,ChessWayPointType.MOVE_AND_ATTACK));
		public static const STRAIGHT_LINE_ATTACK:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.STRAIGHT_LINE_ATTACK,new ChessWayPoint(0,0,ChessWayPointType.MOVE_AND_ATTACK));
		public static const STRAIGHT_CANNON_MOVE:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.STRAIGHT_CANNON_MOVE,new ChessWayPoint(0,0,ChessWayPointType.MOVE_AND_ATTACK));
		public static const STRAIGHT_CANNON_ATTACK:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.STRAIGHT_CANNON_ATTACK,new ChessWayPoint(0,0,ChessWayPointType.MOVE_AND_ATTACK));
		public static const STRAIGHT_THROUGH:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.STRAIGHT_THROUGH,new ChessWayPoint(0,0,ChessWayPointType.THROUGH));
		
		public static const OBLIQUE_LINE_MOVE:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.OBLIQUE_LINE_MOVE,new ChessWayPoint(0,0,ChessWayPointType.MOVE_AND_ATTACK));
		public static const OBLIQUE_LINE_ATTACK:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.OBLIQUE_LINE_ATTACK,new ChessWayPoint(0,0,ChessWayPointType.MOVE_AND_ATTACK));
		public static const OBLIQUE_CANNON_MOVE:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.OBLIQUE_CANNON_MOVE,new ChessWayPoint(0,0,ChessWayPointType.MOVE_AND_ATTACK));
		public static const OBLIQUE_CANNON_ATTACK:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.OBLIQUE_CANNON_ATTACK,new ChessWayPoint(0,0,ChessWayPointType.MOVE_AND_ATTACK));
		public static const OBLIQUE_THROUGH:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.OBLIQUE_THROUGH,new ChessWayPoint(0,0,ChessWayPointType.THROUGH));
		
		public static const GLOBAL_TELEPORT_REQUIRED_LEVEL:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.ALL_OF_BOARD,new ChessWayPoint(0,0,ChessWayPointType.TELEPORT,null,ChessMoveCondition.SELF_LEVEL_GRANDER_THAN_ZERO));
		public static const GLOBAL_SWAP:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.ALL_OVER_CHESS,new ChessWayPoint(0,0,ChessWayPointType.SWAP));
		
		public static const COPY_NEARBY_CHESS_WAYS:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.COPY_NEARBY_CHESS_WAYS,null);
		public static const COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL,null);
		public static const COPY_ALL_CHESS_WAYS:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.COPY_ALL_CHESS_WAYS,null);
		
		public static const CHAIN_JUMP:ChessWayPointGenerater=new ChessWayPointGenerater(ChessWayPointGenerateType.CHAIN_JUMP,null);
		
		//============Static Functions============//
		public static function constructOld(generateType:ChessWayPointGenerateType,argumentPoints:Array):ChessWayPointGenerater
		{
			var genereater:ChessWayPointGenerater=new ChessWayPointGenerater(null,null);
			genereater._generateType=generateType;
			if(argumentPoints==null||argumentPoints.length<1) return genereater;
			for(var i:uint=0;i<argumentPoints.length;i++)
			{
				if(argumentPoints[i] is ChessWayPoint)
				{
					genereater._argumentPoints.push(argumentPoints[i] as ChessWayPoint);
				}
			}
			return genereater;
		}
		
		public static function construct2(generateType:ChessWayPointGenerateType,...argumentPoints):ChessWayPointGenerater
		{
			return ChessWayPointGenerater.constructOld(generateType,argumentPoints);
		}
		
		public static function construct3(generateType:ChessWayPointGenerateType,argumentPoints:Vector.<ChessWayPoint>):ChessWayPointGenerater
		{
			return ChessWayPointGenerater.construct2(generateType,null).overrideArgumentPoints(argumentPoints);
		}
		
		public static function construct4(generateType:ChessWayPointGenerateType,firstArgumentPoint:ChessWayPoint):ChessWayPointGenerater
		{
			return ChessWayPointGenerater.construct2(generateType,firstArgumentPoint);
		}
		
		public static function construct5(generateType:ChessWayPointGenerateType,pointType:ChessWayPointType):ChessWayPointGenerater
		{
			return ChessWayPointGenerater.construct4(generateType,new ChessWayPoint(0,0,pointType,null));
		}
		
		//============Instance Variables============//
		protected var _generateType:ChessWayPointGenerateType;
		protected var _argumentPoints:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
		
		//============Constructor Function============//
		public function ChessWayPointGenerater(generateType:ChessWayPointGenerateType,firstArgumentPoint:ChessWayPoint):void
		{
			this._generateType=generateType;
			if(firstArgumentPoint!=null) this._argumentPoints.push(firstArgumentPoint);
		}
		
		//============Instance Getter And Setter============//
		public function get generateType():ChessWayPointGenerateType
		{
			return this._generateType;
		}
		
		public function get argumentPoints():Vector.<ChessWayPoint>
		{
			return this._argumentPoints;
		}
		
		public function get argumentPointCount():uint
		{
			return this._argumentPoints.length;
		}
		
		public function get firstArgumentPoint():ChessWayPoint
		{
			return this.argumentPointCount>0?this.argumentPoints[0]:null;
		}
		
		//============Instance Functions============//
		public function copyFrom(other:ChessWayPointGenerater):ChessWayPointGenerater
		{
			this._argumentPoints=other._argumentPoints.concat();
			this._generateType=other._generateType;
			return this;
		}
		
		public function deepCopyFrom(other:ChessWayPointGenerater):ChessWayPointGenerater
		{
			//Type
			this._generateType=other._generateType;
			//ArgumentPoints
			if(this.argumentPointCount>0) this.removeAllArgumentPoints();
			for(var i:uint=0;i<other._argumentPoints.length;i++)
			{
				this.appendArgumentPoint(other._argumentPoints[i].getCopy());
			}
			return this;
		}
		
		public function getCopy():ChessWayPointGenerater
		{
			return ChessWayPointGenerater.construct2(null,null).copyFrom(this);
		}
		
		public function changeType(type:ChessWayPointGenerateType):ChessWayPointGenerater
		{
			this._generateType=type;
			return this;
		}
		
		public function getArgumentPointAt(index:uint):ChessWayPoint
		{
			return this.argumentPointCount>index?this.argumentPoints[index]:null;
		}
		
		public function appendArgumentPoint(point:ChessWayPoint):ChessWayPointGenerater
		{
			this._argumentPoints.push(point);
			return this;
		}
		
		public function appendArgumentPoints(...points):ChessWayPointGenerater
		{
			for(var i:uint=0;i<points.length;i++)
			{
				if(points[i] is ChessWayPoint)
				{
					this._argumentPoints.push(points[i] as ChessWayPoint);
				}
			}
			return this;
		}
		
		public function overrideArgumentPoints(newPoints:Vector.<ChessWayPoint>):ChessWayPointGenerater
		{
			this._argumentPoints=newPoints;
			return this;
		}
		
		public function removeAllArgumentPoints():void
		{
			this.argumentPoints.splice(0,this.argumentPointCount);
		}
	}
}