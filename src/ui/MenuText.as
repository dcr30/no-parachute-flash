package ui 
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.Font;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	/**
	 * ...
	 * @author drcra
	 */
	public class MenuText extends TextField
	{
		public function MenuText(textSize:Number=25, center:Boolean = false) 
		{
			super();
			textColor = 0xFFFFFF;
			embedFonts = true;
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "MainFont";
			textFormat.size = textSize;
			autoSize = TextFieldAutoSize.LEFT;
			if (center)
			{
				autoSize = TextFieldAutoSize.NONE;
				textFormat.align = TextFormatAlign.CENTER;
			}
			defaultTextFormat = textFormat;
			selectable = false;
		}
		
	}

}