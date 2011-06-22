package
{
	import caurina.transitions.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	public class robotGuide extends MovieClip
	{
		public static var words:String="Welcome To Brain Game!";
		public static var trophyDescript:String="";	
		
		static const lowerRight:Point=new Point(470,500);
		static const defaultLocation:Point=new Point(435,480);
		
		public var robotObj:Object;	
		
		private var talking:Boolean;
		private var newTimer:Timer;
		
		public function robotGuide()
		{
			talking=true;
			
			robotObj=new Object();
			robotObj.mc=this;
			robotObj.mc.bubble.text.selectable=false;
			
			robotObj.originX=defaultLocation.x;
			robotObj.originY=defaultLocation.y;
			
			robotObj.whereAmI="";
			robotObj.subMode=modeClass.NONE;
			robotObj.state="normal";
			
			robotObj.hide=false;
			robotObj.explain=false;
			
			addEventListener(Event.ENTER_FRAME,robot);
		}
	
		private function robot(event:Event)
		{				
			if (robotObj.hide)
				robotObj.mc.visible=false;
			else 
				robotObj.mc.visible=true;
								
			if (talking)
				bubbleChange();
			
			stateChange();
			robotObj.mc.parent.setChildIndex(robotObj.mc,robotObj.mc.parent.numChildren-1);	//putting the robotguide on top of everything
		}
		private function bubbleChange():void
		{
			if (robotObj.whereAmI==modeClass.MAIN)							//when the robot is on the main screen
			{
				robotObj.mc.gotoAndStop("talk");
				robotObj.mc.bubble.text.text=words;	
				robotObj.state="laugh";		
				Tweener.addTween(robotObj.mc,{scaleX:1,scaleY:1,x:robotObj.originX,y:robotObj.originY,time:1});
			}
			else if (robotObj.whereAmI==modeClass.SCORE)				//score pages
			{
				robotObj.mc.bubble.text.text="This shows your most recent score in each mini-game!";
				Tweener.addTween(robotObj.mc,{scaleX:.7,scaleY:.7,x:450,y:500,time:1});
			}
			else if (robotObj.whereAmI==modeClass.BRAIN_TEST)			//brain test mode where the robot must offer explanation
			{
				robotObj.state="normal";
				
				if (robotObj.subMode==modeClass.NONE)
					robotObj.mc.bubble.text.text="Please click on the icon to begin";
				else
				{
					subModeDescription();					
				}
			}
			else if (robotObj.whereAmI==modeClass.CATEGORY)
			{
				Tweener.addTween(robotObj.mc,{scaleX:.7,scaleY:.7,x:lowerRight.x,y:lowerRight.y,time:1});
				robotObj.mc.gotoAndStop("talk");
				robotObj.state="laugh";
				
				if (robotObj.subMode==modeClass.NONE)
					robotObj.mc.bubble.text.text="Click on the game you want to play!";	
				else
					subModeDescription();				
			}
			else if (robotObj.whereAmI==modeClass.TROPHY)
			{
				robotObj.mc.gotoAndStop("talk");
				
				if (trophyDescript=="")
					robotObj.mc.bubble.text.text="This shows the trophies you have won.";
				else
					robotObj.mc.bubble.text.text=trophyDescript;
						
				Tweener.addTween(robotObj.mc,{scaleX:.7,scaleY:.7,x:lowerRight.x,y:lowerRight.y,time:1});
			}
		}
		private function stateChange() //for animating the character
		{
			if (robotObj.state=="normal")
			{
				robotObj.mc.eye.gotoAndStop("normal");
				robotObj.mc.mouth.gotoAndStop("normal");
			}
			else if (robotObj.state=="laugh")
			{
				robotObj.mc.eye.gotoAndStop("laugh");
				robotObj.mc.mouth.gotoAndStop("laugh");
			}		
		}
		private function subModeDescription()
		{
			if (robotObj.subMode==modeClass.MATH_NORMAL)
				robotObj.mc.bubble.text.text="You are going to do some math";
			else if (robotObj.subMode==modeClass.EYE_ROCK)
				robotObj.mc.bubble.text.text="Click on the smallest number to biggest in sequence.";
			else if (robotObj.subMode==modeClass.MEMO_MATCH)
				robotObj.mc.bubble.text.text="Match 2 cards.";
			else if (robotObj.subMode==modeClass.MATH_SIGN)
				robotObj.mc.bubble.text.text="Choose the correct math function.";
			else if (robotObj.subMode==modeClass.ANA_WEIGHT)
				robotObj.mc.bubble.text.text="Pick the heaviest object.";
			else if (robotObj.subMode==modeClass.ANA_CUBE)
				robotObj.mc.bubble.text.text="Count the cubes.";
			else if (robotObj.subMode==modeClass.MEMO_ORDER)
				robotObj.mc.bubble.text.text="Pick the showed card in order from left to right.";
			else if (robotObj.subMode==modeClass.EYE_PUZZLE)
				robotObj.mc.bubble.text.text="Pick the missing piece.";	
			else if (robotObj.subMode==modeClass.EYE_DIGIT)
				robotObj.mc.bubble.text.text="Count a particular number. Click on a number to answer.";
			else if (robotObj.subMode==modeClass.MEMO_ITEM)
				robotObj.mc.bubble.text.text="Count the occurrence of an item.";
			else if (robotObj.subMode==modeClass.MATH_MISSING)
				robotObj.mc.bubble.text.text="Enter the missing number.";
			else
				robotObj.mc.bubble.text.text="AN ERROR OCCURRED!!!";	
		}
	}
}