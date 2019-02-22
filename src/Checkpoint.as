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
	public class Checkpoint extends ObjectContainer3D
	{
		public var mesh:Mesh;
		public var textureMaterial:TextureMaterial;
		public var width:Number = 100;
		public var height:Number = 100;
		public var type:String = "";
		
		public function Checkpoint(wallSize:Number, lightPicker:StaticLightPicker, type:String="checkpoint") 
		{
			this.type = type;
			// Load and setup texture
			var textureBitmap:Bitmap = Instances.assets.getBitmap(type);
			var bitmapData:BitmapData = textureBitmap.bitmapData;
			textureMaterial =  new TextureMaterial(Cast.bitmapTexture(textureBitmap), false);
			textureMaterial.alphaThreshold = 1;
			textureMaterial.colorTransform = new ColorTransform(0, 0, 0, 1);
			var textureSize:Number = bitmapData.width;
			mesh = new Mesh(new PlaneGeometry(width, height), textureMaterial);
			mesh.x = 0;
			mesh.z = 0;
			addChild(mesh);			
			x = Utils.randomRange(width * 2, wallSize - width * 2);
			y = 0;
			z = Utils.randomRange(height * 2, wallSize - height * 2);
		}
		
	}

}