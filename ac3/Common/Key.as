package ac3.Common
{
	//Flash
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	//Class
	public final class Key
	{
		//Variables
		private static var listenTo:Stage=null
		private static var prassedKeys:Vector.<uint>=new Vector.<uint>
		private static var _ctrlKey:Boolean=false
		private static var _shiftKey:Boolean=false
		private static var _altKey:Boolean=false
		
		//Getters And Setters
		public static function get Listens():*
		{
			return Key.listenTo
		}
		
		public static function set Listens(_stage:Stage):void
		{
			if(_stage!=null)
			{
				//Set Old
				if(listenTo!=null)
				{
					if(listenTo.hasEventListener(KeyboardEvent.KEY_DOWN))
					{
						listenTo.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
					}
					if(listenTo.hasEventListener(KeyboardEvent.KEY_UP))
					{
						listenTo.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp)
					}
				}
				//Set New
				listenTo=_stage
				listenTo.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
				listenTo.addEventListener(KeyboardEvent.KEY_UP,onKeyUp)
			}
		}
		
		public static function get shiftKey():Boolean
		{
			return Key._shiftKey
		}
		
		public static function get ctrlKey():Boolean
		{
			return Key._ctrlKey
		}
		
		public static function get altKey():Boolean
		{
			return Key._altKey
		}
		
		//Public Functions
		public static function isDown(Code:uint):Boolean
		{
			return Key.prassedKeys.some(function(c,i,v):Boolean{return Code==c})
		}
		
		public static function isUp(Code:uint):Boolean
		{
			return !isDown(Code)
		}
		
		public static function isAnyKeyPrass():Boolean
		{
			return Key.prassedKeys==null?false:Key.prassedKeys.length>0
		}
		
		//Private Functions
		private static function onKeyDown(E:KeyboardEvent):void
		{
			onKeyDeal(E)
			Key.prassedKeys.push(uint(E.keyCode))
		}
		
		private static function onKeyUp(E:KeyboardEvent):void
		{
			onKeyDeal(E)
			if(Key.prassedKeys.indexOf(E.keyCode)>-1)
			Key.prassedKeys.splice(Key.prassedKeys.indexOf(E.keyCode),1)
		}
		
		private static function onKeyDeal(E:KeyboardEvent):void
		{
			Key._ctrlKey=E.ctrlKey
			Key._shiftKey=E.shiftKey
			Key._altKey=E.altKey
		}
	}
}