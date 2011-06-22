package arithmetics
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	public class test extends MovieClip		//math mini-game providing class
	{
		static const intLimit:uint=20;
		
		private var NumX:int;
		private var NumY:int;	//two random number variables
		private var divisor:int;	
		private var choice:int=0;		//random number holder for deciding which function to execute
		private var quest:int
		private var questR:int;	//quest is the number of questions asked and questR is the number answered correctly
		private var cont:Boolean;			//boolean for main while
		private var correct:Boolean;
		private var reply:Number;
		
		private var textArea:TextField;
		private var currentTime:int;
		
		public function test(textBox:TextField)
		{
			textArea=textBox;
		}
		public function MathFunction ():int
		{
			var ans:int;
			ans=0;
			
			NumX=Math.floor(Math.random()*intLimit+1);
			NumY=Math.floor(Math.random()*intLimit+1);			
			choice=Math.floor(Math.random()*4+1);
		
			switch (choice)
			{
				case 1:		
					ans=NumX+NumY;
					textArea.text=NumX+" + "+NumY+" = ";
					break;
				case 2:
					ans=NumX-NumY;
					textArea.text=NumX+" - "+NumY+" = ";
					break;
				case 3:
					ans=NumX*NumY;
					textArea.text=NumX+" * "+NumY+" = ";
					break;
				case 4:
					{
						ans=Math.floor(Math.random()*intLimit+2);
						NumX=NumY*ans;
						
						textArea.text=NumX+" / "+NumY+" = ";
						break;
					}
			}

			return ans;		
		}
		public function MathSymbol():String
		{
			var ans:String;
						
			NumX=Math.floor(Math.random()*intLimit+1);
			NumY=Math.floor(Math.random()*intLimit+1);			
			choice=Math.floor(Math.random()*4+1);
			
			switch (choice)
			{
				case 1:		
					ans="plus";
					textArea.text=NumX+" __ "+NumY+" = "+(NumX+NumY);
					break;
				case 2:
					ans="minus";
					textArea.text=NumX+" __ "+NumY+" = "+(NumX-NumY);
					break;
				case 3:
					ans="multiply";
					textArea.text=NumX+" __ "+NumY+" = "+(NumX*NumY);
					break;
				case 4:
					{
						ans="divide";
						
						var NumAns=Math.floor(Math.random()*intLimit+1);
						NumX=NumY*NumAns;
						
						textArea.text=NumX+" __ "+NumY+" = "+NumAns;
						break;
					}
			}
			
			return ans;
		}
		public function MathAnswer():int
		{
			var ans:int;
			ans=0;
			
			NumX=Math.floor(Math.random()*intLimit+1);
			NumY=Math.floor(Math.random()*intLimit+1);			
			choice=Math.floor(Math.random()*4+1);
		
			switch (choice)
			{
				case 1:		
					ans=Math.random()>.5 ? NumX : NumY;
					if (ans==NumX)
						textArea.text="   "+" + "+NumY+" = "+(NumX+NumY);
					else
						textArea.text=NumX+" + "+"    = "+(NumX+NumY);
					break;
				case 2:
					ans=Math.random()>.5 ? NumX : NumY;
					if (ans==NumX)
						textArea.text="   "+" - "+NumY+" = "+(NumX-NumY);
					else
						textArea.text=NumX+" - "+"    = "+(NumX-NumY);
					break;
				case 3:
					ans=Math.random()>.5 ? NumX : NumY;
					if (ans==NumX)
						textArea.text="   "+" * "+NumY+" = "+(NumX*NumY);
					else
						textArea.text=NumX+" * "+"    = "+(NumX*NumY);
					break;
				case 4:
					{
						var temp=Math.floor(Math.random()*intLimit+1);	//adding 1 here to prevent 0
						NumX=NumY*temp;
						
						ans=Math.random()>.5 ? NumX : NumY;
						
						if (ans==NumX)
							textArea.text="   "+" / "+NumY+" = "+temp;
						else
							textArea.text=NumX+" / "+"    = "+temp;
							
						break;
					}
			}

			return ans;		
		}
	}
}
