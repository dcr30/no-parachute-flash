package  
{
	import away3d.animators.nodes.ParticleAccelerationNode;
	import away3d.cameras.Camera3D;
	import away3d.containers.View3D;
	import away3d.debug.AwayStats;
	import away3d.entities.Mesh;
	import away3d.lights.PointLight;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;
	import flash.geom.Vector3D;
	import flash.media.SoundTransform;
	import flash.utils.getTimer;
	import screens.FinalScreen;
	/**
	 * Realizes Away3D code
	 * @author drcra
	 */
	public class World extends Sprite 
	{
		// Constants
		public const wallSize:Number = 1300;
		public const wallCount:uint = 10;
		// Public
		public var player:Player;
		public var camera:Camera3D;
		public var wallsHeight:Number;
		public var fallingSpeed:Number = 80; // 80
		
		public var rotationMul:Number = 1000;
		private var isRotationFrozen:Boolean = false;
		// Private
		private var view:View3D;
		private var light:PointLight;
		private var lightPicker:StaticLightPicker;
		// Containers
		private var movingObjects:Array;
		private var walls:Array;
		private var planes:Array;
		private var particles:Array;
		private var lastPlane:Plane;
		
		private var currentLevelID:uint = 1;
		private var levelConfig:Object;
		
		private var spawnPlanes:Boolean = true;
		private var spawnCheckpoints:Boolean = true;
		
		public var checkpointsCount:uint = 0;
		public var checkpointsNeed:uint = 999;
		
		public var lives:uint = 3;
		
		private const defaultEndingDelay:uint = 300;
		private var endingDelay:uint;
		private var endingEnabled:Boolean;
		public  var isLevelEnded:Boolean;
		
		private const decoFrequency:Number = 200;//200
		private var deco:Array;
		
		private var isPlayerGod:Boolean = false;
		private var respawnGodDelay:Number = 0;
		private var respawnGodDelayMax:Number = 300;
		
		private var defaultFallingSpeed:Number = 0;
		
		private var levelParticlesSpeed:Number = 100;
		
		private var gameTime:uint = 0;
		
		private var isFirstRecord:Boolean = true;
		private var recording:Array;
		private var replayPos:uint = 0;
		private var isRecording:Boolean;
		private var secondPlayer:Player;
		
		public function World(config:Object, levelID:uint) 
		{
			//var stats:AwayStats = new AwayStats(view);
			//addChild(stats);
			//stats.y = 600 - stats.height;
			
			currentLevelID = levelID;
			levelConfig = config;
			
			wallsHeight = wallSize * wallCount;
			// Create Away3D scene and setup camera
			view = new View3D();
			addChild(view);
			camera = view.camera;
			camera.lens.far = wallsHeight + 10;
			
			// Setup light
			light = new PointLight();
			light.x = wallSize / 2;
			light.y = wallsHeight;
			light.z = wallSize / 2;
			light.color = uint(config.color);
			light.ambient = 0.02;
			light.specular = 0;
			light.fallOff = light.y;
			light.castsShadows = true;
			light.diffuse = 1;
			view.scene.addChild(light);
			
			lightPicker = new StaticLightPicker([light]);	
			
			// Setup walls
			walls = new Array();
			for (var i:int = 0; i < wallCount; i++)
			{
				var wall:Wall = new Wall(wallSize, lightPicker, levelID);
				wall.y = wallSize * i;
				view.scene.addChild(wall);
				walls.push(wall);
			}
			
			recording = [];
			isFirstRecord = true;
			init();
		}
		
		public function init():void
		{	
			Utils.seed = levelConfig.seed;
			isLevelEnded = false;
			spawnPlanes = true;
			replayPos = 0;
			spawnCheckpoints = true;
			lives = 3;
			checkpointsCount = 0;
			if (movingObjects && planes)
			{
				var i:int;
				for (i = 0; i < movingObjects.length; i++)
				{
					removeMoving(i);
				}
				for (i = 0; i < planes.length; i++)
				{
					removePlane(i);
				}
			}
			if (deco)
			{
				for (i = 0; i < deco.length; i++)
				{
					view.scene.removeChild(deco[i]);
					deco[i] = null;
				}
			}
			rotationMul = Number(levelConfig.rotationMul);
			if (!rotationMul)
			{
				rotationMul = 1;
				trace("Level " + currentLevelID + " warning - no rotationMul");
			}
			
			checkpointsNeed = levelConfig.checkpoints;
			if (!checkpointsNeed)
			{
				checkpointsNeed = 999;
				trace("Level " + currentLevelID + " warning - no checkpointsNeed");
			}
			
			
			isRotationFrozen = true;
			if (levelConfig.rotationEnabled == "true")
			{
				isRotationFrozen = false;
				//trace("Level " + currentLevelID + " warning - no rotationEnabled");
			}
			
			fallingSpeed = levelConfig.speed;
			defaultFallingSpeed = fallingSpeed;
			if (!fallingSpeed)
			{
				fallingSpeed = 60;
				defaultFallingSpeed = 60;
				trace("Level " + currentLevelID + " warning - no speed");
			}
			
			// Setup containers
			movingObjects = new Array();
			planes = new Array();
			deco = new Array();
			if (levelConfig.deco)
			{
				for (i = 1; i <= Math.floor(wallsHeight / decoFrequency); i++)
				{
					var d:Plane = addPlane(true); 
					d.y = i * decoFrequency;
				}
			}
			
			if (levelConfig.particles == "true")
			{
				for (i = 1; i <= 40; i++)
				{
					var p:Particle = new Particle(levelConfig.particlesColor);
					p.x = Utils.randomRange(0, wallSize);
					p.z = Utils.randomRange(0, wallSize);
					p.y = Utils.randomRange(0, wallsHeight);
					view.scene.addChild(p);
					movingObjects.push(p);
				}			
				levelParticlesSpeed = levelConfig.particlesSpeed;
			}
			camera.x = wallSize / 2;
			camera.y = wallsHeight - wallSize / 2;
			camera.z = wallSize / 2;
			camera.lookAt(new Vector3D(wallSize / 2, 0, wallSize / 2));
			
			player = new Player();
			addMoving(player);
			player.alive = true;
			player.x = wallSize / 2;
			player.y = camera.y - 840;
			player.z = wallSize / 2;
			
			secondPlayer = new Player(0, 1, 1);
			addMoving(secondPlayer);
			secondPlayer.y = camera.y - 840 - 50;
			secondPlayer.visible = false;
			
			endingEnabled = false;
		}
		
		public function respawn():void
		{
			fallingSpeed = defaultFallingSpeed;
			if (endingEnabled)
			{
				endingDelay = defaultEndingDelay;
			}
			lastPlane.y += 200;
			lastPlane = null;
			var i:int;
			for (i = 0; i < movingObjects.length; i++)
			{
				if (movingObjects[i] is Blood)
				{
					removeMoving(i);
				}
			}
			player.alive = true;
			player.x = wallSize / 2;
			player.y = camera.y - 840;
			player.z = wallSize / 2;
			player.velocity = new Vector3D();
			player.realRotation = 0;
			player.rotationY = 0;
			
			makePlayerGod();
			
			// TODO Make speed proper
			fallingSpeed = levelConfig.speed;
			
			camera.x = wallSize / 2;
			camera.y = wallsHeight - wallSize / 2;
			camera.z = wallSize / 2;
			
			isRotationFrozen = true;
			if (levelConfig.rotationEnabled == "true")
			{
				isRotationFrozen = false;
			}
		}
		
		public function addNPC():void
		{
			return;
			var npc:Player = new Player();
			addMoving(npc);
			npc.alive = true;
			npc.x = wallSize / 2;
			npc.y = camera.y - 840;
			npc.z = wallSize / 2;			
		}
		
		public function destroyWorld():void
		{
			removeChild(view);
			view.stage3DProxy.dispose();
		}
		
		public function addMoving(o:MovingObject):void
		{
			var isAdded:Boolean = false;
			for (var i:int = 0; i < movingObjects.length; i++)
			{
				if (!movingObjects[i])
				{
					movingObjects[i] = o;
					isAdded = true;
					break;
				}
			}
			if (!isAdded)
			{
				movingObjects.push(o);
			}
			view.scene.addChild(o);
		}
		
		public function removeMoving(id:int):void
		{
			if (movingObjects[id])
			{
				view.scene.removeChild(movingObjects[id]);
				movingObjects[id] = null;
			}
		}
		
		public function addPlane(isDeco:Boolean = false):Plane
		{
			if (!spawnPlanes)
			{
				return null;
			}
			
			var o:Plane;
			if (isDeco)
			{
				o = new Plane(wallSize, lightPicker, currentLevelID, uint(levelConfig.deco), "deco");
				deco.push(o);
				view.scene.addChild(o);
				return o;
			}
			else
			{
				o = new Plane(wallSize, lightPicker, currentLevelID, uint(levelConfig.planes));
			}
			var isAdded:Boolean = false;
			for (var i:int = 0; i < planes.length; i++)
			{
				if (!planes[i])
				{
					planes[i] = o;
					isAdded = true;
					break;
				}
			}
			if (!isAdded)
			{
				planes.push(o);
			}
			view.scene.addChild(o);
			return o;
		}
		
		public function removePlane(id:int):void
		{
			if (planes[id])
			{
				view.scene.removeChild(planes[id]);
				planes[id] = null;
			}
		}
		
		public function addCheckpoint(type:String="checkpoint"):void
		{
			if (!spawnCheckpoints)
			{
				return;
			}
			var o:Checkpoint = new Checkpoint(wallSize, lightPicker, type);
			var isAdded:Boolean = false;
			for (var i:int = 0; i < planes.length; i++)
			{
				if (!planes[i])
				{
					planes[i] = o;
					isAdded = true;
					break;
				}
			}
			if (!isAdded)
			{
				planes.push(o);
			}
			view.scene.addChild(o);
		}
		
		public function draw():void
		{
			gameTime++;
			if (isPlayerGod)
			{
				respawnGodDelay--;
				if (respawnGodDelay <= 0)
				{
					player.stopFlashing();
					isPlayerGod = false;
				}
			}
			if (endingEnabled)
			{
				endingDelay -= 1;
				if (endingDelay <= 0)
				{
					endingEnabled = false;
					levelEnded();
				}
			}
			camera.rotationY = 0;
			if (player.alive)
			{
				player.x += ((stage.mouseX / stage.stageWidth) * wallSize - player.x) * 0.05;
				player.z += ((wallSize - (stage.mouseY / stage.stageHeight) * wallSize) - player.z) * 0.05;
				//player.x = player.px * Math.cos(-camera.rotationY / 180 * Math.PI);
				//player.z = player.pz * Math.sin(-camera.rotationY / 180 * Math.PI); 				//velocity.x -= speed 
				//velocity.z -= speed * Math.sin(-realRotation / 180 * Math.PI);
				
				player.rotationY = camera.rotationY + ((stage.mouseX / stage.stageWidth) * wallSize - player.x) * 0.05;
			}
			if (player.alive && fallingSpeed != 0)
			{
				fallingSpeed += (defaultFallingSpeed - fallingSpeed) * 0.01;
			}
			if (!isRotationFrozen)
			{
				//camera.rotationY = Math.sin(gameTime / rotationMul) * 180;
			}
			light.y = camera.y;
			view.render();
			
			var i:uint;
			for (i = 0; i < movingObjects.length; i++)
			{
				if (!movingObjects[i])
				{
					continue;
				}
				movingObjects[i].update();
				if (movingObjects[i].x < movingObjects[i].width / 2)
				{
					movingObjects[i].x = movingObjects[i].width / 2;
				}
				else if (movingObjects[i].x > wallSize - movingObjects[i].width / 2)
				{
					movingObjects[i].x = wallSize - movingObjects[i].width / 2;
				}
				
				if (movingObjects[i].z < movingObjects[i].width / 2)
				{
					movingObjects[i].z = movingObjects[i].width / 2;
				}
				else if (movingObjects[i].z > wallSize - movingObjects[i].width / 2)
				{
					movingObjects[i].z = wallSize  - movingObjects[i].width / 2;
				}
				
				if (movingObjects[i] is Blood)
				{
					if (lastPlane)
					{
						if (!lastPlane.canCollide(Math.floor(movingObjects[i].x / wallSize*lastPlane.textureSize), Math.floor((wallSize - movingObjects[i].z) / wallSize*lastPlane.textureSize)))
						{
							removeMoving(i);
							continue;
						}
					}
					movingObjects[i].delay--;
					if (movingObjects[i].delay <= 0 || movingObjects[i].y >= wallsHeight)
					{
						removeMoving(i);
						continue;
					}
				}
				else if (movingObjects[i] is Particle)
				{
					movingObjects[i].y += levelParticlesSpeed + fallingSpeed;
					if (movingObjects[i].y > wallsHeight)
					{
						movingObjects[i].y = 0;
					}
					else if (movingObjects[i].y < 0)
					{
						movingObjects[i].y = wallsHeight;
					}
				}
			}
			
			
			for (i = 0; i < walls.length; i++)
			{
				walls[i].y += fallingSpeed;
				if (walls[i].y > wallsHeight)
				{
					walls[i].y = walls[i].y - wallsHeight;
				}
			}
			
			for (i = 0; i < deco.length; i++)
			{
				deco[i].y += fallingSpeed;
				if (deco[i].y > wallsHeight)
				{
					deco[i].y = deco[i].y - wallsHeight;
				}
				var colorTransformParam:Number = deco[i].y / (wallCount * wallSize);
				deco[i].textureMaterial.colorTransform = new ColorTransform(colorTransformParam, colorTransformParam, colorTransformParam, 1);
			}
			
			for (i = 0; i < planes.length; i++)
			{
				if (!planes[i])
				{
					continue;
				}
				planes[i].y += fallingSpeed;
				if (planes[i].y > wallsHeight)
				{
					removePlane(i);
					//addPlane(new Plane(wallSize, lightPicker));
					continue;
				}
				if (planes[i] is Checkpoint)
				{
					//planes[i].rotationY += 10;
				}
				if (player.y > planes[i].y - fallingSpeed/2 && player.y < planes[i].y + fallingSpeed/2)
				{
					if (planes[i] is Plane)
					{
						if (planes[i].canCollide(Math.floor(player.x / wallSize*planes[i].textureSize), Math.floor((wallSize - player.z) / wallSize*planes[i].textureSize)))
						{
							// Fail
							playerHitPlane(planes[i]);
						}
						else
						{
							// Success
						}
					}
					else if (planes[i] is Checkpoint)
					{
						///if (player.x >= planes[i].x && player.x <= planes[i].x + planes[i].width && player.z >= planes[i].z && player.z <= planes[i].z + planes[i].height)
						if (((player.x - planes[i].x)*(player.x - planes[i].x) + (player.z - planes[i].z)*(player.z - planes[i].z)) < (planes[i].width * planes[i].width + player.width * player.width/3.5))
						{
							if (planes[i].type == "checkpoint")
							{
								playerHitCheckpoint(i);
							}
							else if (planes[i].type == "speedup")
							{
								playerTakeSpeedup(i);
							}
							continue;
						}
					}
					/*else if (planes[i] is Killer)
					{
						planes[i].y = player.y;
						planes[i].update();
					}*/
				}
				var colorTransformParam:Number = planes[i].y / (wallCount * wallSize) * 1.5;
				planes[i].textureMaterial.colorTransform = new ColorTransform(colorTransformParam, colorTransformParam, colorTransformParam, 1);
			}
			player.realRotation = camera.rotationY;
			
			if (recording[replayPos] && player.alive)
			{
				//secondPlayer.x = recording[replayPos][0];
				//secondPlayer.z = recording[replayPos][1];
				//secondPlayer.rotationY = recording[replayPos][2];			
				//secondPlayer.visible = recording[replayPos][3];
			}
			else
			{
				secondPlayer.visible = false;
			}
			
			if (fallingSpeed != 0)
			{
				//recording[replayPos] = [player.x, player.z, player.rotationY, player.visible];
				//replayPos++;
			}
			
		}
		
		public function sprayBloodDeath(x:Number, y:Number, z:Number):void
		{
			var b:Blood;
			var i:int;
			for (i = 1; i <= Utils.randomRange(10, 20); i++)
			{
				b = new Blood();
				b.x = x;
				b.y = y; 
				b.z = z;
				b.velocity.x = Utils.randomRange(0, 20) - 10 + player.velocity.x / 2;
				//b.velocity.y = Utils.randomRange(0, 10);
				b.velocity.z = Utils.randomRange(0, 20) - 10 + player.velocity.y / 2;
				addMoving(b);				
			}
			for (i = 1; i <= Utils.randomRange(60, 100); i++)
			{
				b = new Blood();
				b.x = x;
				b.y = y; 
				b.z = z;
				b.velocity.x = Utils.randomRange(0, 10) - 5;
				//b.velocity.y = Utils.randomRange(0, 10);
				b.velocity.z = Utils.randomRange(0, 10) - 5;
				addMoving(b);				
			}
		}
		
		public function sprayBloodCheckpoint(x:Number, y:Number, z:Number, color:uint = 0xFFAA00):void
		{
			var b:Blood;
			var i:int;
			for (i = 1; i <= Utils.randomRange(5, 10); i++)
			{
				b = new Blood(color);
				b.x = x;
				b.y = y; 
				b.z = z;
				b.velocity.x = Utils.randomRange(0, 20) - 10;
				b.velocity.y = fallingSpeed * 3/4;
				b.velocity.z = Utils.randomRange(0, 20) - 10;
				b.delay = 100;
				addMoving(b);				
			}
		}
		
		private function levelFinished():void
		{
			endingDelay = defaultEndingDelay;
			endingEnabled = true;
			if (Instances.main.saves.data.levelsPassed == currentLevelID - 1)
			{
				Instances.main.saves.data.levelsPassed = currentLevelID;
			}
		}
		
		private function levelEnded():void
		{
			if (currentLevelID == Main.LEVELS_COUNT)
			{
				Instances.main.changeScreen(FinalScreen);
			}
			else
			{
				Instances.gameScreen.showEnding();
			}
			isLevelEnded = true;
		}
		
		private function playerHitCheckpoint(id:uint):void
		{
			if (isPlayerGod)
			{
				return;
			}
			if (Instances.main.soundsMuted == false)
			{
				Instances.main.coinSound.play(0, 0, new SoundTransform(0.5, 0));
			}
			Instances.main.saves.data["lvl" + currentLevelID].checkpoints = int(Instances.main.saves.data["lvl" + currentLevelID].checkpoints) + 1;
			sprayBloodCheckpoint(planes[id].x, planes[id].y, planes[id].z);	
			removePlane(id);
			checkpointsCount ++;
			if (checkpointsCount >= checkpointsNeed)
			{
				checkpointsCount = checkpointsNeed;
				spawnPlanes = false;
				spawnCheckpoints = false;
				levelFinished();
			}
		}
		
		private function playerTakeSpeedup(id:uint):void
		{
			if (isPlayerGod)
			{
				return;
			}			
			sprayBloodCheckpoint(planes[id].x, planes[id].y, planes[id].z, 0x4488FF);	
			removePlane(id);
			fallingSpeed = fallingSpeed * 1.5;
		}
		
		private function playerHitPlane(plane:Plane):void
		{
			if (isPlayerGod)
			{
				return;
			}
			if (endingEnabled)
			{
				return;
			}
			if (Instances.main.soundsMuted == false)
			{
				Instances.main.bamSound.play();
			}
			Instances.main.saves.data["lvl" + currentLevelID].deaths = int(Instances.main.saves.data["lvl" + currentLevelID].deaths) + 1;
			isRecording = false; 
			fallingSpeed = 0;
			isRotationFrozen = true;
			player.alive = false;
			plane.y = player.y - 0.1;
			lastPlane = plane;
			sprayBloodDeath(player.x, player.y - 0.05, player.z);
			Instances.gameScreen.showDead();
			lives --;
			if (lives <= 0)
			{
				Instances.gameScreen.showGameOver();
			}
		}
		
		private function makePlayerGod():void
		{
			isPlayerGod = true;
			respawnGodDelay = respawnGodDelayMax;
			player.startFlashing();
		}
		
	}

}