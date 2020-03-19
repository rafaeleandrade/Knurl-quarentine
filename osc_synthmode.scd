/***** osc_demo.scd *****/
(

OSCdef(\synthmode, {|msg|
		var id = msg[2], count = msg[3].asInt, mode = msg[4],dig = msg[5], red = msg[6]; // dig = msg[4] lpress = msg[6];// tempo = msg[12];
		~dig = dig ;
		~count = count;
		
if (~dig == 1){                          ///avoid more than one trigger


[~count,count].postln;
// ["sm:" ++ msg[2..]].postln;
1.do {b.sendMsg("/tr", "sm:"  ++ ~count.postln; )};

if(red == 1){
b.sendMsg("/tr", "sm: ALL - off");
				t = Task({ fork{
							
							~a1.set(\gate, -2);
							~a2.set(\gate, -2);
							~a3.set(\gate, -2);
							~a4.set(\gate, -2);
							~a5.set(\gate, -2);
							~b1.release;
							~b1.set(\gate, -2);
							~b2.set(\gate, -2);
							~b3.set(\gate, -2);
							~b4.set(\gate, -2);
							~b5.set(\gate, -2);
							~c1.set(\gate, -2);
							~c2.set(\gate, -2);
							~c3.set(\gate, -2);
							~c4.stop;
							~c5.set(\gate, -2);
							~d1.set(\gate, -2);
							~d2.set(\gate, -2);
							~d3.set(\gate, -2);
							~d4.set(\gate, -2);
							~d5.set(\gate, -2);

							3.wait;
							1.do({
							~a1 = nil;
							~a2 = nil;
							~a3 = nil;
							~a4 = nil;
							~a5 = nil;
							~b1 = nil;
							~b2 = nil;
							~b3 = nil;
							~b4 = nil;
							~b5 = nil;
							~c1 = nil;
							~c2 = nil;
							~c3 = nil;
							~c4 = nil;
							~c5 = nil;
							~d1 = nil;
							~d2 = nil;
							~d3 = nil;
							~d4 = nil;
							~d5 = nil;
							});
							b.sendMsg("/tr", " ALL Synths gate -4");
							" ALL Synths off".postln;
							1.wait;t.reset; t.stop;}});
							b.sendMsg("/tr", " ALL Synths OFF");
							" ALL Synths OFF".posltn;
							x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 8]); //~a.free
};

if ( mode == 0,
// synth mode
{


				//sc1
				if(id == 101) {
			
				if(~count == 1, {

							t = Task({
								fork{
								2.wait;
								if(~count == 1){
								b.sendMsg("/tr", "sm: 2A"  );
								// 0.4.wait;
								if(~a2 != nil, {
									~a2.set(\gate, -4);
									p = Task({fork{4.wait; ~b = nil; 1.wait;p.reset; p.stop;}});
									p.start;  "synth A1  off".postln;
									b.sendMsg("/tr", "sm: A1  off");
									x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]); },
									{ 	if(~a1 == nil, {
										(
										// c = Buffer.alloc( s, 5.0 * s.sampleRate, 1);
										q = Task({Synth(\record_my_voice); 6.wait; ~a1 = Synth(\a1); 1.wait; t.stop; t.reset; });
										q.start
										);
										x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 8]);
										"synth A1  on".postln;
										b.sendMsg("/tr", "sm: A1 on"); }) }
							);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});


					if(~count == 2, {
						
							t = Task({
								fork{
								2.wait;
								if(~count == 2){
								b.sendMsg("/tr", "sm: 2A"  );
								// 0.4.wait;
								if(~a2 != nil, {
									~a2.set(\gate, -4);
									p = Task({fork{4.wait; ~b = nil; 1.wait;p.reset; p.stop;}});
									p.start;  "synth A2  off".postln;
									b.sendMsg("/tr", "sm: A2  off");
									x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]); },

									{ 	if(~a2 == nil, { 1.do{
										~a2 = Synth(\a1);
										x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 2]);
										"synth A2  on".postln;
										b.sendMsg("/trsm", "sm: A2  on");} }) }
								 );  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					if(~count == 3, {
					
							t = Task({

								fork{
								2.wait;
								if(~count == 3){
								b.sendMsg("/tr", "sm: 3A" );
								// 0.4.wait;
								if(~a3 != nil, {
								~a3.set(\gate, -4);
								b.sendMsg("/trsm", "sm: 3A off");
								"synth A3 off".postln;
								p = Task({fork{7.wait; ~a3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3]); },
									{ 	if(~a3 == nil, {   ~a3= Synth(\a3);	 b.sendMsg("/tr", "sm: 3A");
									"synth A3 on".postln;
									x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 3]); }) }
												);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					if(~count == 4, {
						// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
							1.2.wait;
								if(~count == 4){
								// 0.4.wait;
								if(~a4 != nil,{
								~a4.set(\gate, -4); b.sendMsg("/tr", "sm: A4 off");
								"synth A4 on".postln;
								p = Task({fork{4.wait; ~a4 = nil; 1.wait;p.reset; p.stop;}});
								p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 4]); },
								{ 	if(~a4 == nil, {   ~a4 = Synth(\a4);
								"A4".postln;	 b.sendMsg("/tr", "sm: A4 on"); x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 4]); }) }
												);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					// if(~count == 5, {
					// 	fork{1.do{"synth mode receiving".postln;}; 5.wait};
					// 		t = Task({

					// 			fork{
					// 			1.wait;
					// 			if(~count == 5){
					// 			// 0.4.wait;
					// 			if(~a5 != nil,{ ~a5.set(\gate, -4); b.sendMsg("/tr", "sm: B5 off"); "sm: A5 off".postln;
					// 			p = Task({fork{4.wait; ~a5 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 5]); },
					// 									{ 	if(~a5 == nil, {   ~a5 = Synth(\a5);
					// 									"sm: A5 ON".postln;	 b.sendMsg("/tr", "sm: A5 on"); x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 5]); }) }
					// 							);  //short press
					// 							1.wait;
					// 							t.reset;
					// 							t.stop;
					// 					}}
					// 				});
					// 				t.start;

					// 		});
						};


//sc2
				if(id == 102) {

					if(~count == 1, {
						// fork{1.do{"synth mode receiving".postln;}; 5.wait};
					t = Task({

						fork{
						2.wait;
						
[~count,count].postln;
						if(~count == 1){
						// 0.4.wait;
						if(~b1 != nil,{
						~b1.set(\gate, -4); b.sendMsg("/tr", "sm: 1B off");
						" B1 off -4".postln;  p = Task({fork{8.wait; ~b1 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 1]);  },
						{ if(~b1 == nil, {
						~b1 = Synth(\b1); "sm: 1B ON ".postln;	 b.sendMsg("/tr", "synth F running"); x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 1]); }) }	);
							1.wait;
							t.reset;
							t.stop;
						}}
					});
					t.start;
			      	});


					if(~count == 2, {
						// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								2.wait;
								
[~count,count].postln;
								if(~count == 2){
								// 0.4.wait;
								
								if(~b2 != nil, { ~b2.set(\gate, 0);	b.sendMsg("/tr", "sm: 2B off");
								"b2 off".postln;
								p = Task({fork{4.wait; ~b2 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]); },
								{ 	if(~b2== nil, {   ~b2 = Synth(\b2);	 b.sendMsg("/tr", "sm: 2B on");
								"sm: B2 on".postln;
								x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 2]); }) }
												);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					if(~count == 3, {
						// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								2.wait;
								
[~count,count].postln;
								if(~count == 3){
								// 0.4.wait;
								if(~b3 != nil, { ~b3.free;	b.sendMsg("/tr", "sm: 3B off");
								"B3 off".postln;
								p = Task({fork{4.wait; ~b3 = nil; 1.wait;p.reset; p.stop;}});
								p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3]); },
								{ 	if(~b3 == nil, {   ~b3 = Synth(\b3);	 b.sendMsg("/tr", "sm: 3B on");
								"B3 on".postln;
								x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 3]); }) }
												);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					if(~count == 4, {
						// fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								1.2.wait;
										if(~count == 4){
								// 0.4.wait;
										if(~b4 != nil,{ ~b4.set(\gate, -4) ;b.sendMsg("/tr", "sm: 4B Off");
										"B4 off".postln;
										p = Task({fork{4.wait; ~b4 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 4]); },
								{ 	if(~b4 == nil, {   ~b4 = Synth(\b4);	b.sendMsg("/tr", "sm: 4B ON");
								"B4 on".postln;
								x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 4]); }) }
												);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					// if(~count == 5, {
					// 	fork{1.do{"synth mode receiving".postln;}; 5.wait};
					// 		t = Task({

					// 			fork{
					// 			1.wait;
					// 			if(~count == 5){
					// 			// 0.4.wait;
					// 			if(~b5 != nil,{ ~b5.set(\gate, -4) ;
					// 							b.sendMsg("/tr", "sm: 5B off");
					// 							"5b off".postln;
					// 							p = Task({fork{
					// 								7.wait;
					// 								~b5 = nil;
					// 							1.wait;p.reset; p.stop;}});
					// 							p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 5]); },
					// 			{ 	if(~b5 == nil, {   ~b5 = Synth(\b5);	b.sendMsg("/tr", "sm: 5B on");
					// 			 "5A on".postln;
					// 			 x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 5]); }) }
					// 							);  //short press
					// 							1.wait;
					// 							t.reset;
					// 							t.stop;
					// 					}}
					// 				});
					// 				t.start;

					// 		});


						};

				//sc3
		if(id == 103) {

					if(~count == 1, {
						fork{1.do{"synth mode receiving".postln;}; 5.wait};
					t = Task({

						fork{
						2.wait;
						if(~count == 1){
						// 0.4.wait;
						if(~c1 != nil,
						{ ~c1.set(\gate, 0);		 b.sendMsg("/tr", "sm: 1C off");
						"1C off".postln;
						p = Task({fork{4.wait; ~c1 = nil; 1.wait;p.reset; p.stop;}}); p.start;
						x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 1]);  },  //long press
						{ 	if(~c1== nil, {   ~c1 = Synth(\c1); b.sendMsg("/tr", "sm: 1C on");
						"1C on".postln;
						x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 1]); }) });
							1.wait;
							t.reset;
							t.stop;
						}}
					});
					t.start;
			      	});


					if(~count == 2, {
						fork{1.do{"synth mode receiving".postln;}; 5.wait};
					t = Task({
					fork{
					2.wait;
					if(~count == 2 ){
					// 0.4.wait;
					if(~c2 != nil, {
					~c2.set(\gate, -4);	p = Task({fork{4.wait; ~c2 = nil; 1.wait;p.reset; p.stop;}}); p.start;
					"2C off".postln;
					b.sendMsg("/tr", "sm: 2C off"); x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]); },
						{ 	if(~c2 == nil, {   ~c2 = Synth(\c2); b.sendMsg("/tr", "sm: 2C on");
						"2C on".postln;
						x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 2]); }) });  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					if(~count == 3, {
						fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								2.wait;
								if(~count == 3){
								// 0.4.wait;
								if(~c3 != nil, { ~c3.set(\gate, -4);	b.sendMsg("/tr", "sm: 3C off");
								"3C off".postln;
								p = Task({fork{4.wait; ~c3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3]); },
							{ 	if(~cc3 == nil, {   ~c3 = Synth(\c3);	b.sendMsg("/tr", "sm: 3C on");
							"3C on".postln;
							x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 3]); }) }
												);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					if(~count == 4, {
						fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								1.2.wait;
								if(~count == 4){
								// 0.4.wait;
								if(~c4 != nil,{ ~c4.stop; b.sendMsg("/tr", "sm: 4C off");
								"4C off".postln;
								p = Task({fork{4.wait; ~c4 = nil; 1.wait;p.reset; p.stop;}}); x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 4]); },
							{ 	if(~c4 == nil, {
								(
								(
								~c4 = Task({  50.do({ Synth(\c4, [\freq: [76.rand]]);  9.rand.wait }); }););
								~c4.start
								);
								b.sendMsg("/tr", "sm: 4C on");
								"4C on".postln;
								x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 4]); }) }
												);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					// if(~count == 5, {
					// 	fork{1.do{"synth mode receiving".postln;}; 5.wait};
					// 		t = Task({

					// 			fork{
					// 			1.wait;
					// 			if(~count == 5){
					// 			// 0.4.wait;
					// 			if(~c5 != nil,{ ~c5.set(\gate, -4) ;b.sendMsg("/tr", "sm: 5C off");
					// 			"5C off".postln;
					// 			p = Task({fork{4.wait; ~c5 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 5]); },
					// 		{ 	if(~c5 == nil, {   ~c5 = Synth(\c5);	 b.sendMsg("/tr", "sm: 5C on");
					// 		"5C on".postln;
					// 		x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 5]); }) }
					// 							);  //short press
					// 							1.wait;
					// 							t.reset;
					// 							t.stop;
					// 					}}
					// 				});
					// 				t.start;

					// 		});

						};


			if(id == 104) {

					if(~count == 1, {
						fork{1.do{"synth mode receiving".postln;}; 5.wait};
					t = Task({

						fork{
						1.wait;
						if(~count == 1){
						// 0.4.wait;
						if(~d1 != nil,{ ~d1.set(\gate, -4); b.sendMsg("/tr", "sm: 1D off");
						"1D off".postln;
						p = Task({fork{4.wait; ~d1 = nil; 1.wait;p.reset; p.stop;}});
						p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 1]); },
						{ 	if(~d1 == nil, {  ~d1 = Synth(\d1);	 b.sendMsg("/tr", "sm: 1D on");
												"1D on".postln;
												x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 1]); }) }
												);  //short press

							1.wait;
							t.reset;
							t.stop;
						}}
					});
					t.start;
			      	});


					if(~count == 2, {
						fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								1.wait;
								if(~count == 2){
								// 0.4.wait;
								if(~d2 != nil,{ ~d2.set(\gate, -4) ;b.sendMsg("/tr", "sm: 2D off");
								"2D off".postln;
								p = Task({fork{4.wait; ~d2 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 2]); },
								{ 	if(~d2 == nil, {   ~d2 = Synth(\d2);	 b.sendMsg("/tr", "sm: 2D on");
														"2D on".postln;
														x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 2]); }) }
												);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					if(~count == 3, {
						fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								1.wait;
								if(~count == 3){
								// 0.4.wait;
								if(~d3 != nil,{ ~d3.set(\gate, -4) ;b.sendMsg("/tr", "sm: 3D off");
								"3D off".postln;
								p = Task({fork{4.wait; ~d3 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 3]); },
								{ 	if(~d3 == nil, {   ~d3 = Synth(\d3);	 b.sendMsg("/tr", "sm: 3D on");
								"3D ON".postln;
								x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 3]); }) }
												);  //short press
												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;

							});

					if(~count == 4 , {
						fork{1.do{"synth mode receiving".postln;}; 5.wait};
							t = Task({

								fork{
								1.wait;
								if(~count == 4){
								// 0.4.wait;
								if(~d4 != nil,{ ~d4.set(\gate, -4) ; b.sendMsg("/tr", "sm: 4D off");
								"4D off".postln;
								p = Task({fork{4.wait; ~d4 = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', ]); },
								{ 	if(~d4 == nil, {   ~d4 = Synth(\d4);	b.sendMsg("/tr", "synth S on");
								"4D ON".postln;
								x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 4]); }, {"sm: 4D on".postln}) }
								);  //short press

												1.wait;
												t.reset;
												t.stop;
										}}
									});
									t.start;
							});

					// if(~count == 5 && dig == 1, {
					// 	fork{1.do{"synth mode receiving".postln;}; 5.wait};
					// 		t = Task({

					// 			fork{
					// 			1.wait;
					// 			if(~count == 5){
					// 			// 0.4.wait;
					// 			if(~d5 != nil,{ ~d5.set(\gate, -4) ; b.sendMsg("/tr", "sm: 5D off");
					// 			"5D off".postln;
					// 			p = Task({fork{4.wait; ~t = nil; 1.wait;p.reset; p.stop;}}); p.start; x = Synth('blinker', ['outPin', 5, 'rate', 2, 'seq', 5]); },
					// 			{ 	if(~d5 == nil, {   ~d5 = Synth(\d5);	b.sendMsg("/tr", "sm: 5D on");
					// 			"5D ON".postln;
					// 			x = Synth('blinker', ['outPin', 8, 'rate', 2, 'seq', 5]); }) }
					// 			);  //short press

					// 							1.wait;
					// 							t.reset;
					// 							t.stop;
					// 					}}
					// 				});
					// 				t.start;
					// 		});

						};


		}
)

};
}, "/trsm");

)
