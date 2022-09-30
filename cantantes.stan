data {
  int<lower=0> N;
  vector[N] estaturas;
}

parameters {
  real mu;
  real<lower=0> sigma;
}

model {
  // verosimilitud
  estaturas ~ normal(mu, sigma);
  // iniciales
  mu ~ normal(175, 5);
  sigma ~ gamma(2.0, 0.5);
}

generated quantities {
  vector[N] estaturas_sim;
  // generar una muestra bajo el modelo ajustado
  for(i in 1:N){
    estaturas_sim[i] = normal_rng(mu, sigma);
  }
}
