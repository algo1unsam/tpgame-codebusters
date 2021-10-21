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
	var property image = "bicho.png"
	var vidas=5
	
	const property position = game.at(4,3) 
	
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
		
	}
}