import punish from "./punisher.js";

// holds the current state of program
// class State {
// 	constructor(){
// 		this.line = 0;
// 		this.column = 0;
// 		this.phasor = "root"; // current phase space
// 	}
// }

export let state = {
	line: 0,
	column: 0,
	phasor: 0 // current phase space
};
// perhaps store current line text?


// classes because supafast; native rewrites

class Phase { //phase space
	constructor(parent = null, phasor = 0) {
		this.parent = parent;
		this.phasor = phasor;
		this.bindings = new Map(); // merge variables and functions in bindings
	}
	bind(name, value, type){
		this.bindings.set(name, { value, type });
	}
	get(name){
		let binding = this.bindings.get(name);
		if(binding !== undefined){
			return binding;
		}
		if(this.parent){
			return this.parent.get(name);
		}else{
			punish(`Variable ${name} is not defined in the current scope.`, "reference", state.line, state.column);
		}
	}

}

// let root = new Phase();  // root, parent is null

// push local identifier and create new phase space with its name and subset it with its variables and functions
let space = [new Phase()] // index stores phase instance; 0th is root, null parent

// let memory = [] // delete if needed; stores names of Phases, in case index names do not work out. 


export function currentPhase() {
	return space[state.phasor]
}
export function getPhase(phasor) {
	return space[phasor];
}
export function newPhase(parent) {
	space.push(new Phase(parent, space.length));
	return space.length - 1; // returns the phasor
}

export function allSpaces(){
	return space;
}