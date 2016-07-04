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
		
		var routePath:Array;
		var pathToPlayer:Array;
		var distanceToPlayer:int;
		
		var detectionDistance:int;
		var nextRoutePointIndex:int;
		var routeAsc:Boolean;
		
		public function Zombie() {
			//Night creatures call
			//And the dead start to walk in their masquerade
			//There's no escapin' the jaws of the alien this time (they're open wide)
			//This is the end of your life
			
			startHuting = false;
			currentSpeed = new Point(0,0);
			gridIndex = new Point(0,0);
			
			routePath = new Array();
			pathToPlayer = new Array();
			
			nextRoutePointIndex = 1;
			routeAsc = true;
		}
		
		public function updateZombie():void {
			updateGridIndex();
			
			if(startHuting) {
				walk(pathToPlayer, 1);			//Next point é sempre 1 porque a medida que o zumbi anda, o path vai reduzindo através do update do zumbi, então 1 é sempre o próximo ponto
			} else if(routePath.length > 1) {
				walk(routePath, nextRoutePointIndex);	//Neste caso não pois a rota é constante
				updateRouteIndex();
			}
			
			setAnimation();
		}
		
		public function updateDistanceToPlayer(gridPath:Object):void {
			if(gridPath.hasOwnProperty(this.gridIndex.x + ',' + this.gridIndex.y)) {
				distanceToPlayer = gridPath[this.gridIndex.x + ',' + this.gridIndex.y]
			} else { //Caso minha posição não exista na grid "dentro da parede" minha distancia será a menor distancia dos quadrados adjacentes + 1
				distanceToPlayer = findCloserDistance(gridPath);
			}
		}
		
		private function findCloserDistance(gridPath:Object):int {
			var array = [gridPath[(this.gridIndex.x - 1) + ',' + this.gridIndex.y],
							gridPath[this.gridIndex.x + ',' + (this.gridIndex.y - 1)],
							gridPath[(this.gridIndex.x + 1) + ',' + this.gridIndex.y],
							gridPath[this.gridIndex.x + ',' + (this.gridIndex.y + 1)],
							gridPath[(this.gridIndex.x - 1) + ',' + (this.gridIndex.y - 1)],
							gridPath[(this.gridIndex.x - 1) + ',' + (this.gridIndex.y + 1)],
							gridPath[(this.gridIndex.x + 1) + ',' + (this.gridIndex.y - 1)],
							gridPath[(this.gridIndex.x + 1) + ',' + (this.gridIndex.y + 1)]]
			
			var minValue = 99999;
			
			for(var i = 0; i < array.length; i++) {
				if(array[i] >= 1 && array[i] < minValue) {
					minValue = array[i];
				}
			}
			
			return minValue + 1;
		}
		
		public function walk(path:Array, nextPointIndex:int):void {
			currentSpeed = getCurrentSpeed(path, nextPointIndex)
			this.rotation = getRotation()
			
			this.x += currentSpeed.x
			this.y += currentSpeed.y
		}
		
		private function setAnimation():void {			
			if(this.currentSpeed.x == 0 && this.currentSpeed.y == 0) {
				gotoAndStop('idle');
			} else {
				gotoAndStop('walk');
			}
		}
		
		private function updateGridIndex():void {
			this.gridIndex.x = (int) (this.x / Level.gridBlocksSize);
			this.gridIndex.y = (int) (this.y / Level.gridBlocksSize);
		}
		
		private function getRotation():Number {			
			return Math.atan2(currentSpeed.x, -currentSpeed.y) * 180/Math.PI;
		}
		
		private function getCurrentSpeed(path:Array, nextPointIndex:int):Point {
			var cSpeed = new Point(0,0)
			
			if(path.length > 1) {
				var xPath = path[nextPointIndex].x * Level.gridBlocksSize + Level.gridBlocksSize / 2;
				var yPath = path[nextPointIndex].y * Level.gridBlocksSize + Level.gridBlocksSize / 2;
				
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
		
		private function updateRouteIndex():void {
			//Se eu cheguei no próximo ponto atualiza o indice do próximo ponto
			if(this.gridIndex.x == routePath[nextRoutePointIndex].x && this.gridIndex.y == routePath[nextRoutePointIndex].y) {
				if(routePath.length - 1 == nextRoutePointIndex) {
					routeAsc = false;
				} else if (nextRoutePointIndex == 0) {
					routeAsc = true;
				}
				
				if(routeAsc) {
					nextRoutePointIndex++;
				} else {
					nextRoutePointIndex--;
				}
			}			
		}
	}
	
}
