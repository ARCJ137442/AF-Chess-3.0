package ac3.Chess 
{
	//============Import All============//
	import ac3.Common.*;
	import ac3.Chess.*;
	import ac3.Game.*;
	
	//Flash
	import flash.display.MovieClip;
	import flash.utils.Dictionary;
	import flash.text.TextField;
	
	public class ChessOverlay extends MovieClip
	{
		//============Static Variables============//
		protected static var typeCurrents:Dictionary=new Dictionary();
		protected static var inited:Boolean=false;
		
		//============Static Functions============//
		protected static function classInit():void
		{
			inited=true;
			addTypeCurrents2(ChessType.ALL_TYPES);
		}
		
		public static function addTypeCurrents(...currents):void
		{
			currents.forEach(function(c:*,i:uint,a:Array):void
							 {
								 if(!(c is ChessType)) return;
								 typeCurrents[c as ChessType]=i+1;
							 });
		}
		
		public static function addTypeCurrents2(currents:Vector.<ChessType>):void
		{
			currents.forEach(function(str:ChessType,i:uint,a:Vector.<ChessType>):void
							 {
								 typeCurrents[str]=i+1;
							 });
		}
		
		//============Instance Variables============//
		protected var _displayAsText:Boolean=false;
		protected var _lastType:ChessType=null;
		
		//============Constructor Function============//
		public function ChessOverlay():void
		{
			if(!inited) classInit();
			this.stop();
			this.displayText.selectable=false;
			this.displayText.tabEnabled=false;
			this.displayText.multiline=false;
			this.setText(null);
		}
		
		//============Instance Getter And Setter============//
		public function get displayText():TextField
		{
			return this.getChildByName("text") as TextField;
		}
		
		public function get displayAsText():Boolean
		{
			return this._displayAsText;
		}
		
		public function set displayAsText(value:Boolean):void
		{
			this.displayText.visible=value;
			if(value)
			{
				this.gotoAndStop(0);
				this.setText(ChessType.getName(this._lastType))
			}
			else this.setType(this._lastType);
		}
		
		//============Instance Functions============//
		public function hasType(type:ChessType):Boolean
		{
			return typeCurrents[type] is uint;
		}
		
		public function setType(type:ChessType):void
		{
			if(!hasType(type))
			{
				this.gotoAndStop(1);
				return;
			}
			else this._lastType=type;
			this.gotoAndStop(typeCurrents[this._lastType]);
		}
		
		public function setText(text:String):void
		{
			if(text==null)
			{
				this.displayText.visible=false;
				this.displayText.text="";
				return;
			}
			this.displayText.visible=true;
			this.displayText.text=text;
		}
	}
}