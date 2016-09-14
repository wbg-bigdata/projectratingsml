ieg <- read.csv('../../data/ieg-ratings.csv', stringsAsFactors = T)

ieg_negative = c("Highly Unsatisfactory","Moderately Unsatisfactory","Unsatisfactory")
ieg_positive = c("Satisfactory", "Moderately Satisfactory", "Highly Satisfactory")

ieg$IEG_Outcome[ieg$IEG_Outcome %in% c("Not Applicable", "Not Available", "Not Rated")] <- NA
ieg$IEG_Outcome <- ordered(ieg$IEG_Outcome, levels=c(ieg_negative, ieg_positive))

ieg$Binary_Outcome <- ieg$IEG_Outcome %in% ieg_positive
ieg$Binary_Outcome[is.na(ieg$IEG_Outcome)] <- NA

prop.table(table(ieg$IEG_Outcome, ieg$Region), 2)
prop.table(table(ieg$Binary_Outcome, ieg$Region), 2)

shuffled <- ieg[sample(nrow(ieg)),]
train <- shuffled[1:(nrow(shuffled)*0.8),]
test <- shuffled[(nrow(shuffled)*0.8+1):nrow(shuffled),]

model <- glm(Binary_Outcome ~ Region + Sector.Board + Agreement.Type,family=binomial(link='logit'),data= train)


