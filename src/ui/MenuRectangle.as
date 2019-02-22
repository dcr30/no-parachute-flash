package ui 
{
	import flash.display.Sprite;
	/**
	 * ...
	 * @author drcra
	 */
	public class MenuRectangle extends Sprite
	{
		
		public function MenuRectangle() 
		{
			changeColor();
		}
		
		public function changeColor():void
		{
			graphics.clear();
			graphics.beginFill(Utils.randomRange(0x000000,  0xFFFFFF));
			graphics.drawRect(0, 0, 10, 10);
			graphics.endFill();

		}
		
	}

}