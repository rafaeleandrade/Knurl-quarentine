/***** synth-color.scd *****/
(
k = 5;
~ndims = 1;
~kbuf = Buffer.alloc(s, k, ~ndims+1);


 SynthDef(\mic,{ |gate = 1, amp = 6.6, k =5|
 	var in, freqT, hasFreq, sp1,sp2,sp3,sp4,sp5,sp6;
	  var chain, chaintrig, features, kbuf, classif, centroid, resynth;

	in = Limiter.ar(SoundIn.ar(0),amp);
	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02, median: 0.7);
	// freqT.poll;

	// sp1= 0.1;//MouseX.kr(0,1);
	// sp2= 0.1;//MouseX.kr(0,01);
	// sp3= 0.1;//MouseX.kr(0,001);
	// sp4= 0.1;//MouseX.kr(0,08);
	// sp5= 0.1;//MouseX.kr(2,6);
	// sp6= 0.1;//MouseX.kr(0,7);
	
	sp1 = AnalogIn.kr(0).exprange(2,6); //volume
	sp2 = AnalogIn.kr(1).(0.14 ,0.001) ; // iphase width
	sp3 = AnalogIn.kr(2).exprange(0.6, 0.1) ; // iphase  mul
	sp4 = AnalogIn.kr(3).exprange(0.097,0.7);  //freq phase
	sp5 = AnalogIn.kr(4).exprange(12,40);  // teeth
	sp6 = AnalogIn.kr(6).exprange( 2, 8 ); //voulme

	chain = FFT(LocalBuf(128), in);
    chaintrig = chain > -0.0001;

    features = [SpecCentroid.kr(chain)]; // just one 1D feature here
    classif = KMeansRT.kr(~kbuf, features, k, chaintrig);
	// classif.poll(chaintrig);

    // Now we read the centroid position back out of the buffer and sonify
    centroid = KMeansRT.getCentroid(~kbuf, classif, ~ndims).at(0);

   // resynth = SinOsc.ar(centroid, 0, 0.1);

	SendReply.kr(Impulse.kr(0.1), "/color",[freqT, classif,centroid,sp1,sp2,sp3,sp4,sp5 ,sp6], 106);
	// [sig, resynth]

/*	OffsetOut.ar([0,1], in!2);*/
}).play;


// SynthDef(\res, {
// 	var env , sound;
// 	sound = Resonz.ar(WhiteNoise.ar(XLine.kr(0.3,0.6,60)), XLine.kr(1,80,4,XLine.kr(1,0.7,20)), 0.05);
// 	env =EnvGen.kr(Env.asr(3, 1.3, 0.3,4), 1, doneAction:2);
// 	Out.ar([0,1],sound*env)}).add;


// SynthDef(\backnoise, {
// 	var imp, klank, rusty,env;
// 	imp = WhiteNoise.ar(0.3);
// 			klank = Ringz.ar(imp, 0.1*[8, 10, 11, 17]);
// 			env = EnvGen.kr(Env.asr(10, 0.03, 0.2,4), 1, doneAction:2);
// 			rusty = Friction.ar(klank,
// 			friction: 10.75584e-5,
// 			mass: 4.69789)*env;
// 			/*Pan2.ar(rusty*env,level:0.01)*/
// 	Out.ar([0,1],Limiter.ar(rusty*env,1));}).add;
	
// ~neutral = Synth(\res);

// ~noise = Synth(\backnoise);


(
	
// SynthDef(\voiceaum,	{  |gate=1| var env;
// 	/*				sp1 = sp1.exprange(0.14 ,0.001) ; // iphase width
// 					sp2 = sp2.exprange(0.6, 0.1) ; // iphase  mul
// 					sp3 = sp3.exprange(0.097,0.7);  //freq phase
// 					sp4 = sp4.exprange(12,40);  // teeth
// 					sp5 =sp5.exprange( 2, 8 ); //voulme
// 					//sp6 = ()*/
// 		 env = EnvGen.kr(Env.asr(10, 0.03, 0.3,4), gate, doneAction:1);
// 		Out.ar([0,1],Limiter.ar( IFFT( PV_RectComb(FFT(LocalBuf(512), SoundIn.ar([0,1],6)),
// 						sp5,
// 						LFTri.kr(sp4, 0, 0.5, 0.9),   //phase
// 						LFTri.kr(0.5, 0, -0.5, 0.5));   //width

// ),1))
// }).add;

// ~va1 = Synth(\voiceaum);
// ~va1.set(\gate,-2);

// SynthDef(\voiceadois, { |gate = 1,speed=10 | 
// 		var f1,f2,delay,env,sig,freqLag;
// 		freqLag= XLine.kr(0.2,2.6,5);
// 				f1 = freq.lag(freqLag);
// 				f2 = freq.lag(freqLag * 0.5);
// 				delay = 0.25 / f2;
// 				env = EnvGen.kr(Env.asr(3, 0.03, 0.3,4), gate, doneAction:1);
// 				sig = WhiteNoise.ar(180);
// 				sig = CombL.ar(sig, delay, delay, 1);
// 				sig = Resonz.ar(sig, f1, 0.001).abs;
// 				Limiter.ar(sig*env,1);
// 			}).add;

// ~va2 = Synth(\voiceadois);
// ~va2.set(\gate,-2);

SynthDef(\voicebum, { |gate=1| var env;
	env = EnvGen.kr(Env.asr(3, 0.03, 0.3,4), gate, doneAction:1);
	Out.ar([0,1],Limiter.ar(
	Friction.ar(SoundIn.ar(0,2), friction: XLine.kr(20,5.41322e-5), spring: XLine.kr(0.5,0.8,4),mass: XLine.kr(30,8.05501,4))*env,1
	))
}).add;

	// ~vb1 = Synth(\voicebum);
	// ~vb1.set(\gate,-2);

SynthDef(\voicebdois, { |gate = 1|
			var enva, sound;
	enva = EnvGen.kr(Env.asr(1, 1, 0.2,4), gate, doneAction:2);
	sound = FreeVerb.ar(SoundIn.ar([0,1],1),0.3.rand,0.8.rand);
	Out.ar([0,1],Limiter.ar(sound*enva,1));
}).add;


	// ~vb2 = Synth(\voicebdois);
	// ~vb2.set(\gate,-2);


SynthDef(\voicecum, { |gate = 1|
			var enva, sound;
			enva = EnvGen.kr(Env.asr(1, 1, 0.2,4), gate, doneAction:2);
			sound = SoundIn.ar([0,1], Gendy3.ar(freq: [XLine.kr(0.7,2,19)], durscale: 0.1, mul:1));
	Out.ar([0,1],Limiter.ar(sound*enva,1));
			}).add;

	// ~vc1 = Synth(\voicecum);
	// ~vc1.set(\gate,-2);


SynthDef(\voicecdois, { arg gate = 1;
	var input, output, delrd, sig, deltimes, env;

	// Choose which sort of input you want by (un)commenting these lines:
	// input = Pan2.ar(PlayBuf.ar(1, b, loop: 0), -0.5); // buffer playback, panned halfway left
	input = SoundIn.ar(0,1); // TAKE CARE of feedback - use headphones
	//input = Dust2.ar([0.1, 0.01]); // Occasional clicks

	// Read our 4-channel delayed signals back from the feedback loop
	delrd = LocalIn.ar(4);

	// This will be our eventual output, which will also be recirculated
	output = input + delrd[[0,1]];

	env = EnvGen.kr(Env.asr(0.1, 0.3, 1.3), gate, doneAction:2);
	// Cross-fertilise the four delay lines with each other:
	sig = [output[0]+output[1], output[0]-output[1], delrd[2]+delrd[3], delrd[2]-delrd[3]];
	sig = [sig[0]+sig[2], sig[1]+sig[3], sig[0]-sig[2], sig[1]-sig[3]];
	// Attenutate the delayed signals so they decay:
	sig = sig * [0.4, 0.37, 0.333, 0.3];

	// Here we give delay times in milliseconds, convert to seconds,
	// then compensate with ControlDur for the one-block delay
	// which is always introduced when using the LocalIn/Out fdbk loop
	deltimes = [101, 143, 165, 177] * 0.001 - ControlDur.ir;

	// Apply the delays and send the signals into the feedback loop
	Out.ar([0,1],DelayC.ar(sig, deltimes, deltimes));

	// Now let's hear it:
	output

}).add;

	// ~vc2 = Synth(\voicecdois);
	// ~vc2.set(\gate,-2);

)


)
