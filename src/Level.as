package src {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	public class Level extends Scene {
		var floor:Background;
		var player:Player;
		var exit:Exit;
		var wallList:Array;
		var zombieList:Array;
		var nextLevel:String;
		var grid:Array;
		var gridPath:Object;
		var gridKeys:Array;
		var oldPositionPlayer:Point;
		
		public static var gridBlocksSize = 20; 
		
		//Debug vars
		var blocksPathfinding:Array;	
		
		public function Level() {
			//Start Background
			floor = new Background();
			floor.x = Main.myStage.stageWidth / 2;
			floor.y = Main.myStage.stageHeight / 2;
			
			Main.myStage.addChild(floor);
			//End Background
			
			createDefaultGrid();
			
			//Start Walls Array (Children push into array)
			wallList = new Array();
			//End Walls
			
			//Start Zombies Array (Children push into array)
			zombieList = new Array();
			//End Zombies
			
			//Start Debug Vars
			blocksPathfinding = new Array();
			//End Debug Vars
			
			oldPositionPlayer = new Point(0,0);
		}
		
		override public function removeScene():void { 
			//Start Background
			Main.myStage.removeChild(floor);
			//End Background
			
			//Start Player
			player.removePlayer();
			Main.myStage.removeChild(player);
			//End Player
			
			//Start Exit
			Main.myStage.removeChild(exit);
			//End Exit
		}
		
		override public function updateScene():void {
			player.updatePlayer();
			
			//drawGrid();
			
			for (var j = 0; j < zombieList.length ; j++){
				zombieList[j].updateZombie(player);
			}
			
			checkCollision();
			
			if(!oldPositionPlayer.equals(player.gridIndex)) {
				pathfinding();
			}
			
			oldPositionPlayer.copyFrom(player.gridIndex);
		}
		
		public function pathfinding():void {
			gridKeys = new Array();
			
			//for(var j = 0; j < zombieList.length; j++) {
			//	zombiesCoordenates[zombieList[j].gridIndex.x + ',' + zombieList[j].gridIndex.y] = j;
			//}
			
			gridPath = {};
			
			gridKeys.push(new Point(player.gridIndex.x, player.gridIndex.y));
			
			gridPath[gridKeys[0].x + ',' + gridKeys[0].y] = 0;
			
			var newCoordenate:Point;
			var index:String;
			
			for(var i = 0; i < gridKeys.length; i++) {				
				newCoordenate = gridKeys[i];
				index = gridKeys[i].x + ',' + gridKeys[i].y;
				
				calculatePath(newCoordenate.x - 1, newCoordenate.y - 1, gridPath[index]);
				calculatePath(newCoordenate.x + 1, newCoordenate.y - 1, gridPath[index]);
				calculatePath(newCoordenate.x - 1, newCoordenate.y + 1, gridPath[index]);
				calculatePath(newCoordenate.x + 1, newCoordenate.y + 1, gridPath[index]);
				calculatePath(newCoordenate.x, newCoordenate.y - 1, gridPath[index]);
				calculatePath(newCoordenate.x, newCoordenate.y + 1, gridPath[index]);
				calculatePath(newCoordenate.x - 1, newCoordenate.y, gridPath[index]);
				calculatePath(newCoordenate.x + 1, newCoordenate.y, gridPath[index]);
			}
		}
		
		private function calculatePath(xPath:Number, yPath:Number, counter:Number):void {
			if(grid[yPath][xPath] != 1) {
				if(!gridPath.hasOwnProperty(xPath + ',' + yPath)) {
					gridPath[xPath + ',' + yPath] = counter + 1;
					gridKeys.push(new Point(xPath,yPath));
				} else if(gridPath[xPath + ',' + yPath] > counter + 1) {
					gridPath[xPath + ',' + yPath] = counter + 1;
				}
			}
		}
		
		private function calculatePathToPlayer(index:String):void {
			trace(index + ' : ' + gridPath[index]);
		}
		
		public function createDefaultGrid():void {
			grid = new Array();
			
			for (var i = 0; i < Main.myStage.stageHeight/gridBlocksSize; i++) {
				grid[i] = new Array();
				
				for (var j = 0; j < Main.myStage.stageWidth/gridBlocksSize; j++) {
					grid[i][j] = 0;
				}
			}
		}
		
		//Debug Method
		public function printGrid():void {
			for (var i = 0; i < grid.length; i++) {
				var test:String = "";
				
				for (var j = 0; j < grid[i].length; j++) {
					test += grid[i][j] + ",";
				}
				
				trace(test);
			}
		}
		
		//Debug Method
		public function drawGrid():void {
			for(var k = 0; k < blocksPathfinding.length; k++) {
				Main.myStage.removeChild(blocksPathfinding[k]);
			}
			
			blocksPathfinding = new Array();
			
			for (var i = 0; i < grid.length; i++) {
				for (var j = 0; j < grid[i].length; j++) {
					var block:BlockPathfinding = new BlockPathfinding();
					block.x = gridBlocksSize * j + block.width / 2;
					block.y = gridBlocksSize * i + block.height / 2;
					block.alpha = 0.2;
					
					if(grid[i][j] == 1) {
						block.gotoAndStop(2);
					} else if(player.gridIndex.y == i && player.gridIndex.x == j) {
						block.gotoAndStop(4);
					} else {
						for (var l = 0; l < zombieList.length ; l++){
							if(zombieList[l].gridIndex.y == i && zombieList[l].gridIndex.x == j) {
								block.gotoAndStop(5);
							}
						}
					}
					
					blocksPathfinding.push(block);
					Main.myStage.addChild(block);
				}
			}
		}
		
		public function setUpPlayer(x:int, y:int):void {
			player = new Player();
			player.x = x;
			player.y = y;
			
			Main.myStage.addChild(player);
		}
		
		public function setUpExit(x:int, y:int):void {
			exit = new Exit();
			exit.x = x;
			exit.y = y;
			
			Main.myStage.addChild(exit);
		}
		
		//private function indexOfCoordenate(arrayToSearch:Array, string:String) {
		//	var pathString:String = arrayToSearch.join("|");
		//	var indexInString:int = pathString.indexOf(string);
		//	
		//	if(indexInString == -1) return -1;
		//	
		//	var shorterStr:String = pathString.substring(0, indexInString);
        //   return shorterStr.split("|").length - 1;
		//}
		
		private function checkCollision():void {
			for(var i = 0; i < wallList.length; i++) {
				playerCollision(wallList[i])
			}
			
			for(var j = 0; j < zombieList.length; j++) {
				if(player.hitBox.hitTestObject(zombieList[j].hitDetectionArea)) {
					//trace('Ele me viu! O.O')
					zombieList[j].startHuting = true
				}
				
				if(player.hitBox.hitTestObject(zombieList[j].hitBox)) {
					//trace('Morri!')
					
					Main.sceneChange = true
					Main.sceneName = nextLevel
				}
			}
			
			if(player.hitBox.hitTestObject(exit)) {
				Main.sceneChange = true
				Main.sceneName = nextLevel
			}
		}
		
		private function playerCollision(obj:MovieClip):void {
			var stillColliding = false
			
			if(player.hitBox.hitTestObject(obj) && !isPlayerGoingAwayFromCollision(obj)) {
				player.x -= player.currentSpeed.x * player.currentMultiplier
				
				if(player.hitBox.hitTestObject(obj)) {
					player.x += player.currentSpeed.x * player.currentMultiplier
					player.y -= player.currentSpeed.y * player.currentMultiplier
					
					if(player.hitBox.hitTestObject(obj)) {
						player.x -= player.currentSpeed.x * player.currentMultiplier
						
						stillColliding = true
					}
				}
			}
			
			if (stillColliding) {
				playerCollision(obj);
			}
		}
		
		private function isPlayerGoingAwayFromCollision(obj:MovieClip):Boolean {
			var directionX = player.x - obj.x
			var directionY = player.y - obj.y 
			
			if(player.currentSpeed.x > 0 && directionX > 0 || player.currentSpeed.x < 0 && directionX < 0) {
				if(player.currentSpeed.y >= 0 && directionY >= 0 || player.currentSpeed.y <= 0 && directionY <= 0) {
					return true
				}
			}
			
			return false
		}
	}
}
