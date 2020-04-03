package ac3.Game 
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Game.*;
	import ac3.AI.*;
	
	//Flash
	import flash.display.Sprite;
	import flash.display.Shape;
	import flash.display.BlendMode;
	import flash.geom.Point;
	
	public class ChessGameSave extends Object
	{
		//============Static Variables============//
		public static const UNIT_DELIM:String=";";
		public static const POINT_DELIM:String=",";
		public static const CHESS_NUM_DELIM:String="/";
		public static const PART_SIGN_LEFT:String="[";
		public static const PART_SIGN_RIGHT:String="]";
		public static const LINE_DELIM:String="";
		
		public static const PART_NAME_ChessHistory:String="ChessHistory";
		public static const PART_NAME_ClickHistory:String="ClickHistory";
		public static const PART_NAME_Rule:String="Rule";
		public static const PART_NAME_BoardSize:String="BoardSize";
		public static const PART_NAME_Players:String="Players";
		public static const PART_NAME_PlayerSettings:String="PlayerSettings";
		public static const PART_NAME_PlayerCount:String="PlayerCount";
		public static const PART_NAME_NowPlayer:String="NowPlayer";
		
		//============Static Functions============//
		public static function encapsulateToString(strings:Vector.<String>,delim:String=UNIT_DELIM):String
		{
			var result:String="";
			for(var i:uint=0;i<strings.length;i++)
			{
				result+=strings[i];
				if(i<strings.length-1) result+=delim;
			}
			return result;
		}
		
		//====Convertion====//
		//Vector.<Chess>,Vector.<uint>|Vector.<Point> --> Vector.<String>
		//0 means initial chess
		public static function createChessHistory(chesses:Vector.<Chess>,stepNums:Vector.<uint>):Vector.<String>
		{
			var result:Vector.<String>=new Vector.<String>;
			var tempStep:uint;
			if(chesses==null||chesses.length<1) return result;
			if(chesses.length!=stepNums.length)
			{
				trace("createBonusHistory:Not equal length!");
			}
			for(var i:uint=0;i<chesses.length;i++)
			{
				tempStep=(i<stepNums.length)?stepNums[i]:1;
				result.push(chesses[i].basicInformation+CHESS_NUM_DELIM+tempStep);
			}
			return result;
		}
		
		public static function createClickHistory(clickHistory:Vector.<Point>):Vector.<String>
		{
			var result:Vector.<String>=new Vector.<String>;
			if(clickHistory==null||clickHistory.length<1) return result;
			for each(var click:Point in clickHistory)
			{
				result.push(Math.floor(click.x)+POINT_DELIM+Math.floor(click.y));
			}
			return result;
		}
		
		//Vector.<String> --> Vector.<Chess>,Vector.<uint>|Vector.<Point>,Vector.<ChessPlayer>
		public static function fromChessHistoryToChesses(host:ChessGame,history:Vector.<String>):Vector.<Chess>
		{
			var result:Vector.<Chess>=new Vector.<Chess>;
			if(history==null||history.length<1) return result;
			var tempChess:Chess;
			for(var i:uint=0;i<history.length;i++)
			{
				tempChess=Chess.fromInformation(host,history[i].split(CHESS_NUM_DELIM)[0],POINT_DELIM);
				result.push(tempChess);
			}
			return result;
		}
		
		public static function fromChessHistoryToMoveNums(history:Vector.<String>):Vector.<uint>
		{
			var result:Vector.<uint>=new Vector.<uint>;
			if(history==null||history.length<1) return result;
			var tempNum:uint;
			for(var i:uint=0;i<history.length;i++)
			{
				tempNum=uint(history[i].split(CHESS_NUM_DELIM)[1]);
				result.push(tempNum);
			}
			return result;
		}
		
		public static function fromClickHistoryToPoints(history:Vector.<String>):Vector.<Point>
		{
			var result:Vector.<Point>=new Vector.<Point>;
			if(history==null||history.length<1) return result;
			var splitArr:Array;
			var tempPoint:Point;
			for(var i:uint=0;i<history.length;i++)
			{
				splitArr=history[i].split(POINT_DELIM);
				tempPoint=new Point(int(splitArr[0]),int(splitArr[1]));
				result.push(tempPoint);
			}
			return result;
		}
		
		public static function fromPlayersToChessPlayers(host:ChessGame,players:Vector.<String>):Vector.<ChessPlayer>
		{
			var result:Vector.<ChessPlayer>=new Vector.<ChessPlayer>;
			if(players==null||players.length<1) return result;
			var tempPlayer:ChessPlayer;
			for(var i:uint=0;i<players.length;i++)
			{
				tempPlayer=ChessPlayer.fromInformation(host,players[i],UNIT_DELIM);
				result.push(tempPlayer);
			}
			return result;
		}
		
		//String --> Vector.<String>
		public static function fromStringToVector(string:String,delim:String=UNIT_DELIM):Vector.<String>
		{
			var result:Vector.<String>=new Vector.<String>;
			if(string==null||string.length<1) return result;
			var splitStrings:Array=string.split(delim);
			for each(var tempString:String in splitStrings)
			{
				result.push(tempString);
			}
			return result;
		}
		
		public static function fromStringToChessHistory(string:String):Vector.<String>
		{
			return fromStringToVector(string);
		}
		
		public static function fromStringToClickHistory(string:String):Vector.<String>
		{
			return fromStringToVector(string);
		}
		
		public static function fromStringToPlayers(string:String):Vector.<String>
		{
			return fromStringToVector(string);
		}
		
		//String --> ChessGameSave
		public static function fromString(string:String):ChessGameSave
		{
			var chessHistory:Vector.<String>;
			var clickHistory:Vector.<String>;
			var rule:String;
			var boardSize:Point;
			var playerCount:uint;
			var nowPlayer:int;
			var players:Vector.<String>;
			//Operation
			//Clear \n,\r,\t
			var currentString:String=removeInvalidInSaveString(string);
			chessHistory=fromStringToChessHistory(getPartContextByName(currentString,PART_NAME_ChessHistory));
			clickHistory=fromStringToClickHistory(getPartContextByName(currentString,PART_NAME_ClickHistory));
			rule=getPartContextByName(currentString,PART_NAME_Rule);
			boardSize=parseToPoint(getPartContextByName(currentString,PART_NAME_BoardSize));
			playerCount=uint(getPartContextByName(currentString,PART_NAME_PlayerCount));
			nowPlayer=uint(getPartContextByName(currentString,PART_NAME_NowPlayer));
			trace("a:"+getPartContextByName(currentString,PART_NAME_Players))
			players=fromStringToPlayers(getPartContextByName(currentString,PART_NAME_Players));
			//Return
			return new ChessGameSave(chessHistory,clickHistory,rule,boardSize.x,boardSize.y,playerCount,nowPlayer,players);
		}
		
		//<This's unfinished>
		//ChessGameSave --> Object
		public static function toObject(save:ChessGameSave):Object
		{
			//Set Result
			var result:Object=new Object();
			//Operate
			
			//Return
			return result;
		}
		
		//Object --> ChessGameSave
		public static function fromObject(object:Object):ChessGameSave
		{
			//Set Result
			var result:ChessGameSave=new ChessGameSave();
			//Operate
			
			//Return
			return result;
		}
		
		//String --> Point
		public static function parseToPoint(string:String,delim:String=POINT_DELIM):Point
		{
			if(string==null||string.length<1)
			{
				return new Point(ChessBoard.DEFAULT_BOARD_SIZE_X,ChessBoard.DEFAULT_BOARD_SIZE_Y);
			}
			var splitArr:Array=string.split(delim);
			if(splitArr==null||splitArr.length<1)
			{
				return new Point(ChessBoard.DEFAULT_BOARD_SIZE_X,ChessBoard.DEFAULT_BOARD_SIZE_Y);
			}
			return new Point(int(splitArr[0]),int(splitArr[1]));
		}
		
		//Deal With The <String>Save Text
		public static function getPartSign(partName:String):String
		{
			return PART_SIGN_LEFT+partName+PART_SIGN_RIGHT;
		}
		
		public static function getPartContextByName(text:String,partName:String):String
		{
			//Set Result
			var result:String="";
			//Operate
			var sign:String=getPartSign(partName);
			var index:int=text.indexOf(sign);
			var startIndex:int;
			var endIndex:int;
			if(index>=0)
			{
				startIndex=index+sign.length;
				endIndex=text.indexOf(PART_SIGN_LEFT,startIndex);
				endIndex=endIndex<0?int.MAX_VALUE:endIndex;
				result=text.slice(startIndex,endIndex);
			}
			//Return
			return result;
		}
		
		public static function getPartNames(text:String):Vector.<String>
		{
			//Set Result
			var result:Vector.<String>=new Vector.<String>;
			//Operate
			var index:int=-1;
			var startIndex:int;
			var endIndex:int;
			//trace("text.length="+text.length)
			while(index<text.length)
			{
				startIndex=text.indexOf(PART_SIGN_LEFT,index);
				if(startIndex<0) break;
				endIndex=text.indexOf(PART_SIGN_RIGHT,startIndex);
				endIndex=endIndex>=0?endIndex:int.MAX_VALUE;
				result.push(text.slice(startIndex+1,endIndex));
				index=endIndex;
			}
			//Return
			return result;
		}
		
		public static function getPartContexts(text:String):Vector.<String>
		{
			//Set Result
			var result:Vector.<String>=new Vector.<String>;
			//Operate
			var names:Vector.<String>=getPartNames(text);
			for(var i:uint=0;i<names.length;i++)
			{
				result.push(getPartContextByName(text,names[i]));
			}
			//Return
			return result;
		}
		
		public static function removeInvalidInSaveString(string:String):String
		{
			return General.clearCharsInString(string,"\n","\r","\t");
		}
		
		//============Instance Variables============//
		//Game General
		protected var _boardSize:String;
		
		//Player
		protected var _playerCount:uint;
		protected var _nowPlayer:uint;
		protected var _players:Vector.<String>;
		
		//Chess And Click
		protected var _clickHistory:Vector.<String>;
		protected var _chessHistory:Vector.<String>;
		
		//Rule
		protected var _rule:String;
		
		//============Constructor Function============//
		public function ChessGameSave(chessHistory:Vector.<String>=null,
									 clickHistory:Vector.<String>=null,
									 rule:String=null,
									 boardSizeX:uint=15,
									 boardSizeY:uint=15,
									 playerCount:uint=4,
									 nowPlayer:uint=1,
									 players:Vector.<String>=null):void
		{
			this._chessHistory=(chessHistory==null)?new Vector.<String>:chessHistory;
			this._clickHistory=(clickHistory==null)?new Vector.<String>:clickHistory;
			this._rule=(rule==null)?"":rule;
			this.replaceBoardSize(boardSizeX,boardSizeY);
			this._playerCount=playerCount;
			this._nowPlayer=nowPlayer;
			this._players=(players==null)?new Vector.<String>:players;
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this._clickHistory=null;
			this._chessHistory=null;
			this._boardSize="";
			this._rule="";
			this._playerCount=0;
			this._nowPlayer=0;
			this._players=null;
		}
		
		//============Instance Getter And Setter============//
		public function get chessHistory():Vector.<String>
		{
			return this._chessHistory;
		}
		
		public function get clickHistory():Vector.<String>
		{
			return this._clickHistory;
		}
		
		public function get rule():String
		{
			return this._rule;
		}
		
		public function get boardSize():String
		{
			return this._boardSize;
		}
		
		public function get playerCount():uint
		{
			return this._playerCount;
		}
		
		public function get nowPlayer():uint
		{
			return this._nowPlayer;
		}
		
		public function get players():Vector.<String>
		{
			return this._players;
		}
		
		//No any move returns 0
		public function get totalActionsDid():uint
		{
			return this._clickHistory.length;
		}
		
		//============Instance Functions============//
		//Real Saves
		public function getHistoryChesses(host:ChessGame):Vector.<Chess>
		{
			return ChessGameSave.fromChessHistoryToChesses(host,this._chessHistory);
		}
		
		public function getHistoryMoveNum():Vector.<uint>
		{
			return ChessGameSave.fromChessHistoryToMoveNums(this._chessHistory);
		}
		
		public function getHistoryClick():Vector.<Point>
		{
			return ChessGameSave.fromClickHistoryToPoints(this._clickHistory);
		}
		
		public function getRule():ChessRule
		{
			return ChessRule.fromString(this._rule);
		}
		
		public function getBoardSizeX():uint
		{
			return uint(this._boardSize.split(POINT_DELIM)[0]);
		}
		
		public function getBoardSizeY():uint
		{
			return uint(this._boardSize.split(POINT_DELIM)[1]);
		}
		
		public function getBoardSize():Point
		{
			return parseToPoint(this._boardSize);
		}
		
		public function getNowPlayer():uint
		{
			return this.nowPlayer;
		}
		
		public function getNowPlayerByMode(host:ChessGame):ChessPlayer
		{
			return host.getPlayerByModeAt(this.nowPlayer);
		}
		
		public function getPlayers(host:ChessGame):Vector.<ChessPlayer>
		{
			return fromPlayersToChessPlayers(host,this.players);
		}
		
		//Methods
		public function addChessHistory(chess:Chess,stepNum:uint):void
		{
			this._chessHistory.push(chess.basicInformation+CHESS_NUM_DELIM+stepNum);
		}
		
		public function addClickHistory(history:Point):void
		{
			this._clickHistory.push(Math.floor(history.x)+POINT_DELIM+Math.floor(history.y));
		}
		
		public function resetChessHistory():void
		{
			this._chessHistory.splice(0,this._chessHistory.length);
		}
		
		public function resetClickHistory():void
		{
			this._clickHistory.splice(0,this._clickHistory.length);
		}
		
		public function resetRule():void
		{
			this._rule="";
		}
		
		public function resetPlayers():void
		{
			this._players.splice(0,this._players.length);
		}
		
		public function reset():void
		{
			this.resetChessHistory();
			this.resetClickHistory();
			this._boardSize="";
			this._playerCount=0;
			this._nowPlayer=1;
			resetRule();
		}
		
		public function resetToGameGlobal(game:ChessGame):void
		{
			this.replaceRule(game.rules.toString());
			this.replacePlayerCount(game.playerCount);
			this.replaceBoardSize(game.board.boardSizeX,game.board.boardSizeY);
			this.replaceNowPlayer(game.nowPlayer.gameIndex);
		}
		
		public function replaceChessHistory(history:Vector.<String>):void
		{
			this.resetChessHistory();
			for(var i:uint=0;i<history.length;i++)
			{
				this._chessHistory.push(history[i]);
			}
		}
		
		public function replaceClickHistory(history:Vector.<String>):void
		{
			this.resetClickHistory();
			for(var i:uint=0;i<history.length;i++)
			{
				this._clickHistory.push(history[i]);
			}
		}
		
		public function replaceRule(rule:String):void
		{
			this._rule=(rule==null)?"":rule;
		}
		
		public function replaceBoardSize(sizeX:uint,sizeY:uint):void
		{
			this._boardSize=""+sizeX+POINT_DELIM+sizeY;
		}
		
		public function replaceBoardSize2(size:String):void
		{
			this._boardSize=size;
		}
		
		public function replaceNowPlayer(index:uint):void
		{
			this._nowPlayer=index;
		}
		
		public function replacePlayerCount(count:uint):void
		{
			this._playerCount=count;
		}
		
		public function replacePlayers(players:Vector.<String>):void
		{
			this.resetPlayers();
			for(var i:uint=0;i<players.length;i++)
			{
				this._players.push(players[i]);
			}
		}
		
		//To String
		public function toString(delim:String=LINE_DELIM):String
		{
			var result:String="";
			result+=getPartSign(PART_NAME_ChessHistory)+delim;
			result+=encapsulateToString(this.chessHistory);
			result+=getPartSign(PART_NAME_ClickHistory)+delim;
			result+=encapsulateToString(this.clickHistory);
			result+=getPartSign(PART_NAME_Rule)+delim;
			result+=this.rule;
			result+=getPartSign(PART_NAME_BoardSize)+delim;
			result+=this.boardSize;
			result+=getPartSign(PART_NAME_PlayerCount)+delim;
			result+=this.playerCount;
			result+=getPartSign(PART_NAME_NowPlayer)+delim;
			result+=this.nowPlayer;
			result+=getPartSign(PART_NAME_Players)+delim;
			result+=encapsulateToString(this.players);
			return result;
		}
	}
}