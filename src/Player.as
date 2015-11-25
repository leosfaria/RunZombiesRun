package src {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	public class Player extends MovieClip {
		var keyboardPressed:Array;
		
		var currentSpeed:Point;
		var currentMultiplier:int;
		
		static var speed = 5;
		static var runningMultiplier = 2.25;
		
		public function Player() {
			keyboardPressed = new Array();
						
			Main.myStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownPressed);
			Main.myStage.addEventListener(KeyboardEvent.KEY_UP, keyUpPressed);
		}
		
		public function removePlayer():void {
			Main.myStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownPressed);
			Main.myStage.removeEventListener(KeyboardEvent.KEY_UP, keyUpPressed);
		}
		
		public function updatePlayer():void {
			currentMultiplier = 1;
			currentSpeed = getCurrentSpeed();			
			
			if(keyboardPressed.indexOf(Keyboard.SPACE) >= 0 && !currentSpeed.equals(new Point(0,0))) {
				currentMultiplier = runningMultiplier;
			}
			
			this.x += currentSpeed.x * currentMultiplier;
			this.y += currentSpeed.y * currentMultiplier;
			
			//trace(currentSpeed)
			//trace(currentMultiplier)
		}
		
		public function keyDownPressed(event:KeyboardEvent):void {
			if ((event.keyCode == Keyboard.A || event.keyCode == Keyboard.LEFT) && 
				(keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.LEFT)) {		
				keyboardPressed.push(Keyboard.LEFT);
			} 
			
			if ((event.keyCode == Keyboard.D || event.keyCode == Keyboard.RIGHT) && 
				(keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.RIGHT)){		
				keyboardPressed.push(Keyboard.RIGHT);
			}
			
			if ((event.keyCode == Keyboard.W || event.keyCode == Keyboard.UP) && 
				(keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.UP)){		
				keyboardPressed.push(Keyboard.UP);
			}
			
			if ((event.keyCode == Keyboard.S || event.keyCode == Keyboard.DOWN) &&
				(keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.DOWN)){
				keyboardPressed.push(Keyboard.DOWN);
			}
			
			if (event.keyCode == Keyboard.SPACE && (keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.SPACE)){		
				keyboardPressed.push(Keyboard.SPACE);
			}
		}
		
		public function keyUpPressed(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.A || event.keyCode == Keyboard.LEFT) {
				removeFromKeyboardPressed(Keyboard.LEFT);
			}
			
			if (event.keyCode == Keyboard.D || event.keyCode == Keyboard.RIGHT) {
				removeFromKeyboardPressed(Keyboard.RIGHT);
			}
			
			if (event.keyCode == Keyboard.W || event.keyCode == Keyboard.UP) {
				removeFromKeyboardPressed(Keyboard.UP);
			}
			
			if (event.keyCode == Keyboard.S || event.keyCode == Keyboard.DOWN) {
				removeFromKeyboardPressed(Keyboard.DOWN);
			}
			
			if (event.keyCode == Keyboard.SPACE) {		
				removeFromKeyboardPressed(Keyboard.SPACE);
			}
		}
		
		private function removeFromKeyboardPressed(key:uint):void {
			var index = keyboardPressed.indexOf(key)
				
			if(index >= 0) {
				keyboardPressed.splice(index, 1);
			}
		}
		
		private function getCurrentSpeed():Point {
			var cSpeed = new Point(0,0)
			
			if(keyboardPressed.length > 1) {
				if(keyboardPressed[keyboardPressed.length - 2] == Keyboard.LEFT) {
					cSpeed.x = -speed;
				} else if (keyboardPressed[keyboardPressed.length - 2] == Keyboard.RIGHT) {
					cSpeed.x = speed;
				} else if (keyboardPressed[keyboardPressed.length - 2] == Keyboard.UP) {
					cSpeed.y = -speed;
				} else if (keyboardPressed[keyboardPressed.length - 2] == Keyboard.DOWN) {
					cSpeed.y = speed;
				}
			}
				
			if(keyboardPressed.length > 0) {
				if(keyboardPressed[keyboardPressed.length - 1] == Keyboard.LEFT) {
					cSpeed.x = -speed;
				} else if (keyboardPressed[keyboardPressed.length - 1] == Keyboard.RIGHT) {
					cSpeed.x = speed;
				} else if (keyboardPressed[keyboardPressed.length - 1] == Keyboard.UP) {
					cSpeed.y = -speed;
				} else if (keyboardPressed[keyboardPressed.length - 1] == Keyboard.DOWN) {
					cSpeed.y = speed;
				}
			}
			
			return cSpeed;
		}
	}
}
