import wollok.game.*
import player.*
import enemigos.*
import nivel.*


class Direccion{
	
	method moverEnDireccion(objetoAMover){
		objetoAMover.position(self.posicionSiSeMueveEnEstaDireccion(objetoAMover.position()))
	}
	
	method proximaPosicionFueraDeLimites(posicion){
		return (self.posicionSiSeMueveEnEstaDireccion(posicion).y() > game.height())
		or
		self.posicionSiSeMueveEnEstaDireccion(posicion).y() < 0
	}
	
	method posicionSiSeMueveEnEstaDireccion(posicion)
}

object arriba inherits Direccion{
	
	
	override method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.up(1)
	}
	
	method nombreDireccion(){
		return "arriba"
	}
}
object abajo inherits Direccion{

	
	override method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.down(1)
	}
	method nombreDireccion(){
		return "abajo"
	}
}
object derecha inherits Direccion{
	 
	
	override method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.right(1)
	}
	method nombreDireccion(){
		return "derecha"
	}
}
object izquierda inherits Direccion{

	
	override method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.left(1)
	}
	method nombreDireccion(){
		return "izquierda"
	}
}