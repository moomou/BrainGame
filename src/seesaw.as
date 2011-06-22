package
{
	import caurina.transitions.*;
	
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.sampler.Sample;
	
	public class seesaw extends MovieClip
	{
		static const timeRequiredToRotate:uint=3;
		static const rotationConst:uint=15;
		static const transitionType:String="easeOutBack";
		
		static const point1stSeesaw:Point=new Point(300,280); //default locations of the seesaw
		static const point2ndSeesaw:Point=new Point(475,130);
		static const point3rdSeesaw:Point=new Point(125,130);
		
		static const item1st:Point=new Point(-2,75);		 //default location of items on both right and left
		static const item2nd:Point=new Point(35,75);
		static const item3rd:Point=new Point(-40,75);
		
		public static var numOfSeesaw:uint=1;
		
		private var seesawMC;
		
		public var numRight:uint=0;
		public var numLeft:uint=0;	
		
		private var weightRight:Number=0;
		private var weightLeft:Number=0;
		
		public function seesaw()
		{
			numRight=0;
			numLeft=0;
			weightRight=0;
			weightLeft=0;
			seesawMC=this;
			
			if (numOfSeesaw==1)
			{
				numOfSeesaw++;
				this.x=point1stSeesaw.x;
				this.y=point1stSeesaw.y;
			}
			else if (numOfSeesaw==2)
			{
				numOfSeesaw++;
				this.x=point2ndSeesaw.x;
				this.y=point2ndSeesaw.y;
			}
			else if (numOfSeesaw==3)
			{
				numOfSeesaw=1;
				this.x=point3rdSeesaw.x;
				this.y=point3rdSeesaw.y;
			}
		}
		public function addItemsRight(itemObj)
		{
			if (numRight==0)
			{
				numRight++;
				itemObj.mc.x=item1st.x;
				itemObj.mc.y=item1st.y;
				seesawMC.pivot.rightP.addChild(itemObj.mc);
				seesawMC.pivot.rightP.setChildIndex(itemObj.mc,0);
				weightRight+=itemObj.weight;
			}
			else if (numRight==1)
			{
				numRight++;
				itemObj.mc.x=item2nd.x;
				itemObj.mc.y=item2nd.y;
				seesawMC.pivot.rightP.addChild(itemObj.mc);
				seesawMC.pivot.rightP.setChildIndex(itemObj.mc,0);
				weightRight+=itemObj.weight;
			}
			else if (numRight==2)
			{
				numRight++;
				itemObj.mc.x=item3rd.x;
				itemObj.mc.y=item3rd.y;
				seesawMC.pivot.rightP.addChild(itemObj.mc);
				seesawMC.pivot.rightP.setChildIndex(itemObj.mc,0);
				weightRight+=itemObj.weight;
			}
			else 
				return;	
		}
		public function addItemsLeft(itemObj)
		{
			if (numLeft==0)
			{
				numLeft++;
				itemObj.mc.x=item1st.x;
				itemObj.mc.y=item1st.y;
				seesawMC.pivot.leftP.addChild(itemObj.mc);
				seesawMC.pivot.leftP.setChildIndex(itemObj.mc,0);
				weightLeft+=itemObj.weight;
			}
			else if (numLeft==1)
			{
				numLeft++;
				itemObj.mc.x=item2nd.x;
				itemObj.mc.y=item2nd.y;
				seesawMC.pivot.leftP.addChild(itemObj.mc);
				seesawMC.pivot.leftP.setChildIndex(itemObj.mc,0);
				weightLeft+=itemObj.weight;
			}
			else if (numLeft==2)
			{
				numLeft++;
				itemObj.mc.x=item3rd.x;
				itemObj.mc.y=item3rd.y;
				seesawMC.pivot.leftP.addChild(itemObj.mc);
				seesawMC.pivot.leftP.setChildIndex(itemObj.mc,0);
				weightLeft+=itemObj.weight;
			}	
			else 
				return;		
		}
		public function sway()										//showing the seesaw's animation (has to be called explicitly)
		{			
			if (weightLeft!=weightRight)
			{
				var rotate=weightLeft>weightRight ? -rotationConst : rotationConst;	//assigning the rotation based on weight
				
				Tweener.addTween(this.pivot,{rotation:rotate,time:timeRequiredToRotate,transition:transitionType});
				Tweener.addTween(this.pivot.rightP,{rotation:-rotate,time:timeRequiredToRotate,delay:.5,transition:transitionType});
				Tweener.addTween(this.pivot.leftP,{rotation:-rotate,time:timeRequiredToRotate,delay:.5,transition:transitionType});				
			}
			else
			{
				Tweener.addTween(this,{rotation:rotationConst/6,time:timeRequiredToRotate*2,transition:"easInOutBack"});
				Tweener.addTween(this,{rotation:-rotationConst/6,time:timeRequiredToRotate*2,delay:timeRequiredToRotate*2,transition:"easeInOutBack"});
				Tweener.addTween(this,{rotation:0,time:timeRequiredToRotate*2,delay:timeRequiredToRotate*2,transition:"easeInOutBack"});
			}
		}
	}
}