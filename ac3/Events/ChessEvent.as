package ac3.Events 
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Game.*;
	import ac3.AI.*;
	
	//Flash
	import flash.geom.Point;
	import flash.events.Event;
	
	public class ChessEvent extends Event
	{
		//============Static Variables============//
		public static const NEW_CHESS_ADDED:String="newChessAdded";
		public static const CHESS_REMOVED:String="chessRemoved";
		public static const NEW_GAME_STARTED:String="newGameStarted";
		public static const BOARD_RESIZED:String="boardResized";
		
		//============Instance Variables============//
		public var currentChess:Chess;
		public var currentHost:ChessGame;
		public var currentBoard:ChessBoard;
		
		//============Constructor Function============//
		public function ChessEvent(type:String,currentChess:Chess=null,currentHost:ChessGame=null,currentBoard:ChessBoard=null):void
		{
			super(type,false,false);
			this.currentChess=currentChess;
			this.currentHost=currentHost;
			this.currentBoard=currentBoard;
		}
		
		//============Instance Getter And Setter============//
		
		//============Instance Functions============//
		public override function clone():Event
		{
			return new ChessEvent(this.type,this.currentChess,this.currentHost,this.currentBoard);
		}
		
		public override function toString():String
		{
			return formatToString("ChessEvent","type","bubbles","cancelable","eventPhase");
		}
		
		public function alignToChess():ChessEvent
		{
			if(this.currentChess==null)
			{
				this.currentHost=null;
				this.currentBoard=null;
			}
			else
			{
				this.currentHost=this.currentChess.host;
				this.currentBoard=this.currentChess.board;
			}
			return this;
		}
	}
}