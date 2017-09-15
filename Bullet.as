//This is the basic skeleton that all classes must have
package{
	//we have to import certain display objects and events
	import flash.display.MovieClip;
	import flash.events.*;
	//this just means that Bullet will act like a MovieClip
	public class Bullet extends MovieClip{
		//VARIABLES
		//this will act as the root of the document
		//so we can easily reference it within the class
		private var _root:Object;
		//how quickly the bullet will move
		private var speed:int = 40;
		//this function will run every time the Bullet is added
		//to the stage
		public function Bullet(){
			//adding events to this class
			//functions that will run only when the MC is added
			addEventListener(Event.ADDED, beginClass);
			//functions that will run on enter frame
			addEventListener(Event.ENTER_FRAME, eFrame);
		}
		private function beginClass(event:Event):void{
			_root = MovieClip(root);
		}
		private function eFrame(event:Event):void{
			//moving the bullet up screen
			y -= speed;
			//making the bullet be removed if it goes off stage
			if(this.y < -1 * this.height){
				removeEventListener(Event.ENTER_FRAME, eFrame);
				_root.bulletContainer.removeChild(this);
			}
			
			//TELA DE GAME OVER(FIM DO JOGO)
			if (_root.gameOver)
			{
				this.removeEventListener(Event.ENTER_FRAME, eFrame);				
				this.parent.removeChild(this);			
				
				_root.Nave.removeEventListener(Event.ENTER_FRAME, _root.moveChar);
			}
		}
		public function removeListeners():void
		{
			removeEventListener(Event.ENTER_FRAME, eFrame);
		}
	}
}