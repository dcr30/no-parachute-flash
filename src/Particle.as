package  
{
	import away3d.materials.ColorMaterial;
	/**
	 * ...
	 * @author ...
	 */
	public class Particle extends MovingObject
	{
		
		public function Particle(color:uint) 
		{
			super(20, 20);
			material = new ColorMaterial(color, 1);
		}
		
	}

}