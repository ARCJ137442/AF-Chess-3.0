package ac3.AI 
{
	//AF Chess 3.0
	import ac3.Chess.movement.ChessWayPoint;
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Chess.movement.*;
	import ac3.Game.*;
	import ac3.AI.*;
	
	//Flash
	import flash.geom.Point;
	
	public class ChessAI_Killer extends ChessAI_Common implements IChessAI 
	{
		//============Instance Variables============//
		protected var _targetPlayer:ChessPlayer;
		protected var _targetChess:Chess;
		
		//============Constructor Function============//
		public function ChessAI_Killer(owner:ChessPlayer=null):void
		{
			super(owner);
		}
		
		//============Instance Getter And Setter============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function get name():String
		{
			return "AI-Killer";
		}
		
		public override function get thinkTime():uint
		{
			return 16;
		}
		
		//============Instance Functions============//
		/* INTERFACE ac3.AI.IChessAI */
		public override function getOutput():Vector.<Point> 
		{
			//Set Variables
			var result:Vector.<Point>=new Vector.<Point>;
			var selfChesses:Vector.<Chess>=this._owner.controllableSelfChesses;
			var otherChesses:Vector.<Chess>=this.host.getChessesByOwner(this._owner,true);
			var dangerPlaces:Vector.<ChessWayPoint>=new Vector.<ChessWayPoint>;
			var willContolChess:Chess;
			var willMovePoint:ChessWayPoint;
			var tempChess:Chess;
			var tempChesses:Vector.<Chess>;
			var oldDistance:Number,nowDistance:Number;
			var tempWayPoint:ChessWayPoint;
			var tempMovePlaces:Vector.<ChessWayPoint>;
			//Init Variables
			for each(tempChess in otherChesses)
			{
				dangerPlaces=dangerPlaces.concat(tempChess.getMovePlaces())
			}
			//Deal Global Target
			if(this._targetPlayer==null||
			   this._targetPlayer==this._owner||
			   !this._targetPlayer.canMoveChess)
			{
				for each(var tempPlayer:ChessPlayer in this.host.players)
				{
					if(this._targetPlayer==this._owner) continue;
					if(this._targetPlayer==null)
					{
						this._targetPlayer=tempPlayer;
						continue;
					}
					if(tempPlayer.controllableSelfChessCount>this._targetPlayer.controllableSelfChessCount)
					{
						this._targetPlayer=tempPlayer;
					}
				}
			}
			if(this._targetChess==null||
			   this._targetChess.owner!=this._targetPlayer||
			   !this._targetChess.activeInBoard)
			{
				if(this._targetPlayer.hasImportmentChess)
				{
					this._targetChess=this._targetPlayer.randomImportmentChess;
				}
				else
				{
					tempChesses=this._targetPlayer.mostHarmfulChesses;
					if(tempChesses==null||tempChesses.length<1)
					{
						this._targetChess=this._targetPlayer.randomHandleChess;
					}
					else
					{
						this._targetChess=tempChesses[acMath.random(tempChesses.length)];
					}
				}
			}
			//Detect
			if(!this._owner.canMoveChess)
			{
				for each(tempChess in this.board.allChesses)
				{
					if(tempChess.type==ChessType.NULL||
					   tempChess.type==ChessType.Ra&&tempChess.owner==this._owner)
					{
						result.push(tempChess.boardPoint);
						return result;
					}
				}
				trace("ChessAI_Killer:cannot move chess!")
				return null;
			}
			//Select Chess
			willContolChess=this._owner.randomControllableSelfChess;
			/*for each(tempChess in selfChesses)
			{
				oldDistance=willContolChess.distanceOfChess(this._targetChess);
				nowDistance=tempChess.distanceOfChess(this._targetChess);
				if(nowDistance<oldDistance)
				{
					willContolChess=tempChess;
				}
			}*/
			//Select WayPoint
			willMovePoint=willContolChess.getRandomMovePlace();
			tempMovePlaces=willContolChess.getMovePlaces();
			for each(tempWayPoint in tempMovePlaces)
			{
				oldDistance=this._targetChess.distanceOfWayPoint(willMovePoint);
				nowDistance=this._targetChess.distanceOfWayPoint(tempWayPoint);
				if(nowDistance<oldDistance)
				{
					willMovePoint=tempWayPoint;
				}
			}
			//Check
			if(willContolChess==null||willMovePoint==null)
			{
				trace("ChessAI_Killer:null error!");
				return null;
			}
			//Loadin Result
			result.push(willContolChess.boardPoint);
			result.push(willMovePoint.point);
			//Return
			return result;
		}
	}
}