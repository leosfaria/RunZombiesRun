package src {
	import flash.geom.Point;
	
	public class Level3 extends Level {
		private var columnWall1:int;
		private var columnWall2:int;
		private var rowWall1:int;
		private var rowWall2:int;
		private var rowWall3:int;
		
		public function Level3() {
			super();
			
			//Start Walls
			rowWall1 = grid.length - 5;
			rowWall2 = 7;
			rowWall3 = 7;
			columnWall1 = grid[0].length - 8;
			columnWall2 = 11;
			
			setUpWalls();
			//End Walls
			
			//Start Zombies
			var zombie = new Zombie1();
			zombie.x = 14 * Level.gridBlocksSize;
			zombie.y = 17 * Level.gridBlocksSize;
			zombie.routePath.push(new Point(14,17), new Point(15,17), new Point(16,17), new Point(17,17), new Point(18,17), new Point(19,17), new Point(20,17), new Point(21,17), new Point(22,17),
								  new Point(23,17), new Point(24,17), new Point(25,17), new Point(26,17), new Point(27,17), new Point(28,17), new Point(29,17), new Point(30,17), new Point(31,17));
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			
			zombie = new Zombie1();
			zombie.x = (grid[0].length - 3) * Level.gridBlocksSize;
			zombie.y = 3 * Level.gridBlocksSize;
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			
			zombie = new Zombie1();
			zombie.x = 3 * Level.gridBlocksSize;
			zombie.y = 6 * Level.gridBlocksSize;
			zombie.routePath.push(new Point(3,6), new Point(4,6), new Point(5,6), new Point(6,6), new Point(7,6), new Point(8,6), new Point(9,6), new Point(10,6), new Point(11,6), new Point(12,6), new Point(13,6),
								  new Point(14,6), new Point(15,6), new Point(16,6), new Point(17,6), new Point(18,6), new Point(19,6), new Point(20,6), new Point(21,6), new Point(22,6), new Point(23,6), new Point(24,6));
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			
			zombie = new Zombie1();
			zombie.x = (grid[0].length - 10) * Level.gridBlocksSize;
			zombie.y = 3 * Level.gridBlocksSize;
			
			Main.myStage.addChild(zombie);
			zombieList.push(zombie);
			//End Zombies
			
			//Start Player
			setUpPlayer((grid[0].length - 3) * Level.gridBlocksSize, (grid.length - 6) * Level.gridBlocksSize);
			//End Player
			
			//Start Exit
			setUpExit(6 * Level.gridBlocksSize,(grid.length - 2) * Level.gridBlocksSize);
			//End Exit
			
			createGrid();
			
			currentLevel = "Level3";
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
					
					if(i == rowWall1 && j > grid[0].length - 20 && j < grid[0].length - 5) {
						grid[i][j] = 1;
					}
					
					if(i == rowWall2 && j >= 10 && j <= 22) {
						grid[i][j] = 1;
					}
					
					if(i == rowWall3 && j <= 7) {
						grid[i][j] = 1;
					}
					
					if(j == columnWall1 && i <= 8) {
						grid[i][j] = 1;
					}
					
					if(j == columnWall2 && i >= 8) {
						grid[i][j] = 1;
					}
				}
			}
		}
		
		private function setUpWalls():void {
			setUpBordWalls();
			
			var wall = new Wall();
			wall.x = columnWall1 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.y = 115;
			wall.scaleY = 12;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = columnWall2 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.y = 400;
			wall.scaleY = 17;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = 660;
			wall.y = rowWall1 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.scaleX = 17;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = 495;
			wall.y = rowWall2 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.scaleX = 16;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			
			wall = new Wall();
			wall.x = 105;
			wall.y = rowWall3 * Level.gridBlocksSize + Level.gridBlocksSize / 2;
			wall.scaleX = 10;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
		}
	}	
}
