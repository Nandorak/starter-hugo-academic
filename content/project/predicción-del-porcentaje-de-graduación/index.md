---
title: Predicción del porcentaje de graduación
date: 2021-11-15T22:04:58.042Z
summary: Se intentará predecir la variable Grad.Rate a traves de una Regresión
  Lineal, y también a través de Random Forest. Se compararan los resultados
  obtenidos y sacaran conclusiones.
draft: false
featured: true
tags:
  - regresión lineal
  - random forest
  - feature selection
categories:
  - Predicción
links:
  - url: proyectoSinOutliersRF.R
    name: Descargar código R
image:
  filename: featured.jpg
  focal_point: ""
  preview_only: false
---
## Presentación del caso de estudio

Para este trabajo se hará uso de la base de datos College provista por el paquete ISLR de r, en la que se buscara predecir la variable *Grad.Rate* en base a otros atributos que describen las caracteristicas de una universidad.

Arriba de este proyecto podrás descargar el código fuente (en r) que fue la base para este informe.

La base de datos College dispone de estadísticas de un gran número de universidades de Estados
Unidos correspondientes a la edición de 1995 de US News and World Report.

## Entendimiento de caso de uso y planificación del trabajo

Se realizara un modelo supervisado en el que se hará una regresión para predecir la variable *Grad.Rate*. Se utilizaran dos modelos distintos, una Regresión Lineal Simple y Random Forest. Para estos se analizara su comportamiento realizando comparativas entre ambos y finalizaremos con las conclusiones de los casos expuestos.

## Extracción, transformación y carga de datos

Para la extracción y carga de los datos no tendremos mayores problemas ya que la base de datos se encuentra bien estructurada y sin valores nulos o vacíos. Lo único que deberemos hacer es dentro de RStudio importar la librería ISLR para tener acceso a la base de datos College.

## Exploración y análisis descriptivo

College es una base de datos que contiene 777 observaciones de las siguientes 18 variables:

* **Private**: factor con No, Yes indica si la universidad es pública o privada.
* **Apps**: número de solicitudes recibidas
* **Accept**: número de solicitudes aceptadas
* **Enroll**: número de nuevos estudiantes inscriptos
* **Top10pers**: porcentaje de nuevos alumnos que integraban el 10% superior en su liceo
* **Top25pers**: porcentaje de nuevos alumnos que integraban el 25% superior en su liceo
* **F.Undergrad**: número de estudiantes universitarios a tiempo completo
* **P.Undergrad**: número de estudiantes universitarios a medio tiempo
* **Outstate**: gasto de tutoría por ser estudiante de fuera del estado o extranjero
* **Room.Board**: costo de alojamiento y comida
* **Books**: costo estimado de libros
* **Personal**: gastos personales estimados
* **PhD**: porcentaje de la facultad con Doctorados
* **Terminal**: porcentaje de facultad con título terminal
* **S.F.Ratio**: relación estudiante/facultad
* **pers.alumni**: porcentaje de ex alumnos que donan
* **Expend**: gastos de instrucción por alumno
* **Grad.Rate**: tasa de graduación (variable objetivo)

Aplicando *str()* a nuestro conjunto de datos se obtiene la estructura de nuestros dato, la cual se
expone a continuación:

```
> str(bd)
'data.frame':	777 obs. of  18 variables:
 $ Private    : Factor w/ 2 levels "No","Yes": 2 2 2 2 2 2 2 2 2 2 ...
 $ Apps       : num  1660 2186 1428 417 193 ...
 $ Accept     : num  1232 1924 1097 349 146 ...
 $ Enroll     : num  721 512 336 137 55 158 103 489 227 172 ...
 $ Top10perc  : num  23 16 22 60 16 38 17 37 30 21 ...
 $ Top25perc  : num  52 29 50 89 44 62 45 68 63 44 ...
 $ F.Undergrad: num  2885 2683 1036 510 249 ...
 $ P.Undergrad: num  537 1227 99 63 869 ...
 $ Outstate   : num  7440 12280 11250 12960 7560 ...
 $ Room.Board : num  3300 6450 3750 5450 4120 ...
 $ Books      : num  450 750 400 450 800 500 500 450 300 660 ...
 $ Personal   : num  2200 1500 1165 875 1500 ...
 $ PhD        : num  70 29 53 92 76 67 90 89 79 40 ...
 $ Terminal   : num  78 30 66 97 72 73 93 100 84 41 ...
 $ S.F.Ratio  : num  18.1 12.2 12.9 7.7 11.9 9.4 11.5 13.7 11.3 11.5 ...
 $ perc.alumni: num  12 16 30 37 2 11 26 37 23 15 ...
 $ Expend     : num  7041 10527 8735 19016 10922 ...
 $ Grad.Rate  : num  60 56 54 59 15 55 63 73 80 52 ...
```

A continuación, se muestra un boxplot de *Grad.Rate*, la variable que se intentara predecir:

![Boxplot de Grad.Rate](rplot01.png "Boxplot de Grad.Rate")

Aquí es necesario corregir estos outliers, si estamos hablando de porcentajes, no es coherente la existencia de uno que sea 118% (este se convirtió a 100). Además, los 4 valores menores a 20, se convirtieron a 20. De esta forma no tenemos mas outliers en nuestra Label.

![Grad.Rate sin outliers](boxplot.png "Grad.Rate sin outliers")

A continuación, se muestra un ploteo entre la variable Grad.Rate y Ouststate en la que se ve su relación, siendo esta ultima una de las variables mas importantes como se verá más adelante.

![Grad.Rate vs Ouststate](rplot.png "Grad.Rate vs Ouststate")

El siguiente cuadro me pareció importante incorporarlo ya que demuestra que no importa que se haya tenido las mejores notas en el liceo, esto no implicara que en la universidad se obtengan muy buenos resultados.

![Grad.Rate vs Top10perc](top10perc.png "Grad.Rate vs Top10perc")

### Matriz de correlación

La siguiente matriz de correlación se le aplico a toda la base College, esto nos mostrara la relación entre las diferentes variables de este modelo.

![Matriz de correlación](correlacion.png "Matriz de correlación")

Esta matriz nos da un indicio de que hay variables con una fuerte correlación positiva entre sí, a modo de ejemplo la variable Enroll con las variables Apps y Accept, es posible entonces que algunas de estas variables muy asociadas entre sí no sean significativas para el modelo, tal cual ser verá más adelante en el trabajo con el modelo de Regresión Lineal.

## Modelado y Evaluación

Para esta predicción utilizaremos dos métodos, Regresión Lineal Simple y Random Forest. Optimizaremos y compararemos el comportamiento de estos dos métodos a fin de poder concluir cual es el que mejor se adapta a nuestras necesidades.

### Regresión Lineal Simple

Para esta técnica, primeramente, se ejecutó el método con todas las variables, obteniendo los siguientes resultados (pequeña extracción de summary):

```
Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) 30.4574822  5.5729462   5.465 7.14e-08 ***
PrivateYes   5.2045054  1.9886106   2.617  0.00912 ** 
Apps         0.0016361  0.0005125   3.192  0.00150 ** 
Accept      -0.0011846  0.0009285  -1.276  0.20259    
Enroll       0.0038452  0.0025977   1.480  0.13940    
Top10perc    0.0345468  0.0824687   0.419  0.67545    
Top25perc    0.1427174  0.0620819   2.299  0.02190 *  
F.Undergrad -0.0007396  0.0004518  -1.637  0.10222    
P.Undergrad -0.0011986  0.0004191  -2.860  0.00440 ** 
Outstate     0.0010675  0.0002568   4.156 3.77e-05 ***
Room.Board   0.0013805  0.0006645   2.077  0.03824 *  
Books        0.0001332  0.0029872   0.045  0.96446    
Personal    -0.0023439  0.0008419  -2.784  0.00556 ** 
PhD          0.1344993  0.0626652   2.146  0.03230 *  
Terminal    -0.0859281  0.0685640  -1.253  0.21067    
S.F.Ratio    0.2257821  0.1863241   1.212  0.22614    
perc.alumni  0.2163186  0.0541207   3.997 7.33e-05 ***
Expend      -0.0004322  0.0001947  -2.220  0.02684 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

Para identificar la colinealidad entre las variables usaremos factores de inflación de varianza (VIF (1)). En este análisis cuanto mayor es el valor del VIF, mayor es la colinealidad. Calculamos entonces el VIF para cada variable y vamos eliminando aquellas con valores altos. La definición de 'alto' que tomaremos para este ejercicio es un VIF > 5.

La eliminación de variables individuales de forma simultanea con valores altos de VIF en la comparación inicial no es lo ideal, ya que los valores de VIF cambiarán después de eliminar cada variable. Por lo expuesto, realizaremos un enfoque gradual, eliminando la variable con VIF más alto y ejecutando nuevamente, repitiendo el proceso hasta que todos los valores VIF estén por debajo del umbral deseado (menor a 5 en nuestro caso). El resultado final de este proceso se expone a continuación:

```
> vif(modelosimple5)
    Private        Apps   Top25perc P.Undergrad    Outstate  Room.Board    Personal         PhD perc.alumni      Expend 
   2.791996    2.082394    2.050054    1.496521    3.947868    1.878437    1.239493    1.947419    1.732255    2.380616 
```

La siguiente tabla muestra un resumen de nuestro modelo final para explicar Grad.Rate, el cual se redujo a un total de 10 variables:

```
> summary(modelosimple5)

Call:
lm(formula = Grad.Rate ~ Private + Apps + Top25perc + P.Undergrad + 
    Outstate + Room.Board + Personal + PhD + perc.alumni + Expend, 
    data = collegeTrain)

Residuals:
    Min      1Q  Median      3Q     Max 
-42.691  -7.161  -0.388   6.603  50.781 

Coefficients:
              Estimate Std. Error t value Pr(>|t|)    
(Intercept) 31.9176421  3.4135985   9.350  < 2e-16 ***
PrivateYes   5.6014864  1.9047982   2.941  0.00342 ** 
Apps         0.0010172  0.0001998   5.090 4.97e-07 ***
Top25perc    0.1659687  0.0364951   4.548 6.72e-06 ***
P.Undergrad -0.0014004  0.0003916  -3.576  0.00038 ***
Outstate     0.0009650  0.0002491   3.874  0.00012 ***
Room.Board   0.0013238  0.0006471   2.046  0.04126 *  
Personal    -0.0026318  0.0008135  -3.235  0.00129 ** 
PhD          0.0714951  0.0422977   1.690  0.09156 .  
perc.alumni  0.2229852  0.0532862   4.185 3.34e-05 ***
Expend      -0.0004008  0.0001577  -2.541  0.01134 *  
---
Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
```

Como se puede apreciar, el resultado que arroja es similar al estudio de p valor realizado inicialmente, manteniendo la mayoría de las variables un p valor menor a 0.05 y las 2 que no lo hacen (PRivateYes y PhD) ya habían sido detectadas y arrojado un resultado similar en nuestro primer recuadro de coeficientes.

Una vez obtenido el modelo idóneo, se utilizó la función *predict* sobre el mismo. A continuación se aprecia un histograma del modelo final:

![Histograma de predicciones](rplot04.png "Histograma de predicciones")

Para medir la precisión del modelo de Regresión Lineal Simple se hizo un *postResample* del modelo con la graduación original del conjunto de entrenamiento, arrojando el siguiente resultado:

```
> postResample(regresionLineal,graduacionOriginal)
      RMSE   Rsquared        MAE 
11.7410366  0.4930572  8.9728433 
```

Finalmente, con este modelo se aplicó la predicción a nuestro juego de datos de test (collegeTest) obteniendo el siguiente resultado:

```
> postResample(pred = regresionLineal2, obs = graduacionOriginalTest)
      RMSE   Rsquared        MAE 
14.2168124  0.3879399 10.6987405 
```

Como se puede apreciar, el resultado de la predicción del conjunto de entrenamiento es un poco mejor que en el conjunto de test. Sin embargo, no hay que entusiasmarse tratando de encontrar mejores y mejores valores para el conjunto de entrenamiento ya que esto puede producir un alto grado de overfitting. Lo importante es ver como se compara el RMSE en diferentes modelos en el conjunto de test.

### Random Forest

Antes de ejecutar el Random Forest, se buscó la optimización del mismo buscando los valores apropiados tanto para el ntree como para el mtry.

Luego de esta optimización y para los valores de seed elegidos se llegó a la conclusión de que los valores óptimos para su ejecución son 800 para ntree y 2 para el mtry. Se utilizó como criterio para la selección el menor valor de RMSE.

A continuación se expone el postResample de nuestro conjunto de entrenamiento:

```
> postResample(randForestFinal,graduacionOriginal)
     RMSE  Rsquared       MAE 
5.4185570 0.9242982 3.9941331 
```

Aplicado este modelo al conjunto de test:

```
> postResample(pred = randForest2, obs = graduacionOriginalTest)
      RMSE   Rsquared        MAE 
14.3822119  0.3777601 10.8279685 
```

## Conclusiones

1. Si bien el modelo de Random Forest predice mucho mejor para el conjunto de entrenamiento, arroja resultados similares al modelo de Regresión Lineal para los conjuntos de test.
2. Los buenos resultados obtenidos con el método de Regresión Lineal pueden ser
   explicados por un comportamiento bastante lineal de la propia base College.
3. Luego de comparar resultados, se considera que para la predicción de *Grade.Rate* es mejor utilizar el método de Regresión Lineal Simple ya que es más sencilla su interpretación, no exige grandes cálculos computacionales y sobre todo arroja resultados similares en el conjunto de test comparados con Random Forest.
4. Según el método de Regresión Lineal Simple para explicar el Grad.Rate las variables más importantes son: Apps, Top25perc, Outstate, P.Undergrad, perc.alumni.
5. Sorprendentemente el gasto en Books no es significativo lo que se podría explicar a través de la facilidad de acceso a internet.

Las técnicas aplicadas fueron ejecutadas con varias seeds distintas, obteniendo en todas las ejecuciones comportamientos similares entre ambos métodos.

### Posibles ampliaciones

Como posibles ampliaciones o mejoras a este trabajo se le podría agregar K-fold *cross validation* a la Regresión Lineal Simple siendo  esta técnica utilizada para la evaluación de resultados la cual garantiza la independencia entre el subconjunto de datos de entrenamiento y test.

### Mejora (agregado posteriormente)

Para los modelos anteriores, se utilizo random forest con cross validation pero para la regresión lineal simple lo que se utilizo fue la base de datos particionada en dos conjuntos, el 70% de las observaciones fueron utilizadas para el entrenamiento, mientras que el otro 30% fueron utilizadas para test.

De esta forma se divide el el dataset en k-folds diferentes (en este caso fueron 10) para asegurar que todas las observaciones sean utilizadas como entrenamiento y también cono test de forma disjunta. Esto como se menciono en las posibles ampliaciones garantiza la independencia de datos del conjunto de entrenamiento y test.

```
Resampling results:

  RMSE     Rsquared   MAE     
  12.6463  0.4551071  9.574706
```

Como se aprecia en la imagen anterior este modelo es mucho mas optimo ya que el RMSE es bastante mas bajo que el calculado anteriormente.

### Bibliografía

1- Kutner, M. H.; Nachtsheim, C. J.; Neter, J. (2004). Applied Linear Regression Models (4th edición). McGraw-Hill Irwin.