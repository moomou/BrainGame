package boulder
{
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	
	public class valueChain extends MovieClip	///potential bug! could get 2 equal num
	{		
		static const maxX:Number=.5;
		static const maxY:Number=.5;
		
		//stage const
		static const stageheight:uint=500;
		static const stagewidth:uint=550;
		
		//textfield const
		static const fontsize=35;
		static const fontname=new GameFont();
		
		public static var magArray:Array;
				
		private var parentMC;
		private var valueObj:Object;
		
		public function valueChain()
		{
			valueObj=new Object();
			return;
		}
		public function generateRock(newRock):Object
		{
			var size:Number=Math.random()+.5; //.5--1.3	
			var valueN:int=generateRandomValue();//between 20 and 70(could be <0)
			
			valueN=checkDuplicate(valueN);
			
			if (Math.random()>.5)
				valueN*=-1;	
				
			setUpText(newRock,valueN); //do things to the textfield			
							
			newRock.scaleX=size;
			newRock.scaleY=size;
					
			valueObj.dx=Math.random()*maxX+maxX/2;
			valueObj.dy=Math.random()*maxY+maxY/2;
			valueObj.rotate=Math.random()>.5 ? -.5 : .5;	
						
			newRock.buttonMode=true;
			newRock.mouseChildren=false;
			newRock.name=String(valueN);			
						
			addEventListener(Event.ENTER_FRAME,moveAbout);	
			
			valueObj.mc=newRock;
			valueObj.mag=valueN; //magnitude
			valueObj.removed=false;
			
			return valueObj;
		}
		private function setUpText(newRock,valueN)
		{
			var textFormat:TextFormat=new TextFormat();
			textFormat.size=fontsize;
			textFormat.font=fontname.fontName;
			textFormat.align="center";
			textFormat.bold=true;
			
			newRock.value.defaultTextFormat=textFormat;	
			newRock.value.selectable=false;
			newRock.value.embedFonts=true;
			newRock.value.autoSize = TextFieldAutoSize.CENTER;
			newRock.value.text=String(valueN);
			
			return;				
		}
		private function moveAbout(event:Event)			//moving the rock around on stage
		{
			valueObj.mc.x+=valueObj.dx;
			valueObj.mc.y+=valueObj.dy;
			valueObj.mc.rotation+=valueObj.rotate;
			
			if (valueObj.mc.x>stagewidth|| valueObj.mc.x<0)
				valueObj.dx*=-1;
			if (valueObj.mc.y>stageheight || valueObj.mc.y<0)
				valueObj.dy*=-1;
				
			return;	
		}
		private function generateRandomValue():Number	//generating random magnitude fot the rock
		{
			return Math.floor(Math.random()*70)+20; 
		}
		private function checkDuplicate(mag):Number		//checking for duplicate values in rock's magnitude attributes
		{
			var temp=mag;
			var fixed:Boolean=false;
			
			if (magArray.length==0)
			{
				magArray.push(mag);
				return mag;
			}
			else
			{
				while(!fixed)
					goThroughArray();
				
				magArray.push(temp);
				return temp;				
			}
			
			function goThroughArray()
			{
				fixed=true; //assume no duplicate from the beginning
				
				for (var i:int=magArray.length-1; i>=0; i--)
				{
					if (magArray[i]==temp)
					{
						fixed=false;
						temp=generateRandomValue();
						break;
					}
				}				
			}
		}
	}
}