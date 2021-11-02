---
title: Titanic
subtitle: Predicción de supervivencia en el Titanic
date: 2021-09-11T23:20:22.131Z
draft: true
featured: false
image:
  filename: featured.jpg
  focal_point: ""
  preview_only: false
---
A continuación se predecirá el grado de supervivencia del Titanic (específicamente la variable Survived) a traves de las diferentes variables que componen el dataset Titanic. Para los efectos prácticos se tomara la base *Titanic* que viene dentro los ejemplos de RapidMiner.

El dataset cuenta con 12 atributos y 1.309 registros.

## Atributos

* Passenger Class: la clase en la que viajo la persona, puede ser *First*, *Second* o *Third*
* Name: nombre del pasajero
* Sex: sexo del pasajero, puede ser *Female* o *Male*
* Age: edad del pasajero (hay 263 valores faltantes)
* No of Siblings or Spouses on Board: 
* No of Parents or Children on Board:
* Ticket Number: numero del ticket.
* Passenger Fare: costo del ticket del pasajero (1 valor faltante)
* Cabin: numero de la cabina o camarote del pasajero (1.014 valores faltantes)
* Port of Embarkation: puerto de embarcación (2 variables faltantes)
* Life Boat: numero del bote salvavidas (823 variables faltantes)
* Survived: indica si el pasajero sobrevivió o no, puede ser *Yes* o *No*

## Relaciones entre variables

![Life Boat vs Survived](lifeboat-survived.png "Life Boat vs Survived")

La imagen anterior muestra una alta correlación indicando que la gran mayoría de los pasajeros que tenían un bote salvavidas tenían muchísimas probabilidades de sobrevivir, por lo que esta variable no será tenida en cuenta para este estudio.

![Passanger Fare vs Sex](passengerfare-sex.png "Passanger Fare vs Sex")

El grafico anterior nos muestra que las mujeres (principalmente las que tickets mas caros) sobrevivieron mas que los hombres.