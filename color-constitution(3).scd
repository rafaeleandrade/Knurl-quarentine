/***** color-constitution.scd *****/

//A
//ressonance 
//Spectrum gap
//B
//friction
//ressonance
//C
//centroid
//converb

(


//color definition
// 1.do{
// ~voicea = nil;
// ~voiceb = nil;
// ~voicec  = nil;
// ~ta = nil;
// ~tb = nil;
// ~tc = nil;
// "color nil".postln;
// };



OSCdef(\color, {arg msg ;
	var id = msg[2], freq = msg[3], classif = msg[4], centroid = msg[5], sp1 = msg[6], sp2 = msg[7],sp3=msg[8],sp4=msg[9],sp5=msg[10],sp6=msg[11] ; 
	var sig,in;
	var delay, f1,f2, rgz, freqLag,nlf, hasFreq,speed,sound, proc , chaos,env ;
	var enva, pan,gate;
	var ta,tb,tc;
	var delrd, output,deltimes;
	
	// msg[2..].postln;

	freqLag=XLine.kr(0.2,2.6,5);
	speed=10  ;
	gate =1;
	// volume, freqLag,whitenoise, delay

	//------------------------------------------------------voice a
	if(classif <= 2){
		if (~va1 == nil) { 1.do{
			"color a1: gap spectrum".postln;
			b.sendMsg("/tr", "CL-a1: gap spectrum");
					~va1 = SynthDef(\voiceaum,
						{  |gate=1| var env;
	/*				sp1 = sp1.exprange(0.14 ,0.001) ; // iphase width
					sp2 = sp2.exprange(0.6, 0.1) ; // iphase  mul
					sp3 = sp3.exprange(0.097,0.7);  //freq phase
					sp4 = sp4.exprange(12,40);  // teeth
					sp5 =sp5.exprange( 2, 8 ); //voulme
					//sp6 = ()*/
						 env = EnvGen.kr(Env.asr(10, 0.03, 0.3,4), gate, doneAction:1);
						Out.ar([0,1],Limiter.ar( IFFT( PV_RectComb(FFT(LocalBuf(128), SoundIn.ar([0,1],2)),
						sp5,
						LFTri.kr(sp4, 0, 0.5, 0.9),   //phase
						LFTri.kr(0.5, 0, -0.5, 0.5));   //width
						),2))
						}).play;
	
			// ~va1 = Synth(\voiceaum);
			if(~va2 !=  nil) {~va2.set(\gate,-2);  ~va2=nil };
			}
		};
	}{
	if ( ~va2 == nil) {
		1.do { 
			"color a2: ressonance".postln;	
				b.sendMsg("/tr", "CL-a2: ressonance");
			~va2 = SynthDef(\voiceadois, { |gate = 1,speed=10 | 
			var f1,f2,delay,env,sig,freqLag;
			freqLag= XLine.kr(0.2,2.6,5);
				f1 = freq.lag(freqLag);
				f2 = freq.lag(freqLag * 0.5);
				delay = 0.25 / f2;
				env = EnvGen.kr(Env.asr(3, 0.03, 0.3,4), gate, doneAction:1);
				sig = WhiteNoise.ar(180);
				sig = CombL.ar(sig, delay, delay, 1);
				sig = Resonz.ar(sig, f1, 0.001).abs;
				Limiter.ar(sig*env,2);
			}).play;

		 	if(~va1 != nil) {~va1.set(\gate,-2); ~va1=nil } ;
		}
	};
	
	};


	//------------------------------------------------------voice b
		if(classif == 3){
		if (~vb1 == nil)  {
			"CL-b1: friction".postln;
			b.sendMsg("/tr", "CL-b1: friction");
			~vb1 = SynthDef(\voicebum, { |gate=1| var env;
	env = EnvGen.kr(Env.asr(3, 0.03, 0.3), gate, doneAction:2);
	Out.ar([0,1],Limiter.ar(
	Friction.ar(SoundIn.ar(0,2), friction: XLine.kr(20,5.41322e-5), spring: XLine.kr(0.5,0.8,4),mass: XLine.kr(30,8.05501,4))*env,8
	))
}).play;
			// ~vb1 = Synth(\voicebum);
			~vb2.set(\gate,-2);
			}
	}{ 	if (~tb == nil) {

		~tb = Tdef(\stopb,{  1.do { 
			 "CL-b2: reverb".postln; 
			 b.sendMsg("/tr", "CL-b2: reverb");
	  		~vb2 = Synth(\voicebdois);
			if (~vb1 != nil){~vb1.set(\gate,-2);};
			
			12.wait; 
			~vb2.set(\gate,-2);  ~vb1 = nil; ~tb.stop; ~tb.reset; ~tb = nil}});
		~tb.play  
		
	}};

	//------------------------------------------------------voice c

		if(classif >3){
		if (~vc1 == nil) {
			"cl-c1: chaos".postln;
			 b.sendMsg("/tr", "CL-c1: chaos");
			~vc1 = Synth(\voicecum); 
			{if (~vc2 != nil){ ~vc2.set(\gate, -4); ~vc2 = nil}}
		}
	}{ 	if (~tc == nil) {
	
		~tc = Tdef(\stopc,{  1.do {  
			"color c2: converb".postln;
			 b.sendMsg("/tr", "CL-c2: converb");
			~vc2 = Synth(\voicecdois); 
			if (~vc1 != nil){	~vc1.set(\gate,-2)};
			20.wait;
			~vc1.set(\gate,-2);  ~vc1 = nil; ~tc.stop; ~tc.reset; ~tc = nil}});
		~tc.play  
	}};

},"/color");
);


