package ac3.Chess 
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Game.*;
	
	//Flash
	import flash.display.Shape;
	
	public class ChessSelectOverlay extends Shape 
	{
		//============Instance Variables============//
		protected var _host:ChessBoard;
		
		//============Constructor Function============//
		public function ChessSelectOverlay(host:ChessBoard):void
		{
			this._host=host;
			initDisplay();
		}
		
		protected function initDisplay():void
		{
			this.graphics.beginFill(uint(this._host.selectColor[0]),this._host.selectColor[1]);
			this.graphics.drawRect(0,0,this._host.chessDisplayWidth,this._host.chessDisplayHeight);
			this.graphics.endFill();
		}
		
		public function get boardX():int
		{
			return this._host.lockX(this.x);
		}
		
		public function set boardX(value:int):void
		{
			this.x=this._host.unlockX(value);
		}
		
		public function get boardY():int
		{
			return this._host.lockY(this.y);
		}
		
		public function set boardY(value:int):void
		{
			this.y=this._host.unlockY(value);
		}
	}
}