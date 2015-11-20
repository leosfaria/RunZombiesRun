package src {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	
	public class Player extends MovieClip {
		var speed:int;
		var currentSpeed:Point;
		
		public function Player() {
			speed = 5;	//pixels / update
			currentSpeed = new Point(0,0);
			
			Main.myStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownPressed);
			Main.myStage.addEventListener(KeyboardEvent.KEY_UP, keyUpPressed);
		}
		
		public function removePlayer():void {
			Main.myStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownPressed);
			Main.myStage.removeEventListener(KeyboardEvent.KEY_UP, keyUpPressed);
		}
		
		public function updatePlayer():void {
			this.x += currentSpeed.x;
			this.y += currentSpeed.y;
		}
		
		public function keyDownPressed(event:KeyboardEvent):void {
			trace(currentSpeed)
			if (event.keyCode == Keyboard.A || event.keyCode == Keyboard.LEFT) {		
				currentSpeed.x = -speed
			} 
			else if (event.keyCode == Keyboard.D || event.keyCode == Keyboard.RIGHT) {		
				currentSpeed.x = speed
			}
			else if (event.keyCode == Keyboard.W || event.keyCode == Keyboard.UP) {		
				currentSpeed.y = -speed
			}
			else if (event.keyCode == Keyboard.S || event.keyCode == Keyboard.DOWN) {		
				currentSpeed.y = speed
			}
		}
		
		public function keyUpPressed(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.A || event.keyCode == Keyboard.LEFT || 
				event.keyCode == Keyboard.D || event.keyCode == Keyboard.RIGHT) {		
				currentSpeed.x = 0
			} 
			else if (event.keyCode == Keyboard.W || event.keyCode == Keyboard.UP ||
					 event.keyCode == Keyboard.S || event.keyCode == Keyboard.DOWN) {		
				currentSpeed.y = 0
			}
		}
	}
}
