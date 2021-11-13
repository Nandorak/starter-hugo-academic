---
title: Predicción del precio de venta de una casa
subtitle: ""
date: 2021-11-13T14:13:34.818Z
draft: true
featured: false
tags:
  - algoritmo lineal
  - regresión lineal múltiple
categories: []
image:
  filename: ""
  focal_point: ""
  preview_only: false
---
Para realizar este proyecto haremos uso del dataset de Housing ubicado en el repositorio de UCI: <https://archive.ics.uci.edu/ml/machine-learning-databases/housing/>

También en la parte superior de esta entrada lo podrás descargar mas fácilmente.

**En este trabajo tendremos como objetivos:**

* Identificar cuáles atributos, entre los varios disponibles, son necesarios para predecir con exactitud la mediana de precios de una casa.
* Construir un modelo de regresión lineal múltiple para predecir la mediana de los precios utilizando los atributos más importantes.
* Evaluar la exactitud del modelo para predecir nuevos ejemplos

Este dataset cuenta con 506 registros (ninguno es faltante) y 14 atributos referentes a características con las que cuentan en la ciudad de Boston (EEUU).

## Atributos

* CRIM: tasa de delincuencia per cápita en la ciudad.
* ZN: proporción de terreno residencial dividido en zonas para lotes de más de 25,000 pies cuadrados.
* INDUS: proporción de acres comerciales no minoristas por ciudad.
* CHAS: variable ficticia de Charles River (1 si el tramo limita con el río; 0 en caso contrario)
* NOX: concentración de óxidos nítricos (partes por 10 millones).
* RM: número medio de habitaciones por vivienda
* AGE: proporción de unidades ocupadas por el propietario construidas antes de 1940
* DIS: distancias ponderadas a cinco centros de empleo de Boston.
* RAD: índice de accesibilidad a carreteras radiales
* TAX: tasa de impuesto a la propiedad de valor total por $ 10,000
* PTRATIO: Proporción alumno-profesor por ciudad
* B: 1000 (Bk - 0.63) ^ 2 donde Bk es la proporción de afrodescendientes por ciudad
* LSTAT: % menor estado de la población
* MEDV: valor medio de las viviendas ocupadas por el propietario en $ 1000