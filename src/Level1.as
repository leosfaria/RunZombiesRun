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
			
			//Start Zombies
			var zombie = new Zombie1();
			zombie.x = 200;
			zombie.y = 200;
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			//End Zombies
			
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
			for (var i = 0; i < wallList.length ; i++){
				Main.myStage.removeChild(wallList[i]);
			}
			//End Walls
			
			//Start Zombies
			for (var j = 0; j < zombieList.length ; j++){
				Main.myStage.removeChild(zombieList[j]);
			}
			//End Zombies
		}
	}
}
