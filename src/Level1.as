package src {
	
	public class Level1 extends Level {
		
		public function Level1() {
			super();
			
			//Start Walls			
			var wall = new Wall();
			wall.x = 800;
			wall.y = 450;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			//End Walls
			
			//Start Player
			setUpPlayer(910,450);
			//End Player
			
			//Start Exit
			setUpExit(100,70);
			//End Exit
			
			nextLevel = "Level1"
		}
		
		override public function removeScene():void { 
			super.removeScene();
			
			//Start Walls
			for (var i = 0; i < 1 ; i++){
				Main.myStage.removeChild(wallList[i]);
			}
			//End Walls
		}
	}
}
