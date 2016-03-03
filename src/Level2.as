package src  {
	
	public class Level2 extends Level {
		private var columnWall:int;
		private var rowWall1:int;
		private var rowWall2:int;
		
		public function Level2() {
			super();
			
			//Start Walls
			rowWall1 = grid.length - grid.length / 2;
			rowWall2 = grid.length - 5;
			columnWall = grid[0].length - 13;
			
			setUpWalls();
			//End Walls
			
			//Start Zombies
			var zombie = new Zombie1();
			zombie.x = 16 * Level.gridBlocksSize;
			zombie.y = 17 * Level.gridBlocksSize;
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			
			zombie = new Zombie1();
			zombie.x = 29 * Level.gridBlocksSize;
			zombie.y = 12 * Level.gridBlocksSize;
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			
			zombie = new Zombie1();
			zombie.x = 10 * Level.gridBlocksSize;
			zombie.y = 5 * Level.gridBlocksSize;
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			//End Zombies
			
			//Start Player
			setUpPlayer((grid[0].length - 7) * Level.gridBlocksSize, 3 * Level.gridBlocksSize);
			//End Player
			
			//Start Exit
			setUpExit(130,60);
			//End Exit
			
			createGrid();
			
			currentLevel = "Level2";
			nextLevel = "Level3";
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
					
					if(i == rowWall1 && j > grid[0].length - 11) {
						grid[i][j] = 1;
					}
					
					if(i == rowWall2 && j >= 5 && j <= 17) {
						grid[i][j] = 1;
					}
					
					if(j == columnWall && i <= grid.length - 6) {
						grid[i][j] = 1;
					}
				}
			}
		}
		
		private function setUpWalls():void {
			setUpBordWalls();
			
			var wall = new Wall();
			wall.x = columnWall * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.y = 220;
			wall.scaleY = 20;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = 900;
			wall.y = rowWall1 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.scaleX = 15;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = 345;
			wall.y = rowWall2 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.scaleX = 17;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
		}
	}
}
