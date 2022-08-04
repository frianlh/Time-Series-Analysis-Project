# Time Series Analysis


> **Disclaimer :**
> 
> This project is for educational purposes.
> 
> **Tujuan :**
> 
> 1. Mengetahui proses dalam menganalisis data runtun waktu sampai mendapatkan model yang sesuai pada data tersebut.
> 2. Mendapatkan model runtun waktu yang terbaik dalam efisiensi parameter maupun kemampuan prediktif dalam memprediksi ISPU NO<sub>2</sub> di DKI Jakarta berdasarkan data 1 Juni 2021 sampai 27 Oktober 2021.
> 3. Mendapatkan hasil prediksi ISPU NO<sub>2</sub> di DKI Jakarta dalam rentang 4 hari sesudah 27 Oktober 2021.


## 1. Data ##
Sampel yang digunakan dalam penelitian ini adalah [data ISPU NO<sub>2</sub> di provinsi DKI Jakarta](https://data.jakarta.go.id/dataset/indeks-standar-pencemaran-udara-ispu-tahun-2021) harian selama 149 hari, sejak 1 Juni hingga 27 Oktober 2021.
<p align="center">
  <img src="">
  <i>Gambar 1 Plot Data Indeks Standar Pencemaran Udara NO<sub>2</sub></i>
</p>

Berikut ringkasan dari data yang digunakan:
```
     Waktu                Index      
 Min.   :2021-06-01   Min.   :14.00  
 1st Qu.:2021-07-08   1st Qu.:26.00  
 Median :2021-08-14   Median :31.00  
 Mean   :2021-08-14   Mean   :31.88  
 3rd Qu.:2021-09-20   3rd Qu.:36.00  
 Max.   :2021-10-27   Max.   :63.00  
```

## 2. Tahapan Penelitian ##

## 3. Uji Stasioner ##
Berdasarkan **Gambar 1** dapat dilihat bahwa secara subjektif data ISPU NO<sub>2</sub> yang dimiliki belum bersifat stasioner karena masih bisa dilihat terdapat kecenderungan naik atau turun.
```
	Augmented Dickey-Fuller Test

data:  index
Dickey-Fuller = -3.035, Lag order = 5, p-value = 0.1452
alternative hypothesis: stationary
```

Berdasarkan Uji Augmented Dickey-Fuller, didapatkan $p − value = 0.1452 > 0.05$. Keputusan yang diambil adalah tidak menolak $H_0$ dan disimpulkan bahwa data observasi bersifat tidak stasioner, sehingga perlu dilakukan transformasi pada data dengan melakukan differencing terhadap data.
<p align="center">
  <img src="">
  <i>Gambar 3 Plot Data Indeks Standar Pencemaran Udara NO<sub>2</sub> Setelah Differencing (d = 1)</i>
</p>

```
	Augmented Dickey-Fuller Test

data:  diff_index
Dickey-Fuller = -8.6387, Lag order = 5, p-value = 0.01
alternative hypothesis: stationary

Warning message:
In adf.test(diff_index) : p-value smaller than printed p-value
```

Berdasarkan **Gambar 3**, diperoleh $p − value = 0.01 < 0.05$. Keputusan yang diambil adalah menolak $H_0$ dan disimpulkan bahwa data observasi hasil differencing bersifat stasioner.

## 4. Spesifikasi Model ##
Pemilihan model akan dilakukan berdasarkan grafik ACF, PACF, dan EACF dari data differencing.
### 4.1. ACF dan PACF ###
<p align="center">
  <img src="">
  <i>Gambar 4 Plot ACF dan PACF Data Indeks Standar Pencemaran Udara NO<sub>2</sub> Setelah Differencing (d = 1)</i>
</p>

Berdasarkan **Gambar 4**, pada plot ACF dapat dilihat terdapat tiang pancang pada lag ke−1. Sementara itu, pada plot PACF terdapat tiang pancang hingga lag ke−4. Pola yang didapat dari plot ACF dan PACF tidak menggambarkan pola AR atau MA. Maka, model runtun waktu yang diduga adalah ARIMA yang ordenya akan dicari melalui tabel EACF.

### 4.2. EACF ###
```
AR/MA
   0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15
0  x o o o o o o o o o o  o  o  o  o  o 
1  x o o o o o o o o o o  o  o  o  o  o 
2  x x o o o o o o o o o  o  o  o  o  o 
3  x o x o o o o o o o o  o  o  o  o  o 
4  x x x x o o o o o o o  o  o  o  o  o 
5  x x x x o x o o x o o  o  o  o  o  o 
6  x x x x o x o o x o o  o  o  o  o  o 
7  x x x x o x x o o o o  o  o  o  o  o 
8  x x x x o o o o o o o  o  o  o  o  o 
9  o o x o o o o o o o o  o  o  o  o  o 
10 x o x o o o o o o o o  o  o  o  o  o 
11 x x o o o o o o o o o  o  o  o  o  o 
12 x x x o o o o o o o o  o  o  o  o  o 
13 x x x o o o o o o o o  o  o  o  o  o 
14 x o o o o o o o o o o  x  o  o  o  o 
15 x x o o o o o o o o o  x  o  o  o  o
```

Berdasarkan tabel EACF. terdapat tiga model yang akan menjadi kandidat, yaitu $ARIMA(0,1,1)$, $ARIMA(1,1,1)$, dan $ARIMA(2,1,2)$. Dari ketiga model tersebut akan diseleksi untuk memperoleh model terbaik.

## 5. Pemilihan Model Terbaik ##
Pemilihan model terbaik akan didasari atas nilai Log-Likelihood terbesar, nilai Akaike Information Criterion (AIC) terkecil dan Bayesian Information Criterion (BIC) terkecil. Metode pemilihan dilakukan dengan cara pertama membuat semua model ARIMA yang menjadi kandidat model terbaik, kemudian membandingkan nilai Log- Likelihood, AIC, dan BIC.
```
          model1      model2      model3     
coef      numeric,2   numeric,3   numeric,5  
sigma2    64.26305    62.99618    62.2411    
var.coef  numeric,4   numeric,9   numeric,25 
mask      logical,2   logical,3   logical,5  
loglik    -517.4861   -515.5649   -514.3892  
aic       1040.972    1039.13     1040.778   
arma      integer,7   integer,7   integer,7  
residuals ts,149      ts,149      ts,149     
call      expression  expression  expression 
series    "df$Index"  "df$Index"  "df$Index" 
code      0           0           0          
n.cond    0           0           0          
nobs      148         148         148        
model     list,10     list,10     list,10    
aicc      1041.139    1039.41     1041.374   
bic       1049.964    1051.119    1058.762   
xreg      integer,149 integer,149 integer,149
x         numeric,149 numeric,149 numeric,149
fitted    ts,149      ts,149      ts,149 
```

Didapatkan model 2 merupakan model yang memiliki nilai AIC terkecil, BIC terkecil kedua, dan Log-Likelihood terbesar kedua. Maka, model $ARIMA(1,1,1)$ adalah model terbaik yang akan digunakan.

## 5. Estimasi Parameter ##
Metode estimasi parameter yang digunakan untuk data ISPU NO<sub>2</sub> adalah penggunaan conditional sum of square untuk menentukan nilai awal kemudian diestimasi dengan memanfaatkan metode maximum-likelihood (CSS-ML).
```
Series: df$Index 
ARIMA(1,1,1) with drift 

Coefficients:
         ar1      ma1   drift
      0.2197  -0.8606  0.0017
s.e.  0.1172   0.0752  0.1211

sigma^2 estimated as 63:  log likelihood=-515.56
AIC=1039.13   AICc=1039.41   BIC=1051.12
```

Diperoleh estimasi yang dapat diekspresikan sebagai berikut:
$$\sigma_\epsilon^2 = 63$$

$$\nabla Y_t = 0.2197\nabla Y_{t-1} + e_t - 0.8606e_{t−1} + 0.0017$$

## 6. Model Diagnostik ##
### 6.1. Analisis Residual ###
1. Uji Independensi/Autokorelasi Residual
2. Uji Kenormalan Residual
### 6.2. Overfitting ###

## 7. Peramalan (Forecasting) ##
### 7.1. Ex Post ###
### 7.1. Ex Ante ###
