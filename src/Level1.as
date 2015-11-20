package src {
	
	public class Level1 extends Level {
		var wallList:Array;
		
		public function Level1() {
			super();
			
			//Start Walls
			wallList = new Array();
			
			var wall = new Wall();
			wall.x = Main.myStage.stageWidth / 2;
			wall.y = Main.myStage.stageHeight / 2;
			
			Main.myStage.addChild(wall);
			wallList.push(wall);
			//End Walls
		}
		
		override public function removeScene():void { 
			super.removeScene();
			
			//Start Walls
			for (var i = 0; i < 1 ; i++){
				Main.myStage.removeChild(wallList[i]);
			}
			//End Walls
		}
	}
}
