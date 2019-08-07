addPart <- function (name, type, description, antibiotic, sequence = NA, file = NA) {
  
}

validConstruct <- function (t1,t2,t3,t3a,t3b,t4,t4a,t4b,t5,t6,t7,t8,t8a,t8b,t234,t678, return = "logical") {
  partsNumber <- sum(as.numeric(parts[parts$description == t1 & parts$type == "1",][,5:15]),
                     as.numeric(parts[parts$description == t2 & parts$type == "2",][,5:15]),
                     as.numeric(parts[parts$description == t3 & parts$type == "3",][,5:15]),
                     as.numeric(parts[parts$description == t3a & parts$type == "3a",][,5:15]),
                     as.numeric(parts[parts$description == t3b & parts$type == "3b",][,5:15]),
                     as.numeric(parts[parts$description == t4 & parts$type == "4",][,5:15]),
                     as.numeric(parts[parts$description == t4a & parts$type == "4a",][,5:15]),
                     as.numeric(parts[parts$description == t4b & parts$type == "4b",][,5:15]),
                     as.numeric(parts[parts$description == t5 & parts$type == "5",][,5:15]),
                     as.numeric(parts[parts$description == t6 & parts$type == "6",][,5:15]),
                     as.numeric(parts[parts$description == t7 & parts$type == "7",][,5:15]),
                     as.numeric(parts[parts$description == t8 & parts$type == "8",][,5:15]),
                     as.numeric(parts[parts$description == t8a & parts$type == "8a",][,5:15]),
                     as.numeric(parts[parts$description == t8b & parts$type == "8b",][,5:15]),
                     as.numeric(parts[parts$description == t234 & parts$type == "234",][,5:15]),
                     as.numeric(parts[parts$description == t678 & parts$type == "678",][,5:15]),
                     na.rm = TRUE
                  )
  if (return == "logical") {
    if (partsNumber == 11) {
      return(TRUE)
    } else {
      return(FALSE)
    }
  } else if (return == "numerical") {
    return(partsNumber)
  }
}

molesToMass <- function (moles, length, molePrefix = 0.000000000000001, massPrefix = 0.000000001, type = "dsDNA") {
  avgWeight <- 617.96
  endWeight <- 36.04
  
  if(type == "dsDNA") {
    avgWeight <- 617.96
    endWeight <- 36.04
  } else if (type == "ssDNA") {
    avgWeight <- 308.97
    endWeight <- 18.02
  } else if (type == "ssRNA") {
    avgWeight <- 321.47
    endWeight <- 18.02
  } else {
    print(paste(type, "is not a nucleic acid type. Defaulting to dsDNA."))
  }
  
  mass <- (moles * molePrefix) * ((length * avgWeight) + endWeight)
  return(mass / massPrefix)
}