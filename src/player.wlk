import wollok.game.*

object player {
	var property position = game.center()
	var property image = "player.png"
	var derecha=true
	
	method disparar(){
		const proyectil1=new Proyectil(derecha=derecha,position=position)
		game.addVisual(proyectil1)
		game.onTick(200, "disparo", { proyectil1.moverse() })
		game.onTick(5000, "desaparecer", { game.removeVisual(proyectil1) })
	}
	method derecha(){
		derecha=true
		self.image("player.png") 
	}
	method izquierda(){
		derecha=false
		self.image("playerIzq.png") 
	}
}

class Proyectil{
	var property position
	var property derecha		
	var property image="pepita.png"
	method accionDeColicion(){
		
	}
	
	
	method moverse(){
		if(derecha){
			self.position(self.position().right(1))
		}else{
			self.position(self.position().left(1))
		}
		game.onTick(200, "disparo", { self.moverse() })
	}
}