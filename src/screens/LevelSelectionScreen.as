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
	import flash.media.SoundTransform;
	import flash.utils.getTimer;
	import ui.MenuButton;
	import ui.MenuText;
	/**
	 * ...
	 * @author drcra
	 */
	public class LevelSelectionScreen extends Screen
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
		private var levelState:MenuText;
		private var blackRect:Sprite;
		private var levelStats:MenuText;
		
		public function LevelSelectionScreen() 
		{
		}
		
		override public function init(params:Object = null):void 
		{
			super.init(params);
			levelImages = [];
			
			bgRect = new Sprite();
			bgRect.graphics.drawRect(0, 0, 1, 1);
			bgRect.width = 64 * 13.1;
			bgRect.height = 64 * 13.1; 		
			//bgRect.alpha = 0;
			levelImages.push(bgRect);
			
			var i:int;
			for (i = 1; i <= 5; i++)
			{
				var levelImage:Bitmap = new Bitmap;
				addChildAt(levelImage, 0);
				levelImages.push(levelImage);
			}
			
			
			playerFrame = false;
			playerFrames = [
				Instances.assets.getBitmap("player1").bitmapData,
				Instances.assets.getBitmap("player2").bitmapData
			];
			for (i = 0; i < playerFrames.length; i++)
			{
				BitmapData(playerFrames[i]).colorTransform(new Rectangle(0, 0, 32, 32), new ColorTransform(0.2, 0.4, 1, 1));
			}
			
			player = new Bitmap(playerFrames[0]);
			player.scaleX = 3;
			player.scaleY = 3;
			addChild(player);
			
			
			addChildAt(bgRect, 0);
			
			startButton = new MenuButton(50);
			startButton.text = "START GAME!";
			startButton.x = 0;
			startButton.y = stage.stageHeight - 100;
			startButton.width = stage.stageWidth;
			addChild(startButton);
			
			blackRect = new Sprite();
			blackRect.graphics.beginFill(0);
			blackRect.graphics.drawRect(0, 0, 1, 1);
			blackRect.graphics.endFill();
			blackRect.width = stage.stageWidth;
			blackRect.height = stage.stageHeight;
			addChild(blackRect);
			blackRect.alpha = 0.8;
			blackRect.visible = false;
			
			var title:MenuText = new MenuText(25, true);
			title.text = "Select level";
			title.width = stage.stageWidth - 20;
			title.alpha = 0.5;
			title.x = 10;
			title.y = 5;
			addChild(title);
			
			currentLevelName = new MenuText(35, true);
			currentLevelName.text = "adssaasddassd";
			currentLevelName.x = 0;
			currentLevelName.y = 100;
			currentLevelName.width = 64 * 13.1 / 2;
			addChild(currentLevelName);			
			
			previousButton = new MenuButton(50, 0x7B2AEB);
			previousButton.text = "<<";
			previousButton.x = 0;
			previousButton.width = 100;
			previousButton.y = stage.stageHeight / 2 - previousButton.height / 2;
			addChild(previousButton);
			
			nextButton = new MenuButton(50, 0x7B2AEB);
			nextButton.text = ">>";
			nextButton.x = stage.stageWidth - nextButton.width;
			nextButton.y = stage.stageHeight / 2 - nextButton.height / 2;
			nextButton.width = 50;
			addChild(nextButton);			
			levelImages[0].alpha = 0;
			
			levelState = new MenuText(65, true);
			levelState.text = "Completed";
			levelState.textColor = 0x00FF00;
			levelState.x = 100;
			levelState.y = stage.stageHeight / 2 - levelState.height / 2;
			levelState.width = stage.stageWidth - 200;
			addChild(levelState);
			
			levelStats = new MenuText(25, true);
			levelStats.text = "Deaths: 0 \nCheckpoints collected: 0";
			levelStats.x = 100;
			levelStats.y = stage.stageHeight / 2 - levelState.height / 2 + 100;
			levelStats.width = stage.stageWidth - 200;
			levelStats.visible = false;
			addChild(levelStats);
			
			if (params)
			{
				currentLevel = uint(params);
			}
			
			showLevel();
			update();
			
			addEventListener(MouseEvent.CLICK, click);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDown);
			stage.stageFocusRect = false;
			stage.focus = this;
		}
		
		override public function close():void 
		{
			super.close();
			removeEventListener(MouseEvent.CLICK, click);
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDown);
		}
		
		private function showLevel():void
		{
			for (var i:int = 1; i < levelImages.length; i++)
			{
				levelImages[i].bitmapData = Instances.assets.getBitmap("levels/" + currentLevel + "/planes/" + i).bitmapData.clone();
				levelImages[i].scaleX = 13.1 / i;
				levelImages[i].scaleY = 13.1 / i;
				levelImages[i].alpha = 0;
				levelImages[i].bitmapData.colorTransform(new Rectangle(0, 0, levelImages[i].width, levelImages[i].height), new ColorTransform(1 / (i * 0.9), 1 / (i * 0.9), 1 / (i * 0.9), 1));
			}
			var levelColor:uint = Instances.assets.getConfig("levels/" + currentLevel + "/level.cfg").menuColor;
			if (!levelColor)
			{
				levelColor = Instances.assets.getConfig("levels/" + currentLevel + "/level.cfg").color;
			}
			currentLevelName.text = "Cave " + currentLevel;  Instances.assets.getConfig("levels/" + currentLevel + "/level.cfg").name;
			currentLevelName.textColor = levelColor;
			bgRect.graphics.clear();
			bgRect.graphics.beginFill(levelColor);
			bgRect.graphics.drawRect(0, 0, 1, 1);
			bgRect.graphics.endFill();
			
			/*if (currentLevel <= Instances.main.saves.data.levelsPassed)
			{
				levelState.text = "Passed";
				levelState.visible = true;
				levelState.textColor = 0x00FF00;	
				blackRect.visible = false;
				levelStats.visible = true;
				
				if (!Instances.main.saves.data["lvl" + currentLevel].deaths)
				{
					Instances.main.saves.data["lvl" + currentLevel].deaths = 0;
				}
				if (!Instances.main.saves.data["lvl" + currentLevel].checkpoints)
				{
					Instances.main.saves.data["lvl" + currentLevel].checkpoints = 0;
				}
				levelStats.text = "Deaths: " + String(Instances.main.saves.data["lvl" + currentLevel].deaths) + "\nCheckpoints collected: " + String(Instances.main.saves.data["lvl" + currentLevel].checkpoints);
			}
			else if (currentLevel == Instances.main.saves.data.levelsPassed + 1)
			{
				levelState.text = "Not passed";
				levelState.visible = false;
				levelState.textColor = 0xBEBEBE;	
				
				blackRect.visible = false;
				levelStats.visible = false;
			}
			else
			{
				levelState.text = "Locked";
				levelState.visible = true;
				levelState.textColor = 0xFF0000;	
				
				blackRect.visible = true;
				levelStats.visible = false;
			}*/
		}
		
		private function switchLevel(cLevel:int):void
		{
			if (cLevel < 1)
			{
				return;
			}
			if (cLevel > Main.LEVELS_COUNT)// || cLevel > Instances.main.saves.data.levelsPassed + 2)
			{
				return;
			}
			currentLevel = cLevel;
			isSwitching = true;
			dAlpha = 0;			
		}
		
		private function click(e:MouseEvent):void 
		{
			if (e.target == startButton)// && currentLevel <= Instances.main.saves.data.levelsPassed + 1)
			{
				Instances.main.changeScreen(GameScreen, currentLevel);
				if (Instances.main.soundsMuted == false)
				{
					Instances.main.planeSound.play(0, 0, new SoundTransform(0.5, 0));
				}
			}
			else if (e.target == nextButton)
			{
				switchLevel(currentLevel + 1);
			}
			else if (e.target == previousButton)
			{
				switchLevel(currentLevel - 1);
			}
		}
		
		private function keyDown(e:KeyboardEvent):void
		{
			if (e.keyCode == Input.LEFT || e.keyCode == Input.LEFT_ALTERNATIVE)
			{
				switchLevel(currentLevel - 1);
			}
			else if (e.keyCode == Input.RIGHT || e.keyCode == Input.RIGHT_ALTERNATIVE)
			{
				switchLevel(currentLevel + 1);
			}
		}
		
		override public function update():void 
		{
			super.update();
			for (var i:int = 1; i < levelImages.length; i++)
			{
				levelImages[i].x = stage.stageWidth / 2 - levelImages[i].width / 2 + Math.cos(getTimer() / 1000) * 40 / (i + 1);
				levelImages[i].y = stage.stageHeight / 2 - levelImages[i].height / 2 + Math.sin(getTimer() / 1000) * 40 / (i + 1);
				levelImages[i].alpha += (dAlpha - levelImages[i].alpha) * 0.1;
			}
			levelImages[0].x = levelImages[1].x;
			levelImages[0].y = levelImages[1].y;
			levelImages[0].alpha += (dAlpha * 0.15 - levelImages[0].alpha) * 0.1;
			if (levelImages[0].alpha <= 0 && isSwitching)
			{
				showLevel();
				isSwitching = false;
				dAlpha = 1;
			}
			currentLevelName.x = levelImages[2].x;
			currentLevelName.y = levelImages[2].y;
			currentLevelName.alpha += (dAlpha - currentLevelName.alpha) * 0.3;
			if (player)
			{
				player.x = (stage.stageWidth - player.width) / 2 + Math.cos(getTimer() / 1000) * 40;
				player.y = (stage.stageHeight - player.height) / 2 + Math.sin(getTimer() / 1000) * 40;
				player.rotation = Math.cos(getTimer() / 2000) * 10;
				player.alpha += (dAlpha - player.alpha) * 0.3;
				playerDelay--;
				if (playerDelay <= 0)
				{
					playerDelay = 5;
					if (playerFrame)
					{
						player.bitmapData = playerFrames[0];
						playerFrame = false;
					}
					else
					{
						player.bitmapData = playerFrames[1];
						playerFrame = true;
					}
				}
			}
		}
		
	}

}