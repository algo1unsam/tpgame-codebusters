import wollok.game.*
import enemigos.*
import player.*

object nivel {
	
	method crearEnemigo(){
		const enemigoNuevo = new Enemigo()
		game.addVisual(enemigoNuevo)
		game.onTick(1000,"moverse",{enemigoNuevo.seguirPlayer()})
	}
	
/*
 
 method direccionRandom(){
		const random = 0.randomUpTo(3).truncate(0)
		console.println(random)
		if(random == 0){
			return izquierda
		}else if(random == 1){
			return derecha
		}else if(random == 2){
			return arriba
		}else return abajo
		
		
	}
  
 */	
	

	
}
