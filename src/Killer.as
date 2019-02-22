package  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.ColorTransform;
	/**
	 * ...
	 * @author ...
	 */
	public class Killer extends ObjectContainer3D
	{
		private var animationDelay:uint = 0;
		private var currentFrame:uint = 0;
		private var animationFrames:Array;
		private var mesh:Mesh;
		public var textureMaterial:TextureMaterial;
		
		public function Killer(lightPicker:StaticLightPicker, type:String, width:Number, height:Number, framesCount:uint = 1) 
		{
			animationFrames = [];
			// Load and setup texture
			for (var i:uint = 0; i < framesCount; i++)
			{
				var textureBitmap:Bitmap = Instances.assets.getBitmap(type + String(i + 1));
				var bitmapData:BitmapData = textureBitmap.bitmapData;
				animationFrames[i] =  new TextureMaterial(Cast.bitmapTexture(textureBitmap), false);
				animationFrames[i].lightPicker = lightPicker;
				animationFrames[i].alphaThreshold = 1;
				//animationFrames[i].colorTransform = new ColorTransform(0, 0, 0, 1);
			}
			
			trace(animationFrames.length);

			mesh = new Mesh(new PlaneGeometry(width, height), animationFrames[0]);
			//plane.x = wallSize / 2;
			//	plane.y = 0;
			//plane.z = wallSize / 2;
			addChild(mesh);		
			textureMaterial = TextureMaterial(mesh.material);
		}
		
		public function update():void
		{
			this.y -= 60;
			animationDelay++;
			if (animationDelay >= 15)
			{
				animationDelay = 0;
				currentFrame++;
				if (currentFrame > animationFrames.length)
				{
					currentFrame = 0;
				}
				mesh.material = animationFrames[currentFrame];
			}
		}
		
	}

}