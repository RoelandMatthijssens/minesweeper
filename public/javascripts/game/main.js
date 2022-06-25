let world;
let world_data;

function preload() {
  world_data = loadJSON("/javascripts/data/world.json");
}

function setup() {
  frameRate(5);
  const canvas = createCanvas(window.innerWidth, window.innerHeight);
  strokeWeight(1);
  stroke(51);
  noFill();
  world = new World(canvas);
  world.initialize(world_data);
}

function draw() {
  background(255);
  world.render();
}
