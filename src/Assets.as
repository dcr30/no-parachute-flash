package  
{
	import away3d.events.LoaderEvent;
	import away3d.library.assets.BitmapDataAsset;
	import deng.fzip.FZip;
	import deng.fzip.FZipFile;
	import deng.fzip.FZipLibrary;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author drcra
	 */
	public class Assets extends EventDispatcher
	{
		[Embed (source = "../assets/main.ttf", fontName = "MainFont", 
                mimeType = "application/x-font", 
                fontWeight="normal", 
                fontStyle="normal", 
                //unicodeRange="U+0020-U+007E", 
                advancedAntiAliasing="true", 
                embedAsCFF="false")]
		public static var mainFont:Class;
		/*[Embed (source="../assets/logo.png" )]
		public static var logo:Class;
		
		[Embed (source="../assets/wall.png" )]
		public static var wall:Class;
		
		[Embed (source="../assets/planes/plane1.png" )]
		public static var plane1:Class;
		[Embed (source="../assets/planes/plane2.png" )]
		public static var plane2:Class;
		[Embed (source="../assets/planes/plane3.png" )]
		public static var plane3:Class;
		[Embed (source="../assets/planes/plane4.png" )]
		public static var plane4:Class;
		[Embed (source="../assets/planes/plane5.png" )]
		public static var plane5:Class;
		[Embed (source="../assets/planes/plane6.png" )]
		public static var plane6:Class;
		[Embed (source="../assets/planes/plane7.png" )]
		public static var plane7:Class;
		[Embed (source="../assets/planes/plane8.png" )]
		public static var plane8:Class;
		[Embed (source="../assets/planes/plane9.png" )]
		public static var plane9:Class;
		[Embed (source="../assets/planes/plane10.png" )]
		public static var plane10:Class;
		[Embed (source="../assets/planes/plane11.png" )]
		public static var plane11:Class;
		[Embed (source="../assets/planes/plane12.png" )]
		public static var plane12:Class;
		
		[Embed (source="../assets/player1.png" )]
		public static var player1:Class;		
		[Embed (source="../assets/player2.png" )]
		public static var player2:Class;		*/
		
		// Assets archive
		[Embed(source="../assets.zip",mimeType="application/octet-stream")]
		private static var assetsByteArrayClass:Class;
		
		public var assetsZip:FZip;
		public var assetsZipLib:FZipLibrary;
		
		public function loadAssets():void
		{	
			var assetsByteArray:ByteArray = new assetsByteArrayClass();
			// Setup Zip
			assetsZip = new FZip();
			assetsZip.loadBytes(assetsByteArray);
			// Setup ZipLibrary
			assetsZipLib = new FZipLibrary();
			assetsZipLib.formatAsBitmapData(".png");			
			assetsZipLib.addZip(assetsZip);
			assetsZipLib.addEventListener(Event.COMPLETE, onAssetsLoaded);
			trace("Started loading assets");
		}
		
		private function onAssetsLoaded(e:Event):void
		{
			trace("Finished loading assets: " + assetsZip.getFileCount() + " files");
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		public function getBitmap(name:String):Bitmap
		{
			var bitmapData:BitmapData = assetsZipLib.getBitmapData(name + ".png");
			if (!bitmapData)
			{
				trace("Error loading bitmap '" + name + ".png'");
				return null;
			}
			var bitmap:Bitmap = new Bitmap(bitmapData);
			return bitmap;
		}
		
		public function getSound(name:String):Sound
		{
			var soundFile:FZipFile = assetsZip.getFileByName(name);
			if (!soundFile)
			{
				trace("Error loading sound '" + name + "'");
				return null;
			}
			var sound:Sound = new Sound();
			sound.loadCompressedDataFromByteArray(soundFile.content, soundFile.content.length);
			return sound;
		}
		
		public function getConfig(name:String):Object
		{
			var configFile:FZipFile = assetsZip.getFileByName(name);
			if (!configFile)
			{
				trace("Error loading config '" + name + "' #1");
				return null;
			}
			var configString:String = configFile.getContentAsString();
			if (!configString)
			{
				trace("Error loading config '" + name + "' #2");
				return null;				
			}
			var configObject:Object = JSON.parse(configString);
			if (!configObject)
			{
				trace("Error loading config '" + name + "' #3");
				return null;				
			}
			return configObject;
		}
	}

}