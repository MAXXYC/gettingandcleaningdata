#
# JHU Getting and Cleaning Data, week 4, final course project

# setting working dir and reading test and train data

setwd("C:\\Users\\Berwind\\Documents\\data")

DataTest <- read.table("X_test.txt", quote = "\"", comment.char = "")
DataTrain <- read.table("X_train.txt", quote = "\"", comment.char = "")

DataTrainy <- read.table("y_train.txt", quote = "\"", comment.char = "")
DataTesty <- read.table("y_test.txt", quote = "\"", comment.char = "")

DataSubjectTrain <- read.table("subject_train.txt", quote = "\"", comment.char = "")
DataSubjectTest <- read.table("subject_test.txt", quote = "\"", comment.char = "")

FeaturesInfo <- read.table("features.txt", quote = "\"", comment.char = "")

# read file
Activitylabel <- read.table("activity_labels.txt", quote = "\"", comment.char = "")


# combining data sets
combinedTrain <- cbind(DataTrain, DataSubjectTrain, DataTrainy)
combinedTest <- cbind(DataTest, DataSubjectTest, DataTesty)

data <- rbind(combinedTest, combinedTrain)

# set the row names in the data set
names(data) <- FeaturesInfo$V2
names(data) [563] <- "activityid"
names(data) [562] <- "subject"

# label file
names(Activitylabel) <- c("activityid", "activityname")

# fill the activitylabels
data$activityname <- factor(data$activityid, levels = Activitylabel$activityid, labels = Activitylabel$activityname)

# select only the needed rows
datafinal <- data[,grep("-mean\\(\\)|-std\\(\\)|subject|activityname", names(data))]

# compute mean values
datareallyfinal <- datafinal

# reshape
install.packages("reshape2")
library(reshape2)
datareallyfinal <- reshape2::melt(data = datareallyfinal, id = c("subject", "activityname"))
datareallyfinal <- reshape2::dcast(data = datareallyfinal, subject + activityname ~ variable, fun.aggregate = mean)


# write tidy data set
write.table(datareallyfinal, "tidydata.txt", row.names = FALSE)
