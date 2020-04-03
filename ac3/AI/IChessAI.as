package ac3.AI 
{
	//AF Chess 3.0
	import ac3.Chess.*;
	import ac3.Game.*;
	import ac3.Common.*;
	import ac3.AI.*;
	
	//Flash
	import flash.geom.Point;
	
	public interface IChessAI 
	{
		//========Instance Getter And Setter========//
		function get name():String
		function get localAIName():String
		function get owner():ChessPlayer
		function set owner(value:ChessPlayer):void
		function get host():ChessGame
		function get board():ChessBoard
		function get thinkTime():uint//ms
		//========Instance Functions========//
		function getOutput():Vector.<Point>
	}
}