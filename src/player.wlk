import wollok.game.*

object player {
	var property position = game.center()
	var property image = "playerFront.png"
	var direccion=0//0 Abajo, 1 Derecha, 2 izquierda, 3 Arriba
	//reemplazar numeros por objetos
	var vidas=100
	
	method bajarVidas(){
		
	}
	
	method subirVidas(){
		vidas=vidas+1
	}
	
	method derecha(){
		direccion=1
		self.image("playerRight.png") 
	}
	method izquierda(){
		direccion=2
		self.image("playerLeft.png") 
	}
	method arriba(){
		direccion=3
		self.image("playerBack.png") 
	}
	method abajo(){
		direccion=0
		self.image("playerFront.png") 
	}
	//un solo metodo para direccionar
	method moverseHacia(unaDireccion){
		//hacer lo mismo que los 4 metodos de arriba
	}
	
	method disparar(){
		const proyectil=new Proyectil(direccion=direccion,position=position)
		game.addVisual(proyectil)
		game.onTick(200, "disparo", { proyectil.moverse() })
		game.onCollideDo(proyectil, { target => target.bajarVidas() } ) //proyectil.atacar(target)
	}
}

class Proyectil{
	var property position
	var property direccion		
	var property image="proyectil.png"
	var movimientos=0
	const maxRango=3
	method accionDeColicion(){
		
	}
	method atacar(target){ 
		//bajar vidas, eliminarse 
	}
	method moverse(){
		if(direccion==0){ //sacar este if por polimorfismo (usar direcciones polimorficamente)
			self.position(self.position().up(-1))
		}else if(direccion==1){
			self.position(self.position().right(1))
		}else if(direccion==2){
			self.position(self.position().left(1))
		}else if(direccion==3){
			self.position(self.position().up(1))
		}
		if(movimientos < maxRango){
			movimientos=movimientos+1
		}else{
			game.removeTickEvent("disparo")
			game.removeVisual(self)
		}
	}
}