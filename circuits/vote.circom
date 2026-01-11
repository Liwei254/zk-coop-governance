pragma circom 2.0.0;

include "../node_modules/circomlib/circuits/poseidon.circom";

template VoteCircuit() {
    // Private inputs
    signal input memberSecret;
    signal input proposalId;

    // Public output
    signal output nullifier;

    component hasher = Poseidon(2);
    hasher.inputs[0] <== memberSecret;
    hasher.inputs[1] <== proposalId;

    nullifier <== hasher.out;
}

component main = VoteCircuit();
