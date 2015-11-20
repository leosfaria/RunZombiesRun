package src {
	import flash.events.MouseEvent;
	
	public class MainMenu extends Scene {
		var menuBackground:MainMenuBackground;
		var startButton:PlayButton;
		
		public function MainMenu() {
			//Start Menu Background
			menuBackground = new MainMenuBackground();
			menuBackground.x = Main.myStage.stageWidth / 2;
			menuBackground.y = Main.myStage.stageHeight / 2;
			
			Main.myStage.addChild(menuBackground);
			//Start Menu Background
			
			//Start Play Button
			startButton = new PlayButton();
			startButton.x = Main.myStage.stageWidth / 2;
			startButton.y = Main.myStage.stageHeight / 2;
			
			startButton.addEventListener(MouseEvent.CLICK, startGame);
			Main.myStage.addChild(startButton);
			//End Play Button
		}

		override public function removeScene():void { 
			//Start Menu Background
			Main.myStage.removeChild(menuBackground);
			//End Menu Background
			
			//Start Play Button
			startButton.removeEventListener(MouseEvent.CLICK, startGame);
			Main.myStage.removeChild(startButton);
			//End Play Button
		}
		
		function startGame(event:MouseEvent): void {
		   Main.sceneChange = true;
		   Main.sceneName = "Level1";
		}
	}
	
}
