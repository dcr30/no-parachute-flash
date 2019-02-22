package  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import away3d.utils.Cast;
	import flash.geom.ColorTransform;
	import flash.geom.Rectangle;
	/**
	 * ...
	 * @author drcra
	 */
	public class Plane extends ObjectContainer3D
	{
		public var textureMaterial:TextureMaterial;
		public var textureSize:int;
		private var bitmapData:BitmapData;
		
		public function Plane(wallSize:Number, lightPicker:StaticLightPicker, levelID:uint, maxPlaneID:uint, type:String = "planes") 
		{
			// Load and setup texture
			var textureBitmap:Bitmap = Instances.assets.getBitmap("levels/" + levelID + "/" + type + "/" + Utils.randomRangeSeed(1, maxPlaneID).toString());
			bitmapData = textureBitmap.bitmapData;
			textureMaterial =  new TextureMaterial(Cast.bitmapTexture(textureBitmap), false);
			textureMaterial.lightPicker = lightPicker;
			textureMaterial.alphaThreshold = 1;
			textureMaterial.colorTransform = new ColorTransform(0, 0, 0, 1);
			textureSize = bitmapData.width;

			var plane:Mesh = new Mesh(new PlaneGeometry(wallSize, wallSize), textureMaterial);
			plane.x = wallSize / 2;
			plane.y = 0;
			plane.z = wallSize / 2;
			addChild(plane);
		}
		
		public function canCollide(x:int, y:int):Boolean
		{
			return Utils.getPixelAlpha(bitmapData.getPixel32(x, y)) > 0;
		}
		
	}

}