package src {
	
	public final class PlayerTShirtColor {

		public static const WHITE:uint = 0xFFFFFF;
		public static const BLACK:uint = 0x000000;
		public static const GREY:uint = 0x999999;
		public static const RED:uint = 0xFF0000;
		public static const GREEN:uint = 0x009900;
		public static const BLUE:uint = 0x000066;
		public static const LIGHTBLUE:uint = 0x6666FF;
		public static const YELLOW:uint = 0xFFFF33;
		public static const ORANGE:uint = 0xFF6600;
		public static const SALMON:uint = 0xFF6666;
		
		private static var colorArray:Array = [PlayerTShirtColor.WHITE, 
										   PlayerTShirtColor.BLACK, 
										   PlayerTShirtColor.GREY,
										   PlayerTShirtColor.RED,
										   PlayerTShirtColor.GREEN,
										   PlayerTShirtColor.BLUE,
										   PlayerTShirtColor.LIGHTBLUE,
										   PlayerTShirtColor.YELLOW,
										   PlayerTShirtColor.ORANGE,
										   PlayerTShirtColor.SALMON];
		
		public static function getRandomColor(lastColor:int = -1):uint {
			var index:int = (Math.random() * 1000) % colorArray.length
			
			if(lastColor != -1 && colorArray[index] == lastColor) {
				if(index == colorArray.length - 1) {
					return colorArray[0]
				}
				
				index = index + 1;
			}
			return colorArray[index]
		}
	}
	
}
