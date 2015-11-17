package src {
	
	public class MainMenu extends Scene {

		public function MainMenu() {
			this.x = Main.myStage.stageWidth / 2;
			this.y = Main.myStage.stageHeight / 2;
			
			Main.myStage.addChild(this);
		}

		override public function removeScene():void { 
			Main.myStage.removeChild(this);
		}
	}
	
}
