package ac3.AI 
{
	//AF Chess 3.0
	import ac3.Chess.*;
	import ac3.Game.*;
	import ac3.Common.*;
	import ac3.AI.*;
	
	//Flash
	import flash.geom.Point;
	
	public class ChessAI_Common implements IChessAI
	{
		//============Instance Variables============//
		protected var _owner:ChessPlayer;
		
		//============Constructor Function============//
		public function ChessAI_Common(owner:ChessPlayer=null):void
		{
			if(owner) this._owner=owner;
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public function get owner():ChessPlayer
		{
			return this._owner;
		}
		
		public function set owner(value:ChessPlayer):void
		{
			this._owner=value;
		}
		
		public function get board():ChessBoard
		{
			return this._owner.board;
		}
		
		public function get host():ChessGame
		{
			return this._owner.host;
		}
		
		public function get name():String
		{
			return "AI-Common";
		}
		
		public function get thinkTime():uint
		{
			return 10;
		}
		
		public function get localAIName():String
		{
			if(this.host==null) return this.name+"<null>";
			return this.name+"<"+this.host.getPlayerIndex(this.owner)+">";
		}
		
		//============Instance Functions============//
		/* INTERFACE ac3.AI.IChessAI */
		public function getOutput():Vector.<Point> 
		{
			throw new Error("Cann't give output by"+this.name);
			return null;
		}
	}
}