package ;

import kha.Game;
import kha.Framebuffer;
import kha.Color;
import kha.Image;

class Empty extends Game {

	var maze:Array<Array<Int>>;
	var mazeWidth = 64; 
	var mazeHeight = 48;
	var tileSize = 10;
	var mazeImage:Image;
	var posX = 1;
	var posY = 1;
	var moves:Array<Int>;

	public function new() {
		super("Empty");
	}

	public override function init() {
		mazeImage = Image.createRenderTarget(mazeWidth * tileSize, mazeHeight * tileSize);
		
		maze = [];
		for (i in 0...mazeHeight) {
			maze.push([]);
			for(j in 0...mazeWidth) {
				maze[i].push(1);
			}
		}
		
		maze[posX][posY] = 0;
		
		moves = [];
		moves.push(posY + posY * mazeWidth);

		generateMaze();
		drawMaze();
	}

	override public function render(frame:Framebuffer) {
		var g = frame.g2;

		g.begin();
		g.clear(Color.Black);
		g.color = kha.Color.White;

		g.drawImage(mazeImage, 0, 0);

		g.end();
	}

	function generateMaze() {
		if (moves.length > 0) {
			var possibleDirections:Array<String> = [];
			
			if (posX + 2 > 0 && posX + 2 < mazeHeight -1 && maze[posX + 2][posY] == 1) {
				possibleDirections.push("S");
			}
			if (posX - 2 > 0 && posX - 2 < mazeHeight -1 && maze[posX - 2][posY] == 1) {
				possibleDirections.push("N");
			}
			if (posY - 2 > 0 && posY - 2 < mazeWidth - 1 && maze[posX][posY - 2] == 1) {
				possibleDirections.push("W");
			}
			if (posY + 2 > 0 && posY + 2 < mazeWidth - 1 && maze[posX][posY + 2] == 1) {
				possibleDirections.push("E");
			}
			
			if (possibleDirections.length > 0) {
				var move = Std.random(possibleDirections.length);
				switch(possibleDirections[move]) {
					case "N":
						maze[posX - 2][posY] = 0;
						maze[posX - 1][posY] = 0;
						posX-=2;
					case "S":
						maze[posX + 2][posY] = 0;
						maze[posX + 1][posY] = 0;
						posX += 2;
					case "W":
						maze[posX][posY - 2] = 0;
						maze[posX][posY - 1] = 0;
						posY -= 2;
					case "E":
						maze[posX][posY + 2] = 0;
						maze[posX][posY + 1] = 0;
						posY += 2;
				}
				moves.push(posY + posX * mazeWidth);   
			}
			else {
				var back = moves.pop();
				posX = Std.int(back / mazeWidth);
				posY = back % mazeWidth;
			}

			// Recursive
			generateMaze();
		}
	}

	function drawMaze() {
		// Renders maze into texture
		var g = mazeImage.g2;

		g.begin();
		g.clear(Color.Black);
		g.color = kha.Color.fromValue(0xff333333);

		for (i in 0...mazeHeight) {
			for (j in 0...mazeWidth) {
				if (maze[i][j] == 1) {
					g.fillRect(j * tileSize, i * tileSize, tileSize, tileSize);
				}
			}
		}

		g.end();
	}
}
