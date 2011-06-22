package
{
	public class modeClass	//a class for holding most of the string constants 
	{
		//main modes
		public static const MAIN="main";
		public static const CATEGORY="catMode";
		public static const SCORE="scoreMode";
		public static const TROPHY="trophy";
		public static const BRAIN_TEST="brainTestMode";
		public static const OVER="over";
		
		//category
		public static const MEMO="Memory";
		public static const ANA="Analytical";
		public static const MATH="Math";
		public static const EYE="Eye Coordination";
		
		//mini-game submode
		public static const NONE="none";
				
		public static const MATH_NORMAL="math";
		public static const MATH_SIGN="sign";
		public static const MATH_MISSING="missing";
		
		public static const MEMO_MATCH="match";
		public static const MEMO_ORDER="order";
		public static const MEMO_ITEM="item";
		
		public static const ANA_WEIGHT="weight";
		public static const ANA_CUBE="cube";
		
		public static const EYE_ROCK="rock";
		public static const EYE_PUZZLE="puzzle";
		public static const EYE_DIGIT="digit"; 
		
		public function modeClass()
		{
			trace("Not to be instantiated.");
		}

	}
}