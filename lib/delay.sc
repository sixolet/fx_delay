FxDelay : FxBase {

    *new { 
        var ret = super.newCopyArgs(nil, \none, (
            time: 0.5,
            hp: 50,
            lp: 10000,
            pingpong: 0,
            feedback: 0.6,
        ));
        ^ret;
    }

    *initClass {
        FxSetup.register(this.new);
    }

    subPath {
        ^"/fx_delay";
    }  

    symbol {
        ^\fxDelay;
    }

    addSynthdefs {
        SynthDef(\fxDelay, {|inBus, outBus|
            var fb = LocalIn.ar(2);
            var lpb = (-2pi*(\lp.kr(20000)/SampleRate.ir)).exp;
	        var hpb = (-2pi*(\hp.kr(50)/SampleRate.ir)).exp;
            var input = In.ar(inBus, 2);
            var delayed = DelayL.ar(input + fb, 1.2, \time.kr(0.2).lag(0.3));
            var lowpassed = OnePole.ar(delayed, lpb);
            var highpassed = lowpassed - OnePole.ar(lowpassed, hpb);
            var pingpong = \pingpong.kr(0);
            var normal = 1 - pingpong;
            LocalOut.ar(
                \feedback.kr(0.5) * ( 
                    (normal*highpassed) + 
                    (pingpong*highpassed.reverse)));
            Out.ar(outBus, highpassed);
        }).add;
    }

}