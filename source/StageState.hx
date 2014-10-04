package;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxObject;
import flixel.FlxState;
import flixel.text.FlxText;
import flixel.ui.FlxButton;
import flixel.util.FlxMath;
import flixel.util.FlxPool;
import flixel.group.FlxGroup;
import flixel.group.FlxTypedGroup;
import flixel.ui.FlxBar;
import flixel.util.FlxRandom;
import flixel.tweens.FlxTween;
import flixel.tweens.FlxEase;
import flixel.util.FlxColor;
import flixel.effects.particles.FlxEmitter;
import flixel.effects.particles.FlxParticle;
import flixel.system.FlxSound;

/**
 * A FlxState which can be used for the actual gameplay.
 */
class StageState extends FlxState
{

	public static var selectedShip:Int = 1;

	//CONSTANTS
	var MAX_ENERGY:Float = 100;
	var MAX_TIME_NEW_TURBO = 200;
	var MAX_TIME_NEW_BG_OBJECT = 50;
	var BOOST_DURATION = 150;
	var MAX_BOOST_DURATION = 80;
	var BOOST_ACCEL = 10;
	var MISSED_TURBO_DAMAGE = 15;
	var USED_TURBO_HEAL = 20;
	var MAX_SPEED = 120;
	var DRAG = 1;
	var LEVEL_1_APPEAR_RATE = 10;
	var LEVEL_2_APPEAR_RATE = 5;
	var LEVEL_3_APPEAR_RATE = 3;
	var LEVEL_4_APPEAR_RATE = 2;
	var LEVEL_5_APPEAR_RATE = 1;

	var NORMAL_SPEED = 20;
	var NORMAL_SPEED_SHIP1 = 20;
	var NORMAL_SPEED_SHIP2 = 25;
	var NORMAL_SPEED_SHIP3 = 30;

	// Control vars
	var time:Float = 0;
	var turboAppearRate = 5;
	var speed:Float = 0;
	var boostActive:Bool = false;
	var boostTimerLeft:Float = 0;
	var turboCount = 0;
	var chainCount = 0;
	var gameOver = false;
	var bgObjectTimer:Float = 0;

	//Stage objects
	var ship:Ship;
	var shadow:FlxSprite;
	var floatTween:FlxTween;

	//Particles and emitters
	private var engineEmitter:FlxEmitter;
	private var _whitePixel:FlxParticle;

	private var explosionEmitter:FlxEmitter;
	private var explosionPixel:FlxParticle;

	public var roadBlockGroup:FlxTypedGroup<FlxSprite>;
	public var turboObjects:FlxTypedGroup<Turbo>;

	public var backgroundObjects:FlxTypedGroup<FlxSprite>;

	var firstBGSprite:FlxSprite;
	var secondBGSprite:FlxSprite;

	//HUD
	var speedOMeter:FlxText;
	var turboCounter:FlxText;
	var chainCounter:FlxText;
	var energyBar:FlxBar;
	var txtGameOver:FlxText;
	var txtPressSpace:FlxText;

	//Sound
	var engineSound:FlxSound;

	/**
	 * Function that is called up when to state is created to set it up. 
	 */
	override public function create():Void
	{
		super.create();
	  	

		var sky = new FlxSprite();
		sky.loadGraphic(Reg.sky);
		add(sky);
		sky.x = 0;
		sky.y = 0;

		backgroundObjects = new FlxTypedGroup<FlxSprite>();
		add(backgroundObjects);

		roadBlockGroup = new FlxTypedGroup<FlxSprite>();
		add(roadBlockGroup);

		turboObjects = new FlxTypedGroup<Turbo>();
		add(turboObjects);

	    firstBGSprite = new FlxSprite();
		firstBGSprite.loadGraphic(Reg.road1);
		firstBGSprite.x = 0;
		firstBGSprite.y = 200;
		roadBlockGroup.add(firstBGSprite);

		secondBGSprite = new FlxSprite();
		secondBGSprite.loadGraphic(Reg.road1);
		secondBGSprite.x = 800;
		secondBGSprite.y = 200;
		roadBlockGroup.add(secondBGSprite);




		//loads test ship
		ship = new Ship();

		switch (selectedShip) {
			case 1:
				ship.loadGraphic(Reg.ship1);
				NORMAL_SPEED = NORMAL_SPEED_SHIP1;
			case 2:
				ship.loadGraphic(Reg.ship2);
				NORMAL_SPEED = NORMAL_SPEED_SHIP2;
			case 3:
				ship.loadGraphic(Reg.ship3);
				NORMAL_SPEED = NORMAL_SPEED_SHIP3;
			default:
				ship.loadGraphic(Reg.ship1);
		}
		
		add(ship);
		ship.x = 200;
		ship.y = 280;
		ship.energy = MAX_ENERGY;

		shadow = new FlxSprite();
		shadow.makeGraphic(90, 20, FlxColor.GRAY);
		shadow.alpha = 0.5;
		add(shadow);
		shadow.x = ship.x + 5;
		shadow.y = ship.y + ship.height;



		//ship engine
		var emitterX:Float;
		var emitterY:Float;

		if (selectedShip == 1){
			emitterX = ship.x + 25;
			emitterY = ship.y + 47;
		}else if (selectedShip == 2){
			emitterX = ship.x;
			emitterY = ship.y + 40;
		}else if (selectedShip == 3){
			emitterX = ship.x+10;
			emitterY = ship.y+18;
		}else{
			emitterX = ship.x;
			emitterY = ship.y;
		}


		engineEmitter = new FlxEmitter(emitterX, emitterY, 200);
		engineEmitter.setXSpeed(-500, 0);
		engineEmitter.setYSpeed( -40, 40);
		add(engineEmitter);

		for (i in 0...(Std.int(engineEmitter.maxSize / 2))) 
		{
			_whitePixel = new FlxParticle();
			if (i % 2 == 0){
				_whitePixel.makeGraphic(2, 2, FlxColor.RED);
			}else{
				_whitePixel.makeGraphic(2, 2, FlxColor.YELLOW);
			}
			// Make sure the particle doesn't show up at (0, 0)
			_whitePixel.visible = false; 
			engineEmitter.add(_whitePixel);
			_whitePixel = new FlxParticle();
			_whitePixel.makeGraphic(1, 1, FlxColor.YELLOW);
			_whitePixel.visible = false;
			engineEmitter.add(_whitePixel);
		}

		engineEmitter.start(false, 2, .001);


		explosionEmitter = new FlxEmitter(ship.x + 60, ship.y + 32, 1000);
		explosionEmitter.setXSpeed(-250, 250);
		explosionEmitter.setYSpeed( -250, 250);
		add(explosionEmitter);

		for (i in 0...(Std.int(explosionEmitter.maxSize / 2))) 
		{
			explosionPixel = new FlxParticle();
			
			if (i % 2 == 0){
				explosionPixel.makeGraphic(2, 2, FlxColor.YELLOW);
			}else{
				explosionPixel.makeGraphic(2, 2, FlxColor.RED);
			}

			// Make sure the particle doesn't show up at (0, 0)
			explosionPixel.visible = false; 
			explosionEmitter.add(explosionPixel);
			explosionPixel = new FlxParticle();
			explosionPixel.makeGraphic(1, 1, FlxColor.RED);
			explosionPixel.visible = false;
			explosionEmitter.add(explosionPixel);
		}

		

		//ship animation
		floatTween = FlxTween.tween(ship, { x:200, y:283 }, 0.1, { type:FlxTween.PINGPONG, ease:FlxEase.quadInOut, complete:null, startDelay:0, loopDelay:0.01 });


		//HUD 

		//SpeedOMeter
		speedOMeter = new FlxText(630, 40, 300, "SPEED " + speed,25);
		add(speedOMeter);

		//Turbo Count
		turboCounter = new FlxText(390, 20, 300, turboCount + "" ,50);
		add(turboCounter);

		//Chain Count
		chainCounter = new FlxText(630, 80, 300, "CHAIN " + chainCount,25);
		add(chainCounter);

		//Energy
		var txtEnergy = new FlxText(42, 35,100, "ENERGY", 14);
		add(txtEnergy);
		energyBar = new FlxBar (30, 10, FlxBar.FILL_LEFT_TO_RIGHT,100, 20, ship,"energy",0, 100, true);
		add(energyBar);

		//Game over sign

		txtGameOver = new FlxText(245, 130,1000, "GAME OVER", 50);
		add(txtGameOver);
		txtGameOver.alpha = 0;

		txtPressSpace = new FlxText(290, 210,1000, "Press SPACE to continue", 16);
		add(txtPressSpace);
		txtPressSpace.alpha = 0;

		//init config
		speed = NORMAL_SPEED;
		turboAppearRate = LEVEL_1_APPEAR_RATE;

		engineSound = FlxG.sound.play(Reg.ENGINE,1,true,true,null);
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
		
		if (gameOver){
			//back to title screen
			if (FlxG.keys.justPressed.SPACE){
				FlxG.sound.play(Reg.BLOP);
				FlxG.switchState(new MenuState());
			}
			return;			
		}


		//drag (decreases speed until it has a normal value)
		speed -= DRAG;
		if (speed <= NORMAL_SPEED){
			speed = NORMAL_SPEED;
		}

		firstBGSprite.x -= speed;
		secondBGSprite.x -= speed;

		//updates HUD
		speedOMeter.text = "SPEED " + speed*10;
		turboCounter.text = turboCount + "";

		chainCounter.text = "CHAIN " + chainCount;

		if (firstBGSprite.x <= -800){
			roadBlockGroup.remove(firstBGSprite);
			firstBGSprite.destroy();
			firstBGSprite = secondBGSprite;
			secondBGSprite = new FlxSprite();
			secondBGSprite.loadGraphic(Reg.road1);
			roadBlockGroup.add(secondBGSprite);
			secondBGSprite.x = firstBGSprite.x + firstBGSprite.width;
			secondBGSprite.y = 200;
		}

		//Game over?
		if (ship.energy <= 0){
			ship.energy = 0;
			speed = 0;
			gameOver = true;
			destroyShip();
			txtGameOver.alpha = 1;
			txtPressSpace.alpha = 1;
			engineSound.stop();
			FlxG.sound.play(Reg.EXPLOSION);
		}

		//creates new turbo objects
		time +=  FlxRandom.intRanged(0, turboAppearRate) + chainCount;
		if (time > MAX_TIME_NEW_TURBO){
			time = 0;
			var turbo = new Turbo();
			turboObjects.add(turbo);
			turbo.x = 800;
			turbo.y = 250;
		}

		//levels

		if (turboCount >= 10 && turboCount < 20){
			turboAppearRate = LEVEL_2_APPEAR_RATE;
		}

		if (turboCount >= 20 && turboCount < 30){
			turboAppearRate = LEVEL_3_APPEAR_RATE;
		}

		if (turboCount >= 20 && turboCount < 30){
			turboAppearRate = LEVEL_4_APPEAR_RATE;
		}

		if (turboCount > 30){
			turboAppearRate = LEVEL_5_APPEAR_RATE;
		}

		//creates new background objects
		bgObjectTimer +=  FlxRandom.intRanged(0, 10);
		if (bgObjectTimer > MAX_TIME_NEW_BG_OBJECT){
			bgObjectTimer = 0;
			var bgObject = new FlxSprite();
			if (FlxRandom.chanceRoll()){
				bgObject.loadGraphic(Reg.building);
			}else{
				bgObject.loadGraphic(Reg.tower);
			}
			backgroundObjects.add(bgObject);
			bgObject.x = 800;
			bgObject.y = 100;
		}

		//updates bg objects
		for (b in backgroundObjects){
			//if objects is out of screen we destroy it
			if (b.x <= -b.width){
				backgroundObjects.remove(b);
				b.destroy();
			}else{
				b.x -= speed;
			}
		}


		//updates turbo objects
		for (t in turboObjects){
			//if objects is out of screen we destroy it
			if (t.x <= -t.width){
				turboObjects.remove(t);
				t.destroy();
				if (!t.used){
					chainCount = 0;
				}
			}else{
				t.x -= speed;
			}
		}

		//boost update
		if (boostActive && boostTimerLeft > 0){
			boostTimerLeft -= 5;
			if (boostTimerLeft <= 0){
				boostTimerLeft = 0;
				boostActive = false;
			}else{
				speed += BOOST_ACCEL;
				if (speed > MAX_SPEED){
					speed = MAX_SPEED;
				}
			}
		}

		//energy goes down
		ship.energy -=0.2;

		if (FlxG.keys.justPressed.SPACE){
			FlxG.overlap(turboObjects, ship, null, collideWithTurbo);
		}

	}	

	private function collideWithTurbo(Sprite1:FlxObject, Sprite2:FlxObject):Bool{
		var sprite1ClassName:String = Type.getClassName(Type.getClass(Sprite1));
		var sprite2ClassName:String = Type.getClassName(Type.getClass(Sprite2));
		//Missile and planet
		if ((sprite1ClassName == "Turbo") && (sprite2ClassName == "Ship")){

			var t: Dynamic = cast(Sprite1,Turbo);
			var s: Dynamic = cast(Sprite2,Ship);

			//activate turbo -> restores energy
			if (!t.used){
				turboCount++;
				t.use();
				boostActive = true;
				boostTimerLeft += BOOST_DURATION;
				ship.energy += USED_TURBO_HEAL;
				chainCount++;
				FlxG.sound.play(Reg.BOOST);
				if (ship.energy > MAX_ENERGY){
					ship.energy = MAX_ENERGY;
				}
				if (boostTimerLeft >= MAX_BOOST_DURATION){
					boostTimerLeft = MAX_BOOST_DURATION;
				}
			}

		}
		return true;
	}

	function destroyShip():Void{
		ship.destroy();
		shadow.destroy();
		engineEmitter.destroy();
		explosionEmitter.start(true, 3, .00001);
	}

}