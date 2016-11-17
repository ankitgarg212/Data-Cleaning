library("dplyr")

setwd("C:/Users/User/Desktop/Coursera/Datacleaning/Project/UCI HAR Dataset/")

##get file paths for the files
featuresfile <- file.path(getwd(), 'features.txt')
labelsfile <- file.path(getwd(), 'activity_labels.txt')
trainlabelfile <- file.path(getwd(), 'train/y_train.txt')
traindatafile <- file.path(getwd(), 'train/x_train.txt')
trainsubjectfile <- file.path(getwd(), 'train/subject_train.txt')
testlabelfile <- file.path(getwd(), 'test/y_test.txt')
testdatafile <- file.path(getwd(), 'test/x_test.txt')
testsubjectfile <- file.path(getwd(), 'test/subject_test.txt')

##read the table for features
features <- read.table(featuresfile)
setnames(features, c("V1","V2"), c("featurenum", "featurename"))

##read the table for activity labels
labels <- read.table(labelsfile)
setnames(labels, c("V1","V2"), c("activitynum", "activityname"))

##combine train and test data
datalabel <- rbind(read.table(trainlabelfile), read.table(testlabelfile))
setnames(datalabel, names(datalabel), "activitynum")

datasubject <- rbind(read.table(trainsubjectfile), read.table(testsubjectfile))
setnames(datasubject, names(datasubject), "subject")

dataset <- rbind(read.table(traindatafile), read.table(testdatafile))
names(dataset) <- features[,2]

##Merged data set - "datacom"
datacom <- cbind(datasubject, datalabel, dataset)

##extract only the mean and standard deviation 
features <- subset(features, grepl("mean\\(\\)|std\\(\\)", features$featurename))
reqfeatures <- features[,1]
##reqdata is a subset of dataset that contains only the features pertaining to mean and standard deviation
reqdata <- dataset[,reqfeatures]
datacom <- cbind(datasubject, datalabel, reqdata)

##merge the data and activity labels tables to identify values fpr each feature by activity name
datacom <- merge(labels, datacom, by="activitynum", all.x = TRUE)
##sort the datacom
datacom <- arrange(datacom, subject, activitynum, activityname)

##tidydata will have the means for the selected columns grouped by subject and then activity name
tidydata <- datacom %>% group_by(subject, activityname) %>% summarise_each(funs(mean))

write.csv(tidydata, "tidydata.csv")
