package ac3.Game 
{
	//============Import All============//
	import ac3.Chess.movement.ChessWayPoint;
	import ac3.Chess.movement.ChessWayPointType;
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.movement.*;
	import ac3.Events.*;
	import ac3.Game.*;
	import ac3.Text.*;
	import ac3.AI.*;
	import flash.events.TextEvent;
	
	//Flash
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.Graphics;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.events.MouseEvent;
	
	public class ChessBoard extends Sprite
	{
		//============Static Variables============//
		//Display
		public static const DEFAULT_BOARD_DISPLAY_WIDTH:uint=STAGE_WIDTH;
		public static const DEFAULT_BOARD_DISPLAY_HEIGHT:uint=STAGE_HEIGHT;
		public static const DEFAULT_BOARD_SIZE_X:uint=15;
		public static const DEFAULT_BOARD_SIZE_Y:uint=15;
		public static const DEFAULT_FRAME_DISPLAY_SIZE:uint=9;
		
		public static const MOVE_COUNT_KEY:String="Move Count:";
		public static const TIME_PASSED_KEY:String="Time Passed:";
		
		//Colors
		public static const DEFAULT_FRAME_COLOR:uint=0x666666;
		public static const DEFAULT_FRAME_ALPHA:Number=1;
		public static const DEFAULT_BACKGROUND_COLOR:uint=0xe0e0e0;
		public static const DEFAULT_SELECT_COLOR:Vector.<Number>=new<Number>[0xffffff,2/5];
		public static const SELECT_PLACE_COLOR_EMPTY:uint=0x8888ff;
		public static const SELECT_PLACE_COLOR_HAS_OWNER:uint=0x000000;
		public static const SELECT_PLACE_COLOR_NOT_HAS_OWNER:uint=0xbbbbbb;
		public static const DEFAULT_PLACE_COLOR_EMPTY:uint=0x8080ff;
		public static const DEFAULT_PLACE_COLOR_HAS_OWNER:uint=0x000000;
		public static const DEFAULT_PLACE_COLOR_HAS_NOT_OWNER:uint=0xcccccc;
		
		//Patterns
		public static const CLASSIC_PATTERN:Vector.<ChessType>=new <ChessType>[ChessType.S,ChessType.Si,ChessType.H,ChessType.Di,ChessType.D,
																			  ChessType.Ci,
																			  ChessType.D,ChessType.Di,ChessType.H,ChessType.Si,ChessType.S];
		public static const SQUARES_PATTERN:Vector.<ChessType>=new <ChessType>[ChessType.S,ChessType.S,ChessType.S,ChessType.S,ChessType.S,
																			  ChessType.Tr,
																			  ChessType.S,ChessType.S,ChessType.S,ChessType.S,ChessType.S];
		public static const STRAIGHT_PATTERN:Vector.<ChessType>=new <ChessType>[ChessType.F,ChessType.Rc,ChessType.Ca,ChessType.Rk,ChessType.F,
																			   ChessType.Tr,
																			   ChessType.F,ChessType.Rk,ChessType.Ca,ChessType.Rc,ChessType.F];
		public static const BONUS_STORM_PATTERN:Vector.<ChessType>=new <ChessType>[ChessType.Ra,ChessType.Ra,ChessType.Ra,
																				  ChessType.Ra,ChessType.Ra,ChessType.Ra,ChessType.Ra,ChessType.Ra,
																				  ChessType.Ra,ChessType.Ra,ChessType.Ra];
		public static const EPISODE_PATTERN:Vector.<ChessType>=new <ChessType>[ChessType.S,ChessType.F,ChessType.Cu,ChessType.Sd,ChessType.Co,
																			  ChessType.Tp,
																			  ChessType.Co,ChessType.Sd,ChessType.Cu,ChessType.F,ChessType.S];
		public static const MAGIC_PATTERN:Vector.<ChessType>=new <ChessType>[ChessType.V,ChessType.Sp,ChessType.Tp,ChessType.Ci,ChessType.Cw,
																			ChessType.Wt,
																			ChessType.Cw,ChessType.Ci,ChessType.Tp,ChessType.Sp,ChessType.V];
		public static const POWER_PATTERN:Vector.<ChessType>=new <ChessType>[ChessType.Cw,ChessType.Cw,ChessType.Cw,
																			ChessType.S,ChessType.X,ChessType.Cj,ChessType.Co,ChessType.Gl,
																			ChessType.Cw,ChessType.Cw,ChessType.Cw];
		
		//============Static Getter And Setter============//
		protected static function get STAGE_WIDTH():uint
		{
			return ChessGame.STAGE_WIDTH;
		}
		
		protected static function get STAGE_HEIGHT():uint
		{
			return ChessGame.STAGE_HEIGHT;
		}
		
		public static function get CLASSIC_PATTERN_LENGTH():uint
		{
			return ChessBoard.CLASSIC_PATTERN.length;
		}
		
		//============Static Functions============//
		
		//============Instance Variables============//
		//Host
		protected var _host:ChessGame;
		
		//Display
		protected var _frame:Shape=new Shape();
		protected var _board:Sprite=new Sprite();
		protected var _bottom:Shape=new Shape();
		protected var _selectOverlay:Sprite=new Sprite();
		protected var _movePlaceHistory:Sprite=new Sprite();
		protected var _selectPlace:Sprite=new Sprite();
		protected var _scoreBoards:Sprite=new Sprite();
		protected var _logText:TextField=new TextField();
		protected var _saveText:TextField=new TextField();
		
		protected var _moveCountText:KeyValueText=new KeyValueText(MOVE_COUNT_KEY);
		protected var _timePassedText:KeyValueText=new KeyValueText(TIME_PASSED_KEY);
		
		protected var _displayWidth:uint=DEFAULT_BOARD_DISPLAY_WIDTH;
		protected var _displayHeight:uint=DEFAULT_BOARD_DISPLAY_HEIGHT;
		protected var _boardSizeX:uint=DEFAULT_BOARD_SIZE_X;
		protected var _boardSizeY:uint=DEFAULT_BOARD_SIZE_Y;
		protected var _frameDisplaySize:uint=DEFAULT_FRAME_DISPLAY_SIZE;
		protected var _frameColor:uint=DEFAULT_FRAME_COLOR;
		protected var _frameAlpha:uint=DEFAULT_FRAME_ALPHA;
		protected var _backGroundColor:uint;
		protected var _backGroundColor_grid:uint;
		protected var _selectColor:Vector.<Number>=DEFAULT_SELECT_COLOR;
		
		//============Constructor Function============//
		public function ChessBoard(host:ChessGame,
								  boardWidth:uint=0,boardHeight:uint=0,
								  boardSizeX:uint=0,boardSizeY:uint=0,
								  frameSize:uint=0,
								  frameColor:uint=DEFAULT_FRAME_COLOR,
								  frameAlpha:Number=DEFAULT_FRAME_ALPHA,
								  backGroundColor:uint=DEFAULT_BACKGROUND_COLOR):void
		{
			this._host=host;
			if(boardWidth>0) this._displayWidth=boardWidth;
			if(boardHeight>0) this._displayHeight=boardHeight;
			if(boardSizeX>0) this._boardSizeX=boardSizeX;
			if(boardSizeY>0) this._boardSizeY=boardSizeY;
			if(frameSize>0) this._frameDisplaySize=frameSize;
			this.backGroundColor=backGroundColor;
			this._frameColor=frameColor;
			this._frameAlpha=frameAlpha;
			//Add Event Listener
			this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
		}
		
		//============Instance Getter And Setter============//
		//========Main========//
		public function get host():ChessGame
		{
			return this._host;
		}
		
		//========About Display========//
		public function get backGroundColor():uint
		{
			return this._backGroundColor;
		}
		
		public function set backGroundColor(value:uint):void
		{
			this._backGroundColor=value;
			var bc:Vector.<Number>=Color.HEXtoHSV(value);
			this._backGroundColor_grid=Color.HSVtoHEX(bc[0],bc[1],bc[2]-10);
		}
		
		public function get frameColor():uint
		{
			return this._frameColor;
		}
		
		public function set frameColor(value:uint):void
		{
			this._frameColor=value;
			this.drawFrame();
		}
		
		public function get frameAlpha():uint
		{
			return this._frameAlpha;
		}
		
		public function set frameAlpha(value:uint):void
		{
			this._frameAlpha=value;
			this.drawFrame();
		}
		
		public function get frameSize():uint
		{
			return this._frameDisplaySize;
		}
		
		public function set frameSize(value:uint):void
		{
			this._frameDisplaySize=value;
			this.drawFrame();
		}
		
		public function get selectColor():Vector.<Number>
		{
			return this._selectColor;
		}
		
		public function set selectColor(value:Vector.<Number>):void
		{
			if(value==null||value.length<2) return;
			this._selectColor=value;
		}
		
		public function get moveCountText():KeyValueText
		{
			return this._moveCountText;
		}
		
		public function get timePassedText():KeyValueText
		{
			return this._timePassedText;
		}
		
		public function get logText():TextField
		{
			return this._logText;
		}
		
		public function get saveText():TextField
		{
			return this._saveText;
		}
		
		public function get boardOriginalX():Number
		{
			return (this._displayWidth-this.realDisplayWidth)/2;
		}
		
		public function get boardOriginalY():Number
		{
			return (this._displayHeight-this.realDisplayHeight)/2;
		}
		
		public function get realDisplayWidth():Number
		{
			return this.frameSize*2+this.boardSizeX*this.chessDisplayWidth;
		}
		
		public function get realDisplayHeight():Number
		{
			return this.frameSize*2+this.boardSizeY*this.chessDisplayHeight;
		}
		
		public function get boardAreaWithFrame():Rectangle
		{
			return new Rectangle(this.boardOriginalX,
								 this.boardOriginalY,
								 this.realDisplayWidth,
								 this.realDisplayHeight);
		}
		
		public function get displayWidthWithoutFrame():Number
		{
			return this._displayWidth-this.frameSize*2;
		}
		
		public function get displayHeightWithoutFrame():Number
		{
			return this._displayHeight-this.frameSize*2;
		}
		
		public function get chessDisplayWidth():Number
		{
			return this.boardSizeX>=this.boardSizeY?this.displayWidthWithoutFrame/this.boardSizeX:this.displayHeightWithoutFrame/this.boardSizeY;
			//(displayWidthWithoutFrame)/this._boardSizeX;
		}
		
		public function get chessDisplayHeight():Number
		{
			return this.chessDisplayWidth;
			//(displayHeightWithoutFrame)/this._boardSizeY;
		}
		
		public function get boardSizeX():uint
		{
			return this._boardSizeX;
		}
		
		public function get boardSizeY():uint
		{
			return this._boardSizeY;
		}
		
		public function get randomX():int
		{
			return acMath.random(this.boardSizeX);
		}
		
		public function get randomY():int
		{
			return acMath.random(this.boardSizeY);
		}
		
		public function get centerX():int
		{
			return Math.floor(this.boardSizeX/2);
		}
		
		public function get centerY():int
		{
			return Math.floor(this.boardSizeY/2);
		}
		
		//========About Chess========//
		public function get allPoints():Vector.<Point>
		{
			var returnVec:Vector.<Point>=new Vector.<Point>;
			for(var xd:uint=0;xd<this._boardSizeX;xd++)
			{
				for(var yd:uint=0;yd<this._boardSizeY;yd++)
				{
					returnVec.push(new Point(xd,yd));
				}
			}
			return returnVec;
		}
		
		public function get allWayPoints():Vector.<ChessWayPoint>
		{
			var returnVec:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			for(var xd:uint=0;xd<this._boardSizeX;xd++)
			{
				for(var yd:uint=0;yd<this._boardSizeY;yd++)
				{
					returnVec.push(new ChessWayPoint(xd,yd,ChessWayPointType.MOVE_AND_ATTACK));
				}
			}
			return returnVec;
		}
		
		public function get allChesses():Vector.<Chess>
		{
			var returnVec:Vector.<Chess>=new Vector.<Chess>;
			var tempObj:DisplayObject;
			for(var i:uint=0;i<this._board.numChildren;i++)
			{
				tempObj=this._board.getChildAt(i);
				if(tempObj==null) continue;
				if(tempObj is Chess)
				{
					returnVec.push(tempObj as Chess);
				}
			}
			return returnVec;
		}
		
		public function get selectList():Vector.<ChessSelectOverlay>
		{
			var returnVec:Vector.<ChessSelectOverlay>=new Vector.<ChessSelectOverlay>;
			var tempObj:DisplayObject;
			for(var i:uint=0;i<this._selectOverlay.numChildren;i++)
			{
				tempObj=this._selectOverlay.getChildAt(i);
				if(tempObj==null) continue;
				if(tempObj is ChessSelectOverlay)
				{
					returnVec.push(tempObj as ChessSelectOverlay);
				}
				else
				{
					this._selectOverlay.removeChild(tempObj);
				}
			}
			return returnVec;
		}
		
		public function get hasSelect():Boolean
		{
			return this.selectList.length>0;
		}
		
		public function get selectedChess():Chess
		{
			var tempObj:ChessSelectOverlay,tempChess:Chess;
			for(var i:uint=0;i<this._selectOverlay.numChildren;i++)
			{
				if(this._selectOverlay.getChildAt(i)==null) continue;
				if(this._selectOverlay.getChildAt(i) is ChessSelectOverlay)
				{
					tempObj=this._selectOverlay.getChildAt(i) as ChessSelectOverlay;
					if(!tempObj.visible) continue;
					tempChess=this.getChessAt(tempObj.boardX,tempObj.boardY);
					if(tempChess==null) continue;
					return tempChess;
				}
				else
				{
					this._selectOverlay.removeChild(tempObj);
				}
			}
			return null;
		}
		
		public function get selectedChesses():Vector.<Chess>
		{
			var tempObj:ChessSelectOverlay,tempChess:Chess,tempVec:Vector.<Chess>=new Vector.<Chess>;
			for(var i:uint=0;i<this._selectOverlay.numChildren;i++)
			{
				if(this._selectOverlay.getChildAt(i)==null) continue;
				if(this._selectOverlay.getChildAt(i) is ChessSelectOverlay)
				{
					tempObj=this._selectOverlay.getChildAt(i) as ChessSelectOverlay;
					tempChess=this.getChessAt(tempObj.boardX,tempObj.boardY);
					if(tempChess==null) continue;
					tempVec.push(tempChess);
				}
				else
				{
					this._selectOverlay.removeChild(tempObj);
				}
			}
			return tempVec;
		}
		
		public function get chessSelectPlaces():Vector.<ChessSelectPlace>
		{
			var result:Vector.<ChessSelectPlace>=new Vector.<ChessSelectPlace>;
			var selectPlace:ChessSelectPlace;
			for(var i:uint=0;i<this._selectPlace.numChildren;i++)
			{
				selectPlace=this._selectPlace.getChildAt(i) as ChessSelectPlace;
				if(selectPlace!=null) result.push(selectPlace);
			}
			return result;
		}
		
		public function get chessSelectPlaceCount():uint
		{
			return this._selectPlace.numChildren;
		}
		
		public function get hasSelectPlace():Boolean
		{
			return this.chessSelectPlaceCount>0;
		}
		
		//============Instance Functions============//
		//--------Init Functions--------//
		public function onAddedToStage(event:Event):void
		{
			//Remove EventListener
			this.removeEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
			//Init Display
			this.initDisplay();
		}
		
		public function updateTextSize(text:TextField):void
		{
			text.width=Math.min(text.textWidth+30,STAGE_WIDTH);
			text.height=Math.min(text.textHeight+30,STAGE_HEIGHT);
		}
		
		protected function initDisplay():void
		{
			//Draw
			this.drawFrame();
			this.drawGrid();
			this.addScoreBoards();
			//Add Child
			this.initChildPosition();
			this.initChildContext();
			this.addChilds();
		}
		
		protected function drawFrame():void
		{
			var boardRect:Rectangle=this.boardAreaWithFrame;
			this._frame.graphics.clear();
			this._frame.graphics.lineStyle(0,0,0);
			this._frame.graphics.beginFill(this._frameColor,this._frameAlpha);
			this._frame.graphics.drawRect(boardRect.left,boardRect.top,
										  boardRect.width-frameSize,frameSize);//Up
			this._frame.graphics.drawRect(boardRect.left,boardRect.top+frameSize,
										  frameSize,boardRect.height-frameSize);//Left
			this._frame.graphics.drawRect(boardRect.right-frameSize,boardRect.top,
										  frameSize,boardRect.height-frameSize);//Right
			this._frame.graphics.drawRect(boardRect.left+frameSize,boardRect.bottom-frameSize,
										  boardRect.width-frameSize,frameSize);//Down
			this._frame.graphics.endFill();
		}
		
		protected function drawGrid():void
		{
			var boardRect:Rectangle=this.boardAreaWithFrame;
			this._bottom.graphics.clear();
			this._bottom.graphics.beginFill(this._backGroundColor_grid,1);
			this._bottom.graphics.drawRect(boardRect.left,boardRect.top,boardRect.width,boardRect.height);
			this._bottom.graphics.endFill();
			this._bottom.graphics.beginFill(this._backGroundColor,1);
			for(var xd:uint=0;xd<this._boardSizeX;xd++)
			{
				for(var yd:uint=0;yd<this._boardSizeY;yd++)
				{
					if(xd%2==yd%2)
					{
						this._bottom.graphics.drawRect(boardRect.left+unlockX(xd)+frameSize,
													   boardRect.top+unlockY(yd)+frameSize,
													   chessDisplayWidth,chessDisplayHeight);
					}
				}
			}
			this._bottom.graphics.endFill();
		}
		
		public function initChildPosition():void
		{
			var boardRect:Rectangle=this.boardAreaWithFrame;
			this._board.x=boardRect.left+frameSize;
			this._board.y=boardRect.top+frameSize;
			this._selectOverlay.x=boardRect.left+frameSize;
			this._selectOverlay.y=boardRect.top+frameSize;
			this._selectPlace.x=boardRect.left+frameSize;
			this._selectPlace.y=boardRect.top+frameSize;
			this._movePlaceHistory.x=boardRect.left+frameSize;
			this._movePlaceHistory.y=boardRect.top+frameSize;
			this._frame.x=this._frame.y=0;
			this._moveCountText.x=this._timePassedText.x=boardRect.left+frameSize;
			this._moveCountText.y=boardRect.bottom-this.frameSize-this._moveCountText.height;
			this._timePassedText.y=this._moveCountText.y-this._timePassedText.height;
			this._logText.x=this._logText.y=this._saveText.x=this._saveText.y=0;
		}
		
		public function initChildContext():void
		{
			this._logText.visible=false;
			this._logText.textColor=0x000000;
			this._logText.width=STAGE_WIDTH;
			this._logText.height=STAGE_HEIGHT;
			//
			this._saveText.visible=false;
			this._saveText.textColor=0xffffff;
			this._saveText.width=STAGE_WIDTH;
			this._saveText.height=STAGE_HEIGHT;
			this._saveText.type=TextFieldType.INPUT;
		}
		
		protected function addChilds():void
		{
			this.addChild(this._bottom);
			this.addChild(this._scoreBoards);
			this.addChild(this._moveCountText);
			this.addChild(this._timePassedText);
			this.addChild(this._board);
			this.addChild(this._frame);
			this.addChild(this._selectOverlay);
			this.addChild(this._selectPlace);
			this.addChild(this._movePlaceHistory);
			this.addChild(this._logText);
			this.addChild(this._saveText);
		}
		
		public function addScoreBoards():void
		{
			var totalHeight:Number=ChessPlayerScoreBoard.realHeight*this._host.playerCount;
			var distancePerBoard:Number=(_displayHeight-totalHeight)/(this._host.playerCount+1);
			var centerX:Number=_displayWidth/2-ChessPlayerScoreBoard.realWidth/2;
			var player:ChessPlayer,distanceY:Number;
			for(var i:uint=0;i<this._host.playerCount;i++)
			{
				player=this._host.players[i];
				distanceY=ChessPlayerScoreBoard.realHeight*i+distancePerBoard*(i+1);
				var scoreBoard:ChessPlayerScoreBoard=new ChessPlayerScoreBoard(player);
				scoreBoard.x=centerX,scoreBoard.y=distanceY;
				this._scoreBoards.addChild(scoreBoard);
			}
		}
		
		public function removeAllScoreBoard():void 
		{
			var scoreBoard:ChessPlayerScoreBoard;
			for(var i:int=this._scoreBoards.numChildren;i>0;i--)
			{
				scoreBoard=this._scoreBoards.getChildAt(0) as ChessPlayerScoreBoard;
				if(scoreBoard==null) continue;
				scoreBoard.deleteSelf();
				this._scoreBoards.removeChildAt(0);
			}
		}
		
		public function resetAllScoreBoard():void
		{
			this.removeAllScoreBoard();
			this.addScoreBoards();
		}
		
		public function resizeOfBoard(newSizeX:uint,newSizeY:uint):void
		{
			//Check
			if(newSizeX*newSizeY==0)
			{
				throw new Error("Can't set size to zero!");
				return;
			}
			//Remove
			if(this.allChesses.length>0) this.removeAllChess();
			//Set
			this._boardSizeX=newSizeX;
			this._boardSizeY=newSizeY;
			//Remove II
			this.removeAllScoreBoard();
			//Init
			this.initDisplay();
			//Remove III
			this.removeAllSelectOverlay();
			this.clearAllSelectPlace();
			this.clearAllMovePlaceHistory();
			//Patch Event
			this.dispatchEvent(new ChessEvent(ChessEvent.BOARD_RESIZED,null,this.host,this));
		}
		
		//--------Main Functions--------//
		public function getGridPos(x:Number,y:Number):Point
		{
			var p0:Point=this._board.globalToLocal(new Point(x,y));
			return new Point(lockX(p0.x-this.chessDisplayWidth/2),lockY(p0.y-this.chessDisplayHeight/2));
		}
		
		public function lockX(x:Number):int
		{
			//trace("X:","\t",x,this.chessWidth,"\t\t\t",x/this.chessWidth,"\t\t\t",Math.round(x/this.chessWidth),x/this.chessWidth-Math.floor(x/this.chessWidth));
			return Math.round(x/this.chessDisplayWidth);
		}
		
		public function lockY(y:Number):int
		{
			//trace("Y:","\t",y,this.chessWidth,"\t\t\t",y/this.chessWidth,"\t\t\t",Math.round(y/this.chessWidth),y/this.chessWidth-Math.floor(y/this.chessWidth));
			return Math.round(y/this.chessDisplayHeight);
		}
		
		public function unlockX(x:int):Number
		{
			return x*this.chessDisplayWidth;
		}
		
		public function unlockY(y:int):Number
		{
			return y*this.chessDisplayHeight;
		}
		
		public function isInBoard(x:int,y:int):Boolean
		{
			return (x>=0&&x<this._boardSizeX)&&(y>=0&&y<this._boardSizeY);
		}
		
		public function isInBoard2(point:Point):Boolean
		{
			return isInBoard(point.x,point.y);
		}
		
		public function isInBoard3(point:ChessWayPoint):Boolean
		{
			return isInBoard(point.x,point.y);
		}
		
		public function isActiveChess(chess:Chess):Boolean
		{
			return this._board.contains(chess);
		}
		
		
		public function fillWayPoints(wayPoint:ChessWayPoint):Vector.<ChessWayPoint>
		{
			var returnVec:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			for(var xd:uint=0;xd<this._boardSizeX;xd++)
			{
				for(var yd:uint=0;yd<this._boardSizeY;yd++)
				{
					returnVec.push(wayPoint.getCopyAndMargePosition(xd,yd));
				}
			}
			return returnVec;
		}
		
		public function getAllChessesWayPointWith(wayPoint:ChessWayPoint):Vector.<ChessWayPoint>
		{
			var tempVec:Vector.<Chess>=this.allChesses;
			var tempPoint:ChessWayPoint;
			var returnVec:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			for each(var tempChess:Chess in tempVec)
			{
				tempPoint=tempChess.boardWayPoint;
				if(tempPoint.equals(wayPoint,true,false,true)) continue;
				returnVec.push(wayPoint.getCopyAndMargePosition(tempPoint.x,tempPoint.y));
			}
			return returnVec;
		}
		
		public function getSymmetryPoint(x:int,y:int):Point
		{
			return new Point(this.boardSizeX-1-x,this.boardSizeY-1-y);
		}
		
		public function getSymmetryPoint2(point:Point):Point
		{
			return getSymmetryPoint(point.x,point.y);
		}
		
		public function getSymmetryPoint3(point:ChessWayPoint):Point
		{
			return getSymmetryPoint(point.x,point.y);
		}
		
		//Chess
		public function putChessesPattern(gameMode:ChessGameMode):void 
		{
			var type:ChessType,owner:ChessPlayer;
			var i:int,j:int,xd:int,yd:int;
			var tempBoolean:Boolean;
			var tempPoint:Point;
			var tempPattern:Vector.<ChessType>;
			var tempPlayer:ChessPlayer;
			var tempChess:Chess;
			//tempPattern
			switch(gameMode)
			{
				case ChessGameMode.SQUARES:
					tempPattern=ChessBoard.SQUARES_PATTERN;
					break;
				case ChessGameMode.STRAIGHT:
					tempPattern=ChessBoard.STRAIGHT_PATTERN;
					break;
				case ChessGameMode.BONUS_STORM:
					tempPattern=ChessBoard.BONUS_STORM_PATTERN;
					break;
				case ChessGameMode.EPISODE:
					tempPattern=ChessBoard.EPISODE_PATTERN;
					break;
				case ChessGameMode.MAGIC:
					tempPattern=ChessBoard.MAGIC_PATTERN;
					break;
				case ChessGameMode.POWER:
					tempPattern=ChessBoard.POWER_PATTERN;
					break;
				default:
					tempPattern=ChessBoard.CLASSIC_PATTERN;
					break;
			}
			//Real Put
			switch(gameMode)
			{
				case ChessGameMode.DEBUG:
					for(i=0;i<ChessType.ALL_TYPES.length;i++)
					{
						var vx:uint=i%this._boardSizeX,vy:uint=Math.floor(i/this._boardSizeX);
						type=ChessType.ALL_TYPES[i];
						owner=this._host.getPlayerByModeAt(i%(_host.playerCount+1));
						setNewChess(vx,vy,owner,type);
					}
					break;
				case ChessGameMode.ELDER:
				case ChessGameMode.RANDOM_II:
					for(i=0;i<ChessBoard.CLASSIC_PATTERN_LENGTH;i++)
					{
						type=(gameMode==ChessGameMode.RANDOM_II)?ChessType.randomEnableWithoutUnknown:ChessType.randomInitial;
						tempBoolean=General.randomBoolean2(1/5);
						this.setNewChess(0,(this._boardSizeY-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,this._host.getPlayerByModeAt(1),type,tempBoolean);
						this.setNewChess(this._boardSizeX-1,(this._boardSizeY-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,this._host.getPlayerByModeAt(2),type,tempBoolean);
						this.setNewChess((this._boardSizeX-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,0,this._host.getPlayerByModeAt(3),type,tempBoolean);
						this.setNewChess((this._boardSizeX-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,this._boardSizeY-1,this._host.getPlayerByModeAt(4),type,tempBoolean);
					}
					break;
				case ChessGameMode.RANDOM_III:
					for(xd=0;xd<2;xd++)
					{
						for(yd=0;yd<2;yd++)
						{
							this.setNewChess(xd,yd,null,ChessType.So,false,true);
						}
						for(yd=this.boardSizeY-2;yd<this.boardSizeY;yd++)
						{
							this.setNewChess(xd,yd,null,ChessType.So,false,true);
						}
					}
					for(xd=this.boardSizeX-2;xd<this.boardSizeX;xd++)
					{
						for(yd=0;yd<2;yd++)
						{
							this.setNewChess(xd,yd,null,ChessType.So,false,true);
						}
						for(yd=this.boardSizeY-2;yd<this.boardSizeY;yd++)
						{
							this.setNewChess(xd,yd,null,ChessType.So,false,true);
						}
					}
					for(yd=0;yd<this.boardSizeY;yd+=this.boardSizeY-1)
					{
						tempPlayer=this.host.getPlayerByModeAt(yd<this.centerY?3:4);
						i=acMath.sgn(this.centerY-yd);
						for(xd=2;xd<this.boardSizeX-2;xd++)
						{
							this.setNewChess(xd,yd,tempPlayer,ChessType.randomEnableWithoutUnknown,true);
							this.setNewChess(xd,yd+i,tempPlayer,ChessType.S,false);
						}
					}
					for(xd=0;xd<this.boardSizeX;xd+=this.boardSizeX-1)
					{
						tempPlayer=this.host.getPlayerByModeAt(xd<this.centerX?1:2);
						i=acMath.sgn(this.centerX-xd);
						for(yd=2;yd<this.boardSizeY-2;yd++)
						{
							this.setNewChess(xd,yd,tempPlayer,ChessType.randomEnableWithoutUnknown,true);
							this.setNewChess(xd+i,yd,tempPlayer,ChessType.S,false);
						}
					}
					break;
				case ChessGameMode.CLASSIC:
				case ChessGameMode.EPISODE:
				case ChessGameMode.MAGIC:
					for(i=0;i<ChessBoard.CLASSIC_PATTERN_LENGTH;i++)
					{
						type=tempPattern[i];
						tempBoolean=ChessBoard.CLASSIC_PATTERN_LENGTH%2==1&&(ChessBoard.CLASSIC_PATTERN_LENGTH+1)/(i+1)==2;
						this.setNewChess(0,(this._boardSizeY-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,this._host.getPlayerByModeAt(1),type,tempBoolean);
						this.setNewChess(this._boardSizeX-1,(this._boardSizeY-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,this._host.getPlayerByModeAt(2),type,tempBoolean);
						this.setNewChess((this._boardSizeX-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,0,this._host.getPlayerByModeAt(3),type,tempBoolean);
						this.setNewChess((this._boardSizeX-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,this._boardSizeY-1,this._host.getPlayerByModeAt(4),type,tempBoolean);
					}
					break;
				case ChessGameMode.SQUARES:
				case ChessGameMode.STRAIGHT:
				case ChessGameMode.BONUS_STORM:
				case ChessGameMode.POWER:
					for(i=0;i<ChessBoard.CLASSIC_PATTERN_LENGTH;i++)
					{
						type=tempPattern[i];
						this.setNewChess(0,(this._boardSizeY-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,this._host.getPlayerByModeAt(1),type);
						this.setNewChess(this._boardSizeX-1,(this._boardSizeY-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,this._host.getPlayerByModeAt(2),type);
						this.setNewChess((this._boardSizeX-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,0,this._host.getPlayerByModeAt(3),type);
						this.setNewChess((this._boardSizeX-ChessBoard.CLASSIC_PATTERN_LENGTH)/2+i,this._boardSizeY-1,this._host.getPlayerByModeAt(4),type);
					}
					break;
				case ChessGameMode.X_STORM:
					for each(tempPoint in this.allPoints)
					{
						this.setNewChess(tempPoint.x,tempPoint.y,this._host.randomPlayer,ChessType.X,false);
					}
					break;
				case ChessGameMode.SWAP:
					for each(tempPoint in this.allPoints)
					{
						this.setNewChess(tempPoint.x,tempPoint.y,null,ChessType.NULL,false);
					}
					break;
				case ChessGameMode.ADVANCE:
					//Set Chess.Ra At Center<Not Use>
					//this.setNewChess(this.centerX,this.centerY,null,ChessType.Ra,true);
					//Spawn Bonuses
					for(i=0;i<4+acMath.random(13);i++)
					{
						this.host.randomAddBonusChessByRule();
					}
					//Add Initial Chess.S
					this.putChessesForEveryPlayer(ChessType.S);
					break;
				case ChessGameMode.SURVIVAL:
					//Add Initial Chess.S
					this.putChessesForEveryPlayer(ChessType.S);
					break;
				case ChessGameMode.COPYFROM:
					this.putChessesForEveryPlayer(ChessType.Cl,true);
					this.randomPutChess(null,ChessType.getRandomInTypes(ChessType.COPYFROM_INITIAL_TYPES));
					break;
				case ChessGameMode.DECENTRALIZED:
					for each(type in ChessBoard.CLASSIC_PATTERN)
					{
						tempBoolean=type==ChessType.Ci;
						this.putChessesForEveryPlayer(type,tempBoolean);
					}
					break;
				case ChessGameMode.SURVANCE:
					//Set Chess.Ra At Center<Not Use>
					//this.setNewChess(this.centerX,this.centerY,null,ChessType.Ra,true);
					//Trun Bonus Types To
					this.host.rules.loadByMode(ChessGameMode.ADVANCE);
					//Spawn Bonuses
					var maxCount:uint=4+acMath.random(9);
					for(i=0;i<maxCount;i++)
					{
						this.host.randomAddBonusChessByRule();
					}
					//Trun Bonus Types Back
					this.host.rules.loadByMode(ChessGameMode.SURVIVAL);
					//Add Initial Chess.S
					this.putChessesForEveryPlayer(ChessType.S);
					break;
				case ChessGameMode.INFLUENCE:
					//Side
					this.setNewChess(0,1,this.host.getPlayerByModeAt(1),ChessType.V,false);
					this.setNewChess(1,0,this.host.getPlayerByModeAt(1),ChessType.V,false);
					this.setNewChess(0,this.boardSizeX-2,this.host.getPlayerByModeAt(2),ChessType.V,false);
					this.setNewChess(1,this.boardSizeX-1,this.host.getPlayerByModeAt(2),ChessType.V,false);
					this.setNewChess(this.boardSizeX-2,0,this.host.getPlayerByModeAt(3),ChessType.V,false);
					this.setNewChess(this.boardSizeX-1,1,this.host.getPlayerByModeAt(3),ChessType.V,false);
					this.setNewChess(this.boardSizeX-2,this.boardSizeX-1,this.host.getPlayerByModeAt(4),ChessType.V,false);
					this.setNewChess(this.boardSizeX-1,this.boardSizeX-2,this.host.getPlayerByModeAt(4),ChessType.V,false);
					//Base
					var base1:Chess=this.setNewChess(0,0,this.host.getPlayerByModeAt(1),ChessType.V,false);
					var base2:Chess=this.setNewChess(0,this.boardSizeX-1,this.host.getPlayerByModeAt(2),ChessType.V,false);
					var base3:Chess=this.setNewChess(this.boardSizeX-1,0,this.host.getPlayerByModeAt(3),ChessType.V,false);
					var base4:Chess=this.setNewChess(this.boardSizeX-1,this.boardSizeX-1,this.host.getPlayerByModeAt(4),ChessType.V,false);
					base1.levelGenerateOnTrun=base2.levelGenerateOnTrun=base3.levelGenerateOnTrun=base4.levelGenerateOnTrun=1;
					base1.levelGenerateLimit=base2.levelGenerateLimit=base3.levelGenerateLimit=base4.levelGenerateLimit=10;
					for(i=1+acMath.random(4);i>0;i--)
					{
						tempChess=this.randomPutChess(null,ChessType.Ts,false);
						tempChess.level=1+acMath.random(10);
					}
					for each(tempPoint in this.allPoints)
					{
						if(!this.hasChessAt(tempPoint.x,tempPoint.y))
						{
							tempChess=this.setNewChess(tempPoint.x,tempPoint.y,null,ChessType.V,false,false);
						}
					}
					break;
			}
		}
		
		public function putChessesForEveryPlayer(type:ChessType,importment:Boolean=false,overRide:Boolean=false):void
		{
			for each(var tempPlayer:ChessPlayer in this.host.players)
			{
				this.randomPutChess(tempPlayer,type,importment,overRide);
			}
		}
		
		public function randomPutChess(owner:ChessPlayer,type:ChessType,importment:Boolean=false,overRide:Boolean=false):Chess
		{
			var chess:Chess=new Chess(this.host,-1,-1,type,owner);
			chess.importment=importment;
			return randomPutChess2(chess,overRide);
		}
		
		public function randomPutChess2(chess:Chess,overRide:Boolean=false):Chess
		{
			var i:uint=0;
			var rx:int;
			var ry:int;
			var result:Chess;
			var tempBoolean:Boolean;
			do
			{
				rx=this.randomX;
				ry=this.randomY;
				tempBoolean=this.hasChessAt(rx,ry);
				if(!tempBoolean)
				{
					chess.boardX=rx;
					chess.boardY=ry;
					return this.setNewChess2(chess,overRide);
				}
				i++;
			}
			while(i<1024&&tempBoolean)
			return null;
		}
		/*
		//override
			if(overRide)
			{
				removeChessAt(x,y);
			}
			else if(this.hasChessAt(x,y))
			{
				return null;
			}
			//Add New Chess
			var chess:Chess=new Chess(this._host,x,y,type,owner);
			chess.importment=importment;
			this._board.addChild(chess);
			//Patch Event
			this.dispatchEvent(new ChessEvent(ChessEvent.NEW_CHESS_ADDED,chess).alignToChess());
			//Return
			return chess;*/
		public function setNewChess(x:int,y:int,
									owner:ChessPlayer,
									type:ChessType,
									importment:Boolean=false,
									overRide:Boolean=true):Chess
		{
			//Create New Chess
			var chess:Chess=new Chess(this._host,x,y,type,owner);
			chess.importment=importment;
			//Return
			return this.setNewChess2(chess,overRide);
		}
		
		public function setNewChess2(chess:Chess,overRide:Boolean=true):Chess
		{
			//override
			if(overRide)
			{
				removeChessAt(chess.boardX,chess.boardY);
			}
			else if(this.hasChessAt(chess.boardX,chess.boardY))
			{
				return null;
			}
			//Update Chess
			//chess.x=chess.boardX*this.chessDisplayWidth;
			//chess.y=chess.boardY*this.chessDisplayHeight;
			chess.updateDisplay(true,true,true);
			//Add Chess
			this._board.addChild(chess);
			//Patch Event
			this.dispatchEvent(new ChessEvent(ChessEvent.NEW_CHESS_ADDED,chess).alignToChess());
			//Return
			return chess;
		}
		
		public function getChessAt(x:int,y:int):Chess
		{
			for each(var chess:Chess in this.allChesses)
			{
				if(chess.boardX==x&&chess.boardY==y)
				{
					return chess;
				}
			}
			return null;
		}
		
		public function getChessOwnerAt(x:int,y:int):ChessPlayer
		{
			return hasChessAt(x,y)?getChessAt(x,y).owner:null;
		}
		
		public function getChessTypeAt(x:int,y:int):ChessType
		{
			return hasChessAt(x,y)?getChessAt(x,y).type:null;
		}
		
		public function getChessesAt(x:int,y:int):Vector.<Chess>
		{
			var returnVec:Vector.<Chess>=new Vector.<Chess>;
			for each(var chess:Chess in this.allChesses)
			{
				if(chess.boardX==x&&chess.boardY==y)
				{
					returnVec.push(chess);
				}
			}
			return returnVec;
		}
		
		public function hasChessAt(x:int,y:int):Boolean
		{
			return this.getChessAt(x,y)!=null;
		}
		
		public function chessHasOwnerAt(x:int,y:int):Boolean
		{
			return this.hasChessAt(x,y)?this.getChessAt(x,y).owner!=null:false;
		}
		
		public function removeChess(chess:Chess):void
		{
			if(chess==null||!this._board.contains(chess)) return;
			//Release Mind Contol
			if(chess.hasMindContol) chess.releaseAllMindContol();
			//Remove From Display List
			this._board.removeChild(chess);
			//Patch Event
			this.dispatchEvent(new ChessEvent(ChessEvent.CHESS_REMOVED,chess).alignToChess());
			//Decostruct Chess<Not Use>
			//chess.deleteSelf();
		}
		
		public function removeChessAt(x:int,y:int):void
		{
			for(var i:int=this.allChesses.length-1;i>=0;i--)
			{
				var chess:Chess=this.allChesses[i];
				if(chess.boardX==x&&chess.boardY==y)
				{
					removeChess(chess);
				}
			}
		}
		
		public function removeAllChess():void
		{
			for(var i:int=this.allChesses.length-1;i>=0;i--)
			{
				removeChess(this.allChesses[i]);
			}
		}
		
		public function removeAllChessByOwner(owner:ChessPlayer):void
		{
			var tempChess:Chess;
			for(var i:int=this.allChesses.length-1;i>=0;i--)
			{
				tempChess=this.allChesses[i];
				if(tempChess.owner==owner) removeChess(tempChess);
			}
		}
		
		public function moveChess(chess:Chess,moveX:int,moveY:int,keepChessOnTargetPlace:Boolean=false):void
		{
			if(!isInBoard(moveX,moveY)) return;
			if(hasChessAt(moveX,moveY))//Already Have Chess On There
			{
				if(keepChessOnTargetPlace) return;
				removeChessAt(moveX,moveY);
			}
			//Real Move
			chess.boardX=moveX;
			chess.boardY=moveY;
		}
		
		public function hideChessOutOfBoard(chess:Chess):void
		{
			//Hide
			chess.visible=false;
			//Move
			chess.boardX=-1;
			chess.boardY=-1;
		}
		
		public function showChessAt(chess:Chess,moveX:int,moveY:int):void
		{
			//Show
			chess.visible=true;
			//Move
			chess.boardX=moveX;
			chess.boardY=moveY;
		}
		
		public function showAndReallyMoveChess(chess:Chess,wayPoint:ChessWayPoint,ownerChess:Chess,dealGameRule:Boolean=true):void
		{
			//Show
			chess.visible=true;
			//Move
			this._host.reallyMoveChess(chess,wayPoint,ownerChess,dealGameRule);
		}
		
		//Select Place
		public function addSelectPlace(x:int,y:int,color:uint,alpha:Number=1,type:ChessSelectPlaceType=null):void
		{
			var sPlace:ChessSelectPlace=new ChessSelectPlace(unlockX(x),unlockY(y),color,alpha,type,this.chessDisplayWidth/100,this.chessDisplayHeight/100);
			sPlace.buttonMode=true;
			sPlace.addEventListener(MouseEvent.CLICK,this.onSelectPlaceClicked);
			this._selectPlace.addChild(sPlace);
		}
		
		public function autoAddSelectPlace(x:int,y:int,
										  emptyColor:int=-1,
										  hasOwnerChessColor:int=-1,
										  notHasOwnerChessColor:int=-1,
										  emptyType:ChessSelectPlaceType=null,
										  hasOwnerChessType:ChessSelectPlaceType=null,
										  notHasOwnerChessType:ChessSelectPlaceType=null):void
		{
			if(emptyColor<0) emptyColor=SELECT_PLACE_COLOR_EMPTY;
			if(hasOwnerChessColor<0) hasOwnerChessColor=SELECT_PLACE_COLOR_HAS_OWNER;
			if(notHasOwnerChessColor<0) notHasOwnerChessColor=SELECT_PLACE_COLOR_NOT_HAS_OWNER;
			//======Detect======//
			var tempChess:Chess=getChessAt(x,y);
			//Nothing
			if(tempChess==null)
			{
				addSelectPlace(x,y,emptyColor,1,emptyType);
			}
			//Has Chess On There
			else
			{
				if(tempChess.hasOwner)
				{
					addSelectPlace(x,y,hasOwnerChessColor,1,hasOwnerChessType);
				}
				else
				{
					addSelectPlace(x,y,notHasOwnerChessColor,1,notHasOwnerChessType);
				}
			}
		}
		
		public function onSelectPlaceClicked(event:MouseEvent):void
		{
			var sPlace:ChessSelectPlace=event.currentTarget as ChessSelectPlace;
			if(sPlace==null) return;
			this.host.click(this.lockX(sPlace.x),this.lockY(sPlace.y),false);
		}
		
		public function clearAllSelectPlace():void
		{
			var sPlace:ChessSelectPlace;
			while(this._selectPlace.numChildren>0)
			{
				sPlace=this._selectPlace.getChildAt(0) as ChessSelectPlace;
				if(sPlace!=null)
				{
					sPlace.buttonMode=false;
					sPlace.removeEventListener(MouseEvent.CLICK,this.onSelectPlaceClicked);
				}
				this._selectPlace.removeChildAt(0);
			}
		}
		
		public function showPlaceGrid(emptyColor:int=-1,
									  hasOwnerChessColor:int=-1,
									  hasNotOwnerChessColor:int=-1):void
		{
			if(emptyColor<0) emptyColor=DEFAULT_PLACE_COLOR_EMPTY;
			if(hasOwnerChessColor<0) hasOwnerChessColor=DEFAULT_PLACE_COLOR_HAS_OWNER;
			if(hasNotOwnerChessColor<0) hasNotOwnerChessColor=DEFAULT_PLACE_COLOR_HAS_NOT_OWNER;
			clearAllSelectPlace();
			var tempChess:Chess;
			for(var xd:uint=0;xd<this._boardSizeX;xd++)
			{
				for(var yd:uint=0;yd<this._boardSizeY;yd++)
				{
					//Detect
					if(!isInBoard(xd,yd)) continue;
					//Add
					autoAddSelectPlace(xd,yd,emptyColor,hasOwnerChessColor,hasNotOwnerChessColor);
				}
			}
		}
		
		//Move Place History
		public function addMovePlaceHistory(x:int,y:int,color:int=-1):void
		{
			var sPlace:ChessSelectPlace=new ChessSelectPlace(unlockX(x),unlockY(y),color,1,ChessSelectPlaceType.OUTLINE,this.chessDisplayWidth/100,this.chessDisplayHeight/100);
			this._movePlaceHistory.addChild(sPlace);
		}
		
		public function clearAllMovePlaceHistory():void
		{
			while(this._movePlaceHistory.numChildren>0)
			{
				this._movePlaceHistory.removeChildAt(0);
			}
		}
		
		//Select Overlay
		public function getSelectOverlayAt(x:int,y:int):ChessSelectOverlay
		{
			var tempObj:ChessSelectOverlay;
			for(var i:uint=0;i<this._selectOverlay.numChildren;i++)
			{
				if(this._selectOverlay.getChildAt(i)==null) continue;
				if(this._selectOverlay.getChildAt(i) is ChessSelectOverlay)
				{
					tempObj=this._selectOverlay.getChildAt(i) as ChessSelectOverlay;
					if(tempObj.boardX==x&&tempObj.boardY==y)
					{
						return tempObj;
					}
				}
				else
				{
					this._selectOverlay.removeChild(tempObj);
				}
			}
			return null;
		}
		
		public function hasSelectAt(x:int,y:int):Boolean
		{
			var so:ChessSelectOverlay=getSelectOverlayAt(x,y);
			return so!=null&&so.visible;
		}
		
		public function selectAt(x:int,y:int,value:Boolean=true):void
		{
			var so:ChessSelectOverlay=getSelectOverlayAt(x,y);
			if(so==null)
			{
				if(value)
				{
					var overlay:ChessSelectOverlay=new ChessSelectOverlay(this);
					overlay.boardX=x;
					overlay.boardY=y;
					this._selectOverlay.addChild(overlay);
				}
				else return;
			}
			else
			{
				so.visible=value;
			}
		}
		
		public function clearAllSelectOverlay():void
		{
			for each(var overlay:ChessSelectOverlay in this.selectList)
			{
				overlay.visible=false;
			}
		}
		
		public function removeAllSelectOverlay():void
		{
			while(this._selectOverlay.numChildren>0)
			{
				this._selectOverlay.removeChildAt(0);
			}
		}
		
		//Score Board
		public function updateScoreBoardByOwner(owner:ChessPlayer):void
		{
			var board:ChessPlayerScoreBoard;
			for(var i:uint=0;i<this._scoreBoards.numChildren;i++)
			{
				board=this._scoreBoards.getChildAt(i) as ChessPlayerScoreBoard;
				if(board==null) continue;
				if(board.linkagePlayer==owner)
				{
					board.updateDisplay();
				}
			}
		}
		
		public function updateAllScoreBoard():void
		{
			var board:ChessPlayerScoreBoard;
			for(var i:uint=0;i<this._scoreBoards.numChildren;i++)
			{
				board=this._scoreBoards.getChildAt(i) as ChessPlayerScoreBoard;
				if(board==null) continue;
				board.updateDisplay();
			}
		}
		
		public function resetAllTextValue():void
		{
			this._moveCountText.value=0;
			this._timePassedText.value=0;
		}
		
		//Reset
		public function resetBoard():void
		{
			this.removeAllChess();
			this.clearAllSelectOverlay();
			this.clearAllSelectPlace();
			this.clearAllMovePlaceHistory();
			this.updateAllScoreBoard();
			this._moveCountText.reset();
		}
	}
}