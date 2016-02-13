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
			
			createGrid();
			drawGrid();
			//printGrid();
			
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
		
		public function createGrid():void {
			for(var i = 0; i < grid.length; i++) {
				for(var j = 0; j < grid[0].length; j++) {
					if(i == 0 || j == 0 || i == grid.length - 1 || j == grid[0].length - 1) {
						grid[i][j] = 1;
					}
					
					if(i == 5 && j < grid[0].length - 15) {
						grid[i][j] = 1;
					}
					
					if(j == grid[0].length - 6 && i >= 5) {
						grid[i][j] = 1;
					}
					
					if(j == grid[0].length - 11 && i <= grid.length - 6) {
						grid[i][j] = 1;
					}
				}
			}
		}
	}
}
