setwd("C:/Users/Fernando/Desktop/IA/portfolio/usarrest")

#Instalamos las librerias que hagan falta
install.packages("rattle")
install.packages("factoextra")

#Cargamos las librerías
library(rpart)
library(rattle)
library(factoextra)

#Cargamos la base de datos
x = USArrests
pairs(x)


#normalizamos
x = data.frame(scale(USArrests))
head(x)
pairs(x)

#Obtenemos el valor de Hopkins
h = get_clust_tendency(x, 1e1, graph = FALSE)
h

#Calculamos la silueta y calculamos los clusters con K-means
#silueta
silueta <- fviz_nbclust(x, kmeans, method = 'silhouette')
silueta

#---k-means
#Utilizamos la cantidad de clusters recomendados por la silueta: 2
q = kmeans(x, 2)
q

#Graficamos los clusters obtenidos
fviz_cluster(object = q, data = x, show.clust.cent = TRUE,
             star.plot = FALSE, repel = TRUE) +
  labs(title = "Resultados clustering K-means") +
  theme_bw() +
  theme(legend.position = "none")


#agregamos a los datos originales el cluster ID
x$cluster_id = q$cluster
head(x)

write.csv2(x, "parte1.csv")

#---------------------------------------------------
#Realizamos un árbol de clasificación
t = rpart(cluster_id ~., data = x)

# Podamos el árbol
fancyRpartPlot(t)

#ahora vemos la importancia de las variables (veremos que UrbanPop no es importante para el modelo)
t$variable.importance

#Creamos una nueva base a partir de la original eliminando las variables UrbanPop y cluster_id
x1 = x[,-c(3,5)]
head(x1)

#Calculamos los clusters nuevamente-----------------

#Calculamos la silueta calculamos los clusters con K-means nuevamente
#silueta
silueta2 <- fviz_nbclust(x1, kmeans, method = 'silhouette')
silueta2

#k-means
q1 = kmeans(x1, centers = 2)

#Graficamos los clusters obtenidos
fviz_cluster(object = q1, data = x1, show.clust.cent = TRUE,
             star.plot = FALSE, repel = TRUE) +
  labs(title = "Resultados clustering K-means optimizados") +
  theme_bw() +
  theme(legend.position = "none")

#Obtenemos el valor de Hopkins
h1 = get_clust_tendency(x1, 1e1, graph = FALSE)
h1


x1$cluster_id = q$cluster
write.csv2(x1, "parte2.csv")


