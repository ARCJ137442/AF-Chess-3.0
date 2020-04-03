package 
{
	//AF Chess
	import ac3.Common.*;
	import ac3.Game.ChessGame;
	
	//Flash
	import flash.display.MovieClip;
	
	public class Main extends MovieClip
	{
		//============Constructor Function============//
		public function Main():void
		{
			var game:ChessGame=new ChessGame();
			this.addChild(game);
		}
	}
}