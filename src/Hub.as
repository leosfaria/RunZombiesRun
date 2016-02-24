package src {
	
	public class Hub {
		var stamineBar:StamineBar;
		
		public function Hub() {
			//Start Stamina Bar
			stamineBar = new StamineBar();
			stamineBar.x = 900; // ??
			stamineBar.y = 50; // ??
			
			Main.myStage.addChild(stamineBar);
			//End Stamina Bar
		}
		
		public function updateHub():void {
			//Setting everything on hub to front
			Main.myStage.addChild(stamineBar);
			
			updateStamineBar();
		}
		
		public function removeHub():void {
			Main.myStage.removeChild(stamineBar);
		}
		
		private function updateStamineBar():void {
			if(Player.stamina > 0) {
				stamineBar.stamineEnergy.scaleX = Player.stamina/100;
			} else {
				stamineBar.stamineEnergy.scaleX = 0;
			}
			
			stamineBar.stamineEnergy.x = stamineBar.stamineEnergy.width / 2 + 3 - stamineBar.width / 2;
		}
	}
}
