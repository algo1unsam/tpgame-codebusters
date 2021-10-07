import wollok.game.*
class Box {
	const x = 0.randomUpTo(game.width()).truncate(0)
    const y = 0.randomUpTo(game.height()).truncate(0) 
    const property position = game.at(x,y) 
	
	const property image = "box.jpg"
	
	method bajarVidas(){
		game.removeVisual(self)
	}
}
