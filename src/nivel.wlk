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
	const niveles = [nivel1,nivel2,nivel3]
	
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
	//	game.schedule(3000,{game.clear()})
		
	}
	
	method gano() = actual == niveles.size()
	
	method win(){
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

object nivel1{
	const cantidadEnemigosMelee = 0
	const cantidadEnemigosRango = 2
	method inicio(){
		const portal1=new ParejaPortales(position=game.at(0,1),position2=game.at(12,12))
		game.addVisualCharacter(player) 	
 	    game.addVisual(displayVidas)
		portal1.crearPortales()
		cantidadEnemigosMelee.times({i => self.crearEnemigo(i)})
		cantidadEnemigosRango.times({i => self.crearEnemigoRango(i)})
	}
	
	method crearEnemigo(enemigo){
		const enemigoNuevo = new Enemigo(id=enemigo)
		game.addVisual(enemigoNuevo)
		enemigos.coleccion(enemigoNuevo)
		game.onTick(1000,"moverse"+enemigo.toString(),{enemigoNuevo.seguirPlayer()})
		
	}
	method crearEnemigoRango(enemigoRango){
		const enemigoRangoNew = new EnemigoRango(id=enemigoRango)
		game.addVisual(enemigoRangoNew)
		enemigos.coleccion(enemigoRangoNew)
		game.onTick(1000,"moverseRango"+enemigoRango.toString(),{enemigoRangoNew.seguirPlayer()})
		
	}
		
}
object nivel2{
	const cantidadEnemigosMelee = 5
	method inicio(){
		const portal1=new ParejaPortales(position=game.at(0,4),position2=game.at(0,12))
		game.addVisualCharacter(player) 	
 	    game.addVisual(displayVidas)
		portal1.crearPortales()
		cantidadEnemigosMelee.times({i => self.crearEnemigo(i)})
	}
	method crearEnemigo(enemigo){
		const enemigoNuevo = new Enemigo(id=enemigo)
		game.addVisual(enemigoNuevo)
		enemigos.coleccion(enemigoNuevo)
		game.onTick(1000,"moverse"+enemigo.toString(),{enemigoNuevo.seguirPlayer()})
		
	}
}
object nivel3{
	const cantidadEnemigosMelee = 6
	method inicio(){
		const portal1=new ParejaPortales(position=game.at(3,7),position2=game.at(8,0))
		game.addVisualCharacter(player) 	
 	    game.addVisual(displayVidas)
		portal1.crearPortales()
		cantidadEnemigosMelee.times({i => self.crearEnemigo(i)})
	}
	method crearEnemigo(enemigo){
		const enemigoNuevo = new Enemigo(id=enemigo)
		game.addVisual(enemigoNuevo)
		enemigos.coleccion(enemigoNuevo)
		game.onTick(1000,"moverse"+enemigo.toString(),{enemigoNuevo.seguirPlayer()})
		
	}
}

