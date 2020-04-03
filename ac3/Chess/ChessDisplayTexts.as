package ac3.Chess 
{
	//Flash
	import flash.display.MovieClip;
	import flash.text.TextField;
	
	public class ChessDisplayTexts extends MovieClip
	{
		//============Constructor Function============//
		public function ChessDisplayTexts():void
		{
			this.stop();
			
			this.levelText.selectable=false;
			this.levelText.multiline=false;
			this.levelText.wordWrap=false;
			
			this.lifeText.selectable=false;
			this.lifeText.multiline=false;
			this.lifeText.wordWrap=false;
			
			this.importmentText.selectable=false;
			this.importmentText.multiline=false;
			this.importmentText.wordWrap=false;
			
			this.beMindContolText.selectable=false;
			this.beMindContolText.multiline=false;
			this.beMindContolText.wordWrap=false;
		}
		
		//============Instance Functions============//
		public function get level():uint
		{
			return uint(parseInt(this.levelText.text));
		}
		
		public function set level(value:uint):void
		{
			this.levelText.text=value==0?"":String(value);
		}
		
		public function get life():int
		{
			return int(parseInt(this.lifeText.text));
		}
		
		public function set life(value:int):void
		{
			this.lifeText.text=value<0?"":String(value);
		}
		
		public function get importment():Boolean
		{
			return this.importmentText.visible;
		}
		
		public function set importment(value:Boolean):void
		{
			this.importmentText.visible=value;
		}
		
		public function get beMindContol():Boolean
		{
			return this.beMindContolText.visible;
		}
		
		public function set beMindContol(value:Boolean):void
		{
			this.beMindContolText.visible=value;
		}
	}
}