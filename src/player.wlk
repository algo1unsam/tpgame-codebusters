import wollok.game.*
import direcciones.*
import nivel.*

object displayVidas{
	const property position = game.at(0,0)
	var property image = "corazon.png"
	var property text = player.vidas().toString()
	
	method colicionConPlayer(){}
	method bajarVidas(d){}
}



object player {
	var property position = game.center()
	var property image = "playerabajo.png"
	var direccion=abajo//0 Abajo, 1 Derecha, 2 izquierda, 3 Arriba
	//reemplazar numeros por objetos
	var property vidas=100
	var property danioMelee = 30
	const property proyectiles = []
	var property limiteProyectiles = 2
	
	method bajarVidas(danio){
		self.vidas(self.vidas() -danio) 
		displayVidas.text(self.vidas().toString())
		if(self.estaMuerto()){
			self.morir()
		}
	}
	
	method estaVivo() = self.vidas() > 0
	
	method estaMuerto() = self.vidas() <= 0
	
	method morir() {
		game.removeVisual(self)
		nivelController.gameOver()
	} 
	
	method subirVidas(){
		vidas=vidas+1
	}
	
	//un solo metodo para direccionar
	method moverseHacia(unaDireccion){
		direccion=unaDireccion
		self.cambiarImagenCaminando(direccion)
	
	}
	
	method puedeSeguirDisparando() = proyectiles.size() < self.limiteProyectiles()
	
	method disparar(){
		if(self.puedeSeguirDisparando()){
			const proyectil=new Proyectil(direccion=direccion,position=direccion.posicionSiSeMueveEnEstaDireccion(self.position()))
			game.addVisual(proyectil)
			game.onTick(200, "disparo", { proyectil.moverse() })
			proyectiles.add(proyectil)
		}
		
	}
	
	method ataqueMelee(){
		const posQueMira = direccion.posicionSiSeMueveEnEstaDireccion(position)
		const objetosEnPosQueMira = game.getObjectsIn(posQueMira)
		self.cambiarImagenAtaque()
		game.schedule(300,{self.cambiarImagenCaminando(direccion)})
		objetosEnPosQueMira.forEach({ o => o.bajarVidas(danioMelee)})
		game.colliders(self).forEach({ o => o.bajarVidas(danioMelee)})
	}
	
	method cambiarImagenAtaque(){
		self.image("player"+ direccion.nombreDireccion() +"attack.png")
	}
	
	method cambiarImagenCaminando(direccionxd){
		self.image("player"+ direccionxd.nombreDireccion() +".png")
	}
	
	
	
}

class Proyectil{
	var property position
	var property direccion		
	var movimientos=0
	const maxRango=3
	method colicionConPlayer(){
		
	}
	method  image()="proyectil.png"
	method objetosEnLaMismaPosicion() = game.colliders(self)
	
	method tieneObjetosEnLaMismaPosicion() = not self.objetosEnLaMismaPosicion().isEmpty() 
	
	method  danioProyectil() = 100
	method terminar() {
		game.removeTickEvent("disparo")
		player.proyectiles().remove(self)
		 if(self.estaEntablero() ){
        game.removeVisual(self)       	
       }
	} 
	
	method atacar(){ 
		//
		if(self.tieneObjetosEnLaMismaPosicion()){
		self.objetosEnLaMismaPosicion().forEach({ elementoEnLaPosicion => elementoEnLaPosicion.bajarVidas(self.danioProyectil())})
		self.terminar()			
		}
	}
	method moverse(){
		
		if(movimientos < maxRango){
			movimientos=movimientos+1
			self.atacar()
			direccion.moverEnDireccion(self)
			
		}else{
			self.terminar()
		}
	}
	method bajarVidas(da){}
	
	method estaEntablero()= game.allVisuals().contains(self)
}

