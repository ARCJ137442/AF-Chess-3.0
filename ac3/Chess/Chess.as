package ac3.Chess 
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.Way.*;
	import ac3.Game.*;
	import ac3.AI.*;
	import ac3.AI.Functions.*;
	
	//Flash
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BlendMode;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	//============Class Chess============//
	public class Chess extends Sprite implements IChessAbstruct
	{
		//============Static Variables============//
		public static const FRAME_SIZE_PERCENT:uint=5;//%
		public static const DEFAULT_SIZE_X:uint=100;
		public static const DEFAULT_SIZE_Y:uint=100;
		public static const DEFAULT_LIFE_USING_ON_MOVE:uint=0;
		public static const DEFAULT_LIFE_USING_ON_TRUN:uint=0;
		
		public static const STRING_DELIM:String=",";
		
		protected static var nowUUID:uint=1;//0 means null
		
		//============Static Functions============//
		//====Tools====//
		public static function deleteEqualMoveWayInWays(way:ChessMoveWay,ways:Vector.<ChessMoveWay>):void
		{
			if(ways==null||ways.length<1) return;
			for(var i:int=ways.length-1;i>=0;i--)
			{
				if(ways[i]==way)
				{
					ways.splice(i,1);
				}
			}
			return;
		}
		
		public static function copyMoveWays(moveWays:Vector.<ChessMoveWay>,withoutSpecial:Boolean=false):Vector.<ChessMoveWay>
		{
			var result:Vector.<ChessMoveWay>=new Vector.<ChessMoveWay>;
			for(var i:uint=0;i<moveWays.length;i++)
			{
				result.push(moveWays[i].getCopy(withoutSpecial));
			}
			return result;
		}
		
		public static function copyWayPoints(points:Vector.<ChessWayPoint>):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			for(var i:uint=0;i<points.length;i++)
			{
				result.push(points[i].getCopy());
			}
			return result;
		}
		
		public static function localWayPointsToGlobalWayPoints(points:Vector.<ChessWayPoint>,centerX:int,centerY:int):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			if(points==null||points.length<1) return result;
			var tempPoint:ChessWayPoint;
			for(var i:uint=0;i<points.length;i++)
			{
				tempPoint=points[i];
				result.push(tempPoint.getCopyAndMargePosition(tempPoint.x+centerX,tempPoint.y+centerY));
			}
			return result;
		}
		
		public static function globalWayPointsToLocalWayPoints(points:Vector.<ChessWayPoint>,centerX:int,centerY:int):Vector.<ChessWayPoint>
		{
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			var tempPoint:ChessWayPoint;
			for(var i:uint=0;i<points.length;i++)
			{
				tempPoint=points[i];
				result.push(tempPoint.getCopyAndMargePosition(tempPoint.x-centerX,tempPoint.y-centerY));
			}
			return result;
		}
		
		public static function checkConditionAt(chess:Chess,checkX:int,checkY:int,checkOwner:ChessPlayer,condition:ChessMoveCondition):Boolean
		{
			//Need Full
			if(condition==null) return true;
			//Set Temp Variables
			var hasChess:Boolean=chess.board.hasChessAt(checkX,checkY);
			var targetChess:Chess=chess.board.getChessAt(checkX,checkY);
			var tempOwner:ChessPlayer=chess.board.getChessOwnerAt(checkX,checkY);
			//Get Result
			if(condition.chessSelfRequired&&condition.positionRequired)
			{
				//Indev
				switch(condition)
				{
					case ChessMoveCondition.HAS_ALLY_CHESS:
						return hasChess&&tempOwner==checkOwner;
					case ChessMoveCondition.HAS_OTHER_CHESS:
						return hasChess&&tempOwner!=checkOwner;
					case ChessMoveCondition.HAS_NON_ENEMY_CHESS:
						return hasChess&&(tempOwner==null||tempOwner==checkOwner);
					case ChessMoveCondition.HAS_ENEMY_CHESS:
						return hasChess&&tempOwner!=null&&tempOwner!=checkOwner;
					case ChessMoveCondition.HAS_SAME_TYPE_CHESS:
						return hasChess&&targetChess.type==chess.type;
					default:
						return true;
				}
			}
			//Need Chess Self
			else if(condition.chessSelfRequired)
			{
				return checkChessSelfCondition(chess,checkOwner,condition);
			}
			//Need Position
			else if(condition.positionRequired)
			{
				return checkPositionCondition(chess.board,checkX,checkY,condition);
			}
			//Need Nothing
			else
			{
				switch(condition)
				{
					case ChessMoveCondition.FULL:return false;
					default:
						return true;
				}
			}
			return true;
		}
		
		public static function checkPositionCondition(board:ChessBoard,checkX:int,checkY:int,condition:ChessMoveCondition):Boolean
		{
			//Set Temp Variables
			var hasChess:Boolean=board.hasChessAt(checkX,checkY);
			var tempOwner:ChessPlayer=board.getChessOwnerAt(checkX,checkY);
			//Get Result
			switch(condition)
			{
				case ChessMoveCondition.HAS_CHESS:
					return hasChess;
				case ChessMoveCondition.HAS_BLACK_CHESS:
					return hasChess&&tempOwner==null;
				default:
						throw new Error("checkPositionCondition:A not fit condition will be check!Arguments:"+arguments);
					return true;
			}
		}
		
		public static function checkChessSelfCondition(chess:Chess,checkOwner:ChessPlayer,condition:ChessMoveCondition):Boolean
		{
			switch(condition)
			{
				case ChessMoveCondition.SELF_LEVEL_GRANDER_THAN_ZERO:
					return chess.level>0;
				case ChessMoveCondition.SELF_LEVEL_EQUALS_ZERO:
					return chess.level==0;
				case ChessMoveCondition.SELF_NO_ACTION_DID:
					return chess.totalActionsDid==0;
				default:
						throw new Error("checkChessSelfCondition:A not fit condition will be check!Arguments:"+arguments);
					return true;
			}
		}
		
		public static function generateMovePlaces(chess:Chess,
												 moveWays:Vector.<ChessMoveWay>=null,
												 x:int=int.MIN_VALUE,
												 y:int=int.MIN_VALUE,
												 owner:ChessPlayer=null,
												 ignoreChessOnCurrentWayPoint:Boolean=false):Vector.<ChessWayPoint>
		{
			//Init Arguments
			if(x==int.MIN_VALUE) x=chess.boardX;
			if(y==int.MIN_VALUE) y=chess.boardY;
			if(owner==null) owner=chess.owner;
			if(moveWays==null) moveWays=chess.moveWays;
			//Set Main Variables
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			var host:ChessGame=chess.host;
			var board:ChessBoard=host.board;
			//Set Temp Variables
			var i:int,j:int;
			var mx:int,my:int,willAddList:Vector.<ChessWayPoint>;
			var tempChess:Chess;
			var tempCondition:ChessMoveCondition;
			var tempBoolean:Boolean;
			var tempBoolean2:Boolean;
			var tempPoint:ChessWayPoint;
			var tempWay:ChessMoveWay;
			var radius:uint;
			var throughChessCount:uint=0;
			var wayPointsInBoard:Vector.<ChessWayPoint>;
			var generatedWayPointsInBoard:Vector.<ChessWayPoint>;
			var totalWayPointsInBoard:Vector.<ChessWayPoint>;
			var tempGenerater:ChessWayPointGenerater;
			var tempGenerateFAPoint:ChessWayPoint;
			//Detect Before Generate
			if(chess==null||moveWays==null||moveWays.length<1)
			{
				//host.addLog("Chess/generateMovePlaces:Error at null!"+arguments);
				return result;
			}
			//Detect MovePlaces
			wayLoop:for each(tempWay in moveWays)
			{
				/*//Deal With Special MoveWays<Not Use>
				switch(tempWay)
				{
					//ALL_OF_BOARD
					case ChessMoveWay.ALL_OF_BOARD:
						result=result.concat(board.allWayPoints);
						continue;
						break;
					//LINE&CANNON&THROUGH
					case ChessMoveWay.SPECIAL_STRAIGHT_LINE_MOVE:
					case ChessMoveWay.SPECIAL_STRAIGHT_LINE_ATTACK:
					case ChessMoveWay.SPECIAL_STRAIGHT_CANNON_MOVE:
					case ChessMoveWay.SPECIAL_STRAIGHT_CANNON_ATTACK:
					case ChessMoveWay.SPECIAL_OBLIQUE_LINE_MOVE:
					case ChessMoveWay.SPECIAL_OBLIQUE_LINE_ATTACK:
					case ChessMoveWay.SPECIAL_OBLIQUE_CANNON_MOVE:
					case ChessMoveWay.SPECIAL_OBLIQUE_CANNON_ATTACK:
					case ChessMoveWay.SPECIAL_STRAIGHT_THROUGH:
					case ChessMoveWay.SPECIAL_OBLIQUE_THROUGH:
						//Set tempBoolean as the way is use for Attack
						tempBoolean=ChessMoveWay.isLinedAttackSpecialWay(tempWay);
						//Loop Of Every Line
						for(j=0;j<4;j++)
						{
							//Set throughChessCount as the count of through Chesses
							throughChessCount=0;
							//Loop Per Line
							for(i=1;i<=board.boardSizeX*board.boardSizeY;i++)
							{
								if(ChessMoveWay.isObliqueSpecialWay(tempWay))
								{
									//0,1:LU&LD
									//2,3:RU&RD
									mx=x+(j<2?-i:i);
									my=y+(j%2==0?-i:i);
								}
								else
								{
									//0,1:Up&Down
									//2,3:Left&Right
									mx=x+(j>1?1:0)*(j%2==0?-i:i);
									my=y+(j<2?1:0)*(j%2==0?-i:i);
								}
								if(!board.isInBoard(mx,my)) break;
								//Set
								tempChess=board.getChessAt(mx,my);
								//Line
								if(ChessMoveWay.isLineSpecialWay(tempWay))
								{
									if(ignoreChessOnCurrentWayPoint)
									{
										result.push(new ChessWayPoint(mx,my,ChessWayPointType.MOVE_AND_ATTACK))
									}
									else if(tempChess!=null)
									{
										if(tempBoolean&&checkConditionAt(chess,mx,my,owner,ChessMoveCondition.HAS_OTHER_CHESS))
										{
											result.push(new ChessWayPoint(mx,my,ChessWayPointType.ATTACK));
										}
										break;
									}
									else if(!tempBoolean)
									{
										result.push(new ChessWayPoint(mx,my,ChessWayPointType.MOVE_AND_ATTACK));
									}
								}
								//Cannon
								else if(ChessMoveWay.isCannonSpecialWay(tempWay))
								{
									if(tempChess!=null)
									{
										if(tempBoolean&&throughChessCount==1)
										{
											if(ignoreChessOnCurrentWayPoint||
											   checkConditionAt(chess,mx,my,owner,ChessMoveCondition.HAS_OTHER_CHESS))
											{
												result.push(new ChessWayPoint(mx,my,ChessWayPointType.ATTACK));
											}
											if(!ignoreChessOnCurrentWayPoint) break;
										}
										throughChessCount++;
									}
									else if(!tempBoolean&&throughChessCount==1)
									{
										result.push(new ChessWayPoint(mx,my,ChessWayPointType.MOVE));
									}
								}
								//Through
								else if(ChessMoveWay.isThroughSpecialWay(tempWay))
								{
									if(tempChess!=null)
									{
										if(!checkConditionAt(chess,mx,my,owner,ChessMoveCondition.HAS_ENEMY_CHESS))
										{
											continue;
										}
										result.push(new ChessWayPoint(mx,my,ChessWayPointType.MOVE_THROUGH_CHESSES));
										throughChessCount++;
									}
									else
									{
										result.push(new ChessWayPoint(mx,my,ChessWayPointType.MOVE_THROUGH_CHESSES));
										break;
									}
								}
								//Error
								else
								{
									host.addLog("Chess/generateMovePlaces:Unknown Way In Line Special!");
								}
							}
						}
						continue;
						break;
					//GLOBAL_TELEPORT_REQUIRED_LEVEL
					case ChessMoveWay.SPECIAL_GLOBAL_TELEPORT_REQUIRED_LEVEL:
						if(chess.level<1) continue;
						for each(tempPoint in board.allWayPoints)
						{
							if(!board.hasChessAt(tempPoint.x,tempPoint.y))
							{
								result.push(new ChessWayPoint(tempPoint.x,tempPoint.y,ChessWayPointType.TELEPORT));
							}
						}
						continue;
						break;
					//SPECIAL_GLOBAL_SWAP
					case ChessMoveWay.SPECIAL_GLOBAL_SWAP:
						for each(tempChess in board.allChesses)
						{
							if(tempChess!=chess)
							{
								result.push(new ChessWayPoint(tempChess.boardX,tempChess.boardY,ChessWayPointType.SWAP));
							}
						}
						continue;
						break;
					//SPECIAL_COPY_NEARBY_CHESS_WAYS
					//SPECIAL_COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL
					case ChessMoveWay.SPECIAL_COPY_NEARBY_CHESS_WAYS:
					case ChessMoveWay.SPECIAL_COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL:
						radius=tempWay==ChessMoveWay.SPECIAL_COPY_NEARBY_CHESS_WAYS?1:chess.level+1;
						for(mx=-radius;mx<=radius;mx++)
						{
							for(my=-radius;my<=radius;my++)
							{
								//Detect
								if(mx==0&&my==0) continue;
								tempChess=board.getChessAt(x+mx,y+my);
								if(tempChess==null||
								   tempChess.moveWays.indexOf(ChessMoveWay.SPECIAL_COPY_NEARBY_CHESS_WAYS)>=0||
								   tempChess.moveWays.indexOf(ChessMoveWay.SPECIAL_COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL)>=0||
								   tempChess.moveWays.indexOf(ChessMoveWay.SPECIAL_COPY_ALL_CHESS_WAYS)>=0||
								   tempWay==ChessMoveWay.SPECIAL_COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL&&
								   tempChess.owner!=owner)
								{
									continue;
								}
								//Start Copy
								result=result.concat(Chess.generateMovePlaces(chess,tempChess.moveWays,x,y,owner,ignoreChessOnCurrentWayPoint));
							}
						}
						continue;
						break;
					//SPECIAL_COPY_ALL_CHESS_WAYS
					case ChessMoveWay.SPECIAL_COPY_ALL_CHESS_WAYS:
						for each(tempChess in chess.board.allChesses)
						{
							//Detect
							if(tempChess==null||
							   tempChess.moveWays.indexOf(ChessMoveWay.SPECIAL_COPY_NEARBY_CHESS_WAYS)>=0||
							   tempChess.moveWays.indexOf(ChessMoveWay.SPECIAL_COPY_ALL_CHESS_WAYS)>=0)
							{
								continue;
							}
							//Start Copy
							result=result.concat(Chess.generateMovePlaces(chess,tempChess.moveWays,x,y,owner,ignoreChessOnCurrentWayPoint));
						}
						continue;
						break;
					//SPECIAL_CHAIN_JUMP
					case ChessMoveWay.SPECIAL_CHAIN_JUMP:
						result=result.concat(generateChainJumpWayPoints(chess,x,y,owner));
						continue;
						break;
				}*/
				//Generate WayPoints
				generatedWayPointsInBoard=new Vector.<ChessWayPoint>;
				if(tempWay.wayPointGeneraterCount>0)
				{
					for each(tempGenerater in tempWay.wayPointGeneraters)
					{
						if(tempGenerater==null) continue;
						tempGenerateFAPoint=tempGenerater.firstArgumentPoint;
						switch(tempGenerater.generateType)
						{
							//ALL_OF_BOARD
							case ChessWayPointGenerateType.ALL_OF_BOARD:
								generatedWayPointsInBoard=generatedWayPointsInBoard.concat(board.fillWayPoints(tempGenerateFAPoint));
								break;
							//ALL_OF_BOARD
							case ChessWayPointGenerateType.ALL_OVER_CHESS:
								generatedWayPointsInBoard=generatedWayPointsInBoard.concat(board.getAllChessesWayPointWith(tempGenerateFAPoint.getCopyAndMargePosition(x,y)));
								break;
							//LINE&CANNON&THROUGH
							case ChessWayPointGenerateType.STRAIGHT_LINE_MOVE:
							case ChessWayPointGenerateType.STRAIGHT_LINE_ATTACK:
							case ChessWayPointGenerateType.STRAIGHT_CANNON_MOVE:
							case ChessWayPointGenerateType.STRAIGHT_CANNON_ATTACK:
							case ChessWayPointGenerateType.OBLIQUE_LINE_MOVE:
							case ChessWayPointGenerateType.OBLIQUE_LINE_ATTACK:
							case ChessWayPointGenerateType.OBLIQUE_CANNON_MOVE:
							case ChessWayPointGenerateType.OBLIQUE_CANNON_ATTACK:
							case ChessWayPointGenerateType.STRAIGHT_THROUGH:
							case ChessWayPointGenerateType.OBLIQUE_THROUGH:
								//Set tempBoolean as the way is use for Attack
								tempBoolean=ChessWayPointGenerateType.isLinedAttackSpecialType(tempGenerater.generateType);
								//Loop Of Every Line
								for(j=0;j<4;j++)
								{
									//Set throughChessCount as the count of through Chesses
									throughChessCount=0;
									//Loop Per Line
									for(i=1;i<=board.boardSizeX*board.boardSizeY;i++)
									{
										if(ChessWayPointGenerateType.isObliqueSpecialType(tempGenerater.generateType))
										{
											//0,1:LU&LD
											//2,3:RU&RD
											mx=x+(j<2?-i:i);
											my=y+(j%2==0?-i:i);
										}
										else
										{
											//0,1:Up&Down
											//2,3:Left&Right
											mx=x+(j>1?1:0)*(j%2==0?-i:i);
											my=y+(j<2?1:0)*(j%2==0?-i:i);
										}
										if(!board.isInBoard(mx,my)) break;
										//Set
										tempChess=board.getChessAt(mx,my);
										//Line
										if(ChessWayPointGenerateType.isLineSpecialType(tempGenerater.generateType))
										{
											if(ignoreChessOnCurrentWayPoint)
											{
												generatedWayPointsInBoard.push(tempGenerateFAPoint.getCopyAndMargePosition(mx,my))
											}
											else if(tempChess!=null)
											{
												if(tempBoolean&&checkConditionAt(chess,mx,my,owner,ChessMoveCondition.HAS_OTHER_CHESS))
												{
													generatedWayPointsInBoard.push(tempGenerateFAPoint.getCopyAndMargePosition(mx,my));
												}
												break;
											}
											else if(!tempBoolean)
											{
												generatedWayPointsInBoard.push(tempGenerateFAPoint.getCopyAndMargePosition(mx,my));
											}
										}
										//Cannon
										else if(ChessWayPointGenerateType.isCannonSpecialType(tempGenerater.generateType))
										{
											if(tempChess!=null)
											{
												if(tempBoolean&&throughChessCount==1)
												{
													if(ignoreChessOnCurrentWayPoint||
													   checkConditionAt(chess,mx,my,owner,ChessMoveCondition.HAS_OTHER_CHESS))
													{
														generatedWayPointsInBoard.push(tempGenerateFAPoint.getCopyAndMargePosition(mx,my));
													}
													if(!ignoreChessOnCurrentWayPoint) break;
												}
												throughChessCount++;
											}
											else if(!tempBoolean&&throughChessCount==1)
											{
												generatedWayPointsInBoard.push(tempGenerateFAPoint.getCopyAndMargePosition(mx,my));
											}
										}
										//Through
										else if(ChessWayPointGenerateType.isThroughSpecialType(tempGenerater.generateType))
										{
											if(tempChess!=null)
											{
												if(!checkConditionAt(chess,mx,my,owner,ChessMoveCondition.HAS_ENEMY_CHESS))
												{
													continue;
												}
												generatedWayPointsInBoard.push(tempGenerateFAPoint.getCopyAndMargePosition(mx,my));
												throughChessCount++;
											}
											else
											{
												generatedWayPointsInBoard.push(tempGenerateFAPoint.getCopyAndMargePosition(mx,my));
												break;
											}
										}
										//Error
										else
										{
											host.addLog("Chess/generateMovePlaces:Unknown Way In Line Special!");
										}
									}
								}
								continue;
								break;
							//COPY_NEARBY_CHESS_WAYS
							//COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL
							case ChessWayPointGenerateType.COPY_NEARBY_CHESS_WAYS:
							case ChessWayPointGenerateType.COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL:
								radius=tempGenerater.generateType==ChessWayPointGenerateType.COPY_NEARBY_CHESS_WAYS?1:chess.level+1;
								for(mx=-radius;mx<=radius;mx++)
								{
									for(my=-radius;my<=radius;my++)
									{
										//Detect
										if(mx==0&&my==0) continue;
										tempChess=board.getChessAt(x+mx,y+my);
										if(tempChess==null||!ChessType.getCanBeCopyWay(tempChess.type)||
										   tempGenerater.generateType==ChessWayPointGenerateType.COPY_NEARBY_ALLY_CHESS_WAYS_BY_LEVEL&&
										   tempChess.owner!=owner)
										{
											continue;
										}
										//Start Copy
										generatedWayPointsInBoard=generatedWayPointsInBoard.concat(Chess.generateMovePlaces(chess,tempChess.moveWays,x,y,owner,ignoreChessOnCurrentWayPoint));
									}
								}
								break;
							//COPY_ALL_CHESS_WAYS
							case ChessWayPointGenerateType.COPY_ALL_CHESS_WAYS:
								for each(tempChess in chess.board.allChesses)
								{
									//Detect
									if(tempChess==null||!ChessType.getCanBeCopyWay(tempChess.type))
									{
										continue;
									}
									//Start Copy
									generatedWayPointsInBoard=generatedWayPointsInBoard.concat(Chess.generateMovePlaces(chess,tempChess.moveWays,x,y,owner,ignoreChessOnCurrentWayPoint));
								}
								break;
							//CHAIN_JUMP
							case ChessWayPointGenerateType.CHAIN_JUMP:
								generatedWayPointsInBoard=generatedWayPointsInBoard.concat(generateChainJumpWayPoints(chess,x,y,owner));
								break;
							//SYMMETY_POINT
							case ChessWayPointGenerateType.SYMMETY_POINT:
								var syPoint:Point=board.getSymmetryPoint(x,y);
								generatedWayPointsInBoard.push(tempGenerateFAPoint.getCopyAndMargePosition(syPoint.x,syPoint.y));
								break;
						}
					}
				}
				//Normal Ways
				willAddList=new Vector.<ChessWayPoint>;
				//Start Detect Way Points
				wayPointsInBoard=localWayPointsToGlobalWayPoints(tempWay.wayPoints,x,y);
				totalWayPointsInBoard=wayPointsInBoard.concat(generatedWayPointsInBoard);
				if(totalWayPointsInBoard==null||totalWayPointsInBoard.length<1) continue;
				pointLoop:for each(tempPoint in totalWayPointsInBoard)
				{
					if(tempPoint==null) continue;
					mx=tempPoint.x;
					my=tempPoint.y;
					tempChess=board.getChessAt(mx,my);
					tempBoolean2=board.hasChessAt(mx,my);
					if(!board.isInBoard(mx,my)) continue;
					//Continue pointLoop means the point isn't will be add to list
					//Continue wayLoop means all points of the way isn't will be add to list
					for(i=0;i<2;i++)
					{
						//0=condition,1=condition_not
						//Check Way Conditions
						tempCondition=(i==1?tempWay.globalConditionNot:tempWay.globalCondition);
						tempBoolean2=(Boolean(i)==(checkConditionAt(chess,mx,my,owner,tempCondition)));
						if(tempBoolean2)
						{
							continue pointLoop;
						}
						//Check Point Conditions
						tempCondition=(i==1?tempPoint.condition_not:tempPoint.condition);//Not Will Be Boolean
						if(tempCondition==null) continue;
						tempBoolean2=(Boolean(i)==(checkConditionAt(chess,mx,my,owner,tempCondition)));
						//If Not
						if(tempBoolean2)
						{
							if(tempPoint.type==ChessWayPointType.CONDITION) continue wayLoop;
							else continue pointLoop;
						}
					}
					//Check Special Ability
					switch(tempPoint.moveSpecialAbility)
					{
						//Need To Attack
						case ChessWayPointType.SPECIAL_MIND_CONTOL:
							if(board.hasChessAt(mx,my)&&
							   ChessType.getCanBeMindContol(tempChess.type)&&
							   tempChess.hasBeMindContol||
							   board.getChessOwnerAt(mx,my)==owner)
							{
								continue pointLoop;
							}
							break;
						case ChessWayPointType.SPECIAL_DESTROY:
							if(!board.hasChessAt(mx,my)) continue pointLoop;
							break;
						//Need To Move
						case ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS:
							if(board.hasChessAt(mx,my)) continue pointLoop;
							break;
					}
					//Detect Current Place And Push
					tempBoolean2=board.hasChessAt(mx,my);
					if(ignoreChessOnCurrentWayPoint) willAddList.push(tempPoint);
					else switch(tempPoint.type)
					{
						case ChessWayPointType.NULL:
						case ChessWayPointType.THROUGH:
							willAddList.push(tempPoint);
							break;
						case ChessWayPointType.MOVE:
						case ChessWayPointType.TELEPORT:
							if(tempBoolean2) continue pointLoop;
							else willAddList.push(tempPoint);
							break;
						case ChessWayPointType.ATTACK:
							if(checkConditionAt(chess,mx,my,owner,ChessMoveCondition.HAS_ALLY_CHESS)) continue pointLoop;
						case ChessWayPointType.SWAP:
							if(!tempBoolean2) continue pointLoop;
							else willAddList.push(tempPoint);
							break;
						case ChessWayPointType.ABSORPTION_LEVEL:
							if(!tempBoolean2||tempChess.level<1) continue pointLoop;
							else willAddList.push(tempPoint);
							break;
						case ChessWayPointType.TRANSFER_LEVEL:
							if(!tempBoolean2||chess.level<1) continue pointLoop;
							else willAddList.push(tempPoint);
							break;
						case ChessWayPointType.MOVE_AND_ATTACK:
							if(checkConditionAt(chess,mx,my,owner,ChessMoveCondition.HAS_ALLY_CHESS)) continue pointLoop;
							willAddList.push(tempPoint);
							break;
					}
				}
				//Add Points
				result=result.concat(willAddList);
			}
			//Final Filter
			for(i=result.length-1;i>=0;i--)
			{
				tempPoint=result[i];
				mx=tempPoint.x;
				my=tempPoint.y;
				//Immune Attack Filter
				if(ChessType.getImmuneActions(board.getChessTypeAt(mx,my))||
				   tempPoint.canCaptureChess&&
				   checkPositionCondition(board,mx,my,ChessMoveCondition.HAS_BLACK_CHESS)&&
				   !ChessType.getCanBeCapture(board.getChessTypeAt(mx,my)))
				{
					result.splice(i,1);
				}
			}
			//Return
			return result;
		}
		
		public static function generateChainJumpWayPoints(chess:Chess,
														 x:int=int.MIN_VALUE,
														 y:int=int.MIN_VALUE,
														 owner:ChessPlayer=null,
														 wayPointMemory:Vector.<ChessWayPoint>=null):Vector.<ChessWayPoint>
		{
			//Define Result
			var result:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			//Detect
			if(chess==null) return result;
			//Init Arguments
			if(x==int.MIN_VALUE) x=chess.boardX;
			if(y==int.MIN_VALUE) y=chess.boardY;
			if(owner==null) owner=chess.owner;
			if(wayPointMemory==null) wayPointMemory=new Vector.<ChessWayPoint>;
			//Define Temp Variables
			var detectX:int,detectY:int;
			var moveX:int,moveY:int;
			var moveWayPoint:ChessWayPoint;
			//Start Operate
			for(var vx:int=-1;vx<2;vx++)
			{
				for(var vy:int=-1;vy<2;vy++)
				{
					if(vx==0&&vy==0)
					{
						continue;
					}
					detectX=x+vx;
					detectY=y+vy;
					//Check
					if(!checkPositionCondition(chess.board,detectX,detectY,ChessMoveCondition.HAS_CHESS))
					{
						continue;
					}
					//Define move Position
					moveX=x+vx*2;
					moveY=y+vy*2;
					if(!chess.board.isInBoard(moveX,moveY)||ChessAITools.pointInPoints2(moveX,moveY,wayPointMemory))
					{
						continue;
					}
					moveWayPoint=new ChessWayPoint(moveX,moveY,ChessWayPointType.MOVE_AND_ATTACK);
					//Check II
					if(checkConditionAt(chess,moveX,moveY,owner,ChessMoveCondition.HAS_NON_ENEMY_CHESS))
					{
						continue;
					}
					//Add Point
					result.push(moveWayPoint);
					wayPointMemory.push(moveWayPoint);
					//Check III
					if(checkPositionCondition(chess.board,moveX,moveY,ChessMoveCondition.HAS_CHESS))
					{
						continue;
					}
					//Callee
					result=result.concat(generateChainJumpWayPoints(chess,moveWayPoint.x,moveWayPoint.y,owner,wayPointMemory));
				}
			}
			//Return Result
			return result;
		}
		
		//====API====//
		public static function fromInformation(host:ChessGame,information:String,delim:String=STRING_DELIM):Chess
		{
			if(General.isEmptyChar(information)) return null;
			return new Chess(host,0,0,ChessType.NULL,null).loadByInformation(information,delim);
		}
		
		public static function fromAbstruct(host:ChessGame,abstruct:IChessAbstruct):Chess
		{
			return new Chess(host,abstruct.boardX,abstruct.boardY,abstruct.type,abstruct.owner)
		}
		
		//============Instance Variables============//
		protected var _host:ChessGame;
		
		protected var _uuid:uint;
		protected var _isActive:Boolean=true;
		
		protected var _base:Shape=new Shape();
		protected var _overlay:ChessOverlay=new ChessOverlay();
		protected var _displayTexts:ChessDisplayTexts=new ChessDisplayTexts();
		
		protected var _boardX:int=-1;
		protected var _boardY:int=-1;
		protected var _originalColor:uint=0x000000;
		protected var _type:ChessType=ChessType.NULL;
		protected var _originalOwner:ChessPlayer;
		protected var _moveWays:Vector.<ChessMoveWay>;
		protected var _mindContolChesses:Vector.<Chess>=new Vector.<Chess>;
		protected var _beMindContolOf:Chess;
		protected var _level:uint=0;
		protected var _life:uint=10;
		protected var _importment:Boolean=false;
		
		public var lifeUsingOnMove:int=DEFAULT_LIFE_USING_ON_MOVE;
		public var lifeUsingOnTurn:int=DEFAULT_LIFE_USING_ON_TRUN;
		
		public var levelGenerateOnTrun:int=0;
		public var levelGenerateLimit:int=-1;
		
		public var actionDidInTrun:uint=0;
		public var totalActionsDid:uint=0;
		
		//============Constructor Function============//
		public function Chess(host:ChessGame,x:int,y:int,
							 type:ChessType,owner:ChessPlayer,color:int=-1):void
		{
			//Set UUID
			this._uuid=Chess.nowUUID;
			Chess.nowUUID++;
			//Set Variable
			this._host=host;
			this._type=type;
			this._originalOwner=owner;
			this._originalColor=this.owner!=null?this.owner.color:(color>=0?color:ChessPlayer.NULL_COLOR);
			//Set Display
			this.boardX=x;
			this.boardY=y;
			//Set Attributes
			this.tabEnabled=true;
			//this._displayTexts.blendMode=BlendMode.INVERT;
			updateDisplay();
			updateMoveWaysByType();
			this.addChild(this._base);
			this.addChild(this._overlay);
			this.addChild(this._displayTexts);
			//Add Event Listener
			this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
		}
		
		//============Destructor Function============//
		public function deleteRefences():void
		{
			removeChilds();
			this.releaseAllMindContol();
			this._isActive=false;
			this._type=null;
			this._originalColor=0;
			this._originalOwner=null;
			this._importment=false;
			this._life=0;
			this._level=0;
			this._mindContolChesses=null
			this._base=null;
			this._displayTexts=null;
			this._overlay=null;
			this.actionDidInTrun=0;
			this.moveWays=null;
			this._host=null;
		}
		
		protected function removeChilds():void
		{
			while(this.numChildren>0) this.removeChildAt(0);
		}
		
		//============Instance Getter And Setter============//
		public function get host():ChessGame
		{
			return this._host;
		}
		
		public function get board():ChessBoard
		{
			return this.host.board;
		}
		
		public function get displaySizeX():Number
		{
			return this.board.chessDisplayWidth;
		}
		
		public function get displaySizeY():Number
		{
			return this.board.chessDisplayHeight;
		}
		
		public function get overlayDisplayAsText():Boolean
		{
			return this._overlay.displayAsText;
		}
		
		public function set overlayDisplayAsText(value:Boolean):void
		{
			this._overlay.displayAsText=value;
		}
		
		public function get boardX():int
		{
			return this._boardX;//board.lockX(value);
		}
		
		public function set boardX(value:int):void
		{
			this._boardX=value;
			this.x=board.unlockX(this._boardX);
		}
		
		public function get boardY():int
		{
			return this._boardY;//board.lockY(this.y);
		}
		
		public function set boardY(value:int):void
		{
			this._boardY=value;
			this.y=board.unlockY(this._boardY);
		}
		
		public function get boardPoint():Point
		{
			return new Point(this.boardX,this.boardY);
		}
		
		public function get boardWayPoint():ChessWayPoint
		{
			return new ChessWayPoint(this.boardX,this.boardY,ChessWayPointType.NULL);
		}
		
		public function get color():uint
		{
			return this.owner!=null&&this.owner.lockChessColor?this.owner.color:this._originalColor;
		}
		
		public function set color(value:uint):void
		{
			if(this._originalColor==value) return;
			if(!this.hasBeMindContol) this._originalColor=value;
			updateDisplay(true,false,false);
		}
		
		public function get type():ChessType
		{
			return this._type;
		}
		
		public function set type(value:ChessType):void
		{
			if(this._type==value) return;
			this._type=value;
			updateDisplay(false,true,false);
		}
		
		public function get isUnknownType():Boolean
		{
			return (this.type==ChessType.NULL||this.type==ChessType.Ra)
		}
		
		public function get captureable():Boolean
		{
			return this.owner==null&&!ChessType.getOnlyBeAttack(this.type)&&ChessType.getCanBeCapture(this.type);
		}
		
		public function get owner():ChessPlayer
		{
			//Be Changed By MindContol
			return this.hasBeMindContol?this._beMindContolOf.owner:this._originalOwner;
		}
		
		public function set owner(value:ChessPlayer):void
		{
			if(value!=this.owner&&this.hasBeMindContol)
			{
				this.releaseMindContolBy();
			}
			if(this._originalOwner==value) return;
			this._originalOwner=value;
			if(value!=null)
			{
				if(value.lockChessColor) this.color=value.color;
			}
			else
			{
				this.color=ChessPlayer.NULL_COLOR;
			}
			this.updateMindContol();
		}
		
		public function get ownerNum():uint
		{
			return this._host.getPlayerIndex(this.owner);
		}
		
		public function set ownerNum(value:uint):void
		{
			this.owner=this._host.getPlayerByModeAt(value);
		}
		
		public function get originalOwner():ChessPlayer
		{
			return this._originalOwner;
		}
		
		public function get hasOwner():Boolean
		{
			return this.owner!=null;
		}
		
		public function get activeInBoard():Boolean
		{
			return this.board.isActiveChess(this);
		}
		
		public function get moveWays():Vector.<ChessMoveWay>
		{
			return this._moveWays;
		}
		
		public function set moveWays(value:Vector.<ChessMoveWay>):void
		{
			if(value!=null) this._moveWays=value;
		}
		
		public function get beMindContolOf():Chess
		{
			return this._beMindContolOf;
		}
		
		public function set beMindContolOf(value:Chess):void
		{
			this._beMindContolOf=value;
			this.updateMindContol();
			this.updateDisplay(false,false,true);
		}
		
		public function get hasMindContol():Boolean
		{
			return this._mindContolChesses!=null&&this._mindContolChesses.length>0;
		}
		
		public function get hasBeMindContol():Boolean
		{
			return this._beMindContolOf!=null;
		}
		
		protected function get frameSize():Number
		{
			return FRAME_SIZE_PERCENT;
		}
		
		public function get level():uint 
		{
			return this._level;
		}
		
		public function set level(value:uint):void 
		{
			if(Math.min(this._level,this._host.rules.chessMaxLevel)==value) return;
			this._level=Math.min(value,this._host.rules.chessMaxLevel);
			updateDisplay(false,false,true);
		}
		
		public function get life():int 
		{
			return this._life;
		}
		
		public function set life(value:int):void 
		{
			if(this._life==value) return;
			//Add Life
			this._life=value;
			this._displayTexts.life=this._life;
			updateDisplay(false,false,true);
		}
		
		public function get importment():Boolean 
		{
			return this._importment;
		}
		
		public function set importment(value:Boolean):void 
		{
			if(this._importment!=value)
			{
				this._importment=value;
				updateDisplay(false,false,true);
			}
		}
		
		public function get scoreWeight():uint
		{
			return ChessType.getScoreWeight(this.type);
		}
		
		public function get score():uint
		{
			return this.level+this.scoreWeight;
		}
		
		//========Using For AI========//
		public function get canBeContol():Boolean
		{
			return this.life>0&&this.actionDidInTrun<this.host.rules.maxActionDoingPerChess&&this.hasMoveWay;
		}
		
		public function get hasMoveWay():Boolean
		{
			return this.getMovePlaces().length>0;
		}
		
		public function get harmfulWayPoints():Vector.<ChessWayPoint>
		{
			var _this:Chess=this;
			return this.getMovePlaces().filter(function(p:ChessWayPoint,i:uint,v:Vector.<ChessWayPoint>){
				return p.isHarmful&&_this.board.hasChessAt(p.x,p.y);
			});
		}
		
		public function get harmfulWayPointCount():uint
		{
			return this.harmfulWayPoints.length;
		}
		
		public function get onlyBeAttack():Boolean
		{
			return ChessType.getOnlyBeAttack(this.type);
		}
		
		public function get immuneActions():Boolean
		{
			return ChessType.getImmuneActions(this.type);
		}
		
		public function getSwapableToPlayer(player:ChessPlayer):Boolean
		{
			return this.type==null||this.owner==player&&this.type==ChessType.Ra;
		}
		
		//========Using For API========//
		public function get basicInformation():String
		{
			//Result
			var result:String="";
			//Loadin
			result+="x="+this.boardX+STRING_DELIM;
			result+="y="+this.boardY+STRING_DELIM;
			result+="owner="+this._host.getPlayerIndex(this.originalOwner)+STRING_DELIM;
			result+="type="+ChessType.getTypeName(this.type)+STRING_DELIM;
			result+="level="+this.level+STRING_DELIM;
			result+="life="+this.life+STRING_DELIM;
			result+="lifeUsingOnMove="+this.lifeUsingOnMove+STRING_DELIM;
			result+="lifeUsingOnTurn="+this.lifeUsingOnTurn+STRING_DELIM;
			result+="levelGenerateOnTrun="+this.levelGenerateOnTrun+STRING_DELIM;
			result+="levelGenerateLimit="+this.levelGenerateLimit+STRING_DELIM;
			result+="moveCountLeft="+this.actionDidInTrun+STRING_DELIM;
			result+="totalActionsDid="+this.totalActionsDid+STRING_DELIM;
			result+="importment="+this.importment;
			//Return
			return result;
		}
		
		public function loadByInformation(information:String,delim:String=STRING_DELIM):Chess
		{
			//Temp Variables
			var key:String;
			var value:String;
			var keyValueArr:Array;
			//Detect String
			if(information==null) return null;
			else if(information=="") return this;
			//Start Loading
			var valueArr:Array=information.split(delim);
			for each(var keyValueString:String in valueArr)
			{
				keyValueArr=keyValueString.split("=");
				key=keyValueArr[0];
				value=keyValueArr[1];
				switch(key)
				{
					case "x":
						this.boardX=parseInt(value);
						break;
					case "y":
						this.boardY=parseInt(value);
						break;
					case "owner":
						this.owner=this._host.getPlayerByModeAt(uint(value))
						break;
					case "type":
						this.type=ChessType.getTypeByName(value)
						break;
					case "level":
						this.level=parseInt(value);
						break;
					case "life":
						this.life=parseInt(value);
						break;
					case "lifeUsingOnMove":
						this.lifeUsingOnMove=parseInt(value);
						break;
					case "lifeUsingOnTurn":
						this.lifeUsingOnTurn=parseInt(value);
						break;
					case "levelGenerateOnTrun":
						this.levelGenerateOnTrun=parseInt(value);
						break;
					case "levelGenerateLimit":
						this.levelGenerateLimit=parseInt(value);
						break;
					case "moveCountLeft":
					case "actionDidInTrun":
						this.actionDidInTrun=parseInt(value);
						break;
					case "totalActionsDid":
						this.totalActionsDid=parseInt(value);
						break;
					case "importment":
						this.importment=(value=="true")?true:false;
						break;
				}
			}
			this.updateMoveWaysByType();
			//Return
			return this;
		}
		
		//============Instance Functions============//
		//========Initial Functions========//
		protected function onAddedToStage(event:Event):void
		{
			//Remove Event Listener
			this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			//Set
			if(this.host!=null) this.updateButtonModeByNowPlayer();
			this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
		}
		
		protected function onMouseClick(event:MouseEvent):void
		{
			//trace("Pressed!");
			this.host.clickByPoint(this.boardPoint,false);
		}
		
		public function updateDisplay(updateBase:Boolean=true,
									 updateOverlay:Boolean=true,
									 updateTexts:Boolean=true):void
		{
			//Set Base
			if(updateBase)
			{
				var color_hsv:Vector.<Number>=Color.HEXtoHSV(this.color);
				var color_dark:uint=Color.HSVtoHEX(color_hsv[0],color_hsv[1],color_hsv[2]-5);
				this._base.graphics.clear();
				this._base.graphics.beginFill(color_dark);
				this._base.graphics.drawRect(0,0,DEFAULT_SIZE_X,DEFAULT_SIZE_Y);
				this._base.graphics.endFill();
				this._base.graphics.beginFill(this.color);
				this._base.graphics.drawRect(this.frameSize,this.frameSize,DEFAULT_SIZE_X-2*this.frameSize,DEFAULT_SIZE_Y-2*this.frameSize);
				this._base.graphics.endFill();
			}
			//Set Overlay
			if(updateOverlay)
			{
				this._overlay.x=DEFAULT_SIZE_X/2;
				this._overlay.y=DEFAULT_SIZE_Y/2;
				this._overlay.setType(this._type);
				this._overlay.displayAsText=this.host.chessDisplayAsText;
			}
			//Set Texts
			if(updateTexts)
			{
				this._displayTexts.level=this._level;
				this._displayTexts.life=(this.lifeUsingOnMove!=0||this.lifeUsingOnTurn!=0)?this._life:-1;
				this._displayTexts.importment=this.importment;
				this._displayTexts.beMindContol=this.hasBeMindContol;
			}
			//Set Positions
			this.x=this.board.unlockX(this.boardX);
			this.y=this.board.unlockY(this.boardY);
			//Set Size
			this.scaleX=this.displaySizeX/DEFAULT_SIZE_X;
			this.scaleY=this.displaySizeY/DEFAULT_SIZE_Y;
		}
		
		//========Tool Functions========//
		public function usingLevel(value:int=1):void
		{
			if(value==0) return;
			this.level=Math.max(this.level-value,0);
		}
		
		public function usingLife(value:int=1):void
		{
			if(value==0) return;
			this.life=Math.max(this.life-value,0);
		}
		
		public function updateButtonMode(mode:Boolean):void
		{
			this.buttonMode=this.tabEnabled=mode;
		}
		
		public function updateButtonModeByPlayer(player:ChessPlayer):void
		{
			updateButtonMode(player==this.owner&&player.canContolByMouse);
		}
		
		public function updateButtonModeByNowPlayer():void
		{
			updateButtonModeByPlayer(this.host.nowPlayer);
		}
		
		//====Move Places====//
		public function updateMoveWaysByType():void
		{
			this._moveWays=ChessMoveWay.getWaysFromType(this._type);
			if(ChessType.getNeedCopyMoveWays(this.type))
			{
				this._moveWays=this._moveWays.concat();
			}
		}
		
		public function getMovePlaces(ignoreChessOnCurrentWayPoint:Boolean=false):Vector.<ChessWayPoint>//In Board
		{
			//Return as Static Function
			return Chess.generateMovePlaces(this,this.moveWays,this.boardX,this.boardY,this.owner,ignoreChessOnCurrentWayPoint);
		}
		
		public function getHarmfulMovePlaces(ignoreChessOnCurrentWayPoint:Boolean=false):Vector.<ChessWayPoint>
		{
			return this.getMovePlaces(ignoreChessOnCurrentWayPoint).filter(this.harmfulFilter);
		}
		
		protected function harmfulFilter(p:ChessWayPoint,i:uint,v:Vector.<ChessWayPoint>):Boolean
		{
			return p.isHarmful;
		}
		
		public function getRandomMovePlace():ChessWayPoint
		{
			var mps:Vector.<ChessWayPoint>=this.getMovePlaces();
			if(mps.length<1) return null;
			return mps[acMath.random(mps.length)];
		}
		
		public function drawMovePlaces(places:Vector.<ChessWayPoint>=null,
									   clear:Boolean=true):void
		{
			//Get
			if(places==null) places=this.getMovePlaces();
			//Clear
			if(clear) this.board.clearAllSelectPlace();
			//Var
			var addAfter:Boolean=false;
			//Draw
			for each(var point:ChessWayPoint in places)
			{
				if(point==null) continue;
				addAfter=true;
				switch(point.type)
				{
					case ChessWayPointType.SWAP:
						this.board.autoAddSelectPlace(point.x,point.y,-1,0x000000,this.color,ChessSelectPlaceType.RING,ChessSelectPlaceType.RING,ChessSelectPlaceType.RING);
						addAfter=false;
						break;
					case ChessWayPointType.ABSORPTION_LEVEL:
						this.board.autoAddSelectPlace(point.x,point.y,-1,0x000000,this.color,null,ChessSelectPlaceType.CIRCLE,null);
						addAfter=false;
						break;
					case ChessWayPointType.TRANSFER_LEVEL:
						this.board.autoAddSelectPlace(point.x,point.y,-1,0x000000,this.color,null,ChessSelectPlaceType.SQUARE,null);
						addAfter=false;
						break;
				}
				if(!addAfter) continue;
				switch(point.moveSpecialAbility)
				{
					case ChessWayPointType.SPECIAL_MIND_CONTOL:
						this.board.autoAddSelectPlace(point.x,point.y,-1,this.color,this.color,null,ChessSelectPlaceType.CIRCLE,null);
						break;
					case ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS:
						this.board.autoAddSelectPlace(point.x,point.y,this.color,this.color,this.color,ChessSelectPlaceType.SQUARE,null,null);
						break;
					case ChessWayPointType.SPECIAL_CREATE_MOVE_PLACES:
						this.board.autoAddSelectPlace(point.x,point.y,0x88ff88,-1,-1,ChessSelectPlaceType.DIAMOND,null,null);
						break;
					case ChessWayPointType.SPECIAL_INFLUENCE:
						this.board.autoAddSelectPlace(point.x,point.y,-1,this.color,this.color,null,ChessSelectPlaceType.X,null);
						break;
					case ChessWayPointType.SPECIAL_DESTROY:
						this.board.autoAddSelectPlace(point.x,point.y,-1,this.color,this.color,null,ChessSelectPlaceType.CROSS,null);
						break;
					case ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL:
						this.board.autoAddSelectPlace(point.x,point.y,-1,ChessPlayer.NULL_COLOR,this.color,null,ChessSelectPlaceType.CIRCLE,null);
						break;
					default:
						this.board.autoAddSelectPlace(point.x,point.y,-1,-1,this.color);
						break;
				}
			}
		}
		
		public function isInWay(x:int,y:int):Boolean
		{
			if(!this.board.isInBoard(x,y)) return false;
			var mP:Vector.<ChessWayPoint>=this.getMovePlaces();
			var point:ChessWayPoint=new ChessWayPoint(x,y,null);
			if(mP.length<1) return false;
			return mP.some(function(p:ChessWayPoint,i:uint,v:Vector.<ChessWayPoint>){
				return p.equals(point);
			});
		}
		
		public function getPointInWay(x:int,y:int,dontGetNull:Boolean=false):ChessWayPoint//In Board
		{
			if(!this.board.isInBoard(x,y)) return dontGetNull?new ChessWayPoint(x,y,null):null;
			var mP:Vector.<ChessWayPoint>=this.getMovePlaces(),point:ChessWayPoint=new ChessWayPoint(x,y,null);
			if(mP.length<1) return dontGetNull?new ChessWayPoint(x,y,null):null;
			for each(var p:ChessWayPoint in mP)
			{
				if(p.equals(point,true,false,false)) return p;
			}
			return dontGetNull?new ChessWayPoint(x,y,null):null;
		}
		
		public function createMovePlacesByWayPoint(point:ChessWayPoint):void
		{
			var way:ChessMoveWay=new ChessMoveWay(new ChessWayPoint(point.x,point.y,ChessWayPointType.MOVE_AND_ATTACK,point.moveSpecialAbility,point.condition,point.condition_not),
												  new ChessWayPoint(-point.x,point.y,ChessWayPointType.MOVE_AND_ATTACK,point.moveSpecialAbility,point.condition,point.condition_not),
												  new ChessWayPoint(-point.x,-point.y,ChessWayPointType.MOVE_AND_ATTACK,point.moveSpecialAbility,point.condition,point.condition_not),
												  new ChessWayPoint(point.x,-point.y,ChessWayPointType.MOVE_AND_ATTACK,point.moveSpecialAbility,point.condition,point.condition_not),
												  new ChessWayPoint(point.y,point.x,ChessWayPointType.MOVE_AND_ATTACK,point.moveSpecialAbility,point.condition,point.condition_not),
												  new ChessWayPoint(-point.y,point.x,ChessWayPointType.MOVE_AND_ATTACK,point.moveSpecialAbility,point.condition,point.condition_not),
												  new ChessWayPoint(-point.y,-point.x,ChessWayPointType.MOVE_AND_ATTACK,point.moveSpecialAbility,point.condition,point.condition_not),
												  new ChessWayPoint(point.y,-point.x,ChessWayPointType.MOVE_AND_ATTACK,point.moveSpecialAbility,point.condition,point.condition_not));
			this._moveWays.push(way);
		}
		
		public function copyMovePlacesFrom(chess:Chess,withoutSpecial:Boolean=false):void
		{
			this._moveWays=Chess.copyMoveWays(chess._moveWays,withoutSpecial);
		}
		
		//====Mind Contol====//
		public function hasMindContolOf(chess:Chess):Boolean
		{
			return this._mindContolChesses.indexOf(chess)>=0;
		}
		
		public function mindContol(chess:Chess):void
		{
			if(this.owner==chess.owner) return;
			if(chess.hasBeMindContol) chess.releaseMindContolBy();
			this._mindContolChesses.push(chess);
			chess.beMindContolOf=this;
		}
		
		protected function updateMindContol():void
		{
			//Update Self
			this.updateDisplay(true,false,true);
			if(!this.hasMindContol) return;
			//Update Down Level
			for each(var chess:Chess in this._mindContolChesses)
			{
				if(chess!=this&&chess.hasMindContol) chess.updateMindContol();
				chess.updateDisplay(true,false,true);
			}
		}
		
		public function releaseMindContolTo(chess:Chess):void
		{
			if(!this.hasMindContolOf(chess)) return;
			this._mindContolChesses.splice(this._mindContolChesses.indexOf(chess),1);
			chess.beMindContolOf=null;
		}
		
		public function releaseMindContolBy():void
		{
			if(!this.hasBeMindContol) return;
			this.beMindContolOf.releaseMindContolTo(this);
		}
		
		public function releaseAllMindContol():void
		{
			//Release
			for each(var chess:Chess in this._mindContolChesses)
			{
				chess.releaseMindContolBy();
			}
			//Delete
			this._mindContolChesses.splice(0,this._mindContolChesses.length);
			//Release II
			this.releaseMindContolBy();
		}
		
		//========Tool Functions========//
		public function distanceOfChess(chess:Chess):Number
		{
			if(chess==null) return 0;
			return acMath.getDistance(this.boardX,this.boardY,chess.boardX,chess.boardY);
		}
		
		public function distanceOfPoint(point:Point):Number
		{
			if(point==null) return 0;
			return acMath.getDistance(this.boardX,this.boardY,point.x,point.y);
		}
		
		public function distanceOfWayPoint(point:ChessWayPoint):Number
		{
			if(point==null) return 0;
			return acMath.getDistance(this.boardX,this.boardY,point.x,point.y);
		}
		
		//========API Functions========//
		public function getObject():Object
		{
			//Result
			var result:Object=new Object();
			//Variables
			var uuid:uint=this._uuid;
			var type:String=this._type.name;
			var originalOwnerNum:uint=this._host.getPlayerIndex(this._originalOwner);
			var ownerNum:uint=this.owner.gameIndex;
			var boardX:int=this.boardX;
			var boardY:int=this.boardY;
			var level:uint=this.level;
			var life:uint=this.life;
			var importment:Boolean=this.importment;
			var beMindContolOf:uint=this._beMindContolOf==null?0:this._beMindContolOf._uuid;
			var mindContolChesses:Vector.<Chess>=this._mindContolChesses.map(function(c:Chess,i:uint,v:Vector.<Chess>)
																			 {
																				 return c==null?0:c._uuid;
																			 });
			//Loadin
			result.uuid=uuid;
			result.type=type;
			result.originalOwner=originalOwnerNum;
			result.owner=ownerNum;
			result.boardX=boardX;
			result.boardY=boardY;
			result.level=level;
			result.life=life;
			result.importment=importment;
			result.beMindContolOf=beMindContolOf;
			result.mindContolChesses=mindContolChesses;
			//Return
			return result;
		}
	}
}