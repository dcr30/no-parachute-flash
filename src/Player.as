package
{
	import away3d.materials.TextureMaterial;
	import away3d.primitives.data.NURBSVertex;
	import away3d.utils.Cast;
	import flash.geom.ColorTransform;
	
	/**
	 * ...
	 * @author drcra
	 */
	public class Player extends MovingObject
	{
		public var alive:Boolean;
		
		private const delay:uint = 5;
		private var curDelay:uint = 0;
		private var animationFrames:Array;
		private var currentFrame:int;
		
		private var speed:Number = 0.6;
		private const friction:Number = 0.98;
		public var px, pz:Number;
		public var realRotation:Number = 0;
		private var moveRotation:Number = 0;
		
		public var isFlashing:Boolean = false;
		private var flashingDelay:Number = 0;
		private var flashingDelayMax:Number = 5;
		
		public function Player(r:Number = 0.2, g:Number = 0.4, b:Number = 1)
		{
			super(100, 100);
			px = 0;
			pz = 0;
			alive = true;
			
			var playerColor:ColorTransform = new ColorTransform(r, g, b, 1);
			
			animationFrames = [];
			animationFrames[0] = new TextureMaterial(Cast.bitmapTexture(Instances.assets.getBitmap("player1")), false);
			animationFrames[0].alphaThreshold = 255;
			animationFrames[0].colorTransform = playerColor;
			animationFrames[1] = new TextureMaterial(Cast.bitmapTexture(Instances.assets.getBitmap("player2")), false);
			animationFrames[1].alphaThreshold = 255;
			animationFrames[1].colorTransform = playerColor;
			//showBounds = true;
			currentFrame = 0;
			material = animationFrames[0];
		
		}
		
		public function startFlashing():void
		{
			flashingDelay = flashingDelayMax;
			isFlashing = true;
		}
		
		public function stopFlashing():void
		{
			isFlashing = false;
			visible = true;
		}
		
		private function updateInput():void
		{
			// horizontal
			if (Input.isDown(Input.LEFT) || Input.isDown(Input.LEFT_ALTERNATIVE))
			{
				//velocity.x -= speed * Math.cos(-realRotation / 180 * Math.PI);
				//velocity.z -= speed * Math.sin(-realRotation / 180 * Math.PI);
				moveRotation -= speed * 2;
			}
			else if (Input.isDown(Input.RIGHT) || Input.isDown(Input.RIGHT_ALTERNATIVE))
			{
				//velocity.x += speed * Math.cos(-realRotation / 180 * Math.PI);
				//velocity.z += speed * Math.sin(-realRotation / 180 * Math.PI);
				moveRotation += speed * 2;
			}
			moveRotation *= friction;
			velocity.x *= friction;
			// vertical
			if (Input.isDown(Input.DOWN) || Input.isDown(Input.DOWN_ALTERNATIVE))
			{
				//velocity.x -= speed * Math.sin(realRotation / 180 * Math.PI);
				//velocity.z -= speed * Math.cos(realRotation / 180 * Math.PI);
			}
			else if (Input.isDown(Input.UP) || Input.isDown(Input.UP_ALTERNATIVE))
			{
				//velocity.x += speed * Math.sin(realRotation / 180 * Math.PI);
				//velocity.z += speed * Math.cos(realRotation / 180 * Math.PI);
			}
			velocity.z *= friction;
		}
		
		override public function update():void
		{
			if (alive)
			{
				curDelay++;
				if (curDelay >= delay)
				{
					curDelay = 0;
					currentFrame++;
					if (currentFrame >= animationFrames.length)
					{
						currentFrame = 0;
					}
					material = animationFrames[currentFrame];
				}
				updateInput();
				rotationY = realRotation + moveRotation;
				super.update();
				
				if (isFlashing)
				{
					flashingDelay--;
					if (flashingDelay <= 0)
					{
						flashingDelay = flashingDelayMax;
						visible = !visible;
					}
				}
			}
		}
	
	}

}