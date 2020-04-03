package ac3.Chess 
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Game.*;
	import ac3.AI.*;
	
	//Flash
	import flash.geom.Point;
	
	public interface IChessAbstruct
	{
		function get boardX():int
		function set boardX(value:int):void
		function get boardY():int
		function set boardY(value:int):void
		function get owner():ChessPlayer
		function set owner(value:ChessPlayer):void
		function get ownerNum():uint
		function set ownerNum(value:uint):void
		function get type():ChessType
		function set type(value:ChessType):void
		function get level():uint
		function set level(value:uint):void
		function get life():int
		function set life(value:int):void
		function get importment():Boolean
		function set importment(value:Boolean):void
	}
}