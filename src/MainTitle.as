package src {
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	public class MainTitle extends Scene {
		var timer:Timer = new Timer(1000);
		
		public function MainTitle() {
			this.x = Main.myStage.stageWidth / 2;
			this.y = Main.myStage.stageHeight / 2;
			
			Main.myStage.addChild(this);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, pressMouseButtonDown);
			
			Main.time = 0;
			
			timer.addEventListener(TimerEvent.TIMER, timerCount);
			timer.start();
		}
		
		public function pressMouseButtonDown(e:MouseEvent):void {
			changeScene("Main Menu");
		}
		
		private function timerCount(e:TimerEvent):void {
			Main.time++;
			
			if(Main.time >= 3)
				changeScene("Main Menu");
		}
		
		override public function removeScene():void { 
			this.removeEventListener(MouseEvent.MOUSE_DOWN, pressMouseButtonDown);
			timer.removeEventListener(TimerEvent.TIMER, timerCount);
			Main.myStage.removeChild(this);
		}
	}
}
