package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxColor;
import flixel.effects.FlxFlicker;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class TitleState extends FlxState
{
	private var _emitter:FlxEmitter;
	private var _whitePixel:FlxParticle;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();



		_emitter = new FlxEmitter(400, FlxG.height / 2, 300);
		_emitter.setXSpeed(-300, 300);
		_emitter.setYSpeed( -100, 100);
		add(_emitter);

		for (i in 0...(Std.int(_emitter.maxSize / 2))) 
		{
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(2, 2, FlxColor.WHITE);
			// Make sure the particle doesn't show up at (0, 0)
			_whitePixel.visible = false; 
			_emitter.add(_whitePixel);
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(1, 1, FlxColor.WHITE);
			_whitePixel.visible = false;
			_emitter.add(_whitePixel);
		}

		_emitter.start(false, 10, .01);

		var titleLogo = new FlxSprite();
		titleLogo.loadGraphic(Reg.logo);
		add(titleLogo);
		titleLogo.x = 100;
		titleLogo.y = 0;

		var txtPressText = new FlxText(355, 300,500, "Press SPACE", 16);
		var txtAuthor =  new FlxText(360, 360,500, "2014 sbarrio",14);

		FlxFlicker.flicker(txtPressText, 1000, 0.5,true, true,null,null);

		add(txtPressText);
		add(txtAuthor);

		FlxG.sound.play(Reg.TITLE,1,true,true,null);
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
            goToMenuState();
        }
	}	

	public function goToMenuState():Void{
		FlxG.switchState(new MenuState());
	}
}