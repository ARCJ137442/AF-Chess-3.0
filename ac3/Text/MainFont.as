package ac3.Text
{
	//TriangleCraft
	import ac3.Common.*;
	
	//Flash
	import flash.text.Font;

	public class MainFont extends Font
	{
		//============Static Variables============//
		protected static const _INSTANCE:MainFont=new MainFont();
		
		protected static var isRegisted:Boolean=false;
		
		//============Static Getter And Setter============//
		public static function get instance():MainFont
		{
			if(!isRegisted)
			{
				isRegisted=true;
			}
			return MainFont._INSTANCE;
		}
		
		//============Constructor Function============//
		public function MainFont():void
		{
			if(!isRegisted)
			{
				isRegisted=true;
			}
		}
	}
}