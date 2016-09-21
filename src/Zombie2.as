package src {
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.events.TimerEvent;
	
	public class Zombie2 extends Zombie {

		private var player:Player;
		private var timer:Timer;
		private var jump:Boolean;
		
		protected var JUMP_DISTANCE:int;
		protected var jumpSpeed:int;
		protected var isReadyToJump:Boolean;
		
		
		public function Zombie2(player:Player) {
			super();
			
			this.player = player;
			this.speed = 4
			this.jumpSpeed = this.speed * 4
			this.detectionDistance = MEDIUM_DETECTION;
			this.JUMP_DISTANCE = this.detectionDistance - 3;
			this.isReadyToJump = false;
			this.jump = false;
			
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, timerCount);
		}
		
		override public function removeZombie():void {
			timer.removeEventListener(TimerEvent.TIMER, timerCount);
		}

		override public function updateZombie():void {
			if(this.distanceToPlayer <= JUMP_DISTANCE && this.distanceToPlayer != 0 && !isReadyToJump) {
				isReadyToJump = true;
				timer.start();
			} 
			
			if(isReadyToJump) {
				jumpAction();
			} else {
				super.updateZombie();
			}
		}
		
		private function timerCount(e:TimerEvent):void {
			jump = true;
			timer.stop();
		}
		
		private function jumpAction():void {
			if(!jump) {
				setRotation();
			} else {
				trace("JUMP!!");
			}
		}
		
		private function setRotation():void {
			var playerVector:Point = new Point(player.x - this.x, player.y - this.y);
			
			this.rotation = Math.atan2(playerVector.x, -playerVector.y) * 180/Math.PI;
		}
	}
	
}
