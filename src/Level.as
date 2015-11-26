package src {
	
	public class Level extends Scene {
		var floor:Background;
		var player:Player;
		var wallList:Array;
		
		public function Level() {
			//Start Background
			floor = new Background();
			floor.x = Main.myStage.stageWidth / 2;
			floor.y = Main.myStage.stageHeight / 2;
			
			Main.myStage.addChild(floor);
			//End Background
			
			//Start Walls Array (Children push into array)
			wallList = new Array();
			//End Walls
		}
		
		override public function removeScene():void { 
			//Start Background
			Main.myStage.removeChild(floor);
			//End Background
			
			//Start Player
			player.removePlayer();
			Main.myStage.removeChild(player);
			//End Player
		}
		
		override public function updateScene():void {
			player.updatePlayer();
			collision();
		}
		
		public function setUpPlayer(x:int, y:int):void {
			player = new Player();
			player.x = x;
			player.y = y;
			
			Main.myStage.addChild(player);
		}
		
		private function collision():void {
			for(var i = 0; i < wallList.length; i++) {
				if(player.hitTestObject(wallList[i])) {
					player.x -= player.currentSpeed.x * player.currentMultiplier
					
					if(player.hitTestObject(wallList[i])) {
						player.x += player.currentSpeed.x * player.currentMultiplier
						player.y -= player.currentSpeed.y * player.currentMultiplier
						
						if(player.hitTestObject(wallList[i])) {
							player.x -= player.currentSpeed.x * player.currentMultiplier
						}
					}
				}
			}
		}
	}
}
