import wollok.game.*
import player.*

class ParejaPortales {
	const property position
	const property position2	
	
	method crearPortales(){
		game.addVisual(new Portal1(position=position,position2=position2))
		game.addVisual(new Portal1(position=position2,position2=position))
	}
	method accionDeColicion(){
		player.position(position.up(1))
	}
}

class Portal1{
	const property image = "portal.png"
	const property position
	const property position2
	
	method colicionConPlayer(){
		player.position(position2.up(1))
	}
	method bajarVidas(){}
}

class Portal2{
	const property image = "portal.png"
	const property position	
	const property position2
	
	
	method colicionConPlayer(){
		player.position(position2.down(1))
	}
	method bajarVidas(){}
}

