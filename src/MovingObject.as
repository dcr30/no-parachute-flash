package  
{
	import away3d.entities.Mesh;
	import away3d.primitives.PlaneGeometry;
	import flash.geom.Vector3D;
	/**
	 * ...
	 * @author drcra
	 */
	public class MovingObject extends Mesh
	{
		public var pos:Vector3D;
		public var velocity:Vector3D;
		public var width:Number;
		public var height:Number;
		
		public function MovingObject(width:Number, height:Number)
		{
			super(new PlaneGeometry(width, height), null);
			velocity = new Vector3D();
			this.width = width;
			this.height = height;
		}
		
		public function update():void
		{
			x += velocity.x;
			y += velocity.y;
			z += velocity.z;
		}
		
	}

}