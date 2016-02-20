package src {
	import flash.display.MovieClip;
	import flash.geom.Point;
	
	public class Zombie extends MovieClip {
		protected var LONG_DETECTION = 10;
		protected var MEDIUM_DETECTION = 7;
		protected var SMALL_DETECTION = 5;
		
		var speed:uint;
		var startHuting:Boolean;
		
		var currentSpeed:Point;
		var gridIndex:Point;
		
		var pathToPlayer:Array;
		var distanceToPlayer:int;
		
		var detectionDistance:int;
		
		public function Zombie() {
			//Night creatures call
			//And the dead start to walk in their masquerade
			//There's no escapin' the jaws of the alien this time (they're open wide)
			//This is the end of your life
			
			startHuting = false;
			currentSpeed = new Point(0,0);
			gridIndex = new Point(0,0);
			
			pathToPlayer = new Array();
		}
		
		public function updateZombie():void {
			updateGridIndex();
			
			if(startHuting) {
				goHunting()
			}
		}
		
		public function updateDistanceToPlayer(gridPath:Object):void {
			if(gridPath.hasOwnProperty(this.gridIndex.x + ',' + this.gridIndex.y)) {
				distanceToPlayer = gridPath[this.gridIndex.x + ',' + this.gridIndex.y]
			}
		}
		
		public function goHunting():void {
			//trace('Brains.......')
			currentSpeed = getCurrentSpeed()
			this.rotation = getRotation()
			
			this.x += currentSpeed.x
			this.y += currentSpeed.y
		}
		
		private function updateGridIndex():void {
			this.gridIndex.x = (int) (this.x / Level.gridBlocksSize);
			this.gridIndex.y = (int) (this.y / Level.gridBlocksSize);
		}
		
		private function getRotation():Number {			
			return Math.atan2(-currentSpeed.x, currentSpeed.y) * 180/Math.PI;
		}
		
		private function getCurrentSpeed():Point {
			var cSpeed = new Point(0,0)
			
			if(pathToPlayer.length > 1) {
				var xPath = pathToPlayer[1].x * Level.gridBlocksSize + Level.gridBlocksSize / 2;
				var yPath = pathToPlayer[1].y * Level.gridBlocksSize + Level.gridBlocksSize / 2;
				
				if(xPath - this.x > 0) {
					cSpeed.x = speed
				} else {
					cSpeed.x = -speed
				}
				
				if ( willPassTarget(xPath, this.x, cSpeed.x) ) {
					cSpeed.x = 0
				}
				
				if(yPath - this.y > 0) {
					cSpeed.y = speed
				} else {
					cSpeed.y = -speed
				}
				
				if ( willPassTarget(yPath, this.y, cSpeed.y) ) {
					cSpeed.y = 0
				}
			}
			
			return cSpeed
		}
		
		private function willPassTarget(targetAxis:int, currentAxis:int, speed:int):Boolean {
			return (targetAxis > currentAxis && targetAxis < currentAxis + speed) || (targetAxis < currentAxis && targetAxis > currentAxis + speed)
		}
	}
	
}
