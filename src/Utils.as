package  
{
	/**
	 * ...
	 * @author drcra
	 */
	public class Utils 
	{
		// http://stackoverflow.com/questions/1150046/alpha-rgb-argb
		public static var seed:Number = 0;
		
		public static function getPixelAlpha(argb:int):uint
		{
			return (argb>>24)&0xFF;
		}
		
		// http://dev.tutsplus.com/tutorials/quick-tip-get-a-random-number-within-a-specified-range-using-as3--active-3142
		public static function randomRange(minNum:uint, maxNum:uint):Number
		{
			return Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum;
		}		
		
		// Random seed
		public static function randomRangeSeed(min:Number, max:Number):Number
        {
            min -= .4999;
            max += .4999;
            return Math.round(min + ((max - min) * nextDouble()));
        }
		
		private static function nextDouble():Number
        {
            return (gen() / 2147483647);
        }
		
		private static function gen():Number
        {
            return Utils.seed = (Utils.seed * 16807) % 2147483647;
		}
		
		// TODO: Make Random seed code beautiful
	}

}