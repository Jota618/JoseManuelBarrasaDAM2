// instruments.js

// Instrument definitions
const instruments = {
    electricPiano: {
        name: "Electric Piano",
        harmonics: [
            { ratio: 1, amplitude: 1.0 },   // Fundamental frequency
            { ratio: 2, amplitude: 0.6 },   // First overtone
            { ratio: 3, amplitude: 0.4 },   // Second overtone
            { ratio: 4, amplitude: 0.2 },   // Third overtone
            { ratio: 5, amplitude: 0.1 }    // Fourth overtone
        ],
        envelope: {
            attackTime: 0.01,
            decayTime: 0.2,
            sustainLevel: 0.8,
            releaseTime: 1.5
        }
    },
    // Add other instruments here in the same format
};

// Export the instruments
export default instruments;

