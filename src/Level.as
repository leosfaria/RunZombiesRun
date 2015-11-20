package src {
	
	public class Level extends Scene {
		var floor:Background;
		var player:Player;
		
		public function Level() {
			//Start Background
			floor = new Background();
			floor.x = Main.myStage.stageWidth / 2;
			floor.y = Main.myStage.stageHeight / 2;
			
			Main.myStage.addChild(floor);
			//End Background
			
			//Start Player
			setUpPlayer(700,600);
			//End Player
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
		}
		
		public function setUpPlayer(x:int, y:int):void {
			player = new Player();
			player.x = x;
			player.y = y;
			
			Main.myStage.addChild(player);
		}
	}
}
