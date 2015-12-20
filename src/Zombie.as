package src {
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Zombie extends MovieClip {
		var speed:uint;
		var startHuting:Boolean;
		
		var currentSpeed:Point;
		
		public function Zombie() {
			//Night creatures call
			//And the dead start to walk in their masquerade
			//There's no escapin' the jaws of the alien this time (they're open wide)
			//This is the end of your life
			
			startHuting = false
			currentSpeed = new Point(0,0)
		}
		
		public function updateZombie(player:Player):void {
			if(startHuting) {
				goHunting(player)
			}
		}
		
		public function goHunting(player:Player):void {
			//trace('Brains.......')
			this.rotation = getRotation(player)
			currentSpeed = getCurrentSpeed(player)
			
			this.x += currentSpeed.x
			this.y += currentSpeed.y
		}
		
		private function getRotation(player:Player):Number {			
			return Math.atan2(this.x - player.x, player.y - this.y) * 180/Math.PI;
		}
		
		private function getCurrentSpeed(player:Player):Point {
			var cSpeed = new Point(0,0)
			
			if(player.x - this.x > 0) {
				cSpeed.x = speed
			} else {
				cSpeed.x = -speed
			}
			
			if(player.y - this.y > 0) {
				cSpeed.y = speed
			} else {
				cSpeed.y = -speed
			}
			
			return cSpeed
		}
	}
	
}
