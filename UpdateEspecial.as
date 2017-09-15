package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	import flash.net.URLRequest;
	
	public class UpdateEspecial extends MovieClip
	{
		private var _root:Object;
		private var speed:int = 8;
		private var numEspecial:int = 2;
		public function UpdateEspecial()
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
			y += speed;
			//gotoAndStop(_root.tipoDoEspecial + 2);			
			if(this.y > stage.stageHeight)
			{
				removeEventListener(Event.ENTER_FRAME, eFrame);
				_root.removeChild(this);
			}

			if(hitTestObject(_root.Nave))
			{
				removeEventListener(Event.ENTER_FRAME, eFrame);
				this.parent.removeChild(this);
				if(_root.quantExplosion < numEspecial)
				{
					_root.quantExplosion++;
					_root.PersonagemEscolhido.txt_especial.text = String(_root.quantExplosion);
				}			
			}
			
			//TELA DE GAME OVER(FIM DO JOGO)
			if (_root.gameOver)
			{
				this.removeEventListener(Event.ENTER_FRAME, eFrame);				
				this.parent.removeChild(this);			
				
				_root.Nave.removeEventListener(Event.ENTER_FRAME, _root.moveChar);
			}
		}
		public function removeListeners():void{
			this.removeEventListener(Event.ENTER_FRAME, eFrame);
		}
	}
}