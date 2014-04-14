﻿package adcha
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.MouseEvent;
	import flash.events.KeyboardEvent;
	import flash.events.Event;
	
	public class DocumentClass extends MovieClip
	{
		//initialise global variables
		public static var inputString:String;
		private const startFreq:Number = 6.875;
		private var freqs:Array = new Array();
		private var noteNames:Array = new Array();
		private var freqsCounter:Number;
		private var freqsRounded:Number;
		private const coeff:Number = Math.pow(2,1/12);
		private var inputNum:Number;
		private var ioDiff:Number;
		private var ioDiffTemp:Number;
		public static var bestIndex:uint;
		private var haveLooked:Boolean = false;


		//startup
		public function DocumentClass():void
		{
			//set the counter to begin at startFreq
			freqsCounter = startFreq;
			
			nanWarning.visible = false;
			tooLargeWarning.visible = false;
			
			//because the loop can't include a line
			//to just add startFreq to the array without multiplying it,
			//add that value to the array here.
			freqs.push(freqsCounter);
			
			//addEventListener(Event.ENTER_FRAME, loop)
			submitButton.addEventListener(MouseEvent.MOUSE_DOWN, clickPasser)
			stage.addEventListener(KeyboardEvent.KEY_DOWN, returnPasser)
			
			generateFreqs();
			generateNoteNames();
			//trace(freqs[freqs.length-1]);
		}
		
		private function generateFreqs(arrayLength:uint = 180, dp:uint = 5)
		{
			//create the number to round by. Defaults to 10,000.
			var dp2:uint = Math.pow(10, dp);
			
			//generate _arrayLength_ number of frequencies, and add them to an array.
			for(var i = 0; i < arrayLength; i++)
			{
				//multiply our counter by our special musical constant
				freqsCounter *= coeff;
				
				//add the /rounded/ version to the array, to prevent 55.0000002 from happening;
				//but calculate further numbers with the unrounded version to avoid round error.
				
				//this is done because of flash's imperfect floating number system.
				//read ch4 of the Adobe AS3 programming guide: page 57.
				freqsRounded = (Math.floor(freqsCounter * dp2)) / dp2
				freqs.push(freqsRounded);
			}
		}
		
		private function generateNoteNames():void
		{
			while(noteNames.length < freqs.length)
			{
				noteNames.push("A ");
				noteNames.push("A#");
				noteNames.push("B ");
				noteNames.push("C ");
				noteNames.push("C#");
				noteNames.push("D ");
				noteNames.push("D#");
				noteNames.push("E ");
				noteNames.push("F ");
				noteNames.push("F#");
				noteNames.push("G ");
				noteNames.push("G#");
			}
		}
		
		private function doIt():void
		{
			//get the number from the string, which got it from the inputbox.
			
			haveLooked = false;
			
			//maximum initial difference that numbers will be considered with.
			//don't forget that the higher the frequency,
			//the greater the Hz between freqs,
			//so this has to be pretty high for that reason.
			ioDiff = 500;
			//trace("arrayIndexA:"+freqs[i]);
			
			//check the input frequency against each frequency in the array
			//whenever the positived difference is smaller, store the difference and its index
			//when the difference starts getting bigger again, stop checking.
			for(var i = 0; i < freqs.length; i++)
			{
				//trace("stillsearching:"+stillSearching);
				ioDiffTemp = inputNum - freqs[i];
				//positivise the difference
				ioDiffTemp = Math.sqrt((ioDiffTemp * ioDiffTemp))
				//trace("arrayIndexB:"+freqs[i]);
				trace(ioDiffTemp);
								
				if(ioDiffTemp < ioDiff)
				{
					ioDiff = ioDiffTemp;
					trace(ioDiff);
					bestIndex = i;
					outputFreq.text = freqs[bestIndex];
					outputNote.text = noteNames[bestIndex];
					trace("looking");
					haveLooked = true;
					
				}
				
				if (ioDiffTemp > ioDiff
				&& haveLooked == true)
				{
					//well then hell, mary, we've got ourselves a rodeo!
					trace("END SEARCH");
					break;
				}
				
				//it has to be < ioDiff on every loop, otherwise it aborts
				//i havent let it carry on till it WAS < ioDIff, I just aborted it.
				//this means anything further from startFreq 
				//than the ioDiff initial threshold of 200 just wouldnt run. baaad.
				//I need to a new way to make my code efficient.
			}
		}
				
		//if a click is detected on the submitbutton, activate checkInput.
		private function clickPasser(e:MouseEvent)
		{
			submitButton.gotoAndPlay(2);
			checkInput(inputFreq);
		}
		
		//if a 'return' keypress is detected anywhere, activate checkInput.
		private function returnPasser(key:KeyboardEvent)
		{
			if(key.keyCode == 13)
			{
				checkInput(inputFreq);
			}
		}
		
		private function checkInput(inputBox:TextField)
		{
			tooLargeWarning.visible = false;
			nanWarning.visible = false;
			for(var i = 0; i < inputBox.length; i++)
			{
				inputString = inputBox.text;
				//each inputted letter MUST match one of these!
				//I considered an array for the valid chars, but not sure how, so cba.
				if(inputString.charAt(i) == "0"
				|| inputString.charAt(i) == "1"
				|| inputString.charAt(i) == "2"
				|| inputString.charAt(i) == "3"
				|| inputString.charAt(i) == "4"
				|| inputString.charAt(i) == "5"
				|| inputString.charAt(i) == "6"
				|| inputString.charAt(i) == "7"
				|| inputString.charAt(i) == "8"
				|| inputString.charAt(i) == "9"
				|| inputString.charAt(i) == ".")
				{
					//trace("aok mista!");
					nanWarning.visible = false;
					if(i == (inputBox.length - 1))
					{
						inputNum = Number(inputString);
						if(inputNum <= 21000)
						{
							//trace("LESS DOOEET");
							doIt();
						}
						else
						{
							tooLargeWarning.visible = true;
						}
					}
				}
				else
				{
					trace("WRAWNG!");
					nanWarning.visible = true;
				}
			}
		}
		
	}
	
}