package
{
	import caurina.transitions.*;
	
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.*;
	
	public class numberCount extends MovieClip
	{
		static const potentialColor:Array=[0x424113,0x0045E6,0xD80E36,0xD7220F,0x7B43A3,0x18AACD,0xBB722B,0x73E600,0x2BBB64];
		static const maxSpeed:Number=.7;
		static const stagewidth:uint=400;
		static const stageheight:uint=400;
		static const growLimit:Number=5;
		static const myfont=new GameFont();
	
		static const timeToGrow:Number=2;
		static const fontFace=myfont.fontName;
		static const fontBold=true;
				
		public  var numObj:Object;
		private var numArray:Array;
		private var numText:TextField;
		private var newSprite:Sprite;
		
		public function set internalValue(value:int)
		{
			numObj.name=String(value);
			numObj.numText.text=String(value);
		}
		public function numberCount()
		{
			getTextPropertySet();
			
			numObj=new Object();			
			numObj.numText=numText;
			numObj.mc=newSprite;		
			numObj.dx=maxSpeed*Math.random();
			numObj.dy=maxSpeed*Math.random();
			numObj.animation=Math.floor(Math.random()*4+1);	
			
			addEventListener(Event.ENTER_FRAME,animateSprite);
		}		
		private function getTextPropertySet() //for setting text property
		{				
			var fontSize=Math.round(Math.random()*15+32); //font size of 32 - 47
			var fontColor=potentialColor[Math.floor(Math.random()*potentialColor.length)];
			
			var textformat:TextFormat=new TextFormat();
			textformat.font=fontFace;
			textformat.size=fontSize;
			textformat.bold=fontBold;
			textformat.color=fontColor;
			textformat.align="center";

			numText=new TextField();
			numText.embedFonts=true;
			numText.defaultTextFormat=textformat;
			numText.selectable=false;
			numText.autoSize = TextFieldAutoSize.CENTER;
			numText.text = String(Math.floor(Math.random()*9+1)-1);
			numText.x = -(numText.width/2);
			numText.y = -(numText.height/2);
			
			newSprite=new Sprite();
			newSprite.x=stagewidth*Math.random()+100;
			newSprite.y=stageheight*Math.random()+100;
			newSprite.scaleX=2;
			newSprite.scaleY=2;
			newSprite.name=numText.text;
			newSprite.addChild(numText);
			newSprite.buttonMode=true;	
			newSprite.mouseChildren=false;		
		}
		private function animateSprite(event:Event)		//four different kinds of animations; 
		{
			if (numObj.animation==1)
				rotationAnimation();
			else if (numObj.animation==2)
				floatAnimation();
			else if (numObj.animation==3)
				shrinkAndGrowAnimation();
			else
				; //do nothing
		}
		private function rotationAnimation()
		{
			numObj.mc.rotation++;
		}
		private function floatAnimation()
		{			
			numObj.mc.x+=numObj.dx;
			numObj.mc.y+=numObj.dy;
			
			if (numObj.mc.x>550|| numObj.mc.x<50)
				numObj.dx*=-1;
			if (numObj.mc.y>500 || numObj.mc.y<50)
				numObj.dy*=-1;
				
			return;	
		}
		private function shrinkAndGrowAnimation()
		{
			if (!Tweener.isTweening(numObj.mc))
			{
				var X=growLimit*Math.random()+.2;
				var Y=growLimit*Math.random()+.2;
				Tweener.addTween(numObj.mc,{scaleX:X,scaleY:Y,time:timeToGrow});
			}
			
		}
	}
}