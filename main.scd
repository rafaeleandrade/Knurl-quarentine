/**
(C) 2020 Rafaele Andrade

**/

s = Server.default;

s.options.numAnalogInChannels = 2; // can be 2, 4 or 8
s.options.numAnalogOutChannels = 2; // can be 2, 4 or 8
s.options.numDigitalChannels = 16;
s.options.maxLogins = 8;

s.options.pgaGainLeft = 6;     // sets the pregain for the left audio input (dB)
s.options.pgaGainRight = 6;    // sets the pregain for the right audio input (dB)
s.options.headphoneLevel = 0; // sets the headphone level (-dB)
s.options.speakerMuted = 1;    // set true to mute the speaker amp and draw a little less power

s.options.dacLevel = 6;       // sets the gain of the analog dac to (dB)
s.options.adcLevel = 0;       // sets the gain of the analog adc to (dB)

s.options.blockSize = 128;//512; //1
s.options.numInputBusChannels = 10;
s.options.numOutputBusChannels = 2;  

s.options.sampleRate= 88200;
s.options.maxNodes = 1024 * 64; // increase this if you are getting drop outs and the message "too many nodes"
s.options.numAudioBusChannels = 1024;
s.options.memSize = 8192 * 32; // the default is 8192 which is quite little
s.options.hardwareBufferSize = 128;
 
   //send to timo
//changing the income portnumber
thisProcess.openUDPPort(8000); //8000 is to send to timo

// z = NetAddr.new("169.254.236.203", 9000);     //timo address    (rafa is active)
// b.sendMsg("/rafa", "Hello App 1");

b = NetAddr.new("127.0.0.1", 7562);    // create the NetAddr
// c = Buffer.alloc(s, 7.0, 1);

// r = NetAddr.new("127.0.0.1", 57120); // rafa computer address  //   192.168.2.5


s.waitForBoot {
	
// c = Buffer.alloc( s, 5.0 * s.sampleRate, 1);

// ~master = EnvGen.kr(Env.adsr(3, 0.01, 0.8, 3, 0.6, 0.01), gate, doneAction: 1);   ///its not so simple, because you depend of a variable from gate, you have to variable through the env inside

		// Curve of expectation
		// "curveofexpectation".loadRelative;

		//load synths & trackers
		"externalsynths.scd".loadRelative;  
		"synth_analoguemode.scd".loadRelative;
		"synth_synthmode.scd".loadRelative;
		"synth-color.scd".loadRelative;
		// "synth-detectmode.scd".loadRelative;
		
		"set_trillraw.scd".loadRelative;
		// // "set_coderaw.scd".loadRelative;
		
		//load oscdefs
		"color-constitution.scd".loadRelative;
		"osc_synthmode.scd".loadRelative;
		"osc_analoguemode.scd".loadRelative;
		// // "osc_detectionmode.scd".loadRelative;
		// "osc_programmingmode.scd".loadRelative;
		



		// ~master = EnvGen.kr(Env.adsr(3, 0.01, 0.8, 3, 0.6, 0.01), 1, doneAction: 1); //EnvGen.kr(Env.new(levels: [~a.exprange(0.01,1.1), ~s, ~r], times: [~at, ~st, ~rt], curve: [~ac,~ar,~at]), doneAction: Done.freeSelf)
		//"curveofexpectation".loadRelative;


//receive from timo
// (
// OSCdef.new(\rafa, { arg msg,time,addr,port;
// 	// [msg,time,addr,port].postln;
	
// 	loop{
// 	["Timo:" ++ msg].postln;
// 	// z.sendMsg("/rafa", "Hello Mercury");
// 	r.sendMsg("/rafa", "Hello rafa's computer");
// 	1.wait;
// 	}
// }, '/rafa/yourMessage')
// );

s.sync;
}
