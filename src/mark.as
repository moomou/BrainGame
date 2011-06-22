﻿package
{
	//need to make a font and linkage for actionscript
	import flash.display.*;
	import flash.events.*;
	import flash.media.Sound;
	import flash.text.*;
	import flash.utils.*;
			
	public class mark extends Sprite
	{
		// animation
		private static var count:uint=0;
		
		static const animSteps:int = 100;
		static const startScale:Number = 0;
		static const endScale:Number = 2.0;		
		
		private var bSprite:Sprite;
		private var parentMC:MovieClip;
		private var temp:MovieClip;
		private var animTimer:Timer;
		private var soundToPlay:Sound;
		private var animStepTime:int;
					
		public function mark(mc:MovieClip,pt:MovieClip,x:Number,y:Number,time:int):void
		{
			if (count>1)
				return;
				
			temp=pt;
			
			bSprite=new Sprite();
			bSprite.x=x;
			bSprite.y=y;
			bSprite.alpha=0;
			bSprite.scaleX=startScale;
			bSprite.scaleY=startScale;
			
			bSprite.addChild(temp);
			parentMC=mc;
			parentMC.addChild(bSprite);
			parentMC.setChildIndex(bSprite,parentMC.numChildren-1);
			
			animTimer=new Timer(animStepTime,animSteps);
			animTimer.addEventListener(TimerEvent.TIMER,animation);
			animTimer.addEventListener(TimerEvent.TIMER_COMPLETE,remove);
			animTimer.start();	
			
			increaseCount();
						
			if (pt is right)
				SoundEffect.playMark(SoundEffect.RIGHT);
			else
				SoundEffect.playMark(SoundEffect.WRONG);				
		}
		private function animation(event:TimerEvent):void
		{
			var percentDone:Number=event.target.currentCount/animSteps;
			
			bSprite.scaleX = (1.0-percentDone)*startScale + percentDone*endScale;
			bSprite.scaleY = (1.0-percentDone)*startScale + percentDone*endScale;
			bSprite.alpha = 1.0-percentDone;			
		}
		private function remove(event:Event):void
		{
			bSprite.removeChild(temp);
			parentMC.removeChild(bSprite);
			bSprite=null;
			parentMC=null;
			delete this;
			
			setCountToZero();	
		}
		private static function increaseCount()
		{
			count++;
		}
		private static function setCountToZero()
		{
			count=0;
		}
	}
}