package 
{
	import flash.display.MovieClip;
	import flash.events.*;
	public class Explosion extends MovieClip
	{
		private var _root:Object;
		private var speed:int = 10;
		public function Explosion()
		{
			addEventListener(Event.ADDED, beginClass);
			addEventListener(Event.ENTER_FRAME, eFrame);
		}
		private function beginClass(event:Event):void
		{
			_root = MovieClip(root);
		}
		private function eFrame(event:Event):void
		{
			y -=  speed;
			if (this.y < -1 * this.height)
			{
				removeEventListener(Event.ENTER_FRAME, eFrame);
				_root.explosionContainer.removeChild(this);
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