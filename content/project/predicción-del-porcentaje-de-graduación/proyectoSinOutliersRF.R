#Instalo y cargo las librerias a utilizar (Instalar las que no se dispongan actualmente)
install.packages("ISLR")
install.packages("caret")
install.packages("tidyverse")
install.packages("randomForest")
install.packages("corrplot")
install.packages("car")


library(ISLR)
library(caret)
library(tidyverse)
library(randomForest)
library(corrplot)
library(car)

set.seed(100)
bd <- College

#Comienzo analisis descriptivo----------------------
summary(bd)
str(bd)

boxplot(bd$Grad.Rate)
bd$Grad.Rate[bd$Grad.Rate>100]<-100
bd$Grad.Rate[bd$Grad.Rate<20]<-20
boxplot(bd$Grad.Rate)

plot(density(bd$Grad.Rate))

plot(bd$Grad.Rate,bd$Outstate)
plot(bd$Top10perc,bd$Grad.Rate)
#library(ggplot2)
#ggplot(bd,aes(x=Grad.Rate))+geom_histogram()

#Matriz de correlaciones
bd2<- bd
bd2$Private <-ifelse(bd2$Private == "Yes",1,0)
correlacion<-round(cor(bd2), 1)
corrplot(correlacion, method="number", type="upper")

#Finalizo analisis descriptivo----------------------


#Convierto las columnas que son character a factor. En este caso solo lo aplica a Private
bd<-bd %>% mutate_if(is.character,factor)

#Defino los indices que seran parte de mi entrenamiento
train_index<-createDataPartition(y=bd$Private,p=0.70,list=FALSE)

#Asigno los elementos correspondientes a mis tablas en base a los indices
collegeTrain<-bd[train_index,]
collegeTest<-bd[-train_index,]
graduacionOriginal<-collegeTrain$Grad.Rate
graduacionOriginalTest<-collegeTest$Grad.Rate


#Regresion simple

### Seleccion de modelo lineal stepwise
modelosimple1=lm(Grad.Rate ~ .,data=collegeTrain)
summary(modelosimple1)
step(modelosimple1,direction = 'both')
modelosimple2=lm(Grad.Rate ~ Private + Apps + Accept + Enroll + Top25perc + 
                   F.Undergrad + P.Undergrad + Outstate + Room.Board + Personal + 
                   PhD + perc.alumni + Expend,
                 data=collegeTrain)

vif(modelosimple2)
modelosimple3=lm(Grad.Rate ~ Private + Apps + Accept + Top25perc + 
                   F.Undergrad + P.Undergrad + Outstate + Room.Board + Personal + 
                   PhD + perc.alumni + Expend,
                 data=collegeTrain)
vif(modelosimple3)
modelosimple4=lm(Grad.Rate ~ Private + Apps  + Top25perc + 
                   F.Undergrad + P.Undergrad + Outstate + Room.Board + Personal + 
                   PhD + perc.alumni + Expend,
                 data=collegeTrain)
vif(modelosimple4)
summary(modelosimple4)
modelosimple5=lm(Grad.Rate ~ Private + Apps  + Top25perc + 
                   P.Undergrad + Outstate + Room.Board + Personal + 
                   PhD + perc.alumni + Expend,
                 data=collegeTrain)
vif(modelosimple5)
summary(modelosimple5)
varImp(modelosimple5)
###

regresionLineal<-predict(modelosimple5)
hist(regresionLineal,main = 'Histograma de las predicciones',xlab = 'Porcentaje de graduación',ylab = 'Frecuencia')


#Random Forest---------------

#dejamos en none y luego lo vamos variando para probar. Ver https://www.rdocumentation.org/packages/caret/versions/6.0-84/topics/trainControl
control <-trainControl(method = "cv", number = 10)

#Optimizo los tree
probarTrees<-seq(100,2000, by=100)
arboles<-list()

for (i in probarTrees){
  set.seed(77)
  modeloRF <- train(form = Grad.Rate ~ Private + Apps  + Top25perc + 
                      P.Undergrad + Outstate + Room.Board + Personal + 
                      PhD + perc.alumni + Expend,   
                    data = collegeTrain,
                    method = "rf",
                    trControl = control,
                    ntree=i,
                    tuneGrid = expand.grid(mtry = 2),
                    importance = TRUE)
  llave<-toString(i)
  arboles[[llave]]<-modeloRF
  
}
resultado<- resamples(arboles)
summary(resultado)
print(resultado)


#Optimizo el mtry
tuneGrid<-expand.grid(.mtry=c(1:10))
set.seed(77)
modeloRF <- train(form = Grad.Rate ~ Private + Apps  + Top25perc + 
                    P.Undergrad + Outstate + Room.Board + Personal + 
                    PhD + perc.alumni + Expend,   
                  data = collegeTrain,
                  method = "rf",
                  trControl = control,
                  tuneGrid = tuneGrid,
                  importance = TRUE)

print(modeloRF)

#----------------------------------------------------------------
#Random forest con los valores correctos. mtree 800 y mtry 2

modeloRFfinal <- train(form = Grad.Rate ~ Private + Apps  + Top25perc + 
                         P.Undergrad + Outstate + Room.Board + Personal + 
                         PhD + perc.alumni + Expend,   
                       data = collegeTrain,
                       method = "rf",
                       mtree=800,
                       importance = TRUE,
                       trControl = control,
                       tuneGrid = expand.grid(mtry = 2))

randForestFinal<- predict(modeloRFfinal)
hist(randForestFinal,main = 'Histograma de las predicciones',xlab = 'Porcentaje de graduación',ylab = 'Frecuencia')
plot(varImp(modeloRFfinal))

#-----------------------------------------
#Aqui evaluamos la precision de nuestros modelos
postResample(regresionLineal,graduacionOriginal)

postResample(randForestFinal,graduacionOriginal)

#Aqui viene la prediccion

regresionLineal2<-predict(modelosimple5, newdata = collegeTest)
randForest2<-predict(modeloRFfinal, newdata = collegeTest)

postResample(pred = regresionLineal2, obs = graduacionOriginalTest)

postResample(pred = randForest2, obs = graduacionOriginalTest)

#--------------------------------------------------------------------
#MEJORA: Agregamos cross validation

#Regresion lineal con CV de las variables mas importantes
fit1 <- train(
  form = Grad.Rate ~ Private + Apps  + Top25perc + 
    P.Undergrad + Outstate + Room.Board + Personal + 
    PhD + perc.alumni + Expend,
  data = bd,
  method = "lm",
  trControl = control
)

fit1

