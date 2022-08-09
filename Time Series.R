#### Package ####
library(readxl)
library(TSA)
library(forecast)
library(tseries)
library(normtest)
library(ggplot2)

#### Import Data ####
df <- read_excel("C:/Users/dataset.xlsx")
df <- data.frame("Waktu"=df$tanggal,"Index"=df$no2)
View(df)


#### Identifikasi Data ####
summary(df)
index <- ts(df$Index,
           start = 1,
           frequency = 1)
index


#### Plot Data ####
plot(index,
     xlab = "Waktu",
     ylab = "Index NO2",
     main ="Indeks Standar Pencemaran Udara (NO2)",
     lwd = 2,
     col="blue")


#### Uji Stasioner ####
#ADF
adf.test(index)


#### Differencing Model ####
#Differencing
diff_index <- diff(index,
                  differences = 1)
diff_index

#Plot
plot(diff_index,
     xlab = "Waktu",
     ylab = "Index NO2",
     main ="Differencing (1) Indeks Standar Pencemaran Udara (NO2)",
     lwd = 2,
     col="blue")

#Uji Stasioner
#ADF
adf.test(diff_index)


#### Model ARIMA ####
#ACF dan PACF
tsdisplay(diff_index)

#EACF
eacf(diff_index, ar.max=15, ma.max=15)

#Model
model1 <- Arima(df$Index, order = c(0,1,1), include.constant = TRUE)
model2 <- Arima(df$Index, order = c(1,1,1), include.constant = TRUE)
model3 <- Arima(df$Index, order = c(2,1,2), include.constant = TRUE)

cbind(model1,model2,model3)

#Model Terbaik
fit <- Arima(df$Index, order = c(1,1,1), include.constant = TRUE)
fit


#### Diagnosis Model ####
#Uji Stasioner
fit$residuals
adf.test(fit$residuals)

#Independensi
checkresiduals(fit)

#Normalitas
qqnorm(fit$residuals, pch = 16)
qqline(fit$residuals, lwd = 4, col = "blue")

shapiro.test(fit$residuals)
ks.test(fit$residuals, "pnorm", 0, sd(fit$residuals))
jb.norm.test(fit$residuals, nrepl = 1000)

#### Overfitting ####
overfit1 <- Arima(df$Index, order = c(1,1,2), include.constant = TRUE)
overfit2 <- Arima(df$Index, order = c(2,1,1), include.constant = TRUE)
cbind(fit,overfit1,overfit2)

#Overfit MA
fit; overfit1

stat_uji_1 <- overfit1$coef[['ma2']]/0.3256
derajat_bebas <- length(df$Index)-1
daerah_kritis <- qt(0.025,derajat_bebas)
stat_uji_1;daerah_kritis
#p-value
2*(pt(stat_uji_1,derajat_bebas))

#Overfit AR
fit; overfit2

stat_uji_2 <- overfit2$coef[['ar2']] / 0.1080
derajat_bebas <- length(df$Index)-1
daerah_kritis <- qt(0.025,derajat_bebas)
stat_uji_2;daerah_kritis
#p-value
2*(pt(stat_uji_2,derajat_bebas))


#### Forecasting ####
train <- window(index, end = 145)
test <- window(index, start = 146)

train_fit <- Arima(train, order = c(1,1,1), include.constant = TRUE)
forecast_train <- forecast(train_fit, 4)
forecast_train
cbind(test, forecast_train)

plot(forecast_train,
     fcol="blue", lwd = 2,
     main = "Peramalan ARIMA(1,1,1) melalui Data Training - Testing",
     xlab="Waktu",
     ylab="Index NO2")
lines(seq(146,149),
      test[1:4],
      col="red",
      lwd=2)
legend("topleft",
       col=c("blue", "red"), 
       legend = c("Peramalan Nilai Testing","Nilai Aktual"),
       lwd=2,
       bty = "n")

forecast_final <- forecast(fit, h = 4)
forecast_final
plot(fcol="blue",
     forecast_final,
     main = "Peramalan ARIMA(1,1,1) 4 Periode ke Depan",
     xlab="Waktu",
     ylab="Index NO2",
     lwd = 2)
legend("topleft",
       col="blue",
       legend = "Hasil Peramalan",
       lwd = 2,
       bty = "n")
