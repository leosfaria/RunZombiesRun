﻿package src {
	
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
			zombie.x = 9 * Level.gridBlocksSize;
			zombie.y = 13 * Level.gridBlocksSize;
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			
			zombie = new Zombie1();
			zombie.x = 21 * Level.gridBlocksSize;
			zombie.y = 3 * Level.gridBlocksSize;
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			//End Zombies
			
			//Start Player
			setUpPlayer((grid[0].length - 3) * Level.gridBlocksSize, (grid.length - 3) * Level.gridBlocksSize);
			//End Player
			
			//Start Exit
			setUpExit(100,70);
			//End Exit
			
			createGrid();
			
			currentLevel = "Level1";
			nextLevel = "Level2";
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
			setUpBordWalls();
			
			var wall = new Wall();
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
