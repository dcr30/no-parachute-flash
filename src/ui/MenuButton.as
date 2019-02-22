package ui 
{
	import flash.display.Sprite;
	import flash.events.Event;
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
	public class MenuButton extends TextField
	{
		private const DEFAULT_TEXT_SIZE:Number = 25;
		private var lx:Number = 0;
		private var ly:Number = 0;
		private var buttonTextDefault:uint = 0;
		private var buttonTextHover:uint = 0;
		private var shake:Number = 5;
		
		public function MenuButton(textSize:Number = DEFAULT_TEXT_SIZE, textColor1:uint = 0xFFFFFF, textColor2:uint = 0x7B2AEA) 
		{
			buttonTextDefault = textColor1;
			buttonTextHover = textColor2;
			super();
			textColor = buttonTextDefault;
			embedFonts = true;
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = "MainFont";
			textFormat.size = textSize;
			textFormat.align = TextFormatAlign.CENTER;
			defaultTextFormat = textFormat;
			autoSize = TextFieldAutoSize.CENTER;
			selectable = false;
			
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			addEventListener(Event.ENTER_FRAME, update);
		}
		
		private function mouseOut(e:MouseEvent):void 
		{
			textColor = buttonTextDefault;
			x = lx;
			y = ly;
		}
		
		private function mouseOver(e:MouseEvent):void 
		{
			textColor = buttonTextHover;
			lx = x;
			ly = y;
			shake = 10;
		}
		
		public function update(e:Event=null):void
		{
			if (textColor == buttonTextHover)
			{
				x = lx + Utils.randomRange(0, shake) - shake/2;
				y = ly + Utils.randomRange(0, shake) - shake / 2;
				shake *= 0.9;
			}
			else
			{
				
			}
		}
		
	}

}