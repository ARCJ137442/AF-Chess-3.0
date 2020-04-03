package ac3.Text 
{
	import flash.display.*;
	import flash.text.*;
	
	public class KeyValueText extends Sprite
	{
		//============Static Variables============//
		public static const TEXT_COLOR:uint=0x666666;
		public static const TEXT_ALPHA:Number=0.6;
		public static const KEY_TICKNESS:Number=20;
		public static const VALUE_TICKNESS:Number=24;
		public static const KEY_WIDTH:Number=123;
		public static const KEY_HEIGHT:Number=30;
		
		public static const TEXT_FORMET_KEY:TextFormat=new TextFormat(
		MainFont.instance.fontName,
		KEY_TICKNESS,
		TEXT_COLOR,
		true,false,false,
		null,null,TextFormatAlign.RIGHT);
		public static const TEXT_FORMET_VALUE:TextFormat=new TextFormat(
		MainFont.instance.fontName,
		VALUE_TICKNESS,
		TEXT_COLOR,
		true,false,false,
		null,null,TextFormatAlign.LEFT);
		
		//============Static Getter And Setter============//
		
		//============Static Functions============//
		public static function alignText(text:TextField,addW:Number=0,addH:Number=0):void
		{
			text.width=text.textWidth+addW;
			text.height=text.textHeight+addH;
		}
		
		//============Instance Variables============//
		protected var _key:TextField;
		protected var _value:TextField;
		
		//============Constructor Function============//
		public function KeyValueText(key:String,value:uint=0):void
		{
			super();
			/*key*/
			this._key=new TextField();
			this._key.width=KEY_WIDTH;
			this._key.height=KEY_HEIGHT;
			this._key.textColor=TEXT_COLOR;
			this._key.alpha=TEXT_ALPHA;
			this._key.text=key;
			this._key.selectable=false;
			this._key.multiline=false;
			this._key.embedFonts=true;
			this._key.defaultTextFormat=TEXT_FORMET_KEY;
			this._key.setTextFormat(TEXT_FORMET_KEY);
			/*value*/
			this._value=new TextField();
			this._value.textColor=TEXT_COLOR;
			this._value.alpha=TEXT_ALPHA;
			this._value.selectable=false;
			this._value.multiline=false;
			this._value.embedFonts=true;
			this._value.defaultTextFormat=TEXT_FORMET_VALUE;
			//Set Variable
			this.value=value;
			this.align();
			//Add Childs
			this.addChilds();
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this.removeChilds();
			this._key=this._value=null;
		}
		
		//============Instance Getter And Setter============//
		public function get key():String
		{
			return this._key.text;
		}
		
		public function set key(value:String):void
		{
			this._key.text=value;
			this.align();
		}
		
		public function get value():uint
		{
			return uint(this._value.text);
		}
		
		public function set value(value:uint):void
		{
			this._value.text=String(value);
			alignText(this._value,5,0);
		}
		
		//============Instance Functions============//
		protected function addChilds():void
		{
			this.addChild(this._key);
			this.addChild(this._value);
		}
		
		protected function removeChilds():void
		{
			this.removeChild(this._key);
			this.removeChild(this._value);
		}
		
		public function align():void
		{
			this._key.x=this._key.y=0;
			alignText(this._key,5,5);
			this._value.x=this._key.width;
			this._value.y=0;
		}
		
		public function reset():void
		{
			this.value=0;
		}
		
		public function setBorder(value:Boolean):void
		{
			this._key.border=this._value.border=value;
		}
	}
}