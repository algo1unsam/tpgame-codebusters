import wollok.game.*
import player.*
class Box {

	const x = 0.randomUpTo(game.width()).truncate(0)
    const y = 0.randomUpTo(game.height()).truncate(0) 
    const property position = game.at(x,y) 
	
	const property image = "box.jpg"
	
	method bajarVidas(){
		game.removeVisual(self)
	}
}

class Enemigo {
	var property image = "playerabajo.png"
	var vidas=5
	var direccion = abajo
	
	var property position = game.at(5,5) 
	
	method bajarVidas(){
		if(self.vivo()){
			vidas = vidas- 1
			console.println(vidas)
		}else{ game.removeVisual(self) }
	}
	
	method vivo(){
	return vidas > 0
	}
	
	method colicionConPlayer(){
		self.atacar(player)
	}
	method atacar(objetoAATacar){
		objetoAATacar.bajarVidas(100)
	}
	
	
	method moverse(unaDireccion){
		direccion = unaDireccion
		self.image("player"+ direccion.nombreDireccion() +".png")
		
		if(not direccion.proximaPosicionFueraDeLimites(position)){
		self.position(direccion.posicionSiSeMueveEnEstaDireccion(self.position()))
			
		}
	}
	
	method seguirPlayerX(){
		const xPlayer = player.position().x()
		const yPlayer = player.position().y()
		const xEnemy = self.cuantoEnX(xPlayer)
	//	const yEnemy = self.cuantoEnY(xPlayer)
		console.println(xEnemy)
	//	console.println(yEnemy)

		return xEnemy
	}
	method seguirPlayerY(){
		const xPlayer = player.position().x()
		const yPlayer = player.position().y()
	//	const xEnemy = self.cuantoEnX(xPlayer)
		const yEnemy = self.cuantoEnY(xPlayer)
	//	console.println(xEnemy)
		console.println(yEnemy)

		return yEnemy
	}
	
	method cuantoEnX(xPlayer) {
		if(self.esMayorEnX(xPlayer)){
			return derecha
		}else return izquierda
	}
	
	method cuantoEnY(xPlayer) {
		if(self.esMayorEnY(xPlayer)){
			return arriba
		}else return abajo
	}
	
	method esMayorEnX(xPlayer) = player.position().x() > self.position().x()
	method esMayorEnY(xPlayer) = player.position().y() > self.position().y()
	
	
}