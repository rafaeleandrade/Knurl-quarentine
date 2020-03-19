/***** set_trillraw.scd *****/
(
		
	SynthDef(\raw,{|t_updateTrill = 1.0,t_recalibrate=0|
	var numTouchPads = 10;
	var i2c_bus = 1; // I2C bus to use on BeagleBone, usually you want this to be 1
	var i2c_address = 0x19; // I2C address of Trill sensor
	var noiseThresh = 40; // noise threshold, int: 5-255 (255=highest threshold)  //10
	var prescalerOpt = 4; // sensitivity option, int: 0-4 (!!!!!!!!!!!!!0=highest sensitivity, play with this for complex Trill Craft setups)
	var rawvals;
	var sig, ping,d1, gt, pc,ch ,step,t_trig_1;
	var ch1,pc1,gt1,step1,	t_trig_2 ;
	var ch2,pc2,gt2,step2,	t_trig_3 ;
	var ch3,pc3,gt3,step3,	t_trig_4 ;
	var mode, ch5;
	var lp0,lp1,lp2,lp3;
	var ch6,ch7, step6,step7, t_trig_am6, t_trig_am7;
	var in,freq,hasFreq, sp1,sp2,sp3,sp4,sp5,sp6,mfcc,cent;   //color constitution
	var chl1;
	var an0, an1,an2,amp; 
	var tch,tch1,tch2,tch3;
	var cch,cch1,cch2,cch3, trmode, dig, dig1, dig2,dig3,trgt2,red;
	
	rawvals = TrillRaw.kr(i2c_bus, i2c_address, noiseThresh, prescalerOpt, t_updateTrill);
	
	//-------------------------------------------------------- start-to-start interval button 
	ch = Trig.kr(Changed.kr(rawvals[1]),0.35);
	gt = Trig.kr(Changed.kr(ch),0.25); //attenuate the reset
	pc = Stepper.kr(Impulse.kr(10), gt,0.0,80);  //attenuate the data input
	
	 
	ch1 = Trig.kr(Changed.kr(rawvals[2]),0.35);
	gt1 = Trig.kr(Changed.kr(ch1),0.25); //attenuate the reset
	pc1 = Stepper.kr(Impulse.kr(10), gt1,0.0,80);  //attenuate the data input
	

	ch2 = Trig.kr(Changed.kr(rawvals[3]),0.35);
	gt2 = Trig.kr(Changed.kr(ch2),0.25); //attenuate the reset
	pc2 = Stepper.kr(Impulse.kr(10), gt2,0.0,80);  //attenuate the data input
	trgt2 = Trig.kr(pc2);
	
	ch3 = Trig.kr(Changed.kr(rawvals[4]),0.35);
	gt3 = Trig.kr(Changed.kr(ch3),0.25); //attenuate the reset
	pc3 = Stepper.kr(Impulse.kr(10), gt3,0.0,80);  //attenuate the data input
	
	
	//--------------------------------------------------------counter button

	cch = Trig.kr(Changed.kr(rawvals[1]),Gate.kr(0.6,Changed.kr(rawvals[1])));
	cch1 = Trig.kr(Changed.kr(rawvals[2]),Gate.kr(0.6,Changed.kr(rawvals[2])));
	cch2 = Trig.kr(Changed.kr(rawvals[3]),Gate.kr(0.6,Changed.kr(rawvals[3])));
	cch3 = Trig.kr(Changed.kr(rawvals[4]),Gate.kr(0.6,Changed.kr(rawvals[4])));
	
	step = PulseCount.kr(cch, Impulse.kr(0.1));
	step1 = PulseCount.kr(cch1, Impulse.kr(0.1));
	step2 = PulseCount.kr(cch2, Impulse.kr(0.1));
	step3 = PulseCount.kr(cch3, Impulse.kr(0.1));
	
	
		//--------------------------------------------------------TRIGGER
	
	tch = Trig.kr(Changed.kr(rawvals[1]),0.5);
	tch1 = Trig.kr(Changed.kr(rawvals[2]),0.5);
	tch2 = Trig.kr(Changed.kr(rawvals[3]),0.5);
	tch3 = Trig.kr(Changed.kr(rawvals[4]),0.5);
	
	
	t_trig_1 =  Trig.kr(pc,0.3);
	t_trig_2 =  Trig.kr(pc1,0.3);
	t_trig_3 =  Trig.kr(pc2,0.3);
	t_trig_4 =  Trig.kr(pc3,0.3);
	
	
	// ----------------------------------------------------- Mode button
	ch5 = Trig.kr(Changed.kr(rawvals[5]),0.35);
	mode = Stepper.kr(ch5, 0,0, 2,1);
	// ~mode = mode;
	trmode = Changed.kr(mode);

	//	-----------------------------------------------------Long Press button

		lp0 = Trig.kr(Changed.kr(rawvals[1]),1);
		lp1 = Trig.kr(Changed.kr(rawvals[2]),1);
		lp2 = Trig.kr(Changed.kr(rawvals[3]),1);
		lp3 = Trig.kr(Changed.kr(rawvals[4]),1);
	
		
	//	-----------------------------------------------------Analogue button
	// centroids = TrillCentroids.kr(i2c_bus, i2c_address, noiseThresh, prescalerOpt, t_recalibrate);   -!!!!!!!!!!!only centroid or TrillRaw !!!!!!!!!!

	ch6 = Trig.kr(Changed.kr(rawvals[8]),0.35);
	ch7 = Trig.kr(Changed.kr(rawvals[9]),0.35);
	
	step6 = PulseCount.kr(ch6, Impulse.kr(1));
	step7 = PulseCount.kr(ch7, Impulse.kr(1));
	
	t_trig_am6 = Changed.kr(step6);
	t_trig_am7 = Changed.kr(step7);
	
	//-----------------------------------------------------MFCC color constitution
	//separado
	
	//-----------------------------------------------------Sound Trackers
	in = SoundIn.ar([0,1],2) ;
	// # freq, hasFreq = Pitch.kr(in, ampThreshold: 0.2, median: 7);
	#freq, hasFreq = Pitch.kr(in, ampThreshold: 0.09,median: 0.7);
	amp = Amplitude.kr(in);

	an0 = AnalogIn.kr(0).exprange(10,100);
	an1 = AnalogIn.kr(1).exprange(10,100);
	an2 = AnalogIn.kr(2).exprange(10,100);
	// an3 = AnalogIn.kr(3).exprange(10,100);
	// an4 = AnalogIn.kr(4).exprange(10,100);
	// an5 = AnalogIn.kr(6).exprange(10,100);



	dig = Trig.kr(Changed.kr(rawvals[1]),0.5);
	dig1 = Trig.kr(Changed.kr(rawvals[2]),0.5);
	dig2 = Trig.kr(Changed.kr(rawvals[3]),0.5);
	dig3 = Trig.kr(Changed.kr(rawvals[4]),0.5);
	
	//-----------------------------------------------------EMMERGENCY button
	
	red = Trig.kr(Changed.kr(rawvals[6]),0.35);
	// ----------------------------------------------------- OSCSEND
	SendReply.kr(t_trig_1, "/trsm", [step, mode,ch,red],101);
	SendReply.kr(t_trig_2, "/trsm", [step1, mode,ch1,red],102);
	SendReply.kr(t_trig_3, "/trsm", [step2,mode,ch2,red],103);
	SendReply.kr(t_trig_4, "/trsm", [step3,mode,ch3,red],104);
	
	SendReply.kr(t_trig_am6, "/tram", [step6,mode],106);  
	SendReply.kr(t_trig_am7, "/tram", [step7,mode],107);  
	
	SendReply.kr(trmode, "/mode", [mode],108); 
	
	// SendReply.kr(t_trig_1, "/trpm", [pc,ch,mode,lp0,amp,freq,an0,an1,an2],101);
	// SendReply.kr(t_trig_2, "/trpm", [pc1,ch1,mode,lp1,amp,freq,an0,an1,an2],102);
	// SendReply.kr(t_trig_3, "/trpm", [pc2,ch2,mode,lp2,amp,freq,an0,an1,an2],103);
	// SendReply.kr(t_trig_4, "/trpm", [pc3,ch3,mode,lp3,amp,freq,an0,an1,an2],104);
	

	// SendReply.kr(t_trig_4, "/trdm", [pc,step3,ch3,mode],104);
	
 	// SendReply.kr(Impulse.kr(1), "/color", [freq, sp1,sp2,sp3,sp4,sp5,sp6],101);

	sig = SinOsc.ar((1..numTouchPads) * 50, mul: Lag.kr(rawvals.linlin(0.0, 300, 0.0, 1.0), 0.1)) * 0.6;
	sig = Splay.ar(sig);
	sig = CombL.ar(sig.sum, 0.2, 0.2, 3.0, mul: 0.4) + sig;
	
	ping = EnvGen.ar(Env.perc, t_updateTrill) * SinOsc.ar(440);
	
	sig + ping;
	}).play;


b.sendMsg("/trsm", "foi eu tenho um arco falante");
b.sendMsg("/mode", "foi eu tenho um arco falante");


OSCdef(\detectmode, { |msg| var mode = msg[3];

if (mode == 0){1.do{"synth mode (0)".postln}};
if (mode == 1){1.do{"code mode (1)".postln}};
if (mode == 2){1.do{"analogue mode (2)".postln}};


},'/mode')


);
