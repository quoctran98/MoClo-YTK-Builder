addPart <- function (name, type, description, antibiotic, sequence = NA, file = NA) {
  
}

validConstruct <- function (t1,t2,t3,t3a,t3b,t4,t4a,t4b,t5,t6,t7,t8,t8a,t8b,t234,t678) {
  partsNumber <- sum(as.numeric(partsYTK[partsYTK$description == t1 & partsYTK$type == "1",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t2 & partsYTK$type == "2",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t3 & partsYTK$type == "3",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t3a & partsYTK$type == "3a",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t3b & partsYTK$type == "3b",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t4 & partsYTK$type == "4",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t4a & partsYTK$type == "4a",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t4b & partsYTK$type == "4b",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t5 & partsYTK$type == "5",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t6 & partsYTK$type == "6",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t7 & partsYTK$type == "7",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t8 & partsYTK$type == "8",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t8a & partsYTK$type == "8a",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t8b & partsYTK$type == "8b",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t234 & partsYTK$type == "234",][,5:15]),
                     as.numeric(partsYTK[partsYTK$description == t678 & partsYTK$type == "678",][,5:15]),
                     na.rm = TRUE
                  )
  
  if (partsNumber == 11) {
    return(TRUE)
  } else {
    return(FALSE)
  }
}