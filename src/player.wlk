import wollok.game.*

object player {
	var property position = game.center()
	var property image = "playerFront.png"
	var direccion=0//0 Abajo, 1 Derecha, 2 izquierda, 3 Arriba
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
	
	method disparar(){
		const proyectil=new Proyectil(direccion=direccion,position=position)
		game.addVisual(proyectil)
		game.onTick(200, "disparo", { proyectil.moverse() })
		game.whenCollideDo(proyectil, { elemento => 
		elemento.bajarVidas()
  	})
	}
}

class Proyectil{
	var property position
	var property direccion		
	var property image="proyectil.png"
	var movimientos=0
	const maxMovimientos=3
	method accionDeColicion(){
		
	}
	
	method moverse(){
		if(direccion==0){
			self.position(self.position().down(1))
		}else if(direccion==1){
			self.position(self.position().right(1))
		}else if(direccion==2){
			self.position(self.position().left(1))
		}else if(direccion==3){
			self.position(self.position().up(1))
		}
		if(movimientos<maxMovimientos){
			movimientos=movimientos+1
		}else{
			game.removeTickEvent("disparo")
			game.removeVisual(self)
		}
	}
}