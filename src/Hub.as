package src {
	
	public class Hub {
		var stamineBar:StamineBar;
		var isStamineEnergyVisible:Boolean;
		
		public function Hub() {
			//Start Stamina Bar
			stamineBar = new StamineBar();
			stamineBar.x = 900; // ??
			stamineBar.y = 50; // ??
			
			isStamineEnergyVisible = true;
			
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
			
			if(Player.staminaNeedsRecharge) {
				if(isStamineEnergyVisible) {
					stamineBar.stamineEnergy.alpha -= 0.1;
				} else {
					stamineBar.stamineEnergy.alpha += 0.1;
				}
				
				if(stamineBar.stamineEnergy.alpha < 0.2) {
					isStamineEnergyVisible = false;
				} else if(!isStamineEnergyVisible && stamineBar.stamineEnergy.alpha >= 1) {
					isStamineEnergyVisible = true;
				}
			} else {
				stamineBar.stamineEnergy.alpha = 1;
			}
		}
	}
}
