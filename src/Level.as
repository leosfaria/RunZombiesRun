package src {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
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
		
		public static var gridBlocksSize = 30; 
		
		//Debug vars
		var blocksPathfinding:Array;
		var zombieBlocksToPlayer:Array;
		
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
			zombieBlocksToPlayer = new Array();
			//End Debug Vars
			
			gridPath = {};
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
			
			for (var j = 0; j < zombieList.length ; j++){
				zombieList[j].updateZombie();
				zombieList[j].updateDistanceToPlayer(gridPath);
				
				zombieList[j].pathToPlayer = new Array();
				calculatePathToPlayer(zombieList[j].gridIndex.x, zombieList[j].gridIndex.y, zombieList[j].distanceToPlayer, j);
				drawZombiePath(j);
			}
			
			checkCollision();
			
			if(!oldPositionPlayer.equals(player.gridIndex)) {
				//var init = getTimer();
				pathfinding();
				//trace("Time Path Maped em ms: " + (getTimer() - init));
			}
			
			oldPositionPlayer.copyFrom(player.gridIndex);
		}
		
		public function pathfinding():void {
			gridKeys = new Array();
			
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
		
		private function calculatePathToPlayer(xPath:int, yPath:int, oldDistance:int, zombieIndex:int):void {
			var distance;
			
			if(gridPath.hasOwnProperty(xPath + ',' + yPath)) {
				distance = gridPath[xPath + ',' + yPath];
			} else {
				distance = oldDistance;
			}
			
			zombieList[zombieIndex].pathToPlayer.push(new Point(xPath, yPath));
			
			if(distance != 0) {
				if ( isNewIndexCloserThanMe((xPath - 1) + ',' + yPath, distance) ){
					calculatePathToPlayer(xPath - 1, yPath, distance, zombieIndex);
				} else if ( isNewIndexCloserThanMe((xPath + 1) + ',' + yPath, distance) ){
					calculatePathToPlayer(xPath + 1, yPath, distance, zombieIndex);	   
				} else if ( isNewIndexCloserThanMe(xPath + ',' + (yPath - 1), distance) ){
					calculatePathToPlayer(xPath, yPath - 1, distance, zombieIndex);   
				} else if ( isNewIndexCloserThanMe(xPath + ',' + (yPath + 1), distance) ){
					calculatePathToPlayer(xPath, yPath + 1, distance, zombieIndex);
				} else if ( isNewIndexCloserThanMe((xPath + 1) + ',' + (yPath + 1), distance) ){
					calculatePathToPlayer(xPath + 1, yPath + 1, distance, zombieIndex);
				} else if ( isNewIndexCloserThanMe((xPath + 1) + ',' + (yPath - 1), distance) ){
					calculatePathToPlayer(xPath + 1, yPath - 1, distance, zombieIndex);
				} else if ( isNewIndexCloserThanMe((xPath - 1) + ',' + (yPath + 1), distance) ){
					calculatePathToPlayer(xPath - 1, yPath + 1, distance, zombieIndex);
				} else if ( isNewIndexCloserThanMe((xPath - 1) + ',' + (yPath - 1), distance) ){
					calculatePathToPlayer(xPath - 1, yPath - 1, distance, zombieIndex);
				}
			}
		}
		
		private function isNewIndexCloserThanMe(newIndex:String, meDistance:int):Boolean {
			return gridPath.hasOwnProperty(newIndex) && gridPath[newIndex] < meDistance
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
		
		//Debug Method
		public function drawZombiePath(zombieIndex:int):void {
			var zombie = zombieList[zombieIndex];
			
			for(var j = 0; j < zombieBlocksToPlayer.length; j++) {
				Main.myStage.removeChild(zombieBlocksToPlayer[j]);
			}
			
			zombieBlocksToPlayer = new Array();
			
			for(var i = 0; i < zombie.pathToPlayer.length; i++) {
				var block:BlockPathfinding = new BlockPathfinding();
				block.x = gridBlocksSize * zombie.pathToPlayer[i].x + block.width / 2;
				block.y = gridBlocksSize * zombie.pathToPlayer[i].y + block.height / 2;
				block.alpha = 0.6;
				block.gotoAndStop(3);
				
				if(i == 0) {
					block.gotoAndStop(4);
				} else if (i == zombie.pathToPlayer.length - 1) {
					block.gotoAndStop(5);
				}
				
				zombieBlocksToPlayer.push(block);
				Main.myStage.addChild(block);
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
