/***** osc_synthmode.scd *****/
(
c = Buffer.alloc( s, 5.0 * s.sampleRate, 1);
//reaction

//1 - REC
SynthDef( \record_my_voice, {
		arg buf = 0;
		var input = SoundIn.ar( 0,1 );
		RecordBuf.ar( input, buf, loop: 0, doneAction: 2 );
	}).add;

	SynthDef(\a1, { arg out=0, bufnum=0, gate = 1;
		var trig, env, sig, playbuf;
	trig = Impulse.kr(AnalogIn.kr(1).exprange(0.5,200)); //MouseY.kr(0.5, 200, 1));
		env = EnvGen.kr(Env.adsr(2, 3, 2.3, 3, 0.8, 2), gate, doneAction: 2);
	playbuf = PlayBuf.ar(1, bufnum, BufRateScale.kr(c.bufnum), trig, AnalogIn.kr(2).exprange(0.001,BufFrames.kr(c.bufnum),10 ), 1);
		sig = env * playbuf;
		Out.ar([0,1], sig*2)
	}).add;

SynthDef(\a3,{ |amp= 0.18, out = 0 , gate = 1|
	 var in ,freqT, hasFreq,env, ampG, n,pit;
n=LFNoise1;
in = SoundIn.ar(0,1);
	ampG = AnalogIn.kr(1).exprange(0.2,5);
env = EnvGen.kr(Env.asr(0.1, 0.3, 0.7), gate, doneAction:2);
// #freqT, hasFreq = Tartini.kr(in,2.9,128,overlap: 128);
#freqT, hasFreq = Pitch.kr(in,ampThreshold: 0.001,median: 7);   //, ampThreshold: 0.02,median: 7
/*freqT = freqT * hasFreq;
pit = Latch.kr(freqT,Impulse.kr(1));
pit.poll;*/
a=SinOsc.ar(freqT,in*LFNoise2.ar(0.1,3),LFNoise1.ar(3,2));
a = AllpassL.ar(a,0.03,{0.5.rand+0.1}!2,1,0.2);
Out.ar(out, a!2*env*amp)}).add;

//4 - Auditory feeedback
SynthDef(\a4, {|drive = 1, rotSpeed = 1, posLag = 0.1, shifter = 1, gate = 1|
	var in, pos, width, sig, sig2, sig2pan, out, chain, centroid;
	var freq, hasFreq, freq2, hasFreq2,env;
	var numOutChans = 4;
	var numInternalChannels = 4;

	in = SoundIn.ar(0);  // input
	env = EnvGen.kr(Env.adsr(3, 0.01, 0.8, 3, 0.6, 5), gate, doneAction: 2);
	width = \width.kr(4);

	// calculate spectral centroid (center of mass)
	// do some magic to scale it properly
	centroid = ((
		SpecCentroid.kr(
			FFT(LocalBuf(64, 1), in)  //2048
		) * 0.0005
	) - 0.3 ) * 10;

	// new position determined by centroid, linearly lagged
	pos = VarLag.ar(K2A.ar(centroid), posLag, 0) * rotSpeed;

	sig = PanAz.ar(
	     numInternalChannels,
	     in,
	     pos,
	     0.5,
	     width
	);

	// Freezr
	#freq, hasFreq = Pitch.kr(
		in,
		ampThreshold: 0.02,
		median: 7
	);
	freq = freq * hasFreq * 0.01;


	chain = FFT({LocalBuf(64, 1)}.dup(4), sig);
	chain = PV_MagFreeze(
		chain,
		SinOsc.ar(
			(freq*AnalogIn.kr(0).exprand(100,400)).lag2(\laggin.kr(0.8), 0)
		)
	);

	sig2 = IFFT(chain);
	sig2pan = SplayAz.ar(
		numInternalChannels,
		sig2,
		center: LFSaw.ar(0.125)
	);

	sig = PitchShift.ar(sig, 0.05, shifter, 2);

	Out.ar(0,(SplayAz.ar(
		numOutChans,
		Mix([sig, sig2pan]).scramble
	) * drive)*env*30);  //tanh
}).add;

//1 freq shift
	SynthDef(\b1,
	{| in=0, out=0, feedback=0.4, delay=0.2, shiftFreq=2000, shiftDens=0.1,gate=1|
	var sig, effect,env,amp;
	sig = SoundIn.ar(in, 2);
	amp = 3;//AnalogIn.kr(2).exprand(1.7,5.8);  //5.8;
	env = EnvGen.kr(Env.adsr(3, 0.01, 0.8, 3, 0.6, 2), gate, doneAction: 2);
	effect = sig + LocalIn.ar(2);
	effect = FreqShift.ar(effect, LFNoise2.ar(shiftDens, shiftFreq));
	effect = DelayC.ar(effect, delay, GbmanN.ar(1).range(0.1,0.2));
	LocalOut.ar(effect * feedback);
		Out.ar([0,1], effect*env*amp)}).add;

SynthDef(\b2,
	{|out=0, amp=0.05, surface=0.0, freq=100, atk=0.02, sus=0.02, rel=2, pan=0.2,gate=1.0,curve=2,
	hpf=40, lpf=18500, ampModFreq=15, ampModAmt=0.01|
	var ampa=0.5, ampb=1.0, ampc=0.4, ampd=0.8;
	var afreq = AnalogIn.kr(0).exprange(1, 3.5);
	var adur = AnalogIn.kr(1).exprange(pan, 0.001);
	var aamp = AnalogIn.kr(2).exprange(amp, 0.5);
 	var signal, osca, oscb, oscc, oscd, distorted, in,env,freqT, hasFreq,frequencies,amplitudes,ampIn , freqMod;
 	var downsamp, samplerate=8000, bitsize=15;
	in = SoundIn.ar(0);
	//# freqT, hasFreq = Tartini.kr(in,0.9,16,8,overlap: 256);
	#freqT, hasFreq = Pitch.kr(SoundIn.ar(0), ampThreshold: 0.02,median: 7);
	ampIn = Amplitude.ar(in);
	freqMod = LinLin.ar(ampIn,0.001,0.05,0.2,0.6);
	env = EnvGen.ar(Env.new([0, 0.2, 0.2, 0],[atk, sus, rel], curve, 2), gate, doneAction:2);
	frequencies=[ freq-freqMod,  freqT,  freqT + freqMod,  freqT +  (freqMod * 2)] * afreq ;
	amplitudes=[ampa,ampb,ampc,ampd];
	osca = LFTri.ar(frequencies[0], mul:ampa) * env;
	oscb = LFTri.ar(frequencies[1], mul:ampb) * env;
	oscc = LFTri.ar(frequencies[2], mul:ampc) * env;
	oscd = LFTri.ar(frequencies[3], mul:ampd) * env;
	signal = (osca + oscb + oscc + oscd) * amp;
	downsamp = Latch.ar(signal, LFTri.ar(samplerate*0.5));
	distorted = downsamp.round(0.5 ** bitsize);
	signal = (signal * (1 - surface)) + (distorted * surface);
	signal = signal * SinOsc.ar(ampModFreq).range(1-ampModAmt, 1);
	signal = HPF.ar(LPF.ar(signal, lpf), hpf);
		signal = Ringz.ar(signal * aamp, XLine.kr(4000,8000,100), 0.08) ;
		signal = Pan2.ar(signal,SinOsc.ar(adur));
	Out.ar(out, signal);
}).add;




//saw   -esse tem um final porque é muito pesado

SynthDef(\b3, {
	|out=0, amp=0.7 atk=1.6441, sus=0.2, rel=12.92, mod=1.8, pan=0.0, gate=1.0,
	numHarmonics=10, duration=#[4,3], lop=17000|
	var in , peak, pitch , haspit, freq, env, gatel, amount , lfo, blip , blip2, signal;
	 in = SoundIn.ar(0);
	peak = Peak.ar(in, Impulse.kr(Amplitude.kr(in)));
	// # pitch, haspit =Tartini.kr(in,0.9,512,256,overlap: 256);
	#pitch, haspit = Pitch.kr(in,ampThreshold: 0.021,median: 7); 
	// pitch.poll;
	freq= [pitch*0.3,pitch*0.01];
	env = EnvGen.ar(Env([0, 1, 0.7, 0], [atk, sus, rel,0.2],[2,1,1]), gate, amp, doneAction:1);
	gatel = Gate.kr(env, peak);
	amount = mod;
	lfo = SinOsc.ar(XLine.kr( freq *0.24 , 0.001, duration), 0, 0.5, 0.5);
	 blip = Blip.ar(freq, XLine.ar(numHarmonics,numHarmonics/10,duration), 0.75);
	 blip2 = Blip.ar(freq/2, XLine.ar(numHarmonics,numHarmonics/2,duration * 0.5), 0.75);
	 signal = (blip + blip2) * 0.5;
	signal = RLPF.ar(signal, lop, 1);
	signal = (signal * (lfo * amount)) + (signal * (1 - amount));
	OffsetOut.ar(out, Pan2.ar(signal*env, pan)!2);
	}).add;




// hildur
SynthDef(\b4, { |gate =1|
var a=GrayNoise.ar;
var b=(1..6);
var 	env = EnvGen.kr(Env.asr(0.1, 0.01, 1), gate, doneAction:2);
Out.ar([0,1],CombL.ar(a,1,b/Duty.ar(2,0,Dseq([0.5,1,2,3]*XLine.kr(99,XLine.kr(50,90,60),30),99)).lag3(1)).mean/2+Ringz.ar(a/99,b*99).mean*env)}).add;


//space
SynthDef(\c1, { |out, gate = 1,
    amps (#[1, 0.8, 0.2, 0.1]),
    rings (#[1, 1, 1, 2])|
    var in, freqs, hasFreq,env,amp,sig,mult,signal;
	// amp = AnalogIn.ar(0);
	in = SoundIn.ar(0);
	amp = Amplitude.kr(in);
	mult = LinLin.kr(amp,0,0.2, 1.1,2.1);
	/*mult = MouseX.kr(1.01,2.1);*/
	freqs = (#[146.83, 293.66,415.30]*mult);
	env = EnvGen.kr(Env.asr(0.1, 0.3, 1.3), gate, doneAction:2);
	sig =DynKlank.ar(`[freqs, amps, rings], WhiteNoise.ar*0.006);
	signal = Pan2.ar( sig, SinOsc.kr(XLine.kr(0.6,0.2,16)));
	OffsetOut.ar([0,1],XLine.kr(0.01,0.2,12)* signal*env!2)
}).add;

//Sachoir
SynthDef(\c2, {
	|out=0, amp=0.15, freq=100, atk=0.1, sus=0.2, rel=0.2, mod=0.8, pan=0.5, gate=1.0, curve=1,
	modFreq=1040.1, modDur=0.9, modFrom=0.02, modTo=0.8, rateFrom=4, rateTo=8, grEnvAtk=0.1, grEnvRel=0.5|
	var sig, env, osca, oscb, oscc, oscd, in , ampIn, afreq,adur,aamp,modfreqsc, freqT, hasFreq,pit;
	in = SoundIn.ar(0);
	//# freqT, hasFreq = Tartini.kr(in,0.9,128,overlap: 128);
	#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02,median: 7);
	//freqT = freqT * hasFreq;
	pit = Latch.kr(freqT,Impulse.kr(1));
	freqT = Median.kr(3,freqT);
	ampIn = Amplitude.ar(in);
	modfreqsc = LinLin.ar(ampIn,0.001,0.1,1.5,2);
	adur = AnalogIn.kr(0).exprange(rateTo, 3);
	afreq = AnalogIn.kr(1).exprange(modDur, 1.6);
	aamp = AnalogIn.kr(2).exprange(amp, 1.6);
	env = EnvGen.ar(Env([0, 0.13, 0.24, 0], [atk, sus, rel], [4,2,-2], curve), gate, aamp, doneAction:2);
	osca = PMOsc.ar(freqT, modFreq * modfreqsc, Line.kr(modFrom, modTo, modDur),mul:0.1) * 0.3 ;
	oscb = PMOsc.ar(freqT * 0.5, modFreq * 0.25, Line.kr(modFrom, modTo, modDur*2)) * 0.1 ;
	oscc = PMOsc.ar(freqT* 1.5, modFreq, Line.kr(modFrom, modTo, modDur)) * 0.05 ;
	oscd = PMOsc.ar(freqT * 0.25, modFreq * 0.15, Line.kr(modFrom, modTo, modDur*2)) * 0.2 ;
	sig = HPF.ar(osca + oscb + oscc + oscd, 40, 0.5);
	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, adur, afreq)));
	sig = Pan2.ar(sig, SinOsc.ar(XLine.kr(pan,0.1,5)));
   	OffsetOut.ar(out, sig*env);
}).add;

//Sichoir
SynthDef(\c3, {
	|out=0, amp=3.9, freq=30, atk=0.1, sus=0.2, rel=0.2, mod=0.8, pan=0.4, gate=1, curve=1,modFreq=80.1, modDur=0.24, modFrom=0.02, modTo=0.8, rateFrom=4, rateTo=12, grEnvAtk=0.1, grEnvRel=0.5|
	var sig, env, osca, oscb, oscc, oscd, in, amc,pita,pitc,pitb,pitd, pit, pity, pite,hasFreq,ampOut;
	in = SoundIn.ar(0,10);
	amc = Amplitude.kr(in);

	//#pit, hasFreq =  Tartini.kr(in,0.9,128,overlap:128);
	#pit, hasFreq = Pitch.kr(in, ampThreshold: 0.09,median: 7);
	pity = Latch.kr(pit,pit * hasFreq);

	pita = Gate.kr(pity, Impulse.kr(0.9));
	pitb = Gate.kr(pity*3, Impulse.kr(0.7));
	pitc = Gate.kr(pity*0.2, Impulse.kr(0.1));
	pitd = Gate.kr(pity*0.7, Impulse.kr(0.3));
	pite = Gate.kr(pit, Impulse.kr(0.19));
	modFreq =AnalogIn.kr(0).exprange(modFreq,200);
	ampOut = 0.08;
	/*pit.poll;*/
	env = EnvGen.ar(Env([0, 1, 1, 0], [atk, sus, rel], [4,2,-2], curve), gate, 1, doneAction:2);
	osca = PMOsc.ar([pita +45,pita+95], 1 * 2, Line.kr(modFrom, modTo*0.1, modDur)) * 0.8 ;
	oscb = PMOsc.ar([pit,pitb+65] * 1/2, pitb * 0.25, Line.kr(modFrom, modTo*0.5, modDur*2)) * 0.3 ;
	oscc = PMOsc.ar([pit,pitc+67] * 1/6, pitc, Line.kr(modFrom, modTo, modDur*0.3)) * 0.20 ;
	oscd = PMOsc.ar([pit,pitd+98]* 0.25, pitd * 0.125, Line.kr(modFrom, modTo*0.9, modDur*2)) * 0.6 ;
	sig = HPF.ar(osca + oscb + oscc + oscd, 40, 0.5);
	sig = sig * EnvGen.ar(Env.perc(grEnvAtk, grEnvRel), Impulse.ar(Line.kr(rateFrom, rateTo, modDur)));
	sig = Pan2.ar(sig * env, StandardL.ar(70,1,2.3,2));
   	OffsetOut.ar([0,1], sig*XLine.kr(0.001,ampOut,5)!2);
}).add;


//loca
SynthDef(\c4,
	{ arg gate =1,out=0, amp=0.5, freq=60, sus=5;
		// var env = EnvGen.ar(Env([0,1,0],[2.rand, 8, 9]), doneAction:2);
			var env = EnvGen.kr(Env.circle([0.001, 0.5, 1.3],[0.03,4,0.3]), gate);
		Out.ar([0,1], Resonz.ar(FreeVerb.ar( StandardL.ar(3100,1.2,0.6,0,0.2), 0.73,1.2),2000,XLine.kr(0.001, 0.21, 14))*env)
	}).add;


//beattracker
 SynthDef(\d1,{ |gate = 1, amp = 0.06|
	var in = SoundIn.ar([0,1]);
	var env = EnvGen.kr(Env.circle([0.001, 0.013, 0.83],[0.3,1,0.3]), gate, doneAction:2);  //~master
	var tr = Trig.kr(in,0.1);
	var ch = Changed.kr(tr,0.001);
	var     bsound = Pan2.ar(LPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), 1000,0.3), 0.0);
	var hsound = Pan2.ar(BPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05), 3000, 0.66,0.3), -0.5);
	 var  qsound = Pan2.ar(HPF.ar(WhiteNoise.ar * Decay.kr(ch, 0.05),5000), 0.5);
	Out.ar([0,1], Ringz.ar([bsound + hsound + qsound],10000,0.7,0.05)*amp);
}).add;

//LFPulse

SynthDef(\d2,
{ |pan = 0, gate = 1| var in ,freqT, hasFreq, a, b,signal,env, an,anm;
		// an = AnalogIn.kr(0);
		// anm = LinLin.kr(an,0,127,1,1000);
in = SoundIn.ar(0);
// #freqT, hasFreq = Tartini.kr(in,0.9,n:128,overlap: 128);
#freqT, hasFreq = Pitch.kr(in, ampThreshold: 0.02,median: 7);
freqT = freqT * hasFreq;

env = EnvGen.kr(Env.asr(0.01, 0.91, 0.3), gate, doneAction:2);
a = SinOsc.ar([freqT, [freqT+ 23 ]*0.7]);
		b = SinOsc.ar(AnalogIn.kr(0).exprange(4, 21));  //AnalogIn.ar(0)  b = SinOsc.ar(anm)
rrand(a, b) * 1.81 ;
	signal = [b,in];
	OffsetOut.ar([0,1], signal*env!2);
}).add;



//beat cresc
 SynthDef(\d3,{ |gate = 1, amp = 1|
	var in = Limiter.ar(SoundIn.ar([0,1]),1);
	var aamp = Amplitude.kr(in);
	var lamp = LinLin.kr(aamp, 0.001,0.3,1,7);
	var env = EnvGen.kr(Env.circle([0.001, 0.1, 1.3],[0.03,lamp,0.3]), gate);
	var sin = SinGrain.ar(Impulse.kr(XLine.kr(0.31,10,30)), 1.2, WhiteNoise.kr.range(14, 5))*env;
	var verb = FreeVerb.ar(sin,0.2,1.2,0.9);
	OffsetOut.ar([0,1], verb!2);
}).add;


 SynthDef(\d4,{ |gate = 1, amp = 1|
	MoogFF.ar(LPF.ar(Saw.ar(60),[31,20]), AnalogIn.kr(0).exprange(100, 10000, 1),AnalogIn.kr(1).exprange(0, 4),Impulse.kr(0.1), mul:0.31)*EnvGen.kr(Env.circle([0.001, 0.15, 1.3],[0.03,0.5,0.3]), gate); }).add;




)