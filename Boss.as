package
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	public class Boss extends MovieClip
	{
		private var _root:Object;
		private var speed:int = 5;
		private var transSoundEnemy:SoundTransform = new SoundTransform();
		private var canalEnemy:SoundChannel = new SoundChannel();
		public function Boss()
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
			_root.HUDBoss.visible = true;
			_root.BossLife.visible = true;
			_root.BossLife.scaleX = _root.lifeBoss / (300 + (_root.NivelForca[_root.nivelEscolhido] * _root.FaseAtual));
			
			if(this.y > stage.stageHeight)
			{
				removeEventListener(Event.ENTER_FRAME, eFrame);
			}
			for(var i:int = 0;i<_root.bulletContainer.numChildren;i++)
			{
				var bulletTarget:MovieClip = _root.bulletContainer.getChildAt(i);				
				if(BossAHit.hitTestObject(bulletTarget))
				{
					_root.bulletContainer.removeChild(bulletTarget);
					bulletTarget.removeListeners();					
					
					if(_root.tipoDoTiro == 0) { _root.lifeBoss--; }
					else if(_root.tipoDoTiro == 1) { _root.lifeBoss -= 2; }
					else if(_root.tipoDoTiro == 2) { _root.lifeBoss -= 4; }
					
					if(_root.lifeBoss <= 0)
					{
						this.gotoAndStop("Explosion");
						removeEventListener(Event.ENTER_FRAME, eFrame);
					}
				}
			}
			
			for (i = 0; i<_root.explosionContainer.numChildren; i++)
			{
				var explosionTarget:MovieClip = _root.explosionContainer.getChildAt(i);
				if (hitTestObject(explosionTarget))
				{					
					_root.lifeBoss--;
					if(_root.lifeBoss <= 0)
					{
						this.gotoAndStop("Explosion");
						removeEventListener(Event.ENTER_FRAME, eFrame);
					}
				}
			}
			
			if(_root.gameOver)
			{
				this.removeEventListener(Event.ENTER_FRAME, eFrame);
				this.parent.removeChild(this);
			}
		}
		public function removeListeners():void{
			this.removeEventListener(Event.ENTER_FRAME, eFrame);
		}
	}
}