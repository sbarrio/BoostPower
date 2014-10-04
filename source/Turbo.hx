package;

import flixel.FlxSprite;
import flixel.FlxG;
import flixel.FlxObject;


class Turbo extends FlxSprite
{

    public var boost:Float;
    public var used:Bool = false;

    public function new()
    {
    	super();
        loadGraphic(Reg.turbo);
    }

    override public function update():Void
    {
    	super.update();
    }

    override public function destroy():Void
    {
        super.destroy();
    }

    public function use():Void{
        used = true;
        //change color when used
        loadGraphic(Reg.turboUsed);
    }

}