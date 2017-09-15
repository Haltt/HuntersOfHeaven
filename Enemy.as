package 
{
	//IMPORTAÇÃO DAS BIBLIOTECAS
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;

	//CLASS QUE TRANSFORMA OS INIMIGOS EM MOVIECLIP
	public class Enemy extends MovieClip
	{
		//VARIABLES
		private var _root:Object;//REFERÊNCIA DO DOCUMENTO
		private var speed:int = 7;//VELOCIDADE DO INIMIGO
		private var lf:int = 0;//LIFE (PORCENTAGEM ATUAL)
		private var transSoundEnemy:SoundTransform = new SoundTransform();
		private var canalEnemy:SoundChannel = new SoundChannel();

		//ESTA FUNÇÃO SERÁ REALIZADA TODAS AS VEZES QUE UMA BALA FOR ATIRADA
		public function Enemy()
		{
			addEventListener(Event.ADDED, beginClass);
			addEventListener(Event.ENTER_FRAME, eFrame);//FUNÇÃO REALIZADA QUANDO SE ENTRA NO FRAME
		}
		private function beginClass(event:Event):void
		{
			_root = MovieClip(root);
		}
		private function eFrame(event:Event):void
		{
			var reqEnemy:URLRequest = new URLRequest("Audio/Explosion.mp3");//CAMINHO DO AUDIO DA EXPLOSÃO
			var sEnemy:Sound = new Sound(reqEnemy);			

			//MOVIMENTO DO TIRO NA TELA
			//x += Math.random() * speed;
			x +=  int(Math.random() * 3);
			y +=  speed;

			//REMOVE O TIRO CASO SAIA DO PALCO(STAGE)
			if (this.y > stage.stageHeight)
			{
				removeEventListener(Event.ENTER_FRAME, eFrame);
				_root.removeChild(this);
			}

			//checking if it is touching any bullets
			//we will have to run a for loop because there will be multiple bullets
			for (var i:int = 0; i<_root.bulletContainer.numChildren; i++)
			{
				//numChildren É A QUANTIDADE DE MOVIECLIP'S DENTRO DE bulletContainer.
				//VARIÁVEL QUE DEFINE QUE TIRO ESTAMOS TESTANDO ATUALMENTE
				var bulletTarget:MovieClip = _root.bulletContainer.getChildAt(i);

				//TESTE DE TIRO
				if (hitTestObject(bulletTarget))
				{
					//EXPLOSÃO DO INIMIGO QUANDO O TIRO ACERTA
					this.gotoAndStop("Explosion");
					//CHAMA A ANIMAÇÃO DA EXPLOSÃO;
					canalEnemy = sEnemy.play();//INICIA O AUDIO
					transSoundEnemy.volume = _root.efeitosSonoros;//VOLUME DA EXPLOSÃO
					canalEnemy.soundTransform = transSoundEnemy;
			
					removeEventListener(Event.ENTER_FRAME, eFrame);//REMOVE O ALVO QUE FOI ATINGIDO PELO TIRO DO FRAME
					//_root.removeChild(this); //REMOVE O TIRO

					//REMOVE O TIRO DOS OUVINTES
					_root.bulletContainer.removeChild(bulletTarget);
					bulletTarget.removeListeners();				
					
					_root.score +=  100;//SCORE APOS DESTRUIR UM INIMIGO
					_root.scoreEnemy++;
				}
			}

			//TESTE DE EXPLOSAO (ESPECIAL)
			for (i = 0; i<_root.explosionContainer.numChildren; i++)
			{
				var explosionTarget:MovieClip = _root.explosionContainer.getChildAt(i);
				if (hitTestObject(explosionTarget))
				{
					_root.forcaExplosion--;
					this.gotoAndStop("Explosion");
					canalEnemy = sEnemy.play();
					transSoundEnemy.volume = _root.efeitosSonoros;//VOLUME DA EXPLOSÃO
					canalEnemy.soundTransform = transSoundEnemy;
			
					removeEventListener(Event.ENTER_FRAME, eFrame);
					if (_root.forcaExplosion == 0)
					{
						_root.explosionContainer.removeChild(explosionTarget);
						explosionTarget.removeListeners();
					}
					_root.score +=  150;
				}
			}

			//TESTA QUANDO A NAVE ACERTA UM INIMIGO
			if (hitTestObject(_root.Nave))
			//if(this.hitTestPoint(_root.Nave.x + 100, _root.Nave.y, false))
			{
				removeEventListener(Event.ENTER_FRAME, eFrame);

				this.gotoAndStop("Explosion");
				var reqNaveExplosion:URLRequest = new URLRequest("Audio/ExplosionNave.mp3");
				var sNaveExplosion:Sound = new Sound(reqNaveExplosion);
				canalEnemy = sNaveExplosion.play();
				transSoundEnemy.volume = _root.efeitosSonoros;//VOLUME DA EXPLOSÃO
				canalEnemy.soundTransform = transSoundEnemy;

				_root.tipoDoTiro = 0;//RETORNA O TIPO DE TIRO PARA O PADRÃO
				//RETORNA A NAVE E O HUD PARA POSIÇÃO INICIAL
				_root.Nave.x = stage.stageWidth / 2 - 50;
				_root.Nave.y = 623.95;
				_root.HUD.x = stage.stageWidth / 2 - 50;
				_root.HUD.y = 623.95;
				_root.NaveAvatar[_root.Avatar].gotoAndStop("dano");

				//CONTROLE DO LIFE(VIDA);
				_root.life -=  20;
				_root.life = _root.life;
				_root.HUD.txtLifePorc.text = String(_root.life) + "%";//ATUALIZAD O LIFE NA TELA

				//FIM DO JOGO
				if (_root.life <= 0)
				{
					_root.gameOver = true;
					_root.gotoAndStop('lose');
				}
			}

			//QUANDO O INIMIGO ENCOSTA NA PARTE DE BAIXO (PASSA PELA NAVE)
			if (hitTestObject(_root.LayoutBarra))
			{
				if (_root.score > 0)
				{
					removeEventListener(Event.ENTER_FRAME, eFrame);
					this.parent.removeChild(this);
					_root.score -=  10;//RETIRA PONTO DO JOGADOR COMO PENALIDADE
					_root.score = _root.score;//NOVO SCORE
				}
			}
			
			if(_root.lifeBoss <= 0)
			{
				this.removeEventListener(Event.ENTER_FRAME, eFrame);
				this.parent.removeChild(this);
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
			this.removeEventListener(Event.ENTER_FRAME, eFrame);
		}
	}
}