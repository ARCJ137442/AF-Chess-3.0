package ac3.Chess
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Game.*;
	
	//Flash
	import flash.display.*;
	import flash.geom.Point;
	
	public class ChessSelectPlace extends Sprite
	{
		public static const DRAW_POS_X:uint=18;
		public static const DRAW_POS_Y:uint=18;
		public static const DRAW_SIZE_X:uint=64;
		public static const DRAW_SIZE_Y:uint=64;
		public static const AREA_SIZE_X:uint=100;
		public static const AREA_SIZE_Y:uint=100;
		public static const LINE_SCALE:Number=7;
		
		//============Instance Variables============//
		protected var _color:int=0x000000;
		protected var _type:ChessSelectPlaceType;
		
		public function ChessSelectPlace(X:int,Y:int,
										color:int,alpha:Number=1,
										type:ChessSelectPlaceType=null,
										xScale:Number=1,
										yScale:Number=1):void
		{
			this.x=X;
			this.y=Y;
			this._color=color;
			this._type=type==null?ChessSelectPlaceType.DIAMOND:type;
			this.scaleX=xScale;
			this.scaleY=yScale;
			drawSprite(alpha);
		}
		
		protected function drawSprite(alpha:Number=NaN):void
		{
			//Set Variables
			if(this._color<0) this.blendMode=BlendMode.INVERT;
			else this.blendMode=BlendMode.NORMAL;
			if(!isNaN(alpha)) this.alpha=alpha;
			//Pos
			var drawX:Number=DRAW_POS_X;
			var drawY:Number=DRAW_POS_Y;
			var sizeX:Number=DRAW_SIZE_X;
			var sizeY:Number=DRAW_SIZE_Y;
			var centerX:Number=drawX+sizeX/2;
			var centerY:Number=drawY+sizeY/2;
			//Points
			var up:Point=new Point(
							drawX+sizeX/2,
							drawY);
			var down:Point=new Point(
							drawX+sizeX/2,
							drawY+sizeY);
			var left:Point=new Point(
							drawX,
							drawY+sizeY/2);
			var right:Point=new Point(
							drawX+sizeX,
							drawY+sizeY/2);
			var outlinePosUp:Number=LINE_SCALE/2;
			var outlinePosDown:Number=AREA_SIZE_Y-LINE_SCALE/2;
			var outlinePosLeft:Number=LINE_SCALE/2;
			var outlinePosRight:Number=AREA_SIZE_X-LINE_SCALE/2;
			//Draw Shape on 18,18,64,64 or outline
			this.graphics.clear();
			this.graphics.lineStyle(LINE_SCALE,this._color,1,true,LineScaleMode.NORMAL,CapsStyle.SQUARE,JointStyle.MITER);
			switch(this._type)
			{
				case ChessSelectPlaceType.CIRCLE:
					this.graphics.drawEllipse(drawX,drawY,sizeX,sizeY);
					break;
				case ChessSelectPlaceType.RING:
					this.graphics.drawEllipse(drawX,drawY,sizeX,sizeY);
					this.graphics.drawEllipse(drawX+sizeX/4,drawY+sizeY/4,sizeX/2,sizeY/2);
					break;
				case ChessSelectPlaceType.SQUARE:
					this.graphics.drawRect(drawX,drawY,sizeX,sizeY);
					break;
				case ChessSelectPlaceType.X:
					//I
					this.graphics.moveTo(left.x,up.y);
					this.graphics.lineTo(right.x,down.y);
					//II
					this.graphics.moveTo(right.x,up.y);
					this.graphics.lineTo(left.x,down.y);
					break;
				case ChessSelectPlaceType.CROSS:
					//I
					this.graphics.moveTo(up.x,up.y);
					this.graphics.lineTo(down.x,down.y);
					//II
					this.graphics.moveTo(right.x,right.y);
					this.graphics.lineTo(left.x,left.y);
					break;
				case ChessSelectPlaceType.OUTLINE:
					//LU
					this.graphics.moveTo(outlinePosLeft,outlinePosUp);
					this.graphics.lineTo(left.x,outlinePosUp);
					this.graphics.moveTo(outlinePosLeft,outlinePosUp);
					this.graphics.lineTo(outlinePosLeft,up.y);
					//LD
					this.graphics.moveTo(outlinePosLeft,outlinePosDown);
					this.graphics.lineTo(left.x,outlinePosDown);
					this.graphics.moveTo(outlinePosLeft,outlinePosDown);
					this.graphics.lineTo(outlinePosLeft,down.y);
					//RU
					this.graphics.moveTo(outlinePosRight,outlinePosUp);
					this.graphics.lineTo(right.x,outlinePosUp);
					this.graphics.moveTo(outlinePosRight,outlinePosUp);
					this.graphics.lineTo(outlinePosRight,up.y);
					//RD
					this.graphics.moveTo(outlinePosRight,outlinePosDown);
					this.graphics.lineTo(right.x,outlinePosDown);
					this.graphics.moveTo(outlinePosRight,outlinePosDown);
					this.graphics.lineTo(outlinePosRight,down.y);
					break;
				default:
				case ChessSelectPlaceType.DIAMOND:
					//Draw a Prismatic
					//U-L
					this.graphics.moveTo(up.x,up.y);
					this.graphics.lineTo(left.x,left.y);
					//L-D
					this.graphics.moveTo(left.x,left.y);
					this.graphics.lineTo(down.x,down.y);
					//D-R
					this.graphics.moveTo(down.x,down.y);
					this.graphics.lineTo(right.x,right.y);
					//R-U
					this.graphics.moveTo(right.x,right.y);
					this.graphics.lineTo(up.x,up.y);
					break;
			}
		}
		
		public function get color():int
		{
			return this._color;
		}
		
		public function set color(value:int):void
		{
			if(this._color==value) return;
			this._color=color;
			drawSprite();
		}
		
		public function get type():ChessSelectPlaceType
		{
			return this._type;
		}
		
		public function set type(value:ChessSelectPlaceType):void
		{
			if(this._type==value) return;
			this._type=value;
			drawSprite();
		}
	}
}