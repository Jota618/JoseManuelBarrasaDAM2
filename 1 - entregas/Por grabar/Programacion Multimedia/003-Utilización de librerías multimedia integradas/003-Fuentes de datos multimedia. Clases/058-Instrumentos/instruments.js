// Instrument definitions
const instruments = {
    electricPiano: {
        name: "Electric Piano",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 2, amplitude: 0.6 },
            { ratio: 3, amplitude: 0.4 },
            { ratio: 4, amplitude: 0.2 },
            { ratio: 5, amplitude: 0.1 }
        ],
        envelope: {
            attackTime: 0.01,
            decayTime: 0.2,
            sustainLevel: 0.8,
            releaseTime: 1.5
        }
    },
    acousticGuitar: {
        name: "Acoustic Guitar",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 2, amplitude: 0.8 },
            { ratio: 3, amplitude: 0.6 }
        ],
        envelope: {
            attackTime: 0.02,
            decayTime: 0.3,
            sustainLevel: 0.7,
            releaseTime: 2.0
        }
    },
    bassGuitar: {
        name: "Bass Guitar",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 2, amplitude: 0.5 },
            { ratio: 3, amplitude: 0.3 }
        ],
        envelope: {
            attackTime: 0.01,
            decayTime: 0.4,
            sustainLevel: 0.6,
            releaseTime: 1.8
        }
    },
    flute: {
        name: "Flute",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 2, amplitude: 0.2 },
            { ratio: 3, amplitude: 0.1 }
        ],
        envelope: {
            attackTime: 0.05,
            decayTime: 0.2,
            sustainLevel: 0.9,
            releaseTime: 1.2
        }
    },
    violin: {
        name: "Violin",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 2, amplitude: 0.7 },
            { ratio: 3, amplitude: 0.5 },
            { ratio: 4, amplitude: 0.3 }
        ],
        envelope: {
            attackTime: 0.1,
            decayTime: 0.4,
            sustainLevel: 0.85,
            releaseTime: 2.5
        }
    },
    trumpet: {
        name: "Trumpet",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 2, amplitude: 0.6 },
            { ratio: 3, amplitude: 0.3 },
            { ratio: 4, amplitude: 0.2 }
        ],
        envelope: {
            attackTime: 0.08,
            decayTime: 0.3,
            sustainLevel: 0.8,
            releaseTime: 1.7
        }
    },
    synthPad: {
        name: "Synth Pad",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 1.5, amplitude: 0.8 },
            { ratio: 2, amplitude: 0.6 },
            { ratio: 2.5, amplitude: 0.3 },
            { ratio: 3, amplitude: 0.2 }
        ],
        envelope: {
            attackTime: 0.5,
            decayTime: 0.5,
            sustainLevel: 0.7,
            releaseTime: 3.0
        }
    },
    xylophone: {
        name: "Xylophone",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 2, amplitude: 0.4 },
            { ratio: 3, amplitude: 0.2 }
        ],
        envelope: {
            attackTime: 0.01,
            decayTime: 0.2,
            sustainLevel: 0.6,
            releaseTime: 0.8
        }
    },
    organ: {
        name: "Organ",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 2, amplitude: 0.7 },
            { ratio: 3, amplitude: 0.5 },
            { ratio: 4, amplitude: 0.4 },
            { ratio: 5, amplitude: 0.3 }
        ],
        envelope: {
            attackTime: 0.05,
            decayTime: 0.1,
            sustainLevel: 0.9,
            releaseTime: 1.5
        }
    },
    marimba: {
        name: "Marimba",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },
            { ratio: 2, amplitude: 0.5 },
            { ratio: 3, amplitude: 0.2 },
            { ratio: 4, amplitude: 0.1 }
        ],
        envelope: {
            attackTime: 0.02,
            decayTime: 0.3,
            sustainLevel: 0.5,
            releaseTime: 0.9
        }
    }
};
