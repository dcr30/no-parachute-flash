package screens 
{
	import away3d.animators.data.SpriteSheetAnimationFrame;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import ui.MenuButton;
	import ui.MenuText;
	/**
	 * ...
	 * @author drcra
	 */
	public class GameScreen extends Screen
	{
		private var game:Game;
		private var cpText:MenuText;
		private var endText:MenuText;
		private var endText2:MenuText;
		private var endBg:Sprite;
		private var livesText:MenuText;
		private var config:Object;
		private var pauseButton:Sprite;
		private var pauseRect:Sprite;
		private var continueButton:MenuButton;
		private var backToMenuButton:MenuButton;
		private var muteSoundsButton:MenuButton;
		
		public function GameScreen() 
		{
			Instances.gameScreen = this;
		}
		
		override public function init(params:Object = null):void 
		{
			super.init(params);
			
			var cpImg:Bitmap = Instances.assets.getBitmap("cp_icon");
			addChild(cpImg);
			cpImg.x = 10;
			cpImg.y = 10;
			cpImg.scaleX = 3;
			cpImg.scaleY = 3;
			
			cpText = new MenuText(25);
			cpText.x = 40;
			cpText.text = "1000/10";
			addChild(cpText);
			
			var livesImg:Bitmap = Instances.assets.getBitmap("lives_icon");
			addChild(livesImg);
			livesImg.x = stage.stageWidth - 34 - 30;
			livesImg.y = 10;
			livesImg.scaleX = 3;
			livesImg.scaleY = 3;
			
			livesText = new MenuText(25);
			livesText.x = stage.stageWidth - 30;
			livesText.text = "3";
			addChild(livesText);
			
			endBg = new Sprite();
			endBg.width = 1;
			endBg.height = 1;
			setEndBgColor(0xFF0000);
			endBg.width = stage.stageWidth;
			endBg.height = stage.stageHeight;
			addChild(endBg);
			endBg.alpha = 0.2;
			
			endText = new MenuText(80, true);
			endText.width = stage.stageWidth;
			endText.y = stage.stageHeight / 2 - 100;
			endText.text = "";
			addChild(endText);
			
			endText2 = new MenuText(20, true);
			endText2.width = stage.stageWidth;
			endText2.y = stage.stageHeight / 2;
			endText2.text = "";
			addChild(endText2);
			hideScreens()
			
			config = Instances.assets.getConfig("levels/" + params + "/level.cfg");
			if (config)
			{
				game = new Game(stage, config, uint(params));
				addChild(game);
				stage.stageFocusRect = false;
				stage.focus = game;
			}
			
			pauseButton = new Sprite();
			pauseButton.graphics.clear();
			pauseButton.graphics.beginFill(0xFFFFFF, 0);
			pauseButton.graphics.drawRect(0, 0, 30, 30);
			pauseButton.graphics.endFill();
			
			pauseButton.graphics.beginFill(0xFFFFFF);
			pauseButton.graphics.drawRect(0, 0, 10, 30);
			pauseButton.graphics.endFill();
			
			pauseButton.graphics.beginFill(0xFFFFFF);
			pauseButton.graphics.drawRect(20, 0, 10, 30);
			pauseButton.graphics.endFill();
			addChild(pauseButton);
			
			pauseButton.x = stage.stageWidth - pauseButton.width - 10;
			pauseButton.y = stage.stageHeight - pauseButton.height - 10;
			pauseButton.alpha = 0.3;
			
			pauseButton.addEventListener(MouseEvent.MOUSE_OVER, pauseButton_mouseOver);
			pauseButton.addEventListener(MouseEvent.MOUSE_OUT, pauseButton_mouseOut);
			pauseButton.addEventListener(MouseEvent.CLICK, pauseButton_click);
			
			pauseRect = new Sprite();
			pauseRect.graphics.clear();
			pauseRect.graphics.beginFill(0,0.8);
			pauseRect.graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight / 3);
			pauseRect.graphics.endFill();
			pauseRect.y = stage.stageHeight / 3;
			addChild(pauseRect);
			
			var title:MenuText = new MenuText(25, true);
			pauseRect.addChild(title);
			title.text = "GAME IS PAUSED";
			title.x = 0;
			title.y = -60;
			title.width = stage.stageWidth;
			title.alpha = 0.5;		
			
			continueButton = new MenuButton();
			pauseRect.addChild(continueButton);
			continueButton.x = 0;
			continueButton.y = 20;
			continueButton.width = stage.stageWidth;
			continueButton.text = "Continue";
			
			backToMenuButton = new MenuButton();
			pauseRect.addChild(backToMenuButton);
			backToMenuButton.x = 0;
			backToMenuButton.y = 80;
			backToMenuButton.width = stage.stageWidth;
			backToMenuButton.text = "Menu";
			
			muteSoundsButton = new MenuButton();
			pauseRect.addChild(muteSoundsButton);
			muteSoundsButton.x = 0;
			muteSoundsButton.y = 140;
			muteSoundsButton.width = stage.stageWidth;
			muteSoundsButton.text = "Restart level";
			
			pauseRect.visible = false;
			
			addEventListener(MouseEvent.CLICK, click);
			
			Mouse.hide();
		}
		
		private function click(e:MouseEvent):void 
		{
			if (e.target == backToMenuButton)
			{
				Instances.main.changeScreen(LevelSelectionScreen, game.currentLevelID);
			}
			else if (e.target == continueButton)
			{
				pauseButton_click();
			}
			else if (e.target == muteSoundsButton)
			{
				Instances.gameScreen.hideScreens();
				game.isRunning = true;
				pauseRect.visible = false;
				game.world.init();
			}
		}
		
		private function pauseButton_click(e:MouseEvent=null):void 
		{
			game.isRunning = !game.isRunning;
			pauseRect.visible = !game.isRunning;
			if (pauseRect.visible)
			{
				Mouse.show();
			}
			else
			{
				Mouse.hide();
			}
		}
		
		private function pauseButton_mouseOver(e:MouseEvent):void 
		{
			pauseButton.alpha = 1;
		}
		
		private function pauseButton_mouseOut(e:MouseEvent):void 
		{
			pauseButton.alpha = 0.3;
		}
		
		override public function close():void 
		{
			super.close();
			pauseButton.removeEventListener(MouseEvent.MOUSE_OVER, pauseButton_mouseOver);
			pauseButton.removeEventListener(MouseEvent.MOUSE_OUT, pauseButton_mouseOut);
			pauseButton.removeEventListener(MouseEvent.CLICK, pauseButton_click);
			game.destroyGame();
			removeChild(game);
			game = null;
			Mouse.show();
		}
		
		private function setEndBgColor(color:uint):void
		{
			endBg.graphics.clear();
			endBg.graphics.beginFill(color);
			endBg.graphics.drawRect(0, 0, 1, 1);
			endBg.graphics.endFill();			
		}
		
		public function showDead():void
		{
			endBg.visible = true;
			endBg.alpha = 0;
			endText.text = "DEAD";
			endText.visible = true;
			endText2.text = "Press SPACE to try again";
			endText2.visible = true;
			setEndBgColor(0xFF0000);
			endText.textColor = 0xFFFFFF;
			endText2.textColor = 0xFFFFFF;
			endText2.alpha = 1
			endText.alpha = 1;
		}
		
		public function showEnding():void
		{
			endBg.visible = true;
			endBg.alpha = 0;
			endText.text = "LEVEL PASSED!";	
			endText.visible = true;
			endText2.text = "Press SPACE to continue";
			endText2.visible = true;		
			endText2.alpha = 0;
			endText.alpha = 0;
			var c:uint = config.menuColor;
			if (!c)
			{
				c = config.color;
			}
			setEndBgColor(c);
			endText.textColor = 0xFFFFFF;
			endText2.textColor = 0xFF0000;
		}
		
		public function showGameOver():void
		{
			endBg.visible = true;
			endBg.alpha = 0;
			endText.text = "GAME OVER";	
			endText.visible = true;
			endText2.text = "Press SPACE to restart this level";
			endText2.visible = true;
			setEndBgColor(0x000000);
			endText.textColor = 0xFF0000;
			endText2.textColor = 0xFFFFFF;
			endText2.alpha = 1;
			endText.alpha = 1;
		}
		
		public function hideScreens():void
		{
			endBg.visible = false;
			endText.visible = false;
			endText2.visible = false;			
		}
		
		override public function update():void 
		{
			endBg.alpha += 0.005;
			endText.alpha += 0.005;
			endText2.alpha += 0.005;
			super.update();
			cpText.text = game.world.checkpointsCount + "/" + game.world.checkpointsNeed;
			if (game.world.checkpointsCount >= game.world.checkpointsNeed)
			{
				cpText.textColor = 0xFFAA00;
			}
			else
			{
				cpText.textColor = 0xFFFFFF;
			}
			livesText.text = game.world.lives.toString();
			if (game.world.lives <= 1)
			{
				livesText.textColor = 0xFF0000;
			}
			else
			{
				livesText.textColor = 0xFFFFFF;
			}
			
			game.update();
		}
		
		
	}

}