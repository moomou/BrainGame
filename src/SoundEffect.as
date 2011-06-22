package
{
	//3 channels; 1 for background, 1 for sound effects, and 1 for marking
	import caurina.transitions.*;
	
	import flash.events.Event;
	import flash.media.Sound;
	import flash.media.SoundChannel;
		
	public class SoundEffect extends Sound
	{			
		//different sounds
		public static const RIGHT:Sound=new rightSound();
		public static const WRONG:Sound=new wrongSound();		
		public static const NUMKEY_SOUND:Sound=new numkeySound();
		public static const MENUBTN_SOUND:Sound=new menubtnSound();		
		public static const BACK_SOUND:Sound=new backSound();
		public static const TIME_SOUND:Sound=new timeSound();
		
		public static const START_BTN_SOUND:Sound=new startBtnSound();
				
		//background music for different modes
		public static const MAIN_MENU_MUSIC:Sound=new mainSound();
		public static const MATH_MUSIC:Sound=new mathSound();
		public static const EYE_COORD_MUSIC:Sound=new eyeSound();
		public static const ANA_MUSIC:Sound=new anaSound();
		public static const MEMO_MUSIC:Sound=new memoSound();
		
		//sound channels
		private static var stageChannel:SoundChannel=new SoundChannel(); //stage sound effects
		private static var markChannel:SoundChannel=new SoundChannel();	//marking sound effect
		private static var backgroundChannel:SoundChannel=new SoundChannel();
		
		private static var currentSoundMark:Sound=null;
		private static var currentSoundStage:Sound=null;
		private static var currentBGSound:Sound=null;
		private static var soundOn:Boolean=true;		
			
		public function SoundEffect()	//warning that no instance should be created
		{
			trace("Not to be instantiated.");
		}	
		public static function soundToggle(currentMode)	//turning sound on and off
		{
			soundOn=!soundOn;
			
			if (!soundOn)
				stopBG();
			else
				chooseBGSound(currentMode);				
		}	
		public static function chooseBGSound(currentMode)	//for choosing submode sound
		{
			switch (currentMode)
			{
				case modeClass.NONE: 
				{
					playBG(MAIN_MENU_MUSIC);
					break;
				}
				case modeClass.MATH_MISSING: 
				case modeClass.MATH_NORMAL: 
				case modeClass.MATH_SIGN: 
				{
					playBG(MATH_MUSIC);
					break;
				}
				case modeClass.EYE_DIGIT: 
				case modeClass.EYE_PUZZLE: 
				case modeClass.EYE_ROCK: 
				{
					playBG(EYE_COORD_MUSIC);
					break;
				}
				case modeClass.MEMO_ITEM: 
				case modeClass.MEMO_MATCH: 
				case modeClass.MEMO_ORDER: 
				{
					playBG(MEMO_MUSIC);
					break;
				}
				case modeClass.ANA_CUBE: 
				case modeClass.ANA_WEIGHT: 
				{
					playBG(ANA_MUSIC);
					break;
				}				
			}			
		}
		public static function stopMark()	//marking sound
		{			
			if (markChannel!=null)
				markChannel.stop();					
			currentSoundMark=null;				
		}	
		public static function stopStage()	//stage sound
		{
			if (stageChannel!=null)
				stageChannel.stop();
			currentSoundStage=null;
		}
		public static function stopBG()
		{
			if (backgroundChannel!=null)
				backgroundChannel.stop();
			currentBGSound=null;			
		}
		public static function playMark(sound:Sound)	//get the mark channel to play
		{
			if (!soundOn)
				return;
				
			if (currentSoundMark!=sound)
			{
				if (markChannel!=null)
					markChannel.stop();
				
				currentSoundMark=sound;
				
				if (currentSoundMark!=null)
				{
					markChannel=currentSoundMark.play();
					markChannel.addEventListener(Event.SOUND_COMPLETE,stopAll);				
				}	
			}			
		}
		public static function playStage(sound:Sound)
		{
			if (!soundOn)
				return;
				
			if (currentSoundStage!=sound)
			{
				if (stageChannel!=null)
					stageChannel.stop();
				
				currentSoundStage=sound;
				
				if (currentSoundStage!=null)
				{
					stageChannel=currentSoundStage.play();
					stageChannel.addEventListener(Event.SOUND_COMPLETE,stopAll);
				}
			}		
		}	
		public static function playBG(sound:Sound)
		{
			if (!soundOn)
				return;
				
			if (currentBGSound!=sound)
			{
				if (backgroundChannel!=null)
					backgroundChannel.stop();
					
				currentBGSound=sound;
				
				if (backgroundChannel!=null)
				{
					backgroundChannel=currentBGSound.play();
					backgroundChannel.addEventListener(Event.SOUND_COMPLETE,stopAll);	
				}
			}			
		}
		private static function replayBG()
		{
			var tempSound:Sound=currentBGSound;
			currentBGSound=null;
			playBG(tempSound);
		}
		private static function stopAll(event:Event)
		{
			var channelToStop=event.target;
			
			if (channelToStop==stageChannel)
				stopStage();
			else if (channelToStop==markChannel)
				stopMark();
			else if (channelToStop==backgroundChannel)
				replayBG();		
		}	
	}
}
