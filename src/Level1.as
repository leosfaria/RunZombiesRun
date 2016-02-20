package src {
	
	public class Level1 extends Level {
		private var columnWall1:int;
		private var columnWall2:int;
		private var rowWall:int;
		
		public function Level1() {
			super();
			
			//Start Walls
			rowWall = 5;
			columnWall1 = grid[0].length - 6;
			columnWall2 = grid[0].length - 11;
			
			setUpWalls();
			//End Walls
			
			//Start Zombies
			var zombie = new Zombie1();
			zombie.x = 200;
			zombie.y = 200;
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			//End Zombies
			
			//Start Player
			setUpPlayer(950,450);
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
					
					if(i == rowWall && j < grid[0].length - 15) {
						grid[i][j] = 1;
					}
					
					if(j == columnWall1 && i >= 5) {
						grid[i][j] = 1;
					}
					
					if(j == columnWall2 && i <= grid.length - 6) {
						grid[i][j] = 1;
					}
				}
			}
		}
		
		private function setUpWalls():void {
			//Start Bord Walls
			var wall = new Wall();
			wall.x = Level.gridBlocksSize / 2;
			wall.y = Main.myStage.stageHeight / 2;
			wall.scaleY = 30;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = (grid[0].length - 1) * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.y = Main.myStage.stageHeight / 2;
			wall.scaleY = 30;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = Main.myStage.stageWidth / 2;
			wall.y = Level.gridBlocksSize / 2;
			wall.scaleX = 50;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = Main.myStage.stageWidth / 2;
			wall.y = (grid.length - 1) * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.scaleX = 50;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			//End Bord Walls
			
			wall = new Wall();
			wall.x = columnWall1 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.y = 380;
			wall.scaleY = 20;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = columnWall2 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.y = 220;
			wall.scaleY = 20;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = 300;
			wall.y = rowWall * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.scaleX = 27;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
		}
	}
}
