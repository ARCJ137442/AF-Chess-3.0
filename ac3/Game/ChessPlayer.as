package ac3.Game
{
	//============Import All============//
	import ac3.Chess.movement.ChessWayPoint;
	import ac3.Chess.movement.ChessWayPointType;
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.movement.*;
	import ac3.Game.*;
	import ac3.AI.*;
	
	//Flash
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.utils.getQualifiedClassName;
	
	public class ChessPlayer
	{
		//============Static Variables============//
		public static const NAME_PLAYER:String="Player";
		public static const NAME_AI:String="AI";
		
		public static const STRING_DELIM:String=",";
		
		public static const ENABLE_AI_QNAMES:Vector.<String>=new <String>[
		getQualifiedClassName(ChessAI_Random),
		getQualifiedClassName(ChessAI_Hunter),
		getQualifiedClassName(ChessAI_Hunter_II),
		getQualifiedClassName(ChessAI_Hunter_III),
		getQualifiedClassName(ChessAI_Nearest),
		getQualifiedClassName(ChessAI_Nearest_II),
		getQualifiedClassName(ChessAI_Nearest_III),
		getQualifiedClassName(ChessAI_Killer)
		];
		
		public static const INITIAL_ENABLE_AI:Vector.<String>=new <String>[
		getQualifiedClassName(ChessAI_Hunter_II)/*,
		getQualifiedClassName(ChessAI_Nearest_III)*/
		];
		
		public static const NULL_COLOR:uint=0x222222;
		
		protected static const colorTrunNum:uint=20;
		protected static var nextId:uint=1;
		
		//============Static Functions============//
		//========Chess Player Color========//
		public static function getColorByUUID(uuid:uint):uint
		{
			return Color.HSVtoHEX(uuid%(360/colorTrunNum)*colorTrunNum/360,1,1);
		}
		
		public static function getColor(player:ChessPlayer):uint
		{
			return player==null?NULL_COLOR:player.color;
		}
		
		//========Chess AI Choice========//
		public static function getRandomAIQName():String
		{
			return getQualifiedClassName(getRandomAI(null));
		}
		
		public static function getAIFromIndex(owner:ChessPlayer,index:int):IChessAI
		{
			if(index<0) return null;
			switch(index)
			{
				case 1:return new ChessAI_Hunter(owner);
				case 2:return new ChessAI_Hunter_II(owner);
				case 3:return new ChessAI_Hunter_III(owner);
				case 4:return new ChessAI_Nearest(owner);
				case 5:return new ChessAI_Nearest_II(owner);
				case 6:return new ChessAI_Nearest_III(owner);
				case 7:return new ChessAI_Killer(owner);
				default:return new ChessAI_Random(owner);
			}
		}
		
		public static function getIndexFromAI(ai:IChessAI):int
		{
			return ENABLE_AI_QNAMES.indexOf(getQualifiedClassName(ai));
		}
		
		public static function getAIFromQName(owner:ChessPlayer,qName:String):IChessAI
		{
			return getAIFromIndex(owner,ENABLE_AI_QNAMES.indexOf(qName));
		}
		
		public static function parseAIFromIndexString(owner:ChessPlayer,string:String):IChessAI
		{
			if(string==null||string.length<1) return null
			return getAIFromIndex(owner,parseInt(string));
		}
		
		public static function getRandomAI(owner:ChessPlayer):IChessAI
		{
			return getAIFromIndex(owner,acMath.random(ENABLE_AI_QNAMES.length));
		}
		
		public static function getRandomInitialAI(owner:ChessPlayer):IChessAI
		{
			return getAIFromQName(owner,INITIAL_ENABLE_AI[acMath.random(INITIAL_ENABLE_AI.length)]);
		}
		
		public static function getNextAI(AIOwner:ChessPlayer):IChessAI
		{
			return getAIFromIndex(AIOwner,(getIndexFromAI(AIOwner.AI)+1)%ENABLE_AI_QNAMES.length);
		}
		
		public static function getDefaultAI(owner:ChessPlayer):IChessAI
		{
			return getRandomInitialAI(owner);
		}
		
		//====API====//
		public static function fromInformation(host:ChessGame,information:String,delim:String=STRING_DELIM):ChessPlayer
		{
			if(General.isEmptyChar(information)) return null;
			return new ChessPlayer(host,0,0).loadByInformation(information,delim);
		}
		
		//============Instance Variables============//
		protected var _uuid:uint;
		protected var _host:ChessGame;
		
		protected var _color:uint;
		protected var _lockChessColor:Boolean=true;
		protected var _canContolByMouse:Boolean=true;
		
		protected var _winCount:uint=0;
		protected var _score:uint=0;
		
		protected var _ai:IChessAI;
		protected var _isAI:Boolean=false;
		protected var _aiResult:Vector.<Point>;
		protected var _aiTimer:Timer;
		
		public var actionDidInTrun:uint=0;
		public var totalActionsDid:uint=0;
		public var lastHasImportmentChess:Boolean=false;
		
		//Attack Stats
		public var lastAttackerChess:Chess;
		public var lastVictimChess:Chess;
		public var lastAttackerType:ChessWayPointType;
		
		//============Constructor Function============//
		public function ChessPlayer(host:ChessGame,color:int=-1,aiLevel:uint=0):void
		{
			//Set UUID
			this._uuid=ChessPlayer.nextId;
			ChessPlayer.nextId++;
			//Set Host
			this._host=host;
			//Set Color
			this._color=color<0?getColorByUUID(this._uuid):color;
			//Set AI
			initAI(aiLevel);
		}
		
		//============Constructor Function============//
		public function deleteSelf():void
		{
			this._ai=null;
			this._isAI=false;
			this.stopAIThink();
			this._aiTimer=null;
			this.lastAttackerChess=null;
			this.lastAttackerType=null;
			this.lastVictimChess=null;
			this.lastHasImportmentChess=false;
			this.actionDidInTrun=0;
			this._host=null;
		}
		
		//============Instance Getter And Setter============//
		//========Global========//
		public function get host():ChessGame
		{
			return this._host;
		}
		
		public function get board():ChessBoard
		{
			return this._host.board;
		}
		
		public function get typeName():String
		{
			return this.isAI?((this._ai==null)?ChessPlayer.NAME_AI:this._ai.name):ChessPlayer.NAME_PLAYER
		}
		
		public function get color():uint
		{
			return this._color;
		}
		
		public function set color(value:uint):void
		{
			this._color=value;
			this.board.updateScoreBoardByOwner(this);
		}
		
		public function get lockChessColor():Boolean
		{
			return this._lockChessColor;
		}
		
		public function set lockChessColor(value:Boolean):void 
		{
			this._lockChessColor=value;
		}
		
		public function get canContolByMouse():Boolean
		{
			return this._canContolByMouse;
		}
		
		public function set canContolByMouse(value:Boolean):void 
		{
			this._canContolByMouse=value;
		}
		
		public function get gameIndex():uint
		{
			return this._host.getPlayerIndex(this);
		}
		
		//========Stat========//
		public function get winCount():uint 
		{
			return this._winCount;
		}
		
		public function set winCount(value:uint):void 
		{
			this._winCount=value;
			this.board.updateScoreBoardByOwner(this);
		}
		
		public function get score():uint 
		{
			return this._score;
		}
		
		public function set score(value:uint):void 
		{
			this._score=value;
			this.board.updateScoreBoardByOwner(this);
		}
		
		//========Chess========//
		public function get handleChesses():Vector.<Chess>
		{
			return this._host.getChessesByOwner(this);
		}
		
		public function get handleChessCount():uint
		{
			return handleChesses.length;
		}
		
		public function get randomHandleChess():Chess
		{
			if(this.handleChessCount<1) return null;
			return this.handleChesses[acMath.random(this.handleChessCount)];
		}
		
		public function get hasOwnChess():Boolean
		{
			return this.handleChessCount>0;
		}
		
		public function get canMoveChess():Boolean
		{
			if(this.handleChessCount<1) return false;
			if(!this.handleChesses.some(checkChess)) return false;
			return true;
		}
		
		public function get controllableSelfChesses():Vector.<Chess>
		{
			var rV:Vector.<Chess>=new Vector.<Chess>;
			for each(var chess:Chess in this.handleChesses)
			{
				if(chess.canBeContol) rV.push(chess);
			}
			return rV;
		}
		
		public function get controllableSelfChessCount():uint
		{
			return this.controllableSelfChesses.length;
		}
		
		public function get canContolSelfChess():Boolean
		{
			return (this.controllableSelfChessCount>0);
		}
		
		public function get randomControllableSelfChess():Chess
		{
			if(this.controllableSelfChessCount<1) return null;
			return this.controllableSelfChesses[acMath.random(this.controllableSelfChessCount)];
		}
		
		public function get clickableChesses():Vector.<Chess>
		{
			return this.controllableSelfChesses.concat(this.swapableChesses);
		}
		
		public function get clickableChessCount():uint
		{
			return this.clickableChesses.length;
		}
		
		public function get canClickChess():Boolean
		{
			return (this.actionDidInTrun<this.host.rules.maxActionDoingPerTrun&&this.clickableChessCount>0);
		}
		
		public function get randomClickableChess():Chess
		{
			if(this.clickableChessCount<1) return null;
			return this.clickableChesses[acMath.random(this.clickableChessCount)];
		}
		
		public function get typeRaChesses():Vector.<Chess>
		{
			var rV:Vector.<Chess>=new Vector.<Chess>;
			for each(var chess:Chess in this.handleChesses)
			{
				if(chess.type==ChessType.Ra) rV.push(chess);
			}
			return rV;
		}
		
		public function get typeRaChessCount():uint
		{
			return this.typeRaChesses.length;
		}
		
		public function get randomTypeRaChess():Chess
		{
			if(this.typeRaChessCount<1) return null;
			return this.typeRaChesses[acMath.random(this.typeRaChessCount)];
		}
		
		public function get swapableChesses():Vector.<Chess>
		{
			return this.host.nullChesses.concat(this.typeRaChesses);
		}
		
		public function get swapableChessCount():uint
		{
			return this.swapableChesses.length;
		}
		
		public function get canSwapChess():Boolean
		{
			return this.swapableChessCount>0;
		}
		
		public function get randomSwapableChess():Chess
		{
			if(this.swapableChessCount<1) return null;
			return this.swapableChesses[acMath.random(this.swapableChessCount)];
		}
		
		public function get mostLevelChesses():Vector.<Chess>
		{
			var result:Vector.<Chess>=new Vector.<Chess>;
			var tempLevel:uint=0;
			for each(var tempChess:Chess in this.handleChesses)
			{
				if(tempChess.level>tempLevel)
				{
					result=new Vector.<Chess>;
				}
				if(tempChess.level==tempLevel)
				{
					result.push(tempChess);
				}
			}
			return result;
		}
		
		public function get mostHarmfulChesses():Vector.<Chess>
		{
			var result:Vector.<Chess>=new Vector.<Chess>;
			var tempHarmful:uint=0,mostHarmful:uint=0;
			for each(var tempChess:Chess in this.handleChesses)
			{
				tempHarmful=tempChess.harmfulWayPointCount;
				if(tempHarmful>mostHarmful)
				{
					result=new Vector.<Chess>;
				}
				if(tempHarmful==mostHarmful)
				{
					result.push(tempChess);
				}
			}
			return result;
		}
		
		public function get importmentChesses():Vector.<Chess>
		{
			return this.handleChesses.filter(function(c:Chess,i:uint,v:Vector.<Chess>)
											 {
												 return c.importment;
											 })
		}
		
		public function get importmentChessCount():uint
		{
			return this.importmentChesses.length;
		}
		
		public function get hasImportmentChess():Boolean
		{
			return this.importmentChessCount>0;
		}
		
		public function get onlyHasOneImportmentChess():Boolean
		{
			return this.importmentChessCount==1;
		}
		
		public function get randomImportmentChess():Chess
		{
			var tCs:Vector.<Chess>=this.importmentChesses;
			if(tCs==null||tCs.length<1) return null;
			return tCs[acMath.random(tCs.length)];
		}
		
		public function get allMovePlaces():Vector.<ChessWayPoint>
		{
			var rV:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			if(!this.canMoveChess) return rV;
			for each(var chess:Chess in this.controllableSelfChesses)
			{
				rV=rV.concat(chess.getMovePlaces());
			}
			return rV;
		}
		
		//========AI========//
		public function get isAI():Boolean
		{
			return this._isAI;
		}
		
		public function set isAI(value:Boolean):void
		{
			this._isAI=value;
			this.canContolByMouse=!this._isAI;
			this.board.updateScoreBoardByOwner(this);
			if(value&&!this.hasAI)
			{
				setAI(getDefaultAI(this),false);
			}
		}
		
		public function get hasAI():Boolean
		{
			return this._ai!=null;
		}
		
		public function get AI():IChessAI
		{
			return this._ai;
		}
		
		public function get isAIThinking():Boolean
		{
			if(!this.hasAI) return false;
			return this._aiTimer==null?false:this._aiTimer.running;
		}
		
		//========API========//
		public function get basicInformation():String
		{
			var result:String="";
			//Loadin
			result+="color="+this._color+STRING_DELIM;
			result+="canContolByMouse="+this.canContolByMouse+STRING_DELIM;
			result+="winCount="+this.winCount+STRING_DELIM;
			result+="score="+this.score+STRING_DELIM;
			result+="aiIndex="+getIndexFromAI(this.AI)+STRING_DELIM;
			result+="actionDidInTrun="+this.actionDidInTrun;
			//Return
			return result;
		}
		
		public function loadByInformation(information:String,delim:String=STRING_DELIM):ChessPlayer
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
					case "color":
						this.color=parseInt(value);
						break;
					case "canContolByMouse":
						this.canContolByMouse=(value=="true")?true:false;
						break;
					case "winCount":
						this.winCount=parseInt(value);
						break;
					case "score":
						this.score=parseInt(value);
						break;
					case "aiIndex":
						this.setAI(parseAIFromIndexString(this,value),true);
						break;
					case "actionDidInTrun":
						this.actionDidInTrun=parseInt(value);
						break;
				}
			}
			//Return
			return this;
		}
		
		//============Instance Functions============//
		//========Initial Functions========//
		protected function initAI(level:uint=0):void
		{
			if(level>0)
			{
				this.isAI=true;
				setAI(getDefaultAI(this),false);
			}
		}
		
		public function initAIThink():void
		{
			if(!this.hasAI) return;
			if(this.isAI)
			{
				this.startAIThink();
			}
			else
			{
				this.stopAIThink();
			}
		}
		
		//========Enum Functions========//
		protected function checkChess(chess:Chess,i:uint=0,v:Vector.<Chess>=null):Boolean
		{
			return chess.canBeContol;
		}
		
		protected function checkChess2(chess:Chess,i:uint=0,v:Vector.<Chess>=null):Boolean
		{
			return (chess.isUnknownType||chess.canBeContol)&&chess.life>0;
		}
		
		//========Tool Functions========//
		public function isEnemyTo(player:ChessPlayer):Boolean
		{
			return (player!=this);
		}
		
		//========Gameplay Functions========//
		public function resetToNewGame():void
		{
			//Update Self
			this.actionDidInTrun=0;
			//Update Chess
			//Update Stats
			this.lastAttackerChess=null;
			this.lastVictimChess=null;
			this.lastHasImportmentChess=false;
		}
		
		public function resetScore():void
		{
			this.score=0;
		}
		
		public function resetWinCount():void
		{
			this.winCount=0;
		}
		
		public function resetScoreBoard():void
		{
			this.resetWinCount();
			this.resetScore();
		}
		
		public function lost(killerChess:Chess=null):void
		{
			//Remove Chesses
			if(killerChess!=null)
			{
				switch(lastAttackerType)
				{
					case ChessWayPointType.SPECIAL_MIND_CONTOL:
						this.beMindContol(killerChess);
						break;
					case ChessWayPointType.SPECIAL_CONVER_OWNER_TO_NULL:
						this.beLostOwner(killerChess);
						break;
					default:
						this.beKilled(killerChess);
						break;
				}
			}
			else this.board.removeAllChessByOwner(this);
			//Reset
			this.lastHasImportmentChess=false;
		}
		
		public function beKilled(killerChess:Chess):void
		{
			for each(var tC:Chess in this.handleChesses)
			{
				killerChess.level+=(1+tC.level);
				killerChess.owner.score+=tC.score;
			}
			this.board.removeAllChessByOwner(this);
		}
		
		public function beMindContol(contolerChess:Chess):void
		{
			if(contolerChess==null||contolerChess.owner==this) return;
			for each(var tC:Chess in this.handleChesses)
			{
				contolerChess.level++;
				contolerChess.mindContol(tC);
				contolerChess.owner.score+=tC.score;
			}
		}
		
		public function beLostOwner(contolerChess:Chess):void
		{
			if(contolerChess==null||contolerChess.owner==this) return;
			for each(var tC:Chess in this.handleChesses)
			{
				tC.owner=null;
				contolerChess.level++;
				contolerChess.owner.score+=tC.score;
			}
		}
		
		//========AI Functions========//
		public function setAI(AI:IChessAI,setContol:Boolean):void
		{
			//Set AI
			this._ai=AI;
			if(this.hasAI) this._aiTimer=new Timer(this._ai.thinkTime,int.MAX_VALUE);
			//Set
			this._isAI=this.hasAI;
			if(setContol) this.canContolByMouse=!this._isAI;
			//Update
			this.board.updateScoreBoardByOwner(this);
			for each(var chess:Chess in this.clickableChesses)
			{
				chess.updateButtonModeByPlayer(this);
			}
		}
		
		public function startAIThink():void
		{
			this._aiTimer.reset();
			this._aiTimer.delay=this.AI.thinkTime;
			this._aiTimer.repeatCount=int.MAX_VALUE;
			this._aiTimer.addEventListener(TimerEvent.TIMER,this.onAIRunning);
			this._aiTimer.addEventListener(TimerEvent.TIMER_COMPLETE,this.onAIStop);
			this._aiTimer.start();
		}
		
		public function stopAIThink():void
		{
			if(this._aiTimer==null) return;
			this._aiTimer.stop();
			this._aiTimer.reset();
			this._aiResult=null;
			this._aiTimer.removeEventListener(TimerEvent.TIMER,this.onAIRunning);
			this._aiTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,this.onAIStop);
		}
		
		protected function onAIRunning(E:TimerEvent=null):void
		{
			//Check
			if(!this._isAI||this._host.nowPlayer!=this)
			{
				onAIStop();
				return;
			}
			//Get Result
			if(this._aiResult==null)
			{
				this._aiResult=this.AI.getOutput();
			}
			//Select Chess
			else if(this._aiResult.length>0)
			{
				this._host.click(this._aiResult[0].x,this._aiResult[0].y,true);
				this._aiResult.shift();
			}
			//Stop
			else
			{
				onAIStop();
			}
		}
		
		protected function onAIStop(E:TimerEvent=null):void
		{
			stopAIThink();
			//Reselect
			if(this._host.nowPlayer==this)
			{
				this.startAIThink();
			}
		}
	}
}