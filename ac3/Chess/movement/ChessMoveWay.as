package ac3.Chess.movement 
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.movement.*;
	import ac3.Game.*;
	
	//Flash
	import flash.geom.Point;
	import flash.utils.Dictionary;
	
	public class ChessMoveWay 
	{
		//============Static Variables============//
		protected static var classInited:Boolean=false;
		protected static var typeCurrents:Dictionary=new Dictionary();
		
		//Preseted Move Way
		public static const ALL_OF_BOARD:ChessMoveWay=new ChessMoveWay();
		
		//Lined Special Ways
		public static const SPECIAL_STRAIGHT_LINE:ChessMoveWay=new ChessMoveWay().appendGenereaters(ChessWayPointGenerater.STRAIGHT_LINE_MOVE,ChessWayPointGenerater.STRAIGHT_LINE_ATTACK);
		public static const SPECIAL_STRAIGHT_CANNON:ChessMoveWay=new ChessMoveWay().appendGenereaters(ChessWayPointGenerater.STRAIGHT_LINE_MOVE,ChessWayPointGenerater.STRAIGHT_CANNON_ATTACK);
		public static const SPECIAL_STRAIGHT_REVERSE_CANNON:ChessMoveWay=new ChessMoveWay().appendGenereaters(ChessWayPointGenerater.STRAIGHT_CANNON_MOVE,ChessWayPointGenerater.STRAIGHT_LINE_ATTACK);
		
		public static const SPECIAL_OBLIQUE_LINE:ChessMoveWay=new ChessMoveWay().appendGenereaters(ChessWayPointGenerater.OBLIQUE_LINE_MOVE,ChessWayPointGenerater.OBLIQUE_LINE_ATTACK);
		public static const SPECIAL_OBLIQUE_CANNON:ChessMoveWay=new ChessMoveWay().appendGenereaters(ChessWayPointGenerater.OBLIQUE_LINE_MOVE,ChessWayPointGenerater.OBLIQUE_CANNON_ATTACK);
		public static const SPECIAL_OBLIQUE_REVERSE_CANNON:ChessMoveWay=new ChessMoveWay().appendGenereaters(ChessWayPointGenerater.OBLIQUE_CANNON_MOVE,ChessWayPointGenerater.OBLIQUE_LINE_ATTACK);
		
		public static const SPECIAL_STRAIGHT_THROUGH:ChessMoveWay=new ChessMoveWay().appendGenereater(ChessWayPointGenerater.STRAIGHT_THROUGH);
		public static const SPECIAL_OBLIQUE_THROUGH:ChessMoveWay=new ChessMoveWay().appendGenereater(ChessWayPointGenerater.OBLIQUE_THROUGH);
		
		//Other Special Ways
		public static const SPECIAL_GLOBAL_TELEPORT_REQUIRED_LEVEL:ChessMoveWay=new ChessMoveWay().appendGenereater(ChessWayPointGenerater.GLOBAL_TELEPORT_REQUIRED_LEVEL);
		public static const SPECIAL_GLOBAL_SWAP:ChessMoveWay=new ChessMoveWay().appendGenereater(ChessWayPointGenerater.GLOBAL_SWAP);
		
		public static const SPECIAL_COPY_NEARBY_CHESS_WAYS:ChessMoveWay=new ChessMoveWay().appendGenereater(ChessWayPointGenerater.COPY_NEARBY_CHESS_WAYS);
		public static const SPECIAL_COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL:ChessMoveWay=new ChessMoveWay().appendGenereater(ChessWayPointGenerater.COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL);
		public static const SPECIAL_COPY_ALL_CHESS_WAYS:ChessMoveWay=new ChessMoveWay().appendGenereater(ChessWayPointGenerater.COPY_ALL_CHESS_WAYS);
		
		public static const SPECIAL_CHAIN_JUMP:ChessMoveWay=new ChessMoveWay().appendGenereater(ChessWayPointGenerater.CHAIN_JUMP);
		
		//============Static Functions============//
		
		//======Main Functions======//
		protected static function classInit():void
		{
			if(classInited) return;
			else classInited=true;
			//====Init All Of CHesses's Move Way,WillBe Parse In Game====//
			var way:ChessMoveWay,ways:Vector.<ChessMoveWay>;
			for each(var type:ChessType in ChessType.ALL_TYPES)
			{
				ways=new Vector.<ChessMoveWay>();
				switch(type)
				{
					case ChessType.S:
						//I
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE_AND_ATTACK)
								));
						//II
						ways.push(new ChessMoveWay(
									new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
									).appendGenereater(
									new WayPointGeneraterStraight(
										null,new ChessWayPoint(2,0,ChessWayPointType.ATTACK),1,0
										)
									),new ChessMoveWay(
									new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
									).appendGenereater(
									new WayPointGeneraterStraight(
										null,new ChessWayPoint(-2,0,ChessWayPointType.ATTACK),-1,0
										)
									),new ChessMoveWay(
									new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
									).appendGenereater(
									new WayPointGeneraterStraight(
										null,new ChessWayPoint(0,2,ChessWayPointType.ATTACK),0,1
										)
									),new ChessMoveWay(
									new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
									).appendGenereater(
									new WayPointGeneraterStraight(
										null,new ChessWayPoint(0,-2,ChessWayPointType.ATTACK),0,-1
										)
									)
								);
						break;
					case ChessType.D:
						//I
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,-1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,-1,ChessWayPointType.MOVE_AND_ATTACK)
								));
						//II
						ways.push(new ChessMoveWay(
									new ChessWayPoint(1,1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
									).appendGenereater(
									new WayPointGeneraterStraight(
										null,new ChessWayPoint(2,2,ChessWayPointType.ATTACK),1,1
										)
									),new ChessMoveWay(
									new ChessWayPoint(-1,1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
									).appendGenereater(
									new WayPointGeneraterStraight(
										null,new ChessWayPoint(-2,2,ChessWayPointType.ATTACK),-1,1
										)
									),new ChessMoveWay(
									new ChessWayPoint(1,-1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
									).appendGenereater(
									new WayPointGeneraterStraight(
										null,new ChessWayPoint(2,-2,ChessWayPointType.ATTACK),1,-1
										)
									),new ChessMoveWay(
									new ChessWayPoint(-1,-1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
									).appendGenereater(
									new WayPointGeneraterStraight(
										null,new ChessWayPoint(-2,-2,ChessWayPointType.ATTACK),-1,-1
										)
									)
								);
						break;
					case ChessType.Si:
						//I
						ways.push(new ChessMoveWay(
								new ChessWayPoint(2,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-2,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,-2,ChessWayPointType.MOVE_AND_ATTACK)
								));
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								));
						break;
					case ChessType.Di:
						//I
						ways.push(new ChessMoveWay(
								new ChessWayPoint(2,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								));
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,1,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,-1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-1,-1,ChessWayPointType.MOVE),
								new ChessWayPoint(1,1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-1,1,ChessWayPointType.MOVE),
								new ChessWayPoint(1,-1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(1,-1,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,1,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								));
						//II
						break
					case ChessType.X:
						ways.push(new ChessMoveWay().addPointSquare(-1,-1,1,1,ChessWayPointType.MOVE_AND_ATTACK));
						break;
					case ChessType.H:
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(1,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(2,-1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-2,-1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								));
						break;
					case ChessType.Ki:
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(2,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(2,-1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-2,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-2,-1,ChessWayPointType.MOVE_AND_ATTACK)
								));
						break;
					case ChessType.Ci:
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE)
								),new ChessMoveWay(
								new ChessWayPoint(1,1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_MIND_CONTOL),
								new ChessWayPoint(-1,-1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_MIND_CONTOL),
								new ChessWayPoint(-1,1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_MIND_CONTOL),
								new ChessWayPoint(1,-1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_MIND_CONTOL)
								),new ChessMoveWay(
								new ChessWayPoint(2,0,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_MIND_CONTOL),
								new ChessWayPoint(-2,0,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_MIND_CONTOL),
								new ChessWayPoint(0,2,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_MIND_CONTOL),
								new ChessWayPoint(0,-2,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_MIND_CONTOL)
								));
						break;
					case ChessType.Cu:
						ways.push(new ChessMoveWay().margeCondition(ChessMoveCondition.SELF_NO_ACTION_DID).addPointSquare(-4,-4,4,4,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_CREATE_MOVE_PLACES))
						break;
					case ChessType.Co:
						ways.push(new ChessMoveWay().addPointSquare(-1,-1,1,1,ChessWayPointType.MOVE_AND_ATTACK))
						break;
					case ChessType.F:
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,1,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,1,ChessWayPointType.MOVE),
								new ChessWayPoint(1,-1,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,-1,ChessWayPointType.MOVE)
								),
								new ChessMoveWay().addPointLine(1,0,4,0,ChessWayPointType.ATTACK),
								new ChessMoveWay().addPointLine(-1,0,-4,0,ChessWayPointType.ATTACK),
								new ChessMoveWay().addPointLine(0,1,0,4,ChessWayPointType.ATTACK),
								new ChessMoveWay().addPointLine(0,-1,0,-4,ChessWayPointType.ATTACK))
						break;
					case ChessType.Sp:
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE)
								),new ChessMoveWay(
								new ChessWayPoint(1,1,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS),
								new ChessWayPoint(-1,1,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS),
								new ChessWayPoint(1,-1,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS),
								new ChessWayPoint(-1,-1,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,0,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS),
								new ChessWayPoint(-2,0,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS),
								new ChessWayPoint(0,2,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS),
								new ChessWayPoint(0,-2,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,2,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS),
								new ChessWayPoint(-2,-2,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS),
								new ChessWayPoint(-2,2,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS),
								new ChessWayPoint(2,-2,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS)
								));
						break;
					case ChessType.Gl:
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE),
								new ChessWayPoint(1,1,ChessWayPointType.ATTACK),
								new ChessWayPoint(-1,1,ChessWayPointType.ATTACK),
								new ChessWayPoint(1,-1,ChessWayPointType.ATTACK),
								new ChessWayPoint(-1,-1,ChessWayPointType.ATTACK)
								));
						break;
					case ChessType.Tr:
						ways.push(
								new ChessMoveWay().addPointLine(0,0,20,0,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_MOVE_OTHER_CHESS),
								new ChessMoveWay().addPointLine(0,0,-20,0,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_MOVE_OTHER_CHESS),
								new ChessMoveWay().addPointLine(0,0,0,20,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_MOVE_OTHER_CHESS),
								new ChessMoveWay().addPointLine(0,0,0,-20,ChessWayPointType.MOVE,ChessWayPointType.SPECIAL_MOVE_OTHER_CHESS)
						);
						break;
					case ChessType.Sd:
						//I
						ways.push(new ChessMoveWay().addPointSquare(-1,-1,1,1,ChessWayPointType.MOVE));
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(2,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								));
						break;
					case ChessType.V:
						//I
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE_AND_ATTACK,ChessWayPointType.SPECIAL_INFLUENCE,null,ChessMoveCondition.HAS_BLACK_CHESS),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE_AND_ATTACK,ChessWayPointType.SPECIAL_INFLUENCE,null,ChessMoveCondition.HAS_BLACK_CHESS),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE_AND_ATTACK,ChessWayPointType.SPECIAL_INFLUENCE,null,ChessMoveCondition.HAS_BLACK_CHESS),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE_AND_ATTACK,ChessWayPointType.SPECIAL_INFLUENCE,null,ChessMoveCondition.HAS_BLACK_CHESS),
								new ChessWayPoint(1,1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_INFLUENCE,null/*,ChessMoveCondition.HAS_BLACK_CHESS*/),
								new ChessWayPoint(-1,1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_INFLUENCE,null/*,ChessMoveCondition.HAS_BLACK_CHESS*/),
								new ChessWayPoint(1,-1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_INFLUENCE,null/*,ChessMoveCondition.HAS_BLACK_CHESS*/),
								new ChessWayPoint(-1,-1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_INFLUENCE,null/*,ChessMoveCondition.HAS_BLACK_CHESS*/)
								));
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.ABSORPTION_LEVEL,null,ChessMoveCondition.HAS_ALLY_CHESS),
								new ChessWayPoint(-1,0,ChessWayPointType.ABSORPTION_LEVEL,null,ChessMoveCondition.HAS_ALLY_CHESS),
								new ChessWayPoint(0,1,ChessWayPointType.ABSORPTION_LEVEL,null,ChessMoveCondition.HAS_ALLY_CHESS),
								new ChessWayPoint(0,-1,ChessWayPointType.ABSORPTION_LEVEL,null,ChessMoveCondition.HAS_ALLY_CHESS),
								new ChessWayPoint(1,1,ChessWayPointType.TRANSFER_LEVEL,null,ChessMoveCondition.HAS_ALLY_CHESS),
								new ChessWayPoint(-1,1,ChessWayPointType.TRANSFER_LEVEL,null,ChessMoveCondition.HAS_ALLY_CHESS),
								new ChessWayPoint(1,-1,ChessWayPointType.TRANSFER_LEVEL,null,ChessMoveCondition.HAS_ALLY_CHESS),
								new ChessWayPoint(-1,-1,ChessWayPointType.TRANSFER_LEVEL,null,ChessMoveCondition.HAS_ALLY_CHESS)
								));
						break;
					case ChessType.Rk:
						ways.push(ChessMoveWay.SPECIAL_STRAIGHT_LINE);
						break;
					case ChessType.Ca:
						ways.push(ChessMoveWay.SPECIAL_STRAIGHT_CANNON);
						break;
					case ChessType.Rc:
						ways.push(ChessMoveWay.SPECIAL_STRAIGHT_REVERSE_CANNON);
						break;
					case ChessType.Bs:
						ways.push(ChessMoveWay.SPECIAL_OBLIQUE_LINE);
						break;
					case ChessType.Ic:
						ways.push(ChessMoveWay.SPECIAL_OBLIQUE_CANNON);
						break;
					case ChessType.Ir:
						ways.push(ChessMoveWay.SPECIAL_OBLIQUE_REVERSE_CANNON);
						break;
					case ChessType.Le:
						ways.push(ChessMoveWay.SPECIAL_STRAIGHT_LINE,
								  ChessMoveWay.SPECIAL_OBLIQUE_LINE);
						break;
					case ChessType.Ce:
						ways.push(ChessMoveWay.SPECIAL_STRAIGHT_CANNON,
								  ChessMoveWay.SPECIAL_OBLIQUE_CANNON);
						break;
					case ChessType.Re:
						ways.push(ChessMoveWay.SPECIAL_STRAIGHT_REVERSE_CANNON,
								  ChessMoveWay.SPECIAL_OBLIQUE_REVERSE_CANNON);
						break;
					case ChessType.Tp:
						//I
						ways.push(ChessMoveWay.SPECIAL_GLOBAL_TELEPORT_REQUIRED_LEVEL);
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE)));
						//III
						ways.push(new ChessMoveWay(
								new ChessWayPoint(3,0,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_DESTROY),
								new ChessWayPoint(2,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS),
								new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-3,0,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_DESTROY),
								new ChessWayPoint(-2,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS),
								new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,3,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_DESTROY),
								new ChessWayPoint(0,2,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS),
								new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,-3,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_DESTROY),
								new ChessWayPoint(0,-2,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS),
								new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,2,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_DESTROY),
								new ChessWayPoint(1,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,2,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_DESTROY),
								new ChessWayPoint(-1,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,-2,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_DESTROY),
								new ChessWayPoint(-1,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,-2,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_DESTROY),
								new ChessWayPoint(1,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								));
						break;
					case ChessType.Ts:
						ways.push(ChessMoveWay.SPECIAL_GLOBAL_SWAP);
						break;
					case ChessType.Wt:
						//I
						ways.push(new ChessMoveWay(
								new ChessWayPoint(2,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-2,0,ChessWayPointType.MOVE),
								new ChessWayPoint(0,2,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-2,ChessWayPointType.MOVE)));
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,1,ChessWayPointType.ATTACK),
								new ChessWayPoint(-1,1,ChessWayPointType.ATTACK),
								new ChessWayPoint(-1,-1,ChessWayPointType.ATTACK),
								new ChessWayPoint(1,-1,ChessWayPointType.ATTACK)));
						//III
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(2,0,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-2,0,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,2,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-2,ChessWayPointType.CONDITION,null,ChessMoveCondition.HAS_CHESS)
								));
						//IV
						ways.push(new ChessMoveWay(
								new ChessWayPoint(3,1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL,ChessMoveCondition.HAS_ENEMY_CHESS),
								new ChessWayPoint(3,-1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL,ChessMoveCondition.HAS_ENEMY_CHESS),
								new ChessWayPoint(2,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS),
								new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-3,-1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL,ChessMoveCondition.HAS_ENEMY_CHESS),
								new ChessWayPoint(-3,1,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL,ChessMoveCondition.HAS_ENEMY_CHESS),
								new ChessWayPoint(-2,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS),
								new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-1,3,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL,ChessMoveCondition.HAS_ENEMY_CHESS),
								new ChessWayPoint(1,3,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL,ChessMoveCondition.HAS_ENEMY_CHESS),
								new ChessWayPoint(0,2,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS),
								new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-1,-3,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL,ChessMoveCondition.HAS_ENEMY_CHESS),
								new ChessWayPoint(1,-3,ChessWayPointType.ATTACK,ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL,ChessMoveCondition.HAS_ENEMY_CHESS),
								new ChessWayPoint(0,-2,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS),
								new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								));
						break;
					case ChessType.Cw:
						ways.push(ChessMoveWay.SPECIAL_COPY_NEARBY_CHESS_WAYS);
						break;
					case ChessType.Cv:
						ways.push(ChessMoveWay.SPECIAL_COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL);
						break;
					case ChessType.Cl:
						ways.push(ChessMoveWay.SPECIAL_COPY_ALL_CHESS_WAYS);
						break;
					case ChessType.Cj:
						ways.push(ChessMoveWay.SPECIAL_CHAIN_JUMP);
						break;
					case ChessType.Ae:
						ways.push(ChessMoveWay.SPECIAL_OBLIQUE_THROUGH);
					case ChessType.Al:
						ways.push(ChessMoveWay.SPECIAL_STRAIGHT_THROUGH);
						break;
					case ChessType.Ia:
						ways.push(ChessMoveWay.SPECIAL_OBLIQUE_THROUGH);
						break;
					case ChessType.Kc:
						//I
						ways.push(new ChessMoveWay().appendGenereater(ChessWayPointGenerater.construct5(ChessWayPointGenerateType.SYMMETY_POINT,ChessWayPointType.MOVE)));
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,1,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,1,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,-1,ChessWayPointType.MOVE),
								new ChessWayPoint(1,-1,ChessWayPointType.MOVE)
								));
						//III
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(1,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(2,-1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-2,-1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								));
						break;
					case ChessType.Kx:
						//I
						ways.push(new ChessMoveWay().appendGenereater(ChessWayPointGenerater.construct5(ChessWayPointGenerateType.SYMMETY_POINT,ChessWayPointType.MOVE)));
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE),
								new ChessWayPoint(1,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,-1,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,-1,ChessWayPointType.MOVE_AND_ATTACK)
								));
						//III
						ways.push(new ChessMoveWay(
								new ChessWayPoint(2,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,0,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(0,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(-2,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(-1,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								),new ChessMoveWay(
								new ChessWayPoint(2,-2,ChessWayPointType.MOVE_AND_ATTACK),
								new ChessWayPoint(1,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								));
						break;
					case ChessType.Pw:
						//I
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE),
								new ChessWayPoint(1,1,ChessWayPointType.ATTACK),
								new ChessWayPoint(-1,1,ChessWayPointType.ATTACK),
								new ChessWayPoint(1,-1,ChessWayPointType.ATTACK),
								new ChessWayPoint(-1,-1,ChessWayPointType.ATTACK)
								));
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(2,0,ChessWayPointType.TELEPORT),
								new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								).margeCondition(ChessMoveCondition.SELF_LEVEL_GRANDER_THAN_ZERO),
								new ChessMoveWay(
								new ChessWayPoint(-2,0,ChessWayPointType.TELEPORT),
								new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								).margeCondition(ChessMoveCondition.SELF_LEVEL_GRANDER_THAN_ZERO),
								new ChessMoveWay(
								new ChessWayPoint(0,2,ChessWayPointType.TELEPORT),
								new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								).margeCondition(ChessMoveCondition.SELF_LEVEL_GRANDER_THAN_ZERO),
								new ChessMoveWay(
								new ChessWayPoint(0,-2,ChessWayPointType.TELEPORT),
								new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								).margeCondition(ChessMoveCondition.SELF_LEVEL_GRANDER_THAN_ZERO),
								new ChessMoveWay(
								new ChessWayPoint(2,0,ChessWayPointType.MOVE),
								new ChessWayPoint(1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								).margeCondition(ChessMoveCondition.SELF_NO_ACTION_DID),
								new ChessMoveWay(
								new ChessWayPoint(-2,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,0,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								).margeCondition(ChessMoveCondition.SELF_NO_ACTION_DID),
								new ChessMoveWay(
								new ChessWayPoint(0,2,ChessWayPointType.MOVE),
								new ChessWayPoint(0,1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								).margeCondition(ChessMoveCondition.SELF_NO_ACTION_DID),
								new ChessMoveWay(
								new ChessWayPoint(0,-2,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-1,ChessWayPointType.CONDITION,null,null,ChessMoveCondition.HAS_CHESS)
								).margeCondition(ChessMoveCondition.SELF_NO_ACTION_DID));
						break;
					case ChessType.Kl:
						//I
						ways.push(new ChessMoveWay().appendGenereater(ChessWayPointGenerater.construct5(ChessWayPointGenerateType.SYMMETY_POINT,ChessWayPointType.MOVE_AND_ATTACK)));
						//II
						ways.push(new ChessMoveWay(
								new ChessWayPoint(1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(-1,0,ChessWayPointType.MOVE),
								new ChessWayPoint(0,1,ChessWayPointType.MOVE),
								new ChessWayPoint(0,-1,ChessWayPointType.MOVE)
								));
						break;
					case ChessType.So:
					case ChessType.St:
						break;
				}
				//Clear Original Point
				for each(way in ways)
				{
					way.removePoint(0,0);
					//way.clearEqualPoints();
				}
				//Add To List
				typeCurrents[type]=ways;
			}
		}
		
		public static function getWaysFromType(type:ChessType):Vector.<ChessMoveWay>
		{
			classInit();
			return typeCurrents[type] as Vector.<ChessMoveWay>;
		}
		
		//============Instance Variables============//
		protected var _wayPoints:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
		protected var _globalCondition:ChessMoveCondition=ChessMoveCondition.NULL;
		protected var _globalConditionNot:ChessMoveCondition=ChessMoveCondition.FULL;
		protected var _wayPointGeneraters:Vector.<ChessWayPointGenerater>=new Vector.<ChessWayPointGenerater>;
		
		//============Constructor Function============//
		public function ChessMoveWay(...points):void
		{
			var point:ChessWayPoint;
			for each(var i in points)
			{
				point=i as ChessWayPoint;
				if(point==null) continue;
				this.wayPoints.push(point);
			}
		}
		
		//============Instance Getter And Setter============//
		public function get wayPoints():Vector.<ChessWayPoint>
		{
			return this._wayPoints;
		}
		
		public function get wayPointCount():uint
		{
			return this.wayPoints.length;
		}
		
		public function get globalCondition():ChessMoveCondition
		{
			return this._globalCondition;
		}
		
		public function set globalCondition(value:ChessMoveCondition):void
		{
			this._globalCondition=value;
		}
		
		public function get globalConditionNot():ChessMoveCondition
		{
			return this._globalConditionNot;
		}
		
		public function set globalConditionNot(value:ChessMoveCondition):void
		{
			this._globalConditionNot=value;
		}
		
		public function get wayPointGeneraters():Vector.<ChessWayPointGenerater>
		{
			return this._wayPointGeneraters;
		}
		
		public function get wayPointGeneraterCount():uint
		{
			return this.wayPointGeneraters.length;
		}
		
		//============Instance Functions============//
		public function copyFrom(other:ChessMoveWay,clearSpecial:Boolean=false):ChessMoveWay
		{
			//Set
			var i:uint;
			//Point
			if(this.wayPointCount>0) this.removeAllPoint();
			for(i=0;i<other.wayPointCount;i++)
			{
				this._wayPoints.push(other.wayPoints[i].getCopy());
			}
			//Genereater
			if(this.wayPointGeneraterCount>0) this.removeAllGenereater();
			for(i=0;i<other.wayPointGeneraterCount;i++)
			{
				this._wayPoints.push(other.getGenereaterAt(i).getCopy());
			}
			//Condition
			this._globalCondition=other.globalCondition;
			this._globalConditionNot=other.globalConditionNot;
			//Special
			if(clearSpecial) this.clearSpecials();
			return this;
		}
		
		public function getCopy(clearSpecial:Boolean=false):ChessMoveWay
		{
			return new ChessMoveWay().copyFrom(this,clearSpecial);
		}
		
		public function clearSpecials():void
		{
			for each(var p:ChessWayPoint in this.wayPoints)
			{
				p.removeSpecial();
			}
		}
		
		public function margeCondition(condition:ChessMoveCondition):ChessMoveWay
		{
			this._globalCondition=condition;
			return this;
		}
		
		public function margeConditionNot(condition:ChessMoveCondition):ChessMoveWay
		{
			this._globalConditionNot=condition;
			return this;
		}
		
		//Functions About WayPoint
		public function addPoint(x:int,y:int,type:ChessWayPointType,specialEvent:ChessWayPointType=null):ChessMoveWay
		{
			this.wayPoints.push(new ChessWayPoint(x,y,type,specialEvent));
			return this;
		}
		
		public function addPointLine(x1:int,y1:int,x2:int,y2:int,
									 type:ChessWayPointType,
									 specialEvent:ChessWayPointType=null,
									 condition:ChessMoveCondition=null,
									 condition_not:ChessMoveCondition=null):ChessMoveWay
		{
			var xv:Number,yv:Number,memX:int,memY:int,distance:uint=Math.ceil(new Point(x1-x2,y1-y2).length);
			for(var i:uint=0;i<distance;i++)
			{
				xv=Math.round(x1*(distance-i)/distance+x2*(i/distance));
				yv=Math.round(y1*(distance-i)/distance+y2*(i/distance));
				if(xv==memX&&yv==memY) continue;
				this.wayPoints.push(new ChessWayPoint(xv,yv,type,specialEvent,condition,condition_not));
				memX=xv,memY=yv;
			}
			return this;
		}
		
		public function addPointSquare(x1:int,y1:int,x2:int,y2:int,
									  type:ChessWayPointType,
									  specialEvent:ChessWayPointType=null,
									  condition:ChessMoveCondition=null,
									  condition_not:ChessMoveCondition=null):ChessMoveWay
		{
			var xm:int=Math.max(x1,x2),xl:int=Math.min(x1,x2),ym:int=Math.max(y1,y2),yl:int=Math.min(y1,y2);
			for(var xv:int=xl;xv<=xm;xv++)
			{
				for(var yv:int=yl;yv<=ym;yv++)
				{
					this.wayPoints.push(new ChessWayPoint(xv,yv,type,specialEvent,condition,condition_not));
				}
			}
			return this;
		}
		
		public function removePoint(x:int,y:int):ChessMoveWay
		{
			if(this.wayPoints==null||this.wayPoints.length<1) return this;
			var p:ChessWayPoint=new ChessWayPoint(x,y,null);
			for(var i:int=this.wayPoints.length-1;i>=0;i--)
			{
				if(this.wayPoints[i].equals(p)) this.wayPoints.splice(i,1);
			}
			return this;
		}
		
		public function removeAllPoint():ChessMoveWay
		{
			this.wayPoints.splice(0,this.wayPoints.length);
			return this;
		}
		
		//Functions About WayPoint Generater
		public function getGenereaterAt(index:uint):ChessWayPointGenerater
		{
			return this.wayPointGeneraterCount>index?this.wayPointGeneraters[index]:null;
		}
		
		public function appendGenereater(genereater:ChessWayPointGenerater):ChessMoveWay
		{
			this._wayPointGeneraters.push(genereater);
			return this;
		}
		
		public function appendGenereaters(...genereaters):ChessMoveWay
		{
			for(var i:uint=0;i<genereaters.length;i++)
			{
				if(genereaters[i] is ChessWayPointGenerater)
				{
					this._wayPointGeneraters.push(genereaters[i] as ChessWayPointGenerater);
				}
			}
			return this;
		}
		
		public function removeAllGenereater():void
		{
			this.wayPointGeneraters.splice(0,this.wayPointGeneraterCount);
		}
	}
}