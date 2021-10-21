import wollok.game.*

object player {
	var property position = game.center()
	var property image = "playerFront.png"
	var direccion=abajo//0 Abajo, 1 Derecha, 2 izquierda, 3 Arriba
	//reemplazar numeros por objetos
	var vidas=100
	
	method bajarVidas(danio){
		vidas=vidas-danio
	}
	
	method subirVidas(){
		vidas=vidas+1
	}
	
	//un solo metodo para direccionar
	method moverseHacia(unaDireccion){
		direccion=unaDireccion
		self.image(direccion.imagen())
	}
	
	method disparar(){
		const proyectil=new Proyectil(direccion=direccion,position=direccion.posicionSiSeMueveEnEstaDireccion(self.position()))
		game.addVisual(proyectil)
		game.onTick(200, "disparo", { proyectil.moverse() })
	}
}

class Proyectil{
	var property position
	var property direccion		
	var property image="proyectil.png"
	var movimientos=0
	const maxRango=3
	method colicionConPlayer(){
		
	}
	method atacar(){ 
		//
		game.colliders(self).forEach({ elementoEnLaPosicion => elementoEnLaPosicion.bajarVidas()})
	}
	method moverse(){
		direccion.moverEnDireccion(self)
		if(movimientos < maxRango){
			movimientos=movimientos+1
			self.atacar()
			
		}else{
			game.removeTickEvent("disparo")
			game.removeVisual(self)
		}
	}
}

class Direccion{
	
	method moverEnDireccion(objetoAMover){
		objetoAMover.position(self.posicionSiSeMueveEnEstaDireccion(objetoAMover.position()))
	}
	
	method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.up(1)
	} 	
}

object arriba inherits Direccion{
	method imagen()=("playerBack.png")
	
	override method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.up(1)
	}
}
object abajo inherits Direccion{
	method imagen()=("playerFront.png")
	
	override method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.down(1)
	}
}
object derecha inherits Direccion{
	method imagen()=("playerRight.png") 
	
	override method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.right(1)
	}
}
object izquierda inherits Direccion{
	method imagen()=("playerLeft.png")
	
	override method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.left(1)
	}
}