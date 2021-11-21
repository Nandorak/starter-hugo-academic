---
title: Clasificación de vinos
date: 2021-11-21T14:46:44.884Z
summary: Nos introducimos a los algoritmos de clasificación, clasificando
  diferentes tipos de vinos.
draft: true
featured: false
tags:
  - clasificación
  - knn
  - performance
categories:
  - Clasificación
image:
  filename: featured.jpg
  focal_point: ""
  preview_only: false
---
En este ejercicio haremos una clasificación de vinos, ya es hora de  que salgamos un poco de las predicciones. Utilizaremos el dataset Wine de [UCI](https://archive.ics.uci.edu/ml/datasets/wine).

Según el autor de este dataset, estos datos son el resultado de un análisis químico de vinos cultivados en la misma región en Italia pero derivados de tres cultivares diferentes. El análisis determinó las cantidades de 13 componentes que se encuentran en cada uno de los tres tipos de vinos. 

Este dataset es apropiado para iniciarse con los algoritmos de clasificación ya que al estar bien estructurado no es muy desafiante. 

## Atributos

Excepto el atributo Clase (variable objetivo que indica el tipo de vino), los restantes 13 atributos son de tipo contínuo y refieren a atributos de cada vino:

* Clase
* Alcohol
* Malic acid
* Ash
* Alcalinity of ash
* Magnesium
* Total phenols
* Flavanoids
* Nonflavanoid phenols
* Proanthocyanins
* Color intensity
* Hue
* OD280/OD315 of diluted wines
* Proline

