import wollok.game.*
import enemigos.*
import player.*
import portal.*
import direcciones.*

object starteo {
	method iniciar(){
		game.title("La papa")
		game.height(15)
		game.width(15)
		game.boardGround("fondo-principal.jpg")
		keyboard.space().onPressDo({self.setearEntorno(nivelController.cualNivel())})
		keyboard.c().onPressDo({self.instrucciones()})
		nivelController.iniciarTemaDeFondo()
	}
	
	method setearEntorno(nivel){
		game.clear()
		floor.cambiarFloor()
		game.addVisual(floor)
		self.crearEntidades(nivel)
		self.controles()
	}
	
	method controles(){
		game.whenCollideDo(player, { elemento => 
		elemento.colicionConPlayer()
  		})
	
 		keyboard.z().onPressDo({ player.disparar() })
 		keyboard.x().onPressDo({ player.ataqueMelee() })
		keyboard.left().onPressDo({player.moverseHacia(izquierda)})
		keyboard.right().onPressDo({player.moverseHacia(derecha)})
		keyboard.up().onPressDo({player.moverseHacia(arriba)})
		keyboard.down().onPressDo({player.moverseHacia(abajo)})
	}
	
	method crearEntidades(nivel){
		nivel.inicio()
	}
	
	method instrucciones(){
		game.clear()
		game.addVisual(instrucciones)
		keyboard.space().onPressDo({self.setearEntorno(nivelController.cualNivel())})
	}
	
}


object instrucciones{
	var property image = "info.jpg"
	var property position = game.at(0,0)
	
	method bajarVidas(){}
	method colicionConPlayer(){}
}

object floor{
	var property image = "floor"+ nivelController.actual().toString() + ".png"
	var property position = game.at(0,0)
	
	method cambiarFloor() = self.image("floor"+ nivelController.actual().toString() + ".png")
	
	method bajarVidas(){}
	method colicionConPlayer(){}
}



object enemigos{
	var property coleccion = []
	
	method coleccion(enemigonuevo){
		coleccion.add(enemigonuevo)
	}

}

object nivelController{
	var property actual = 1
	
	const nivel1=new Nivel(danioMelee=2,danioProyectil=5,cantidadEnemigosMelee = 2, cantidadEnemigosRango = 2, portal1X = 1, portal1Y = 10, portal2X = 5, portal2Y = 2)
	const nivel2=new Nivel(danioMelee=5,danioProyectil=7,cantidadEnemigosMelee = 4, cantidadEnemigosRango = 3, portal1X = 4, portal1Y = 1, portal2X = 12, portal2Y = 0)
	const nivel3=new Nivel(danioMelee=6,danioProyectil=10,cantidadEnemigosMelee = 6, cantidadEnemigosRango = 4, portal1X = 12, portal1Y = 5, portal2X = 0, portal2Y = 3)
	
	const niveles = [nivel1,nivel2,nivel3]
	
	const temaDeFondo = game.sound("temardo.mp3")
	
	method iniciarTemaDeFondo(){
		temaDeFondo.shouldLoop(true)
		game.schedule(500, { temaDeFondo.play()} )
	}
	method finTemaDeFondo(){
		temaDeFondo.stop()
	}
	method checkPaseDeNivel(){  
		if(self.nivelEstaFinalizado()){
			game.schedule(1000,{self.nuevoNivel()})
		}
	}
	
	method nivelEstaFinalizado() =  (enemigos.coleccion()).isEmpty() 
	
	method nuevoNivel(){
			if(self.gano()){
				self.win()
			}else{
			self.pantalla()
			self.actual(self.actual() + 1)
			game.schedule(3000,{starteo.setearEntorno(self.cualNivel())})
			}
			
		}
	method cualNivel(){
		return niveles.get(actual - 1)
		
		}
	
	method pantalla(){
		game.clear()
		nivelComplete.imageCambiar(actual.toString())
		game.addVisual(nivelComplete)		
	}
	
	method gano() = actual == niveles.size()
	
	method win(){
		self.finTemaDeFondo()
		game.sound("win.mp3").play()
		game.clear()
		game.addVisual(win)
		game.schedule(5000,{game.stop()})
		
	}
	
	method gameOver(){
		game.clear()
		game.addVisual(gameOver)
		game.schedule(5000,{game.stop()})
	}

}

object win{
	var property image = "ganaste.jpg"
	var property position = game.at(0,0)
	
}


object gameOver{
	var property image = "moriste.jpg"
	var property position = game.at(0,0)
}

object nivelComplete{
	var property image = "success"+ nivelController.actual().toString() +".jpg"
	var property position = game.at(0,0)
	
	method imageCambiar(nivel) = self.image("success"+ nivel +".jpg") 
	
	method bajarVidas(){}
	method colicionConPlayer(){}
}

class Nivel{
	const cantidadEnemigosMelee
	const cantidadEnemigosRango
	
	const portal1X
	const portal1Y
	const portal2X
	const portal2Y	
	const danioProyectil
	const danioMelee
	method inicio(){
		const portal1=new ParejaPortales(position=game.at(portal1X,portal1Y),position2=game.at(portal2X,portal2Y))
		game.addVisualCharacter(player) 	
 	    game.addVisual(displayVidas)
		portal1.crearPortales()
		cantidadEnemigosMelee.times({i => self.crearEnemigo(i)})
		cantidadEnemigosRango.times({i => self.crearEnemigoRango(i)})
	}
	
	method crearEnemigo(enemigo){
		const enemigoNuevo = new Enemigo(image="enemyabajo.png",id=enemigo,danio=danioMelee)
		game.addVisual(enemigoNuevo)
		enemigos.coleccion(enemigoNuevo)
		game.onTick(1000,"moverse"+enemigo.toString(),{enemigoNuevo.seguirPlayer()})
		
	}
	method crearEnemigoRango(enemigoRango){
		const enemigoRangoNew = new EnemigoRango(image="enemyrangoabajo.png",id=enemigoRango,danioProyectil=danioProyectil)
		game.addVisual(enemigoRangoNew)
		enemigos.coleccion(enemigoRangoNew)
		game.onTick(1000,"moverseRango"+enemigoRango.toString(),{enemigoRangoNew.seguirPlayer()})
		
	}
		
}

