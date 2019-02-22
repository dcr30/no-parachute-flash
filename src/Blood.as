package  
{
	import away3d.materials.ColorMaterial;
	/**
	 * ...
	 * @author drcra
	 */
	public class Blood extends MovingObject
	{
		public var delay:uint = 1000;
		
		public function Blood(color:uint = 0xFF0000) 
		{
			super(20, 20);
			if (color == 0xFF0000)
			{
				switch (Utils.randomRange(1, 3))
				{
					case 1:
						color = 0xAA0000;
						break;
					case 2:
						color = 0xCC0000;
						break;
					case 3:
						color = 0xFF0000;
						break;
				}
			}
			material = new ColorMaterial(color, 1);
		}
		
		override public function update():void
		{
			super.update();
			velocity.scaleBy(0.9);
			velocity.y *= 1.1;
		}
		
	}

}