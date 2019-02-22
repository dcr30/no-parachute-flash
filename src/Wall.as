package  
{
	import away3d.containers.ObjectContainer3D;
	import away3d.entities.Mesh;
	import away3d.materials.lightpickers.StaticLightPicker;
	import away3d.materials.TextureMaterial;
	import away3d.primitives.PlaneGeometry;
	import away3d.utils.Cast;
	/**
	 * ...
	 * @author drcra
	 */
	public class Wall extends ObjectContainer3D
	{
		
		public function Wall(wallSize:Number, lightPicker:StaticLightPicker, levelID:uint) 
		{
			super();
			var wallTexture:TextureMaterial =  new TextureMaterial(Cast.bitmapTexture(Instances.assets.getBitmap("levels/"+levelID+"/walls/1")), false);
			wallTexture.lightPicker = lightPicker;
			var wall:Mesh = new Mesh(new PlaneGeometry(wallSize, wallSize), wallTexture);
			wall.x = wallSize / 2;
			wall.rotationX = 90;
			addChild(wall);
			wall = new Mesh(new PlaneGeometry(wallSize, wallSize), wallTexture);
			wall.x = wallSize / 2;
			wall.z = wallSize;
			wall.rotationX = 90;
			wall.rotationY = 180;
			addChild(wall);
			wall = new Mesh(new PlaneGeometry(wallSize, wallSize), wallTexture);
			wall.x = 0;
			wall.z = wallSize / 2;
			wall.rotationX = 90;
			wall.rotationY = 90;
			addChild(wall);
			wall = new Mesh(new PlaneGeometry(wallSize, wallSize), wallTexture);
			wall.x = wallSize;
			wall.z = wallSize / 2;
			wall.rotationX = 90;
			wall.rotationY = 270;
			addChild(wall);		
		}
		
	}

}