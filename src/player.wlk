import wollok.game.*
import direcciones.*
import nivel.*

object displayVidas{
	const property position = game.at(0,0)
	var property image = "corazon.png"
	var property text = player.vidas().toString()
	var property textColor = "FFFFFF"
	
	method colicionConPlayer(){}
	method bajarVidas(parametro){}
}

object player {
	var property position = game.center()
	var property image = "playerabajo.png"
	var direccion=abajo
	var property vidas=100
	var property danioMelee = 16
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
		game.sound("muerte.mp3").play()
		game.schedule(2500,{nivelController.gameOver()})
	} 
	
	method subirVidas(){
		vidas=vidas+1
	}
	
	method moverseHacia(unaDireccion){
		direccion=unaDireccion
		self.cambiarImagenCaminando(direccion)
	
	}
	
	method puedeSeguirDisparando() = proyectiles.size() < self.limiteProyectiles()
	
	method disparar(){
		if(self.puedeSeguirDisparando()){
			const proyectil=new Proyectil(numeroDeProyectil=proyectiles.size().toString(),direccion=direccion,position=direccion.posicionSiSeMueveEnEstaDireccion(self.position()))
			game.addVisual(proyectil)
			game.onTick(200, "disparo"+proyectiles.size().toString(), { proyectil.moverse() })
			proyectiles.add(proyectil)
			game.sound("disparoPlayer.mp3").play()
		}
	}
	
	method ataqueMelee(){
		const posQueMira = direccion.posicionSiSeMueveEnEstaDireccion(position)
		const objetosEnPosQueMira = game.getObjectsIn(posQueMira)
		self.cambiarImagenAtaque()
		game.schedule(300,{self.cambiarImagenCaminando(direccion)})
		objetosEnPosQueMira.forEach({ o => o.bajarVidas(danioMelee)})
		game.colliders(self).forEach({ o => o.bajarVidas(danioMelee)})
		game.sound("punch.mp3").play()
	}
	
	method cambiarImagenAtaque(){
		self.image("player"+ direccion.nombreDireccion() +"attack.png")
	}
	
	method cambiarImagenCaminando(direccionxd){
		self.image("player"+ direccionxd.nombreDireccion() +".png")
	}
}

class Proyectil{
	const numeroDeProyectil=0
	var property position
	var property direccion		
	var movimientos=0
	const maxRango=3
	const danioProyectil=4
	
	method colicionConPlayer(){
		
	}
	method  image()="proyectil.png"
	method objetosEnLaMismaPosicion() = game.colliders(self)
	
	method tieneObjetosEnLaMismaPosicion() = not self.objetosEnLaMismaPosicion().isEmpty() 
	
	method  danioProyectil() = danioProyectil
	method terminar() {
		game.removeTickEvent("disparo"+numeroDeProyectil)
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
	method bajarVidas(a){}
	
	method estaEntablero()= game.allVisuals().contains(self)
}

