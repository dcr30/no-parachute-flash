package 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.text.TextField;
	import screens.MainMenuScreen;
	import flash.text.Font;
	
	/**
	 * ...
	 * @author drcra
	 */
	public class Main extends Sprite 
	{
		public var coinSound:Sound;
		public var planeSound:Sound;
		public var selectSound:Sound;
		private var currentScreen:Screen;
		private var menuThemeSound:Sound;
		private var menuThemeChannel:SoundChannel;
		private var menuThemePos:Number = 0;
		private var soundIcons:Array;
		private var soundButton:Sprite;
		
		public var soundsMuted:Boolean = false;
		private var screenContainer:Sprite;
		private var tf:TextField;
		public var bamSound:Sound;
		public var saves:SharedObject;
		
		public static const LEVELS_COUNT:uint = 8;
		
		public function Main():void 
		{
			tf = new TextField();
			tf.text = "Loading. Wait please...";
			addChild(tf);
			tf.x = 10;
			tf.y = 10;
			Instances.main = this;
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		public function changeScreen(screenClass:Class, params:Object = null):void
		{
			if (!screenClass is Screen)
			{
				return;
			}
			if (currentScreen != null)
			{
				currentScreen.close();
				screenContainer.removeChild(currentScreen);
				currentScreen = null;
			}
			currentScreen = new screenClass();
			screenContainer.addChild(currentScreen);
			currentScreen.init(params);
		}
		
		private function update(e:Event):void
		{
			currentScreen.update();
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			Instances.assets = new Assets();
			Instances.assets.addEventListener(Event.COMPLETE, onAssetsLoaded);
			Instances.assets.loadAssets();
		}
		
		public function stopMenuTheme():void
		{
			menuThemePos = menuThemeChannel.position;
			menuThemeChannel.stop();
		}
		
		public function startMenuTheme():void
		{
			menuThemeChannel = menuThemeSound.play(menuThemePos, int.MAX_VALUE);
		}
		
		private function onAssetsLoaded(e:Event):void
		{			
			removeChild(tf);
			saves = SharedObject.getLocal("BrightSunGamesNoParachute");
			if (saves.data.levelsPassed == null)
			{
				saves.data.levelsPassed = 0;
			}
			for (var i:uint = 1; i <= LEVELS_COUNT; i++)
			{
				if (!saves.data["lvl" + i])
				{
					saves.data["lvl" + i] = { };
					saves.data["lvl" + i].deaths = 0;
					saves.data["lvl" + i].checkpoints = 0;
				}
			}
			
			screenContainer = new Sprite();
			addChild(screenContainer);
			changeScreen(MainMenuScreen);
			addEventListener(Event.ENTER_FRAME, update);
			menuThemeSound = Instances.assets.getSound("sounds/theme1.mp3"); // Music: Long Time Coming by Kevin MacLeod (incompetech.com)
			coinSound = Instances.assets.getSound("sounds/coin.mp3");
			bamSound = Instances.assets.getSound("sounds/bam.mp3");
			selectSound = Instances.assets.getSound("sounds/menu.mp3");
			planeSound = Instances.assets.getSound("sounds/wall.mp3");
			menuThemeChannel = menuThemeSound.play(menuThemePos, int.MAX_VALUE);
			
			
			soundButton = new Sprite();
			soundButton.useHandCursor = true;
			soundIcons = [Instances.assets.getBitmap("sound_icon"), Instances.assets.getBitmap("sound_icon2")];
			soundIcons[0].scaleX = soundIcons[0].scaleY = soundIcons[1].scaleX = soundIcons[1].scaleY = 0.3;
			soundIcons[0].smoothing = soundIcons[1].smoothing = true;
			soundButton.addChild(soundIcons[0]);
			soundButton.x = 10;
			soundButton.alpha = 0.5;
			soundButton.y = stage.stageHeight - soundButton.height - 10;
			addChild(soundButton);
			soundButton.addEventListener(MouseEvent.CLICK, toggleSound);
			soundsMuted = false;
			if (saves.data.soundEnabled == false)
			{
				toggleSound();
			}
			else if (saves.data.soundEnabled == null)
			{
				saves.data.soundEnabled = true;
			}
		}
		
		private function toggleSound(e:MouseEvent = null):void 
		{
			if (soundsMuted)
			{
				soundsMuted = false;
				soundButton.removeChild(soundIcons[1]);
				soundButton.addChild(soundIcons[0]);
				startMenuTheme();
			}
			else
			{
				soundsMuted = true;
				soundButton.removeChild(soundIcons[0]);
				soundButton.addChild(soundIcons[1]);
				stopMenuTheme()
			}
			saves.data.soundEnabled = !soundsMuted;
		}
		
	}
	
}