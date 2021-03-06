﻿package src {
	
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class Main extends MovieClip {
		static var myStage:Stage;
		static var time:int;
		static var sceneName:String;
		static var sceneChange:Boolean;
		static var endGame:Boolean;
		static var loadFinish:Boolean;
		static var playerLastStatus:Player;
		static var currentPlayer:Player;
		
		var scene:Scene;
		
		public function Main() {
			setStage(stage);
		}
		
		public function setStage(newStage:Stage):void {
			myStage = newStage;
			sceneName = "Main Title";
			sceneChange = false;
			loadFinish = true;
			endGame = false;
			
			scene = new MainTitle();
			
			addEventListener(Event.ENTER_FRAME, atualizar);
		}
		
		public function atualizar(e:Event):void
		{
			if(loadFinish) {
				if(sceneChange)
				{
					scene.removeScene();
					changeScene();
					sceneChange = false;
				}
				
				//trace(myStage.mouseX + " y " + myStage.mouseY);
				
				scene.updateScene();
			}
		}
		
		public function changeScene():void {
			if(sceneName == "Main Title") scene = new MainTitle();
			if(sceneName == "Main Menu") scene = new MainMenu();
			if(sceneName == "Level1") scene = new Level1();
			if(sceneName == "Level2") scene = new Level2();
			if(sceneName == "Level3") scene = new Level3();
			if(sceneName == "Level4") scene = new Level4();
			//if(sceneName == "Game Over") scene = new GameOver();
		}
		
		static public function normalizeVector(vector:Point):Point {
			var mag = Math.sqrt(vector.x * vector.x + vector.y * vector.y);
			
			return new Point(vector.x / mag, vector.y / mag);
		}
	}
}
