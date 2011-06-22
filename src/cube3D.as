package
{
	//import external classes needed.
	import caurina.transitions.*;	
	import five3D.display.*;
	
	import flash.events.*;
	import flash.geom.Point;
	
	public class cube3D extends Sprite3D
	{	
		static const fallingCubeTime:Number=.7; //falling time of cube
		static const cubesAlpha:Number=.9;		//visibility of cubes
		static const rotationXX:int=30;			//should not be changed
		static const rotationYY:int=-45;		//should not be changed
		
		static const colorArray:Array=[0x36E2E2,0x97F05B,0xF87EC8,0xDDBB33,0xFFE711]; //the colors of cubes, can be expanded to add variety
		
		static const stagewidth=400;
		static const stageheight=200;
		static const offsetCX:Number=42.5; //canvas offset
		static const offsetCY:Number=23.5; 
		static const cubeOffsetX:uint=42; //cube offset
		static const cubeOffsetY:uint=24;
		static const cubeOffsetZ:uint=51;
				
		static const maxRowZ:uint=3;	//max rows of cubes z-axis
		static const max:uint=3;		//max rows of cubes in the x-axis
		static const maxHeight:uint=4; //y-axis
		
		public static var numberOfCubes:uint=0;		//used for tracking cubes and answer
		
		private var currentStage;
		
		private var clickOffset:Point;
		private var cube:Sprite3D;		
		private var cubeObj:Object;
		
		private var cubeArray1:Array;
		private var cubeArray2:Array;
		private var cubeArray3:Array;
			
		private var canvas1:Scene3D;
		private var canvas2:Scene3D;
		private var canvas3:Scene3D;
		
		private var defaultRotateX;
		private var defaultRotateY;
		private var defaultRotateZ;
		
		private var canX1;
		private var canY1;
		private var canX2;
		private var canY2;
		private var canX3;
		private var canY3;
						
		public function cube3D(current)
		{
			currentStage=current;
			
			cubeArray1=new Array();
			cubeArray2=new Array();
			cubeArray3=new Array();			
					
			setup3DScene();
			pattern();
			
			animateCubes(cubeArray1,0);
			animateCubes(cubeArray2,.5);
			animateCubes(cubeArray3,1);
						
			//currentStage.addEventListener(MouseEvent.MOUSE_DOWN,stageRotate);
		}
		private function setup3DScene() //manually setting up 3d canvas
		{
			canvas1=new Scene3D();
			canvas1.x=stagewidth/2;
			canvas1.y=stageheight/2;
			canvas1.viewDistance=2000;
			canvas1.ambientLightIntensity=1;
			currentStage.addChild(canvas1);			
								
			canvas2=new Scene3D();
			canvas2.x=stagewidth/2-offsetCX;
			canvas2.y=stageheight/2+offsetCY;
			canvas2.viewDistance=2000;
			canvas2.ambientLightIntensity=-.5;
			currentStage.addChild(canvas2);
						
			canvas3=new Scene3D();
			canvas3.x=stagewidth/2-offsetCX*2;
			canvas3.y=stageheight/2+offsetCY*2;
			canvas3.viewDistance=2000;
			canvas3.ambientLightIntensity=1;
			currentStage.addChild(canvas3);
		}
		private function pattern() //makes cubes
		{		
			for (var z:uint=1; z<4; z++) 
			{
				var randRowX:uint=Math.round(Math.random()*max+1);				
				constructCubes(randRowX,z);
			}		
		}
		private function constructCubes(randRowX,z)
		{			
			var randHeight=maxHeight;			
			while (randHeight>=1)
			{
				for (var x:uint=0; x<randRowX; x++)
				{
					var y=x;
				
					generateCube(this["canvas"+z],x*cubeOffsetX,y*cubeOffsetY-500+randHeight*cubeOffsetZ,0);
				}		
				
				randRowX=Math.floor(Math.random()*randRowX);						
				randHeight--;			
			}		
		}
		private function animateCubes(array:Array,priority)
		{
			for (var i:uint=0; i<array.length; i++)
			{
				Tweener.addTween(array[i],{y:array[i].y+500,time:fallingCubeTime,delay:priority});
			}
		}
		private function generateCube(sceneToAdd,xx=0,yy=0,zz=0)
		{
			var randomColor;
			var rand=Math.floor(Math.random()*colorArray.length);
			
			randomColor=colorArray[rand];		
		
			cube=new Sprite3D();
			cube.rotationX=rotationXX;
			cube.rotationY=rotationYY;					
					
			createFace(randomColor,0, 0, -150, 0, 0, 0); //faces of cubes
			createFace(randomColor,150, 0, 0, 0, -90, 0);
			createFace(randomColor,0, 0, 150, 0, 180, 0);
			createFace(randomColor,-150, 0, 0, 0, 90, 0);
			createFace(randomColor,0, -150, 0, -90, 0, 0);
			createFace(randomColor,0, 150, 0, 90, 0, 0);
	
			cube.x=xx; //setting position of cube
			cube.y=yy;
			cube.z=zz;
						
			cube.scaleX=.2; //so the cube does not occupy the whole stage
			cube.scaleY=.2;
			cube.scaleZ=.2;
			
			sceneToAdd.addChild(cube);
			cube.mouseChildren=false;
			
			numberOfCubes++;
			
			if (sceneToAdd==canvas1)
				cubeArray1.push(cube);
			else if (sceneToAdd==canvas2)
				cubeArray2.push(cube);
			else if (sceneToAdd==canvas3)
				cubeArray3.push(cube);
		}
		private function createFace(faceHue,x:Number, y:Number, z:Number, rotationx:Number, rotationy:Number, rotationz:Number):void 
		{
			var face:Sprite3D = new Sprite3D();
		
			face.graphics3D.beginFill(faceHue); //red
			
			face.graphics3D.drawRect(-150, -150, 300, 300);
			face.graphics3D.endFill();
			
			face.x = x;
			face.y = y;
			face.z = z;
			
			face.alpha=cubesAlpha;
			
			face.rotationX = rotationx;
			face.rotationY = rotationy;
			face.rotationZ = rotationz;
			face.singleSided = true;
			face.flatShaded = true;
			cube.addChild(face);			
		}
		public function cleanupCubes() //cleanup function 
		{
			numberOfCubes=0;
			currentStage.removeChild(canvas1);
			currentStage.removeChild(canvas2);
			currentStage.removeChild(canvas3);
		}
		
//==============================================================================experimental rotation of cubes
		private function stageRotate(event:MouseEvent):void
		{
			defaultRotateX=cubeArray1[0].rotationX;
			defaultRotateY=cubeArray1[0].rotationY;			
			defaultRotateZ=cubeArray1[0].rotationZ;
			
			canX1=canvas1.mouseX;
			canY1=canvas1.mouseY;
			canX2=canvas2.mouseX;
			canY2=canvas2.mouseY;
			canX3=canvas3.mouseX;
			canY3=canvas3.mouseY;
			
			currentStage.addEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
			currentStage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
		}
		private function stageMouseMove(event:MouseEvent):void 
		{
			for (var i:uint=0; i<cubeArray1.length; i++)
			{
				cubeArray1[i].rotationX=defaultRotateX+canvas1.mouseY-canY1;
				cubeArray1[i].rotationY=defaultRotateY+canvas1.mouseX-canX1;
				cubeArray1[i].rotationZ=defaultRotateZ+canvas1.mouseX-canX1;
			}			
			for (var j:uint=0; j<cubeArray2.length; j++)
			{
				cubeArray2[j].rotationX=defaultRotateX+canvas2.mouseY-canY2;
				cubeArray2[j].rotationY=defaultRotateY+canvas2.mouseX-canX2;
				cubeArray2[j].rotationZ=defaultRotateZ+canvas2.mouseX-canX2;
			}
			for (var k:uint=0; k<cubeArray3.length; k++)
			{
				cubeArray3[k].rotationX=defaultRotateX+canvas3.mouseY-canY3;
				cubeArray3[k].rotationY=defaultRotateY+canvas3.mouseX-canX3;
				cubeArray3[k].rotationZ=defaultRotateZ+canvas3.mouseX-canX3;
			}
					
			canvas1.render();
			canvas2.render();
			canvas3.render();
						
			event.updateAfterEvent();
		}
		private function stageMouseUp(event:MouseEvent):void 
		{
			currentStage.removeEventListener(MouseEvent.MOUSE_MOVE, stageMouseMove);
			currentStage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
		}		
						
	}
}
