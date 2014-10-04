package;

import flixel.util.FlxSave;

/**
 * Handy, pre-built Registry class that can be used to store 
 * references to objects and other things for quick-access. Feel
 * free to simply ignore it or change it in any way you like.
 */
class Reg
{


	// ASSETS PATHS

	public static inline var TestStageBG:String = "assets/images/stage/testBG.png";
	public static inline var ship1:String = "assets/images/object/ship1.png";
	public static inline var ship2:String = "assets/images/object/ship2.png";
	public static inline var ship3:String = "assets/images/object/ship3.png";
	public static inline var selector:String = "assets/images/object/selector.png";
	public static inline var turbo:String = "assets/images/object/turbo.png";
	public static inline var turboUsed:String = "assets/images/object/turboUsed.png";
	public static inline var sky:String = "assets/images/stage/sky.png";
	public static inline var road1:String = "assets/images/stage/road1.png";
	public static inline var building:String = "assets/images/stage/building.png";
	public static inline var tower:String = "assets/images/stage/tower.png";
	public static inline var logo:String = "assets/images/title/logo.png";

	//SOUND
	public static inline var BLIP:String = "assets/sounds/blip.wav";
	public static inline var BLOP:String = "assets/sounds/blop.wav";
	public static inline var ENGINE:String = "assets/sounds/engine.wav";
	public static inline var EXPLOSION:String = "assets/sounds/explosion.wav";
	public static inline var BOOST:String = "assets/sounds/boost.wav";
	public static inline var TITLE:String = "assets/sounds/title.wav";
	public static inline var MENU:String = "assets/sounds/menu.wav";
	public static inline var STAGE:String = "assets/sounds/stage.wav";


	/**
	 * Generic levels Array that can be used for cross-state stuff.
	 * Example usage: Storing the levels of a platformer.
	 */
	public static var levels:Array<Dynamic> = [];
	/**
	 * Generic level variable that can be used for cross-state stuff.
	 * Example usage: Storing the current level number.
	 */
	public static var level:Int = 0;
	/**
	 * Generic scores Array that can be used for cross-state stuff.
	 * Example usage: Storing the scores for level.
	 */
	public static var scores:Array<Dynamic> = [];
	/**
	 * Generic score variable that can be used for cross-state stuff.
	 * Example usage: Storing the current score.
	 */
	public static var score:Int = 0;
	/**
	 * Generic bucket for storing different FlxSaves.
	 * Especially useful for setting up multiple save slots.
	 */
	public static var saves:Array<FlxSave> = [];
}