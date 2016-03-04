package src {
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.ui.Keyboard;
	import flash.events.KeyboardEvent;
	
	public class Level extends Scene {
		var floor:Background;
		var player:Player;
		var exit:Exit;
		var wallList:Array;
		var zombieList:Array;
		var currentLevel:String;
		var nextLevel:String;
		var grid:Array;
		var gridPath:Object;
		var gridKeys:Array;
		var oldPositionPlayer:Point;
		var hub:Hub;
		
		var runZombieCode:String;
		
		public static var gridBlocksSize = 30; 
		
		//Debug vars
		var blocksPathfinding:Array;
		var zombieBlocksToPlayer:Array;
		var zombieRouteBlocks:Array;
		var debug:Boolean;
		
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
			
			//Start Hub
			hub = new Hub();
			//End Hub
			
			//Start Debug
			blocksPathfinding = new Array();
			zombieBlocksToPlayer = new Array();
			zombieRouteBlocks = new Array();
			debug = false;
			//End Debug
			
			gridPath = {};
			oldPositionPlayer = new Point(0,0);
			runZombieCode = "";
			
			Main.myStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownPressed);
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
			
			//Start Hub
			hub.removeHub();
			//End Hub
			
			eraseGrid();
			erasePath();
			eraseRoute();
			
			Main.myStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownPressed);
		}
		
		override public function updateScene():void {
			//Start update player status
			player.updatePlayer();
			//End update player status
			
			//Start update zombies status
			for (var j = 0; j < zombieList.length ; j++){
				zombieList[j].updateZombie();
				zombieList[j].updateDistanceToPlayer(gridPath);
				
				zombieList[j].pathToPlayer = new Array();
				calculatePathToPlayer(zombieList[j].gridIndex.x, zombieList[j].gridIndex.y, zombieList[j].distanceToPlayer, j);
				
				//DEBUG
				if(debug) {
					if(j == 0) {
						erasePath();
						eraseRoute();
					}
					
					drawZombiePath(j);
					drawZombieRoute(j);
					zombieList[j].hitBox.visible = true;
				} else {
					if(zombieList[j].hitBox.visible) {
						erasePath();
						eraseRoute();
						zombieList[j].hitBox.visible = false;
					}
				}
				//DEBUG
			}
			//End update zombies status
			
			//DEBUG
			if(debug) {
				drawGrid();
				player.hitBox.visible = true;
				//printGrid();
			} else if(player.hitBox.visible) {
				player.hitBox.visible = false;
				eraseGrid();
			}
			//DEBUG
			
			checkCollision();
			
			//Calculate pathfinding if necessary
			if(!oldPositionPlayer.equals(player.gridIndex)) {
				//var init = getTimer();
				pathfinding();
				//trace("Time Path Maped em ms: " + (getTimer() - init));
			}
			
			//Save old position of player in grid to reduce the call of pathfinding
			oldPositionPlayer.copyFrom(player.gridIndex);
			
			//Start updating Hub stuff
			hub.updateHub();
			//End updating Hub stuff
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
		
		public function keyDownPressed(event:KeyboardEvent):void {
			//DEBUG
			if (event.keyCode == Keyboard.E) {		
				debug = !debug
			} 
			//DEBUG
			
			runZombieCode += String.fromCharCode(event.charCode);
			
			if(runZombieCode.length > 50) {
				runZombieCode = "";
			}
			
			changeLevelByCode();
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
		public function eraseGrid():void {
			for(var k = 0; k < blocksPathfinding.length; k++) {
				Main.myStage.removeChild(blocksPathfinding[k]);
			}
			
			blocksPathfinding = new Array();
		}
		
		//Debug Method
		public function drawGrid():void {
			eraseGrid();
			
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
		public function erasePath():void {
			for(var j = 0; j < zombieBlocksToPlayer.length; j++) {
				Main.myStage.removeChild(zombieBlocksToPlayer[j]);
			}
			
			zombieBlocksToPlayer = new Array();
		}
		
		//Debug Method
		public function drawZombiePath(zombieIndex:int):void {
			var zombie = zombieList[zombieIndex];
			
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
		
		//Debug Method
		public function eraseRoute():void {
			for(var j = 0; j < zombieRouteBlocks.length; j++) {
				Main.myStage.removeChild(zombieRouteBlocks[j]);
			}
			
			zombieRouteBlocks = new Array();
		}
		
		//Debug Method
		public function drawZombieRoute(zombieIndex:int):void {
			var zombie = zombieList[zombieIndex];
			
			for(var i = 0; i < zombie.routePath.length; i++) {
				var block:BlockPathfinding = new BlockPathfinding();
				block.x = gridBlocksSize * zombie.routePath[i].x + block.width / 2;
				block.y = gridBlocksSize * zombie.routePath[i].y + block.height / 2;
				block.alpha = 0.6;
				block.gotoAndStop(6);
				
				zombieRouteBlocks.push(block);
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
				if(zombieList[j].distanceToPlayer != 0 && zombieList[j].distanceToPlayer <= zombieList[j].detectionDistance) {
					//trace('Ele me viu! O.O')
					zombieList[j].startHuting = true
				}
				
				if(player.hitBox.hitTestObject(zombieList[j].hitBox)) {
					//trace('Morri!')
					
					Main.sceneChange = true;
					Main.sceneName = currentLevel;
				}
			}
			
			if(player.hitBox.hitTestObject(exit)) {
				Main.sceneChange = true;
				Main.sceneName = nextLevel;
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
			var cornerUpperLeft:Point = new Point(obj.x - obj.width/2, obj.y - obj.height / 2);
			var cornerUpperRight:Point = new Point(obj.x + obj.width/2, obj.y - obj.height / 2);
			var cornerBottonLeft:Point = new Point(obj.x - obj.width/2, obj.y + obj.height / 2);
			var cornerBottonRight:Point = new Point(obj.x + obj.width/2, obj.y + obj.height / 2);
			
			if(player.x <= cornerUpperLeft.x && player.currentSpeed.x < 0) {
				return true;
			}
			if(player.x >= cornerUpperRight.x && player.currentSpeed.x > 0) {
				return true;
			}
			if(player.y <= cornerUpperLeft.y && player.currentSpeed.y < 0) {
				return true;
			}
			if(player.y >= cornerBottonLeft.y && player.currentSpeed.y > 0) {
				return true;
			}			
			
			return false
		}
		
		private function changeLevelByCode():void {
			if(runZombieCode.toLowerCase().indexOf("walking dead") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level1";
			} else if(runZombieCode.toLowerCase().indexOf("dawn of the dead") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level2";
			} else if(runZombieCode.toLowerCase().indexOf("night of the living dead") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level3";
			} else if(runZombieCode.toLowerCase().indexOf("world war z") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level4";
			} else if(runZombieCode.toLowerCase().indexOf("zumbiland") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level5";
			} else if(runZombieCode.toLowerCase().indexOf("i am legend") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level6";
			} else if(runZombieCode.toLowerCase().indexOf("resident evil") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level7";
			} else if(runZombieCode.toLowerCase().indexOf("the return of the living dead") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level8";
			} else if(runZombieCode.toLowerCase().indexOf("house of the dead") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level9";
			} else if(runZombieCode.toLowerCase().indexOf("dead rising") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level10";
			} else if(runZombieCode.toLowerCase().indexOf("28 days later") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level11";
			} else if(runZombieCode.toLowerCase().indexOf("quarantine") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level12";
			} else if(runZombieCode.toLowerCase().indexOf("survival of the dead") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level13";
			} else if(runZombieCode.toLowerCase().indexOf("warm bodies") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level14";
			} else if(runZombieCode.toLowerCase().indexOf("z nation") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level15";
			} else if(runZombieCode.toLowerCase().indexOf("infectuz") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level16";
			} else if(runZombieCode.toLowerCase().indexOf("planet terror") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level17";
			} else if(runZombieCode.toLowerCase().indexOf("beatlejuice") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level18";
			} else if(runZombieCode.toLowerCase().indexOf("paranorman") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level19";
			} else if(runZombieCode.toLowerCase().indexOf("corpse bride") >=0) {
				Main.sceneChange = true;
				Main.sceneName = "Level20";
			}
		}
		
		protected function setUpBordWalls():void {
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
		}
	}
}
