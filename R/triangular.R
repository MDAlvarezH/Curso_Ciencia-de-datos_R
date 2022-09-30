# tomadas de Max R. P. Grossmann, https://max.pm/posts/triangular_dist/
dtri <- function(x, a, b, c = (a + b)/2) {
   if (!all(a <= c && c <= b && a < b)) stop("It must be that a ≤ c ≤ b and a < b!");

   ifelse(x >= a & x <= b,
          ifelse(x <= c,
                 2*(x-a)/((b-a)*(c-a)),
                 2*(b-x)/((b-a)*(b-c))),
          0)
}
ptri <- function(x, a, b, c = (a + b)/2) {
   if (!all(a <= c && c <= b && a < b)) stop("It must be that a ≤ c ≤ b and a < b!");

   ifelse(x > a & x < b,
          ifelse(x <= c,
                 ((x-a)^2)/((b-a)*(c-a)),
                 1-((b-x)^2)/((b-a)*(b-c))),
          ifelse(x <= a,
                 0,
                 1))
}
qtri <- function(p, a, b, c = (a + b) / 2) {
   if (!all(a <= c && c <= b && a < b)) stop("It must be that a ≤ c ≤ b and a < b!");

   ifelse(p > 0 & p < 1,
          ifelse(p <= ptri(c, a, b, c),
                 a+sqrt((a^2-a*b-(a-b)*c)*p),
                 b-sqrt(b^2-a*b+(a-b)*c+(a*b-b^2-(a-b)*c)*p)),
          NA)
}
rtri <- function(n, a, b, c = (a + b)/2) {
   if (!all(a <= c && c <= b && a < b)) stop("It must be that a ≤ c ≤ b and a < b!");

   qtri(runif(n, min = 0, max = 1), a, b, c)
}
