package src {
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Level extends Scene {
		var floor:Background;
		var player:Player;
		var exit:Exit;
		var wallList:Array;
		var zombieList:Array;
		var nextLevel:String;
		
		public function Level() {
			//Start Background
			floor = new Background();
			floor.x = Main.myStage.stageWidth / 2;
			floor.y = Main.myStage.stageHeight / 2;
			
			Main.myStage.addChild(floor);
			//End Background
			
			//Start Walls Array (Children push into array)
			wallList = new Array();
			//End Walls
			
			//Start Zombies Array (Children push into array)
			zombieList = new Array();
			//End Zombies
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
				zombieList[j].updateZombie(player);
			}
			
			checkCollision();
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
