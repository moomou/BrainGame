package 
{
	import arithmetics.test;
	
	import boulder.valueChain;
	
	import caurina.transitions.*;
	
	import five3D.display.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.geom.*;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.Timer;
		
	public class BrainGame extends MovieClip
	{	
		static const totalNumberOfPuzzleOutline=5;
		static const totalNumberOfMiniGames:uint=11;
		static const transitMODE:String="linear"; 			//mode of tween for menu tweens
		static const tempScoreBoardTransitMode:String="easeInOutBack";
		static const locationOfXML:String="picturesURL.xml"; //file name of the xml file
		static const gf:GlowFilter=new GlowFilter();	//used for btn animation
		
		//default location of certain movieclip
		static const markPosition:Point=new Point(320,470);	//check mark's default location
		static const contBtnPoint:Point=new Point(300,450);
		static const backupPoint:Point=new Point(11,504);
		static const trophyPlatformPosition:Point=new Point(25,105);
		static const blackBoardPosition:Point=new Point(70, -370);		//x is when the blackboard is pulled down, y is up
		
		//default time for various animations; >1000 means ms
		static const markTime:uint=1000;		   	 //check mark's default playing time
		static const timeToMemorizeCard:Number=5000; //time of the cards being displayed in ms
		static const timeToAnimateCards:Number=1.5;	
		static const timeToAnimateRock:Number=1.2;		
		static const timeToMemorizeItems:Number=2.5;
		static const timeToAnimatePuzzlePieces:Number=.7;
		static const timeToSeeCountItem:Number=1000;
		static const timeToShowCorrectAnswer:Number=.5;
		
		static const introScreenTime:Number=1; 
		static const timeToAnimateBtns:Number=.5;
		static const timeToAnimateTrophyPlatform:Number=1.2;
		static const totalTimePerGame:int=-30000; //total time for each mini game
						
		static const OFF:Boolean=false;
		static const ON:Boolean=true;
		
		//whether to animate flip or not in the mini-games
		static const flipMatch:Boolean=true;
		static const flipOrder:Boolean=false;
		
		//score constants
		static const questWorth:uint=10;//used to calculate score
		static const rightQuestWorth:uint=500;		
		static const rankAScore:uint=7500;	//greater or above 
		static const rankBScore:uint=5500;
		static const rankCScore:uint=2500;
		static const trophyWorthyNumberOfQuestion:uint=15;
		static const brainTestWorthyNumber:uint=3;				
		
		//miscellaneous const
		static const totalFrameCount:uint=60;	//frame per second, used to control how fast the programs checks for answers in mini-game using numkeys
		static const framePercent:Number=.8;	//this is a constant used to control for how long each math Q waits until check answer; represent percent of a second
		static const totalCardToPickFrom:uint=5;	//this is the number of cards for showing random choices in order card game
		static const gravityPullForItemCount:Number=.25;
		
		//picture variables
		static const numPiecesHoriz:uint=5; //the number of pieces horizontal for the puzzle picture
		static const numPiecesVert:uint=5; //
		static const horizOffset:Number =83.5;
		static const vertOffset:Number = 50;
		static const puzzlePlateLoc:Point=new Point(130,47);
				
		private var puzzlePlate:MovieClip;
		private var pieceWidth:Number;
		private var pieceHeight:Number;
		
		//textfield const
		static const fontFace:String = "Arial";
		static const fontSize:int = 35;
		static const fontBold:Boolean = true;
				
		//textfields
		private var questionField:TextField;
		private var answerField:TextField;
		private var TIMEUP:TextField;
		private var negative:TextField;
		private var answerString:String;		
		
		//answers & questions
		private var correctAnswer:int; //numeric answer
		private var correctSign:String;
		private var ansSign:Boolean; //true indicates >=0, while false <0
		private var answerWeight:int;
		private var numberOfCorrectAnswers:int;
		private var numberOfQuestions:int;		
		
		//buttons
		private var buttonArray:Array;
		private var catBtnArray:Array;
		private var numpadArray:Array;
		private var	contBtn:SimpleButton;
		private var signArray:Array; 
		
		//scores
		private var scoreList:Array;
		private var scoreAll:Array;
		private var currentScore:Object;
		
		// mode
		private var currentMode:String;	
		private var subMode:String;
		private var catModeChoice:Object;
		private var trialChoice:Object;
		
		//time variables
		private var timer:int;
		private var second:Timer;
		private var answerTiming:int;
		private var toggleAnimation:Boolean;
		private var CountToThree:MovieClip;
		private var countToThreeTimer:Timer;
		private var checkAnswerTimer:Timer;
		
		//var for loading external xmls
		private var xmlLoader:URLLoader;
		private var xml:XML;
		private var xmlList:XMLList;
	
		//boolean
		private var attempted:Boolean; //if a question is attempted
		private var neg:Boolean;  //if the answer is negative
		private var addedCont:Boolean; //continue button flag
		
		//4 categories
		private var anaCatPlayed:Boolean;	//analytical
		private var mathCatPlayed:Boolean;	//math	
		private var memoCatPlayed:Boolean;	//memory
		private var eyeCatPlayed:Boolean;	//eye coordination
		
		//each mini-games' flag
		private var mathPlayed:Boolean; //to indicate these levels have been played
		private var memoPlayed:Boolean;
		private var seriesPlayed:Boolean;
		private var symbolPlayed:Boolean;
		private var weightPlayed:Boolean;
		private var puzzlePlayed:Boolean;
		private var brickPlayed:Boolean;
		private var showedCardPlayed:Boolean;
		private var countNumPlayed:Boolean;
		private var countItemPlayed:Boolean;
		private var numberPlayed:Boolean;
		
		//game objects-boulder
		private var boulderArray:Array;
		
		//game object-seesaw
		private var seesawArray:Array;
		private var weightObjArray:Array;
		private var weightIndexArray:Array;
		private var linkArray:Array; //for checking comparison between different weights
		
		//game object-card
		private var cardArray:Array;
		private var playCard:Array;
		private var showedCards:Array;
		private var usedThisCards:Array;
		private var cardPosition:Array;
		private var currentAnswer:int;
		private var cardFlipping:Timer;		//timer for controlling card flipping
		private var handlerAdded:Boolean;
		private var cardLeft:uint;
		private var firstCard:matchCard;
		private var secondCard:matchCard;
		
		//game object-puzzle
		private var piecesArray:Array;
		private var copyArray:Array;
		private var puzzleAnswerArray:Array;
		private var missingPiecesArray:Array;
		private var maskPiecesArray:Array;
		private var picLoader:Loader;
		private var pictureUsed:Bitmap;
	
		//game object-cube
		private var newCubeStack:cube3D;
		
		//game obj-count mini-game obj
		private var countNumArray:Array;
		private var countItemArray:Array;	//game obj-count items
		private var ansString:String;			//particular answer seeked
		private var	ansCount:int;				//number of times ansString occurred
		private var graphicPlate:Sprite;
		private var counterArray:Array;
		private var answerMCRemoved:Boolean;
		
		//game object-trophy
		private var trophyList:Array;
		private var trophyPlatform:MovieClip;
		private var trophyCount:uint;
		
		//guide
		private var guideRobot:Object;	
				
//==========================================================================================================================functions
		public function startBrainGame()//constructor
		{		
			//stage properties	
			stage.scaleMode=StageScaleMode.EXACT_FIT;
			stage.showDefaultContextMenu=false;
		
			currentMode=modeClass.MAIN;
			toolBar.gameInfo.selectable=false;
			puzzleBase.mouseEnabled=false;
		
			//main variable initialization
			CountToThree=new countToThree();
			answerString=new String();
			scoreAll=new Array();
			scoreList=new Array();
			trophyList=new Array();			
			catModeChoice=new Object();			
			contBtn=new cont();			
			second=new Timer(0);	//timer
			checkAnswerTimer=new Timer(0);
			trophyCount=0;

			handlerAdded=false;		//properties of mini-games		
			addedCont=false;
			answerMCRemoved=false;
			toggleAnimation=false;
				
			getGuide();			//add robot guide
			getButtons();		//add event listeners to buttons
			resetPlayed();		//make sure all the mini-game are playable	
			backUp(null);
			
			//animate intro
			Tweener.addTween(intro,{alpha:0,time:introScreenTime,delay:1,onComplete:removeME,onCompleteParams:[intro],transition:"easeInExpo"});
			SoundEffect.playBG(SoundEffect.MAIN_MENU_MUSIC);
		}
			
		//entering different modes and loading files
		private function getGuide()
		{
			guideRobot=new Object();
			guideRobot=roboGuide.robotObj;
			guideRobot.whereAmI=currentMode;				
		}
		private function getButtons()
		{		
			//main btn trio
			buttonArray=new Array();
			buttonArray.push(brainTestMode);
			buttonArray.push(scoreMode);
			buttonArray.push(catMode);
			buttonArray.push(trophy);
			
			//add event listener for the button Array
			buttonOnOff(ON);
				
			//back button		
			back.addEventListener(MouseEvent.CLICK,backUp);
			back.alpha=0;
			back.enabled=false;
			
			//turning the visibility of clock to false
			countDown.visible=false;
			
			//category button
			catBtnArray=new Array();
			catBtnArray.push(mathBtn);
			catBtnArray.push(eyeBtn);
			catBtnArray.push(anaBtn);
			catBtnArray.push(memoBtn);
			
			//adding event listener to each of choice bars in catMode
			mathBtn.math.addEventListener(MouseEvent.CLICK,registerModeChange);
			mathBtn.sign.addEventListener(MouseEvent.CLICK,registerModeChange);
			mathBtn.missing.addEventListener(MouseEvent.CLICK,registerModeChange);
			mathBtn.none.addEventListener(MouseEvent.CLICK,registerModeChange);
			
			
			eyeBtn.rock.addEventListener(MouseEvent.CLICK,registerModeChange);
			eyeBtn.puzzle.addEventListener(MouseEvent.CLICK,registerModeChange);
			eyeBtn.digit.addEventListener(MouseEvent.CLICK,registerModeChange);
			eyeBtn.none.addEventListener(MouseEvent.CLICK,registerModeChange);
			
			anaBtn.weight.addEventListener(MouseEvent.CLICK,registerModeChange);
			anaBtn.cube.addEventListener(MouseEvent.CLICK,registerModeChange);
			anaBtn.none.addEventListener(MouseEvent.CLICK,registerModeChange);
			
			memoBtn.match.addEventListener(MouseEvent.CLICK,registerModeChange);
			memoBtn.order.addEventListener(MouseEvent.CLICK,registerModeChange);
			memoBtn.item.addEventListener(MouseEvent.CLICK,registerModeChange);
			memoBtn.none.addEventListener(MouseEvent.CLICK,registerModeChange);
			
			//quality btn
			qualityBtn.addEventListener(MouseEvent.CLICK, changeQ);
			
			//sound
			soundBtn.addEventListener(MouseEvent.CLICK,toggleSound);
		}
		private function changeMode(event:Event)
		{
			SoundEffect.playStage(SoundEffect.MENUBTN_SOUND);
			
			var mode:String=event.target.name;			
			enterMode(mode);
		}
		private function enterMode(mode:String)
		{
			subMode=modeClass.NONE;
			currentMode=mode;
			
			guideRobot.subMode=subMode;
			guideRobot.whereAmI=currentMode; //telling the robot where he is
						
			if (mode==modeClass.BRAIN_TEST)
			{
				startBrainTest();				
			}
			else if (mode==modeClass.CATEGORY)
			{
				startCatChoose();			
			}
			else if (mode==modeClass.SCORE)
			{
				showScoreList();
			}
			else if (mode==modeClass.TROPHY)
			{
				showTrophyPlatform();
			}
			else
				trace("error in enter mode");			
		}
		private function startBrainTest()
		{		
			fadeOutMenu();					
			blackboard.option2.addEventListener(MouseEvent.CLICK,chooseNextStage);	
		}
		private function startCatChoose()	//category mode
		{
			//to indicate what parts of the test have occurred
			catModeChoice.ana=null;
			catModeChoice.math=null;
			catModeChoice.eye=null;
			catModeChoice.memo=null;
			
			fadeOutMenu();
			addcontBtn();	//add start btn
		}
		private function showScoreList()
		{
			fadeOutMenu();
		}	
		private function showTrophyPlatform()	//trophy function
		{
			trophyPlatform=new trophyDrawer();
			trophyPlatform.x=-600;
			trophyPlatform.y=50;
			addChild(trophyPlatform);
			setChildIndex(trophyPlatform,numChildren-1);
			
			fadeOutMenu();
			placeTrophy();
		}	
//==========================================================================================================================starter game functions
		private function firstTrial()//math 1
		{
			mathPlayed=true;
			
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
				
			startTimer();
			setupMathQs();			
		}
		private function secondTrial()	//boulder click
		{
			seriesPlayed=true;
				
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
		
			startTimer();
			createBoulder();			
		}
		private function thirdTrial()	//card match
		{
			memoPlayed=true;
			
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
			
			startTimer();
			createCards();			
		}
		private function fourthTrial()	//math sign
		{
			symbolPlayed=true;
			
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
			
			startTimer();	
			setupSymbolKeys();					
		}
		private function fifthTrial()	//weight / seesaw game
		{
			weightPlayed=true;
		
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
			
			startTimer();
			setupWeightAndSeesaw();
		}
		private function sixthTrial()	//bitmap puzzle
		{
			puzzlePlayed=true;
		
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
			
			startTimer();
			xmlLoad();		
		}
		private function seventhTrial()	//count the cube 
		{			
			brickPlayed=true;
		
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
					
			startTimer();
			setupKeypad();
			makeCubes();			
		}
		private function eighthTrial()	//order card
		{			
			showedCardPlayed=true;
		
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
					
			startTimer();
			setupCardArray();		
		}
		private function ninthTrial()	//digit counting games
		{			
			countNumPlayed=true;
		
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
					
			startTimer();
			setupNumbers();	
		}
		private function tenthTrial()	//item counting game
		{
			countItemPlayed=true;
			
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
					
			startTimer();
			setupCountItemText();
			setupCountItems();
		}
		private function eleventhTrial()	//math finding missing number
		{
			numberPlayed=true;
			
			numberOfCorrectAnswers=0;
			numberOfQuestions=0;
					
			startTimer();
			setupNumberPlay();
		}
//==========================================================================================================================numeracy tests
//------------------------------------------------------------------------------------math questions (1st)
		private function setupMathQs()
		{	
			var startX=170; //starting position for num keys
			var startY=220;
			
			setupNumkeys(startX,startY,true,true); //boolean represents clear and negative btn respectively
			setupTextField();	//places two textfield on the stage			
		}
		private function checkAnswerForMath()
		{
			if (answerField.text!="" && questionField.text!="")
			{				
				if (answerString==String(correctAnswer) && ansSign==!neg)
				{
					var check:mark=new mark(this,new right(),markPosition.x,markPosition.y,markTime); 
					
					numberOfCorrectAnswers++;
					questionField.text="";
					
					answerField.text="";
					answerString="";
					
					negative.text="";
					neg=false;						
				}
				else 
				{
					removeEventListener(Event.ENTER_FRAME,startQuestion);
					var check2:mark=new mark(this,new wrong(),markPosition.x,markPosition.y,markTime); //...					
					showCorrectAnswer(String(correctAnswer));
				}
			}
		}
//------------------------------------------------------------------------------------math question 2 putting in x, %, - *(4th)
		private function setupSymbolKeys()
		{
			var startX=200; //starting position of sign btns
			var startY=250;
			
			signArray=new Array();
			
			for (var i:uint=0; i<4; i++)
			{
				var signSymbol:MovieClip=new mathSign();
				signSymbol.x=startX+signSymbol.width*i;
				signSymbol.y=startY;
				signSymbol.gotoAndStop(i+1);
			
				signSymbol.buttonMode=true;
				signSymbol.addEventListener(MouseEvent.CLICK,returnSign);
				
				stage.addChild(signSymbol);
				signArray.push(signSymbol);				
			}
			
			setupTextField();	
		}
		private function returnSign(event:MouseEvent)
		{
			var symbol=event.currentTarget as MovieClip;
			checkForSign(symbol.currentLabel);
		}
		private function checkForSign(userInput:String)
		{
			for (var i:uint=0; i<signArray.length; i++)							//removing handlers to prevent users from halting the game
				signArray[i].removeEventListener(MouseEvent.CLICK,returnSign);
									
			if (userInput==correctSign)
			{
				numberOfCorrectAnswers++;
				var SignRight:mark=new mark(this,new right(),markPosition.x,markPosition.y,markTime);	
				
				questionField.text="";
				answerField.text="";
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME,startQuestion);				
				var SignWrong:mark=new mark(this,new wrong(),markPosition.x,markPosition.y,markTime);				
				showCorrectAnswer(returnSymbol(correctSign));				
			}			
		}
		private function returnSymbol(input):String
		{
			if (input=="plus")
				return "+";
			else if (input=="minus")
				return "-";
			else if (input=="divide")
				return "/";
			else
				return "*";
		}
//-------------------------------------------------------------------------------------answered Qs
		private function setupNumberPlay()
		{
			var startX=170; //starting position for num keys
			var startY=220;
			var ansFieldPoint:Point=new Point(275,150);
			var negFieldPoint:Point=new Point(270,147);
			var infoPoint:Point=new Point(130,150);
			var infoText:TextField=new TextField();
			
			infoText.defaultTextFormat=getDefaultFormat();	//for placing answer to give the user a bit of orientation
			infoText.selectable=false;
			infoText.text="Answer: ";
			infoText.name="infoText";
			infoText.width=150;
			infoText.x=infoPoint.x;
			infoText.y=infoPoint.y;
			addChild(infoText);
			
			setupNumkeys(startX,startY,true,true); //boolean represents clear and negative btn respectively
			setupTextField(false,ansFieldPoint.x,ansFieldPoint.y,negFieldPoint.x,negFieldPoint.y);	//places two textfield on the stage		
		}
		private function numberPlayCheckAnswer()
		{
			checkAnswerForMath();	// uses the original check math funciton
		}
//==========================================================================================================================memory tests
//------------------------------------------------------------------------------------card match (3rd)
		private function createCards()
		{		
			matchCard.imageIndex=Math.floor(Math.random()*5+3);	//to randomly generate card faces
			
			var randomEven:uint;
			
			if (timer/totalTimePerGame>.7) //adjust difficulty according to available time
				randomEven=Math.round(4+Math.random()*2);
			else if (timer/totalTimePerGame>.4) 
				randomEven=Math.round(4+Math.random()*4);				
			else
				randomEven=Math.floor(6+Math.random()*4);	
		
			if (randomEven%2 != 0)	//make sure there are even number of cards
				randomEven+=1;
				
			cardArray=new Array();
		
			for (var i:uint=0; i<randomEven/2; i++) //making up index for cards
			{
				cardArray.push(i);
				cardArray.push(i);				
			}
			
			getCardFaces(randomEven);
		}
		private function getCardFaces(numOfCards:uint)	//put cards onto the stage
		{
			playCard=new Array();
			cardPosition=new Array();
			
			cardLeft=0;		//to indicate how many cards are left
			var j:uint=0;
			
			for(var i:uint=0;i<numOfCards;i++)
			{
				var newCard:matchCard=new matchCard();
				var index:uint=Math.floor(Math.random()*cardArray.length);
				var x_y:Object=new Object;
				
				var startX=stage.stageWidth/2;
				var startY=stage.stageHeight/2;
								
				var positionX=140;
				var spacingX=15;
				var spacingY=20;
				
				newCard.faceFrame=cardArray[index];	//assign pictures
							
				cardArray.splice(index,1); //delete assigned pictures
				
				if (i>=numOfCards/2)	//if less than half, stay on the top row
				{
					newCard.y=startY;	//assigning y values
					x_y.y=newCard.height*2+spacingY;		 
										
					newCard.x=startX;
					x_y.x=(spacingX+newCard.width)*j+positionX;	//assigning x values
					
					j++;
				}
				else //else go to bottom row 
				{
					newCard.y=startY;
					x_y.y=newCard.height;
					
					newCard.x=startX;
					x_y.x=(spacingX+newCard.width)*i+positionX;
				}
									
				cardLeft++;
				newCard.scaleX=.5;
				newCard.scaleY=.5;
				Tweener.addTween(newCard,{scaleX:1,scaleY:1,time:1}); //an entrance animation for the cards
				
				cardPosition.push(x_y);
				playCard.push(newCard);
				addChild(newCard);	
				newCard.added=true;			
			}
			
			Tweener.addCaller(new Object(),{onUpdate:putCardsIntoPosition,time:1,count:1});	//calls the function to spread the card out
			//Tweener.addCaller(new Object(),{onUpdate:startTiming,time:1,count:1,delay:1});
		}	
		private function putCardsIntoPosition()	//actual placing function
		{
			for (var i:uint=0; i<cardPosition.length; i++)
			{
				var destX=cardPosition[i].x;
				var destY=cardPosition[i].y;
				
				Tweener.addTween(playCard[i],{x:destX,y:destY,time:timeToAnimateCards});
				playCard[i].flip(flipMatch);
			}
			
			startTiming();
		}
		private	function startTiming()
		{
			if (timer<0 && subMode!=modeClass.NONE) //only execute this when if the backup is not pressed and there is still time
			{
				toolBar.gameInfo.text="Click to begin.";
				cardFlipping=new Timer(timeToMemorizeCard,1);
				cardFlipping.addEventListener(TimerEvent.TIMER,beginMemoGameMatch);
					
				stage.addEventListener(MouseEvent.MOUSE_UP,beginMemoGameMatch);
				cardFlipping.start();
				handlerAdded=true;
			}		
		}		
		private	function beginMemoGameMatch(event:Event) 
		{
			removeHandlersMemo();		//clean up event handler	
			toolBar.gameInfo.text="";
			
			startQuestion(null); //to randomly shuffle cards around
			
			for (var i:uint=0; i<playCard.length; i++)
			{
				playCard[i].addEventListener(MouseEvent.CLICK,cardClick);
				playCard[i].flipBack(flipMatch);
			}
		}		
		private function cardClick(event:MouseEvent)	//checking card matches
		{
			var cardClicked:matchCard=(event.target as matchCard);
			
			if (firstCard==null)
			{
				firstCard=cardClicked;
				firstCard.flip(flipMatch);
			}
			else if (firstCard==cardClicked)
			{
				//to prevent self pairing
			}
			else if (secondCard==null)
			{
				secondCard=cardClicked;
				secondCard.flip(flipMatch);
				
				var checkTimer:Timer=new Timer(900,1); //so the card can flip before it is marked
				checkTimer.addEventListener(TimerEvent.TIMER,checkCards);
				checkTimer.start();
			}			
		}
		private function checkCards(event:TimerEvent)
		{			
			if (subMode==modeClass.NONE || timer>0)		//stops checking if time is up
				return;
				
			if (firstCard.faceFrame==secondCard.faceFrame) //if a match results
			{
				var newMarkRight:mark=new mark(this,new right(),markPosition.x,markPosition.y,markTime);
						
				if (!firstCard.removed)
					removeChild(firstCard);
				if (!secondCard.removed)
					removeChild(secondCard);
				
				firstCard.removed=true;
				secondCard.removed=true;
				
				firstCard=null;
				secondCard=null;
				
				cardLeft-=2;				
				
				if (cardLeft==2)
				{
					cardLeft=0;
				}
				if (cardLeft==0)
				{
					removeCardsAll(true);
					numberOfCorrectAnswers++;
					numberOfQuestions++;
				}							
			}
			else
			{
				var newMarkWrong:mark=new mark(this,new wrong(),markPosition.x,markPosition.y,markTime);
				
				firstCard.flipBack(flipMatch);
				secondCard.flipBack(flipMatch);					
					
				firstCard=null;
				secondCard=null;
				
				numberOfQuestions++;	//to prevent perfect if user made a mistake
			}	
		}
		private function removeCardsAll(toContinue:Boolean)
		{
			removeHandlersMemo();	//to clean up event handler 
			
			if (playCard==null)
				return;
			
			for (var i:uint=0; i<playCard.length; i++) //removing cards
			{
				if (!playCard[i].removed && playCard[i].added)
				{
					playCard[i].removeEventListener(MouseEvent.CLICK,cardClick);
					removeChild(playCard[i]);
				}
			}
			
			if (timer<0 && toContinue)
				createCards();
		}
		private function removeHandlersMemo() //cleaning up event handlers
		{
			if (handlerAdded)
			{
				handlerAdded=false;
				stage.removeEventListener(MouseEvent.MOUSE_UP,beginMemoGameMatch);
				cardFlipping.stop();
				cardFlipping.removeEventListener(TimerEvent.TIMER,beginMemoGameMatch);
			}
		}			
//------------------------------------------------------------------------------------order cards (8th)
		private function setupCardArray()
		{		
			matchCard.imageIndex=Math.floor(Math.random()*9+15);	
			currentAnswer=0;	//current order of the card being answered starting from left			
			cardArray=new Array();
			
			for (var i:uint=0; i<totalCardToPickFrom; i++)
				cardArray.push(i);
				
			constructCards();
		}
		private function constructCards()	//create answer cards and choice cards
		{	
			var position:uint=1;
			var answerCardNum:uint;
			
			if (timer/totalTimePerGame>.7)  //adjust difficulty according to available time
				answerCardNum=Math.round(Math.random()*1+2);
			else if (timer/totalTimePerGame>.4) 
				answerCardNum=Math.round(Math.random()*2+2);				
			else
				answerCardNum=Math.floor(Math.random()*1+3);	
							
			playCard=new Array();
			usedThisCards=new Array();
			showedCards=new Array();	//represents answer cards
						
			while (cardArray.length>=answerCardNum) //setting up answer cards
			{
				var randIndex=Math.floor(Math.random()*cardArray.length);
				var newCard2:MovieClip=new matchCard();
				var newCard3:MovieClip=new matchCard();
				
				newCard2.faceFrame=cardArray[randIndex];
				newCard3.faceFrame=cardArray[randIndex];
			
				addChild(newCard3);
				newCard3.added=true;
							
				animateCards(newCard3,position); 		//animate the entrance
				
				position++;	//marking the order of the cards
				
				showedCards.push(newCard3);	//an array for storing answers
				playCard.push(newCard2);
				usedThisCards.push(cardArray[randIndex]);
				
				cardArray.splice(randIndex,1);				
			}			
			while (cardArray.length>0) //putting random cards into potential answers
			{
				var randIndex2=Math.floor(Math.random()*cardArray.length);
				var newCard:MovieClip=new matchCard();
				newCard.faceFrame=cardArray[randIndex2];
				
				playCard.push(newCard);
				cardArray.splice(randIndex2,1);				
			}		
			
			var TimerTimer:Timer=new Timer(answerCardNum*850,1);		
			TimerTimer.addEventListener(TimerEvent.TIMER,startCounting);
			TimerTimer.start();				
		}
		private function startCounting(event:Event)
		{
			if (timer<0 && subMode!=modeClass.NONE)
			{									
				toolBar.gameInfo.text="Click To Begin";				//player has 2 choice, wait or mouseclick to begin immediately
				cardFlipping=new Timer(timeToMemorizeCard,1);
				cardFlipping.addEventListener(TimerEvent.TIMER,beginMemoGameOrder);					
				stage.addEventListener(MouseEvent.MOUSE_UP,beginMemoGameOrder);
				cardFlipping.start();
				handlerAdded=true;				
			}
		}
		private	function beginMemoGameOrder(event:Event) //flip the cards back and start the game
		{
			removeHandlersOrder();			
			toolBar.gameInfo.text="";
					
			for (var i:uint=0; i<showedCards.length; i++)
				showedCards[i].flipBack(flipOrder);
							
			showChoice();			
		}	
		private function animateCards(cardMC,order) //for the entrance animation of the cards
		{
			var startX:int=-13;
			var startY:uint=750;
			var spacingX:uint=50;
			
			var endY:uint=150;
			var midY:uint=300;
			
			var startScale:Number=.3;
			var endScale:int=1;			
			
			var delayCount:Number=.5;
			
			var endX=startX+order*(cardMC.width+spacingX);
			
			cardMC.x=stage.stageWidth/2;					//center the card
			cardMC.y=startY;
			cardMC.scaleX=startScale;
			cardMC.scaleY=Math.abs(startScale);
			
			Tweener.addTween(cardMC,{y:midY,time:timeToAnimateCards,delay:delayCount*order});			
			Tweener.addTween(cardMC,{scaleX:endScale,scaleY:Math.abs(endScale),delay:delayCount*order*1.3,time:timeToAnimateCards/2,transition:"easInOutElastic",onComplete:animateCardsPart2,onCompleteParams:[endY,endX,cardMC]});		
						
			cardMC.flip(flipOrder);			
		}
		private function animateCardsPart2(endY,endX,cardMC)	//part 2 of the animation
		{
			Tweener.addTween(cardMC,{y:endY, x:endX,time:timeToAnimateCards});			
		}
		private function showChoice() //put potential answer onto the stage
		{	
			var startX=100;
			var startY=300;
			var spacingX=25;
			var startScale=.5;
			var endScale=1;	
			
			playCard.sort(shuffle); //randomly shuffling the cards
			
			for (var i:uint=0; i<totalCardToPickFrom; i++)
			{
				playCard[i].x=startX+i*(playCard[i].width+spacingX);
				playCard[i].scaleX=startScale;
				playCard[i].scaleY=startScale;
				playCard[i].y=startY;
				
				playCard[i].addEventListener(MouseEvent.CLICK,checkAnswerShowCard);
				Tweener.addTween(playCard[i],{scaleX:endScale,scaleY:endScale,time:timeToAnimateCards});				
														
				addChild(playCard[i]);
				playCard[i].flip(flipOrder);
				playCard[i].added=true;	
			}					
		}
		private function checkAnswerShowCard(event:MouseEvent) 	//checking whether the clicked card is the right card
		{
			var obj=event.target as matchCard;
			var found=false;
			var timeToDisappear:uint=1;
			
			if (obj.faceFrame==usedThisCards[currentAnswer])	//if it is, set found equal to true to play animation
			{
				found=true;
				currentAnswer++;
			}
				
			if (found)
				showedCards[currentAnswer-1].flip(flipOrder);
			else
			{
				var showedCardWrong:mark=new mark(this,new wrong(),markPosition.x,markPosition.y,markTime);
				numberOfQuestions++;
		
				flipOverAllCards();				
			}
						
			if (currentAnswer==usedThisCards.length)
			{
				var showedCardRight:mark=new mark(this,new right(),markPosition.x,markPosition.y,markTime);
				
				cleanupShowCard(true);
				
				numberOfQuestions++;
				numberOfCorrectAnswers++;				
			}			
		}
		private function flipOverAllCards()						//allows the player to see all the card before starting again
		{
			for (var i:uint=0; i<showedCards.length; i++)
				if (showedCards[i].currentFrame==matchCard.BACK_FACE)
					showedCards[i].flip(flipOrder);				
			
			for (var j:uint=0; j<playCard.length; j++)
				playCard[j].removeEventListener(MouseEvent.CLICK,checkAnswerShowCard);
				
			checkAnswerTimer=new Timer(timeToShowCorrectAnswer*1000);
			checkAnswerTimer.addEventListener(TimerEvent.TIMER,insetFunction);
			checkAnswerTimer.start();
			
			function insetFunction(event:Event)
			{
				checkAnswerTimer.stop();
				checkAnswerTimer.removeEventListener(TimerEvent.TIMER,insetFunction);
				cleanupShowCard(true);	
			}
		}
		private function cleanupShowCard(toContinue:Boolean)
		{		
			removeHandlersOrder();	//to clean event handler
			
			if (playCard==null)
				return;
			
			for (var i:uint=0; i<playCard.length; i++)
				if (playCard[i].added) //if not yet removed
				{
					removeChild(playCard[i]);
					playCard[i].added=false;
				}
			for (var j:uint=0; j<showedCards.length; j++)
					if (showedCards[j].added) 
					{
						removeChild(showedCards[j]);
						showedCards.added=false;
					}
					
			if (timer<0 && toContinue)
				setupCardArray();			
		}
		private function removeHandlersOrder()
		{
			if (handlerAdded)
			{
				handlerAdded=false;
				stage.removeEventListener(MouseEvent.MOUSE_UP,beginMemoGameOrder);
				cardFlipping.stop();	
				cardFlipping.removeEventListener(TimerEvent.TIMER,beginMemoGameOrder);
			}
		}
//------------------------------------------------------------------------------------memorize how many of each items (count items)
		private function setupCountItems()
		{
			var randNumberOfObj:uint;
			
			if (timer/totalTimePerGame>.7)  //adjust difficulty according to available time
				randNumberOfObj=Math.round(Math.random()*2+3);
			else if (timer/totalTimePerGame>.4) 
				randNumberOfObj=Math.round(Math.random()*3+4);				
			else
				randNumberOfObj=Math.floor(Math.random()*4+5);	
				
			countItemArray=new Array();
			addPlate();	//main mc for holding graphic assets
					
			for (var i:uint=0; i<randNumberOfObj; i++)
			{
				var temp:MovieClip=new countItem();
				temp.x=stage.stageWidth/2;
				temp.y=stage.stageHeight/2;
				temp.gotoAndStop(getCountItemFrame());
								
				countItemArray.push(temp);				
			}
			
			ansString=String(Math.floor(Math.random()*countItemArray.length));	//getting the answer 
			
			countupAnswer();	
			animateCountItems();
		}
		private function setupCountItemText() //setting the position of answer field
		{
			answerField=new TextField();
			answerField.selectable=false;
			answerField.x=280;
			answerField.y=75;
			answerField.width=85;
			answerField.height=85;
			answerField.defaultTextFormat=getDefaultFormat();
			answerField.text="";
			stage.addChild(answerField);	
		}
		private function addPlate()	//main graphic holder for easy cleanup later
		{
			graphicPlate=new Sprite();
			addChild(graphicPlate);
		}
		private function getCountItemFrame():uint	//get random frames
		{
			var tempFrameGetter:MovieClip=new countItem();
			var tempFrame:uint=Math.floor(Math.random()*tempFrameGetter.totalFrames+1);//generate random frame
			return tempFrame; 
		}
		private function countupAnswer()	//get the answers
		{
			var tempFrame=countItemArray[ansString].currentFrame;
			
			ansCount=0;		
			
			for (var i:uint=0; i<countItemArray.length; i++)
				if (tempFrame==countItemArray[i].currentFrame)
					ansCount++;
		}
		private function animateCountItems()
		{
			var answerMC:MovieClip=new countItem();
			
			answerMC.gotoAndStop(countItemArray[int(ansString)].currentFrame)
			answerMC.name="answer";
			answerMC.x=350;
			answerMC.y=480;
			addChild(answerMC);
			answerMCRemoved=false;
			toolBar.gameInfo.text="Count";
			
			var animationTimer:Timer=new Timer(1000);
			animationTimer.addEventListener(TimerEvent.TIMER,startAnimation);
			animationTimer.start();
			
			function startAnimation(event:Event)
			{
				animationTimer.stop();				
				animationTimer.removeEventListener(TimerEvent.TIMER_COMPLETE,startAnimation);
				
				if (!answerMCRemoved)
				{
					removeChild(answerMC);
					answerMCRemoved=true;
				}
				
				toolBar.gameInfo.text="";
				
				if (timer>0 || subMode==modeClass.NONE)
					return;								
				
				if (timer/totalTimePerGame>.7) //as time left decreases, difficulty increaes
					alphaMode();
				else if (timer/totalTimePerGame>.4) 
					linearMode();				
				else
					fallMode();
			}		
		}		
		private function linearMode()
		{
			var startXLeft=-150;
			var startXRight=900;
			var startYLeft=250;
			var startYRight=150;
			
			var spacingX=70;
			var j:uint=0;
			
			loop(j,Math.floor(countItemArray.length/2),startXLeft,startXRight,startYLeft);	//make the item animate from left
			j=Math.floor(countItemArray.length/2)-1;				
			loop(j,countItemArray.length,startXRight,startXLeft,startYRight);	//...right
			
			addEventListener(Event.ENTER_FRAME,startQuestion);
			
			function loop(iStart,iEnd,startX,endX,startY)
			{
				var sign;
				var counter=iEnd;
				
				if (startX>0)
					sign=1;
				else
					sign=-1;					
				
				for (var i:uint=iStart; i<iEnd; i++)
				{
					countItemArray[i].x=startX+i*spacingX*sign;
					countItemArray[i].y=startY;
					graphicPlate.addChild(countItemArray[i]);
					Tweener.addTween(countItemArray[i],{x:endX+(-counter--)*spacingX*sign,time:timeToMemorizeItems,transition:"linear"});
				}		
			}			
		}
		private function alphaMode()	//expand and becoming less
		{
			var startX=220;
			var startY=150;			
			var startScale=.2;
			var endScale=1.5;			
			var spacing=70;			
			var counter=0;
						
			for (var i:uint=0; i<countItemArray.length; i++)
			{	
				countItemArray[i].scaleX=startScale;
				countItemArray[i].scaleY=startScale;			
				
				if (i>=countItemArray.length/2)
				{	
					countItemArray[i].x=startX+spacing*counter;
					countItemArray[i].y=startY;
					counter++;
				}
				else
				{
					countItemArray[i].y=startY*1.5;
					countItemArray[i].x=startX+spacing*i;
				}
			
				graphicPlate.addChild(countItemArray[i]);
				Tweener.addTween(countItemArray[i],{alpha:0,scaleX:endScale,scaleY:endScale,time:timeToMemorizeItems,transition:"linear"});
			}		
			
			addEventListener(Event.ENTER_FRAME,startQuestion);
		}
		private function fallMode()	//simulate falling down
		{				
			counterArray=new Array();
			
			var startXLeft=650;
			var startY=50;		
			var startXRight=50;
			var spacing=100;
			var counter=0;
			
			for (var i:uint=0; i<countItemArray.length; i++)
			{
				var speedObj:Object=new Object();
				
				speedObj.dy=-Math.round(Math.random()*3+3);
				speedObj.dx=Math.round(Math.random()*3+5);
				
				if (i>=countItemArray.length/2)
				{	
					countItemArray[i].x=startXRight;
					countItemArray[i].y=startY+spacing*counter;
					counter++;
				}
				else
				{
					countItemArray[i].y=startY*1.5;
					countItemArray[i].x=startXLeft+spacing*i;
				}		
				
				counterArray.push(speedObj);
				
				graphicPlate.addChild(countItemArray[i]);
				Tweener.addTween(countItemArray[i],{alpha:.5,time:timeToMemorizeItems,transition:"linear"});
			}
			
			addEventListener(Event.ENTER_FRAME,fallDown);
			addEventListener(Event.ENTER_FRAME,startQuestion);			
		}			
		private	function fallDown(event:Event)
		{
			for (var i:uint=0; i<countItemArray.length; i++)
			{
				if (i>=countItemArray.length/2)
				{	
					countItemArray[i].x+=counterArray[i].dx;
					countItemArray[i].y+=counterArray[i].dy;
					counterArray[i].dy+=gravityPullForItemCount;
				}
				else
				{
					countItemArray[i].x-=counterArray[i].dx;
					countItemArray[i].y+=counterArray[i].dy;
					counterArray[i].dy+=gravityPullForItemCount;
				}
				
				countItemArray[i].rotation++;				
			}
		}
		private function checkCountItemAnswer()
		{
			attempted=false;			
			
			if (answerField.text==String(ansCount))
			{
				var countItemMarkRight:mark=new mark(this,new right(),markPosition.x,markPosition.y,markTime);
				numberOfCorrectAnswers++;
				numberOfQuestions++;
				cleanupCountAnswer(true);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME,startQuestion);				
				var countItemMarkWrong:mark=new mark(this,new wrong(),markPosition.x,markPosition.y,markTime);
				showCorrectAnswer(String(ansCount));			
			}						
		}
		private function cleanupCountAnswer(toContinue:Boolean)
		{
			removeEventListener(Event.ENTER_FRAME,startQuestion);
			removeEventListener(Event.ENTER_FRAME,fallDown);
			
			removeChild(graphicPlate);		
			toolBar.gameInfo.text="";
			answerField.text="";		
			
			removeNumKey(false);	//false means don't remove textfield at this time
	
			if (!answerMCRemoved)
			{
				removeChild(getChildByName("answer"));
				answerMCRemoved=true;
			}			
			
			if (timer<0 && toContinue)
				setupCountItems();			
		}
//==========================================================================================================================analytical game
//-------------------------------------------------------------------------------------weight question (5th)
		private function setupWeightAndSeesaw() //creates distinct number of objects with different weight
		{			
			weightObj.imageIndex=Math.floor(Math.random()*8+1);
			seesaw.numOfSeesaw=1;
			
			var numItems:uint=0;		
					
			seesawArray=new Array();
		
			if (timer/totalTimePerGame>.7) //if time > 80%, create 1 seesaw
				numItems=2; //2 items
			else if (timer/totalTimePerGame>.4) //create 2 seesaw
				numItems=Math.round(Math.random()*1+2);				
			else
				numItems=4;
				
			for (var i:uint=0; i<numItems-1; i++) //setting up the seesaw
			{
				var seesawMC2:MovieClip=new seesaw(); //creating 1 seesaw
				addChild(seesawMC2);
				seesawArray.push(seesawMC2);			
			}
			
			generateRandomWeight(numItems);			//initialize the weights of each item
			makeObjects(numItems);			
		}
		private function generateRandomWeight(numItems)
		{
			var counter=0;
			weightIndexArray=new Array();
			
			while (counter<numItems)
			{
				var tempWeight=Math.floor(Math.random()*12+1);		
				checkForDuplicatesWeight(tempWeight);	//to make sure no duplicate is selected
				counter++;
			}
		}
		private function checkForDuplicatesWeight(tempWeight)
		{	
			var temp=tempWeight;
			var fixed:Boolean=false;
			
			if (weightIndexArray.length==0)
				weightIndexArray.push(tempWeight);
			else
			{
				while(!fixed)
					goThroughArray();
				
				weightIndexArray.push(temp);
			}
			
			function goThroughArray()
			{
				fixed=true; //assume no duplicate from the beginning
				
				for (var i:int=weightIndexArray.length-1; i>=0; i--)
				{
					if (weightIndexArray[i]==temp)
					{
						fixed=false;
						temp=Math.floor(Math.random()*12+1);
						break;
					}
				}				
			}
		}
		private function makeObjects(numItems:uint) //creates an array of those objects containing weight info
		{		
			var tempArray:Array=new Array();
			weightObjArray=new Array();	
			
			for (var i:uint=0; i<numItems; i++) //seesawArray and weightObjarray are not compatible
			{
				var randIndex:uint=Math.floor(Math.random()*weightIndexArray.length);
				var temp:MovieClip=new weightObj(i,weightIndexArray[randIndex]);	//i is the frame, the 2nd parameter is the weight
				var temp2:MovieClip=new weightObj(i,weightIndexArray[randIndex]);
				
				weightIndexArray.splice(randIndex,1);										
				weightObjArray.push(temp.obj);
				tempArray.push(temp2.obj);
			}			
		
			tempArray.sortOn("weight",16); //an copy array
			weightObjArray.sortOn("weight",16); //sorts the array to get the heaviest to the last array position
			setupSeesaw(numItems,tempArray);
			placeClickableIcon();								
		}		
		private function setupSeesaw(numItems:uint,tempArray:Array) //puts objects onto seesaw
		{
			var last=tempArray.length;
			
			setuplinkArray(numItems);
			
			//given n items, must do comparison between n & n-1, n-1 & n-2 ... 
			//until n==1; linkArray.length==seesawArray.length && each seesaw makes 1 link
			for (var i:uint=1; i<tempArray.length;)
			{
				var z:uint=Math.floor(Math.random()*linkArray.length); //to randomly put things on the seesaw
				
				if (!linkArray[z])
				{
					var placeHolder1:MovieClip=new weightObj(tempArray[last-i].mc.currentFrame-weightObj.imageIndex,tempArray[last-i].weight);
					i++;
					var placeHolder2:MovieClip=new weightObj(tempArray[last-i].mc.currentFrame-weightObj.imageIndex,tempArray[last-i].weight);
					
					if (Math.random()>.5) //randomly switching the objects to increase variety
					{	
						var temp=placeHolder1;
						placeHolder1=placeHolder2;
						placeHolder2=temp;
					}
					
					putOnseesaw(placeHolder1.obj,placeHolder2.obj,z);
					linkArray[z]=true; //link established
				}
			}			
			
			for (var k:uint=0; k<seesawArray.length; k++)
				seesawArray[k].sway();
	
			return;		
		}
		private function setuplinkArray(numItems:uint) //for making sure enough comparison between weights are done
		{
			linkArray=new Array();
		
			for (var i:uint=0; i<numItems-1; i++)
				linkArray.push(false);
		}
		private function putOnseesaw(obj1,obj2,seesawNum) //putting objects onto seesaw using another class
		{
			seesawArray[seesawNum].addItemsRight(obj1);
			seesawArray[seesawNum].addItemsLeft(obj2);
				
			if (obj1.weight>obj2.weight && (obj1.weight/obj2.weight>=2))
			{
				for (var i:uint=1; i<Math.floor(obj1.weight/obj2.weight); i++)
				{
					var temp=new weightObj(obj2.mc.currentFrame-weightObj.imageIndex,obj2.weight);
					seesawArray[seesawNum].addItemsLeft(temp.obj);
				}
			}
			else if (obj2.weight>obj1.weight && obj2.weight/obj1.weight>=2)
			{
				for (var j:uint=1; j<Math.floor(obj2.weight/obj1.weight); j++)
				{	
					var temp2=new weightObj(obj1.mc.currentFrame-weightObj.imageIndex,obj1.weight);
					seesawArray[seesawNum].addItemsRight(temp2.obj);
				}
			}				
		}
		private function placeClickableIcon() //show choices
		{
			var startX=130;
			var startY=490;
			var spacingX=125;
			var numIcon=0;
			
			answerWeight=weightObjArray[weightObjArray.length-1].weight;
			
			while (weightObjArray.length>0)
			{
				var randIndex:uint=Math.floor(Math.random()*weightObjArray.length);
				var frameToJump:uint=weightObjArray[randIndex].mc.currentFrame-weightObj.imageIndex;
				
				var newMC=new weightObj(frameToJump);
				
				newMC.scaleX=1.5; //cosmetic effects
				newMC.scaleY=1.5;
				
				newMC.x=startX+numIcon*spacingX;	//setting the positions
				newMC.y=startY;
				newMC.name=weightObjArray[randIndex].weight;
				
				newMC.addEventListener(MouseEvent.CLICK,checkAnswerWeight);
				newMC.addEventListener(MouseEvent.ROLL_OVER,rollOver);	//for cosmetic touches later
				newMC.addEventListener(MouseEvent.ROLL_OVER,rollOut);
				
				newMC.buttonMode=true;
								
				weightObjArray.splice(randIndex,1); //removing the item to prevent duplicate
				numIcon++;
				
				addChild(newMC);				
				seesawArray.push(newMC); //to aid in cleanup later
			}
			return;
		}
		private function rollOver(event:Event) //for clickable icons
		{
			//not used yet
		}
		private function rollOut(event:Event)  //for clickable icons
		{
			//not used yet
		}
		private function checkAnswerWeight(event:MouseEvent)
		{
			var answer=event.target as MovieClip;
		
			if (answer.name==String(answerWeight)) //if heaviest picked
			{
				var WeightRight:mark=new mark(this,new right(),markPosition.x,markPosition.y,markTime);
				numberOfCorrectAnswers++;
				numberOfQuestions++;
				cleanupWeightGame(true);
			}
			else	//show the x mark and circle the right answer for the player
			{
				var WeightWrong:mark=new mark(this,new wrong(),markPosition.x,markPosition.y,markTime);
				var tempCircle:MovieClip=new correctAnswerCircle();
		
				for (var i:uint=0; i<seesawArray.length; i++)
					seesawArray[i].removeEventListener(MouseEvent.CLICK,checkAnswerWeight);
		
				numberOfQuestions++;
						
				tempCircle.x=getChildByName(String(answerWeight)).x;
				tempCircle.y=getChildByName(String(answerWeight)).y;
				
				addChild(tempCircle);				
				seesawArray.push(tempCircle);				
				
				checkAnswerTimer=new Timer(timeToShowCorrectAnswer*1000);
				checkAnswerTimer.addEventListener(TimerEvent.TIMER,insetFunction);
				checkAnswerTimer.start();
				
				function insetFunction(event:Event)
				{
					checkAnswerTimer.stop();
					checkAnswerTimer.removeEventListener(TimerEvent.TIMER,insetFunction);
					cleanupWeightGame(true);	
				}
			}
		}
		private function cleanupWeightGame(toContinue:Boolean)
		{		
			if (seesawArray.length==0)
				return;
					
			for (var j:uint=0; j<seesawArray.length; j++)
				removeChild(seesawArray[j]);
				
			if (timer<0 && toContinue)	
				setupWeightAndSeesaw();	
		}
//-------------------------------------------------------------------------------------brickQs (7th)
		private function makeCubes()
		{
			answerString="";
			answerField.text="";	
			
			newCubeStack=new cube3D(this);						
		}
		private function setupKeypad()
		{
			var startX=310;
			var startY=80;	
			
			setupNumkeys(startX,startY,true);	//for numpads for answering Qs
			setupCubeText();
		}
		private function setupCubeText()
		{
			answerField=new TextField();
			answerField.selectable=false;
			answerField.x=390;
			answerField.y=375;
			answerField.width=85;
			answerField.height=85;
			answerField.defaultTextFormat=getDefaultFormat();
			
			answerField.text="";
			answerString="";
			attempted=false;
			
			stage.addChild(answerField);	
			
			addEventListener(Event.ENTER_FRAME,startQuestion);
		}
		private function checkAnswerCube()
		{
			attempted=false;
			
			if (answerField.text==String(cube3D.numberOfCubes))
			{
				var BrickRight:mark=new mark(this,new right(),markPosition.x,markPosition.y,markTime);
				numberOfCorrectAnswers++;
				
				answerString="";
				numberOfQuestions++;				
				cleanupCube(true);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME,startQuestion);
				
				var BrickWrong:mark=new mark(this,new wrong(),markPosition.x,markPosition.y,markTime);				
				showCorrectAnswer(String(cube3D.numberOfCubes));
			}			
		}
		private function cleanupCube(toCreate:Boolean)
		{
			newCubeStack.cleanupCubes();			
			answerString="";
			answerField.text="";
			
			if (timer<0 && toCreate)
				makeCubes();
		}
//=============================================================================================================================eye coordination 
//-------------------------------------------------------------------------------------series QS (2nd) NOTES: need to add shrink
		private function createBoulder()
		{
			var	pointArray:Array=[new Point(75,75),new Point(500,75), new Point(75,400), new Point(500,400), new Point(300,250)];	//potential starting place for placing the boulder
			var numberOfRocks:uint;
			
			boulderArray=new Array();
			valueChain.magArray=new Array();
			
			if (timer/totalTimePerGame>.7)  //adjust difficulty according to available time
				numberOfRocks=Math.round(Math.random()*1+2);
			else if (timer/totalTimePerGame>.4) 
				numberOfRocks=Math.round(Math.random()*2+2);				
			else
				numberOfRocks=Math.floor(Math.random()*2+3);			
			
			for (var i:uint=0; i<numberOfRocks; i++)
			{
				var newRock:MovieClip=new rock();	//actual rock mc
				var newChain:valueChain=new valueChain();	//the class governing the behaviour of the rock
				var rand=Math.floor(Math.random()*pointArray.length);	//for choosing starting place for the rock
				var currPoint:Point=pointArray[rand];	
				
				pointArray.splice(rand,1);	//removing the start position selected to prevent duplicates
								
				boulderArray.push(newChain.generateRock(newRock));
				boulderArray[i].mc.addEventListener(MouseEvent.CLICK,checkSeries);
				
				newRock.x=currPoint.x;
				newRock.y=currPoint.y;			
				
				addChild(newRock);
			}		
		
			shuffleArray();	///to shuffle the array to order the answers
			addEventListener(Event.ENTER_FRAME,startQuestion);
		}
		private function shuffleArray()
		{
			boulderArray.sortOn("mag",16); //sorting according to magnitude; 16 represents numeric sorting
		}
		private function checkSeries(event:Event)
		{
			var obj=event.target as MovieClip;
			
			if (obj.value.text==String(boulderArray[0].mag))
				checkRight();			
			else 
				checkWrong();			
		}
		private function checkRight()
		{
			var temp=boulderArray[0].mc;
			Tweener.addTween(boulderArray[0].mc,{alpha:0,scaleX:0,scaleY:0,time:1,onComplete:removeME,onCompleteParams:[temp]});
			boulderArray.splice(0,1);
			shuffleArray();
			
			if (boulderArray.length==1) //if only 1 left, user has it right
			{
				removeChild(boulderArray[0].mc);
				boulderArray.splice(0,1);
			}
			if (boulderArray.length==0)
			{
				var newY:mark=new mark(this,new right(),markPosition.x,markPosition.y,markTime/3);
				removeBoulderAll(true); //parameter means to create if time allows
				
				numberOfQuestions++;
				numberOfCorrectAnswers++;
			}			
		}
		private function checkWrong()
		{
			var newX:mark=new mark(this,new wrong(),markPosition.x,markPosition.y,markTime/3);
				
			numberOfQuestions++;
			removeBoulderAll(true); //parameter means to create if time allows
		}
		private function removeBoulderAll(toContinue:Boolean)
		{					
			for (var i:uint=0; i<boulderArray.length; i++)
				removeChild(boulderArray[i].mc);
				
			if (timer<0 && toContinue)	
				createBoulder();		
		}		
//--------------------------------------------------------------------------------------puzzle Qs (4th)
		private function xmlLoad () //loading the xml file
		{
			xmlLoader=new URLLoader();
			xmlLoader.addEventListener (Event.COMPLETE,loaded);
			xmlLoader.load (new URLRequest(locationOfXML));			
		}
		private function loaded (event:Event) //after loading of xml is complete
		{
			xml=XML(event.target.data);	
			xmlList=xml.children();
			
			var randIndex:uint=Math.floor(xmlList.length()*Math.random()); //getting a random picture
			
			picLoader=new Loader();
			picLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,processBitmap);	
			picLoader.load(new URLRequest(xmlList[randIndex].attribute("source")));					
		}
		private function processBitmap(event:Event)	//after loading of the bitmap is complete
		{
			var image:Bitmap=Bitmap(event.target.loader.content);
			
			pieceWidth = image.width/numPiecesHoriz;	//getting width and height based the predefined number of pieces
			pieceHeight = image.height/numPiecesVert;
		
			getPuzzlePlate();	//main placeholder for all mc
			generatePieces(image.bitmapData);	//generate the puzzle piece
			makeMissingPieces();	//choose random pieces to be missing
			placeAnswerPuzzle();	//show possible choices
		}
		private function generatePieces(image:BitmapData)										
		{			
			piecesArray = new Array();
			copyArray=new Array();	//a copy array to create a copy of the pieces 
			
			for(var x:uint=0;x<numPiecesHoriz;x++)
			{
				for (var y:uint=0;y<numPiecesVert;y++)
				{
					var newPuzzlePiece:Bitmap = new Bitmap(new BitmapData(pieceWidth,pieceHeight));	// create new puzzle piece bitmap and sprite
					newPuzzlePiece.bitmapData.copyPixels(image,new Rectangle(x*pieceWidth,y*pieceHeight,pieceWidth,pieceHeight),new Point(0,0));
			
					var newPuzzlePiece2:Bitmap = new Bitmap(new BitmapData(pieceWidth,pieceHeight)); //a copy to used for answers later
					newPuzzlePiece2.bitmapData.copyPixels(image,new Rectangle(x*pieceWidth,y*pieceHeight,pieceWidth,pieceHeight),new Point(0,0));
					
					var puzzlePiece:Sprite = new Sprite(); // sprite to hold the bitmap data
					puzzlePiece.addChild(newPuzzlePiece);
					puzzlePlate.addChild(puzzlePiece);
					
					var puzzlePiece2:Sprite = new Sprite();
					puzzlePiece2.addChild(newPuzzlePiece2);					
					
					puzzlePiece.x = x*(pieceWidth);	// set location
					puzzlePiece.y = y*(pieceHeight);
					
					var puzzleObject:Object = new Object();// create object to store in array
					puzzleObject.homeLoc = new Point(x,y);
					puzzleObject.piece = puzzlePiece;
					piecesArray.push(puzzleObject);
					
					var puzzleObject2:Object = new Object();// create object to store in array
					puzzleObject2.homeLoc = new Point(x,y);
					puzzleObject2.piece = puzzlePiece2;
					copyArray.push(puzzleObject2);
				}
			}
			
			puzzlePlate.alpha=0;
			puzzlePlate.scaleX=.8; //cosmetic 
			puzzlePlate.scaleY=.8;
			
			Tweener.addTween(puzzlePlate,{alpha:1,time:0.5});			
		}
		private function getPuzzlePlate() //main mc for placing puzzle pieces
		{
			if (timer<0 && subMode!=modeClass.NONE)
			{
				puzzlePlate=new puzzleHolder();
				puzzlePlate.name="pp";
				puzzlePlate.x=puzzlePlateLoc.x;
				puzzlePlate.y=puzzlePlateLoc.y;
				addChild(puzzlePlate);
			}
		}
		private function makeMissingPieces()
		{
			var numOfMissing:uint=Math.round(Math.random()*3+1);
			
			if (timer/totalTimePerGame>.7) //adjust difficulty according to available time
				numOfMissing=Math.round(Math.random()*1+2);
			else if (timer/totalTimePerGame>.4) 
				numOfMissing=Math.round(Math.random()*2+2);				
			else
				numOfMissing=Math.floor(Math.random()*2+3);		
			
			puzzleAnswerArray=new Array();
			missingPiecesArray=new Array();
		
			for (var i:uint=0; i<numOfMissing; i++) //random number of pieces removed
			{
				var randIndex:uint=Math.floor(Math.random()*piecesArray.length);
				var tempPoint:Point=new Point(piecesArray[randIndex].homeLoc.x,piecesArray[randIndex].homeLoc.y);				
		
				copyArray[randIndex].cover=Math.round(totalNumberOfPuzzleOutline/(i+1));
				missingPiecesArray.push(copyArray[randIndex]); //storing the object here
				puzzleAnswerArray.push(tempPoint); //storing the answer
							
				placeMissingCover(tempPoint,i);
								
				piecesArray.splice(randIndex,1); //removing to prevent duplicates 
				copyArray.splice(randIndex,1);	//removing to prevent duplicates
			}
			
			while (missingPiecesArray.length<5) //total of 5 answers options
			{
				var randIndex2:uint=Math.floor(Math.random()*copyArray.length);
				missingPiecesArray.push(copyArray[randIndex2]);
				copyArray.splice(randIndex2,1);
			}
			
			missingPiecesArray.sort(shuffle); //make random orders				
		}
		private function placeMissingCover(tempPoint:Point,i)
		{
			this["cover"+i].gotoAndStop(Math.round(totalNumberOfPuzzleOutline/(i+1)));	//puzzle missing indicator placed on stage
			this["cover"+i].x=tempPoint.x*pieceWidth+pieceWidth/2;
			this["cover"+i].y=tempPoint.y*pieceHeight+pieceHeight/2;
							
			puzzlePlate.addChild(this["cover"+i]);
		}
		private function shuffle(a,b):Number //for shuffling
		{
			var num:Number=Math.round(Math.random()*2)-1;
			return num;
		}
		private function placeAnswerPuzzle() //place the puzzle piece on the stage
		{
			var distanceH=100;
			var startX=-15;
			var startY=400;
			
			for (var i:uint=0; i<missingPiecesArray.length; i++)
			{
				var newSprite:Sprite=new Sprite();
				var maskMC:MovieClip=new unpuzzle();
				
				maskMC.x=pieceWidth/2;					//setting the mask to midpoint
				maskMC.y=pieceHeight/2;					//...
				maskMC.gotoAndStop(missingPiecesArray[i].cover);
							
				newSprite.x=startX+i*distanceH;			//put the actual piece on the stage
				newSprite.y=startY;
				newSprite.addChild(missingPiecesArray[i].piece);
				newSprite.addChild(maskMC);
				newSprite.mask=maskMC;				
				//newSprite.rotation=Math.random()*90;
				
				missingPiecesArray[i].missing=newSprite;
				missingPiecesArray[i].piece.name=i;        //to be used for answer checking later
				missingPiecesArray[i].piece.buttonMode=true;
				missingPiecesArray[i].removed=false;
				
				missingPiecesArray[i].piece.addEventListener(MouseEvent.CLICK,checkAnswerPuzzle);
				puzzlePlate.addChild(newSprite);
			}
		}
		private function checkAnswerPuzzle(event:MouseEvent)
		{
			var index=int(event.target.name);
			var found:Boolean=false;
			
			for (var i:uint=0; i<puzzleAnswerArray.length; i++)
			{
				if (puzzleAnswerArray[i].equals(missingPiecesArray[index].homeLoc)) //if the clicked puzzle is one of the missing piece
				{
					found=true;
					puzzleAnswerArray.splice(i,1);
					break;
				}					
			}
		
			markChoices(found,index);
		}
		private function markChoices(correct:Boolean,index)
		{
			if (correct)	//if right, move the puzzle piece to its default location
			{
				var xLoc=missingPiecesArray[index].homeLoc.x;
				var yLoc=missingPiecesArray[index].homeLoc.y;
						
				missingPiecesArray[index].piece.removeEventListener(MouseEvent.CLICK,checkAnswerPuzzle);
				missingPiecesArray[index].piece.buttonMode=false;		
				Tweener.addTween(missingPiecesArray[index].missing,{rotation:0,x:xLoc*pieceWidth,y:yLoc*pieceHeight,time:timeToAnimatePuzzlePieces});						
			}			
			else
			{
				var PuzzleWrong:mark=new mark(puzzleBase,new wrong(),markPosition.x,markPosition.y,markTime);
				putAllPuzzleBack();
				numberOfQuestions++;				
			}
			
			if (puzzleAnswerArray.length==0 && subMode!=modeClass.NONE && timer<0)
			{
				var PuzzleRight:mark=new mark(puzzleBase,new right(),markPosition.x,markPosition.y,markTime);
				numberOfQuestions++;
				numberOfCorrectAnswers++;
				removePuzzle(true);		
			}
		}
		private function putAllPuzzleBack()							//put all the puzzle pieces back
		{
			for (var i:uint=0; i<missingPiecesArray.length; i++)
			{			
				var xLoc=missingPiecesArray[i].homeLoc.x;
				var yLoc=missingPiecesArray[i].homeLoc.y;
								
				if (missingPiecesArray[i].piece.buttonMode)
				{
					missingPiecesArray[i].piece.buttonMode=false;
					Tweener.addTween(missingPiecesArray[i].missing,{rotation:0,x:xLoc*pieceWidth,y:yLoc*pieceHeight,time:timeToAnimatePuzzlePieces});
					missingPiecesArray[i].piece.removeEventListener(MouseEvent.CLICK,checkAnswerPuzzle);
				}
			}
			
			checkAnswerTimer=new Timer(timeToShowCorrectAnswer*1000);
			checkAnswerTimer.addEventListener(TimerEvent.TIMER,insetFunction);
			checkAnswerTimer.start();
			
			function insetFunction(event:Event)
			{
				checkAnswerTimer.stop();
				checkAnswerTimer.removeEventListener(TimerEvent.TIMER,insetFunction);
				removePuzzle(true);	
			}
		}
		private function removePuzzle(toCreate:Boolean) //cleanup and reload XML is still time
		{			
			if (getChildByName("pp")!=null)			//removing the puzzlePlate 
				removeChild(getChildByName("pp"));
			
			if (timer<0 && toCreate)
				xmlLoad();		
		}
//------------------------------------------------------------------------------------count numbers (9th)
		private function setupNumbers()	//initialize the count digit game
		{
			var randNumOfDigits:uint;
			
			if (timer/totalTimePerGame>.7)  //adjust difficulty according to available time
				randNumOfDigits=Math.round(Math.random()*1+3);
			else if (timer/totalTimePerGame>.4) 
				randNumOfDigits=Math.round(Math.random()*3+3);				
			else
				randNumOfDigits=Math.floor(Math.random()*4+5);		
			
			graphicPlate=new Sprite(); //for holding all the numbers
			countNumArray=new Array(); //to reference the numbers if necessary
			ansCount=0;	//the number of a particular digit
			addChild(graphicPlate);
			
			for (var i:uint=0; i<randNumOfDigits; i++)
			{
				var tempNum:numberCount=new numberCount();
				
				tempNum.numObj.mc.addEventListener(MouseEvent.CLICK,checkAnswerNumCounted);
					
				countNumArray.push(tempNum.numObj); //storing an object		
				graphicPlate.addChild(tempNum.numObj.mc);	
			}
			
			chooseDigitToCount();
			return;
		}
		private function chooseDigitToCount()	//choose the digit to count
		{
			var randIndex:uint=Math.floor(Math.random()*countNumArray.length);
			ansString=countNumArray[randIndex].mc.name;			
			toolBar.gameInfo.text="Count "+ansString;
			
			countAnsNum();
			return;		
		}
		private function countAnsNum()
		{
			var ansAlreadyInArray=false;
			
			for (var i:uint=0; i<countNumArray.length; i++)	//counting the number of times the digit appears
				if (countNumArray[i].numText.text==String(ansString))
					ansCount++;
							
			for (var j:uint=0; j<countNumArray.length; j++)	//seeing if the answer is in the array
				if (String(ansCount)==countNumArray[j].numText.text)
				{
					ansAlreadyInArray=true;
					break;
				}			
		 			
			if (!ansAlreadyInArray)	//if not, make one
				addAnsNum();
		}	
		private function addAnsNum()	//add the answer number when answer digit missing
		{
			var tempObj:MovieClip=new numberCount();
			tempObj.internalValue=ansCount;
			tempObj.numObj.mc.addEventListener(MouseEvent.CLICK,checkAnswerNumCounted);	
			
			graphicPlate.addChild(tempObj.numObj.mc);
			return;
		}
		private function checkAnswerNumCounted(event:MouseEvent)
		{
			var curNum=event.target as Sprite;
			
			if (curNum.getChildAt(0).text==String(ansCount)) //child at 0 is the textfield
			{				
				var countRight:mark=new mark(puzzleBase,new right(),markPosition.x,markPosition.y,markTime);
				numberOfCorrectAnswers++;
				numberOfQuestions++;
				cleanupNum(true);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME,startQuestion);
				var countWrong:mark=new mark(puzzleBase,new wrong(),markPosition.x,markPosition.y,markTime);
				removeDigitListeners();
				
				showCorrectAnswer(String(ansCount));
			}			
		}
		private function removeDigitListeners()
		{
			for (var i:uint=0; i<countNumArray.length; i++)
				countNumArray[i].mc.removeEventListener(MouseEvent.CLICK,checkAnswerNumCounted);
		}
		private function cleanupNum(toContinue:Boolean)
		{
			removeChild(graphicPlate);
			toolBar.gameInfo.text="";
			
			if (timer<0 && toContinue)
				setupNumbers();
				
			return;
		}
//====================================================================================================================================timer
		private function startTimer():void
		{
			timer=totalTimePerGame; //setting time for each stage right here	
			countDown.visible=true; //make clock visible
			
			second=new Timer(1000,0);
			second.addEventListener(TimerEvent.TIMER,timeDisplay);
			second.start();
		}
		private function stopTimer():void
		{
			countDown.visible=false; //hides the clock and stops timer
			second.stop();
			
			second.removeEventListener(TimerEvent.TIMER,timeDisplay);
		}	
		private function timeDisplay(event:Event):void
		{
			timer+=1000; //adding one second
	
			if (timer<0)
			{
				var currentTime:int=Math.abs(Math.floor(timer/1000));
				var timeString:String=String(currentTime);
							
				countDown.timeText.text=timeString;
				
				if (int(timeString)<10)
				{
					if (!Tweener.isTweening(countDown))
						if (toggleAnimation)
						{
							toggleAnimation=!toggleAnimation;
							Tweener.addTween(countDown,{scaleX:1.2,scaleY:1.2,time:.9});
						}
						else
						{
							toggleAnimation=!toggleAnimation;
							Tweener.addTween(countDown,{scaleX:.9,scaleY:.9,time:.9});
						}	
				}
			}
			else
			{
				if (Tweener.isTweening(countDown))
					Tweener.removeTweens(countDown);
				
				timeupFunction();				
					
				countDown.scaleX=1;
				countDown.scaleY=1;
				countDown.timeText.text="00";
				return;				
			}			
			
				function timeupFunction()
				{
					cleanup();		
					
					if (countDown.timeText.text!="00") //so the textfield don't show up more than once
					{
						toolBar.gameInfo.text="Time Up";	
						Tweener.addCaller(new Object,{onUpdate:CONTINUE,delay:1,count:1});		
					}						
				}
				
				function CONTINUE()
				{			
					toolBar.gameInfo.text="";
						
					stage.removeEventListener(MouseEvent.MOUSE_UP,beginMemoGameOrder);	//different eventlistener used in different games
					stage.removeEventListener(MouseEvent.MOUSE_UP,beginMemoGameMatch);							
				
					calculateScore();
					
					if (currentMode==modeClass.BRAIN_TEST)//migrating to next stages
						chooseNextStage(null);					
					else if (currentMode==modeClass.CATEGORY)
						gotoTrial(null);	
				}
						
			return;
		}		
//====================================================================================================================================utility functions
		private function startQuestion(event:Event) //for aiding different mini game by providing a enter_frame function
		{			
			if (subMode==modeClass.MATH_NORMAL)
			{
				if (questionField.text=="")
				{
					answerField.text="";
					answerString="";
					
					var mathQuestion:test=new test(questionField);
					correctAnswer=mathQuestion.MathFunction();
					ansSign=correctAnswer>=0;
					correctAnswer=Math.abs(correctAnswer);
					numberOfQuestions++;
					attempted=false;						
				}
				if (answerTiming++/totalFrameCount>framePercent && attempted) //if waited long enough and user attempted, mark the question
					checkAnswerForMath();
			}
			else if (subMode==modeClass.EYE_ROCK) //checks for rock collision to prevent one from hovering over another
			{
				if (boulderArray!=null)
				for (var k:uint=0; k<boulderArray.length; k++)
				{
					var temp=boulderArray[k].mc;
					
					for (var testing:uint=0; testing<boulderArray.length; testing++)
					{
						if (boulderArray[testing].mc != temp && temp.hitTestObject(boulderArray[testing].mc))
						{
							boulderArray[testing].dx*=-1;
							boulderArray[testing].dy*=-1;
							temp.dy*=-1;
							temp.dx*=-1;
							
							var tempX=boulderArray[testing].x;
							var tempY=boulderArray[testing].y;
							boulderArray[testing].x+=temp.x-boulderArray[testing].x;
							boulderArray[testing].y+=temp.y-boulderArray[testing].y;
						}
					}
				}
			}
			else if (subMode==modeClass.MEMO_MATCH)	//for randomly shuffling cards on the fly while the game is going
			{
				var baseTimer:uint=3500+Math.floor(Math.random()*3000);
				var switchCardTimer:Timer=new Timer(baseTimer,0);	
				switchCardTimer.addEventListener(TimerEvent.TIMER,randomSwitch);
				switchCardTimer.start();			
				
				function randomSwitch(event:TimerEvent)
				{
					var randIndex:uint=Math.floor(Math.random()*playCard.length);
					var randIndex2:uint=Math.floor(Math.random()*playCard.length);
				
					while (randIndex==randIndex2 && !playCard[randIndex].removed && !playCard[randIndex2].removed)
					{	
						randIndex=Math.floor(Math.random()*playCard.length);
						randIndex2=Math.floor(Math.random()*playCard.length);	
					}
					
					var newX=cardPosition[randIndex].x;
					var newY=cardPosition[randIndex].y;
					var newX2=cardPosition[randIndex2].x;
					var newY2=cardPosition[randIndex2].y;
					
					cardPosition[randIndex].x=newX2;
					cardPosition[randIndex].y=newY2;
					cardPosition[randIndex2].x=newX;
					cardPosition[randIndex2].y=newY;
					
					Tweener.addTween(playCard[randIndex],{time:timeToAnimateCards*1.5,x:newX2,y:newY2});
					Tweener.addTween(playCard[randIndex2],{time:timeToAnimateCards*1.5,x:newX,y:newY});
					
					switchCardTimer.stop();
					switchCardTimer.removeEventListener(TimerEvent.TIMER,randomSwitch);
				}			
			}
			else if (subMode==modeClass.MATH_SIGN) //for checking answers
			{
				if (questionField.text=="")
				{
					for (var i:uint=0; i<signArray.length; i++)							//removing handlers to prevent users from halting the game
						signArray[i].addEventListener(MouseEvent.CLICK,returnSign);
				
					var SignQuestion:test=new test(questionField);
					correctSign=SignQuestion.MathSymbol();
					
					numberOfQuestions++;
				}				
			}
			else if (subMode==modeClass.ANA_WEIGHT)
			{
				//not used	
			}
			else if (subMode==modeClass.EYE_PUZZLE)
			{
				//not used
			}
			else if (subMode==modeClass.ANA_CUBE)	//for checking answers
			{
				if (answerTiming++/totalFrameCount>framePercent&& attempted)
					checkAnswerCube();
			}
			else if (subMode==modeClass.MEMO_ORDER)
			{
				//not used
			}
			else if (subMode==modeClass.EYE_DIGIT)
			{
				//not used
			}
			else if (subMode==modeClass.MEMO_ITEM)
			{
				var startX=220;
				var startY=220;
				
				if (!Tweener.isTweening(countItemArray[countItemArray.length-1]) && numpadArray==null)
				{					
					answerField.text="";
					answerString="";
					
					setupCountItemText();
					setupNumkeys(startX,startY);
					attempted=false;
				}
				else if (numpadArray!=null)
				{
					if (answerTiming++/totalFrameCount>framePercent&& attempted)
						checkCountItemAnswer();
				}
			}
			else if (subMode==modeClass.MATH_MISSING)
			{
				if (questionField.text=="")
				{
					answerField.text="";
					answerString="";
					
					var numberMathQuestion:test=new test(questionField);
					correctAnswer=numberMathQuestion.MathAnswer();
					ansSign=correctAnswer>=0;
					correctAnswer=Math.abs(correctAnswer);
					numberOfQuestions++;
					attempted=false;
				}
				if (answerTiming++/totalFrameCount>framePercent && attempted) //if waited long enough and user attempted, mark the question
					numberPlayCheckAnswer();
			}
		}		
//----------------------------------------------------------------------------------------------------------------------score tabulating function			
		private function calculateScore()	//modify this function to change the methodologies of scores calculation
		{
			if (subMode==modeClass.MATH_MISSING || subMode==modeClass.MATH_NORMAL || subMode==modeClass.MATH_SIGN)	//to compensate for the fact that numberOfQ for math is incremented as Q is posed
				numberOfQuestions-=1;
							
			if (currentScore.mode==modeClass.MEMO) //because memory mini game takes longer
				currentScore.score=numberOfQuestions*questWorth+numberOfCorrectAnswers*rightQuestWorth*1.5;
			else
				currentScore.score=numberOfQuestions*questWorth+numberOfCorrectAnswers*rightQuestWorth;
		
			if (numberOfQuestions!==0)
				currentScore.percentage=numberOfCorrectAnswers/numberOfQuestions;
			else
				currentScore.percentage=0;				
			
			noMistakeTrophy(currentScore.mode);			//see if the player achieved a perfect score on a mini-game
			lightningTrophy(currentScore.mode);			//if player answered many Qs
						
			scoreAll.push(currentScore);
			
			if (currentMode==modeClass.CATEGORY)			//quick show of scores in category mode
			{
				catScoreBoard.score.text="Score: "+currentScore.score;
				catScoreBoard.accuracy.text="Accuracy: "+Math.round(100*currentScore.percentage)+"%";												
				Tweener.addTween(catScoreBoard,{x:stage.stageWidth/2,time:timeToAnimateBtns*1.5,transition:tempScoreBoardTransitMode}); 
			}			
		}
		private function recordScore()		//record the scores in different categories
		{		
			var scoresSum:uint=0;
			var percentSum:Number=0;
			
			for (var i:uint=0; i<scoreAll.length; i++)
			{
				scoresSum+=scoreAll[i].score;
				percentSum+=scoreAll[i].percentage;
				
				switch(i)
				{					
					case 0:
					{
						score.scoreBox1.text=scoreAll[i].mode+": "+scoreAll[i].score;
						getRank(score.rank1,scoreAll[i].score,scoreAll[i].mode);
						break;
					}
					case 1:
					{
						score.scoreBox2.text=scoreAll[i].mode+": "+scoreAll[i].score;
						getRank(score.rank2,scoreAll[i].score,scoreAll[i].mode);
						break;
					}
					case 2:
					{
						score.scoreBox3.text=scoreAll[i].mode+": "+scoreAll[i].score;
						getRank(score.rank3,scoreAll[i].score,scoreAll[i].mode);
						break;						
					}
					case 3:
					{
						score.scoreBox4.text=scoreAll[i].mode+": "+scoreAll[i].score;
						getRank(score.rank4,scoreAll[i].score,scoreAll[i].mode);
						break;						
					}					
				}
			}
		
			brainTestOverallRank(scoresSum/4,percentSum/4);
			scoreList.push(scoreAll);									//score list contains all previous scoreAll
			brainTestTrophy(scoreList.length);			//see if the player played many many times	
			scoreAll.splice(0,scoreAll.length);			//cleaning up the score list
		}
		private function getRank(rank_mc,scoreNum,trophyName)	//rank the performance of the player
		{
			var rankLevel:String;
			
			if (scoreNum>=rankAScore)
				rankLevel="A";
			else if (scoreNum>=rankBScore)
				rankLevel="B";
			else if (scoreNum>=rankCScore)
				rankLevel="C";
			else
				rankLevel="D";
				
			rank_mc.gotoAndStop(rankLevel);
			getRankTrophy(rankLevel,trophyName);	//check to see if a rank A cup is won
		}		
		private function brainTestOverallRank(scoresSum,percentSum)
		{
			if (scoresSum>=rankAScore)
				score.overallRank.text="A";
			else if (scoresSum>=rankBScore)
				score.overallRank.text="B";
			else if (scoresSum>=rankCScore)
				score.overallRank.text="C";
			else
				score.overallRank.text="D";
				
			score.accuracyPercent.text="Accuracy: "+Math.round(100*percentSum)+"%";
		}
//-----------------------------------------------------------------------------------------------------------------------------mode/mini-game changing functions		
		private function registerModeChange(event:MouseEvent,user=null)	//for registering the player choice of mini-games
		{
			var obj;
			
			if (event!=null)
				obj=event.target as SimpleButton;
			else
				obj=user;
						
			if (obj.parent.name=="memoBtn")
			{
				catModeChoice.memo=obj.name;				
				if (obj.name==modeClass.MEMO_MATCH)
				{
					buttonAnimation(obj,memoBtn.order,memoBtn.none,memoBtn.item);
				}
				else if (obj.name==modeClass.MEMO_ORDER)
				{
					buttonAnimation(obj,memoBtn.match,memoBtn.none,memoBtn.item);
				}
				else if (obj.name==modeClass.MEMO_ITEM)
				{
					buttonAnimation(obj,memoBtn.match,memoBtn.none,memoBtn.order);
				}
				else		
				{
					catModeChoice.memo=null;
					buttonAnimation(obj,memoBtn.match,memoBtn.order,memoBtn.item);
				}
			}
			else if (obj.parent.name=="mathBtn")
			{
				catModeChoice.math=obj.name;
				if (obj.name==modeClass.MATH_NORMAL)
				{
					buttonAnimation(obj,mathBtn.sign,mathBtn.none,mathBtn.missing);
				}
				else if (obj.name==modeClass.MATH_SIGN)
				{
					buttonAnimation(obj,mathBtn.math,mathBtn.none,mathBtn.missing);
				}
				else if (obj.name==modeClass.MATH_MISSING)
				{
					buttonAnimation(obj,mathBtn.math,mathBtn.none,mathBtn.sign);
				}
				else		
				{
					catModeChoice.math=null;
					buttonAnimation(obj,mathBtn.sign,mathBtn.math,mathBtn.missing);
				}	
			}	
			else if (obj.parent.name=="eyeBtn")
			{
				catModeChoice.eye=obj.name;				
				if (obj.name==modeClass.EYE_ROCK)
				{
					buttonAnimation(obj,eyeBtn.puzzle,eyeBtn.none,eyeBtn.digit);
				}
				else if (obj.name==modeClass.EYE_PUZZLE)
				{
					buttonAnimation(obj,eyeBtn.rock,eyeBtn.none,eyeBtn.digit);
				}
				else if (obj.name==modeClass.EYE_DIGIT)
				{
					buttonAnimation(obj,eyeBtn.rock,eyeBtn.none,eyeBtn.puzzle);
				}
				else
				{
					catModeChoice.eye=null;
					buttonAnimation(obj,eyeBtn.rock,eyeBtn.digit,eyeBtn.puzzle);
				}
			}
			else if (obj.parent.name=="anaBtn")
			{
				catModeChoice.ana=obj.name;
				if (obj.name==modeClass.ANA_CUBE)
				{
					buttonAnimation(obj,anaBtn.weight,anaBtn.none);
				}
				else if (obj.name==modeClass.ANA_WEIGHT)
				{
					buttonAnimation(obj,anaBtn.cube,anaBtn.none);
				}
				else
				{
					catModeChoice.ana=null;
					buttonAnimation(obj,anaBtn.cube,anaBtn.weight);
				}
			}
		}
		private function chooseNextStage(event:Event) //
		{	
			Tweener.addTween(blackboard,{y:blackBoardPosition.y,time:1});	//tweening away the blackboard
												
			if (scoreAll.length<4)	//if less than 4 mini-game played, continue 
				getSubMode();
			else
			{
				recordScore();
				enterMode(modeClass.SCORE);			
			}
			
			if (!addedCont && currentMode!=modeClass.SCORE) //add the continue button if not already added and if not in score mode
				addcontBtn();						
		}
		private function getSubMode()	//random function for choosing the next level; problem here because no 3 mini for each cat
		{
			var chooseGame=Math.round(Math.random()*2+1); //randomly choosing 1 of 3 mini games in each mode
			currentScore=new Object();
			
			if (!anaCatPlayed)
			{
				anaCatPlayed=true;
				currentScore.mode=modeClass.ANA;
				
				if (chooseGame==1)
					subMode=modeClass.ANA_CUBE;
				else if (chooseGame==2)
					subMode=modeClass.ANA_WEIGHT;	
				else
					subMode=modeClass.ANA_WEIGHT;	
			}
			else if (!mathCatPlayed)
			{
				mathCatPlayed=true;
				currentScore.mode=modeClass.MATH;
				
				if (chooseGame==1)
					subMode=modeClass.MATH_NORMAL;
				else if (chooseGame==2)
					subMode=modeClass.MATH_SIGN;
				else
					subMode=modeClass.MATH_MISSING;
			}
			else if (!memoCatPlayed)
			{
				memoCatPlayed=true;
				currentScore.mode=modeClass.MEMO;
				
				if (chooseGame==1)
					subMode=modeClass.MEMO_MATCH;
				else if (chooseGame==2)
					subMode=modeClass.MEMO_ORDER;
				else
					subMode=modeClass.MEMO_ITEM;
			}
			else if (!eyeCatPlayed)
			{
				eyeCatPlayed=true;
				currentScore.mode=modeClass.EYE;
				
				if (chooseGame==1)
					subMode=modeClass.EYE_ROCK;
				else if (chooseGame==2)
					subMode=modeClass.EYE_PUZZLE;
				else
					subMode=modeClass.EYE_DIGIT;
			}			
		}
		
		private function addcontBtn(forceMode:Boolean=false) //stops and show button until the player is ready to begin
		{		
			var delayTime:uint=1; //delay time for animating the start btn
			addedCont=true;	//indicate the start btn is placed on stage
			
			contBtn.x=contBtnPoint.x;	//setting th position of the btn
			contBtn.y=contBtnPoint.y;
			contBtn.alpha=0;
			
			if (!forceMode)	//force mode is enable the btn to be used in cat to continue
			{
				if (currentMode==modeClass.CATEGORY) //category mode
					contBtn.addEventListener(MouseEvent.CLICK,gotoTrial);
				else if (currentMode==modeClass.BRAIN_TEST) //brain test mode
					contBtn.addEventListener(MouseEvent.CLICK,startStageNow);
			}
			else
			{
				contBtn.addEventListener(MouseEvent.CLICK,startStageNow);
			}			
			
			Tweener.addTween(contBtn,{alpha:1,time:timeToAnimateBtns,delay:delayTime});
			
			showExplanationGraphics();
			addChild(contBtn);				
			
			guideRobot.subMode=subMode;		//make sure the robot explains the right game	
			guideRobot.explain=true;		//signal the game has yet to start and provide explanation
			guideRobot.hide=false;			//show robot
		}
		
		private function gotoTrial(event:Event) //for catMode
		{
			removeContBtn(); //remove the continue btn
			SoundEffect.playStage(SoundEffect.START_BTN_SOUND);
			currentScore=new Object();
		
			if (catModeChoice.ana!=null)
			{
				currentScore.mode=modeClass.ANA;
				subMode=catModeChoice.ana;
				catModeChoice.ana=null;
			}
			else if (catModeChoice.math!=null)	//start from math mode and check if any game is chosen
			{
				currentScore.mode=modeClass.MATH;
				subMode=catModeChoice.math;
				catModeChoice.math=null;
			}
			else if (catModeChoice.memo!=null)
			{
				currentScore.mode=modeClass.MEMO;
				subMode=catModeChoice.memo;
				catModeChoice.memo=null;
			}
			else if (catModeChoice.eye!=null)
			{
				currentScore.mode=modeClass.EYE;
				subMode=catModeChoice.eye;
				catModeChoice.eye=null;
			}			
			else
				toolBar.gameInfo.text=modeClass.OVER;
					
			if (toolBar.gameInfo.text==modeClass.OVER)
				Tweener.addTween(back,{x:247,y:240,scaleX:2,scaleY:2,time:1}); //tweening the back button into focus
			else
				addcontBtn(true);	//else, begin the game play	
				
			hideChoiceBar(); //hiding the choice menu							
		}
		private function startStageNow(event:Event) //start counting down to sart the mini-game
		{
			removeContBtn();
			clearSampleGraphics();
			SoundEffect.playStage(SoundEffect.START_BTN_SOUND);				//playing startbtn sound
			Tweener.addTween(catScoreBoard,{x:-stage.stageWidth/2,time:timeToAnimateBtns/2,transition:tempScoreBoardTransitMode})	//tweening away the temp score board
			
			toolBar.gameInfo.text="";
			guideRobot.hide=true;
			guideRobot.explain=false;				//to make sure the player is has clicked on the start game btn so cleanup functions correctly			
						
			back.enabled=false;						//diabling the back btn to prevent game from crashing
			back.removeEventListener(MouseEvent.CLICK,backUp);
			back.alpha=0;
						
			countToThreeTimer=new Timer(1000,3);
			countToThreeTimer.addEventListener(TimerEvent.TIMER,transitionScreen);
			countToThreeTimer.start();							
		}	
		private function transitionScreen(event:Event)
		{
			if (CountToThree.currentFrame>=1 && CountToThree.currentFrame<4)
				CountToThree.gotoAndStop(CountToThree.currentFrame+1);
			
			CountToThree.x=stage.stageWidth/2;
			CountToThree.y=stage.stageHeight/2;
			CountToThree.scaleX=1.5;
			CountToThree.scaleY=1.5;
			
			addChild(CountToThree);
			Tweener.addTween(CountToThree,{scaleX:1,scaleY:1,time:.9,onComplete:timeUpYet});
			SoundEffect.playStage(SoundEffect.TIME_SOUND);
			
			function timeUpYet()
			{
				if (CountToThree.currentFrame==4)
				{
					SoundEffect.stopStage();
										
					countToThreeTimer.removeEventListener(TimerEvent.TIMER,transitionScreen);
					countToThreeTimer.stop();			
					
					CountToThree.gotoAndStop(1);
					removeChild(CountToThree);
					
					SoundEffect.chooseBGSound(subMode);		//choose background sound depeding on the submode (ie what mini-games)
				
					back.enabled=true;						//reenable the back btn
					back.addEventListener(MouseEvent.CLICK,backUp);
					back.alpha=1;
					
					initializeGameNow(); //start the actual mini-game
				}
			}			
		}
		private	function initializeGameNow()
		{			
			if (subMode==modeClass.MATH_NORMAL)
				firstTrial();
			else if (subMode==modeClass.MATH_MISSING)
				eleventhTrial();
			else if (subMode==modeClass.MATH_SIGN)
				fourthTrial();
					
			else if (subMode==modeClass.EYE_ROCK)
				secondTrial();
			else if (subMode==modeClass.EYE_PUZZLE)
				sixthTrial();
			else if (subMode==modeClass.EYE_DIGIT)
				ninthTrial();
			
			else if (subMode==modeClass.MEMO_MATCH)
				thirdTrial();
			else if (subMode==modeClass.MEMO_ORDER)
				eighthTrial();
			else if (subMode==modeClass.MEMO_ITEM)
				tenthTrial();
			
			else if (subMode==modeClass.ANA_WEIGHT)
				fifthTrial();			
			else if (subMode==modeClass.ANA_CUBE)
				seventhTrial();	
		}	
//------------------------------------------------------------------------------------------------------------------------mini-game help function
		private function setupNumkeys(startX,startY,clearEnabled:Boolean=false,minusEnabled:Boolean=false,demo:Boolean=false) //setting up numeric answer keys
		{		
			var currentNum:uint=1;						
			numpadArray=new Array();
						
			for (var i:uint=0; i<3; i++)
			{				
				for (var j:uint=0; j<3; j++)
				{
					var newPad:MovieClip=new numKey();
					newPad.mouseChildren=false;
					newPad.buttonMode=true;
										
					newPad.addEventListener(MouseEvent.CLICK,returnNum);
					newPad.addEventListener(MouseEvent.MOUSE_OUT,numOut);
					newPad.addEventListener(MouseEvent.MOUSE_DOWN,numDown);
					newPad.addEventListener(MouseEvent.MOUSE_OVER,numOver);				
									
					newPad.x=startX+newPad.width*j;
					newPad.y=startY+newPad.height*i;
					newPad.textBox.text=currentNum++;
					newPad.name=String(currentNum-1);
					
					if (!demo)
						stage.addChild(newPad);
					else
						puzzleBase.addChild(newPad);	
									
					numpadArray.push(newPad);					
				}				
			}
			
			//zero btn
			var newPad0:MovieClip=new numKey();
			newPad0.mouseChildren=false;			
			newPad0.buttonMode=true;			
			newPad0.x=startX+newPad0.width;
			newPad0.y=startY+newPad0.height*3
			newPad0.textBox.text="0";		
			newPad0.name="0";		
			newPad0.addEventListener(MouseEvent.CLICK,returnNum);
			newPad0.addEventListener(MouseEvent.MOUSE_DOWN,numDown);
			newPad0.addEventListener(MouseEvent.MOUSE_OVER,numOver);	
			newPad0.addEventListener(MouseEvent.MOUSE_OUT,numOut);		
			
			if (!demo)
				stage.addChild(newPad0);
			else
				puzzleBase.addChild(newPad0);
									
			numpadArray.push(newPad0);						
						
			//minus & clear btn						
			var newPadM:MovieClip=new minusKey();
			newPadM.mouseChildren=false;
			var newPadC:MovieClip=new clearKey();
			newPadC.mouseChildren=false;
					
			if (minusEnabled)
			{		
				newPadM.buttonMode=true;
				
				newPadM.addEventListener(MouseEvent.CLICK,returnNum);
				newPadM.addEventListener(MouseEvent.MOUSE_DOWN,numDown);
				newPadM.addEventListener(MouseEvent.MOUSE_OVER,numOver);	
				newPadM.addEventListener(MouseEvent.MOUSE_OUT,numOut);			
				
				newPadM.x=startX+newPad0.width*3;
				newPadM.y=startY;
				newPadM.name="negative";
				
				if (!demo)
					stage.addChild(newPadM);
				else
					puzzleBase.addChild(newPadM);
					
				numpadArray.push(newPadM);			
			}
			
			if (clearEnabled)
			{				
				newPadC.buttonMode=true;
				
				newPadC.addEventListener(MouseEvent.CLICK,returnNum);
				newPadC.addEventListener(MouseEvent.MOUSE_DOWN,numDown);
				newPadC.addEventListener(MouseEvent.MOUSE_OVER,numOver);				
				newPadC.addEventListener(MouseEvent.MOUSE_OUT,numOut);
				
				newPadC.x=startX+newPad0.width*3;
				newPadC.y=startY+newPadM.height;
				newPadC.name="clear";
				
				if (!demo)
					stage.addChild(newPadC);
				else
					puzzleBase.addChild(newPadC);
					
				numpadArray.push(newPadC);
			}	
		}
		private function setupTextField(demo:Boolean=false,ansX=350,ansY=75,negX=345,negY=72)	//default location of ans	//set the textfield required for different mini-games
		{				
			var textformat:TextFormat=getDefaultFormat();
		
			questionField=new TextField();
			questionField.selectable=false;
			questionField.x=130;
			questionField.y=75;
			questionField.width=300;
			questionField.height=85;
			questionField.defaultTextFormat=textformat;
			questionField.text="";
			
			
			answerField=new TextField();
			answerField.selectable=false;
			answerField.x=ansX;
			answerField.y=ansY;
			answerField.width=85;
			answerField.height=85;
			answerField.defaultTextFormat=textformat;
			answerField.text="";
				
			
			negative=new TextField();
			negative.selectable=false;
			negative.x=negX;
			negative.y=negY;
			negative.width=30;
			negative.height=85;
			negative.defaultTextFormat=textformat;
			negative.text="";
			
			if (!demo)
			{	
				stage.addChild(answerField);
				stage.addChild(questionField);
				stage.addChild(negative);			
				addEventListener(Event.ENTER_FRAME,startQuestion);	//start the questions
			}
			else
			{
				puzzleBase.addChild(answerField);
				puzzleBase.addChild(questionField);				
			}		
		}
		private function returnNum(event:Event)	//returning the numeric key pressed and store the value into textfields
		{
			SoundEffect.playStage(SoundEffect.NUMKEY_SOUND);
			
			var obj=event.target as MovieClip;
						
			if (obj.name=="clear")
			{
				answerField.text="";
				answerString="";
				
				attempted=false; //added later
				
				if (subMode==modeClass.MATH_NORMAL || subMode==modeClass.MATH_MISSING)
				{
					negative.text="";
					neg=false;		
				}								
			}
			else if (obj.name=="negative")
			{
				if (negative.text=="")
				{
					negative.text="-";
					neg=true;
				}
				else 
				{
					negative.text="";
					neg=false;
				}
			}
			else if (!(answerString.length>2))
			{			
				answerTiming=0;
				attempted=true;
				
				if (answerField.text=="")
				{
					answerField.text=obj.textBox.text;
					answerString=obj.textBox.text;
				}
				else
				{
					answerField.appendText(obj.textBox.text);
					answerString+=obj.textBox.text;
				}
			}
		}	

		private function showCorrectAnswer(answerToBeDisplayed:String)	//shows the correct answer then proceed with normal game play
		{
			numberOfQuestions++;
			
			if ((subMode==modeClass.MATH_NORMAL || subMode==modeClass.MATH_MISSING) && !ansSign)
				answerToBeDisplayed="-"+answerToBeDisplayed;
			
			answerBox.answerText.text="Answer: "+answerToBeDisplayed;
			Tweener.addTween(answerBox,{y:answerBox.height,time:timeToAnimateBtns/1.5});
			Tweener.addTween(answerBox,{y:-(answerBox.height+20),time:timeToAnimateBtns/1.5,delay:timeToShowCorrectAnswer+timeToAnimateBtns,onComplete:finished});
			
			function finished()
			{			
				if (timer>0 || subMode==modeClass.NONE)
					return;			
					
				if (subMode!=modeClass.EYE_DIGIT)
					answerField.text="";
							
				if (subMode!=modeClass.ANA_CUBE && subMode!=modeClass.MEMO_ITEM && subMode!=modeClass.EYE_DIGIT)	//specific to cube counting since no question field is used and must explicitly cleanup the cube
					questionField.text="";
				else if (subMode==modeClass.ANA_CUBE)
					cleanupCube(true);
				else if (subMode==modeClass.MEMO_ITEM)
					cleanupCountAnswer(true);
				else if (subMode==modeClass.EYE_DIGIT)
					cleanupNum(true);
									
				if (subMode==modeClass.MATH_NORMAL || subMode==modeClass.MATH_MISSING)
				{
					negative.text="";
					neg=false;
				}
				
				if (subMode!=modeClass.MEMO_ITEM)
					addEventListener(Event.ENTER_FRAME,startQuestion);
					
				answerString="";								
			}
		}

		private function getDefaultFormat():TextFormat
		{
			var textformat:TextFormat=new TextFormat();
			textformat.font=fontFace;
			textformat.size=fontSize;
			textformat.bold=fontBold;
			textformat.align="center";
			
			return textformat;			
		}
		private function numDown(event:Event)
		{
			var key=event.target as MovieClip;
			key.gotoAndStop("Down");
		}
		private function numOver(event:Event)
		{
			var key=event.target as MovieClip;
			key.gotoAndStop("Over");
		}
		private function numOut(event:Event)
		{
			var key=event.target as MovieClip;
			key.gotoAndStop("Normal");
		}		
//------------------------------------------------------------------------------------------------------------------------animation and menu bts
		private function buttonOnOff(state:Boolean) //turning button on and off
		{
			for (var i:uint=0; i<buttonArray.length; i++)
			{
				if (state)
					buttonArray[i].addEventListener(MouseEvent.CLICK,changeMode);
				else
					buttonArray[i].removeEventListener(MouseEvent.CLICK,changeMode);				
			}
		}	
		private function backUp(event:Event)	//for moving from any place in the game back to the start menu
		{				
			var DELAY:int=1; //for delaying back up button animation
		
			SoundEffect.playStage(SoundEffect.BACK_SOUND); //playing back btn sound
						
			toolBar.gameInfo.text="";
			guideRobot.whereAmI=modeClass.MAIN;	
			guideRobot.hide=false;	//show the guide
			back.enabled=false;		//disable the back button
			
			back.removeEventListener(MouseEvent.CLICK,backUp);			
			stage.removeEventListener(MouseEvent.MOUSE_UP,startStageNow);
			
			resetPlayed();		//reset any mini-game played
			cleanup();			//call the main cleanup function
			clearSampleGraphics();
			hideChoiceBar(); 	//hide the catMode menu bars
			resetChoiceBar();	//make choices to none
			scoreAll.splice(0,scoreAll.length); //removing score records
										
			Tweener.addTween(back,{alpha:0,time:timeToAnimateBtns}); //cleanup by tweening away irrelevant menus
			Tweener.addTween(blackboard,{y:blackBoardPosition.y,time:timeToAnimateBtns});	
			Tweener.addTween(score,{y:stage.stageHeight,time:timeToAnimateBtns});							
			Tweener.addTween(buttonArray,{alpha:1,time:timeToAnimateBtns,delay:DELAY,onComplete:buttonOnOff,onCompleteParams:[ON]});
			Tweener.addTween(catScoreBoard,{x:-stage.stageWidth/2,time:timeToAnimateBtns/2,transition:tempScoreBoardTransitMode})
			
			back.x=backupPoint.x;
			back.y=backupPoint.y;
			back.scaleX=1;
			back.scaleY=1;
			
			SoundEffect.chooseBGSound(modeClass.NONE);	//play sound for main menu		
		}
		
		private function showExplanationGraphics()	//for showing sample gameplay 
		{
			if (subMode!=modeClass.NONE)
			{
				var tempSampleArt:MovieClip=new sampleArt();	//adding the sample words
				tempSampleArt.x=150;
				tempSampleArt.y=-10;
				puzzleBase.addChild(tempSampleArt);			
						
				puzzleBase.scaleX=.5;
				puzzleBase.scaleY=.5
				puzzleBase.y=150;
				puzzleBase.x=170;
				
				puzzleBase.mouseChildren=false;
			}
						
			if (subMode==modeClass.MATH_NORMAL || subMode==modeClass.MATH_MISSING)
			{
				setupNumkeys(170,200,true,true,true);
				setupTextField(true);
				
				if (subMode==modeClass.MATH_NORMAL)
				{
					questionField.text=" 12 + 32 =";
					answerField.text="?";
				}	
				else
					questionField.text=" 12 + ?? = 44";
			}	
			else if (subMode==modeClass.MATH_SIGN)
			{
				var startX=200; //starting position of sign btns
				var startY=250;
			
				setupTextField(true);
				
				for (var i:uint=0; i<4; i++)
				{
					var signSymbol:MovieClip=new mathSign();
					signSymbol.x=startX+signSymbol.width*i;
					signSymbol.y=startY;
					signSymbol.gotoAndStop(i+1);				
					signSymbol.buttonMode=true;
					
					puzzleBase.addChild(signSymbol);
				}
				
				questionField.text=" 12 __ 32 = 44";							
			}
				
			else if (subMode==modeClass.EYE_ROCK)
			{				
				var tempChain:valueChain=new valueChain();
				valueChain.magArray=new Array();
				
				for (var j:uint=0; j<2; j++)
				{
					var demoRock:MovieClip=new rock();
					var tempObjValue:Object=tempChain.generateRock(demoRock);
					
					tempObjValue.mc.x=j*100;
					tempObjValue.mc.y=100;
					puzzleBase.addChild(tempObjValue.mc);					
				}
			}
			else if (subMode==modeClass.EYE_DIGIT)
			{
				for (var k:uint=0; k<3; k++)
				{
					var demoDigit:numberCount=new numberCount();
					puzzleBase.addChild(demoDigit.numObj.mc);
				}							
			}
			else if (subMode==modeClass.EYE_PUZZLE)
			{
				var demoBp:MovieClip=new demoBitmap();
				demoBp.gotoAndStop("puzzle");
				puzzleBase.addChild(demoBp);
			}			
			
			else if (subMode==modeClass.ANA_WEIGHT)
			{
				var demoSS:MovieClip=new seesaw();
				var demoWeight1:MovieClip=new weightObj(3,0);		//arbitrarily setting properties of demo weightObj
				var demoWeight2:MovieClip=new weightObj(5,2);
				demoSS.y=200;
				demoSS.x=150;
				demoSS.addItemsRight(demoWeight1.obj);
				demoSS.addItemsLeft(demoWeight2.obj);
				demoSS.sway();
				puzzleBase.addChild(demoSS);				
			}				
			else if (subMode==modeClass.ANA_CUBE)
			{
				var demoBCp:MovieClip=new demoBitmap();
				demoBCp.gotoAndStop("cube");
				puzzleBase.addChild(demoBCp);			
			}
			
			else if (subMode==modeClass.MEMO_MATCH)
			{
				var demoArray:Array=[1,1,2,2];
				
				for (var l:uint=0; l<4; l++)
				{
					var demoMatch:MovieClip=new matchCard();		
					demoMatch.faceFrame=demoArray[l];
					demoMatch.x=130+l*100;
					demoMatch.y=200;
					demoMatch.flip(true);
					puzzleBase.addChild(demoMatch);
				}	
			}				
			else if (subMode==modeClass.MEMO_ORDER)
			{
				for (var m:uint=0; m<4; m++)
				{
					var demoOrder:MovieClip=new matchCard();		
					demoOrder.faceFrame=m+1;
					demoOrder.x=130+m*100;
					demoOrder.y=200;
					demoOrder.flip(true);
					
					var demoBox:TextField=new TextField();
					demoBox.text="No. "+(m+1);
					demoBox.defaultTextFormat=getDefaultFormat();
					demoBox.x=100+m*100;
					demoBox.y=demoOrder.y+demoOrder.height+20;
					
					puzzleBase.addChild(demoOrder);
					puzzleBase.addChild(demoBox);
				}	
			}			
			else if (subMode==modeClass.MEMO_ITEM)
			{
				for (var z:uint=0; z<5; z++)
				{
					var demoCount:MovieClip=new countItem();
					demoCount.gotoAndStop(z+2);
					demoCount.x=120+z*60;
					demoCount.y=150;
					
					Tweener.addTween(demoCount,{alpha:0,time:1.5,delay:.5,transition:"linear",onComplete:setupNumkeys,onCompleteParams:[170,220,true,true,true]});
					puzzleBase.addChild(demoCount);
				}				
			}				
		}
		private function clearSampleGraphics()
		{						
			while (puzzleBase.numChildren!=0)		//removing every thing in puzzlebase
				puzzleBase.removeChildAt(0);			
			
			numpadArray=null;
			puzzleBase.scaleX=1;
			puzzleBase.scaleY=1;
			puzzleBase.x=0;
			puzzleBase.y=0;
			puzzleBase.mouseChildren=true;
		}
		private function fadeOutMenu()	//for tweening different buttons and menus based on current modes
		{	
			Tweener.addTween(buttonArray,{alpha:0,time:timeToAnimateBtns,onStart:buttonOnOff,onStartParams:[OFF]}); //hiding the buttons
			
			if (currentMode==modeClass.BRAIN_TEST)
				Tweener.addTween(blackboard,{y:blackBoardPosition.x,time:timeToAnimateBtns,delay:timeToAnimateBtns/2,transition:transitMODE}); //moving in the blackboard
			else if (currentMode==modeClass.CATEGORY)
				for (var i:uint=0; i<catBtnArray.length; i++)
					Tweener.addTween(catBtnArray[i],{x:145,time:timeToAnimateBtns,delay:timeToAnimateBtns/2,transition:transitMODE});
			else if (currentMode==modeClass.SCORE)
				Tweener.addTween(score,{y:50,time:timeToAnimateBtns,delay:timeToAnimateBtns/2,transition:transitMODE});
			else if (currentMode==modeClass.TROPHY)
				Tweener.addTween(trophyPlatform,{x:trophyPlatformPosition.x,y:trophyPlatformPosition.y,time:timeToAnimateTrophyPlatform,delay:timeToAnimateBtns/2});
				
			back.x=backupPoint.x;
			back.y=backupPoint.y;
			back.scaleX=1;
			back.scaleY=1;			
			
			Tweener.addTween(back,{alpha:1,time:timeToAnimateBtns,delay:timeToAnimateBtns}); //show back buttons			
			back.enabled=true;
			back.addEventListener(MouseEvent.CLICK,backUp);		
		}	
		private function buttonAnimation(obj,otherObj,otherObj2,otherObj3=null) //can be customized to create unique button animation
		{			
			obj.filters=[gf];	//applying filters to show choices
						
			otherObj.filters=[];	//removing filters
			otherObj2.filters=[];	//...
			
			if (otherObj3!=null)
				otherObj3.filters=[];
		}
		private function hideChoiceBar()	//hides away the catMode menu bar
		{
			for (var i:uint=0; i<catBtnArray.length; i++)
				Tweener.addTween(catBtnArray[i],{x:650,time:timeToAnimateBtns});				
		}
		private function resetChoiceBar()
		{
			for (var i:uint=0; i<catBtnArray.length; i++)
				registerModeChange(null,catBtnArray[i].none);				
		}
		private function changeQ(event:MouseEvent)	//change game quality
		{
			if (stage.quality=="LOW")
				stage.quality=StageQuality.BEST;
			else
				stage.quality=StageQuality.LOW;
		}
		private function toggleSound(event:MouseEvent)	//to make the sound play in marking scheme or turn it off
		{
			if (soundBtn.symbol.currentFrame==1)	//sound is currently on
				soundBtn.symbol.gotoAndStop(2);
			else
				soundBtn.symbol.gotoAndStop(1);
			
			SoundEffect.soundToggle(subMode);		//play the background sound relevant to current submode
		}
//---------------------------------------------------------------------------------------------------------------------trophy section	
		private function placeTrophy()
		{
			var startX=75;
			var startY1=-55;
			var startY2=80;
			var startY3=210;
			var spacingX=100;
			var currentRow=1;
			var rowNum=0;
			
			if (trophyList.length==0)
			{	
				toolBar.gameInfo.text="No trophy!";
				return;
			}
			
			for (var i:uint=0; i<trophyList.length; i++)
			{
				if (i>=12)		//only enough spots for 12 trophies
					break;
					
				trophyPlatform.addChild(trophyList[i]);
				trophyList[i].x=startX+spacingX*rowNum++;
				trophyList[i].addEventListener(MouseEvent.CLICK,getDescription);
				trophyList[i].buttonMode=true;
				
				if (i!=0 && i%3==0)
					rowNum=0;
				
				if (i<=3)
					trophyList[i].y=startY1;
				else if (i<=7)
					trophyList[i].y=startY2;
				else
					trophyList[i].y=startY3;							
			}							
		}
		private function removeTrophyPlatform()
		{
			Tweener.addTween(trophyPlatform,{x:1200,time:timeToAnimateTrophyPlatform*2,onComplete:removeME,onCompleteParams:[trophyPlatform]});	//tweeing the platform away
			
			for (var i:uint=0; i<trophyList.length; i++)									//removing envent listeners
				trophyList[i].removeEventListener(MouseEvent.MOUSE_DOWN,getDescription);
			
			robotGuide.words="Welcome To Brain Game!";		//reset the guide
			robotGuide.trophyDescript="";					//...
		}
		
		private function getDescription(event:Event)
		{
			var obj=event.currentTarget;
			robotGuide.trophyDescript=obj.name;
		}
	
		private function getRankTrophy(rankLevel:String,trophyName:String)
		{
			var newTrophy:MovieClip;
			
			if (rankLevel=="A")
			{
				newTrophy=new trophyA();
				newTrophy.name="Grade A! Earned for Rank A performance.";
				newTrophy.trophyName.text=trophyName;
				
				checkForDuplicateTrophy(newTrophy);				
				trophyAnnounce(trophyList.length);
			}			
		}
		private function noMistakeTrophy(trophyName:String)
		{
			var newTrophy:MovieClip;
			
			if (numberOfQuestions==0)
				return;
			
			if (numberOfCorrectAnswers==numberOfQuestions)
			{
				newTrophy=new trophy100();				
				newTrophy.name="Perfect Score! Earned for making no mistake.";
				newTrophy.trophyName.text=trophyName;
				
				checkForDuplicateTrophy(newTrophy);
				trophyAnnounce(trophyList.length);
			}
		}
		private function lightningTrophy(trophyName)
		{
			var newTrophy:MovieClip=new trophyLightning();
			
			if (numberOfQuestions==0)
				return;
			
			if (numberOfQuestions>=trophyWorthyNumberOfQuestion)
			{
				newTrophy.name="You were fast! Earned for answering greater than "+trophyWorthyNumberOfQuestion+" questions.";
				newTrophy.trophyName.text=trophyName;
				
				checkForDuplicateTrophy(newTrophy);
				trophyAnnounce(trophyList.length);
			}
		}
		private function brainTestTrophy(numberOfTrials)
		{
			var newTrophy:MovieClip=new trophyBrainTest();
			 
			if (numberOfTrials>=brainTestWorthyNumber)
			{
				newTrophy.name="Earned for playing BrainTest mode greater than "+brainTestWorthyNumber+" time(s).";
				newTrophy.trophyName.text="BrainMaster";
			
				checkForDuplicateTrophy(newTrophy);
				trophyAnnounce(trophyList.length);
			}
		}
		private function trophyAnnounce(currentNum:uint)
		{
			if (currentNum>trophyCount)
			{
				trophyCount=currentNum;
				robotGuide.words="You have new a trohpy! See the Trophy Section.";					
			}				
		}
		private function checkForDuplicateTrophy(currentTrophy)	//to prevent duplicate trophy
		{		
			var temp=currentTrophy;
			var foundDuplicateTrophy:Boolean=false;
			
			if (trophyList.length==0)
			{
				trophyList.push(temp);
			}
			else
			{
				for (var i:int=trophyList.length-1; i>=0; i--)
				{
					if (trophyList[i].name==temp.name)
					{
						foundDuplicateTrophy=true;
						break;
					}
				}
				
				if (foundDuplicateTrophy)
					return;
				else
					trophyList.push(temp);	
			}
		}
//==========================================================================================================================cleanup functions
		private function cleanup() //cleanup for accessing each mini games's internal cleanup function
		{			
			removeEventListener(Event.ENTER_FRAME,startQuestion);
			SoundEffect.stopBG();
			
			if ((currentMode==modeClass.BRAIN_TEST || currentMode==modeClass.CATEGORY ) && !guideRobot.explain)	//depending on submode, calls different function.bra
			{
				if (subMode==modeClass.MATH_NORMAL)
				{
					removeNumKey();
				}	
				else if (subMode==modeClass.MATH_SIGN)
				{
					removeSignKey();
				}
				else if (subMode==modeClass.MATH_MISSING)
				{
					removeNumKey();
					removeChild(getChildByName("infoText"));
				}
				
				else if (subMode==modeClass.EYE_ROCK)
				{
					if (boulderArray.length!=0)
						removeBoulderAll(false);
				}
				else if (subMode==modeClass.EYE_DIGIT)
				{
					cleanupNum(false);
				}
				else if (subMode==modeClass.EYE_PUZZLE)
				{
					removePuzzle(false);
				}				
				
				else if (subMode==modeClass.ANA_WEIGHT)
				{
					cleanupWeightGame(false);
				}				
				else if (subMode==modeClass.ANA_CUBE)
				{
					cleanupCube(false);
					removeNumKey();
				}
				
				else if (subMode==modeClass.MEMO_MATCH)
				{
					removeCardsAll(false);
				}				
				else if (subMode==modeClass.MEMO_ORDER)
				{
					cleanupShowCard(false);
				}			
				else if (subMode==modeClass.MEMO_ITEM)
				{
					cleanupCountAnswer(false);
					removeNumKey();
				}				
			}
			
			if (currentMode==modeClass.TROPHY)
				removeTrophyPlatform();		
			
			subMode=modeClass.NONE;			
		
			removeContBtn();	//remove continue btn (ie start btn)			
			stopTimer();	//stops the timer
			toolBar.gameInfo.text="";	
		}
		private function removeNumKey(remove=true) //removing numeric keys
		{
			if (numpadArray!=null)
				for (var i:uint=0; i<numpadArray.length; i++)
				{
					numpadArray[i].removeEventListener(MouseEvent.MOUSE_OVER,numOver);
					numpadArray[i].removeEventListener(MouseEvent.MOUSE_DOWN,numDown);
					numpadArray[i].removeEventListener(MouseEvent.CLICK,returnNum);
					stage.removeChild(numpadArray[i]);					
				}
			
			numpadArray=null;	
			
			if (remove)		
				removeTextField();
		}
		private function removeSignKey() //removing sign keys
		{
			if (signArray!=null)
				for (var i:uint=0; i<signArray.length; i++)
					stage.removeChild(signArray[i]);
			
			signArray=null;
			removeTextField()
		}
		private function removeTextField()
		{
			stage.removeChild(answerField);
			
			answerString="";
			
			if (subMode==modeClass.MATH_NORMAL || subMode==modeClass.MATH_SIGN|| subMode==modeClass.MATH_MISSING)
			{
				stage.removeChild(questionField);			
				stage.removeChild(negative);
			}
		}
		
		private function removeContBtn()
		{
			if (addedCont)
			{
				addedCont=false;
				contBtn.removeEventListener(MouseEvent.CLICK,gotoTrial);
				contBtn.removeEventListener(MouseEvent.CLICK,startStageNow);
				removeChild(contBtn);
			}
		}
		private function removeME(me)//only for removing mc and alikes added to main timeline
		{
			if (me!=null)
			{
				removeChild(me);
				me=null;
			}
		}
		private function resetPlayed() 
		{			
			if (mathPlayed)
				mathBtn.addChild(addPlayedThisIcon(mathBtn.math.x,mathBtn.math.y));
			if (seriesPlayed)
				eyeBtn.addChild(addPlayedThisIcon(eyeBtn.rock.x,eyeBtn.rock.y));
			if (memoPlayed)
				memoBtn.addChild(addPlayedThisIcon(memoBtn.match.x,memoBtn.match.y));
			if (symbolPlayed)
				mathBtn.addChild(addPlayedThisIcon(mathBtn.sign.x,mathBtn.sign.y));
			if (weightPlayed)
				anaBtn.addChild(addPlayedThisIcon(anaBtn.weight.x,anaBtn.weight.y));
			if (puzzlePlayed)
				eyeBtn.addChild(addPlayedThisIcon(eyeBtn.puzzle.x,eyeBtn.puzzle.y));
			if (brickPlayed)
				anaBtn.addChild(addPlayedThisIcon(anaBtn.cube.x,anaBtn.cube.y));
			if (showedCardPlayed)
				memoBtn.addChild(addPlayedThisIcon(memoBtn.order.x,memoBtn.order.y));
			if (countNumPlayed)
				eyeBtn.addChild(addPlayedThisIcon(eyeBtn.digit.x,eyeBtn.digit.y));
			if (countItemPlayed)
				memoBtn.addChild(addPlayedThisIcon(memoBtn.item.x,memoBtn.item.y));
			if (numberPlayed)
				mathBtn.addChild(addPlayedThisIcon(mathBtn.missing.x,mathBtn.missing.y));
					
			anaCatPlayed=false; //resetting category boolean
			mathCatPlayed=false;
			memoCatPlayed=false;
			eyeCatPlayed=false;
			
			mathPlayed=false; //resetting individual level boolean
			seriesPlayed=false;
			memoPlayed=false;
			symbolPlayed=false;
	
			weightPlayed=false;
			puzzlePlayed=false;
			brickPlayed=false;
			showedCardPlayed=false;		
			countNumPlayed=false;
			countItemPlayed=false;
			numberPlayed=false;				
		}
		private function addPlayedThisIcon(xx,yy):MovieClip
		{
			var tempP:MovieClip=new playedThis();
			tempP.x=xx-5;
			tempP.y=7+yy;
			
			return tempP;			
		}
	}
}