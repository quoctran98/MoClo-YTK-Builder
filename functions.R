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

assembleCassette <- function (t1,t2,t3,t3a,t3b,t4,t4a,t4b,t5,t6,t7,t8,t8a,t8b,t234,t678) {
  t1DNA <- (parts[parts$description == t1 & parts$type == "1","sequence"])
  t2DNA <- (parts[parts$description == t2 & parts$type == "2","sequence"])
  t3DNA <- (parts[parts$description == t3 & parts$type == "3","sequence"])
  t3aDNA <- (parts[parts$description == t3a & parts$type == "3a","sequence"])
  t3bDNA <- (parts[parts$description == t3b & parts$type == "3b","sequence"])
  t4DNA <- (parts[parts$description == t4 & parts$type == "4","sequence"])
  t4aDNA <- (parts[parts$description == t4a & parts$type == "4a","sequence"])
  t4bDNA <- (parts[parts$description == t4b & parts$type == "4b","sequence"])
  t5DNA <- (parts[parts$description == t5 & parts$type == "5","sequence"])
  t6DNA <- (parts[parts$description == t6 & parts$type == "6","sequence"])
  t7DNA <- (parts[parts$description == t7 & parts$type == "7","sequence"])
  t8DNA <- (parts[parts$description == t8 & parts$type == "8","sequence"])
  t8aDNA <- (parts[parts$description == t8a & parts$type == "8a","sequence"])
  t8bDNA <- (parts[parts$description == t8b & parts$type == "8b","sequence"])
  t234DNA <- (parts[parts$description == t234 & parts$type == "234","sequence"])
  t678DNA <- (parts[parts$description == t678 & parts$type == "678","sequence"])
}

generateAddgeneURL <- function (rowNumber) {
  urlNumberBase <- rowNumber + 160
  urlNumber1 <- paste("0", substr(as.character(urlNumberBase),1,1), sep = "")
  urlNumber2 <- substr(as.character(urlNumberBase),2,3)
  urlNumber3 <- paste("110", as.character(urlNumberBase), sep = "")
  urlNumber4 <- as.character(rowNumber + 65107)
  urlNumber5 <- urlNumber3
  urlFinal  <- paste("https://media.addgene.org/snapgene-media/v1.6.2-0-g4b4ed87/sequences/", 
                     urlNumber1, "/", 
                     urlNumber2, "/", 
                     urlNumber3, "/addgene-plasmid-", 
                     urlNumber4, "-sequence-", 
                     urlNumber5, "-map.png", sep = "")
  return(urlFinal)
}

renderPartsList <- function (type) {
  return(
    renderUI({
    selectInput(paste("type", "t1", sep = ""), 
                typeDefinitions["t1","description"], 
                unlist(typeDefinitions["t1","parts"]), 
                selected = unlist(typeDefinitions["t1","parts"])
                )
    })
  )
}