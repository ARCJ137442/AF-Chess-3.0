package ac3.Game 
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.Way.*;
	import ac3.Events.*;
	import ac3.Game.*;
	import ac3.AI.*;
	import flash.text.TextField;
	
	//Flash
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.TimerEvent;
	import flash.events.IOErrorEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.system.fscommand;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.system.Security;
	import flash.net.SharedObject;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.net.FileReference;
	
	//============Main Game============//
	public class ChessGame extends Sprite
	{
		//============Static Variables============//
		public static const STAGE_WIDTH:uint=768;
		public static const STAGE_HEIGHT:uint=768;
		
		public static const DEFAULT_PLAYER_COUNT:uint=4;
		
		public static const SHARED_OBJECT_LOCAL_NAME:String="AC3_SO";
		public static const SHARED_OBJECT_SAVE_INDEX:String="lastSave";
		public static const SAVE_FILE_NAME:String="save.txt";
		
		public static const PRINT_LOG:Boolean=Capabilities.isDebugger;
		
		//============Static Functions============//
		
		//============Instance Variables============//
		//Game
		protected var _rules:ChessRule;
		protected var _board:ChessBoard;
		
		//Debug|Display
		protected var _logs:Vector.<String>=new Vector.<String>;
		protected var _chessDisplayAsText:Boolean=false;
		
		//Playing
		protected var _players:Vector.<ChessPlayer>;
		protected var _playerTrun:uint=1;
		
		protected var _lastChessGameMode:ChessGameMode;
		protected var _lastChessGameSave:ChessGameSave;
		protected var _localSave:ChessGameSave=new ChessGameSave();
		
		//Key Control
		public var fnEnabled:Boolean=false;
		
		//Information
		protected var _timeTimer:Timer=new Timer(1000);
		
		//============Constructor Function============//
		public function ChessGame(sizeX:uint=15,
								 sizeY:uint=15,
								 playerCount:uint=DEFAULT_PLAYER_COUNT,
								 AICount:uint=DEFAULT_PLAYER_COUNT-1,
								 rules:ChessRule=null):void
		{
			//Add Log
			this.addLog("A ChessGame Created!");
			var lastTime:int=getTimer();
			//Init Variables
			this.rules=rules==null?new ChessRule():rules;
			this._board=new ChessBoard(this,0,0,sizeX,sizeY);
			this._players=new Vector.<ChessPlayer>();
			initPlayers(playerCount,AICount);
			//Add Log II
			this.addLog("The ChessGame's rules,board,players has successly inited,usage:"+(getTimer()-lastTime)+"ms!");
			//Set Event Listener
			this.addEventListener(Event.ADDED_TO_STAGE,this.init);
		}
		
		//============Destructor Function============//
		public function deleteRefences():void
		{
			this.rules=null;
			this._board=null;
			this._logs=null;
			
			this._players=null;
			this._playerTrun=0;
			
			this._lastChessGameMode=null;
			this._lastChessGameSave=null;
			this._localSave=null;
			this._timeTimer=null;
		}
		
		//============Instance Getter And Setter============//
		//========Main Functions========//
		public function get rules():ChessRule
		{
			return this._rules;
		}
		
		public function set rules(rule:ChessRule):void
		{
			if(rule!=null) this._rules=rule;
		}
		
		public function get board():ChessBoard
		{
			return this._board;
		}
		
		public function get localSave():ChessGameSave
		{
			return this._localSave;
		}
		
		public function get log():Vector.<String>
		{
			return this._logs;
		}
		
		public function get chessDisplayAsText():Boolean
		{
			return this._chessDisplayAsText;
		}
		
		public function set chessDisplayAsText(value:Boolean):void
		{
			this._chessDisplayAsText=value;
			for each(var chess:Chess in this.boardChesses)
			{
				chess.overlayDisplayAsText=value;
			}
		}
		
		public function get dateTime():String
		{
			return "["+new Date().toLocaleString()+"]";
		}
		
		public function get players():Vector.<ChessPlayer>
		{
			return this._players;
		}
		
		public function get playerCount():uint
		{
			return this._players==null?0:this._players.length;
		}
		
		//Index Start At 1
		public function get nowPlayer():ChessPlayer
		{
			if(this._playerTrun==0) return null;
			return this._players[Math.max(1,Math.min(this._playerTrun,this.playerCount))-1];
		}
		
		public function get randomPlayer():ChessPlayer
		{
			return this._players[acMath.random(this.playerCount)];
		}
		
		public function get shouldToTrunPlayer():Boolean
		{
			if(!this.nowPlayer.canClickChess) return true;
			return false;
		}
		
		public function get canContolSelfChessesPlayers():Vector.<ChessPlayer>
		{
			var returnVec:Vector.<ChessPlayer>=new Vector.<ChessPlayer>;
			for each(var player:ChessPlayer in this.players)
			{
				if(player.canContolSelfChess) returnVec.push(player);
			}
			return returnVec;
		}
		
		public function get canContolSelfChessesPlayerCount():uint
		{
			return this.canContolSelfChessesPlayers.length;
		}
		
		public function get canClickChessesPlayers():Vector.<ChessPlayer>
		{
			var returnVec:Vector.<ChessPlayer>=new Vector.<ChessPlayer>;
			for each(var player:ChessPlayer in this.players)
			{
				if(player.canClickChess) returnVec.push(player);
			}
			return returnVec;
		}
		
		public function get canClickChessesPlayerCount():uint
		{
			return this.canClickChessesPlayers.length;
		}
		
		//========Use For AI========//
		public function get boardChesses():Vector.<Chess>
		{
			return this._board.allChesses;
		}
		
		public function get boardChessCount():uint
		{
			return this.boardChesses.length;
		}
		
		public function get hasBoardChess():Boolean
		{
			return this.boardChessCount>0;
		}
		
		public function get nullChesses():Vector.<Chess>
		{
			return this.boardChesses.filter(function(c:Chess,i:uint,v:Vector.<Chess>)
											{
												return c.type==null;
											});
		}
		
		public function get nullChessCount():uint
		{
			return this.nullChesses.length;
		}
		
		public function get hasNullChess():Boolean
		{
			return this.nullChessCount>0;
		}
		
		public function get randomNullChess():Chess
		{
			var cs:Vector.<Chess>=this.nullChesses;
			return cs.length>0?cs[acMath.random(cs.length)]:null;
		}
		
		public function get captureableChesses():Vector.<Chess>
		{
			return this.boardChesses.filter(function(c:Chess,i:uint,v:Vector.<Chess>)
											{
												return c.captureable;
											});
		}
		
		public function get captureableChessCount():uint
		{
			return this.captureableChesses.length;
		}
		
		public function get hasCaptureableChess():Boolean
		{
			return this.captureableChessCount>0;
		}
		
		public function get randomCaptureableChess():Chess
		{
			var cs:Vector.<Chess>=this.captureableChesses;
			return cs.length>0?cs[acMath.random(cs.length)]:null;
		}
		
		public function get blackChesses():Vector.<Chess>
		{
			return this.boardChesses.filter(function(c:Chess,i:uint,v:Vector.<Chess>)
											{
												return c.owner==null;
											});
		}
		
		public function get blackChessCount():uint
		{
			return this.blackChesses.length;
		}
		
		public function get hasBlackChess():Boolean
		{
			return this.blackChessCount>0;
		}
		
		public function get randomBlackChess():Chess
		{
			var cs:Vector.<Chess>=this.blackChesses;
			return cs.length>0?cs[acMath.random(cs.length)]:null;
		}
		
		public function get swapableChesses():Vector.<Chess>
		{
			return this.boardChesses.filter(function(c:Chess,i:uint,v:Vector.<Chess>)
											{
												return c.owner==null;
											});
		}
		
		public function get swapableChessCount():uint
		{
			return this.swapableChesses.length;
		}
		
		public function get hasSwapableChess():Boolean
		{
			return this.swapableChessCount>0;
		}
		
		public function get randomSwapableChess():Chess
		{
			var cs:Vector.<Chess>=this.swapableChesses;
			return cs.length>0?cs[acMath.random(cs.length)]:null;
		}
		
		//============Instance Functions============//
		//========Game Init========//
		public function initPlayers(count:uint=DEFAULT_PLAYER_COUNT,
									aiCount:uint=DEFAULT_PLAYER_COUNT-1):void
		{
			for(var i:uint=0;i<count;i++)
			{
				this.appendPlayerToPlayerList(new ChessPlayer(this,-1,i>=count-aiCount?uint.MAX_VALUE:0));
			}
			this.initPlayerColors();
			this._board.frameColor=this.nowPlayer.color;
		}
		
		public function initPlayerColors():void
		{
			if(this.playerCount<1) return
			for(var i:uint=0;i<this.playerCount;i++)
			{
				this.players[i].color=Color.HSVtoHEX(i*(360/this.playerCount),100,80);
			}
		}
		
		public function init(E:Event):void
		{
			//Add Log
			this.addLog("The ChessGame has been added to stage,start init display!");
			var lastTime:int=getTimer();
			//Remove Event Listener
			this.removeEventListener(Event.ADDED_TO_STAGE,this.init);
			//Init Display
			this.addChild(this._board);
			//Add EventListener
			this.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseClick);
			this.addEventListener(MouseEvent.MOUSE_UP,this.onMouseRelease);
			this.stage.addEventListener(KeyboardEvent.KEY_DOWN,this.onGameKeyDown);
			this._board.addEventListener(ChessEvent.NEW_CHESS_ADDED,this.onChessAdded);
			this.addEventListener(ChessEvent.NEW_GAME_STARTED,this.onNewGameStarted);
			this.addEventListener(ChessEvent.BOARD_RESIZED,this.onBoardResized);
			//Start New Game
			this.setNewGameByMode(ChessGameMode.CLASSIC);
			//Start Timer
			this._timeTimer.reset();
			this._timeTimer.start();
			this._timeTimer.addEventListener(TimerEvent.TIMER,this.timeTimerTick);
			//Add Log II
			this.addLog("The ChessGame's Display has been successly inited,usage:"+(getTimer()-lastTime)+"ms!");
		}
		
		//========Game General========//
		public function resetGameByMode(mode:ChessGameMode):void
		{
			//Reset Board
			this.board.resetBoard();
			//Reset Stats
			this.localSave.reset();
			//Set Game
			setNewGameByMode(mode);
			trunPlayerTo(1);
			if(this.shouldToTrunPlayer) this.trunPlayer();
		}
		
		public function resetGameBySave(save:ChessGameSave):void
		{
			//Reset Board
			this.board.resetBoard();
			//Reset Stats
			this.localSave.reset();
			//Set Game
			this.setNewGameBySave(save);
		}
		
		public function resetGameByLast():void
		{
			if(this._lastChessGameSave!=null)
			{
				resetGameBySave(this._lastChessGameSave);
			}
			else
			{
				if(this._lastChessGameMode==null)
				{
					this._lastChessGameMode=ChessGameMode.random;
				}
				resetGameByMode(this._lastChessGameMode);
			}
		}
		
		public function setNewGameByMode(mode:ChessGameMode):void
		{
			//Add Log
			this.addLog("Setting a new game with Mode<"+mode.name+">!");
			var lastTime:int=getTimer();
			//Detect
			if(mode==null)
			{
				this.addLog("Can't load Mode<null>!");
				return;
			}
			//Update&Set
			this._lastChessGameMode=mode;
			this._lastChessGameSave=null;
			//this.rules.reset();
			this.rules.loadByMode(this._lastChessGameMode);
			this._board.putChessesPattern(this._lastChessGameMode);
			//Set Players
			for each(var player:ChessPlayer in this._players)
			{
				player.resetToNewGame();
			}
			//Update Save
			this.localSave.resetToGameGlobal(this);
			//Patch Event
			this.dispatchEvent(new ChessEvent(ChessEvent.NEW_GAME_STARTED,null,this,this._board));
			//Add Log II
			this.addLog("The new game has been successly setted,usage:"+(getTimer()-lastTime)+"ms!");
		}
		
		public function setNewGameBySave(save:ChessGameSave):void
		{
			//Add Log
			this.addLog("Setting a new game with Save["+save.toString()+"]!");
			var lastTime:int=getTimer();
			//Update&Set
			this._lastChessGameSave=save;
			this._lastChessGameMode=null;
			this.loadGameFromSave(save);
			//Set Players
			for each(var player:ChessPlayer in this._players)
			{
				player.resetToNewGame();
			}
			//Update Save
			this.localSave.resetToGameGlobal(this);
			//Patch Event
			this.dispatchEvent(new ChessEvent(ChessEvent.NEW_GAME_STARTED,null,this,this._board));
			//Add Log II
			this.addLog("The new game has been successly setted,usage:"+(getTimer()-lastTime)+"ms!");
		}
		
		public function setNewGameByLast():void
		{
			if(this._lastChessGameSave!=null)
			{
				setNewGameBySave(this._lastChessGameSave);
			}
			else
			{
				if(this._lastChessGameMode==null)
				{
					this._lastChessGameMode=ChessGameMode.random;
				}
				setNewGameByMode(this._lastChessGameMode);
			}
		}
		
		//========Game Log========//
		public function addLog(logText:String=null):void
		{
			if(logText==null||logText=="") return;
			var fullLog:String=this.dateTime+logText;
			this._logs.push(fullLog);
			if(this.board!=null) this.updateDebugText(this.board.logText,this.board.logText.visible,true);
			if(PRINT_LOG) trace(fullLog);
		}
		
		public function addLogs(...logs):void
		{
			for(var i:uint=0;i<logs.length;i++)
			{
				addLog(String(logs[i]));
			}
		}
		
		public function resetLog():void
		{
			this._logs.splice(0,this._logs.length);
			if(this.board!=null&&this.board.logText.visible) updateDebugText(this.board.logText,true,true);
		}
		
		//========Game Save And Load========//
		public function saveRuleInSave():void
		{
			this.localSave.replaceRule(this.rules.toString());
		}
		
		public function savePlayersInSave():void
		{
			var playerInfVec:Vector.<String>=new Vector.<String>;
			var tempPlayer:ChessPlayer;
			var tempInf:String;
			for(var i:uint=1;i<=this.playerCount;i++)
			{
				tempPlayer=this.getPlayerAt(i);
				tempInf=(tempPlayer==null)?"":tempPlayer.basicInformation;
				playerInfVec.push(tempInf);
			}
			this.localSave.replacePlayers(playerInfVec);
		}
		
		public function loadClickFromPoint(point:Point):void
		{
			this.clickByPoint(point,true,true,true);
		}
		
		public function saveGameToLocal():void
		{
			try
			{
				var saveString:String=this.localSave.toString();
				var sharedObj:SharedObject=SharedObject.getLocal(SHARED_OBJECT_LOCAL_NAME,"/");
				sharedObj.data[SHARED_OBJECT_SAVE_INDEX]=saveString;
				var saveOutput:String=sharedObj.flush();
				addLog("Saved game with ["+saveString+"].");
				addLog("Saved data with ["+sharedObj.data[SHARED_OBJECT_SAVE_INDEX]+"].");
				addLog("Output is {"+saveOutput+"}.");
				sharedObj=null;
			}
			catch(err:Error)
			{
				addLog("Saving Error!"+err.message);
			}
		}
		
		public function loadGameFromLocal():void
		{
			var sharedObj:SharedObject=SharedObject.getLocal(SHARED_OBJECT_LOCAL_NAME,"/");
			var saveString:String=sharedObj.data[SHARED_OBJECT_SAVE_INDEX];
			if(saveString==null)
			{
				addLog("Null!Maybe Haven't Save.");
				return;
			}
			addLog("Loaded game with ["+saveString+"].");
			this._localSave=ChessGameSave.fromString(saveString);
			addLog("Conver string to Class ChessGameSave:["+this.localSave.toString()+"]");
			addLog("Start loading game...");
			this.resetGameBySave(this.localSave);
			sharedObj=null;
		}
		
		public function loadGameFromText(text:String):void
		{
			var loadSave:ChessGameSave=ChessGameSave.fromString(text);
			this.resetGameBySave(loadSave);
		}
		
		public function loadGameByFile(fileName:String=SAVE_FILE_NAME):void
		{
			//Set Variables
			var urlR:URLRequest=new URLRequest(fileName);
			var urlL:URLLoader=new URLLoader(urlR);
			addLog("Start load save from "+urlR.url);
			//Add Event Listener
			urlL.addEventListener(Event.COMPLETE,this.onSaveLoadComplete);
			urlL.addEventListener(IOErrorEvent.IO_ERROR,this.handleFileError);
			//Start Load
			addLog("Loading "+urlR.url+"...");
			try
			{
				urlL.load(urlR);
			}
			catch(error:Error)
			{
				addLog("Loading Error!");
				addLog(error.message);
			}
		}
		
		protected function onSaveLoadComplete(event:Event):void
		{
			addLog("Loading File Complete!");
			/*try
			{*/
				var loadData:String=String(event.target.data);
				addLog("Loaded data with ["+ChessGameSave.removeInvalidInSaveString(loadData)+"]");
				//trace("Names:"+ChessGameSave.getPartNames(loadData))
				//trace("Contexts:"+ChessGameSave.getPartContexts(loadData))
				var loadSave:ChessGameSave=ChessGameSave.fromString(loadData);
				this.resetGameBySave(loadSave);
			/*}
			catch(error:Error)
			{
				addLog("Loading Data Error!");
				addLog(error.message);
			}*/
		}
		
		protected function handleFileError(event:IOErrorEvent):void
		{
			addLog("Loading IO Error!"+event.text);
		}
		
		public function loadGameFromSave(save:ChessGameSave):void
		{
			//Detect
			if(save==null)
			{
				addLog("Try To Load Null!");
				return;
			}
			//Get Global Informations
			var boardSize:Point=save.getBoardSize();
			var playerCount:uint=save.playerCount;
			var players:Vector.<String>=save.players;
			//Set Temp Variables
			var moveNum:uint;
			var tempIndex:int;
			var tempChess:Chess;
			var tempPoint:Point;
			var tempPlayer:ChessPlayer;
			var i:uint;
			//Set Player Count
			if(this.playerCount!=playerCount)
			{
				if(this.playerCount<playerCount)
				{
					for(i=this.playerCount;i<playerCount;i++)
					{
						this.appendPlayerToPlayerList(new ChessPlayer(this,-1,uint.MAX_VALUE));
					}
				}
				else
				{
					for(i=this.playerCount;i>playerCount;i--)
					{
						tempPlayer=this._players.pop();
						if(tempPlayer!=null)
						{
							tempPlayer.deleteSelf();
						}
					}
				}
				this.initPlayerColors();
				this.board.resetAllScoreBoard();
			}
			//Load Players
			for(i=1;i<=players.length;i++)
			{
				tempPlayer=this.getPlayerAt(i);
				if(tempPlayer!=null) tempPlayer.loadByInformation(players[i-1]);
			}
			//Set Board Size
			if(boardSize.x!=this.board.boardSizeX||
			   boardSize.y!=this.board.boardSizeY)
			{
				this.board.resizeOfBoard(boardSize.x,boardSize.y);
			}
			//Load Chesses After Player's And Board's Change
			var historyChesses:Vector.<Chess>=save.getHistoryChesses(this);
			var historyClick:Vector.<Point>=save.getHistoryClick();
			var historyMoveNum:Vector.<uint>=save.getHistoryMoveNum();
			//Test Before Set
			if(historyChesses.length!=historyMoveNum.length)
			{
				addLog("loadGameFromSave:Not equal length:"+historyChesses.length+":"+historyMoveNum.length+"!");
			}
			//Load Rules
			this.rules.loadByString(save.rule);
			//Temp Set Rule
			var lastBonus:Boolean=this.rules.enableSpawnBonus;
			this.rules.enableSpawnBonus=false;
			//Trun Player
			this.trunPlayerTo(save.getNowPlayer());
			//Set Game
			moveNum=0;
			do
			{
				//==Place chesses==//
				//Get Index
				tempIndex=historyMoveNum.indexOf(moveNum);
				while(tempIndex>=0)
				{
					//Get And Add Chess
					tempChess=historyChesses[tempIndex];
					if(tempChess!=null)
					{
						this._board.setNewChess2(tempChess,false);
						//addLog("loadGameFromSave:Added Chess to <"+tempChess.basicInformation+">,Index="+tempIndex+"!");
					}
					//Splice
					historyChesses.splice(tempIndex,1);
					historyMoveNum.splice(tempIndex,1);
					//Get Index
					tempIndex=historyMoveNum.indexOf(moveNum);
				}
				//Move Chesses
				if(historyClick.length>0)
				{
					tempPoint=historyClick.shift();
					this.loadClickFromPoint(tempPoint);
					addLog("loadGameFromSave:Click to "+tempPoint.toString()+"!");
				}
				//moveNum++
				moveNum++
			}
			while(historyClick.length>0)
			//Set Rule Back
			this.rules.enableSpawnBonus=lastBonus;
			//Detect Player
			if(this.nowPlayer.isAI&&!this.nowPlayer.isAIThinking)
			{
				this.nowPlayer.startAIThink();
			}
		}
		
		//========Player Function========//
		//Null:0,Red:1,Green:2,Cyan:3,Purple:4
		public function getPlayerIndex(player:ChessPlayer):uint
		{
			return this._players.indexOf(player)+1;
		}
		
		public function getChessesByOwner(owner:ChessPlayer,reverseOwner:Boolean=false,withNull:Boolean=true):Vector.<Chess>
		{
			return this.boardChesses.filter(function(c:Chess,i:uint,v:Vector.<Chess>)
									   {
										   return (withNull||c.hasOwner)&&(reverseOwner!=(c.owner==owner));
									   })
		}
		
		protected function getPlayerAt(index:uint):ChessPlayer
		{
			if(index==0||index>this.players.length||this.players==null||this.playerCount<1) return null;
			return this.players[index-1];
		}
		
		public function getPlayerByModeAt(id:uint):ChessPlayer
		{
			if(id==0||this._players==null||this.playerCount<1) return null;
			return getPlayerAt(id%playerCount==0?playerCount:id%playerCount);
		}
		
		//============Hook Functions============//
		//KeyBoard
		protected function onGameKeyDown(E:KeyboardEvent):void
		{
			this.onKeyPressed(E.keyCode,E.shiftKey,E.ctrlKey,E.altKey);
		}
		
		protected function onKeyPressed(keyCode:uint,shift:Boolean,ctrl:Boolean,alt:Boolean):void
		{
			//F5,Space,Fn
			if(this.fnEnabled)
			{
				this.fnEnabled=false;
				var n:int=-1;
				if(keyCode>KeyCode.NUM_0&&keyCode<=KeyCode.NUM_9)
				{
					n=keyCode-KeyCode.NUM_0;
				}
				if(keyCode>KeyCode.NUMPAD_0&&keyCode<=KeyCode.NUMPAD_9)
				{
					n=keyCode-KeyCode.NUMPAD_0;
				}
				if(n>=0)
				{
					onKeyPressed(KeyCode.F1+n-1,shift,ctrl,alt);
					return;
				}
			}
			if(keyCode==KeyCode.SPACE)
			{
				this.fnEnabled=true;
			}
			else if(keyCode==KeyCode.F5)
			{
				if(ctrl||shift)
				{
					this.loadGameFromText(this.board.saveText.text);
					this.board.saveText.visible=false;
				}
				else
				{
					this.toggleDebugTextVisible(this.board.saveText,this.board.logText,false,false);
				}
			}
			//If SaveText Has Been Showed,Return
			if(this.board.saveText.visible) return;
			//Exit
			if(keyCode==KeyCode.ESC)
			{
				if(shift||ctrl||alt)
				{
					fscommand("quit");
				}
				else
				{
					this.board.clearAllSelectOverlay();
					this.board.clearAllSelectPlace();
				}
			}
			switch(keyCode)
			{
				//Show Debug Grid
				case KeyCode.F1:
					if(ctrl&&shift)
					{
						
					}
					else if(ctrl)
					{
						
					}
					else if(shift)
					{
						this.chessDisplayAsText=!this.chessDisplayAsText;
					}
					else
					{
						if(this.board.hasSelectPlace) this._board.clearAllSelectPlace();
						else this._board.showPlaceGrid();
					}
					break;
				//Save Or Load Game
				case KeyCode.F2:
					if(ctrl&&shift)
					{
						this.loadGameFromLocal();
					}
					else if(shift)
					{
						this.loadGameByFile();
					}
					else if(ctrl)
					{
						this.saveGameToLocal();
					}
					else
					{
						var copySave:String=this.localSave.toString();
						System.setClipboard(copySave);
						addLog("Copy Save To Clipboard:["+copySave+"]");
					}
					break;
				case KeyCode.F3:
					if(ctrl&&shift)
					{
						this.resetAllTextValue();
						this._timeTimer.reset();
						this._timeTimer.start();
					}
					else if(ctrl)
					{
						this.resetAllPlayerScoreBoard();
					}
					else
					{
						this.resetGameByLast();
					}
					break;
				case KeyCode.F4:
					if(ctrl)
					{
						System.setClipboard(this._logs.join("	"));
					}
					else if(shift)
					{
						this.resetLog();
						//var fR:FileReference=new FileReference();
						//fR.save(this._logs.join("\n"),"AClog.txt");
					}
					else
					{
						this.toggleDebugTextVisible(this.board.logText,this.board.saveText,true,false);
					}
					break;
				//Reset Game By Mode
				case KeyCode.C:
					resetGameByMode(ChessGameMode.CLASSIC);
					break;
				case KeyCode.D:
					resetGameByMode(ChessGameMode.DEBUG);
					break;
				case KeyCode.R:
					resetGameByMode(ChessGameMode.DEFAULT);
					break;
				case KeyCode.S:
					resetGameByMode(ChessGameMode.SQUARES);
					break;
				case KeyCode.T:
					resetGameByMode(ChessGameMode.STRAIGHT);
					break;
				case KeyCode.B:
					resetGameByMode(ChessGameMode.BONUS_STORM);
					break;
				case KeyCode.X:
					resetGameByMode(ChessGameMode.X_STORM);
					break;
				case KeyCode.E:
					resetGameByMode(ChessGameMode.EPISODE);
					break;
				case KeyCode.W:
					resetGameByMode(ChessGameMode.SWAP);
					break;
				case KeyCode.M:
					resetGameByMode(ChessGameMode.MAGIC);
					break;
				case KeyCode.A:
					resetGameByMode(ChessGameMode.ADVANCE);
					break;
				case KeyCode.U:
					resetGameByMode(ChessGameMode.SURVIVAL);
					break;
				case KeyCode.O:
					resetGameByMode(ChessGameMode.COPYFROM);
					break;
				case KeyCode.N:
					resetGameByMode(ChessGameMode.DECENTRALIZED);
					break;
				case KeyCode.V:
					resetGameByMode(ChessGameMode.SURVANCE);
					break;
				case KeyCode.P:
					resetGameByMode(ChessGameMode.POWER);
					break;
				case KeyCode.Y:
					resetGameByMode(ChessGameMode.RANDOM_II);
					break;
				case KeyCode.Q:
					resetGameByMode(ChessGameMode.RANDOM_III);
					break;
				case KeyCode.I:
					resetGameByMode(ChessGameMode.INFLUENCE);
					break;
			}
			//Num:Trun AI
			if(keyCode>KeyCode.NUM_0&&keyCode<=KeyCode.NUM_9)
			{
				var player:ChessPlayer=this.getPlayerByModeAt(keyCode-KeyCode.NUM_0);
				if(player!=null)
				{
					if(this.nowPlayer==player)
					{
						this._board.clearAllSelectOverlay();
						this._board.clearAllSelectPlace();
					}
					//Change AI
					if(!ctrl&&shift)
					{
						if(!player.isAI) player.isAI=true;
						player.stopAIThink();
						player.setAI(ChessPlayer.getNextAI(player),false);
					}
					else
					{
						player.isAI=!player.isAI;
					}
					if(this.nowPlayer==player) player.initAIThink();
				}
			}
		}
		
		protected function toggleDebugTextVisible(text1:TextField,text2:TextField,updateSize:Boolean=true,updateAsLog:Boolean=true):void
		{
			text1.visible=!text1.visible;
			if(text1.visible) text2.visible=false;
			if(text1.visible)
			{
				updateDebugText(text1,updateSize,updateAsLog);
			}
		}
		
		protected function timeTimerTick(event:TimerEvent):void
		{
			this._board.timePassedText.value++;
		}
		
		protected function updateDebugText(text:TextField,updateSize:Boolean,updateAsLog:Boolean):void
		{
			if(updateAsLog) text.text=this._logs.join(String.fromCharCode(KeyCode.ENTER));
			if(updateSize) this.board.updateTextSize(text);
		}
		
		//Mouse
		protected function onMouseClick(E:MouseEvent):void
		{
			var realClickPoint:Point=this._board.getGridPos(this.stage.mouseX,this.stage.mouseY);
			this.clickByPoint(realClickPoint,false,true,true);
		}
		
		protected function onMouseRelease(E:MouseEvent):void
		{
			var realClickPoint:Point=this._board.getGridPos(this.stage.mouseX,this.stage.mouseY);
			this.clickByPoint(realClickPoint,false,true,false);
		}
		
		protected function onChessAdded(event:ChessEvent):void
		{
			//Write In Stats
			this.localSave.addChessHistory(event.currentChess,this.localSave.totalActionsDid);
		}
		
		protected function onNewGameStarted(event:ChessEvent):void
		{
			//Save Rules
			this.saveRuleInSave();
			//Save Players
			this.savePlayersInSave();
			//Save Initial Chess<Not Use>
			/*
			for each(var tempChess:Chess in this._board.allChesses)
			{
				this._save.addChessHistory(tempChess,0);
				addLog("Save initial chess with ["+tempChess.basicInformation+"].");
			}*/
		}
		
		protected function onBoardResized(event:ChessEvent):void
		{
			//Save Size
			this.localSave.replaceBoardSize(event.currentBoard.boardSizeX,event.currentBoard.boardSizeY);
		}
		
		//========Gameplay Functions========//
		public function click(clickX:int,clickY:int,forceSelect:Boolean,runFirst:Boolean=true,runSecord:Boolean=true):void
		{
			//====Set Variables====//
			//Now
			var clickedChess:Chess=this._board.getChessAt(clickX,clickY);
			var isClickChess:Boolean=clickedChess!=null;
			//Last
			var lastSelectedChess:Chess=this._board.selectedChess;
			var isSelectedChess:Boolean=lastSelectedChess!=null;
			//====Test Before Select====//
			if(!forceSelect&&nowPlayer!=null&&!this.nowPlayer.canContolByMouse) return;
			//If Should Trun Player
			if(this.shouldToTrunPlayer) this.trunPlayer();
			//====Real Select====//
			//If Selected A Chess
			if(runFirst&&isSelectedChess)
			{
				//When Select Chess Itself,Doing Nothing
				if(clickedChess==lastSelectedChess)
				{
					
				}
				else
				{
					//Clear
					this._board.clearAllSelectOverlay();
					this._board.clearAllSelectPlace();
					//If Chess Can Move To
					if(testPlayerCanMoveChess(lastSelectedChess,
					   clickX,clickY))
					{
						onPlayerMoveChess(lastSelectedChess,
										  lastSelectedChess.boardX,
										  lastSelectedChess.boardY,
										  clickX,clickY);
					}
					//Maybe Select Self's Chess
					else if(isClickChess&&clickedChess.owner==this.nowPlayer)
					{
						onPlayerSelectChess(clickedChess,clickX,clickY);
					}
				}
			}
			//Secord Part
			else if(runSecord)
			{
				//Clear
				this._board.clearAllSelectOverlay();
				this._board.clearAllSelectPlace();
				//Maybe Select A New Chess
				if(isClickChess)
				{
					onPlayerSelectChess(clickedChess,clickX,clickY);
				}
				//Select Nothing,Doing Nothing
				else
				{
					
				}
			}
			//addLog(realClickPoint,isClickChess?(Color.HEXtoHSV(clickedChess.color)[0]):-1)
		}
		
		public function clickByPoint(point:Point,forceSelect:Boolean,runFirst:Boolean=true,runSecord:Boolean=true):void
		{
			if(point==null) return;
			this.click(Math.floor(point.x),Math.floor(point.y),forceSelect,runFirst,runSecord);
		}
		
		protected function onPlayerSelectChess(clickedChess:Chess,clickX:int,clickY:int):void
		{
			//Swap NULL Chess
			if(clickedChess.type==ChessType.NULL)
			{
				if(clickedChess.owner==null) clickedChess.owner=this.randomPlayer;
				clickedChess.type=ChessType.getRandomInTypes(this.rules.swapableChessTypes);
				clickedChess.updateMoveWaysByType();
				dealGameRuleAfterAction(this.nowPlayer);
				return;
			}
			//Open Random Chess
			else if(clickedChess.type==ChessType.Ra&&clickedChess.owner==this.nowPlayer)
			{
				clickedChess.type=ChessType.getRandomInTypes(this.rules.swapableChessTypes);
				clickedChess.updateMoveWaysByType();
				dealGameRuleAfterAction(this.nowPlayer);
				return
			}
			//Detect Owner,MoveStepLeft
			if(clickedChess.owner==this.nowPlayer&&
			   clickedChess.actionDidInTrun<this.rules.maxActionDoingPerChess)
			{
				//Detect AI
				if(this.nowPlayer.canContolByMouse||this.nowPlayer.isAI)
				{
					this._board.selectAt(clickX,clickY);
					clickedChess.drawMovePlaces();
				}
			}
		}
		
		protected function testPlayerCanMoveChess(chess:Chess,targetX:int,targetY:int):Boolean
		{
			//Don't Move Outside & Check Move In Places
			return (this._board.isInBoard(targetX,targetY)&&chess.isInWay(targetX,targetY));
		}
		
		protected function onPlayerMoveChess(chess:Chess,x1:int,y1:int,x2:int,y2:int):void
		{
			if(!testPlayerCanMoveChess(chess,x2,y2)) return;
			//Write In Stats
			this.localSave.addClickHistory(new Point(x1,y1));
			this.localSave.addClickHistory(new Point(x2,y2));
			//Move
			reallyMoveChess(chess,chess.getPointInWay(x2,y2,true),chess);
			//Add Count
			this._board.moveCountText.value++;
		}
		
		public function reallyMoveChess(chess:Chess,wayPoint:ChessWayPoint,ownerChess:Chess,dealGameRule:Boolean=true):void
		{
			//Set Variables
			var targetChess:Chess=this._board.getChessAt(wayPoint.x,wayPoint.y);
			var targetChessOwner:ChessPlayer=targetChess==null?null:targetChess.owner;
			var moveAfter:Boolean=true,successlyMove:Boolean=true;
			var player:ChessPlayer=chess.owner;
			var willingAddScore:uint=0;
			var lastChessX:int=chess.boardX;
			var lastChessY:int=chess.boardY;
			//Clear
			this._board.clearAllSelectPlace();
			//Move Through Chesses
			if(wayPoint.type==ChessWayPointType.THROUGH)
			{
				moveAfter=false;
				var vx:int=acMath.sgn(wayPoint.x-lastChessX);
				var vy:int=acMath.sgn(wayPoint.y-lastChessY);
				var nowX:int=chess.boardX;
				var nowY:int=chess.boardY;
				var nowTargetChess:Chess;
				var xMove:Boolean=true,yMove:Boolean=true;
				while(xMove||yMove)
				{
					if(!this.board.isActiveChess(chess)) break;
					if(nowX==wayPoint.x&&nowY==wayPoint.y) break;
					xMove=vx==acMath.sgn(wayPoint.x-lastChessX);
					yMove=vy==acMath.sgn(wayPoint.y-lastChessY);
					nowX+=vx;
					nowY+=vy;
					if(!this.board.isInBoard(nowX,nowY)) continue;
					nowTargetChess=this.board.getChessAt(nowX,nowY);
					if(Chess.checkConditionAt(ownerChess,nowX,nowY,ownerChess.owner,ChessMoveCondition.HAS_ALLY_CHESS)||
					   nowTargetChess!=null&&
					   (ChessType.getImmuneActions(nowTargetChess.type)||
					   nowTargetChess.owner==null&&
					   !nowTargetChess.captureable))
					{
						continue;
					}
					else
					{
						reallyMoveChess(chess,new ChessWayPoint(nowX,nowY,ChessWayPointType.MOVE_AND_ATTACK),chess,false);
					}
				}
				/*var distance:Number=acMath.getDistance(lastChessX,lastChessY,wayPoint.x,wayPoint.y)*2;
				var lastX:int,lastY:int;
				if(isNaN(distance)||!isFinite(distance))
				{
					addLog("reallyMoveChess:Distance Error by "+lastChessX+","+lastChessY+","+wayPoint.x+","+wayPoint.y+"!");
				}
				var n:uint=0;
				while(n>=0&&n<distance)
				{
					n++;
					nowX=n/distance*wayPoint.x+(distance-n)/distance*lastChessX;
					nowY=n/distance*wayPoint.y+(distance-n)/distance*lastChessY;
					if(!this.board.isActiveChess(chess)) break;
					if(!this.board.isInBoard(nowX,nowY)) break;
					if(nowX==lastX&&nowY==lastY||nowX==lastChessX&&nowY==lastChessY) continue;
					nowTargetChess=this.board.getChessAt(nowX,nowY);
					if(Chess.checkConditionAt(ownerChess,nowX,nowY,ownerChess.owner,ChessMoveCondition.HAS_ALLY_CHESS)||
					   nowTargetChess!=null&&
					   (ChessType.getImmuneAttack(nowTargetChess.type)||
					   nowTargetChess.owner==null&&
					   !ChessType.getCanBeCapture(nowTargetChess.type)))
					{
						lastX=nowX,lastY=nowY;
						continue;
					}
					else
					{
						reallyMoveChess(chess,new ChessWayPoint(nowX,nowY,ChessWayPointType.MOVE_AND_ATTACK),chess,false);
					}
					lastX=nowX,lastY=nowY;
				}*/
			}
			//If Has Chess
			else if(targetChess!=null)
			{
				//Load Rule
				moveAfter=this.rules.moveChessAfterEat&&wayPoint.type!=ChessWayPointType.NULL;
				//Swap With Chess
				if(wayPoint.type==ChessWayPointType.SWAP)
				{
					successlyMove=false;
					//Hide Other
					var targetX:int=targetChess.boardX;
					var targetY:int=targetChess.boardY;
					this._board.hideChessOutOfBoard(targetChess);
					this.reallyMoveChess(chess,
										 new ChessWayPoint(targetX,targetY,ChessWayPointType.MOVE),
										 chess,false);
					this.reallyMoveChess(targetChess,
										 new ChessWayPoint(lastChessX,lastChessY,ChessWayPointType.MOVE),
										 chess,false);
					targetChess.visible=true;
				}
				//Absorption Level With Other Chess
				else if(wayPoint.type==ChessWayPointType.ABSORPTION_LEVEL)
				{
					chess.level+=targetChess.level;
					targetChess.level=0;
					moveAfter=false;
				}
				//Transfer Level With Other Chess
				else if(wayPoint.type==ChessWayPointType.TRANSFER_LEVEL)
				{
					targetChess.level+=chess.level;
					chess.level=0;
					moveAfter=false;
				}
				//Capture Chess<owner had Chess>
				else if(ownerChess.owner!=null&&targetChess.captureable)
				{
					if(targetChess.type==ChessType.Ra)
					{
						targetChess.type=ChessType.randomEnableWithoutUnknown;
						targetChess.updateMoveWaysByType();
					}
					targetChess.owner=ownerChess.owner;
					moveAfter=false;
				}
				//If Immune Actions
				else if(targetChess.immuneActions)
				{
					moveAfter=false;
				}
				//Eat Chess
				else if(wayPoint.type!=ChessWayPointType.NULL&&
						wayPoint.moveSpecialAbility==ChessWayPointType.SPECIAL_NULL)
				{
					ownerChess.level+=targetChess.level+1;
					willingAddScore+=targetChess.score;
					targetChess.level=0;
					//Set Stats
					if(targetChessOwner!=null)
					{
						targetChessOwner.lastAttackerChess=ownerChess;
						targetChessOwner.lastVictimChess=targetChess;
						targetChessOwner.lastAttackerType=ChessWayPointType.ATTACK;
					}
					//Suicide
					if(ChessType.getSuicideOnEat(targetChess.type)||
					   ChessType.getSuicideOnEat(chess.type))
					{
						this._board.removeChess(chess);
						this._board.removeChess(targetChess);
						moveAfter=false;
					}
					//Copy Move Ways
					if(ChessType.getCopyMoveWaysOnEat(chess.type)&&
					   ChessType.getCanBeCopyWay(targetChess.type))
					{
						chess.moveWays=targetChess.moveWays.concat();
					}
				}
				//Use Special
				else
				{
					switch(wayPoint.moveSpecialAbility)
					{
						case ChessWayPointType.SPECIAL_MIND_CONTOL:
							if(targetChess.hasBeMindContol) break;
							targetChessOwner.lastAttackerChess=chess;
							targetChessOwner.lastVictimChess=targetChess;
							targetChessOwner.lastAttackerType=ChessWayPointType.SPECIAL_MIND_CONTOL;
							chess.mindContol(targetChess);
							ownerChess.level++;
							willingAddScore+=targetChess.scoreWeight;
							break;
						case ChessWayPointType.SPECIAL_INFLUENCE:
							var selfDamage:uint=chess.level+1;
							if(targetChess.level>=selfDamage)
							{
								targetChess.level-=selfDamage;
							}
							//Success Influence
							else
							{
								targetChessOwner.lastAttackerChess=chess;
								targetChessOwner.lastVictimChess=targetChess;
								targetChessOwner.lastAttackerType=ChessWayPointType.SPECIAL_INFLUENCE;
								chess.level=selfDamage-targetChess.level-1;
								targetChess.level=1;
								targetChess.owner=chess.owner;
								targetChess.type=chess.type;
								targetChess.releaseAllMindContol();
								targetChess.updateMoveWaysByType();
								willingAddScore+=targetChess.level;
							}
							break;
						case ChessWayPointType.SPECIAL_DESTROY:
							moveAfter=false;
							ownerChess.level++;
							willingAddScore+=targetChess.score;
							targetChess.level=0;
							//Set Stats
							targetChessOwner.lastAttackerChess=ownerChess;
							targetChessOwner.lastVictimChess=targetChess;
							targetChessOwner.lastAttackerType=ChessWayPointType.SPECIAL_DESTROY;
							//Suicide
							if(ChessType.getSuicideOnEat(chess.type))
							{
								this._board.removeChess(chess);
							}
							//Copy Move Ways
							if(ChessType.getCopyMoveWaysOnEat(chess.type))
							{
								chess.moveWays=targetChess.moveWays;
							}
							this._board.removeChess(targetChess);
							break;
						case ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL:
							moveAfter=false;
							targetChessOwner.lastAttackerChess=chess;
							targetChessOwner.lastVictimChess=targetChess;
							targetChessOwner.lastAttackerType=ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL;
							targetChess.owner=null;
							ownerChess.level++;
							willingAddScore+=targetChess.scoreWeight;
							break;
					}
					moveAfter=false;
				}
			}
			else
			{
				//Deal Teleport
				if(wayPoint.type==ChessWayPointType.TELEPORT)
				{
					if(ChessType.getUseLevelOnTeleport(chess.type)&&chess.level>0)
					{
						chess.level--;
					}
				}
				//Use Special II
				switch(wayPoint.moveSpecialAbility)
				{
					case ChessWayPointType.SPECIAL_SUMMON_LIFED_CHESS:
						var tC:Chess=this._board.setNewChess(wayPoint.x,wayPoint.y,ownerChess.owner,ChessType.getRandomInTypes(this.rules.spawnerSpawnableTypes),false,false);
						tC.life=this.rules.spawnerSpawnLife+1;
						tC.lifeUsingOnMove=this.rules.spawnerSpawnLifeUsingPerMove;
						tC.lifeUsingOnTurn=this.rules.spawnerSpawnLifeUsingPerTrun;
						tC.updateDisplay(false,false,true);
						moveAfter=false;
						break;
				}
			}
			//Successry Move
			if(moveAfter)
			{
				//Use Special
				var tempChess:Chess;
				switch(wayPoint.moveSpecialAbility)
				{
					case ChessWayPointType.SPECIAL_MOVE_OTHER_CHESS:
						successlyMove=false;
						var willMoveChesses:Vector.<Chess>=new Vector.<Chess>;
						var chessOldWayPoints:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
						var willMoveWayPoints:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
						//Hide Other
						for(var xv:int=-1;xv<=1;xv++)
						{
							for(var yv:int=-1;yv<=1;yv++)
							{
								if(xv==0&&yv==xv) continue;
								tempChess=_board.getChessAt(chess.boardX+xv,chess.boardY+yv);
								if(tempChess==null||ChessType.getImmuneActions(tempChess.type))
								{
									continue;
								}
								if(!this._board.isInBoard(wayPoint.x+xv,wayPoint.y+yv))
								{
									continue;
								}
								willMoveChesses.push(tempChess);
								chessOldWayPoints.push(tempChess.boardWayPoint);
								willMoveWayPoints.push(new ChessWayPoint(wayPoint.x+xv,wayPoint.y+yv,ChessWayPointType.MOVE_AND_ATTACK));
								this._board.hideChessOutOfBoard(tempChess);
							}
						}
						//Hide Self
						willMoveChesses.push(chess);
						willMoveWayPoints.push(new ChessWayPoint(wayPoint.x,wayPoint.y,ChessWayPointType.MOVE_AND_ATTACK));
						this._board.hideChessOutOfBoard(chess);
						//Move
						for(var i:uint=0;i<willMoveChesses.length;i++)
						{
							//Try To Move To The Target Place
							this.reallyMoveChess(willMoveChesses[i],
												 willMoveWayPoints[i],
												 chess,false);
							//If Chess Still Out Of The Board,Move To Original Place
							for(var j:uint=0;j<10&&!this._board.isInBoard3(willMoveChesses[i].boardWayPoint);j++)
							{
								this.reallyMoveChess(willMoveChesses[i],
													 chessOldWayPoints[i],
													 chess,false);
							}
							//If Chess Still Out Of The Board,Remove That
							if(!this._board.isInBoard3(willMoveChesses[i].boardWayPoint))
							{
								addLog("Invalid Carring from "+willMoveChesses[i].boardPoint.toString()+" to "+willMoveWayPoints[i].toString());
								this.board.removeChess(willMoveChesses[i]);
								continue;
							}
							//Final Detect
							if(!this.board.isInBoard(willMoveChesses[i].boardX,willMoveChesses[i].boardY))
							{
								addLog("Try To Move Chess Out Of Board!Arguments:"+arguments);
							}
							willMoveChesses[i].visible=true;
						}
						break;
					case ChessWayPointType.SPECIAL_CREATE_MOVE_PLACES:
						chess.createMovePlacesByWayPoint(wayPoint.boardToChess(chess).removeSpecial());
						break;
				}
				//Real Move
				if(successlyMove) this._board.moveChess(chess,wayPoint.x,wayPoint.y);
				//addLog("successly Move!"+getPlayerIndex(chess.owner),wayPoint.x,wayPoint.y);
			}
			//Add Score
			if(willingAddScore>0) ownerChess.owner.score+=willingAddScore;
			//Deal With Game Rule
			if(dealGameRule)
			{
				//Add Move History
				this.board.clearAllMovePlaceHistory();
				this.board.addMovePlaceHistory(lastChessX,lastChessY,0x000000);
				this.board.addMovePlaceHistory(wayPoint.x,wayPoint.y,0xffffff);
				//Deal Life
				if(chess.life>0) chess.usingLife(chess.lifeUsingOnMove);
				//Deal Stats
				chess.totalActionsDid++;
				//Deal Action Did In Trun
				chess.actionDidInTrun++;
				this.dealGameRuleAfterAction(player);
			}
		}
		
		public function dealGameRuleAfterAction(nowPlayer:ChessPlayer):void
		{
			//Deal Stats
			nowPlayer.actionDidInTrun++;
			nowPlayer.totalActionsDid++;
			//Add Bonus Chess
			if(this.rules.enableSpawnBonus&&
			   this.boardChessCount<this.rules.bonusSpawnLimitCount&&
			   General.randomBoolean2(this.rules.getFinalBonusSpawnChance(this.boardChessCount)))
			{
				randomAddBonusChessByRule();
			}
			//Detect All Player
			detectAllPlayer();
			//Try To Trun Player
			if(this.shouldToTrunPlayer)//Not Has Enough Move Chance
			{
				//Release Move Count
				nowPlayer.actionDidInTrun=0;
				//Deal Chess Life
				for each(var tempChess:Chess in nowPlayer.handleChesses)
				{
					//Set moveCountLeftInTrun
					tempChess.actionDidInTrun=0;
					//Deal Life
					if(tempChess.life>0) tempChess.usingLife(tempChess.lifeUsingOnTurn);
					//Generate Level
					if(tempChess.levelGenerateLimit<0||tempChess.level<tempChess.levelGenerateLimit)
					{
						tempChess.usingLevel(tempChess.levelGenerateOnTrun);
					}
				}
				//Trun Player
				trunPlayer();
			}
			//Detect Victory
			if(this.rules.enableDetectWin) detectVictory();
		}
		
		public function trunPlayer():void
		{
			//Loop
			var i:uint=0;
			do
			{
				this._playerTrun=Math.max(1,(this._playerTrun+1)%(this.playerCount+1));//Start On 1
				//Update Chesses
				var chess:Chess;
				for each(chess in nowPlayer.handleChesses)
				{
					//Deal Life
					if(chess.life<=0)
					{
						this.board.removeChess(chess);
						continue;
					}
				}
				i++;
			}
			while(this.shouldToTrunPlayer&&i<this.playerCount)
			//Set
			this._board.frameColor=this.nowPlayer.color;
			//Update
			onPlayerTruned(this.nowPlayer);
		}
		
		public function trunPlayerBy(player:ChessPlayer):void
		{
			//if(this.getPlayerIndex(player)==0||!player.canClickChess) return;
			//Set
			this._playerTrun=this.getPlayerIndex(player);
			this._board.frameColor=this.nowPlayer.color;
			//Update
			onPlayerTruned(this.nowPlayer);
		}
		
		public function trunPlayerTo(index:uint):void
		{
			//if(!this.getPlayerByModeAt(index).canClickChess) return;
			//Set
			this._playerTrun=index;
			this._board.frameColor=ChessPlayer.getColor(this.nowPlayer);
			//Update
			onPlayerTruned(this.nowPlayer);
		}
		
		protected function onPlayerTruned(nowPlayer:ChessPlayer):void
		{
			//Active Player AI
			if(nowPlayer!=null&&nowPlayer.isAI) nowPlayer.startAIThink();
			//Detect Player
			if(!detectPlayer(nowPlayer)) return;
			//Detect Trun
			if(this.shouldToTrunPlayer)
			{
				trunPlayer();
				return;
			}
			//Update Save
			this.localSave.replaceNowPlayer(this._playerTrun);
			//Chess updateButtonMode
			for each(var chess:Chess in this.boardChesses)
			{
				chess.updateButtonMode(false);
			}
			for each(chess in nowPlayer.clickableChesses)
			{
				chess.updateButtonModeByPlayer(nowPlayer);
			}
		}
		
		protected function detectPlayer(player:ChessPlayer):Boolean
		{
			if(player==null||!player.canClickChess) return false;
			var newHasImportmentChess:Boolean=player.hasImportmentChess;
			if(!player.lastHasImportmentChess&&newHasImportmentChess)
			{
				player.lastHasImportmentChess=newHasImportmentChess;
			}
			//When Player Lost All Importment Chess
			else if(player.lastHasImportmentChess&&!newHasImportmentChess)
			{
				player.lost(player.lastAttackerChess);
				return false;
			}
			player.lastHasImportmentChess=newHasImportmentChess;
			return true;
		}
		
		protected function detectAllPlayer():void
		{
			for each(var player:ChessPlayer in this.players)
			{
				detectPlayer(player);
			}
		}
		
		public function detectVictory():void
		{
			var alivePlayerCount:uint=this.canClickChessesPlayerCount;
			//If Only One Player
			if(alivePlayerCount>1) return;
			else if(alivePlayerCount==1)
			{
				onPlayerWin(this.canClickChessesPlayers[0]);
			}
			//If No Player Win
			else
			{
				onPlayerWin(null);
			}
		}
		
		protected function onPlayerWin(winner:ChessPlayer):void
		{
			if(winner!=null)
			{
				winner.winCount++;
				addLog("Player "+winner.gameIndex+"<"+winner.typeName+"> Win!Use "+this.board.moveCountText.value+" moveSteps");
			}
			else
			{
				addLog("No Player Win!Use "+this.board.moveCountText.value+" moveSteps");
			}
			//Set New Game
			resetGameByLast();
		}
		
		public function randomAddBonusChessByRule():void
		{
			var rx:int,ry:int;
			var count:uint=1;
			var importment:Boolean;
			var willSpawnChess:Chess;
			var willSpawnType:ChessType;
			var willSpawnLife:ChessType;
			if(General.randomBoolean2(this.rules.bonusChessGroupSpawnChance))
			{
				count=1+acMath.random(this.rules.maxBonusChessCountAtOnce);
			}
			for(;count>0;count--)
			{
				willSpawnType=ChessType.getRandomInTypes(this.rules.spawnableBonusTypes);
				importment=General.randomBoolean2(this.rules.bonusImportmentChance);
				willSpawnChess=new Chess(this,-1,-1,willSpawnType,null);
				willSpawnChess.life=acMath.randomBetween(this.rules.bonusSpawnLifeLeast,this.rules.bonusSpawnLifeMost,false);
				willSpawnChess.lifeUsingOnMove=this.rules.bonusSpawnLifeUsePerMove;
				willSpawnChess.lifeUsingOnTurn=this.rules.bonusSpawnLifeUsePerTrun;
				willSpawnChess.importment=importment;
				this._board.randomPutChess2(willSpawnChess,false);
			}
		}
		
		//========Player About Functions========//
		public function appendPlayerToPlayerList(player:ChessPlayer):void
		{
			if(this._players.indexOf(player)>=0) return;
			this._players.push(player);
		}
		
		public function removeAllPlayer():void
		{
			//reset players
			for each(var player:ChessPlayer in this.players)
			{
				player.deleteSelf();
			}
			this._players.splice(0,this.playerCount);
		}
		
		public function resetAllPlayerScoreBoard():void
		{
			for each(var player:ChessPlayer in this._players)
			{
				player.resetScoreBoard();
			}
		}
		
		public function resetAllTextValue():void
		{
			this._board.resetAllTextValue();
		}
	}
}