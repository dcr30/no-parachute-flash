package  
{
	import away3d.debug.AwayStats;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import screens.LevelSelectionScreen;
	/**
	 * ...
	 * @author drcra
	 */
	public class Game extends Sprite
	{
		public var world:World;
		
		private var planeDelayMax:Number = 3000;
		private var planeDelayMin:Number = 2500;
		private var planeDelay:Number;
		
		private var checkpointDelay:Number;
		private var checkpointDelayMax:Number = 6000; 
		public var currentLevelID:uint = 0;
		public var isRunning:Boolean = true;
		
		public function Game(stage:Stage, config:Object, levelID:uint) 
		{
			currentLevelID = levelID;
			
			planeDelayMax = config.planeDelayMax;
			if (!planeDelayMax)
			{
				planeDelayMax = 3000;
				trace("Level " + levelID + " warning - no planeDelayMax");
			}
			planeDelayMin = config.planeDelayMin;
			if (!planeDelayMin)
			{
				planeDelayMin = 2500;
				trace("Level " + levelID + " warning - no planeDelayMin");
			}
			checkpointDelayMax = config.checkpointDelayMax;
			if (!checkpointDelayMax)
			{
				checkpointDelayMax = 6000;
				trace("Level " + levelID + " warning - no checkpointDelayMax");
			}
			
			world = new World(config, levelID);
			addChild(world);
			world.player = world.player;
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			planeDelay = 0;
			checkpointDelay = checkpointDelayMax;
			isRunning = true;
			//world.addCheckpoint();
		}
		
		public function destroyGame():void
		{
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			world.destroyWorld();
			removeChild(world);
			world = null;
		}
		
		private function cameraFollowPlayer():void
		{
			var cameraRadius:Number = 5;
			var cameraSlowdown:Number = 100;
			if (!world.player.alive)
			{
				cameraRadius = 20;
				cameraSlowdown = 500;
			}
			world.camera.x += (world.player.x - world.camera.x + Math.cos(getTimer() / cameraSlowdown) * cameraRadius) * 0.1;
			world.camera.z += (world.player.z - world.camera.z + Math.sin(getTimer() / cameraSlowdown) * cameraRadius) * 0.1;
		}
		
		public function update():void 
		{
			if (!isRunning)
			{
				return;
			}
			planeDelay -= world.fallingSpeed;
			if (planeDelay <= 0)
			{
				planeDelay = Utils.randomRangeSeed(planeDelayMin, planeDelayMax);
				world.addPlane();
			}
			checkpointDelay -= world.fallingSpeed;
			if (checkpointDelay <= 0)
			{
				checkpointDelay = checkpointDelayMax + 100;
				world.addCheckpoint("checkpoint");
			}
			cameraFollowPlayer();
			world.draw();
			
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			if (!isRunning)
			{
				return;
			}
			Input.keyDown(e.keyCode);
			if (!world.player.alive && e.keyCode == Input.ACTION)
			{
				if (world.lives > 0)
				{
					world.respawn();
				}
				else
				{
					world.init();
				}
				Instances.gameScreen.hideScreens();
			}
			if (world.isLevelEnded && e.keyCode == Input.ACTION)
			{
				Instances.main.changeScreen(LevelSelectionScreen, currentLevelID);
			}
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			Input.keyUp(e.keyCode);
		}
		
	}

}