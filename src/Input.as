package  
{
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	/**
	 * ...
	 * @author drcra
	 */
	public class Input 
	{
		public static const LEFT:int = Keyboard.LEFT;
		public static const RIGHT:int = Keyboard.RIGHT;
		public static const UP:int = Keyboard.UP;
		public static const DOWN:int = Keyboard.DOWN;

		public static const LEFT_ALTERNATIVE:int = Keyboard.A;
		public static const RIGHT_ALTERNATIVE:int = Keyboard.D;
		public static const UP_ALTERNATIVE:int = Keyboard.W;
		public static const DOWN_ALTERNATIVE:int = Keyboard.S;
		
		public static const ACTION:int = Keyboard.SPACE;
		
		private static var keys:Array = [];
		public static function keyDown(keyCode:int):void
		{
			keys[keyCode] = true;
		}
		
		public static function keyUp(keyCode:int):void
		{
			keys[keyCode] = false;
		}
		
		public static function isDown(keyCode:int):Boolean
		{
			if (keys[keyCode] == true)
			{
				return true;
			}
			else
			{
				return false;
			}
		}
		
	}

}