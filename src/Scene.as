package src {
	import flash.display.MovieClip;
	
	public class Scene extends MovieClip {

		public function Scene() {
		}

		public function updateScene(): void {	} //To be overrided by childs
		public function removeScene(): void {	} //To be overrided by childs
		
		public function changeScene(sceneName:String):void {
			Main.sceneChange = true;
			Main.sceneName = sceneName;
		}
	}
}
