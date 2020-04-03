package ac3.AI 
{
	//AF Chess 3.0
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.Way.*;
	import ac3.Game.*;
	import ac3.AI.*;
	
	//Flash
	import flash.geom.Point;
	
	public class ChessAI_Random extends ChessAI_Common implements IChessAI
	{
		//============Static Functions============//
		public static function getOutputByPlayer(player:ChessPlayer):Vector.<Point> 
		{
			//Set Variables
			var result:Vector.<Point>=new Vector.<Point>;
			//Detect
			if(!player) return null;
			//Get
			var willContolChess:Chess;
			//Deal Null
			var swapableChess:Chess=player.randomSwapableChess;
			if(swapableChess!=null)
			{
				result.push(swapableChess.boardPoint);
				return result;
			}
			else
			{
				willContolChess=player.randomControllableSelfChess;
			}
			//Check
			if(willContolChess==null) return null;
			result.push(willContolChess.boardPoint);
			var wayPoint:ChessWayPoint=willContolChess.getRandomMovePlace();
			if(wayPoint==null) return null;
			result.push(wayPoint.point);
			//Return
			return result;
		}
		
		//============Constructor Function============//
		public function ChessAI_Random(owner:ChessPlayer=null):void
		{
			super(owner);
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function get name():String
		{
			return "AI-Random";
		}
		
		//============Instance Functions============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function getOutput():Vector.<Point> 
		{
			return ChessAI_Random.getOutputByPlayer(this.owner);
		}
	}
}