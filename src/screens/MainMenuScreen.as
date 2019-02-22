package screens 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.media.SoundTransform;
	import ui.MenuButton;
	import ui.MenuRectangle;
	import flash.utils.getTimer;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author drcra
	 */
	public class MainMenuScreen extends Screen
	{
		private const rectSize:Number = 7;
		private var backgroundRects:Array = [];
		private var flyingRects:Array = [];
		private var logo:Bitmap;
		private var defaultLogoY:Number = 100;
		private var startButton:MenuButton;
		private var aboutButton:MenuButton;
		
		public function MainMenuScreen() 
		{
		}
		
		private function createFlying(rect:Sprite = null):Sprite
		{
			if (rect)
			{
				rect.x = Utils.randomRange(10, stage.stageWidth);
				rect.y = -50;				
			}
			else
			{
				rect = new Sprite();
				rect.x = Utils.randomRange(10, stage.stageWidth);
				rect.y = Utils.randomRange(0, stage.stageHeight);
				addChild(rect);
			}
			var sizeMul:Number = Utils.randomRange(5, 10) / 10;
			rect.graphics.clear();
			rect.graphics.beginFill(Utils.randomRange(0x000000,  0xFFFFFF));
			rect.graphics.drawRect(0, 0, rectSize * 2 * sizeMul, rectSize * 2 * sizeMul);
			rect.graphics.endFill();
			rect.alpha = sizeMul/2*(rect.x/stage.stageWidth);
			
			return rect;
		}
		
		override public function init(params:Object = null):void 
		{
			super.init(params);
			var rectsCount:int = Math.floor(stage.stageWidth / rectSize);
			var i:int;
			for (i = 0; i <= rectsCount; i++)
			{
				var bgRect:MenuRectangle = new MenuRectangle();
				bgRect.x = i * rectSize;
				bgRect.y = 0;
				bgRect.width = rectSize;
				bgRect.height = stage.stageHeight;
				bgRect.alpha = 0.15 * (i/rectsCount);
				bgRect.changeColor();
				backgroundRects.push(bgRect);
				addChild(bgRect);
			}
			
			for (i = 1; i <= 10; i++)
			{
				flyingRects.push(createFlying());
			}
			
			logo = Instances.assets.getBitmap("logo");
			logo.scaleX = 5;
			logo.scaleY = 5;
			addChild(logo);
			logo.x = stage.stageWidth / 2 - logo.width / 2;
			logo.y = 100;
			
			addChild(new MenuButton());
			
			startButton = new MenuButton();
			startButton.text = "Start game";
			startButton.x = 50;
			startButton.y = 300;
			addChild(startButton);

			aboutButton = new MenuButton();
			aboutButton.text = "Credits";
			aboutButton.x = 50;
			aboutButton.y = 350;
			addChild(aboutButton);
			
			addEventListener(MouseEvent.CLICK, click);
		}
		
		private function click(e:MouseEvent):void 
		{
			if (e.target == startButton)
			{
				Instances.main.changeScreen(LevelSelectionScreen);
				if (Instances.main.soundsMuted == false)
				{
					Instances.main.selectSound.play(0, 0, new SoundTransform(0.5, 0));
				}
			}
			else if (e.target == aboutButton)
			{
				Instances.main.changeScreen(CreditsScreen);
				if (Instances.main.soundsMuted == false)
				{
					Instances.main.selectSound.play(0, 0, new SoundTransform(0.5, 0));
				}
			}
		}
		
		override public function close():void 
		{
			super.close();
		}
		
		override public function update():void 
		{
			super.update();
			var i:int;
			for (i = 0; i < backgroundRects.length; i++)
			{
				backgroundRects[i].changeColor();
			}
			
			for (i = 0; i < flyingRects.length; i++)
			{
				flyingRects[i].y += 30;
				if (flyingRects[i].y > stage.stageHeight)
				{
					createFlying(flyingRects[i]);
				}
			}
			logo.y = defaultLogoY + Math.sin(getTimer() / 400) * 20;
		}
		
	}

}