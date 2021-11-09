import wollok.game.*
import player.*
import direcciones.*
import nivel.*
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
	var property image = "enemyabajo.png"
	var vidas=5
	var direccion = abajo
	const x = 0.randomUpTo(game.width()).truncate(0)
    const y = 0.randomUpTo(game.height()).truncate(0) 
    var property position = game.at(x,y) 
    var property text = vidas.toString()
    var property danio = 2
    var property id
	
	method bajarVidas(danioCausado){
		if(self.danioMayorOIgualQueVida(danioCausado)){
			enemigos.coleccion().remove(self)
			game.removeVisual(self)
			self.terminarCaminar()
			nivelController.checkPaseDeNivel()
			
		}else{ 
			vidas = vidas- danio
			self.text(vidas.toString())
		}
	}
	
	method terminarCaminar() = game.removeTickEvent("moverse"+id.toString())
	method colicionConPlayer(){}
	
	method danioMayorOIgualQueVida(danioCausado) = danioCausado >= vidas
	
	
	method estaCerca(posicionJugador) =  self.position().distance(posicionJugador) <= 1
		
		
	method cambiarImagenAtaque(){
		self.image("enemy"+ direccion.nombreDireccion() +"attack.png")
	}
	
	method cambiarImagenCaminando(direccionxd){
		self.image("enemy"+ direccionxd.nombreDireccion() +".png")
	}
	
	method atacar(objetoAATacar){
		self.cambiarImagenAtaque()
		game.schedule(300,{objetoAATacar.bajarVidas(danio)})
		game.schedule(300,{self.cambiarImagenCaminando(direccion)})
	}
	
	
	method moverse(unaDireccion){
		direccion = unaDireccion
		self.cambiarImagenCaminando(direccion)
		
		if(not direccion.proximaPosicionFueraDeLimites(position) and self.proximaPosVacia(direccion)){	
		self.position(direccion.posicionSiSeMueveEnEstaDireccion(self.position()))
		}
	}
	
	method proximaPosVacia(direccionALaQueSeMueve){
			const proxPos = direccionALaQueSeMueve.posicionSiSeMueveEnEstaDireccion(position)
			return game.getObjectsIn(proxPos).size() == 0
			
	}
	
	method seguirPlayer(){
		
		if(self.estaCerca(player.position())){
			self.atacar(player)
			
		}else {
			self.seguirPlayerX()
			game.schedule(400, {(self.seguirPlayerY())})
		}
	}
	
	method seguirPlayerX(){
		const xPlayer = player.position().x()
	//	const yPlayer = player.position().y()
	//	const yEnemy = self.cuantoEnY(xPlayer)
		if(not self.enElMismoX(xPlayer)){
			self.moverse(self.cuantoEnX(xPlayer))
		}
	}
	
	method enElMismoX(xPlayer) = self.position().x() == xPlayer
	
	method seguirPlayerY(){
	///	const xPlayer = player.position().x()
		const yPlayer = player.position().y()
		
		if(not self.enElMismoY(yPlayer)){
			self.moverse(self.cuantoEnY(yPlayer))
		}
		
	}
	
	method enElMismoY(yPlayer) = self.position().y() == yPlayer
	
	method cuantoEnX(xPlayer) {
		if(self.esMayorEnX(xPlayer)){
			return derecha
		}else return izquierda
	}
	
	method cuantoEnY(yPlayer) {
		if(self.esMayorEnY(yPlayer)){
			return arriba
		}else return abajo
	}
	
	method esMayorEnX(xPlayer) = player.position().x() > self.position().x()
	method esMayorEnY(xPlayer) = player.position().y() > self.position().y()
	
	
}


class EnemigoRango inherits Enemigo {
        
    var property proyectiles = []
    var property limiteProyectiles = 3
    
    
    override method terminarCaminar() = game.removeTickEvent("moverseRango"+id.toString())
    
    override method seguirPlayer(){
        
        if(self.estaCerca(player.position())){
            self.voltearse()
            
        }else {
            self.seguirPlayerX()
            game.schedule(400, {(self.seguirPlayerY())})
        }
    }
    
    method voltearse() {
        if (self.enElMismoY(player.position().y())){
            direccion = self.cuantoEnX(player.position().x())
            self.cambiarImagenCaminando(direccion)
            self.disparar()
            
        } else if (self.enElMismoX(player.position().x())){
            direccion = self.cuantoEnY(player.position().y())
            self.cambiarImagenCaminando(direccion)
            self.disparar()
        } else {
            self.seguirPlayerX()
        }
    }
    
    
    override method seguirPlayerX(){
        const xPlayer = player.position().x()
        if(not self.enElMismoX(xPlayer)){
            self.moverse(self.cuantoEnX(xPlayer))
        } else {
            self.voltearse()
        }
    }
    
    
    override method seguirPlayerY(){
        const yPlayer = player.position().y()
        
        if(not self.enElMismoY(yPlayer)){
            self.moverse(self.cuantoEnY(yPlayer))
        }else {
            self.voltearse()
        }
        
    }

    
    
    override method estaCerca(posicionJugador) = self.position().distance(posicionJugador) <= 4
    

    method disparar(){
    
        if(self.puedeSeguirDisparando()){
            const proyectil=new ProyectilEnemigo(direccion=direccion,position=direccion.posicionSiSeMueveEnEstaDireccion(self.position()),duenio=self)
            game.addVisual(proyectil)
            game.onTick(200, "disparoEnemigo", { proyectil.moverse() })
            proyectiles.add(proyectil)
        } else {
            game.schedule(2000,{self.reiniciarDisparos()})    
        }        
    }
    method puedeSeguirDisparando() = proyectiles.size() <= self.limiteProyectiles()
    method reiniciarDisparos() = proyectiles.clear()

    
}

class ProyectilEnemigo inherits Proyectil {
    const duenio 
	override method image() = "proyectil-enemigo.png"
	override method danioProyectil() = 5
    method colicionPlayer() = game.colliders(self).contains(player)
    override method atacar(){
		if(self.estaEntablero()){
			if(self.colicionPlayer()){
            player.bajarVidas(self.danioProyectil())
            self.terminar()            
        }    
		}      
        
    }
    
    override method terminar() {
        game.removeTickEvent("disparoEnemigo")
        duenio.proyectiles().remove(self)
       if(self.estaEntablero() ){
        game.removeVisual(self)       	
       }
    } 
    
    
    }


