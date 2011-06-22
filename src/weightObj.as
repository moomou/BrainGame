package
{
	import flash.display.MovieClip;
	
	public class weightObj extends MovieClip
	{
		//totalFrame:uint=14;		
		
		public static var imageIndex:uint=1;
		public var obj:Object;
		
		public function weightObj(frame,weight=0)
		{
			this.mouseChildren=false;			
			obj=new Object();			
			obj.mc=this;
			obj.weight=weight;			
			obj.mc.gotoAndStop(frame+imageIndex);
		}
	}
}