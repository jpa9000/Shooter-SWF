package  
{
	
	import flash.display.MovieClip;
	import flash.events.*;
	import flash.text.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import Player
	import Bullet
	import Enemy
	import flash.utils.*;
	import flash.media.*;
	import flash.media.SoundChannel;
	import flash.net.URLRequest;
	
	public class bg extends MovieClip 
	{	 
		var blackperson:Player = new Player();
		var police:Enemy = new Enemy();
		var bulletgone:String = "yes";
		var pbulletgone:String = "yes";
		var bpd:String = "no";
		var developOn:String= "false";
		var PlayerX:Number, Health:Number = 100, pHealth:Number = 100, 
			PlayerY:Number, speed:Number = 8, angleRadian, action, pangleRadian;
		var bullet:Bullet= new Bullet();
		var pbullet:Bullet= new Bullet();
		var dMode:TextField = new TextField();
		var disHP:TextField = new TextField();
		var pTimer:Timer = new Timer(500);
		var gunshot:Sound = new Sound();
		

		public function bg() 
		{
			//adding functions
			var bgsound:Sound = new Sound();
			bgsound.load(new URLRequest("bgmusic.mp3"));
			gunshot.load(new URLRequest("gunshot.mp3"));
			bgsound.play(0,999);
			police.addEventListener(Event.ENTER_FRAME, enemyEnterFrame);
			blackperson.addEventListener(Event.ENTER_FRAME,  blackpersonEnterFrame);
			pTimer.addEventListener(TimerEvent.TIMER, AI);pTimer.start();
			
			
			//changing properties
			police.x = 268;
			police.y = 257.7;
			blackperson.x = 399.25;
			blackperson.y = 36.45;
			dMode.textColor = 0x00CC66; 
			disHP.textColor = 0xFF0000;
			disHP.backgroundColor = 0x0000FF;
			dMode.wordWrap = true;
			disHP.wordWrap = true;
			dMode.visible = false;
			dMode.height = 200;
			dMode.width = 200;
			
			//adding to stage
			addChild(disHP);
			addChild(dMode);
			addChild(blackperson);
			addChild(police);
		}
		
		public function enemyEnterFrame(event:Event):void {
			var angleRadian = Math.atan2(blackperson.y - police.y,blackperson.x - police.x);
   			var angleDegree = angleRadian * 180 / Math.PI;
    		police.rotation = angleDegree;
			getAway();
			getClose();
			
			if(pHealth < 0) {
				this.visible = false;
			}
			else if(Health <0 ) {
				this.removeEventListener(Event.ENTER_FRAME,  blackpersonEnterFrame);
				this.removeChild(blackperson);
				bpd = "yes";
			}
			
		}
		
		function getDistance(pObj1:MovieClip,pObj2:MovieClip):Number {
    		var distX:Number = pObj1.x - pObj2.x;
    		var distY:Number = pObj1.y - pObj2.y;
    		return Math.sqrt(distX * distX + distY * distY);
		}
		
		public function AI(event:Event):void {
			if ( bpd == "yes" ) {
					action = Math.floor(Math.random() * 4) + 1;
				switch(action){
					case 1: //attack
						shootbullet();
					break;
						
					case 2:
						shootbullet();
					break;
					
					case 3:
						if(getDistance(police, blackperson)>170){
							getClose();
						}
					break;
					
					case 4:
						if(getDistance(police, blackperson)<170){
							getAway();
						}
					break;
					
				}
			}
			else{
				
			}
		}
		
		public function getAway() {
			police.x-=6*Math.cos(police.rotation*Math.PI/180)*2; 
			police.y-=6*Math.sin(police.rotation*Math.PI/180)*2;
		}
		
		public function getClose() {
			police.x+=6*Math.cos(police.rotation*Math.PI/180)*2; 
			police.y+=6*Math.sin(police.rotation*Math.PI/180)*2;
		}
		
		public function blackpersonEnterFrame(event:Event):void {
    		var angleRadian = Math.atan2(mouseY - blackperson.y,mouseX - blackperson.x);
   			var angleDegree = angleRadian * 180 / Math.PI;
    		blackperson.rotation = angleDegree;
			PlayerX = blackperson.x;
			PlayerY = blackperson.y;
			disHP.text= "Health: " + Health + "\nPolice: " + pHealth;
			dMode.text = 
			"Developer Mode \n" + "Player(" + PlayerX + ", " + PlayerY + ")\n" + 
			"Player Rotation: " + blackperson.rotation + "\n" +
			"Police(" + police.x + ", " + police.y + ")\n" + 
			"Police Rotation: " + police.rotation + "\n" +
			"Bullet(" + bullet.x + ", " + bullet.y + ")\n" +
			"AI:" + action +
			"\nPlayer Distance: " + getDistance(blackperson, police) +
			"\nPolice Distance: " + getDistance(police, blackperson);
		}

		
		public function mouseDown(event:Event){
			 
			if (bulletgone == "yes"){
				 bulletgone = "no";
			 	bullet.x = blackperson.x;
			 	bullet.y = blackperson.y;
			 	angleRadian = Math.atan2(mouseY - blackperson.y,mouseX - blackperson.x);
			 	bullet.addEventListener(Event.ENTER_FRAME, bulletEnterFrame);
			 	this.addChild(bullet);
			 }
			 else
			 {
			 	//do nothing
			 }
			 
		}
		
		public function shootbullet() {
			if (pbulletgone == "yes"){
				 	pbulletgone = "no";
			 		pbullet.x = police.x;
			 		pbullet.y = police.y;
			 		pangleRadian = Math.atan2(blackperson.y - police.y,blackperson.x - police.x);
			 		pbullet.addEventListener(Event.ENTER_FRAME, pbulletEnterFrame);
			 		this.addChild(pbullet);
			 }
			 else
			 {
			 	//do nothing
			 }
		}
		
		
		public function bulletEnterFrame(event:Event) {
			bullet.x += Math.cos(angleRadian)*speed;
			bullet.y += Math.sin(angleRadian)*speed;
   			var angleDegree = angleRadian * 180 / Math.PI;
			bullet.rotation = angleDegree;
			//gunshot.play();
			if (bullet.hitTestObject(police)) {
				bullet.removeEventListener(Event.ENTER_FRAME, bulletEnterFrame); 
				this.removeChild(bullet);
				bulletgone = "yes";
				pHealth -= 2;
				police.x-=6*Math.cos(police.rotation*Math.PI/180)*2; 
				police.y-=6*Math.sin(police.rotation*Math.PI/180)*2;
			}
			if (bullet.x < 0 || bullet.x > 550 || bullet.y < 0 || bullet.y > 400) {
       	 		bullet.removeEventListener(Event.ENTER_FRAME, bulletEnterFrame); 
				this.removeChild(bullet);
				bulletgone = "yes";
			}
    	}
		
		public function pbulletEnterFrame(event:Event) {
			pbullet.x += Math.cos(pangleRadian)*speed;
			pbullet.y += Math.sin(pangleRadian)*speed;
   			var pangleDegree = pangleRadian * 180 / Math.PI;
			pbullet.rotation = pangleDegree;
			
			if (pbullet.hitTestObject(blackperson)) {
				pbullet.removeEventListener(Event.ENTER_FRAME, pbulletEnterFrame); 
				this.removeChild(pbullet);//gunshot.play();
				pbulletgone = "yes";
				Health -= 4;
				blackperson.x-=2*Math.cos(blackperson.rotation*Math.PI/180); 
				blackperson.y-=2*Math.sin(blackperson.rotation*Math.PI/180);
			}
			if (pbullet.x < 0 || pbullet.x > 550 || pbullet.y < 0 || pbullet.y > 400) {
       	 		pbullet.removeEventListener(Event.ENTER_FRAME, pbulletEnterFrame); 
				removeChild(pbullet);//gunshot.play();
				pbulletgone = "yes";
			}
    	}
				
		public function keyDownHandler(event:KeyboardEvent):void {
			switch(event.keyCode) {
				case 87: // up arrow
					blackperson.x+=2*Math.cos(blackperson.rotation*Math.PI/180)*2; 
					blackperson.y+=2*Math.sin(blackperson.rotation*Math.PI/180)*2;
				break;
				
				case 83://down
				blackperson.x-=2*Math.cos(blackperson.rotation*Math.PI/180); 
				blackperson.y-=2*Math.sin(blackperson.rotation*Math.PI/180);
				break;
				
				case 68 ://developer mode
				if (developOn == "false") {
					 dMode.visible = true;
					developOn = "true";
				}
				else if (developOn == "true") {
					dMode.visible = false;
					developOn = "false";
				}
				break;
				
			}
		}
	
	}	
}