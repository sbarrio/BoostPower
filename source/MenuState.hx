package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.effects.FlxFlicker;

/**
 * A FlxState which can be used for the game's menu.
 */
class MenuState extends FlxState
{

	private var selectedShip:Int = 1;
	private var selector:FlxSprite;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();

		var txtChoose = new FlxText(260, 50,500, "Choose your vehicle < >", 20);
		add(txtChoose);

		var ship1 = new FlxSprite();
		ship1.loadGraphic(Reg.ship1);
		add(ship1);
		ship1.x = 130;
		ship1.y = 170;
		
		var ship2 = new FlxSprite();
		ship2.loadGraphic(Reg.ship2);
		add(ship2);
		ship2.x = 350;
		ship2.y = 170;

		var ship3 = new FlxSprite();
		ship3.loadGraphic(Reg.ship3);
		add(ship3);
		ship3.x = 570;
		ship3.y = 170;

		selector = new FlxSprite();
		selector.loadGraphic(Reg.selector);
		add(selector);
		selector.x = 130;
		selector.y = 160;


		var txtSpace = new FlxText(285, 330,500, "Press SPACE to start!", 20);
		add(txtSpace);

		FlxFlicker.flicker(txtSpace, 1000, 0.5,true, true,null,null);

		FlxG.sound.play(Reg.MENU,1,true,true,null);

	}
	
	/**
	 * Function that is called when this state is destroyed - you might want to 
	 * consider setting all objects this state uses to null to help garbage collection.
	 */
	override public function destroy():Void
	{
		super.destroy();
	}

	/**
	 * Function that is called once every frame.
	 */
	override public function update():Void
	{
		super.update();

        if (FlxG.keys.justPressed.SPACE)
        {
        	FlxG.sound.play(Reg.BLOP);
            goToStageState(selectedShip);
        }

        if (FlxG.keys.justPressed.ESCAPE)
        {
        	FlxG.sound.play(Reg.BLOP);
            goToTitleState();
        }

        if (FlxG.keys.justPressed.RIGHT){
        	if (selectedShip == 1){
        		selectedShip = 2;
        		selector.x =350;
        	}else if (selectedShip == 2){
        		selectedShip = 3;
        		selector.x =570;
        	}else  if (selectedShip == 3){
        		selectedShip = 1;
        		selector.x =130;
        	}
        	FlxG.sound.play(Reg.BLIP);
        }

        if (FlxG.keys.justPressed.LEFT){
        	if (selectedShip == 1){
        		selectedShip = 3;
        		selector.x =570;
        	}else if (selectedShip == 2){
        		selectedShip = 1;
        		selector.x =130;
        	}else if (selectedShip == 3){
        		selectedShip = 2;
        		selector.x =350;
        	}
        	FlxG.sound.play(Reg.BLIP);
        }
	}	

	public function goToStageState(ship:Int):Void{
		StageState.selectedShip = ship;
		FlxG.switchState(new StageState());
	}

	public function goToTitleState():Void{
		FlxG.switchState(new TitleState());
	}
}