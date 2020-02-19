library(tidyverse)

#before beginning, load the data into memory
x_train <- read.table(file = "UCI HAR Dataset/train/X_train.txt")
y_train <- read.table(file = "UCI HAR Dataset/train/Y_train.txt")
subject_train <- read.table(file = "UCI HAR Dataset/train/subject_train.txt")

y_train %>%
    rename(activity = V1) %>%
    cbind(x_train) -> train

subject_train %>%
    rename(subject = V1) %>%
    cbind(train) -> train

x_test <- read.table(file = "UCI HAR Dataset/test/X_test.txt")
y_test <- read.table(file = "UCI HAR Dataset/test/Y_test.txt")
subject_test <- read.table(file = "UCI HAR Dataset/test/subject_test.txt")

y_test %>%
    rename(activity = V1) %>%
    cbind(x_test) -> test

subject_test %>%
    rename(subject = V1) %>%
    cbind(test) -> test

remove(x_train, y_train, subject_train, x_test, y_test, subject_test)

#1. combining the training and test datasets
train %>%
    mutate(group = "train") %>%
    select(subject, group, activity, everything()) -> train

test %>%
    mutate(group = "test") %>%
    select(subject, group, activity, everything()) -> test

all_data <- rbind(train, test)

remove(train, test)

#4. adding descriptive var names
col_labs <- read.table(file = "UCI HAR Dataset/features.txt")

col_labs %>%
    mutate(V3 = gsub("\\(.*\\)", "", V2)) %>%
    mutate(V4 = gsub("-", "_", V3)) %>%
    mutate(V5 = gsub(",", "_", V4)) -> col_labs

names <- c("subject", "group", "activity", col_labs$V5)
    
colnames(all_data) <- names

remove(col_labs, names)

#2. extracting measurements on mean and sd
all_data_mean_sd <- all_data[, grepl("subject", names(all_data)) |
                               grepl("group", names(all_data)) | 
                               grepl("activity", names(all_data)) |
                               grepl("mean", names(all_data)) | 
                               grepl("std", names(all_data))]
remove(all_data)

#3. adding descriptive names for activities
act_labs <- read.table(file = "UCI HAR Dataset/activity_labels.txt")

act_labs %>%
    rename(activity = V1) %>%
    rename(activity_label = V2) -> act_labs

all_data_mean_sd %>%
    merge(act_labs, by = "activity") %>%
    select(subject, group, activity, activity_label, everything()) -> all_data_mean_sd

remove(act_labs)

#5. creating a second dataset containing averages of each activity for each subject
all_data_mean_sd %>%
    mutate(sub_act = paste(activity_label, as.character(subject), sep = "_")) %>%
    arrange(group, subject, activity) %>%
    select(subject, group, activity, activity_label, sub_act, everything()) -> all_data_mean_sd

all_data_mean_sd %>%
    group_by(sub_act) %>%
    filter(row_number() == 1) %>%
    ungroup() %>%
    arrange(group, subject, activity) %>%
    select(subject, group, activity, activity_label, sub_act) -> sub_act_means

for(i in 6:ncol(all_data_mean_sd)){
    output <- as.data.frame(tapply(all_data_mean_sd[,i], all_data_mean_sd$sub_act, mean))
    
    sub_act_means <- cbind(sub_act_means, output)
    remove(output)
}

colnames(sub_act_means) <- colnames(all_data_mean_sd)
rownames(sub_act_means) <- 1:nrow(sub_act_means)