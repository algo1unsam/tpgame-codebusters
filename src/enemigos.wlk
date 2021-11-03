import wollok.game.*
import player.*
import direcciones.*
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
	const x = 0.randomUpTo(game.width()).truncate(0)
    const y = 0.randomUpTo(game.height()).truncate(0) 
    var property position = game.at(x,y) 
	
	method bajarVidas(danio){
		if(self.danioMayorQueVida(danio)){
			game.removeVisual(self)
			
		}else{ 
			vidas = vidas- danio
			console.println(vidas)
		}
	}
	
	method colicionConPlayer(){}
	
	method danioMayorQueVida(danio) = danio > vidas
	
	
	method estaCerca(posicionJugador) =  self.position().distance(posicionJugador) <= 1
		
		
	method cambiarImagenAtaque(){
		self.image("enemy"+ direccion.nombreDireccion() +"attack.png")
	}
	
	method cambiarImagenCaminando(direccionxd){
		self.image("enemy"+ direccionxd.nombreDireccion() +".png")
	}
	
	method atacar(objetoAATacar){
		self.cambiarImagenAtaque()
		game.schedule(300,{objetoAATacar.bajarVidas(1)})
		game.schedule(300,{self.cambiarImagenCaminando(direccion)})
	}
	
	
	method moverse(unaDireccion){
		direccion = unaDireccion
		self.cambiarImagenCaminando(direccion)
		
		if(not direccion.proximaPosicionFueraDeLimites(position) and self.proximaPosVacia(direccion)){	
		self.position(direccion.posicionSiSeMueveEnEstaDireccion(self.position()))
		}
	}
	
	method proximaPosVacia(direccionALaQueSeMueve){
			const proxPos = direccionALaQueSeMueve.posicionSiSeMueveEnEstaDireccion(position)
			return game.getObjectsIn(proxPos).size() == 0
			
	}
	
	method seguirPlayer(){
		
		if(self.estaCerca(player.position())){
			self.atacar(player)
			
		}else {
			self.seguirPlayerX()
			game.schedule(400, {(self.seguirPlayerY())})
		}
	}
	
	method seguirPlayerX(){
		const xPlayer = player.position().x()
	//	const yPlayer = player.position().y()
	//	const yEnemy = self.cuantoEnY(xPlayer)
		if(not self.enElMismoX(xPlayer)){
			self.moverse(self.cuantoEnX(xPlayer))
		}
	}
	
	method enElMismoX(xPlayer) = self.position().x() == xPlayer
	
	method seguirPlayerY(){
	///	const xPlayer = player.position().x()
		const yPlayer = player.position().y()
		
		if(not self.enElMismoY(yPlayer)){
			self.moverse(self.cuantoEnY(yPlayer))
		}
		
	}
	
	method enElMismoY(yPlayer) = self.position().y() == yPlayer
	
	method cuantoEnX(xPlayer) {
		if(self.esMayorEnX(xPlayer)){
			return derecha
		}else return izquierda
	}
	
	method cuantoEnY(yPlayer) {
		if(self.esMayorEnY(yPlayer)){
			return arriba
		}else return abajo
	}
	
	method esMayorEnX(xPlayer) = player.position().x() > self.position().x()
	method esMayorEnY(xPlayer) = player.position().y() > self.position().y()
	
	
}