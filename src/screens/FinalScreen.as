package screens 
{
	import away3d.library.assets.BitmapDataAsset;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	import flash.utils.getTimer;
	import ui.MenuButton;
	import ui.MenuText;
	/**
	 * ...
	 * @author drcra
	 */
	public class FinalScreen extends Screen
	{
		private var currentLevelName:MenuText;
		private var startButton:MenuButton;
		private var previousButton:MenuButton;
		private var nextButton:MenuButton;
		private var currentLevel:uint = 1;
		private var levelImages:Array;
		private var levelImageX:Number;
		private var levelImageY:Number;
		private var bgRect:Sprite;
		
		private var isSwitching:Boolean = false;
		private var dAlpha:Number = 1;
		private var player:Bitmap;
		private var playerFrames:Array;
		private var playerFrame:Boolean;
		private var playerDelay:uint = 10;
		
		public function FinalScreen() 
		{
		}
		
		override public function init(params:Object = null):void 
		{
			super.init(params);
			
			var title:MenuText = new MenuText(25, true);
			title.text = "Thank you for playing my game";
			title.width = stage.stageWidth - 20;
			title.alpha = 0.5;
			title.x = 10;
			title.y = 5;
			addChild(title);
			
			currentLevelName = new MenuText(25, true);
			currentLevelName.text = "No Parachute!\n\n\nInspired by Das Uberleben";
			currentLevelName.x = 10;
			currentLevelName.y = 100;
			currentLevelName.width = stage.stageWidth - 20;
			currentLevelName.height = stage.stageHeight;
			addChild(currentLevelName);
			
			startButton = new MenuButton(50);
			startButton.text = "CREDITS";
			startButton.x = 0;
			startButton.y = stage.stageHeight - 100;
			startButton.width = stage.stageWidth;
			addChild(startButton);
			addEventListener(MouseEvent.CLICK, click);
			
			stage.stageFocusRect = false;
			stage.focus = this;
		}
		
		override public function close():void 
		{
			super.close();
			removeEventListener(MouseEvent.CLICK, click);
		}
		
		private function click(e:MouseEvent):void 
		{
			Instances.main.changeScreen(CreditsScreen);
		}
		
		
	}

}