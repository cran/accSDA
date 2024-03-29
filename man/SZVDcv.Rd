% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/SZVDcv.R
\name{SZVDcv}
\alias{SZVDcv}
\alias{SZVDcv.default}
\title{Cross-validation of sparse zero variance discriminant analysis}
\usage{
SZVDcv(Atrain, ...)

\method{SZVDcv}{default}(
  Atrain,
  Aval,
  k,
  num_gammas,
  g_mults,
  D,
  sparsity_pen,
  scaling,
  penalty,
  beta,
  tol,
  ztol,
  maxits,
  quiet,
  ...
)
}
\arguments{
\item{Atrain}{Training data set.}

\item{...}{Parameters passed to SZVD.default.}

\item{Aval}{Validation set.}

\item{k}{Number of classes within training and validation sets.}

\item{num_gammas}{Number of gammas to train on.}

\item{g_mults}{Parameters defining range of gammas to train, g_max*(c_min, c_max).
Note that it is an array/vector with two elements.}

\item{D}{Penalty dictionary basis matrix.}

\item{sparsity_pen}{weight defining validation criteria as weighted sum of misclassification error and
cardinality of discriminant vectors.}

\item{scaling}{Whether to rescale data so each feature has variance 1.}

\item{penalty}{Controls whether to apply reweighting of l1-penalty (using sigma = within-class std devs)}

\item{beta}{Parameter for augmented Lagrangian term in the ADMM algorithm.}

\item{tol}{Stopping tolerances for the ADMM algorithm, must have tol$rel and tol$abs.}

\item{ztol}{Threshold for truncating values in DVs to zero.}

\item{maxits}{Maximum number of iterations used in the ADMM algorithm.}

\item{quiet}{Controls display of intermediate results.}
}
\value{
\code{SZVDcv} returns an object of \code{\link{class}} "\code{SZVDcv}"
       including a list with the following named components:
\describe{
  \item{\code{DVs}}{Discriminant vectors for the best choice of gamma.}
  \item{\code{all_DVs}}{Discriminant vectors for all choices of gamma.}
  \item{\code{l0_DVs}}{Discriminant vectors for gamma minimizing cardinality.}
  \item{\code{mc_DVs}}{Discriminant vector minimizing misclassification.}
  \item{\code{gamma}}{Choice of gamma minimizing validation criterion.}
  \item{\code{gammas}}{Set of all gammas trained on.}
  \item{\code{max_g}}{Maximum value of gamma guaranteed to yield a nontrivial solution.}
  \item{\code{ind}}{Index of best gamma.}
  \item{\code{w0}}{unpenalized zero-variance discriminants (initial solutions) plus B and W, etc. from ZVD}
}

\code{NULL}
}
\description{
Applies alternating direction methods of multipliers to solve sparse
zero variance discriminant analysis.
}
\details{
This function might require a wrapper similar to ASDA.
}
\examples{
  P <- 300 # Number of variables
  N <- 50 # Number of samples per class

  # Mean for classes, they are zero everywhere except the first 3 coordinates
  m1 <- rep(0,P)
  m1[1] <- 3

  m2 <- rep(0,P)
  m2[2] <- 3

  m3 <- rep(0,P)
  m3[3] <- 3

  # Sample dummy data
  Xtrain <- rbind(MASS::mvrnorm(n=N,mu = m1, Sigma = diag(P)),
                 MASS::mvrnorm(n=N,mu = m2, Sigma = diag(P)),
                MASS::mvrnorm(n=N,mu = m3, Sigma = diag(P)))
 Xval <- rbind(MASS::mvrnorm(n=N,mu = m1, Sigma = diag(P)),
                 MASS::mvrnorm(n=N,mu = m2, Sigma = diag(P)),
                MASS::mvrnorm(n=N,mu = m3, Sigma = diag(P)))

  # Generate the labels
  Ytrain <- rep(1:3,each=N)
  Yval <- rep(1:3,each=N)


  # Train the classifier and increase the sparsity parameter from the default
  # so we penalize more for non-sparse solutions.

  res <- accSDA::SZVDcv(cbind(Ytrain,Xtrain),cbind(Yval,Xval),num_gammas=4,
                        g_mults = c(0,1),beta=2.5,
                        D=diag(P), maxits=100,tol=list(abs=1e-3,rel=1e-3), k = 3,
                        ztol=1e-4,sparsity_pen=0.3,quiet=FALSE,penalty=TRUE,scaling=TRUE)
}
\seealso{
Non CV version: \code{\link{SZVD}}.
}
