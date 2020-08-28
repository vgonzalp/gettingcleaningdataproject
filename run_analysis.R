library(dplyr)
#link and download file
SamsungUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(SamsungUrl, destfile = "dataset.zip", method = "curl")
unzip("dataset.zip")
#load general data sets
etiquetas <- read.csv("./UCI HAR Dataset/features.txt", header = FALSE, sep = " ")
etiquetas_act <- read.csv("./UCI HAR Dataset/activity_labels.txt", header = FALSE, sep = " ")

#load specific train data sets in memory
datos_train <- read.table("./UCI HAR Dataset/train/X_train.txt")
sujetos_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")
actividad_train <-read.table("./UCI HAR Dataset/train/y_train.txt")
#bind train data sets
datos_train <- cbind(datos_train, sujetos_train, actividad_train)
#load specific test data sets in memory
datos_test <- read.table("./UCI HAR Dataset/test/X_test.txt")
sujetos_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")
actividad_test <- read.table("./UCI HAR Dataset/test/y_test.txt")
#bind test data sets
datos_test <- cbind(datos_test, sujetos_test, actividad_test)
#put all data in a single data set
datos_total <- rbind(datos_test, datos_train)
#define names por combined data set
names(datos_total) <- c(etiquetas$V2, "Subject", "Activity")
#locate mean and std variables
sel_var <- grep("mean|std", etiquetas$V2)
#new filtered data set
datos_filtrados <- select(datos_total, sel_var, Subject, Activity)
#change to descriptive activity names
datos_filtrados_descriptivos <- datos_filtrados %>% mutate(Activity = as.character(factor(Activity, levels = etiquetas_act$V1, labels = etiquetas_act$V2)))

#changing labels to a more descriptive
names(datos_filtrados_descriptivos) <- gsub("tBodyAcc-", replacement = "Body linear Acceleration Signal in time domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("tGravityAcc-", replacement = "Gravity linear Acceleration Signal in time domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("tBodyAccJerk-", replacement = "Body linear Acceleration Jerk Signal in time domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("tBodyGyro-", replacement = "Body Angular Velocity signal in time domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("tBodyGyroJerk-", replacement = "Body Angular Velocity Jerk Signal in time domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("tBodyAccMag-", replacement = "Body linear Acceleration Magnitude in time domain", x= names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("tGravityAccMag-", replacement = "Gravity Linear Acceleration Magnitude in time domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("tBodyAccJerkMag-", replacement = "Body linear Accelaration Jerk Magnitude in time domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("tBodyGyroMag-", replacement = "Body Angular Velocity Magnitude in time domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("tBodyGyroJerkMag-", replacement = "Body Angular Velocity Jerk Magnitude in time domain", x = names(datos_filtrados_descriptivos))

names(datos_filtrados_descriptivos) <- gsub("fBodyAcc-", replacement = "Body linear Acceleration Signal in frecuency domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("fBodyAccJerk-", replacement = "Body linear Acceleration Jerk Signal in frecuency domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("fBodyGyro-", replacement = "Body Angular Velocity signal in frecuency domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("fBodyAccMag-", replacement = "Body linear Acceleration Magnitude in frecuency domain", x= names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("fBodyBodyAccJerkMag-", replacement = "Body linear Accelaration Jerk Magnitude in frecuency domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("fBodyBodyGyroMag-", replacement = "Body Angular Velocity Magnitude in frecuency domain", x = names(datos_filtrados_descriptivos))
names(datos_filtrados_descriptivos) <- gsub("FBodyBodyGyroJerkMag-", "Body Angular Velocity Jerk Magnitude in frecuency domain", x = names(datos_filtrados_descriptivos))
datos_ordenados <- group_by(datos_filtrados_descriptivos, Activity, Subject)
#tidy data set
datos_tidy <- datos_ordenados %>% summarise_at(vars(1:79), mean, na.rm = TRUE)
write.table(datos_tidy, "tidydata.txt", row.name=FALSE)

