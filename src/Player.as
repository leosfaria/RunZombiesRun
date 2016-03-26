package src {
	import flash.display.MovieClip;
	import flash.events.KeyboardEvent;
	import flash.utils.Timer;
	import flash.ui.Keyboard;
	import flash.geom.Point;
	import flash.geom.ColorTransform;
	
	public class Player extends MovieClip {
		var keyboardPressed:Array;
		
		var lastMovingCurrentSpeed:Point;
		var currentSpeed:Point;
		var currentMultiplier:int;
		var hairNumber:int;
		var colorTrans:ColorTransform;
		
		var gridIndex:Point;
		
		static var speed = 5;
		static var runningMultiplier = 2.25;
		static var stamina:Number;
		static var maxStamina:int = 100;
		static var staminaDownPSec:int = 30;
		static var staminaRestorePSec:int = 15;
		static var staminaNeedsRecharge:Boolean = false;
		
		public function Player() {
			keyboardPressed = new Array();
			
			lastMovingCurrentSpeed = new Point(0,0);
			gridIndex = new Point(0,0);
			stamina = maxStamina;
			
			generateNewPlayer();
			
			Main.myStage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownPressed);
			Main.myStage.addEventListener(KeyboardEvent.KEY_UP, keyUpPressed);
		}
		
		private function generateNewPlayer():void {
			var oldhair:int = 0;
			
			this.hairNumber = ((Math.random() * 1000) % 6) + 1;
			this.colorTrans = new ColorTransform();
			this.colorTrans.color = PlayerTShirtColor.getRandomColor();
			
			if(Main.lastPlayer != null) {
				if(this.hairNumber == Main.lastPlayer.hairNumber) {
					if(this.hairNumber == 6) {
						this.hairNumber = 0;
					} else {
						this.hairNumber++;
					}
				}
				
				this.colorTrans.color = PlayerTShirtColor.getRandomColor(Main.lastPlayer.colorTrans.color);
			}
		}
		
		public function removePlayer():void {
			Main.lastPlayer = this;
			
			Main.myStage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownPressed);
			Main.myStage.removeEventListener(KeyboardEvent.KEY_UP, keyUpPressed);
		}
		
		public function updatePlayer():void {
			currentMultiplier = 1;
			currentSpeed = getCurrentSpeed();
			rotation = getRotation();
			updateGridIndex();
			
			if(!staminaNeedsRecharge && keyboardPressed.indexOf(Keyboard.SPACE) >= 0 && !currentSpeed.equals(new Point(0,0))) {
				currentMultiplier = runningMultiplier;
				stamina -= staminaDownPSec/Main.myStage.frameRate;
			} else if(stamina < maxStamina || staminaNeedsRecharge){
				stamina += staminaRestorePSec/Main.myStage.frameRate;
			}
			
			if(stamina >= maxStamina) {
				stamina = maxStamina;
				staminaNeedsRecharge = false;
			} else if (stamina <= 0) {
				stamina = 0;
				staminaNeedsRecharge = true;
			}
			
			setAnimation();
			
			this.x += currentSpeed.x * currentMultiplier;
			this.y += currentSpeed.y * currentMultiplier;
		}
		
		public function keyDownPressed(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.A && (keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.LEFT)) {		
				keyboardPressed.push(Keyboard.LEFT);
			} 
			
			if (event.keyCode == Keyboard.D && (keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.RIGHT)){		
				keyboardPressed.push(Keyboard.RIGHT);
			}
			
			if (event.keyCode == Keyboard.W && (keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.UP)){		
				keyboardPressed.push(Keyboard.UP);
			}
			
			if (event.keyCode == Keyboard.S && (keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.DOWN)){
				keyboardPressed.push(Keyboard.DOWN);
			}
			
			if (event.keyCode == Keyboard.SPACE && (keyboardPressed.length == 0 || keyboardPressed[keyboardPressed.length - 1] != Keyboard.SPACE)){		
				keyboardPressed.push(Keyboard.SPACE);
			}
		}
		
		public function keyUpPressed(event:KeyboardEvent):void {
			if (event.keyCode == Keyboard.A) {
				removeFromKeyboardPressed(Keyboard.LEFT);
			}
			
			if (event.keyCode == Keyboard.D) {
				removeFromKeyboardPressed(Keyboard.RIGHT);
			}
			
			if (event.keyCode == Keyboard.W) {
				removeFromKeyboardPressed(Keyboard.UP);
			}
			
			if (event.keyCode == Keyboard.S) {
				removeFromKeyboardPressed(Keyboard.DOWN);
			}
			
			if (event.keyCode == Keyboard.SPACE) {		
				removeFromKeyboardPressed(Keyboard.SPACE);
			}
		}
		
		private function updateGridIndex():void {
			this.gridIndex.x = (int) (this.x / Level.gridBlocksSize);
			this.gridIndex.y = (int) (this.y / Level.gridBlocksSize);
		}
		
		private function setAnimation():void {
			if(currentSpeed.x == 0 && currentSpeed.y == 0) {
				gotoAndStop('idle');
			} else if(currentMultiplier == 1) {
				gotoAndStop('walk');
			} else {
				gotoAndStop('run');
			}
			
			this.movieClip.head.gotoAndStop(hairNumber);
			this.movieClip.randomColor.transform.colorTransform = colorTrans;
		}
		
		private function getRotation():Number {			
			return Math.atan2(lastMovingCurrentSpeed.x,-lastMovingCurrentSpeed.y) * 180/Math.PI;
		}
		
		private function removeFromKeyboardPressed(key:uint):void {
			var index = keyboardPressed.indexOf(key)
				
			if(index >= 0) {
				keyboardPressed.splice(index, 1);
			}
		}
		
		private function getCurrentSpeed():Point {
			var cSpeed = new Point(0,0)
			var lastMoveKey = -1
			var previousMoveKey = -1
			
			for(var i = keyboardPressed.length - 1; i >= 0; i--) {
				if(previousMoveKey != -1) break;
				
				if(keyboardPressed[i] != Keyboard.SPACE) {
					if(lastMoveKey == -1) {
						lastMoveKey = keyboardPressed[i]
					} else {
						previousMoveKey = keyboardPressed[i]
					}
				}
			}
			
			if(previousMoveKey != -1) {
				if(previousMoveKey == Keyboard.LEFT) {
					cSpeed.x = -speed;
				} else if (previousMoveKey == Keyboard.RIGHT) {
					cSpeed.x = speed;
				} else if (previousMoveKey == Keyboard.UP) {
					cSpeed.y = -speed;
				} else if (previousMoveKey == Keyboard.DOWN) {
					cSpeed.y = speed;
				}
			}
				
			if(lastMoveKey != -1) {
				if(lastMoveKey == Keyboard.LEFT) {
					cSpeed.x = -speed;
				} else if (lastMoveKey == Keyboard.RIGHT) {
					cSpeed.x = speed;
				} else if (lastMoveKey == Keyboard.UP) {
					cSpeed.y = -speed;
				} else if (lastMoveKey == Keyboard.DOWN) {
					cSpeed.y = speed;
				}
			}
			
			if(cSpeed.x != 0 && cSpeed.y != 0) {
				cSpeed.x = Math.abs(Math.cos(45)) * cSpeed.x
				cSpeed.y = Math.abs(Math.sin(45)) * cSpeed.y
			}
			
			if(cSpeed.x != 0 || cSpeed.y != 0) {
				lastMovingCurrentSpeed.x = cSpeed.x
				lastMovingCurrentSpeed.y = cSpeed.y
			}
			
			return cSpeed;
		}
	}
}
