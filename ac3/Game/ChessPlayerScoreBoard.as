package ac3.Game 
{
	//AF Chess 3.0
	import ac3.Common.*;
	import ac3.Game.ChessPlayer;
	
	//Flash
	import flash.events.Event;
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ChessPlayerScoreBoard extends MovieClip
	{
		//============Static Variables============//
		protected static const TEXT_ALPHA:Number=1/2;
		public static const realWidth:Number=240;
		public static const realHeight:Number=120;
		
		//============Instance Variables============//
		protected var _linkagePlayer:ChessPlayer
		
		//============Constructor Function============//
		public function ChessPlayerScoreBoard(link:ChessPlayer):void
		{
			stop();
			this._linkagePlayer=link;
			this.addEventListener(Event.ADDED_TO_STAGE,init);
		}
		
		protected function init(E:Event):void
		{
			/*for(var i:uint=0;i<this.numChildren;i++)
			{
				trace("Child "+i+":",this.getChildAt(i).name)
			}*/
			this.removeEventListener(Event.ADDED_TO_STAGE,init);
			this.winCountText.selectable=false;
			this.scoreText.selectable=false;
			this.typeText.selectable=false;
			
			this.winCountKey.selectable=false;
			this.scoreKey.selectable=false;
			this.typeKey.selectable=false;
			
			this.winCountText.alpha=TEXT_ALPHA;
			this.scoreText.alpha=TEXT_ALPHA;
			this.typeText.alpha=TEXT_ALPHA;
			
			this.winCountKey.alpha=TEXT_ALPHA;
			this.scoreKey.alpha=TEXT_ALPHA;
			this.typeKey.alpha=TEXT_ALPHA;
			this.updateDisplay();
		}
		
		//============Destructor Function============//
		public function deleteSelf():void 
		{
			this.linkagePlayer=null;
		}
		
		//============Instance Getter And Setter============//
		protected function get typeText():TextField
		{
			return this["_typeText"];
		}
		
		protected function get winCountText():TextField
		{
			return this["_winCountText"];
		}
		
		protected function get scoreText():TextField
		{
			return this["_scoreText"];
		}
		
		protected function get typeKey():TextField
		{
			return this["_typeKey"];
		}
		
		protected function get winCountKey():TextField
		{
			return this["_winCountKey"];
		}
		
		protected function get scoreKey():TextField
		{
			return this["_scoreKey"];
		}
		
		public function get linkagePlayer():ChessPlayer
		{
			return this["_linkagePlayer"];
		}
		
		public function set linkagePlayer(value:ChessPlayer):void
		{
			this._linkagePlayer=value;
			updateDisplay();
		}
		
		protected function get playerType():String
		{
			return linkagePlayer==null?null:linkagePlayer.typeName;
		}
		
		protected function get playerColor():uint
		{
			return ChessPlayer.getColor(linkagePlayer);
		}
		
		protected function get playerWinCount():uint
		{
			return linkagePlayer==null?0:linkagePlayer.winCount;
		}
		
		protected function get playerScore():uint
		{
			return linkagePlayer==null?0:linkagePlayer.score;
		}
		
		//============Instance Functions============//
		public function updateDisplay(updateColor:Boolean=true,
									 updateText:Boolean=true):void
		{
			if(updateText)
			{
				this.winCountText.text=String(playerWinCount);
				this.scoreText.text=String(playerScore);
				this.typeText.text=String(playerType);
			}
			if(updateColor)
			{
				this.winCountText.textColor=playerColor;
				this.scoreText.textColor=playerColor;
				this.typeText.textColor=playerColor;
				
				this.winCountKey.textColor=playerColor;
				this.scoreKey.textColor=playerColor;
				this.typeKey.textColor=playerColor;
			}
		}
	}
}