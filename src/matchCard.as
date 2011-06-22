package
{
	import caurina.transitions.*;
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.utils.*;
	
	public class matchCard extends MovieClip
	{
		//totalFrame=13 + 1 for back cover
		public static var imageIndex:uint=2; //to generate different pictures each time;	
		
		private static const timeToFlipCardBack:Number=1.0;
		private static const timeToFlipCard:Number=1.0;
		public static const BACK_FACE:uint=1;	
		
		public var removed:Boolean;
		public var added:Boolean;
		public var faceFrame:uint;
		public var index:uint;		
		
		private var flipping:Boolean;
			
		public function matchCard() //card face represents the frame to jump to
		{
			this.mouseChildren=false;
			this.buttonMode=true;
			
			removed=false;
			added=false;
		}
		public function flip (animate:Boolean)
		{
			if (animate)
			{
				Tweener.addCaller(this,{onUpdate:changeCardFace,time:timeToFlipCard/2,count:1});
				Tweener.addTween(this,{scaleX:-1,time:timeToFlipCard,transition:"linear"});
			}
			else
			{
				this.scaleX=-1;
				changeCardFace();
			}
		}
		public function flipBack(animate:Boolean)
		{
			if (animate)
			{
				Tweener.addCaller(this,{onUpdate:changeCardFace,time:timeToFlipCardBack/2,count:1});
				Tweener.addTween(this,{scaleX:1,time:timeToFlipCardBack,transition:"linear"});
			}	
			else
			{
				this.scaleX=1;
				changeCardFace();
			}
		}
		private function changeCardFace()
		{
			if (this.currentFrame==BACK_FACE)
				this.gotoAndStop(faceFrame+imageIndex);
		
			else
				this.gotoAndStop(BACK_FACE);			
		}
	}
}