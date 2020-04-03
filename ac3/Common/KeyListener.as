package ac3.Common
{
	//Flash
	import flash.display.Stage;
	import flash.events.KeyboardEvent;

	//Class
	public class KeyListener
	{
		//============Static Variables============//
		protected static const KEY_STR:String="Key_"
		
		//============Instance Variables============//
		protected var _listenTo:Stage=null
		protected var _pressedKeys:Object=new Object()
		//protected var pressedKeys:Vector.<uint>=new Vector.<uint>
		protected var _ctrlKey:Boolean=false
		protected var _shiftKey:Boolean=false
		protected var _altKey:Boolean=false
		
		//============Constructor Function============//
		public function KeyListener(listens:Stage):void
		{
			this.listens=listens
		}
		
		//============Destructor Function============//
		public function deleteSelf():void
		{
			this.listens=null
			for(var k:String in this._pressedKeys)
			{
				delete this._pressedKeys[k]
			}
			this._altKey=false
			this._ctrlKey=false
			this._shiftKey=false
		}
		
		//============Instance Getter And Setter============//
		public function get listens():Stage
		{
			return this.listenTo
		}
		
		public  function set listens(stage:Stage):void
		{
			//Detect
			if(this._listenTo==stage) return
			//Set Old
			if(_listenTo!=null)
			{
				if(_listenTo.hasEventListener(KeyboardEvent.KEY_DOWN))
				{
					_listenTo.removeEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
				}
				if(_listenTo.hasEventListener(KeyboardEvent.KEY_UP))
				{
					_listenTo.removeEventListener(KeyboardEvent.KEY_UP,onKeyUp)
				}
			}
			//Set Variable
			_listenTo=stage
			//Set New
			if(this._listenTo==null) return
			stage.addEventListener(KeyboardEvent.KEY_DOWN,onKeyDown)
			stage.addEventListener(KeyboardEvent.KEY_UP,onKeyUp)
		}
		
		public function get shiftKey():Boolean
		{
			return this._shiftKey
		}
		
		public function get ctrlKey():Boolean
		{
			return this._ctrlKey
		}
		
		public function get altKey():Boolean
		{
			return this._altKey
		}
		
		//============Instance Functions============//
		//Public Functions
		public function isKeyDown(code:uint):Boolean
		{
			return Boolean(_pressedKeys[KEY_STR+code])
			//return Key.pressedKeys.some(function(c,i,v):Boolean{return code==c})
		}
		
		public function isKeyUp(code:uint):Boolean
		{
			return !isKeyDown(code)
		}
		
		public function isAnyKeyPress():Boolean
		{
			for each(var b in _pressedKeys)
			{
				if(Boolean(b)) return true
			}
			return false
			//return Key.pressedKeys==null?false:Key.pressedKeys.length>0
		}
		
		//Listener Functions
		protected function onKeyDown(E:KeyboardEvent):void
		{
			onKeyDeal(E)
			//Key.pressedKeys.push(uint(E.keyCode))
			_pressedKeys[KEY_STR+E.keyCode]=true
		}
		
		protected function onKeyUp(E:KeyboardEvent):void
		{
			onKeyDeal(E)
			if(this.pressedKeys.indexOf(E.keyCode)>-1)
			//Key.pressedKeys.splice(Key.pressedKeys.indexOf(E.keyCode),1)
			_pressedKeys[KEY_STR+E.keyCode]=false
		}
		
		protected function onKeyDeal(E:KeyboardEvent):void
		{
			this._ctrlKey=E.ctrlKey
			this._shiftKey=E.shiftKey
			this._altKey=E.altKey
		}
	}
}