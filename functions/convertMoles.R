convertMoles <- function(dnaLength, femtomoles, returnUnits = "ng") {
  grams <- (femtomoles * 1e-15) * ((dnaLength * 617.96) + 36.04)
  if (returnUnits == "ng") {
    return(grams * 1e9)
  }
}
