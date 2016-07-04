package src {
	import flash.geom.Point;
	
	public class Level4 extends Level {
		private var columnWall1:int;
		private var columnWall2:int;
		private var rowWall:int;
		
		public function Level4() {
			super();
			
			//Start Walls
			rowWall = grid.length / 2;
			
			columnWall1 = grid[0].length - 7;
			columnWall2 = grid[0].length - 7;
			
			setUpWalls();
			//End Walls
			
			//Start Zombies
			var zombie = new Zombie2();
			zombie.x = 14 * Level.gridBlocksSize;
			zombie.y = 17 * Level.gridBlocksSize;
			//zombie.routePath.push(new Point(14,17), new Point(15,17), new Point(16,17), new Point(17,17), new Point(18,17), new Point(19,17), new Point(20,17), new Point(21,17), new Point(22,17),
			//					  new Point(23,17), new Point(24,17), new Point(25,17), new Point(26,17), new Point(27,17), new Point(28,17), new Point(29,17), new Point(30,17), new Point(31,17));
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			
			//zombie = new Zombie1();
			//zombie.x = (grid[0].length - 3) * Level.gridBlocksSize;
			//zombie.y = 3 * Level.gridBlocksSize;
			
			//Main.myStage.addChild(zombie);
			//zombieList.push(zombie);
			
			//zombie = new Zombie1();
			//zombie.x = 3 * Level.gridBlocksSize;
			//zombie.y = 6 * Level.gridBlocksSize;
			//zombie.routePath.push(new Point(3,6), new Point(4,6), new Point(5,6), new Point(6,6), new Point(7,6), new Point(8,6), new Point(9,6), new Point(10,6), new Point(11,6), new Point(12,6), new Point(13,6),
			//					  new Point(14,6), new Point(15,6), new Point(16,6), new Point(17,6), new Point(18,6), new Point(19,6), new Point(20,6), new Point(21,6), new Point(22,6), new Point(23,6), new Point(24,6));
			
			//Main.myStage.addChild(zombie);
			//zombieList.push(zombie);
			
			//zombie = new Zombie1();
			//zombie.x = (grid[0].length - 10) * Level.gridBlocksSize;
			//zombie.y = 3 * Level.gridBlocksSize;
			
			//Main.myStage.addChild(zombie);
			//zombieList.push(zombie);
			//End Zombies
			
			//Start Player
			setUpPlayer((grid[0].length - 3) * Level.gridBlocksSize, (grid.length - 6) * Level.gridBlocksSize);
			//End Player
			
			//Start Exit
			setUpExit(4 * Level.gridBlocksSize, 2 * Level.gridBlocksSize);
			//End Exit
			
			createGrid();
			
			currentLevel = "Level4";
			nextLevel = "Level4";
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
					
					if(i == rowWall && j < grid[0].length - 6) {
						grid[i][j] = 1;
						
						if(j == grid[0].length - 8) {
							grid[i + 1][j] = 1;
						}
					}
					
					if(j == columnWall1 && i < 6) {
						grid[i][j] = 1;
					}
					
					if(j == columnWall2 && i > 8 && i < 15) {
						grid[i][j] = 1;
					}
				}
			}
		}
		
		private function setUpWalls():void {
			setUpBordWalls();
			
			var wall = new Wall();
			wall.x = columnWall1 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.y = 90;
			wall.scaleY = 7;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = columnWall2 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.y = 350;
			wall.scaleY = 7;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = 415;
			wall.y = rowWall * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.scaleX = 40;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
		}
	}
}
