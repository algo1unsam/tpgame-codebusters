import wollok.game.*

object player {
	var property position = game.center()
	var property image = "playerabajo.png"
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
		self.image("player"+ direccion.nombreDireccion() +".png")
		console.println(direccion)
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
	
	method objetosEnLaMismaPosicion() = game.colliders(self)
	
	method tieneObjetosEnLaMismaPosicion() = not self.objetosEnLaMismaPosicion().isEmpty() 
	
	method terminar() {
		game.removeTickEvent("disparo")
		game.removeVisual(self)
	} 
	
	method atacar(){ 
		//
		if(self.tieneObjetosEnLaMismaPosicion()){
		self.objetosEnLaMismaPosicion().forEach({ elementoEnLaPosicion => elementoEnLaPosicion.bajarVidas()})
		self.terminar()			
		}
	}
	method moverse(){
		direccion.moverEnDireccion(self)
		if(movimientos < maxRango){
			movimientos=movimientos+1
			self.atacar()
			
		}else{
			self.terminar()
		}
	}
	method bajarVidas(){}
}

class Direccion{
	
	method moverEnDireccion(objetoAMover){
		objetoAMover.position(self.posicionSiSeMueveEnEstaDireccion(objetoAMover.position()))
	}
	
	method proximaPosicionFueraDeLimites(posicion){
		if(self.posicionSiSeMueveEnEstaDireccion(posicion).y() > game.height()){
			return true
		}else return self.posicionSiSeMueveEnEstaDireccion(posicion).y() < 0
	}
	
	method posicionSiSeMueveEnEstaDireccion(posicion){
		return posicion.up(1)
	} 	
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